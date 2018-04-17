/*
Type Name: ClsR_TeamRoomDetailTest  Class
Author: Global Foundries (Dinesh Suggala) 
Created Date: 25-07-2017
Reason: This Page is used for this "ClsR_TeamRoomDetail" class
Change History:
Author: 
Modified Date: 

*/

@isTest

public Class ClsR_TeamRoomDetailTest{

 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
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
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    private static testmethod void test_clsTeamRoomDetail(){
        

        
            Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c();            
            
            R_Team_Room_Account__c teamRoomAccountObj = new R_Team_Room_Account__c();
            R_Team_Room_Member__c teamRoomMemberObj = new R_Team_Room_Member__c();


            Salesforce_Field_Ids__c cstObj=new Salesforce_Field_Ids__c();
                        
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            cstObj.Name='1';
            cstObj.SObject_Name__c='R_Team_Room_Account__c';
            cstObj.Field_Name__c='Restricted_Team_Room__c';
            cstObj.Id__c='testId';
            
            insert cstObj;
            
            userObj.Alias = 'Kenny';
            userObj.Email='Kenny@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Loggins';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='Kennytucky@test.com';
            userObj.IsActive = true;
                        
            insert userObj;
            
            RecordType recType=[Select Id from RecordType where DeveloperName='GLOBALFOUNDRIES_with_Multi_Party'];
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.RecordTypeId=recType.Id;
            teamRoomObj.R_Primary_Account__c=acctObj.id;
            
            insert teamRoomObj;           
            
            teamRoomMemberObj.Restricted_Team_Room__c = teamRoomObj.id;
            teamRoomMemberObj.User__c = userObj.Id;
            
            insert teamRoomMemberObj;          
       
            
            teamRoomAccountObj.Restricted_Team_Room__c = teamRoomObj.id;
            teamRoomAccountObj.Account__c=acctObj.Id;
            
            insert teamRoomAccountObj;
            
            Folder__c folder=new Folder__c();
            folder.Name='Test';
            folder.Restricted_Team_Room__c=teamRoomObj.Id;

            insert folder;
                        
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

            ContentVersion cv = new ContentVersion();
            cv.title = 'test content trigger';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;          
            insert cv;         

            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=folder.Id;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=testcontent.ContentDocumentId;

             insert contentlink;

         
            List<Default_Page_Size__c> pageSizeList=new List<Default_Page_Size__c>();
            Default_Page_Size__c pageSizeObj=new Default_Page_Size__c(Name='Account',Page_Size__c=1);
            pageSizeList.add(pageSizeObj);
            pageSizeObj=new Default_Page_Size__c(Name='Member',Page_Size__c=1);
            pageSizeList.add(pageSizeObj);                       
            insert pageSizeList;
            
            
            Test.startTest();  
                System.runAs(userObj){         
                    
                    
                    PageReference pageRef = Page.VFTeamRoomDetail;
                    pageRef.getParameters().put('id', String.valueOf(teamRoomObj.Id));
                    pageRef.getParameters().put('memberId', String.valueOf(teamRoomMemberObj.Id));
                    pageRef.getParameters().put('accToDelete', String.valueOf(teamRoomAccountObj.Id));
                    pageRef.getParameters().put('accToEdit', String.valueOf(teamRoomAccountObj.Id));
                    pageRef.getParameters().put('objectTonavigate', 'Member');
                    Test.setCurrentPage(pageRef);
                    
                    ApexPages.StandardController controller = new ApexPages.StandardController(teamRoomObj); 
                    ClsR_TeamRoomDetail objcontroller= new ClsR_TeamRoomDetail(controller);
                    ClsR_TeamRoomDetail.ContentDocumentLinkWrapper CDWrapper=new ClsR_TeamRoomDetail.ContentDocumentLinkWrapper(contentlink,folder);
                    objcontroller.populateAccountMap();
                    objcontroller.getAccMapSize();
                    objcontroller.goToEditTRAccount();
                    objcontroller.goToNewTRAccount();
                    objcontroller.deleteTRAccount();
                    objcontroller.deleterelatedmembers();
                    objcontroller.checkUserPermissions();
                    objcontroller.goToNewMember();
                    objcontroller.populateMemberMap();
                    objcontroller.getMemberMapSize();
                    objcontroller.deleteMember();
                    objcontroller.next();
                    objcontroller.previous();
                    objcontroller.first();
                    objcontroller.last();
                    objcontroller.Displayattachments();
                    objcontroller.LoadAllFiles();
                    objcontroller.DeleteRow();
                    objcontroller.savefolder();
                    system.assert(objcontroller.folder.id!=null);
                    objcontroller.closePopup();
                    objcontroller.showPopup();

                    pageRef.getParameters().put('objectTonavigate', 'Account');
                    Test.setCurrentPage(pageRef);
                    objcontroller.previous();
                    objcontroller.next();
                    objcontroller.first();
                    objcontroller.last();
                    
                    pageRef.getParameters().put('objectTonavigate', 'Member');
                    Test.setCurrentPage(pageRef);
                    objcontroller.previous();
                    objcontroller.next();
                    objcontroller.first();
                    objcontroller.last();
                    
                    pageRef.getParameters().put('selectedPageNum', '1');
                    Test.setCurrentPage(pageRef);
                    objcontroller.updatePageNumberDisplay();
                    
                    
                }
            Test.stopTest();    
            
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}