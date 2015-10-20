#!/bin/bash -eu

SCRIPT_DIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

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
    echo "conflict with existing file at ${FROM}"
  else
    echo "ln -s ${TO} ${FROM}"
  fi
}

DOTFILE_DIR="${SCRIPT_DIR}/dotfiles/common"
for DOTFILE in $( find -H "${DOTFILE_DIR}" -type f ); do
  TARGET="${HOME}/${DOTFILE#${DOTFILE_DIR}/}"
  link_file "${DOTFILE}" "${TARGET}"
done
