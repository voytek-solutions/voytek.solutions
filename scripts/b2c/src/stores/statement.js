'use strict';

var Store = require('./store');
var lastEntryIsFromToday, addLookup;

class Statement extends Store {
	getInitialState() {
		return {
			rows: [ ]
		};
	}

	reduce(payload) {
		if ('NEW_FILE' === payload.type) {
			this.actionNewFile(payload);
		}
		if ('NEW_BALANCE' === payload.type) {
			this.actionNewBalance(payload);
		}
	}

	updateState() {
		this.state.rows = this.data;
		this.state.headers = this.headers;

		this.changed = true;
	}

	actionNewFile(payload) {
		this.raw = payload.data.raw;
		this.data = [];
		this.headers = [];
		this.headersLookup = [];
		this.parseCsv();
		this.updateState();
		this.changed = true;
	}

	actionNewBalance(payload) {
		this.addBalanceColumn(this.getDecimal(payload.data.new_balance), payload.data.which);
	}

	parseCsv() {
		var lines = this.raw.split(/\r\n|\n/);
		var statement = this;

		this.headers = lines[0].split(/,/);
		lines.shift();
		this.data = lines.map(function (line) {
			return line.split(/,/);
		});

		this.headers.forEach(function (header, index) {
			addLookup(index, header, statement.headersLookup);
		});
	}

	getField(lineNo, fieldName, defaultValue) {
		var hl = this.headersLookup[fieldName];

		if (!hl) {
			return defaultValue;
		}

		if ('last' === lineNo) {
			lineNo = this.data.length - 1;
		}

		if (
			hl === this.headersLookup.balance ||
			hl === this.headersLookup.amount
		) {
			return this.getDecimal(this.data[lineNo][hl]);
		}

		return this.data[lineNo][hl];
	}

	getDecimal(n) {
		n = Number(n).toFixed(2);
		n = n.replace('.', '');

		return parseInt(n);
	}

	setField(lineNo, fieldName, value) {
		console.log(lineNo);
		var hl = this.headersLookup[fieldName];

		if ('last' === lineNo) {
			lineNo = this.data.length - 1;
		}

		if (
			hl === this.headersLookup.balance ||
			hl === this.headersLookup.amount
		) {
			this.data[lineNo][hl] = value.toString().replace(/^(.*?)(\d\d)$/, '$1.$2');
			return this;
		}

		this.data[lineNo][hl] = value;
		return this;
	}

	getWarnigns() {
		var warnigns = [ ];

		warnigns += lastEntryIsFromToday(this);

		return warnigns;
	}

	setStartBalance(balance) {
		var i, b, a;

		this.setField('last', 'balance', balance);
		for (i=this.data.length-2; i >= 0; i--) {
			b = Number(this.getField((i+1), 'balance'));
			a = Number(this.getField((i), 'amount'));
			this.setField(i, 'balance', (b + a));
		}

		this.updateState();
	}

	setLastBalance(balance) {
		var i, b, a;

		this.setField(0, 'balance', balance);
		for (i=1; i < this.data.length; i++) {
			b = Number(this.getField((i-1), 'balance'));
			a = Number(this.getField((i-1), 'amount'));
			this.setField(i, 'balance', (b - a));
		}

		this.updateState();
	}

	addBalanceColumn(balance, which) {
		var balanceIndex;

		if (this.headersLookup.balance === undefined) {
			this.headers.push('Balance');
			balanceIndex = this.headers.length - 1;
			addLookup(balanceIndex, 'Balance', this.headersLookup);
		}

		if ('last' === which) {
			this.setLastBalance(balance);
		} else {
			this.setStartBalance(balance);
		}
	}
}

function lastEntryIsFromToday(statement) {
	var latestDate, today, dd, mm, yyyy;

	latestDate = statement.getField(0, 'date');
	today = new Date();
	dd = today.getDate();
	dd = dd < 10 ? '0' + dd : dd;
	mm = today.getMonth() + 1;
	mm = mm < 10 ? '0' + mm : mm;
	yyyy = today.getFullYear();

	if (latestDate === dd+'/'+mm+'/'+yyyy) {
		return [
			"Date on ... has todays entry."
		];
	}

	return [ ];
}

function addLookup(index, text, lookupArray) {
	lookupArray[text] = index;
	lookupArray[text.toUpperCase()] = index;
	lookupArray[text.toLowerCase()] = index;
}

module.exports = Statement;
