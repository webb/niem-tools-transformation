<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f="http://webb.github.io/xslt/xml"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- 
       Get the in-scope base URI at a given element.
    -->

  <function name="f:get-base-uri" as="xs:anyURI">
    <param name="context" as="element()"/>
    <variable name="base-attribute" as="attribute(xml:base)?"
              select="$context/ancestor-or-self::*[@xml:base][1]/@xml:base"/>
    <variable name="base-uri">
      <choose>
        <when test="exists($base-attribute)">
          <value-of select="xs:anyURI($base-attribute)"/>
        </when>
        <otherwise>
          <value-of select="base-uri($context)"/>
        </otherwise>
      </choose>
    </variable>
    <choose>
      <when test="ends-with($base-uri, '#')">
        <sequence select="xs:anyURI(substring($base-uri,1,string-length($base-uri) - 1))"/>
      </when>
      <otherwise>
        <sequence select="$base-uri"/>
      </otherwise>
    </choose>
  </function>

</stylesheet>
