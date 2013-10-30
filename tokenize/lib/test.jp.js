var dictionary = new Dictionary(_DIC);

var dst = { 
	save : function(ret) {
		if ( ret.c){
			ret.c = dictionary.findOne({_id:ret.c});
		}
		if ( _VERBOSE ) {
			print(ret.i + ' : ' + JSON.stringify(ret));
		}else{
			print(ret.i + ' (' + ret.l + '): ' + ret.w);
		}
	},
	findAndModify: function(a){
	},
	remove: function(a){
	},
};

var tokenizer = new JPTokenizer(dictionary,dst,_VERBOSE);
var docid = ISODate();
tokenizer.parse_doc(docid,_SENTENSE);
print ( JSON.stringify(docid) + ' : ' + tokenizer.nquery + ' ( ' + tokenizer.nfetch + ' ) ');
