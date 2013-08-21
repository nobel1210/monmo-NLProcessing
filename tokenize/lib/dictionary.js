function Dictionary(ns){
	this.dictionary  = utils.getCollection(ns);
	this.pdictionary = utils.getWritableCollection(ns);
	this.seq         = utils.getWritableCollection(ns + '.seq');
}

Dictionary.prototype.init = function(nheads){
	this.pdictionary.drop();
	this.pdictionary.save({_id:'.meta',nheads:nheads});

	this.seq.drop();
	this.seq.save({_id:'seq',c:0});
}
Dictionary.prototype.index = function(){
	this.pdictionary.ensureIndex({w:1});
	this.pdictionary.ensureIndex({h:1,l:-1,s:1});
	this.pdictionary.ensureIndex({t:1});
}

Dictionary.prototype.nheads = function(){
	return this.dictionary.findOne({_id:'.meta'}).nheads;
}
Dictionary.prototype.findOne = function(q,f){
	return this.dictionary.findOne(q,f);
}
Dictionary.prototype.find = function(q,f){
	return this.dictionary.find(q,f);
}

Dictionary.prototype.update = function(q,v,f){
	this.pdictionary.update(q,v,f);
}

Dictionary.prototype.remove = function(q){
	this.pdictionary.remove(q);
}

Dictionary.prototype.save = function(e){
//  e._id = this.seq.findAndModify({
//    query: { _id: 'seq' },
//    update: { $inc: { c: 1 } },
//    new: true
//  }).c;
	this.pdictionary.save(e);
}

Dictionary.prototype.upsert = function(e){
	return this.pdictionary.findAndModify({
		query:{w:e.w},
		update:{ $setOnInsert:e},
		upsert:true,
		new:true
	});
}
