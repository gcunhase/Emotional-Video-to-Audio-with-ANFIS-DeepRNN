function [X_temp, T_temp] = format_data_for_seq2seq_model(X, T)

    X_temp = con2seq(X);
    T_temp = con2seq(T);

end

