#! /bin/bash

# Copyright © 2025 Boian Berberov
#
# Licensed under the EUPL-1.2 only.
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
# SPDX-License-Identifier: EUPL-1.2

if   which realpath > /dev/null 2>&1 && which dirname > /dev/null 2>&1
then
	origin="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"

	# Bash completion
	source "${origin}/bash-completion/bash_completion"

	if   [[ -v BASH_COMPLETION_USER_DIR ]]
	then
		[[ ":${BASH_COMPLETION_USER_DIR}:" =~ ":${origin}/bash-completion"/?':' ]] \
		|| export BASH_COMPLETION_USER_DIR="${BASH_COMPLETION_USER_DIR}:${origin}/bash-completion"
	else
		export BASH_COMPLETION_USER_DIR="${origin}/bash-completion"
	fi
fi
