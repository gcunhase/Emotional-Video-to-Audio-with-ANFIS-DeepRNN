%%Function to read data obtained from Google Form to obtain MOS - CONG
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
%
%filename: 2D (Valence and Arousal) - ICONIP_MOS_Test - Spring '16 (Responses) - Form Responses
%Variables
%   splice
%   emotion
%

function [values, values_dict] = tsvreadGoogleForm_cognimuse(filename)

    delimiter = ',';
    dataFile = textread(filename, '%s', 'delimiter', '\n', 'whitespace', '');
        
    variables = strread(dataFile{1},'%s','delimiter',delimiter);
    
    values = [];
    s_var = size(variables);
	for i=1:(length(dataFile)-1)
        v = strread(dataFile{1+i},'%s','delimiter',delimiter);
        % splice, emotion
        values = [values, str2num(cell2str(v([1,2])))];  
    end

    values_dict = containers.Map;
    values_dict('splice') = values(1, :);
    values_dict('emotion') = values(2, :);
    
end

