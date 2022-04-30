Class dc.chatbot.TelegramRequest Extends Ens.Request
{

Property Text As %String(MAXLEN = "");

Storage Default
{
<Data name="TelegramRequestDefaultData">
<Subscript>"TelegramRequest"</Subscript>
<Value name="1">
<Value>Text</Value>
</Value>
</Data>
<DefaultData>TelegramRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
