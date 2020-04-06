%
% Loads data with 2D emotion score
%
% Gwena Cunha
%

%% 1. Obtain dataset
plot_bool = 0;
emotion_mapping = containers.Map;

if strcmp(dataset_name, 'cognimuse')
    % 4 emotions = {NegHigh: 0, NegLow: 1, PosLow: 2, PosHigh: 3}
    filename_csv = 'intended_1_2D_splices_3secs.csv';
    [input_HSL, output_TLR, output_audio_equivalent, input_mos_num, output_mos_num, input_full, output_full] = getIO_HSL_TLR_equivAudio_MOS_cognimuse(visual_feat_path, sound_feat_path, filename_csv);
    
    emotion_mapping('pos_high') = 3; emotion_mapping('pos_low') = 2;
    emotion_mapping('neg_high') = 0; emotion_mapping('neg_low') = 1;
else
    if strcmp(dataset_name, 'lindsey')
        [input_HSL, output_TLR, output_audio_equivalent, input_mos, output_mos, input_mos_num, output_mos_num, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS(plot_bool, visual_feat_path, sound_feat_path);
    else  % deap
        [input_HSL, output_TLR, output_audio_equivalent, input_mos, output_mos, input_mos_num, output_mos_num, input_full, output_full, mos_values_valence, mos_values_arousal, std_values_valence, std_values_arousal] = getIO_HSL_TLR_equivAudio_2DMOS_deap(visual_feat_path, sound_feat_path);
    end
    
    % 1: +H, 2: +l, 3: -H, 4: -l
    emotion_mapping('pos_high') = 1; emotion_mapping('pos_low') = 2;
    emotion_mapping('neg_high') = 3; emotion_mapping('neg_low') = 4;
end


%% 2. Check how many video excerpts in each class (used in ANFIS and Seq2Seq)
if strcmp(dataset_name, 'cognimuse')
    class1_total = sum(input_mos_num == emotion_mapping('pos_high'))
    class2_total = sum(input_mos_num == emotion_mapping('pos_low'))
    class3_total = sum(input_mos_num == emotion_mapping('neg_high'))
    class4_total = sum(input_mos_num == emotion_mapping('neg_low'))
else
    class1_in = [];
    class2_in = [];
    class3_in = [];
    class4_in = [];
    for i=1:size(input_mos_num,2)
        switch input_mos_num(i)
            case 1
                class1_in = [class1_in, input_mos(:,i)];
            case 2
                class2_in = [class2_in, input_mos(:,i)];
            case 3
                class3_in = [class3_in, input_mos(:,i)];
            case 4
                class4_in = [class4_in, input_mos(:,i)];
            otherwise
                break;
        end
    end
    class1_total = sum(size(class1_in, 2))
    class2_total = sum(size(class2_in, 2))
    class3_total = sum(size(class3_in, 2))
    class4_total = sum(size(class4_in, 2))
end

%% 3. Divide dataset for Seq2Seq model (I-O Networks)
%%Separates + (H and l) from - (H and l) -> 4 groups

input_HSL_dict = containers.Map;
input_HSL_dict('pos_high') = []; input_HSL_dict('pos_low') = [];
input_HSL_dict('neg_high') = []; input_HSL_dict('neg_low') = [];

output_TLR_dict = containers.Map;
output_TLR_dict('pos_high') = []; output_TLR_dict('pos_low') = [];
output_TLR_dict('neg_high') = []; output_TLR_dict('neg_low') = [];

output_audio_equivalent_dict = containers.Map;
output_audio_equivalent_dict('pos_high') = []; output_audio_equivalent_dict('pos_low') = [];
output_audio_equivalent_dict('neg_high') = []; output_audio_equivalent_dict('neg_low') = [];

% 1: +H, 2: +l, 3: -H, 4: -l
for i=1:size(input_HSL,2)
    i
    if (input_mos_num(i) == emotion_mapping('pos_high')) %+H
        input_HSL_dict('pos_high') = [input_HSL_dict('pos_high'), input_HSL(:,i)];
        output_TLR_dict('pos_high') = [output_TLR_dict('pos_high'), output_TLR(:,i)];
        output_audio_equivalent_dict('pos_high') = [output_audio_equivalent_dict('pos_high'), output_audio_equivalent(:,i)];
    else %+l
        if (input_mos_num(i) == emotion_mapping('pos_low')) %+l
            input_HSL_dict('pos_low') = [input_HSL_dict('pos_low'), input_HSL(:,i)];
            output_TLR_dict('pos_low') = [output_TLR_dict('pos_low'), output_TLR(:,i)];
            output_audio_equivalent_dict('pos_low') = [output_audio_equivalent_dict('pos_low'), output_audio_equivalent(:,i)];
        else
            if (input_mos_num(i) == emotion_mapping('neg_high')) %-H
                input_HSL_dict('neg_high') = [input_HSL_dict('neg_high'), input_HSL(:,i)];
                output_TLR_dict('neg_high') = [output_TLR_dict('neg_high'), output_TLR(:,i)];
                output_audio_equivalent_dict('neg_high') = [output_audio_equivalent_dict('neg_high'), output_audio_equivalent(:,i)];
            else %-l -> 4
                input_HSL_dict('neg_low') = [input_HSL_dict('neg_low'), input_HSL(:,i)];
                output_TLR_dict('neg_low') = [output_TLR_dict('neg_low'), output_TLR(:,i)];
                output_audio_equivalent_dict('neg_low') = [output_audio_equivalent_dict('neg_low'), output_audio_equivalent(:,i)];
            end
        end
    end
end

save(strcat([root_save, 'model_data_train_2D_v73.mat']), 'input_HSL_dict', 'output_TLR_dict', 'output_audio_equivalent_dict', 'input_mos_num', '-v7.3');