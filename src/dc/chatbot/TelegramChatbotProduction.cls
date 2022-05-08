Class dc.chatbot.TelegramChatbotProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.chatbot.TelegramChatbotProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="ToChatterbot" Category="" ClassName="dc.chatbot.ToChatterbot" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ChatbotRouter" Category="" ClassName="dc.chatbot.ChatbotRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FromTelegram" Category="" ClassName="dc.chatbot.FromTelegram" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="TelegramToken">5331175806:AAFdMVxbQV6RzVvJ1f7cnXrHEdte3ir4mhQ</Setting>
  </Item>
  <Item Name="ToTelegram" Category="" ClassName="Telegram.TelegramOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfiguration">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="TelegramToken">5331175806:AAFdMVxbQV6RzVvJ1f7cnXrHEdte3ir4mhQ</Setting>
  </Item>
</Production>
}

}
