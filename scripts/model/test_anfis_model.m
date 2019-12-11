function [out_round, perf] = test_anfis_model(Xin, Xout, data_type, plot_data_classification)
%Test ANFIS
%   data_type = HSL or TLR (to save the model with the proper name)
%

    global model_anfis_save_path emotion_dim numepochs nummfs num_emotion;
    
    anfis_model_name = strcat([model_anfis_save_path, 'fuzzy_anfis_', data_type, '_', emotion_dim, 'mos_', num2str(nummfs), 'mfs_ep', num2str(numepochs)]);
    load(anfis_model_name);
    
    % Evaluates the output of the fuzzy system out_fis_train - input checking
    out=evalfis(Xin, out_fis_train);
    out_round = round(out);
    perf = 100*(sum(out_round == Xout))/length(out_round);
    
    % ANFIS plot data classification
	if plot_data_classification
        if num_emotion == 2
            figure('name', strcat([data_type, ' original']));
            hold on; grid on;
            for i=1:length(Xout)
                if (Xout(i) == 1) %+H
                	plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'r*');
                else
                    if (Xout(i) == 2) %+l
                    	plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'g*');
                    else
                        if (Xout(i) == 3) %-H
                            plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'c*');
                        else %-l
                        	plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'b*');
                        end
                    end
                end
            end
            xlabel('Hue');
            ylabel('Saturation');
            zlabel('Lightness');

            figure('name', strcat([data_type, ' estimated']));
            hold on; grid on;
            for i=1:length(out_round)
                if (out_round(i) == 1) %+H
                    plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'r*');
                else
                    if (out_round(i) == 2) %+l
                        plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'g*');
                    else
                        if (out_round(i) == 3) %-H
                            plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'c*');
                        else %-l
                            plot3(Xin(i,1), Xin(i,2), Xin(i,3), 'b*');
                        end
                    end
                end
            end
            xlabel('Hue');
            ylabel('Saturation');
            zlabel('Lightness');
        end
	end
    
end

