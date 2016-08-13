'use strict';

var PREFIX = 'ID_';

class Dispatcher {
	constructor() {
		this.callbacks = { };
		this.lastID = 1;
		this.isHandled = { };
		this.isPending = { };
		this.isDispatching = false;
		this.pendingPayload = { };

		return this;
	}

	dispatch(payload) {
		this.startDispatching(payload);
		try {
			for (var token in this.callbacks) {
				if (this.isPending[token]) {
					continue;
				}
				this.invokeCallback(token);
			}
		} finally {
			this.stopDispatching();
		}
	}

	register(callback) {
		var id = PREFIX + this.lastID++;
		this.callbacks[id] = callback;

		return id;
	}

	waitFor(tokens) {
		tokens.forEach(function (token) {
			console.log("wait for calback " + token);
			if (this.isPending[token]) {
				// invariant(
				//   this._isHandled[token],
				//   'Dispatcher.waitFor(...): Circular dependency detected while ' +
				//   'waiting for `%s`.',
				//   token
				// );
				return;
			}
			// invariant(
			// 	this._callbacks[token],
			// 	'Dispatcher.waitFor(...): `%s` does not map to a registered callback.',
			// 	token
			// );
			this.invokeCallback(token);
		}.bind(this));
	}

	invokeCallback(token) {
		console.log("calback " + token + " type " + this.pendingPayload.type);
		this.isPending[token] = true;
		this.callbacks[token](this.pendingPayload);
		this.isHandled[token] = true;
	}

	/**
	 * Set up bookkeeping needed when dispatching.
	 *
	 * @internal
	 */
	startDispatching(payload) {
		for (var token in this.callbacks) {
			this.isPending[token] = false;
			this.isHandled[token] = false;
		}
		this.pendingPayload = payload;
		this.isDispatching = true;
	}

	/**
	 * Clear bookkeeping used for dispatching.
	 *
	 * @internal
	 */
	stopDispatching() {
		delete this.pendingPayload;
		this.isDispatching = false;
	}
}

module.exports = Dispatcher;
