#!/bin/bash
set -eo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

echo $PWD

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

travisEnv=
for version in "${versions[@]}"; do
    for variant in alpine debian; do
        if [ ! -d "$version/$variant" ]; then
            continue;
        fi
        (
            set -x
	        sed -ri \
		        -e 's/^(ENV INFINIT_VERSION) .*/\1 '"$version"'/' \
		        -e 's/^(LABEL version=).*/\1'"\"$version\""'/' \
                "$version/$variant/Dockerfile"
	    )
        travisEnv='\n  - VERSION='"$version"' VARIANT='"$variant$travisEnv"
    done
done

travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
