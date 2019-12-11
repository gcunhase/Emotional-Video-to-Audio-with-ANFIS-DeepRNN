function [loud] = loud2(data)
    y=data;
    SPLmeas=70;
    Pref = 20e-6;
    y_refscaled= (y./Pref);
    RMS=sqrt(mean(y_refscaled.^2));
    SPLmat=20*log10(RMS); % dBSPL in matlab
    c=10^((SPLmeas-SPLmat)/20);
    ycal=c*(y_refscaled);

    NFFT=1024;NOVERLAP=0;
    Bf=1:18;
    fs=44100;
    %[Yxx,f] = psd(ycal,NFFT,fs,NFFT,0);
    [Yxx,f] = pwelch(ycal, NFFT,0, NFFT, fs);
    Yxx_scale=(2.*Yxx)./NFFT;
    [B_XX,bark]=bk_frq02(Bf,f,Yxx_scale);
    % C_XX=spread_new(Bf,B_XX);
    % P_XX=dbtophon(C_XX);
    % P_XX=dbtophon(B_XX);
    S_XX=phtosn(10*log10(B_XX));
    loud=sum(S_XX);
end