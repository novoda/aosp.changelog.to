#!/bin/sh

# This script does a diff of the tags for AOSP since last time it ran
# if a new tag is found it will email the address given as the first arguemnt

ALERT_ADDRESS=$1

WORK_DIRECTORY=~/aosp/checkouts/
GIT_LOG=~/aosp/build.gitlog
TAGS_FILE=~/aosp/existing_build_tags

if [ ! -d $WORK_DIRECTORY ]; then
	mkdir -p $WORK_DIRECTORY
fi

if [ ! -f $TAGS_FILE ]; then
	touch $TAGS_FILE
fi

cd $WORK_DIRECTORY
if [ ! -d build ]; then 
	git clone https://android.googlesource.com/platform/build 
fi

cd build
echo ------ >> $GIT_LOG
date >> $GIT_LOG
git pull >> $GIT_LOG 2>&1
git tag -l > $TAGS_FILE.new 2>> $GIT_LOG

diff $TAGS_FILE $TAGS_FILE.new > $TAGS_FILE.diff
rm $TAGS_FILE
mv $TAGS_FILE.new $TAGS_FILE

if [ -s $TAGS_FILE.diff ]; then
	mail -s "New AOSP Build Tags" $ALERT_ADDRESS < $TAGS_FILE.diff
else
	echo "No new tags found" >> $GIT_LOG
fi
