function data_set = trans_data(data)
    a=1;
    temp = data;
    %%Begin of Gwena's modification (uncomment this)
    %temp = [];
    %for n=1:size(data,3)
    %    if mod(n,3) == 0
    %        temp(:,:,a) = data(:,:,n);
    %        a=a+1;
    %    end
    %end
    %%End of Gwena's modification (uncomment this)
    
    %%Begin of Gwena's modification (comment this)
    %temp = reshape(data(:,:,1:236),[100 236]);
    %h_data = reshape(temp,[100*236 1]); 
    %%End of Gwena's modification (comment this)
    
    %%----Begin: Gwena's modification-----
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
    
    %%----End: Gwena's modification-----
     
%     for n=1:700
%         temp_data = data(:,:,n:n+4);       
%         temp(1:100,:,n) = reshape(temp_data, [100 5]);       
%         data_set(:,n) = reshape(temp(:,:,n),[500 1]);        
%     end   
end
