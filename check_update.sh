#! /bin/bash

pkgdir=$1
source $pkgdir/PKGBUILD

current_ver=$pkgver

printf ' >>> %-50s\r' "checking $pkgdir..."

if [[ -n $_github ]]; then
  # this method has rate limit...
  #latest_ver=$(curl https://api.github.com/repos/$_github/releases/latest 2> /dev/null | jq -r '.tag_name')
  #latest_ver=$(curl -L https://github.com/$_github/releases/latest 2> /dev/null | grep -oP '(?<=tag/)v?[0-9.]+(?=")' | head -n 1)
  latest_ver=$(curl -L https://github.com/$_github/releases 2> /dev/null | grep -oP '(?<=tag/)v?[0-9.]+(?=")' | head -n 1)
  latest_ver=${latest_ver/v/}
elif [[ -n $_pypiname ]]; then
  _pypiname=${_pypiname//_/-}
  jsondata=$(curl https://pypi.org/pypi/$_pypiname/json 2> /dev/null)
  latest_ver=$(echo $jsondata | jq -r ".info.version")
  source_url=$(echo $jsondata | jq '.urls | map(select(.packagetype == "sdist")) | .[0].url')
elif [[ -s "$pkgdir/check_update.sh" ]]; then
  latest_ver=$(bash $pkgdir/check_update.sh)
fi

printfmt=' %-30s%18s%18s\n'
if [[ -z $latest_ver ]]; then
  latest_ver=FAILED
elif [[ `vercmp $latest_ver $current_ver` -ne 0 ]]; then
  printf "$printfmt" $pkgdir $current_ver $latest_ver
fi
