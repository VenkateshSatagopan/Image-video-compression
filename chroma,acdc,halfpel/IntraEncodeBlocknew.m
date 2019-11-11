function [zero_y, zero_cb, zero_cr] = IntraEncodeBlocknew( block_Y, block_Cb, block_Cr, q_factor,option)
%%
%IntraEncodeBlock Summary of this function goes here
%   Inputs  --> block_Y:    y component of the block
%               block_Cb:   cb component of the block
%               block_Cr:   cr component of the block
%               q_factor:   scalar quantization factor
%              
%   Outputs --> zero_y:     y component of zero run encoded sequence
%               zero_cb:    cb component of zero run encoded sequence
%               zero_cr:    cr component of zero run encoded sequence

dct_y = DCT8x8(block_Y);
dct_cb = DCT8x8(block_Cb);
dct_cr = DCT8x8(block_Cr);
[quant_y,quant_cb,quant_cr]= Quant8x8(dct_y,dct_cb,dct_cr, q_factor,option);
zigzag_y = zigzag8x8(quant_y);
zigzag_cb = zigzag8x8(quant_cb);
zigzag_cr = zigzag8x8(quant_cr);
% dc_y = zigzag_y(1);
% dc_cb = zigzag_cb(1);
% dc_cr = zigzag_cr(1);
zero_y = ZeroRunEnc(zigzag_y);
zero_cb = ZeroRunEnc(zigzag_cb);
zero_cr = ZeroRunEnc(zigzag_cr);
end