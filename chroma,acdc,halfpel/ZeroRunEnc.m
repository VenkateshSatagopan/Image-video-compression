function [sequence ] = ZeroRunEnc( vect )
%Input------------------>Input vector to be Run length encoded
%Output----------------->Sequence(Output run length sequence corresponding to input
sequence = [];
i = 1;
while(i <= length(vect))
    count = 0;
   
    while(i < length(vect) && vect(i) == 0 && vect(i+1) == vect(i))
        count = count + 1;
        i = i+1;
    end 
    if(vect(i) == 0 && i == length(vect))
        sequence = [sequence, 1000];
        i = i+1;
        
    else if(vect(i) == 0)
        sequence = [sequence, vect(i), count];
        i = i+1;
       
        else
            sequence = [sequence, vect(i)];
            i = i + 1;
        end
    end
    


end



