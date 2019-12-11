%%% anfis 학습 및 분류
fismat_initial=genfis3(new_train_feature(1:size(train_feature,1),1:13),new_train_feature(:,16),'sugeno',numcluster);
[out_fis_train error] = anfis([new_train_feature(1:size(train_feature,1),1:13),new_train_feature(:,16)],fismat_initial,500);

train_predict=evalfis(new_train_feature(1:size(train_feature,1),1:13),out_fis_train);
for i=1:size(train_feature,1)
    [value index]=min((ones(1,2)*train_predict(i)-[0,1]).^2);
    train_emotion(i)=index-1;
end
compare_train=train_emotion'-new_train_feature(:,16);
train_accuracy=sum((compare_train==0))/size(train_feature,1)

test_predict=evalfis(new_test_feature(1:size(test_feature,1),1:13), out_fis_train);
for i=1:size(test_feature,1)
    [value index]=min((ones(1,2)*(test_predict(i))-[0,1]).^2);
    test_emotion(i)=index-1;
end

compare_test=test_emotion'-new_test_feature(:,16);
test_accuracy=sum((compare_test==0))/size(test_feature,1)