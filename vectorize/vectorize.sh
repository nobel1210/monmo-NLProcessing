#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  all.sh [options]

Summary:
  This is an automation script

  Calculate the TF/IDF from tokens in the specified collection.
  

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns
    -t, --threshold   float   : IDF threashold minimum proportion (defalut : 0.0)
    -l, --limit       float   : IDF threashold maximum proportion (defalut : 0.40)
    -v, --verb-only           : Pickup verb only
USAGE
  exit $1
}

OPTIONS=`getopt -o hs:t:l:vj:C --long help,source:,threshold:,limit:,verb-only, -- "$@"`

if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-s|--source)     SRC="${OPTARG}";shift;;
				-t|--threshold)  THRESHOLD=" -t ${OPTARG} ";shift;;
				-l|--limit)      LIMIT=" -l ${OPTARG} "shift;;
				-v|--verb-only)  VERB=" -v ";;
				--) shift;break;;
				# *) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done


SRCDB=`echo ${SRC} | sed -e 's/^\([^\.]\+\)\.\(.\+\)/\1/'`
SRCCOL=`echo ${SRC} | sed -e 's/^\([^\.]\+\)\.\(.\+\)/\2/'`

TF=${SRCDB}'.vector.tf.'${SRCCOL}
DF=${SRCDB}'.vector.df.'${SRCCOL}
IDF=${SRCDB}'.vector.idf.'${SRCCOL}
TFIDF=${SRCDB}'.vector.tfidf.'${SRCCOL}

$CURDIR/tf.sh    -s ${SRC} -o ${TF} 
$CURDIR/df.sh    -s ${TF}  -o ${DF} 
$CURDIR/idf.sh   -s ${DF}  -o ${IDF}
$CURDIR/idf.sh   -s ${DF}  -o ${IDF} ${THRESHOLD} ${LIMIT} ${VERB}
$CURDIR/tfidf.sh -s ${IDF} -o ${TFIDF}





