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
		<div class="content">
			<p itemscope="itemscope" itemtype="http://schema.org/SoftwareApplication">
				<xsl:apply-templates select="data/name" /> - <span itemprop="description">
					<xsl:value-of select="data/description" />
				</span>
			</p>
		</div>
	</xsl:template>

	<xsl:template match="name[@link]">
		<b itemprop="name">
			<a href="{@link}"><xsl:value-of select="." /></a>
		</b>
	</xsl:template>

	<xsl:template match="name[not(@link)]">
		<b itemprop="name">
			<xsl:value-of select="." />
		</b>
	</xsl:template>
</xsl:stylesheet>
