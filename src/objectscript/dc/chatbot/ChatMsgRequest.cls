Class dc.chatbot.ChatMsgRequest Extends Ens.Request
{

Property RequestText As %String(MAXLEN = "");

Storage Default
{
<Data name="ChatMsgRequestDefaultData">
<Subscript>"ChatMsgRequest"</Subscript>
<Value name="1">
<Value>RequestText</Value>
</Value>
</Data>
<DefaultData>ChatMsgRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
