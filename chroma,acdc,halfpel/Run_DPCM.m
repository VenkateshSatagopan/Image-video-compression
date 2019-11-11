function [ dpcm ] = Run_DPCM( dc_comps, option )

%   Input:  dc_comps: Dc_component array
%           option:   if 1 --> encode
%                     if 2 --> decode
%   Output: dpcm:      output array after performing DPCM

len = length(dc_comps);
dpcm = zeros(1, len);
dpcm(1) = dc_comps(1);
% Encode
if option == 1  
    dpcm(2:end) = dc_comps(2:end) - dc_comps(1:end-1);
% Decode
elseif option == 2 
    dpcm(1);
    for i =2:len
        dpcm(i) = dpcm(i-1) + dc_comps(i);
    end
end

end