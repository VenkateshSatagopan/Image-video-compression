function [ block_out_Y, block_out_Cb, block_out_Cr ] = Quant8x8( block_in_Y, block_in_Cb, block_in_Cr,factor,option)


%Input ------------------> block_in_y(Y component block of size nxn)
%                          block_in_Cb(Cb component block of size nxn)
%                          block_in_Cr(Cr component block of size nxn)
%                           factor(Quantisation factor)     
%                           option =1 for Intracoding
%                           option=2 for intercoding


%output------------------>block_out_y(Quantised Y component block of size nxn)
%                          block_out_Cb(Quantised Cb component block of size nxn)
%                          block_out_Cr(Quantised component block of size nxn)


bl_sz = length(block_in_Cb);


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


if bl_sz==8
if option==1
C = factor*[17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 13 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    ];
else
C = factor*[11 13 15 17 19 20 22 24;
            13 15 17 19 20 22 24 25;
            15 17 19 20 22 24 25 27;
            17 19 20 22 24 25 27 29;
            19 20 22 24 25 27 29 30;
            20 22 24 25 27 29 30 31;
            22 24 25 27 29 30 31 33;
            24 25 27 29 30 31 33 34];
end
else
    if option==1
    C=factor*[17 18 24 47;
        18 21 26 66;
        24 13 56 99;
        47 66 99 99];
    else
      C=factor*[10 15 20 24;
          15,19 24 27;
          20 24 27 31;
          24 27 31 33];
    end
          
    
end


        block_out_Y = round(block_in_Y./L);
        block_out_Cb = round(block_in_Cb./C);
        block_out_Cr = round(block_in_Cr./C);

end