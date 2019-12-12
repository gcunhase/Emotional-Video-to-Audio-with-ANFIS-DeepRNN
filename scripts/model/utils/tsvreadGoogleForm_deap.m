%%Function to read data obtained from Google Form to obtain MOS - DEAP
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
% Date: Dec 12th 2019
%
%filename: 2D (Valence and Arousal) - ICONIP_MOS_Test - Spring '16 (Responses) - Form Responses
%Variables
%   Participant_id -> range: 1 - 32
%   Trial: 1 to 40 (skip 17 and 18 for lack of visual stimuli)
%   Experiment_id: not sure what this is, not relevant
%   Sart_time
%   Valence: 1 to 9
%   Arousal: 1 to 9
%   Dominance
%   Liking
%   Familiarity
%

function [values, values_dict] = tsvreadGoogleForm_deap(filename)

    delimiter = ',';
    dataFile = textread(filename, '%s', 'delimiter', '\n', 'whitespace', '');
        
    variables = strread(dataFile{1},'%s','delimiter',delimiter);
    
    values = [];
    s_var = size(variables);
	for i=1:(length(dataFile)-1)
        v = strread(dataFile{1+i},'%s','delimiter',delimiter);
        % Participant_id, Trial, Valence and Arousal
        values = [values, str2num(cell2str(v([1,2,5,6])))];  
    end

    values_dict = containers.Map;
    values_dict('Participant_id') = values(1, :);
    values_dict('Trial') = values(2, :);
    values_dict('Valence') = values(3, :);
    values_dict('Arousal') = values(4, :);
    
end

