Class UnitTest.dc.chatbot.Utils Extends %RegisteredObject
{

/// Given a class name, this method tries to create a unique new one appending
/// a suffix on it.
ClassMethod GetCloneName(className As %String, suffix As %String = "Test") As %String
{
    Set name = className_suffix
    For attemp=1:1:100 {
        If ('##class(%ClassDefinition).%ExistsId(name)) Quit
        Set name = className_suffix_attemp
    }
    If (attemp > 100) {
        Throw ##class(%Exception.General).%New("Can't create a valid class name")
    }
    Return name
}

/// Given a class name, this method checks if its a valid one.
ClassMethod ValidateClass(className As %String)
{
    If (className = "") {
        Throw ##class(%Exception.General).%New("Class name excepted")
    }
    If ($Data(^oddDEF(className)) '= 11) {
        Throw ##class(%Exception.General).%New("Class not found: "_className)
    }
}

/// Based on https://community.intersystems.com/post/copying-all-classes-package-new-package#comment-103271
ClassMethod CloneClass(className As %String, newClassName As %String)
{
    Merge ^oddDEF(newClassName) = ^oddDEF(className)
    Set ^oddDEF(newClassName, 1) = newClassName
}

/// Changes the production name on the copied production
/// 
/// TODO: use a better way to handle XData for ProductionDefinition; 
/// for instance, copy the class through ^oddDEF, but clearing its ProductionDefinition
/// XData block **before** compiling, then open and copy the original XDATA content
/// but using XML projection to handle with XData block content, and after edintig it
/// serialize it back to XML and save the ProductionDefinition XData block.
ClassMethod SetProductionName(className As %String, oldName As %String, newName As %String)
{
    Set productionTag = ^oddDEF(className, "x", "ProductionDefinition", 21, 1)
    Set productionTag = $Replace(productionTag, "Production Name="""_oldName_"""", "Production Name="""_newName_"""")
    Set ^oddDEF(className, "x", "ProductionDefinition", 21, 1) = productionTag
}

/// Sets a business host item (BS, BP and BO).
/// 
/// TODO: use a better way to handle XData for ProductionDefinition; 
/// for instance, copy the class through ^oddDEF, but clearing its ProductionDefinition
/// XData block **before** compiling, then open and copy the original XDATA content
/// but using XML projection to handle with XData block content, and after edintig it
/// serialize it back to XML and save the ProductionDefinition XData block.
ClassMethod SetItemName(className As %String, itemName As %String, oldItemValue As %String, newItemValue As %String)
{
    Set line = $Order(^oddDEF(className, "x", "ProductionDefinition", 21, ""))
    While (line '= "") {
        Set lineText = ^oddDEF(className, "x", "ProductionDefinition", 21, line)
        Set item = "  <Item Name="""_itemName_""""
        If (lineText [ item) {
            Set lineText = $Replace(lineText, "ClassName="""_oldItemValue_"""", "ClassName="""_newItemValue_"""")
            Set lineText = lineText
            Set ^oddDEF(className, "x", "ProductionDefinition", 21, line) = lineText
            Quit
        }
        Set line = $Order(^oddDEF(className, "x", "ProductionDefinition", 21, line))
    }
}

/// Remove a setting for business host.
/// 
/// TODO: use a better way to handle XData for ProductionDefinition; 
/// for instance, copy the class through ^oddDEF, but clearing its ProductionDefinition
/// XData block **before** compiling, then open and copy the original XDATA content
/// but using XML projection to handle with XData block content, and after edintig it
/// serialize it back to XML and save the ProductionDefinition XData block.
ClassMethod RemoveSetting(className As %String, setting As %String)
{
    Set line = $Order(^oddDEF(className, "x", "ProductionDefinition", 21, ""))
    While (line '= "") {
        Set lineText = ^oddDEF(className, "x", "ProductionDefinition", 21, line)
        If (lineText [ setting) {
            Set ^oddDEF(className, "x", "ProductionDefinition", 21, line) = ""
        }
        Set line = $Order(^oddDEF(className, "x", "ProductionDefinition", 21, line))
    }
}

}
