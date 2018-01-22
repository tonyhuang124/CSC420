%% Q2d
% DESCRIPTIVE TEXT
data = getData([], 'test','list');
ids = data.ids(1:3);

for i = 1:3
    %get image
    imdata = getData(ids{i}, 'test', 'left');
    im = imdata.im;
    
    %get car detections
    car_ds = imdata.car.ds;
    %if this is first time run Q2d, we need add 3 cols for avg x,y,z
    if size(car_ds,2) < 9
        car_ds = [car_ds zeros([size(car_ds,1),3])];
    end
    person_ds = imdata.person.ds;
    if size(person_ds,2) < 9
       person_ds = [person_ds zeros([size(person_ds,1),3])]; 
    end
    cyclist_ds = imdata.cyclist.ds;
    if size(cyclist_ds,2) < 9
       cyclist_ds = [cyclist_ds zeros([size(cyclist_ds,1),3])];
    end
    
    
    
    
    %create a white image for record pixels in boundary boxs
    inbox = zeros(size(im,1),size(im,2), 3, 'uint8');
    car_bs = imdata.car.bs;
    person_bs = imdata.person.bs;
    cyclist_bs = imdata.cyclist.bs;
    
    
    
    calib = getData(ids{i}, 'test', 'calib');
    disp = getData(ids{i}, 'test', 'disp');
    disparity = disp.disparity;
    f = calib.f;
    numerator = f*calib.baseline;
    depth = numerator./disparity;
    pleft = calib.P_left;
    [K, R, t]= KRt_from_P(pleft);
    Px = K(1,3);
    Py = K(2,3);
    
    
    
    for car = 1:size(car_ds,1)
        num = 0;
        avg_world_x = 0;
        avg_world_z = 0;
        avg_world_y = 0;
        for y = 1:size(inbox,1)
            for x = 1:size(inbox,2)
               % because t = Cw
               %compute the world coordinate for every pixel inside the
               %boundary box
                if and(and(x>car_ds(car,1),x<car_ds(car,3)),and(y>car_ds(car,2),y<car_ds(car,4)))
                    inbox(y,x,:) = im(y,x,:);
                    num = num + 1;
                    camera_Coor_Z = depth(y,x); 
                    camera_Coor_X = (camera_Coor_Z.*(x - Px))./f;
                    camera_Coor_Y = (camera_Coor_Z.*(y - Py))./f;
                    camera_Coor = [camera_Coor_X camera_Coor_Y camera_Coor_Z];
                    world_Coor = (camera_Coor - t)/R;
                    avg_world_x = avg_world_x + world_Coor(1,1);
                    avg_world_y = avg_world_y + world_Coor(1,2);
                    avg_world_z = avg_world_z + world_Coor(1,3);
                end
            end
        end
        avg_world_x = avg_world_x/num;
        avg_world_y = avg_world_y/num;
        avg_world_z = avg_world_z/num;
        car_ds(car,9) = avg_world_z;
        car_ds(car,7) = avg_world_x;
        car_ds(car,8) = avg_world_y;
    end
    ds = car_ds;
    bs = car_bs;
    save(imdata.car_name,'ds','bs');
    
    
    
    
    %same thing for person
    for person = 1:size(person_ds,1)
        num = 0;
        avg_world_x = 0;
        avg_world_z = 0;
        avg_world_y = 0;
        for y = 1:size(inbox,1)
            for x = 1:size(inbox,2)
                if and(and(x>person_ds(person,1),x<person_ds(person,3)),and(y>person_ds(person,2),y<person_ds(person,4)))
                    inbox(y,x,:) = im(y,x,:);
                    num = num + 1;
                    camera_Coor_Z = depth(y,x); 
                    camera_Coor_X = (camera_Coor_Z.*(x - Px))./f;
                    camera_Coor_Y = (camera_Coor_Z.*(y - Py))./f;
                    camera_Coor = [camera_Coor_X camera_Coor_Y camera_Coor_Z];
                    world_Coor = (camera_Coor - t)/R;
                    avg_world_x = avg_world_x + world_Coor(1,1);
                    avg_world_y = avg_world_y + world_Coor(1,2);
                    avg_world_z = avg_world_z + world_Coor(1,3);
                end
            end
        end
        avg_world_x = avg_world_x/num;
        avg_world_y = avg_world_y/num;
        avg_world_z = avg_world_z/num;
        person_ds(person,9) = avg_world_z;
        person_ds(person,7) = avg_world_x;
        person_ds(person,8) = avg_world_y;
    end
    ds = person_ds;
    bs = person_bs;
    save(imdata.person_name,'ds','bs');
    
    
    
    
    %same thing for cyclist
    for cyclist = 1:size(cyclist_ds,1)
        num = 0;
        avg_world_x = 0;
        avg_world_z = 0;
        avg_world_y = 0;
        for y = 1:size(inbox,1)
            for x = 1:size(inbox,2)
                if and(and(x>cyclist_ds(cyclist,1),x<cyclist_ds(cyclist,3)),and(y>cyclist_ds(cyclist,2),y<cyclist_ds(cyclist,4)))
                    inbox(y,x,:) = im(y,x,:);
                    num = num + 1;
                    camera_Coor_Z = depth(y,x); 
                    camera_Coor_X = (camera_Coor_Z.*(x - Px))./f;
                    camera_Coor_Y = (camera_Coor_Z.*(y - Py))./f;
                    camera_Coor = [camera_Coor_X camera_Coor_Y camera_Coor_Z];
                    world_Coor = (camera_Coor - t)/R;
                    avg_world_x = avg_world_x + world_Coor(1,1);
                    avg_world_y = avg_world_y + world_Coor(1,2);
                    avg_world_z = avg_world_z + world_Coor(1,3);
                end
            end
        end
        avg_world_x = avg_world_x/num;
        avg_world_y = avg_world_y/num;
        avg_world_z = avg_world_z/num;
        cyclist_ds(cyclist,9) = avg_world_z;
        cyclist_ds(cyclist,7) = avg_world_x;
        cyclist_ds(cyclist,8) = avg_world_y;
    end
    ds = cyclist_ds;
    bs = cyclist_bs;
    save(imdata.cyclist_name,'ds','bs'); 
    %save inbox as mat file
    inbox_name = strcat(ids{i},'_inbox');
    save(inbox_name,'inbox');
end