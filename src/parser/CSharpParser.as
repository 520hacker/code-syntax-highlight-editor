package parser
{
	public class CSharpParser extends SyntaxParserBase
	{
		public function CSharpParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
		{
			super(editor, baseIndex, length);
		}
		
		public override function process() : void{
			var array:Array = null;
			var regex:RegExp = null;
			var beginIndex : int = 0;
			var endIndex : int = 0;
			var i : uint;
			
			super.setColor( 0x000000, 0, super.getLength());


			// strings double quote
			regex = /\"([^\r|\n]*?)([^\\]\")/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
			
			// strings single quote
			regex = /(\'(\\?)[^\r|\n]\')/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
			
			// strings @"???"
			regex = /\@\"(""|[^"])*\"/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
			
			// keywords
			regex = /\b(var|dynamic|into|group|let|join|ascending|descending|from|where|select|orderby|abstract|as|base|break|case|catch|checked|continue|default|delegate|do|else|event|explicit|extern|false|finally|fixed|foreach|get|goto|if|implicit|in|interface|internal|is|lock|namespace|new|null|object|operator|out|override|params|partial|private|protected|public|readonly|ref|return|set|sealed|sizeof|static|stackalloc|switch|this|throw|true|try|typeof|unchecked|unsafe|using|virtual|while|bool|byte|char|class|double|float|int|interface|long|string|struct|void)\b/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x0033FF, beginIndex, endIndex);
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
			
		}
	}
}