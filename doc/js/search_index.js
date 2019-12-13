var search_data = {"index":{"searchIndex":["datetime","elastictalk","logline","logwalker","object","string","tailer","warbler","allfiles()","close()","getdatestr()","getdatetime()","getelasticdescription()","getfulllogdate()","getlines()","getlogdate()","hasdate?()","is_fulllogdate?()","is_logdate?()","is_elasticreachable?()","logfiles()","new()","new()","new()","new()","parse()","postlogasjson()","postlogasrubyhash()","postlogbatch()","rot1files()","rotcompressedfiles()","to_datetime()","to_elasticdate()","to_elasticdate()","to_fulllogdate()","to_fulllogdate()","to_logdate()","to_logdate()","lcls-logbeat3.rb,v","logline.rb,v","readme","datetime.html","elastictalk.html","io.html","logline.html","logwalker.html","object.html","lcls-logbeat3_rb,v.html","logline_rb,v.html","readme.html","string.html","tailer.html","warbler.html","created.rid","fonts.css","rdoc.css","index.html","darkfish.js","jquery.js","navigation.js","search.js","search_index.js","searcher.js","makedoc_sh.html","makejar_sh.html","logtoelasticsenderrunner_sh.html","table_of_contents.html","tailer.rb,v","makedoc.sh","makejar.sh","logtoelasticsenderrunner.sh"],"longSearchIndex":["datetime","elastictalk","logline","logwalker","object","string","tailer","warbler","logwalker#allfiles()","tailer#close()","logline#getdatestr()","logline#getdatetime()","elastictalk#getelasticdescription()","logline#getfulllogdate()","tailer#getlines()","logline#getlogdate()","logline#hasdate?()","string#is_fulllogdate?()","string#is_logdate?()","elastictalk#is_elasticreachable?()","logwalker#logfiles()","elastictalk::new()","logline::new()","logwalker::new()","tailer::new()","logline#parse()","elastictalk#postlogasjson()","elastictalk#postlogasrubyhash()","elastictalk#postlogbatch()","logwalker#rot1files()","logwalker#rotcompressedfiles()","string#to_datetime()","datetime#to_elasticdate()","string#to_elasticdate()","datetime#to_fulllogdate()","string#to_fulllogdate()","datetime#to_logdate()","string#to_logdate()","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""],"info":[["DateTime","","DateTime.html","","<p>We overload the class <code>DateTime</code> with two methods to get the\nstring  representation of the date object …\n"],["ElasticTalk","","ElasticTalk.html","","<p>Class to abstract the comunication with <strong>Elasticsearch</strong>.\n"],["LogLine","","LogLine.html","","<p>The class LogLine is specifically to represent logfile lines as seen in \n<em>psmetric01</em>. Here a few examples …\n"],["LogWalker","","LogWalker.html","","<p>The class <code>LogWalker</code> abstracts the most common access\nprocedures to visit the log files.\n<p>The class is …\n"],["Object","","Object.html","",""],["String","","String.html","","<p>We overload the class <code>String</code> with some methods to simplify the\nmanagement of dates.\n<p>Dates appearing in …\n"],["Tailer","","Tailer.html","","<p>class <code>TailFile</code> define behaviour of a <code>TailFile</code>\nobject. A <code>TailFile</code>\n<p>Example\n\n<pre>tf = Tailer.new(&quot;/u2/logs/psmetric01/messages&quot;) ...</pre>\n"],["Warbler","","Warbler.html","",""],["allFiles","LogWalker","LogWalker.html#method-i-allFiles","()","<p>Return <code>Enumerator</code>. The returned enumerator goes through all\n<strong>files</strong>\n<p>contained below <code>basePath</code> node. Directories …\n"],["close","Tailer","Tailer.html#method-i-close","()",""],["getDateStr","LogLine","LogLine.html#method-i-getDateStr","()","<p>Return <strong>String</strong>, the date substring from the log line.\nReturns <strong>“”</strong>  if the date can&#39;t be found …\n"],["getDateTime","LogLine","LogLine.html#method-i-getDateTime","()","<p>Returns <code>DateTime</code>. Date of the logline as a\n<code>DateTime</code>.\n"],["getElasticDescription","ElasticTalk","ElasticTalk.html#method-i-getElasticDescription","()","<p>Return <code>String</code>. If there is an errore returns nil.  TODO:\nExeceptions. Gives a back a string giving some …\n"],["getFullLogDate","LogLine","LogLine.html#method-i-getFullLogDate","()","<p>Returns <code>String</code>. Date of the logline in format\n<strong>FullLogDate</strong>.\n"],["getLines","Tailer","Tailer.html#method-i-getLines","()","<p>get the new lines (tail lines) from the file\n"],["getLogDate","LogLine","LogLine.html#method-i-getLogDate","()","<p>Returns <code>String</code>. Date of the logline in format\n<strong>LogDate</strong>.\n"],["hasDate?","LogLine","LogLine.html#method-i-hasDate-3F","()","<p>Returns a <strong>Boolean</strong>, <strong>true</strong> if the LogLine\nstring contains a correct date substring and false otherwise. …\n"],["is_FullLogDate?","String","String.html#method-i-is_FullLogDate-3F","()","<p>Returns Boolean. Checks if a <code>String</code> is in the\n<code>FullLogDate</code> format.\n\n<pre>&quot;2011 Nov 01 14:12:10&quot;.is_FullLogDate? ...</pre>\n"],["is_LogDate?","String","String.html#method-i-is_LogDate-3F","()","<p>Returns Boolean. Checks if the <code>String</code> is in the\n<code>LogDate</code> format.\n\n<pre class=\"ruby\"><span class=\"ruby-string\">&quot;Nov 01 14:12:10&quot;</span>.<span class=\"ruby-identifier\">is_LogDate?</span>\n=<span class=\"ruby-operator\">&gt;</span> <span class=\"ruby-keyword\">true</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["is_elasticReachable?","ElasticTalk","ElasticTalk.html#method-i-is_elasticReachable-3F","()","<p>Return <code>Object</code>.  Equivalent to “ssh -L 9200:localhost:9200\np@elavi”\n<p>def ElasticTalk.openElaviTunnel …\n"],["logFiles","LogWalker","LogWalker.html#method-i-logFiles","()","<p>Return <code>Enumerator</code>. Return all files that can be considere log\nfiles.  In our setup, these are all files …\n"],["new","ElasticTalk","ElasticTalk.html#method-c-new","(host=\"localhost\", port=\"9200\")",""],["new","LogLine","LogLine.html#method-c-new","(str)","<p>Example:\n\n<pre>ll = LogLine.new( &quot;Oct 31 11:06:01 psana101 systemd: Stopping User Slice of nmingott.&quot; )</pre>\n"],["new","LogWalker","LogWalker.html#method-c-new","(path)","<p>It is supposed the logfiles live under a common directory node.  Here\n<code>path</code> is a <code>String</code> and must be the …\n"],["new","Tailer","Tailer.html#method-c-new","(path, logfile=STDERR)","<p>Example  tf = TailFile.new(“/u2/logs/psmetric01/messages”)\n"],["parse","LogLine","LogLine.html#method-i-parse","()","<p>Parse the LogLine string and returns a Ruby <code>Hash</code>. Return\n<code>Hash</code>.\n<p>These keys are added to the onse found …\n"],["postLogAsJSON","ElasticTalk","ElasticTalk.html#method-i-postLogAsJSON","(index=\"lclslogs-test\", type=\"log\", jsonStr, bulk: false)","<p>Return <code>...</code>. Insert a single document into Elasticsearch using\nPOST. With this method of insertion the …\n"],["postLogAsRubyHash","ElasticTalk","ElasticTalk.html#method-i-postLogAsRubyHash","(index=\"lclslogs-test\", type=\"log\", diz)","<p>Example\n\n<pre>d = {date: &quot;2018 Nov 10 22:48:00&quot;, machine: &quot;foo&quot;, \n     service: &quot;bar&quot;, message: &quot;hello 2&quot;}  ...</pre>\n"],["postLogBatch","ElasticTalk","ElasticTalk.html#method-i-postLogBatch","(index=\"lclslogs-test\", type=\"log\", list, fake: false)","<p>Sends a list of Ruby <code>Hash</code> objects to Elasticsearch in bluk.\n<p>Returns: [sizeInByteOfThePayloadSend, responseObjectFromElasticSearch]. …\n"],["rot1Files","LogWalker","LogWalker.html#method-i-rot1Files","()","<p>Return <code>Enumerator</code>. Return all log files that have been rotated\nexactly one time. There files in out setup …\n"],["rotCompressedFiles","LogWalker","LogWalker.html#method-i-rotCompressedFiles","()","<p>Return <code>Enumerator</code>. Return all files that can be considered\ncompressed log files. Those are files that …\n"],["to_DateTime","String","String.html#method-i-to_DateTime","()","<p>Returns <code>DateTime</code>. Given a <code>LogDate</code> or\n<code>FullLogDate</code> format string, it  returns a <code>DateTime</code>\nobject. In the …\n"],["to_ElasticDate","DateTime","DateTime.html#method-i-to_ElasticDate","()","<p>Return <code>String</code>. The string is in a format that\nElasticsearch/Kibana  can recognize as a date:\n“2018-11-11T15:24:43+TIMEZONE” …\n"],["to_ElasticDate","String","String.html#method-i-to_ElasticDate","()","<p>Returns <code>String</code>. Convert to a date format undertandable by\nElasticsearch/Kibana. i.e.: “2018-11-11T15:24:43” …\n"],["to_FullLogDate","DateTime","DateTime.html#method-i-to_FullLogDate","()","<p>Returns a <code>String</code>. The string is in the\n<code>FullLogDate</code> format.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">d</span> = <span class=\"ruby-constant\">DateTime</span>.<span class=\"ruby-identifier\">now</span>\n=<span class=\"ruby-operator\">&gt;</span> <span class=\"ruby-comment\">#&lt;DateTime: 2018-11-02T19:36:40-07:00 ...</span>\n</pre>\n"],["to_FullLogDate","String","String.html#method-i-to_FullLogDate","()","<p>Returns <code>String</code>. Given a string in the <code>LogDate</code> or\n<code>FullLogDate</code> format  return a <code>String</code> in the\n<code>FullLogDate</code> …\n"],["to_LogDate","DateTime","DateTime.html#method-i-to_LogDate","()","<p>Returns a <code>String</code>. The string is in the <code>LogDate</code>\nformat.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">d</span> = <span class=\"ruby-constant\">DateTime</span>.<span class=\"ruby-identifier\">now</span>\n=<span class=\"ruby-operator\">&gt;</span> <span class=\"ruby-comment\">#&lt;DateTime: 2018-11-02T19:36:40-07:00 ...</span>\n</pre>\n"],["to_LogDate","String","String.html#method-i-to_LogDate","()","<p>Returns <code>String</code>. Given a string in the <code>LogDate</code> of\n<code>FullLogDate</code> format returns a string in the\n<code>LogDate</code> format. …\n"],["LCLS-LogBeat3.rb,v","","RCS/LCLS-LogBeat3_rb,v.html","","<p>head    1.3; access; symbols; locks\n\n<pre>nmingott:1.3; strict;</pre>\n<p>comment @# @;\n"],["logLine.rb,v","","RCS/logLine_rb,v.html","","<p>head    1.1; access; symbols; locks; strict; comment @# @;\n<p>1.1 date    2018.11.15.04.44.06;    author …\n"],["README","","README.html","",""],["DateTime.html","","doc/DateTime_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["ElasticTalk.html","","doc/ElasticTalk_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["IO.html","","doc/IO_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;module …\n"],["LogLine.html","","doc/LogLine_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["LogWalker.html","","doc/LogWalker_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["Object.html","","doc/Object_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["LCLS-LogBeat3_rb,v.html","","doc/RCS/LCLS-LogBeat3_rb,v_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;LCLS-LogBeat3.rb,v …\n"],["logLine_rb,v.html","","doc/RCS/logLine_rb,v_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;logLine.rb,v …\n"],["README.html","","doc/README_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;README …\n"],["String.html","","doc/String_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["Tailer.html","","doc/Tailer_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;class …\n"],["Warbler.html","","doc/Warbler_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;module …\n"],["created.rid","","doc/created_rid.html","","<p>Tue, 27 Nov 2018 12:13:29 -0800 ./README        Tue, 27 Nov 2018 10:44:30\n-0800 ./bin/LCLSlogBeat4.rb …\n"],["fonts.css","","doc/css/fonts_css.html","","\n<pre>Copyright 2010, 2012 Adobe Systems Incorporated (http://www.adobe.com/),\nwith Reserved Font Name &quot;Source&quot;. ...</pre>\n"],["rdoc.css","","doc/css/rdoc_css.html","","\n<pre>&quot;Darkfish&quot; Rdoc CSS\n$Id: rdoc.css 54 2009-01-27 01:09:48Z deveiant $\n\nAuthor: Michael Granger &lt;ged@FaerieMUD.org&gt; ...</pre>\n"],["index.html","","doc/index_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;RDoc …\n"],["darkfish.js","","doc/js/darkfish_js.html","","\n<pre>Darkfish Page Functions\n$Id: darkfish.js 53 2009-01-07 02:52:03Z deveiant $\n\nAuthor: Michael Granger ...</pre>\n"],["jquery.js","","doc/js/jquery_js.html","","\n<pre>! jQuery v1.6.4 http://jquery.com/ | http://jquery.org/license</pre>\n<p>(function(a,b){function cu(a){return f.isWindow …\n"],["navigation.js","","doc/js/navigation_js.html","","\n<pre>Navigation allows movement using the arrow keys through the search results.\n\nWhen using this library ...</pre>\n"],["search.js","","doc/js/search_js.html","","<p>Search = function(data, input, result) {\n\n<pre>this.data = data;\nthis.$input = $(input);\nthis.$result = $(result); ...</pre>\n"],["search_index.js","","doc/js/search_index_js.html","","<p>var search_data =\n{“index”:{“searchIndex”:,“longSearchIndex”:,“info”:[[“DateTime”,“”,“DateTime.html”,“”,“&lt;p&gt;We\n…\n"],["searcher.js","","doc/js/searcher_js.html","","<p>Searcher = function(data) {\n\n<pre>this.data = data;\nthis.handlers = [];</pre>\n<p>}\n"],["makeDoc_sh.html","","doc/makeDoc_sh_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;makeDoc.sh …\n"],["makeJar_sh.html","","doc/makeJar_sh_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;makeJar.sh …\n"],["logToElasticSenderRunner_sh.html","","doc/old/logToElasticSenderRunner_sh_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;logToElasticSenderRunner.sh …\n"],["table_of_contents.html","","doc/table_of_contents_html.html","","<p>&lt;!DOCTYPE html&gt;\n<p>&lt;html&gt; &lt;head&gt; &lt;meta charset=“UTF-8”&gt;\n<p>&lt;title&gt;Table …\n"],["tailer.rb,v","","lib/RCS/tailer_rb,v.html","","<p>head    1.1; access; symbols; locks; strict; comment @# @;\n<p>1.1 date    2018.11.30.23.43.45;    author …\n"],["makeDoc.sh","","makeDoc_sh.html","","<p>#!/usr/bin/env bash\n<p>rdoc\n"],["makeJar.sh","","makeJar_sh.html","","<p># read the config file in ./config/warble.rb to know what to do, # e.g. to\nknow that it must build a …\n"],["logToElasticSenderRunner.sh","","old/logToElasticSenderRunner_sh.html","","<p>#!/bin/bash\n<p>cd /reg/neh/home/nmingott source /reg/neh/home/nmingott/.bashrc\n<p>cd /reg/neh/home/nmingott/scripts/lclsLogBeat2 …\n"]]}}