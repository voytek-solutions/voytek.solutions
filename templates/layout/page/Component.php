<?php
use Hoborg\Bundle\DisplayServiceBundle\Component\Component;

class Page extends Component {

	public function init() {
		parent::init();
	}

	public function prepareData() {
		parent::prepareData();

		$nodes = $this->data->documentElement->childNodes;

		for ($i = 0; $i < $nodes->length; $i++) {
			$component = $nodes->item($i);
			if ('css-file' === $component->nodeName) {
				$cssFile = $this->provider->getRootDir()
						. '/' . $this->provider->getSitePrefix()
						. '/' . $component->nodeValue;
				$css = file_get_contents($cssFile);

				$cssNode = $this->data->importNode(
						new DOMElement('css', $css), true);
				$component->parentNode->replaceChild($cssNode, $component);
			}
		}
		unset($component);
	}

	protected function replaceImages($html) {
		// '<h:img[^/]/>'
		return $html;
	}
}
