/*
Type Name: clsRTeamRoomAccountControllerTest 
Author: Global Foundries(Dinesh Suggala)
Created Date: 27th-July-2017
Reason: This class is used to cover the clsRTeamRoomAccountController Class

……..
……..
*/
@isTest
public Class clsRTeamRoomAccountControllerTest{

@testsetup static void testvoiddata(){
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
     
     public static testmethod void testmethod1(){
      Account acctObj = getAccount('MYTEST ACCOUNT1');
     
      RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Restricted_Team_Room__c' AND DeveloperName = 'GLOBALFOUNDRIES_with_Multi_Party'];
      Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c();
      teamRoomObj.Name='Sample Test';
      teamRoomObj.R_Team_Room_Description__c='This could be first method';
      teamRoomObj.R_Primary_Account__c =acctObj.Id;
      teamRoomObj.RecordTypeId =rt.Id; 
  
      insert teamRoomObj;
      system.assert(teamRoomObj.id!=null);
      
      R_Team_Room_Account__c teamRoomAccObj= new R_Team_Room_Account__c ();
      teamRoomAccObj.Restricted_Team_Room__c = teamRoomObj.Id;
      teamRoomAccObj.Account__c = acctObj.Id;
      teamRoomAccObj.Association_Type__c='Third Party Account' ;         
      insert teamRoomAccObj;

      Test.startTest();
      Test.setCurrentPageReference(new PageReference('Page.VFRTeamRoomAccountPage')); 
      System.currentPageReference().getParameters().put('id', teamRoomObj.id);
      System.currentPageReference().getParameters().put('recordId', teamRoomAccObj.id);
      clsRTeamRoomAccountController controller=new clsRTeamRoomAccountController();
      controller.save();
      controller.cancel();

      Test.StopTest();
     }
     
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}