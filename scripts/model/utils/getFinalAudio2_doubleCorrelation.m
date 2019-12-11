function [final_audio_reshaped, final_audio, mae_vec, audio_filename_sim_framed] = getFinalAudio2_doubleCorrelation(sim_image, filename, output_neg_framed_original, output_neg_framed_original_equivalent)

    final_audio = [];
    mae_vec = [];
    for i=1:size(sim_image,2)
        if ~isnan(sim_image(1,i))
            audio_feat = sim_image(:,i);
            audio_most_similar = [];
            audio_2nd_most_similar = [];
            min_mae = 0;
            mae_vec_tmp = []; mae_vec_tmp_2 = [];
            for j=1:size(output_neg_framed_original,2)
                current_audio_feat = output_neg_framed_original(:,j);
                current_audio_frag = output_neg_framed_original_equivalent(:,j);
                current_mae = mae(current_audio_feat - audio_feat);
                mae_vec_tmp = [mae_vec_tmp, current_mae];
                
                if (i > 1)
                    current_audio_feat = output_neg_framed_original(:,j);
                    current_audio_frag = output_neg_framed_original_equivalent(:,j);
                    current_mae = mae(current_audio_feat - sim_image(:,i-1));
                    mae_vec_tmp_2 = [mae_vec_tmp_2, current_mae];
                %else
                %    mae_vec_tmp_2 = mae_vec_tmp;
                end
            end 
            mae_vec = [mae_vec; mae_vec_tmp];
            
            if (i > 1)
                [~, idx_first] = min(mae_vec_tmp - mae_vec_tmp_2);
            else
                [~, idx_first] = min(mae_vec_tmp);
            end
            
            final_audio = [final_audio, output_neg_framed_original_equivalent(:,idx_first)];
        end
    end
    final_audio_reshaped = reshape(final_audio, [size(final_audio,1)*size(final_audio,2), 1]);
    final_audio_reshaped = .95.*final_audio_reshaped./max(abs(final_audio_reshaped));
    fs = 44100;
    % final_audio_reshaped = smooth(final_audio_reshaped);  %, 20);
    audio_filename_sim_framed = strcat([filename, '_sim_framed.wav']);
    audiowrite(audio_filename_sim_framed,final_audio_reshaped,fs);

end