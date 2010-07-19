package parser
{
	public class AspVbscriptParser extends SyntaxParserBase
	{
		public function AspVbscriptParser(editor:TextFieldBase, baseIndex:uint = 0, length:int = -1)
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
				
			// Reserved words
			regex = /\b(abs|and|array|as|asc|AtEndOfLine|AtEndOfStream|atn|boolean|break|byte|call|case|close|continue|CopyFile|CopyFolder|cos|currency|date|DateAdd|DateDiff|DateValue|day|DeleteFile|DeleteFolder|dim|do|double|doWhile|else|elseif|empty|end|endif|eqv|error|eval|exit|exp|extends|FileSystemObject|Filter|fix|float|for|ForAppending|foreach|FormatDateTime|FormatNumber|FormatPercent|ForReading|ForWriting|function|GetFile|GetObject|global|hex|hour|if|imp|in|include|InStr|InStrRev|int|integer|IsArray|IsDate|IsEmpty|IsNull|IsNumeric|IsObject|k|y|lbound|lcase|left|len|log|long|loop|ltrim|mid|minute|month|MoveFile|MoveFolder|next|not|now|null|object|open|OpenAsTextStream|or|ReadLine|return|RGB|right|rnd|round|rtrim|Scr|pting|second|select|set|sgn|sin|single|split|sqr|StrComp|string|StrReverse|tan|then|time|TimeValue|to|trim|TristateFalse|TristateTrue|TristateUseDefault|ubound|ucase|until|VarT|pe|wend|while|xor|year|FALSE|TRUE)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x0000FF, beginIndex, endIndex);
			}
			
			// Built-in functions
			regex = /\b(Abandon|AddHeader|AppendToLog|Application_OnEnd|Application_OnStart|BinaryRead|BinaryWrite|Buffer|CacheControl|Charset|Clear|ClientCertificate|CodePage|Contents|Contents|Content|ype|Cookies|CreateObject|End|Expires|ExpiresAbsolute|Flush|Form|HTMLEncode|IsClientConnected|LCID|Lock|MapPath|ObjectContext|OnTransactionAbort|OnTransactionCommit|Pics|QuerySt|ing|Redirect|Request|Response|Scripttimeout|Server|ServerVariables|Session|Session_OnEnd|Session_OnStart|SessionID|SetAbort|SetComplete|StaticObject|Status|TimeOut|TotalBytes|U|lock|URLEncode|Write|adArray|adBigInt|adBinary|adBoolean|adBSTR|adByRef|adChar|adCurrency|adDate|adDBDate|adDBTime|adDBTimeStamp|adDecimal|AddHeader|adDouble|adEmpty|adError|a|GUID|adIDispatch|adInteger|adIUnknown|adLongVarBinary|adLongVarChar|adNumeric|adSingle|adSmallInt|adTinyInt|adUnsignedBigInt|adUnsignedInt|adUnsignedSmallInt|adUnsignedTinyInt|adUserDefined|adVarBinary|adVarChar|adVariant|adVarWChar|adVector|adWChar|ALL_HTTP|ALL_RAW|AppendToLog|APPL_MD_PATH|APPL_PHYSICAL_PATH|AUTH_PASSWORD|AUTH_TYPE|AUTH_USER|CER_SERV|R_SUBJECT|CER_SUBJECT|CERT_COOKIE|CERT_FLAGS|CERT_ISSUER|CERT_KEYSIZE|CERT_SECRETKEYSIZE|CERT_SERIALNUMBER|CERT_SERVER_ISSUER|CONTENT_LENGTH|CONTENT_TYPE|GATEWAY_INTERFACE|HTTP|HTTPS_KEYSIZE|HTTPS_SECRETKEYSIZE|HTTPS_SERVER_ISSUER|HTTPS_SERVER_SUBJECT|INSTANCE_ID|INSTANCE_META_PATH|LOCAL_ADDR|LOGON_USER|PATH_INFO|PATH_TRANSLATED|PICS|QUERY_STRING|REM|TE_ADDR|REMOTE_HOST|REMOTE_USER|REQUEST_METHOD|SCRIPT_NAME|SERVER_NAME|SERVER_PORT|SERVER_PORT_SECURE|SERVER_PROTOCOL|SERVER_SOFTWARE)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x0000FF, beginIndex, endIndex);
			}
			
			// ADO
			regex = /\b(AbsolutePage|AbsolutePosition|ActiveConnection|ActualSize|adAddNew|adAffectAll|adAffectCurrent|adAffectGroup|adApproxPosition|adBookmark|adBookmarkCurrent|adBookmarkFirst|adBook|arkLast|adCmdStoredProc|adCmdTable|adCmdText|adCmdUnknown|adDelete|AddNew|adEditAdd|adEditInProgress|adEditNone|adHoldRecords|adLockBatchOptimistic|adLockOptimistic|adLockPessi|istic|adLockReadOnly|adMarshalAll|adMarshalModifiedOnly|adModeRead|adModeReadWrite|adModeShareDenyNone|adModeShareDenyRead|adModeShareDenyWrite|adModeShareExclusive|adModeUnkno|n|adModeWrite|adMovePrevious|adOpenDynamic|adOpenForwardOnly|adOpenKeyset|adOpenStatic|adParamInput|adParamInputOutput|adParamOutput|adPosBOF|adPosEOF|adPosUnknown|adRecCancele|adRecCantRelease|adRecCuncurrencyViolation|adRecDBDeleted|adRecDeleted|adRecIntegrityViolation|adRecInvalid|adRecMaxChangesExceeded|adRecModified|adRecMultipleChanges|adRecNew|adRecObjectOpen|adRecOK|adRecOutOfmemory|adRecPendingChanges|adRecPermissionDenied|adRecSchemaViolation|adRecUnmodified|adResync|adReturnValue|adStateClosed|adStateOpen|adUpdate|adUpdateBatch|Append|AppendChunk|Attributes|BeginTrans|BOF|Bookmark|CacheSize|CancelBatch|CancelUpdate|Clear|Clone|Close|CommandText|CommandTimeOut|CommandType|CommitTrans|Conn|ctionString|ConnectionTimeOut|Count|CreateParameter|CursorLocation|CursorType|DefaultDatabase|DefinedSize|Delete|Description|Direction|EditMode|EOF|Errors|Execute|Fields|Filter|GetChunk|GetRows|HelpContext|HelpFile|IsolationLevel|Item|LockType|MarshalOption|MaxRecords|Mode|Move|MoveFirst|MoveLast|MoveNext|MovePrevious|Name|NativeError|NextRecordset|No|hing|Number|NumericScale|Open|OpenSchema|OriginalValue|PageCount|PageSize|Parameters|Precision|Prepared|Properties|Provider|RecordCount|Requery|Resync|RollbackTrans|Size|Source|SQLState|State|Status|Supports|Type|UnderlyingValue|Update|UpdateBatch|Value|Version)\b/smi;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x2B91AF, beginIndex, endIndex);
			}
			
			// comments
			regex = /((\brem\b)|\')[^\r]*/ism;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor(0x008000, beginIndex, endIndex);
			}
			
			// strings double quote
			regex = /\"([^\r|\n]*)\"/sm;
			array = super.search(regex);
			for( i = 0; i < array.length; i++){
				beginIndex = array[i].beginIndex;
				endIndex = array[i].endIndex;
				super.setColor( 0x800000, beginIndex, endIndex);
			}
		}
	}
}