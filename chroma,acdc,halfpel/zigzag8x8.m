function zigzagoutput= zigzag8x8(input)

bl_sz = length(input);
block_in=input;

if bl_sz==8

zigzag=[1 2 6 7 15 16 28 29;
        3 5 8 14 17 27 30 43;
        4 9 13 18 26 31 42 44;
        10 12 19 25 32 41 45 54;
        11 20 24 33 40 46 53 55;
        21 23 34 39 47 52 56 61;
        22 35 38 48 51 57 60 62;
        36 37 49 50 58 59 63 64];
  
 
  zigzagoutput(zigzag(:))=input(:);
  
else 
  vect = [];

for s = 2:sum(size(block_in))
    if(mod(s,2) == 1)
        for j = max(1, s-bl_sz):min(bl_sz,s-1)
            vect = [vect; block_in(j,s-j)];
        end
    end
    if(mod(s,2) == 0)
        for i = max(1, s-bl_sz):min(s-1, bl_sz)
            vect = [vect; block_in(s-i, i)];
        end
    end
    
end
zigzagoutput=vect';
end
end
    