Class dc.chatbot.TelegramChatbotProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.chatbot.TelegramChatbotProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="FromFileMsg" Category="" ClassName="dc.chatbot.FromFileMsg" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/chatbot/in/</Setting>
  </Item>
  <Item Name="ToChatbot" Category="" ClassName="dc.chatbot.ToChatbot" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ToFileMsg" Category="" ClassName="dc.chatbot.ToFileMsg" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/chatbot/out/</Setting>
  </Item>
  <Item Name="ChatbotRouter" Category="" ClassName="dc.chatbot.ChatbotRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
