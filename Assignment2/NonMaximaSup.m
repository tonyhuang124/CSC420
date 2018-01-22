function [y,x] = NonMaximaSup(cornerness, radius, threshold)
    sharp = strel('disk', radius).Neighborhood;
    last_idx = 0;
    [width, height] = size(sharp);
    for i = 1:width
        for j = 1:height
            if sharp(i,j) == 1
                last_idx = last_idx + 1;
            end
        end
    end
    n = ordfilt2(cornerness, last_idx, sharp);
    nmax = 0;
    [width, height] = size(n);
    for i = 1:width
        for j = 1:height
            if n(i,j) > nmax
                nmax = n(i,j);
            end
            if cornerness(i,j) ~= n(i,j)
                cornerness(i,j) = 0;
            end
        end
    end
    t = threshold*nmax;
    [y,x] = find(cornerness >= t);

end