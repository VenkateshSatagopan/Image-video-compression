function [R,G,B]=ictYCbCr2RGB(img)
Y=img(:,:,1);
Cb=img(:,:,2);
Cr=img(:,:,3);
R=Y+(1.402*Cr);
G=Y-(0.344*Cb)-(0.714*Cr);
B=Y+(1.772*Cb);
end