/*
 Type Name: ClsR_NewRTeamRoomControllerTest
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 18/10/2017
 Reason: This is the test class for 'ClsR_NewRTeamRomController' class.
 Change History:
 Author: Dinesh Suggala    
 Modified Date: 21/11/2017
 Reason: Added one more test method testmethod3()
 …….. 
 ……..

*/

@isTest

public Class ClsR_NewRTeamRoomControllerTest{

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
   
    public static testMethod void testMethod1() {
            Account acctObj = new Account(); 
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            RecordType recType=[Select Id from RecordType where DeveloperName='GLOBALFOUNDRIES_with_Multi_Party'];            
            
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.R_Primary_Account__c=acctObj.Id;   
            teamRoomObj.OwnerId=userinfo.getuserid();  
            teamRoomObj.RecordTypeId=recType.Id;            
            
                
            
            
            Test.startTest();  
            insert teamRoomObj;
            system.assert(teamRoomObj.id!=null);
            
            PageReference pageRef = Page.VFR_NewRTeamRoomPage;
            pageRef.getParameters().put('Id', String.valueOf(teamRoomObj.Id));
            pageRef.getParameters().put('RecordType', String.valueOf(recType.Id));
                   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc= new ApexPages.StandardController(teamRoomObj); 
            ClsR_NewRTeamRomController controller= new ClsR_NewRTeamRomController (sc);
            
            controller.save();
            controller.cancel();
            Test.stopTest();
    
    } 
    
    public static testMethod void testMethod2() {
            Account acctObj = new Account(); 
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            RecordType recType=[Select Id from RecordType where DeveloperName='GLOBALFOUNDRIES_with_Multi_Party'];
            Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];             

            User internaluserObj=new User();
            internaluserObj.Alias = 'TJohn1';
            internaluserObj.Email='TJohn1@test.com'; 
            internaluserObj.EmailEncodingKey='UTF-8';
            internaluserObj.FirstName='TJohn1'; 
            internaluserObj.LastName='Paul';
            internaluserObj.LanguageLocaleKey='en_US'; 
            internaluserObj.LocaleSidKey='en_US';
            internaluserObj.ProfileId = profileObj1.Id;
            internaluserObj.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj.UserName='TJohn1@test.com';
            internaluserObj.IsActive = true;
            
           
            insert internaluserObj;
            
            HCM_Employee__c HCMId=new HCM_Employee__c();
            HCMId.User__c=internaluserObj.id;
            HCMId.ITARCertified__c=false;
            HCMId.TeamRoom_ITAR__c=false;
            HCMId.Employee_ID__c='1234';
            HCMId.First_Name__c='TJohn1';
            HCMId.Last_Name__c='Paul';
            HCMId.Login_ID__c='TJohn1';
            insert HCMId;
            
            internaluserObj.HCM_Record_ID__c =HCMId.Id;
            update internaluserObj;
            
            ITARTRoomErrorMessages__c Itmsg=new ITARTRoomErrorMessages__c();
            Itmsg.Name='NewButtonMessage'; 
            Itmsg.NewErrorMessage__c='You are not a ITAR Certified User';
            insert Itmsg;
                        
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';    
            teamRoomObj.OwnerId=internaluserObj.id;
            teamRoomObj.RecordTypeId=recType.Id;            
            
            system.runAs(internaluserObj) {  
            insert teamRoomObj;
            }
            system.assert(teamRoomObj.id!=null);
            
            Test.startTest();  
            
            PageReference pageRef = Page.VFR_NewRTeamRoomPage;
            pageRef.getParameters().put('id', String.valueOf(teamRoomObj.Id));
            pageRef.getParameters().put('RecordType', String.valueOf(recType.Id));
                   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc= new ApexPages.StandardController(teamRoomObj); 
            ClsR_NewRTeamRomController controller= new ClsR_NewRTeamRomController (sc);
            
            controller.save();
            controller.cancel();
            Test.stopTest();
            
    }     
    
     public static testMethod void testMethod3() {
            Account acctObj = new Account(); 
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            RecordType recType=[Select Id from RecordType where DeveloperName='GLOBALFOUNDRIES_with_Multi_Party'];
            Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];             

            User internaluserObj=new User();
            internaluserObj.Alias = 'TJohn1';
            internaluserObj.Email='TJohn1@test.com'; 
            internaluserObj.EmailEncodingKey='UTF-8';
            internaluserObj.FirstName='TJohn1'; 
            internaluserObj.LastName='Paul';
            internaluserObj.LanguageLocaleKey='en_US'; 
            internaluserObj.LocaleSidKey='en_US';
            internaluserObj.ProfileId = profileObj1.Id;
            internaluserObj.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj.UserName='TJohn1@test.com';
            internaluserObj.IsActive = true;
            
           
            insert internaluserObj;
            
            HCM_Employee__c HCMId=new HCM_Employee__c();
            HCMId.User__c=internaluserObj.id;
            HCMId.ITARCertified__c=false;
            HCMId.TeamRoom_ITAR__c=false;
            HCMId.Employee_ID__c='1234';
            HCMId.First_Name__c='TJohn1';
            HCMId.Last_Name__c='Paul';
            HCMId.Login_ID__c='TJohn1';
            insert HCMId;
            
            internaluserObj.HCM_Record_ID__c =HCMId.Id;
            update internaluserObj;
            
            ITARTRoomErrorMessages__c Itmsg=new ITARTRoomErrorMessages__c();
            Itmsg.Name='NewButtonMessage'; 
            Itmsg.NewErrorMessage__c='You are not a ITAR Certified User';
            insert Itmsg;
                        
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';    
            teamRoomObj.OwnerId=internaluserObj.id;
            teamRoomObj.RecordTypeId=recType.Id;            

            Test.startTest();  
            
            PageReference pageRef = Page.VFR_NewRTeamRoomPage;
            pageRef.getParameters().put('RecordType', String.valueOf(recType.Id));
                   
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc= new ApexPages.StandardController(teamRoomObj); 
            ClsR_NewRTeamRomController controller= new ClsR_NewRTeamRomController (sc);
            
            controller.save();
            controller.cancel();
            Test.stopTest();
            
    }     
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}