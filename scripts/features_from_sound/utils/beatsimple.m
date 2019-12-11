function beats = beatsimple(localscore, period, alpha)
% beats = beatsimple(localscore, period, alpha)
%   Core of the DP-based beat tracker
%   <localscore> is the onset strength envelope
%   <period> is the target tempo period (in samples)
%   <alpha> is weight applied to transition cost
%   <beats> returns the chosen beat sample times.
% 2007-06-19 Dan Ellis dpwe@ee.columbia.edu

% backlink(time) is best predecessor for this point
% cumscore(time) is total cumulated score to this point
backlink = -ones(1,length(localscore));
cumscore = localscore;

% Search range for previous beat
prange = round(-2*period):-round(period/2);
% Log-gaussian window over that range
txwt = (-alpha*abs((log(prange/-period)).^2));

for i = max(-prange + 1):length(localscore)
  
  timerange = i + prange;
  
  % Search over all possible predecessors 
  % and apply transition weighting
  scorecands = txwt + cumscore(timerange);
  % Find best predecessor beat
  [vv,xx] = max(scorecands);
  % Add on local score
  cumscore(i) = vv + localscore(i);
  % Store backtrace
  backlink(i) = timerange(xx);

end

% Start backtrace from best cumulated score
[vv,beats] = max(cumscore);
% .. then find all its predecessors
while backlink(beats(1)) > 0
  beats = [backlink(beats(1)),beats];
end
