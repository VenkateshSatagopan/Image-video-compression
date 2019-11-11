function block_out= DCT8x8(block_input)
%Input-------->Input_block of size mxn
%output------->block_out(DCT of Input_block)

dct_mat=dct(block_input);
temp=dct_mat';
block_out=(dct(temp))';

end

