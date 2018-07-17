#!/bin/sh

main()
{
    ARCHIVE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0;}' $0)
    tail -n+$ARCHIVE $0 | tar xz >/dev/null 2>&1

	INSTALL_DIR=`pwd`/_root_ sh _root_/install.sh
	rm -rf _root_

    exit 0
}
main

# This line must be the last line of the file
__ARCHIVE_BELOW__
