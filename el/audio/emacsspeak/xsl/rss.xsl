<?xml version="1.0"?>
<!--
Author: T. V. Raman <raman@cs.cornell.edu>
Copyright: (C) T. V. Raman, 2001 - 2002,   All Rights Reserved.
License: GPL
View an RSS feed as clean HTML
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
                xmlns:rss="http://purl.org/rss/1.0/"
                xmlns:nsrss="http://my.netscape.com/rdf/simple/0.9/"
                xmlns:str="http://exslt.org/strings"
                version="1.0">
  <xsl:param name="base"/>
  <xsl:variable name="amphetadesk">http://127.0.0.1:8888/my_channels.html</xsl:variable>
  <xsl:output encoding="iso8859-15" method="xml" indent="yes"/>
  <!-- {rss 1.0 -->
  <xsl:template match="img">
    <xsl:if test="@alt">
      <xsl:value-of select="@alt"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="rdf:RDF">
    <html>
      <head>
        <title>
          <xsl:apply-templates select="rss:channel/rss:title"/>
          <xsl:apply-templates select="nsrss:channel/nsrss:title"/>
        </title>
      </head>
      <body>
        <ul>
          <xsl:apply-templates select="rss:item"/>
          <xsl:apply-templates select="nsrss:item"/>
        </ul>
        <p>
          <xsl:apply-templates select="rss:description"/>
          <xsl:apply-templates select="nsrss:description"/>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="$base"/>
            </xsl:attribute>
            RSS 
          </xsl:element>
          <form action="{$amphetadesk}" method="POST">
            <input type="hidden" name="add_url" value="{$base}"/>
            <input type="submit" name="submit" value="Add to AmphetaDesk" />
          </form>
        </p>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="rss:item|nsrss:item">
    <li>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:apply-templates select="rss:link|nsrss:link"/>
        </xsl:attribute>
        <xsl:apply-templates select="rss:title|nsrss:title"/>
      </xsl:element>
	  <br/>
      <xsl:apply-templates select="rss:description|nsrss:description"/>
    </li>
  </xsl:template>
  <xsl:template match="rss:title|rss:description|nsrss:title|nsrss:description">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- } -->
  <!-- {rss 0.9 -naked namespaces -->
  <xsl:template match="/">
    <xsl:apply-templates select="//channel|//rdf:RDF"/>
  </xsl:template>
  <xsl:template match="channel">
    <html>
      <head>
        <title>
          <xsl:apply-templates select="title"/>
        </title>
      </head>
      <body>
        <ul>
          <xsl:apply-templates select="item"/>
        </ul>
        <p>
          <xsl:apply-templates select="description"/>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="$base"/>
            </xsl:attribute>
            RSS 
          </xsl:element>
          <form action="{$amphetadesk}" method="POST">
            <input type="hidden" name="add_url" value="{$base}"/>
            <input type="submit" name="submit" value="Add to AmphetaDesk" />
          </form>
        </p>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="item">
    <li>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:apply-templates select="link"/>
        </xsl:attribute>
        <xsl:apply-templates select="title"/>
      </xsl:element>
	  <br/>
      <xsl:apply-templates select="description"/>
	  <br/>
      <xsl:apply-templates select="enclosure"/>
    </li>
  </xsl:template>
  <xsl:template match="enclosure">
    <xsl:element name="a">
      <xsl:choose>
        <xsl:when test="string-length(@url) != 0">
          <xsl:attribute name="href">
            <xsl:value-of select="str:decode-uri(@url)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="string-length(@href) != 0">
          <xsl:attribute name="href">
            <xsl:value-of
          select="str:decode-uri(@href)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>Boom</xsl:otherwise>
      </xsl:choose>
      Enclosure: Type <xsl:value-of select="@type"/>
      Length: <xsl:value-of select="@length"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="title|description">
    <xsl:value-of select="." disable-output-escaping="yes"/>
  </xsl:template>
  <!-- } -->
  <!-- {identity default  -->
  <xsl:template match="*|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()" disable-output-escaping="yes"/>
    </xsl:copy>
  </xsl:template>
  <!-- } -->
</xsl:stylesheet>
<!--
    Local Variables:
    mode: xae
    sgml-indent-step: 2
    sgml-indent-data: t
    sgml-set-face: nil
    sgml-insert-missing-element-comment: nil
    folded-file: t
    End:
-->
