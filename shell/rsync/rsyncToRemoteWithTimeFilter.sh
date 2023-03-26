#!/bin/bash

SOURCE="/homes/path/to/folder"              # 來源
TARGET="/targetFolder"                      # 儲存目標
SSHSERVER="user@ip"                         # 遠端SERVER
SSHPORT="22"                                # 遠端SERVER PORT
SYNCDAYS="5"                                # 同步天數

rsync \
    -ahrv \
    -e "ssh -p $SSHPORT" \
    --progress \
    --files-from=<(find $SOURCE -mtime -$SYNCDAYS -type f -exec realpath --relative-to $SOURCE {} \;) \
    $SOURCE \
    "${SSHSERVER}:${TARGET}" 
