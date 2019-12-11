function [h_data] = H_trans(data)
    a=1;
    temp = [];
    %%----Begin: Gwena's modification-----
    s = size(data,3);
    for i=1:s
    %%----End: Gwena's modification-----
        if mod(i,3) == 0
            temp(:,:,a) = data(:,:,i);
            a=a+1;
        end
    end     
    %%----Begin: Gwena's modification-----
    if (s ~= 1 && s ~= 7)% && s ~= 6)
        s = 236;
    end
    temp = reshape(data(:,:,1:s),[100 s]);
    h_data = reshape(temp,[100*s 1]); 
    %%----End: Gwena's modification-----
end
