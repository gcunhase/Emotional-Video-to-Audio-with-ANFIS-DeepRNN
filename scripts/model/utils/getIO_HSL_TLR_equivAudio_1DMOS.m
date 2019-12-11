%Gwena Cunha
% Dec 11th 2019
% Also return equivalent audio

function [ input_HSL, output_TLR, output_audio_equivalent, input_mos_num, output_mos_num, input_full, output_full ] = getIO_HSL_TLR_equivAudio_1DMOS( plot, visual_feat_path, sound_feat_path )

    [input_HSL, output_TLR, output_audio_equivalent, input_2dmos, output_2dmos, ~, ~, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS(plot, visual_feat_path, sound_feat_path);
    
    % 1: +H, 2: +l, 3: -H, 4: -l
    % input_2dmos -> line 1 is valence, line 2 is arousal
    input_mos_num = input_2dmos(1, :);
    output_mos_num = output_2dmos(1, :);
    
end

