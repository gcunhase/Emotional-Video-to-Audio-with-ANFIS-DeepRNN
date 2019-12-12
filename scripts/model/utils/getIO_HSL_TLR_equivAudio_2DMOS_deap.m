%Gwena Cunha
% April 14th 2016
% Also return equivalent audio

function [ input_HSL, output_TLR, output_audio_equivalent, input_mos, output_mos, input_mos_num, output_mos_num, input_full, output_full ] = getIO_HSL_TLR_equivAudio_2DMOS_deap( visual_feat_path, sound_feat_path, filename )
    
    format long;
    load(strcat([visual_feat_path, 'number_of_sort_dataset_deap_125_v7'])); %% random���� selection �� ����
    load(strcat([sound_feat_path, 'sound_features_dataset2_deap_size10_v7_raw']));
    
    %% Output
    output_full = [];
    output_song_equivalent = [];
    size_feat = 10; %size(sound_feat{1},2);
    train_feature_target = [];
    for i=1:size(feats_per_song,2)
        vec = cell2mat(sound_feat{num_sort(i)});
        vec_tmp = reshape(vec, size_feat*3,size(sound_feat{num_sort(i)},2));
        output_full = [output_full, vec_tmp];

        tmp = cell2mat(song_data(num_sort(i)));
        output_song_equivalent = [output_song_equivalent, tmp(1:44000,:)];

    end
    
    %% Output considering MOS csv_file from 5 Lab Members
    
    %%----------------BEGIN difference from Lindsey file-------------------
    if (nargin < 3)
        filename = 'dataset/deap dataset/participant_ratings.csv';
    end
    [~, values_dict] = tsvreadGoogleForm_deap(filename);
    
    values_valence = [];
    values_arousal = [];
    
    part_id_arr = values_dict('Participant_id');
    values_valence_all = values_dict('Valence');
    values_arousal_all = values_dict('Arousal');
    for i=1:max(part_id_arr)
        values_valence = [values_valence; values_valence_all(part_id_arr == i)];
        values_arousal = [values_arousal; values_arousal_all(part_id_arr == i)];
    end
    
    % Delete rows 17 and 18
    values_valence = values_valence(:, [1:16, 19:40]);
    values_arousal = values_arousal(:, [1:16, 19:40]);
    
    mos_values_valence = mean(values_valence);
    mos_values_arousal = mean(values_arousal);
    
    % Valence and arousal should be either 0 or 1
    nn_2dmos = [];
    for i=1:length(mos_values_valence)
        valence = 0;
        if (mos_values_valence(i) < 5)
            valence = 1;
        end
        arousal = 0;
        if (mos_values_arousal(i) < 5)
            arousal = 1;
        end
        nn_2dmos = [nn_2dmos, [valence; arousal]];
    end
    
    
    output_mos = [];  %ones(2,size(output_full,2)); %2D
    f = feats_per_song(1);  % in DEAP, all features have the same size, 50 for train
    for i=1:number_items
        output_mos = [output_mos, nn_2dmos(:,i).*ones(2, f)];
    end
    
    %%----------------END difference from Lindsey file---------------------
    
    output_T = sum(output_full(1:10,:))/10;
	output_L = sum(output_full(11:20,:))/10;
	output_R = sum(output_full(21:30,:))/10;
	output_TLR = [output_T; output_L; output_R];
    
    %%Output output_framed_original_equivalent = song_data;
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
    load(strcat([visual_feat_path, 'feature_dataset_deap_125_v7']));        %% feature 
    input_full = [];
    for i=1:size(Feature_train,3)
        input_full = [input_full, Feature_train(:,1:feats_per_song(num_sort(i)),num_sort(i))];
    end
    input_mos = output_mos;
    
    input_H = max(input_full(1:3,:)); %sum(input(1:3,:))/3;
	input_S = max(input_full(4:6,:));
	input_L = max(input_full(7:9,:));
	input_HSL = [input_H; input_S; input_L];
        
    
    %If you prefer the negative emotion to be 0 instead of -1
    for i=1:length(input_mos)
        if (input_mos(i) == -1)
            input_mos(i) = 0;
        end
    end
    
    input_HSL = input_HSL./max(max(input_HSL));
    input_full = input_full(1:9,:);
    input_full = input_full./max(max(input_full));
    
    
    input_mos_num = getBin2Num_2dmos( input_mos );
    output_mos_num = getBin2Num_2dmos( output_mos );

end

