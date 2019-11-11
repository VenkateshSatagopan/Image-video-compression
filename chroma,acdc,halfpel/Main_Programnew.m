clc;
clear;
%%
names =['D:/IVC/NEW_IVC_labs_starting_point_FINAL/Final_w_subs/data/video/foreman0020.bmp'];
names2=['D:/IVC/NEW_IVC_labs_starting_point_FINAL/Final_w_subs/data/video/foreman00'];
%%
cellnames = cellstr(names);
cellnames2 = cellstr(names2);
name=1;
PSNR = zeros(21,1);
b_rate = zeros(21,1);
PSNR_av = zeros(6,1);
b_rate_av = zeros(6,1);
m1=-4;
m2=4;

%%
for name = 1:1
a = 1.2;
kk=1;
for it = 1:1
a=a-0.2;
input_image_filename = strjoin(cellnames(name));
ORIGINAL_image = double( imread( input_image_filename ) ) ;
%use lena_small to build Huffman table
lena = 'C:\Users\Toshiba\Documents\MATLAB\Git\IVClab\data\images\lena_small.tif';
Huffman_image = double( imread(lena ) ) ;
enc_final=IntraEncode(Huffman_image,a,1);
minimum=-500;
maximum=1000;
occur = histc(enc_final, minimum:maximum);
PMF = occur/sum(occur);
H = calc_entropy(occur);
[ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( PMF );

%compress fore0020
enc_final1=IntraEncode(ORIGINAL_image,a,1);
% encode foreman
enc_final11=enc_final1-minimum+1;
bytestream = enc_huffman_new(enc_final11, BinCode, Codelengths);
output = dec_huffman_new(bytestream, BinaryTree, max(size(enc_final11)));
output=output+minimum-1;
Reconstructed_imagenew=IntraDecode(output,size(ORIGINAL_image,1),size(ORIGINAL_image,2),a,1);
% decode
MSE=calcMSE(ORIGINAL_image,Reconstructed_imagenew);
PSNR(kk,it) = calcPSNR(8,MSE);
b_rate_ini = 8*length(bytestream)/(size(ORIGINAL_image,1) *size(ORIGINAL_image,2));
b_rate(kk,it) = b_rate_ini; 


% figure;
% imshow(ORIGINAL_image/255);
% figure;
% imshow(Reconstructed_imagenew/255);
%Newly added
minimum=-500;
maximum=1000;
ss1=size(ORIGINAL_image,1);
ss2=size(ORIGINAL_image,2);
[RECONS_image_Y(:,:,1),RECONS_image_Cb(:,:,1),RECONS_image_Cr(:,:,1)]=ictRGB2YCbCr(Reconstructed_imagenew);
%kk=1;
for tt = 21:40
input_image_filename = [strjoin(cellnames2(name)), num2str(tt), '.bmp'];
ORIGINAL_image = double( imread( input_image_filename ) ) ;
[ORIGINAL_image_Y, ORIGINAL_image_Cb, ORIGINAL_image_Cr] = ictRGB2YCbCr(ORIGINAL_image);
%Motion Estimaton Block
CONCAT_im_Y = [];
CONCAT_im_Cb = [];
CONCAT_im_Cr = [];
M = [];
%Error   
 for i = 1:8:ss1
 for j = 1:8:ss2
%             
ssd = inf;
for t1 = -4:4
for t2 = -4:4
if(i+t1 > 0 && i+7+t1 <= ss1 && j+t2 > 0 && j+7+t2 <= ss2)                        
 reference_block = RECONS_image_Y(i+t1:i+7+t1, j+t2:j+7+t2);
 ssd_curr = sum(sum((ORIGINAL_image_Y(i:i+7, j:j+7) - reference_block).^2));
%                                                   
if(ssd_curr < ssd)
motion_vect = [t1 t2];
ssd = ssd_curr;
good_block = reference_block;
end
end
end
end

M = [M; motion_vect];
r = motion_vect(1);
c = motion_vect(2);
block_curr_Y = RECONS_image_Y(i+r:i+7+r, j+c:j+7+c);
block_curr_Cb = RECONS_image_Cb(i+r:i+7+r, j+c:j+7+c);
block_curr_Cr = RECONS_image_Cr(i+r:i+7+r, j+c:j+7+c);
%this is the image obtained by shifting blocks with the motion
%vectors
CONCAT_im_Y(i:i+7, j:j+7) = block_curr_Y;
CONCAT_im_Cb(i:i+7, j:j+7) = block_curr_Cb;            
CONCAT_im_Cr(i:i+7, j:j+7) = block_curr_Cr;
end
end
 
 
%error between the shifted previous frame and the current frame (YCbCr)
err_Y = ORIGINAL_image_Y(:,:) - CONCAT_im_Y(:, :);
err_Cb = ORIGINAL_image_Cb(:,:) - CONCAT_im_Cb(:, :);
err_Cr = ORIGINAL_image_Cr(:,:) - CONCAT_im_Cr(:, :);
err_final(:,:,1)=err_Y;
err_final(:,:,2)=err_Cb;
err_final(:,:,3)=err_Cr;
[err_final_R,err_final_G,err_final_B]=ictYCbCr2RGB(err_final);
err_final(:,:,1)=err_final_R;
err_final(:,:,2)=err_final_G;
err_final(:,:,3)=err_final_B;


rowsize=size(err_final,1);
columnsize=size(err_final,2);
%find huffman code for error vectors
[data_curr] = IntraEncode(err_final,a,2);   %Intraencode for error_image
occur_error = histc(data_curr, minimum:maximum);
PMF_error = occur_error/sum(occur_error);
[BinaryTree_err, HuffCode_err, BinCode_err, Codelengths_err] = buildHuffman(PMF_error);
data_curr=data_curr-minimum+1;
%Motion Code Estimation
data_motion = M(:);

%Motion vector
occur_mv = histc(data_motion, m1:m2);
PMF_mv = occur_mv/sum(occur_mv);
[BinaryTree_mv, HuffCode_mv, BinCode_mv, Codelengths_mv] = buildHuffman(PMF_mv);
data_motion = data_motion+m2+1;

%encode errors and motion vectors
bytestream_curr = enc_huffman_new(data_curr, BinCode_err, Codelengths_err);
bytestream_mv = enc_huffman_new(data_motion, BinCode_mv, Codelengths_mv);
    
disp(['err_bit_rate=', num2str(length(bytestream_curr)*8/size(ORIGINAL_image,1) /size(ORIGINAL_image,2))]);
disp(['mv_bit_rate=', num2str(length(bytestream_mv)*8/size(ORIGINAL_image,1) /size(ORIGINAL_image,2))]);




%Decoding Process

output_data = dec_huffman_new(bytestream_curr, BinaryTree_err, max(size(data_curr)));
output_data=output_data+minimum-1;
% Intradecoding of decoded data
output_datanew=IntraDecodenew(output_data,rowsize,columnsize,a,2);
Reconstructed_image=[];
count=1;
temp_y=[];
temp_cb=[];
temp_cr=[];


%Motion Compensation part

for i = 1:8:ss1
for j = 1:8:ss2
r = M(count,1); 
c = M(count,2);
count=count+1;
block_curr_Y = RECONS_image_Y(i+r:i+7+r, j+c:j+7+c);
block_curr_Cb = RECONS_image_Cb(i+r:i+7+r, j+c:j+7+c);
block_curr_Cr = RECONS_image_Cr(i+r:i+7+r, j+c:j+7+c);
%             temp_y(i:i+7,j:j+7)=block_curr_Y1;
%             temp_cb(i:i+7,j:j+7)=block_curr_Cb1;
%             temp_cr(i:i+7,j:j+7)=block_curr_Cr1;
            
%              block_curr_Y=CONCAT_im_Y(i:i+7, j:j+7);
%              block_curr_Cb=CONCAT_im_Cb(i:i+7,j:j+7);
%              block_curr_Cr=CONCAT_im_Cr(i:i+7, j:j+7);
Reconstructed_image(i:i+7,j:j+7,1)=block_curr_Y+output_datanew(i:i+7,j:j+7,1);
Reconstructed_image(i:i+7,j:j+7,2)=block_curr_Cb+output_datanew(i:i+7,j:j+7,2);
Reconstructed_image(i:i+7,j:j+7,3)=block_curr_Cr+output_datanew(i:i+7,j:j+7,3);
end
end
RECONS_image_Y=Reconstructed_image(:,:,1);
RECONS_image_Cb=Reconstructed_image(:,:,2);
RECONS_image_Cr=Reconstructed_image(:,:,3);
[RR,RG,RB]=ictYCbCr2RGB(Reconstructed_image);

Reconstructed_imagenew=[];
Reconstructed_imagenew(:,:,1)=RR;
Reconstructed_imagenew(:,:,2)=RG;
Reconstructed_imagenew(:,:,3)=RB;
MSE=calcMSE(ORIGINAL_image,Reconstructed_imagenew);
kk=kk+1;
PSNR(kk,it)=calcPSNR(8,MSE);
b_rate_curr = 8*(length(bytestream_curr)+length(bytestream_mv))/(size(ORIGINAL_image,1) *size(ORIGINAL_image,2));
b_rate(kk,it) = b_rate_curr;
 end
disp('Mean PSNR and bit rate of factor=');
disp(it);
disp('\n');
psnr_av(it,name) = mean(PSNR(:,it))
b_rate_av(it,name) = mean(b_rate(:,it))
kk=1;
end
end
plot(b_rate_av,psnr_av);
title('Graph between bitrate and PSNR')
xlabel('bitrate');
ylabel('PSNR');