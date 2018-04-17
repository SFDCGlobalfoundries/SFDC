/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 30/1/2015
*@ Description  :- #CR : 
*@ History    :- 
*/
public class FV_UpdateImpersonationOnATPDelCls
 {
   public static void updateUserAccMapping(set<id> setATPdelIds)
   {
    Set<Id> setofUserIds=new Set<Id>();
    Set<String> setofUsershortnames=new Set<String>();
    
    system.debug('setATPdelIds$$$'+setATPdelIds);
    Map<String,String> mapofUserAccshortnames =new Map<String,String>();
    List<Account_Team_Proxy__c> listOfATPRecordsdel=new List<Account_Team_Proxy__c>();
    List<Account_Team_Proxy__c> listOfATPRecords=new List<Account_Team_Proxy__c>();
     listOfATPRecordsdel=[Select  id, 
                           User__c,
                           Account__c,
                           User__r.HCM_Login_ID__c,
                           Account__r.Short_Name__c,
                           Account__r.Account_Present_In_OT__c,
                           Account__r.RecordType.Name,
                           Account_Access__c
                           from Account_Team_Proxy__c where Id in :setATPdelIds];
                           
      if(listOfATPRecordsdel<>Null && !listOfATPRecordsdel.isEmpty())
    {
         for(Account_Team_Proxy__c atpObj: listOfATPRecordsdel)
        {
        
        setofUsershortnames.add(atpObj.User__r.HCM_Login_ID__c);
        setofUserIds.add(atpObj.User__c);
        
         
        }
    }                      
     system.debug('setofUsershortnames$$$'+setofUsershortnames);   
     system.debug('setofUserIds$$$'+setofUserIds);
                           
     listOfATPRecords=[Select  id, 
                           User__c,
                           Account__c,
                           User__r.HCM_Login_ID__c,
                           Account__r.Short_Name__c,
                           Account__r.Account_Present_In_OT__c,
                           Account__r.RecordType.Name,
                           Account_Access__c
                           from Account_Team_Proxy__c where User__c in :setofUserIds];
     
   List<Internal_Impersonation_Mapping__c> listofInternalmapping=new List<Internal_Impersonation_Mapping__c>();
   List<Internal_Impersonation_Mapping__c> lstofInternalrecInserted=new List<Internal_Impersonation_Mapping__c>();
   List<Internal_Impersonation_Mapping__c> lstofInternalrecModified=new List<Internal_Impersonation_Mapping__c>();
   
   system.debug('listOfATPRecords$$$'+listOfATPRecords);
   //fetching the list of  all Impersonation records 
     if(Setofusershortnames!=null && !Setofusershortnames.isempty())
     {
         listofInternalmapping=[Select Accounts_ShortName__c,
                                       User_Shortname__c,
                                       Sync_Needed__c,
                                       OpenText_Error_Message__c 
                                       from Internal_Impersonation_Mapping__c
                                       where User_Shortname__c IN :setofUsershortnames];
         
     }  
     
     system.debug('listofInternalmapping$$$'+listofInternalmapping); 
     //preparing the account shortname list for all the Users fetched in the impersonation table
      if(listofInternalmapping!=null && !listofInternalmapping.isempty() && listOfATPRecords!=null && !listOfATPRecords.isempty())
     {
      for(Internal_Impersonation_Mapping__c obj: listofInternalmapping)
          {
          string str=null;
          
            for(Account_Team_Proxy__c atpObj :listOfATPRecords)
            {
               if(!setATPdelIds.contains(atpObj.Id) && obj.User_Shortname__c==atpObj.User__r.HCM_Login_ID__c && atpObj.Account_Access__c=='Read/Write' && atpObj.Account__r.Account_Present_In_OT__c==True && (atpObj.Account__r.RecordType.Name=='Customer' || atpObj.Account__r.RecordType.Name=='Enablement Partner' || atpObj.Account__r.RecordType.Name=='Reseller'))
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
           
             obj.Accounts_ShortName__c=str;
             obj.Sync_Needed__c=True;
             lstofInternalrecModified.add(obj);
         }
     }
      
      system.debug('lstofInternalrecModified$$$'+lstofInternalrecModified); 
    
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
 
 }