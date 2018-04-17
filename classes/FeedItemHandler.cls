/*
Type Name: FeedItemHandler Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 4th August 2017
Reason: This Handler class is handling the events of "FeedItemTrigger" Triggers.
        
Change History:
Author: 
Modified Date: 
Reason: 
*/


Public Class FeedItemHandler extends TriggerHandler{
  
   /*Global variable*/
   public FeedItemHelper helper {get;set;}

 /*************************************************************************************************************************************************************
    @ Constructor:    R_TeamRoomHandler
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public FeedItemHandler() {
        helper = new FeedItemHelper();
    }
    
     /*********************************************************************************************************************************************************
    @ Method:         beforeInsert
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeInsert() {
    helper.OpenAccesstoAllFolderRec(Trigger.New);   
    helper.OpenAccesstoAllRTeamRoomRec(Trigger.New);    
    }
       
}