/*
Type Name: R_TeamRoomAccoountHelperTest Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 25/7/2017
Reason: 

Change History:
Author: 
Modified Date: 
Reason: 
*/
 
@isTest

public Class  R_TeamRoomAccoountHelperTest{

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
      RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Restricted_Team_Room__c' AND Name = 'GLOBALFOUNDRIES with Multi-Party'];
      
      Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c();
      teamRoomObj.Name='Sample Test';
      teamRoomObj.R_Team_Room_Description__c='This could be first method';
      teamRoomObj.R_Primary_Account__c =acctObj.Id;
      teamRoomObj.RecordTypeId =rt.Id; 
     
      insert teamRoomObj;
      system.assert(teamRoomObj.id!=null);
      
      R_Team_Room_Account__c teamroomAcc=new R_Team_Room_Account__c();
      teamroomAcc.Account__c=  acctObj.Id;
      teamroomAcc.Restricted_Team_Room__c= teamRoomObj.Id;
      teamroomAcc.Association_Type__c='Third Party Account';
      
      insert teamroomAcc;
      
      delete teamroomAcc; 
     }
     
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}