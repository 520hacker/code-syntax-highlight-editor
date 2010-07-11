package 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import mx.controls.Image;
	
	public class LineNumberIndicator extends Sprite
	{
		[Bindable]
		[Embed(source="bg.png")]
		private var BACKGROUND_IMAGE : Class;
		private var m_BgImgBmp : BitmapData;
		
		[Bindable]
		[Embed(source="numbers.png")]
		private var NUMBERS_IMAGE : Class;
		private var m_NumImgBmp : BitmapData;
		
		private var m_GetSizeFunction : Function = null;

		
		private var m_TextField : TextFieldEx = null;
		private var m_LineNumbers : int = 0;
		private var m_TimerID : int = 0;
		
		public function LineNumberIndicator(textField:TextFieldEx, getSizeFun : Function)
		{
			super();
			
			m_GetSizeFunction = getSizeFun;
			m_BgImgBmp = new BACKGROUND_IMAGE().bitmapData;
			m_NumImgBmp = new NUMBERS_IMAGE().bitmapData;
			m_TextField = textField;			
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
			m_TextField.addEventListener( Event.SCROLL, this.onTextScroll);
		}
		
		public function refresh() : void{
			var size : Object = m_GetSizeFunction();
			this.graphics.clear();
			this.graphics.beginBitmapFill(m_BgImgBmp);
			this.graphics.drawRect(0,0,size.width,size.height);
			this.graphics.endFill();
			
			var index : int = 0;
			var pageSize : int = Math.ceil( m_TextField.height / (1.0 * m_TextField.getLineHeight()) );
			for( var line : uint = m_TextField.scrollV; line <= (m_TextField.scrollV + pageSize); line++){			
				this.drawNumber( line, 35, m_TextField.getLineHeight() * index + 7);
				index ++;
			}
		}
		
		private function onAddToStage(evt:Event) : void{
		}
		
		private function drawNumber(num:uint, xPos:int, yPos:int) : void{
			var digitWidth : int = m_NumImgBmp.width / 10;
			var xOffset : int = xPos - digitWidth;
			var text : String = num.toString(10);
			for( var i : int = text.length-1; i >= 0; i--){
				var digit : uint = parseInt(text.charAt(i));
				
				this.graphics.beginBitmapFill(m_NumImgBmp, new Matrix( 1, 0, 0, 1, -1*digit*digitWidth + xOffset, yPos));
				this.graphics.drawRect( xOffset, yPos, digitWidth, m_NumImgBmp.height);
				this.graphics.endFill();
				xOffset -= digitWidth;
			}
		}
		
		private function onTextScroll(evt:Event) : void{
			if( m_TimerID != 0 ) clearTimeout(m_TimerID);
			m_TimerID = setTimeout( this.refresh, 10);
		}
		

	}
}