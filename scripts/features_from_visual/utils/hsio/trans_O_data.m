function data_set = trans_O_data (data)

    temp = data;%(:,1:236,:);
	if (size(temp,2) ~= 1 && size(temp,2) ~= 7)% && size(temp,2) ~= 6)
        for n = 1:230
            temp_data = temp(:,n:n+6,:);
            data_set(:,:,n) = reshape(temp_data,[16*7 12]);
        end
    else
        n = size(temp,2);
        temp_data = [];
        if (n == 1)
            temp_data = zeros(size(temp, 1), 7, size(temp, 3));
            for i=1:7
                temp_data(:,i,:) = temp(:,:,:);
            end
        else
            temp_data = temp(:,1:n,:);
        end
        data_set(:,:,n) = reshape(temp_data,[16*7 12]);
    end

end