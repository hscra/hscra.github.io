#!/bin/bash

# CONFIG_FILE=_config.yml 

# /bin/bash -c "rm -f Gemfile.lock && exec jekyll serve --watch --port=8080 --host=0.0.0.0 --livereload --verbose --trace --force_polling"&

# while true; do

#   inotifywait -q -e modify,move,create,delete $CONFIG_FILE

#   if [ $? -eq 0 ]; then
 
#     echo "Change detected to $CONFIG_FILE, restarting Jekyll"

#     jekyll_pid=$(pgrep -f jekyll)
#     kill -KILL $jekyll_pid

#     /bin/bash -c "rm -f Gemfile.lock && exec jekyll serve --watch --port=8080 --host=0.0.0.0 --livereload --verbose --trace --force_polling"&

#   fi

# done

CONFIG_FILE=_config.yml

# Start Jekyll with live reload and watch enabled
bundle exec jekyll serve \
  --watch \
  --port=8080 \
  --host=0.0.0.0 \
  --livereload \
  --incremental \
  --force_polling \
  --verbose \
  --trace &
jekyll_pid=$!

# Only restart if _config.yml changes
while true; do
  inotifywait -q -e modify,move,create,delete $CONFIG_FILE
  if [ $? -eq 0 ]; then
    echo "Change detected to $CONFIG_FILE, restarting Jekyll"

    kill -KILL $jekyll_pid

    bundle exec jekyll serve \
      --watch \
      --port=8080 \
      --host=0.0.0.0 \
      --livereload \
      --incremental \
      --force_polling \
      --verbose \
      --trace &
    jekyll_pid=$!
  fi
done
