#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo/mongo.env

usage (){
cat<<USAGE
Usage :
  keyword_search.sh [options]

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns
    -w, --word        string  : Search word
    -F, --forward-match       : Left-hand match
    -V, --verbose             : With document
    -L, --verbose-length      : View document size
USAGE
  exit $1
}

EVAL=''
WORD=''
FOWARD=''
VERBOSE="var _VERBOSE=false;"
VERBOSE_LEN="var _VERBOSE_LEN=80;"

OPTIONS=`getopt -o hs:v:w:FVL: --long help,source:,word:,forward-match,verbose,verbose-length:, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-s|--source)     EVAL="${EVAL}var _SRC='${OPTARG}';";shift;;
				-w|--word)       WORD="${OPTARG}";shift;;
				-F|--forward-match)   FORWARD=1;;
				-V|--verbose)         VERBOSE="var _VERBOSE=true;";;
				-L|--verbose-length)  VERBOSE_LEN="var _VERBOSE_LEN=${OPTARG};";shift;;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

QUERY="var _QUERY={w:'$WORD'};"
if [ "$FORWARD" = "1" ];then
		QUERY="var _QUERY={w:/^$WORD/};"
fi

${MONGO_SHELL} ${MONGO_NODE} --quiet --eval "${EVAL}${QUERY}${VERBOSE}${VERBOSE_LEN}" ${CURDIR}/../monmo/lib/utils.js ${CURDIR}/lib/search.js | grep -v '^loading file:'
