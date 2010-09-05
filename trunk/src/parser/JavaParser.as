package parser
{
	public class JavaParser extends SyntaxParserBase
	{
		public function JavaParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
				super.setColor( 0x2A00FF, beginIndex, endIndex);
			}
			
			// strings single quote
			regex = /(\'(\\?)[^\r|\n]\')/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x2A00FF, beginIndex, endIndex);
			}
			
			// keywords
			regex = /\b(abstract|continue|for|new|switch|assert|default|goto|package|synchronized|boolean|do|if|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while)\b/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x7F0055, beginIndex, endIndex);
			}
			
			// comments //
			regex = /\/\/([^\r|\n]*)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x3F7F5F, beginIndex, endIndex);
			}
			
			// comments /* */
			regex = /\/\*(.*?)\*\//sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x3F7F5F, beginIndex, endIndex);
			}
		}
	}
}