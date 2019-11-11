function [recon_Y, recon_Cb, recon_Cr,b_rate_curr] = InterEncodewithdecode_imagenew(ORIGINAL_image_Y, ORIGINAL_image_Cb, ORIGINAL_image_Cr, q_factor,M,option)
%%
%   Inputs: ORIGINAL_image = image in YCbCr format
%            q_factor       = quantization factor
%            M              =  Motion vector
%   Outputs: Reconstructed_imagenew  = YcbCr reconstructed image 
%   b_rate_curr       = bitrate calculated from
%   bytestream_ac+bytestream_dc_byte_stream_mv
%%
block_divide=8;
[ac_seq,sizes_full] = IntraEncodeImage_new1(ORIGINAL_image_Y, ORIGINAL_image_Cb, ORIGINAL_image_Cr,q_factor,block_divide,option);
min_val = -500;
max_val = 1000;
m1=-4;
m2=4;
extended_z = min_val:max_val;
occur_ac = histc(ac_seq, extended_z);
pmf_ac = occur_ac/sum(occur_ac);
[BinaryTree_ac, HuffCode_ac, BinCode_ac, Codelengths_ac] = buildHuffman( pmf_ac );
%Motion vector
%Motion Code Estimation
data_motion = M(:);
occur_mv = histc(data_motion, m1:m2);
PMF_mv = occur_mv/sum(occur_mv);
[BinaryTree_mv, HuffCode_mv, BinCode_mv, Codelengths_mv] = buildHuffman(PMF_mv);
data_motion = data_motion+m2+1;
% Encode foreman
bytestream_ac = enc_huffman_new(ac_seq-min_val+1, BinCode_ac, Codelengths_ac);
%min_value=min(dc_seq_new);

bytestream_mv = enc_huffman_new(data_motion, BinCode_mv, Codelengths_mv);
%Decode
output_ac = dec_huffman_new(bytestream_ac, BinaryTree_ac, max(size(ac_seq)));
output_ac = output_ac + min_val - 1;
[Reconstructed_imagenew] =IntraDecode2new1(output_ac,sizes_full, q_factor,option);
recon_Y=Reconstructed_imagenew(:,:,1);
recon_Cb=Reconstructed_imagenew(:,:,2);
recon_Cr=Reconstructed_imagenew(:,:,3);
b_rate_curr = 8*(length(bytestream_ac)+length(bytestream_mv))/(size(ORIGINAL_image_Y,1) *size(ORIGINAL_image_Y,2));
end

