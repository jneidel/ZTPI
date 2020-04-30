#! /bin/sh

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "help" ]; then
  cat << EOF
$ to_json.sh
Convert txt files to json
EOF
  exit
fi

for file in $(find . -name '*.txt'); do
  BASE_FILE="$(basename ${file%.*})"
  JSON="$BASE_FILE.json"

  echo "[" > $JSON

  cat $file | while read line; do
    NR=$(echo $line | awk '{print $1}')

    if [ "$NR" = "rev" ]; then
      NR=$(echo $line | awk '{print $2}')
      IS_REV=true

      line="$(echo $line | cut -d\  -f3-)"
    else
      IS_REV=false

      line="$(echo $line | cut -d\  -f2-)"
    fi

    echo "{ \"question\": \"$line\", \"group\": $NR, \"isReversed\": $IS_REV }," >> $JSON
  done

  echo "]" >> $JSON

  # remove last comma
  TMP=$(mktemp)
  tac $JSON | sed '2s:,$::' | tac > $TMP
  cp $TMP $JSON
done

