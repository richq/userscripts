// ==UserScript==
// @name           Hacker News via viewtext.org
// @namespace      hackernews
// @description    All stories go through viewtext.org
// @include        http://news.ycombinator.com/
// ==/UserScript==


var allTds = document.getElementsByTagName('td');
for (var i in allTds) {
    var td = allTds[i];
    if((" " + td.className + " ").indexOf(" title ") > -1) {
        // fix all urls in this title...
        var elems = td.getElementsByTagName('a');
        var spans = td.getElementsByTagName('span');
        if (elems.length > 0) {
            var a = elems[0];
            var origHref = a.href;
            a.href = "http://viewtext.org/article?url=" + a.href;
            if (spans.length > 0) {
                var span = spans[0];
                var origLink = document.createElement('a');
                origLink.setAttribute('href', origHref);
                var linkText = span.firstChild.data.replace(/^\s*/, "");
                origLink.appendChild(document.createTextNode(linkText));
                span.appendChild(origLink);
                span.firstChild.data = " ";
            }
        }
    }
}


