clear all
clc
function [H_data,S_data,L_data,O_data] = create_training_data(data,G,H_data,S_data,L_data,O_data,NumMovie)
    %%% train data Á¤¸®
    addpath ./hsio;
    data = data(:,:,:,1:end);
    [train_H, train_S] = Hue(data);    
    train_L = Gray(data);
    train_O = Orientation(data,G);
    
    H_data_temp = H_trans(train_H);
    S_data_temp = S_trans(train_S);
    L_data_temp = L_trans(train_L);
    O_data_temp = O_trans1(train_O);
    
    H_data{1}.train(:,NumMovie) = H_data_temp;
    S_data{1}.train(:,NumMovie) = S_data_temp;
    L_data{1}.train(:,NumMovie) = L_data_temp;
    O_data{1}.train(:,:,NumMovie) = O_data_temp;
    
    
    H_data{2}.test(:,:,NumMovie) = trans_data(train_H);
    S_data{2}.test(:,:,NumMovie) = trans_data(train_S);
    L_data{2}.test(:,:,NumMovie) = trans_data(train_L);
    O_data{2}.test(:,:,:,NumMovie) = trans_O_data(train_O);
    
    count = NumMovie    
end