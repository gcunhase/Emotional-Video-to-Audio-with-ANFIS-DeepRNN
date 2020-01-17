%%Main file to obtain visual features from scene in DEAP Test for individual
%%samples
%
% Gwena Cunha
%

clc; clear all;

H_data2 = cell(1,2);S_data2 = cell(1,2);L_data2 = cell(1,2);O_data2 = cell(1,2);

H_dat{1}.train = [];S_data2{1}.train = [];L_data2{1}.train = [];O_data2{1}.train = [];
H_data2{2}.test = [];S_data2{2}.test = [];L_data2{2}.test = [];O_data2{2}.test = [];

%%% create gabor filer
imageSize = 256;
orientationsPerScale = [4 4 4];
G2 = createGabor(orientationsPerScale, imageSize);

%%%%% fuzzy cluster    means
%%-----Beginning of GWENA'S MODIFICATION
%%Convert all to mpg from now on
file_name_raw_pos = {};
movie_id = {};
video_id = 10;
for i=video_id:video_id
    movie_id{end+1} = i;
    file_name_raw_pos{end+1} = strcat(['dataset/deap dataset/test dataset/', num2str(i), '.mp4']);
end

n = 10;  % 10  % 240;
save_root = 'saved_mats/deap/features_from_visual/test_individual/';
vid = get_video_components_totalVideo(file_name_raw_pos{1}, n);
[H_data2,S_data2,L_data2,O_data2] = create_training_data_gwena(vid,G2,H_data2,S_data2,L_data2,O_data2,1);

save(strcat([save_root, 'HSLO_data_dataset_deap_test_', num2str(n), '_video', num2str(video_id), '.mat']), 'H_data2', 'S_data2', 'L_data2', 'O_data2', 'movie_id');
%%-----End of GWENA'S MODIFICATION

%% 1
clc
%clear all;

load(strcat([save_root, 'HSLO_data_dataset_deap_test_', num2str(n), '_video', num2str(video_id), '.mat']));
%load EEG_GIST

%----------------random select ----------------------------
%3 videos
n_videos = 1;
[A num_sort] = sort(rand(1,n_videos));
train_num = num_sort(1:n_videos);

train_H = H_data2{1}.train(:,train_num);
train_S = S_data2{1}.train(:,train_num);
train_L = L_data2{1}.train(:,train_num);
train_O = O_data2{1}.train(:,:,train_num);

number_items = n_videos; %8 before
for iter=1:number_items
    temp(:,:,iter) = train_O(:,:,iter)';
end
train_O_data = reshape(temp,[12 176*number_items])'; %112*number_items])';
train_H_data = reshape(train_H,[1100*number_items 1]); %[700*number_items 1]);
train_S_data = reshape(train_S,[1100*number_items 1]);
train_L_data = reshape(train_L,[1100*number_items 1]);

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
save(strcat([save_root, 'feature_dataset_deap_test_', num2str(n), '_video', num2str(video_id), '_v7']), 'Feature_train', 'movie_id', '-v7');
save(strcat([save_root, 'number_of_sort_dataset_deap_test_', num2str(n), '_video', num2str(video_id), '_v7']), 'num_sort', 'number_items', '-v7');