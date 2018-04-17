/*
Type Name: FV_IPDKTrigger Trigger
Author: Cognizant 
Created Date: 13-Nov-2014
Reason: Case 34665 - IPDK enhancement
Modified BY: Dinesh Suggala(Global FOundries)
Reason: Added a line to Call FV_IPDKTriggerHelper
……..
……..
*/

trigger FV_IPDKTrigger on IPDK_License_Information__c (before delete, before insert,before update,after insert)
{
if(!IntegrationUserUtil.isSkipTrigger()){
  boolean isDSGroup=false;
  SET<id> SetofUserId=new SET<id>();
  List<GroupMember> lstmember=[Select GroupId,
                                       UserOrGroupId 
                                       from GroupMember 
                                       where GroupId =:System.label.DS_Group_Id];
         
         system.debug('lstmember$$$'+lstmember);
       if(lstmember<>Null &&!lstmember.isEmpty())
       {
         for(GroupMember objmember:lstmember)
         {
          SetofUserId.add(objmember.UserOrGroupId);
         }
       } 
         
          system.debug('enter user1'+SetofUserId);
          system.debug('enter user2'+UserInfo.getUserId());
         if(SetofUserId<>Null &&!SetofUserId.isEmpty())
         { 
           if(!(SetofUserId.contains(UserInfo.getUserId())))
           {
           system.debug('enter else$$$');
           isDSGroup=false;
          
           }
           else
           {
           isDSGroup=true;
           }
         }  
   if(trigger.isinsert && trigger.isbefore)
   {
  // boolean isDSGroup=false;
   Set<Id> SetofSpecids=new Set<Id>();
   //List<Id> IPDKlist=new List<Id>();          //Added by Dinesh
   for(IPDK_License_Information__c obj: trigger.new)
   {
   
    SetofSpecids.add(obj.Specification__c);
   // IPDKlist.add(obj.Id);                     //Added by Dinesh
   }
   
   system.debug('SetofSpecids%%%%'+SetofSpecids);
   
   Set<Id> SetofaccId=new Set<Id>();
 
   List<IPDK_License_Information__c> lstIPLA=[Select id,
                                                     account__c,
                                                     Specification__c 
                                                     from IPDK_License_Information__c 
                                                     where Specification__c in:SetofSpecids];
                                                     
                                        
  
   if(lstIPLA<>Null &&!lstIPLA.isEmpty())
   { 
   for(IPDK_License_Information__c obj: lstIPLA)
   {
   SetofaccId.add(obj.account__c);
   }
   }
   system.debug('lstIPLA%%%%'+lstIPLA);
   system.debug('SetofaccId%%%%'+SetofaccId);
   
 
   
   List<Document_Provisioning__c> lstDp=[Select id,
                                                name,
                                                Design_spec__c,
                                                Account__c 
                                                from Document_Provisioning__c 
                                                where Design_spec__c in:SetofSpecids];
                                                
   List<Document_Provisioning__c> lstDpupdate=new List<Document_Provisioning__c>();
   for(IPDK_License_Information__c objipdk :trigger.new)
         {
         
             for(Document_Provisioning__c objdp :lstDp)
              {
                 if(objipdk.Specification__c==objDP.Design_spec__c && objipdk.Account__c==objDP.Account__c)
                 {
                  objDP.IPLA__c=true;
                  lstDpupdate.add(objDP);
                 }
                
              }    
          
     }
 
   update lstDpupdate;
   
   }
   
   //checkRecursive.runOnce() to run trigger only once
   if(trigger.isInsert && trigger.isAfter && checkRecursive.runOnce())
   {
   List<IPDK_License_Information__c> iplist=new List<IPDK_License_Information__c>();
   for(IPDK_License_Information__c ip:Trigger.New){
   iplist.add(ip);
   }
   FV_IPDKTriggerHelper.AATriggerEmailtoFAE(iplist); 
   }
/*------------------------insert code----------------------------------------------------------*/      
/*------------------------edit code----------------------------------------------------------*/   
   if(trigger.isupdate)
   {
   //boolean isDSGroup=false;
    Set<Id> SetofSpecids=new Set<Id>();
    Set<Id> setofaccids=new Set<Id>();

   for(IPDK_License_Information__c obj: trigger.new)
   {
    
    SetofSpecids.add(obj.Specification__c);

   }
   
    Set<Id> SetofaccId=new Set<Id>();
    set<id> triggerIds = trigger.newMap.keyset();

   List<IPDK_License_Information__c> lstofIPLAEdited=[Select id,
                                                     account__c,
                                                     Specification__c,
                                                     Specification__r.specification_type__c
                                                     from IPDK_License_Information__c 
                                                     where Id in:triggerIds];
                                                     

      
   List<IPDK_License_Information__c> lstIPLA=[Select id,
                                                     account__c,
                                                     Specification__c 
                                                     from IPDK_License_Information__c
                                                     where Specification__c in:SetofSpecids];
   
   for(IPDK_License_Information__c obj: lstIPLA)
   {
   SetofaccId.add(obj.account__c);
   }
   
  
   List<Document_Provisioning__c> lstDp=[Select id,
                                                name,
                                                Design_spec__c,Account__c 
                                                from Document_Provisioning__c 
                                                where Design_spec__c in:SetofSpecids];
                                                
   List<Document_Provisioning__c> lstDpupdate=new List<Document_Provisioning__c>();
   
   for(IPDK_License_Information__c objipdk :trigger.new)
   {
         if(isDSGroup==true)
         {
         
          system.debug('objipdk.Specification__r.specification_type__c%%'+objipdk.Specification__r.specification_type__c);
             
              if(SetofaccId.contains(objipdk.account__c)==false || Trigger.oldMap.get(objipdk.ID).Account__c==objipdk.Account__c)
                {
                   for(Document_Provisioning__c objdp :lstDp)
                      {
                          if(objipdk.Specification__c==objDP.Design_spec__c && objipdk.Account__c==objDP.Account__c)
                          {
                             objDP.IPLA__c=true;
                              lstDpupdate.add(objDP);
                          
                          }
                          
                          else if(objipdk.Specification__c==objDP.Design_spec__c && Trigger.oldMap.get(objipdk.ID).Account__c==objDP.Account__c)
                          {
                             objDP.IPLA__c=false;
                              lstDpupdate.add(objDP);
                          }
                     }
               }
               
               else
               {
                objipdk.adderror('Account already added.');
               }
             
          }
          else
          {
          objipdk.adderror('Only DS Group members are allowed to edit IPDK Licence Information record.');
          
          }  
   }
   
   update lstDpupdate;
   }
/*------------------------edit code----------------------------------------------------------*/      
/*--------------------------delete---------------------------------------------------*/   
   if(trigger.isdelete)
   {
   // boolean isDSGroup=false;
   Set<Id> SetofSpecids=new Set<id>();
  
       for(IPDK_License_Information__c obj: trigger.old)
       {
       
        SetofSpecids.add(obj.Specification__c);
        
       }
       
   
 List<Document_Provisioning__c> lstDp=[Select id,
                                              name,
                                              Design_spec__c,
                                              Account__c 
                                              from Document_Provisioning__c 
                                              where Design_spec__c in:SetofSpecids];
                                              
 List<Document_Provisioning__c> lstDpupdate=new List<Document_Provisioning__c>();
                                     
   for(IPDK_License_Information__c obj: trigger.old)
   {                              
        if(isDSGroup==true)
         {
           for(Document_Provisioning__c objdp :lstDp)
           {       
              if(obj.Specification__c==objDP.Design_spec__c && obj.Account__c==objDP.Account__c)
              {
                 objDP.IPLA__c=false;
                  lstDpupdate.add(objDP);
              }
            }

         }
        else
        {
         obj.adderror('Only DS Group members are allowed to del IPDK Licence Information record.');
           
        }  
   }    
   
   update   lstDpupdate;                      

  }
}
}