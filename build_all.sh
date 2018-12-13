#! /bin/zsh -e
# vim: set noet:

PKGDIR=$(realpath $(dirname $0))

cd $PKGDIR

./build_srcinfo.sh

allpkg=$(ls -d */ | tr -d '/')
torder=$(aur graph $PKGDIR/*/.SRCINFO | tsort | tac)
nonorder=$(comm -23 <(echo $allpkg | sort) <(echo $torder | sort) | sed '/^$/d')

for pdir in $(echo $torder $nonorder); do
	if [[ $pdir =~ ".*-git" ]]; then
		continue
	fi

	pkg1=$(grep 'pkgname = ' $pdir/.SRCINFO | awk '{print $3}' | head -n 1)
	repo_ver=$(pacman -Si $pkg1 2> /dev/null | grep Version | awk '{print $3}')
	latest_ver=$(
		pkgver=$(grep pkgver $pdir/.SRCINFO | awk '{print $3}')
		pkgrel=$(grep pkgrel $pdir/.SRCINFO | awk '{print $3}')
		echo $pkgver-$pkgrel
	)

	if [[ -z $repo_ver || $(vercmp $latest_ver $repo_ver) -gt 0 ]]; then
		cd $pdir
		echo $pdir
		echo "$repo_ver -> $latest_ver"
		# build the packages as ADMIN
		aur build -d custom -- -crs --noconfirm
		cd $OLDPWD # equiv to cd - but without echo its path
	fi
done
