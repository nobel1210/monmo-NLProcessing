var _src         = utils.getCollection(_SRC);
var meta         = utils.getmeta(_src);
var dictionary   = new Dictionary(meta.dic);
if ( _VERBOSE ) {
	print('= META =' );
	printjson(meta);
}

var elems = []
_dst = { 
	save : function(token) {
		if ( token.c){
			var elem = dictionary.findOne({_id:token.c});
			elems.push(elem);
		}
	},
	findAndModify: function(a){
	},
	remove: function(a){
	},
};
var tokenizer = new JPTokenizer(dictionary,_dst);
var docid = ISODate();
tokenizer.parse_doc(docid,_WORD);
var ts = []
if ( _VERBOSE ) {
	print('= DIC =' );
}
for ( var i in elems ) {
	var elem = elems[i];
	ts.push(elem._id.valueOf());
	if ( _VERBOSE ) {
		print(elem._id.valueOf() + ' => ' + elem.w);
	}
}
var query = {'value.w': { $all : ts }};
if ( _VERBOSE ) {
	print('= QUERY =' );
	printjson(query);
}
var ins = [];
var _c_src = _src.find(query);
while(_c_src.hasNext()){
	var doc = _c_src.next();
	var oid = ObjectId(doc._id);
	ins.push(oid);
}
print('= DOCS =' );
printjson(ins);

if ( _VERBOSE ) {
	print('= VERBOSE =' );
	var _doc         = utils.getCollection(meta.doc);
	var query = {_id:{'$in':ins}};
	var _c_doc = _doc.find(query);
	while ( _c_doc.hasNext() ) {
		var doc = _c_doc.next();
		print(  ' * ' + doc._id + ' : ' + utils.trimSpace(doc[meta.doc_field]).slice(0,_VERBOSE_LEN));
	}
}
