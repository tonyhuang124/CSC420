%% Q2b
% 
addpath('dpm') ;
addpath('devkit') ;

col = 'r';
imdata = getData([], 'test','list');
ids = imdata.ids(1:3);
for i = 1:3
    DS = [];
    f = 1.5;
    image = getData(ids{i}, 'test', 'left');
    im = image.im;
    imr = imresize(im,f); % if we resize, it works better for small objects
    % detect objects
    fprintf('running the detector, may take a few seconds...\n');
    tic;
    %[ds, bs] = imgdetect(imr, model, model.thresh); % you may need to reduce the threshold if you want more detections
    detect_list = {'detector-car','detector-person','detector-cyclist'};
    thereshold = {0,-0.55,-0.5};
    for detect_label  = 1:3
        data = getData([], [], detect_list{detect_label});
        model = data.model;
        [ds, bs] = imgdetect(imr,model, thereshold{detect_label});
        e = toc;
        fprintf('finished! (took: %0.4f seconds)\n', e);
        name = strcat(ids{i},detect_list{detect_label});
        if ~isempty(ds)
            % resize back
            ds(:, 1:end-2) = ds(:, 1:end-2)/f;
            bs(:, 1:end-2) = bs(:, 1:end-2)/f;
            top = nms(ds, 0.5);
            ds = ds(top,:);
            bs = bs(top,:);
        end
        save(name,'ds','bs');
    end
end
