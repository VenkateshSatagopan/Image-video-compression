function [ block_out_Cb] = Quant8x8Cb( block_in_Cb,factor,option)


bl_sz = length(block_in_Cb);
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

block_out_Cb = round(block_in_Cb./C);
%block_out_Cr = round(block_in_Cr./C);
end