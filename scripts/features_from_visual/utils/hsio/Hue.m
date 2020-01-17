function [H_data, S_data] = Hue(data)
    data_size = size(data);
    
    s = 1;
    if (length(data_size) == 4)
        s = data_size(4);
    end
    
    for i=1:s
        hsv_image = rgb2hsv(data(:,:,:,i));
        Hue_data = hsv_image(:,:,1);
        Satu_data = hsv_image(:,:,2);
        H_data(:,:,i) = downN(Hue_data,10); 
        S_data(:,:,i) = downN(Satu_data,10);
    end   
end

