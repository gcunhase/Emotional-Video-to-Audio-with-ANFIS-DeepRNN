%%Script to evaluate MTurk results for MOS scores
%
% Author: Gwenaelle Cunha Sergio
% Kyungpook National University, Deagu, South Korea
%

%% 2DMOS

num_emotion = 2;
%filename = strcat(['results/', dataset_name, '/mturk-2DMOS-Corrected.csv']);
filename = strcat(['results/', dataset_name, '/mturk-2DMOS.csv']);
[valence, arousal] = mturk_csv_read_mos(filename, num_emotion);

% num_subjects = 10;

if strcmp(dataset_name, 'lindsey')
    lstm_results_valence = []; lstm_results_arousal = [];
    for i=1:8  % there are 16 videos, 8 LSTM and 8 RNN

        valence_values = valence(:, i);
        arousal_values = arousal(:, i);

        lstm_results_valence = [lstm_results_valence, [mean(valence_values); std(valence_values)]];
        lstm_results_arousal = [lstm_results_arousal, [mean(arousal_values); std(arousal_values)]];

    end
    rnn_results_valence = []; rnn_results_arousal = [];
    for i=9:16  % there are 16 videos, 8 LSTM and 8 RNN

        valence_values = valence(:, i);
        arousal_values = arousal(:, i);

        rnn_results_valence = [rnn_results_valence, [mean(valence_values); std(valence_values)]];
        rnn_results_arousal = [rnn_results_arousal, [mean(arousal_values); std(arousal_values)]];

    end
    rnn_results_valence
    rnn_results_arousal
else
    lstm_results_valence = []; lstm_results_arousal = [];
    for i=1:10  % there are 16 videos, 8 LSTM and 8 RNN

        valence_values = valence(:, i);
        arousal_values = arousal(:, i);

        lstm_results_valence = [lstm_results_valence, [mean(valence_values); std(valence_values)]];
        lstm_results_arousal = [lstm_results_arousal, [mean(arousal_values); std(arousal_values)]];

    end
end

lstm_results_valence
lstm_results_arousal


%% 1DMOS

num_emotion = 1;
filename = strcat(['results/', dataset_name, '/mturk-1DMOS.csv']);
[valence, ~] = mturk_csv_read_mos(filename, num_emotion);

% num_subjects = 10;

lstm_results_valence = [];
for i=1:8  % there are 16 videos, 8 LSTM and 8 RNN
    
    valence_values = valence(:, i);
    lstm_results_valence = [lstm_results_valence, [mean(valence_values); std(valence_values)]];
    
end

rnn_results_valence = [];
for i=9:16  % there are 16 videos, 8 LSTM and 8 RNN
    
    valence_values = valence(:, i);
    
    rnn_results_valence = [rnn_results_valence, [mean(valence_values); std(valence_values)]];
    
end

lstm_results_valence
rnn_results_valence


