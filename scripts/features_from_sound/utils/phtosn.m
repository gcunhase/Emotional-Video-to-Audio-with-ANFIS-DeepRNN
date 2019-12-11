% 
% FILE NAME: PHTOSN.M
%
function S_XX = phtosn(P_XX)
% CONVERT LOUDNESS LEVEL (PHON SCALE) INTO LOUDNESS (SONE SCALE)
n=length(P_XX);
for i = 1:1:n
    if P_XX(i) >= 40
        S_XX(i) = 2^((P_XX(i) - 40)/10);
    else
        S_XX(i) = (P_XX(i)/40)^2.642;
    end
end
% END OF PHTOSN.M