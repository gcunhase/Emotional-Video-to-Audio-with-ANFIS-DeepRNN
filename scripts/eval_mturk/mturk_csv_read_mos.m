%%Function to read data obtained from Google Form to obtain AB-Experiment
%%results. Based on `model/utils/tsvreadGoogleForm.m`
%
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
% Date: Spring 2015
%

function [valence, arousal] = mturk_csv_read_mos(filename, num_emotion)

    var_delimiter = ',';
    dataFile = textread(filename, '%s', 'delimiter', '\n', 'whitespace', '');
        
    variables = strread(dataFile{1},'%s','delimiter', var_delimiter);
    
    valence = []; arousal = [];
    s_var = size(variables);
	for i=1:length(dataFile)-1
        v = strread(dataFile{1+i},'%s','delimiter', var_delimiter);
        
        v_cell = cell2str(v(3:s_var));
        v_a_num = str2num(v_cell(:, 2));  % this works if values are 1 to 9
        
        if num_emotion == 2
            % If idx is odd: valence, even: arousal
            valence = [valence; v_a_num(1:2:end)'];
            arousal = [arousal; v_a_num(2:2:end)'];
        else
            valence = [valence; v_a_num'];
        end
	end
    
end

