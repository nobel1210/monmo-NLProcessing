#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  idf.sh [options]

Summary:
  Calculate the TF (Term-Frequency) from documents in the specified collection.

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns ( Tokenized collection )
    -o, --output      ns      : Output collection ns
    -t, --threshold   float   : IDF threashold minimum proportion (defalut : 0.0)
    -l, --limit       float   : IDF threashold maximum proportion (defalut : 0.40)
    -v, --verb-only           : Pickup verb only
USAGE
  exit $1
}


THRESHOLD="T:0.0";
LIMIT="L:0.40";
VERB="V:false";

OPTIONS=`getopt -o hs:o:t:l:v --long help,source:,output:,threshold:,limit:,verb-only -- "$@"`
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
				-l|--limit)      LIMIT="L:${OPTARG}";shift;;
				-v|--verb-only)  VERB="V:true";;
				--) shift;break;;
				# *) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONMO_ROOT}/bin/jobctl.sh ${SRC} ${OUT} -a "{${THRESHOLD},${LIMIT},${VERB}}" -f ${CURDIR}/jobs/idf.js
