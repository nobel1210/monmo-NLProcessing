#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo/mongo.env

usage (){
cat<<USAGE
Usage :
  keyword_search.sh [options]

Options :
    -h, --help                : This message
    -D, --dictionary          : Dictionary collection ns
    -w, --word        string  : Search word
    -F, --forward-match       : Left-hand match
    -V, --verbose             : 
USAGE
  exit $1
}

EVAL=''
WORD=''
FOWARD=''
DIC="var _DIC='analysis.dictionary';"
VERBOSE="var _VERBOSE=false;"

OPTIONS=`getopt -o hD:v:w:FV --long help,dictionary:,word:,forward-match,verbose, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-D|--dictionary)    DIC="var _DIC='${OPTARG}';";shift;;
				-w|--word)          WORD="${OPTARG}";shift;;
				-F|--forward-match) FORWARD=1;;
				-V|--verbose)       VERBOSE="var _VERBOSE=true;";;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

QUERY="var _QUERY={w:'$WORD'};"
if [ "$FORWARD" = "1" ];then
		QUERY="var _QUERY={w:/^$WORD/};"
fi

${MONGO_SHELL} ${MONGO_NODE} --quiet --eval "${EVAL}${DIC}${QUERY}${VERBOSE}" ${CURDIR}/../monmo/lib/utils.js ${CURDIR}/lib/dictionary.js ${CURDIR}/lib/moddic.js | grep -v '^loading file:'


