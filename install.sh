#!/bin/bash
set -e

umask 0027
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
TOPLEVEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
INSTALLDIR=${HOME}
echo "
Using TOPLEVEL_DIR = $TOPLEVEL_DIR
Using INSTALLDIR = $INSTALLDIR
"

echo "Getting Shell Libs and Shell Scripts Git repos"
[[ ! -d $TOPLEVEL_DIR/dotdir/.shell-libs ]] && git clone --depth=1 https://github.com/bennycornelissen/shell-libs.git $TOPLEVEL_DIR/dotdir/.shell-libs
[[ ! -d $TOPLEVEL_DIR/dotdir/bin ]] && git clone --depth=1 https://github.com/bennycornelissen/shell-scripts.git $TOPLEVEL_DIR/dotdir/bin

if command -v brew 2>/dev/null; then
  brew install starship direnv
fi

echo "Ensure directories exist.."
mkdir -p ${INSTALLDIR}/.config
mkdir -p ${INSTALLDIR}/.bashrc.d

echo "Install Symlinked files..."

for myfile in $(ls -A $TOPLEVEL_DIR/dotdir/); do

  echo "$myfile"

  # Clean up old symlinks and backup existing config files
  if [ -h $INSTALLDIR/$myfile ]; then
    unlink $INSTALLDIR/$myfile
  elif [ -f $INSTALLDIR/$myfile ]; then
    mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2>/dev/null
  elif [ -d $INSTALLDIR/$myfile ]; then
    mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2>/dev/null
  fi

  # Create symlinks for our config files
  ln -s $TOPLEVEL_DIR/dotdir/$myfile $INSTALLDIR/$myfile

done

echo "Apply specific patches..."

# Gitconfig patch
echo -n "Gitconfig patch.. "
cat $TOPLEVEL_DIR/patches/gitconfig.patch >>$INSTALLDIR/.gitconfig
echo "done"

# Starship prompt
echo -n "Starship Config.. "
mkdir -p $INSTALLDIR/.config
cat $TOPLEVEL_DIR/patches/starship.toml.full >$INSTALLDIR/.config/starship.toml
cat $TOPLEVEL_DIR/patches/bash-prompt.patch >$INSTALLDIR/.bashrc.d/999-bash-prompt
cat $TOPLEVEL_DIR/patches/bash-prompt.patch >>$INSTALLDIR/.bashrc
echo "done"

# Direnv config
echo -n "Direnv Config.. "
mkdir -p $INSTALLDIR/.config/direnv
cat $TOPLEVEL_DIR/patches/direnvrc.full >$INSTALLDIR/.config/direnv/direnvrc
echo "done"

exit 0
