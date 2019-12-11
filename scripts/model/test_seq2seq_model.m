function [T_pred_arr] = test_seq2seq_model(X_temp, T_temp, path_to_model)
%Test Seq2Seq model
%   Use this function to predict the network's output given HSL input
%   features. Evaluate the after this function with `eval_seq2seq_model.m`.

    global model_type miniBatchSize;
    
    % Load net (name of variable is `net`)
    load(path_to_model);
    
    if strcmp(model_type, 'rnn')
        % net1 = layrecnet(1:3,12);
        [Xs,Xi,Ai,Ts] = preparets(net, X_temp, T_temp);
        output_sim_in_out = net(Xs,Xi,Ai);
        T_pred_arr = seq2con(output_sim_in_out);
        T_pred_arr = T_pred_arr{1};
    else  % lstm
        %miniBatchSize = 10;
        %YPred = classify(net, X_temp, 'MiniBatchSize', miniBatchSize);
        %acc = sum(YPred == T_temp_high)./numel(T_temp_high)
        T_pred = predict(net, X_temp, 'MiniBatchSize', miniBatchSize);
        T_pred_arr = [];
        for i=1:size(T_pred,1)
            T_pred_arr = [T_pred_arr, T_pred{i}];
        end
    end

end
