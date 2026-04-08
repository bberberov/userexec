#! /bin/sh

# Copyright © 2024, 2025 Boian Berberov
#
# Licensed under the EUPL-1.2 only.
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
# SPDX-License-Identifier: EUPL-1.2

if   ! which realpath > /dev/null 2>&1 || ! which dirname > /dev/null 2>&1
then
	exit 0
fi

if   test -n "${BASH_VERSION}"
then
	origin="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"
else
	origin="$( realpath "$( dirname "${0}" )" )"
fi

check_and_set_pre()
{
	if   test -d "${1}"
	then
		new_PATH="${1}:${new_PATH}"
	fi
}

check_and_set_post()
{
	if   test -d "${1}"
	then
		new_PATH="${new_PATH}:${1}"
	fi
}

# Clean if/when re-sourcing, Bash 2.0 compatible
new_PATH=":${PATH}:"
pattern=":${origin}/bin-sh:";       new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash:";     new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash3:";    new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash3.1:";  new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash3.2:";  new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash4:";    new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash4.2:";  new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-bash5:";    new_PATH="${new_PATH/${pattern}/:}"
pattern=":${origin}/bin-python3:";  new_PATH="${new_PATH/${pattern}/:}"
pattern=":${HOME}/bin:";            new_PATH="${new_PATH/${pattern}/:}"
pattern=":${HOME}/.local/bin:";     new_PATH="${new_PATH/${pattern}/:}"
new_PATH="${new_PATH#:}"
new_PATH="${new_PATH%:}"

# Generic sh
check_and_set_pre "${origin}/bin-sh"

# Bash, with versions
if   test -n "${BASH_VERSION}"
then
	check_and_set_pre "${origin}/bin-bash"

	if   (( 3 <= BASH_VERSINFO[0] ))
	then
		# NOTE Released on 2004-07-27
		check_and_set_pre "${origin}/bin-bash3"

		if   (( 1 <= BASH_VERSINFO[1] ))
		then
			# NOTE Released on 2005-12-09
			check_and_set_pre "${origin}/bin-bash3.1"
		fi

		if   (( 2 <= BASH_VERSINFO[1] ))
		then
			# NOTE Released on 2006-10-12
			check_and_set_pre "${origin}/bin-bash3.2"
		fi

		if   (( 4 <= BASH_VERSINFO[0] ))
		then
			# NOTE Released on 2009-02-20
			check_and_set_pre "${origin}/bin-bash4"

			if   (( 2 <= BASH_VERSINFO[1] ))
			then
				# NOTE Released on 2011-02-14
				check_and_set_pre "${origin}/bin-bash4.2"
			fi

			if   (( 5 <= BASH_VERSINFO[0] ))
			then
				# NOTE Released on 2019-01-07
				check_and_set_pre "${origin}/bin-bash5"

			fi
		fi
	fi
fi

# Python
if   which python3 > /dev/null 2>&1
then
	check_and_set_pre "${origin}/bin-python3"
fi

# Local /bin
check_and_set_pre "${HOME}/.local/bin"
check_and_set_pre "${HOME}/bin"

export PATH="${new_PATH}"

# Clean if/when re-sourcing, Bash 2.0 compatible
new_PATH=":${MANPATH}:"
pattern=":${origin}/man:";  new_PATH="${new_PATH/${pattern}/:}"
new_PATH="${new_PATH#:}"
new_PATH="${new_PATH%:}"

check_and_set_post "${origin}/man"

export MANPATH="${new_PATH}"
