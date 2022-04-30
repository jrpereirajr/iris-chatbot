Class dc.chatbot.ToChatbot Extends Ens.BusinessOperation
{

/// Name of the chatbot
Property ChatbotName As %String(MAXLEN = 250);

/// Minimum confidence threshold
Property LowConfidenceThreshold As %Float [ InitialExpression = 0.9 ];

/// Message to be sent when confidence threshold isn't reached
Property DefaultLowConfidenceMsg As %String(MAXLEN = 1024) [ InitialExpression = "I am sorry, but I do not understand..." ];

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "ChatbotName:Basic,LowConfidenceThreshold:Basic,DefaultLowConfidenceMsg:Basic";

Method ProcessFileRequest(pRequest As dc.chatbot.ChatbotRequest, Output pResponse As dc.chatbot.ChatbotResponse) As %Status
{
    $$$TRACE("pRequest: "_pRequest.UserInputText)
    Set pResponse = ##class(dc.chatbot.ChatbotResponse).%New()
    Set chatbot = ..GetChatbot()
    Set resp = chatbot."get_response"(pRequest.UserInputText)
    Set pResponse.ResponseText = resp.text
    Set pResponse.ResponseConf = resp.confidence
    Return $$$OK
}

Method GetChatbot() As %SYS.Python [ Language = python ]
{
    from chatterbot import ChatBot
    from chatterbot.trainers import ChatterBotCorpusTrainer
    from os.path import exists
    import iris
    from datetime import datetime

    adapters = [
        {
            'import_path': 'chatterbot.logic.BestMatch',
            'default_response': self.DefaultLowConfidenceMsg,
            'maximum_similarity_threshold': +self.LowConfidenceThreshold
        }
    ]
    chatbot = ChatBot(
        self.ChatbotName, 
        logic_adapters=adapters
    )

    j = iris.gref('^j')
    j['ChatbotName'] = self.ChatbotName
    j['LowConfidenceThreshold'] = +self.LowConfidenceThreshold
    j['DefaultLowConfidenceMsg'] = self.DefaultLowConfidenceMsg

    path_to_file = '/tmp/my_export.json'
    if not exists(path_to_file):
        trainer = ChatterBotCorpusTrainer(chatbot)
        trainer.train('chatterbot.corpus.english')
        trainer.export_for_training(path_to_file)
        j["trainned", str(datetime.now())] = 1

    return chatbot
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="dc.chatbot.ChatbotRequest">
    <Method>ProcessFileRequest</Method>
  </MapItem>
</MapItems>
}

}
