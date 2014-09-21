<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:php="http://php.net/xsl"
	exclude-result-prefixes="php">
	<xsl:output
		method="html"
		encoding="utf-8"
		indent="no" />

	<xsl:template match="/component">
		<header>
			<div class="container">
				<h1 itemprop="name">voytek.solutions</h1>
			</div>
		</header>
		<nav class="main-nav ">
			<ul class="list--inline main-nav__list">
				<li class=""><a class="" href="#summary" title="Summary">Summary <i class="main-nav__icon icon icon-chevron-right"></i></a></li>
				<li class=""><a class="" href="#contact" title="Contact">Contact<i class="main-nav__icon icon icon-chevron-right"></i></a></li>
				<li class=""><a class="" href="#open-source" title="Open Source">Open Source <i class="main-nav__icon icon icon-chevron-right"></i></a></li>
			</ul>
		</nav>
	</xsl:template>

</xsl:stylesheet>
