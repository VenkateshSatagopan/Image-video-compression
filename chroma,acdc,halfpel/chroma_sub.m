function [ down2 ] = chroma_sub( chroma )
%chroma_sub For chroma plane subsampling
%   Input  --> chroma: one chroma plane of an image
%   Output --> down2:  downsampled version of given chroma plane

down1 = [];
down2 = [];

input_im_pad = padarray(chroma,[4 4],'replicate');

down1(:,:,1) = resample(input_im_pad, 1,2,3);
down2(:,:,1) = resample(down1(:,:,1)', 1,2,3)';
down2 = down2(3:end-2, 3:end-2);

end