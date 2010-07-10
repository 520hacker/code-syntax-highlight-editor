import flash.events.Event;
import flash.events.TextEvent;
import flash.text.TextField;

import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.events.ScrollEvent;

import parser.*;

private var m_TextField : TextFieldEx = new TextFieldEx();
private var m_LineNumberIndicator : LineNumberIndicator = null;

private function creationCompleteHandler(event:FlexEvent):void
{
	wrapper.addChild(m_TextField);
	m_LineNumberIndicator = new LineNumberIndicator(m_TextField, this.getLineNumberIndicatorSize);
	line_wrapper.addChild(m_LineNumberIndicator);
	m_LineNumberIndicator.x = 0;
	m_LineNumberIndicator.y = 0;
	m_TextField.lineNumberIndicator = m_LineNumberIndicator;
	
		
	m_TextField.addEventListener(Event.CHANGE, this.onTextChange);
	m_TextField.addEventListener(Event.SCROLL, this.onTextChange);
	onTextChange(null);
}

private function onAddToStage(evt:Event) : void{
	m_LineNumberIndicator.refresh();
}

private function getLineNumberIndicatorSize() : Object{
	return { width: line_wrapper.width, height: line_wrapper.height };
}


private function resizeHandler(event:ResizeEvent):void
{
	m_TextField.x = 0;
	m_TextField.y = 0;
	m_TextField.width = wrapper.width; 
	m_TextField.height = wrapper.height;
	onTextChange(null);
}

private function onTextChange(evt:Event) : void{
	ctlVScrollBar.maxScrollPosition = m_TextField.maxScrollV - 1;
	ctlVScrollBar.pageSize = m_TextField.bottomScrollV - (m_TextField.scrollV - 1);
	ctlVScrollBar.scrollPosition = m_TextField.scrollV-1;
	ctlVScrollBar.lineScrollSize = 1;
	
	if( m_TextField.textWidth > m_TextField.width - 10 ){
		ctlHScrollBar.enabled = true;
		ctlHScrollBar.maxScrollPosition = m_TextField.maxScrollH;
		ctlHScrollBar.scrollPosition = m_TextField.scrollH;
		ctlHScrollBar.pageSize = m_TextField.width;
	}
	else
		ctlHScrollBar.enabled = false;
}

private function ctlVScrollBar_scrollHandler(evt:ScrollEvent):void {
	m_TextField.scrollV = evt.position + 1;
}

private function ctlHScrollBar_scrollHandler(evt:ScrollEvent):void {
	m_TextField.scrollH = evt.position;
}

