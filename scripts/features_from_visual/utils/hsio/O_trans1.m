function O_data = O_trans1(data)
    for iter = 1:12
         a=1;
         temp = [];
         s = size(data,2);
         for i=1:s
             if mod(i,3) == 0 %Begin of Modified by GWENA (uncomment this)
                 temp(:,a) = data(:,i,iter);
                 a=a+1;
             end %End of Modified by GWENA (uncomment this)
         end
         
         %Begin of Modified by GWENA (comment this)
         temp = [];
         if (s ~= 1 && s ~= 7)% && s~= 6)
            s = 236;
         end
         temp = data(:,1:s,iter); %temp = reshape(data(:,:,1:236),[100 236]);
          %s_data = reshape(temp,[100*236 1]);       
        %End of Modified by GWENA (comment this)

        %Begin of Modified by GWENA (uncomment this)
        size_data = size(temp);
        O_data(:,iter) = reshape(temp(:,1:s),[size_data(1)*s 1]);
        %End of Modified by GWENA (uncomment this)
    end
end