/// 
Class dc.chatbot.ChatbotRouter Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='dc.chatbot.TelegramRequest' response='dc.chatbot.TelegramResponse' height='2000' width='2000' >
<context>
<property name='chatId' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='chatbotResponseObj' type='dc.chatbot.ChatbotResponse' initialexpression='""' instantiate='1' />
</context>
<sequence xend='200' yend='450' >
<trace value='##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(request).%ToJSON()' xpos='721' ypos='210' >
<annotation><![CDATA[$$$TRACE(request)]]></annotation>
</trace>
<call name='ToChatterbot' target='ToChatterbot' async='0' xpos='247' ypos='243' >
<request type='dc.chatbot.ChatbotRequest' >
<assign property="callrequest.UserInputText" value="request.RequestText" action="set" />
<assign property="context.chatId" value="request.RequestChatId" action="set" />
</request>
<response type='dc.chatbot.ChatbotResponse' >
<assign property="context.chatbotResponseObj" value="callresponse" action="set" />
</response>
</call>
<trace value='##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(context.chatbotResponseObj).%ToJSON()' xpos='734' ypos='410' >
<annotation><![CDATA[$$$TRACE(context.chatbotResponseObj)]]></annotation>
</trace>
<call name='ToTelegram' target='ToTelegram' async='0' xpos='200' ypos='350' >
<request type='Telegram.Msg.TextRequest' >
<assign property="callrequest.ChatId" value="context.chatId" action="set" />
<assign property="callrequest.Text" value="context.chatbotResponseObj.ResponseText" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response.ResponseText" value="&quot;OK&quot;" action="set" />
<assign property="response.ResponseChatId" value="context.chatId" action="set" />
</response>
</call>
<trace value='##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(response).%ToJSON()' xpos='731' ypos='532' >
<annotation><![CDATA[$$$TRACE(response)]]></annotation>
</trace>
</sequence>
</process>
}

}
