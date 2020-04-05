%%Main file to obtain visual features from scene in DEAP Test
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
for i=1:10
    movie_id{end+1} = i;
    file_name_raw_pos{end+1} = strcat(['dataset/deap dataset/test dataset/', num2str(i), '.mp4']);
end

%% Save and load videos
n = 10;  % 10  % 240;
is_save = false;
is_load = true;
save_root = 'saved_mats/deap/features_from_visual/test/';
mkdir(save_root);

%%Save videos
if is_save == true
    disp('Save videos');
vid_arr = {};
    for i=1:10
        i
        vid = get_video_components_totalVideo(file_name_raw_pos{i}, n);
        vid_arr{end+1} = vid;
        save(strcat([save_root, 'videos_dataset_deap_test_vid', num2str(i), '_', num2str(n), '.mat']), 'vid');
        clear vid;
    end
end

%%Load videos
if is_load == true
    disp('Load videos');
    vid_arr = {};
    for i=1:10
        data_name = strcat([save_root, 'videos_dataset_deap_test_vid', num2str(i), '_', num2str(n), '.mat']);
        load(data_name, 'vid');
        vid_arr{end+1} = vid;
    end

    for i=1:10
        %load videos video_final1;
        i
        [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid_arr{i},G2,H_data2,S_data2,L_data2,O_data2,i);
    end

    save(strcat([save_root, 'HSLO_data_dataset_deap_test_', num2str(n), '.mat']), 'H_data2', 'S_data2', 'L_data2', 'O_data2', 'movie_id');
end

%% Obtain features from 'mat' - FCM
clc
n_videos = 10;
data_to_load_filename = strcat([save_root, 'HSLO_data_dataset_deap_test_', num2str(n), '.mat']);
save_feature_filename = {strcat([save_root, 'feature_dataset_deap_test_', num2str(n), '_v7']),...
                         strcat([save_root, 'number_of_sort_dataset_deap_test_', num2str(n), '_v7'])};
Feature_train = mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'deap', movie_id);
