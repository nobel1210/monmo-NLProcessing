function main(jobctl,options) {
	jobctl.put( function(){ 
		return new Map({
			empty_dst : function(){
				var psrc = utils.parseCollection(this.SRCCOL);
				return psrc.db + '.token.'   +psrc.col;
			},
			
			prepare_create : function(){
				this.dst.ensureIndex({d:1,i:1});
				this.dst.ensureIndex({i:1});
				this.dst.ensureIndex({w:1});
				
				return { ok:1 };
			},
			
			post_create : function(){
				var meta = { 
					type: 'TOKEN',
					token: this.DSTCOL,
					doc:   this.SRCCOL,
					doc_field: this.ARGS['F'],
					dic: this.ARGS['D']
				};
				this.setmeta(meta);
				
				print('== TOKENIZE : ' + this.DSTCOL + ' ==');
				return { ok:1 };
			},
			
			map : function(id,val){
				this.tokenizer.parse_doc(val._id,utils.getField(val,this.ARGS['F']));
				print ( id.toString() + ' : ' + this.tokenizer.nquery + ' ( ' + this.tokenizer.nfetch + ' ) ');
			},
			
			prepare_run : function(){
				this.meta = this.getmeta2();

				var dictionary = new Dictionary(this.ARGS['D']);
				this.tokenizer = new JPTokenizer(dictionary,this.dst,false);

				return {ok:1};
			},
			
			unique_post_run : function(){
				return this.meta;
			}
		});
	},options);
}
