<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl"
	exclude-result-prefixes="php"
>
	<xsl:output method="html" encoding="utf-8" indent="yes" />

	<xsl:template match="/component">
		<xsl:if test="boolean(number(data/enabled)) = false()">
			<xsl:comment> Google Analytics turned off (dev or test mode) </xsl:comment>
		</xsl:if>
		<xsl:if test="boolean(number(data/enabled))">
			<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(["_setAccount", "<xsl:value-of select="data/account" />"]);
_gaq.push(["_trackPageview"]);
_gaq.push(["_setSiteSpeedSampleRate", 40]);

(function(d, g, s) {
g=d.createElement("script");g.type="text/javascript";g.async=true;
g.src = ("https:" == d.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js";
s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(g, s);
})(document);

(function() {
	var po = document.createElement("script"); po.type = "text/javascript";
	po.async = true;
	po.src = "https://apis.google.com/js/plusone.js";
	var s = document.getElementsByTagName("script")[0];
	s.parentNode.insertBefore(po, s);
})();
			</script>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
