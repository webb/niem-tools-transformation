<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f="http://webb.github.io/xslt/niem"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xml-f="http://webb.github.io/xslt/xml"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- 
       Get the in-scope base URI at a given element.
    -->

  <import href="../xml/get-base-uri.xsl"/>

  <function name="f:get-uri" as="xs:anyURI?">
    <param name="context" as="element()"/>
    <choose>
      <when test="exists($context/@structures:id)">
        <value-of select="resolve-uri(concat('#', $context/@structures:id), xml-f:get-base-uri($context))"/>
      </when>
      <when test="exists($context/@structures:ref)">
        <value-of select="resolve-uri(concat('#', $context/@structures:ref), xml-f:get-base-uri($context))"/>
      </when>
      <when test="exists($context/@structures:uri)">
        <value-of select="resolve-uri($context/@structures:uri, xml-f:get-base-uri($context))"/>
      </when>
    </choose>
  </function>

</stylesheet>
