#! /bin/sh

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "help" ] || [ -z "$1" ]; then
  cat << EOF
$ prompt.sh FILE.txt
Answer the questions and calculate the result
EOF
  exit
fi

printf "Answering file: $1

Possible answers (no validation):
Very Untrue: 1
Untrue:      2
Normal:      3
True:        4
Very True:   5

"

G1=0
G2=0
G3=0
G4=0
G5=0

G1C=0
G2C=0
G3C=0
G4C=0
G5C=0

IFS=$'\n'
for line in $(cat $1); do
  G=$(echo $line | awk '{print $1}')

  if [ "$G" = "rev" ]; then
    G=$(echo $line | awk '{print $2}')
    IS_REV=1

    q="$(echo $line | cut -d\  -f3-)"
  else
    IS_REV=0

    q="$(echo $line | cut -d\  -f2-)"
  fi

  printf "\"$q\": "
  read res

  echo $res >> backup_answers

  if [ "$IS_REV" -eq 1 ]; then
    case $res in
      1) res=5;;
      2) res=4;;
      4) res=2;;
      5) res=1;;
    esac
  fi

  case $G in
    1) G1=$(($G1+$res))
      G1C=$(($G1C+1));;
    2) G2=$(($G2+$res))
      G2C=$(($G2C+1));;
    3) G3=$(($G3+$res))
      G3C=$(($G3C+1));;
    4) G4=$(($G4+$res))
      G4C=$(($G4C+1));;
    5) G5=$(($G5+$res))
      G5C=$(($G5C+1));;
  esac
done

calc() {
  node -e "console.log($@)"
}

if [ "$G2C" -gt 0 ]; then
  printf "
  Results:
    G1: $(calc "$G1/$G1C") ($G1/$G1C)
    G2: $(calc "$G2/$G2C") ($G2/$G2C)
    G3: $(calc "$G3/$G3C") ($G3/$G3C)
    G4: $(calc "$G4/$G4C") ($G4/$G4C)
    G5: $(calc "$G5/$G5C") ($G5/$G5C)
"
else
  printf "
  Results for $1:
    G1: $(calc "$G1/$G1C") ($G1/$G1C)
"
fi
