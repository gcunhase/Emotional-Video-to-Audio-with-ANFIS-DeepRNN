function [rythm]=rythm2(data)
    Fs = 44100;   
    x = data;
    nfft = 2^nextpow2(length(x));
    Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;

    % Create a single-sided or double side spectrum (choose one one of them)
    Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);  % single side
    % Hpsd = dspdata.psd(Pxx,'Fs',Fs,'SpectrumType','twosided') % double side
    % plot(Hpsd); 
    rythm=var(Hpsd.data);
    rythm=log(rythm);
end