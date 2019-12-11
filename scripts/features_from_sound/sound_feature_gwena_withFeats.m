%%Cutting the data to deal with codes easily

function [tempo, loudness, rhythm] = sound_feature_gwena_withFeats(song, sec)
    
    length=size(song);

    sr=4410; % sampling rate for tempo estimating
    if (nargin < 2)
        sec=600;
    end

    initial_point=length(1)-sr*sec+1;
    song=song(initial_point:end);
    data=song;
    %% Feature Extraction in Music
    tempo=zeros(sec,3);
    loudness=zeros(sec,1);
    rhythm=zeros(sec,1);

    for i=1:sec
        tempo(i,:)=tempo2(data(sr*(i-1)+1:(sr*(i-1))+sr),sr); % output vector [t(1),t(2),ratio of t(1),t(2)]
        loudness(i)=abs(loud2(data(sr*(i-1)+1:(sr*(i-1))+sr)));
        rhythm(i)=rythm2(data(sr*(i-1)+1:(sr*(i-1))+sr));
    end

end