/* 
 Name: ContentDocumentLinkHandler Class
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 2-3-2018
 Reason:  This Handler class is handling the events of ContentDocumentLinkTrigger Triggers.
         
--*/
public Class ContentDocumentLinkHandler extends TriggerHandler{

 
   /*Global variable*/
    public ContentDocumentLinkHelper helper { get; set; }

    /*************************************************************************************************************************************************************
    @ Constructor:    ContentDocumentLinkHandler 
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public ContentDocumentLinkHandler() {
        helper = new ContentDocumentLinkHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event
    **********************************************************************************************************************************************************/     
    public override void afterinsert() {
        helper.PreventCheckboxforfile(Trigger.New);
        
    }
    
   
  

}