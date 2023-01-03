#!/bin/bash

SOURCE="/homes/cylee/NTTUDB/NTTU_TEST"      # 來源
TARGET="/rsyncfolder"                       # 儲存目標
SSHSERVER="sysdev@10.1.111.40"              # 遠端SERVER
SSHPORT="22"                                # 遠端SERVER PORT
SYNCDAYS="5"                                # 同步天數

rsync \
    -ahrv \
    -e "ssh -p $SSHPORT" \
    --progress \
    --files-from=<(find $SOURCE -mtime -$SYNCDAYS -type f -exec realpath --relative-to $SOURCE {} \;) \
    $SOURCE \
    "${SSHSERVER}:${TARGET}" 
