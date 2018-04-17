/*
Type Name: CaseCustomLookupTest
Author: Cognizant
Created Date: 24-Feb-2014
Reason: This is the Test class for CaseCustomLookupController Class. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
@isTest(SeeAllData=false)
public class CaseCustomLookupTest{

        
    public static testMethod void testCaseCustomLookup() {
        Test.startTest();
        
        Id recordTypeCustomerApplicationId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('1. Customer Applications').getRecordTypeId();
        
        Case c = new Case(RecordTypeId = recordTypeCustomerApplicationId ,Subject='Test Subject1', Description='Test Description');
        insert c;
        
        
        PageReference pageRef1 = Page.CaseCustomLookup;
        Test.setCurrentPage(pageRef1);         
        apexpages.currentpage().getparameters().put('lksrch',c.CaseNumber);  
        apexpages.currentpage().getparameters().put('frm','myForm');   
        apexpages.currentpage().getparameters().put('txt','CaseLookup');                   
        CaseCustomLookupController controller1 = new CaseCustomLookupController();
            
        controller1.searchString ='a';
        controller1.search();
        controller1.searchString ='';
        controller1.search();
        controller1.searchItems ='CaseNumber';
        controller1.searchString =c.CaseNumber;
        controller1.search();
        controller1.searchItems ='AllFields';
        controller1.searchString ='Test';
        controller1.search();
        //Modified by <Monalisa Mohapatra> Case #00052792 – Start
        CaseCustomLookupController controller2 = new CaseCustomLookupController();
        controller2.searchItems ='CaseNumber';
        controller2.searchString ='Test';
        controller2.search();
        //Modified by <Monalisa Mohapatra> Case #00052792 – End
        Test.stopTest();
    }

}