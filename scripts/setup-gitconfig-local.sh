#!/bin/bash

set -e
set -o pipefail

echo "[setup-gitconfig-local] Setting up local Git config."
name="$(git config --global --includes user.name)" || true
if [[ $name ]]; then
    echo "[setup-gitconfig-local] Full name: $name"
    echo -n "[setup-gitconfig-local] Is this correct? (y/n) "
    read answer
    if ! (echo "$answer" | grep -qi "^y"); then
        name=
    fi
fi
while [[ -z $name ]]; do
    echo -n "[setup-gitconfig-local] Full name: "
    read name
done

email="$(git config --global --includes user.email)" || true
if [[ $email ]]; then
    echo "[setup-gitconfig-local] Email address: $email"
    echo -n "[setup-gitconfig-local] Is this correct? (y/n) "
    read answer
    if ! (echo "$answer" | grep -qi "^y"); then
        email=
    fi
fi
while [[ -z $email ]]; do
    echo -n "[setup-gitconfig-local] Email address: "
    read email
done

editor="$(git config --global --includes core.editor)" || true
if [[ $editor ]]; then
    echo "[setup-gitconfig-local] Editor: $editor"
    echo -n "[setup-gitconfig-local] Is this correct? (y/n) "
    read answer
    if ! (echo "$answer" | grep -qi "^y"); then
        editor=
    fi
fi
if [[ -z $editor ]]; then
    echo -n "[setup-gitconfig-local] Editor (leave blank to use ${EDITOR:-vim}): "
    read editor
fi

contents=

format=$(cat <<'EOF'
[user]
        name = %s
        email = %s
EOF
      )
contents="$contents$(printf "$format" "$name" "$email")"$'\n'

if [[ $editor ]]; then
    format=$(cat <<'EOF'
[core]
        editor = %s
EOF
          )
    contents="$contents$(printf "$format" "$editor")"$'\n'
fi

echo -n "$contents" > ../../dotfiles-local/.gitconfig.local
echo "[setup-gitconfig-local] Wrote the following to dotfiles-local/.gitconfig.local:"
cat ../../dotfiles-local/.gitconfig.local