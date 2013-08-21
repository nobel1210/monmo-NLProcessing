function main(jobctl,options) {
	var ret = jobctl.put( function(){ 
		return new Job({
			empty_dst : function(){
				var psrc = utils.parseCollection(this.SRCCOL);
				return psrc.db + '.canopy.'   +psrc.col;
			},
			prepare_create : function() {
				var pdst = utils.parseCollection(this.DSTCOL);
				utils.cleanCollections(this.DSTCOL+'\.');
				return {ok:1};
			},
			create_job : function() {
			},

			prepare_run : function(){
				this.meta   = utils.getmeta(this.src);
				if ( this.ARGS['N'] ) {
					this.meta.normalize = true;
				}
				this.meta.vector = this.SRCCOL;
				this.meta.canopy = {
					ns:this.DSTCOL + '.cluster',
					t2:this.ARGS['T2'],
					t1:this.ARGS['T1'],
					threshold:this.ARGS['T'],
					field:this.ARGS['F']
				}
				this.cluster = utils.getWritableCollection(this.meta.canopy.ns);
				utils.setmeta(this.cluster,this.meta);

				return {ok:1};
			},

			run : function() {
				var ret = {
					ok : 1,
					msg : '',
					data : { meta : this.meta }
				}
				print('== DATA  ==');
				var data_count = 0;
				var datacol = utils.getWritableCollection(this.DSTCOL + '.data');
				var _c_src= this.src.find(utils.IGNORE_META);
				while(_c_src.hasNext()){
					var data = _c_src.next();
					var loc  = utils.getField(data,this.meta.canopy.field);
					if ( loc ) {
						data_count++;
						datacol.save({
								_id:data._id,
							value:{loc:loc}
						});					
					}
				}

				print('== T2 sampling  ==');
				var cs = [];
				var _c_data = datacol.find();
				while ( _c_data.hasNext() ){
					var data = _c_data.next();
					var n = 0;
					for ( var c in cs ){
						var cluster = cs[c];
						var diff = utils.diffVector(cluster.loc,data.value.loc);
						if ( diff < this.meta.canopy.t2 ) {
							n++;
							break;
						}
					}
					if ( n === 0 ) {
						cs.push({ s : 0, loc : data.value.loc, newloc:{} });
					}
				}
				print('== T1 sampling  ==');
				var _c_data = datacol.find();
				while ( _c_data.hasNext() ){
					var data = _c_data.next();
					for ( var c in cs ){
						var diff = utils.diffVector(cs[c].loc,data.value.loc);
						if ( diff < this.meta.canopy.t1 ) {
							cs[c].newloc = utils.addVector(cs[c].newloc,data.value.loc);
							cs[c].s++;
						}
					}
				}
				ret.data.first = cs.length;

				var newcs = [];
				print('== Reduce minor clusters  ==');
				var threshold = data_count / cs.length * this.meta.canopy.threshold;
				ret.data.threshold = { val : threshold };
				for ( var c in cs ){
					if ( cs[c].s <= threshold ) {
						continue;
					}
					newc = {
						s: cs[c].s , 
						loc : {}
					}
					if ( this.meta.normalize ) { 
						newc.loc = utils.normalize(cs[c].newloc);
					}else{
						newc.loc = utils.normalize(cs[c].newloc,cs[c].s);
					}
					newcs.push(newc);
				}
				ret.data.minor = newcs.length;

				ret.data.closed = [];

				print('== Reduce closed clusters  ==');
				for ( var c in newcs ) {
					var cluster = newcs[c];
					if ( cluster ) {
						var best = c;
						var s = cluster.s;
						for ( var i in newcs ) {
							var cmp = newcs[i];
							if ( cmp ) {
								var diff = utils.diffVector( cluster.loc, cmp.loc );
								if ( diff < this.meta.canopy.t2 ) {
									if ( s < cmp.s ) {
										s = cmp.s;
										best = i;
									}
									if ( diff > 0 ){
										ret.data.closed.push({diff:diff} );
									}
									newcs[i] = null;
								}
							}
						}
						newcs[best] = cluster;
					}
				}
				ret.data.last = 0;
				for ( var c in newcs ) {
					var cluster = newcs[c];
					if ( cluster ) {
						cluster._id = c;
						this.cluster.save(cluster);
						ret.data.last++;
					}
				}
				
				return ret;
			}
		});
	},options);
}


