<cfset emojiLib = new emojiJava()>

<cfsavecontent variable="Attributes.inputString">Let's get some awesome ☕ at the café down the straße. 😃</cfsavecontent>
<cfparam name="form.inputString" default="#Attributes.inputString#">
<cfset inputString = form.inputString>

<cfcontent type="text/html; charset=UTF-8">
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>cf-emoji-java Demo</title>
	<meta name="description" content="ColdFusion + Java library to convert short codes, emoticons, html entities, emoticons to emojis and vice-versa.">
	<meta name="author" content="James Moberg / SunStar Media">
	<style>
		body { font-family: -apple-system, "Segoe UI", sans-serif; max-width: 1000px; margin: 1em auto; padding: 0 1em; line-height: 1.4; }
		textarea { width: 100%; min-height: 80px; font-family: inherit; }
		fieldset { margin-bottom: 18px; padding: 8px 12px; }
		fieldset legend { font-weight: 600; }
		pre code { display: block; background: #f4f4f4; padding: 8px; border-radius: 4px; white-space: pre-wrap; word-break: break-word; font-family: ui-monospace, "SFMono-Regular", Consolas, monospace; }
		nav.toc { background: #f9f9f9; border: 1px solid #ddd; padding: 8px 12px; border-radius: 4px; margin-bottom: 18px; }
		nav.toc a { margin-right: 12px; text-decoration: none; }
		.err { background: #fdecea; border-left: 4px solid #b00020; padding: 6px 10px; color: #b00020; font-family: ui-monospace, monospace; }
		.preset-row { display: flex; flex-wrap: wrap; gap: 6px; margin: 8px 0; }
		.preset-row button { font-size: 0.9em; padding: 4px 10px; }
		h2 { border-bottom: 2px solid #eee; padding-bottom: 4px; margin-top: 1.5em; }
		h2 .top-link { float: right; font-size: 0.65em; font-weight: normal; text-decoration: none; color: #666; }
		h2 .top-link:hover { color: #000; }
		table.lengths { border-collapse: collapse; }
		table.lengths th, table.lengths td { border: 1px solid #ddd; padding: 4px 10px; text-align: left; }
	</style>
</head>
<body>
	<cfoutput>
	<cfscript>
	function guard(required any callback) {
		try {
			return arguments.callback();
		} catch (any e) {
			return '<div class="err">EXCEPTION: ' & encodeForHTML(e.message) & '</div>';
		}
	}
	</cfscript>
	<h1 id="top">cf-emoji-java Demo</h1>

	<nav class="toc">
		<a href="##input">Input</a>
		<a href="##identity">Identity</a>
		<a href="##conversion">Conversion</a>
		<a href="##mutation">Mutation</a>
		<a href="##extraction">Extraction</a>
		<a href="##encoding">Encoding</a>
		<a href="##length">Length & Roundtrip</a>
		<a href="##performance">Performance</a>
		<a href="##romanization">Romanization</a>
	</nav>

	<h2 id="input">Enter Test String Containing Emojis <a href="##top" class="top-link">Top</a></h2>
	<form action="#CGI.Path_Info#" method="post">
		<textarea id="inputString" name="inputString" required placeholder="Enter a string containing emojis.">#encodeForHTML(inputString)#</textarea>
		<div class="preset-row">
			<button type="button" onclick="setPreset('An 😀 awesome 😃 string with a few 😉 emojis!')">Reset</button>
			<button type="button" onclick="setPreset('I ❤️ 🍕')">I ❤️ 🍕</button>
			<button type="button" onclick="setPreset('👁 ❤️ 🍕 🚀 ✨')">Only emojis</button>
			<button type="button" onclick="setPreset('👨‍👩‍👧‍👦')">ZWJ family</button>
			<button type="button" onclick="setPreset('👍🏽 👋🏿')">Skin tone</button>
			<button type="button" onclick="setPreset('The quick brown fox jumps over the lazy dog.')">Plain text</button>
			<button type="button" onclick="setPreset('café Zürich straße 北京 🌏')">Mixed unicode</button>
		</div>
		<button type="submit">Perform Emoji Test</button>
		<script>
		function setPreset(value) {
			var el = document.getElementById('inputString');
			el.value = value;
			el.form.submit();
		}
		</script>
	</form>

	<fieldset><legend>writeOutput(inputString)</legend>
		<pre><code>#encodeForHTML(inputString)#</code></pre>
	</fieldset>

	<h2 id="identity">Identity <a href="##top" class="top-link">Top</a></h2>

	<fieldset><legend>emojiLib.getForAlias("smiley")</legend>
		<cftry>
			<cfdump var="#emojiLib.getForAlias("smiley")#">
			<cfcatch type="any"><div class="err">EXCEPTION: <cfoutput>#encodeForHTML(cfcatch.message)#</cfoutput></div></cfcatch>
		</cftry>
	</fieldset>

	<fieldset><legend>emojiLib.getForTag("happy")</legend>
		<cftry>
			<cfdump var="#emojiLib.getForTag("happy")#">
			<cfcatch type="any"><div class="err">EXCEPTION: <cfoutput>#encodeForHTML(cfcatch.message)#</cfoutput></div></cfcatch>
		</cftry>
	</fieldset>

	<fieldset><legend>emojiLib.getAllTags()</legend>
		<cftry>
			<cfdump var="#emojiLib.getAllTags()#" expand="false" label="emoji tags">
			<cfcatch type="any"><div class="err">EXCEPTION: <cfoutput>#encodeForHTML(cfcatch.message)#</cfoutput></div></cfcatch>
		</cftry>
	</fieldset>

	<fieldset><legend>emojiLib.getAll()</legend>
		<cftry>
			<cfdump var="#emojiLib.getAll()#" expand="false" label="emojis (top 25)" top="25">
			<cfcatch type="any"><div class="err">EXCEPTION: <cfoutput>#encodeForHTML(cfcatch.message)#</cfoutput></div></cfcatch>
		</cftry>
	</fieldset>

	<fieldset><legend>emojiLib.containsEmoji(inputString)</legend>
		containsEmoji = #guard(() => emojiLib.containsEmoji(inputString))#
	</fieldset>

	<fieldset><legend>emojiLib.isEmoji(inputString)</legend>
		isEmoji = #guard(() => emojiLib.isEmoji(inputString))#
	</fieldset>

	<fieldset><legend>emojiLib.isOnlyEmojis(inputString)</legend>
		isOnlyEmojis = #guard(() => emojiLib.isOnlyEmojis(inputString))#
	</fieldset>

	<h2 id="conversion">Conversion <a href="##top" class="top-link">Top</a></h2>

	<fieldset><legend>emojiLib.parseToAliases(inputString)</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.parseToAliases(inputString)) & '</code></pre>')#
	</fieldset>

	<fieldset><legend>emojiLib.parseToHtmlDecimal(inputString)</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.parseToHtmlDecimal(inputString)) & '</code></pre>')#
	</fieldset>

	<fieldset><legend>emojiLib.parseToHtmlHexadecimal(inputString)</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.parseToHtmlHexadecimal(inputString)) & '</code></pre>')#
	</fieldset>

	<h2 id="mutation">Mutation <a href="##top" class="top-link">Top</a></h2>

	<fieldset><legend>emojiLib.removeAllEmojis(inputString)</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.removeAllEmojis(inputString)) & '</code></pre>')#
	</fieldset>

	<fieldset><legend>emojiLib.removeAllEmojisExcept(inputString, ["smiley"])</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.removeAllEmojisExcept(inputString, ["smiley"])) & '</code></pre>')#
	</fieldset>

	<fieldset><legend>emojiLib.removeEmojis(inputString, "smiley")</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.removeEmojis(inputString, "smiley")) & '</code></pre>')#
	</fieldset>

	<fieldset><legend>emojiLib.replaceAllEmojis(inputString, "[emoji]")</legend>
		#guard(() => '<pre><code>' & encodeForHTML(emojiLib.replaceAllEmojis(inputString, "[emoji]")) & '</code></pre>')#
	</fieldset>

	<h2 id="extraction">Extraction <a href="##top" class="top-link">Top</a></h2>

	<fieldset><legend>emojiLib.extractEmojis(inputString)</legend>
		<cftry>
			<cfdump var="#emojiLib.extractEmojis(inputString)#">
			<cfcatch type="any"><div class="err">EXCEPTION: <cfoutput>#encodeForHTML(cfcatch.message)#</cfoutput></div></cfcatch>
		</cftry>
	</fieldset>
	<fieldset><legend>emojiLib.extractEmojis(inputString, true)</legend>
		<cftry>
			<cfdump var="#emojiLib.extractEmojis(inputString, true)#">
			<cfcatch type="any"><div class="err">EXCEPTION: <cfoutput>#encodeForHTML(cfcatch.message)#</cfoutput></div></cfcatch>
		</cftry>
	</fieldset>

	<h2 id="encoding">Encoding <a href="##top" class="top-link">Top</a></h2>

	<fieldset><legend>HTMLEditFormat(inputString)</legend>
		<pre><code>#encodeForHTML(HTMLEditFormat(inputString))#</code></pre>
	</fieldset>
	<fieldset><legend>EncodeForHTML(inputString)</legend>
		<pre><code>#encodeForHTML(EncodeForHTML(inputString))#</code></pre>
	</fieldset>
	<fieldset><legend>EncodeForHTML(emojiLib.parseToHtmlDecimal(inputString), true)</legend>
		#guard(() => '<pre><code>' & encodeForHTML(EncodeForHTML(emojiLib.parseToHtmlDecimal(inputString), true)) & '</code></pre>')#
	</fieldset>
	<fieldset><legend>EncodeForHTMLAttribute(inputString)</legend>
		<pre><code>#encodeForHTML(EncodeForHTMLAttribute(inputString))#</code></pre>
	</fieldset>

	<fieldset><legend>HTMLEditFormat/EncodeforHTML Comparison</legend>
		HTMLEditFormat(inputString) = <pre><code>#encodeForHTML(HTMLEditFormat(inputString))#</code></pre>
		EncodeForHTML(inputString) = <pre><code>#encodeForHTML(EncodeForHTML(inputString))#</code></pre>
	</fieldset>

	<fieldset><legend>writedump(emojiLib)</legend>
		<cfdump VAR="#emojiLib#" label="emojiLib" expand="false">
	</fieldset>

	<h2 id="length">Length & Roundtrip <a href="##top" class="top-link">Top</a></h2>
	<fieldset>
		<legend>Length comparisons</legend>
		<cftry>
			<cfscript>
				utf16Len = len(inputString);
				codepointCount = inputString.codePointCount(javacast("int", 0), javacast("int", utf16Len));
				approxVisible = len(emojiLib.replaceAllEmojis(inputString, "X"));
			</cfscript>
			<table class="lengths">
				<tr><th>Metric</th><th>Value</th><th>What it counts</th></tr>
				<tr><td>len(inputString)</td><td>#numberFormat(utf16Len)#</td><td>UTF-16 code units (surrogate pairs count as 2)</td></tr>
				<tr><td>codePointCount</td><td>#numberFormat(codepointCount)#</td><td>Unicode codepoints</td></tr>
				<tr><td>approx visible</td><td>#numberFormat(approxVisible)#</td><td>Each detected emoji replaced with one char (rough approximation; ZWJ sequences over-count)</td></tr>
			</table>
			<cfcatch type="any"><div class="err">EXCEPTION: #encodeForHTML(cfcatch.message)#</div></cfcatch>
		</cftry>
	</fieldset>
	<fieldset>
		<legend>Roundtrip: original &rarr; aliases &rarr; aliases (idempotent?)</legend>
		<cftry>
			<cfscript>
				once = emojiLib.parseToAliases(inputString);
				twice = emojiLib.parseToAliases(once);
				stable = (once eq twice);
			</cfscript>
			<p><strong>Pass 1:</strong></p>
			<pre><code>#encodeForHTML(once)#</code></pre>
			<p><strong>Pass 2:</strong></p>
			<pre><code>#encodeForHTML(twice)#</code></pre>
			<p><strong>Stable (idempotent on alias-form)?</strong> #yesNoFormat(stable)#</p>
			<cfcatch type="any"><div class="err">EXCEPTION: #encodeForHTML(cfcatch.message)#</div></cfcatch>
		</cftry>
	</fieldset>

	<h2 id="performance">Performance <a href="##top" class="top-link">Top</a></h2>

	<fieldset><legend>Performance</legend>
		<cftry>
			<cfset start = getTickCount()>
			<cfloop from="1" to="1000" index="i"><cfset ignoreString = emojiLib.parseToAliases(inputString)></cfloop>
			1,000 "parseToAliases" Time: #NumberFormat(GetTickCount()-Start)#ms<br>
			<cfset start = getTickCount()><cfset ignoreString = emojiLib.parseToAliases(inputString)>
			1 "parseToAliases" Time: #NumberFormat(GetTickCount()-Start)#ms<br>
			<cfcatch type="any"><div class="err">EXCEPTION: #encodeForHTML(cfcatch.message)#</div></cfcatch>
		</cftry>
	</fieldset>

	<fieldset><legend>len(inputString)</legend>
		<cftry>
			#NumberFormat(len(inputString))# = ACTUAL len()<br>
			#NumberFormat(len(emojiLib.replaceAllEmojis(inputString, "X")))# = VISIBLE length
			<cfcatch type="any"><div class="err">EXCEPTION: #encodeForHTML(cfcatch.message)#</div></cfcatch>
		</cftry>
	</fieldset>

	<h2 id="romanization">AnyAscii / Romanization Results (Extra) <a href="##top" class="top-link">Top</a></h2>
	<p><em>Requires the <a href="https://github.com/anyascii/anyascii">AnyAscii</a> Java JAR plus a CFC wrapper at <code>AnyAscii.cfc</code>. Not bundled with this project.</em></p>
	<cftry>
		<cfset AnyAsciiLib = new AnyAscii()>
		<fieldset><legend>AnyAsciiLib.transliterate(inputString)</legend>
			<pre><code>#encodeForHTML(AnyAsciiLib.transliterate(inputString))#</code></pre>
		</fieldset>

		<fieldset><legend>AnyAsciiLib.transliterate(emojiLib.parseToAliases(inputString))</legend>
			<pre><code>#encodeForHTML(AnyAsciiLib.transliterate(emojiLib.parseToAliases(inputString)))#</code></pre>
		</fieldset>
		<cfcatch type="any">
			<p class="err">AnyAscii testing not available. (Expected — this project doesn't bundle the AnyAscii JAR.)</p>
		</cfcatch>
	</cftry>

	</cfoutput>

</body>
</html>
