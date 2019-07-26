<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f="http://webb.github.io/xslt/xml"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!--
      Get a URI for an id value on an element. An ID is turned into a fragement on the base URI.
    -->

  <import href="get-base-uri.xsl"/>

  <function name="f:get-uri-for-id" as="xs:anyURI">
    <param name="context" as="element()"/>
    <param name="id" as="xs:string"/>
    <sequence select="resolve-uri(concat('#', $id), f:get-base-uri($context))"/>
  </function>

</stylesheet>
