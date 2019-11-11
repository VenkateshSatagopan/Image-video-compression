function Dezigzagoutput=Dezigzag8x8(input)

vect=input;

if size(input,2)==64
 zigzag=[1 2 6 7 15 16 28 29;
        3 5 8 14 17 27 30 43;
        4 9 13 18 26 31 42 44;
        10 12 19 25 32 41 45 54;
        11 20 24 33 40 46 53 55;
        21 23 34 39 47 52 56 61;
        22 35 38 48 51 57 60 62;
        36 37 49 50 58 59 63 64];
  temp = input( zigzag(:) );
  Dezigzagoutput=reshape(temp,8,8);
else 
  bl_sz = sqrt(length(vect));
index = 0;

for s = 2:2*bl_sz
  
    if(mod(s,2) == 1)
        for j = max(1, s-bl_sz):min(bl_sz,s-1)
            index = index + 1;
            block(j,s-j) = vect(index);
        end
    end
    
    if(mod(s,2) == 0)
        for i = max(1, s-bl_sz):min(s-1, bl_sz)
            index = index + 1;
            block(s-i, i) = vect(index);
        end
    end
    

end
Dezigzagoutput=reshape(block,4,4);
end
end