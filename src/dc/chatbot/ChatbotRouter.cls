/// 
Class dc.chatbot.ChatbotRouter Extends Ens.BusinessProcessBPL
{

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
<call name='ToChatterbot' target='ToChatterbot' async='0' xpos='200' ypos='250' >
<request type='dc.chatbot.ChatbotRequest' >
<assign property="callrequest.UserInputText" value="request.RequestText" action="set" />
<assign property="context.chatId" value="request.RequestChatId" action="set" />
</request>
<response type='dc.chatbot.ChatbotResponse' >
<assign property="context.chatbotResponseObj" value="callresponse" action="set" />
</response>
</call>
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
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
