Class dc.chatbot.ToFileMsg Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method ProcessFileRequest(pRequest As dc.chatbot.TelegramRequest, Output pResponse As dc.chatbot.TelegramResponse) As %Status
{
    $$$TRACE("pRequest: "_pRequest.Text)
    Set filename = "output.txt" 
    $$$QuitOnError(..Adapter.PutLine(filename, pRequest.Text))
    Set pResponse = ##class(dc.chatbot.TelegramResponse).%New()
    Set pResponse.ResponseText = "OK"
    Return $$$OK
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="dc.chatbot.TelegramRequest">
    <Method>ProcessFileRequest</Method>
  </MapItem>
</MapItems>
}

}
