#
# Run this in the vX.XX directory to fix permissions after someone copies over a lot of files from dev
#

git diff|grep -B1 "old mode"|grep -v "^--$"|tr "\n" "@"|perl -pe 's/diff.*? b.(.*?)@old mode 100(...)/chmod \2 \1/g'|tr "@" "\n"|grep chmod > .tmp.perms.sh
sh .tmp.perms.sh
rm .tmp.perms.sh -f
