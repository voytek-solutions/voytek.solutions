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
		<footer>
			<div class="container">
				<ul class="footer-links">
					<li><a href="#summary">Summary</a></li>
					<li><a href="#contact">Contact</a></li>
					<li><a href="#open-source">Open Source</a></li>
				</ul>
				<div class="footer-extras">
					<p>powered by
					<a href="http://hoborglabs.com">hoborglabs</a>
					</p>
				</div>
			</div>
		</footer>
	</xsl:template>

</xsl:stylesheet>
