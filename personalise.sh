#!/bin/bash -eu

SCRIPT_DIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
mkdir -p "${HOME}/bin"

link_file() {
  TO="${1}"
  FROM="${2}"

  if [ -L "${FROM}" ] && [ ! -d "${FROM}" ]; then
    if [ "$( readlink -f "${FROM}" )" != "${TO}" ]; then
      echo "replacing symbolic link ${FROM}"
    else
      echo "noop for ${FROM}"
    fi
  elif [ -e "${FROM}" ]; then
    echo "diff ${FROM} ${TO}"
  else
    echo "ln -s ${TO} ${FROM}"
    ln -s "${TO}" "${FROM}"
  fi
}

apply_dotfile_dir() {
  DOTFILE_DIR="${1}"
  for DOTFILE in $( find -H "${DOTFILE_DIR}" -type f ); do
    TARGET="${HOME}/${DOTFILE#${DOTFILE_DIR}/}"
    link_file "${DOTFILE}" "${TARGET}"
  done
}

apply_dotfile_dir "${SCRIPT_DIR}/dotfiles/common"

HOST_SPECIFIC_DOTFILE_DIR="${SCRIPT_DIR}/dotfiles/${HOSTNAME}"
if [ -d "${HOST_SPECIFIC_DOTFILE_DIR}" ]; then
  apply_dotfile_dir "${HOST_SPECIFIC_DOTFILE_DIR}"
fi

