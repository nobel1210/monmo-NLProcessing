#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  viewvector.sh [options]

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns
    -V, --verbose             : 
    -L, --verbose-length      : View document size
USAGE
  exit $1
}

EVAL=''

VERBOSE="var _VERBOSE=false;"
VERBOSE_LEN="var _VERBOSE_LEN=10;"

OPTIONS=`getopt -o hs:v:t:VL: --long help,source:,verbose,verbose-length: -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-s|--source)     EVAL="${EVAL}var _SRC='${OPTARG}';";shift;;
				-V|--verbose)    VERBOSE="var _VERBOSE=true;";;
				-L|--verbose-length)  VERBOSE_LEN="var _VERBOSE_LEN=${OPTARG};";shift;;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONGO_SHELL} ${MONGO_NODE} --quiet --eval "${EVAL}${DIC}${VERBOSE}${VERBOSE_LEN}" ${MONMO_ROOT}/lib/utils.js ${CURDIR}/lib/viewvector.js | grep -v '^loading file:'
