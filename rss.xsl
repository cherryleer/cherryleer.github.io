<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="url" select="'red'"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="rss/channel/title"/>
                </title>
                <link rel="stylesheet" type="text/css" href="http://rss.feedsportal.com/xsl/test/rss_es.css"/>
            </head>

            <body onload="go_decoding()" style="font-family:helvetica,arial;">
                <div id="cometestme" style="display:none;">
                    <xsl:text disable-output-escaping="yes">&amp;amp;</xsl:text>
                </div>

                <div id="outer">
                    <div class="heading">
                        <h1 class="feednametitle" style="font-size:26pt;font-color:#ff0093;" id="feednametitle">
                            <xsl:value-of select="rss/channel/title"/>
                        </h1>
                        <h4 class="feednameinfo">
                            <xsl:value-of select="rss/channel/description"/><xsl:text></xsl:text>
                        </h4>
                        <p class="builddate" style="font-size:10pt;margin-top: 15px;">
                            <xsl:value-of select="rss/channel/lastBuildDate"/>
                        </p>
                    </div>
                    <!-- end heading-->

                    <div id="items">

                        <xsl:for-each select="/rss/channel/item">
                            <div class="item">
                                <h3 class="header">
                                    <a style="font-size:18pt !important;color:#3c3c46;font-weight:bold;text-decoration: none;"
                                       href="{link}">
                                        <xsl:value-of select="title"/>
                                    </a>
                                </h3>
                                <p class="pubdate">
                                    <xsl:value-of select="pubDate"/>
                                </p>
                                <br/>
                                <span style="font-size:13pt">
                                    <xsl:value-of select="description" disable-output-escaping="yes"/>
                                </span>
                                <br/><br/>
                            </div>
                            <!-- end item (class) -->
                        </xsl:for-each>

                        <p name="decodeable" class="itembody"></p>
                    </div>
                    <!-- end items (ID) -->
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:output method="html" encoding="UTF-8" indent="no"/>

</xsl:stylesheet>