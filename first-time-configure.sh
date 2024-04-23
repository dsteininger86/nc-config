#!/usr/bin/env bash

SHIPPED_JSON="core/shipped.json"

function ooc() {
	php occ \
		"${@}"
}

function main() {
	# test required apps are set
	REQS=( php )

	for REQ in "${REQS[@]}"
	do
		which "${REQ}" >/dev/null
		if [ ! $? -eq 0 ]; then
			echo "ERROR: requirement '${REQ}' is missing"
			exit 1
		fi
	done

	echo "Configure NextCloud basics"

	if [[ $(ooc status --output json | jq '.installed') != "true" ]]; then
		echo "NextCloud is not installed, abort"
		exit 1
	fi

	ooc config:system:set lookup_server --value=""
	ooc user:setting admin settings email admin@example.net

	echo "Configure theming"

	ooc theming:config name "EasyStorage"
	ooc theming:config color "#003D8F"
	ooc theming:config disable-user-theming yes
	ooc config:app:set theming backgroundMime --value backgroundColor
}

main ${@}
