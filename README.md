# cf-emoji-java

A ColdFusion wrapper around the [emoji-java](https://github.com/vdurmont/emoji-java) Java library. Detect, strip, replace, and convert emojis from CFML without dealing with the Java API directly.

## Why this exists

Emojis are surprisingly hard. They're variable-width, sometimes multi-codepoint, sometimes joined by zero-width joiners, sometimes modified by skin-tone selectors. CFML's string functions don't really know any of that. emoji-java handles the messy parts and exposes a clean API for the things you actually want to do: detect, strip, replace, list, and convert between unicode and shortcode forms.

This CFC is a thin wrapper. It does not add features beyond what emoji-java provides; it just makes the Java API ergonomic to call from CFML.

## A note on emoji-java

emoji-java is no longer actively maintained. Version 5.1.1, bundled in `lib/`, is the last public release. It works for the emoji set it knows about (Unicode 11.0, circa 2018), but newer additions like fortune cookies, ninjas, and the wider 2020+ glyphs aren't in its data file. If you need bleeding-edge emoji coverage, you'll want a different library.

For the common cases (sanitizing user input, generating shortcode output for storage, stripping emojis before writing to a non-UTF-8 column, counting visible characters), 5.1.1 is fine.

## Installation

### Manual

Grab `emoji-java-5.1.1.jar` from emoji-java's [releases](https://github.com/vdurmont/emoji-java/releases). Then either:

- Drop the JAR into a folder loaded via `this.javaSettings.loadPaths` in your `Application.cfc`. This is what the bundled `Application.cfc` does - it points at the local `lib/` folder.
- Add the JAR to the global Java classpath.
- Load it dynamically with [JavaLoader](https://github.com/markmandel/JavaLoader).

The first option is simplest for application-scoped deployments and is the path the demo and tests in this repo assume.

## Running the demo

Visit `/demo.cfm`. The demo exercises every public method with preset inputs covering simple cases plus the awkward ones (ZWJ family sequences, skin-tone modifiers, mixed unicode, plain text).

## Running tests

Visit `/tests/test_emojiJava.cfm`. The runner is plain CFML; no TestBox or MXUnit needed. Each assertion prints a green check or red X, and the page returns HTTP 500 if any assertion fails, so it works with `curl` and CI:

## Usage

Instantiate once:

```js
emojijava = new emojijava();
```

The constructor creates Java references to `EmojiManager` and `EmojiParser` and stores them in the variables scope. It's safe to cache the instance in `application` scope; emoji-java is thread-safe for read operations and the wrapper performs no per-call mutation.

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
emojijava.replaceAllEmojis('I ❤️ 🍕', "[emoji]");  // I [emoji] [emoji]
```

## emojijava.extractEmojis(text, _returnAsStruct_);

Returns an array or array of structures of emoji data identified from the string.
```js
emojijava.extractEmojis('I ❤️ 🍕');  // I ["❤️", "🍕"]
emojijava.extractEmojis('I ❤️ 🍕', true);  // an array of structs w/emoji data
```

## A few things worth knowing

- `len(text)` returns UTF-16 code units, not codepoints. Most emojis are surrogate pairs, so `len("🍕")` is 2. If you want codepoints, call `text.codePointCount(0, len(text))`. For an approximate visible/grapheme count, do `len(replaceAllEmojis(text, "X"))`.
- `parseToAliases` is idempotent on its own output. Running it twice produces the same string as running it once.
- `extractEmojis(text, true)` re-runs the alias parser internally to look up each match, which is fine for small inputs but pays for itself if you're calling it in a tight loop. For bulk work, prefer `extractEmojis(text)` and look up structs only when you need them.
- Skin-tone modifiers (Fitzpatrick scale) are returned as separate emojis from their base in 5.1.1. `extractEmojis("👍🏽")` returns `["👍", "🏽"]`. Same goes for ZWJ-joined family sequences; they decompose. If you need grouped extraction, do it yourself by walking the byte offsets.
- Caching `emojijava.getAll()` in `application` scope is worth doing if your app calls it more than once per request. The underlying data is static for the life of the JVM, and the deserialization is the slow part of the call.

## Romanization (optional)

The demo includes an optional romanization section using [AnyAscii](https://github.com/anyascii/anyascii). To enable it, drop the AnyAscii Java JAR into `lib/` and create a small `AnyAscii.cfc` wrapper exposing a `transliterate(text)` method. This project does not bundle the JAR - AnyAscii's data table is significantly larger than emoji-java itself, and most users of this library don't need romanization, so it's left as a soft dependency.

If you do enable it, the demo block will start working automatically. There's nothing else to wire up.

## License

MIT. See `LICENSE`.

## Acknowledgements

Built around the Java library at [github/vdurmont/emoji-java](https://github.com/vdurmont/emoji-java) by Vincent Durmont. The optional romanization integration is built around [AnyAscii](https://github.com/anyascii/anyascii).
