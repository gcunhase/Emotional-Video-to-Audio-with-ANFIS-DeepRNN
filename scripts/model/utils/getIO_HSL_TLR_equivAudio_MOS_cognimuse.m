%%Also return equivalent audio
%
% Gwena Cunha
%

function [ input_HSL_all, output_TLR_all, output_audio_equivalent_all, input_mos_num_all, output_mos_num_all, input_full_all, output_full_all ] = getIO_HSL_TLR_equivAudio_2DMOS_cognimuse( visual_feat_path, sound_feat_path, filename_csv )
%function [ clip_struct_all ] = getIO_HSL_TLR_equivAudio_2DMOS_cognimuse( visual_feat_path, sound_feat_path )
    
    format long;
    input_HSL_all = []; output_TLR_all = [];
    output_audio_equivalent_all = [];
	input_mos_num_all = []; output_mos_num_all = [];
	input_full_all = []; output_full_all = [];

    list_of_clip_names = {'BMI', 'CHI', 'FNE', 'GLA', 'LOR'};
    %clip_struct_all = [];
    num_samples_total = 0;
    for clip_names=list_of_clip_names
        clip_name = clip_names{1};
        load(strcat([visual_feat_path, 'number_of_sort_dataset_cognimuse_', clip_name, '_10_v7']));  % num_sort, number_items
        load(strcat([visual_feat_path, 'feature_dataset_cognimuse_', clip_name, '_10_v7']));  % Feature_train, clip_struct
        load(strcat([sound_feat_path, 'sound_features_dataset2_cognimuse_', clip_name, '_size10_v7_raw']));  % 
        num_samples_total = num_samples_total + clip_struct.size;
        %clip_struct.num_sort = num_sort;
        %clip_struct.number_items = number_items
        %clip_struct.visual_feats = Feature_train;
        %clip_struct.sound_feats = sound_feat;
        %clip_struct.song_data = song_data;
        %clip_struct_all = [clip_struct_all, clip_struct];

        %%%%%%% Output: sound %%%%%%%
        output_full = [];
        output_song_equivalent = [];
        size_feat = size(sound_feat{1, 1}{1, 1}, 1)  % 10
        train_feature_target = [];
        size(feats_per_song)
        for i=1:size(feats_per_song,2)
            vec = cell2mat(sound_feat{num_sort(i)});
            vec_tmp = reshape(vec, size_feat*3,size(sound_feat{num_sort(i)},2));
            output_full = [output_full, vec_tmp];

            tmp = cell2mat(song_data(num_sort(i)));
            output_song_equivalent = [output_song_equivalent, tmp(1:44000,:)];
        end

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

        %%%%%%% Input - Visual %%%%%%%
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

        %%%%%%% Output - Emotion %%%%%%%
        % Output considering MOS csv_file
        filename = strcat(['dataset/cognimuse dataset/', clip_name, '/emotion/']);
        if (nargin < 3)
            filename = strcat([filename, 'intended_1_2D_splices_3secs.csv']);
        else
            filename = strcat([filename, filename_csv]);
        end
        [~, values_dict] = tsvreadGoogleForm_cognimuse(filename);
        
        output_mos = values_dict('emotion');
        output_mos = output_mos(num_sort);
        
        output_mos_num = [];  %ones(2,size(output_full,2)); %2D
        f = feats_per_song(1);  % in COGNIMUSE, all features have the same size, 3 for train
        for i=1:number_items
            output_mos_num = [output_mos_num, output_mos(i).*ones(1, f)];
        end
        input_mos_num = output_mos_num;

        % Sum of samples from BMI, CHI, ... = X
        % 3*x -> 3 seconds * X
        input_HSL_all = [input_HSL_all, input_HSL];  % (3, 3*X)
        output_TLR_all = [output_TLR_all, output_TLR]; % (3, 3*X)
        output_audio_equivalent_all = [output_audio_equivalent_all, output_audio_equivalent];  % (44100, 3*X)
        input_mos_num_all = [input_mos_num_all, input_mos_num];  % (1, 3*X)
        output_mos_num_all = [output_mos_num_all, output_mos_num];  % (1, 3*X)
        input_full_all = [input_full_all, input_full];  % (9, 3*X)
        output_full_all = [output_full_all, output_full];  % (30, 3*X)

    end

    % TODO: Shuffle final array - Should be done in groups of 3
    %[A num_sort] = sort(rand(1,n_videos));
    %train_num = num_sort(1:n_videos);

end

