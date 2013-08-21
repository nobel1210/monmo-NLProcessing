#!/usr/bin/env bash
CURDIR=`dirname $0`

usage (){
cat<<USAGE
Usage :
  tf.sh [options]

Summary:
  Calculate the TF (Term-Frequency) from documents in the specified collection.

Options :
    -h, --help                : This message
    -s, --source      ns      : Target collection ns ( Tokenized collection )
    -o, --output      ns      : Output collection ns
    -q, --query       query   : Query          (default : {i:1} })
    -k, --key-filed   name    : Key field      (default : 'd')
    -w, --word-field  name    : Word field     (default : 'c')
USAGE
  exit $1
}

QUERY="Q:{i:1}"
KEY="K:'d'";
WORD="W:'c'";

OPTIONS=`getopt -o hs:o:q:k:w: --long help,source:,output:,query:,key-field:,word-field:, -- "$@"`
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
				-q|--query)      QUERY="Q:${OPTARG}";shift;;
				-k|--key-field)  KEY="K:'${OPTARG}'";shift;;
				-w|--word-field) WORD="W:'${OPTARG}'";shift;;
				--) shift;break;;
				# *) echo "Internal error! " >&2; exit 1 ;;
    esac
		shift
done

${CURDIR}/../monmo/bin/jobctl.sh ${SRC} ${OUT} -a "{${QUERY},${KEY},${WORD}}" -f ${CURDIR}/jobs/tf.js
