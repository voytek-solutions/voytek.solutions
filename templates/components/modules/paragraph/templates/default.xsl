<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:php="http://php.net/xsl"
        exclude-result-prefixes="php"
>
<xsl:output method="html" encoding="utf-8" indent="yes" />
    <xsl:include href="../../../../helpers/hoborg.xsl"/>
	<xsl:template match="/component">
		<div class="{data/size}">
			<xsl:apply-templates select="data/text" />
		</div>
	</xsl:template>

    <xsl:template match="text">
        <xsl:value-of select="." disable-output-escaping="yes" />
    </xsl:template>
</xsl:stylesheet>
