/*************************************************************************************************************************************************************
@ Class:          User_TriggerHelper
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        Helper class which consist of logics used in User Triggers.


--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 26.08.2016 / Ishtpreet Singh / Created the class.
@ Modified History:11/07/2017 / Dinesh Suggala
**************************************************************************************************************************************************************/
Public Class User_TriggerHelper{
    /*Global Variables declarations*/
    public            Map<Id,User>                                        triggerOldMap               { get; set; }
    public            Map<Id,User>                                        triggerNewMap               { get; set; }
    public            Map<Id,Id>                                          userManagerMap              { get; set; } /* Map of ID and ID to store the User & its managers ID */
    public            Map<String,User>                                    mUsersByFedID               { get; set; } /* Map of String and User to store the User & values in Federation field */
    public            Map<String,HCM_Employee__c >                        mHCMEmployees               { get; set; } /* Map of String and HCM_Employee__c object */
    public            List<String>                                        lFederationIDS              { get; set; } /* List of String to store Federation Ids */
    public            List<String>                                        lUserIDS                    { get; set; } /* List of String to store the User Ids */
    public            Map<String, Id>                                     mEmpIdUserId                { get; set; } /* Map of String and Id to store the User name & User Id corresponding to it */
    public            Map<String, String>                                 mEmpIdSupervisorId          { get; set; }
    public            map<Id,String>                                      mapLoginsToContactFuture    { get; set; }
    public            set<Id>                                             setConIdsFuture             { get; set; }
    public            set<id>                                             setUserIdsFuture            { get; set; }
    public            set<id>                                             setContactIdsFuture         { get; set; }
    public            set<id>                                             setaccIdsFuture             { get; set; }
    public            set<Id>                                             setUIdsFuture               { get; set; }
    public            map<String,String>                                  newToOldLoginsFuture        { get; set; }
    public            List<String>                                        newLoginsToInsertFuture     { get; set; } 
    public            set<id>                                             setInactiveUsers            { get; set; }
    public            set<Id>                                             setProfileIds               { get; set; }
    public            set<Id>                                             setContactIds               { get; set; } 
    public            set<Id>                                             setUserIds                  { get; set; }    
    public            set<String>                                         setShortName                { get; set; }
    public            set<string>                                         setNewShortName             { get; set; }
    public  Static    integer                                             recursiveController         { get; set; }               
    
    
    /*Boolean Variables*/
    Boolean assignTabAccessBoolean=false;
    Boolean updateEnabledContactBoolean=false;
    Boolean addPortalUserLoginToShortNameBoolean=false;
    Boolean updatecustomerPortaladminBoolean=false;
    Boolean updateContactPortalStatusProxyBoolean=false;
    Boolean updateContactsBoolean=false;
    Boolean updateASNBoolean=false;
    Boolean insertASNBoolean=false;
    Boolean updateContactPortalLoginBoolean=false;
    static boolean checkRegressionUser=true;
    static boolean checkRegressionCon=true;
    
    public User_TriggerHelper(){
    
        triggerOldMap = ((Map<Id,User>)Trigger.oldMap);
        triggerNewMap = ((Map<Id,User>)Trigger.newMap);
        lFederationIDS = new List<String>();
        lUserIDS = new List<String>();
        mEmpIdSupervisorId = new Map<String, String>();
        mEmpIdUserId = new Map<String, Id>();
        mHCMEmployees = new Map<String, HCM_Employee__c>();
        userManagerMap = new Map<Id,Id>();
        mUsersByFedID = new Map<String,User>();
        mapLoginsToContactFuture = new Map<Id,String>();
        setConIdsFuture = new Set<Id>();
        setUserIdsFuture = new Set<Id>();
        setContactIdsFuture = new Set<Id>();
        setaccIdsFuture = new Set<Id>();
        setUIdsFuture = new Set<Id>();
        newToOldLoginsFuture = new Map<String,String>();
        newLoginsToInsertFuture = new List<String>();
        setInactiveUsers = new Set<Id>();
        setProfileIds = new set<Id>();
        setContactIds = new set<Id>();
        setUserIds = new set<Id>();
        setShortName = new set<String>();
        setNewShortName= new set<string>();
            
        recursiveController=0;
    }
    
    public void UserTrigger_biu(){
        system.debug('start>>>>>>>>>>UserTrigger_biu :SOQL queries:'+limits.getQueries());
        if(trigger.isInsert || (trigger.isUpdate && !managerUpdater.executed)){
            // Get all the profiles as we will look to identify the GF profiles
            Map<ID,Profile> allProfileMap = new Map<ID,Profile>( [SELECT Id, Name FROM Profile LIMIT 200] );
    
            for (User eachUser: (List<User>)Trigger.new) {                                     
                Profile myProfile = allProfileMap.get(eachUser.ProfileId);
                String myProfileName = '' + myProfile.name;                
                // only apply validation to the GF profiles
                if (myProfileName.StartsWith('GF')) {
                    if (eachUser.FederationIdentifier != null && eachUser.FederationIdentifier.length() > 0) {
                    
                        eachUser.FederationIdentifier = eachUser.FederationIdentifier.toUpperCase();
                        eachUser.HCM_Employee_ID__c = eachUser.FederationIdentifier;
                        lFederationIDS.add(eachUser.FederationIdentifier);
                    } else {eachUser.FederationIdentifier.addError('Federation ID must be populated with a valid HCM Employee ID');// add a field validation error - should always provide a federationID
                    }
                    system.debug('eachUser.FederationIdentifier: inside if of GF:'+eachUser.FederationIdentifier);
                }
            }
            lUserIDS.addAll(lFederationIDS);
            for (HCM_Employee__c eachHCM: [select id, Login_ID__c, Last_Name__c, First_Name__c, Department_Name__c, Email_Address__c, Job_Title__c, Phone_Number__c , Employee_ID__c, Supervisor_ID__c
                    FROM HCM_Employee__c where Employee_ID__c in :  lFederationIDS ]) {
                mHCMEmployees.put(eachHCM.Employee_ID__c , eachHCM);
                // Enhancement HCM Supervisor Update: Collect all users in List
                    mEmpIdSupervisorId.put(eachHCM.Employee_ID__c, eachHCM.Supervisor_ID__c);
                    lUserIDS.add(eachHCM.Supervisor_ID__c);
            }
            // Enhancement HCM Supervisor Update: Get all HCM Employee_Ids and Corrosponding User Ids
            for (User eachUser: 
                [SELECT FederationIdentifier, id FROM User Where FederationIdentifier IN: lUserIDS]) {
                mEmpIdUserId.put(eachUser.FederationIdentifier, eachUser.id);
            }
            
            for (User eachUser: (List<User>)Trigger.new) { 
                
                Profile myProfile = allProfileMap.get(eachUser.ProfileId);
                String myProfileName = '' + myProfile.name;
    
                // only apply validation to the GF profiles
                if (myProfileName.StartsWith('GF')) {           
                
                   HCM_Employee__c matchedHCM = mHCMEmployees.get(eachUser.FederationIdentifier);
                   if (matchedHCM != null) {
                        eachUser.HCM_Record_ID__c = matchedHCM.id;
                        eachUser.LastName = matchedHCM.Last_Name__c;
                        eachUser.Department = matchedHCM.Department_Name__c;
                        eachUser.email = matchedHCM.Email_Address__c;
                        eachUser.Title = matchedHCM.Job_Title__c;
                        eachUser.HCM_Login_ID__c = matchedHCM.Login_ID__c;
                        
                        // Enhancement HCM Supervisor Update: Update Manager Information in User
                        Id managerUser = mEmpIdUserId.get(mEmpIdSupervisorId.get(eachUser.FederationIdentifier));
                        if ((mEmpIdSupervisorId.get(eachUser.FederationIdentifier)) != null) {
                            if (managerUser != null) {userManagerMap.put(eachUser.id,managerUser);// SFDC TEST - case#13198545 //eachUser.ManagerId = managerUser;
                            }
                        } else {
                            eachUser.ManagerId = null;
                        }
                   }else {eachUser.FederationIdentifier.addError('Federation ID does not match an existing HCM Employee ID'); // add a field validation error - federationID should match an Employee ID
                   }
                }
            } 
            if(userManagerMap.size()>0){managerUpdater.executed=true;
                managerUpdater.process(userManagerMap);           
            }      
            
            //ADDED 05/21/2013 - ASOLITO
            //future and batch calls won't pass this future method
            if (!HCMUserActions.isFuture && !System.isBatch() && !System.isFuture()) {
                HCMUserActions.updateHCMUsers(lFederationIDS, lUserIds);
            }
            
            //ADDED 06/04/2013 - ASOLITO
            //added codes to store removed fabs when user changes the value of fab assigned field
            if(trigger.isUpdate){
                Map<String,User> userMap = new Map<String,User>(); 
                for(User u: (List<User>)trigger.new){                                               
                    if(u.fab_assigned__c <> triggerOldMap.get(u.id).fab_assigned__c){
                        userMap.put(u.id,u);
                    }
                }                  
                 list<user> usrr= new list<user>([SELECT fab_assigned__c,fab_deleted__c,(SELECT id 
                                                                  FROM Account_Team_Proxy__r 
                                                                  WHERE team_role__c IN ('Customer Engineer','Fab Planner'))
                               FROM User
                               WHERE id IN :userMap.keySet()])     ;
                List<Account_Team_proxy__c> atp =new List<Account_Team_proxy__c>();
                if(usrr.size()>0)
                {
                    atp = usrr[0].account_team_proxy__r;
                }
                for(integer i=0; i<usrr.size();i++)
                {
                    if(userMap.containsKey(usrr[i].id)){
                        User currUser = userMap.get(usrr[i].id);
                        
                        if(atp.size() > 0 && !UtilsString.isNotBlank(currUser.fab_assigned__c)){currUser.fab_assigned__c.addError('This user cannot have a blank fab since its been assigned as a Customer Engineer or Fab Planner');
                        }
                    } 
                } 
                               
                //concatenate the existing fab deleted field value
                for(String key: userMap.keySet()){
                    User u = userMap.get(key);
                    
                    //get the new fab assigned values                               
                    Map<String,String> newVal = new Map<String,String>();   
                    if(UtilsString.isNotBlank(u.fab_assigned__c)){
                        newVal = UtilsString.convertStringListToMap(u.fab_assigned__c.split('\\;'));            
                    }   
                    
                    //get the old fab assigned values
                    List<String> oldVal = new List<String>();                                   
                    if(UtilsString.isNotBlank(triggerOldMap.get(u.id).fab_assigned__c)){
                        oldVal = triggerOldMap.get(u.id).fab_assigned__c.split('\\;');
                    }  
                    
                    //filter fabs not found in the new assigned values
                    List<String> newDeletedFabs = new List<String>();   
                    for(String o: oldVal){
                        if(!newVal.containsKey(o)){
                            newDeletedFabs.add(o);
                        }
                    } 
                    
                    //set the value of the fab deleted field
                    String finalVal = '';
                    if(UtilsString.isNotBlank(u.fab_deleted__c)){                                   
                        Map<String,String> currValMap = UtilsString.convertStringListToMap(u.fab_deleted__c.split('\\;'));
    
                        for(String n :newDeletedFabs){
                            if(!currValMap.containsKey(n)){
                                finalVal += ';' + n;
                            }
                        }
                        u.fab_deleted__c += finalVal;
                    } else {
                        for(String n: newDeletedFabs){
                            finalVal += n + ';';
                        }
                        u.fab_deleted__c = finalVal.removeEnd(';');
                        
                    }                                               
                }                       
            }
        }
        //Added for the fab assignment change
        if(trigger.isUpdate && !managerUpdater.executed){
            for(User eachUser: (List<User>)trigger.new){
                if(eachUser.Fab_Assigned__c != triggerOldMap.get(eachUser.Id).Fab_Assigned__c){
                        eachUser.Fab_Assignment_Change__c=true;             
                }
            }   
        }
        system.debug('end>>>>>>>>>>UserTrigger_biu :SOQL queries:'+limits.getQueries());            
    }
    
    public void userTriggerAfter(){
        system.debug('start>>>>>>>>>>userTriggerAfter :SOQL queries:'+limits.getQueries());    
        set<id> setUIds=new set<id>();
        list<user> lstusrs=new list<user>();
        list<contact> lstContacts=new list<contact>();
    
        for(Profile objProfile: [Select Id, Name from Profile where Name LIKE '% Portal %'])
        {
            setProfileIds.add(objProfile.Id);
        }    

        if(trigger.isInsert || (trigger.isupdate && !managerUpdater.executed))
        {// modified for case 5779
        //Added ASOLITO 09262013 - Added codes for Apex sharing of Device and Export control
        //to new portal users coming from FoundryVIew
        //***********************************************************************
            if(!System.isBatch() && !System.isFuture())
            {        
                List<String> newUsers = new List<String>();
                
                for(User u: (List<User>)trigger.new){
                    if(u.isPortalEnabled){
                        newUsers.add(u.id);     
                    }
                } 
                ExposeDeviceToCustomer.createSharingRule(newUsers);
            }
        //***********************************************************************
        
        ClsUserTriggerHandler.addPortalUsertoGroup(triggerNewMap.keySet());
        portalTabAccessTriggerHandler.assignTabAccess(triggerNewMap.keySet());
        
            if (System.isBatch() || System.isFuture())
            {
                System.debug(' enter batch and create portal tab access ');
              
                portalTabAccessTriggerHandler.assignTabAccess (triggerNewMap.keySet());
            }else{
                if(Limits.getFutureCalls()<10){
              //Case-3283 Change-002: De-associating Acess Set Up record creation Future call in order to avoid concurrent update issue on contact record :Start
                //case:2443:commenting out Future methoda call --uncommenting as per Case-3283
                System.debug(' calling insert pta ');
                 Set<Id> userids=new Set<Id>();
                 for(User u: (List<User>)Trigger.new){
                    userids.add(u.id);
                    
                   if(triggerOldMap!=null && (triggerOldMap.get(u.id).Email==u.Email)){  //Added by Dinesh 11/7/2017
                   ClsUserTriggerHandler.insertPermissionSets(userids); 
                   }
                 }
                }
                //commenting as per Case-3283
                //assignTabAccessBoolean=true;
                //Case-3283 Change-002: De-associating Acess Set Up record creation Future call in order to avoid concurrent update issue on contact record :Start
            }
        
        }
        if(trigger.isInsert){
                   
            /** Checking for the newly created Customer Portal Users and putting the User Ids and the parent Contact
                 Ids in Sets. **/
                          
            for(User objUser : (List<User>)trigger.new){
                if(setProfileIds.contains(objUser.profileId)){
                    setUserIds.add(objUser.Id);
                    setContactIds.add(objUser.contactId);    
                }                                    
            }      
            if(setUserIds!=null && !(setUserIds.isEmpty())){            
                if(setContactIds!=null && !(setContactIds.isEmpty())){             
                    /** Calling the updateEnabledContact method in clsUserTrigger class whereby the portal Contact
                        records get updated in Contact object.
                    **/
                        updateEnabledContactBoolean=true;
                        setUserIdsFuture = setUserIds.clone();
                        setContactIdsFuture= setContactIds.clone();

                    /** Calling the addPortalUserLoginToShortName method in clsUserTrigger class whereby 2 new Short
                        Name records get created in Account Short Name object after being checked for uniqueness.
                     **/
                        addPortalUserLoginToShortNameBoolean=true;
                        setUserIdsFuture = setUserIds.clone();
                }
            }            
        }
        if(trigger.isInsert || (trigger.isUpdate && !managerUpdater.executed))
        {
            List<User> userList=new List<user>();
            Set<Id> accId=new Set<Id>();
            //adding the account Ids in the list    
            for(User userobj : (List<User>)trigger.new){
                accId.add(userobj.AccountId);
            }

            if ((System.isBatch() || System.isFuture())){         
            
            }else{
                     
                if(accId.size()>0){ 
                 updatecustomerPortaladminBoolean=true;
                 setaccIdsFuture = accId.clone();    
                }
            }
        }
        if(trigger.isInsert){
            if ((System.isBatch() || System.isFuture()))
            {
            }else{ 
                updateContactPortalStatusProxyBoolean=true;
            }
        }
        if(trigger.isUpdate && !managerUpdater.executed){
            map<String,String> newToOldLogins = new map<String,String>();
            map<Id,String> mapLoginsToContact = new map<Id,String>();
            set<Id> setConIds = new set<Id>();
            List<String> newLoginsToInsert = new List<String>();
            for(User objUser:(List<User>)trigger.new){
                if(objUser.Portal_Login__c!=null && objUser.IsActive){  mapLoginsToContact.put(objUser.contactId,objUser.Portal_Login__c);
                    setConIds.add(objUser.contactId);               
                    if(triggerOldMap.get(objUser.ID).Portal_Login__c!=null){ if(triggerOldMap.get(objUser.ID).IsActive){
                            if(triggerOldMap.get(objUser.ID).Portal_Login__c!=objUser.Portal_Login__c){ 
                                System.debug('** Portal Login Id is modified from old to new **');
                                newToOldLogins.put(triggerOldMap.get(objUser.ID).Portal_Login__c.toLowerCase(),objUser.Portal_Login__c.toLowerCase());}
                        }
                        else{newLoginsToInsert.add(objUser.Portal_Login__c.toLowerCase());
                             System.debug('** Portal Login Id is modified from old to new in case of converting Old to New Accounts **');
                        }   
                    }
                    else{newLoginsToInsert.add(objUser.Portal_Login__c.toLowerCase());
                    }               
                                                                              
                }
                else if(!objUser.IsActive && triggerOldMap.get(objUser.ID).IsActive){
                    mapLoginsToContact.put(objUser.contactId,'');
                    setConIds.add(objUser.contactId); 
                    setInactiveUsers.add(objUser.id);      
                }           
            }
            if(mapLoginsToContact!=null && !(mapLoginsToContact.isEmpty())){if (System.isBatch() || System.isFuture()){
                    ClsUserTriggerHandler.updateContactPortalLogin(setConIds,mapLoginsToContact);}else{
                    updateContactPortalLoginBoolean = true;
                    setConIdsFuture = new set<Id>();
                    mapLoginsToContactFuture = new map<Id,String>();
                    setConIdsFuture = setConIds.clone();
                    mapLoginsToContactFuture = mapLoginsToContact.clone();}
            }
            if((newToOldLogins!=null && !(newToOldLogins.isEmpty()))){if (System.isBatch() || System.isFuture())
                { ClsUserTriggerHandler.updateASN(newToOldLogins);
                }else{updateASNBoolean=true;
                     newToOldLoginsFuture = newToOldLogins.clone();     
                }
            }
            if((newLoginsToInsert!=null && !(newLoginsToInsert.isEmpty()))){ if (System.isBatch() || System.isFuture())
                {ClsUserTriggerHandler.insertASN(newLoginsToInsert);
                }else{insertASNBoolean =true;
                        newLoginsToInsertFuture = newLoginsToInsert.clone();      
                }
            }
        }
        if(Trigger.isInsert || (Trigger.isUpdate && !managerUpdater.executed)){
            for(user usr:(List<User>)Trigger.New){
                if(usr.UserType=='PowerCustomerSuccess'){
                    if(Trigger.isInsert) {                    
                        if(usr.FederationIdentifier==null || usr.FederationIdentifier==''){user u=new user(id=usr.id);
                            u.FederationIdentifier=usr.id;
                            u.Portal_Login__c=usr.id;
                            system.debug('>>>>>>>>>>>>>>FederationIdentifier:'+u.FederationIdentifier);
                            lstusrs.add(u);
                        }
                        if(usr.contactid!=null){
                            setUIds.add(usr.id);        
                        }
                    }
                    else if(usr.Username!=triggerOldMap.get(usr.id).Username || usr.profileId!=triggerOldMap.get(usr.id).profileId || usr.TimeZoneSidKey!=triggerOldMap.get(usr.id).TimeZoneSidKey || usr.FederationIdentifier !=triggerOldMap.get(usr.id).FederationIdentifier){
                        setUIds.add(usr.id);    
                    }   
                }
            }
            //Update users which had null value for Federation Id
            if(lstusrs.size()>0 && checkRegressionUser){checkRegressionUser=false;
                update lstusrs;
            }
            //Update contact where corresponding users fields - User Name, Profile,Timezone - have been updated
            if(setUIds!=null && !setUIds.isEmpty() && checkRegressionCon ){
                checkRegressionCon=false;
                /** Modified for resolving Test Class Failures **/
                if (System.isBatch() || System.isFuture()){ClsUserTriggerHandler.updateContacts(setUIds);
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
        if(trigger.isUpdate  && !managerUpdater.executed){
            set<Id> setUserIdsToDeprovision = new set<Id>(); 
            for(User objUser:(List<User>)trigger.new){
                if(!objUser.isActive && triggerOldMap.get(objUser.ID).isActive && objUser.UserType=='PowerCustomerSuccess')
                {   setUserIdsToDeprovision.add(objUser.Id);                                                  
                }           
            }
            if(setUserIdsToDeprovision!=null && !(setUserIdsToDeprovision.isEmpty())){
                if (System.isBatch() || System.isFuture()){DesignSpecTriggerHandler.removeProvisioningForInactiveUsers(setUserIdsToDeprovision);
                }else{
                    DesignSpecTriggerHandler.removeProvisioningForInactiveUsersFuture(setUserIdsToDeprovision);
                }           
            }   
        }
        
        if(Trigger.isInsert){
            ClsUserTriggerHandler.userTriggerAfterInsertAsyncHandler(triggerNewMap.keySet(),assignTabAccessBoolean,updateEnabledContactBoolean,setUserIdsFuture,setContactIdsFuture,addPortalUserLoginToShortNameBoolean,updatecustomerPortaladminBoolean, setaccIdsFuture,updateContactPortalStatusProxyBoolean,updateContactsBoolean,setUIdsFuture);
        }
        
        if((Trigger.isUpdate && !managerUpdater.executed ) && recursiveController<(integer.valueOf(label.UserTriggerRecursionController))){

             ClsUserTriggerHandler.userTriggerAfterUpdateAsyncHandler(triggerNewMap.keySet(),updatecustomerPortaladminBoolean,setaccIdsFuture,updateContactPortalStatusProxyBoolean,updateASNBoolean,newToOldLoginsFuture,insertASNBoolean,newLoginsToInsertFuture,updateContactsBoolean,setUIdsFuture, updateContactPortalLoginBoolean,setConIdsFuture, mapLoginsToContactFuture,setInactiveUsers);
             recursiveController=recursiveController+1;     
        }
        
        Try{  
            List<id> supplierIds=new List<id>();
            List<id> supplierIdremoved= new List<Id>();
     
            if(Trigger.isInsert){     
                for(User u:(List<User>)Trigger.new){
                    if(u.profileid==label.SupplierProfileId){supplierIds.add(u.id);    
                    }    
                }
            }
     
            if(Trigger.isUpdate && !managerUpdater.executed){
                for(User usr : (List<User>)trigger.new){
                    if(usr.profileid!=triggerOldMap.get(usr.id).profileid && usr.profileid==label.SupplierProfileId)
                    {supplierIds.add(usr.id);        
                     
                    }else if(usr.profileid!=triggerOldMap.get(usr.id).profileid && triggerOldMap.get(usr.id).profileid==label.SupplierProfileId){
                     supplierIdremoved.add(usr.id);    
                    }
                }
             
            }
             
            // Add new supplier users to Supplier public group
            if(supplierIds!=null && supplierIds.size()>0){
                list<groupmember> grpmbr=new list<groupmember>();
                for(string uid :supplierIds){groupmember gm=new groupmember();
                    gm.userorgroupid=uid;
                    gm.groupid=label.SupplierGroupId;
                    grpmbr.add(gm);    
                }
                if(grpmbr!=null && grpmbr.size()>0){insert grpmbr;
                }
            }
     
            //Remove Supplier users from Supplier group for whom profile is changed to some other value
            if(supplierIdremoved!=null && supplierIdremoved.size()>0)
            {list<groupmember> lstsuppGrpMbr= new list<groupmember>();
                lstsuppGrpMbr = [select id from groupmember where userorgroupid in :supplierIdremoved and groupid=:label.SupplierGroupId];
            
                if(lstsuppGrpMbr!=null && lstsuppGrpMbr.size()>0){delete lstsuppGrpMbr;
                }
            }
            
        }catch(exception e){    
        system.debug('Error while adding valid users to Supplier group:'+e.getmessage());
        } 
             
        if(trigger.isUpdate && !managerUpdater.executed){
          if (System.isBatch() || System.isFuture()){
        
            }else{
               updateContactPortalStatusProxyBoolean=true;
            }         
        }
        
        system.debug('end>>>>>>>>>>userTriggerAfter :SOQL queries:'+limits.getQueries());        
    }
    
    public void userTriggerBefore(){
        system.debug('start>>>>>>>>>>userTriggerBefore :SOQL queries:'+limits.getQueries());   
        for(Profile objProfile: [Select Id, Name from Profile where Name LIKE '% Portal %']){
            setProfileIds.add(objProfile.Id);
        }      
        if(trigger.isInsert || (trigger.isUpdate && !managerUpdater.executed)){           
            for(User objUser : (List<User>)trigger.new){
                if(setProfileIds.contains(objUser.profileId) && objUser.isActive){
                    if(objUser.FederationIdentifier!=null){
                        if(trigger.isInsert){
                            setNewShortName.add(objUser.FederationIdentifier.toLowerCase()); 
                        }
                        else if(trigger.isUpdate){if(triggerOldMap.get(objUser.ID).FederationIdentifier!=null){
                                if(triggerOldMap.get(objUser.ID).IsActive){ if(objUser.FederationIdentifier.toLowerCase()!= triggerOldMap.get(objUser.ID).FederationIdentifier.toLowerCase()){
                                        setNewShortName.add(objUser.FederationIdentifier.toLowerCase());
                                    }
                                }
                                else{setNewShortName.add(objUser.FederationIdentifier.toLowerCase()); 
                                } 
                            }
                            else{setNewShortName.add(objUser.FederationIdentifier.toLowerCase()); 
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

            for(User objUser : (List<User>)trigger.new){
            
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
                                system.debug('objUser.FederationIdentifier::'+objUser.FederationIdentifier);

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
        
        //Sync Federation Id and Portal Login fields 
        if((Trigger.isUpdate && !managerUpdater.executed) || Trigger.isInsert){
            for(User u :(List<User>)Trigger.New){
                if(u.Portal_Login__c!=u.FederationIdentifier && u.UserType=='PowerCustomerSuccess'){
                    if(Trigger.isUpdate && (u.FederationIdentifier==null || u.FederationIdentifier=='')){
                        u.FederationIdentifier=u.id;
                    }u.Portal_Login__c=u.FederationIdentifier ;               
                }
            }
        }
        
        if(trigger.isUpdate && !managerUpdater.executed){
            if (System.isBatch() || System.isFuture()){
            }else{
            
                updateContactPortalStatusProxyBoolean=true;
            }         
        }
        /*for(Profile objProfile: [Select Id, Name from Profile where Name LIKE '% Portal %']){
            setProfileIds.add(objProfile.Id);
        } */ 
        system.debug('end>>>>>>>>>>userTriggerBefore :SOQL queries:'+limits.getQueries());                  
    }  
     
}