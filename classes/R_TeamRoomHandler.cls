/*
Type Name: R_TeamRoomHandler Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 24-May-2017
Reason: This Handler class is handling the events of "R_TeamRoomTrigger" Triggers.
        
Change History:
Author: 
Modified Date: 
Reason: 
*/

Public Class R_TeamRoomHandler extends TriggerHandler{
  
   /*Global variable*/
   public R_TeamRoomHelper helper { get; set; }

 /*************************************************************************************************************************************************************
    @ Constructor:    R_TeamRoomHandler
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public R_TeamRoomHandler() {
        helper = new R_TeamRoomHelper();
    }
    
     /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        helper.OnTeamRoomCreationInsertFolder(Trigger.New);
        helper.OnTRCreationaddUserasMember(Trigger.New);
        helper.addCorrespondingTRAccount(Trigger.New);
    }
       
       
     /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/       
    public override void afterUpdate() {
      //  helper.addCorrespondingTRAccount(Trigger.New);   
    }   
}