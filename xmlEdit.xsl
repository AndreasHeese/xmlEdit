<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2021 - xmlEdit.xsl - Andreas Heese - Version 1.1 - MIT-License -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT" xmlns:js="http://saxonica.com/ns/globalJS" xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="html ixsl js">
	<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>
	<xsl:param name="parameter"></xsl:param>
	<xsl:variable name="data">
		<xsl:copy-of select="/"/>
	</xsl:variable>
	
	<!-- ===== root template ===== -->
	<xsl:template match="/">
		<xsl:result-document href="#content" method="ixsl:replace-content">
			<xsl:apply-templates select="$data/(processing-instruction()|comment()|*)" mode="display"/>
		</xsl:result-document>
		<xsl:result-document href="#save" method="ixsl:replace-content">
			<xsl:if test="$parameter[1] = 'update'">
				<html:a href="{js:returnBlob(serialize($data, map{'method':'xml', 'indent':true()}))}" download="{$parameter[2]}" id="lnkDownload"><html:button type="button">Download</html:button></html:a>
			</xsl:if>
		</xsl:result-document>
		<ixsl:set-style object="js:document.getElementById('btnUpdate')" name="display" select="'none'"/>
	</xsl:template>
	
	<!-- ===== on update button click trigger new transform with changed xml ===== -->
	<xsl:template mode="ixsl:onclick" match="button[@id='btnUpdate']">
		<xsl:variable name="updated">
			<xsl:text>
</xsl:text><!-- start with new line to avoid XML declaration conficts -->
			<xsl:apply-templates select="$data/(processing-instruction()|comment()|*)" mode="update"/>
		</xsl:variable>
		<xsl:value-of select="js:handleUpdate(serialize($updated, map{'method':'xml', 'indent':true()}))"/>
	</xsl:template>
	
	<!-- ===== on download click hide link with button ===== -->
	<xsl:template mode="ixsl:onclick" match="a[@id='lnkDownload']">
		<ixsl:set-style name="display" select="'none'"/>
	</xsl:template>
	
	<!-- ===== display ===== -->
	<xsl:template match="*" mode="display">
		<html:p class="elem">
			<html:span class="name">
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:variable name="namespace" select="namespace-uri()"/>
				<!-- add namespace on first occurrence (not first in-scope for simplicity) -->
				<xsl:if test="(string-length(namespace-uri()) != 0) and not(ancestor::*[namespace-uri(.) = $namespace])">
					<xsl:variable name="prefix" select="substring-before(name(),':')"/>
					<html:span class="attr">
						<xsl:value-of select="if (string-length($prefix) &gt; 0) then ('xmlns:'||$prefix) else ('xmlns')"/>
						<xsl:value-of select="'=&#x22;'||namespace-uri()||'&#x22;'"/>
					</html:span>
				</xsl:if>
				<xsl:apply-templates select="@*" mode="display"/>
				<xsl:text>&gt;</xsl:text>
			</html:span>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="display"/>
		</html:p>
	</xsl:template>
	
	<xsl:template match="@*" mode="display">
		<xsl:variable name="id" select="generate-id(.)"/>
		<html:span class="attr">
			<xsl:value-of select="name()"/>
			<xsl:text>="</xsl:text>
			<html:span contenteditable="true" id="{$id}" oninput="handleInput(this)" title="ID: {$id}">
				<xsl:value-of select="."/>
			</html:span>
			<xsl:text>"</xsl:text>
		</html:span>
	</xsl:template>

	<xsl:template match="processing-instruction()" mode="display">
		<xsl:variable name="id" select="generate-id(.)"/>
		<html:p class="proc">
			<html:span class="proc">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>?&gt;</xsl:text>
			</html:span>
		</html:p>
	</xsl:template>

	<xsl:template match="comment()" mode="display">
		<xsl:variable name="id" select="generate-id(.)"/>
		<html:p class="comt">
			<html:span class="comt">
				<xsl:text>&lt;!--</xsl:text>
				<html:span contenteditable="true" id="{$id}" oninput="handleInput(this)" title="ID: {$id}">
					<xsl:value-of select="."/>
				</html:span>
				<xsl:text>--&gt;</xsl:text>
			</html:span>
		</html:p>
	</xsl:template>

	<xsl:template match="text()[string-length(normalize-space(.)) = 0]" mode="display"/>
	
	<xsl:template match="text()" mode="display">
		<xsl:variable name="id" select="generate-id(.)"/>
		<html:span contenteditable="true" id="{$id}" oninput="handleInput(this)" title="ID: {$id}">
			<xsl:value-of select="."/>
		</html:span>
	</xsl:template>
	
	<!-- ===== update ===== -->
	<xsl:template match="*" mode="update">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:apply-templates select="@*" mode="update"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="update"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*" mode="update">
		<xsl:variable name="id" select="generate-id(.)"/>
		<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
			<xsl:value-of select="if (js:getClassEdited($id) = 'e') then (js:getContent($id)) else (.)"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="text()" mode="update">
		<xsl:variable name="id" select="generate-id(.)"/>
		<xsl:value-of select="if (js:getClassEdited($id) = 'e') then (js:getContent($id)) else (.)"/>
	</xsl:template>
	
	<xsl:template match="processing-instruction()" mode="update">
		<xsl:processing-instruction name="{name()}">
			<xsl:value-of select="."/>
		</xsl:processing-instruction>
	</xsl:template>
	
	<xsl:template match="comment()" mode="update">
		<xsl:variable name="id" select="generate-id(.)"/>
		<xsl:comment>
			<xsl:value-of select="if (js:getClassEdited($id) = 'e') then (js:getContent($id)) else (.)"/>
		</xsl:comment>
	</xsl:template>
	
</xsl:stylesheet>
