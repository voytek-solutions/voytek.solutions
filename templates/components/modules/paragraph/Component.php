<?php
use Hoborg\Bundle\DisplayServiceBundle\Component\Component;
include_once __DIR__ . '/markdown.php';

class Paragraph extends Component {

	public function init() {
		parent::init();
	}

	public function prepareData() {
		parent::prepareData();

		$nodes = $this->data->documentElement->childNodes;

		for ($i = 0; $i < $nodes->length; $i++) {
			$component = $nodes->item($i);
			if ('markdown' === $component->nodeName) {
				if ($component->hasAttribute('file')) {
					$mdFile = $this->provider->getRootDir()
							. '/' . $this->provider->getSitePrefix()
							. '/' . $component->getAttribute('file');
					$md = file_get_contents($mdFile);
				} else {
					$md = $component->nodeValue;
				}
				$html = Markdown($md);
				$html = preg_replace('/\n\s*/', '', $html);
				$html = preg_replace('/(\s|\t)+/', ' ', $html);

				$textNode = $this->data->importNode(
						new DOMElement('text', $html), true);
				$component->parentNode->replaceChild($textNode, $component);
			}
		}
		unset($component);
	}

	protected function replaceImages($html) {
		// '<h:img[^/]/>'
		return $html;
	}
}
