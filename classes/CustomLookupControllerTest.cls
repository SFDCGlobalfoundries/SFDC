/*
 Type Name: CustomLookupControllerTest
 Author: Prosenjit Saha and Thomas Lai
 Created Date: 10-Oct-2013
 Reason: This is the test class for 'CustomLookupController' class.
 Change History:
 Author:  Prosenjit Saha
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/


@isTest(SeeAllData=true)
private class CustomLookupControllerTest
{
    static testMethod void customLookUPTestMethodPID(){
        ApexPages.currentPage().getParameters().put('frm', 'BX041Page:BX041Form');
        ApexPages.currentPage().getParameters().put('Objct', 'REQPID');
        ApexPages.currentPage().getParameters().put('Geom', '0.010UM');
        ApexPages.currentPage().getParameters().put('ProcFam', 'XM'); 
        ApexPages.currentPage().getParameters().put('lksrch', 'Test'); 
        Pagereference pf = new pagereference ('/apex/CustomLoopUpPage?'); 
        test.startTest();
        CustomLookupController controller = new CustomLookupController();
            controller.search();
            controller.getListSize();
            controller.QueryProcessesIP();
            controller.DoSort();
        test.stopTest();
    }
    static testMethod void customLookUPTestMethodIP(){
        ApexPages.currentPage().getParameters().put('frm', 'BX041Page:BX041Form');
        ApexPages.currentPage().getParameters().put('Objct', 'IP');
        ApexPages.currentPage().getParameters().put('Geom', '0.010UM');
        ApexPages.currentPage().getParameters().put('ProcFam', 'XM'); 
        ApexPages.currentPage().getParameters().put('lksrch', 'Test'); 
        Pagereference pf = new pagereference ('/apex/CustomLoopUpPage?'); 
        test.startTest();
        CustomLookupController controller = new CustomLookupController();
            controller.search();
            controller.getIPListSize();
            controller.QueryProcessesIP();
            controller.DoSort();
        test.stopTest();
    }
    static testMethod void woSearchStringCustomLookUPTestMethodPID(){
        ApexPages.currentPage().getParameters().put('frm', 'BX041Page:BX041Form');
        ApexPages.currentPage().getParameters().put('Objct', 'REQPID');
        ApexPages.currentPage().getParameters().put('Geom', '0.010UM');
        ApexPages.currentPage().getParameters().put('ProcFam', 'XM'); 
        Pagereference pf = new pagereference ('/apex/CustomLoopUpPage?'); 
        test.startTest();
        CustomLookupController controller = new CustomLookupController();
            //controller.search();
            controller.getListSize();
            //controller.QueryProcessesIP();
        test.stopTest();
    }
    static testMethod void woSearchStringCustomLookUPTestMethodIP(){
        ApexPages.currentPage().getParameters().put('frm', 'BX041Page:BX041Form');
        ApexPages.currentPage().getParameters().put('Objct', 'IP');
        ApexPages.currentPage().getParameters().put('Geom', '0.010UM');
        ApexPages.currentPage().getParameters().put('ProcFam', 'XM'); 
        Pagereference pf = new pagereference ('/apex/CustomLoopUpPage?'); 
        test.startTest();
        CustomLookupController controller = new CustomLookupController();
            controller.search();
            controller.getIPListSize();
            controller.QueryProcessesIP();
        test.stopTest();
    }
    
}