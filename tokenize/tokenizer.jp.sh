#!/usr/bin/env bash
CURDIR=`dirname $0`

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
    -s, --source      ns      : Target collection ns
    -f, --field       name    : Target field
    -o, --output      ns      : Output collection ns
USAGE
  exit $1
}


DIC="D:'analysis.dictionary'"
FIELD="F:'body'"

OPTIONS=`getopt -o hd:s:o:f: --long help,dictionary:,source:,output:,field:, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-s|--source)     SRC="-s ${OPTARG}";shift;;
				-o|--output)     OUT="-o ${OPTARG}";shift;;
				-d|--dictionary) DIC="D:'${OPTARG}'";shift;;
				-f|--field)      FIELD="F:'${OPTARG}'";shift;;
				--) shift;break;;
    esac
		shift
done

${CURDIR}/../monmo/bin/jobctl.sh ${SRC} ${OUT} -a "{${DIC},${FIELD}}" -f ${CURDIR}/lib/dictionary.js -f ${CURDIR}/lib/morpho.js -f ${CURDIR}/lib/jptokenizer.js -f ${CURDIR}/jobs/tokenize.js
