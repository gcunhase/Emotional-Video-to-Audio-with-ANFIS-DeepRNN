%%All extension of the audio is used, not just the min
%
% Extracts audio features from COGNIMUSE dataset (TRAIN and TEST)
%   Train: BMI, CHI, FNE, GLA, LOR
%   Test: CRA, DEP
%
% Gwena Cunha
%

clear all
clc

%% Audio filename
% Choose the files to extract the features from
root_dir='dataset/cognimuse dataset/';
list_of_clip_names = {'BMI', 'CHI', 'FNE', 'GLA', 'LOR', 'CRA', 'DEP'};
list_of_clip_size = [];  % 625   602   605   600   750
% Get numbers of videos in each clip
for l=list_of_clip_names
    clip_name = l{1};
    files = dir(strcat([root_dir, clip_name, '/audio_splices_3secs/*.wav']));
    list_of_clip_size = [list_of_clip_size, length(files)];
end

%% Make struct with clip data
clip_struct_all = [];

for l=1:length(list_of_clip_size)
    clip_struct = struct();
    clip_struct.name = list_of_clip_names{l};
    clip_struct.size = list_of_clip_size(l);
    file_name_raw_pos = {};
    movie_id = {};
    for i=0:clip_struct.size-1
        movie_id{end+1} = i;
        file_name_raw_pos{end+1} = strcat(['dataset/cognimuse dataset/', clip_struct.name, '/audio_splices_3secs/', num2str(i), '.wav']);
    end
    clip_struct.movie_id = movie_id;
    clip_struct.file_names = file_name_raw_pos;
    clip_struct_all = [clip_struct_all, clip_struct];
end

% Check clip_struct_all
%for l=1:length(clip_struct_all)
%    clip_struct_all(l).name
%end

%% Audio from filename
% Get audio from filenames
clip_struct_all_expanded = [];
for l=1:length(clip_struct_all)
    clip_struct = clip_struct_all(l);
    clip_name = clip_struct.name;
    clip_size = clip_struct.size;
    movie_id = clip_struct.movie_id;
    file_name_raw_pos = clip_struct.file_names;
    
    s = [];
    for j=1:clip_size
        %file_name_raw_pos{j}
        raw_data_tmp = audioread(file_name_raw_pos{j});
        s = [s, size(raw_data_tmp(:,1), 1)];
    end
    
    raw_data = [];
    for j=1:clip_size
        raw_data_tmp = audioread(file_name_raw_pos{j});
        raw_data = [raw_data, {raw_data_tmp(:,1)}];
    end
    clip_struct.raw_data = raw_data;
    clip_struct_all_expanded = [clip_struct_all_expanded, clip_struct];
end

% Check clip_struct_all
%for l=1:length(clip_struct_all_expanded)
%    clip_struct_all_expanded(l).name
%end

%% Get audio features: 3D Tensor data
% Saves in individual files: BMI, CHI, ...
size_sound_feats = 10; %default = 600

for l=1:length(clip_struct_all_expanded)
    clip_struct = clip_struct_all_expanded(l);
    clip_name = clip_struct.name
    clip_size = clip_struct.size;
    movie_id = clip_struct.movie_id;
    raw_data = clip_struct.raw_data;
    
    save_root = 'saved_mats/cognimuse/features_from_sound/train/';
    if strcmp(clip_name, 'CRA') || strcmp(clip_name, 'DEP')  % test
        save_root = 'saved_mats/cognimuse/features_from_sound/test/';
    end
    mkdir( save_root);
    
    save_to_filename = strcat([save_root, 'sound_features_dataset2_cognimuse_', clip_name, '_size', num2str(size_sound_feats), '_v7_raw']);

    size_sound_feats_10 = size_sound_feats/10;
    total_sound = zeros(30,size_sound_feats_10,clip_size);
    sound_3D = zeros(30,size_sound_feats_10,clip_size);
    sound_feat = [];
    %feats_per_song = [225, 200, 210]; %225 because if I choose 230 there's an error with 
    feats_per_song = 3*ones(1,clip_size); %50*ones(1,clip_size); %[100, 200, 225, 200, 180, 200, 200, 200];%, 210];
    song_data = [];
    for j=1:clip_size
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

    %%Save mat
    %save sound_features_dataset2_size10 sound_feat sound_3D
    %sound_feat -> 8x1 cells, each cell 10x3 features
    save(save_to_filename, 'sound_feat', 'sound_3D', 'song_data', 'feats_per_song', 'movie_id', '-v7.3');
end