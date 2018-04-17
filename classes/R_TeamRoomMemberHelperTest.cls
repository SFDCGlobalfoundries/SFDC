/* 
 Name: R_TeamRoomMemberHelperTest Class
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 25-07-2017
 Reason: 
 ……..
--*/

@isTest 
public Class R_TeamRoomMemberHelperTest{
  
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
      
      Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c();
      teamRoomObj.Name='Sample Test';
      teamRoomObj.R_Team_Room_Description__c='This could be first method';
      teamRoomObj.R_Primary_Account__c =acctObj.Id;
      
     
      insert teamRoomObj;
      
      
      R_Team_Room_Member__c teamRoomMem= new R_Team_Room_Member__c();
      teamRoomMem.Account__c=acctObj.Id;
      teamRoomMem.Restricted_Team_Room__c=teamRoomObj.Id;
      teamRoomMem.Team_Room_Role__c ='Moderator';
      teamRoomMem.User__c=userinfo.getuserId();
      
      insert teamRoomMem;
      system.assert(teamRoomMem.id!=null);
      
           
      R_Team_Room_Member__c teamRoomMem1= new R_Team_Room_Member__c();
      teamRoomMem1.Account__c=acctObj.Id;
      teamRoomMem1.Restricted_Team_Room__c=teamRoomObj.Id;
      teamRoomMem1.Team_Room_Role__c ='Internal Member';
      teamRoomMem1.User__c=userinfo.getuserId();
      
      insert teamRoomMem1;
      
      Delete teamRoomMem;
      
      
     }
     
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }



}