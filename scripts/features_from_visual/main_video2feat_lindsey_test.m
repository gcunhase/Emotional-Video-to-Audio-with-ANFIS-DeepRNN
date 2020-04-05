%%Main file to obtain visual features from scene in Lindsey Test
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
%%Convert all to mpg
file1 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/1 - Roundtable.mp4';
file2 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/2 - Beyond the veil.mp4';
file3 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/3 - Phantom of the Opera.mp4';
file4 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/4 - Take Flight.mp4';
file5 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/5 - Crystallize.mp4';
file6 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/6 - Moon Trance.mp4';
file7 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/7 - LOTR Medley.mp4';
file8 = 'dataset/lindsey stirling dataset/test dataset/trimmed + obtained audio/8 - Elements.mp4';
movie_id = {1, 2, 3, 4, 5, 6, 7, 8};

%% Save and load videos
n = 8; %(256, 256, 3, 6)
is_save = false;
is_load = false;
save_root = 'saved_mats/lindsey/features_from_visual/test/';
mkdir(save_root);

%%Save videos
if is_save
    disp('Save videos');
    vid1 = get_video_components_totalVideo(file1, n);
    vid2 = get_video_components_totalVideo(file2, n);
    vid3 = get_video_components_totalVideo(file3, n);
    vid4 = get_video_components_totalVideo(file4, n);
    vid5 = get_video_components_totalVideo(file5, n);
    vid6 = get_video_components_totalVideo(file6, n);
    vid7 = get_video_components_totalVideo(file7, n);
    vid8 = get_video_components_totalVideo(file8, n);

    save(strcat([save_root, 'videos_dataset2_testVideoAll_lindsey_vids_', num2str(n)]),...
        'vid1', 'vid2', 'vid3', 'vid4', 'vid5', 'vid6', 'vid7', 'vid8');
end

%%Load videos
if is_load
    disp('Load videos');
    load(strcat([save_root, 'videos_dataset2_testVideoAll_lindsey_vids_', num2str(n)]), 'vid1', 'vid2', 'vid3', 'vid4', 'vid5', 'vid6', 'vid7', 'vid8');

    %load videos video_final1;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid1,G2,H_data2,S_data2,L_data2,O_data2,1); clear vid1;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid2,G2,H_data2,S_data2,L_data2,O_data2,2); clear vid2;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid3,G2,H_data2,S_data2,L_data2,O_data2,3); clear vid3;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid4,G2,H_data2,S_data2,L_data2,O_data2,4); clear vid4;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid5,G2,H_data2,S_data2,L_data2,O_data2,5); clear vid5;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid6,G2,H_data2,S_data2,L_data2,O_data2,6); clear vid6;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid7,G2,H_data2,S_data2,L_data2,O_data2,7); clear vid7;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid8,G2,H_data2,S_data2,L_data2,O_data2,8); clear vid8;

    save(strcat([save_root, 'HSLO_data_dataset2_testVideoAll_lindsey_', num2str(n)]), 'H_data2', 'S_data2', 'L_data2', 'O_data2');
end

%% Obtain features from 'mat' - FCM
clc
% clear all;
n_videos = 8;
data_to_load_filename = strcat([save_root, 'HSLO_data_dataset2_testVideoAll_lindsey_', num2str(n)]);
save_feature_filename = {strcat([save_root, 'feature_dataset2_testVideoAll_lindsey_', num2str(n), '_v7']),...
                         strcat([save_root, 'number_of_sort_dataset2_testVideoAll_lindsey_', num2str(n), '_v7'])};
Feature_train = mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'lindsey', movie_id);
