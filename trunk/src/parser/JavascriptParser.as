package parser
{
	public class JavascriptParser extends SyntaxParserBase
	{
		public function JavascriptParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
		{
			super(editor, baseIndex, length);
		}
		
		public override function process() : void{
			var array:Array = null;
			var regex:RegExp = null;
			var beginIndex : int = 0;
			var endIndex : int = 0;
			var i : uint;
			
			super.setColor( 0x000000, beginIndex, super.getLength());
			
			// strings double quote
			regex = /\"([^\r|\n]*?)([^\\]\")/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
			
			// strings single quote
			regex = /\'([^\r|\n]*?)([^\\]\')/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
			
			// keywords
			regex = /\b(delete|alert|window|confirm|document|break|continue|do|for|new|this|void|case|default|else|function|return|typeof|while|if|label|switch|var|with|catch|Array|Object|String|try|false|throws|null|true|goto|self|top|parent|setTimeout|undefined|opener)\b/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x0033FF, beginIndex, endIndex);
			}
			
			// comments //
			regex = /\/\/([^\r|\n]*)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x008000, beginIndex, endIndex);
			}
			
			// comments /* */
			regex = /\/\*(.*?)\*\//sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x008000, beginIndex, endIndex);
			}
			
			// <![CDATA[  ]]>
			regex = /(\<\!\[CDATA\[)|(\]\]\>)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x666666, beginIndex, endIndex);
			}
		}
	}
}