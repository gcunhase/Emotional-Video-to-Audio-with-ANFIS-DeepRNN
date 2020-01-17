function data_set = trans_data(data)
    a=1;
    temp = data;
    
    if (size(temp,3) ~= 1 && size(temp,3) ~= 7) % && size(temp,3) ~= 6)
        for n=1:230
            temp_data = temp(:,:,n:n+6);
            te = reshape(temp_data,[100 7]);
            data_set(:,n) = reshape(te,[700 1]);
        end
    else
        n = size(temp,3);
        temp_data = [];
        if (n == 1)
            temp_data = zeros(size(temp, 1), size(temp, 2), 7);
            for i=1:7
                temp_data(:,:,i) = temp(:,:);
            end
        else
            temp_data = temp(:,:,1:n);
        end
        %temp_data = temp(:,:,n:n+6);
        te = reshape(temp_data,[100 7]);
        data_set(:,n) = reshape(te,[700 1]);
    end
    
end
