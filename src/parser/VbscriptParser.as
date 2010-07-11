package parser
{
	public class VbscriptParser extends SyntaxParserBase
	{
		public function VbscriptParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
					
			// keywords
			regex = /\b(And|As|ByRef|ByVal|Call|Case|Class|Const|Dim|Do|Each|Else|ElseIf|Empty|End|Eqv|Exit|False|For|Function|Get|GoTo|If|Imp|In|Is|Let|Loop|Me|Mod|Enum|New|Next|Not|Nothing|Null|On|Option|Or|Private|Public|ReDim|Rem|Resume|Select|Set|Stop|Sub|Then|To|True|Until|Wend|While|With|Xor|Execute|Randomize|Erase|ExecuteGlobal|Explicit|step)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x4040FF, beginIndex, endIndex);
			}
			
			// comments
			regex = /\'(.*?)(\'|\r)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x008000, beginIndex, endIndex);
			}
			
			// strings double quote
			regex = /\"(.*?)(\"|\r)/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
		}
	}
}