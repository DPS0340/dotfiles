#!/bin/bash

for f in $(find ./decrypted); do
    filename=$(echo $f | sed 's/.\/decrypted\///')

    if [[ filename == ".gitkeep" ]]; then
        continue
    fi

	if [[ -d $f ]]; then
		continue
	fi

    echo $filename

	mkdir -p ./encrypted/$(dirname $filename)
	touch ./encrypted/$filename

    gpg --batch --yes --sign --recipient optional.int@kakao.com -o ./encrypted/$filename --encrypt $f
done
