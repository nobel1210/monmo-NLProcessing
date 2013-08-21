function main(jobctl,options) {
	
	print('== FIRST ==');
	var ret = jobctl.put( function(){
		return new Job({
			empty_dst : function(){
				var psrc = utils.parseCollection(this.SRCCOL);
				return psrc.db + '.kmeans.'   +psrc.col;
			},
			prepare_create : function() {
				var pdst = utils.parseCollection(this.DSTCOL);
				utils.cleanCollections(this.DSTCOL+'\.');
				return {ok:1};
			},
			create_job : function() {
			},

			prepare_run : function(){
				this.initial_cluster = this.ARGS['I'];
				this.cluster_field   = this.ARGS['C'];
				this.field           = this.ARGS['F'];

				this.meta =	utils.getmeta(this.src);
				this.meta.vector = this.SRCCOL;
				this.meta.kmeans = {
					data    : this.DSTCOL + '.it1.data',
					cluster : this.DSTCOL + '.it1.cluster',
					field   : this.ARGS['F']
				};
				this.cluster = utils.getWritableCollection(this.meta.kmeans.cluster);
				this.data    = utils.getWritableCollection(this.meta.kmeans.data);

				return {ok:1};
			},
			run : function() {
				var cs = utils.getClusters(this.initial_cluster,this.cluster_field);
				for ( var c in cs ) {
					this.cluster.save({ 
						_id : c ,
						s : 0, 
						loc : cs[c] , 
						st: 0 });
				}
		
				var _c_src = this.src.find(utils.IGNORE_META);
				while(_c_src.hasNext()){
					var data = _c_src.next();
					var loc  = utils.getField(data,this.field);
					if ( loc ) {
						this.data.save({
							_id:data._id,
							loc:loc,
							st: 0
						});					
					}
				}

				return {
					ok : 1,
					msg : 'success',
					data : { meta: this.meta }
				}
			}
		});
	},options);

	var NS = ret.dst;
	options.args['meta'] = ret.data.meta;

	for (var i = 1 ; i <= 10 ; i++ ) {
		var PREV_C = NS+'.it'+i+'.cluster';
		var PREV_D = NS+'.it'+i+'.data';
		var CUR_C  = NS+'.it'+(i+1)+'.cluster';
		var CUR_D  = NS+'.it'+(i+1)+'.data';
		
		print('== '+i+' DATA ==');
		options.src = PREV_D;
		options.dst = CUR_D;
		options.args['prev_cluster'] = options.args['cluster'];
		options.args['cluster'] = PREV_C;
		
		// data iterate
		var ret = jobctl.put( function(){
			return new Map({
				prepare_create : function(){
					this.dst.ensureIndex({'c':1});
					return {ok:1};
				},
				prepare_run : function(){
					this.cs = utils.getClusters(this.ARGS['cluster']);
					if ( ! this.cs ) {
						return {
							ok : 0,
							msg: 'Could not get cluster info',
							data:this.cs
						}
					}
					
					if ( this.ARGS['prev_cluster'] ){
						var cs_history = utils.getClusters(this.ARGS['prev_cluster']);
						this.cdiff = 0;

						for ( var c in this.cs ){
							this.cdiff += utils.diffVector(this.cs[c].loc,cs_history[c].loc);
						}	
						print('Cluster diff: '+this.cdiff);
						if ( this.cdiff < 1.0e-12 ) {
							return {
								ok : 2,
								msg: 'End of iteration',
								data: {cdiff: this.cdiff}
							}
						}
					}
					return {ok:1};
				},
				map : function(id,val){
					var cur = null;
					var min = null;
					var cssum     = 0;
					val.cs = [];
					
					for ( var c in this.cs ){
						var diff = utils.diffVector(this.cs[c].loc , val.loc);
						if ( min === null || min > diff ) {
							cur = c;
							min = diff;
						}
						var score = Number.MAX_VALUE;
						if ( diff ) {
							score = 1/diff;
						}
						val.cs.push({c:c,s:score});
						cssum += score;
					}
					val.c  = cur;
					for ( var i in val.cs ){
						val.cs[i].s /= cssum;
						val.cs[i].s = (val.cs[i].s<1.0e-12)?0:val.cs[i].s;
					}
					val.cs = utils.sort(val.cs,function(a,b){ return a.s > b.s;});
					val.st = 0;
					this.dst.save(val);
				},
				unique_post_run : function(){
					return {
						cdiff : this.cdiff
					};
					return true;
				}
			},true);
		},options);
		print(' DIFF : ' + ret.data.cdiff);
		if ( ret.ok === 2 ) {
			utils.getWritableCollection(options.dst).drop();
			break;
		}
		print('== '+i+' CLUSTER ==');
		// cluster iterate
		options.src = PREV_C;
		options.dst = CUR_C;
		options.args['data'] = CUR_D;

		var ret = jobctl.put( function(){
			return new Map({
				prepare_create : function(){
					return { ok:1 };
				},
				prepare_run : function(){
					this.data = utils.getCollection(this.ARGS['data']);
					this.meta = this.ARGS['meta'];
					return { ok:1 };
				},
				map_data : function(id){
					return utils.getField(
												 this.src.findOne({_id:id},{_id:1}),
												 '_id');
				},
				map : function(id,val){
					var newc = { _id : val, s:0, loc:{},st:0 };
					var _c_data = this.data.find({'c':val});
					while(_c_data.hasNext()){
						var data = _c_data.next();
						newc.loc = utils.addVector(newc.loc,data.loc);
						newc.s++;
					}
					if ( this.meta.normalize ) {
						newc.loc = utils.normalize(newc.loc);
					}else{
						for ( var d in newc.loc ) {
							newc.loc[d] /=  newc.s;
						}
					}
					this.dst.save(newc);
				}
			},true);
		},options);
	}
	var meta = options.args['meta'];
	meta.kmeans.data   = NS+'.fin.data';
	meta.kmeans.cluster= NS+'.fin.cluster';

	var pns = utils.parseCollection(NS);
	
print(options.args['data'] + ' => ' + meta.kmeans.data);
print(options.args['cluster'] + ' => ' + meta.kmeans.cluster);

	utils.getWritableCollection(options.args['data']).renameCollection(pns.col+'.fin.data');
	utils.getWritableCollection(options.args['cluster']).renameCollection(pns.col+'.fin.cluster');

	utils.setmeta(utils.getWritableCollection(meta.kmeans.data),meta);
	utils.setmeta(utils.getWritableCollection(meta.kmeans.cluster),meta);
	
}



function Kmeans(src) {
	this.SRC = src;
	var src_split = src.split('\.');
	this.DB = src_split.shift();
//	this.db = db.getMongo().getDB(this.DB);
//	this.pdb= _pmongo.getDB(this.DB);
	this.NS = src_split.join('\.');
	this.FIN_C  = 'kmeans.'+this.NS+'.fin.cluster';
	this.FIN_D  = 'kmeans.'+this.NS+'.fin.data';
	this.cs_history = null;
	this.N = 0;
	this._src = utils.getCollection(this.SRC);
	this.meta=	utils.getmeta(this._src);
}



Kmeans.prototype.finish = function(){
	var prev_c = this.PREV_C;
	var prev_d = this.PREV_D;

	var JOBID = 2;
	if ( utils.sync_job(this._job,JOBID) ) {
		utils.getWritableCollection(prev_c).renameCollection(this.FIN_C);
		utils.getWritableCollection(prev_d).renameCollection(this.FIN_D);
		
		this.meta.vector = this.SRC;
		this.meta.data   = this.DB + '.' + this.FIN_D;
		this.meta.cluster= this.DB + '.' + this.FIN_C;
		delete(this.meta._id);
		utils.setmeta(utils.getWritableCollection(this.meta.cluster),this.meta);
		utils.setmeta(utils.getWritableCollection(this.meta.data),this.meta);
		printjson(this.meta);
		utils.end_job(this._job,JOBID);
	}
}

//var kmeans = new Kmeans(_SRC);
//
//if ( _CJOB ) {
//	kmeans.clean();
//	quit();
//}
//
//print('== KMEANS ==');
//kmeans.prepareIt();
//kmeans.first(_CLUSTER,_CFIELD,_VFIELD);
//for (var i = 0 ; i <= 99 ; i++ ) {
//	kmeans.prepareIt();
//	kmeans.createJob();
//	var cs = kmeans.dataIterate();
//	if ( ! cs ) {
//		break;
//	}
//	kmeans.waitForData();
//	kmeans.clusterIterate(cs);
//	kmeans.waitForCluster();
//}
//kmeans.finish();
