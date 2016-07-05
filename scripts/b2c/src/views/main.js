'use strict';
/* globals FileReader */

var View = require('./view.js');
var tpl = require('./jst/main.js');
var StatementView = require('./statement');
var SummaryView = require('./summary');
var fileListener, addDropHandlers;

class MainView extends View {
	init() {
		this.stores.getStore('summary')
			.on('change', this.dataChangeHandler.bind(this));

		this.views.summary = new SummaryView('b2c__summary', this.stores,
				this.dispatcher);

		addDropHandlers(this.getEl(), this.dispatcher);
		this.render();

		this.views.statement = new StatementView('b2c__takeover', this.stores,
				this.dispatcher);
	}

	dataChangeHandler() {
		var data = this.stores.getStore('summary').getState();
		this.state = data;
		this.render();
	}

	render() {
		this.getEl().innerHTML = tpl(this.state);
		this.views.summary.dataChangeHandler();
	}
}

fileListener = function (files, dispatcher) {
	var onloadHandler = function (e) {
		dispatcher.dispatch({
			type: 'NEW_FILE',
			data: {
				filename: e.target.filename,
				raw: e.target.result
			}
		});
	};

	for (var i = 0; i < files.length; i++) {
		var reader = new FileReader();
		var file = files.item(i);

		reader.onload = onloadHandler;
		reader.filename = file.name;
		reader.readAsText(file);
	}
};

addDropHandlers = function (el, dispatcher) {
	el.addEventListener('dragover', function (e) {
		e.stopPropagation();
		e.preventDefault();
		// Optional. Show the copy icon when dragging over.
		// Seems to only work for chrome.
		e.dataTransfer.dropEffect = 'copy';
	});

	// Get file data on drop
	el.addEventListener('drop', function (e) {
		var files;

		e.stopPropagation();
		e.preventDefault();
		files = e.dataTransfer.files; // Array of all files

		fileListener(files, dispatcher);
	});
};

module.exports = MainView;
