#!/bin/bash

for f in ./decrypted/*; do
    filename=$(basename -- "$f")

    echo $filename

    if [[ filename = ".gitkeep" ]]; then
        continue
    fi

    gpg --sign --recipient optional.int@kakao.com -o ./encrypted/$filename.gpg --encrypt $f
done
