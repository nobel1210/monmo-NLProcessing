var _src         = utils.getCollection(_SRC);
var meta         = utils.getmeta(_src);
if ( _VERBOSE ) {
	print('= META =' );
	printjson(meta);
}
var docs = {};
if ( _VERBOSE ) {
	print('= QUERY =' );
	printjson(_QUERY);
}
var _c_src = _src.find(_QUERY);
while ( _c_src.hasNext() ) {
	var token = _c_src.next();
	var docid = token.d.valueOf();
	if ( ! docs[docid] ) {
		docs[docid] = 0;
	}
	docs[docid]++;
}
var sorted_docs = [];
for ( var i in docs ){
	sorted_docs.push({d:i,n:docs[i]});
}
sorted_docs = utils.sort(sorted_docs,function(a,b){return a.n > b.n});
print('= DOCS =' );
printjson(sorted_docs);

if ( _VERBOSE ) {
	print('= VERBOSE =' );
	var ins = [];
	for ( var i in sorted_docs ) {
		var d = sorted_docs[i];	
		var oid = ObjectId(d.d);
		ins.push(oid);
	}
	var _doc         = utils.getCollection(meta.doc);
	var query = {_id:{'$in':ins}};
	var _c_doc = _doc.find(query);
	while ( _c_doc.hasNext() ) {
		var doc = _c_doc.next();
		print( doc._id + ' : ' + utils.strView(doc[meta.doc_field],_VERBOSE_LEN));
	}
}

