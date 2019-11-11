function Reconstructed_image = IntraDecode2(seq, dc_seq, sizes_full, factor,option)

%IntraDecode which is not used as part of interdecode
sizes_y=sizes_full(:,:,1);
sizes_cb=sizes_full(:,:,2);
sizes_cr=sizes_full(:,:,3);
dc_size_y=sizes_full(:,:,4);
dc_size_cb=sizes_full(:,:,5);
dc_size_cr=sizes_full(:,:,6);

dec_dc_y = Run_DPCM(dc_seq(1:dc_size_y), 2);
dec_dc_cb = Run_DPCM(dc_seq(dc_size_y+1:dc_size_y+dc_size_cb), 2);
dec_dc_cr = Run_DPCM(dc_seq(dc_size_y+dc_size_cb+1:dc_size_y+dc_size_cb+dc_size_cr), 2);

dec_dc = [dec_dc_y, dec_dc_cb, dec_dc_cr];
% Zero Run Decoding
all_sizes = [sizes_full(:,:,9)^2, sizes_full(:,:,9)^2, sizes_full(:,:,9)^2];
row_size=sizes_full(:,:,7);
col_size=sizes_full(:,:,8);
len=row_size*col_size;
i = 1;
cnt = 0;
dec_output_Y = [];
dec_output_Cb = [];
dec_output_Cr=[];
dec_output = [];
t_y=[];
t_cb=[];
t_cr=[];
dec_output_inst=[];
ii=1;
dec_output_Y1=[];
dec_output_Cb1=[];
dec_output_Cr1=[];
while ii <= length(seq)
    cnt=cnt+1;
   if ii <= sizes_y 
      [dec_output_inst,loc] = ZeroRunDec(seq(ii:end), 1000,63);
       dec_output_Y = [dec_output_Y, dec_dc(cnt), dec_output_inst];
       
   elseif ii > sizes_y &&  ii <= (sizes_y+sizes_cb) 

     [dec_output_inst,loc] = ZeroRunDec(seq(ii:end), 1000, 15);
     dec_output_Cb = [dec_output_Cb, dec_dc(cnt), dec_output_inst];
     %t_y=[t_y,dec_dc(cnt), dec_output_inst];
      elseif  ii > (sizes_y+sizes_cb) && ii <= (sizes_y+sizes_cb+sizes_cr)
%         t1=3;
    [dec_output_inst,loc] = ZeroRunDec(seq(ii:end), 1000, 15);
    dec_output_Cr = [dec_output_Cr, dec_dc(cnt), dec_output_inst];
    %t_y=[t_y,dec_dc(cnt), dec_output_inst];
%         t_cr=[t_cr, dec_output_inst];
 end
    ii = ii + loc - 1;
end
ty=[];
% aa=zero_full_y-t_y;
% aa1=zero_full_cb-t_cb;
% aa2=zero_full_cr-t_cr;
% Decode
% dec_output=[dec_output_Y1,dec_output_Cb1,dec_output_Cr1];
% l = length(dec_output);
% dec_output_Y = dec_output(1:l/2);
% dec_output_Cb = dec_output(l/2+1:3*l/4);
% dec_output_Cr = dec_output(3*l/4+1:end);

sizes=sizes_full(:,:,9);
j=1;
i=1;
% j=1;
recon_Y=[];
recon_Cb=[];
recon_Cr=[];
for r=1:8:row_size
for  c=1:8:col_size
        
    %split decoder output in blocks of length 64
        
            block_64_Y = dec_output_Y(j:j+63);
        
        
%       block_64_Cb = dec_output_Cb(j:j+63);
%       block_64_Cr = dec_output_Cr(j:j+63);
        block_16_Cb = dec_output_Cb(i:i+15);
        block_16_Cr = dec_output_Cr(i:i+15);
        
        
        
        %undo the zigzag scan
        block_8x8_Y = DeZigZag8x8(block_64_Y);
        block_4x4_Cb = DeZigZag8x8(block_16_Cb);
        block_4x4_Cr = DeZigZag8x8(block_16_Cr);
        
        %dequantize each block
        [ block_out_Y, block_out_Cb, block_out_Cr ] = DeQuant8x8( block_8x8_Y, block_4x4_Cb, block_4x4_Cr,factor,option);
        
        %undo DCT
        block_IDCT_Y = IDCT8x8(block_out_Y);
        block_IDCT_Cb = IDCT8x8(block_out_Cb);
        block_IDCT_Cr = IDCT8x8(block_out_Cr);
        
        %concatenate blocks
        recon_Y(r:r+7, c:c+7) = block_IDCT_Y;
        recon_Cb(ceil(r/2):ceil(r/2)+3, ceil(c/2):ceil(c/2)+3) = block_IDCT_Cb;
        recon_Cr(ceil(r/2):ceil(r/2)+3, ceil(c/2):ceil(c/2)+3) = block_IDCT_Cr;
   
    
        j = j + 64;
        i=i+16;
%         %split decoder output in blocks
%           block_Y = dec_output_Y(i:i+63);
% %         block_Cb = dec_output_Cb(j:j+(sizes/2)^2-1);
% %         block_Cr = dec_output_Cb(j:j+(sizes/2)^2-1);
%       block_Cb = dec_output_Cb(i:i+63);
%       block_Cr = dec_output_Cb(i:i+63);
% 
%         
%         %undo the zigzag scan
%         zigzag_Y = DeZigZag8x8(block_Y);
%         zigzag_Cb = DeZigZag8x8(block_Cb);
%         zigzag_Cr = DeZigZag8x8(block_Cr);
%         
%         %dequantize each block
%         [block_out_Y,block_out_Cb,block_out_Cr] = DeQuant8x8(zigzag_Y,zigzag_Cb,zigzag_Cr, q_factor);
% %         [block_out_Cb] = DeQuant(zigzag_Cb, q_factor, option);
% %         [block_out_Cr] = DeQuant(zigzag_Cr, q_factor, option);
% %         
%         %undo DCT
%         block_IDCT_Y = IDCT8x8(block_out_Y);
%         block_IDCT_Cb = IDCT8x8(block_out_Cb);
%         block_IDCT_Cr = IDCT8x8(block_out_Cr);
%         
%         %concatenate blocks
%         
%         %recon_Y(k:k+sizes-1,t:t+sizes-1) = block_IDCT_Y;
%         recon_Y(k:k+7,t:t+7) = block_IDCT_Y;
% %         recon_Cb(ceil(k/2):ceil((k/2))+(sizes/2)-1,ceil(t/2):(ceil(t/2))+(sizes/2)-1) = block_IDCT_Cb;
% %         recon_Cr(ceil(k/2):ceil((k/2))+(sizes/2)-1,ceil(t/2):(ceil(t/2))+(sizes/2)-1) = block_IDCT_Cr;
% %           recon_Cb(k:k+sizes-1,t:t+sizes-1) = block_IDCT_Cb;
% %          recon_Cr(k:k+sizes-1,t:t+sizes-1) = block_IDCT_Cr;
%         recon_Cb(k:k+7,t:t+7) = block_IDCT_Cb;
%         recon_Cr(k:k+7,t:t+7) = block_IDCT_Cr;
%         
% 
%         
%        i = i + 64;
% %        j=  j+ (sizes/2)^2;
%        
       
       
end
end

 recon_Cb = chroma_up(recon_Cb);
 recon_Cr = chroma_up(recon_Cr);

Reconstructed_image=[];
Reconstructed_image(:,:,1)=recon_Y;
Reconstructed_image(:,:,2)=recon_Cb;
Reconstructed_image(:,:,3)=recon_Cr;
end