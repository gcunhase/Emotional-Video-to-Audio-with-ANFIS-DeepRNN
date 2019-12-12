%Gwena Cunha
% April 14th 2016
% Also return equivalent audio

function [ input_HSL, output_TLR, output_audio_equivalent, input_full, output_full ] = getIO_HSL_TLR_equivAudio_test_individual( visual_feat_path_test, sound_feat_path_test, video_id )
    
    global dataset_name;
    
    format long;
    % root_save = 'saved_mats/lindsey/';
    load(strcat([visual_feat_path_test, 'number_of_sort_dataset2_test_', dataset_name, '_video', num2str(video_id), '_v7'])); %% random���� selection �� ����
    load(strcat([sound_feat_path_test, 'sound_features_dataset2_', dataset_name, '_testAll_video', num2str(video_id), '_size10_v7_raw']));
    
    %% Output
    output_full = [];
    output_song_equivalent = [];
    size_feat = 10;
    train_feature_target = [];
    for i=1:size(feats_per_song,2)
        vec = cell2mat(sound_feat{num_sort(i)});
        vec_tmp = reshape(vec, size_feat*3,size(sound_feat{num_sort(i)},2));
        output_full = [output_full, vec_tmp];

        tmp = cell2mat(song_data(num_sort(i)));
        output_song_equivalent = [output_song_equivalent, tmp(1:44000,:)];
    end
    
    %%Output TLR
    output_T = sum(output_full(1:10,:))/10;
	output_L = sum(output_full(11:20,:))/10;
	output_R = sum(output_full(21:30,:))/10;
	output_TLR = [output_T; output_L; output_R];
    
    %%Output output_original_equivalent = song_data;
    min_size = 0;
    for i=1:size(song_data,1)
        current_size = size(song_data{i},1);
        if (i == 1)
            min_size = current_size;
        else
            if (min_size > current_size)
                min_size = current_size;
            end
        end
    end
    output_audio_equivalent = [];
    for i=1:size(song_data,1)
        output_audio_equivalent = [output_audio_equivalent, song_data{i}(1:min_size, :)];
    end
    
    % Eliminate NaNs and normalize
    for i=1:size(output_full,1)
        for j=1:size(output_full,2)
            if (isnan(output_full(i,j)) || output_full(i,j) == log(0)) %equivalent to -Inf
                output_full(i,j) = 0;
            else
                if (output_full(i,j) == exp(1000)) %Inf
                    output_full(i,j) = 0;
                end    
            end
        end
    end
    a = min(min(output_full));
    b = max(max(output_full));
    output_full = 0 + (1-0)*(output_full-a)/(b-a);
    
    % Eliminate NaNs and normalize
    for i=1:size(output_TLR,1)
        for j=1:size(output_TLR,2)
            if (isnan(output_TLR(i,j)) || output_TLR(i,j) == log(0)) %equivalent to -Inf
                output_TLR(i,j) = 0;
            else
                if (output_TLR(i,j) == exp(1000)) %Inf
                    output_TLR(i,j) = 0;
                end    
            end
        end
    end
    a = min(min(output_TLR));
    b = max(max(output_TLR));
    output_TLR = 0 + (1-0)*(output_TLR-a)/(b-a);
    
    %% Input
    load(strcat([visual_feat_path_test, 'feature_dataset2_test_', dataset_name, '_video', num2str(video_id), '_v7']));        %% feature 
    input_full = [];
    for i=1:size(Feature_train,3)
        input_full = [input_full, Feature_train(:,1:feats_per_song(num_sort(i)),num_sort(i))];
    end
    
    input_H = max(input_full(1:3,:)); %sum(input(1:3,:))/3;
	input_S = max(input_full(4:6,:));
	input_L = max(input_full(7:9,:));
	input_HSL = [input_H; input_S; input_L];
    
    input_HSL = input_HSL./max(max(input_HSL));
    input_full = input_full(1:9,:);
    input_full = input_full./max(max(input_full));
    
end

