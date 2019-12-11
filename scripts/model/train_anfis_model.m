function [out_fis_train, trnerr, ss, fismat2, chkerr] = train_anfis_model(Xin, Xout, data_type, plot_learning_curve)
%Train ANFIS
%   data_type = HSL or TLR (to save the model with the proper name)
%

    global model_anfis_save_path emotion_dim mftype numepochs nummfs;
    
    trndata = [Xin, Xout];
    chkdata = trndata;
    
    %Genfis2
    %fismat_HSL = genfis2(Xin_HSL,Xout_HSL,0.5);
    %Genfis3
    %fismat_HSL = genfis3(Xin_HSL,Xout_HSL,'sugeno',4) 
    %Genfis1 -> use only if it's NOT input_full
    fismat = genfis1(trndata, nummfs, mftype);  % Requires Fuzzy Logic Toolbox

    [out_fis_train, trnerr, ss, fismat2, chkerr]= anfis(trndata, fismat, numepochs, NaN, chkdata);

    anfis_model_name = strcat([model_anfis_save_path, 'fuzzy_anfis_', data_type, '_', emotion_dim, 'mos_', num2str(nummfs), 'mfs_ep', num2str(numepochs)]);
    save(anfis_model_name, 'out_fis_train', 'trnerr', 'numepochs', 'fismat', 'mftype');
    
    
    % Anfis - Learning Curve Plot
    if plot_learning_curve
        clear plot;
        ct = 1:numepochs;
        plot(ct,trnerr','b*'); grid on;
        xlabel('Epochs');
        ylabel('Training Error');
        title('Learning Curve');

        figure('name', 'genfis1', 'numbertitle', 'off');
        NumInput = size(trndata, 2) - 1;
        for i = 1:NumInput
            subplot(NumInput, 1, i);
            plotmf(fismat, 'input', i);
            xlabel(['input ' num2str(i) ' (' mftype ')']);
        end
    end

end

