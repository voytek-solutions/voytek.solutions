'use strict';

var Store = require('./store');

class Summary extends Store {
	getInitialState() {
		return {
			entries_count: 0,
			file_name: '',
			date_first: '',
			date_last: '',
			balance_first: '',
			balance_last: '',
		};
	}

	reduce(payload) {
		if ('INIT' === payload.type) {
			this.changed = true;
		} else
		if ('NEW_FILE' === payload.type) {
			this.actionNewFile(payload);
		}
		if ('NEW_BALANCE' === payload.type) {
			this.actionNewBalance(payload);
		}
	}

	actionNewFile(payload) {
		this.state.file_name = payload.data.filename;

		this.dispatcher.waitFor([
			this.stores.statement.getDispatchToken()
		]);

		this.updateStateFromStatement(this.stores.statement);
	}

	actionNewBalance() {
		this.dispatcher.waitFor([
			this.stores.statement.getDispatchToken()
		]);

		this.updateStateFromStatement(this.stores.statement);
	}

	updateStateFromStatement(statement) {
		var sst = statement.getState();

		this.changed = true;

		this.state.entries_count = sst.rows.length;
		this.state.date_first = statement.getField('last', 'Date');
		this.state.date_last = statement.getField(0, 'Date');
		this.state.balance_first = statement.getField('last', 'Balance', '');
		this.state.balance_last = statement.getField(0, 'Balance', '');
	}
}

module.exports = Summary;
