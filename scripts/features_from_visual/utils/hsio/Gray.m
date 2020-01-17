function L_data = Gray(data)
    data_size = size(data);
    
    s = 1;
    if (length(data_size) == 4)
        s = data_size(4);
    end
    
    for i=1:s
        L_image = rgb2gray(data(:,:,:,i));
        L_data(:,:,i) = downN(L_image,10);        
    end   
end