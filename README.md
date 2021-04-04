# xmlEdit
Editor for XML-files made with Saxon-JS 2.1

After a Hello World approach this is my first try with Saxon-JS and XSLT 3.0 in the browser. Would it be able to realize a XML editor? It is, but it's only capable of editing the text values of elements and attributes yet. No comments or processing instructions and no structure changes. Everything happens client side.

Check it out running on [GitHub Pages](https://andreasheese.github.io/xmlEdit).

Saxon-JS 2 is a product of Saxonica and available at [saxonica.com](https://www.saxonica.com/saxon-js/index.xml). It is free of charge but not open source. The [public license](https://www.saxonica.com/saxon-js/documentation/index.html#!conditions/public-license) only applies to the file [SaxonJS2.rt.js](https://andreasheese.github.io/xmlEdit/SaxonJS2.rt.js) for the working example on GitHub Pages, which is not part of the xmlEdit project. The MIT License applies to xmlEdit.

Saxonica states that Saxon-JS is a high-performance XSLT 3.0 processor that runs either in the browser, or on Node.js. It conforms with the latest W3C specifications (notably XSLT 3.0 and XPath 3.1), together with extensions designed to meet the needs of modern web applications.

For use with Saxon-JS the XSLT script must be compiled into SEF format. To do this, either Saxon-EE or the Node-based Saxon-JS Compiler is required. I used Saxon-EE for compiling. You will only need to compile the stylesheet if you want to change it. If you use it as-is the compiled .sef.json file can be used. To change only the .html file, recompiling isn't needed. Also the initial .xsl script isn't necessary to run the .html file.
