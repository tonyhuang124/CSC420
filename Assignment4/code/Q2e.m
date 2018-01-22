%% Q2e
% DESCRIPTIVE TEXT
data = getData([], 'test','list');
ids = data.ids(1:3);

for i = 1:3
    imdata = getData(ids{i}, 'test', 'left');
    im = imdata.im;
    
    %add three detection's ds into one ds for easier comparsion
    car_ds = imdata.car.ds;
    person_ds = imdata.person.ds;
    cyclist_ds = imdata.cyclist.ds;
    ds = [];
    if ~isempty(car_ds)
        ds =  [ds;car_ds(:,[7 8 9])];
    end
    if ~isempty(person_ds)
        ds = [ds;person_ds(:,[7 8 9])];
    end
    if ~isempty(cyclist_ds)
        ds = [ds;cyclist_ds(:,[7 8 9])];
    end
     calib = getData(ids{i}, 'test', 'calib');
     disp = getData(ids{i}, 'test', 'disp');
     disparity = disp.disparity;
     f = calib.f;
     fT = f*calib.baseline;
     depth = fT./disparity;
     pleft = calib.P_left;
     [K, R, t]= KRt_from_P(pleft);
     Px = K(1,3);
     Py = K(2,3);
    
     
    % inbox store all the pixel inside boundary box
    inbox = imdata.inbox.inbox;
    if inbox == 0
        inbox = im;
    end
    
    %loop all the pixels inside boundary box
    for y = 1:size(inbox(:,:,1),1)
        for x = 1:size(inbox(:,:,1),2)
            if and(and(inbox(y,x,1) ~= 0,inbox(y,x,2) ~=0),inbox(y,x,3) ~= 0)
                    camera_Coor_Z = depth(y,x); 
                    camera_Coor_X = (camera_Coor_Z.*(x - Px))./f;
                    camera_Coor_Y = (camera_Coor_Z.*(y - Py))./f;
                    camera_Coor = [camera_Coor_X camera_Coor_Y camera_Coor_Z];
                    world_Coor = (camera_Coor - t)/R;
                    %tweak this +/- value for segementation
                     if min(pdist2(world_Coor(1,3),ds(:,3))) > 30
                         inbox(y,x,:) = 0;
                     end
            end
        end
    end

    figure;imshow(inbox);

        
end