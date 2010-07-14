package parser
{
	public class PhpParser extends SyntaxParserBase
	{
		public function PhpParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
			regex = /(\<[^\!\%].*?([^\%]>))/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				
				super.setColor( 0x000084, beginIndex, endIndex);
			}
			
			// atributes double quote
			regex = /\=(\s*)(\".*?\")/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x5255FF, beginIndex, endIndex);
			}
			
			// atributes single quote
			regex = /\=(\s*)(\'.*?\')/sm;
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
				super.setColor( 0x848284, beginIndex, endIndex);
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
				
				super.setColor( 0x900090, beginIndex, endIndex);
				
				text = super.getString();
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
				
				super.setColor( 0x840000, beginIndex, endIndex);
				
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
			
			
			// server tag <? ?>
			regex = /(\<\?(.*?)\?\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;				
				
				super.setColor( 0xFF0000, beginIndex, endIndex);
				
				text = super.getString();
				var code : String = text.substring(beginIndex, endIndex);
				
				while( text.charAt(--endIndex) != '?' );
				var r : Array = code.match(/^\<\?(\s*)php(\s*)/s);
				if( r != null && r.length > 0 )
					beginIndex += r[0].toString().length;
				else{
					r = code.match(/^\<\?(\s*)=(\s*)/s);
					if( r != null && r.length > 0 ){
						beginIndex += r[0].toString().length;
					}
					else{
						beginIndex += 2;
					}
				}
				
				code = text.substring(  beginIndex, endIndex).toLowerCase();	
				(new PhpCodeParser( super.m_Editor, beginIndex, endIndex-beginIndex)).process();
			}
			
			
		
		}
	}
}