var dictionary = new Dictionary(_DIC);

var dst = { 
	save : function(ret) {
		if ( ret.c){
			ret.c = dictionary.findOne({_id:ret.c});
		}
		if ( _VERBOSE ) {
			print(JSON.stringify(ret));
		}else{
			print(ret.i + ' : ' + ret.w);
		}
	},
	findAndModify: function(a){
	},
	remove: function(a){
	},
};

var tokenizer = new JPTokenizer(dictionary,dst,false);
var docid = ISODate();
tokenizer.parse_doc(docid,_SENTENSE);
print ( JSON.stringify(docid) + ' : ' + tokenizer.nquery + ' ( ' + tokenizer.nfetch + ' ) ');
