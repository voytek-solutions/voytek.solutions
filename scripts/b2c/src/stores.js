'use strict';

var Statement = require('./stores/statement');
var Summary = require('./stores/summary');
var stores = {
	statement: null,
	summary: null
};
var registerStores, getStore;

registerStores = function (dispatcher) {
	stores.statement = new Statement(dispatcher, stores);
	stores.summary = new Summary(dispatcher, stores);
};

getStore = function (storeName) {
	return stores[storeName];
};

module.exports = {
	registerStores: registerStores,
	getStore: getStore
};
