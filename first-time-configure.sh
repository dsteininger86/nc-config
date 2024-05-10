#!/bin/sh

SHIPPED_JSON="core/shipped.json"

ooc() {
	php occ \
		"${@}"
}

fail() {
	echo "${*}"
	exit 1
}

checks() {
	if ! which php 2>&1 >/dev/null; then
		fail "Error: php is required"
	fi

	if ! which jq 2>&1 >/dev/null; then
		fail "Error: jq is required"
	fi
}

config_server() {
	echo "Configure NextCloud basics"

	ooc config:system:set lookup_server --value=""
	ooc user:setting admin settings email admin@example.net
}

config_ui() {
	echo "Configure theming"

	ooc theming:config name "EasyStorage"
	ooc theming:config color "#003D8F"
	ooc theming:config disable-user-theming yes
	ooc config:app:set theming backgroundMime --value backgroundColor
}

main() {
	checks

	if [ $(ooc status --output json | jq '.installed') != "true" ]; then
		echo "NextCloud is not installed, abort"
		exit 1
	fi

	config_server
	config_ui
}

main ${@}
