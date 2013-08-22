#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../monmo.env

usage (){
cat<<USAGE
Usage :
  kmeans.sh [options]

Options :
    -h, --help                : This message
    -s, --source         ns   : Target collection ns
    -o, --output      ns      : Output collection ns
    -f, --filed        name   : Vector field                      (defalut : 'value')
    -i, --inital-cluster ns   : Cluster collection ns (Initial centers)
    -c, --cluster-filed  name : Vector field                      (defalut : 'loc')
USAGE
//    -q, --query       query   : Target document
  exit $1
}


FIELD="F:'value'"
CFIELD="C:'loc'"




OPTIONS=`getopt -o hs:o:f:i:c:j:C --long help,source:,output:,field:,initial-cluster:,cluster-field:, -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi
eval set -- "$OPTIONS"
while true; do
    OPTARG=$2
    case $1 in
				-h|--help)       usage 0 ;;
				-s|--source)       SRC="-s ${OPTARG}";shift;;
				-o|--output)       OUT="-o ${OPTARG}";shift;;
				-f|--field)        FIELD="F:'${OPTARG}'";shift;;
				-i|--initial-cluster)  INITIAL="I:'${OPTARG}'";shift;;
				-c|--cluster-field)    CFIELD="C:'${OPTARG}'";shift;;
				--) shift;break;;
				*) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${MONMO_ROOT}/bin/jobctl.sh ${SRC} ${OUT} -a "{${FIELD},${INITIAL},${CFIELD}}" -f ${CURDIR}/jobs/kmeans.js
