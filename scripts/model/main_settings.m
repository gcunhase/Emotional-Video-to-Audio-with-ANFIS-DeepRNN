%Gwena Cunha
% Scripts with settings: used by main_2DMOS_anfis.m and main_2DMOS_seq2seq.m
% Added on December 9th 2019

clc; clear all;
%% Settings
emotion_dim = '2d'; global emotion_dim;
model_type = 'lstm'; global model_type;
dataset_name = 'lindsey'; global dataset_name;
tsne_marker_size = 1;
plot_in_out_seq2seq_output = 0;

% Only relevant for LSTM
maxEpochs = 150; global maxEpochs;
miniBatchSize = 1; global miniBatchSize;

% Paths
root_save = strcat(['saved_mats/', dataset_name, '/']); global root_save;

root_sound_feat_path = strcat([root_save, 'features_from_sound/']);
root_visual_feat_path = strcat([root_save, 'features_from_visual/']);
sound_feat_path = strcat([root_sound_feat_path, 'train/']);
visual_feat_path = strcat([root_visual_feat_path, 'train/']);
sound_feat_path_test = strcat([root_sound_feat_path, 'test/']);
visual_feat_path_test = strcat([root_visual_feat_path, 'test/']);

model_anfis_save_path = strcat([root_save, 'model_anfis/']); global model_anfis_save_path;
model_seq2seq_save_path = strcat([root_save, 'model_', model_type, '/']); global model_seq2seq_save_path;

results_path = strcat(['results/', dataset_name, '/', model_type, '/']); global results_path;

%% Load data
if strcmp(emotion_dim, '2d')
    run load_2DMOS_data
end
