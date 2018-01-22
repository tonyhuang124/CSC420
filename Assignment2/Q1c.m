img = imread('synthetic.png');
img = double(img);
img = mean(img,3);

%perform base-level smoothing to supress noise
imgS = img;
cnt = 1;
clear responseLoG
k = 1.1;
sigma = 2.0;
s = k.^(1:50)*sigma;

responseLoG = zeros(size(img,1),size(img,2),length(s));
imG = zeros(size(img,1),size(img,2),length(s));

%% Filter over a set of scales
for si = 1:length(s)
    sL = s(si);
    hs= max(25,min(floor(sL*3),256));
    HL = fspecial('log',[hs hs],sL);
    imgFiltL = conv2(imgS,HL,'same');
    %Compute the LoG
    responseLoG(:,:,si)  = (sL^2)*imgFiltL;
    
end
scale_magnitude = zeros(size(img,1),size(img,2),2);
fg = figure;imagesc(img);axis image;hold on;colormap gray;
drawnow;
nmax = 0;
for y = 1:5:size(img,1)
    for x = 1:5:size(img,2)
        f = squeeze(responseLoG(y,x,:));
        [fMax,fmaxLocs] = findpeaks(f);
        [fMin,fminLocs] = findpeaks(-f);
        locs = [fmaxLocs' fminLocs'];
        extrema = [fMax' fMin'];
        [best,idx] = max(abs(extrema));
        if abs(best) > nmax
            nmax = abs(best);
        end
        sc = s(locs(idx));
        if(isempty(sc)==0)
            scale_magnitude(y,x,1) = sc;
            scale_magnitude(y,x,2) = best;
        end
        %fprintf('done\n');
    end
end

% for y = 1:5:size(img,1)
%     for x = 1:5:size(img,2)
%         if scale_magnitude(y,x,2) > 0.7*nmax
%             figure(fg)
%             xc = scale_magnitude(y,x,1)*sin(0:0.1:2*pi)+x;
%             yc = scale_magnitude(y,x,1)*cos(0:0.1:2*pi)+y;
%             plot(xc,yc,'r');
%         end
%     end
% end








[y,x] = NonMaximaSup(scale_magnitude(:,:,2),50,0.7);

for i = 1:size(y,1)
    figure(fg);
    xc = scale_magnitude(y(i,1),x(i,1),1)*sin(0:0.1:2*pi)+x(i,1);
    yc = scale_magnitude(y(i,1),x(i,1),1)*cos(0:0.1:2*pi)+y(i,1);
    plot(xc,yc,'r');

end


