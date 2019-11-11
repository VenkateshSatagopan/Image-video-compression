function PSNR = calcPSNR(B, MSE)
% Input----> B
%            MSE(Mean square error)
%Output---->PSNR(Peak signal to Noise ratio)

    PSNR = 10 * (log10(((2^B - 1)^2)/MSE));
   
end