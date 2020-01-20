component
	displayname="emojiJava"
	output = false
	hint = "I abstract functions for emoji-java, a lightweight java library that helps you use Emojis in your java applications."
	accessors=false {

	/*
		* Version 1.0 - January 16, 2020
		* Blog Entry:
		* Java Library: https://github.com/vdurmont/emoji-java (by Vincent Durmont)
		* Emoji Alias List: https://github.com/vdurmont/emoji-java/blob/master/EMOJIS.md
		* CFC:
	*/

	public component function init() output=false hint="initialize emoji-java library" {
		variables.EmojiParser = createObject( "java", "com.vdurmont.emoji.EmojiParser");
		variables.EmojiManager = createObject( "java", "com.vdurmont.emoji.EmojiManager");
		return this;
	}

	private any function makeEmojiCollection(required any source=[]) output=false hint="convert array of aliases to emoji arrayList" {
		var aliasList = CreateObject("java", "java.util.ArrayList").Init();
		var thisAlias = "";
		if (isSimpleValue(arguments.source) ){
			arguments.source = listtoArray(arguments.source);
		}
		if (NOT isArray(arguments.source) ){
			arguments.source = [];
		}
		for (thisAlias in arguments.source) {
			aliasList.add(variables.EmojiManager.getForAlias( trim(javacast("string", thisAlias))));
		}
		return aliasList;
	}

	/* EmojiManager */
	public array function getForTag(required string tag) output=false hint="Returns an array of structures containing data associated with the given tag." {
		var result = variables.EmojiManager.getForTag( arguments.tag );
		var iterator = result.iterator();
		var tempResult = [];
		while(iterator.hasNext()){
			arrayAppend(tempResult, deserializeJson(SerializeJSON(iterator.next())));
		}
		return tempResult;
	}

	public struct function getForAlias( required string alias) output=false hint="Returns a structure containing data associated with the given alias." {
		var result = variables.EmojiManager.getForAlias( arguments.alias );
		return deserializeJson(SerializeJSON(result));
	}

	public array function getAll() output=false hint="Returns an array with all the emoji structs." {
		result = variables.EmojiManager.getAll();
		var iterator = result.iterator();
		var tempResult = [];
		while(iterator.hasNext()){
			arrayAppend(tempResult, deserializeJson(SerializeJSON(iterator.next())));
		}
		return tempResult;
	}

	public boolean function isEmoji( required string text ) output=false hint="Returns true/false if a string is an emoji." {
		return javacast("boolean", variables.EmojiManager.isEmoji( arguments.text ));
	}

	public boolean function containsEmoji( required string text ) output=false hint="Returns true/false if a string contains any emoji." {
		return javacast("boolean", variables.EmojiManager.containsEmoji( arguments.text ));
	}

	public array function getAllTags() output=false hint="Returns an array with all emoji tags." {
		var result = variables.EmojiManager.getAllTags();
		var iterator = result.iterator();
		var tempResult = [];
		while(iterator.hasNext()){
			arrayAppend(tempResult, iterator.next());
		}
		arraySort(tempResult, "textnocase");
		return tempResult;
	}

	public boolean function isOnlyEmojis( required string text ) output=false hint="Returns true/false if the entire string is composed of only emojis." {
		return javacast("boolean", variables.EmojiManager.isOnlyEmojis( arguments.text ));
	}

	/* EmojiParser */
	public string function parseToAliases( required string text ) output=false html="Replaces all the emoji's unicodes found in a string by their aliases." {
		return variables.EmojiParser.parseToAliases( arguments.text);
	}

	public string function parseToHtmlDecimal( required string text ) output=false hint="Replace all the emoji's unicodes found in a string by their HTML decimal representation." {
		return variables.EmojiParser.parseToHtmlDecimal( arguments.text ).toString();
	}

	public string function parseToHtmlHexadecimal( required string text ) output=false  hint="Replaces all the emoji's unicodes found in a string by their HTML hex representation."{
		return variables.EmojiParser.parseToHtmlHexadecimal( arguments.text );
	}

	public string function removeAllEmojis( required string text ) output=false hint="Returns a string with all emojis removed." {
		return variables.EmojiParser.removeAllEmojis( arguments.text );
	}

	public string function removeAllEmojisExcept( required string text, any emojisToKeep=[]) output=false hint="Removes all emojis from the String, except the ones in the 'emojisToKeep' (list or array). Use 'alias'." {
		return variables.EmojiParser.removeAllEmojisExcept( arguments.text, makeEmojiCollection(arguments.emojisToKeep) );
	}

	public string function removeEmojis( required string text, any emojisToRemove=[] ) output=false hint="Removes emojis listed in the 'emojisToRemove' parameter (list or array) from the string. Use 'alias'." {
		return variables.EmojiParser.removeEmojis( arguments.text, makeEmojiCollection(emojisToRemove) );
	}

	public string function replaceAllEmojis( required string text, required string replacementText) output=false hint="Replaces all emojis with text string with the replacementText string." {
		return variables.EmojiParser.replaceAllEmojis( arguments.text, arguments.replacementText);
	}

	public array function extractEmojis( required string text, boolean returnAsStruct=false) output=false hint="Returns an array or array of structures of emoji data identified from the string." {
		var result = variables.EmojiParser.extractEmojis( arguments.text );
		var iterator = result.iterator();
		var tempResult = [];
		var currentEmoji = "";
		while(iterator.hasNext()){
			currentEmoji = iterator.next();
			if (isEmoji(currentEmoji)){
				if (returnAsStruct){
					arrayAppend(tempResult, getForAlias(parseToAliases(currentEmoji)));
				} else {
					arrayAppend(tempResult, currentEmoji);
				}
			}
		}
		return tempResult;
	}

}
