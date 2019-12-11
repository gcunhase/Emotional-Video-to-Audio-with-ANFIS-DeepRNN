%% Using audioread -> THIS ONE

file = '../Emotion Datasets - Sep 15/Media/mp4/1. Baby.mp4';
sound_final1 = get_sound_component( file );

file = '../Emotion Datasets - Sep 15/Media/mp4/2. Do re mi.mp4';
sound_final2 = get_sound_component( file );

file = '../Emotion Datasets - Sep 15/Media/mp4/3. Neutral1.mp4';
sound_final3 = get_sound_component( file );

file = '../Emotion Datasets - Sep 15/Media/mp4/4. Neutral2.mp4';
sound_final4 = get_sound_component( file );

file = '../Emotion Datasets - Sep 15/Media/mp4/5. Pig.mp4';
sound_final5 = get_sound_component( file );

file = '../Emotion Datasets - Sep 15/Media/mp4/6. Amazon.mp4';
sound_final6 = get_sound_component( file );


%% to get video alone from the file 

%%-----Beginning of GWENA'S MODIFICATION
file = '../Emotion Datasets - Sep 15/Media/avi/1. Baby.avi';
file_root = file(1:end-4);
file1 = strcat([file_root, '_video.avi']);
file2 = strcat([file_root, '_audio.wav']);

videoFReader = vision.VideoFileReader(file,'AudioOutputPort',true, 'AudioOutputDataType', 'int16'); 
video_final = vision.VideoFileWriter(file1,'FrameRate',videoFReader.info.VideoFrameRate);
%audio_final = vision.VideoFileWriter(file2,'AudioInputPort',true);

audio_final = [];
i = 0;
%while ~isDone(videoFReader)
for j=1:300
  %videoFrame = step(videoFReader);
  %step(videoPlayer, videoFrame);
  [videoFrame,audioFrame] = step(videoFReader);
  step(video_final, videoFrame);
  %step(audio_final, videoFrame);
  i = i+1;
  audio_final = [audio_final, audioFrame];
end

disp('end');
fileinfo = aviinfo(file);
fs =  %videoFReader.info.VideoFrameRate*i;
wavwrite(audio_final, fs, file2);
release(video_final);
%release(audio_final);
release(videoFReader);

%%-----End of GWENA'S MODIFICATION

%% Old
%file='chunch.avi'; 
%file1='vipmen2.avi';
%
%hmfr = video.MultimediaFileReader(file,'AudioOutputPort',true,'VideoOutputPort',false); 
%hmfw = video.MultimediaFileWriter(file1,'AudioInputPort',true,'VideoInputPort',false); 
%
% while ~isDone(hmfr) 
%	videoFrame = step(hmfr); 
%   step(hmfw,videoFrame); 
% end 
%close(hmfw); 
%close(hmfr); 