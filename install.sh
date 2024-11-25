#!/usr/bin/env bash
set -e

############################################################
########## Dotfiles for Toolchain-as-Code Project ##########
############################################################

########## AUTHOR:  Jan Rother
########## DATE:    2024-12
########## VERSION: 1.0

# |----------------------- Variables ----------------------|

GITHUB_USER=toolchain-as-code
GITHUB_REPO=tac-dotfiles

DOTFILES_ARCHIVE=/tmp/${GITHUB_REPO}.tar.gz
DOTFILES_DIR=/tmp/${GITHUB_REPO}
TARGET_DIR=${HOME}

# |------------------------ Helper ------------------------|

get_dotfiles() {
  echo "      - Creating temporary directory:"
  mkdir -p "${DOTFILES_DIR}" || {
    echo "        ! ERROR: Failed to create temporary directory: ${DOTFILES_DIR}"
    exit 1
  }
  echo "          ${DOTFILES_DIR}"

  echo "      - Downloading dotfiles."
  curl -#fLo "${DOTFILES_ARCHIVE}" "https://github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/main" || {
    echo "        ! ERROR: Failed to download dotfiles archive."
    exit 1
  }

  echo "      - Extracting dotfiles."
  tar -xzf "${DOTFILES_ARCHIVE}" --strip-components 1 -C "${DOTFILES_DIR}" || {
    echo "        ! ERROR: Failed to extract dotfiles archive."
    exit 1
  }

  echo "      - Removing dotfiles archive."
  rm -f "${DOTFILES_ARCHIVE}" || {
    echo "        ! ERROR: Failed to remove dotfiles archive."
    exit 1
  }
}

install_dotfiles() {
  echo "      - Changing to dotfiles directory."
  cd "${DOTFILES_DIR}/configs" || {
    echo "          ERROR: 'configs/' directory of dotfiles not found."
    exit 1
  }

  echo "      - Installing dotfiles:"
  find . -type f | while IFS= read -r file; do
    target="${TARGET_DIR}/${file#./}"
    mkdir -p "$(dirname "${target}")" || {
      echo "        ! '${target}' -> ERROR: Failed to create directory."
      exit 1
    }
    if cp "${file}" "${target}" 2>/dev/null; then
      echo "          '${file}' -> '${target}'"
    else
      echo "        ! '${file}' -> ERROR: Failed to copy file to target: '${target}'"
      exit 1
    fi
  done
}

remove_temporary_files() {
  echo "      - Removing temporary files:"
  rm -rf ${DOTFILES_DIR}
  echo "          ${DOTFILES_DIR}"
  echo "      - Changing back to the original directory."
  cd -
}

# |------------------------ Script ------------------------|

install() {
  echo " "
  echo "+++++++ INSTALLING DOTFILES +++++++"
  echo "from ${GITHUB_USER}/${GITHUB_REPO}"
  echo "-----------------------------------"
  echo " "

  echo "(0/3) GETTING DOTFILES"
  get_dotfiles
  echo "(1/3) INSTALLING DOTFILES"
  install_dotfiles
  echo "(2/3) CLEANING UP"
  remove_temporary_files
  echo "(3/3) DONE"
  echo " "
}

install
