<cfset emojiLib = new emojiJava()>

<cfsavecontent variable="Attributes.inputString">Let's get some awesome ☕ at the café down the straße. 😃</cfsavecontent>
<cfparam name="form.inputString" default="#Attributes.inputString#">
<cfset inputString = form.inputString>

<cfcontent type="text/html; charset=UTF-8">
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>cf-emoji-java Test</title>
	<meta name="description" content="ColdFusion + Java library to convert short codes, emoticons, html entities, emoticons to emojis and vice-versa.">
	<meta name="author" content="James Moberg / SunStar Media">
	<style>
	textarea {width:100%;}
	fieldset {margin-bottom:25px;}
	</style>
</head>
<body>
	<cfoutput>
	<h1>cf-emoji-java Test</h1>

	<h2>Enter Test String Containing Emojis</h2>
	<form action="#CGI.Path_Info#" method="post">
		<textarea id="inputString" name="inputString" required placeholder="Enter a string containing emojis.">#inputString#</textarea>
		<div style="float:right;">
			<button type="button" onclick="document.getElementById('inputString').value='An 😀awesome 😃string with a few 😉emojis!';">Reset</button>
			<button type="button" onclick="document.getElementById('inputString').value='I ❤️ 🍕';">I ❤️ 🍕</button>
		</div>
		<button type="submit">Perform Emoji Test</button>
	</form>

	<h2>Results</h2>
	<fieldset><legend>writeOutput(inputString)</legend>
		<xmp>#inputString#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.getForAlias("smiley")</legend>
		<cfdump var="#emojiLib.getForAlias("smiley")#">
	</fieldset>

	<fieldset><legend>emojiLib.getForTag("happy")</legend>
		<cfdump var="#emojiLib.getForTag("happy")#">
	</fieldset>

	<fieldset><legend>emojiLib.getAllTags()</legend>
		<cfdump var="#emojiLib.getAllTags()#" expand="false" label="emoji tags">
	</fieldset>

	<fieldset><legend>emojiLib.getAll()</legend>
		<cfdump var="#emojiLib.getAll()#" expand="false" label="emojis (top 25)" top="25">
	</fieldset>

	<fieldset><legend>emojiLib.containsEmoji(inputString)</legend>
		containsEmoji = #emojiLib.containsEmoji(inputString)#
	</fieldset>

	<fieldset><legend>emojiLib.isEmoji(inputString)</legend>
		isEmoji = #emojiLib.isEmoji(inputString)#
	</fieldset>

	<fieldset><legend>emojiLib.isOnlyEmojis(inputString)</legend>
		isOnlyEmojis = #emojiLib.isOnlyEmojis(inputString)#
	</fieldset>

	<fieldset><legend>emojiLib.parseToAliases(inputString)</legend>
		<xmp>#emojiLib.parseToAliases(inputString)#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.parseToHtmlDecimal(inputString)</legend>
		<xmp>#emojiLib.parseToHtmlDecimal(inputString)#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.parseToHtmlHexadecimal(inputString)</legend>
		<xmp>#emojiLib.parseToHtmlHexadecimal(inputString)#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.removeAllEmojis(inputString)</legend>
		<xmp>#emojiLib.removeAllEmojis(inputString)#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.removeAllEmojisExcept(inputString, ["smiley"])</legend>
		<xmp>#emojiLib.removeAllEmojisExcept(inputString, ["smiley"])#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.removeEmojis(inputString, "smiley")</legend>
		<xmp>#emojiLib.removeEmojis(inputString, "smiley")#</xmp>
	</fieldset>

	<fieldset><legend>emojiLib.extractEmojis(inputString)</legend>
		<cfdump var="#emojiLib.extractEmojis(inputString)#">
	</fieldset>
	<fieldset><legend>emojiLib.extractEmojis(inputString, true)</legend>
		<cfdump var="#emojiLib.extractEmojis(inputString, true)#">
	</fieldset>

	<fieldset><legend>emojiLib.replaceAllEmojis(inputString, "[emoji]")</legend>
		<xmp>#emojiLib.replaceAllEmojis(inputString, "[emoji]")#</xmp>
	</fieldset>

	<h2>Misc Tests</h2>

	<fieldset><legend>writedump(emojiLib)</legend>
		<cfdump VAR="#emojiLib#" label="emojiLib" expand="false">
	</fieldset>

	<fieldset><legend>Performance</legend>
		<cfset start = getTickCount()>
		<cfloop from="1" to="1000" index="i"><cfset ignoreString = emojiLib.parseToAliases(inputString)></cfloop>
		1,000 "parseToAliases" Time: #NumberFormat(GetTickCount()-Start)#ms<br>
		<cfset start = getTickCount()><cfset ignoreString = emojiLib.parseToAliases(inputString)>
		1 "parseToAliases" Time: #NumberFormat(GetTickCount()-Start)#ms<br>
	</fieldset>

	<fieldset><legend>len(inputString)</legend>
		#NumberFormat(len(inputString))# = ACTUAL len()<br>
		#NumberFormat(len(emojiLib.replaceAllEmojis(inputString, "X")))# = VISIBLE length
	</fieldset>

	<fieldset><legend>HTMLEditFormat(inputString)</legend>
		<xmp>#HTMLEditFormat(inputString)#</xmp>
	</fieldset>
	<fieldset><legend>EncodeForHTML(inputString)</legend>
		<xmp>#EncodeForHTML(inputString)#</xmp>
	</fieldset>
	<fieldset><legend>EncodeForHTML(emojiLib.parseToHtmlDecimal(inputString), true)</legend>
		<xmp>#EncodeForHTML(emojiLib.parseToHtmlDecimal(inputString), true)#</xmp>
	</fieldset>
	<fieldset><legend>EncodeForHTMLAttribute(inputString)</legend>
		<xmp>#EncodeForHTMLAttribute(inputString)#</xmp>
	</fieldset>

	<fieldset><legend>HTMLEditFormat/EncodeforHTML Comparison</legend>
		HTMLEditFormat(inputString) = <xmp>#HTMLEditFormat(inputString)#</xmp>
		EncodeForHTML(inputString) = <xmp>#EncodeForHTML(inputString)#</xmp>
	</fieldset>

	<h2>Junidecode / Romanization Results (Extra)</h2>
	<cftry>
		<cfset JunidecodeLib = new Junidecode()>
		<fieldset><legend>JunidecodeLib.unidecode(inputString)</legend>
			<xmp>#JunidecodeLib.unidecode(inputString)#</xmp>
		</fieldset>

		<fieldset><legend>JunidecodeLib.unidecode(emojiLib.parseToAliases(inputString))</legend>
			<cfdump var="#JunidecodeLib.unidecode(emojiLib.parseToAliases(inputString))#">
		</fieldset>
		<cfcatch>
			<p style="color:red;">Junidecode testing not available.</p>
		</cfcatch>
	</cftry>

	</cfoutput>

</body>
</html>
