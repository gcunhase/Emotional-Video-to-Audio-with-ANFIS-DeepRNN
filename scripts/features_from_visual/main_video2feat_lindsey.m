clc; clear all;

H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);

H_dat{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];

%%% create gabor filer
imageSize = 256;
orientationsPerScale = [4 4 4];
G2 = createGabor(orientationsPerScale, imageSize);

%%%%% fuzzy cluster means
%%-----Beginning of GWENA'S MODIFICATION
%%Convert all to mpg
% file1 = 'dataset/lindsey stirling dataset/video/Beyond_The_Veil_-_Lindsey_Stirling_(Original_Song).mpg';
% file2 = 'dataset/lindsey stirling dataset/video/Crystallize_-_Lindsey_Stirling_(Dubstep_Violin_Original_Song).mpg';
% file3 = 'dataset/lindsey stirling dataset/video/Elements - Lindsey Stirling (Dubstep Violin Original Song).mp4';
% file4 = 'dataset/lindsey stirling dataset/video/Lindsey_Stirling_-_Take_Flight_[Official_Music_Video_-_YTMAs].mpg';
% file5 = 'dataset/lindsey stirling dataset/video/Lord_of_the_Rings_Medley_-_Lindsey_Stirling.mpg';
% file6 = 'dataset/lindsey stirling dataset/video/Moon_Trance_-_Lindsey_Stirling_(Original_Song).mpg';
% file7 = 'dataset/lindsey stirling dataset/video/Phantom_of_the_Opera_-_Lindsey_Stirling.mpg';
% file8 = 'dataset/lindsey stirling dataset/video/Roundtable Rival - Lindsey Stirling.mp4';
%%%%%file9 = 'dataset/lindsey stirling dataset/video/Shadows - Lindsey Stirling (Original Song).mp4'; %Black and white
% 

save_root = 'saved_mats/lindsey/features_from_visual/';

% % %%Save videos
% n=500; %n = 1200;
% vid1 = get_video_components_totalVideo(file1, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid1_correct_500']), 'vid1');
% vid2 = get_video_components_totalVideo(file2, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid2_correct_500']), 'vid2');
% vid3 = get_video_components_totalVideo(file3, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid3_correct_500']), 'vid3');
% vid4 = get_video_components_totalVideo(file4, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid4_correct_500']), 'vid4');
% vid5 = get_video_components_totalVideo(file5, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid5_correct_500']), 'vid5');
% vid6 = get_video_components_totalVideo(file6, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid6_correct_500']), 'vid6');
% vid7 = get_video_components_totalVideo(file7, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid7_correct_500']), 'vid7');
% vid8 = get_video_components_totalVideo(file8, n);
% save(strcat([save_root, 'videos_dataset2_lindsey_vid8_correct_500']), 'vid8');

% %save videos_dataset2_full_vid1 vid1 -v7.3;
% %save(strcat([save_root, 'videos_dataset2_full_vid1']), 'vid1', '-v7.3');

%%Load videos
load videos_dataset2_lindsey_vid1_correct_500 vid1;
load videos_dataset2_lindsey_vid2_correct_500 vid2;
load videos_dataset2_lindsey_vid3_correct_500 vid3;
load videos_dataset2_lindsey_vid4_correct_500 vid4;
load videos_dataset2_lindsey_vid5_correct_500 vid5;
load videos_dataset2_lindsey_vid6_correct_500 vid6;
load videos_dataset2_lindsey_vid7_correct_500 vid7;
load videos_dataset2_lindsey_vid8_correct_500 vid8;

%%-----End of GWENA'S MODIFICATION
%load videos video_final1;
% [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid3,G2,H_data2,S_data2,L_data2,O_data2,1); clear vid3;
% [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid8,G2,H_data2,S_data2,L_data2,O_data2,2); clear vid8;
% [H_data2,S_data2,L_data2,O_data2] = create_training_data(vid9,G2,H_data2,S_data2,L_data2,O_data2,3); clear vid9;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid1,G2,H_data2,S_data2,L_data2,O_data2,1); clear vid1;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid2,G2,H_data2,S_data2,L_data2,O_data2,2); clear vid2;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid3,G2,H_data2,S_data2,L_data2,O_data2,3); clear vid3;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid4,G2,H_data2,S_data2,L_data2,O_data2,4); clear vid4;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid5,G2,H_data2,S_data2,L_data2,O_data2,5); clear vid5;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid6,G2,H_data2,S_data2,L_data2,O_data2,6); clear vid6;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid7,G2,H_data2,S_data2,L_data2,O_data2,7); clear vid7;
[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid8,G2,H_data2,S_data2,L_data2,O_data2,8); clear vid8;
%[H_data2,S_data2,L_data2,O_data2] = create_training_data(vid9,G2,H_data2,S_data2,L_data2,O_data2,9); clear vid9;

%load('HSLO_data_dataset2_correct_lindsey_1200.mat');

save(strcat([save_root, 'HSLO_data_dataset2_correct_lindsey_500']), 'H_data2', 'S_data2', 'L_data2', 'O_data2');

%video3
% NumMovie = 3;
% H_data3{1}.train(:,NumMovie) = H_data2{1}.train(:,NumMovie);
% S_data3{1}.train(:,NumMovie) = S_data2{1}.train(:,NumMovie);
% L_data3{1}.train(:,NumMovie) = L_data2{1}.train(:,NumMovie);
% O_data3{1}.train(:,:,NumMovie) = O_data2{1}.train(:,:,NumMovie);
%     
% H_data3{2}.test(:,:,NumMovie) = H_data2{2}.test(:,:,NumMovie);
% S_data3{2}.test(:,:,NumMovie) = S_data2{2}.test(:,:,NumMovie);
% L_data3{2}.test(:,:,NumMovie) = L_data2{2}.test(:,:,NumMovie);
% O_data3{2}.test(:,:,:,NumMovie) = O_data2{2}.test(:,:,:,NumMovie);
    

%% 1
clc
clear all;

load(strcat([save_root, 'HSLO_data_dataset2_correct_lindsey_500']));
%load EEG_GIST

%----------------random select ----------------------------
%3 videos
[A num_sort] = sort(rand(1,8));
train_num = num_sort(1:8);

train_H = H_data2{1}.train(:,train_num);
train_S = S_data2{1}.train(:,train_num);
train_L = L_data2{1}.train(:,train_num);
train_O = O_data2{1}.train(:,:,train_num);

number_items = 8; %3 before
for iter=1:number_items
    temp(:,:,iter) = train_O(:,:,iter)';
end
train_O_data = reshape(temp,[12 3776*number_items])';
train_H_data = reshape(train_H,[23600*number_items 1]);
train_S_data = reshape(train_S,[23600*number_items 1]);
train_L_data = reshape(train_L,[23600*number_items 1]);

clear train_H train_S train_L train_O temp

%fcm: Fuzzy c-means clustering
%http://www.mathworks.com/matlabcentral/fileexchange/48686-fuzzyclustertoolbox/content/FuzzyClusterToolBox/FCM_Matlab/fcm.m
%http://kr.mathworks.com/help/fuzzy/fcm.html
[center_H,Y_h,obj_h_fcn] = fcm(train_H_data,3);
[center_S,Y_s,obj_s_fcn] = fcm(train_S_data,3);
[center_L,Y_L,obj_L_fcn] = fcm(train_L_data,3);
[center_O,Y_O,obj_O_fcn] = fcm(train_O_data,4);
    
center_H = sort(center_H);
center_S = sort(center_S);
center_L = sort(center_L);
center_O = sort(center_O);

data_H_train = H_data2{2}.test(:,:,train_num);
data_S_train = S_data2{2}.test(:,:,train_num);
data_L_train = L_data2{2}.test(:,:,train_num);
data_O_train = O_data2{2}.test(:,:,:,train_num);

data_size = size(data_H_train);
O_train_feature_ver2 = [];
%%---------------Changed until HERE-----------------------
for k=1:number_items
    for i=1:data_size(2)
        distance_H(:,:,i) = distfcm(center_H,data_H_train(:,i,k));
        [H_C H_I] = min(distance_H);
        distance_S(:,:,i) = distfcm(center_S,data_S_train(:,i,k));
        [S_C S_I] = min(distance_S);
        distance_L(:,:,i) = distfcm(center_L,data_L_train(:,i,k));
        [L_C L_I] = min(distance_L);
        for iter=1:12
            distance_O(:,:,i,iter) = distfcm(center_O(:,iter),data_O_train(:,iter,i,k));
        end
        [O_C O_l] = min(distance_O);
    end
    
    for j=1:data_size(2)
        for i=1:3
            Feature_H(i,j) = length(find(H_I(1,:,j) == i));
            Feature_S(i,j) = length(find(S_I(1,:,j) == i));
            Feature_L(i,j) = length(find(L_I(1,:,j) == i));
            for iter=1:12
                O_train_feature(i,j,iter) = length(find(O_l(1,:,j,iter) == i));
            end
        end
    end
    train_feature = [Feature_H;Feature_L;Feature_S];
    Feature_train(:,:,k) = train_feature;
    Feature_O = [];
    for iter=1:12
        Feature_O = [Feature_O;O_train_feature(:,:,iter)];  
    end
    O_train_feature_ver2 = [O_train_feature_ver2 Feature_O];
    O_train_feature_ver3(:,:,k) = Feature_O;
end

[O_center_ver2,O_Y_ver2] = fcm(O_train_feature_ver2',4);
for k=1:number_items
    train_feature = Feature_train(:,:,k);
    train_feature = [train_feature; O_Y_ver2(:,(k-1)*data_size(2)+1:k*data_size(2))];
    temp(:,:,k) = train_feature;
end
Feature_train = temp;

%save feature_dataset2_1200 Feature_train
%save number_of_sort_dataset2_1200 num_sort number_items
save(strcat([save_root, 'feature_dataset2_correct_lindsey_500_v7']), 'Feature_train', '-v7');
save(strcat([save_root,'number_of_sort_dataset2_correct_lindsey_500_v7', 'num_sort']), 'number_items', '-v7');
