#!/bin/bash
set -e

umask 0027

echo "Getting Shell Libs and Shell Scripts Git repos"
git clone --depth=1 https://github.com/bennycornelissen/shell-libs.git dotdir/.shell-libs
git clone --depth=1 https://github.com/bennycornelissen/shell-scripts.git dotdir/bin

if command -v brew 2>/dev/null; then
  brew install starship direnv
fi

TOPLEVEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
INSTALLDIR=${HOME}
echo "Install Symlinked files..."
echo "Using INSTALLDIR = $INSTALLDIR"

for myfile in $(ls -A dotdir/ ); do

  echo "$myfile"

  # Clean up old symlinks and backup existing config files
	if [ -h $INSTALLDIR/$myfile ]; then
		unlink $INSTALLDIR/$myfile
	elif [ -f $INSTALLDIR/$myfile ]; then
		mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2> /dev/null
	elif [ -d $INSTALLDIR/$myfile ]; then
		mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2> /dev/null
	fi

  # Create symlinks for our config files
	ln -s $TOPLEVEL_DIR/dotdir/$myfile $INSTALLDIR/$myfile

done

echo "Apply specific patches..."

# Gitconfig patch
echo -n "Gitconfig patch.. "
cat $TOPLEVEL_DIR/patches/gitconfig.patch >> $INSTALLDIR/.gitconfig
echo "done"

# Starship prompt
echo -n "Starship Config.. "
mkdir -p $INSTALLDIR/.config
cat $TOPLEVEL_DIR/patches/starship.toml.full > $INSTALLDIR/.config/starship.toml
cat $TOPLEVEL_DIR/patches/bash-prompt.patch > $INSTALLDIR/.bashrc.d/999-bash-prompt
echo "done"

# Direnv config
echo -n "Direnv Config.. "
mkdir -p $INSTALLDIR/.config/direnv
cat $TOPLEVEL_DIR/patches/direnvrc.full > $INSTALLDIR/.config/direnv/direnvrc
echo "done"

exit 0
