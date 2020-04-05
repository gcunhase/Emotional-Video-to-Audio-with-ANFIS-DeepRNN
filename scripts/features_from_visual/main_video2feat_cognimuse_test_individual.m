%%Main file to obtain visual features from scene in COGNIMUSE
%
% Gwena Cunha
%

clc; clear all;

H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);

H_data2{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];

% Create Gabor filter
imageSize = 256;
orientationsPerScale = [4 4 4];
G2 = createGabor(orientationsPerScale, imageSize);

%% Get data filename and struct info
root_dir='dataset/cognimuse dataset/test_individual/';
list_of_clip_names = {'CRA', 'DEP'}
list_of_clip_size = [];  % 625   602   605   600   750
% Get numbers of videos in each clip
for l=list_of_clip_names
    clip_name = l{1}
    files = dir(strcat([root_dir, clip_name, '/video_splices_3secs/*.mp4']));
    list_of_clip_size = [list_of_clip_size, length(files)];
end
list_of_clip_size

% Make struct with clip data
clip_struct_all = [];
for l=1:length(list_of_clip_size)
    clip_struct = struct();
    clip_struct.name = list_of_clip_names{l};
    clip_struct.size = list_of_clip_size(l);
    file_name_raw_pos = {};
    movie_id = {};
    for i=0:clip_struct.size-1
        movie_id{end+1} = i;
        file_name_raw_pos{end+1} = strcat(['dataset/cognimuse dataset/test_individual/', clip_struct.name, '/video_splices_3secs/', num2str(i), '.mp4']);
    end
    clip_struct.movie_id = movie_id;
    clip_struct.file_names = file_name_raw_pos;
    clip_struct_all = [clip_struct_all, clip_struct];
end

% Check clip_struct_all
for l=1:length(clip_struct_all)
    clip_struct_all(l).name
end

%% Save and load videos
%n = 125;  % DEAP. 500 used for Lindsey Dataset, where each video is between 3 and 4 minutes
total_frames = 90;  % 3 seconds of video at 30fps
n = total_frames/9;
is_save = true;
is_load = true;
save_root = 'saved_mats/cognimuse/features_from_visual/test_individual/';
mkdir(save_root);

%%%% Save videos %%%%
if is_save == true
    disp('Save videos');
    clip_struct_all_expanded = [];
    for l=1:length(clip_struct_all)
       clip_struct = clip_struct_all(l);
       clip_name = clip_struct.name
       clip_size = clip_struct.size
       movie_id = clip_struct.movie_id;
       file_name_raw_pos = clip_struct.file_names;

       save_path = strcat([save_root, clip_name, '/']);
       mkdir(save_path);

       vid_arr = {};
       for i=1:clip_size
           vid = get_video_components_totalVideo(file_name_raw_pos{i}, n);
           vid_arr{end+1} = vid;
           save_path_mat = strcat([save_path, 'videos_dataset_cognimuse_vid', num2str(i-1), '_', num2str(n), '.mat'])
           save(save_path_mat, 'vid');
           clear vid;
       end
       clip_struct.vid_arr = vid_arr;
       clip_struct_all_expanded = [clip_struct_all_expanded, clip_struct];
    end
end

%%%% Load videos and get HSLO data %%%%
if is_load == true
    disp('Load videos');
    for l=1:length(clip_struct_all)
       clip_struct = clip_struct_all(l);
       clip_name = clip_struct.name
       clip_size = clip_struct.size;
       movie_id = clip_struct.movie_id;
       file_name_raw_pos = clip_struct.file_names;

       save_path = strcat([save_root, clip_name, '/']);

       for i=1:clip_size
           i
           % Reset HSLO and Gabor variables
           H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);
           H_data2{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
           H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];
           G2 = createGabor(orientationsPerScale, imageSize);
           % Load
           load(strcat([save_path, 'videos_dataset_cognimuse_vid', num2str(i-1), '_', num2str(n), '.mat']), 'vid');
           [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid,G2,H_data2,S_data2,L_data2,O_data2,1);
           save(strcat([save_root, 'HSLO_data_dataset_cognimuse_', clip_name, '_vid', num2str(i-1), '_', num2str(n), '.mat']), 'H_data2', 'S_data2', 'L_data2', 'O_data2', 'movie_id');
           clear vid;
       end
    end
end

%% Obtain features from 'mat' for each video individually - FCM

n_videos = 1;  % 1 because we want the features from each video individually
for l=1:length(clip_struct_all)
    clip_struct = clip_struct_all(l);
    clip_name = clip_struct.name
    clip_size = clip_struct.size
    for i=1:clip_size
        data_to_load_filename = strcat([save_root, 'HSLO_data_dataset_cognimuse_', clip_name, '_vid', num2str(i-1), '_', num2str(n), '.mat']);
        save_feature_filename = {strcat([save_root, 'feature_dataset_cognimuse_', clip_name, '_vid', num2str(i-1), '_', num2str(n), '_v7']),...
                                 strcat([save_root, 'number_of_sort_dataset_cognimuse_', clip_name, '_vid', num2str(i-1), '_', num2str(n), '_v7'])};
        mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'cognimuse', clip_struct);
    end
end
