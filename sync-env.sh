#! /bin/sh
set -e

ROOT_USER_FOLDER=~/

# test for stow
if ! command -v stow &> /dev/null
then
    echo "This script needs stow to be executed!"
    exit
fi

echo "linking home directory"
## Symlink config files
stow -v -R --no-folding --target=$ROOT_USER_FOLDER .

echo "Sync complete."
