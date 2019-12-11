file_name=cell(80,1);
avg_MC=zeros(80,3);
addpath ./sound
addpath ./coversongs
for i=1:40
    s=sprintf('nega%d.wav' , i);
    file_name{i}=s;
    [tempo loudness rythm]=sound_feature(file_name{i});
    D_sound=[tempo(:,1) loudness rythm];    
    avg_MC(i,:)=mean(D_sound);
end

for i=1:40
    s=sprintf('po%d.wav' , i);
    file_name{40+i}=s;
    [tempo loudness rythm]=sound_feature(file_name{40+i});
    D_sound=[tempo(:,1) loudness rythm];    
    avg_MC(40+i,:)=mean(D_sound);
end

% %% 3D Tensor data
