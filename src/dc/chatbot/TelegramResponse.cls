Class dc.chatbot.TelegramResponse Extends Ens.Response
{

Property ResponseText As %String(MAXLEN = "");

Property ResponseChatId As %String(MAXLEN = "");

Storage Default
{
<Data name="TelegramResponseDefaultData">
<Subscript>"TelegramResponse"</Subscript>
<Value name="1">
<Value>ResponseText</Value>
</Value>
<Value name="2">
<Value>ResponseChatId</Value>
</Value>
</Data>
<DefaultData>TelegramResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
