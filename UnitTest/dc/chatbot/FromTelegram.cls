Class UnitTest.dc.chatbot.FromTelegram Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
	#; set msg = ##class(Telegram.Msg.TextRequest).%New()
	#; if (pInput.message = "") {
	#; 	return $$$OK // skipping, if update type not equal to "message" 
	#; }

	#; $$$TRACE(pInput.message.chat.id)
	#; $$$TRACE(pInput.message.text)

    #; Set msg = ##class(dc.chatbot.TelegramRequest).%New()
    #; Set msg.RequestText = pInput.message.text
    #; Set msg.RequestChatId = pInput.message.chat.id

    #; $$$TOE(sc, ..SendRequestAsync("ChatbotRouter", msg, .pOutput))
    
    Return $$$OK
}

}
