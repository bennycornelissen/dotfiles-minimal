#!/usr/bin/env bash
# shellcheck disable=2086
set -euo pipefail

readonly commit_message_file="${1?ERROR: Argument missing}"
readonly tmpdir="$(mktemp -d)"
readonly tmpfile="${tmpdir}/commit-temp"

cleanup_on_exit() {
  if [[ -d ${tmpdir} ]]; then
    rm -rf "${tmpdir}"
  else
    echo "${tmpdir} temp dir is not a dir"
  fi
}

trap cleanup_on_exit EXIT

cat ${commit_message_file} | cowsay >"${tmpfile}"

cp ${tmpfile} ${commit_message_file}
