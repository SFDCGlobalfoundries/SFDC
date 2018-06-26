@isTest
private class DeploymentRequestTest{

    @testSetup public static void setupData(){
        
    }
    
    static testMethod void testCreateDR(){
        Deployment_Request__c drObject = new Deployment_Request__c();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(drObject);
        DeploymentRequestController controller = new DeploymentRequestController(stdcontroller); 
        drObject.Request_Type_txt__c = 'Emergency';
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.Source_Environment_txt__c = 'SIT';
        drObject.Target_Environment_txt__c = 'UAT';
        drObject.GFSDR__Application_Name_txt__c= 'Test';
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.Short_Description__c = 'test';
        drObject.Description__c = 'test';
        drObject.Deployment_Request_Date_Time__c = DateTime.now();
        drObject.Is_TFA_Review_Completed_txt__c = 'No';
        drObject.Is_TA_Review_Completed_txt__c = 'No';
        controller.disableChangeType = false;
        controller.disableApplicationName = false;   
        controller.fetchChangeTypeValues();
        controller.fetchApplicationNameValues();
        controller.save();       
        controller.cancel();
    }
    
    static testMethod void testDRhelper(){
        
        Account newAccount = new Account (name='XYZ Organization',
        BillingCity ='TestCity',
        BillingCountry ='TestCountry',
        BillingStreet ='TestStreet',
        BillingPostalCode ='t3stcd3'
        );
        
        insert newAccount;
        
        Contact NewContact = new Contact (
        FirstName = 'xyzFirst',
        LastName = 'XyZLast',
        Account = newAccount,
        Email = 'xyzmail@mail.com'
        );
        
        insert NewContact;
        
        Deployment_Request__c drObject = new Deployment_Request__c();
        drObject.Request_Type_txt__c = 'Emergency';
        drObject.Application_Category_txt__c = 'SOX compliance Apps';
        drObject.Source_Environment_txt__c = 'SIT';
        drObject.Target_Environment_txt__c = 'UAT';
        drObject.GFSDR__Application_Name_txt__c= 'Test';
        drObject.Short_Description__c = 'test';
        drObject.Description__c = 'test';
        drObject.Deployment_Request_Date_Time__c = DateTime.now();
        drObject.Is_TFA_Review_Completed_txt__c = 'No';
        drObject.Is_TA_Review_Completed_txt__c = 'No';
        insert drObject;
                
        DeploymentRequestHelper.processApprovalNew(drObject.Id);
        
    }
}