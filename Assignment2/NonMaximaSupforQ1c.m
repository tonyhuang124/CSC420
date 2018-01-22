function [r,c] = NonMaximaSupforQ1c(cornerness, radius, threshold)
    sharp = strel('disk', radius).Neighborhood;

    n = ordfilt2(cornerness, 1, sharp);
    nmax = 0;
    [width, height] = size(n);
    for i = 1:width
        for j = 1:height
            if abs(n(i,j)) > nmax
                nmax = abs(n(i,j));
            end
            if cornerness(i,j) ~= n(i,j)
                cornerness(i,j) = 0;
            end
        end
    end
    t = threshold*nmax;
    [r,c] = find(abs(cornerness) >= t);

end