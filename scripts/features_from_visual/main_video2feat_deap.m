%%Main file to obtain visual features from scene in DEAP
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

%% Get data filenames
file_name_raw_pos = {};
movie_id = {};
for i=1:40
    if i ~= 17 && i ~= 18
        movie_id{end+1} = i;
        file_name_raw_pos{end+1} = strcat(['dataset/deap dataset/mp4/', num2str(i), '.mp4']);
    end
end

%% Save and load videos
n = 125;  % 500 used for Lindsey Dataset, where each video is between 3 and 4 minutes
is_save = false;
is_load = true;
save_root = 'saved_mats/deap/features_from_visual/train/';
mkdir(save_root);

%%Save videos
if is_save == true
    disp('Save videos');
    vid_arr = {};
    for i=1:16
        i
        vid = get_video_components_totalVideo(file_name_raw_pos{i}, n);
        vid_arr{end+1} = vid;
        save(strcat([save_root, 'videos_dataset_deap_vid', num2str(i), '_', num2str(n), '.mat']), 'vid');
        clear vid;
    end
    for i=19:40
        i
        vid = get_video_components_totalVideo(file_name_raw_pos{i-2}, n);
        vid_arr{end+1} = vid;
        save(strcat([save_root, 'videos_dataset_deap_vid', num2str(i), '_', num2str(n), '.mat']), 'vid');
        clear vid;
    end
end

%%Load videos
if is_load == true
    disp('Load videos');
    vid_arr = {};
    for i=1:40
        if i ~= 17 && i ~= 18
            load(strcat([save_root, 'videos_dataset_deap_vid', num2str(i), '_', num2str(n), '.mat']), 'vid');
            vid_arr{end+1} = vid;
        end
    end
    
    for i=1:38
        %load videos video_final1;
        i
        [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid_arr{i},G2,H_data2,S_data2,L_data2,O_data2,i);
        % [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid_arr{i},G2,H_data2,S_data2,L_data2,O_data2,i);
    end
    save(strcat([save_root, 'HSLO_data_dataset_deap_', num2str(n), '.mat']), 'H_data2', 'S_data2', 'L_data2', 'O_data2', 'movie_id');
end

%% Obtain features from 'mat' - FCM

n_videos = 38;
data_to_load_filename = strcat([save_root, 'HSLO_data_dataset_deap_', num2str(n), '.mat']);
save_feature_filename = {strcat([save_root, 'feature_dataset_deap_', num2str(n), '_v7']),...
                         strcat([save_root, 'number_of_sort_dataset_deap_', num2str(n), '_v7'])};
Feature_train = mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'deap', movie_id);
