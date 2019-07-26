<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f="http://webb.github.io/xslt/xml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- 
       Get the clark name for a qname
    -->

  <function name="f:get-clark-name" as="xs:string">
    <param name="qname" as="xs:QName"/>
    <value-of>{<value-of select="namespace-uri-from-QName($qname)"/>}<value-of select="local-name-from-QName($qname)"/></value-of>
  </function>

</stylesheet>
