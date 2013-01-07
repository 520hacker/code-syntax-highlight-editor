package parser
{
	public class Custom1Parser extends SyntaxParserBase
	{
		public function Custom1Parser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
			regex = /\<(\s?)((\w|\/)+\s.*?([^\%]>))|(\<(\s?)(\w|\/)+([^\%]>))/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;

				super.setColor( 0x000084, beginIndex, endIndex);
			}
			
			// atributes double quote
			regex = /\=(\"[^\r|\n|\"]*\")/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x0000FF, beginIndex, endIndex);
			}
			
			// atributes single quote
			regex = /\=(\'[^\r|\n|\']*\')/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x5255FF, beginIndex, endIndex);
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
						case "vb":
							subParser = new VbNetParser( super.m_Editor, beginIndex, endIndex-beginIndex);
							break;
						case "c#":
							subParser = new CSharpParser( super.m_Editor, beginIndex, endIndex-beginIndex);
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
							case "text/c#":
								subParser = new CSharpParser( super.m_Editor, beginIndex, endIndex-beginIndex);
								break;
							case "text/vb":
								subParser = new VbNetParser( super.m_Editor, beginIndex, endIndex-beginIndex);
								break;
							case "text/vbscript":
								subParser = new VbscriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);
								break;
						}
					}
				}
				
				if( subParser == null ){
					regExp = /\brunat\=\"server\"/smi;
					if( regExp.test(attributes) ){
						subParser = new CSharpParser( super.m_Editor, beginIndex, endIndex-beginIndex);
					}
					else{
						subParser = new JavascriptParser( super.m_Editor, beginIndex, endIndex-beginIndex);
					}					
				}
				
				subParser.process();
			}
					
			

			// html comments <!-- -->
			regex = /(\<\!\-\-.*?\-\-\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x666666, beginIndex, endIndex);
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

			// tag <# #> <#= #>
			regex = /(\<\#(.*?)\#\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
								
				super.setColor( 0xFF0000, beginIndex, endIndex);
				
				text = super.getString();
				var code : String = text.substring(beginIndex, endIndex);
				if( code.search( /^\<\#(\=)/s ) == 0 )
					beginIndex = beginIndex+3;
				else
					beginIndex = beginIndex+2;
				while( text.charAt(--endIndex) != '#' );
				
				new JavascriptParser( super.m_Editor, beginIndex, endIndex-beginIndex).process();
			}
			
			// html [metadata:value ]
			regex = /(\[(\s*)metadata(\s*)\:(\s*)(((htmlencode)|(scriptencode)|(value)))(\s*)\((\s*)((\w|\/|\-|\_|\.)+)(\s*)\)(\s*)\])/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0xFF00FF, beginIndex, endIndex);
			}
			

		}
	}
}