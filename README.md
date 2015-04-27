# AOSP Changelog Generator
Receive a notification email every time a new git tag is found in AOSP<br/>
_Will_ generates a change log between different aosp tags. 

### Usage
#### New tag notification
```
$ ./check_for_new_build_label.sh <notification email address> <AOSP working directory>
```

The param `AOSP working directory` is optional and must specify the *absolute* path of the directory in which the whole AOSP code will be cloned.
If this parameter is passed, when a new tag is found on the remote the creation of the corresponding changelog HTML page is started automatically.

#### Changelog generation
To generate a changelog between two tags use
```
$ ./get_gitlog.sh <old tag> <new tag>
```
from the AOSP working directory.

#### Changelog publication
Every time a new changelog is generated, it is published in the `gh-pages` branch of the current repo.
This requires the `gh-pages` branch to exist in the current repo.

The `gh-pages` branch is cloned in a subdirectory of the generator repo, the changelog is copied from the AOSP_DIRECTORY, committed and pushed, using the script
```
$ ./upload_to_gh_pages.sh <AOSP working directory>
```
The param `AOSP working directory` is **mandatory** and must specify the *absolute* path of the directory in which the whole AOSP code has been cloned.
