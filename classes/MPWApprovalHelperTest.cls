@isTest
public class MPWApprovalHelperTest {
  
  @testSetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
  
  
     private static testmethod void testRejectionWithoutComment(){
       Id testWorkItemId = generateAndSubmitObject();
       
       Approval.ProcessWorkitemRequest testApp = new Approval.ProcessWorkitemRequest();
        testApp.setComments ('');
        testApp.setAction   ('Approve');
        testApp.setWorkitemId(testWorkItemId);
    
       // Generate sample work item using utility method.
        //Id testWorkItemId = generateAndSubmitObject();
        
        // Reject the submitted request, without providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('');
        testRej.setAction  ('Reject');      
        testRej.setWorkitemId(testWorkItemId);
    
        Test.startTest();        
            // Attempt to process the rejection
            try
            {
                Approval.ProcessResult testRejResult =  Approval.process(testRej);
                system.assert(false, 'A rejection with no comment should cause an exception');
            }
            catch(DMLException e){}
        Test.stopTest();
       
     }
     
      private static Id generateAndSubmitObject()
    {
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u2 = new User(Alias = 'test769', Email='test76579@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='test76579@testorg.com');
        Contact c = new Contact();
        c.LastName = 'Last';
        c.FirstName = 'First';
        c.AccountId = accntObj.Id;
        c.User_Name__c = u2.UserName;
        insert c;
        
        Manufacturing_Lot__c objChild1 = new Manufacturing_Lot__c();
        objChild1.Name = 'testobjChild1';
        objChild1.Manufacturing_Lot_Id__c = '132323';
        //objChild1.Parent_Lot_Id__c = objParent.Id;
        objChild1.Active_Flag__c = true;
        objChild1.Device_ID_MES__c = 'Device';
        objChild1.Current_Mask_Layer_Being_Processed__c = 2;
        objChild1.Total_Mask_Count__c = 5;
        insert objChild1;
            
        MPW_Train_Maintenance__c mpwmant = new MPW_Train_Maintenance__c();
        mpwmant.Name = 'mpwmant'; 
        mpwmant.Tapeout_Date_Customer__c = Date.today()-1; 
        insert mpwmant;
        
         MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
          mpwConfig.Active__c = true;
          mpwConfig.Geometry__c = '28nm';
          mpwConfig.Name = '28nm HPP';
          insert mpwConfig;
            
        MPW_Reservation__c mpwRes = new MPW_Reservation__c();
        mpwRes.Name = 'Test Mpwres' ;
        mpwRes.Form_Status__c = 'Draft';
        mpwRes.Category__c ='Customer';
        mpwRes.Process_Type__c=mpwConfig.id;
        mpwRes.Customer_Company_Name__c = accntObj.Id;
        mpwRes.MPW_Train_Name__c = mpwmant.Id; 
        mpwRes.Step_1_Approver_1__c=Userinfo.getUserId();
        insert mpwRes;
        
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(mpwRes.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);
        
        System.assertEquals(reqResult.isSuccess(),true);
        
        return reqResult.getNewWorkitemIds()[0];
    }
    
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
     
}