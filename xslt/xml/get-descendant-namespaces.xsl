<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f="http://webb.github.io/xslt/xml"
  xmlns:private="http://webb.github.io/xslt/xml/private"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- results are:

       <f:namespace prefix="$prefix" uri="$uri"/>
       ...

       -->

  <!-- demo

  <output method="xml" indent="yes"/>

  <template match="/*">
    <sequence select="f:get-descendant-namespaces(.)"/>
  </template>
    -->
       
  <function name="f:get-descendant-namespaces" as="element(f:namespace)*">
    <param name="targets" as="element()*"/>
    <variable name="raw-results" as="element(f:namespace)*">
      <apply-templates mode="private:get-descendant-namespaces" select="$targets"/>
    </variable>
    <for-each select="distinct-values($raw-results/@prefix)">
      <variable name="prefix" select="."/>
      <variable name="namespaces-for-prefix" select="distinct-values($raw-results[@prefix = $prefix]/@uri)"/>
      <if test="count($namespaces-for-prefix) gt 1">
        <message terminate="yes">too many uris defined for prefix <value-of select="."/></message>
      </if>
      <variable name="namespace" select="exactly-one($namespaces-for-prefix)"/>
      <f:namespace prefix="{$prefix}" uri="{$namespace}"/>
    </for-each>
  </function>

  <template mode="private:get-descendant-namespaces"
            match="*"
            as="element(f:namespace)*">
    <variable name="context" select="."/>
    <for-each select="in-scope-prefixes(.)">
      <f:namespace prefix="{.}" uri="{namespace-uri-for-prefix(., $context)}"/>
    </for-each>
    <apply-templates mode="#current" select="*"/>
  </template>


</stylesheet>
