%Gwena Cunha
% All extension of the audio is used, not just the min
% Jan 9th 2016

clear all
clc
%addpath ../Emotion Datasets - Sep 15/Media/audio

%% Audio filename
% Choose the files to extract the features from

file1 = 'dataset/lindsey stirling dataset/video/Beyond The Veil - Lindsey Stirling (Original Song).mp4';
file2 = 'dataset/lindsey stirling dataset/video/Crystallize - Lindsey Stirling (Dubstep Violin Original Song).mp4';
file3 = 'dataset/lindsey stirling dataset/video/Elements - Lindsey Stirling (Dubstep Violin Original Song).mp4';
file4 = 'dataset/lindsey stirling dataset/video/Lindsey Stirling - Take Flight [Official Music Video - YTMAs].mp4';
file5 = 'dataset/lindsey stirling dataset/video/Lord of the Rings Medley - Lindsey Stirling.mp4';
file6 = 'dataset/lindsey stirling dataset/video/Moon Trance - Lindsey Stirling (Original Song).mp4';
file7 = 'dataset/lindsey stirling dataset/video/Phantom of the Opera - Lindsey Stirling.mp4';
file8 = 'dataset/lindsey stirling dataset/video/Roundtable Rival - Lindsey Stirling.mp4';
%file9 = '../lindsey stirling dataset/video/Shadows - Lindsey Stirling (Original Song).mp4';

file_name_raw_pos = {file1, file2, file3, file4, file5, file6, file7, file8};%, file9};

%% Audio from filename
% Get audio from filenames above

s = [];
s_files = size(file_name_raw_pos,2);
for j=1:s_files
    raw_data_tmp = audioread(file_name_raw_pos{j});
    s = [s, size(raw_data_tmp(:,1), 1)];
end
min_val = min(s);

raw_data = [];
for j=1:s_files
    raw_data_tmp = audioread(file_name_raw_pos{j});
    raw_data = [raw_data, {raw_data_tmp(:,1)}];
end
plot(raw_data{1});
%soundsc(raw_data{2},44100);

%% Get audio features: 3D Tensor data
size_sound_feats = 10; %default = 600
save_root = 'saved_mats/lindsey/features_from_sound/';
save_to_filename = strcat([save_root, 'sound_features_dataset2_lindsey_size', num2str(size_sound_feats), '_v7_raw']);

size_sound_feats_10 = size_sound_feats/10;
total_sound = zeros(30,size_sound_feats_10,s_files);
sound_3D = zeros(30,size_sound_feats_10,s_files);
sound_feat = [];
%feats_per_song = [225, 200, 210]; %225 because if I choose 230 there's an error with 
feats_per_song = [200, 200, 225, 200, 180, 200, 200, 200];%, 210];
%feats_size = min_val/100;
song_data = [];
for j=1:s_files
    sound_feat_tmp = [];
    song_data_tmp = [];
    %feats_per_song = round(size(raw_data{j},1)/feats_size);
    val = size(raw_data{j},1);
	for i=1:feats_per_song(j)
        song = raw_data{j}((i-1)*val/feats_per_song(j)+1:i*val/feats_per_song(j));
        
        %tempo = [t(1),t(2), ratio of t(1) and t(2)]
        [tempo, loudness, rhythm] = sound_feature_gwena_withFeats(song, size_sound_feats);
        % %% 3D Tensor data
        D_sound=[tempo(:,1) loudness rhythm];
        tensor_sound=zeros(10,3,size_sound_feats_10);

        for k=1:size_sound_feats_10
            tensor_sound(:,:,k)=D_sound(10*(k-1)+1:10*(k-1)+10,:);
        end

        for k=1:size_sound_feats_10
            sound_3D(:,k,j,i)=[tensor_sound(:,1,k);tensor_sound(:,2,k);tensor_sound(:,3,k)];
        end

        %total_sound(:,:,j)=reshape(sound_3D,30*60,j);
        sound_feat_tmp = [sound_feat_tmp, {D_sound}];
        song_data_tmp = [song_data_tmp, song];
    end
    sound_feat = [sound_feat; {sound_feat_tmp}];
    song_data = [song_data; {song_data_tmp}];
end

%% Save mat
%save sound_features_dataset2_size10 sound_feat sound_3D
%sound_feat -> 8x1 cells, each cell 10x3 features
save(save_to_filename, 'sound_feat', 'sound_3D', 'song_data', 'feats_per_song', '-v7.3');
