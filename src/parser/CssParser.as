package parser
{
	public class CssParser extends SyntaxParserBase
	{
		public function CssParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
			
			// tags, ids, classes, values
			regex = /(.*?)\{(.*?)\}/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0xFF00FF, beginIndex, endIndex);
			}
			
			// keys
			regex = /([\w-]*?)\:(.*?)\r/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				var text : String = super.getString();
				super.setColor( 0x000000, beginIndex, endIndex);
				
				while( text.charAt(beginIndex++) != ':' );
				var newEndIndex : uint = beginIndex;
				while( text.charAt(++newEndIndex) != ';' && newEndIndex < endIndex );
				super.setColor( 0x0000FF, beginIndex, newEndIndex);
			}
			
		
			// comments /* */
			regex = /\/\*(.*?)\*\//sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x008000, beginIndex, endIndex);
			}
		}
	}
}