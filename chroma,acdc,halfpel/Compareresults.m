clc;
clear;
%%
% %For still image
% PSNR_without=load('C:\Users\Toshiba\Documents\MATLAB\Git\IVClab\Nomal\ForACDC\psnr_av1');
% PSNR_withoutopt=PSNR_without.PSNR1;
% Bitrate_without=load('C:\Users\Toshiba\Documents\MATLAB\Git\IVClab\Nomal\ForACDC\b_rate_av1');
% Bitrate_withoutopt=Bitrate_without.bitrate1;
% PSNR_with=load('D:\IVC\AcwithDcandchromasubsampling\ACDCwithchromasubsampling\checkresults\ACDC\psnr_av1');
% PSNR_withopt=PSNR_with.psnr_av;
% Bitrate_with=load('D:\IVC\AcwithDcandchromasubsampling\ACDCwithchromasubsampling\checkresults\ACDC\b_rate_av1');
% Bitrate_withopt=Bitrate_with.b_rate_av;
% figure;
% plot(Bitrate_withoutopt,PSNR_withoutopt,'color','b');hold on
% title('Graph between bitrate and PSNR')
% xlabel('Bitrate');
% ylabel('PSNR');
% plot(Bitrate_withopt,PSNR_withopt,'color','r');
% legend('Withoutoptimisation','withoptimisation')
%For video sequence
PSNR_without=load('C:\Users\Toshiba\Documents\MATLAB\Git\IVClab\Nomal\chroma\psnr_av');
Bitrate_without=load('C:\Users\Toshiba\Documents\MATLAB\Git\IVClab\Nomal\chroma\b_rate_av');
PSNR_withoutopt=PSNR_without.psnr_av;
Bitrate_withoutopt=Bitrate_without.b_rate_av;
PSNR_with=load('D:\IVC\AcwithDcandchromasubsampling\ChromawithSubsamplingalone\checkresults\chromaold\psnr_av');
PSNR_withopt=PSNR_with.psnr_av;
Bitrate_with=load('D:\IVC\AcwithDcandchromasubsampling\ChromawithSubsamplingalone\checkresults\chromaold\b_rate_av');
Bitrate_withopt=Bitrate_with.b_rate_av;
% PSNR_with1=load('D:\IVC\AcwithDcandchromasubsampling\ACDCwithchromasubsampling\checkresults\ACDCvideo\psnr_av1');
% PSNR_withopt1=PSNR_with1.psnr_av;
% Bitrate_with1=load('D:\IVC\AcwithDcandchromasubsampling\ACDCwithchromasubsampling\checkresults\ACDCvideo\b_rate_av1');
% Bitrate_withopt1=Bitrate_with1.b_rate_av;
figure;
plot(Bitrate_withoutopt,PSNR_withoutopt,'color','b');hold on
title('Graph between bitrate and PSNR')
xlabel('Bitrate');
ylabel('PSNR');
plot(Bitrate_withopt,PSNR_withopt,'color','r'); hold on
%plot(Bitrate_withopt1,PSNR_withopt1,'color','g'); 
legend('Withoutoptimisation','withoptimisation','withchroma')


