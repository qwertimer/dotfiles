#!/bin/bash

{
  umask 0077

if [ -n "$SSH_TTY" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

if eval `ssh-agent -s`; then
  if [ "$HOSTNAME" == 'syl-ubuntu' ]; then
    [ -z "$SSH_TTY" ] && ssh-add "$HOME"/.ssh/id_ed25519
  fi
  trap 'kill $SSH_AGENT_PID' EXIT
fi
} &> /dev/null
