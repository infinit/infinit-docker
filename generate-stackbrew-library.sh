#!/bin/bash
set -eu

declare -A main=(
	[0.8.0]='alpine'
	[0.7.3]='alpine'
)

declare -A aliases=(
    [0.8.0-alpine]='latest'
)

self="$(basename "$BASH_SOURCE")"
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( */ )
versions=( "${versions[@]%/}" )

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

cat <<-EOH
# this file is generated via https://github.com/infinit/infinit-docker/blob/$(fileCommit "$self")/$self
Maintainers: Antony Mechin <antony.mechin@docker.com> (@Dimrok)
GitRepo: https://github.com/infinit/infinit-docker.git
EOH

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#$sep}"
}

for version in "${versions[@]}"; do
	for variant in {debian,alpine}; do
		[ -f "$version/$variant/Dockerfile" ] || continue
		commit="$(dirCommit "$version/$variant")"

		fullVersion="$(git show "$commit":"$version/$variant/Dockerfile" | awk '$1 == "ENV" && $2 == "INFINIT_VERSION" { print $3; exit }')"

		versionAliases=()
		while [ "$fullVersion" != "$version" -a "${fullVersion%[.-]*}" != "$fullVersion" ]; do
			versionAliases+=( $fullVersion )
			fullVersion="${fullVersion%[.-]*}"
		done
		versionAliases+=(
			$version
			${aliases[$version]:-}
		)

		variantAliases=( "${versionAliases[@]/%/-$variant}" )

		subVariant="${variant#*-}"
		[ "$subVariant" != "$variant" ] || subVariant=

		if [ "$variant" = "${main[$version]}" ]; then
			variantAliases+=( "${versionAliases[@]}" )
        fi

        variantAliases+=(
            ${aliases[$version-$variant]:-}
        )

		echo
		cat <<-EOE
			Tags: $(join ', ' "${variantAliases[@]}")
			GitCommit: $commit
			Directory: $version/$variant
		EOE
	done
done
