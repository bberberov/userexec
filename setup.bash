#! /usr/bin/env bash

# Copyright © 2025, 2026 Boian Berberov
#
# Licensed under the EUPL-1.2 only.
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
# SPDX-License-Identifier: EUPL-1.2

profile='shared'
userdir="/srv/user/${SUDO_USER:-${USER}}"
repo_name='userexec.git'
repo_path="github.com/bberberov/${repo_name}"
perm_repo="${userdir}/vcs/${repo_path}"
repo_tree_f='${HOME}/user/exec/'"${profile}"
repo_tree_e="${HOME}/user/exec/${profile}"

# Check for necesary commands
for cmd in \
	chmod \
	grep \
	stat \
	sudo \
;
do
	if   ! which "${cmd}" > /dev/null 2>&1
	then
		echo "ERROR: command ${cmd} not found"
	fi
done

# Set up permanent repo and tree
if   (( 1000 <= EUID ))
then
	if   [[ ! -d "${perm_repo}" ]] || ! git -C "${perm_repo}" rev-parse --git-dir > /dev/null 2>&1
	then
		if   [[ -f './init.profile' ]]
		then
			echo 'Updating PATH'
			source './init.profile'

			echo 'Setting up permanent userexec repo'
			[[ -d "${userdir}" ]] || sudo mkdir -p "${userdir}"
			[[ -O "${userdir}" && -G "${userdir}" ]] || sudo bash -c '[[ -n "${SUDO_UID}" ]] && chown "${SUDO_UID}:${SUDO_GID}" '"${userdir}"
			[[ 700 -eq "$(stat --printf=%a "${userdir}")" ]] || chmod 700 "${userdir}"
			[[ -d "${perm_repo%/${repo_name}}" ]] || mkdir -p "${perm_repo%/${repo_name}}"

			# Bare clone and permanent tree setup
			git -C "${perm_repo%/${repo_name}}" clone-bare "https://${repo_path}"
		else
			echo 'Cannot find `./init.profile`.  Run the script from the top level.'
			exit 1
		fi
	else
		echo "Using permanent userexec repo: ${perm_repo}"
	fi

	if   [[ ! -d "${repo_tree_e}" ]] && ! git -C "${repo_tree_e}" rev-parse --git-dir > /dev/null 2>&1
	then
		echo 'Setting up permanent userexec tree'
		git -C "${perm_repo}" worktree add "${repo_tree_e}"
	else
		echo "Using permanent userexec tree: ${repo_tree_e}"
	fi
else
	if   [[ -n "${SUDO_USER}" ]]
	then
		if   [[ -d "${perm_repo}" ]] && git -C "${perm_repo}" rev-parse --git-dir > /dev/null 2>&1
		then
			if   [[ ! -d "${repo_tree_e}" ]] && ! git -C "${repo_tree_e}" rev-parse --git-dir > /dev/null 2>&1
			then
				echo "Setting up permanent userexec repo and tree from user ${SUDO_USER}"
				git clone --shared --single-branch "${perm_repo}" "${repo_tree_e}"
			else
				echo "Using permanent userexec tree: ${repo_tree_e}"
			fi
		else
			echo "User ${SUDO_USER} permanent userexec repo is not set up yet"
		fi
	else
		echo "Setting up ${USER} userexec requires sudo and SUDO_USER"
	fi
fi

# Update .profile if needed
if   ! grep -F 'source "'"${repo_tree_f}"'/init.profile"' "${HOME}/.profile" > /dev/null 2>&1
then
	echo 'Adding .profile configuration'
	echo '
source "'"${repo_tree_f}"'/init.profile"' >> "${HOME}/.profile"
else
	echo 'Skipping .profile configuration'
fi

# Update .bashrc if needed
if   ! grep -F 'source "'"${repo_tree_f}"'/init.bashrc"' "${HOME}/.bashrc" > /dev/null 2>&1
then
	echo 'Adding .bashrc configuration'
	echo '
source "'"${repo_tree_f}"'/init.bashrc"' >> "${HOME}/.bashrc"
else
	echo 'Skipping .bashrc configuration'
fi
