function [ H_out ] = calc_entropy (occurences )
%computes entropy given statistics (# of occurences for each val)
%occurences is given as column vector

prob_vect = occurences/sum(occurences(:));
%extract probabilities larger than 0 
% prob_vect = prob_vect (occurences >0);
H = prob_vect.*log2(prob_vect);
H(isnan(H)) = 0;
H_out = -sum(H);

end

