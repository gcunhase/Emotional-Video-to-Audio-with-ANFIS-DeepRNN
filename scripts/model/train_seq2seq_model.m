function [net] = train_seq2seq_model(X_temp, T_temp, model_type, path_to_model, miniBatchSize, maxEpochs)

    if strcmp(model_type, 'rnn')
        %net1_in_out_pos = layrecnet(1:3,[6 12]);
        net = layrecnet(1:3,12);
        [Xs,Xi,Ai,Ts] = preparets(net, X_temp, T_temp);
        [net, tr_rnn] = train(net,Xs,Ts,Xi,Ai);
    else  % lstm
        inputSize = 3; %1;
        outputSize = 3;  %10;
        outputMode = 'sequence'; % last 'sequence' 
        % numClasses = 3;
        layers = [ ...
            sequenceInputLayer(inputSize)
            lstmLayer(outputSize,'OutputMode',outputMode)
            %fullyConnectedLayer(numClasses)
            %softmaxLayer
            %classificationLayer
            regressionLayer
            ];

        options = trainingOptions('sgdm', ...
            'MaxEpochs',maxEpochs, ...
            'MiniBatchSize',miniBatchSize);

        net = trainNetwork(X_temp,T_temp,layers,options);
    end
    
    save(path_to_model, 'net', '-v7');  % , 'tr_rnn', '-v7');

end

