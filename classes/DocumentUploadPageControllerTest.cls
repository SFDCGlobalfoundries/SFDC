/*
 Type Name: DocumentUploadPageControllerTest 
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 31-July-2017
 Reason: This is the test class for 'DocumentUploadPageControllerTest' class.
 Change History:
 Author: Dinesh Suggala    
 Modified Date: 26/10/2017
 Reason: Added the Code for dummy test method
 …….. 
 ……..

*/
@isTest

public Class DocumentUploadPageControllerTest{


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

     public static testMethod void testMethod1(){
     
         Account acctObj = new Account(); 
         acctObj = getAccount('MYTEST ACCOUNT1');
            
         Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
         teamRoomObj.Name ='Team Room 1';
         teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
         teamRoomObj.R_Primary_Account__c=acctObj.Id;               
                
         insert teamRoomObj;
       
         Test.startTest();
         Test.setCurrentPageReference(new PageReference('Page.DocumentUploadPageController')); 
         ApexPages.StandardController sc = new ApexPages.StandardController(teamRoomObj);        
         DocumentUploadPageController controller= new DocumentUploadPageController(sc);  
         PageReference p=controller.UploadedTrue();       
         PageReference p1=controller.dummy();             //Added by Dinesh 26/10/2017
         system.assertEquals(p,null);         
         Test.StopTest();
 
 }
 
   private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}