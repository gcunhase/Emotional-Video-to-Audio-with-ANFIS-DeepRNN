%%Function to read data obtained from Google Form to obtain MOS
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
%
%filename: 2D (Valence and Arousal) - ICONIP_MOS_Test - Spring '16 (Responses) - Form Responses
%Variables
%   Timestamp -> i = 1
%   Name (optional) -> i = 2
%   Videos:  -> i = 3:52
%       Roundtable Rival (+): 0 - 3:22 -> i = 3:4
%           Time: 0 - 3:22 [Valence, Arousal] -> 2 separate indexes
%       Beyond The Veil (+/-): 0:05 - 4:09 -> i = 5:20
%           Time: 0:05 - 0:27 [Valence, Arousal]
%           Time: 0:28 - 0:47 [Valence, Arousal]
%           Time: 0:48 - 1:13 [Valence, Arousal]
%           Time: 1:14 - 1:#7 [Valence, Arousal]
%           Time: 1:38 - 2:46 [Valence, Arousal]
%           Time: 2:47 - 3:09 [Valence, Arousal]
%           Time: 3:10 - 3:20 [Valence, Arousal]
%           Time: 3:21 - 4:09 [Valence, Arousal]
%       Phantom of the Opera (+/-): 0:06 - 6:32 -> i = 21:32
%           Time: 0:06 - 1:13 [Valence, Arousal]
%           Time: 1:14 - 2:28 [Valence, Arousal]
%           Time: 2:29 - 4:06 [Valence, Arousal]
%           Time: 4:07 - 4:20 [Valence, Arousal]
%           Time: 4:21 - 5:09 [Valence, Arousal]
%           Time: 5:10 - 6:32 [Valence, Arousal]
%       Take Flight (-): 0:11 - 4:26 -> i = 33:34
%           Time: 0:11 - 4:26 [Valence, Arousal]
%       Crystallize (-): 0:10 - 4:15 -> i = 35:36
%           Time: 0:10 - 4:15 [Valence, Arousal]
%       Moon Trance (+/-): 0:27 - 4:12 -> i = 37:48
%           Time: 0:27 - 1:13 [Valence, Arousal]
%           Time: 1:14 - 1:28 [Valence, Arousal]
%           Time: 1:29 - 1:58 [Valence, Arousal]
%           Time: 1:59 - 2:28 [Valence, Arousal]
%           Time: 2:29 - 2:51 [Valence, Arousal]
%           Time: 2:52 - 4:12 [Valence, Arousal]
%       Lord of the Rings Medley (-): 0:05 - 3:10 -> i = 49:50
%           Time: 0:05 - 3:10 [Valence, Arousal]
%       Elements (-): 0 - 3:50 -> i = 51:52
%           Time: 0 - 3:50 [Valence, Arousal]
%   Comment (optional) -> i = 53

function [values, variables, data, varout] = tsvreadGoogleForm(filename, varin)

    dataFile = textread(filename, '%s', 'delimiter', '\n', 'whitespace', '');
        
    variables = strread(dataFile{1},'%s','delimiter','\t');
    
    values = [];
    s_var = size(variables);
	for i=1:(length(dataFile)-1)
        v = strread(dataFile{1+i},'%s','delimiter','\t');
        values = [values, str2num(cell2str(v(3:s_var-1)))];
	end
    
    data = [];
    for i=3:length(variables)-1 %timestamp, names, comment
        data = [data; {variables(i), values(i-2,:)}];
    end
    
    %In case you want the values for just 1 or more fields, not alll
    %You can choose by sending as parameter the name of the attribute
    varout = [];
    if (nargin > 1)
        for i=1:length(varin)
            name = strcat([varin{i}, ' ']);
            idx = strmatch(name, variables);
            varout = [varout; data{idx,2}];
        end
    end

end

