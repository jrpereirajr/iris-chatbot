Class dc.chatbot.ChatbotResponse Extends Ens.Response
{

Property ResponseText As %String(MAXLEN = "");

Property ResponseConf As %Float;

Storage Default
{
<Data name="ChatbotResponseDefaultData">
<Subscript>"ChatbotResponse"</Subscript>
<Value name="1">
<Value>ResponseText</Value>
</Value>
<Value name="2">
<Value>ResponseConf</Value>
</Value>
</Data>
<DefaultData>ChatbotResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
