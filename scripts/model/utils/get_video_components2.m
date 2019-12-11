%VideoReader: http://kr.mathworks.com/help/matlab/ref/videoreader.read.html

function [ video_final ] = get_video_components2(file, nFrames)

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

    %Read one frame at a time.
    for k = 1 : nFrames
        %mov(k).cdata = read(video_obj,k);
        img = im2double(read(video_obj,k));
        %imshow(img);
        pause;
        video_final(:,:,:,k) = imresize(img,resize_size);
        %imshow(video_final(:,:,:,k));
        pause;
    end

    %Resize image
    %http://www.mathworks.com/help/images/ref/imresize.html
    % I = im2double(imread('rice.png'));
    % J = imresize(I, 0.5);
    %%J = imresize(I, [100 150]);
    % figure
    % imshow(I)
    % title('Original')
    % figure
    % imshow(J)
    % title('Resized Image')
end

