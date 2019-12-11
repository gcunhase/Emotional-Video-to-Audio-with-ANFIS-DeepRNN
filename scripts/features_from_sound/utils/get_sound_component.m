function sound_final = get_sound_component( file )

    file_root = file(1:end-4);
    file2 = strcat([file_root, '.wav']);

    [sound_final,Fs] = audioread(file);

    wavwrite(sound_final, Fs, file2);

end

