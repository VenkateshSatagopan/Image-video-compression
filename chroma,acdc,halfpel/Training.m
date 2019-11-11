function [recon_Y, recon_Cb, recon_Cr,b_rate_curr] = Training(ORIGINAL_image_Y, ORIGINAL_image_Cb, ORIGINAL_image_Cr, q_factor)

%%
%   Inputs: ORIGINAL_image = image in YCbCr format
%            q_factor       = quantization factor
%   Outputs: Reconstructed_imagenew  = YcbCr reconstructed image 
%   b_rate_curr       = bitrate calculated from bytestream_ac+bytestream_dc

% use lena_small to build Huffman table
lena_small = 'data/images/lena_small.tif';
Original_small_image = double( imread( lena_small ) ) ;
[Original_small_image_Y, Original_small_image_Cb, Original_small_image_Cr] = ictRGB2YCbCr(Original_small_image);
block_divide=8;
[ac_seq, dc_seq,~] = IntraEncodeImage(Original_small_image_Y, Original_small_image_Cb, Original_small_image_Cr, q_factor,block_divide,1);
min_val = -500;
max_val = 1000;
extended_z = min_val:max_val;
occur_ac = histc(ac_seq, extended_z);
pmf_ac = occur_ac/sum(occur_ac);
[ BinaryTree_ac, HuffCode_ac, BinCode_ac, Codelengths_ac] = buildHuffman( pmf_ac );
occur_dc = histc(dc_seq, extended_z);
pmf_dc = occur_dc/sum(occur_dc);
[ BinaryTree_dc, HuffCode_dc, BinCode_dc, Codelengths_dc] = buildHuffman( pmf_dc );
[ sequence, dc_sequence,sizes_full] = IntraEncodeImage(ORIGINAL_image_Y, ORIGINAL_image_Cb, ORIGINAL_image_Cr,q_factor,block_divide,1);
% first_frame=[];
% first_frame(:,:,1)=ORIGINAL_image_Y;
% first_frame(:,:,2)=ORIGINAL_image_Cb;
% first_frame(:,:,3)=ORIGINAL_image_Cr;
% Encode foreman
bytestream_ac = enc_huffman_new(sequence-min_val+1, BinCode_ac, Codelengths_ac);
bytestream_dc = enc_huffman_new(dc_sequence-min_val+1, BinCode_dc, Codelengths_dc);
% Decode
output_ac = dec_huffman_new(bytestream_ac, BinaryTree_ac, max(size(sequence)));
output_ac = output_ac + min_val - 1;
output_dc = dec_huffman_new(bytestream_dc, BinaryTree_dc, max(size(dc_sequence)));
output_dc = output_dc + min_val - 1;
[Reconstructed_imagenew] =IntraDecode2(output_ac, output_dc,sizes_full, q_factor,1);
recon_Y=Reconstructed_imagenew(:,:,1);
recon_Cb=Reconstructed_imagenew(:,:,2);
recon_Cr=Reconstructed_imagenew(:,:,3);



b_rate_curr = 8*(length(bytestream_ac)+length(bytestream_dc))/(size(ORIGINAL_image_Y,1) *size(ORIGINAL_image_Y,2));
end

