#!/bin/bash

for f in ./encrypted/*; do
    filename=$(basename -- "$f")
    filename="${filename%.*}"

    echo $filename

    if [[ filename = ".gitkeep" ]]; then
        continue
    fi

    gpg -o ./decrypted/$filename --decrypt $f
done
