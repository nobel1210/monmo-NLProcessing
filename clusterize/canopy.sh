#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  canopy.sh [options]

Options :
    -h, --help                : This message
    -s, --source       ns     : Target collection ns
    -o, --output      ns      : Output collection ns
    -f, --filed        name   : Vector field                      (defalut : 'value')
    -t, --threshold    float  : Cluster member minimum threashold (defalut : 0.1)
                              :  Ignoring clusters having member less than "#all-member / #cluster * threshold"
    -2, --t2   float          : T2 cluster redius                 (defalut : 0.93)
    -1, --t1   float          : T1 have to be bigger than T2      (defalut : 0.94)
    -N, --normalize           : Normalize vector
USAGE
  exit $1
}

FIELD="F:'value'"
THRESHOLD="T:0.1";
T2="T2:0.93";
T1="T1:0.94";
NORMALIZE="N:false";


OPTIONS=`getopt -o hs:o:f:t:1:2:N --long help,source:,output:,field:,threshold:,t1:,t2:normalize, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)         usage 0 ;;
				-s|--source)       SRC="-s ${OPTARG}";shift;;
				-o|--output)       OUT="-o ${OPTARG}";shift;;
				-f|--field)        FIELD="F:'${OPTARG}'";shift;;
				-t|--threshold)    THRESHOLD="T:${OPTARG}";shift;;
				-2|--t2)           T2="T2:${OPTARG}";shift;;
				-1|--t1)           T1="T1:${OPTARG}";shift;;
				-N|--normalize)    NORMALIZE="N:true";;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONMO_ROOT}/bin/jobctl.sh ${SRC} ${OUT} -a "{${FIELD},${THRESHOLD},${T1},${T2},${NORMALIZE}}" -f ${CURDIR}/jobs/canopy3.js
