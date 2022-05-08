Class UnitTest.dc.chatbot.Main Extends %UnitTest.TestProduction
{

Parameter PRODUCTION = "dc.chatbot.TelegramChatbotProductionTest";

Parameter MAXWAIT = 1;

Parameter MINRUN = 1;

ClassMethod TestSetup() As %Status
{
    Set sc = $$$OK
    Set ^UnitTestRoot = "/tmp"
    #; Do $ZF(-1, 
    #;     "mkdir -p /tmp/chatbot/in && "_
    #;     "mkdir -p /tmp/chatbot/out"
    #; )
    Return sc
}

Method OnBeforeProductionStart() As %Status
{
    If ($Get(^UnitTestRoot) = "") {
        Do ..TestSetup()
    }

    Set prodcutionClassName = ##class(dc.chatbot.TelegramChatbotProduction).%ClassName(1)
    Set testProdcutionClassName = prodcutionClassName_"Test"
    If (##class(%ClassDefinition).%ExistsId(testProdcutionClassName)) {
        Do $system.OBJ.Delete(testProdcutionClassName)
    }
    Do ..CreateTestProduction()

	Quit $$$OK
}

/// Creates a copy of this production and replace some of its business hosts
/// to mocks, in order to avoid dependencies on external APIs during testing.
/// TODO: improve this code (check out TODOs in UnitTest.dc.chatbot.Utils class)
ClassMethod CreateTestProduction()
{
    Set className = ##class(dc.chatbot.TelegramChatbotProduction).%ClassName(1)
    Set newClassName = ##class(UnitTest.dc.chatbot.Utils).GetCloneName(className)

    Do ##class(UnitTest.dc.chatbot.Utils).ValidateClass(className)

    Do ##class(UnitTest.dc.chatbot.Utils).CloneClass(className, newClassName)

    Do ##class(UnitTest.dc.chatbot.Utils).SetProductionName(newClassName, className, newClassName)

    // mocking for FromTelegram BS and ToTelegram BO
    Do ##class(UnitTest.dc.chatbot.Utils).SetItemName(newClassName, "FromTelegram", "dc.chatbot.FromTelegram", "UnitTest.dc.chatbot.FromTelegram")
    Do ##class(UnitTest.dc.chatbot.Utils).SetItemName(newClassName, "ToTelegram", "Telegram.TelegramOperation", "UnitTest.dc.chatbot.TelegramOperation")
    
    // removing of settings used by original business hosts (replaced by mock versions)
    Do ##class(UnitTest.dc.chatbot.Utils).RemoveSetting(newClassName, "    <Setting Target=""Adapter"" Name=""SSLConfiguration"">")
    Do ##class(UnitTest.dc.chatbot.Utils).RemoveSetting(newClassName, "    <Setting Target=""Adapter"" Name=""TelegramToken"">")
    
    $$$TOE(st, $system.OBJ.Compile(newClassName))
}

Method OnAfterProductionStart() As %Status
{
    Set chatId = "5364421812"

    Set request = ##class(dc.chatbot.TelegramRequest).%New()
    Set request.RequestChatId = chatId
    Set request.RequestText = "hi!"
    Set tSC = ..SendRequest("ChatbotRouter", request, .response, 1, 10)
    Do $$$AssertEquals(response.ResponseText, "OK", "Response should contain OK.")

    Set request = ##class(dc.chatbot.TelegramRequest).%New()
    Set request.RequestChatId = chatId
    Set request.RequestText = "olá!"
    Set tSC = ..SendRequest("ChatbotRouter", request, .response, 1, 10)
    Do $$$AssertEquals(response.ResponseText, "OK", "Response should contain OK.")
    
    Return tSC
}

Method CheckResults(ByRef Log As %String, New As %String) As %Status
{
    #Define MyAssertEquals(%a1, %a2) $$$AssertEquals(%a1, %a2, ##quote(%a1)_" should be """_%a2_""" (found: """_%a1_""")")
    #Define MyAssertTrue(%a1) $$$AssertTrue(%a1, ##quote(%a1)_" should be TRUE (found: """_%a1_""")")

    Do ..GetEventLog("trace", "", "", .Log, .New)
    #; m ^k("Log", $I(^k("Log"))) = Log
    #; m ^k("New", $I(^k("New"))) = New
    
    Do ..RecognizedMessageAsserts(.Log)
    Do ..UnrecognizedMessageAsserts(.Log)
    
    Return $$$OK
}

Method RecognizedMessageAsserts(Log)
{
    Set assertion = $$$MyAssertEquals(Log(1,"ConfigName"),"ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(1,"SourceClass"),"dc.chatbot.ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(1,"SourceMethod"),"S1")
    Set assertion = $$$MyAssertTrue($Find(Log(1,"Text"),"""RequestText"":""hi!"""))
    Set assertion = $$$MyAssertTrue($Match(Log(1,"Text"),".*""RequestChatId"":""[\d]+"".*"))
    
    Set assertion = $$$MyAssertEquals(Log(2,"ConfigName"),"ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(2,"SourceClass"),"dc.chatbot.ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(2,"SourceMethod"),"ProcessRequest")
    Set assertion = $$$MyAssertTrue($Find(Log(2,"Text"),"""UserInputText"":""hi!"""))

    Set assertion = $$$MyAssertEquals(Log(3,"ConfigName"),"ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(3,"SourceClass"),"dc.chatbot.ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(3,"SourceMethod"),"ProcessRequest")
    Set assertion = $$$MyAssertTrue($Match(Log(3,"Text"),".*""ResponseText"":"".*"".*"))
    Set assertion = $$$MyAssertTrue($Find(Log(3,"Text"),"""ResponseConf"":1}"))
    
    Set assertion = $$$MyAssertEquals(Log(4,"ConfigName"),"ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(4,"SourceClass"),"dc.chatbot.ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(4,"SourceMethod"),"S3")
    Set assertion = $$$MyAssertTrue($Match(Log(4,"Text"),".*""ResponseText"":"".*"".*"))
    Set assertion = $$$MyAssertTrue($Find(Log(4,"Text"),"""ResponseConf"":1}"))
    
    Set assertion = $$$MyAssertEquals(Log(5,"ConfigName"),"ToTelegram")
    Set assertion = $$$MyAssertEquals(Log(5,"SourceClass"),"UnitTest.dc.chatbot.TelegramOperation")
    Set assertion = $$$MyAssertEquals(Log(5,"SourceMethod"),"SendMessage")
    Set assertion = $$$MyAssertTrue($Match(Log(5,"Text"),".*""Text"":"".*"".*"))
    
    Set assertion = $$$MyAssertEquals(Log(6,"ConfigName"),"ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(6,"SourceClass"),"dc.chatbot.ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(6,"SourceMethod"),"S5")
    Set assertion = $$$MyAssertTrue($Find(Log(6,"Text"),"""ResponseText"":""OK"""))
    Set assertion = $$$MyAssertTrue($Match(Log(6,"Text"),".*""ResponseChatId"":""[\d]+"".*"))
}

Method UnrecognizedMessageAsserts(Log)
{
    Set assertion = $$$MyAssertEquals(Log(7,"ConfigName"),"ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(7,"SourceClass"),"dc.chatbot.ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(7,"SourceMethod"),"S1")
    Set assertion = $$$MyAssertTrue($Find(Log(7,"Text"),"""RequestText"":""olá!"""))
    Set assertion = $$$MyAssertTrue($Match(Log(7,"Text"),".*""RequestChatId"":""[\d]+"".*"))
    
    Set assertion = $$$MyAssertEquals(Log(8,"ConfigName"),"ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(8,"SourceClass"),"dc.chatbot.ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(8,"SourceMethod"),"ProcessRequest")
    Set assertion = $$$MyAssertTrue($Find(Log(8,"Text"),"""UserInputText"":""olá!"""))
    
    Set assertion = $$$MyAssertEquals(Log(9,"ConfigName"),"ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(9,"SourceClass"),"dc.chatbot.ToChatterbot")
    Set assertion = $$$MyAssertEquals(Log(9,"SourceMethod"),"ProcessRequest")
    Set assertion = $$$MyAssertTrue($Find(Log(9,"Text"),"""ResponseText"":""I am sorry, but I do not understand..."""))
    Set assertion = $$$MyAssertTrue($Match(Log(9,"Text"),".*""ResponseConf"":0.*"))
    
    Set assertion = $$$MyAssertEquals(Log(10,"ConfigName"),"ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(10,"SourceClass"),"dc.chatbot.ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(10,"SourceMethod"),"S3")
    Set assertion = $$$MyAssertTrue($Find(Log(10,"Text"),"""ResponseText"":""I am sorry, but I do not understand..."""))
    Set assertion = $$$MyAssertTrue($Match(Log(10,"Text"),".*""ResponseConf"":0.*"))
    
    Set assertion = $$$MyAssertEquals(Log(11,"ConfigName"),"ToTelegram")
    Set assertion = $$$MyAssertEquals(Log(11,"SourceClass"),"UnitTest.dc.chatbot.TelegramOperation")
    Set assertion = $$$MyAssertEquals(Log(11,"SourceMethod"),"SendMessage")
    Set assertion = $$$MyAssertTrue($Find(Log(11,"Text"),"""Text"":""I am sorry, but I do not understand..."""))
    Set assertion = $$$MyAssertTrue($Match(Log(11,"Text"),".*""ChatId"":[\d]+.*"))
    
    Set assertion = $$$MyAssertEquals(Log(12,"ConfigName"),"ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(12,"SourceClass"),"dc.chatbot.ChatbotRouter")
    Set assertion = $$$MyAssertEquals(Log(12,"SourceMethod"),"S5")
    Set assertion = $$$MyAssertTrue($Find(Log(12,"Text"),"""ResponseText"":""OK"""))
    Set assertion = $$$MyAssertTrue($Match(Log(12,"Text"),".*""ResponseChatId"":""[\d]+"".*"))
}

Method CheckErrors() As %Status
{
    Return $$$OK
}

}
