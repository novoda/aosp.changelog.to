# AOSP Changelog Generator
Receive a notification email every time a new git tag is found in AOSP<br/>
_Will_ generates a change log between different aosp tags. 

### Usage
#### New tag notification
```
$ ./check_for_new_build_label.sh <notification email address> <AOSP working directory>
```

The param `AOSP working directory` is optional and must specify the *absolute* path of the directory in which will be cloned the whole AOSP code.
If this param is specified, when a new tag is found then the related changelog html page is automatically generated 

#### Changelog generation
To generate a changelog between two tags use
```
./get_gitlog.sh <old tag> <new tag>
```
