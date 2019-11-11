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
kk1=input('enter the 1st value');
kk2=input('enter the 2nd value');
for name = 1:1
a = 1.2;
kk=1;
for it = 1:1
a=a-0.2;
input_image_filename = strjoin(cellnames(name));
ORIGINAL_image = double( imread( input_image_filename)) ;
first_frame=double( imread( input_image_filename)) ;
[first_frame_y, first_frame_cb, first_frame_cr] = ictRGB2YCbCr(first_frame);
[recons_y, recons_cb, recons_cr,b_rate_curr] = Training(first_frame_y, first_frame_cb, first_frame_cr, a);
recon_image_y(:,:,1) = recons_y;
recon_image_cb(:,:,1) = recons_cb;
recon_image_cr(:,:,1) = recons_cr;
Reconstructed_image=[];
Reconstructed_image(:,:,1)=recons_y;
Reconstructed_image(:,:,2)=recons_cb;
Reconstructed_image(:,:,3)=recons_cr;
[recons_r, recons_g, recons_b] = ictYCbCr2RGB(Reconstructed_image);
Reconstructed_imagenew=[];
Reconstructed_imagenew(:,:,1) = recons_r;
Reconstructed_imagenew(:,:,2) = recons_g;
Reconstructed_imagenew(:,:,3) = recons_b;
MSE=calcMSE(ORIGINAL_image,Reconstructed_imagenew);
PSNR(kk,it) = calcPSNR(8,MSE);
b_rate(kk,it) = b_rate_curr;
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
ref_img(:,:,1)=RECONS_image_Y;
ref_img(:,:,2)=RECONS_image_Cb;
ref_img(:,:,3)=RECONS_image_Cr;
 for tt = 21:40
input_image_filename = [strjoin(cellnames2), num2str(tt), '.bmp'];
ORIGINAL_image = double( imread( input_image_filename ) ) ;
[ORIGINAL_image_Y, ORIGINAL_image_Cb, ORIGINAL_image_Cr] = ictRGB2YCbCr(ORIGINAL_image);
current_image(:,:,1)=ORIGINAL_image_Y;
current_image(:,:,2)=ORIGINAL_image_Cb;
current_image(:,:,3)=ORIGINAL_image_Cr;
%Motion Estimaton Block
[err_final, M] = MotionEstimation_pel(ref_img, current_image, kk1, kk2);

%err_final(:,:,1)=err_Y;
%err_final(:,:,2)=err_Cb;
%err_final(:,:,3)=err_Cr;
rowsize=size(err_final,1);
columnsize=size(err_final,2);
output_datanew=[];
[output_datanew(:,:,1),output_datanew(:,:,2),output_datanew(:,:,3),b_rate_curr]=InterEncodewithdecode_imagenew(err_final(:,:,1),err_final(:,:,2),err_final(:,:,3),a,M,2);

dec_err(:,:,1)=output_datanew(:,:,1);
dec_err(:,:,2)=output_datanew(:,:,2);
dec_err(:,:,3)=output_datanew(:,:,3);

%Motion Compensation part
[decoded_frame, MV] = MotionCompensation_pel(ref_img, M, dec_err, kk1, kk2);
Reconstructed_image(:,:,1)=decoded_frame(:,:,1);
Reconstructed_image(:,:,2)=decoded_frame(:,:,2);
Reconstructed_image(:,:,3)=decoded_frame(:,:,3);

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
PSNR(kk,it)=calcPSNR(8,MSE)
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

