%%Main file to obtain visual features from scene in Lindsey
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
file1 = 'dataset/lindsey stirling dataset/video/Beyond_The_Veil_-_Lindsey_Stirling_(Original_Song).mpg';
file2 = 'dataset/lindsey stirling dataset/video/Crystallize_-_Lindsey_Stirling_(Dubstep_Violin_Original_Song).mpg';
file3 = 'dataset/lindsey stirling dataset/video/Elements - Lindsey Stirling (Dubstep Violin Original Song).mp4';
file4 = 'dataset/lindsey stirling dataset/video/Lindsey_Stirling_-_Take_Flight_[Official_Music_Video_-_YTMAs].mpg';
file5 = 'dataset/lindsey stirling dataset/video/Lord_of_the_Rings_Medley_-_Lindsey_Stirling.mpg';
file6 = 'dataset/lindsey stirling dataset/video/Moon_Trance_-_Lindsey_Stirling_(Original_Song).mpg';
file7 = 'dataset/lindsey stirling dataset/video/Phantom_of_the_Opera_-_Lindsey_Stirling.mpg';
file8 = 'dataset/lindsey stirling dataset/video/Roundtable Rival - Lindsey Stirling.mp4';
%file9 = 'dataset/lindsey stirling dataset/video/Shadows - Lindsey Stirling (Original Song).mp4'; %Black and white 
movie_id = {1, 2, 3, 4, 5, 6, 7, 8};

%% Save and load videos
n = 500;  % In the Lindsey Dataset, each video is between 3 and 4 minutes
is_save = false;
is_load = false;
save_root = 'saved_mats/lindsey/features_from_visual/train/';
mkdir(save_root);

%%Save videos
if is_save
    disp('Save videos');
    vid1 = get_video_components_totalVideo(file1, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid1_correct_500']), 'vid1');
    vid2 = get_video_components_totalVideo(file2, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid2_correct_500']), 'vid2');
    vid3 = get_video_components_totalVideo(file3, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid3_correct_500']), 'vid3');
    vid4 = get_video_components_totalVideo(file4, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid4_correct_500']), 'vid4');
    vid5 = get_video_components_totalVideo(file5, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid5_correct_500']), 'vid5');
    vid6 = get_video_components_totalVideo(file6, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid6_correct_500']), 'vid6');
    vid7 = get_video_components_totalVideo(file7, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid7_correct_500']), 'vid7');
    vid8 = get_video_components_totalVideo(file8, n);
    save(strcat([save_root, 'videos_dataset2_lindsey_vid8_correct_500']), 'vid8');

    % %save videos_dataset2_full_vid1 vid1 -v7.3;
    % %save(strcat([save_root, 'videos_dataset2_full_vid1']), 'vid1', '-v7.3');
end

%%Load videos
if is_load
    disp('Load videos');
    load videos_dataset2_lindsey_vid1_correct_500 vid1;
    load videos_dataset2_lindsey_vid2_correct_500 vid2;
    load videos_dataset2_lindsey_vid3_correct_500 vid3;
    load videos_dataset2_lindsey_vid4_correct_500 vid4;
    load videos_dataset2_lindsey_vid5_correct_500 vid5;
    load videos_dataset2_lindsey_vid6_correct_500 vid6;
    load videos_dataset2_lindsey_vid7_correct_500 vid7;
    load videos_dataset2_lindsey_vid8_correct_500 vid8;

    %load videos video_final1;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid1,G2,H_data2,S_data2,L_data2,O_data2,1); clear vid1;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid2,G2,H_data2,S_data2,L_data2,O_data2,2); clear vid2;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid3,G2,H_data2,S_data2,L_data2,O_data2,3); clear vid3;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid4,G2,H_data2,S_data2,L_data2,O_data2,4); clear vid4;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid5,G2,H_data2,S_data2,L_data2,O_data2,5); clear vid5;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid6,G2,H_data2,S_data2,L_data2,O_data2,6); clear vid6;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid7,G2,H_data2,S_data2,L_data2,O_data2,7); clear vid7;
    [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid8,G2,H_data2,S_data2,L_data2,O_data2,8); clear vid8;
    %[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid9,G2,H_data2,S_data2,L_data2,O_data2,9); clear vid9;

    save(strcat([save_root, 'HSLO_data_dataset2_correct_lindsey_500']), 'H_data2', 'S_data2', 'L_data2', 'O_data2');
end

%% Obtain features from 'mat' - FCM
clc
% clear all;
n_videos = 8;
data_to_load_filename = strcat([save_root, 'HSLO_data_dataset2_correct_lindsey_500']);
save_feature_filename = {strcat([save_root, 'feature_dataset2_correct_lindsey_500_v7']),...
                         strcat([save_root,'number_of_sort_dataset2_correct_lindsey_500_v7', 'num_sort'])};
Feature_train = mat2feat(n_videos, data_to_load_filename, save_feature_filename, 'lindsey', movie_id);
