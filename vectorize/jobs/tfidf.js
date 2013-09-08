function main(jobctl,options) {
  return map(jobctl,options,{
			empty_dst : function(){
				var psrc = utils.parseCollection(this.SRCCOL);
				return psrc.db + '.vector.tfidf.'   +psrc.col;
			},
			
			prepare_create : function(){
				this.meta   = this.getmeta();
				if ( ! this.meta || 	this.meta.type !== 'IDF' ) {
					return { 
						ok:0,
						msg:'== Invalid collection : ' + this.SRCCOL + ' ==',
						reason:this.meta
					};
				}
				return { ok:1 };
			},
			
			post_create : function(){
				this.meta.type  = 'TFIDF';
				this.meta.tfidf    = this.DSTCOL;
				this.setmeta(this.meta);
				
				print('== TFIDF : ' + this.DSTCOL + ' ==');
				return { ok:1 };
			},
			
			map_cursor : function(){
				var tf  = utils.getCollection(this.meta.tf);
				return tf.find(utils.IGNORE_META,{_id:1});
			},
			
			map_data : function(id){
				return this.tf.findOne({_id:id});
			},
			
			
			map : function(id,val){
				var diff = 0;
				var ndim = 0;
				var vec  = {};
				for ( var i in val.value ) {
					var e = val.value[i];
					if ( ! (e.w in this.idfall) || ! this.idfall[e.w] ) {
						continue;
					}
					vec[e.w] = e.c * this.idfall[e.w];
					diff += vec[e.w]*vec[e.w];
					ndim++;
				}
				var div = Math.sqrt(diff);
				vec = utils.normalize(vec,div);
				this.dst.save({
						_id:id,
					value:vec
				});
				print(id + ' : ' + ndim);
			},
			
			prepare_run : function(){
				this.meta = this.getmeta2();
  // Get IDF
				this.idfall = {};
				var _c_src = this.src.find(utils.IGNORE_META);
				while ( _c_src.hasNext() ) {
					var idf = _c_src.next();
					this.idfall[idf._id] = idf.i;
				}
				this.tf  = utils.getCollection(this.meta.tf);
				return {ok:1};
			},
			
			unique_post_run : function(){
				return this.meta;
			}
	},options);
}
