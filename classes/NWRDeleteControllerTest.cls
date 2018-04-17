@isTest
(seeAllData=true)
public class NWRDeleteControllerTest{
    
    static testMethod void testRun1(){
    
        Test.startTest();
        
        String acccountId = DeviceUtilTest.createAccount();
        String opportunitytyId;
        if(acccountId != null){
            
            opportunitytyId = DeviceUtilTest.createOpp(acccountId, '0.10UM');
        }
        
        Non_Wafer_Revenue__c nwrObj = new Non_Wafer_Revenue__c();
        if(opportunitytyId != null){
            
            nwrObj.Opportunity__c = opportunitytyId;
        }
        insert nwrObj;
        
        Test.stopTest();
        
        PageReference pageRef = Page.NWRDelete;
        //Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(pageRef);
        
        if(nwrObj != null && nwrObj.Id  != null){
        
            pageRef.getParameters().put('id', String.valueOf(nwrObj.Id));
        }
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(nwrObj);
        NWRDeleteController  nWRDeleteController  = new NWRDeleteController (standardController);
        
        PageReference pageReference = nWRDeleteController.deleteRecord();
        
        if(opportunitytyId != null){
        
            pageRef.getParameters().put('id', opportunitytyId);
        }
        
        pageRef.getHeaders().put('Referer', URL.getSalesforceBaseUrl().toExternalForm() + '/' + nwrObj.Id);
        
        standardController = new ApexPages.StandardController(nwrObj);
        nWRDeleteController  = new NWRDeleteController (standardController);
        
        pageReference = nWRDeleteController.deleteRecord();
        
    }
}