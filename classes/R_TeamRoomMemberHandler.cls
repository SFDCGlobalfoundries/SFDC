/* 
 Name: R_TeamRoomMemberHandler Class
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 11-07-2017
 Reason:  This Handler class is handling the events of R TeamRoom Triggers.
         
--*/
public Class R_TeamRoomMemberHandler extends TriggerHandler{

 
   /*Global variable*/
    public R_TeamRoomMemberHelper helper { get; set; }

    /*************************************************************************************************************************************************************
    @ Constructor:    R_TeamRoomMemberHandler
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public R_TeamRoomMemberHandler() {
        helper = new R_TeamRoomMemberHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        helper.CreateTeamRoomShare(Trigger.New);
        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterdelete
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after delete event.
    **********************************************************************************************************************************************************/     
    public override void afterdelete() {
        helper.DeleteTeamRoomShare(Trigger.Old);
        
    }
  

}