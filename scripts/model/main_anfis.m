%
% Code for ANFIS separated from full code
%
% Gwena Cunha
%

%% Anfis - Image (HSL) - load variables
data_type = 'HSL';
Xin_HSL = input_HSL'; %input_full';
Xout_HSL = input_mos_num';

%Start the optimization - ANFIS
% 2DMOS HSL: epochs 4000, perf 73.644859813084111
% 1DMOS HSL: epochs 4000, perf 89.968847352024923
% 1DMOS HSL - DEAP: epochs 4000, perf ??
% 2DMOS HSL - DEAP: epochs 4000, perf 47.842105263157897

%%-------- Anfis - Image (HSL) - SAVE ---------
[out_fis_train_HSL, trnerr_HSL, ss_HSL, fismat2_HSL, chkerr_HSL] = train_anfis_model(Xin_HSL, Xout_HSL, data_type, 1);

%%-------- Anfis - Image (HSL) - LOAD ---------
plot_data_classification = 1;
[out_HSL_round, perf_HSL] = test_anfis_model(Xin_HSL, Xout_HSL, data_type, plot_data_classification);

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
    figure('name', strcat([data_type, ' original - t-SNE']));
    hold on; grid on;
    
    
    if num_emotion == 2
        for i=1:length(input_mos_num)
            if (input_mos_num(i) == 1) %+H
                hsl_target_tsne_score_1 = [hsl_target_tsne_score_1, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'r.');
            else
                if (input_mos_num(i) == 2) %+l
                    hsl_target_tsne_score_2 = [hsl_target_tsne_score_2, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'g.');
                else
                    if (input_mos_num(i) == 3) %-H
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

    else     
     
        for i=1:length(input_mos_num)
            if (input_mos_num(i) == 1) % +
                hsl_target_tsne_score_1 = [hsl_target_tsne_score_1, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'r.');
            else  % 0
               hsl_target_tsne_score_2 = [hsl_target_tsne_score_2, [Y(i,1); Y(i,2)]]; %'r*' %plot(Y(i,1), Y(i,2), 'b.');
            end
        end
        plot(hsl_target_tsne_score_1(1,:), hsl_target_tsne_score_1(2,:), 'r*', 'MarkerSize', tsne_marker_size);
        plot(hsl_target_tsne_score_2(1,:), hsl_target_tsne_score_2(2,:), 'g*', 'MarkerSize', tsne_marker_size);
        title(strcat([data_type, ' original - t-SNE']));
        xlabel('1st dimension');
        ylabel('2nd dimension');
        legend({'Positive', 'Negative'});

        figure('name', strcat([data_type, ' estimated - t-SNE']));
        hold on; grid on;
        for i=1:length(out_HSL_round)
            if (out_HSL_round(i) == 1) %+H
                hsl_estimated_tsne_score_1 = [hsl_estimated_tsne_score_1, [Y(i,1); Y(i,2)]]; %plot(Y(i,1), Y(i,2), 'r.');
            else
                hsl_estimated_tsne_score_2 = [hsl_estimated_tsne_score_2, [Y(i,1); Y(i,2)]]; %plot(Y(i,1), Y(i,2), 'g.');  
            end
        end
        plot(hsl_estimated_tsne_score_1(1,:), hsl_estimated_tsne_score_1(2,:), 'r*', 'MarkerSize', tsne_marker_size);
        plot(hsl_estimated_tsne_score_2(1,:), hsl_estimated_tsne_score_2(2,:), 'g*', 'MarkerSize', tsne_marker_size);
        title(strcat([data_type, ' estimated - t-SNE']));
        xlabel('1st dimension');
        ylabel('2nd dimension');
        legend({'Positive', 'Negative'});
        
    end
end