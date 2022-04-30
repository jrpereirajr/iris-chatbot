Class UnitTest.dc.chatbot.Main Extends %UnitTest.TestProduction
{

Parameter PRODUCTION = "dc.chatbot.TelegramChatbotProduction";

Parameter MAXWAIT = 1;

Parameter MINRUN = 1;

Method OnBeforeProductionStart() As %Status
{
    If ('##class(%File).DirectoryExists("/tmp/chatbot")) {
        Do ..TestSetup()
    }
	Quit $$$OK
}

ClassMethod TestSetup() As %Status
{
    Set sc = $$$OK
    #; Set ^UnitTestRoot = "/tmp"
    Do $ZF(-1, 
        "mkdir -p /tmp/chatbot/in && "_
        "mkdir -p /tmp/chatbot/out"
    )
    Return sc
}

Method OnAfterProductionStart() As %Status
{
    Set request = ##class(dc.chatbot.TelegramRequest).%New()
    Set request.Text = "hi!"
    Set tSC = ..SendRequest("ChatbotRouter", request, .response, 1, 10)
    Do $$$AssertEquals(response.ResponseText, "OK", "Response should contain OK.")

    Set request = ##class(dc.chatbot.TelegramRequest).%New()
    Set request.Text = "olá!"
    Set tSC = ..SendRequest("ChatbotRouter", request, .response, 1, 10)
    Do $$$AssertEquals(response.ResponseText, "OK", "Response should contain OK.")
    
    Return tSC
}

Method CheckResults(ByRef Log As %String, New As %String) As %Status
{
    #Define MyAssertEquals(%a1, %a2) $$$AssertEquals(%a1, %a2, ##quote(%a1)_" should be """_%a2_""" (found: """_%a1_""")")

    Set tSC = $$$OK 

    Do ..GetEventLog("trace", "", "", .Log, .New)
    m ^k("Log", $I(^k("Log"))) = Log
    m ^k("New", $I(^k("New"))) = New

    #; Set assertion = $$$MyAssertEquals(Log(1, "ConfigName"), "ChatbotRouter")
    #; Set assertion = $$$MyAssertEquals(Log(1, "Text"), "request.RequestText: hey you!")
    #; Set assertion = $$$MyAssertEquals(Log(2, "ConfigName"), "ToChatbot")
    #; Set assertion = $$$MyAssertEquals(Log(2, "Text"), "pRequest: hey you!")
    #; Set assertion = $$$MyAssertEquals(Log(3, "ConfigName"), "ChatbotRouter")
    #; Set assertion = $$$MyAssertEquals(Log(3, "Text"), "context.chatbotResponse: echo: hey you!")
    #; Set assertion = $$$MyAssertEquals(Log(4, "ConfigName"), "ToFileMsg")
    #; Set assertion = $$$MyAssertEquals(Log(4, "Text"), "pRequest: echo: hey you!")
    #; Set assertion = $$$MyAssertEquals(Log(5, "ConfigName"), "ChatbotRouter")
    #; Set assertion = $$$MyAssertEquals(Log(5, "Text"), "response.ResponseText: OK")
    
    Return tSC
}

Method CheckErrors() As %Status
{
    Return $$$OK
}

}
