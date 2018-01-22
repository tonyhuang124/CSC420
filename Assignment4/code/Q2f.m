%% Q2f
% 
data = getData([], 'test','list');
ids = data.ids(1:3);

for i = 1:3
   fprintf('In %s:\n',ids{i});
   imdata = getData(ids{i}, 'test', 'left');
   car_ds = imdata.car.ds;
   person_ds = imdata.person.ds;
   cyclist_ds = imdata.cyclist.ds;
   if ~isempty(car_ds)
       for car_idx = 1:size(car_ds,1)
           fprintf('There is a car ');
           if car_ds(car_idx,7) < 0
                fprintf('to you left ');
           else
               fprintf('to you right ');
           end
           distance = norm(car_ds(car_idx,[7 8 9]));
           fprintf('with distances %d\n',distance);
       end
       
   end
   if ~isempty(person_ds)
       for person_idx = 1:size(person_ds,1)
           fprintf('There is a car ');
           if person_ds(person_idx,7) < 0
                fprintf('to you left ');
           else
               fprintf('to you right ');
           end
           distance = norm(person_ds(person_idx,[7 8 9]));
           fprintf('with distances %d\n',distance);
       end        
   end
   if ~isempty(cyclist_ds)
       for cyclist_idx = 1:size(cyclist_ds,1)
           fprintf('There is a car ');
           if cyclist_ds(cyclist_idx,7) < 0
                fprintf('to you left ');
           else
               fprintf('to you right ');
           end
           distance = norm(cyclist_ds(cyclist_idx,[7 8 9]));
           fprintf('with distances %d\n',distance);
       end
   end
 end