#!/bin/bash
usage="usage:
    codejamtest
        run from within the problem directory it moves input from Downloads and does a few sanity tests
"
die(){ echo "${usage}" >&2; exit 1; }

num_py_files="$(ls *.py | wc -l)"
[ "$num_py_files" -eq "1" ] || die

solution="$(ls *.py)"

mv $HOME/Downloads/*practice.in* .  2>/dev/null

for i in $(ls *.in*); do
    o="$(sed 's/\.in/.out/' <<<$i)"
    python "${solution}" <"$i" >"$o"
    num_of_test_cases="$(head -1 $i)"
    [ "${num_of_test_cases}" -eq "$(cat ${o} | wc -l)" ] || { echo >&2 "Incorrect number of test cases in ${o}."; exit 1; }

#    add more sanity checks

    echo "${o} seems good."
done

