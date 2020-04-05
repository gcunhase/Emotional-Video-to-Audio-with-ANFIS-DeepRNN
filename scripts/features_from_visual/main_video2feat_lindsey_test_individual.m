%%Main file to obtain visual features from scene in Lindsey for individual
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

%% Save and load videos
n = 8; %(256, 256, 3, 6)
save_root = 'saved_mats/lindsey/features_from_visual_debug/test_individual/';
mkdir(save_root);

% NOTE: This section assumes that the '.mat' data for each video has 
%   already been obtained with the test script

%%Load videos
movie_id = {1, 2, 3, 4, 5, 6, 7, 8};
load_root_test = 'saved_mats/lindsey/features_from_visual_debug/test/';

load(strcat([load_root_test, 'videos_dataset2_testVideoAll_lindsey_vids_', num2str(n)]));
vid_arr = {vid1, vid2, vid3, vid4, vid5, vid6, vid7, vid8};
for i=movie_id
    id = i{1}
    vid = vid_arr{id};

    % Reset HSLO variables and Gabor
    H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);
    H_data2{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
    H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];
    G2 = createGabor(orientationsPerScale, imageSize);

    % Create training data
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid,G2,H_data2,S_data2,L_data2,O_data2,1);
    clear vid;
    save(strcat([save_root, 'HSLO_data_dataset2_test_lindsey_video', num2str(id)]), 'H_data2', 'S_data2', 'L_data2', 'O_data2');
end

%% Obtain features from 'mat' - FCM
clc
% clear all;
n_videos = 1;  % 1 because we want the features from each video individually
for i=movie_id
    id = i{1}
    data_to_load_filename = strcat([save_root, 'HSLO_data_dataset2_test_lindsey_video', num2str(id)]);
    save_feature_filename = {strcat([save_root, 'feature_dataset2_test_lindsey_video', num2str(id), '_v7']),...
                             strcat([save_root, 'number_of_sort_dataset2_test_lindsey_video', num2str(id), '_v7'])};
    mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'lindsey', i);
end
