function data_set = trans_O_data (data)

%     for i=1:12
%         a=1;
%         temp = [];
%         for n = 1:size(data,2)
%             if mod(i,3) == 0
%                 temp(:,a,i) = data(:,n,i);
%                 a=a+1;
%             end
%         end
%     
%         %Begin of Modified by GWENA (comment this)
%         temp = data(:,1:236,i); %temp = reshape(data(:,:,1:236),[100 236]);
%         size_data = size(temp);
%         O_data(:,i) = reshape(temp(:,1:236),[size_data(1)*236 1]);
%         %End of Modified by GWENA (comment this)
% 
%     end
% 
%     for n = 1:230
%         temp_data = temp(:,n:n+6,:);
%         data_set(:,:,n) = reshape(temp_data,[16*7 12]);
%     end


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


%This was commented originally
%     for n=1:700
%         temp_data = data(:,n:n+4,:);       
%         data_set(:,:,n) = reshape(temp_data,[16*5 12]);        
%     end 
end