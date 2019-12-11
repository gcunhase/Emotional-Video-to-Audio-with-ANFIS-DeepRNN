function [perf, input_sim_round] = getPerformance( input_sim, input_mos )

    input_sim_round = [];
    correct_count = 0;
    for i=1:length(input_sim)
        if (input_sim(i) >= 0) %Positive
            input_sim_round = [input_sim_round, 1];
        else %Negative
            input_sim_round = [input_sim_round, -1];
        end
        if (input_sim_round(i) == input_mos(i))
            correct_count = correct_count + 1;
        end
    end
    perf = 100*correct_count/length(input_sim);

end

