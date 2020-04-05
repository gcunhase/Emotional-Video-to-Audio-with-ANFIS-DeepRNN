%%Main file to obtain visual features from scene in DEAP Test for individual
%%samples
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
video_id = 10;
for i=1:video_id
    movie_id{end+1} = i;
    file_name_raw_pos{end+1} = strcat(['dataset/deap dataset/test dataset/', num2str(i), '.mp4']);
end

%% Save and load videos
n = 10;  % 10  % 240;
save_root = 'saved_mats/deap/features_from_visual/test_individual/';
mkdir(save_root);

for i=1:video_id
    i
    vid = get_video_components_totalVideo(file_name_raw_pos{1}, n);
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid,G2,H_data2,S_data2,L_data2,O_data2,1);

    save(strcat([save_root, 'HSLO_data_dataset_deap_test_', num2str(n), '_video', num2str(i), '.mat']), 'H_data2', 'S_data2', 'L_data2', 'O_data2', 'movie_id');
end

%% Obtain features from 'mat' - FCM
clc

n_videos = 1;  % 1 because we want the features from each video individually
for i=1:video_id
    data_to_load_filename = strcat([save_root, 'HSLO_data_dataset_deap_test_', num2str(n), '_video', num2str(i), '.mat']);
    save_feature_filename = {strcat([save_root, 'feature_dataset_deap_test_', num2str(n), '_video', num2str(i), '_v7']),...
                             strcat([save_root, 'number_of_sort_dataset_deap_test_', num2str(n), '_video', num2str(i), '_v7'])};
    mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'deap', i);
end
