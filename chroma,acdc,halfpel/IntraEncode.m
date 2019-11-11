function enc_final= IntraEncode(inputimage,factor,option)
[Y,Cb,Cr]=ictRGB2YCbCr(inputimage);
DCTimageY=[];
DCTimagecb=[];
DCTimagecr=[];
QuantimageY=[];
Quantimagecb=[];
Quantimagecr=[];
ZigzagsmallY=[];
Zigzagsmallcb=[];
Zigzagsmallcr=[];
encode_y=[];
encode_cb=[];
encode_cr=[];
subsampled_cb = chroma_sub(Cb);
subsampled_cr = chroma_sub(Cr);

for i=1:8:size(inputimage,1)
 for j=1:8:size(inputimage,2)
   DCTimageY(i:i+7,j:j+7)=DCT8x8(Y(i:i+7,j:j+7,1));
   
  %[block_y,block_cb,block_cr]=Quant8x8(DCTimageY(i:i+7,j:j+7),DCTimagecb(i:i+7,j:j+7),DCTimagecr(i:i+7,j:j+7),factor,option);
   [block_y]=Quant8x8Y(DCTimageY(i:i+7,j:j+7),factor,option);
   QuantimageY(i:i+7,j:j+7)=block_y;
  
   scan_Y=zigzag8x8(QuantimageY(i:i+7,j:j+7));
   ZigzagsmallY=[ZigzagsmallY, scan_Y];
   Run_enc_Y=ZeroRunEnc(scan_Y);
   encode_y=[encode_y,Run_enc_Y];
   
   
end
end

for i=1:8:(size(inputimage,1)/2)
 for j=1:8:(size(inputimage,2)/2)
   DCTimagecb(i:i+7,j:j+7)=DCT8x8(subsampled_cb(i:i+7,j:j+7,1));
   DCTimagecr(i:i+7,j:j+7)=DCT8x8(subsampled_cr(i:i+7,j:j+7,1));
   [block_cb]=Quant8x8Cb(DCTimagecb(i:i+7,j:j+7),factor,option);
   [block_cr]=Quant8x8Cb(DCTimagecr(i:i+7,j:j+7),factor,option);
   Quantimagecb(i:i+7,j:j+7)=block_cb;
   Quantimagecr(i:i+7,j:j+7)=block_cr;
   scan_cb=zigzag8x8(Quantimagecb(i:i+7,j:j+7));
   scan_cr=zigzag8x8(Quantimagecr(i:i+7,j:j+7));
   Zigzagsmallcb=[Zigzagsmallcb, scan_cb];
   Zigzagsmallcr=[Zigzagsmallcr, scan_cb];
   Run_enc_cb=ZeroRunEnc(scan_cb);
   Run_enc_cr=ZeroRunEnc(scan_cr);
   encode_cb=[encode_cb,Run_enc_cb];
   encode_cr=[encode_cr,Run_enc_cr];
 end
end
   
enc_final = [encode_y,encode_cb,encode_cr];
% disp(size(ZigzagsmallY));
% disp(size(Zigzagsmallcb));
% disp(size(Zigzagsmallcr));
% disp(size(encode_y));
% disp(size(encode_cb));
% disp(size(encode_cr));
end


% for i=1:8:64
%  for j=1:8:64
% [Quantimage(i:i+7,j:j+7,k),Quantimage(i:i+7,j:j+7,1),Quantimage(i:i+7,j:j+7,3)]=Quant8x8(DCTimage(i:i+7,j:j+7,1),DCTimage(i:i+7,j:j+7,2),DCTimage(i:i+7,j:j+7,3));
%  end
% end
% ZigzagsmallY=[];
% Zigzagsmallcb=[];
% Zigzagsmallcr=[];
% 
% for i=1:8:64
% for j=1:8:64
%  ZigzagsmallY=[ZigzagsmallY;zigzag8x8(Quantimage(i:i+7,j:j+7,1))];
%  Zigzagsmallcb=[ZigzagsmallY;zigzag8x8(Quantimage(i:i+7,j:j+7,2))];
%  Zigzagsmallcr=[ZigzagsmallY;zigzag8x8(Quantimage(i:i+7,j:j+7,3))];
% end
% end
% 
% for i=1:8:64
% for j=1:8:64
% 
% 
%  