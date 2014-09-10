<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:php="http://php.net/xsl"
    exclude-result-prefixes="php"
>
<xsl:output method="html" encoding="utf-8" indent="no" />
    <xsl:include href="../../../../helpers/hoborg.xsl"/>
    <xsl:template match="/component">
        <section class="{data/type}">
            <div class="container">
                <xsl:value-of select="$H_SUB_COMPONENTS" disable-output-escaping="yes" />
            </div>
        </section>
    </xsl:template>
</xsl:stylesheet>
