%Works with 1D and 2D MOS thanks to...
function [perf, input_sim_round] = getPerformance_negativeEmotionIs0( input_sim, input_mos )

    input_sim_round = round(input_sim);
    correct_count = 0;
    for i=1:length(input_sim)
        if (input_sim_round(:,i) == input_mos(:,i)) %...this line
            correct_count = correct_count + 1;
        end
    end
    perf = 100*correct_count/length(input_sim);

end

