#!/bin/sh

key=$(git config ssh.key)

if [ -z "$key" ]; then
  git_opts=""
else
  git_opts="-i ${key}"
fi

exec ssh $git_opts "$@"
