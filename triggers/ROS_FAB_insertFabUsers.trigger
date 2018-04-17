/*    
* Author       :  Cognizant Technologies PTE Ltd
* Company      :  Cognizant Technologies PTE Ltd.
* Description  :  ROS_FAB_insertFabUsers trigger control. 
                  When record inserted from Data warehouse find the Fab user from Account Team Proxy
* History      :
    Initials        Date              Description
-----------------------------------------------------------------------------------------
    CTS                               Created
    CTS             30-May-14         Added the condition to run only in case of After Triggers
*/

trigger ROS_FAB_insertFabUsers on FAB__c (after insert,after update,before insert,
                                            before update,after delete,after undelete){
    if((ROS_Triggers_Bypass__c.getInstance('ROS_Fab_insertFabUsers_Trigger') != NULL && 
        ROS_Triggers_Bypass__c.getInstance('ROS_Fab_insertFabUsers_Trigger').Username__c==NULL)||
       (ROS_Triggers_Bypass__c.getInstance('ROS_Fab_insertFabUsers_Trigger') != NULL &&
        UserInfo.getUserName()!=ROS_Triggers_Bypass__c.getInstance('ROS_Fab_insertFabUsers_Trigger').Username__c))
    {
        String Fablist='';
        if((Trigger.IsInsert || Trigger.IsUpdate) && Trigger.isAfter){
            try{
                for(Fab__c fabtemp : Trigger.new){
                    Fablist = Fablist + ';'+ fabtemp.name;
                }
                if(Fablist != NULL && Fablist.startswith(';')){
                    Fablist = Fablist.substring(1,Fablist.length());
                }
                
                List<User> FabUserList = new List<User>([SELECT id,Fab_Assigned__c 
                                                         FROM USER
                                                         WHERE Fab_Assigned__c INCLUDES (:Fablist) and IsActive = True]);
                                
                List<Fab__c> LMasterFabs = [SELECT Id,Name FROM Fab__c LIMIT 50000];
                
                Map<String,Id> MFabUser = new Map<String,Id>{};
                
                for(Fab__c temp : LMasterFabs){
                    MFabUser.put(temp.name,temp.id);
                }
                
                List<Fab_User__c> LFabUserfinal=new List<Fab_User__c>();

                for(Fab__c fabtemp : Trigger.new){
                    for(User u : FabUserlist){
                        If(u.Fab_Assigned__c.contains(fabtemp.name)){
                            Fab_user__c temp= new Fab_user__c(Fab__c=MfabUser.get(fabtemp.name),User__c=u.id,Is_ROS_User__c = True);
                            LFabUserfinal.add(temp);
                        }
                    }
                }
                if(!LFabUserfinal.IsEmpty()){
                    Database.SaveResult[] Lr = database.insert(LFabUserfinal);
                }
            }catch(exception ex){
                ROS_Util.insertException(ex,'ROS_FAB_insertFabUsers-Trigger','ROS');
            }
        }
    }
}