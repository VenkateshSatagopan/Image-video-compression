function block_out= IDCT8x8(block_input)


idct_mat=idct(block_input);
temp=idct_mat';
block_out=idct(temp);
block_out=block_out';
end

