function [vect,index]=ZeroRunDec(sequence,EOB,size)

%Input--------------->sequence(Input sequence)
%                       EOB(End of block)
%                       size(size after which Run length decoding has to be stopped
%Output---------------> vect(Decoded Run length vectors of Size=size(Inputparamter)
%                       index(Index of Sequence array upto which Run length decoding is performed
vect=[];

index=1;
while(length(vect)<size)
    
    if(index<=length(sequence))
        if(sequence(index)==0)
            if sequence(index+1)==0
               temp1=zeros(1,1);
            else
            temp1=zeros(1,sequence(index+1)+1);
            end
            vect=[vect temp1];
            index=index+2;
        else if(sequence(index) ~=0 &&sequence(index) ~=EOB)
                vect=[vect sequence(index)];
                index=index+1;
            else if (sequence(index)==EOB)
                    temp=zeros(1,size-length(vect));
                    vect=[vect,temp];
                    index=index+1;
                end
            end
        end
    end
end
                