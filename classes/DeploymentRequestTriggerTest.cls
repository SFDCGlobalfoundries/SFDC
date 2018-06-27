@isTest
private class DeploymentRequestTriggerTest{
    
    @testSetup public static void setupData(){
        DR_Configuration__c config = new DR_Configuration__c(Admin_Email__c = 'test@gmail.com', ApproverSubmitter_Check__c = true);
        insert config;                      
    }
    
    static testMethod void triggerTest(){
        
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        insert testAccount;
        
        Contact con = new Contact(accountid=testAccount.id,lastname='test con',email='test@gmail.com');
        insert con;
    
        Deployment_Request__c drObject = new Deployment_Request__c();
        drObject.Request_Type_txt__c = 'Emergency';
        drObject.GFSDR__Application_Name_txt__c= 'Test';        
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.GFSDR__Application_Name_txt__c= 'Test';
        drObject.Source_Environment_txt__c = 'SIT';
        drObject.Target_Environment_txt__c = 'UAT';
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.Short_Description__c = 'test';
        drObject.Stage_txt__c = 'Draft';
        drObject.Description__c = 'test';
        drObject.Deployment_Request_Date_Time__c = DateTime.now();
        drObject.Is_TFA_Review_Completed_txt__c = 'No';
        drObject.Is_TA_Review_Completed_txt__c = 'No';
        insert drObject;
        drObject.Stage_txt__c = 'Deployed';
        update drObject;      

        DR_Configuration__c config = [Select Id, Name, ApproverSubmitter_Check__c from DR_Configuration__c limit 1];
        config.ApproverSubmitter_Check__c = false;
        update config;
        
        drObject.Stage_txt__c = 'Approved';
        update drObject;
    }
}