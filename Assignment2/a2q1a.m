original=imread('building.png');
im=double(rgb2gray(original));
[Ix,Iy] = imgradientxy(im);
% (a.1) Computing Ix2, Iy2 and IxIy
g = fspecial('gaussian');
    
Ix2 = conv2(Ix.^2, g, 'same'); 
Iy2 = conv2(Iy.^2, g, 'same');
IxIy = conv2(Ix.*Iy, g, 'same');

harmonic_mean = (Ix2.*Iy2 - IxIy.^2)./(Ix2 + Iy2);

for y = 1:size(harmonic_mean,1)
    for x = 1:size(harmonic_mean,2)
        if isnan(harmonic_mean(y,x)) == 1
            harmonic_mean(y,x) = 0;
        end
    end
end
    

[Y,X] = NonMaximaSup(harmonic_mean, 10, 0.1);

figure, imshow(original);
hold on;
plot(X, Y, 'oR');