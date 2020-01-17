%%Script to evaluate MTurk results for AB Experiment
%
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
%

csv_filename = strcat(['results/', dataset_name, '/mturk-1DMOS-ABexperiment.csv']);
values = mturk_csv_read(csv_filename);

% 2D: max 22, shape 22x8
% 1D: max 20
num_subjects = 20;
values = values(1:num_subjects, :);

% Values caption = A: 0, B: 1, Either: 2

ab_results = [];
for i=1:8  % there are 8 videos
    A = sum(values(:,i) == 0);
    B = sum(values(:,i) == 1);
    Either = sum(values(:,i) == 2);
    
    ab_results = [ab_results, [A; B; Either]];
    
end

ab_results
