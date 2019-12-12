%Gwena Cunha
% Added Deep Network on Decmber 11th 2019

%% 1. Obtain dataset
plot_bool = 0;
if strcmp(dataset_name, 'lindsey')
    % [input_HSL, output_TLR, output_audio_equivalent, input_mos_num, output_mos_num, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS(plot_bool, visual_feat_path, sound_feat_path);
    [input_HSL, output_TLR, output_audio_equivalent, input_2dmos, output_2dmos, ~, ~, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS(plot_bool, visual_feat_path, sound_feat_path);
else  % deap
    [input_HSL, output_TLR, output_audio_equivalent, input_2dmos, output_2dmos, ~, ~, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS_deap( visual_feat_path, sound_feat_path);
end

% 1: +H, 2: +l, 3: -H, 4: -l
% input_2dmos -> line 1 is valence, line 2 is arousal
input_mos_num = input_2dmos(1, :);
output_mos_num = output_2dmos(1, :);


%% 2. Check how many video excerpts in each class (used in ANFIS and Seq2Seq)
class1_total = sum(input_mos_num == 1);
class2_total = sum(input_mos_num == 0);


%% 3. Divide dataset for Seq2Seq model (I-O Networks)
%%Separates + (H and l) from - (H and l) -> 4 groups

input_HSL_dict = containers.Map;
input_HSL_dict('pos') = []; input_HSL_dict('neg') = [];

output_TLR_dict = containers.Map;
output_TLR_dict('pos') = []; output_TLR_dict('neg') = [];

output_audio_equivalent_dict = containers.Map;
output_audio_equivalent_dict('pos') = []; output_audio_equivalent_dict('neg') = [];

for i=1:size(input_HSL,2)
    if (input_mos_num(i) == 1) % +
        input_HSL_dict('pos') = [input_HSL_dict('pos'), input_HSL(:,i)];
        output_TLR_dict('pos') = [output_TLR_dict('pos'), output_TLR(:,i)];
        output_audio_equivalent_dict('pos') = [output_audio_equivalent_dict('pos'), output_audio_equivalent(:,i)];
    else % -
        input_HSL_dict('neg') = [input_HSL_dict('neg'), input_HSL(:,i)];
        output_TLR_dict('neg') = [output_TLR_dict('neg'), output_TLR(:,i)];
        output_audio_equivalent_dict('neg') = [output_audio_equivalent_dict('neg'), output_audio_equivalent(:,i)];
    end
end
