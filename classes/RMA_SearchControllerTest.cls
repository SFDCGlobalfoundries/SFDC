/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class acts as a test class for RMA_SearchController
 * History:
 *    SurendranadhNune 17022016  -   Created.
 *                            
 **/
@isTest
private class RMA_SearchControllerTest {

    @Testsetup
    static void loadTestData(){ 
        DataUtilTest.loadEnvironmentVariables();
        Account a = RMA_testDataUtility.createAccount();
        RMA_TestDataUtility.createRMA(1, a);        
    }
    
    static testmethod void testSearchMethods(){
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = acc.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
            insert con;
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
            User portalUser  = [select id from User where UserRoleId != NULL and ProfileId = :profile1.Id and isActive = True limit 1];
            
            RMA_SearchController rmaSearch = new RMA_SearchController();
            rmaSearch.getRMAcategoryList();
            rmaSearch.getFabNameList();
            rmaSearch.getdatesFilter();
            rmaSearch.getRegionList();
            rmaSearch.getStageList();
            rmaSearch.totalRecords = 1;
            rmaSearch.customerName = 'Test account';
            rmaSearch.SearchRMANumber = '123';
            rmaSearch.stage = 'Draft';
            rmaSearch.RMACategory = 'Business';
            rmaSearch.fabName = 'FAB 1';
            rmaSearch.owner = 'test owner';
            rmaSearch.createdDate = 'today';
            rmaSearch.lastModifiedDate = 'today';
            rmaSearch.AlphaFilter = 'AlphaFilter';
            rmaSearch.region = 'region';
            rmaSearch.SortField = 'SortField';
            rmaSearch.ExporttoExcel();
        Test.stopTest();
    }
    
    static testmethod void testSearchFunctionality(){
        Account acc = [select name,id from account limit 1];
        rma__c rmaRec = [select id from rma__c limit 1];
        
        Test.startTest();
            Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = acc.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
            insert con;
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
            User portalUser  = [select id from User where UserRoleId != NULL and ProfileId = :profile1.Id and isActive = True limit 1];
            
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Lot_Device_Risk_Production__c = 'test';
            rmaRec.Return_Estimated_Date__c = Date.today() +5;
            update rmaRec;
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            
            //Get all fields from RMA
            UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
            String rmaFields = util.getAllFields('RMA__c');   
            rmaRec = database.query('select '+rmaFields+', owner.name, CreatedBy.name from RMA__c limit 1');
                        
            Test.setCurrentPage(Page.RMA_search);
            Apexpages.currentPage().getParameters().put('CustomerName', acc.name);
            Apexpages.currentPage().getParameters().put('SearchRMANumber', rmaRec.name);
            Apexpages.currentPage().getParameters().put('RMAcategory', rmaRec.RMA_Category__c);
            Apexpages.currentPage().getParameters().put('stage', rmaRec.Workflow_Stage__c);
            Apexpages.currentPage().getParameters().put('region', rmaRec.region__c);
            Apexpages.currentPage().getParameters().put('fabName', rmaRec.fab__c);
            Apexpages.currentPage().getParameters().put('productName', rmaRec.Lot_Device_Risk_Production__c);
            Apexpages.currentPage().getParameters().put('expectedCloseDate', 'TODAY');
            Apexpages.currentPage().getParameters().put('createdDate', 'TODAY');
            Apexpages.currentPage().getParameters().put('lastModifiedDate', 'TODAY');
            Apexpages.currentPage().getParameters().put('AlphaFilter', 'All');
            Apexpages.currentPage().getParameters().put('SortField', 'Name');
            Apexpages.currentPage().getParameters().put('exptype', 'extype');
            RMA_SearchController rmaSearch = new RMA_SearchController();
            rmaSearch.next();
            rmaSearch.Previous();
            rmaSearch.ClearAll();
            rmaSearch.getUserRecordAccessList(new id[]{rmaRec.id});
            rmaSearch.SortDirection = 'asc';
            rmaSearch.SortFieldSave = 'owner';
            rmaSearch.SortToggle();
            rmaSearch.SearchCase();
            //running as portal user
            system.runAs(portalUser){
                RMA_SearchController rmaSearch1 = new RMA_SearchController();
                rmaSearch.SearchCase();
            }
        Test.stopTest();
        
    }
}