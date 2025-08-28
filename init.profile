#! /bin/sh

# Copyright © 2024, 2025 Boian Berberov
#
# Licensed under the EUPL-1.2 only.
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
# SPDX-License-Identifier: EUPL-1.2

new_PATH="${PATH}"

check_and_set_sh()
{
	if   test -d "${1}"
	then
		echo ":${PATH}:" | grep -E ":${1}/?:" > /dev/null \
		|| new_PATH="${1}:${new_PATH}"
	fi
}

check_and_set_bash()
{
	if   [[ -d "${1}" ]]
	then
		[[ ":${PATH}:" =~ ":${1}"/?':' ]] \
		|| new_PATH="${1}:${new_PATH}"
	fi
}

if   test -n "${BASH_VERSION}"
then
	origin="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"
else
	origin="$( realpath "$( dirname "${0}" )" )"
fi

check_and_set_sh "${origin}/bin-sh"

if   which realpath > /dev/null 2>&1 && which dirname > /dev/null 2>&1
then
	if   test -n "${BASH_VERSION}"
	then
		check_and_set_bash "${origin}/bin-bash"

		if   (( 3 <= BASH_VERSINFO[0] ))
		then
			check_and_set_bash "${origin}/bin-bash3"

			if   (( 4 <= BASH_VERSINFO[0] ))
			then
				check_and_set_bash "${origin}/bin-bash4"

				if   (( 5 <= BASH_VERSINFO[0] ))
				then
					check_and_set_bash "${origin}/bin-bash5"

				fi
			fi
		fi
	fi

	if   which python3 > /dev/null 2>&1
	then
		check_and_set_sh "${origin}/bin-python3"
	fi
fi

check_and_set_sh "${HOME}/.local/bin"
check_and_set_sh "${HOME}/bin"

export PATH="${new_PATH}"
