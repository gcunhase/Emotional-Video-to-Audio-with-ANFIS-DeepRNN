function d = mkblips(b,sr,l,x)
% d = mkblips(b,sr,l,x)
%    Make a blip track at the set of times in b (in sec).  Output 
%    waveform has sampling rate sr (default 8000) and length l 
%    samples (default: long enough to contain all blips).
%    If b has two rows, second gives amplitude weights for each
%    blip.  x is optional blip waveform.
% 2006-05-02, 2006-09-30 dpwe@ee.columbia.edu

if nargin < 2
  sr = 8000;
end
if nargin < 3
  l = 0;
end

if nargin < 4
  % 100ms pip @ 2khz
  tdur = 0.1;
  fblip = 2000;
  tt = (0:round(tdur*sr))';
  x = tt.*exp(-tt/((tdur*sr)/10)).*cos(2*pi*tt/sr*fblip)/200;
end

lx = length(x);

if size(b,1) == 2
  ww = b(2,:);
  b = b(1,:);
else
  ww = ones(length(b),1);
end

bsamp = round(b*sr);

% remove beats that would run off end
if l > 0
  bsamp = bsamp(bsamp < (l-lx));
else
  l = max(bsamp)+lx;
end

d = zeros(l,1);

for bbx = 1:length(bsamp)
  bb = bsamp(bbx);
  d(bb+[1:lx]) = d(bb+[1:lx]) + ww(bbx).*x'; %before it was ww(bbx)*x
end