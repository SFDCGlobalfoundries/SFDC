/*************************************************************************************************************************************************************
@ Class:          InternalImpMapp_TriggerHelper
@ Version:        1.0
@ Author:         Sandesh Singh
@ Purpose:        Helper class which consist of logics used in InternalImpersonationMapping Triggers.
@ History:        Sandesh: filterOldAndNewIIMOnUpdate() method added to Case:  00087342 &  00086933
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.08.2017 / Sandesh Singh / Created the class.
**************************************************************************************************************************************************************/
public class InternalImpMapp_TriggerHelper {
    private List<Merit__Share> maritShares;
    private Set<String> accShortNames;
    private Map<String,Set<String>> userAccMap;
    private Map<Id,Merit__c> mertis;
    private Map<String,List<Merit__C>> mapAccShortMerits;
    private List<sObject> objects;
    private List<Id> lstUserIds;
    private static boolean run = true;
    private List<Internal_Impersonation_Mapping__c> newListTemp;
    private List<Internal_Impersonation_Mapping__c> oldListTemp;
    
    public InternalImpMapp_TriggerHelper(){
        maritShares = new List<Merit__Share>();
    }
 
    /**
    * @description insertMeritIndexAccess method to assiged Impernation Users sharing access to Merit Index object.
    * @param List<Internal_Impersonation_Mapping__c> newImpMapps
    * @return None
    */
    public void insertMeritIndexAccess(List<Internal_Impersonation_Mapping__c> newImpMapps){
        if(!newImpMapps.isEmpty()){
            accShortNames(newImpMapps);
            getActiveUsers();
            maritShares = getShareMerits(getMerits());
            try{
                //check empty record and recurcive calling 
                if(!maritShares.isEmpty()){
                  objects = new List<sObject>();
                  //retrieving List of "Merit_share" and "Customer_satifaction_Improvment_Share" objects 
                  objects.addAll((List<sObject>)maritShares);
                  //DML insert operation on share objects
                  DataBase.SaveResult[] cusImpSaveResult = Database.insert(objects,false); 
                }
            }
           catch(System.DmlException e){
                for(Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    GlobalUtility.logMessage('Error','InternalImpMapp_TriggerHelper','assignCustomerSatAccess','',e.getDmlMessage(i),String.valueof(e.getMessage()),'','Customer Satisfaction',e,0);
                    System.debug(e.getDmlMessage(i)); 
                }
      }
        }
    }
    
    
    /**
    * @description filterOldAndNewIIMOnUpdate method to filter Impersination records if account short name changes while updating.
    * @param List<Internal_Impersonation_Mapping__c> newImpMapps,List<Internal_Impersonation_Mapping__c> oldImpMapps 
    * @return None
    */
    private void filterOldAndNewIIMOnUpdate(List<Internal_Impersonation_Mapping__c> newList, List<Internal_Impersonation_Mapping__c> oldList){
       newListTemp = new List<Internal_Impersonation_Mapping__c>();
       oldListTemp = new List<Internal_Impersonation_Mapping__c>();  
       Map<String,Internal_Impersonation_Mapping__c> oldMapTemp = new Map<String,Internal_Impersonation_Mapping__c>();
       Map<String,Internal_Impersonation_Mapping__c> newMapTemp = new Map<String,Internal_Impersonation_Mapping__c>();  
       Map<String,Internal_Impersonation_Mapping__c> oldMapIdKey = new Map<String,Internal_Impersonation_Mapping__c>();  
       
       for(Internal_Impersonation_Mapping__c iimpNew : newList){
         newMapTemp.put(iimpNew.Id +'_' +iimpNew.Accounts_ShortName__c, iimpNew);                                     
       }                                      
        
       for(Internal_Impersonation_Mapping__c iimpOld : oldList){
         oldMapTemp.put(iimpOld.Id +'_' +iimpOld.Accounts_ShortName__c, iimpOld);
         oldMapIdKey.put(iimpOld.Id, iimpOld);
       }  
                                            
      for(String mapKey : newMapTemp.keySet()){
          if(!oldMapTemp.containsKey(mapKey)){
              Internal_Impersonation_Mapping__c iim = newMapTemp.get(mapKey);
              newListTemp.add(iim);
              oldListTemp.add(oldMapIdKey.get(iim.Id));
          }                                     
      }  
    
   }
     
    /**
    * @description updateMeritIndexAccess method to update Impernation Users sharing access to Merit Index object.
    * @param List<Internal_Impersonation_Mapping__c> newImpMapps,List<Internal_Impersonation_Mapping__c> oldImpMapps 
    * @return None
    */
    public void updateMeritIndexAccess(List<Internal_Impersonation_Mapping__c> newImpMapps,
                                        List<Internal_Impersonation_Mapping__c> oldImpMapps ){
        
        filterOldAndNewIIMOnUpdate(newImpMapps,oldImpMapps);
        newImpMapps = newListTemp;
        oldImpMapps = oldListTemp;   
                    
        //check empty record and recurcive calling                                    
        if(!oldImpMapps.isEmpty() && !newImpMapps.isEmpty()){
                accShortNames(oldImpMapps);
                getActiveUsers();
                getMerits();
                //delete all record
                deleteATPSharingFromMerit();  
                //Assign access again
                accShortNames(newImpMapps);
                insertMeritIndexAccess(newImpMapps);
        }
    }
    
    /**
    * @description getActiveUsers method to fetch active user
    * @param None
    * @return Map<String,User>: Key:UserSort Name Value:User record
    */
    private Map<String,User> getActiveUsers(){
        lstUserIds = new List<Id>();
        Map<String,User> mapUserShortNMUser = new Map<String,User>();
        if(!userAccMap.isEmpty()){
          for(User user : [Select Id, Name, HCM_Login_ID__c From User Where HCM_Login_ID__c IN:userAccMap.keySet()]){
            mapUserShortNMUser.put(user.HCM_Login_ID__c, user);
            lstUserIds.add(user.Id);
          }  
        }
        return mapUserShortNMUser;
    } 
    
    /**
    * @description accShortNames method create list of account which use for impersination
    * @param: List<Internal_Impersonation_Mapping__c> intImpMapps
    * @return: Map<String,Set<String>> Key:userShortName Value:List of accountSort Name
    */
    private Map<String,Set<String>> accShortNames(List<Internal_Impersonation_Mapping__c> intImpMapps){

        userAccMap = new Map<String,Set<String>>();
        accShortNames =new Set<String>();
        
            for(Internal_Impersonation_Mapping__c intImpMapp: intImpMapps){
                Set<String> setAccShortName = new Set<String>();
                List<String> shortAccTemp = new  List<String>();
                if(intImpMapp.Accounts_ShortName__c !=null)
                  shortAccTemp = intImpMapp.Accounts_ShortName__c.Split(',');
                setAccShortName.addAll(shortAccTemp);
                accShortNames.addAll(shortAccTemp);
                userAccMap.put(intImpMapp.User_Shortname__c, setAccShortName);
            }
        
        return userAccMap;
    }
 
    /**
    * @description getMerits method fetch merit index based on selected account
    * @param: None
    * @return: Map<String, List<Merit__c>> Key:UserSortName, Value:list of Merit Index
    */
    private Map<String, List<Merit__c>> getMerits(){
        mertis = new Map<Id,Merit__c>();
        Map<String, List<Merit__c>> mapMerits = new Map<String, List<Merit__c>>();
        mertis = new Map<Id,Merit__c>([Select Id, Name, Account__c, Account__r.Short_Name__c From Merit__c Where Account__r.Short_Name__c IN:accShortNames]);
       
        if(!mertis.isEmpty()){
            for(String userShortName :userAccMap.keySet()){
                for(Merit__c merit :mertis.values()){
                    if(!mapMerits.containsKey(userShortName)){
                        mapMerits.put(userShortName,new List<Merit__c>{merit});
                  }
                    else{
                       mapMerits.get(userShortName).add(merit); 
                    }
                    mertis.put(merit.Id,merit);
              }
          }
      }
        return mapMerits;
    }
    
   
  /**
    * @description getShareMerits method to recieve input as a list of merit object and return list of merit share object
    * @param List<Merit__c> merits
    * @return List<Merit__Share>
    */
    private List<Merit__Share> getShareMerits(Map<String, List<Merit__c>> mapShortAccMerits){
        List<Merit__Share> maritShares = new List<Merit__Share>();
        Map<String,User> mapUsers = new Map<String,User>(); 
        mapUsers = getActiveUsers();
        for(String userShortName : mapUsers.keySet()){
                if(!mapShortAccMerits.isEmpty()){
                    for(Merit__c merit : mapShortAccMerits.get(userShortName)){
                         Merit__Share maritShare = new Merit__Share();
                        if(mapUsers.get(userShortName) != null){
                            maritShare = (Merit__Share)ApexSharingUtils.createCustomObjectShare(merit.Id, mapUsers.get(userShortName).Id, 'Read', 'Merit'); 
                           maritShare.RowCause = Schema.Merit__Share.RowCause.Manual;
                           maritShares.add(maritShare);
                        }
                }
          }
        }
        return maritShares;
    }

    
    private void deleteATPSharingFromMerit(){
        try{
            //logic to delete manual sharing for user
            List<Merit__Share> meritShares;
            objects = new List<sObject>();
            meritShares = [Select Id From Merit__Share WHERE UserOrGroupId IN :lstUserIds AND RowCause = 'Manual'];
            
            //validate empty check
            if(!meritShares.isEmpty()){
                Database.Delete(meritShares, false);
             } 
        }catch(System.DmlException e){
            for(Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                GlobalUtility.logMessage('Error','InternalImpMapp_TriggerHelper','assignCustomerSatAccess','',e.getDmlMessage(i),String.valueof(e.getMessage()),'','Customer Satisfaction',e,0);
                System.debug(e.getDmlMessage(i)); 
         }
        }
        
    }
    
}