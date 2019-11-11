function [ sequence, dc_sequence,sizes_full] = IntraEncodeImage( image_Y, image_Cb, image_Cr, q_factor,block_divide_factor,option)
%IntraEncodeImage Encode the image provided in YCbCr color plane
%   Inputs  --> image_Y:    y component of the image
%               image_Cb:   cb component of the image
%               image_Cr:   cr component of the image
%               q_factor:   scalar quantization factor
%               
%   Outputs --> sequence:   zero run encoded AC sequence
%               dc_sequence:  DPCM processed DC sequence
%               sizes_full: sizes of AC/DC blocks


subsample_factor = 2;
subsampled_cb = chroma_sub(image_Cb);
subsampled_cr = chroma_sub(image_Cr);
% subsampled_cb = (image_Cb);
% subsampled_cr =(image_Cr);
zero_full_y = [];
zero_full_cb = [];
zero_full_cr = [];
dc_full_y = [];
dc_full_cb = [];
dc_full_cr = [];
dc_full_y1 = [];
dc_full_cb1 = [];
dc_full_cr1 = [];

[r_y, c_y] = size(image_Y);
sizes_full = [];
pos_full = [];
% for i=1:ctb_size:r_y
%  for j = 1:ctb_size:c_y
%        
%         
%         ctb_y = image_Y(i:i+ctb_size-1, j:j+ctb_size-1);
%         ctb_cb = subsampled_cb(ceil(i/subsample_factor):ceil(i/subsample_factor)+ctb_size/subsample_factor-1, ceil(j/subsample_factor):ceil(j/subsample_factor)+ctb_size/subsample_factor-1);
%         ctb_cr = subsampled_cr(ceil(i/subsample_factor):ceil(i/subsample_factor)+ctb_size/subsample_factor-1, ceil(j/subsample_factor):ceil(j/subsample_factor)+ctb_size/subsample_factor-1);
        
        
for k =1:block_divide_factor:r_y
for t=1:block_divide_factor:c_y
coding_block_y = image_Y(k:k+7,t:t+7);
coding_block_cb = subsampled_cb(ceil(k/2):ceil(k/2)+3, ceil(t/2):ceil(t/2)+3);
coding_block_cr = subsampled_cr(ceil(k/2):ceil(k/2)+3, ceil(t/2):ceil(t/2)+3);
% coding_block_cb = subsampled_cb(k:k+7,t:t+7);
% coding_block_cr = subsampled_cr(k:k+7,t:t+7);
[zero_y, zero_cb, zero_cr, dc_y, dc_cb, dc_cr]= IntraEncodeBlock(coding_block_y, coding_block_cb, coding_block_cr, q_factor,option);
zero_full_y = [zero_full_y, zero_y];
zero_full_cb = [zero_full_cb, zero_cb];
zero_full_cr = [zero_full_cr, zero_cr];
dc_full_y = [dc_full_y, dc_y];
dc_full_cb = [dc_full_cb, dc_cb];
dc_full_cr = [dc_full_cr, dc_cr];
end
end
% end

% zero run encoded sequence
sizes_full(:,:,1)=size(zero_full_y,2);
sizes_full(:,:,2)=size(zero_full_cb,2);
sizes_full(:,:,3)=size(zero_full_cr,2);
sequence = [zero_full_y, zero_full_cb, zero_full_cr];
% dpcm on dc components
dc_full_y1 = Run_DPCM(dc_full_y, 1);
dc_full_cb1 = Run_DPCM(dc_full_cb, 1);
dc_full_cr1 = Run_DPCM(dc_full_cr, 1);
dc_sequence = [dc_full_y1, dc_full_cb1, dc_full_cr1];

sizes_full(:,:,4)=size(dc_full_y1,2);
sizes_full(:,:,5)=size(dc_full_cb1,2);
sizes_full(:,:,6)=size(dc_full_cr1,2);
sizes_full(:,:,7)=r_y;
sizes_full(:,:,8)=c_y;
sizes_full(:,:,9)=block_divide_factor;

end

