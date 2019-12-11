function g = Orientation(src_data,G)
    % Parameters
    Nblocks = 4;
    imageSize = 256;
    orientationsPerScale = [4 4 4];
    numberBlocks = 4;
    %W = numberBlocks*numberBlocks;
    W = Nblocks*Nblocks;
    
    % Data set
    data_size = size(src_data);
    %%----Begin: Gwena's modification-----
    s = 1;
    if (length(data_size) == 4)
        s = data_size(4);
    end
    
    for i=1:s
    %%----End: Gwena's modification-----
        O_data(:,:,i) = rgb2gray(src_data(:,:,:,i));
    end
    
    % precompute filter
    %G = createGabor(orientationsPerScale, imageSize);
    
    % output energies
    for i=1:s
        output(:,:,i) = prefilt(double(O_data(:,:,i)),4);
        g_1(:,i) = gistGabor(output(:,:,i),Nblocks,G);
        %g_1(:,i) = gistGabor1(output(:,:,i),Nblocks,G);
        for j=1:4
            g(1:W,i,(j-1)*3+1) = g_1(1+(j-1)*W:j*W,i);
            g(1:W,i,(j-1)*3+2) = g_1(W*Nblocks+1+(j-1)*W:W*Nblocks+j*W,i);
            g(1:W,i,(j-1)*3+3) = g_1(W*Nblocks*2+1+(j-1)*W:W*Nblocks*2+j*W,i);
        end
    end     
end