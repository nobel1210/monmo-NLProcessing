#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  fulltext_search.sh [options]

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns
    -w, --word        string  : Search word
    -V, --verbose             : With document
USAGE
  exit $1
}

EVAL=''
FOWARD=''
VERBOSE="var _VERBOSE=false;"
VERBOSE_LEN="var _VERBOSE_LEN=80;"

OPTIONS=`getopt -o hs:v:w:L:V --long help,source:,word:,forward-match,verbose, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-s|--source)     EVAL="${EVAL}var _SRC='${OPTARG}';";shift;;
				-w|--word)       EVAL="${EVAL}var _WORD='${OPTARG}';";shift;;
				-V|--verbose)    VERBOSE="var _VERBOSE=true;";;
				-L|--verbose-length)  VERBOSE_LEN="var _VERBOSE_LEN=${OPTARG};";shift;;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONGO_SHELL} ${MONGO_NODE} --quiet --eval "${EVAL}${VERBOSE}${VERBOSE_LEN}" ${MONMO_ROOT}/lib/utils.js ${CURDIR}/../tokenize/lib/dictionary.js ${CURDIR}/../tokenize/lib/morpho.js ${CURDIR}/../tokenize/lib/jptokenizer.js ${CURDIR}/lib/search.js | grep -v '^loading file:'
