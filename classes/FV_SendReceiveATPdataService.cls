/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 30/1/2015
*@ Description  :- #CR : Webservice class to send OT the user and account mapping.
*@ History    :- 
*/
global class FV_SendReceiveATPdataService {

  
    global class ImpersonationDataWrapper{
        webService String SFId;
        webService String UserShortname;
        webService String AccountsShortName;
        
        
    }
    
    public static List<ImpersonationDataWrapper> ImpersonationDataWrapperList;
    
    webService static List<ImpersonationDataWrapper> getUserAccInfo()
    {
    
    List<Internal_Impersonation_Mapping__c> listofInternalmapping=new List<Internal_Impersonation_Mapping__c>();
    listofInternalmapping=[Select  Id,
                                   Accounts_ShortName__c,
                                   User_Shortname__c,
                                   Sync_Needed__c,
                                   Sync_With_OpenText__c,
                                   OpenText_Error_Message__c 
                                   from Internal_Impersonation_Mapping__c
                                   where Sync_Needed__c =True limit 100];
                                   
     List<Internal_Impersonation_Mapping__c> listTobeupdated=new List<Internal_Impersonation_Mapping__c>();                         
     ImpersonationDataWrapperList =new List<ImpersonationDataWrapper>();
     for(Internal_Impersonation_Mapping__c obj : listofInternalmapping)
     {
      
      ImpersonationDataWrapper objData=new ImpersonationDataWrapper();
      objData.UserShortname=obj.User_Shortname__c;
      objData.AccountsShortName=obj.Accounts_ShortName__c;
      objData.SFId=obj.Id;
      ImpersonationDataWrapperList.add(objData);
      system.debug('ImpersonationDataWrapperList$$$'+ImpersonationDataWrapperList);
     }
     
     for(Internal_Impersonation_Mapping__c obj : listofInternalmapping)
     {
     
     obj.Sync_Needed__c =false;
     listTobeupdated.add(obj );
     }
     
     update listTobeupdated;
     return ImpersonationDataWrapperList;
    }
    global class OtStatusWrapper{

        webservice String SFId;             
        webservice Boolean SyncwthOT;
        webservice String OTErrorMsg;

    }
    webService static List<String> updateSyncwithOTStatus(List<OtStatusWrapper> otStatusLst)
    {
    List<String> retValList = new List<String>() ;
          
    List<Internal_Impersonation_Mapping__c> listReceivedfromOT=new List<Internal_Impersonation_Mapping__c>();
    
    List<Internal_Impersonation_Mapping__c> listTobeUpdated=new List<Internal_Impersonation_Mapping__c>();
    
    Map<String,Boolean> mapofSFIdandSyncFlag=new Map<String,Boolean>();
    
    Map<String,String> mapofSFIdandErrorMsg=new Map<String,String>();
   
    Set<String> SetofSFDCIds=new Set<String>();
    if(otStatusLst!=null && otStatusLst.size()>0)
    {
        for(OtStatusWrapper obj :otStatusLst)
        {
         SetofSFDCIds.add(obj.SFId);
         mapofSFIdandSyncFlag.put(obj.SFId,obj.SyncwthOT);
         mapofSFIdandErrorMsg.put(obj.SFId,obj.OTErrorMsg);
         }
    }
    
    system.debug('SetofSFDCIds$$$'+SetofSFDCIds);
    system.debug('MapofSFIdandSyncFlag$$$'+MapofSFIdandSyncFlag);
    system.debug('MapofSFIdandErrorMsg$$$'+MapofSFIdandErrorMsg);
    
    listReceivedfromOT=[Select id,
                               OpenText_Error_Message__c,
                               Sync_With_OpenText__c 
                               from Internal_Impersonation_Mapping__c 
                               where Id In:SetofSFDCIds];
    
    system.debug('MapofSFIdanlistReceivedfromOTErrorMsg$$$'+listReceivedfromOT);
    
    if(listReceivedfromOT!=null && listReceivedfromOT.size()>0)
    {
        for(Internal_Impersonation_Mapping__c obj :listReceivedfromOT)
        {                         
           if(MapofSFIdandSyncFlag.containskey(obj.Id))
           {
           obj.Sync_With_OpenText__c =mapofSFIdandSyncFlag.get(obj.Id);
           obj.OpenText_Error_Message__c=mapofSFIdandErrorMsg.get(obj.Id);
           listTobeUpdated.add(obj);
           }
           
        }
        
    system.debug('listTobeUpdated$$$'+listTobeUpdated);
    /*if(listTobeUpdated!=null && listTobeUpdated.size()>0)
       {
        try{
          update listTobeUpdated;
                 
          }
       catch (Exception e)
          {
          system.debug('Exception :: '+e.getMessage());
          }
        }*/
        
        Database.UpsertResult[] db_upsert_res = Database.upsert(listTobeUpdated, Internal_Impersonation_Mapping__c.Fields.ID,   FALSE) ; 
        Integer pointerInt = 0 ; 
        for(Database.UpsertResult er : db_upsert_res)
        { 
            String retMsg = '' ; 
          
           if(er.isSuccess())
           {
           retMsg = listTobeUpdated.get(pointerInt).Id + ':Success:'+er.getId() ;  
           system.debug('retMsg if$$$'+retMsg );
           }
           else
           {
           retMsg = listTobeUpdated.get(pointerInt).Id + ':Error:'+er.getId() ;  
           system.debug('retMsg else$$$'+retMsg);
           }
           
           if(retMsg!=null && retMsg.trim()!='')
           {
             retValList.add(retMsg) ;
             system.debug('retValList$$$'+retValList);
           }                       
             pointerInt++ ;   
           
        }       
      
    }
    
    else
    {
            retValList.add('No Data Received From Source.');
    }
    system.debug('retValListfinal$$$'+retValList);
     return retValList;
    }
        
    
  }