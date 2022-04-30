Class dc.chatbot.ChatMsgResponse Extends Ens.Response
{

Property ResponseText As %String(MAXLEN = "");

Property ResponseConf As %Float;

Storage Default
{
<Data name="ChatMsgResponseDefaultData">
<Subscript>"ChatMsgResponse"</Subscript>
<Value name="1">
<Value>ResponseText</Value>
</Value>
<Value name="2">
<Value>ResponseConf</Value>
</Value>
</Data>
<DefaultData>ChatMsgResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
