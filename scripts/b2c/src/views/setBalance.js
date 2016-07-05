'use strict';

var View = require('./view.js');
var tpl = require('./jst/setBalance.js');

class SetBalanceView extends View {
	init() {
		this.stores.getStore('summary')
			.on('change', this.stateSummaryChangeHandler.bind(this));
		this.render();
	}

	stateSummaryChangeHandler(data) {
		this.state = data;
		this.render();
	}

	render() {
		this.el.innerHTML = tpl(this.state);
	}
}

module.exports = SetBalanceView;
