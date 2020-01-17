function [s_data] = S_trans(data)   
    a=1;
    temp = [];
    
    s = size(data,3);
    for i=1:s
        if mod(i,3) == 0
            temp(:,:,a) = data(:,:,i);
            a=a+1;
        end
    end
    
    if (s ~= 1 && s ~= 7)% && s ~= 6)
        s = 236;
    end
    temp = reshape(data(:,:,1:s),[100 s]);
    s_data = reshape(temp,[100*s 1]);    
end