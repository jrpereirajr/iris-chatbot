Class dc.chatbot.TelegramRequest Extends Ens.Request
{

Property RequestText As %String(MAXLEN = "");

Property RequestChatId As %String(MAXLEN = "");

Storage Default
{
<Data name="TelegramRequestDefaultData">
<Subscript>"TelegramRequest"</Subscript>
<Value name="1">
<Value>RequestText</Value>
</Value>
<Value name="2">
<Value>RequestChatId</Value>
</Value>
</Data>
<DefaultData>TelegramRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
