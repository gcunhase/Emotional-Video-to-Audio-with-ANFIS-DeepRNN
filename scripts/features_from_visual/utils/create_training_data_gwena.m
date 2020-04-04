function [H_data,S_data,L_data,O_data,count] = create_training_data_gwena(data,G,H_data,S_data,L_data,O_data,NumMovie)
    %%% train data ����
    %addpath hsio;
    %data = data(:,:,:,1:end);
    
    H_data_tmp = cell(1,2);S_data_tmp = cell(1,2);L_data_tmp = cell(1,2);O_data_tmp = cell(1,2);
    H_data_tmp{1}.train = [];S_data_tmp{1}.train = [];L_data_tmp{1}.train = [];O_data_tmp{1}.train = [];
    H_data_tmp{2}.test = [];S_data_tmp{2}.test = [];L_data_tmp{2}.test = [];O_data_tmp{2}.test = [];

    count = 1; %NumMovie;
    for i=1:size(data, 4)
        data_tmp = data(:,:,:,i);
        [train_H, train_S] = Hue(data_tmp);    
        train_L = Gray(data_tmp);
        train_O = Orientation(data_tmp,G);

        H_data_temp = H_trans(train_H);
        S_data_temp = S_trans(train_S);
        L_data_temp = L_trans(train_L);
        O_data_temp = O_trans1(train_O); % Size should be [23600 1] maybe?

        H_data_tmp{1}.train(:,count) = H_data_temp;
        S_data_tmp{1}.train(:,count) = S_data_temp;
        L_data_tmp{1}.train(:,count) = L_data_temp;
        O_data_tmp{1}.train(:,:,count) = O_data_temp;

        H_data_tmp{2}.test(:,:,count) = trans_data(train_H);
        S_data_tmp{2}.test(:,:,count) = trans_data(train_S);
        L_data_tmp{2}.test(:,:,count) = trans_data(train_L);
        O_data_tmp{2}.test(:,:,:,count) = trans_O_data(train_O);

        count = count+1; 
    end
    
    %Reshape
    s = size(H_data_tmp{1}.train, 1)*size(H_data_tmp{1}.train, 2);
    H_data{1}.train(:,NumMovie) = reshape(H_data_tmp{1}.train,[s 1]);
    S_data{1}.train(:,NumMovie) = reshape(S_data_tmp{1}.train,[s 1]);
    L_data{1}.train(:,NumMovie) = reshape(L_data_tmp{1}.train,[s 1]);
    s = size(O_data_tmp{1}.train, 1)*size(O_data_tmp{1}.train, 3);
    O_data{1}.train(:,:,NumMovie) = reshape(O_data_tmp{1}.train,[s size(O_data_tmp{1}.train, 2)]);
    
    s1 = size(H_data_tmp{2}.test, 1);
    s3 = size(H_data_tmp{2}.test, 3);
    H_data{2}.test(:,:,NumMovie) = reshape(H_data_tmp{2}.test,[s1 s3]);
    S_data{2}.test(:,:,NumMovie) = reshape(S_data_tmp{2}.test,[s1 s3]);
    L_data{2}.test(:,:,NumMovie) = reshape(L_data_tmp{2}.test,[s1 s3]);
    s1 = size(O_data_tmp{2}.test, 1);
    s2 = size(O_data_tmp{2}.test, 2);
    s4 = size(O_data_tmp{2}.test, 4);
    O_data{2}.test(:,:,:,NumMovie) = reshape(O_data_tmp{2}.test,[s1 s2 s4]);
    
end