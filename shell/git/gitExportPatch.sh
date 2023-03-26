git diff \
     --binary  \
     {start_commit_id} {end_commit_id}  \
     --patch > {export_patch_path_dir}/{export_patch_path_name}.patch
# git diff --binary 79e8e0d95db7c6eb437ab40fa03210498c83bd20 9b4252aa7f5ab2a64acd30012032731e3005468e --patch > /c/Users/test/Desktop/kr_git_patch.patch

git format-patch \
    -{commit_count} {commit_id}  \
    -o {export_patch_path_dir}
# git format-patch -1 9b4252aa7f5ab2a64acd30012032731e3005468e -o /c/Users/test/Desktop