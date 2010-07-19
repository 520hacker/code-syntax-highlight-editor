package parser
{
	public class CppParser extends SyntaxParserBase
	{
		public function CppParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
			regex = /\b(cin|endl|INT_MIN|iomanip|main|npos|std|cout|pragma|include|INT_MAX|iostream|MAX_RAND|NULL|string|auto|const|double|float|int|short|struct|unsigned|break|continue|else|for|long|signed|switch|void|case|default|enum|goto|register|sizeof|typedef|volatile|char|do|extern|if|return|static|union|while|asm|dynamic_cast|namespace|reinterpret_cast|try|bool|explicit|new|static_cast|typeid|catch|false|operator|template|typename|class|friend|private|this|using|const_cast|inline|public|throw|virtual|delete|mutable|protected|true|wchar_t)\b/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x0000FF, beginIndex, endIndex);
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