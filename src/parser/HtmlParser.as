package parser
{
	public class HtmlParser extends SyntaxParserBase
	{
		public function HtmlParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
		{
			super(editor, baseIndex, length);
		}
		
		public override function process() : void{
			var array:Array = null;
			var regex:RegExp = null;
			var beginIndex : int = 0;
			var endIndex : int = 0;
			var i : uint;
			var text : String = null;
			var attributes : String = null;
			
			super.setColor( 0x000000, 0, super.getLength());			
			
			// normal tags
			regex = /(\<[^!\%]*?\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;

				super.setColor( 0x0000FF, beginIndex, beginIndex+1);
				super.setColor( 0x0000FF, endIndex-1, endIndex);
				
				super.setColor( 0xFF0000, beginIndex+1, endIndex-1);
			}

		
			// atributes double quote
			regex = /\=(\".*?\")/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x0000FF, beginIndex, endIndex);
			}
			
			// atributes single quote
			regex = /\=(\'.*?\')/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x0000FF, beginIndex, endIndex);
			}
			
			// html comments <!-- -->
			regex = /(\<\!\-\-.*?\-\-\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x006600, beginIndex, endIndex);
			}
			
			// html doctype <!DOCTYPE >
			regex = /(\<\!\DOCTYPE.*?\>)/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x666666, beginIndex, endIndex);
			}
			
			// styles
			regex = /(\<(\s*)style.*?\<(\s*)\/(\s*)style(\s*)\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				text = super.m_Editor.text;
				beginIndex = text.indexOf('>', beginIndex) + 1;
				while( text.charAt(--endIndex) != '<' );
				
				attributes = text.substring(  array[i].beginIndex, beginIndex).toLowerCase();
				
				var cssParser : CssParser = new CssParser( super.m_Editor, beginIndex, endIndex-beginIndex);
				cssParser.process();
			}
			
			// scripts
			regex = /(\<(\s*)script.*?\<(\s*)\/(\s*)script(\s*)\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				text = super.getString();
				beginIndex = text.indexOf('>', beginIndex) + 1;
				while( text.charAt(--endIndex) != '<' );

				attributes = text.substring(  array[i].beginIndex, beginIndex).toLowerCase();
				
				var subParser : SyntaxParserBase = null;
				var regExp : RegExp = /\blanguage\=(?<quote>\"|\')(?<language>.*?)(\k<quote>)/smi;
				var results : Array = regExp.exec(attributes);
				if( results != null && results.length > 3 ){
					switch(results[2].toString().toLowerCase()){
						case "javascript":
						case "jscript":
							subParser = new JavascriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);
							break;
						case "vbscript":
							subParser = new VbscriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);
							break;
					}
				}
				
				
				if( subParser == null ){
					regExp = /\btype\=(?<quote>\"|\')(?<type>.*?)(\k<quote>)/smi;
					results = regExp.exec(attributes);
					if( results != null && results.length > 3 ){
						switch(results[2].toString().toLowerCase()){
							case "text/javascript":
							case "text/jscript":
								subParser = new JavascriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);
								break;
							case "text/vbscript":
								subParser = new VbscriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);
								break;
						}
					}
				}
				
				if( subParser == null ){
					subParser = new JavascriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);		
				}
				
				subParser.process();
			}
		}
	}
}