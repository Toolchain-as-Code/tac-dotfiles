#!/usr/bin/env bash

############################################################
########## Dotfiles for Toolchain-as-Code Project ##########
############################################################

########## AUTHOR:  Jan Rother
########## DATE:    2024-12
########## VERSION: 1.0

# |----------------------- Variables ----------------------|

GITHUB_USER=toolchain-as-code
GITHUB_REPO=tac-dotfiles

DOTFILES_DIR=/tmp/${GITHUB_REPO}

# |------------------------ Helper ------------------------|

get_dotfiles() {
  echo "      - Creating temporary directory."
  mkdir -p /tmp/
  echo "      - Downloading dotfiles."
  curl -#fLo /tmp/${GITHUB_REPO}.tar.gz "https://github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/main"
  echo "      - Extracting dotfiles."
  tar -xzf /tmp/${GITHUB_REPO}.tar.gz --strip-components 1 -C /tmp/${GITHUB_REPO}
  echo "      - Removing dotfiles archive."
  rm -f /tmp/${GITHUB_REPO}.tar.gz
}

install_dotfiles() {
  echo "      - Changing to dotfiles directory."
  cd "${DOTFILES_DIR}/configs"
  echo "      - Installing dotfiles:"
  find . -type f -exec sh -c 'cp -v "$1" "${HOME}/${1#./}" | sed "s/^/          /"' _ {} \;
}

remove_temporary_files() {
  echo "      - Removing temporary files."
  rm -rf /tmp/${GITHUB_REPO}
}

# |------------------------ Script ------------------------|

install() {
  echo "Dotfiles"
  echo "-> ${GITHUB_USER}/${GITHUB_REPO}"

  echo "(0/3) GETTING DOTFILES"
  get_dotfiles
  echo "(1/3) INSTALLING DOTFILES"
  install_dotfiles
  echo "(2/3) CLEANING UP"
  remove_temporary_files
  echo "(3/3) DONE"
}

install
