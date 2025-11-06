#! /usr/bin/env bash

# Copyright © 2025 Boian Berberov
#
# Licensed under the EUPL-1.2 only.
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
# SPDX-License-Identifier: EUPL-1.2

if   ! which realpath > /dev/null 2>&1 || ! which dirname > /dev/null 2>&1
then
	exit 0
fi

if   [[ -n "${BASH_VERSION}" ]]
then
	origin="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"
else
	origin="$( realpath "$( dirname "${0}" )" )"
fi

# Bash completion
if   [[ -d "${origin}/bash-completion" ]]
then
	if   [[ -f "${origin}/bash-completion/bash_completion" ]]
	then
		source "${origin}/bash-completion/bash_completion"
	fi

	if   [[ -n "${BASH_COMPLETION_USER_DIR}" ]]
	then
		if [[ "${origin}/bash-completion" != "${BASH_COMPLETION_USER_DIR}" ]]
		then
			# Clean if/when re-sourcing, Bash 2.0 compatible
			new_BASH_COMPLETION_USER_DIR=":${BASH_COMPLETION_USER_DIR}:"
			pattern=":${origin}/bash-completion:";  new_PATH="${new_PATH/${pattern}/:}"
			new_BASH_COMPLETION_USER_DIR="${new_BASH_COMPLETION_USER_DIR#:}"
			new_BASH_COMPLETION_USER_DIR="${new_BASH_COMPLETION_USER_DIR%:}"

			export BASH_COMPLETION_USER_DIR="${new_BASH_COMPLETION_USER_DIR}:${origin}/bash-completion"
		fi
	else
		export BASH_COMPLETION_USER_DIR="${origin}/bash-completion"
	fi
fi
