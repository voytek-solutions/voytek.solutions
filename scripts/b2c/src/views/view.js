'use strict';
/* globals document */

class View {
	constructor(rootId, stores, dispatcher) {
		this.rootId = rootId;
		this.stores = stores;
		this.dispatcher = dispatcher;
		this.state = {};
		this.views = {};
		this.el = null;

		this.init();
	}

	getEl() {
		// no caching due to re-renering of HTML
		return document.getElementById(this.rootId);
	}
}

module.exports = View;
