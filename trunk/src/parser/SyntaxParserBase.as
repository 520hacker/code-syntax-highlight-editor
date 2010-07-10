package parser
{	
	import flash.text.*;
	
	public class SyntaxParserBase
	{
		protected var m_BaseIndex : uint = 0;
		private var m_Length : int = 0;
		protected var m_Editor : TextFieldBase;
				
		public function SyntaxParserBase(editor:TextFieldBase, baseIndex:uint, length:int)
		{
			m_Editor = editor;
			m_Length = length;
			m_BaseIndex = baseIndex;
		}
		
		public function process() : void{			
		}
		
		protected function getLength() : uint{
			return (m_Length < 0) ? m_Editor.text.length : m_Length;;
		}
		
		protected function getString() : String{
			return m_Editor.text.substr(m_BaseIndex, this.getLength());
		}
		
		protected function search(regex:RegExp) : Array{
			var beginIndex : int = 0;
			var endIndex : int = 0;
			var totalIndex : uint = 0;
			
			var textToSearch : String = this.getString();
			var array : Array = new Array();
			
			beginIndex = textToSearch.search(regex);
			while( beginIndex >= 0 && beginIndex < this.getLength()){
				totalIndex += beginIndex;
				textToSearch = textToSearch.substr(beginIndex);
				var results : Array = textToSearch.match(regex);
				if( results != null && results.length > 0){
					beginIndex = totalIndex;
					var len : uint = (results[0] as String).length;
					endIndex = beginIndex + len;
					array.push( { beginIndex:beginIndex, endIndex:endIndex} );
					
					textToSearch = textToSearch.substr(len);
					totalIndex += len;
				}
				else{
					throw new Error("search failed!");
				}
				beginIndex = textToSearch.search(regex);
			}
			return array;
		}
		
		protected function setColor( color:uint, beginIndex:int, endIndex:int) : void {
			if( beginIndex < 0 || endIndex < 0 )
				throw new Error("Invalid parameter. setColor");
			
			m_Editor.setTextColor( color, m_BaseIndex + beginIndex,m_BaseIndex + endIndex);
		}
		
	}
}