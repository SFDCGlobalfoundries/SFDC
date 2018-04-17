/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 30/1/2015
*@ Description  :- #CR : 31836 - to modify the impersonation table when Account_Present_In_OT__c is changed from false to true or vice versa
*@ History    :- 
*/
public class FV_AccountUpdateCls
 {
  public static void updateUserAccMapping(set<id> setofAccId)
   {
  system.debug('SetofaccId$$$'+SetofaccId);
    Set<Id> setofUserIds=new Set<Id>();
    Set<String> setofUsershortnames=new Set<String>();
    
    Map<String,String> mapofUserAccshortnames =new Map<String,String>();
    List<Account_Team_Proxy__c> listofATPforThisacc=new List<Account_Team_Proxy__c>();
    List<Account_Team_Proxy__c> listOfATPRecords=new List<Account_Team_Proxy__c>();
    
    //fetching the list of ATP records for the accounts Ot flag changed
    listofATPforThisacc=[Select  id, 
                           User__c,
                           Account__c,
                           User__r.HCM_Login_ID__c,
                           Account__r.Short_Name__c,
                           Account__r.Account_Present_In_OT__c,
                           Account__r.RecordType.Name,
                           Account_Access__c
                           from Account_Team_Proxy__c where Account__c in :setofAccId and Account_Access__c='Read/Write'];
                           
   system.debug('listOfATPRecords$$$'+listOfATPRecords);
   if(listofATPforThisacc<>Null && !listofATPforThisacc.isEmpty())
    {
     for(Account_Team_Proxy__c atpObj: listofATPforThisacc)
    {
    setofUserIds.add(atpObj.User__c);
    
    setofUsershortnames.add(atpObj.User__r.HCM_Login_ID__c);
   
     
    }
    }
    
    //fetching the list of  all ATP records for the users whose ATP records are fetched above
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
     //preparing the account shortname list for all the Users fetched in the impersonation table
      if(listofInternalmapping!=null && !listofInternalmapping.isempty() && listOfATPRecords!=null && !listOfATPRecords.isempty())
     {
      for(Internal_Impersonation_Mapping__c obj: listofInternalmapping)
          {
          string str=null;
          for(Account_Team_Proxy__c atpObj: listOfATPRecords)
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
             obj.Accounts_ShortName__c=str;
             obj.Sync_Needed__c=true;
             lstofInternalrecModified.add(obj);
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
 
 }