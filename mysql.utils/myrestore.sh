#!/bin/sh



#Restore SQL first
for f in $(ls *.sql); do echo $f; mysql -p4tadapt6 vyew < ./$f ; done

#restore Data
for f in `ls -1 *.txt`;
  do mysqlimport -p4tadapt6 vyew `pwd`/$f;
done


#for f in `ls -1 *.txt`;  do echo $f; mysqlimport -p4tadapt6 vyew ./$f; done
