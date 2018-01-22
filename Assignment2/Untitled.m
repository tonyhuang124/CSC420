%or load a real image
%img = rand(imSize,imSize);
img = imread('synthetic.png');
img = double(img);
img = mean(img,3);

%%perform base-level smoothing to supress noise
imgS = img;%conv2(img,fspecial('Gaussian',[25 25],0.5),'same');%Base smoothing
cnt = 1;
clear responseDoG responseLoG
k = 2;
sigma = 10;
s = k.^(1:10)*sigma;
responseDoG = zeros(size(img,1),size(img,2),length(s));
responseLoG = zeros(size(img,1),size(img,2),length(s));
imG = zeros(size(img,1),size(img,2),length(s));

d = [1 1]';
%% Filter over a set of scales
fg = figure;imagesc(img);axis image;hold on;colormap gray;
drawnow;
for si = 1:length(s)
    sL = s(si);
    hs= max(25,min(floor(sL*3),512));
    HL = fspecial('log',[hs hs],sL);
 

    imgFiltL = conv2(imgS,HL,'same');
   
    %Compute the LoG
    responseLoG(:,:,si)  = (sL^2)*imgFiltL;
    [r,c] = NonminimaSup(responseLoG(:,:,si),floor(sL),0.7);
    rc = [r c];
    figure(fg);
    plot(r, c, 'ro');
end

