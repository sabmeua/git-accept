#!/bin/sh

FILE="tests/inputfile"
TESTCASES=tests/testcases

mkdir -p .bin
export PATH=./.bin:$PATH
cp git-accept .bin/
chmod +x .bin/git-accept

OK=0
NG=0

merge_test() {
  local name=$1
  local plan=$(echo $name | cut -d. -f2)
  git accept ${plan} ${FILE}
  diff ${TESTCASES}/${name} ${FILE}
  if [ $? -eq 0 ]; then
    OK=$(expr ${OK} + 1)
  else
    NG=$(expr ${NG} + 1)
    echo "NG : ${name}"
    cat ${FILE}
    echo
  fi
  git checkout -m ${FILE}
}

git checkout master -b conflict2
cp tests/conflict2 ${FILE}
git commit -a -m 'Add conflict 2'
git checkout master -b conflict1
cp tests/conflict1 ${FILE}
git commit -a -m 'Add conflict 1'

git merge conflict2

for testcase in $(ls ${TESTCASES}); do
  merge_test ${testcase}
done

git merge --abort
git checkout master
git branch -D conflict1
git branch -D conflict2

rm -rf .bin

cat <<RESULT
#
# ${OK} passed, ${NG} failed
#
RESULT

if [ ${NG} -ne 0 ]; then
  exit 1
fi

exit 0
