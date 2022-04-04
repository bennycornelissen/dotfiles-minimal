#!/bin/bash
set -e

umask 0027

echo "Getting Shell Libs and Shell Scripts Git repos"
git clone --depth=1 https://github.com/bennycornelissen/shell-libs.git dotdir/.shell-libs
git clone --depth=1 https://github.com/bennycornelissen/shell-scripts.git dotdir/bin

INSTALLDIR=${HOME}
echo "Using INSTALLDIR = $INSTALLDIR"

for myfile in $(ls -A dotdir/ ); do

  # Clean up old symlinks and backup existing config files
	if [ -h $INSTALLDIR/$myfile ]; then
		unlink $INSTALLDIR/$myfile
	elif [ -f $INSTALLDIR/$myfile ]; then
		mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2> /dev/null
	elif [ -d $INSTALLDIR/$myfile ]; then
		mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2> /dev/null
	fi

  # Create symlinks for our config files
	ln -s $PWD/dotdir/$myfile $INSTALLDIR/$myfile

done

# Clean up old shell config files we don't want
  V_SHELLCONFIGS_DONOTWANT=".profile"
  for myfile in ${V_SHELLCONFIGS_DONOTWANT}; do
    if [ -h $INSTALLDIR/$myfile ]; then
      unlink $INSTALLDIR/$myfile
  	elif [ -f $INSTALLDIR/$myfile ]; then
      mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2> /dev/null
  	elif [ -d $INSTALLDIR/$myfile ]; then
      mv $INSTALLDIR/$myfile $INSTALLDIR/${myfile}.old 2> /dev/null
  	fi
  done

exit 0
