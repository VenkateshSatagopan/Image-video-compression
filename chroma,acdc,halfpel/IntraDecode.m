function Reconstructed_imagenew =IntraDecode(output,rowsize,columnsize,factor,option)


dec_output=[];
i=1;
while i <= length(output)
    [dec_output_inst,loc] = ZeroRunDec(output(i:end), 1000, 64);
      dec_output = [dec_output dec_output_inst];
    
     i = i + loc - 1;
    
 end
% 

  l =rowsize*columnsize;
dec_output_Y = dec_output(1:l);
dec_output_Cb = dec_output(l+1:ceil(5*l/4));
dec_output_Cr = dec_output(ceil(5*l/4)+1:end);
j=1;

for r = 1:8:rowsize
for c = 1:8:columnsize
        
        %split decoder output in blocks of length 64
        block_64_Y = dec_output_Y(j:j+63);
       
        
        
        
        %undo the zigzag scan
        block_8x8_Y = DeZigZag8x8(block_64_Y);
        
        
        %dequantize each block
        %[ block_out_Y, block_out_Cb, block_out_Cr ] = DeQuant8x8( block_8x8_Y, block_8x8_Cb, block_8x8_Cr,factor,option );
        [ block_out_Y] = DeQuant8x8Y( block_8x8_Y,factor,option );
        
        %undo DCT
        block_IDCT_Y = IDCT8x8(block_out_Y);
       
        
        %concatenate blocks
        recon_Y(r:r+7, c:c+7) = block_IDCT_Y;
        
   
    
        j = j + 64;
end
end

j=1;
for r=1:8:(rowsize/2)
for c=1:8:(columnsize/2)
    
     block_64_Cb = dec_output_Cb(j:j+63);
     block_64_Cr = dec_output_Cr(j:j+63);
     block_8x8_Cb = DeZigZag8x8(block_64_Cb);
     block_8x8_Cr = DeZigZag8x8(block_64_Cr);
     [ block_out_Cb] = DeQuant8x8Cb( block_8x8_Cb,factor,option );
     [ block_out_Cr] = DeQuant8x8Cb( block_8x8_Cr,factor,option );
      block_IDCT_Cb = IDCT8x8(block_out_Cb);
      block_IDCT_Cr = IDCT8x8(block_out_Cr);
      recon_Cb(r:r+7, c:c+7) = block_IDCT_Cb;
      recon_Cr(r:r+7, c:c+7) = block_IDCT_Cr;
      j=j+64;

end
end
recon_Cb1 = chroma_up(recon_Cb);
recon_Cr1 = chroma_up(recon_Cr);
Reconstructed_image=[];
Reconstructed_image(:,:,1)=recon_Y;
Reconstructed_image(:,:,2)=recon_Cb1;
Reconstructed_image(:,:,3)=recon_Cr1;

%[RR,RG,RB]=ictYCbCr2RGB(Reconstructed_image);
[RR,RG,RB]=ictYCbCr2RGB(Reconstructed_image);
Reconstructed_imagenew=[];
Reconstructed_imagenew(:,:,1)=RR;
Reconstructed_imagenew(:,:,2)=RG;
Reconstructed_imagenew(:,:,3)=RB;

end