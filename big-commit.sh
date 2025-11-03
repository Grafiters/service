#!/usr/bin/env bash
# Find biggest blobs (files) ever committed in Git, in MB/GB units

echo "🔍 Scanning Git repository for large commits..."

git rev-list --objects --all \
  | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
  | awk '/^blob/ {print $3, $4}' \
  | sort -n -r \
  | head -30 \
  | awk '{
      size=$1;
      if (size < 1024) {
        unit="B";
      } else if (size < 1048576) {
        size=size/1024; unit="KB";
      } else if (size < 1073741824) {
        size=size/1048576; unit="MB";
      } else {
        size=size/1073741824; unit="GB";
      }
      printf "%8.2f %s  %s\n", size, unit, $2;
    }'
