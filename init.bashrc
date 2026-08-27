#! /usr/bin/env bash

# Copyright © 2025, 2026 Boian Berberov
#
# Licensed under the EUPL-1.2 only.
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
# SPDX-License-Identifier: EUPL-1.2

if   ! type -fP 'realpath' > '/dev/null' 2>&1 || ! type -fP 'dirname' > '/dev/null' 2>&1
then
	exit 0
fi

# BASH_VERSION in 3.0
if   [[ -n "${BASH_VERSION}" ]]
then
	origin="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"
else
	origin="$( realpath "$( dirname "${0}" )" )"
fi

bash_completion_dir="${origin}/bash-completion"

# Bash completion
if   [[ -d "${bash_completion_dir}" ]]
then
	if   [[ -f "${bash_completion_dir}/bash_completion" ]]
	then
		source "${bash_completion_dir}/bash_completion"
	fi

	if   [[ -n "${BASH_COMPLETION_USER_DIR}" ]]
	then
		if   [[ "${bash_completion_dir}" != "${BASH_COMPLETION_USER_DIR}" ]]
		then
			# Clean if/when re-sourcing, Bash 2.0 compatible
			new_BASH_COMPLETION_USER_DIR=":${BASH_COMPLETION_USER_DIR}:"
			pattern=":${bash_completion_dir}:";  new_PATH="${new_PATH/${pattern}/:}"
			new_BASH_COMPLETION_USER_DIR="${new_BASH_COMPLETION_USER_DIR#:}"
			new_BASH_COMPLETION_USER_DIR="${new_BASH_COMPLETION_USER_DIR%:}"

			export BASH_COMPLETION_USER_DIR="${new_BASH_COMPLETION_USER_DIR}:${bash_completion_dir}"
		fi
	else
		export BASH_COMPLETION_USER_DIR="${bash_completion_dir}"
	fi
fi
