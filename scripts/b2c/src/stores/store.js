'use strict';

var Events = require('minivents');

class Store {
	constructor(dispatcher, stores) {
		this.changed = false;
		this.state = this.getInitialState();
		this.changeEvent = 'change';
		this.dispatcher = dispatcher;
		this.stores = stores;
		Events(this);

		this.dispatchToken = dispatcher.register((payload) => {
			this.invokeOnDispatch(payload);
		});
	}

	getInitialState() {
		return { };
	}

	getDispatchToken() {
		return this.dispatchToken;
	}

	invokeOnDispatch(payload) {
		this.changed = false;
		this.reduce(payload);

		if (this.changed) {
			console.log('emit change for ' + payload.type);
			this.emit('change', this.state);
		}
	}

	getState() {
		return this.state;
	}
}

module.exports = Store;
