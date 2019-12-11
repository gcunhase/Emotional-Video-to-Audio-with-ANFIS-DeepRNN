%% Settings

clc
clear all 

%load number_of_sort_dataset2_correct_lindsey_500_v7
%load feature_dataset2_correct_lindsey_500_v7

plot = 0;
%load scores      %%MOS target
[input_HSL, output_TLR, output_audio_equivalent, input_2dmos, output_2dmos, input_2dmos_num, output_2dmos_num, input_full, output_full] = getIO_HSL_TLR_equivAudio_2DMOS(plot);

%% Anfis (Second ANFIS)
% %% ANFIS test
% x = (0:0.1:10)';
% y = sin(2*x)./exp(x/5);
% epoch_n = 20;
% in_fis  = genfis1([x y],5,'gbellmf');
% out_fis = anfis([x y],in_fis,epoch_n);
% plot(x,y,x,evalfis(x,out_fis));
% legend('Training Data','ANFIS Output');

%Xin = input_full';
Xin = input_HSL';
Xout = input_2dmos_num';

%%-----------------Genfis3
numcluster = 16;
%http://www.cs.nthu.edu.tw/~jang/anfisfaq.htm
fismat_initial = genfis3(Xin, Xout,'sugeno',numcluster);
%numMFs = 5;
%mfType = 'gbellmf';
%fismat_initial = genfis1([Xin, Xout],numMFs,mfType);
out_fis_train = anfis([Xin, Xout],fismat_initial,500);

%%-----------------Genfis1
trndata = [Xin, Xout];
chkdata = trndata;
nummfs=5; % number of membership functions
mftype='gbellmf'; % membership functions type is generalized bell
fismat = genfis1(trndata,nummfs,mftype);

numepochs = 40;
% Start the optimization
 [fismat1, trnerr, ss, fismat2, chkerr]= ...
anfis(trndata, fismat, numepochs, NaN, chkdata);

%%-----------------Genfis2 <- this one!!!!
fismat = genfis2(Xin,Xout,0.5);
trndata = [Xin, Xout];
chkdata = trndata;
numepochs = 100;
% Start the optimization
[out_fis_train, trnerr, ss, fismat2, chkerr]= ...
anfis(trndata, fismat, numepochs, NaN, chkdata);


out=evalfis(Xin,out_fis_train);% Evaluates the output of the fuzzy system out_fis_train - input checking
out_round = round(out);
perf = 100*(sum(out_round == Xout))/length(out_round);


% train_predict=evalfis(new_train_feature(1:size(train_feature,1),1:13),out_fis_train);
% for i=1:size(train_feature,1)
%     [value index]=min((ones(1,2)*train_predict(i)-[0,1]).^2);
%     train_emotion(i)=index-1;
% end
% compare_train=train_emotion'-new_train_feature(:,14);
% train_accuracy=sum((compare_train==0))/size(train_feature,1)


%% Test
%http://www.mathworks.com/help/fuzzy/genfis3.html
Xin = [7*rand(50,1) 20*rand(50,1)-10];
%Xout = [5*rand(50,1) 5*rand(50,1)]; -> can only have 1 output
Xout = 5*rand(50,1);

opt = NaN(4,1);
opt(4) = 0;
fismat = genfis3(Xin,Xout,'sugeno',3,opt);

out_fis_train = anfis([Xin, Xout],fismat,500);