%%Function to read data obtained from Google Form to obtain AB-Experiment
%%results. Based on `model/utils/tsvreadGoogleForm.m`
%
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
% Date: Spring 2015
%

function [values] = mturk_csv_read(filename)

    var_delimiter = ',';
    dataFile = textread(filename, '%s', 'delimiter', '\n', 'whitespace', '');
        
    variables = strread(dataFile{1},'%s','delimiter', var_delimiter);
    
    values = [];
    s_var = size(variables);
	for i=1:length(dataFile)-1
        v = strread(dataFile{1+i},'%s','delimiter', var_delimiter);
        
        % A: 0, B: 1, Either: 2
        v_arr_num = [];
        for idx=3:s_var  % starting at index 3 to skip Timestamp and Age
            v_a = v(idx);
            v_a_str = cell2str(v_a);
            if strcmp(v_a_str, '"A"')
                v_arr_num = [v_arr_num, 0];
            else
                if strcmp(v_a_str, '"B"')
                    v_arr_num = [v_arr_num, 1];
                else  % Either
                    v_arr_num = [v_arr_num, 2];
                end
            end
        end
        values = [values; v_arr_num];
	end
    
end

