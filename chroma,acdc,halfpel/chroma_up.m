function [ up2 ] = chroma_up( down )
%chroma_up For chroma plane upsampling
%   Input  --> down: downsampled version of given chroma plane
%   Output --> up2:  upsampled version of given chroma plane

down2(:,:,1) = padarray(down(:,:,1),[4 4],'replicate');

up1(:,:,1) = resample(down2(:,:,1), 2,1, 3);
up2(:,:,1) = resample(up1(:,:,1)',2,1,3)';

up2 = up2(9:end-8, 9:end-8, :);
end

