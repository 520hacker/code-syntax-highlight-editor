package 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.text.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.events.FlexEvent;
	
	import parser.*;
		
	public class TextFieldEx extends TextFieldBase
	{
		private var m_LineNumberIndicator : LineNumberIndicator = null;
		private var m_TimerID : int = 0;
		private var m_TextFormat : TextFormat = null;
		private var m_LineHeight : int = 0;
		private var m_Parser : SyntaxParserBase = null;
		private var m_PreferredFonts : String = "|Fixedsys|Fixedsys Excelsior 3.01|Fixedsys Excelsior 3.00|Courier New|Courier|";
		
		private const INSERTED_TAB_STR : String = "    ";
		
		public function set lineNumberIndicator(indicator:LineNumberIndicator) : void{
			m_LineNumberIndicator = indicator;
		}
		
		public function getLineHeight() : int{
			return m_LineHeight;
		}
		
		
		public function setParser(lang:String) : Boolean{
			if( lang == null ) return false;
			switch(lang.toLowerCase()){
				case "aspx": 
					m_Parser = new AspxParser(this); 
					break;
				case "csharp": 
					m_Parser = new CSharpParser(this); 
					break;
				case "css": 
					m_Parser = new CssParser(this); 
					break;
				case "javascript": 
					m_Parser = new JavascriptParser(this); 
					break;
				case "vbscript":
					m_Parser = new VbscriptParser(this); 
					break;
				case "html":
					m_Parser = new HtmlParser(this); 
					break;
				case "xml":
					m_Parser = new XmlParser(this); 
					break;
				case "php":
					m_Parser = new PhpParser(this); 
					break;
				default:
					return false;
			}
			this.parse();
			return true;
		}
		public function setReadOnly(readOnly:Boolean) : void{
			this.type = readOnly ? TextFieldType.DYNAMIC : TextFieldType.INPUT;
		}
		public function setText(text:String) : void{
			this.text = text.replace( /\r/gm, "");
			this.parse();
		}
		public function getText() : String{
			return this.text;
		}
		
		public function TextFieldEx()
		{
			super();

			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
			
			this.alwaysShowSelection = true;
			this.antiAliasType = AntiAliasType.NORMAL;
			this.background = true;
			this.backgroundColor = 0xFFFFFF;
			this.border = false;
			this.multiline = true;
			this.selectable = true;
			this.wordWrap = false;
			this.type = TextFieldType.INPUT;
		}
		
		private function onAddToStage(evt:Event) : void{
			 
			this.addEventListener(TextEvent.TEXT_INPUT, this.onTextInput);
			this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
					
			///////////////////////////////
			
			if(  this.loaderInfo.parameters["preferredFonts"] != null )
				m_PreferredFonts = this.loaderInfo.parameters["preferredFonts"];
			var fontName : String = this.getFontName();
			var textFormat : TextFormat = new TextFormat( this.getFontName(), 16, 0x000000	);
			m_TextFormat = new TextFormat( this.getFontName(), 16, 0x000000	);
			this.defaultTextFormat = textFormat;
			{
				// detect the line-height, stupid way; getLineMetrics is untrusted
				this.text = "\n.........................";
				this.setSelection( 0, this.text.length);
				
				var bmp : BitmapData = new BitmapData( this.width, this.height, false, 0xFFFFFF);
				bmp.draw(this);
				var lineHeight : int = 0;
				for( var y : uint = 0; y < bmp.height; y++){
					var color : uint = bmp.getPixel( 5, y);
					if( lineHeight > 0 && color == 0xFFFFFF && bmp.getPixel( 6, y+1) == 0xFFFFFF && bmp.getPixel( 6, y+2) == 0xFFFFFF)
						break;
					if( lineHeight > 0 || color != 0xFFFFFF )
						lineHeight ++;
				}
				bmp.dispose();
				
				this.text = "";
				m_LineHeight = lineHeight;
			}	
			
			//////////////////////////////////////////////////////
			
			ExternalInterface.addCallback( "setReadOnly", this.setReadOnly);
			ExternalInterface.addCallback( "setText", this.setText);
			ExternalInterface.addCallback( "getText", this.getText);
			ExternalInterface.addCallback( "setParser", this.setParser);
			
			
			////////////////////////////////////////////////////
			this.setReadOnly( this.loaderInfo.parameters["readOnly"] == "true" );

			this.setParser( this.loaderInfo.parameters["parser"] );	
			
			var onload : * = this.loaderInfo.parameters["onload"];
			ExternalInterface.call( onload );
			
			m_LineNumberIndicator.refresh();
			
		}
		 
		private function getFontName() : String {
			var fonts : Array = Font.enumerateFonts(true);
			
			var preferredFonts : String = m_PreferredFonts;
			var fontName : String = "";
			for( var i : uint = 0; i < fonts.length; i++){
				var textToSearch : String = "|" + fonts[i].fontName + "|";
				var index : int = preferredFonts.indexOf(textToSearch);
				if( index < 0 )
					continue;
				else if( index == 0 )
					return fonts[i].fontName;
				
				fontName = fonts[i].fontName;
				preferredFonts = preferredFonts.substr( 0, index+1);
			}
			
			return fontName;
		}
		
		public override function setTextColor(color:uint, beginIndex:int, endIndex:int) : void{
			if( beginIndex == 0 && endIndex == 0 )
				return;
			m_TextFormat.color = color;
			this.setTextFormat( m_TextFormat, beginIndex, endIndex);
		}
		
		private function onTextInput(evt:TextEvent) : void{
			if( m_TimerID != 0 )
				clearTimeout(m_TimerID);
			m_TimerID = setTimeout( this.parse, 1000);
		}
			
		private function parse() : void{
			if( m_Parser != null )
				m_Parser.process();
		}
		
		private function onKeyDown(evt:KeyboardEvent) : void{
			if( evt.ctrlKey || this.type != TextFieldType.INPUT ) return;
			if( evt.keyCode == 9 ){
				evt.preventDefault();
				this.onTabKeyDown(evt.shiftKey);
			}			
		}
		
		private function onTabKeyDown(shiftKey:Boolean) : void{
			var startLine : int = this.getLineIndexOfChar(this.selectionBeginIndex);
			var endLine : int = this.getLineIndexOfChar(this.selectionEndIndex);
			if( startLine == endLine){
				if( !shiftKey ){
					this.replaceText( this.selectionBeginIndex, this.selectionEndIndex, INSERTED_TAB_STR);
					this.setSelection( this.selectionBeginIndex + INSERTED_TAB_STR.length, this.selectionBeginIndex + INSERTED_TAB_STR.length);
				}
			}
			else{
				if( !shiftKey ){
					for( var line : uint = startLine; line <= endLine; line++){
						var charIndex : int = this.getLineOffset(line);
						this.replaceText( charIndex, charIndex, INSERTED_TAB_STR);
					} 
					this.setSelection( this.selectionBeginIndex, this.selectionEndIndex + (endLine-startLine+1)*INSERTED_TAB_STR.length);
				}
			}
		}
	}
	
	
}