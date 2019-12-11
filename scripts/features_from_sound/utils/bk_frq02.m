%
% FILE NAME: BK_FRQ02.M
%
function [B_XX, bark] = bk_frq02(Bf, freq, XX)
% COMPUTES CRITICAL BANDS IN THE BARK SPECTRUM
% CRITICAL BANDS FROM "FOUNDATION OF MODERN AUDITORY THEORY"
bark(1) = 0;
bark(2) = 100;
bark(3) = 200;
bark(4) = 300;
bark(5) = 400;
bark(6) = 510;
bark(7) = 630;
bark(8) = 770;
bark(9) = 920;
bark(10) = 1080;
bark(11) = 1270;
bark(12) = 1480;
bark(13) = 1720;
bark(14) = 2000;
bark(15) = 2320;
bark(16) = 2700;
bark(17) = 3150;
bark(18) = 3700;
bark(19) = 4400;
    for i=2:19
        B_XX(i-1)=sum(XX(bark(i-1)<=freq & freq<bark(i)));
    end
end
% END OF BK_FRQ02.M