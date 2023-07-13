#!/bin/bash

for f in $(find ./encrypted); do
    filename=$(echo $f | sed 's/.\/encrypted\///' | sed 's/.gpg//')

    if [[ filename == ".gitkeep" ]]; then
        continue
    fi

	if [[ -d $f ]]; then
		continue
	fi

    echo $filename

	mkdir -p ./decrypted/$(dirname $filename)
	touch ./decrypted/$filename

    gpg --batch --yes -o ./decrypted/$filename --decrypt $f
done
