'use strict';

var View = require('./view.js');
var tpl = require('./jst/statement.js');

class StatementView extends View {
	init() {
		this.stores.getStore('statement')
			.on('change', this.handleStatement.bind(this));
		this.state = {
			rows: [ ]
		};
	}

	handleStatement(state) {
		this.state = state;
		this.render();
	}

	render() {
		this.getEl().innerHTML = tpl(this.state);
	}
}

module.exports = StatementView;
