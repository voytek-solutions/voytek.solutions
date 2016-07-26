<?php
namespace components\modules\google\analytics;

use Hoborg\DisplayService\Component\Component;

class Component extends Component {

	public function render() {
		$enabled = $this->data->getElementsByTagName('enabled');
		if ($enabled->length < 0) {
			return parent::render();
		}

		if (false != getenv('DS_ENV')) {
			$env = getenv('DS_ENV');
		} else {
			$env = $this->provider->getEnvironement();
		}

		// turn off GA for test and dev environment
		if ('dev' == $env || 'test' == $env) {
			$enabled = $enabled->item(0);
			$enabled->nodeValue = 0;
		}

		return parent::render();
	}
}
