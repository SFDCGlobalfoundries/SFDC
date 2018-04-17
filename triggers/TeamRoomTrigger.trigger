/*
Type Name: TeamRoomTrigger Trigger
Author: Cognizant 
Created Date: 16-May-2013
Reason: The trigger will call the method setTeamRoomOwner of the trigger handler class ClsTeamRoomTriggerHandler
        to update owner of Team Room.
        The trigger will also call the method addCorresAccount of the trigger handler lass ClsTeamRoomTriggerHandler
        to add Team Room account to the Team Room.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/


trigger TeamRoomTrigger on Team_Room__c (after insert, after update) 
{
  
   if(trigger.isInsert){
       List<Team_Room__c> teamroomList=new List<Team_Room__c>();
       List<Team_Room__c> totalteamroomList=new List<Team_Room__c>();
       
       List<Profile> profileList=new List<Profile>();
       List<Id> profileIdList=new List<Id>();
       Set<Id> teamroomIds = new Set<Id>();   
       RecordType r = [select id,Name from RecordType where name='Pre FV2 Teamroom'];
       for (Team_Room__c trObj : trigger.new)
       {
           if(trObj.RecordTypeId != r.id )
               teamroomIds.add(trObj.Id);
       }

    //fetching the list of customer portal profiles 
    //Modified by Sunil Arora for Case # 10023 to add OverageCustomerPortalProfile  
       profileList=[Select Id,
                           Name
                           from Profile 
                           where Name=:System.Label.CustomerPortalAdmin 
                           OR Name=:System.Label.CustomerPortalProfile 
                           OR Name=:System.Label.OverageCustomerPortalAdmin
                           OR Name=:System.Label.OverageCustomerPortalProfile
                            OR Name=:System.Label.OverageSupplierPortalProfile
                           OR Name=:System.Label.OverageSupplierPortalAdmin
                            OR Name=:System.Label.OverageResellerPortalProfile
                           OR Name=:System.Label.OverageResellerPortalAdmin
                            OR Name=:System.Label.OverageEnablementPartnerPortalProfile
                           OR Name=:System.Label.OverageEnablementPartnerPortalAdmin
                           OR Name=:System.Label.EnablementPartnerPortalAdmin
                           OR Name=:System.Label.EnablementPartnerPortalProfile
                           OR Name=:System.Label.ResellerPortalAdmin
                           OR Name=:System.Label.ResellerPortalProfile
                           OR Name=:System.Label.SupplierPortalAdmin
                           OR Name=:System.Label.SupplierPortalProfile];
       
     //fetching the profile ids of the customer portal profiles
       for(Profile profileObj:profileList)
       {
        profileIdList.add(profileObj.Id);
       }
    //fetching the list of Team room craeted by customer portal users   
       totalteamroomList=[SELECT  Id,
                             Name,
                             OwnerId,
                             Owner.Isactive,
                             Num_Associated_Accs__c,
                             CreatedBy.ProfileId,
                             CreatedBy.AccountId,
                             Createdby.Isactive,
                             Primary_Account__c 
                             FROM Team_Room__c 
                             where Id in: teamroomIds    
                     ];
       system.debug('@@@totalteamroomList'+totalteamroomList);
       teamroomList=[SELECT  Id,
                             Name,
                             Owner.Isactive,
                             OwnerId,
                             Num_Associated_Accs__c,
                             CreatedBy.ProfileId,
                             CreatedBy.AccountId,
                             Createdby.Isactive,
                             Primary_Account__c 
                             FROM Team_Room__c 
                             where Id in: teamroomIds    
                     ];

    //calling the methods setTeamRoomOwner and  addCorresAccount of the class clsTeamRoomTriggerHandler                    
         if(teamroomList.size()>0)
         {
          //ClsTeamRoomTriggerHandler.setTeamRoomOwner(teamroomList);
          ClsTeamRoomTriggerHandler.addCorresAccount(teamroomList,profileIdList);
          
         }
        if(totalteamroomList.size()>0)
         {
          
          ClsTeamRoomTriggerHandler.setTeamRoomOwner(totalteamroomList);
          
         }
    }
    //Code added by Sunil for case # 27650
    if(trigger.isUpdate){ 
        Set<Id> allTeamRoomIds = new Set<Id>(); //set added by Sunil Arora for case # 27650
           for (Team_Room__c trObj : trigger.new)
            {
                allTeamRoomIds.add(trObj.Id);
            }
           
           Set<Id> teamRoomIdSet=new Set<Id>();
           Integer count=0;
           Profile ProfileRecord= [select Name from profile where id = :userinfo.getProfileId() Limit 1];
           String ProfileName=ProfileRecord.Name;
           Team_Room__c[] allTeamRoomRecordLst;
           if(!ProfileName.contains('Admin')){
                allTeamRoomRecordLst=[SELECT Id,Name,OwnerId,Owner.Isactive,(Select Id, User__c,Team_Room_Role__c From Team_Room_Members__r where Team_Room_Role__c='Moderator') FROM Team_Room__c where Id in: allTeamRoomIds]; 
                    for(Integer i=0;i<allTeamRoomRecordLst.size();i++){
                            if(userInfo.getUserId() !=allTeamRoomRecordLst[i].OwnerId){
                                if(allTeamRoomRecordLst[i].Team_Room_Members__r.size()>0){
                                    count=0;
                                    for(Integer j=0;j<allTeamRoomRecordLst[i].Team_Room_Members__r.size();j++){
                                        if(userInfo.getUserId()==allTeamRoomRecordLst[i].Team_Room_Members__r[j].User__c){
                                            count=1;
                                        }
                                    }
                                    if(count==0){
                                        teamRoomIdSet.add(allTeamRoomRecordLst[i].Id);
                                    }
                                }else{
                                    teamRoomIdSet.add(allTeamRoomRecordLst[i].Id);
                                
                                }
                            }
                    }

           } 
           for (Integer i=0;i<trigger.new.size();i++){
                if(teamRoomIdSet.contains(trigger.new[i].Id) && (trigger.new[i].Name!= trigger.old[i].Name || trigger.new[i].Team_Room_Description__c !=trigger.old[i].Team_Room_Description__c)){
                    trigger.new[i].addError('Team Room Name and description are only editable by admin profiles, owners and moderators');
                }
           
           }
           //Code end by Sunil
    
    
    }
}