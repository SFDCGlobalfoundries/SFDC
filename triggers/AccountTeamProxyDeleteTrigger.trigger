/*
Author: Zymark Ambat
Description: This Trigger handles the delete operation(s) on the Account Team Proxy object.
History: 
ZAmbat      04192013    - Code creation.
Vijay       02032015    - Added after delete event in trigger to revoke/remove the Internal Device access 
Author: Cognizant
Modified Date: 19-Feb-2015
Reason: Case31836 - To modify the impersonation table when ATP records are deleted
      
*/

trigger AccountTeamProxyDeleteTrigger on Account_Team_Proxy__c (before delete, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            DeletedRecordsManager.insertRecords(Trigger.old, EnvironmentVariable.get('ACCT_TEAM_PROXY_ENTITY'));
            
        /*-------------------added for Case 31836 Start------------------------------------------------*/

              
              Set<Id> setUserIds= new Set<Id>();
              Set<Id> setATPdelIds= new Set<Id>();
             //fetching the list of users for which ATP records are deleted 
             for(Account_Team_Proxy__c atp :trigger.old)
              {
              setATPdelIds.add(atp.Id);
             
              }
              for(Account_Team_Proxy__c atp :trigger.old)
              {
              setUserIds.add(atp.User__c);
             
              }
              system.debug('SetUserIds$$$'+SetUserIds);
              system.debug('setATPdelIds$$$'+setATPdelIds);
              FV_UpdateImpersonationOnATPDelCls.updateUserAccMapping(setATPdelIds);
              
            /* system.debug('SetUserIds$$$'+SetUserIds);
             List<User> lstUser =[Select id,User.HCM_Login_ID__c from User where Id in :setUserIds];
             system.debug('lstuser $$$'+lstuser );
             List<Account_Team_Proxy__c > listofAllATP=new List<Account_Team_Proxy__c >();
             
             //fetching the list of all ATP records for the users fetched above
             listofAllATP=[Select id, 
                                   User__c,
                                   Account__c,
                                   User__r.HCM_Login_ID__c,
                                   Account__r.Short_Name__c,
                                   Account__r.Account_Present_In_OT__c,
                                   Account__r.RecordType.Name,
                                   Account_Access__c
                                   from Account_Team_Proxy__c where User__c in :setUserIds];
                                   
             system.debug('listofallATP $$$'+listofallATP);                      
             
             
             Map<String,String> mapofUserAccshortnames =new Map<String,String>();
                           
              if(listofAllATP!=null && !listofAllATP.isempty())
             { 
              for(Account_Team_Proxy__c atp :trigger.old)
              {
               
                 for(Account_Team_Proxy__c atpObj :listofallATP )
                 {
                  string str=null;
                  if(atp.user__c == atpObj.user__c && atpObj.Account_Access__c=='Read/Write' && atp.Id != atpObj.Id && atpObj.Account__r.Account_Present_In_OT__c==True && (atpObj.Account__r.RecordType.Name!='GLOBALFOUNDRIES Internal' || atpObj.Account__r.RecordType.Name!='Suppliers'))
                  {
                      if(str==null)
                      {
                      str=atpObj.Account__r.Short_Name__c;
                      }
                      else
                      {
                      str=str+','+atpObj.Account__r.Short_Name__c;
                      }
                   }
                mapofUserAccshortnames.put(atpObj.User__r.HCM_Login_ID__c,str);
                 }
               }
               
             }  
             
             system.debug('mapofUserAccshortnames$$$'+mapofUserAccshortnames);   
             
             List<Internal_Impersonation_Mapping__c> listofInternalMapping=new List<Internal_Impersonation_Mapping__c>();
             List<Internal_Impersonation_Mapping__c> lstofInternalrecInserted=new List<Internal_Impersonation_Mapping__c>();
             List<Internal_Impersonation_Mapping__c> lstofInternalrecModified=new List<Internal_Impersonation_Mapping__c>();
             
             if(mapofUserAccshortnames!=null && !mapofUserAccshortnames.isempty())
             {
                 listofInternalMapping=[Select Accounts_ShortName__c,
                                               User_Shortname__c,
                                               Sync_Needed__c,
                                               OpenText_Error_Message__c 
                                               from Internal_Impersonation_Mapping__c
                                               where User_Shortname__c IN :mapofUserAccshortnames.keyset()];
                 
              }   
              
              system.debug('listofInternalmapping$$$'+listofInternalmapping);   
          
              system.debug('enter$$$');   
             for(User userObj :lstUser)
              {
                  if(listofInternalmapping.size()==0)
                   {
                          Internal_Impersonation_Mapping__c obj=new Internal_Impersonation_Mapping__c();
                          obj.User_Shortname__c=userObj.HCM_Login_ID__c;
                          obj.Accounts_ShortName__c=mapofUserAccshortnames.get(userObj.HCM_Login_ID__c);
                          obj.Sync_Needed__c =True;
                          lstofInternalrecInserted.add(obj);
                          
                  }
                  else
                 {
                 system.debug('enter else$$$');   
                 for(Internal_Impersonation_Mapping__c obj :listofInternalmapping)
                        {
                          if(obj.User_Shortname__c==userObj.HCM_Login_ID__c)
                          {
                          system.debug('enter if$$$');   
                           obj.Accounts_ShortName__c=mapofUserAccshortnames.get(userObj.HCM_Login_ID__c);
                           obj.Sync_Needed__c =True;
                           lstofInternalrecModified.add(obj);
                           
                          }
                        } 
                  
                    }
                  
             }
             
             if(lstofInternalrecInserted!=null && lstofInternalrecInserted.size()>0)
               {
                try{
                  insert lstofInternalrecInserted;
                         
                  }
               catch (Exception e)
                  {
                  system.debug('Exception :: '+e.getMessage());
                  }
                }
                
               if(lstofInternalrecModified!=null && lstofInternalrecModified.size()>0)
               {
                try{
                  update lstofInternalrecModified;
                         
                  }
               catch (Exception e)
                  {
                  system.debug('Exception :: '+e.getMessage());
                  }
                }  */
            
        /*--------------------added for Case 31836 end-----------------------------------------------------*/
        }
    }else{
        if(Trigger.isDelete){
            ClsAccountTeamProxyTriggerHandler atpTriggerHandler =new ClsAccountTeamProxyTriggerHandler(Trigger.isExecuting, Trigger.size);
            atpTriggerHandler.OnAfterDelete(Trigger.old);
        }
    }
}