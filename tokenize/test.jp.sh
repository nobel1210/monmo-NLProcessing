#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo/mongo.env

usage (){
cat<<USAGE
Usage :
  tokenize.jp.sh [options]

Summary:
  Parse Japanese sentense by morphological analysis.
  It use "analysis.dictionary" collelction as dictionary by default.

    Use "gendic.sh" to create dictionary collection.

Options :
    -h, --help                : This message
    -d, --dictionary  ns      : Dictionary collection ns
    -i, --input       string  : Input sentense directly
USAGE
  exit $1
}

DIC="var _DIC='analysis.dictionary';"

OPTIONS=`getopt -o hd:i: --long help,dictionary:,input:, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-d|--dictionary) DIC="var _DIC='${OPTARG}';";shift;;
				-i|--input)      SENTENSE="var _SENTENSE='`echo \"${OPTARG}\"|tr "\n" " "`';";shift;;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONGO_SHELL} ${MONGO_NODE} --quiet --eval "${DIC}${SENTENSE}"  ${CURDIR}/../monmo/lib/utils.js  ${CURDIR}/lib/dictionary.js  ${CURDIR}/lib/morpho.js  ${CURDIR}/lib/jptokenizer.js  ${CURDIR}/lib/test.jp.js | grep -v '^loading file:'
