/*
 Class Name:         ProductsServicesControllerTest
 Author:             Prosenjit Saha
 Created Date:       17-June-2014
 Modified Date:      17-June-2014
 Reason:             This is Test class of the ProductsServicesController controller. 
 Change History:     
 Author:             
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/
@isTest(SeeAllData=true)
public Class ProductsServicesControllerTest{
    /*
     @Method Name:    ProductsServicesControllerTestMethod
     @Return Type:    NA
     @parameter:      NA
     @Reason:         Test Method
    */
    static testmethod void ProductsServicesControllerTestMethod(){
        test.startTest();
            ProductsServicesController Controller = new ProductsServicesController();           
            Controller.counter = 15;
            Controller.Previous();
            Controller.Beginning();
            Controller.Next();
            Controller.End();
            Controller.getDisablePrevious();
            Controller.getDisableNext();
            Controller.getTotalSize();
            Controller.getPageNumber();
            Controller.getTotalPages();
            String Str= Controller.SortExpression;
            Controller.SortExpression = 'szSortExp';
        test.stopTest();
    }
}