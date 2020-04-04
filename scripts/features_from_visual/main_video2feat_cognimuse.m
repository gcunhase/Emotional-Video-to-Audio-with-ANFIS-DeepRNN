%%Main file to obtain visual features from scene in COGNIMUSE
%
% Gwena Cunha
%

clc; clear all;

H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);

H_data2{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];

%%% create gabor file
imageSize = 256;
orientationsPerScale = [4 4 4];
G2 = createGabor(orientationsPerScale, imageSize);

%% Video filename
% Choose the files to extract the features from
%%%%% fuzzy cluster    means
%%-----Beginning of GWENA'S MODIFICATION

root_dir='dataset/cognimuse dataset/';
list_of_clip_names = {'DEP'}; %{'BMI', 'CHI', 'FNE', 'GLA', 'LOR', 'CRA', 'DEP'};
list_of_clip_size = [];  % 625   602   605   600   750
% Get numbers of videos in each clip
for l=list_of_clip_names
    clip_name = l{1};
    files = dir(strcat([root_dir, clip_name, '/video_splices_3secs/*.mp4']));
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
        file_name_raw_pos{end+1} = strcat(['dataset/cognimuse dataset/', clip_struct.name, '/video_splices_3secs/', num2str(i), '.mp4']);
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
is_save = false;
is_load = true;
save_root = 'saved_mats/cognimuse/features_from_visual/';
if strcmp(clip_name, 'CRA') || strcmp(clip_name, 'DEP')  % test
    save_root = strcat([save_root, 'test/']);
else
    save_root = strcat([save_root, 'train/']);
end
mkdir( save_root);

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
           save_path_mat = strcat([save_path, 'videos_dataset_cognimuse_vid', num2str(i), '_', num2str(n), '.mat'])
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

       % Reset H, S, O, G
       H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);
       H_data2{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
       H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];
       %%% create gabor filer
       imageSize = 256;
       orientationsPerScale = [4 4 4];
       G2 = createGabor(orientationsPerScale, imageSize);

       for i=1:clip_size
           i
           load(strcat([save_path, 'videos_dataset_cognimuse_vid', num2str(i), '_', num2str(n), '.mat']), 'vid');
           [H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid,G2,H_data2,S_data2,L_data2,O_data2,i);
           clear vid;
       end

       save(strcat([save_root, 'HSLO_data_dataset_cognimuse_', clip_name, '_', num2str(n), '.mat']), 'H_data2', 'S_data2', 'L_data2', 'O_data2', 'movie_id');
    end
end

%%-----End of GWENA'S MODIFICATION

%% 1
% clc
% clear all;
clip_struct = clip_struct_all(1);
clip_name = clip_struct.name
load(strcat([save_root, 'HSLO_data_dataset_cognimuse_', clip_name, '_', num2str(n), '.mat']));
%load EEG_GIST

%----------------random select ----------------------------
%3 videos
%n_videos = 38;
n_videos = clip_struct.size
[A num_sort] = sort(rand(1,n_videos));
train_num = num_sort(1:n_videos);

train_H = H_data2{1}.train(:,train_num);
train_S = S_data2{1}.train(:,train_num);
train_L = L_data2{1}.train(:,train_num);
train_O = O_data2{1}.train(:,:,train_num);

%size(train_H)
%size(train_O)

number_items = n_videos; %8 before
for iter=1:number_items
    temp(:,:,iter) = train_O(:,:,iter)';
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
train_O_data = reshape(temp,[12 160*number_items])';  % 2000, n=125  
train_H_data = reshape(train_H,[1000*number_items 1]);  % 12500, n=125
train_S_data = reshape(train_S,[1000*number_items 1]);
train_L_data = reshape(train_L,[1000*number_items 1]);

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

%size(data_O_train)
%size(data_H_train)

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
save(strcat([save_root, 'feature_dataset_cognimuse_', clip_name, '_', num2str(n), '_v7']), 'Feature_train', 'clip_struct', '-v7');
save(strcat([save_root, 'number_of_sort_dataset_cognimuse_', clip_name, '_', num2str(n), '_v7']), 'num_sort', 'number_items', '-v7');
