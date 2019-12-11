%% Initialization
clc;clear all;

%% Data load : Valence emotion information data in scenes
% Input  : 
% Output : 
load positive positive1 positive2 positive3 positive4 positive5 positive6 positive7
load negative negative1 negative2 negative3 negative4 negative5 negative6 negative7

% Empty cell to put into the GIST information
% Input  : 
% Output : 

H_data = cell(1,2);     S_data = cell(1,2);     L_data = cell(1,2);     O_data = cell(1,2);
H_data{1}.train = [];   S_data{1}.train = [];   L_data{1}.train = [];   O_data{1}.train = [];
H_data{2}.test = [];    S_data{2}.test = [];    L_data{2}.test = [];    O_data{2}.test = [];

%% Create gabor filer to analize orientation
% Input  : 
% Output : [imageSize, orientationsPerScale, G]

imageSize = 256;
orientationsPerScale = [4 4 4];
G = createGabor(orientationsPerScale, imageSize);

%% Find the fuzzy cluster means
% Input  : (positive1,  G,          H_data,     S_data,     L_data,     O_data,     labeled number)
% Output : [H_data,     S_data,     L_data,     O_data]
%          

[H_data,S_data,L_data,O_data] = create_training_data(positive1,G,H_data,S_data,L_data,O_data,1);    clear positive1;
[H_data,S_data,L_data,O_data] = create_training_data(positive2,G,H_data,S_data,L_data,O_data,2);    clear positive2;
[H_data,S_data,L_data,O_data] = create_training_data(positive3,G,H_data,S_data,L_data,O_data,3);    clear positive3;
[H_data,S_data,L_data,O_data] = create_training_data(positive4,G,H_data,S_data,L_data,O_data,4);    clear positive4;
[H_data,S_data,L_data,O_data] = create_training_data(positive5,G,H_data,S_data,L_data,O_data,5);    clear positive5;
[H_data,S_data,L_data,O_data] = create_training_data(positive6,G,H_data,S_data,L_data,O_data,6);    clear positive6;
[H_data,S_data,L_data,O_data] = create_training_data(positive7,G,H_data,S_data,L_data,O_data,7);    clear positive7;

[H_data,S_data,L_data,O_data] = create_training_data(negative1,G,H_data,S_data,L_data,O_data,8);    clear negative1;
[H_data,S_data,L_data,O_data] = create_training_data(negative2,G,H_data,S_data,L_data,O_data,9);    clear negative2;
[H_data,S_data,L_data,O_data] = create_training_data(negative3,G,H_data,S_data,L_data,O_data,10);   clear negative3;
[H_data,S_data,L_data,O_data] = create_training_data(negative4,G,H_data,S_data,L_data,O_data,11);   clear negative4;
[H_data,S_data,L_data,O_data] = create_training_data(negative5,G,H_data,S_data,L_data,O_data,12);   clear negative5;
[H_data,S_data,L_data,O_data] = create_training_data(negative6,G,H_data,S_data,L_data,O_data,13);   clear negative6;
[H_data,S_data,L_data,O_data] = create_training_data(negative7,G,H_data,S_data,L_data,O_data,14);   clear negative7;

save HSLO_data H_data S_data L_data O_data

%% 1
clc;                clear all;
load HSLO_data;     load EEG_GIST

%----------------random select ----------------------------
% Input  : 
% Output : 
[A num_sort] = sort(rand(1,7));
train_num = num_sort(1:4);
test_num = num_sort(5:7);


train_H = H_data{1}.train(:,[train_num train_num+7]);
train_S = S_data{1}.train(:,[train_num train_num+7]);
train_L = L_data{1}.train(:,[train_num train_num+7]);
train_O = O_data{1}.train(:,:,[train_num train_num+7]);

for iter=1:8
    temp(:,:,iter) = train_O(:,:,iter)';
end
train_O_data = reshape(temp,[12 3776*8])';
train_H_data = reshape(train_H,[23600*8 1]);
train_S_data = reshape(train_S,[23600*8 1]);
train_L_data = reshape(train_L,[23600*8 1]);

clear train_H train_S train_L train_O temp

[center_H,Y_h,obj_h_fcn] = fcm(train_H_data,3);
[center_S,Y_s,obj_s_fcn] = fcm(train_S_data,3);
[center_L,Y_L,obj_L_fcn] = fcm(train_L_data,3);
[center_O,Y_O,obj_O_fcn] = fcm(train_O_data,4);
    
center_H = sort(center_H);
center_S = sort(center_S);
center_L = sort(center_L);
center_O = sort(center_O);

data_H_train = H_data{2}.test(:,:,[train_num train_num+7]);
data_S_train = S_data{2}.test(:,:,[train_num train_num+7]);
data_L_train = L_data{2}.test(:,:,[train_num train_num+7]);
data_O_train = O_data{2}.test(:,:,:,[train_num train_num+7]);

data_H_test = H_data{2}.test(:,:,[test_num test_num+7]);
data_S_test = S_data{2}.test(:,:,[test_num test_num+7]);
data_L_test = L_data{2}.test(:,:,[test_num test_num+7]);
data_O_test = O_data{2}.test(:,:,:,[test_num test_num+7]);

data_size = size(data_H_train);
O_train_feature_ver2 = [];
for k=1:8
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
for k=1:8
    train_feature = Feature_train(:,:,k);
    train_feature = [train_feature; O_Y_ver2(:,(k-1)*data_size(2)+1:k*data_size(2))];
    temp(:,:,k) = train_feature;
end
Feature_train = [];
Feature_train = temp;

%% 2
distance_H = [];
distance_S = [];
distance_L = [];
distance_O = [];
O_test_feature_ver2 = [];
for k=1:6
    for i=1:data_size(2)
        distance_H(:,:,i) = distfcm(center_H,data_H_test(:,i,k));
        [H_C H_I] = min(distance_H);
        distance_S(:,:,i) = distfcm(center_S,data_S_test(:,i,k));
        [S_C S_I] = min(distance_S);
        distance_L(:,:,i) = distfcm(center_L,data_L_test(:,i,k));
        [L_C L_I] = min(distance_L);
        for iter=1:12
            distance_O(:,:,i,iter) = distfcm(center_O(:,iter),data_O_test(:,iter,i,k));
        end
        [O_C O_l] = min(distance_O);
    end
    
    for j=1:data_size(2)
        for i=1:3
            Feature_H(i,j) = length(find(H_I(1,:,j) == i));
            Feature_S(i,j) = length(find(S_I(1,:,j) == i));
            Feature_L(i,j) = length(find(L_I(1,:,j) == i));
            for iter=1:12
                O_test_feature(i,j,iter) = length(find(O_l(1,:,j,iter) == i));
            end
        end
    end
    test_feature = [Feature_H;Feature_L;Feature_S];
    Feature_test(:,:,k) = test_feature;
    Feature_O = [];
    for iter=1:12
        Feature_O = [Feature_O;O_test_feature(:,:,iter)];  
    end
    O_test_feature_ver2 = [O_test_feature_ver2 Feature_O];  
    O_test_feature_ver3(:,:,k) = Feature_O;
end

expo = 2;
distance_O = [];
Feature_O = [];
distance_O = distfcm(O_center_ver2, O_test_feature_ver2');

tmp = distance_O.^(-2/(expo-1));      % calculate new U, suppose expo != 1
Feature_O = tmp./(ones(4, 1)*sum(tmp));
temp = [];
for k=1:6
    test_feature = Feature_test(:,:,k);
    test_feature = [test_feature; Feature_O(:,(k-1)*data_size(2)+1:k*data_size(2))];
    temp(:,:,k) = test_feature;
end
Feature_test = [];
Feature_test = temp;



train_EEG=feature(:,[train_num train_num+7],:);
test_EEG=feature(:,[test_num test_num+7],:);
tmp_train_EEG=[];
tmp_test_EEG=[];
for iter=1:10
    tmp_train_EEG(iter,:,:) = train_EEG(:,:,iter);
    tmp_test_EEG(iter,:,:) = test_EEG(:,:,iter);
end
train_EEG = [];
test_EEG = [];
train_EEG = tmp_train_EEG;
test_EEG = tmp_test_EEG;

EEG_train = reshape(train_EEG,[230*8 10]);
[center_EEG, EEG_descriptor_train]=fcm(EEG_train,2);
distance_EEG=[];
EEG_descriptor_test=[];
EEG_descriptor_train=[];
for iter = 1:8
    distance_EEG = distfcm(center_EEG, train_EEG(:,:,iter)');
    tmp = distance_EEG.^(-2/(expo-1));      % calculate new U, suppose expo != 1
    EEG_descriptor_train(:,:,iter) = tmp./(ones(2, 1)*sum(tmp));
end
for iter = 1:6
    distance_EEG = distfcm(center_EEG, test_EEG(:,:,iter)');
    tmp = distance_EEG.^(-2/(expo-1));      % calculate new U, suppose expo != 1
    EEG_descriptor_test(:,:,iter) = tmp./(ones(2, 1)*sum(tmp));
end
Feature_train = [Feature_train; EEG_descriptor_train];
Feature_test = [Feature_test; EEG_descriptor_test];

save feature Feature_train Feature_test
save number_of_sort num_sort