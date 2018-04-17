/*Author: Meghna Ganguly/ Devendra
    Description: Testclass for Opportunity Control Point and Check Point Controllers
    
    History:
    Created-Devendra-02/20/2017-code creation.
*/

@isTest(SeeAllData=false)
private class OpportunityControlCheckPoint_CtrlTest {

@testSetup static void testdata() {
    DataUtilTest.loadEnvironmentVariables();
    }
    
    static testMethod void OpportunityProc1() {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
            fieldValueAccMap.put('Name', 'testing501');
            fieldValueAccMap.put('Stage__c', 'Unqualified');
            fieldValueAccMap.put('Short_Name__c', 'test725');
            fieldValueAccMap.put('Site_Department__c', 'cts.com');
            fieldValueAccMap.put('Account_Type__c', 'Customer');
            fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
            fieldValueAccMap.put('Copy_Address__c', true);
            fieldValueAccMap.put('Corporate_Address_1__c', 'test');
            fieldValueAccMap.put('Corporate_City__c', 'sg');
            fieldValueAccMap.put('Corporate_Country__c', 'sg');        
            fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
            fieldValueAccMap.put('Region__c', 'APJ');
            fieldValueAccMap.put('Sub_Type__c', 'Direct');
            fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
            fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
            fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
            fieldValueAccMap.put('Fab_9_10__c', 'No');
            fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));            
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
            
            User user1 = [Select Id from User where Id=:thisUser.Id limit 1];
            Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c();
            atp1.Account__c = account1.Id ;
            atp1.User__c = user1.Id;
            atp1.Team_Role__c = 'Account Manager';
            atp1.Account_Access__c = 'Read/Write';
            atp1.Opportunity_Access__c = 'Read/Write';
            insert atp1;    
           
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId',account1.id);
            fieldValueOppMap.put('Name','Test Opportunity 1');  
            fieldValueOppMap.put('StageName','1. Discovery');
            fieldValueOppMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueOppMap.put('Target_Process_Node__c','14XM');
            fieldValueOppMap.put('Market_Segment__c','Mobility');  
            //fieldValueOppMap.put('Process_Platform__c','GF Baseline');
            fieldValueOppMap.put('Process_Platform__c','GF-Full Custom');
            fieldValueOppMap.put('Fab_Split__c',100);          
            fieldValueOppMap.put('Process_Geometry__c','0.13UM');  
            fieldValueOppMap.put('Process_Family__c','Low Power / Ultra Low Leakage');        
            fieldValueOppMap.put('Fab_Assignment_1__c','FAB 6');
            fieldValueOppMap.put('Product_Line__c','SiPh');
            Opportunity testOppty1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
             
            Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
            testOpptyProgram.Name = 'Test Opportunity 1';
            testOpptyProgram.Account__c = account1.Id;
            testOpptyProgram.Opportunity__c = testOppty1.Id;
            Insert testOpptyProgram;
               
            test.startTest();
        
            OpportunityProcess__c opptypr= new OpportunityProcess__c();
            opptypr.Process_ID__c='6-L1313-15C-1533ZZ-LPA-0PB';
            opptypr.FAB__c='FAB 6';
            opptypr.Geometry__c='0.13UM';
            opptypr.Process_Family__c ='Low Power / Ultra Low Leakage';
            insert opptypr;
                      
            testOppty1.Design_Win_Review_Status__c= 'Won';
            testOppty1.Name = 'Test Opportunity 22';
            testOppty1.Date_Design_Win_Approved__c=System.today();
            testOppty1.Fab_Assignment_1__c = 'FAB 6';
            testOppty1.Fab_Assignment_2__c = 'FAB 7';
            testOppty1.Process_Geometry__c='0.13UM';
            testOppty1.Process_Family__c='Low Power / Ultra Low Leakage';
                
            Update testOppty1;
            
            testOppty1.Fab_Assignment_1__c = 'FAB 6';
            testOppty1.Fab_Assignment_2__c = null;
            
            Update testOppty1;
            
            testOppty1.Fab_Assignment_1__c = null;
            testOppty1.Fab_Assignment_2__c = 'FAB 6';
            
            Update testOppty1;
            ApexPages.StandardController sc = new ApexPages.StandardController(testOppty1);
            OpportunityControlPoint_Ctrl obj = new OpportunityControlPoint_Ctrl(sc);
            
            PageReference pageRef = Page.OpportunityControlPoint;
            pageRef.getParameters().put('id', String.valueOf(testOppty1.Id));
            Test.setCurrentPage(pageRef);
         
            PageReference  myVf = obj.edit();
            system.AssertEquals(null, myVf);
            obj.save();
            Test.stopTest(); 
        }
    }
     
      static testMethod void OpportunityProc2() {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
            fieldValueAccMap.put('Name', 'testing501');
            fieldValueAccMap.put('Stage__c', 'Unqualified');
            fieldValueAccMap.put('Short_Name__c', 'test725');
            fieldValueAccMap.put('Site_Department__c', 'cts.com');
            fieldValueAccMap.put('Account_Type__c', 'Customer');
            fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
            fieldValueAccMap.put('Copy_Address__c', true);
            fieldValueAccMap.put('Corporate_Address_1__c', 'test');
            fieldValueAccMap.put('Corporate_City__c', 'sg');
            fieldValueAccMap.put('Corporate_Country__c', 'sg');        
            fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
            fieldValueAccMap.put('Region__c', 'APJ');
            fieldValueAccMap.put('Sub_Type__c', 'Direct');
            fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
            fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
            fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
            fieldValueAccMap.put('Fab_9_10__c', 'No');
            fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
            
            User user1 = [Select Id from User where Id=:thisUser.Id limit 1];
            Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c();
            atp1.Account__c = account1.Id ;
            atp1.User__c = user1.Id;
            atp1.Team_Role__c = 'Account Manager';
            atp1.Account_Access__c = 'Read/Write';
            atp1.Opportunity_Access__c = 'Read/Write';
            insert atp1;    
           
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId',account1.id);
            fieldValueOppMap.put('Name','Test Opportunity 1');  
            fieldValueOppMap.put('StageName','1. Discovery');
            fieldValueOppMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueOppMap.put('Target_Process_Node__c','14XM');
            fieldValueOppMap.put('Market_Segment__c','Mobility');  
            //fieldValueOppMap.put('Process_Platform__c','GF Baseline');
            fieldValueOppMap.put('Process_Platform__c','GF-Full Custom');
            fieldValueOppMap.put('Fab_Split__c',100);          
            fieldValueOppMap.put('Process_Geometry__c','0.13UM');  
            fieldValueOppMap.put('Process_Family__c','Low Power / Ultra Low Leakage');        
            fieldValueOppMap.put('Fab_Assignment_1__c','FAB 6');
            fieldValueOppMap.put('Product_Line__c','SiPh');
            Opportunity testOppty1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
             
            Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
            testOpptyProgram.Name = 'Test Opportunity 1';
            testOpptyProgram.Account__c = account1.Id;
            testOpptyProgram.Opportunity__c = testOppty1.Id;
            Insert testOpptyProgram;
            
    
            test.startTest();
        
            OpportunityProcess__c opptypr= new OpportunityProcess__c();
            opptypr.Process_ID__c='6-L1313-15C-1533ZZ-LPA-0PB';
            opptypr.FAB__c='FAB 6';
            opptypr.Geometry__c='0.13UM';
            opptypr.Process_Family__c ='Low Power / Ultra Low Leakage';
            insert opptypr;
            
           
            
            testOppty1.Design_Win_Review_Status__c= 'Won';
            testOppty1.Name = 'Test Opportunity 22';
            testOppty1.Date_Design_Win_Approved__c=System.today();
            testOppty1.Fab_Assignment_1__c = 'FAB 6';
            testOppty1.Fab_Assignment_2__c = 'FAB 7';
            testOppty1.Process_Geometry__c='0.13UM';
            testOppty1.Process_Family__c='Low Power / Ultra Low Leakage';   
            
            
            Update testOppty1;
            
            testOppty1.Fab_Assignment_1__c = 'FAB 6';
            testOppty1.Fab_Assignment_2__c = null;
            
            Update testOppty1;
            
            testOppty1.Fab_Assignment_1__c = null;
            testOppty1.Fab_Assignment_2__c = 'FAB 6';
            
            Update testOppty1;
            ApexPages.StandardController sc = new ApexPages.StandardController(testOppty1);
            OpportunityCheckpoint_Ctrl obj = new OpportunityCheckpoint_Ctrl(sc);
            
            PageReference pageRef = Page.OpportunityCheckpoint;
            pageRef.getParameters().put('id', String.valueOf(testOppty1.Id));
            Test.setCurrentPage(pageRef);
         
            PageReference  myVf = obj.edit();
            system.AssertEquals(null, myVf);
            obj.edit2();
            obj.checkAccess();
            obj.doCancel();
            obj.doCancel2();
            obj.doSave();
            obj.doSave2();
            
            Test.stopTest(); 
        }
     }
}