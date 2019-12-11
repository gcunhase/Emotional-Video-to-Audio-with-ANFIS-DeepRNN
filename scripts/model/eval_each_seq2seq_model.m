function [mae_val] = eval_seq2seq_model(T_pred_arr, T, plot_in_out_pos_high, model_type_emotion)
%Evaluate Seq2Seq model
%   FIrst run `test_seq2seq_model.m` to obtain predicted TLR features and 
%   then use this function to evaluate the model (MAE value and plot).

    final_idx = min(size(T_pred_arr,2), size(T,2));
    mae_val = mae(T_pred_arr(1:final_idx)-T(1:final_idx));

    if (plot_in_out_pos_high)
        figure('name', strcat(['Output original: I-O Network ', model_type_emotion]));
        hold on; grid on;
        plot3(T(1,:), T(2,:), T(3,:), 'b*');
        xlabel('Tempo');
        ylabel('Loudness');
        zlabel('Rhythm');

        figure('name', strcat(['Output estimated: I-O Network ', model_type_emotion]));
        hold on; grid on;
        plot3(T_pred_arr(1,:), T_pred_arr(2,:), T_pred_arr(3,:), 'b*');
        xlabel('Tempo');
        ylabel('Loudness');
        zlabel('Rhythm');
    end

end
