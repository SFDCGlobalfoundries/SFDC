/*    
* Author       :  Cognizant Technologies PTE Ltd
* Company      :  Cognizant Technologies PTE Ltd
* Description  :  ROS_FABUserTrigger trigger control
* History      :
    Initials        Date            Description
-----------------------------------------------------------------------------------------
    CTS                             Created
    NJain          09-Oct-14        Moved logic in helper class, Inserting member to Litho Group on Fab User insert
*/

trigger ROS_FABUserTrigger on Fab_User__c (before insert,after insert,after delete,before update, after update){

    if((ROS_Triggers_Bypass__c.getInstance('ROS_FABUserTrigger').Username__c == NULL) ||
       (UserInfo.getUserName() != ROS_Triggers_Bypass__c.getInstance('ROS_FABUserTrigger').Username__c)){
       
        Set<Id> SUserIds=new Set<Id>();
        
        //++ Before Insert Logic
        if(Trigger.isBefore && Trigger.IsInsert){
            ROS_FABUserTriggerHelper.FabUserBeforeInsert(Trigger.New);
        }
        //-- Before Insert Logic
        
        //++ After Insert Logic
        if(Trigger.isAfter && Trigger.IsInsert){
            ROS_FABUserTriggerHelper.FabUserAfterInsert(Trigger.New);
        }
        //-- After Insert Logic
                
        //++ After Delete Logic
        if(Trigger.isAfter && Trigger.IsDelete){
            ROS_FABUserTriggerHelper.FabUserAfterDelete(Trigger.Old);
        }
        //-- After Delete Logic
        
        //++ After Update Logic
        if(Trigger.isAfter && Trigger.IsUpdate){
            ROS_FABUserTriggerHelper.FabUserAfterUpdate(Trigger.New,Trigger.OldMap);
        }
        //-- After Update Logic
    }
    
}