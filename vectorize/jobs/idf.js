function main(jobctl,options) {
  return map(jobctl,options,{
			empty_dst : function(){
				var psrc = utils.parseCollection(this.SRCCOL);
				return psrc.db + '.vector.idf.'   +psrc.col;
			},
			
			prepare_create : function(){
				this.meta   = this.getmeta();
				if ( ! this.meta || 	this.meta.type !== 'DF' ) {
					return { 
						ok:0,
						msg:'== Invalid collection : ' + this.SRCCOL + ' ==',
						reason:this.meta
					};
				}
				return { ok:1 };
			},
			
			post_create : function(){
				this.meta.type  = 'IDF';
				this.meta.idf    = this.DSTCOL;
				this.meta.idf_limit     = this.ARGS['L'];
				this.meta.idf_threshold = this.ARGS['T'];
				this.meta.idf_verb      = this.ARGS['V'];
				this.setmeta(this.meta);
				
				print('== IDF : ' + this.DSTCOL + ' ==');
				return { ok:1 };
			},
			
			map : function(id,val){
				var propotion = val.value / this.meta.docs;
				if ( val.value <= 1 || propotion >= this.ARGS['L'] || this.ARGS['T'] >= propotion ) {
//			if ( _VERBOSE ) {
//				print('EXCEPT : ' + id + ' : ' + val.value + ' / ' + this.meta.docs + ' = ' + propotion);
//			}
				}else if ( this.ARGS['V'] && ! this.dictionary.find({_id:ObjectId(id),t:'名詞'}).count() ) {
//				if ( _VERBOSE ) {
//					print('NOT VERB : ' + id + ' : ' + val.value + ' / ' + this.meta.docs + ' = ' + propotion);
//				}
				} else {
					this.dst.save({
							_id: id,
						value:val.value,
						i:Math.log(this.meta.docs/val.value)
					});
					print(id + ' : ' + val.value + ' => ' + Math.log(this.meta.docs/val.value));
				}
			},
			
			prepare_run : function(){
				this.meta = this.getmeta2();
				this.dictionary = utils.getCollection(this.meta.dic);
				return {ok:1};
			},
			
			unique_post_run : function(){
				return this.meta;
			}
	},options);
}
