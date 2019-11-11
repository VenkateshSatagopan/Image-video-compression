function [ block_out_Y] = DeQuant8x8Y( block_in_Y,factor,option )

%Input ------------------> block_in_y(Y component block of size nxn)
%                          block_in_Cb(Cb component block of size nxn)
%                          block_in_Cr(Cr component block of size nxn)
%                           factor(Quantisation factor)
%output------------------>block_out_y(DeQuantised Y component block of size nxn)
%                          block_out_Cb(DeQuantised Cb component block of size nxn)
%                          block_out_Cr(DeQuantised component block of size nxn)

%bl_sz = length(block_in_Cb);
if option==1
L = factor*[16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 55 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];
else
L = factor*[11 13 15 17 19 20 22 24;
            13 15 17 19 20 22 24 25;
            15 17 19 20 22 24 25 27;
            17 19 20 22 24 25 27 29;
            19 20 22 24 25 27 29 30;
            20 22 24 25 27 29 30 31;
            22 24 25 27 29 30 31 33;
            24 25 27 29 30 31 33 34];
        
end



        block_out_Y = block_in_Y.* L;
        

end