/*    
  Author:  Cognizant Technology Solutions
  Description: This trigger is used to add portal users to Public Group-Portal User Group
  History:  
  Change History:
  Modified On:Nov-07-2013
  Reason: Case-00002443: Merging multiple Future Method calls into one.
  Change History: Case-3283
  Author: Cognizant FV Team
  Modified Date: Dec-10-2013
  Reason: Correcting User Created Flag, Login ID and Access Set UP record creation during portal user enabling. 
  Change History: Case-3342
  Author: Cognizant FV Team
  Modified Date: Jan-08-2014
  Reason: Commenting out Code to that nullified Federation ID (Short Name) for deactivated users  
  Change History: Case-4489
  Author: Cognizant FV Team
  Modified Date: Jan-08-2014
  Reason: Replacing Document owner who get deactivated by default owner. 
  Author: Cognizant 
Created Date: 24th Feb 2014
Reason: Modified for case 5779  

  Modified On: 18-04-2017
  Reason: Track 3 - Providing access on custom objects(specific to track 3) on First portal user under Account get created.
  Change History: Track 3
  Author: L Anil Kumar Reddy
*/

trigger UserTrigger on User (before Insert, after Insert, after Update, before Update) {
    system.debug('start>>>>>>>>>>>UserTrigger : SOQL count:'+limits.getQueries());
    Boolean assignTabAccessBoolean=false;
    Boolean updateEnabledContactBoolean=false;
    Boolean addPortalUserLoginToShortNameBoolean=false;
    Boolean updatecustomerPortaladminBoolean=false;
    Boolean updateContactPortalStatusProxyBoolean=false;
    Boolean updateContactsBoolean=false;
    Boolean updateASNBoolean=false;
    Boolean insertASNBoolean=false;
 //Case-3283 Change-001
    Boolean updateContactPortalLoginBoolean=false;
    map<Id,String> mapLoginsToContactFuture = new map<Id,String>();
    set<Id> setConIdsFuture = new set<Id>();
    //Case-3283 Change-001
        
    set<id> setUserIdsFuture;
    set<id> setContactIdsFuture;
    set<id> setaccIdsFuture;
    set<Id> setUIdsFuture;
    map<String,String> newToOldLoginsFuture;
    List<String> newLoginsToInsertFuture;
    static integer recursiveController=0;
    //Case-4489-Change-001
    set<id> setInactiveUsers = new set<id>();
       
    /** Modified by Cognizant Onsite on 20130426 To Assist in Adding Portal User To Group Start **/
    System.debug('&&&&&&&&&&' + trigger.new);
    if((trigger.isInsert || (trigger.isupdate && !managerUpdater.executed)) && trigger.isAfter ){// modified for case 5779
        //Added ASOLITO 09262013 - Added codes for Apex sharing of Device and Export control
        //to new portal users coming from FoundryVIew
        //***********************************************************************
        if(!System.isBatch() && !System.isFuture()){        
            List<String> newUsers = new List<String>();
            
            for(User u: trigger.new){
                if(u.isPortalEnabled){
                    newUsers.add(u.id);     
                }
            } 
            ExposeDeviceToCustomer.createSharingRule(newUsers);
        }
        //***********************************************************************
        
        ClsUserTriggerHandler.addPortalUsertoGroup(trigger.newMap.keySet());
        portalTabAccessTriggerHandler.assignTabAccess(trigger.newMap.keySet());
        
        if (System.isBatch() || System.isFuture()){
            System.debug(' enter batch and create portal tab access ');
          
            portalTabAccessTriggerHandler.assignTabAccess (trigger.newMap.keySet());
        }else{
            if(Limits.getFutureCalls()<10){
          //Case-3283 Change-002: De-associating Acess Set Up record creation Future call in order to avoid concurrent update issue on contact record :Start
            //case:2443:commenting out Future methoda call --uncommenting as per Case-3283
            System.debug(' calling insert pta ');
             Set<Id> userids=new Set<Id>();
             for(User u: Trigger.new)
                userids.add(u.id);
                
             ClsUserTriggerHandler.insertPermissionSets(userids);
            }
            //commenting as per Case-3283
            //assignTabAccessBoolean=true;
            //Case-3283 Change-002: De-associating Acess Set Up record creation Future call in order to avoid concurrent update issue on contact record :Start
        }
        
    }
    
    /** Modified by Cognizant Onsite on 20130426 To Assist in Adding Portal User To Group End **/
    
    /** Modified by Cognizant Onsite on 20130418 Start **/
    /** Modified by Cognizant to include filter condition for ShortName dupliacte check on 20130515 **/
    
    /** This  section gets triggered when a portal user gets created. This section through the UserTriggerHandler
        class creates 2 unique new records in the Account Short Name object with one record having the Portal Login Name
        and another having the Portal Contact Id. It also updates the corresponding Portal Contact record by setting the
        is Portal User Active field to true and copying the Portal Login Name to the Login Id field of Contact
    **/       
    
     set<Id> setProfileIds = new set<Id>();
     set<Id> setContactIds = new set<Id>();
     set<Id> setUserIds = new set<Id>();
     set<String> setShortName = new set<String>();
     set<string> setNewShortName= new set<string>();
    
     /** Checking for the profiles related to Customer Portal Users
      **/
    
   
     for(Profile objProfile: [Select Id, Name from Profile where Name LIKE '% Portal %']){
         setProfileIds.add(objProfile.Id);
     }
    
    /**
        This section gets triggered when a Portal User is activated and the Portal Login field is checked for uniquenesst.
    **/
    
    if(trigger.isInsert || (trigger.isUpdate && !managerUpdater.executed)){
        if(trigger.isBefore){
            
            for(User objUser : trigger.new){
                if(setProfileIds.contains(objUser.profileId) && objUser.isActive){
                    if(objUser.FederationIdentifier!=null){
                        if(trigger.isInsert){
                            setNewShortName.add(objUser.FederationIdentifier.toLowerCase()); 
                        }
                        else if(trigger.isUpdate){
                            if(Trigger.oldMap.get(objUser.ID).FederationIdentifier!=null){
                                if(Trigger.oldMap.get(objUser.ID).IsActive){
                                    if(objUser.FederationIdentifier.toLowerCase()!=Trigger.oldMap.get(objUser.ID).FederationIdentifier.toLowerCase()){
                                        setNewShortName.add(objUser.FederationIdentifier.toLowerCase());
                                    }
                                }
                                else{
                                    setNewShortName.add(objUser.FederationIdentifier.toLowerCase()); 
                                } 
                            }
                            else{
                                setNewShortName.add(objUser.FederationIdentifier.toLowerCase()); 
                            }  
                        }
                    }
                }   
            }
            //system.debug('new short name set:'+ setNewShortName); 
            
           if(setNewShortName!=null && setNewShortName.size()>0){                   
            for(Account_Short_Name__c objASN: [Select Id, Account_Short_Name__c from Account_Short_Name__c where Account_Short_Name__c in :setNewShortName ] ){
                setShortName.add(objASN.Account_Short_Name__c);        
            }
            system.debug('Retrieved short name set:'+ setShortName); 
            }

            for(User objUser : trigger.new){
            
                if(setProfileIds.contains(objUser.profileId) && objUser.isActive){
                   if (objUser.FederationIdentifier !=null){
                        if (objUser.FederationIdentifier.length() > 1){
                            if(!Pattern.matches('^[a-zA-Z0-9_-]+$',objUser.FederationIdentifier)){                         
                                objUser.addError(' Fedration ID can only contain characters, numbers, -, _ ');
                                system.debug('set shortname:'+setShortName);
                                system.debug('user short name:'+objUser.FederationIdentifier.toLowerCase());
                            }
                            else if( setShortName!=null && setShortName.size()>0 && setShortName.contains(objUser.FederationIdentifier.toLowerCase())){                               
                                system.debug('set shortname:'+setShortName);
                                system.debug('user short name:'+objUser.FederationIdentifier.toLowerCase());
                                objUser.addError(' Fedration ID value must be unique. ');                                    
                            }
                            else{
                                objUser.FederationIdentifier = objUser.FederationIdentifier.toLowerCase();
                            }
                            
                        }
                        else{
                            objUser.adderror(' Federation ID value should be more than 1 character');
                        }  
                            
                   }                   
                   //Assigning random Federation ID to users for test run

                   if(Test.isRunningTest()){
                       if(objUser.FederationIdentifier==null || objUser.FederationIdentifier==''){
                           objUser.FederationIdentifier='FederationID'+string.valueOf(math.random()).replace('.','');
                           objUser.Portal_Login__c= objUser.FederationIdentifier;
                       }
                   }     
                }                    
                               
            }    
         }
    }  
               
    if(trigger.isInsert){
                                        
         if(trigger.isAfter){
                   
             /** Checking for the newly created Customer Portal Users and putting the User Ids and the parent Contact
                 Ids in Sets.
              **/               
            for(User objUser : trigger.new){
                if(setProfileIds.contains(objUser.profileId)){
                    setUserIds.add(objUser.Id);
                    setContactIds.add(objUser.contactId);    
                }                    
                               
            }

    

            
            if(setUserIds!=null && !(setUserIds.isEmpty())){
                System.debug (' ** Size of Set of Portal User Ids created is ** ' + setUserIds.size());
                
                if(setContactIds!=null && !(setContactIds.isEmpty())){
                    System.debug (' ** Size of Set of Parent Portal Contact Ids created is ** ' + setContactIds.size());
                  
                    /** Calling the updateEnabledContact method in clsUserTrigger class whereby the portal Contact
                        records get updated in Contact object.
                    **/
                    //case:2443:commenting out Future method call
                    //if(Limits.getFutureCalls()<10){                    
                    // ClsUserTriggerHandler.updateEnabledContact(setUserIds,setContactIds);
                        updateEnabledContactBoolean=true;
                        setUserIdsFuture = setUserIds.clone();
                        setContactIdsFuture= setContactIds.clone();
                    //}
                    /** Calling the addPortalUserLoginToShortName method in clsUserTrigger class whereby 2 new Short
                        Name records get created in Account Short Name object after being checked for uniqueness.
                     **/
                     
                    //case:2443:commenting out Future method call
                    //if(Limits.getFutureCalls()<10){ 
                    // ClsUserTriggerHandler.addPortalUserLoginToShortName(setUserIds);
                        addPortalUserLoginToShortNameBoolean=true;
                        setUserIdsFuture = setUserIds.clone();
                    //}
                }
            }
        
        }
                       
    }
    


/*    
  Author:  Cognizant Technology Solutions
  Description: Added to call the method updatecustomerPortaladmin for updating the customer Portal admin in account
  History:  
*/
 if(trigger.isInsert || (trigger.isUpdate && !managerUpdater.executed))
 {
   if (trigger.isAfter)
   {
 
     List<User> userList=new List<user>();
     Set<Id> accId=new Set<Id>();
 //adding the account Ids in the list    
     for(User userobj : trigger.new)
     {
     
       accId.add(userobj.AccountId);

     }

         if ((System.isBatch() || System.isFuture()))
         {
                
         }else
         {
                        
             if(accId.size()>0)
              {
      //calling the class  ClsUserTriggerHandler      
                 //case:2443:commenting out Future methoda call
                 //if(Limits.getFutureCalls()<10){                     
                     //ClsUserTriggerHandler.updatecustomerPortaladmin(accId);
                     updatecustomerPortaladminBoolean=true;
                     setaccIdsFuture = accId.clone();
                 //}     
              }
          }

     }
 }


/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

    
    /** Modified by Cognizant Onsite on 20130418 End **/
            
    
          
    /** Modified by Cognizant on 20130425 Start **/
    
    /** This  section gets triggered when a portal user gets created. This section through the UserTriggerHandler
        class creates 2 unique new records in the Account Short Name object with one record having the Portal Login Name
        and another having the Portal Contact Id. It also updates the corresponding Portal Contact record by setting the
        is Portal User Active field to true and copying the Portal Login Name to the Login Id field of Contact
    **/ 
    
     if(trigger.isInsert){
        if (trigger.isAfter){
            if ((System.isBatch() || System.isFuture()))
            {
            }else{

                //case:2443:commenting out Future methoda call
                //ClsUserTriggerHandler.updateContactPortalStatus(trigger.newMap.keySet(),'Insert'); 
                updateContactPortalStatusProxyBoolean=true;

            }
                 
         }
      }
    
    if(trigger.isUpdate && !managerUpdater.executed){
       System.debug('#####################' + System.isFuture());
       if (System.isBatch() || System.isFuture())
        {
        }else{
            
            //case:2443:commenting out Future methoda call
            //ClsUserTriggerHandler.updateContactPortalStatus(trigger.newMap.keySet(),'Update');
            updateContactPortalStatusProxyBoolean=true;
        }         
    }
        
    /**
        This section gets triggered when the Portal Login Id field of a Portal User is changed and the Account Short Name record needs to be modified.
    **/
    
    if((trigger.isUpdate && !managerUpdater.executed) && trigger.isAfter){
        map<String,String> newToOldLogins = new map<String,String>();
        map<Id,String> mapLoginsToContact = new map<Id,String>();
        set<Id> setConIds = new set<Id>();
        List<String> newLoginsToInsert = new List<String>();
        for(User objUser:trigger.new){
            if(objUser.Portal_Login__c!=null && objUser.IsActive){               
                mapLoginsToContact.put(objUser.contactId,objUser.Portal_Login__c);
                setConIds.add(objUser.contactId);               
                if(Trigger.oldMap.get(objUser.ID).Portal_Login__c!=null){
                    if(Trigger.oldMap.get(objUser.ID).IsActive){
                        if(Trigger.oldMap.get(objUser.ID).Portal_Login__c!=objUser.Portal_Login__c){ 
                            System.debug('** Portal Login Id is modified from old to new **');
                            newToOldLogins.put(Trigger.oldMap.get(objUser.ID).Portal_Login__c.toLowerCase(),objUser.Portal_Login__c.toLowerCase());
                        }
                    }
                    else{
                        System.debug('** Portal Login Id is modified from old to new in case of converting Old to New Accounts **');
                        newLoginsToInsert.add(objUser.Portal_Login__c.toLowerCase());
                    }   
                }
                else{
                    System.debug('** Portal Login Id is modified from old to new when old was null **');
                    newLoginsToInsert.add(objUser.Portal_Login__c.toLowerCase());
                }               
                                                                          
            }
            else if(!objUser.IsActive && Trigger.oldMap.get(objUser.ID).IsActive){
                System.debug('** Portal User is deactivated **');
                mapLoginsToContact.put(objUser.contactId,'');
                setConIds.add(objUser.contactId); 
                //Case-4489:Change-002
                setInactiveUsers.add(objUser.id);      
            }           
        }
        if(mapLoginsToContact!=null && !(mapLoginsToContact.isEmpty())){
            System.debug (' ** Value of Map of Portal Login Ids is ** ' + mapLoginsToContact);
            if (System.isBatch() || System.isFuture())
            {
                ClsUserTriggerHandler.updateContactPortalLogin(setConIds,mapLoginsToContact);
            }else{
               //case:2443:commenting out Future method call
               // ClsUserTriggerHandler.updateContactPortalLoginFuture(setConIds,mapLoginsToContact);
               //Case-3283 Change-003: updating correct boolean for corresponding method call : Start
                updateContactPortalLoginBoolean = true;
                setConIdsFuture = new set<Id>();
                mapLoginsToContactFuture = new map<Id,String>();
                setConIdsFuture = setConIds.clone();
                mapLoginsToContactFuture = mapLoginsToContact.clone();
               //Case-3283 Change-003: updating correct boolean for corresponding method call : End
            }
        }
        if((newToOldLogins!=null && !(newToOldLogins.isEmpty()))){
            System.debug (' ** Value of Map of Old To New Login Ids is ** ' + newToOldLogins);
            if (System.isBatch() || System.isFuture())
            {
                ClsUserTriggerHandler.updateASN(newToOldLogins);
            }else{
                //case:2443:commenting out Future methoda call
                //if(Limits.getFutureCalls()<10){
                //ClsUserTriggerHandler.updateASNFuture(newToOldLogins);
                 updateASNBoolean=true;
                 newToOldLoginsFuture = newToOldLogins.clone();
               // }
            }
        }
        if((newLoginsToInsert!=null && !(newLoginsToInsert.isEmpty()))){
            System.debug (' ** Value of List of New Login Ids is ** ' + newLoginsToInsert);
            if (System.isBatch() || System.isFuture())
            {
                ClsUserTriggerHandler.insertASN(newLoginsToInsert);
            }else{
                //case:2443:commenting out Future methoda call
                //if(Limits.getFutureCalls()<10){
                // ClsUserTriggerHandler.insertASNFuture(newLoginsToInsert);
                    insertASNBoolean =true;
                    newLoginsToInsertFuture = newLoginsToInsert.clone();
                //}
            }
        }
    }
    
     /**
        This section gets triggered when a Portal User is deactivated and the Portal Login field needs to be blanked out.
    **/
    //Case-00003342: Commenting out code that nullifies FederationID upon user disbling:Start
    /**
    if(trigger.isUpdate && trigger.isBefore){
        for(User objUser:trigger.new){
            if(!objUser.isActive && Trigger.oldMap.get(objUser.ID).isActive && (objUser.Portal_Login__c!=null ||  objUser.FederationIdentifier != '')){               
                objUser.Portal_Login__c = ''; 
                objUser.FederationIdentifier = '';                                     
            }           
        }        
    }
    **/
    //Case-00003342: Commenting out code that nullifies FederationID upon user disbling:End
    
    // Update Federation ID after Insert if it is null && update contact fields post Insert/update for Portal users
    set<id> setUIds=new set<id>();
    list<user> lstusrs=new list<user>();
    list<contact> lstContacts=new list<contact>();
    static boolean checkRegressionUser=true;
    static boolean checkRegressionCon=true;
    
    if((Trigger.isInsert || (Trigger.isUpdate && !managerUpdater.executed)) && Trigger.isAfter ){
        for(user usr:Trigger.New){
            if(usr.UserType=='PowerCustomerSuccess'){
                if(Trigger.isInsert) {
                    if(usr.FederationIdentifier==null || usr.FederationIdentifier==''){
                        user u=new user(id=usr.id);
                        u.FederationIdentifier=usr.id;
                        u.Portal_Login__c=usr.id;
                        lstusrs.add(u);
                    }
                    if(usr.contactid!=null){
                        setUIds.add(usr.id);        
                    }
                }
                else if(usr.Username!=Trigger.oldMap.get(usr.id).Username || usr.profileId!=Trigger.oldMap.get(usr.id).profileId || usr.TimeZoneSidKey!=Trigger.oldMap.get(usr.id).TimeZoneSidKey || usr.FederationIdentifier !=Trigger.oldMap.get(usr.id).FederationIdentifier){
                    setUIds.add(usr.id);    
                }   
            }
        }
        //Update users which had null value for Federation Id
        if(lstusrs.size()>0 && checkRegressionUser){
            checkRegressionUser=false;
            update lstusrs;
        }
        //Update contact where corresponding users fields - User Name, Profile,Timezone - have been updated
        if(setUIds!=null && !setUIds.isEmpty() && checkRegressionCon ){
               system.debug('***** future calls'+Limits.getLimitFutureCalls());
               checkRegressionCon=false;
               /** Modified for resolving Test Class Failures **/
               if (System.isBatch() || System.isFuture()){
                   ClsUserTriggerHandler.updateContacts(setUIds);
               }
               else{
                   //case:2443:commenting out Future method call
                   if(Limits.getFutureCalls()<10){
                       //ClsUserTriggerHandler.updateContactsFuture(setUIds);
                   }
                   updateContactsBoolean=true;
                   setUIdsFuture = setUIds.clone();
               }
               /** Modified for resolving Test Class Failures **/
            }
        
    }
    
    //Sync Federation Id and Portal Login fields 
    if( Trigger.isBefore && ((Trigger.isUpdate && !managerUpdater.executed) || Trigger.isInsert)){
        for(user u :Trigger.New){
            if(u.Portal_Login__c!=u.FederationIdentifier && u.UserType=='PowerCustomerSuccess'){
                if(Trigger.isUpdate && (u.FederationIdentifier==null || u.FederationIdentifier=='')){
                    u.FederationIdentifier=u.id;
                }
                u.Portal_Login__c=u.FederationIdentifier ;               
            }
        }
    } 
    
    /**
        This section gets triggered when a Portal User is deactivated and the Document Provisioning records need to be De-Provisioned.
    **/
    
    if((trigger.isUpdate  && !managerUpdater.executed) && trigger.isAfter){
        set<Id> setUserIdsToDeprovision = new set<Id>(); 
        for(User objUser:trigger.new){
            if(!objUser.isActive && Trigger.oldMap.get(objUser.ID).isActive && objUser.UserType=='PowerCustomerSuccess'){               
                setUserIdsToDeprovision.add(objUser.Id);                                                  
            }           
        }
        if(setUserIdsToDeprovision!=null && !(setUserIdsToDeprovision.isEmpty())){
            if (System.isBatch() || System.isFuture()){
                DesignSpecTriggerHandler.removeProvisioningForInactiveUsers(setUserIdsToDeprovision);
            }else{
                DesignSpecTriggerHandler.removeProvisioningForInactiveUsersFuture(setUserIdsToDeprovision);
            }           
        }   
    }
            
     /** Modified by Cognizant on 20130425 End **/
     //case:2443:Calling common Future methods for each Trigger event
     if(Trigger.isInsert && Trigger.isAfter){
         ClsUserTriggerHandler.userTriggerAfterInsertAsyncHandler(trigger.newMap.keySet(),assignTabAccessBoolean,updateEnabledContactBoolean,setUserIdsFuture,setContactIdsFuture,addPortalUserLoginToShortNameBoolean,updatecustomerPortaladminBoolean, setaccIdsFuture,updateContactPortalStatusProxyBoolean,updateContactsBoolean,setUIdsFuture);
     }
     
     if((Trigger.isUpdate && !managerUpdater.executed )&& Trigger.isAfter && recursiveController<(integer.valueOf(label.UserTriggerRecursionController))){
//Case-3283 Change-004: updated method to include method call for Federation ID change sync : Start
//         ClsUserTriggerHandler.userTriggerAfterUpdateAsyncHandler(trigger.newMap.keySet(),updatecustomerPortaladminBoolean,setaccIdsFuture,updateContactPortalStatusProxyBoolean,updateASNBoolean,newToOldLoginsFuture,insertASNBoolean,newLoginsToInsertFuture,updateContactsBoolean,setUIdsFuture);
       //Case-4489:Change003:Adding extra method parameter
         ClsUserTriggerHandler.userTriggerAfterUpdateAsyncHandler(trigger.newMap.keySet(),updatecustomerPortaladminBoolean,setaccIdsFuture,updateContactPortalStatusProxyBoolean,updateASNBoolean,newToOldLoginsFuture,insertASNBoolean,newLoginsToInsertFuture,updateContactsBoolean,setUIdsFuture, updateContactPortalLoginBoolean,setConIdsFuture, mapLoginsToContactFuture,setInactiveUsers);
         recursiveController=recursiveController+1;
  //Case-3283 Change-004: updated method to include method call for Federation ID change sync : End       
     }
   //Supplier Internal User related Changes: 09-DEC-2013: Start
     if(Trigger.isAfter){
       Try{  
         List<id> supplierIds=new List<id>();
         List<id> supplierIdremoved= new List<Id>();
         
         if(Trigger.isInsert){     
             for(user u:Trigger.new){
                 if(u.profileid==label.SupplierProfileId){
                     supplierIds.add(u.id);    
                 }    
             }
         }
         
         if(Trigger.isUpdate && !managerUpdater.executed){
             for(user usr :trigger.new){
                 if(usr.profileid!=trigger.oldmap.get(usr.id).profileid && usr.profileid==label.SupplierProfileId){
                     supplierIds.add(usr.id);        
                 }
                 else if(usr.profileid!=trigger.oldmap.get(usr.id).profileid && trigger.oldmap.get(usr.id).profileid==label.SupplierProfileId){
                     supplierIdremoved.add(usr.id);    
                 }
             }
             
         }
         
         // Add new supplier users to Supplier public group
         if(supplierIds!=null && supplierIds.size()>0){
             list<groupmember> grpmbr=new list<groupmember>();
             for(string uid :supplierIds){
                 groupmember gm=new groupmember();
                 gm.userorgroupid=uid;
                 gm.groupid=label.SupplierGroupId;
                 grpmbr.add(gm);    
             }
             if(grpmbr!=null && grpmbr.size()>0){
                 insert grpmbr;
             }
         }
         
         //Remove Supplier users from Supplier group for whom profile is changed to some other value
         if(supplierIdremoved!=null && supplierIdremoved.size()>0){
         list<groupmember> lstsuppGrpMbr= new list<groupmember>();
         lstsuppGrpMbr = [select id from groupmember where userorgroupid in :supplierIdremoved and groupid=:label.SupplierGroupId];
         
         if(lstsuppGrpMbr!=null && lstsuppGrpMbr.size()>0){
             delete lstsuppGrpMbr;
         }
         
         }
        }catch(exception e){
            system.debug('Error while adding valid users to Supplier group:'+e.getmessage());
        } 
     }
     //Supplier Internal User related Changes: 09-DEC-2013: End
    system.debug('end>>>>>>>>>>>UserTrigger : SOQL count:'+limits.getQueries());     
     /*L Anil Kumar Reddy - Start - 18-4-2017 - Report Sharing -Track 3 */
   /*  
     if(Trigger.IsInsert && Trigger.isAfter){
         if(checkRecursive.runOnce()){
         ICC_SharingRecordsToAccountClass.shareAccessToPortalAccounts(trigger.NewMap.keyset());
         }
     } */
     /*L Anil Kumar Reddy - END  - 18-4-2017 - Report Sharing -Track 3 */
     
}