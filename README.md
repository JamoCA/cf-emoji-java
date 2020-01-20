# cf-emoji-java

_ColdFusion wrapper for [emoji-java](https://github.com/vdurmont/emoji-java) (a lightweight java library that helps you use Emojis in your java applications) to identify, sanitize and convert emojis for CFML projects._

## Installation

Download the JAR file directly from the emoji-java's [releases tab](https://github.com/vdurmont/emoji-java/releases) on GitHub. Add the JAR file to the global Java classpath, use [javaSettings](https://cfdocs.org/java) in application.cfc or use [JavaLoader](https://github.com/markmandel/JavaLoader).)


## Usage

Instantiate the component:

```js
emojijava = new emojijava();
```

## emojijava.getForAlias(alias);

Returns a structure containing data associated with the given alias.
```js
emojijava.getForAlias('smiley');
```

## emojijava.getForTag(tag);

Returns an array of structures containing data associated with the given tag.
```js
emojijava.getForTag('happy');
```


## emojijava.getAllTags();

Returns an array with all emoji tags.
```js
emojijava.getAllTags();
```

## emojijava.getAll();

Returns an array with all the emoji structs.
```js
emojijava.getAll();
```

## emojijava.isEmoji(text);

Returns true/false if a string is an emoji.
```js
emojijava.isEmoji('❤️');       // true
emojijava.isEmoji('I ❤️ 🍕');  // false
```

## emojijava.containsEmoji(text);

Returns true/false if a string contains any emoji.
```js
emojijava.containsEmoji('I ❤️ 🍕');  // true
```

## emojijava.isOnlyEmojis(text);

Returns true/false if the entire string is composed of only emojis.
```js
emojijava.isOnlyEmojis('I ❤️ 🍕');   // false
emojijava.isOnlyEmojis('👁 ❤️ 🍕');  // true
```

## emojijava.parseToAliases(text);

Replaces all the emoji's unicodes found in a string by their aliases.
```js
emojijava.parseToAliases('I like 🍕');   // I like :pizza:
```

## emojijava.parseToHtmlDecimal(text);

Replace all the emoji's unicodes found in a string by their HTML decimal representation.
```js
emojijava.parseToHtmlDecimal('I ❤️ 🍕');   // I &#10084;️ &#127829;
```

## emojijava.parseToHtmlHexadecimal(text);

Replaces all the emoji's unicodes found in a string by their HTML hex representation.
```js
emojijava.parseToHtmlHexadecimal('I ❤️ 🍕');   // I &#x2764;️ &#x1f355;
```

## emojijava.removeAllEmojis(text);

Returns a string with all emojis removed.
```js
emojijava.removeAllEmojis('I ❤️ 🍕');   // I
```

## emojijava.removeAllEmojisExcept(text, emojisToKeep);

Removes all emojis from the String, except the ones in the `emojisToKeep` (list or array). Use 'alias'.
```js
emojijava.removeAllEmojisExcept('I ❤️ 🍕', "pizza");   // I  🍕
```

## emojijava.removeEmojis(text, emojisToRemove);

Removes emojis listed in the `emojisToRemove` parameter (list or array) from the string. Use 'alias'.
```js
emojijava.removeEmojis(text, "pizza");  // I ❤️
```

## emojijava.replaceAllEmojis(text, replacementText)

Replaces all emojis with text string with the replacementText string.
```js
emojijava.removeEmojis('I ❤️ 🍕', "[emoji]");  // I [emoji] [emoji]
```

## emojijava.extractEmojis(text, _returnAsStruct_);

Returns an array or array of structures of emoji data identified from the string.
```js
emojijava.extractEmojis('I ❤️ 🍕');  // I ["❤️", "🍕"]
emojijava.extractEmojis('I ❤️ 🍕', true);  // an array of structs w/emoji data
```

## Acknowledgements

cf-emoji-java uses the java library provided by the [github/vdurmont/emoji-java](https://github.com/vdurmont/emoji-java) project.
