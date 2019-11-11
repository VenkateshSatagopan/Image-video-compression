function MSE = calcMSE(ORIGINAL_image,RECONSTRUCTED_image)

%% 
%Calculates MSE of image
%Input------> ORIGINAL_image(RGB format)
%            Reconstructed_image(RGB format)
%output-----> MSE

    sum = 0;
   [m,n,p]=size(ORIGINAL_image);
    for i = 1 : m
        for j = 1 : n
            for k = 1 : p
                sum = sum + ((ORIGINAL_image(i,j,k) - RECONSTRUCTED_image(i,j,k))^2);
            end
        end
    end
    MSE = sum/(m * n * p);
end