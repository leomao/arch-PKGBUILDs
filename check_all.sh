#! /bin/bash -e
# vim: set noet:

PKGDIR=$(realpath $(dirname $0))

cd $PKGDIR

printfmt=' %-30s%18s%18s\n'
printf "$printfmt" 'Package name' 'Current version' 'New version'
printf "$printfmt" | tr ' ' '-'

for pkgdir in $(ls -d */ | tr -d '/'); do
	if [[ $pkgdir =~ '-git' ]]; then
		continue
	else
		bash check_update.sh $pkgdir
	fi
done
