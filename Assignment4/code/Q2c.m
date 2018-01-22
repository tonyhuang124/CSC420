%% Q2c
% 
data = getData([], 'test','list');
ids = data.ids(1:3);
car_model = getData([], [], 'detector-car');
car_model = car_model.model;
person_model = getData([], [], 'detector-person');
person_model = person_model.model;
cyclist_model = getData([], [], 'detector-cyclist');
cyclist_model = cyclist_model.model;
for i = 1:3
    imdata = getData(ids{i}, 'test', 'left');
    im = imdata.im;
    car_ds = imdata.car.ds;
    person_ds = imdata.person.ds;
    cyclist_ds = imdata.cyclist.ds;
    car_bs = imdata.car.bs;
    person_bs = imdata.person.bs;
    cyclist_bs = imdata.cyclist.bs;
    figure;axis ij; hold on
    imagesc(im);
    if ~isempty(car_ds)
        showboxesMy(im, reduceboxes(car_model, car_bs), 'red');
        text(car_ds(:,1)+1, car_ds(:,2)+8,'car','Color','red','FontSize',18);
    end
    
   if ~isempty(person_ds)
        showboxesMy(im, reduceboxes(person_model, person_bs), 'blue');
        text(person_ds(:,1)+1, person_ds(:,2)+8,'person','Color','blue','FontSize',18);
   end
   if ~isempty(cyclist_ds)
        showboxesMy(im, reduceboxes(cyclist_model, cyclist_bs), 'cyan');
        text(cyclist_ds(:,1)+1, cyclist_ds(:,2)+8,'cyclist','Color','cyan','FontSize',18);
   end
   hold off;
    
end