%VideoReader: http://kr.mathworks.com/help/matlab/ref/videoreader.read.html

function [ video_final ] = get_video_components_totalVideo(file, nFrames)

    %file_root = file(1:end-4);
    %file1 = strcat([file_root, '_video.avi']);
    %file2 = strcat([file_root, '_audio.wav']); %audio_final

    video_obj = VideoReader(file);

    if (nargin == 1)
        nFrames = video_obj.NumberOfFrames;
        %numFrames = get(video_obj, 'NumberOfFrames');
    end
    vidHeight = video_obj.Height;
    vidWidth = video_obj.Width;

    %Preallocate the movie structure.
    %mov(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'), 'colormap',[]);
    s = [size(read(video_obj,1)), nFrames];
    resize_size = [256 256];
    video_final = zeros([resize_size, s(3:4)]);

    nFrames_total = video_obj.NumberOfFrames;
    step_size = floor(nFrames_total/nFrames);
    %Read one frame at a time.
    cont = 1;
    for k = 1 : step_size : nFrames_total
        %mov(k).cdata = read(video_obj,k);
        %img = read(video_obj,k);
        img = im2double(read(video_obj,k));
        video_final(:,:,:,cont) = imresize(img,resize_size);
        cont = cont + 1;
    end
    
end

