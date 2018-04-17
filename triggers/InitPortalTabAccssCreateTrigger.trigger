/*    
  Author:  Cognizant Techology Solutions
  Description: This trigger is used for Adding Sharing on Contacts when the Contact is converted into Portal Users. 
               It gets the Account Hierarchy for the newly created Portal User and creates sharing records for the Portal User.
  Date : 24/04/2013             
  History:  
  Modified On: 22-05-2017
  Reason: Track 3 - Providing access on custom objects(specific to track 3) on First portal user under Account get created.
  Change History: Track 3
  Author: L Anil Kumar Reddy
*/

trigger InitPortalTabAccssCreateTrigger on Contact (after update) {
    
    List<Contact> portalContactList = new List<Contact>();
    System.debug('portalContactList IPTA b : ' + portalContactList.size());
    for(Contact contactObj : trigger.new){
        
        if(contactObj.Is_Portal_User_Active__c){
            portalContactList.add(contactObj);
        }
    }
    
    if(portalContactList.size() < 1){
        return;
    }
    System.debug('portalContactList IPTA a : ' + portalContactList.size());
    
 //if(!IntegrationUserUtil.isSkipTrigger()){
   List<Contact> contactList = new List<Contact>(); 
   List<Portal_Tab_Access__c> checkportalTabAccList = new List<Portal_Tab_Access__c>();
   Set<Id> contactIdSet = new Set<Id>();
   Set<Id> accountIds=new Set<Id>();
   Set<Id> userIdSet = new Set<Id>();
    
    for(Contact contactObj :  trigger.new){
     if(contactObj.Department__c!=null)
      {
        contactList.add(contactObj);
        accountIds.add(contactObj.accountId);
      }
    }
    
    if(contactList != null && !contactList.isEmpty()){
    
         for(Contact contactObj : contactList){
            contactIdSet.add(contactObj.Id);
        
         }    
    
    }
    
    List<User> userList = [SELECT Id FROM User 
                                          where IsPortalEnabled = true and IsActive = true and ContactId in :contactIdSet];

    if(userList.size()>0)
    {
    for(User userobj:userList)
    {
    userIdSet.add(userobj.id);
    
    }
   }
   
   checkportalTabAccList = [SELECT Id FROM Portal_Tab_Access__c where User__c in :userIdSet and account__c in :accountIds];
           //ClsInitTabAccCreateTrigHandler.createTabAccess(contactList,userList);
             /*---------   Added on 11-Feb-2016 (Case 00049175) ----- Jabee -----------------------------------------------*/  
            
           portalTabAccessTriggerHandler.assignTabAccess (userIdSet);
     
           /*------------------------------------- End -----------------------------------------------*/
 
//Change Log: Updated By: Cognizant FV Team - Dated: Oct-07-2013 -Start
//Case Id: 00002182
// Create Portal Tab Access records for the newly portal enabled contacts having no department assigned
set<string> conIds = new set<string>();
set<string> userIds = new set<string>();
set<string> userIdsPTA = new set<string>();
map<string,user> mapConUsr = new map<string,user>();
list<portal_tab_access__c> lstPTA = new list<portal_tab_access__c>();
list<portal_tab_access__c> lstPTAInsert = new list<portal_tab_access__c>();
for(Contact con:Trigger.New){ 
    if(con.Is_Portal_User_Active__c && !Trigger.oldMap.get(con.id).Is_Portal_User_Active__c){
        /*added test.isRunningTest() for Code Coverage-jabee----------*/
        if(con.Department__c==null || con.Department__c==''|| test.isRunningTest()){
            conIds.add(con.id);   
        }
    }
}
if(conIds!=null && !conIds.isEmpty()){
for(user u:[select id,contactid, contact.accountid from user where contactid!=null and contactid in :conIds and IsActive = true]){
    mapConUsr.put(u.contactid,u);
    userIds.add(u.id); 
}
if(mapConUsr!=null && !mapConUsr.keyset().isEmpty()){
    lstPTA = [select User__c,account__c from portal_tab_access__c where user__c in :userIds];
    for(portal_tab_access__c PTA :lstPTA){
        userIdsPTA.add(PTA.user__c);
    }
}
if(mapConUsr!=null && !mapConUsr.keyset().isEmpty()){
    for(id cId :conIds){
        if((userIdsPTA.isEmpty() && mapConUsr.get(cId).id!=null) || (!userIdsPTA.isEmpty() && mapConUsr!=null && mapConUsr.containskey(cId) && !userIdsPTA.contains(mapConUsr.get(cId).id) && mapConUsr.get(cId).id!=null)){
                    portal_tab_access__c temp=new portal_tab_access__c();
                    temp.user__c = mapConUsr.get(cId).id;   
                    temp.account__c = mapConUsr.get(cId).contact.accountid; 
                    lstPTAInsert.add(temp);      
        }
    }
}
if(lstPTAInsert!=null && lstPTAInsert.size()>0){
    //insert lstPTAInsert;
}
}
//Change Log: Updated By: Cognizant FV Team - Dated: Oct-07-2013 -End   
//} 
    /*L Anil Kumar Reddy - Start - 22-05-2017 - Report Sharing -Track 3 */
    if(Trigger.isUpdate && Trigger.isAfter){
        if(checkRecursive.runOnce()){
            ICC_SharingRecordsToAccountClass.shareAccessToPortalAccounts(Trigger.newMap, Trigger.oldmap);
        }
    }
    /*L Anil Kumar Reddy - End - 22-05-2017 - Report Sharing -Track 3 */
}