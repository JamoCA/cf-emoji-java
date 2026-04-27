<cfscript>
variables.passes = 0;
variables.failures = [];

function assert(required boolean condition, required string label) {
    if (arguments.condition) {
        variables.passes++;
        writeOutput('<div style="color:##0a7d28;">&##10003; ' & encodeForHTML(arguments.label) & '</div>');
    } else {
        arrayAppend(variables.failures, arguments.label);
        writeOutput('<div style="color:##b00020;font-weight:bold;">&##10007; ' & encodeForHTML(arguments.label) & '</div>');
    }
}

function summarize() {
    var total = variables.passes + arrayLen(variables.failures);
    writeOutput('<hr><h2>' & variables.passes & ' / ' & total & ' passed</h2>');
    if (arrayLen(variables.failures)) {
        getPageContext().getResponse().setStatus(500);
        writeOutput('<h3 style="color:##b00020;">' & arrayLen(variables.failures) & ' failure(s)</h3><ul>');
        for (var f in variables.failures) {
            writeOutput('<li>' & encodeForHTML(f) & '</li>');
        }
        writeOutput('</ul>');
    } else {
        writeOutput('<p style="color:##0a7d28;font-weight:bold;">All tests passed.</p>');
    }
}

function cp(required numeric codepoint) {
    if (arguments.codepoint <= 65535) {
        return chr(arguments.codepoint);
    }
    var offset = arguments.codepoint - 65536;
    return chr(55296 + bitShrn(offset, 10)) & chr(56320 + bitAnd(offset, 1023));
}
</cfscript>
<cfcontent type="text/html; charset=UTF-8">
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>cf-emoji-java tests</title>
    <style>
        body { font-family: -apple-system, Segoe UI, sans-serif; max-width: 900px; margin: 1em auto; padding: 0 1em; }
        div { padding: 2px 0; font-family: monospace; }
        h2 { margin-top: 1em; }
    </style>
</head>
<body>
<h1>cf-emoji-java tests</h1>
<cfscript>
emojiLib = new cfemojijava.emojiJava();

// --- EmojiManager methods ---

smiley = emojiLib.getForAlias("smiley");
assert(isStruct(smiley), "getForAlias('smiley') returns a struct");
assert(isArray(smiley.aliases) && arrayFindNoCase(smiley.aliases, "smiley") gt 0, "getForAlias('smiley').aliases contains 'smiley'");

happyTag = emojiLib.getForTag("happy");
assert(isArray(happyTag) && arrayLen(happyTag) gt 0, "getForTag('happy') returns a non-empty array");
assert(isStruct(happyTag[1]), "getForTag('happy')[1] is a struct");

allEmojis = emojiLib.getAll();
assert(isArray(allEmojis) && arrayLen(allEmojis) gt 100, "getAll() returns a large array");
assert(isStruct(allEmojis[1]), "getAll()[1] is a struct");

allTags = emojiLib.getAllTags();
assert(isArray(allTags) && arrayLen(allTags) gt 0, "getAllTags() returns a non-empty array");
assert(arrayFindNoCase(allTags, "happy") gt 0, "getAllTags() contains 'happy'");

assert(emojiLib.isEmoji("#cp(128512)#"), "isEmoji('grinning face') is true");
assert(!emojiLib.isEmoji("hi"), "isEmoji('hi') is false");

assert(emojiLib.containsEmoji("I #cp(10084)##chr(65039)# pizza"), "containsEmoji('I heart pizza') is true");
assert(!emojiLib.containsEmoji("hello world"), "containsEmoji('hello world') is false");

// emoji-java 5.1.1's isOnlyEmojis rejects strings with a trailing variation selector (chr(65039));
// use heart without VS in this assertion. The containsEmoji true case above keeps the VS because
// containsEmoji tolerates it.
assert(emojiLib.isOnlyEmojis("#cp(128065)##cp(10084)##cp(127829)#"), "isOnlyEmojis('eye heart pizza') is true");
assert(!emojiLib.isOnlyEmojis("I #cp(10084)##chr(65039)# pizza"), "isOnlyEmojis('I heart pizza') is false");

// --- EmojiParser methods ---

mixed = "I #cp(10084)##chr(65039)# #cp(127829)#";

aliasResult = emojiLib.parseToAliases(mixed);
assert(findNoCase(":pizza:", aliasResult) gt 0, "parseToAliases() converts pizza emoji to :pizza:");
assert(findNoCase(":heart:", aliasResult) gt 0, "parseToAliases() converts heart emoji to :heart:");

decResult = emojiLib.parseToHtmlDecimal("#cp(127829)#");
assert(findNoCase("&##127829;", decResult) gt 0, "parseToHtmlDecimal('pizza') contains &##127829;");

hexResult = emojiLib.parseToHtmlHexadecimal("#cp(127829)#");
assert(findNoCase("&##x1f355;", hexResult) gt 0, "parseToHtmlHexadecimal('pizza') contains &##x1f355;");

stripped = emojiLib.removeAllEmojis(mixed);
assert(findNoCase(cp(127829), stripped) eq 0, "removeAllEmojis() strips pizza");
assert(findNoCase(cp(10084), stripped) eq 0, "removeAllEmojis() strips heart");

keptPizza = emojiLib.removeAllEmojisExcept(mixed, ["pizza"]);
assert(findNoCase(cp(127829), keptPizza) gt 0, "removeAllEmojisExcept(['pizza']) keeps pizza");
assert(findNoCase(cp(10084), keptPizza) eq 0, "removeAllEmojisExcept(['pizza']) strips heart");

minusPizza = emojiLib.removeEmojis(mixed, "pizza");
assert(findNoCase(cp(127829), minusPizza) eq 0, "removeEmojis('pizza') strips pizza");
assert(findNoCase(cp(10084), minusPizza) gt 0, "removeEmojis('pizza') keeps heart");

// emoji-java 5.1.1's replaceAllEmojis strips U+2764 (heart) but leaves the trailing
// U+FE0F variation selector intact (same VS-16 quirk family as isOnlyEmojis).
replaced = emojiLib.replaceAllEmojis(mixed, "[e]");
assert(replaced eq "I [e]" & chr(65039) & " [e]", "replaceAllEmojis() replaces emojis but retains trailing VS-16");

extracted = emojiLib.extractEmojis(mixed);
assert(isArray(extracted) && arrayLen(extracted) eq 2, "extractEmojis() returns 2 elements");

extractedStruct = emojiLib.extractEmojis(mixed, true);
assert(isArray(extractedStruct) && arrayLen(extractedStruct) eq 2, "extractEmojis(_, true) returns 2 elements");
assert(isStruct(extractedStruct[1]) && structKeyExists(extractedStruct[1], "aliases"), "extractEmojis(_, true)[1] is a struct with 'aliases'");

// roundtrip: alias-form is idempotent
once = emojiLib.parseToAliases(mixed);
twice = emojiLib.parseToAliases(once);
assert(once eq twice, "parseToAliases() is idempotent on alias-form");

summarize();
</cfscript>
</body>
</html>
