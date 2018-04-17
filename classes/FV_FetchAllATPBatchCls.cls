/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 30/1/2015
*@ Description  :- #CR : Batch will execute after every 1 hr and it will process all Account Team proxy records which are updated every one hour
*@ History    :- 
*/


global class FV_FetchAllATPBatchCls implements Database.Batchable<sObject> {
  
  

  global Database.querylocator start(Database.BatchableContext BC){
  
  
   return Database.getQueryLocator([SELECT ID,
                                   Account__c,
                                   Time_Diff__c,
                                   Account_Access__c,
                                   Account_Short_Name__c,
                                   Account__r.Short_Name__c,
                                   Account__r.RecordType.Name,
                                   Account__r.Account_Present_In_OT__c,
                                   User__c,
                                   User__r.HCM_Login_ID__c
                             FROM  Account_Team_Proxy__c 
                             where User__r.HCM_Login_ID__c!=null 
                             and (Account__r.RecordType.Name='Customer' OR Account__r.RecordType.Name='Enablement Partner' OR Account__r.RecordType.Name='Reseller')
                             and Account__r.Account_Present_In_OT__c=true and Time_Diff__c<=1
                             ]);
 
       
    }

  // Execute Impersonation records
  global void execute(Database.BatchableContext BC, List<sObject> listOfATPRecordsfetched){
    
    Set<Id> SetofUserIds=new Set<Id>();
    Set<String> Setofusershortnames=new Set<String>();
    Set<String> SetofUsernotfound =new Set<String>();
    system.debug('getCurrentJobCount()$$$'+getCurrentJobCount());
    
    listOfATPRecordsfetched.addall(listOfATPRecordsfetched);//added
    
   /* if( getCurrentJobCount() < 1 )
    {
    listOfATPRecordsfetched.addall(listOfATPRecordsfetched);
    system.debug('enter if');
    }
    else 
    {
    system.debug('enter else');
    listOfATPRecordsfetched= [SELECT ID,
                                   Account__c,
                                   Time_Diff__c,
                                   Account_Access__c,
                                   Account_Short_Name__c,
                                   Account__r.Short_Name__c,
                                   Account__r.RecordType.Name,
                                   Account__r.Account_Present_In_OT__c,
                                   User__c,
                                   User__r.HCM_Login_ID__c
                             FROM  Account_Team_Proxy__c
                                WHERE Time_Diff__c<=1 and
                                User__r.HCM_Login_ID__c!=null 
                             and (Account__r.RecordType.Name='Customer' OR Account__r.RecordType.Name='Enablement Partner' OR Account__r.RecordType.Name='Reseller')
                             and Account__r.Account_Present_In_OT__c=true];
                                
    }*/
    
    system.debug('listOfATPRecordsfetched$$$'+listOfATPRecordsfetched);
    if(listOfATPRecordsfetched<>Null && !listOfATPRecordsfetched.isEmpty())
    {
     for(Account_Team_Proxy__c atpObj: (List<Account_Team_Proxy__c>) listOfATPRecordsfetched)
    {
    SetofUserIds.add(atpObj.User__c);
    Setofusershortnames.add(atpObj.User__r.HCM_Login_ID__c);
    }
    }
    
    system.debug('listOfATPRecordsfetched&&&'+listOfATPRecordsfetched);
    
    List<Account_Team_Proxy__c> listOfATPRecords=new List<Account_Team_Proxy__c>();
    listOfATPRecords=[SELECT   ID,
                               Account__c,
                               Time_Diff__c,
                               Account_Access__c,
                               Account_Short_Name__c,
                               Account__r.Short_Name__c,
                               Account__r.RecordType.Name,
                               Account__r.Account_Present_In_OT__c,
                               User__c,
                               User__r.HCM_Login_ID__c
                               FROM  Account_Team_Proxy__c
                               WHERE User__c In:SetofUserIds
                             ];
    system.debug('listOfATPRecords&&&'+listOfATPRecords);
    system.debug('Setofusershortnames&&&'+Setofusershortnames);
    
    List<Internal_Impersonation_Mapping__c> listofInternalmapping=new List<Internal_Impersonation_Mapping__c>();
     List<Internal_Impersonation_Mapping__c> lstofInternalrecInserted=new List<Internal_Impersonation_Mapping__c>();
     List<Internal_Impersonation_Mapping__c> lstofInternalrecModified=new List<Internal_Impersonation_Mapping__c>();
     
     if(Setofusershortnames!=null && !Setofusershortnames.isempty())
     {
         listofInternalmapping=[Select Accounts_ShortName__c,
                                       User_Shortname__c,
                                       Sync_Needed__c,
                                       OpenText_Error_Message__c 
                                       from Internal_Impersonation_Mapping__c
                                       where User_Shortname__c IN :Setofusershortnames];
         
     }   
     
      system.debug('listofInternalmapping&&&'+listofInternalmapping);
     Map<string,String> MapofUsernames=new Map<string,String>();
     
     if(listofInternalmapping!=null && !listofInternalmapping.isempty())
     {
         for(Internal_Impersonation_Mapping__c obj: listofInternalmapping)
         {
         MapofUsernames.put(obj.User_Shortname__c,obj.User_Shortname__c);
         }
     }
     
     system.debug('MapofUsernames&&&'+MapofUsernames); 
     
      if(listofInternalmapping!=null && !listofInternalmapping.isempty() && listOfATPRecords!=null && !listOfATPRecords.isempty())
     {
      for(Internal_Impersonation_Mapping__c obj: listofInternalmapping)
          {
          string str=null;
          
          for(Account_Team_Proxy__c atpObj: listOfATPRecords)
          {
           if(MapofUsernames.containskey(atpObj.User__r.HCM_Login_ID__c))// if user exist
           {
               if(obj.User_Shortname__c==atpObj.User__r.HCM_Login_ID__c && atpObj.Account_Access__c=='Read/Write' && atpObj.Account__r.Account_Present_In_OT__c==True && (atpObj.Account__r.RecordType.Name=='Customer' || atpObj.Account__r.RecordType.Name=='Enablement Partner' || atpObj.Account__r.RecordType.Name=='Reseller'))
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
            }
            else // if user does exist
            {
            system.debug('enter else%%%');
            SetofUsernotfound.add(atpObj.User__r.HCM_Login_ID__c);
            }
           
            }
            //Modified the existing impersonation records
             obj.Accounts_ShortName__c=str;
             obj.Sync_Needed__c =true;
             lstofInternalrecModified.add(obj);
         }
     }
     else if(listofInternalmapping.size()==0)//if no records in impersonation table
     {
     system.debug('enter else'); 
     SetofUsernotfound.addall(Setofusershortnames);
     
     }
     
     system.debug('SetofUsernotfound&&&'+SetofUsernotfound); 
     
     List<user> lstuser=new List<user>();
     if(SetofUsernotfound!=null && !SetofUsernotfound.isempty())
     {
     lstuser=[Select Id,HCM_Login_ID__c from User where HCM_Login_ID__c  In: SetofUsernotfound];
     
     system.debug('lstuser&&&'+lstuser); 
     for(User userobj: lstuser)
     {
      string str=null;
     for(Account_Team_Proxy__c atpObj: listOfATPRecords)
          {
             if(userobj.HCM_Login_ID__c==atpObj.User__r.HCM_Login_ID__c && atpObj.Account_Access__c=='Read/Write' && atpObj.Account__r.Account_Present_In_OT__c==True && (atpObj.Account__r.RecordType.Name=='Customer' || atpObj.Account__r.RecordType.Name=='Enablement Partner' || atpObj.Account__r.RecordType.Name=='Reseller'))
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
            
             
            }
             Internal_Impersonation_Mapping__c obj=new Internal_Impersonation_Mapping__c();
             obj.User_Shortname__c=userobj.HCM_Login_ID__c;
             obj.Accounts_ShortName__c=str;
             obj.Sync_Needed__c =True;
             
            lstofInternalrecInserted.add(obj); 
          
       }
      }                         
      system.debug('lstofInternalrecInserted&&&'+lstofInternalrecInserted);
     
     system.debug('lstofInternalrecModified&&&'+lstofInternalrecModified);
     
     
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
        }  
   } 
   
  /* Public void scheduleBatch()
   {
    String CRON_EXP = System.Label.CRON_EXP_Value;
    system.schedule('Hourly Job to update UserAccountMapping Table', CRON_EXP, new FV_FetchAllATPBatchCls());
   
   } 
   global void execute(SchedulableContext SC) 
   {   
    Database.executeBatch(new FV_FetchAllATPBatchCls(),25); 
    //scheduleBatch();
   }*/
  
  
  global void finish(Database.BatchableContext BC){
    
  }
  
  private static Integer getCurrentJobCount()
   {
    return (Integer)[Select count() 
                         From  AsyncApexJob 
                         Where JobType = 'BatchApex' 
                         and   ApexClass.Name = 'FV_FetchAllATPBatchCls' 
                         and   (Status = 'Processing' or Status = 'Preparing') limit 1];
        }
    
}