%Gwena Cunha
% Code for ANFIS separated from full code on December 9th 2019

%% Anfis - Image (HSL) - load variables
Xin_HSL = input_HSL'; %input_full';
Xout_HSL = input_2dmos_num';
trndata_HSL = [Xin_HSL, Xout_HSL];
chkdata_HSL = trndata_HSL;
%Genfis2
%fismat_HSL = genfis2(Xin_HSL,Xout_HSL,0.5);

%Genfis3
%fismat_HSL = genfis3(Xin_HSL,Xout_HSL,'sugeno',4) 


%Genfis1 -> use only if it's NOT input_full
nummfs_HSL = 4; % number of membership functions
mftype_HSL = 'gbellmf'; % membership functions type is generalized bell
%mftype_HSL = 'gaussmf'; % membership functions type is generalized bell
fismat_HSL = genfis1(trndata_HSL,nummfs_HSL,mftype_HSL);  % Requires Fuzzy Logic Toolbox

%Start the optimization - ANFIS
numepochs_HSL = 4000; 
%epochs 4000, perf 73.644859813084111


%%-------- Anfis - Image (HSL) - SAVE ---------
[out_fis_train_HSL, trnerr_HSL, ss_HSL, fismat2_HSL, chkerr_HSL]= ...
anfis(trndata_HSL, fismat_HSL, numepochs_HSL, NaN, chkdata_HSL);

save(strcat([model_anfis_save_path, 'fuzzy_anfis_HSL_', emotion_dim, 'mos_4mfs_ep', num2str(numepochs_HSL)]), 'out_fis_train_HSL', 'trnerr_HSL', 'numepochs_HSL', 'fismat_HSL', 'mftype_HSL');


%%-------- Anfis - Image (HSL) - LOAD ---------
load(strcat([model_anfis_save_path, 'fuzzy_anfis_HSL_', emotion_dim, 'mos_4mfs_ep', num2str(numepochs_HSL)]));
out_HSL=evalfis(Xin_HSL,out_fis_train_HSL); % Evaluates the output of the fuzzy system out_fis_train - input checking
out_HSL_round = round(out_HSL);
perf_HSL = 100*(sum(out_HSL_round == Xout_HSL))/length(out_HSL_round)


%%-------- Anfis - Image (HSL) - Learning Curve Plot ---------
clear plot;
ct_HSL = 1:numepochs_HSL;
plot(ct_HSL,trnerr_HSL','b*'); grid on;
xlabel('Epochs');
ylabel('Training Error');
title('Learning Curve');
    
figure('name', 'genfis1', 'numbertitle', 'off');
NumInput = size(trndata_HSL, 2) - 1;
for i = 1:NumInput;
    subplot(NumInput, 1, i);
    plotmf(fismat_HSL, 'input', i);
    xlabel(['input ' num2str(i) ' (' mftype_HSL ')']);
end

plot_HSL = 1;
if (plot_HSL)
    figure('name', 'HSL original');
    hold on; grid on;
    for i=1:length(input_2dmos_num)
        if (input_2dmos_num(i) == 1) %+H
            plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'r*');
        else
            if (input_2dmos_num(i) == 2) %+l
                plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'g*');
            else
                if (input_2dmos_num(i) == 3) %-H
                    plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'c*');
                else %-l
                    plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'b*');
                end
            end
        end
    end
    xlabel('Hue');
    ylabel('Saturation');
    zlabel('Lightness');

    figure('name', 'HSL estimated');
    hold on; grid on;
    for i=1:length(out_HSL_round)
        if (out_HSL_round(i) == 1) %+H
            plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'r*');
        else
            if (out_HSL_round(i) == 2) %+l
                plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'g*');
            else
                if (out_HSL_round(i) == 3) %-H
                    plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'c*');
                else %-l
                    plot3(input_HSL(1,i), input_HSL(2,i), input_HSL(3,i), 'b*');
                end
            end
        end
    end
    xlabel('Hue');
    ylabel('Saturation');
    zlabel('Lightness');
end


%% HSL Feature visualization
%%-------- After loading previous subsection, apply t-SNE to HSL 3D graph ---------
X = input_HSL(1:3,:)';

% Original paper:
[Y, loss] = tsne(X);

% Test with different parameters:
%options.MaxIter = 10000;
%options.TolFun = 1e-10;
%options.OutputFcn = [];
%[Y, loss] = tsne(X, 'LearnRate', 500, 'Verbose', 1, 'Options', options);  % The loss is measured by the Kullback-Leibler divergence between the joint distributions of X and Y.

disp(strcat(['loss: ', num2str(loss)]));
%figure
%gscatter(Y(:,1),Y(:,2));
%gscatter(Y(:,1),Y(:,2),input_2dmos_num);

plot_HSL = 1;
hsl_target_tsne_score_1 = []; hsl_target_tsne_score_2 = []; hsl_target_tsne_score_3 = []; hsl_target_tsne_score_4 = [];
hsl_estimated_tsne_score_1 = []; hsl_estimated_tsne_score_2 = []; hsl_estimated_tsne_score_3 = []; hsl_estimated_tsne_score_4 = [];
if (plot_HSL)
    figure('name', 'HSL original - t-SNE');
    hold on; grid on;
    for i=1:length(input_2dmos_num)
        if (input_2dmos_num(i) == 1) %+H
            hsl_target_tsne_score_1 = [hsl_target_tsne_score_1, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'r.');
        else
            if (input_2dmos_num(i) == 2) %+l
                hsl_target_tsne_score_2 = [hsl_target_tsne_score_2, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'g.');
            else
                if (input_2dmos_num(i) == 3) %-H
                    hsl_target_tsne_score_3 = [hsl_target_tsne_score_3, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'c.');
                else %-l
                    hsl_target_tsne_score_4 = [hsl_target_tsne_score_4, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'b.');
                end
            end
        end
    end
    plot(hsl_target_tsne_score_1(1,:), hsl_target_tsne_score_1(2,:), 'r*', 'MarkerSize', tsne_marker_size);
    plot(hsl_target_tsne_score_2(1,:), hsl_target_tsne_score_2(2,:), 'g*', 'MarkerSize', tsne_marker_size);
    plot(hsl_target_tsne_score_3(1,:), hsl_target_tsne_score_3(2,:), 'c*', 'MarkerSize', tsne_marker_size);
    plot(hsl_target_tsne_score_4(1,:), hsl_target_tsne_score_4(2,:), 'b*', 'MarkerSize', tsne_marker_size);
    title('HSL original - t-SNE');
    xlabel('1st dimension');
    ylabel('2nd dimension');
    legend({'Positive High', 'Positive Low', 'Negative High', 'Negative Low'});
    
    figure('name', 'HSL estimated - t-SNE');
    hold on; grid on;
    for i=1:length(out_HSL_round)
        if (out_HSL_round(i) == 1) %+H
            hsl_estimated_tsne_score_1 = [hsl_estimated_tsne_score_1, [Y(i,1); Y(i,2)]]; %plot(Y(i,1), Y(i,2), 'r.');
        else
            if (out_HSL_round(i) == 2) %+l
                hsl_estimated_tsne_score_2 = [hsl_estimated_tsne_score_2, [Y(i,1); Y(i,2)]]; %plot(Y(i,1), Y(i,2), 'g.');
            else
                if (out_HSL_round(i) == 3) %-H
                    hsl_estimated_tsne_score_3 = [hsl_estimated_tsne_score_3, [Y(i,1); Y(i,2)]]; %plot(Y(i,1), Y(i,2), 'c.');
                else %-l
                    hsl_estimated_tsne_score_4 = [hsl_estimated_tsne_score_4, [Y(i,1); Y(i,2)]]; %plot(Y(i,1), Y(i,2), 'b.');
                end
            end
        end
    end
    plot(hsl_estimated_tsne_score_1(1,:), hsl_estimated_tsne_score_1(2,:), 'r*', 'MarkerSize', tsne_marker_size);
    plot(hsl_estimated_tsne_score_2(1,:), hsl_estimated_tsne_score_2(2,:), 'g*', 'MarkerSize', tsne_marker_size);
    plot(hsl_estimated_tsne_score_3(1,:), hsl_estimated_tsne_score_3(2,:), 'c*', 'MarkerSize', tsne_marker_size);
    plot(hsl_estimated_tsne_score_4(1,:), hsl_estimated_tsne_score_4(2,:), 'b*', 'MarkerSize', tsne_marker_size);
    title('HSL estimated - t-SNE');
    xlabel('1st dimension');
    ylabel('2nd dimension');
    legend({'Positive High', 'Positive Low', 'Negative High', 'Negative Low'});
end


% %% -------- After loading previous subsection, apply PCA to HSL 3D graph ---------
% %%%%%%%%%%%%%%%%%%%% THIS SECTION IS NOT USED %%%%%%%%%%%%%%%%%%%%%%%%
% % t-SNE is chosen as disply method instead of PCA
% 
% [coeff,score,latent,tsquared,explained] = pca(input_HSL(1:3,:)');
% explained
% 
% bar(explained); grid on; hold on;
% xlabel('Principal Components');
% ylabel('Percent Variability');
% title('Percent Variability per Principal Component');
% 
% %plot(score(:,1),score(:,2), '*');
% %figure, plot(score(:,1),score(:,2), '*');
% %xlabel('1st Principal Component');
% %ylabel('2nd Principal Component');
% 
% 
% plot_HSL = 1;
% hsl_target_pca_score_1 = []; hsl_target_pca_score_2 = []; hsl_target_pca_score_3 = []; hsl_target_pca_score_4 = [];
% hsl_estimated_pca_score_1 = []; hsl_estimated_pca_score_2 = []; hsl_estimated_pca_score_3 = []; hsl_estimated_pca_score_4 = [];
% if (plot_HSL)
%     figure('name', 'HSL original - PCA');
%     hold on; grid on;
%     for i=1:length(input_2dmos_num)
%         if (input_2dmos_num(i) == 1) %+H
%             hsl_target_pca_score_1 = [hsl_target_pca_score_1, [score(i,1); score(i,2)]]; %'r*'
%         else
%             if (input_2dmos_num(i) == 2) %+l
%                 hsl_target_pca_score_2 = [hsl_target_pca_score_2, [score(i,1); score(i,2)]]; %'g*'
%             else
%                 if (input_2dmos_num(i) == 3) %-H
%                     hsl_target_pca_score_3 = [hsl_target_pca_score_3, [score(i,1); score(i,2)]]; %'c*'
%                 else %-l
%                     hsl_target_pca_score_4 = [hsl_target_pca_score_4, [score(i,1); score(i,2)]]; %'b*'
%                 end
%             end
%         end
%     end
%     title('HSL original - PCA');
%     plot(hsl_target_pca_score_1(1,:), hsl_target_pca_score_1(2,:), 'r*');
%     plot(hsl_target_pca_score_2(1,:), hsl_target_pca_score_2(2,:), 'g*');
%     plot(hsl_target_pca_score_3(1,:), hsl_target_pca_score_3(2,:), 'c*');
%     plot(hsl_target_pca_score_4(1,:), hsl_target_pca_score_4(2,:), 'b*');
%     xlabel('1st Principal Component');
%     ylabel('2nd Principal Component');
% 
%     figure('name', 'HSL estimated - PCA');
%     hold on; grid on;
%     for i=1:length(out_HSL_round)
%         if (out_HSL_round(i) == 1) %+H
%             plot(score(i,1), score(i,2), 'r*');
%         else
%             if (out_HSL_round(i) == 2) %+l
%                 plot(score(i,1), score(i,2), 'g*');
%             else
%                 if (out_HSL_round(i) == 3) %-H
%                     plot(score(i,1), score(i,2), 'c*');
%                 else %-l
%                     plot(score(i,1), score(i,2), 'b*');
%                 end
%             end
%         end
%     end
%     title('HSL estimated - PCA');
%     xlabel('1st Principal Component');
%     ylabel('2nd Principal Component');
% end
% %%%%%%%%%%%%%%%%%%%% END OF PCA SECTION %%%%%%%%%%%%%%%%%%%%%%%%

%% Anfis - Sound (TLR) - load variables
% No need to train ANFIS with sound features for the model to work, only
% HSL is necessary

Xin = output_TLR';
Xout = output_2dmos_num'; %output_full';
trndata = [Xin, Xout];
chkdata = trndata;

%Genfis2
%fismat = genfis2(Xin,Xout,0.5);

%Genfis1 -> use only if it's NOT input_full
nummfs = 4; % number of membership functions
mftype = 'gbellmf'; % membership functions type is generalized bell
fismat = genfis1(trndata,nummfs,mftype);

%Start the optimization - ANFIS
numepochs = 4000;
%epochs 4000, perf 80%


%%--------- Anfis - Sound (TLR) - SAVE ---------
[out_fis_train, trnerr, ss, fismat2, chkerr]= ...
anfis(trndata, fismat, numepochs, NaN, chkdata);

save(strcat([model_anfis_save_path, 'fuzzy_anfis_TLR_', emotion_dim, 'mos_4mfs_Dec2019_ep', num2str(numepochs_HSL)]), 'out_fis_train', 'trnerr', 'numepochs');


%%--------- Anfis - Sound (TLR) - LOAD ---------
load(strcat([model_anfis_save_path, 'fuzzy_anfis_TLR_', emotion_dim, 'mos_4mfs_Dec2019_ep', num2str(numepochs_HSL)]));

out=evalfis(Xin,out_fis_train);% Evaluates the output of the fuzzy system out_fis_train - input checking
out_round = round(out);
perf = 100*(sum(out_round == Xout))/length(out_round)
