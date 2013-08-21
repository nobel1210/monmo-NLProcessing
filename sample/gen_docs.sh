#!/usr/bin/env bash
CURDIR=`dirname $0`
source $CURDIR/../mongo.env

function fetch {
		URL=$1
		FILE=`echo $URL | sed -e 's/.\+\/\([^\/]\+\)$/\1/'`
		if [ ! -f $FILE ]; then
				echo wget -q  \"$URL\" -O \"$FILE\"
				wget -q  "$URL" -O "$FILE"
		fi
}
function fetch_examples {
		mkdir -p $CURDIR/testdata
		pushd $CURDIR/testdata
		fetch 'http://ja.wikipedia.org/wiki/NoSQL'
		fetch 'http://ja.wikipedia.org/wiki/Hibari_(dbms)'
		fetch 'http://ja.wikipedia.org/wiki/Apache_CouchDB'
		fetch 'http://ja.wikipedia.org/wiki/Hypertable'
		fetch 'http://ja.wikipedia.org/wiki/BigTable'
		fetch 'http://ja.wikipedia.org/wiki/HBase'
		fetch 'http://ja.wikipedia.org/wiki/Apache_Cassandra'
		fetch 'http://ja.wikipedia.org/wiki/Riak'
		fetch 'http://ja.wikipedia.org/wiki/MongoDB'
		fetch 'http://ja.wikipedia.org/wiki/PostgreSQL'
		fetch 'http://ja.wikipedia.org/wiki/MySQL'
		fetch 'http://ja.wikipedia.org/wiki/Firebird'
		fetch 'http://ja.wikipedia.org/wiki/Apache_Tomcat'
		fetch 'http://ja.wikipedia.org/wiki/Apache_ZooKeeper'
		fetch 'http://ja.wikipedia.org/wiki/Hadoop'
		fetch 'http://ja.wikipedia.org/wiki/Apache_HTTP_Server'
		fetch 'http://ja.wikipedia.org/wiki/Apache_Ant'
		fetch 'http://ja.wikipedia.org/wiki/Apache_Axis2'
		fetch 'http://ja.wikipedia.org/wiki/Apache_Maven'
		fetch 'http://ja.wikipedia.org/wiki/Log4j'
		fetch 'http://ja.wikipedia.org/wiki/Perl6'
		fetch 'http://ja.wikipedia.org/wiki/Rust_(%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E)'
		fetch 'http://ja.wikipedia.org/wiki/Erlang'
		fetch 'http://ja.wikipedia.org/wiki/Python'
		fetch 'http://ja.wikipedia.org/wiki/Ruby'
		fetch 'http://ja.wikipedia.org/wiki/R%E8%A8%80%E8%AA%9E'
		
		fetch 'http://ja.wikipedia.org/wiki/%E7%B4%99'
		fetch 'http://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E4%BC%81%E6%A5%AD%E4%B8%80%E8%A6%A7_(%E3%83%91%E3%83%AB%E3%83%97%E3%83%BB%E7%B4%99)'
		fetch 'http://ja.wikipedia.org/wiki/%E6%9D%BF%E7%B4%99'
		fetch 'http://ja.wikipedia.org/wiki/%E6%8A%98%E3%82%8A%E7%B4%99'
		fetch 'http://ja.wikipedia.org/wiki/%E9%9B%BB%E5%AD%90%E3%83%9A%E3%83%BC%E3%83%91%E3%83%BC'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%9A%E3%83%BC%E3%83%91%E3%83%BC%E3%83%8A%E3%82%A4%E3%83%95'
		fetch 'http://ja.wikipedia.org/wiki/%E6%96%B0%E8%81%9E'
		fetch 'http://ja.wikipedia.org/wiki/%E5%B0%81%E7%AD%92'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%88%E3%82%A4%E3%83%AC%E3%83%83%E3%83%88%E3%83%9A%E3%83%BC%E3%83%91%E3%83%BC'
		fetch 'http://ja.wikipedia.org/wiki/%E6%AE%B5%E3%83%9C%E3%83%BC%E3%83%AB'
		fetch 'http://ja.wikipedia.org/wiki/%E5%8D%B0%E5%88%B7'
		fetch 'http://ja.wikipedia.org/wiki/%E7%B4%99%E3%81%AE%E5%8D%9A%E7%89%A9%E9%A4%A8'
		fetch 'http://ja.wikipedia.org/wiki/%E7%B4%99%E5%B8%83'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%9A%E3%83%BC%E3%83%91%E3%83%BC%E3%82%AF%E3%83%A9%E3%83%95%E3%83%88'
		fetch 'http://ja.wikipedia.org/wiki/%E3%82%8F%E3%82%89%E5%8D%8A%E7%B4%99'
		
		fetch 'http://ja.wikipedia.org/wiki/%E6%9C%88%E6%8E%A2%E6%9F%BB'
		fetch 'http://ja.wikipedia.org/wiki/%E6%9C%88%E9%9D%A2%E7%9D%80%E9%99%B8'
		fetch 'http://ja.wikipedia.org/wiki/%E5%AE%87%E5%AE%99%E9%96%8B%E7%99%BA'
		fetch 'http://ja.wikipedia.org/wiki/%E5%AE%87%E5%AE%99%E9%96%8B%E7%99%BA%E7%AB%B6%E4%BA%89'
		fetch 'http://ja.wikipedia.org/wiki/%E5%AE%87%E5%AE%99%E6%8E%A2%E6%9F%BB%E6%A9%9F'
		fetch 'http://ja.wikipedia.org/wiki/%E6%9C%88%E9%9D%A2%E8%BB%8A'
		fetch 'http://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%9D%E3%83%AD%E8%A8%88%E7%94%BB'
		
		fetch 'http://ja.wikipedia.org/wiki/%E9%82%84%E5%85%83'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%92%E3%83%89%E3%83%AD%E3%82%AD%E3%82%B7%E5%8C%96%E5%90%88%E7%89%A9'
		fetch 'http://ja.wikipedia.org/wiki/%E6%A0%B9%E3%81%AE%E8%AA%AC'
		fetch 'http://ja.wikipedia.org/wiki/%E6%9C%89%E6%A9%9F%E5%8C%96%E5%AD%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E6%B0%B4%E5%92%8C%E7%89%A9'
		fetch 'http://ja.wikipedia.org/wiki/%E8%8A%B3%E9%A6%99%E5%8C%96%E5%90%88%E7%89%A9'
		fetch 'http://ja.wikipedia.org/wiki/%E5%8D%8A%E5%90%88%E6%88%90'
		fetch 'http://ja.wikipedia.org/wiki/%E6%BA%B6%E5%AA%92'
		
		fetch 'http://ja.wikipedia.org/wiki/%E6%94%BF%E6%B2%BB'
		fetch 'http://ja.wikipedia.org/wiki/%E7%B5%B1%E6%B2%BB'
		fetch 'http://ja.wikipedia.org/wiki/%E7%A4%BE%E4%BC%9A'
		fetch 'http://ja.wikipedia.org/wiki/%E6%94%BF%E6%B2%BB%E5%AD%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E5%AE%9F%E8%A8%BC%E6%94%BF%E6%B2%BB%E7%90%86%E8%AB%96'
		fetch 'http://ja.wikipedia.org/wiki/%E5%A4%A7%E8%87%A3%E6%94%BF%E5%8B%99%E5%AE%98'
		fetch 'http://ja.wikipedia.org/wiki/%E5%86%85%E9%96%A3%E5%BA%9C'
		fetch 'http://ja.wikipedia.org/wiki/%E6%9D%A1%E4%BE%8B'
		
		fetch 'http://ja.wikipedia.org/wiki/%E3%82%B9%E3%83%9A%E3%82%A4%E3%83%B3%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%AD%E3%82%B7%E3%82%A2%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E6%88%8A%E8%BE%B0%E6%88%A6%E4%BA%89'
		fetch 'http://ja.wikipedia.org/wiki/%E3%82%A4%E3%82%A8%E3%83%A1%E3%83%B3%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%B3%E3%82%B4%E3%83%A9%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%AB%E3%83%AF%E3%83%B3%E3%83%80%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E3%82%B9%E3%83%BC%E3%83%80%E3%83%B3%E5%86%85%E6%88%A6'
		fetch 'http://ja.wikipedia.org/wiki/%E3%83%AC%E3%83%90%E3%83%8E%E3%83%B3%E5%86%85%E6%88%A6'
		popd
}

HTMLDATAJS="${CURDIR}/data/htmldata.json"
TESTDATAJS="${CURDIR}/data/testdata.json"
HTMLDIR="${CURDIR}/testdata"
if [ "$1" == "" ]; then
		fetch_examples
else
		HTMLDIR="$1"
fi
for f in `find ${HTMLDIR} -type f | grep -v '.gitignore'`; do ((echo '{body:"'; cat $f  | sed -e 's/\\/\\\\/g' | sed -e 's/$/\\n/g' |sed -e 's/\r//g' | sed -e 's/\t/\\t/g' | sed -e 's/"/\\"/g' ; echo '"}') | tr  -d '\n' ) ;echo ; done > ${HTMLDATAJS}

echo '=== IMPORT HTML TESTDATA (files => test.testdoc.html ) ==='
PRIMARY=`${MONGO_SHELL} ${MONGO_NODE} --quiet ${CURDIR}/../lib/utils.js ${CURDIR}/../lib/getprimary.js | tail -n 1`
${MONGO_IMPORT} -h ${PRIMARY} --drop -d test -c testdoc.html --file ${HTMLDATAJS}

echo '=== COMVERT FROM HTML TO TEXT (test.testdoc.html => test.testdoc ) ==='
rm ${TESTDATAJS}
${MONGO_EXPORT} -h ${PRIMARY} -d test -c testdoc.html -f _id,body | while read -r readline ;do echo ${readline} | node ${CURDIR}/parsehtml.js -m >> ${TESTDATAJS}; done
#${MONGO_EXPORT} -h ${PRIMARY} -d test -c testdoc.html -f _id,body | while read readline ;do echo ${readline} | sed -e 's/"/\\"/g' | node ${CURDIR}/parsehtml.js -m >> ${TESTDATAJS}; done

${MONGO_IMPORT} -h ${PRIMARY} --drop -d test -c testdoc --file ${TESTDATAJS}
