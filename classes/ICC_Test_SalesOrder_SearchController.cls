@isTest
public class ICC_Test_SalesOrder_SearchController
{
    private static testmethod void SO_Search()
    {
        ApexPages.currentPage().getParameters().put('exptype', 'excel');
        ApexPages.currentPage().getParameters().put('SalesOrderName', 'test');
        SalesOrder_SearchController testCon = new SalesOrder_SearchController();
        
        testCon.Previous();
        testCon.Next();
        testCon.ClearAll();
        String s = testCon.SortDirection;
        testCon.SortToggle();
        testCon.Search();
        testCon.getIsFoundryView();
        testCon.getParameters();
        
        testCon.SortFieldSave = 'id'; testCon.SortField = 'name';
        testCon.SortToggle();
        
        testCon.AlphaFilter = null;
        testCon.BuildQuery();
        
        testCon.BuildWhere('','');
        testCon.BuildWhere('test','');
        testCon.isAMDOnly = false;
        testCon.isFoundryView = false;
        
        testCon.createPagination();
        testCon.resetPagination();
        
        SalesOrder_SearchController.SalesOrderSubClass objTest = new SalesOrder_SearchController.SalesOrderSubClass(new Sales_Order_Schedule__c());
        
    }
}