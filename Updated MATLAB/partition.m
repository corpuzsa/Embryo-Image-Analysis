function out = partition(arr, low, high)
    pivot = arr(high);
    i = low - 1;
    
    for j=low:(high-1)
        if(arr(j) < pivot)
            i = i + 1;
            swap(arr(i), arr(j));
        end
    end
    swap(arr(i+1), arr(high));
    out = i + 1;
end