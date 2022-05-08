Class UnitTest.dc.chatbot.TelegramOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method SendMessage(pInput As Telegram.Msg.TextRequest, Output pOutput As Ens.Response) As %Status
{
    Set output = {"ChatId": (pInput.ChatId), "Text": (pInput.Text)}.%ToJSON()
	$$$TRACE(output)
    Return $$$OK
}

Method SendButton(pInput As Telegram.Msg.ButtonRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendButton(pInput.ChatId,pInput.Text,pInput.Button,1)
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Telegram.Msg.TextRequest">
        <Method>SendMessage</Method>
    </MapItem>
    <MapItem MessageType="Telegram.Msg.ButtonRequest">
        <Method>SendButton</Method>
    </MapItem>
</MapItems>
}

}
