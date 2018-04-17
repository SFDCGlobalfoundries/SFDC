/*
 Type Name: cls_RTeamRoomHomeControllerTest 
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 31-July-2017
 Reason: This is the test class for 'cls_RTeamRoomHomeController' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..

*/

@isTest

public Class cls_RTeamRoomHomeControllerTest{

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
            
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.R_Primary_Account__c=acctObj.Id;               
                
            insert teamRoomObj;
            system.assert(teamRoomObj.id!=null);
			
			List<R_Team_Room_SObjectIdsllist__c> newlist=new List<R_Team_Room_SObjectIdsllist__c>();
            R_Team_Room_SObjectIdsllist__c  rt=new R_Team_Room_SObjectIdsllist__c ();
            rt.Name='1';
            rt.sObjectId__c='aHJ';
            newlist.add(rt);
             
            R_Team_Room_SObjectIdsllist__c  rt1=new R_Team_Room_SObjectIdsllist__c ();
            rt1.Name='2';
            rt1.sObjectId__c='aHJ'; 
            newlist.add(rt1);    
            insert newlist;  
            
            Test.startTest();
            
            Test.setCurrentPageReference(new PageReference('Page.VFR_RTeamRoomHomePage'));
            ApexPages.currentPage().getHeaders().put('host', 'globalfoundryview'); 
            ApexPages.StandardController sc = new ApexPages.StandardController(teamRoomObj);        
            cls_RTeamRoomHomeController controller= new cls_RTeamRoomHomeController(sc);  
            controller.stringURL='itartest-globalfoundryview.cs6.force.com';
            controller.firstPage();
            controller.lastPage();
            controller.next();
            controller.prev();
            controller.getRteamRooms();
            controller.getRTeamExistingViews();
            controller.resetFilter();
            controller.newpage();
            Test.stopTest();
    
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}