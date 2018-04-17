/* 
 Name: R_TeamRoomAccountHandler Class
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 11-07-2017
 Reason:  This Handler class is handling the events of R TeamRoomAccount Triggers.
         
--*/
public Class R_TeamRoomAccountHandler extends TriggerHandler{

 
   /*Global variable*/
    public R_TeamRoomAccoountHelper helper { get; set; }

    /*************************************************************************************************************************************************************
    @ Constructor:    R_TeamRoomMemberHandler
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public R_TeamRoomAccountHandler() {
        helper = new R_TeamRoomAccoountHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Dinesh Suggala (manikanthdinesh.suggala@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after before event
    **********************************************************************************************************************************************************/     
    public override void beforedelete() {
        helper.OndeletingAccDeleteMembersaAndShares(Trigger.Old);
        
    }
    
   
  

}