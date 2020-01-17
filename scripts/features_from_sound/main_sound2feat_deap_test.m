%%All extension of the audio is used, not just the min
%
% Gwena Cunha
%

clear all
clc

%% Audio filename
% Choose the files to extract the features from

% Test dataset
file_name_raw_pos = {};
movie_id = {};
for i=1:10
    movie_id{end+1} = i;
    file_name_raw_pos{end+1} = strcat(['dataset/deap dataset/test dataset/', num2str(i), '.mp4']);
end

file_name_raw_pos

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
%plot(raw_data{1});
%soundsc(raw_data{2},44100);

%% Get audio features: 3D Tensor data
size_sound_feats = 10; %default = 600
save_root = 'saved_mats/deap/features_from_sound/test/';
% save_root = 'saved_mats/deap/features_from_sound/test_individual/';
save_to_filename = strcat([save_root, 'sound_features_dataset2_deap_test_size', num2str(size_sound_feats), '_v7_raw']);

size_sound_feats_10 = size_sound_feats/10;
total_sound = zeros(30,size_sound_feats_10,s_files);
sound_3D = zeros(30,size_sound_feats_10,s_files);
sound_feat = [];
%feats_per_song = [225, 200, 210]; %225 because if I choose 230 there's an error with 
feat_size = 10;
feats_per_song = feat_size*ones(1,s_files); %[100, 200, 225, 200, 180, 200, 200, 200];%, 210];
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
save(save_to_filename, 'sound_feat', 'sound_3D', 'song_data', 'feats_per_song', 'movie_id', '-v7.3');
