#! /bin/zsh -e

lines=$(paste - - - | sed -E 's/^\[submodule "(.*)"\]\t\tpath = (.*)\t\turl = (.*)$/\1\t\2\t\3/g' | sort)

for line in ${(ps/\n/)lines}; do
	arr=(${(ps/\t/)line})
  sub=${arr[1]}
  url=${arr[3]}
  echo "git+$url"
done

echo ""

for line in ${(ps/\n/)lines}; do
	arr=(${(ps/\t/)line})
  sub=${arr[1]}
  url=${arr[3]}
  echo -e "git config submodule.\"${sub}\".url\t\${srcdir}/${url:t:r}"
done
