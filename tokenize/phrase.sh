#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  phrase.sh [options]

Summary:
  Analyze phrases from tokenized collection by using C-VALUE.

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns > ( TF collection )
    -o, --output      ns      : Output collection ns
    -t, --threshold   float   : IDF threashold minimum proportion (defalut : 0.0)
    -n, --ngram       int     : N of N-gram (default: 4)
USAGE
  exit $1
}

THRESHOLD="T:0.0";
NGRAM="N:4";

OPTIONS=`getopt -o hs:o:t:n: --long help,source:,output:,threshold:,ngram:, -- "$@"`
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
				-t|--threshold)  THRESHOLD="T:${OPTARG}";shift;;
				-n|--ngram)      NGRAM="N:${OPTARG}";shift;;
				--) shift;break;;
				# *) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONMO_ROOT}/bin/jobctl.sh ${SRC} ${OUT} -a "{${THRESHOLD},${NGRAM}}" -f ${CURDIR}/lib/dictionary.js -f ${CURDIR}/jobs/phrase.js
