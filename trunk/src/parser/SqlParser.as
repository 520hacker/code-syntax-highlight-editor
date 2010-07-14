package parser
{
	public class SqlParser extends SyntaxParserBase
	{
		public function SqlParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
			
			// single quote
			regex = /(\'.*?\')/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x5555FF, beginIndex, endIndex);
			}

			// reserved words
			regex = /\b(add|after|aggregate|alias|all|and|as|authorization|between|by|cascade|cache|cache|called|case|check|column|comment|constraint|createdb|createuser|cycle|database|default|deferrable|deferred|diagnostics|distinct|domain|each|else|elseif|elsif|encrypted|except|exception|for|foreign|from|from|full|function|get|group|having|if|immediate|immutable|in|increment|initially|increment|index|inherits|inner|input|intersect|into|invoker|is|join|key|language|left|like|limit|local|loop|match|maxvalue|minvalue|natural|nextval|no|nocreatedb|nocreateuser|not|null|of|offset|oids|on|only|operator|or|order|outer|owner|partial|password|perform|plpgsql|primary|record|references|replace|restrict|return|returns|right|row|rule|schema|security|sequence|session|sql|stable|statistics|table|temp|temporary|then|time|to|transaction|trigger|type|unencrypted|union|unique|user|using|valid|value|values|view|volatile|when|where|with|without|zone)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				
				super.setColor( 0x0000FF, beginIndex, endIndex);
			}
			
			// types
			regex = /\b(bigint|bigserial|bit|boolean|box|bytea|char|character|cidr|circle|date|decimal|double|float4|float8|inet|int2|int4|int8|integer|interval|line|lseg|macaddr|money|numeric|oid|path|point|polygon|precision|real|refcursor|serial|serial4|serial8|smallint|text|timestamp|varbit|varchar)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				
				super.setColor( 0x00008C, beginIndex, endIndex);
			}
			
			// commands
			regex = /\b(abort|alter|analyze|begin|checkpoint|close|cluster|comment|commit|copy|create|deallocate|declare|delete|drop|end|execute|explain|fetch|grant|insert|listen|load|lock|move|notify|prepare|reindex|reset|restart|revoke|rollback|select|set|show|start|truncate|unlisten|update)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				
				super.setColor( 0xCE6500, beginIndex, endIndex);
			}
			
			// comments
			regex = /([^:]|^)\-\-(.*?)\r/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x008000, beginIndex, endIndex);
			}
		
		}
	}
}