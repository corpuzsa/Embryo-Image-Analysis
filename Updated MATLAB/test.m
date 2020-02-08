for i=1:numVideos
    key = rank(p, 2);
    j = i - 1;
    
    while(j>=0 && rank(j, 2) > key)
        rank(j+1, 2) = rank(j, 2);
        j = j - 1;
    end
    rank(j+1, 2) = key;
end