function [Y,CB,CR]= ictRGB2YCbCr(img)
[m,n]=size(img);
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
Y= (0.299*R)+(0.587*G)+(0.114*B);
CB=(-0.169*R)+(-0.331*G)+(0.5*B);
CR=(0.5*R)+(-0.419*G)+(-0.081*B);
end