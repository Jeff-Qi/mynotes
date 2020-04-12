#!/bin/bash
path='/h/data/atom/'
file=(linux Python network mysql Docker redis)
for i in ${file[*]};
do
	cd $path$i
	read -p "input message to git $i notes: " note_message
	git add -A && git commit -m "$note_message" && git push origin master
done

read -p "whether to git the atom file to github! Y/N: " git_push
if [[ $git_push == Y || $git_push == y ]];
then
	read -p 'input message to git notes to github: ' message
	cd $path && git add -A && git commit -m "$message" && git push origin master
fi
