dest=$1;
[ "$dest" == "" ] && dest="root@dev.vyew.com"
ssh -C2 -D8080 $dest
