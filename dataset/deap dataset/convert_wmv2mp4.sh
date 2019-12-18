for I in {1..40}; do
    ffmpeg -i "wmv/${I}.wmv" "mp4/${I}.mp4"
done
