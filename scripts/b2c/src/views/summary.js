'use strict';
/* globals window,Blob */

var View = require('./view.js');
var TPL_MAIN = 'main';
var TPL_HELLO = 'hello';
var TPL_ENTER_BALANCE = 'enterBalance';
var tpls = { };

tpls[TPL_MAIN] = require('./jst/summary.js');
tpls[TPL_HELLO] = require('./jst/summaryHello.js');
tpls[TPL_ENTER_BALANCE] = require('./jst/summaryEnterBalance.js');

class SummaryView extends View {
	init() {
		this.stores.getStore('summary')
			.on('change', this.dataChangeHandler.bind(this));
	}

	updateState(data) {
		this.state = data;
		this.state.ids = {
			download: 'mhyei2n',
			balance_first: 'ckz193a',
			balance_last: 'x8qde3h'
		};
	}

	dataChangeHandler() {
		this.updateState(
			this.stores.getStore('summary').getState()
		);

		if (!this.state.file_name) {
			this.render(TPL_HELLO);
			return;
		}
		if (!this.state.balance_first) {
			// get balance
			this.render(TPL_ENTER_BALANCE);
			return;
		}

		this.render(TPL_MAIN);
	}

	render(tplName) {
		this.getEl().innerHTML = tpls[tplName](this.state);
		this.bind(tplName);
	}

	bind(tplName) {
		var btn;

		if (TPL_ENTER_BALANCE === tplName) {
			btn = window.document.getElementById(this.state.ids.balance_first);
			btn.onclick = this.handleBalanceClick.bind(this, 'first');

			btn = window.document.getElementById(this.state.ids.balance_last);
			btn.onclick = this.handleBalanceClick.bind(this, 'last');

			return;
		}
		if (TPL_MAIN === tplName) {
			btn = window.document.getElementById(this.state.ids.download);
			btn.onclick = this.handleDownloadClick.bind(this);

			return;
		}
	}

	handleBalanceClick(which) {
		var b = window.document.getElementById('balance');
		this.dispatcher.dispatch({
			type: 'NEW_BALANCE',
			data: {
				new_balance: b.value,
				which: which
			}
		});
	}

	handleDownloadClick() {
		var a, csvBody, csvRows;

		csvRows = this.stores.getStore('statement').getState().rows.map((_) => _.join(','));
		csvRows.unshift(this.stores.getStore('statement').getState().headers);
		csvBody = csvRows.join("\n");
		console.log(csvBody);

		a = window.document.createElement('a');
		a.href = window.URL.createObjectURL(
			new Blob([ csvBody ], { type: 'text/csv' })
		);
		a.download = this.stores.getStore('summary').getState().file_name.replace(/.csv$/, '_with_balance.csv');

		// Append anchor to body.
		window.document.body.appendChild(a);
		a.click();

		// Remove anchor from body
		window.document.body.removeChild(a);
	}
}

module.exports = SummaryView;
