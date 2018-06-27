@isTest
private class DRTaskTriggerTest{
    
    @testSetup public static void setupData(){
        DR_Configuration__c config = new DR_Configuration__c(Admin_Email__c='test@gmail.com');
        insert config;
    }
    
    static testMethod void testDRTask(){  
    
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        insert testAccount;
        
        Contact con = new Contact(accountid=testAccount.id,lastname='test con',email='test@gmail.com');
        insert con;
        
        Deployment_Request__c drObject = new Deployment_Request__c();
        drObject.Request_Type_txt__c = 'Emergency';
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.GFSDR__Application_Name_txt__c= 'Test';
        drObject.Source_Environment_txt__c = 'SIT';
        drObject.Target_Environment_txt__c = 'UAT';
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.Short_Description__c = 'test';
        drObject.Description__c = 'test';
        drObject.Deployment_Request_Date_Time__c = DateTime.now();
        drObject.Is_TFA_Review_Completed_txt__c = 'No';
        drObject.Is_TA_Review_Completed_txt__c = 'No';
        drObject.Stage_txt__c = 'Draft';
        insert drObject;

        DR_Task__c task = new DR_Task__c();
        task.Admin_Email__c = 'test@gmail.com';
        task.Deployment_Request__c = drObject.Id;
        task.Subject__c = 'Deployment Task';
        task.Status__c = 'Not Started';
        task.Description__c = 'Please deploy changes to the target environment and close the request';
        insert task;  
        
        task.Status__c = 'Completed';
        update task;
                  
        /* DR_Task__c t = new DR_Task__c();
        t.Assigned_To__c = drObject.ownerId;
        t.Admin_Email__c = 'test@gmail.com';
        t.Deployment_Request__c = drObject.Id;
        t.Subject__c = 'Post Deployment Review';
        t.Status__c = 'Not Started';
        t.Description__c = 'Please validate changes in the target environment before this request is closed';
        insert t;

        t.Status__c = 'Completed';
        update t; */
                
    }
}