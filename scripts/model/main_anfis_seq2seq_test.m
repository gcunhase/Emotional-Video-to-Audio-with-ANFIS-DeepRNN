%Gwena Cunha
% Added Deep Network on November 13th 2017
%
% TEST Domain transformation: generate audio features from excerpt from training data
% EVALUATION:
%   Spectrogram figures
%   MAE between expected and obtained audios
%

%% Test with 'test dataset'
% Load data
if strcmp(dataset_name, 'lindsey')
    data_path = 'lindsey stirling dataset';
    video_id = 1; % Roundtable
    %video_id = 2; % Beyond the veil
    %video_id = 3; % Phantom of the Opera
    %video_id = 4; % Take Flight
    %video_id = 5; % Crystallize
    %video_id = 6; % Moon Trance
    %video_id = 7; % LOTR Medley
    %video_id = 8; % Elements
else  % deap
    data_path = 'deap dataset';
    video_id = 5;  % range: 1 to 10
end

TLR_database = output_TLR;
audio_database = output_audio_equivalent;
sound_feat_path_test_individual = strcat([root_sound_feat_path, 'test_individual/']);
visual_feat_path_test_individual = strcat([root_visual_feat_path, 'test_individual/']);

% getIO_HSL_TLR_equivAudio_2DMOS -> same for 1DMOS, change name
[ input_HSL_test, output_TLR_test, ~, input_full_test, output_full_test ] = getIO_HSL_TLR_equivAudio_test_individual( visual_feat_path_test_individual, sound_feat_path_test_individual, video_id );

Xin_HSL_test = input_HSL_test'; 
Xout_HSL_test = output_TLR_test'; 
audio_filename = strcat([results_path, 'testVideo_fuzzy_', model_type, '_', emotion_dim, 'mos_video', num2str(video_id)]);  % filename = 'testVideo_fuzzy_rnn_2dmos_trainData';
[out_final, final_audio_reshaped, audio_filename, predicted_audio_filename] = eval_anfis_seq2seq_model(Xin_HSL_test, Xout_HSL_test, output_TLR, output_audio_equivalent, audio_filename);

% Target/expected audio
[y, fs] = audioread(strcat(['dataset/', data_path, '/test dataset/', num2str(video_id), '.mp4']));
y = y(:,1);
audio_filename_expected = strcat([audio_filename, '_expected.wav']);
audiowrite(audio_filename_expected, y, fs);
figure('Name', strcat(['Expected audio - video ', num2str(video_id)])), specgram(y, 512, fs, kaiser(500,5), 475);

% Comparison between expected and predicted audios
[y1, fs] = audioread(strcat([predicted_audio_filename, '_sim_framed.wav']));  % 'sim_framed_testVideo_fuzzy_rnn_2dmos_trainData.wav');
figure('Name', strcat(['Predicted audio - video ', num2str(video_id)])), specgram(y1, 512, fs, kaiser(500,5), 475);

m = min(length(y1), length(y));
mae_val = mae(y1(1:m)-y(1:m));

disp(strcat(['Test video ', num2str(video_id), ' from the ', dataset_name, ' dataset, has MAE of ', num2str(mae_val)]));


%% Test with train data - NOT NECESSARY
% THIS SUBSECTION IS ONLY FOR THE LINDSEY DATASET

%n1 = 100; n2 = 110; %mae = 0.164617559909981
%n1 = 240; n2 = 250; %mae = 0.285375937261687
%n1 = 440; n2 = 450; %mae = 0.253314625943044
%n1 = 610; n2 = 620; %mae = 0.237831239415712
%n1 = 830; n2 = 840; %mae = 0.138472985303681 %Crystallize
n1 = 1140; n2 = 1150; %mae = 0.243540687296346
%n1 = 1300; n2 = 1310; %mae = 0.198422129544547 %LOTR
%n1 = 1510; n2 = 1520; %mae = 0.203434343740401
%n1 = 1; n2 = size(output_audio_equivalent,2);

Xin_HSL_test = input_HSL(:,n1:n2)'; 
Xout_HSL_test = output_TLR(:,n1:n2)'; 

[out_final, final_audio_reshaped, audio_filename, predicted_audio_filename] = eval_anfis_seq2seq_2DMOS_model(Xin_HSL_test, Xout_HSL_test, output_TLR, output_audio_equivalent);


% Target/expected audio
out_audio_eq_full = [];
for i=n1:n2
    out_audio_eq_full = [out_audio_eq_full, output_audio_equivalent(:,i)'];
end
expected_audio_filename = strcat([audio_filename, '_expected.wav']);  % 'out_audio_eq_full.wav'
audiowrite(expected_audio_filename,out_audio_eq_full,44100);
[y, fs] = audioread(expected_audio_filename);
figure, specgram(y, 512, fs, kaiser(500,5), 475);
title('Expected audio');

% Comparison between expected and predicted audios
[y1, fs] = audioread(strcat([predicted_audio_filename, '_sim_framed.wav']));  % 'sim_framed_testVideo_fuzzy_rnn_2dmos_trainData.wav');
figure, specgram(y1, 512, fs, kaiser(500,5), 475);
title('Predicted audio');

m = min(length(y1), length(y));
mae_val = mae(y1(1:m)-y(1:m))
