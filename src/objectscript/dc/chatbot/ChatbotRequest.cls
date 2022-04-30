Class dc.chatbot.ChatbotRequest Extends Ens.Request
{

Property UserInputText As %String(MAXLEN = "");

Storage Default
{
<Data name="ChatbotRequestDefaultData">
<Subscript>"ChatbotRequest"</Subscript>
<Value name="1">
<Value>UserInputText</Value>
</Value>
</Data>
<DefaultData>ChatbotRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
