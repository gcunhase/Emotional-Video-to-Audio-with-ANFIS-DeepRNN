%
% Loads data with 2D emotion score
%
% Gwena Cunha
%

%% 1. Obtain dataset
plot_bool = 0;
if strcmp(dataset_name, 'lindsey')
    [input_HSL, output_TLR, output_audio_equivalent, input_mos, output_mos, input_mos_num, output_mos_num, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS(plot_bool, visual_feat_path, sound_feat_path);
else  % deap
    [input_HSL, output_TLR, output_audio_equivalent, input_mos, output_mos, input_mos_num, output_mos_num, input_full, output_full, mos_values_valence, mos_values_arousal, std_values_valence, std_values_arousal] = getIO_HSL_TLR_equivAudio_2DMOS_deap(visual_feat_path, sound_feat_path);
end

%% 2. Check how many video excerpts in each class (used in ANFIS and Seq2Seq)
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

for i=1:size(input_HSL,2)
    if (input_mos_num(i) == 1) %+H
        input_HSL_dict('pos_high') = [input_HSL_dict('pos_high'), input_HSL(:,i)];
        output_TLR_dict('pos_high') = [output_TLR_dict('pos_high'), output_TLR(:,i)];
        output_audio_equivalent_dict('pos_high') = [output_audio_equivalent_dict('pos_high'), output_audio_equivalent(:,i)];
    else %+l
        if (input_mos_num(i) == 2) %+l
            input_HSL_dict('pos_low') = [input_HSL_dict('pos_low'), input_HSL(:,i)];
            output_TLR_dict('pos_low') = [output_TLR_dict('pos_low'), output_TLR(:,i)];
            output_audio_equivalent_dict('pos_low') = [output_audio_equivalent_dict('pos_low'), output_audio_equivalent(:,i)];
        else
            if (input_mos_num(i) == 3) %-H
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
