%
% Scripts with settings: used by main_2DMOS_anfis.m and main_2DMOS_seq2seq.m
% 
% Gwena Cunha
% 

clc; clear all;
%% Settings
num_emotion = 1; global num_emotion;  % Tested with 1 and 2
emotion_dim = strcat([num2str(num_emotion), 'd']); global emotion_dim;
model_type = 'lstm'; global model_type;  % Options = rnn, lstm
dataset_name = 'cognimuse'; global dataset_name;  % Options = lindsey, deap, cognimuse
tsne_marker_size = 1;
plot_in_out_seq2seq_output = 0;

% Only relevant to ANFIS
nummfs = 2*num_emotion; global nummfs; % number of membership functions: two times the number of emotions. [2DMOS: 4, 1DMOS: 2].
mftype = 'gbellmf'; global mftype; % membership functions type is generalized bell
numepochs = 4000; global numepochs;

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

results_path = strcat(['results/', dataset_name, '/', model_type, '_', emotion_dim, 'mos/']); global results_path;

%% Load data
is_save_data = false;
if is_save_data
    if num_emotion == 2
        run load_2DMOS_data
    else
        run load_1DMOS_data
    end
else
    load(strcat([root_save, 'model_data_train_', num2str(num_emotion), 'D_v73.mat'])); % 'input_HSL_dict', 'output_TLR_dict', 'output_audio_equivalent_dict', 'input_mos_num', '-v7.3');
end
