Class dc.chatbot.FromTelegram Extends Ens.BusinessService
{

Parameter ADAPTER = "Telegram.TelegramInboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
	set msg = ##class(Telegram.Msg.TextRequest).%New()
	if (pInput.message = "") {
		return $$$OK // skipping, if update type not equal to "message" 
	}

	$$$TRACE(##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(pInput).%ToJSON())

    Set msg = ##class(dc.chatbot.TelegramRequest).%New()
    Set msg.RequestText = pInput.message.text
    Set msg.RequestChatId = pInput.message.chat.id

    $$$TOE(sc, ..SendRequestAsync("ChatbotRouter", msg, .pOutput))

	$$$TRACE(pOutput)
    
    Return $$$OK
}

}
