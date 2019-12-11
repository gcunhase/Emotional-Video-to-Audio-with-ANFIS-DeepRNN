Xin=[tempo loudness];Xout=ones(40,1);type='sugeno';cluster_n=2;
fismat = genfis3(Xin,Xout,type,cluster_n);
out_fis = anfis(Xin,fismat,20);


fismat_initial=genfis3(Xin,Xout,type,cluster_n);
[out_fis_train error] = anfis(Xin,fismat_initial,500);

train_predict=evalfis(new_train_feature(1:size(train_feature,1),1:13),out_fis_train);