'use strict';

var Dispatcher = require('./src/dispatcher');
var MainView = require('./src/views/main');
var stores = require('./src/stores');
var dispatcher, mainView;

dispatcher = new Dispatcher();
stores.registerStores(dispatcher);
mainView = new MainView('b2c', stores, dispatcher);

dispatcher.dispatch({
	type: 'INIT',
	data: { elementId: 'b2c'}
});
