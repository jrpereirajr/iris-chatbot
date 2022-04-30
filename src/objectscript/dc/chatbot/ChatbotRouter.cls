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
<property name='chatbotResponseObj' type='dc.chatbot.ChatbotResponse' instantiate='1' />
</context>
<sequence xend='200' yend='800' >
<call name='ToChatbot' target='ToChatbot' async='0' xpos='200' ypos='250' >
<request type='dc.chatbot.ChatbotRequest' >
<assign property="callrequest.UserInputText" value="request.Text" action="set" />
</request>
<response type='dc.chatbot.ChatbotResponse' >
<assign property="context.chatbotResponseObj" value="callresponse" action="set" />
</response>
</call>
<if name='Check confidence' condition='context.chatbotResponseObj.ResponseConf &lt; 0.7' xpos='200' ypos='350' xend='200' yend='600' >
<annotation><![CDATA[Check chatbot response confidence]]></annotation>
<true>
<assign name="No confidence response" property="context.chatbotResponseObj.ResponseText" value="&quot;Sorry, I don't understand you&quot;" action="set" xpos='335' ypos='500' disabled="true">
<annotation><![CDATA[Set the message to a default one when response confidence isn't good enough]]></annotation>
</assign>
</true>
</if>
<call name='ToFileMsg' target='ToFileMsg' async='0' xpos='200' ypos='700' >
<request type='dc.chatbot.TelegramRequest' >
<assign property="callrequest.Text" value="context.chatbotResponseObj.ResponseText" action="set" />
</request>
<response type='dc.chatbot.TelegramResponse' >
<assign property="response.ResponseText" value="callresponse.ResponseText" action="set" />
</response>
</call>
</sequence>
</process>
}

}
