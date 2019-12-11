function [X_temp, T_temp] = format_data_for_seq2seq_model(X, T, model_type)

    if strcmp(model_type, 'rnn')
        X_temp = con2seq(X);
        T_temp = con2seq(T);
    else  % lstm
        %http://stackoverflow.com/questions/10080079/index-exceeds-matrix-dimensions-neural-network-function-error
        X_temp = con2seq(X);
        T_temp = con2seq(T);
        
        %X_temp1 = con2seq(X)';
        %X_temp = [];
        %for i=1:length(X_temp1)
        %    X_temp = [X_temp, {X_temp1{i}'}];
        %end
        %X_temp = X_temp';
        %%T_temp = ones(1,length(X_temp))';
        %%T_temp = categorical(T_temp);
        %T_temp1 = con2seq(T)';
        %T_temp = [];
        %for i=1:length(T_temp1)
        %    T_temp = [T_temp, {T_temp1{i}'}];
        %end
        %T_temp = T_temp';
    end

end

