<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="3.0"
  xmlns:local="https://example.org/z6odMHX3cXfU92qrxgWyyBjZ"
  xmlns:niem-f="http://webb.github.io/xslt/niem"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xml-f="http://webb.github.io/xslt/xml"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xpf="http://www.w3.org/2005/xpath-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!--

  Translates XML to JSON-LD. 

  Caveats:

  - Translates element qnames literally, so make sure you have those right before you get to this point.

  - Does not handle metadata in any special way; metadata attributes are just treated as regular attributes.

  - Does not do typing on property values; everything is treated as a string

  - Does not handle mixed content at all.

    -->

  <import href="../niem/get-uri.xsl"/>
  <import href="../xml/get-descendant-namespaces.xsl"/>
  
  <output method="text" encoding="utf-8"/>
  <!--
  <output method="xml" encoding="utf-8" indent="yes"/>
  -->

  <template match="/">
    <variable name="result">
      <xpf:map>
        <xpf:map key="@context">
          <for-each select="xml-f:get-descendant-namespaces(/*)">
            <choose>
              <when test="@prefix = ''">
                <xpf:string key="@vocab"><value-of select="local:namespace-to-base-uri(@uri)"/></xpf:string>
              </when>
              <otherwise>
                <xpf:string key="{@prefix}"><value-of select="local:namespace-to-base-uri(@uri)"/></xpf:string>
              </otherwise>
            </choose>
          </for-each>
        </xpf:map>
        <apply-templates select="*"/>
      </xpf:map>
    </variable>
    <!--
    <sequence select="$result"/>
    -->
    <value-of select="xml-to-json($result)"/>
  </template>

  <function name="local:namespace-to-base-uri">
    <param name="uri" as="xs:string"/>
    <value-of select="if (ends-with($uri, '#')) then $uri else concat($uri, '#')"/>
  </function>

  <template match="@xsi:nil"/>

  <template match="@structures:id | @structures:ref | @structures:uri">
    <xpf:string key="@id">
      <value-of select="niem-f:get-uri(..)"/>
    </xpf:string>
  </template>

  <template match="@*|*" priority="-1">
    <variable name="qname" as="xs:QName" select="node-name(.)"/>
    <variable name="siblings" as="node()+"
      select="parent::node()/attribute()[node-name(.) = $qname],
              parent::node()/element()[node-name(.) = $qname]"/>
    <!-- only process the first occurrence -->
    <if test="$siblings[1] is .">
      <choose>
        <when test="count($siblings) = 1">
          <apply-templates select="." mode="get-object"/>
        </when>
        <otherwise>
          <xpf:array key="{$qname}">
            <apply-templates select="$siblings"
                             mode="get-object">
              <with-param name="in-array" select="true()"/>
            </apply-templates>
          </xpf:array>
        </otherwise>
      </choose>
    </if>
  </template>

  <template match="@*" mode="get-object">
    <param name="in-array" as="xs:boolean" select="false()"/>
    <xpf:string>
      <if test="not($in-array)">
        <attribute name="key" select="node-name(.)"/>
      </if>
      <value-of select="."/>
    </xpf:string>
  </template>

  <template match="*" mode="get-object">
    <param name="in-array" as="xs:boolean" select="false()"/>
    <variable name="uri" as="xs:anyURI?" select="niem-f:get-uri(.)"/>
    <variable name="has-property-children"
              as="xs:boolean"
              select="exists((*, @*))"/>
    <variable name="has-text-children"
              as="xs:boolean"
              select="exists(text()[string-length(normalize-space(.)) gt 0])"/>
    <choose>
      <when test="$has-property-children and $has-text-children">
        <message terminate="yes">
          <text>Element has element children and text children</text>
        </message>
      </when>
      <when test="$has-property-children">
        <xpf:map>
          <if test="not($in-array)">
            <attribute name="key" select="node-name(.)"/>
          </if>
          <apply-templates select="@*|*"/>
        </xpf:map>
      </when>
      <when test="$has-text-children">
        <xpf:string>
          <if test="not($in-array)">
            <attribute name="key" select="node-name(.)"/>
          </if>
          <apply-templates select="text()[string-length(normalize-space(.)) gt 0]"/>
        </xpf:string>
      </when>
      <otherwise>
      </otherwise>
    </choose>
  </template>

</stylesheet>
