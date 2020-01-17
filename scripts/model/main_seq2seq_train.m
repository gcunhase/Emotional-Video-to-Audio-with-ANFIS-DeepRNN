%
% TRAIN Domain transformation: modeling HSL visual features into TLR sound features
%
% Gwena Cunha
%

for key = keys(input_HSL_dict)
    k = key{1};
    model_type_emotion = k; % 'pos_high';
    % X = input_HSL_pos_high;
    % T = output_TLR_pos_high;
    X = input_HSL_dict(k);
    T = output_TLR_dict(k);
    
    % Setting: Path to save model
    path_to_model = strcat([model_seq2seq_save_path, 'net_', model_type, '_', model_type_emotion, '_', emotion_dim, 'mos_12']);

    % 1: format data for seq2seq
    [X_temp_emotion, T_temp_emotion] = format_data_for_seq2seq_model(X, T);

    % 2: train seq2seq
    train_seq2seq_model(X_temp_emotion, T_temp_emotion, model_type, path_to_model);

    % 3: test seq2seq (predict)
    T_pred_arr = test_seq2seq_model(X_temp_emotion, T_temp_emotion, path_to_model);
        
    % 4. eval seq2seq (MAE value and plot)
    %mae_val = eval_seq2seq_model(T_pred_arr, T, plot_in_out_pos_high, model_type_emotion)
end

