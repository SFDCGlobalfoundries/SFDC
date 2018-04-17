/**
Type Name: ClsUserTriggerHandler
Author: Cognizant 
Created Date: 25-April-2013
Reason: This class is used for creating two records in Contact External Application object - one for FTP and
        another for FV access - whenever a Contact is enabled as a portal User
Change History: Case-2443
Author: 
Modified Date: Nov-07-2013
Reason: Merging Multiple Future methods into one in order to avoid Future Method limits exception.
Change History: Case-3283
Author: Cognizant FV Team
Modified Date: Dec-10-2013
Reason: Correcting User Created Flag, Login ID and Access Set UP record creation during portal user enabling.
Change History: Case-3922
Author: Cognizant FV Team
Modified Date: Jan-08-2014
Reason: Introducing future call handler for User Changes in order to avoid future method calling future method
Change History: Case-4489
Author: Cognizant FV Team
Modified Date: Jan-08-2014
Reason: Replacing Document owner who get deactivated by default owner.

Author:- Suvajit Majumder
Modified Date:- Aug-2016
Reason:- New requirement for DWP project on Customer Portal

Modified By: Abhita Bansal
Modified Date: 14/6/2017
Reason: Added the logic for FMS Project.
……..
……..
**/
public class ClsUserTriggerHandler{

    
    public static Map<String, Contact_Portal_tab_access__c> mapDeptTab = Contact_Portal_Tab_Access__c.getAll();
    /*public static Id permSetMyDevices = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_My_Devices'].Id;
    public static Id permSetMyWafers = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_My_Wafers'].Id;
    public static Id permSetDesignDocs = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_PDK_Design_Documents'].Id;
    public static Id permSetProductsServices = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_Product_Services'].Id;
    */
    
    public static Id permSetSupplierServices = [Select Id,Name from PermissionSet where Name='Tab_Access_to_Supplier_Service_Portal_All_License'].Id;
    
    
    
    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method updates the Contact record enabled as a portal user by setting the Is Portal User Active flag
        to checked. This method also updates the Login Id field of Contact record with the value of Portal Login
        field of the corresponding Portal User record.
        
        @method name: updateEnabledContact
        @parameter:   Set of Ids of Created Portal Users and set of Ids of corresponding Portal Contacts.
        @return :     none
    **/
       
//  @future //Case:2443:Commenting out future call- Bundling in multiple asynchronous calls into one handler asynchronous method.
    public static void updateEnabledContact(Set<Id> userIds, Set<Id> setContactIds){
    
        System.debug(' ** Method Execution Started: updateEnabledContact** ' );
        
      //Case-3283 Change-001: Adding FederationID in SOQL and Replacing Portal_Login in contact update :Start
        Map<Id, User> mapPortalUsers = new Map<Id, User>();
        List<Contact> lstContact = new List<Contact> ();
        
            if(userIds!=null && !(userIds.isEmpty())){
            System.debug (' ** Size of Set of Portal User Ids created is ** ' + userIds.size());       
        
            for(User objUser: [Select Id, Name,Username,User_Profile_Name__c,TimeZoneSidKey,federationidentifier, Portal_Login__c, HCM_Login_ID__c, contactId from User where Id IN:userIds]){
            
                mapPortalUsers.put(objUser.contactId, objUser);
            }
            
            if(setContactIds!=null && !(setContactIds.isEmpty())){
                System.debug (' ** Size of Set of Contact Ids to be updated is ** ' + setContactIds.size());
                
                User currentUser = [select id, Name, HCM_Login_ID__c from User where id = :Userinfo.getUserId()];
                
                for(Contact objContact: [Select Id, Name, Login_Id__c, HCM_Login_ID__c, Is_Portal_User_Active__c, Is_Portal_User_Created__c,Account.Region__c,Account.Corporate_Country__c,ftplocation__c from Contact 
                                where Id IN:setContactIds]){
                                
                      objContact.Is_Portal_User_Active__c = true;
                      objContact.Is_Portal_User_Created__c = true;
                      //objContact.Login_Id__c = mapPortalUsers.get(objContact.Id).Portal_Login__c;
                      objContact.Login_Id__c = (mapPortalUsers.get(objContact.Id).federationidentifier).tolowercase();
                      objContact.User_Name__c = mapPortalUsers.get(objContact.Id).Username;
                      objContact.User_Profile_Name__c = mapPortalUsers.get(objContact.Id).User_Profile_Name__c;
                      objContact.User_Time_Zone__c= mapPortalUsers.get(objContact.Id).TimeZoneSidKey;
                    /**
                    When a contact is enabled as portal user & if the Account region is "GC", then the "FTP PDK Location" value should be set to "CN", and remove the "SGP"
                        case#00053617--- Jabee---
                    **/                          
                        if(objContact.Account.Corporate_Country__c=='China'){
                            objContact.ftplocation__c='CN';
                          }
                  /** Case#00053617 END---------**/     
               //Case-3283 Change-001: Adding FederationID in SOQL and Replacing Portal_Login in contact update :End       
               
                   if(currentUser.HCM_Login_ID__c!=null){
                          objContact.HCM_Login_ID__c= currentUser.HCM_Login_ID__c;
                      }
                      lstContact.add(objContact);                       
                }
                
                if(lstContact!=null && !(lstContact.isEmpty())){
                    updatePortalContact(lstContact); 
                }
            }
        }
        
        System.debug(' ** Method Execution Ended: updateEnabledContact** ' );
        
    } 
    
    /**
        This method updates the Portal Contact record into Salesforce.Com database
        
        @method name: updatePortalContact
        @parameter:   List of Contact records to be updated
        @return :     none
    **/
        
    private static void updatePortalContact (List<Contact> lstContact){
        
        System.debug(' ** Method Execution Started: updatePortalContact ** ' );
                     
        try{
            System.debug(' ** Size of List lstContact to be updated is ** ' + lstContact.size());
            update lstContact;              
        }
        catch(DMLException ex){
            System.debug(' ** Exception Message is ** ' + ex.getMessage());
            
        }       
        
        System.debug(' ** Method Execution Ended: updatePortalContact  ** ' );
             
    }
    
    /**
        This future method adds value of Portal Login field of User object to Login Id field of corresponding 
        Contact record and updates Is Portal User Active field to true. This method also creates 2 records in
        Account Short Name object - one for Portal Login and another for Contact Id Fields
        
        @method name: addPortalUserLoginToShortName
        @parameter:   Set of Ids of Created Portal Users 
        @return :     none
    **/
      
   // @future
    public static void addPortalUserLoginToShortName(Set<Id> userIds){
    
        System.debug(' ** Method Execution Started: addPortalUserLoginToShortName ** ' );
        
        List<Account_Short_Name__c> lstAccShortName = new List<Account_Short_Name__c> ();
          
        if(userIds!=null && !(userIds.isEmpty())){
            System.debug (' ** Size of Set of Portal User Ids created is ** ' + userIds.size());
            
            for(User objUser: [Select Id, Name, FederationIdentifier, contactId from User where Id IN:userIds]){
            
                lstAccShortName.add(createNewAccountShortName(objUser.FederationIdentifier));                     
                //lstAccShortName.add(createNewAccountShortName(objUser.contactId)); 
            } 
            
            if(lstAccShortName!=null && !(lstAccShortName.isEmpty())){
                insertAccountShortName(lstAccShortName); 
            }
        }      
                
        System.debug(' ** Method Execution Ended: addPortalUserLoginToShortName ** ' );
    }
    
    /**
        This method creates a new Account Short Name record with input from the Portal Login and Contact Id fields
        of Portal User record
        
        @method name: createNewAccountShortName
        @parameter:   User fields - Portal Login and Contact Id 
        @return :     New Account Short Name record
    **/
    
    private static Account_Short_Name__c createNewAccountShortName (String userField){
        
        System.debug(' ** Method Execution Started: createNewAccountShortName ** ' );
        
        Account_Short_Name__c objAccShortName = new Account_Short_Name__c();
        objAccShortName.Account_Short_Name__c = userField.toLowerCase();
       
        System.debug(' ** Method Execution Ended: createNewAccountShortName ** ' );
        
        return objAccShortName;
             
    }
    
    /**
        This method inserts the new Account Short Name record into Salesforce.Com database
        
        @method name: insertAccountShortName
        @parameter:   List of Account Short Name records to be inserted 
        @return :     none
    **/
       
    private static void insertAccountShortName (List<Account_Short_Name__c> lstAccShortName){
        
        System.debug(' ** Method Execution Started: insertAccountShortName ** ' );
                      
        try{
            System.debug(' ** Size of List lstAccShortName to be inserted is ** ' + lstAccShortName.size());
            insert lstAccShortName;              
        }
        catch(DMLException ex){
            System.debug(' ** Exception Message is ** ' + ex.getMessage());
            
        }       
        
        System.debug(' ** Method Execution Ended: insertAccountShortName ** ' );
             
    }    
    /** Modified By Cognizant on 25042013 End
     **/
     
        /**
        This method updates the user to a public group
        
        @method name: addPortalUsertoGroup
        @parameter:   Set of Ids of Created Portal Users and set of Ids of corresponding Portal Contacts.
        @return :     none
    **/      
       public static void addPortalUsertoGroup(Set<Id> userIds){
             /** Modified by Cognizant on 20130426 To Assist in Adding Portal User To Group Start **/        
                     
             set<Id> setProfileIds = new set<Id>();
             List<Group> lstPublicGroups = new List<Group>();
             List<GroupMember>listGroupMember =new List<GroupMember>();
             Group publicgroup=new Group();
               
             /** Checking for the profiles related to Customer Portal Users
              **/
             for(Profile objProfile: [Select Id, Name from Profile where Name LIKE '% Portal %']){
                 setProfileIds.add(objProfile.Id);
             } 
             
             for(Group objGroup:[SELECT Id FROM Group where Name =: System.Label.Portal_User_Group]){
                 lstPublicGroups.add(objGroup);    
             }
             if(lstPublicGroups!=null && lstPublicGroups.size()>0){
                 publicgroup = lstPublicGroups[0];
             }         
             
             
             /** Optimizing Query using FOR SOQL Query
              **/
             for(User objUser: [Select Id,Name from User Where Id IN :userIds and profileId IN: setProfileIds]){
                  
                  GroupMember publicgroupmember= new GroupMember(); 
                  publicgroupmember.GroupId=publicgroup.id;
                  publicgroupmember.UserOrGroupId = objUser.id;
                   
                  listGroupMember.add(publicgroupmember);
             }
             
             /** Always checking for NULL and EMPTY List before inserting the List into Database
              **/             
             if(listGroupMember!=null && listGroupMember.size()>0){
                try{
                    insert listGroupMember;
                }
                catch(DmlException ex){
                    System.debug(' ** Exception encountered in Adding Public Group member is ** ' + ex.getMessage());
                }   
            } 
            
            /** Modified by Cognizant on 20130426 To Assist in Adding Portal User To Group End **/    
                
           /*else {
              System.debug('This user is not Customer Profile User. Hence not added to group.');
          } 
            } catch(DMLException de){
            System.debug(de.getMessage());
        }*/
    }
    
       /** Modified By Cognizant 
     **/
     
    /**
        This method inserts new Permission Sets for the newly created Portal Users having a Contact department
        
        @method name: insertPermissionSets
        @parameter:   Set of Ids of Created Portal Users.
        @return :     none
    **/ 
    //Method updated by Sunil for case # 22649, to optimize the code and to make it work for Overage profiles as well 
    public static void insertPermissionSets(Set<Id> userIds){
        List<String> permSetNameLst=new List<String>();
        Map<String,Id> permSetMap=new Map<String,Id>();
        Map<String,Id> permSetOverageMap=new Map<String,Id>();
        Set<Id> permSetIdSet=new Set<Id>();
        Set<Id> overagePermSetIdSet=new Set<Id>();
        List<String> lstDepts=new List<String>();
        Set<String> existingPermSetAssignmentSet=new Set<String>();
        List<PermissionSetAssignment> permissionsetDeleteList= new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> permissionsetInsertList= new List<PermissionSetAssignment>();
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_My_Devices);
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_My_Wafers);
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents);
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_Product_Services);
        permSetNameLst.add(System.Label.Tab_Access_PermissionSetOnSupplierService);
        permSetNameLst.add(System.Label.Tab_Access_PermissionSetOnVendorServices);
        permSetNameLst.add(System.Label.Standard_Tab_access_for_non_vendor_services);
        permSetNameLst.add(System.Label.FMS_External_Users);// Added By Abhita for FMS Project
        
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices);
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers); 
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents);
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services);
        permSetNameLst.add(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService);
        permSetNameLst.add(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices);
        permSetNameLst.add(System.Label.Overage_Standard_Tab_access_for_non_vendor_services);
        permSetNameLst.add(System.Label.Overage_FMS_External_Users); // Added By Abhita for FMS Project
        
        //To fetch 14 permission sets
        
        PermissionSet[] pSetRecordsLst=[Select Id,Name from PermissionSet where Name IN: permSetNameLst];
        for(Integer i=0;i<pSetRecordsLst.size();i++)
        {
            String chkOverage=pSetRecordsLst[i].Name;
            if(chkOverage.contains('Overage'))
            {
                permSetOverageMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                overagePermSetIdSet.add(pSetRecordsLst[i].Id);
            }
            else if(chkOverage.contains('All_License'))
            {
                permSetOverageMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                overagePermSetIdSet.add(pSetRecordsLst[i].Id);
                
                permSetMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                permSetIdSet.add(pSetRecordsLst[i].Id);
            }
            else
            {
                permSetMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                permSetIdSet.add(pSetRecordsLst[i].Id);
            }
           
        }
        //To fetch users and related contact records  // Added By Abhita for FMS Project
        User[] usrRecordLst=[Select Id,ContactId,Contact.department__c,Contact.Account.Fab_9_10__c,CreatedDate,LastModifiedDate, ProfileId,Profile.Name,(Select My_Devices__c, My_Wafers__c, PDK_Design_Documents__c, Product_Services__c,Supplier_Services__c,Vendor_Services__c,Tapeout_Fab_9_10__c From Portal_Tab_Access__r Limit 1), (Select Id, AssigneeId, PermissionSetId From PermissionSetAssignments) from User where ContactId!=null and Id IN:userIds];
        for (Integer i=0;i<usrRecordLst.size();i++){
            String profileName=usrRecordLst[i].Profile.Name;
            
            if(usrRecordLst[i].PermissionSetAssignments.size()>0){
                for(Integer j=0;j<usrRecordLst[i].PermissionSetAssignments.size();j++){
                    //To delete unwanted permission sets
                    if((profileName.contains('Overage') && permSetIdSet.contains(usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId)) || (!profileName.contains('Overage') && overagePermSetIdSet.contains(usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId))){
                        permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);                   
                    }else{
                        if(usrRecordLst[i].Portal_Tab_Access__r.size()>0){
                            if(profileName.contains('Overage')){
                                
                                if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='No' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.FMS_External_Users)){
				                  permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
				                }// Added By Abhita for FMS Project
                                
                                //code for vendor services as per DWP requirement
                                if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }
                            }else{
                                if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='No' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.FMS_External_Users)){
				                  	permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
				                }// Added By Abhita for FMS Project
                                
                                //code for vendor services as per DWP requirement
                                if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }
                                    
                               
                            }
                            
                        }
                        
                        existingPermSetAssignmentSet.add(usrRecordLst[i].PermissionSetAssignments[j].AssigneeId+'|'+usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId);
                        
                    }
                }
                //code to run while inserting users
                if(usrRecordLst[i].CreatedDate ==usrRecordLst[i].LastModifiedDate && usrRecordLst[i].Contact.department__c!=null){
                    String st = usrRecordLst[i].Contact.department__c;
                    if(st.contains(';')){
                        lstDepts=st.split(';');
                    }else{
                         lstDepts.add(st);
                    }
                    
                    
                    for(String dept: lstDepts){
                        Contact_Portal_tab_access__c pta = mapDeptTab.get(dept);
                        if(pta !=null){
                            //to insert/upsert permission sets for overage profile
                            if(profileName.contains('Overage')){
                                if(pta.My_Devices__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices))){
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices));
                                }if(pta.My_wafers__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers));
                                }if(pta.PDK_Design_Documents__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents))){
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents));
                                }if(pta.Product_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services));
                                }if(pta.Supplier_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService));
                                }
                                //code for vendor services as per DWP requirement
                                if(pta.Vendor_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices));
                                }
                                if(!pta.Vendor_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services));
                                }if(pta.Tapeout_Fab_9_10__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_FMS_External_Users))){
                  					permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_FMS_External_Users)));
                  					existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_FMS_External_Users));
                 				}//Added By Abhita for FMS Project
                                
                            }else{
                                if(pta.My_Devices__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices))){
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices));
                                }if(pta.My_wafers__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers));
                                }if(pta.PDK_Design_Documents__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents))){
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents));
                                }if(pta.Product_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services));
                                }if(pta.Supplier_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService));
                                }if(pta.Tapeout_Fab_9_10__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.FMS_External_Users))){
                  					permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.FMS_External_Users)));
                  					existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.FMS_External_Users));
                				}  //Added By Abhita for FMS Project
                                
                                //code for vendor services as per DWP requirement
                                if(pta.Vendor_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices));
                                }
                                if(!pta.Vendor_Services__c && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services))){ 
                                    permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services)));
                                    existingPermSetAssignmentSet.add(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services));
                                }
                            }       
                        }
                        
                        
                    }
                }else{
                    if(usrRecordLst[i].Portal_Tab_Access__r.size()>0){
                        if(profileName.contains('Overage')){
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService));
                            }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='Yes' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_FMS_External_Users))){
                 				permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_FMS_External_Users)));
                 				existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_FMS_External_Users));
             				}  //Added By Abhita for FMS Project
                            
                            //code for vendor services as per DWP requirement
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices));
                            }
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services));
                            }
                        }else{
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService));
                            }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='Yes' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.FMS_External_Users))){
                				permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.FMS_External_Users)));
                				existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.FMS_External_Users));
              				}  // Added By Abhita for FMS Project
                            
                            //code for vendor services as per DWP requirement
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices));
                            }
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services));
                            }
                        }
                        
                    }
                }   
            }
            
            
        }
        
        try{
            
            if(permissionsetDeleteList.size()>0)
            {
                delete permissionsetDeleteList;
            }
            if (permissionsetInsertList.size()>0)
            {
                insert permissionsetInsertList;
            
            }
            
        }catch(DMLException ex){
            System.debug(' ** Exception encountered in Inserting Permission Sets is ** ' + ex.getMessage());
        }
    }

    
    /**
        This future method creates portal tab access records for the users
        
        @method name: insertPTAFuture
        @parameter:   Set of Ids of Created Portal Users and set of Ids of corresponding Portal Contacts.
        @return :     none
    **/
    
    @future
    public static void insertPTAFuture(Set<Id> userIds){
        portalTabAccessTriggerHandler.assignTabAccess(userIds);
    }
    
   
    /** Modified By Cognizant 
     **/
    /**
        This method update contact record of portal user
        
        @method name: updateContactPortalStatus
        @parameter:   Set of Ids of Created Portal Users and set of Ids of corresponding Portal Contacts.
        @return :     none
    **/
    @future
    public static void updateContactPortalStatus(Set<Id> userIds,String operation){
        ClsUserTriggerHandler.updateContactPortalStatusProxy(userIds,operation,false);
        
    }   
    
        /** Modified By Cognizant 
     **/
    /**
        This method update contact record of portal user if called directly from a standard or custom object
        
        @method name: updateContactPortalStatus
        @parameter:   Set of Ids of Created Portal Users and set of Ids of corresponding Portal Contacts.
        @return :     none
    **/
    public static void updateContactPortalStatusProxy(Set<Id> userIds,String operation,Boolean blnDirectCall){
        try{
            // Get the Profile Name for the user created. 
            //Profile objProfile = [Select Name from Profile where Id in (Select Profileid from user where Id IN :userIds)];
            List<User> userList=[Select Profile.Name, ProfileId,Id,ContactId,IsActive From User Where Id IN:userIds];
            Map<Id,User> userMap=new Map<Id,User>();
            for (User objUser:userList){
                //Modified by Sunil Arora for Case # 10023 to add OverageCustomerPortalProfile
                if(objUser.Profile.Name==System.Label.CustomerPortalAdmin || 
                    objUser.Profile.Name==System.Label.CustomerPortalProfile || 
                    objUser.Profile.Name==System.Label.OverageCustomerPortalAdmin || 
                    objUser.Profile.Name==System.Label.OverageCustomerPortalProfile || 
                    objUser.Profile.Name==System.Label.OverageSupplierPortalProfile || 
                    objUser.Profile.Name==System.Label.OverageSupplierPortalAdmin || 
                    objUser.Profile.Name==System.Label.OverageResellerPortalProfile || 
                    objUser.Profile.Name==System.Label.OverageResellerPortalAdmin || 
                    objUser.Profile.Name==System.Label.OverageEnablementPartnerPortalProfile || 
                    objUser.Profile.Name==System.Label.OverageEnablementPartnerPortalAdmin || 
                    objUser.Profile.Name==System.Label.EnablementPartnerPortalAdmin || 
                    objUser.Profile.Name==System.Label.EnablementPartnerPortalProfile || 
                    objUser.Profile.Name==System.Label.ResellerPortalAdmin || 
                    objUser.Profile.Name==System.Label.ResellerPortalProfile || 
                    objUser.Profile.Name==System.Label.SupplierPortalAdmin || 
                    objUser.Profile.Name==System.Label.SupplierPortalProfile)   
                    {
                        userMap.put(objUser.Id,objUser);    
                    }       
            }
            
            Set<Id> contactIds=new Set<Id>();
            // If Insert operation is called. 
            if (operation.equals('Insert') && userMap.size()>0)
            {
                for(User objUser:userMap.values())
                {
                    contactIds.add(objUser.ContactId);      
                }
                List<Contact> contactList = [SELECT Id,Is_Portal_User_Active__c,Is_Portal_User_Created__c FROM Contact WHERE id IN:contactIds];
                for (Contact contactObj:contactList)
                {
                    contactObj.Is_Portal_User_Active__c = true;  
                    contactObj.Is_Portal_User_Created__c = true;    
                }   
                update contactList;
                
            }
            // If Update operation is called.
            else if (operation.equals('Update') && userMap.size()>0) 
            {
                for(User objUser:userMap.values())
                {
                    contactIds.add(objUser.ContactId);      
                }
                List<Contact> contactList = [SELECT Id,Is_Portal_User_Active__c,Is_Portal_User_Created__c FROM Contact WHERE id IN:contactIds];
                for (User objUser:userMap.values())
                {
                    for (Contact contactObj:contactList)
                    {
                        System.debug('$$$$$$$$$$$$$$ In Loop' + contactObj.id);
                        System.debug('%%%%%%%%%%%%%% In Loop' + objUser.ContactId);
                        if (contactObj.id==objUser.ContactId)
                        {
                            System.debug('**************** IS MATCH');
                            if(objUser.IsActive==false)
                            {
                                System.debug('$$$$$$$$$$$$$$ In Loop');
                                contactObj.Is_Portal_User_Active__c = false;                                    
                            }
                            else if(objUser.IsActive==true)
                            {
                            
                                if (blnDirectCall==true)
                                {
                                    contactObj.Is_Portal_User_Active__c = false;        
                                } else if (blnDirectCall==false){
                                    contactObj.Is_Portal_User_Active__c = true;
                                   //Case-3283 Change-002: Updating Is Portal User Created flag: Start
                                    contactObj.Is_Portal_User_Created__c = true;
                                    //Case-3283 Change-002: Updating Is Portal User Created flag: End                                    
                                }   
                            }
                        }
                    }
                }
                update contactList;
            }
            
            /*
            // If Insert operation is called. 
            if(operation.equals('Insert')){
                if(objProfile.Name==System.Label.CustomerPortalAdmin || 
                    objProfile.Name==System.Label.CustomerPortalProfile || 
                    objProfile.Name==System.Label.EnablementPartnerPortalAdmin || 
                    objProfile.Name==System.Label.EnablementPartnerPortalProfile || 
                    objProfile.Name==System.Label.ResellerPortalAdmin || 
                    objProfile.Name==System.Label.ResellerPortalProfile || 
                    objProfile.Name==System.Label.SupplierPortalAdmin || 
                    objProfile.Name==System.Label.SupplierPortalProfile)
                {
     
                    Contact contactObj = [SELECT Id FROM Contact WHERE id IN:contactIds];
                    contactObj.Is_Portal_User_Active__c = true;  
                    contactObj.Is_Portal_User_Created__c = true;  
                    update contactObj;         
     
                }        
            // If Update operation is called.
            } 
            else if (operation.equals('Update'))
            {
                if(objProfile.Name==System.Label.CustomerPortalAdmin || 
                    objProfile.Name==System.Label.CustomerPortalProfile || 
                    objProfile.Name==System.Label.EnablementPartnerPortalAdmin || 
                    objProfile.Name==System.Label.EnablementPartnerPortalProfile || 
                    objProfile.Name==System.Label.ResellerPortalAdmin || 
                    objProfile.Name==System.Label.ResellerPortalProfile || 
                    objProfile.Name==System.Label.SupplierPortalAdmin || 
                    objProfile.Name==System.Label.SupplierPortalProfile)
                {
                 
                    List<User> userList = [SELECT IsActive FROM User where Id IN :userIds];
                    Contact contactObj = new Contact();
                    List<Contact> contactAddList = new List<Contact>();
                    if(userList.size() > 0){
                        for(User userObj : userList){
                            if(userObj.IsActive==false){
                                contactObj = [SELECT Id FROM Contact WHERE id = :contactId];
                                contactObj.Is_Portal_User_Active__c = false;  
                                contactAddList.add(contactObj);
                            } else if(userObj.IsActive==true){
                                contactObj = [SELECT Id FROM Contact WHERE id = :contactId];
                                contactObj.Is_Portal_User_Active__c = true;  
                                contactAddList.add(contactObj);                          
                            }
                        }
                      
                    }
                    update contactAddList;         
                }             
            }*/
        }catch(DMLEXception de){
            System.debug(de.getMessage());
        }   
    }
    
    /**
        This future method deletes portal login records from Account Short Name object whenever portal users are deactivated. 
        
        @method name: deleteAccountShortNameFuture 
        @parameter:   Set of portal login Ids to be deleted.
        @return :     none
    **/ 
    
    @future
    public static void deleteAccountShortNameFuture(Set<String> setPortalLogins){
        deleteAccountShortName(setPortalLogins);
    }
    
    /**
        This method deletes portal login records from Account Short Name object whenever portal users are deactivated. 
        
        @method name: deleteAccountShortName 
        @parameter:   Set of portal login Ids to be deleted.
        @return :     none
    **/ 
    
    public static void deleteAccountShortName(Set<String> setPortalLogins){
        List<Account_Short_Name__c> lstAccShortName = new List<Account_Short_Name__c> ();
        if(setPortalLogins!=null && setPortalLogins.size()>0){
             for(Account_Short_Name__c ASN:[Select Id, Name, Account_Short_Name__c from Account_Short_Name__c where Account_Short_Name__c IN: setPortalLogins]){
                lstAccShortName.add(ASN); 
             }
             if(lstAccShortName!=null && lstAccShortName.size()>0){
                 try{
                     delete lstAccShortName;
                 }
                 catch(DmlException ex){
                     System.debug('***Exception faced in deleting Account Short Name is*** ' + ex);
                 }
             }
        }
           
    } 
    
     /**
        This future method updates portal login field of Contact object whenever login Id field of portal user is modified. 
        
        @method name: updateContactPortalLoginFuture 
        @parameters:  Set of Ids of Contacts to be updated, Map of Contact Ids to Portal Loguin Ids.
        @return :     none
    **/
    
    @future
    public static void updateContactPortalLoginFuture(set<Id> setConIds,map<Id,String> mapLoginsToContact){
        updateContactPortalLogin(setConIds,mapLoginsToContact);
    }
    
    /**
        This method updates portal login field of Contact object whenever login Id field of portal user is modified. 
        
        @method name: updateContactPortalLogin 
        @parameters:  Set of Ids of Contacts to be updated, Map of Contact Ids to Portal Loguin Ids.
        @return :     none
    **/
    
    public static void updateContactPortalLogin(set<Id> setConIds,map<Id,String> mapLoginsToContact){
        List<Contact> lstContactToUpdate = new List<Contact> ();
        if(setConIds!=null && setConIds.size()>0){
             for(Contact con:[Select Id, Name, Login_Id__c from Contact where Id IN: setConIds]){
                con.Login_Id__c = (mapLoginsToContact.get(con.Id)).tolowercase();
                lstContactToUpdate.add(con); 
             }
             if(lstContactToUpdate!=null && lstContactToUpdate.size()>0){
                 try{
                     update lstContactToUpdate;
                 }
                 catch(DmlException ex){
                     System.debug('***Exception faced in updating Contact is*** ' + ex);
                 }
             }
        }
           
    } 
    
    /**
        This future method updates portal login record of Account Short Name object whenever login Id field of portal user is modified. 
        
        @method name: updateASNFuture 
        @parameters:  Map of Old Portal Login Ids to New Portal Login Ids.
        @return :     none
    **/
     /** //Case:2443:Commenting out future call- Bundling in multiple asynchronous calls into one handler asynchronous method.   
    @future
    public static void updateASNFuture(map<String,String> oldtoNewLogins){
        updateASN(oldtoNewLogins);
    }
    **/    
    /**
        This method updates portal login record of Account Short Name object whenever login Id field of portal user is modified. 
        
        @method name: updateASN 
        @parameters:  Map of Old Portal Login Ids to New Portal Login Ids.
        @return :     none
    **/
    
    public static void updateASN(map<String,String> oldtoNewLogins){
        List<Account_Short_Name__c> lstASNToUpdate = new List<Account_Short_Name__c> ();
      
        if(oldtoNewLogins!=null && oldtoNewLogins.size()>0){
             for(Account_Short_Name__c objASN:[Select Id, Name, Account_Short_Name__c from Account_Short_Name__c where Account_Short_Name__c IN: oldtoNewLogins.keySet()]){
                objASN.Account_Short_Name__c  = oldtoNewLogins.get(objASN.Account_Short_Name__c);
                lstASNToUpdate.add(objASN); 
             }
             if(lstASNToUpdate!=null && lstASNToUpdate.size()>0){
                 try{
                     update lstASNToUpdate;
                 }
                 catch(DmlException ex){
                     System.debug('***Exception faced in updating Account Short Name is*** ' + ex);
                 }
             }
        }
           
    }
    
    /** //Case:2443:Commenting out future call- Bundling in multiple asynchronous calls into one handler asynchronous method.
    @future
    public static void insertASNFuture(List<String> newLoginsToInsert){
        insertASN(newLoginsToInsert);
    }
    **/
    public static void insertASN(List<String> newLoginsToInsert){
        List<Account_Short_Name__c> lstASNToInsert = new List<Account_Short_Name__c> ();
      
        if(newLoginsToInsert!=null && newLoginsToInsert.size()>0){
             for(String strASN: newLoginsToInsert){
                Account_Short_Name__c objASN = new Account_Short_Name__c();
                objASN.Account_Short_Name__c = strASN;
                lstASNToInsert.add(objASN); 
             }
             if(lstASNToInsert!=null && lstASNToInsert.size()>0){
                 try{
                     insert lstASNToInsert;
                 }
                 catch(DmlException ex){
                     System.debug('***Exception faced in updating Account Short Name is*** ' + ex);
                 }
             }
        }
           
    }
/*------------------------------------------------------------------------------------*/

/**
        This future method updates the customer portal admin field in account
        
        @method name: updatecustomerPortaladmin
        @parameter:   Set of account Ids related to Portal user.
        @return :     none  **/
         
  //@future

    public static void updatecustomerPortaladmin(Set<Id> accId)
      {
          /*List<Id> accIdList=new List<Id>();
          for(User userrec:userlist)
       {

        accIdList.add(userrec.AccountId);
       
       }*/
       
       
       //Retrieves the profile id for all portal admin
       //Code added by Sunil for case # 5650
                  List<String> profileNameList=new List<String>();
                  profileNameList.add(System.Label.CustomerPortalAdmin);
                  profileNameList.add(System.Label.OverageCustomerPortalAdmin);
                  profileNameList.add(System.Label.OverageSupplierPortalAdmin); 
                  profileNameList.add(System.Label.OverageResellerPortalAdmin); 
                  profileNameList.add(System.Label.OverageEnablementPartnerPortalAdmin);  
                  profileNameList.add(System.Label.EnablementPartnerPortalAdmin);
                  profileNameList.add(System.Label.ResellerPortalAdmin);
                  profileNameList.add(System.Label.SupplierPortalAdmin);
                  Boolean blnAllowUserProfile=false;
                  
                  Set<Id> profileIdSet = new Set<Id>();
                  for (Profile objProfile:[Select id from Profile where Name IN: profileNameList]){
                      profileIdSet.add(objProfile.Id);
                  }
       
       
       
       
       //fetching the list of accounts
       
      List<Account> accList=[Select id,
                                    Customer_Portal_Admin__c
                                    from Account
                                    where Id in:accId];
                                    
      //fetching the list of users
      //ProfileId added by Sunil in query for case # 5650                               
      List<User> userList=[Select id,ProfileId,
                                   profile.name
                                   from User
                                   where AccountId in:accId];
                                   
      ////Code modified from list to map 
       //List<Account> updateaccList = new List<account>();  
       Map<Id,Account> updateaccMap=new Map<Id,Account>();

       for(account  accObj:accList)
          {
           system.debug('@@@enter loop');
           
           //Code modified by Sunil for case # 5650
           for(User usrobj:userList){
             if(accObj.Customer_Portal_Admin__c!=null && !profileIdSet.contains (usrobj.ProfileId)){
               accObj.Customer_Portal_Admin__c=null;
               updateaccMap.put(accObj.Id,accObj);
             }
           }
           
           
           
           
           
               for(User userobj:userList)
        
              {
               system.debug('@@@enter loop1');
               //checking if customer portal admin in account is blank
                   if(accObj.Customer_Portal_Admin__c==null)
                   {
            
                         system.debug('@@@enter if 1');
 //checking the profile for the users with the portal admin profiles
                         
                         //if(userobj.profile.name==System.Label.CustomerPortalAdmin || userobj.profile.name==System.Label.EnablementPartnerPortalAdmin || userobj.profile.name==System.Label.ResellerPortalAdmin || userobj.profile.name==System.Label.SupplierPortalAdmin )
                         if(profileIdSet.contains (userobj.ProfileId))
                        {
                
                              system.debug('@@@enter if');
                              system.debug('@@@enter if'+userobj.profile.name);
    //updating the customer portal admin field with the user who is with portal admin profile            
                           accObj.Customer_Portal_Admin__c=userobj.Id;
                            //updateaccList .add(accObj);
                            updateaccMap.put(accObj.Id,accObj);
                        }
                  }
               }
    
    
          }

    try
   {
    update   updateaccMap.values() ;
   }
  catch(Exception e){
          system.debug('update list'+e);
          }
          //End of code by Sunil for case # 5650
}
/*--------------------------------------------------------------------------------------*/

// This method updates User related informaiton on contact for portal users
/** Modified for resolving Test Class Failures **/
/** //Case:2443:Commenting out future call- Bundling in multiple asynchronous calls into one handler asynchronous method.
@future
public static void updateContactsFuture(set<id> userIds){
    updateContacts(userIds);    
}
**/
/** Modified for resolving Test Class Failures **/

public static void updateContacts(set<id> userIds){
list<contact> lstContacts= new list<contact>();
//Case-3283 Change-004: Adding Federatioidentifier in SOQL: Start/End
for(user usr:[select contactid,Username,User_Profile_Name__c,TimeZoneSidKey,federationidentifier from user where id in :userIds]){
    contact con=new contact(id=usr.contactid);
    con.User_Name__c = usr.Username;
    con.User_Profile_Name__c = usr.User_Profile_Name__c;
    con.User_Time_Zone__c= usr.TimeZoneSidKey;
   //Case-3283 Change-005: Updating Is Portal User Created flag & Login ID: Start
    con.is_portal_user_created__c= true;
    con.login_Id__c= (usr.federationidentifier).tolowercase();   
    //Case-3283 Change-005: Updating Is Portal User Created flag & Login ID: End    
    lstContacts.add(con);
    }
    system.debug('>>>>lstContacts:'+lstContacts);
    if(lstContacts.size()>0){
        try{
            update lstContacts;
        }catch(exception e){}
    }
}

/************************** insert Permission set for Supplier Service User******************/
 public static void insertPermissionSetsSupplierService(Set<Id> userIds,Boolean isUpdate){
               
        set<string> setUserIds = new set<string>();
        Boolean doInsert = True;
        List<PermissionSetAssignment> perSetAssigListExist = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> permissionsetinsertList= new List<PermissionSetAssignment>();
         if(isUpdate)
            {
            List<Id> UserIdExist = new List<Id>(); 
             for(PermissionSetAssignment permSet : [SELECT Id,PermissionSetId,AssigneeId FROM PermissionSetAssignment where AssigneeId IN : userIds And PermissionSetId =: permSetSupplierServices])
              {
              UserIdExist.add(permSet.AssigneeId);
              }
              if(UserIdExist != null && UserIdExist.size()>0)
              {
               userIds.removeAll(UserIdExist);
               }
            }         
        if(userIds!=null && userIds.size()>0){       
            for(user u:[select id,contactid,userType,Parent_Account_RecordType__c from user where id IN:userIds And Parent_Account_RecordType__c =: System.Label.AccountRecordTypeSupplier And usertype =:System.Label.FVPortalLoginuserType]){
                setUserIds.add(u.id);    
            }
            if(setUserIds !=null && setUserIds.size()>0){
                   for(String usrid : setUserIds)
                   {
                    
                    PermissionSetAssignment objPermSupplierService =new PermissionSetAssignment();
                    objPermSupplierService.AssigneeId=usrid; 
                    objPermSupplierService.PermissionSetId=permSetSupplierServices;                           
                     permissionsetinsertList.add(objPermSupplierService);
                    }
                }
                if(permissionsetinsertList!=null && permissionsetinsertList.size()>0){                    
                    try{
                        insert permissionsetinsertList;
                    }
                    catch(DmlException ex){
                        System.debug(' ** Exception encountered in Inserting Permission Sets is ** ' + ex.getMessage());    
                    }
                }
            }
        }   
    
   /****************************************end of insert permission set for Supplier Service ***********************/       
//case:2443:Common Future methods for Insert/Update User Trigger event
@future
public static void userTriggerAfterInsertAsyncHandler(Set<Id> userIds,Boolean assignTabAccessBoolean,Boolean updateEnabledContactBoolean,set<id> setUserIds ,set<id> setContactIds, Boolean addPortalUserLoginToShortNameBoolean, Boolean updatecustomerPortaladminBoolean, set<id> setaccIds, Boolean updateContactPortalStatusProxyBoolean, Boolean updateContactsBoolean,set<Id> setUIds){
   if(assignTabAccessBoolean){
       portalTabAccessTriggerHandler.assignTabAccess(userIds);
   }
   if(updateEnabledContactBoolean){
       updateEnabledContact(setUserIds,setContactIds);
   } 
   if(addPortalUserLoginToShortNameBoolean){
       addPortalUserLoginToShortName(setUserIds);
   }  
   
   if(updatecustomerPortaladminBoolean){
       updatecustomerPortaladmin(setaccIds);
   }
   
   if(updateContactPortalStatusProxyBoolean){
       updateContactPortalStatusProxy(userIds,'Insert',false);
   }
   
   if(updateContactsBoolean){
       updateContacts(setUIds);
   } 
}


//Case-3922:Introducing future call handler for User Changes in order to avoid future method calling future method:Start
//Commenting out the earlier Future method and replacing it with a handler intermediate method to check whether the calling method is itself is an asynchronous method
//Case-3283 Change-006: Updated method to include FederationId Change Sync call: Start 
//@future
public static void userTriggerAfterUpdateAsyncHandler(Set<Id> userIds, Boolean updatecustomerPortaladminBoolean,set<id> setaccIds,Boolean updateContactPortalStatusProxyBoolean, Boolean updateASNBoolean,map<String,String> newToOldLogins, Boolean insertASNBoolean,List<String> newLoginsToInsert, Boolean updateContactsBoolean,set<Id> setUIds,Boolean updateContactPortalLoginBoolean,set<Id> setConIdsFuture,map<Id,String> mapLoginsToContactFuture,set<id>setInactiveUsers){
   if(system.isFuture() || System.isBatch()){
       userTriggerAfterUpdateAsyncHandlerSync(userIds,updatecustomerPortaladminBoolean,setaccIds,updateContactPortalStatusProxyBoolean,updateASNBoolean, newToOldLogins,insertASNBoolean,newLoginsToInsert, updateContactsBoolean,setUIds,updateContactPortalLoginBoolean,setConIdsFuture,mapLoginsToContactFuture,setInactiveUsers);    
   }
   else{
       userTriggerAfterUpdateAsyncHandlerASync(userIds,updatecustomerPortaladminBoolean,setaccIds,updateContactPortalStatusProxyBoolean,updateASNBoolean, newToOldLogins,insertASNBoolean,newLoginsToInsert, updateContactsBoolean,setUIds,updateContactPortalLoginBoolean,setConIdsFuture,mapLoginsToContactFuture,setInactiveUsers);
   }
}

//Future Handler Start
@Future
public static void userTriggerAfterUpdateAsyncHandlerAsync(Set<Id> userIds, Boolean updatecustomerPortaladminBoolean,set<id> setaccIds,Boolean updateContactPortalStatusProxyBoolean, Boolean updateASNBoolean,map<String,String> newToOldLogins, Boolean insertASNBoolean,List<String> newLoginsToInsert, Boolean updateContactsBoolean,set<Id> setUIds,Boolean updateContactPortalLoginBoolean,set<Id> setConIdsFuture,map<Id,String> mapLoginsToContactFuture,set<id> setInactiveUsers){
    userTriggerAfterUpdateAsyncHandlerSync(userIds,updatecustomerPortaladminBoolean,setaccIds,updateContactPortalStatusProxyBoolean,updateASNBoolean, newToOldLogins,insertASNBoolean,newLoginsToInsert, updateContactsBoolean,setUIds,updateContactPortalLoginBoolean,setConIdsFuture,mapLoginsToContactFuture,setInactiveUsers);

}

public static void userTriggerAfterUpdateAsyncHandlerSync(Set<Id> userIds, Boolean updatecustomerPortaladminBoolean,set<id> setaccIds,Boolean updateContactPortalStatusProxyBoolean, Boolean updateASNBoolean,map<String,String> newToOldLogins, Boolean insertASNBoolean,List<String> newLoginsToInsert, Boolean updateContactsBoolean,set<Id> setUIds,Boolean updateContactPortalLoginBoolean,set<Id> setConIdsFuture,map<Id,String> mapLoginsToContactFuture,set<id> setInactiveUsers){
    if(updatecustomerPortaladminBoolean && setaccIds!=null && !setaccIds.isEmpty()){
        updatecustomerPortaladmin(setaccIds);
    }  
    
    if(updateContactPortalStatusProxyBoolean  && userIds!=null && !userIds.isEmpty()){
        updateContactPortalStatusProxy(userIds,'Update',false);
    }  
    
    if(updateASNBoolean && newToOldLogins!=null && !newToOldLogins.keyset().isempty()){
        updateASN(newToOldLogins);
    }  
    
    if(insertASNBoolean && newLoginsToInsert!=null && newLoginsToInsert.size()>0){
        insertASN(newLoginsToInsert);
    }
    
    if(updateContactsBoolean  && setUIds!=null && !setUIds.isEmpty()){
        updateContacts(setUIds);
    }
    if(updateContactPortalLoginBoolean){
        updateContactPortalLogin(setConIdsFuture,mapLoginsToContactFuture);  
    }
    if(setInactiveUsers!=null && !setInactiveUsers.isEmpty()){
        resetDeactivatedSpecOwners(setInactiveUsers);    
    }

}
//Future Handler End

//public static void userTriggerAfterUpdateAsyncHandler(Set<Id> userIds, Boolean updatecustomerPortaladminBoolean,set<id> setaccIds,Boolean updateContactPortalStatusProxyBoolean, Boolean updateASNBoolean,map<String,String> newToOldLogins, Boolean insertASNBoolean,List<String> newLoginsToInsert, Boolean updateContactsBoolean,set<Id> setUIds,Boolean updateContactPortalLoginBoolean,set<Id> setConIdsFuture,map<Id,String> mapLoginsToContactFuture){}
//Case-3283 Change-006: Updated method to include FederationId Change Sync call: End
//Case-3922:Introducing future call handler for User Changes in order to avoid future method calling future method:End

//Case-4489:Method for replacing Document owners who get deactivated by default owner:Start
public static void resetDeactivatedSpecOwners(set<id> setInactiveUsers){
list<document_provisioning__c> lstDocProv = new list<document_provisioning__c>();
list<design_spec__c> lstDesignSpec = new list<design_spec__c>();    

try{
    //Retrieve all Specification records where owner has been deactivated
    for(design_spec__c ds:[select id from design_spec__c where ownerid in :setInactiveUsers]){
        ds.ownerid = Spec_Owner__c.getAll().get('Default').UserId__c;
        lstDesignSpec.add(ds);
    }
    //Retrieve all Dcoument Provisioning records where Spec Owner has been deactivated
    for(document_provisioning__c dp:[select id from document_provisioning__c where Spec_Owner__c in :setInactiveUsers]){
        dp.Spec_Owner__c = Spec_Owner__c.getAll().get('Default').UserId__c;
        lstDocProv.add(dp);
    }
    //Update Specification records
    if(lstDesignSpec!=null && lstDesignSpec.size()>0){
        update lstDesignSpec;
    }
    
    //Update Doc Provisioning records
    if(lstDocProv!=null && lstDocProv.size()>0){
        update lstDocProv;
    }
    
}catch(exception e){
    system.debug('Error in replacing deactivated Specification owners:'+e.getmessage());
}

}
//Case-4489:Method for replacing Document owners who get deactivated by default owner:End


}