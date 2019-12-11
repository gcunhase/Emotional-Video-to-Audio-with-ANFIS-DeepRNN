%
% FILE NAME: DBTOPHON.M
%
function P_XX = dbtophon(Ci)
% CONVERT SPREAD BARK SPECTRUM INTO PHON SCALE
% load a:\MBSD\equal.mat % EQUAL-LOUDNESS CONTOURS
n=length(Ci);
T = 10*log10(Ci); % COMPUTE BARK 4 TO 18 ONLY IN dB
    for i = 1:1:n
       [I]=find(T(i)<=equalcon(:,i));
       if min(I)==1
           P_XX(i)=phons(1);
       else
           t1 = (T(i) - eqlcon(j-1,i))/(eqlcon(j,i) - eqlcon(j-1,i));
           P_XX(i) = phons(j-1) + t1*(phons(j) - phons(j-1));
       end
    end
end
% END OF DBTOPHON.M