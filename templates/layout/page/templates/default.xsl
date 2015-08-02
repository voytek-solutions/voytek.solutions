<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:php="http://php.net/xsl"
	exclude-result-prefixes="php"
>
	<xsl:output method="html"
		encoding="utf-8"
		media-type="text/html"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		cdata-section-elements="script style"
		indent="no"
	/>

	<xsl:include href="../../../helpers/hoborg.xsl" />
	<xsl:template match="/component">

		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

				<title itemprop="name">Voytek Solutions</title>
				<meta name="description"
					content="performance, user experience and automation it's our life’s passions" />

				<style><xsl:value-of select="data/css" /></style>
				<meta id="viewport" name="viewport" content="width=device-width, initial-scale=1" />
			</head>

			<body>
				<xsl:value-of select="$H_SUB_COMPONENTS" disable-output-escaping="yes" />

				<script>(function(d,l,h){l=d.createElement('link');l.rel='stylesheet';l.href='/static/styles/css/main.css';h=d.getElementsByTagName('head')[0];h.parentNode.insertBefore(l,h);})(document);</script>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
