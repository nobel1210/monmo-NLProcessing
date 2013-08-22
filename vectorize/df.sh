#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  df.sh [options]

Summary:
  Calculate the DF (Document-Frequency) from TF.

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns > ( TF collection )
    -o, --output      ns      : Output collection ns
USAGE
  exit $1
}



OPTIONS=`getopt -o hs:o: --long help,source:,output:, -- "$@"`
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
				--) shift;break;;
				# *) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONMO_ROOT}/bin/jobctl.sh ${SRC} ${OUT} -f ${CURDIR}/jobs/df.js
