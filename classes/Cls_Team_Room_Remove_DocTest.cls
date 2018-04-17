/*
 Type Name: Cls_Team_Room_Remove_DocTest
 Author: Cognizant Technology Solutions
 Created Date: 16-Aug-2013
 Reason: This is the test class for 'Cls_Team_Room_Remove_Document' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/

@isTest
private class Cls_Team_Room_Remove_DocTest
{    
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
    
    static testmethod void testCls_Team_Room_Remove_Document()
    {
            Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Team_Room__c teamRoomObj = new Team_Room__c();
            Team_Room_Meeting__c teamRoomMeetingObj = new Team_Room_Meeting__c();
            Design_Spec__c designSpecObj  = new Design_Spec__c ();
           
            Package__c packageObj  = new Package__c();
            Team_Room_Doc__c teamroomdocObj1 = new Team_Room_Doc__c();
            Team_Room_Doc__c teamroomdocObj2 = new Team_Room_Doc__c();
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            userObj.Alias = 'Sally3';
            userObj.Email='Sally2056@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Kuutti';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='Sally2056@test.com';
            userObj.IsActive = true;
                        
            insert userObj;
            
            teamRoomObj.Team_Room_Administrator__c = userObj.Id;
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.Terms_n_Conditions_Accepted__c = true;
            teamRoomObj.Primary_Account__c = acctObj.id;
            
            insert teamRoomObj;
            
            teamRoomMeetingObj.Team_Room__c = teamRoomObj.id;
            teamRoomMeetingObj.Status__c='Open';
            teamRoomMeetingObj.Subject__c='Test Team Room';
            teamRoomMeetingObj.Start_DateTime__c = System.today().addDays(+1);
            
            insert teamRoomMeetingObj;
            
            designSpecObj.name = 'Design Spec 1';
            designSpecObj.OpenText_ID__c = 12345;
            designSpecObj.Release_Status__c = 'General';
            designSpecObj.Technology_Type__c = 'Tech 1';
            designSpecObj.Technology_Geometry__c = 'Tech Geo 1';
            
            insert designSpecObj;
           
            
           
            packageObj.name = 'Package 1';
            packageObj.OpenText_Id__c = 12345;
            packageObj.Package_Release_Status__c = 'Draft';
            insert packageObj;
            
            
           
            teamroomdocObj1.Design_Spec__c = designSpecObj.Id;
            teamroomdocObj1.Team_Room__c = teamRoomObj.Id;
            teamroomdocObj2.Design_Package__c = packageObj.Id;
            teamroomdocObj2.Team_Room__c = teamRoomObj.Id;
            
            
            
            List<Team_Room_Doc__c> teamroomdocList = new List<Team_Room_Doc__c>();
            teamroomdocList.add(teamroomdocObj1);
            teamroomdocList.add(teamroomdocObj2);
            insert teamroomdocList;
            System.runas(userObj)
            {
                Test.startTest();
                ApexPages.currentPage().getParameters().put('id', teamRoomObj.Id);
                ApexPages.currentPage().getParameters().put('itemType','Specifications');
                ApexPages.StandardSetController con1 = new ApexPages.StandardSetController(teamroomdocList);
                             
                Cls_Team_Room_Remove_Document clsTeamRoomRemoveDocumentObj= new Cls_Team_Room_Remove_Document(new ApexPages.StandardController(teamRoomObj));
                Cls_Team_Room_Remove_Document.wrappercls wrapperclsObj1 = new Cls_Team_Room_Remove_Document.wrappercls();
                wrapperclsObj1.checkbox = true;
                wrapperclsObj1.name = 'Design 1';
                List<Cls_Team_Room_Remove_Document.wrappercls> wrapperItemList  = new List<Cls_Team_Room_Remove_Document.wrappercls>();
                wrapperItemList.add(wrapperclsObj1);
                
                clsTeamRoomRemoveDocumentObj.itemInfoGererate();
                
                clsTeamRoomRemoveDocumentObj.first();
                clsTeamRoomRemoveDocumentObj.last();
                clsTeamRoomRemoveDocumentObj.previous();
                clsTeamRoomRemoveDocumentObj.next();
                clsTeamRoomRemoveDocumentObj.cancel();
                clsTeamRoomRemoveDocumentObj.cancelAction();
                clsTeamRoomRemoveDocumentObj.submitItem();
             
                
            
                ApexPages.currentPage().getParameters().put('itemType','Package');
                ApexPages.StandardSetController con3 = new ApexPages.StandardSetController(teamroomdocList);
                Cls_Team_Room_Remove_Document clsTeamRoomRemoveDocumentObj1= new Cls_Team_Room_Remove_Document(new ApexPages.StandardController(teamRoomObj));
                Cls_Team_Room_Remove_Document.wrappercls wrapperclsObj2 = new Cls_Team_Room_Remove_Document.wrappercls();
                wrapperclsObj2.checkbox = true;
                wrapperclsObj2.name = 'Package 1';
                //List<Cls_Team_Room_Remove_Document.wrappercls> wrapperItemList  = new List<Cls_Team_Room_Remove_Document.wrappercls>();
                wrapperItemList.add(wrapperclsObj2);
                
                clsTeamRoomRemoveDocumentObj1.itemInfoGererate();
                clsTeamRoomRemoveDocumentObj1.first();
                clsTeamRoomRemoveDocumentObj1.last();
                clsTeamRoomRemoveDocumentObj1.previous();
                clsTeamRoomRemoveDocumentObj1.next();
                clsTeamRoomRemoveDocumentObj1.cancel();
                
                clsTeamRoomRemoveDocumentObj1.cancelAction();
                clsTeamRoomRemoveDocumentObj1.submitItem();
                
                Test.stopTest();
                
                //System.assertEquals(true,wrapperclsObj1.checkbox);
                
            }
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}