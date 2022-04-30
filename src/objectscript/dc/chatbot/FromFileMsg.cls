Class dc.chatbot.FromFileMsg Extends Ens.BusinessService
{

Property Adapter As EnsLib.File.InboundAdapter;

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Method OnProcessInput(pInput As %Stream.FileCharacter, pOutput As %RegisteredObject) As %Status
{
    Set msg = ##class(dc.chatbot.TelegramRequest).%New()
    Set msg.Text = pInput.ReadLine()
    $$$TRACE("Text: "_msg.Text)
    Return ..SendRequestAsync("ChatbotRouter", msg, .pOutput)
}

}
