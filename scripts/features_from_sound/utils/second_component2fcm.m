sound_train_3D=reshape(total_sound,1800*80,1);
n=length(sound_train_3D);
EEG_3D=zeros(n+2,3);
EEG_3D(1:n,1)=sound_train_3D;
EEG_3D(1+1:n+1,2)=sound_train_3D;
EEG_3D(1+2:n+2,3)=sound_train_3D;

teaching_signal=ones(n+2,1);
teaching_signal(1800*40+2:1800*80+2,:)=0;
fis=genfis3(EEG_3D(1:1*1800+1,:),teaching_signal(180*30+2:180*40+2,:),'sugeno',2);
out=anfis([EEG_3D(1:1*1800+1,:) teaching_signal(1:1*1800+1,:)],fis);
y=evalfis(EEG_3D(1:1802,1:3),out);
plot(1:1800*80+2,teaching_signal,1:1800*80+2,y)