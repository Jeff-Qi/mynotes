#!/bin/bash
path='/h/data/atom/'
file=(linux Python network mysql Docker redis)
for i in ${file[*]};
do
	cd $path$i
	git add -A && git commit -m 'update notes' && git push origin master
done
