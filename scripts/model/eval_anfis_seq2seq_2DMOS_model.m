function [out_final, final_audio_reshaped, audio_filename, predicted_audio_filename] = eval_anfis_seq2seq_2DMOS_model(Xin_HSL_test, Xout_HSL_test, TLR_database, audio_database, audio_filename)
%Evaluate full model ANFIS-Seq2Seq
%   Given a set of visual features, generate music
%   Look up table: TLR_database and audio_database (also named: output_TLR
%   and output_audio_equivalent)

    global results_path model_anfis_save_path model_seq2seq_save_path model_type emotion_dim;

    load(strcat([model_anfis_save_path, 'fuzzy_anfis_HSL_', emotion_dim, 'mos_4mfs_ep4000']));
    load(strcat([model_anfis_save_path, 'fuzzy_anfis_TLR_', emotion_dim, 'mos_4mfs_ep4000']));

    path_to_model_pos_high = strcat([model_seq2seq_save_path, 'net_', model_type, '_pos_high_', emotion_dim, 'mos_12']);
    path_to_model_pos_low = strcat([model_seq2seq_save_path, 'net_', model_type, '_pos_low_', emotion_dim, 'mos_12']);
    path_to_model_neg_high = strcat([model_seq2seq_save_path, 'net_', model_type, '_neg_high_', emotion_dim, 'mos_12']);
    path_to_model_neg_low = strcat([model_seq2seq_save_path, 'net_', model_type, '_neg_low_', emotion_dim, 'mos_12']);

    X_temp_test = con2seq(Xin_HSL_test');
    T_temp_test = con2seq(Xout_HSL_test');
    out_final = [];
    for i=1:size(Xin_HSL_test, 1)-3
        % Evaluates the output of the fuzzy system out_fis_train - input checking
        out_HSL_test=evalfis(out_fis_train_HSL, Xin_HSL_test(i,:)); 
        out_HSL_test_round = round(out_HSL_test);

        % Select appropriate Seq2Seq model based on predicted emotion scores
        if (out_HSL_test_round == 1) %+H  %input_2dmos_num(i)
            out_tmp = test_seq2seq_model(X_temp_test(i:i+3), T_temp_test(i:i+3), path_to_model_pos_high);
        else 
            if (out_HSL_test_round == 2) %+l
                out_tmp = test_seq2seq_model(X_temp_test(i:i+3), T_temp_test(i:i+3), path_to_model_pos_low);
            else 
                if (out_HSL_test_round == 3) %-H
                    out_tmp = test_seq2seq_model(X_temp_test(i:i+3), T_temp_test(i:i+3), path_to_model_neg_high);
                else %-l
                    out_tmp = test_seq2seq_model(X_temp_test(i:i+3), T_temp_test(i:i+3), path_to_model_neg_low);
                end
            end
        end
        
        % Concatenate generated audio features to final array of audio features
        out_final = [out_final, out_tmp];
    end
    
    % Obtain audios from sound features in order to obtain the final predicted audio
    if (nargin < 5)
        audio_filename = strcat([results_path, 'testVideo_fuzzy_', model_type, '_', emotion_dim, 'mos']);  % filename = 'testVideo_fuzzy_rnn_2dmos_trainData';
    end
    predicted_audio_filename = strcat([audio_filename, '_predicted']);

    %getFinalAudio2(out_final, filename, output_TLR, output_audio_equivalent);
    final_audio_reshaped = getFinalAudio2_doubleCorrelation(out_final, predicted_audio_filename, TLR_database, audio_database);
    
end

