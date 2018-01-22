%% Q
% this is a very simple tracking algo
% for more serious tracking, look-up the papers in the projects pdf
FRAME_DIR = '../data/frames/';
DET_DIR = '../data/detections/';
start_frame = 62;
end_frame = 71;
color_bar = ['y','m','c','r','g','b','w','k'];
track = [];
track_id = [];
for i = start_frame:end_frame

    im_cur = imread(fullfile(FRAME_DIR, sprintf('%06d.jpg', i)));
    data = load(fullfile(DET_DIR, sprintf('%06d_dets.mat', i)));
    dets_cur = data.dets;
     
    im_next = imread(fullfile(FRAME_DIR, sprintf('%06d.jpg', i+1)));
    data = load(fullfile(DET_DIR, sprintf('%06d_dets.mat', i+1)));
    dets_next = data.dets;
    
    % sim has as many rows as dets_cur and as many columns as dets_next
    % sim(k,t) is similarity between detection k in frame i, and detection
    % t in frame j
    % sim(k,t)=0 means that k and t should probably not be the same track
    sim = compute_similarity(dets_cur, dets_next, im_cur, im_next);
    
    
    
    
    if i == start_frame
       track = zeros(size(dets_cur,1),size(dets_cur,2),end_frame-start_frame);
       track(:,:,1) = dets_cur;
       
       
       for idx = 1:size(sim,1)
            [value,index] = max(sim(idx,:));
            track_id = [track_id index];
            track(idx,:,2) = dets_next(index,:);
       end
       
       %plot first frame
       figure;axis ij; hold on
       imagesc(im_cur);
       for box = 1:size(track_id,2)
           showboxes(im_cur,track(box,:,i - start_frame + 1),color_bar(1,box));
       end
       hold off;
       
    else
       temp_track_id = [];
       for idx = 1:size(track_id,2)
            [value,index] = max(sim(track_id(size(track_id,1),idx),:));
            temp_track_id = [temp_track_id index];
            track(idx,:,i - start_frame + 2) = dets_next(index,:);
       end
       track_id = [track_id;temp_track_id];
    end
    
    %plot second frame
    figure;axis ij; hold on
    imagesc(im_next);
    for box = 1:size(track_id,2)
        showboxes(im_next,track(box,:,i - start_frame + 2),color_bar(1,box));
    end
    hold off; 
end





