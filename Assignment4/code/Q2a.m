%% Q2a
% 
data = getData([], 'test','list');
ids = data.ids;
for i= 1:3
 calib = getData(ids{i}, 'test', 'calib');
 disp = getData(ids{i}, 'test', 'disp');
 disparity = disp.disparity;
 numerator = calib.f*calib.baseline;
 depth = numerator./disparity;
 %incase depth larger than 255
 depth(depth>255)=255;
 figure;imagesc(depth);
end