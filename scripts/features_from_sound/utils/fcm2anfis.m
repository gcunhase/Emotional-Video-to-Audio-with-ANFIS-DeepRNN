%% fcm to anfis

function [result]=fcm2anfis(test_data, trn_data, cluster_n,teaching)
    if teaching==1
        teaching_signal=ones(size(trn_data,1),1);
    elseif teaching==0
        teaching_signal=zeros(size(trn_data,1),1);
    end
    fis=genfis3(test_data,teaching_signal,'sugeno',cluster_n);
    anfis_output=anfis([trn_data teaching_signal],fis);
    result=evalfis(test_data,anfis_output);  
end
% % [center,U,obj_fcn] = fcm(EEG_3D,2);
% teaching_signal=ones(12+2,1);
% fis=genfis3(EEG_3D,teaching_signal,'sugeno',2);
% out=anfis([train teaching_signal],fis);
% testdata_input=EEG_3D;  
% y=evalfis(testdata_input,out);
% Efficiency=(y>0.8);emotion=0;
% if sum(Efficiency(1:end-2))>3
%     emotion=1;
% end
% plot(y)