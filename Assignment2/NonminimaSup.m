function [r,c] = NonminimaSup(cornerness, radius, threshold)
    sharp = strel('disk', radius).Neighborhood;

    n = ordfilt2(cornerness, 1, sharp);
    nmax = 0;
    [width, height] = size(n);
    for i = 1:width
        for j = 1:height
            if n(i,j) < nmax
                nmax = n(i,j);
            end
            if cornerness(i,j) ~= n(i,j)
                cornerness(i,j) = 0;
            end
        end
    end
    t = threshold*nmax;
    [r,c] = find(cornerness <= t);

end