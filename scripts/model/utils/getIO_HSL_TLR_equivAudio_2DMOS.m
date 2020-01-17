%%Also return equivalent audio
%
% Gwena Cunha
%

function [ input_HSL, output_TLR, output_audio_equivalent, input_mos, output_mos, input_mos_num, output_mos_num, input_full, output_full ] = getIO_HSL_TLR_equivAudio_2DMOS( plot, visual_feat_path, sound_feat_path, filename )
    
    format long;
    % root_save = 'saved_mats/lindsey/';
    load(strcat([visual_feat_path, 'number_of_sort_dataset2_correct_lindsey_500_v7'])); %% random���� selection �� ����
    load(strcat([sound_feat_path, 'sound_features_dataset2_lindsey_size10_v7_raw']));
    
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
    
    %% Output considering MOS from 5 Lab Members
    %1=positive, -1=negative
    if (nargin < 4)
        filename = 'dataset/lindsey stirling dataset/user_response_iconip16.tsv';
    end
    values = tsvreadGoogleForm(filename);
    mos_values = mean(values,2);
    mos_values_valence = mos_values(1:2:end);
    mos_values_arousal = mos_values(2:2:end);
    %9: most negative, 1: most positive
    %plot(mos_values_valence, mos_values_arousal, '*'); grid on;
    %^Opposite -> 1: most negative, 9: most positive
    %plot(10-mos_values_valence, 10-mos_values_arousal, '*'); grid on;
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
    mos_values = [10-mos_values_valence, 10-mos_values_arousal];
    
    feats_per_song = [200, 200, 225, 200, 180, 200, 200, 200];%, 210];
    output_mos = ones(2,size(output_full,2)); %2D
    %8: Roundtable Rival
    idx = feats_per_song(8);
    output_mos(:,1:idx) = [nn_2dmos(1,1)*ones(1,idx); nn_2dmos(2,1)*ones(1,idx)];
    %1: Beyond The Veil %%%%%MIX - OKAY
    i = feats_per_song(1); %i=200
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx_old+20) = [nn_2dmos(1,2)*ones(1,20); nn_2dmos(2,2)*ones(1,20)];
    output_mos(:,idx_old+21:idx_old+36) = [nn_2dmos(1,3)*ones(1,16); nn_2dmos(2,3)*ones(1,16)];%
    output_mos(:,idx_old+37:idx_old+57) = [nn_2dmos(1,4)*ones(1,21); nn_2dmos(2,4)*ones(1,21)];  %237-257
    output_mos(:,idx_old+58:idx_old+76) = [nn_2dmos(1,5)*ones(1,19); nn_2dmos(2,5)*ones(1,19)];%
    output_mos(:,idx_old+77:idx_old+134) = [nn_2dmos(1,6)*ones(1,58); nn_2dmos(2,6)*ones(1,58)];
    output_mos(:,idx_old+135:idx_old+153) = [nn_2dmos(1,7)*ones(1,19); nn_2dmos(2,7)*ones(1,19)];%
    output_mos(:,idx_old+154:idx_old+175) = [nn_2dmos(1,8)*ones(1,22); nn_2dmos(2,8)*ones(1,22)];
    output_mos(:,idx_old+176:idx_old+i) = [nn_2dmos(1,9)*ones(1,25); nn_2dmos(2,9)*ones(1,25)];%
    %7: Phantom of the Opera %%%A LITTLE BIT MIXED, mostly -1
    i = feats_per_song(7); %i=200
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx_old+36) = [nn_2dmos(1,10)*ones(1,36); nn_2dmos(2,10)*ones(1,36)];
    output_mos(:,idx_old+37:idx_old+74) = [nn_2dmos(1,11)*ones(1,38); nn_2dmos(2,11)*ones(1,38)];%  %437-474
    output_mos(:,idx_old+75:idx_old+125) = [nn_2dmos(1,12)*ones(1,51); nn_2dmos(2,12)*ones(1,51)];
    output_mos(:,idx_old+126:idx_old+133) = [nn_2dmos(1,13)*ones(1,8); nn_2dmos(2,13)*ones(1,8)];%
    output_mos(:,idx_old+134:idx_old+158) = [nn_2dmos(1,14)*ones(1,25); nn_2dmos(2,14)*ones(1,25)];
    output_mos(:,idx_old+159:idx_old+i) = [nn_2dmos(1,15)*ones(1,42); nn_2dmos(2,15)*ones(1,42)];%
    %4: Take Flight
    i = feats_per_song(4); %i=200
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx) = [nn_2dmos(1,16)*ones(1,i); nn_2dmos(2,16)*ones(1,i)];
    %2: Crystallize
    i = feats_per_song(2); %i=200
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx) = [nn_2dmos(1,17)*ones(1,i); nn_2dmos(2,17)*ones(1,i)];
    %6: Moon Trance %%%%MIX - OKAY
    i = feats_per_song(6); %i=200
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx_old+40) = [nn_2dmos(1,18)*ones(1,40); nn_2dmos(2,18)*ones(1,40)];
    output_mos(:,idx_old+41:idx_old+55) = [nn_2dmos(1,19)*ones(1,15); nn_2dmos(2,19)*ones(1,15)];%
    output_mos(:,idx_old+56:idx_old+82) = [nn_2dmos(1,20)*ones(1,27); nn_2dmos(2,20)*ones(1,27)];
    output_mos(:,idx_old+83:idx_old+108) = [nn_2dmos(1,21)*ones(1,26); nn_2dmos(2,21)*ones(1,26)];% 
    output_mos(:,idx_old+109:idx_old+121) = [nn_2dmos(1,22)*ones(1,13); nn_2dmos(2,22)*ones(1,13)];
    output_mos(:,idx_old+110:idx_old+i) = [nn_2dmos(1,23)*ones(1,i-110+1); nn_2dmos(2,23)*ones(1,i-110+1)];% %1110-1200
    %5: LOTR
    i = feats_per_song(5); %i=180
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx) = [nn_2dmos(1,24)*ones(1,i); nn_2dmos(2,24)*ones(1,i)];
    %3: Elements
    i = feats_per_song(3); %i=225
    idx_old = idx;
    idx = idx_old+i;
    output_mos(:,idx_old+1:idx) = [nn_2dmos(1,25)*ones(1,i); nn_2dmos(2,25)*ones(1,i)];
    
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
    load(strcat([visual_feat_path, 'feature_dataset2_correct_lindsey_500_v7']));        %% feature 
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
    
    %% Plotting
    if (plot)
        %Output
        hold on; grid on;
        for i=1:length(output_mos)
            if (output_mos(i) == 1) %+
                plot3(output_T(i), output_L(i), output_R(i), 'r*');
            else %-
                plot3(output_T(i), output_L(i), output_R(i), 'b*');
            end
        end
        %plot3(output_T(605:805), output_L(605:805), output_R(605:805), 'c*');
        xlabel('Tempo');
        ylabel('Loudness');
        zlabel('Rhythm');
        
        %Input
        %plot3(input_H, input_S, input_L, 'b*');
        figure('name', 'Image');
        hold on; grid on;
        for i=1:length(input_mos)
            if (input_mos(i) == 1) %+
                plot3(input_H(i), input_S(i), input_L(i), 'r*');
            else %-
                plot3(input_H(i), input_S(i), input_L(i), 'b*');
            end
        end
        xlabel('Hue');
        ylabel('Saturation');
        zlabel('Lightness');
    end

    input_mos_num = getBin2Num_2dmos( input_mos );
    output_mos_num = getBin2Num_2dmos( output_mos );

end

