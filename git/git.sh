#!/bin/bash

for remote_branch in $(git branch -r); do
    local_branch=$(basename $remote_branch)
    git checkout -b $local_branch $remote_branch
done
