/*
Type Name: ClsUserTriggerHandlerTest
Author: Cognizant
Created Date: 8 May-2013
Reason: This is the Test class for class ClsUserTriggerHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..

    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     04072015    - Refactoring test class.
*/

@isTest
public class ClsUserTriggerHandlerTest
{   
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    static List<Map<String,Object>> CreatefieldValueAccMap() {

        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>(); 

        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','Yes');
            
            fieldValueMapList.add(fieldValueMap);
        }
        return fieldValueMapList;
    }

    static Contact createContact(Id accObjId) {

        Contact conobj=new Contact(FirstName='Mr',
                                 LastName='Testcon1',
                                 AccountId=accObjId,
                                 Email='con1@gf.com',
                                 Department__c='Design;Engineering',//5779
                                 is_portal_user_active__c=false,
                                 Login_Id__c = 'Test'
                                 );  
        insert conobj;
        return conobj;
    }

    static Contact_Portal_Tab_Access__c createContactPortal() {

        Contact_Portal_Tab_Access__c ContactPTAObj=new Contact_Portal_Tab_Access__c ();
        ContactPTAObj.name='Design';
        ContactPTAObj.X3rd_Party_IP__c=true;
        ContactPTAObj.Account_Statement__c=true;
        ContactPTAObj.Backlog__c=true;
        ContactPTAObj.Billing__c=true;
        ContactPTAObj.BOM__c=true;
        ContactPTAObj.Certificate_of_Compliance__c=true;
        ContactPTAObj.Configurator__c=true;
        ContactPTAObj.CPK__c=true;
        ContactPTAObj.Credit_and_Debit_Note__c=true;
        ContactPTAObj.Custom_Shipment_Report__c=true;
        ContactPTAObj.Design_Technology_Documents__c=true;
        ContactPTAObj.Design_Enablement__c=true;
        ContactPTAObj.Design_Specification_Packages__c=true;
        ContactPTAObj.My_Devices__c=true;
        ContactPTAObj.My_wafers__c=true;
        ContactPTAObj.Tapeout_Fab_9_10__c=True;
        ContactPTAObj.PDK_Design_Documents__c=True;
        ContactPTAObj.Product_Services__c=True;
        insert ContactPTAObj;

        return ContactPTAObj;
    }

    static User createPortalUser(Id profileId, Id conObjId, Integer i) {

        User portalUserTemp = new User(ProfileId = profileId,
                                            Username = 'portaluser3@testorg.com'+i,
                                            Alias = 'abcuser'+i,  
                                            Email='portaluser31@testorg.com'+i,
                                            EmailEncodingKey='UTF-8',
                                            Firstname='test',
                                            Lastname='user'+i,
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            TimeZoneSidKey='America/Chicago',
                                            Portal_Login__c='abc13',
                                            ContactId = conObjId, 
                                            HCM_Login_ID__c='abc1',
                                            IsActive = false,
                                            federationidentifier = 'fedId'+i
                                    ); 
        insert portalUserTemp;
        return portalUserTemp;
    }
    
    public static testMethod void updateEnabledContact1(){
           
        Set<Id> userIds=new Set<Id>();
        Set<Id> conIds=new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        map<Id, String> mapLoginsToContact = new map<Id, String>();
        Set<String> setPortalLogins=new Set<String>();

        List<Map<String,Object>> fieldValueAccMapList = CreatefieldValueAccMap();
        List<Account> accobjList = AccountDataFactory.createAccounts(fieldValueAccMapList,2);   

        accobjList[1].parent=accobjList[0];                                             
        update accobjList[1]; 
        Contact conobj = createContact(accobjList[1].Id);
        Contact conobj1 = createContact(accobjList[1].Id);

        Account_Short_name__c asnObj= new Account_Short_name__c(Account_Short_name__c='testkey');
        insert asnObj;
  
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        System.runAs (thisUser) { 
            List<Profile> lstProfiles = [Select Id, Name from Profile where name IN ('Supplier Portal Admin', 'Customer Portal Admin')];//5779 
         
            Profile  profile1 = null ; 
            Profile  profile2 = null ;
         
            for(Profile myPrf : lstProfiles ){
                if(myPrf.Name == 'Supplier Portal Admin') {
                    profile1 = myPrf ;
                }
                else if(myPrf.Name == 'Customer Portal Admin') {
                    profile2 = myPrf ;
                }        
            }
            
            test.startTest();

            User portalUser = createPortalUser(profile1.Id, conobj.Id, 1);
            User portalUser1 = createPortalUser(profile2.Id, conobj1.Id, 2);        
 
            userIds.add(portalUser.Id);  // Modified By Krishanu 
            userIds.add(portalUser1.Id); // Added by Krishanu

            conIds.add(conobj.Id);
            conIds.add(conobj1.Id);

            mapLoginsToContact.put(conobj.id, conobj.Login_Id__c);
            mapLoginsToContact.put(conobj1.id, conobj1.Login_Id__c);

            accIds.add(accobjList[0].Id);
            accIds.add(accobjList[1].Id);
             
            setPortalLogins.add(portalUser.Portal_Login__c);

            ClsUserTriggerHandler.deleteAccountShortNameFuture(setPortalLogins);
            ClsUserTriggerHandler.insertPermissionSetsSupplierService(userIds,true);
            ClsUserTriggerHandler.insertPTAFuture(userIds);
            ClsUserTriggerHandler.updateContactPortalStatus(userIds, 'Update');
            ClsUserTriggerHandler.updateContactPortalLoginFuture(conIds, mapLoginsToContact);
            ClsUserTriggerHandler.userTriggerAfterUpdateAsyncHandler(userIds, true, accIds, true, true, new Map<String,String>{'testkey'=>'testVal'}, true, new List<String>{'testVal'}, true, userIds, true, conIds, mapLoginsToContact, new set<id>{portalUser.Id});
            test.stopTest();                           
        } 
    }     
   
    public static testmethod void testPermSetSuppService(){

        Profile profObj = [Select Id from Profile where name = 'Overage Customer Portal Admin'];

        User userobj=[Select Id from User where Profile.Name='System Administrator' and isactive=true limit 1];
        System.Runas(userobj) {
            
            List<Map<String,Object>> fieldValueAccMap = CreatefieldValueAccMap();
            Account accobj = AccountDataFactory.createAccount(fieldValueAccMap[0]);
            Contact conobj = createContact(accobj.Id);
            Contact_Portal_Tab_Access__c ContactPTAObj = createContactPortal();           
                                     
            Test.starttest();
            User portalUserTemp = createPortalUser(profObj.Id, conobj.Id, 1);
       
            ClsUserTriggerHandler.insertPermissionSetsSupplierService(new Set<Id>{portalUserTemp.Id},true);
            Test.stoptest();
        }
    }

    public static testmethod void testPermSetSuppService1(){

        Profile profObj = [Select Id from Profile where name = 'Customer Portal Admin'];

        User userobj=[Select Id from User where Profile.Name='System Administrator' and isactive=true limit 1];
        System.Runas(userobj) {
            
            List<Map<String,Object>> fieldValueAccMap = CreatefieldValueAccMap();
            Account accobj = AccountDataFactory.createAccount(fieldValueAccMap[0]);
            Contact conobj = createContact(accobj.Id);
            Contact_Portal_Tab_Access__c ContactPTAObj = createContactPortal();           
                                     
            Test.starttest();
            User portalUserTemp = createPortalUser(profObj.Id, conobj.Id, 1);
       
            ClsUserTriggerHandler.insertPermissionSetsSupplierService(new Set<Id>{portalUserTemp.Id},true);
            Test.stoptest();
        }
    }

    public static testmethod void testPermSetSuppService3(){

        Profile profObj = [Select Id from Profile where name = 'Customer Portal Admin'];

        User userobj=[Select Id from User where Profile.Name='System Administrator' and isactive=true limit 1];
        System.Runas(userobj) {
            
            List<Map<String,Object>> fieldValueAccMap = CreatefieldValueAccMap();
            Account accobj = AccountDataFactory.createAccount(fieldValueAccMap[0]);
            Contact conobj = createContact(accobj.Id);
                                     
            Test.starttest();
            User portalUserTemp = createPortalUser(profObj.Id, conobj.Id, 1);

            Design_Spec__c desSpecObj=new Design_Spec__c (ownerId=portalUserTemp.Id,OpenText_ID__c=123);
            insert desSpecObj;
            
            Document_provisioning__c docProvObj=new Document_provisioning__c (design_spec__c=desSpecObj.Id,spec_owner__C=portalUserTemp.Id,Status__c='Provisioned');
            insert docProvObj;

            portalUserTemp.isActive=false;
            update portalUserTemp;         
       
            ClsUserTriggerHandler.resetDeactivatedSpecOwners(new Set<Id>{portalUserTemp.Id});
            Test.stoptest();
        }
    }

    public static testMethod void updateEnabledContact2() {
              
        Set<Id> userIds=new Set<Id>();
        List<String> userIdList = new List<String>();
        List<User> userList=new List<User>();
        Set<Id> contIds=new Set<Id>();
        List<Contact> contList=new List<Contact>();
        Set<String> setPortalLogins=new Set<String>();
        Map<string,string> modifyPortallogin=new Map<string,string>();
        List<string> newloginList=new List<string>(); 
        Map<Id,String> mapcontactlogin=new  Map<Id,String>();
                
        List<Map<String,Object>> fieldValueAccMapList = CreatefieldValueAccMap();
        List<Account> accobjList = AccountDataFactory.createAccounts(fieldValueAccMapList,2);   

        accobjList[1].parent=accobjList[0];                                             
        update accobjList[1]; 

        Contact conobj=new Contact(FirstName='Mr',
                                     LastName='Testcon1',
                                     AccountId=accobjList[1].Id,
                                     Email='con1@gf.com',
                                     Department__c='Design;Engineering'//5779                                    
                                     );   
         
         /************** Added By Krishanu *************/ 
        Contact conobj1=new Contact(FirstName='Mr',
                                     LastName='Testcon1',
                                     AccountId=accobjList[1].Id,
                                     Email='con1@gf.com',
                                     Department__c='Design;Engineering',//5779
                                     is_portal_user_active__c=false
                                     ); 
                                          
        List<Contact> lstInsContacts = new List<Contact>() ;
        lstInsContacts.add(conobj)  ;
        lstInsContacts.add(conobj1)  ;  
        insert lstInsContacts ; 
         
        conobj1.is_portal_user_active__c=true;

        contIds.add(conobj.Id);
        contList.add(conobj);
  
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (thisUser ) { 
            List<Profile> lstProfiles = [Select Id, Name from Profile where name IN ('Overage Customer Portal Admin', 'Customer Portal Admin')];//5779 
         
            Profile  profile1 = null ; 
            Profile  profile2 = null ;
         
            for(Profile myPrf : lstProfiles ){
                if(myPrf.Name == 'Overage Customer Portal Admin') {
                    profile1 = myPrf ;
                }
                else if(myPrf.Name == 'Customer Portal Admin') {
                    profile2 = myPrf ;
                }        
            }
         
            User portalUser = new User(ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                Portal_Login__c='abc1',
                                                //ContactId=conobj.Id, // Commented By Krishanu 
                                                IsActive = true, 
                                                ContactId = lstInsContacts[0].Id , // Added By Krishanu
                                                HCM_Login_ID__c='abc',
                                                federationidentifier='abcdef'
                                               );
         
            /***** Modified By Krishanu ***********/
         
            User portalUser1 = new User(ProfileId = profile2.Id,
                                                Username = 'portaluser1@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                Portal_Login__c='abc11',
                                                //ContactId=conobj.Id, // Commented By Krishanu 
                                                IsActive = true ,
                                                ContactId = lstInsContacts[1].Id , // Added By Krishanu
                                                HCM_Login_ID__c='abc1',
                                                federationidentifier='xyzfg'
                                               );
         
            test.startTest();
            List<User> lstInsUsers = new List<User>() ;
            lstInsUsers.add(portalUser) ; 
            lstInsUsers.add(portalUser1) ; 
            insert lstInsUsers ;
            /************ Modified By Krishanu End *************/
          
            userIds.add(lstInsUsers[0].Id);  // Modified By Krishanu 
            userIds.add(lstInsUsers[1].Id); // Added by Krishanu
            userIdList.add(lstInsUsers[0].Id);
            userIdList.add(lstInsUsers[1].Id);
                                                               
            Portal_Tab_Access__c PTAObj1= new Portal_Tab_Access__c (Account__c=accobjList[1].Id ,
                                                               User__c=portalUser.Id,
                                                               Material_Selection_Qualififcation__c=true,
                                                                Supplier_eCOA_Submission__c=true,
                                                                Procedure_Review_Acceptance__c=true,
                                                                Wafer_Disposition_System__c=true,
                                                                Turnkey_Incident_Report__c=true,
                                                                Supplier_Procedure__c=true,
                                                                SQE_Applications_Overview__c=true
                                                            );                                                     
         /**************** Added By Krishanu Start *******************************************/
         
            Portal_Tab_Access__c PTAObj2= new Portal_Tab_Access__c (Account__c=accobjList[1].Id ,
                                                               User__c=portalUser1.Id,
                                                               My_Devices__c = true , 
                                                               PDK_Design_Documents__c = true ,
                                                               Product_Services__c = true,
                                                                Tapeout_Fab_9_10__c = true
                                                            );

         
            List<Portal_Tab_Access__c> lstInsPTA = new List<Portal_Tab_Access__c>() ;
            lstInsPTA.add(PTAObj1) ; 
   
            portalUser.Firstname='Shyam';
            portalUser.Portal_Login__c='abcd1';
         
            userList.add(portalUser);
         
            update  userList;
         
            ClsUserTriggerHandler.insertPermissionSetsSupplierService(userIds,true);

            test.stopTest();                           
        }
    } 

    public static testMethod void updateEnabledContact3() {
              
        Set<Id> userIds=new Set<Id>();
        List<String> userIdList = new List<String>();
        List<User> userList=new List<User>();
        Set<Id> contIds=new Set<Id>();
        List<Contact> contList=new List<Contact>();
        Set<String> setPortalLogins=new Set<String>();
        Map<string,string> modifyPortallogin=new Map<string,string>();
        List<string> newloginList=new List<string>(); 
        Map<Id,String> mapcontactlogin=new  Map<Id,String>();
               
        List<Map<String,Object>> fieldValueAccMapList = CreatefieldValueAccMap();
        List<Account> accobjList = AccountDataFactory.createAccounts(fieldValueAccMapList,2);   

        accobjList[1].parent=accobjList[0];                                             
        update accobjList[1]; 

        Contact conobj=new Contact(FirstName='Mr',
                                     LastName='Testcon1',
                                     AccountId=accobjList[1].Id,
                                     Email='con1@gf.com',
                                     Department__c='Design;Engineering'//5779                                    
                                     );   
         
        /************** Added By Krishanu *************/ 
        Contact conobj1=new Contact(FirstName='Mr',
                                     LastName='Testcon1',
                                     AccountId=accobjList[1].Id,
                                     Email='con1@gf.com',
                                     Department__c='Design;Engineering',//5779
                                     is_portal_user_active__c=false
                                     ); 
                                          
        List<Contact> lstInsContacts = new List<Contact>() ;
        lstInsContacts.add(conobj)  ;
        lstInsContacts.add(conobj1)  ;  
        insert lstInsContacts ; 
         
         
        conobj1.is_portal_user_active__c=true;
    
        contIds.add(conobj.Id);
        contList.add(conobj);
  
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (thisUser) { 
            List<Profile> lstProfiles = [Select Id, Name from Profile where name IN ('Supplier Portal Admin', 'Customer Portal Admin')];//5779 
             
            Profile  profile1 = null ; 
            Profile  profile2 = null ;
             
            for(Profile myPrf : lstProfiles ){
                if(myPrf.Name == 'Supplier Portal Admin') {
                    profile1 = myPrf ;
                }
                else if(myPrf.Name == 'Customer Portal Admin') {
                    profile2 = myPrf ;
                }        
            }
             
            User portalUser = new User(ProfileId = profile1.Id,
                                                    Username = 'portaluser@testorg.com',
                                                    Alias = 'auser',
                                                    Email='portaluser@testorg.com',
                                                    EmailEncodingKey='UTF-8',
                                                    Firstname='Bruce',
                                                    Lastname='Wayne',
                                                    LanguageLocaleKey='en_US',
                                                    LocaleSidKey='en_US',
                                                    TimeZoneSidKey='America/Chicago',
                                                    Portal_Login__c='abc1',
                                                    //ContactId=conobj.Id, // Commented By Krishanu 
                                                    IsActive = true, 
                                                    ContactId = lstInsContacts[0].Id , // Added By Krishanu
                                                    HCM_Login_ID__c='abc',
                                                    federationidentifier='abcdef'
                                                   );
             
             /***** Modified By Krishanu ***********/
             
            User portalUser1 = new User(ProfileId = profile2.Id,
                                                    Username = 'portaluser1@testorg.com',
                                                    Alias = 'auser',
                                                    Email='portaluser1@testorg.com',
                                                    EmailEncodingKey='UTF-8',
                                                    Firstname='Bruce',
                                                    Lastname='Wayne',
                                                    LanguageLocaleKey='en_US',
                                                    LocaleSidKey='en_US',
                                                    TimeZoneSidKey='America/Chicago',
                                                    Portal_Login__c='abc11',
                                                    //ContactId=conobj.Id, // Commented By Krishanu 
                                                    IsActive = true ,
                                                    ContactId = lstInsContacts[1].Id , // Added By Krishanu
                                                    HCM_Login_ID__c='abc1',
                                                    federationidentifier='xyzfg'
                                                   );
             
            test.startTest();
            List<User> lstInsUsers = new List<User>() ;
            lstInsUsers.add(portalUser) ; 
            lstInsUsers.add(portalUser1) ; 
            insert lstInsUsers ;
            /************ Modified By Krishanu End *************/
     
            userIds.add(lstInsUsers[0].Id);  // Modified By Krishanu 
            userIds.add(lstInsUsers[1].Id); // Added by Krishanu
            userIdList.add(lstInsUsers[0].Id);
            userIdList.add(lstInsUsers[1].Id);
                                                                   
            Portal_Tab_Access__c PTAObj1= new Portal_Tab_Access__c (Account__c=accobjList[1].Id ,
                                                                   User__c=portalUser.Id,
                                                                   Material_Selection_Qualififcation__c=true,
                                                                    Supplier_eCOA_Submission__c=true,
                                                                    Procedure_Review_Acceptance__c=true,
                                                                    Wafer_Disposition_System__c=true,
                                                                    Turnkey_Incident_Report__c=true,
                                                                    Supplier_Procedure__c=true,
                                                                    SQE_Applications_Overview__c=true                                       
                                                                );                                                     
             /**************** Added By Krishanu Start *******************************************/
             
            Portal_Tab_Access__c PTAObj2= new Portal_Tab_Access__c (Account__c=accobjList[1].Id ,
                                                                   User__c=portalUser1.Id,                                                   My_Devices__c = true , 
                                                                   PDK_Design_Documents__c = true ,
                                                                   Product_Services__c = true,
                                                                    Tapeout_Fab_9_10__c = true
                                                                  );
           
            List<Portal_Tab_Access__c> lstInsPTA = new List<Portal_Tab_Access__c>() ;
            lstInsPTA.add(PTAObj1) ; 
       
            portalUser.Firstname='Shyam';
            portalUser.Portal_Login__c='abcd1';
             
            userList.add(portalUser);
             
            update  userList;
             
            ClsUserTriggerHandler.insertPermissionSetsSupplierService(userIds,true);

            test.stopTest();                           
        }     
    } 
}