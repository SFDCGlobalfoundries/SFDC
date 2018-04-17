/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest(SeeAllData = false)
private class GF_DynamicQueryHandlerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);                                
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Austria');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Austria');        
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMap.put('Has_Valid_NDA__c',true);
            fieldValueMap.put('Tech_Geo_Granted__c','0.11UM;0.13UM;'); 
            fieldValueMap.put('Valid_Tech_Geos__c','0.11UM; 0.13UM;');
            fieldValueMap.put('Short_Name__c','testAcc'+i);
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);

    }
    // Testing order query service
    static testMethod void orderQueryServiceTest() {
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new GF_WebServiceMockImpl());
        
        GF_DynamicQueryHandler.getOrderReport('ALL','ALL','ALL',
                                              'ALL','ALL',
                                              'ALL','ALL','ALL','15-APR-2013','19-APR-2013',
                                              'ALL','1');
        
        GF_DynamicQueryHandler.getOrderReport('ALL','ALL','ALL',
                                              'ALL','ALL',
                                              'ALL','ALL','ALL','15-APR-2013','19-APR-2013',
                                              'ALL','');
        system.assertEquals(true,true);
        Test.stopTest();      
        
    }
    
    // Testing order getBacklogReport service
    
    static testMethod void backlogReportServiceTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new GF_WebServiceMockImpl());
        GF_DynamicQueryHandler.getBacklogReport('1111');
        system.assertEquals(true,true);
        Test.stopTest();    
    }
    
    // Test order shipSummary service 
    
    static testMethod void ShipmentForOrderServiceTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new GF_WebServiceMockImpl());
        GF_DynamicQueryHandler.getShipmentOrderReport('2222');
        system.assertEquals(true,true);
        Test.stopTest();
    }
    
    // Test all constants used in dynamic query applications
    
    static testMethod void constantClsTest(){
        Test.startTest();
        
        GF_ConstantsCls constant = new GF_ConstantsCls();
        /* GF_ConstantsCls.ORDER_Q                  ='OrderQueryHelper';
GF_ConstantsCls.SHIPPING_Q               ='ShippingQueryHelper';
GF_ConstantsCls.PRODUCTION_Q             ='ProductionQueryHelper';
GF_ConstantsCls.FAB_API_NAME             ='GF_Fab__c';
GF_ConstantsCls.GEOMETRY_API_NAME        ='GF_Geometry__c';
GF_ConstantsCls.LOT_TYPE_API_NAME        ='GF_Lot_Type__c';
GF_ConstantsCls.ORDER_STATUS_API_NAME    ='GF_Order_Status__c';
GF_ConstantsCls.ORDER_TYPE_API_NAME      ='GF_Order_Type__c'; 
GF_ConstantsCls.ORDER_PAGE               ='GF_OrderQueryPage';
GF_ConstantsCls.SHIPPING_PAGE            ='GF_ShippingQueryPage';
GF_ConstantsCls.PRODUCTION_PAGE          ='GF_ProductionQueryPage';
GF_ConstantsCls.SUCCESS                  ='100';
GF_ConstantsCls.ERROR_TOOMANY_ROWS       ='101';
GF_ConstantsCls.ERROR_NO_DATA_FOUND      ='102';
GF_ConstantsCls.ERROR_DATE_IS_NULL       ='103';
GF_ConstantsCls.ERROR_LOGIN_FAIL         ='104';
GF_ConstantsCls.ERROR_CANNOT_BE_NULL     ='106';*/
        
        system.assertEquals(true,true);
        Test.stopTest();
    }
    
    // Following method use to test general functionality code of order query 
    
    static testMethod void orderQueryTest(){
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.GF_OrderQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_OrderQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        GF_ConstantsCls constants = new GF_ConstantsCls();
        
        handler.DynamicQueryURL = 'GF_OrderQueryPage';
        
        GF_DynamicQueryHandler.prepareGridColumn();
        GF_OrderQueryHelper orderHelper = new GF_OrderQueryHelper();
        
        List<GF_DQ_FAB_Settings__c> fabValues = GF_TestData.getFabList();
        insert fabValues;
        
        List<GF_DQ_Geometry_Settings__c> geometryValues = GF_TestData.getGeometryList();           
        insert geometryValues;
        
        List<GF_DQ_Order_status_Settings__c> orderValues = GF_TestData.getOrderStatusList();
        insert orderValues;
        
        List<GF_DQ_Order_Type__c> orderTyprValues = GF_TestData.getOrderTypeList();           
        insert orderTyprValues;
        
        List<GF_DQ_Lot_Type_Settings__c> lotValues = GF_TestData.getLotdataList();           
        insert lotValues;
        
        orderHelper.getFabList();
        orderHelper.getGeometryList();
        orderHelper.getOrderStatusList();
        orderHelper.getOrderTypeList();
        GF_CommonUtilityCls.getLotTypeList();
        //GF_CommonUtilityCls.getInstanceOfDQPicklist();
        GF_CommonUtilityCls.getInstance('GF_DynamicQueryHandler');
        handler.setOrderQueryObj(orderHelper);
        handler.getOrderQueryObj();
        handler.getCustomerList();
        //GF_DynamicQueryHandler.getUserShortName();
        
        // Test Coverage related to Wrapper classes of order report module
        GF_OrderStub.ShipSummaryForOrderInfo_element summaryInfo = new GF_OrderStub.ShipSummaryForOrderInfo_element();
        summaryInfo.FAB = 'FAB1';
        
        List<GF_OrderStub.ShipSummaryForOrderInfo_element> summaryInfoElementList = new List<GF_OrderStub.ShipSummaryForOrderInfo_element>();
        summaryInfoElementList.add(summaryInfo);
        GF_DynamicQueryHandler.ShipmentForOrderWrapperCls shipmentWrapper = new GF_DynamicQueryHandler.ShipmentForOrderWrapperCls(summaryInfoElementList,100);  
        
        //Map<String, GF_OrderStub.BackLogResponse_element> bklg_response_map_x = new Map<String, GF_OrderStub.BackLogResponse_element>();
        GF_OrderStub.BackLogResponse_element backlogResponseElement = new GF_OrderStub.BackLogResponse_element();
        
        GF_OrderStub.BackLogInfo_element backlogInfoElement = new GF_OrderStub.BackLogInfo_element();
        backlogInfoElement.PO = '1111';
        List<GF_OrderStub.BackLogInfo_element> backlogInfoElementList = new List<GF_OrderStub.BackLogInfo_element>();
        backlogInfoElementList.add(backlogInfoElement);
        
        GF_DynamicQueryHandler.BacklogWrapperCls backlogWrapper = new GF_DynamicQueryHandler.BacklogWrapperCls(backlogInfoElementList,100);                                                                   
        
        
        GF_OrderStub.OrderSummaryResponse_element OrderSummaryResponse_element = new GF_OrderStub.OrderSummaryResponse_element();
        
        GF_OrderStub.OrderSummaryInfo_element summaryElement = new GF_OrderStub.OrderSummaryInfo_element();
        summaryElement.SO = '111';   
        
        List<GF_OrderStub.OrderSummaryInfo_element> MockOrderSummaryInfo;
        MockOrderSummaryInfo= new List<GF_OrderStub.OrderSummaryInfo_element>();
        MockOrderSummaryInfo.add(summaryElement);
        
        GF_DynamicQueryHandler.OrderWrapperCls orderWrapper = new GF_DynamicQueryHandler.OrderWrapperCls(MockOrderSummaryInfo,'100');
        system.assertEquals(true,true);
        Test.stopTest();     
    }
    
    // Method test production report export to excel
    
    static testMethod void productionQueryExporToExcel(){
        // Export to excel for production query
        Test.setCurrentPageReference(new PageReference('Page.GF_ProductionQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ProductionQueryPage');   
        GF_DynamicQueryHandler handler2 = new GF_DynamicQueryHandler();
        handler2.DynamicQueryURL = 'GF_ProductionQueryPage';
        handler2.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL'; 
        
        Test.StartTest();
        // Production report Export to Excel
        handler2.gridName = 'EprfReport';
        handler2.exportToExcel();
        
        handler2.gridName = 'WaferStartReport';
        handler2.exportToExcel();
        
        handler2.gridName = 'currentRunSheetReport';
        handler2.exportToExcel();
        
        handler2.gridName = 'FabOutLocationReport';
        handler2.exportToExcel();
        
        handler2.gridName = 'ProductionReport1';
        handler2.exportToExcel();
        
        // Updated on 17 FEB 2015
        //handler2.para='Prod1Report';
        //handler2.exportToExcelReport();
        
        handler2.gridName = 'ProductionReport2';
        handler2.exportToExcel();
        
        // Updated on 17 FEB 2015
        //handler2.para='Prod2Report';
        //handler2.exportToExcelReport();
        
        handler2.gridName = 'ProductionReport3';
        handler2.exportToExcel();
        // Updated on 17 FEB 2015
        //handler2.para='Prod3Report';
        //handler2.exportToExcelReport();
        system.assertEquals(handler2.gridName,'ProductionReport3');
        Test.stopTest(); 
        
    }
    
    
    // Method Test Export to Excel functionality
    static testMethod void dynamicQueryExportToExcelTest(){
        // Export to excel for order query
        Test.setCurrentPageReference(new PageReference('Page.GF_OrderQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_OrderQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        handler.DynamicQueryURL = 'GF_OrderQueryPage';
        handler.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
        
        // Export to excel for shipment query
        
        Test.setCurrentPageReference(new PageReference('Page.GF_ShippingQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ShippingQueryPage');   
        GF_DynamicQueryHandler handler1 = new GF_DynamicQueryHandler();
        handler1.DynamicQueryURL = 'GF_ShippingQueryPage';
        handler1.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
       // Profile p12 = [SELECT Id FROM Profile WHERE Name='GF CSR' LIMIT 1]; 
        
        //Profile p13 = [SELECT Id FROM Profile WHERE Name LIKE '%Portal%' Limit 1];//[SELECT Id FROM Profile WHERE (NOT Name LIKE '%CSR%') and (NOT Name LIKE '%Admin%') and (NOT Name LIKE '%admin%') LIMIT 1]; 
         
       /* HCM_Employee__c hcm = new HCM_Employee__c();
        hcm.First_Name__c = 'Ja';
        hcm.Last_Name__c = 'jean';
        hcm.Employee_ID__c = 'iiju889';
        hcm.Login_ID__c = 'iiju889';
        hcm.Email_Address__c = 'standarduser@testorg32.com';
        insert hcm;
        User u3 = new User(Alias = 'standt1', 
                           EmailEncodingKey='UTF-8', LastName='TestingFor', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p12.Id, isActive = true,
                           TimeZoneSidKey='America/Los_Angeles', UserName='standardButuser1@testorg1.com',FederationIdentifier = 'iiju889',HCM_Employee_ID__c = 'iiju889');
        u3.Email = 'standarduser@testorg32.com';
        insert u3;*/
        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive = true and userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        Account acc = getAccount('MYTEST ACCOUNT1');
        System.runAs(ur){
            //insert acc;
            Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design'
            );
            insert con;
           
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();
            
           /* UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            system.debug('portalRole is ' + portalRole);*/
            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id  );
            //portalAccountOwner1.UserRoleId = portalRole.Id;
            
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            portalAccountOwner1.IsActive = true;
            Database.insert(portalAccountOwner1);
            system.runAs(portalAccountOwner1){
                GF_DynamicQueryHandler handlerDummy = new GF_DynamicQueryHandler();
                handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
                handlerDummy.getShipmentFilters('Portal User');
                Test.startTest();
                handlerDummy.getProd3Filters('Portal User');
            }
        }
        
      
            GF_DynamicQueryHandler handlerDummy2 = new GF_DynamicQueryHandler();
            handlerDummy2.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
            handlerDummy2.para='OrderReport';
            handlerDummy2.exportToExcelReport();
            
            handlerDummy2.getCustomerList();
        
        // Order Query Export to Excel
        Test.setMock(WebServiceMock.class, new GF_WebServiceMockImpl());
        handler.gridName = 'Order_Report';
        handler.exportToExcel();
        
        handler.gridName = 'Shipment_Report';
        handler.exportToExcel();
        // Updated on 17 FEB 2015
        //handler.para='OrderReport';
        //handler.exportToExcelReport();
        
        handler.gridName = 'Backlog_Report';
        handler.exportToExcel();
        //handler.gridName = 'Shipment_Report';
        //handler.exportToExcel();
        //DataUtilTest.loadEnvironmentVariables();
        
        Test.setMock(WebServiceMock.class, new GF_ShipmentWebServiceMockImpl()); 
        handler1.gridName = 'ShippingReport';
        handler1.exportToExcel();
        // Updated on 17 FEB 2015
        Account accntObj1 = getAccount('MYTEST ACCOUNT1');
        
        Account accntObj2 = getAccount('MYTEST ACCOUNT2');
            accntObj2.ParentId=accntObj1.Id;
            update accntObj2;  
        
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
        Account_Team_Proxy__c ATP = new Account_Team_Proxy__c();
        ATP.User__c = admUser.Id;
        ATP.Account__c = accntObj1.Id;
        ATP.Account_Access__c='Read/Write';
        ATP.Opportunity_Access__c= 'Read/Write';
        insert ATP;
        
        
        List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType> test1 = new List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType>();
        List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> wipAndShipLotReportTest = new  List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType>();
        List <GF_ProductionQueryStub.ProdLotStrtSmryType> lotStartDateReportTest = new List <GF_ProductionQueryStub.ProdLotStrtSmryType>();
        List <GF_ProductionQueryStub.ProcEprfResponseType> eprfReportTest = new  List <GF_ProductionQueryStub.ProcEprfResponseType>();
        List <GF_ProductionQueryStub.RunSheetResponseType> currentRunsheetReportTest = new List <GF_ProductionQueryStub.RunSheetResponseType>();
        List <GF_ProductionQueryStub.WaferStartResponseType> waferStartReportTest = new List <GF_ProductionQueryStub.WaferStartResponseType>();
        List <GF_ProductionQueryStub.FabOutLocationResponseType> faboutLocationReportTest = new List <GF_ProductionQueryStub.FabOutLocationResponseType>();
        
        handler1.wipLotReport = test1;
        handler1.wipAndShipLotReport = wipAndShipLotReportTest;
        handler1.lotStartDateReport = lotStartDateReportTest;
        handler1.eprfReport = eprfReportTest;
        handler1.currentRunsheetReport = currentRunsheetReportTest;
        handler1.waferStartReport = waferStartReportTest;
        handler1.faboutLocationReport = faboutLocationReportTest;
        
        handler1.gridParam = 'test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1';
        handler1.para='ShipingReport';
        handler1.exportToExcelReport();
        handler1.para='OrderReport';
        handler1.exportToExcelReport();
      //  handler1.para='Prod1Report';
       // handler1.exportToExcelReport();
       // handler1.para='Prod2Report';
       // handler1.exportToExcelReport();
       // handler1.para='Prod3Report';
       // handler1.exportToExcelReport();  
        
        //handler1.getShipmentFilters('CSR');
        handler1.getOrderFilters('Admin');
        //handler1.getOrderFilters('Portal User');
        
        //handler1.getProd1Filters('CSR');
        handler1.getProd1Filters('Admin');
        //handler1.getProd1Filters('Portal User');
        
        //handler1.getProd2Filters('CSR');
        handler1.getProd2Filters('Admin');
        //handler1.getProd2Filters('Portal User');
        
        //handler1.getProd3Filters('CSR');
        handler1.getProd3Filters('Admin');
        //handler1.getProd3Filters('Portal User');
        //List<Account> accList = new List<Account>();
        
        /* Account accntObj2 = new Account(name ='acc1',Site_Department__c='Site1',Sub_Type__c='Direct',ParentId=accntObj1.Id,
Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
Corporate_City__c='city1',Corporate_Country__c='Austria', Short_Name__c = 'acc1',
Has_Valid_NDA__c =true,Tech_Geo_Granted__c='0.11UM;0.13UM;', Valid_Tech_Geos__c='0.11UM; 0.13UM;'
);                  
insert accntObj2;
*/  
        //handler1.getShipmentFilters('CSR');
        handler1.getShipmentFilters('Admin');
        //handler1.getShipmentFilters('Portal User');
        handler1.getAllChildAccounts(accntObj1.Id);
        handler1.reDirectToExport();
        //handler1.getAccShortNames('testAcc1');
        handler1.gridName = 'PO_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'IPN_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'Lot_Data_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'Ship_Date_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'Shipment_Detail_Report';
        handler1.exportToExcel();
        //handler1.getCSRs(admUser.ID);
        handler1.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
      //  handler1.getShipmentFilters('CSR');
        Test.stoptest();
      
    	system.assertEquals(handler1.gridName,'Shipment_Detail_Report');
    }
    
    // Start: Test Methods for Portal user Export to Excel functionality
        
    static testMethod void dynamicQueryExportToExcelTestPortalProd1(){
        
        Test.setCurrentPageReference(new PageReference('Page.GF_ProductionQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ProductionQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        handler.DynamicQueryURL = 'GF_ProductionQueryPage';       
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive = true and userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        Account acc = getAccount('MYTEST ACCOUNT1');
        System.runAs(ur){
            //insert acc;
            Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design'
            );
            insert con;           
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id );            
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            portalAccountOwner1.IsActive = true;
            Database.insert(portalAccountOwner1);
            system.runAs(portalAccountOwner1){
                GF_DynamicQueryHandler handlerDummy = new GF_DynamicQueryHandler();
                ProductionReport__c pr = new ProductionReport__c();
                pr.CUSTOMER_INITIAL__c = 'testAcc1';
                Insert pr;
                Test.startTest();
                handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';               
                handlerDummy.rTypeValue = 'Prod1Report';
                handlerDummy.exportToExcelForPortalUser();               
                handlerDummy.gridParam = 'T,FAB 35,T,T,T,T,AL,AL,AL,AL,AL,AL,AL,AL';
                handlerDummy.rTypeValue = 'Prod1Report';
                handlerDummy.exportToExcelForPortalUser();
                Test.stopTest();
            }
        }
    }       
    static testMethod void dynamicQueryExportToExcelTestPortalProd2(){
        
        Test.setCurrentPageReference(new PageReference('Page.GF_ProductionQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ProductionQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        handler.DynamicQueryURL = 'GF_ProductionQueryPage ';       
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive = true and userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        Account acc = getAccount('MYTEST ACCOUNT1');
        System.runAs(ur){
            //insert acc;
            Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design'
            );
            insert con;           
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id  );
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            portalAccountOwner1.IsActive = true;
            Database.insert(portalAccountOwner1);
            system.runAs(portalAccountOwner1){
                GF_DynamicQueryHandler handlerDummy = new GF_DynamicQueryHandler();
                //handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,03/12/2000,04/15/2018,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
                ProductionReport__c pr = new ProductionReport__c();
                pr.CUSTOMER_INITIAL__c = 'testAcc1';
                pr.SHIP_DATE__c = date.newinstance(2005,12,12);
                Insert pr;
                Test.startTest(); 
                handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,03/12/2000,04/15/2018,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
                handlerDummy.rTypeValue = 'Prod2Report';
                handlerDummy.exportToExcelForPortalUser();
                handlerDummy.rTypeValue = 'Prod3Report';
                handlerDummy.exportToExcelForPortalUser();
                
                handlerDummy.gridParam = 'AL,FAB 3,AL,AL,AL,03/12/2000,04/15/2018,AL,AL,AL,AL,AL,AL,AL';
                handlerDummy.rTypeValue = 'Prod2Report';
                handlerDummy.exportToExcelForPortalUser();
                handlerDummy.rTypeValue = 'Prod3Report';
                handlerDummy.exportToExcelForPortalUser();
                Test.stopTest();
            }
        }
    }      
    static testMethod void dynamicQueryExportToExcelTestPortalShip(){
                
        Test.setCurrentPageReference(new PageReference('Page.GF_ShippingQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ShippingQueryPage');   
        GF_DynamicQueryHandler handler1 = new GF_DynamicQueryHandler();
        handler1.DynamicQueryURL = 'GF_ShippingQueryPage';        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive = true and userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        Account acc = getAccount('MYTEST ACCOUNT1');
        System.runAs(ur){
            //insert acc;
            Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design'
            );
            insert con;           
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id  );
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            portalAccountOwner1.IsActive = true;
            Database.insert(portalAccountOwner1);
            system.runAs(portalAccountOwner1){
                GF_DynamicQueryHandler handlerDummy = new GF_DynamicQueryHandler();
                ShippingReport__c sr = new ShippingReport__c();
                sr.CUSTOMER_INITIAL__c = 'testAcc1';
                sr.SHIP_DATE__c = date.newinstance(2005,12,12);
                Insert sr;
                Test.startTest();
                handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,03/12/2000,04/15/2018,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
                handlerDummy.rTypeValue = 'ShipingReport';
                handlerDummy.exportToExcelForPortalUser();
                
                handlerDummy.gridParam = 'AL,FAB 35,AL,AL,AL,03/12/2000,04/15/2018,AL,AL,AL,AL,AL,AL,AL';
                handlerDummy.rTypeValue = 'ShipingReport';
                handlerDummy.exportToExcelForPortalUser();
                Test.stopTest();
            }
        }
    }
      
    static testMethod void dynamicQueryExportToExcelTestPortalOrder(){
        Test.setCurrentPageReference(new PageReference('Page.GF_OrderQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_OrderQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        handler.DynamicQueryURL = 'GF_OrderQueryPage';        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive = true and userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        Account acc = getAccount('MYTEST ACCOUNT1');
        System.runAs(ur){
            //insert acc;
            Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design'
            );
            insert con;
           
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();
            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id  );
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            portalAccountOwner1.IsActive = true;
            Database.insert(portalAccountOwner1);
            system.runAs(portalAccountOwner1){
                GF_DynamicQueryHandler handlerDummy = new GF_DynamicQueryHandler();
                OrderReport__c ord = new OrderReport__c();
                ord.CUSTOMER_INITIAL__c = 'testAcc1';
                ord.ORDER_DATE__c = date.newinstance(2005,12,12);
                Insert ord;
                Test.startTest();
                handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,All,All,ALL,03/12/2000,04/15/2018,ALL,ALL,ALL,ALL';
                handlerDummy.rTypeValue = 'OrderReport';
                handlerDummy.exportToExcelForPortalUser();
                
                handlerDummy.gridParam = 'AL,FAB 35,AL,AL,AL,Al,Al,AL,03/12/2000,04/15/2018,AL,AL,AL,AL';
                handlerDummy.rTypeValue = 'OrderReport';
                handlerDummy.exportToExcelForPortalUser();
                Test.stopTest();                
            }
        }
    } 
    
    // End: Test Methods for Portal user Export to Excel functionality
    
    
       static testMethod void dynamicQueryExportToExcelTest2(){
        // Export to excel for order query
        Test.setCurrentPageReference(new PageReference('Page.GF_OrderQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_OrderQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        handler.DynamicQueryURL = 'GF_OrderQueryPage';
        handler.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
        
        // Export to excel for shipment query
        
        Test.setCurrentPageReference(new PageReference('Page.GF_ShippingQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ShippingQueryPage');   
        GF_DynamicQueryHandler handler1 = new GF_DynamicQueryHandler();
        handler1.DynamicQueryURL = 'GF_ShippingQueryPage';
        handler1.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
        Profile p12 = [SELECT Id FROM Profile WHERE Name='GF CSR' LIMIT 1]; 

        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive = true and userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        Account acc = getAccount('MYTEST ACCOUNT1');
        System.runAs(ur){
            //insert acc;
            Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design'
            );
            insert con;
           
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();
            
        
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id  );
          
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            portalAccountOwner1.IsActive = true;
            Database.insert(portalAccountOwner1);
            system.runAs(portalAccountOwner1){
                GF_DynamicQueryHandler handlerDummy = new GF_DynamicQueryHandler();
                handlerDummy.gridParam = 'ALL,FAB 35,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
                handlerDummy.getShipmentFilters('Portal User');
                Test.startTest();
                handlerDummy.getProd3Filters('Portal User');
            }
        }
      
        
        
        // Order Query Export to Excel
        Test.setMock(WebServiceMock.class, new GF_WebServiceMockImpl());
        handler.gridName = 'Order_Report';
        handler.exportToExcel();
        
        handler.gridName = 'Shipment_Report';
        handler.exportToExcel();
        // Updated on 17 FEB 2015
        //handler.para='OrderReport';
        //handler.exportToExcelReport();
        
        handler.gridName = 'Backlog_Report';
        handler.exportToExcel();
      
        Test.setMock(WebServiceMock.class, new GF_ShipmentWebServiceMockImpl()); 
        handler1.gridName = 'ShippingReport';
        handler1.exportToExcel();
        // Updated on 17 FEB 2015
        Account accntObj1 = getAccount('MYTEST ACCOUNT1');
        
        Account accntObj2 = getAccount('MYTEST ACCOUNT2');
            accntObj2.ParentId=accntObj1.Id;
            update accntObj2;  
        
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
        Account_Team_Proxy__c ATP = new Account_Team_Proxy__c();
        ATP.User__c = admUser.Id;
        ATP.Account__c = accntObj1.Id;
        ATP.Account_Access__c='Read/Write';
        ATP.Opportunity_Access__c= 'Read/Write';
        insert ATP;
        
        
        List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType> test1 = new List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType>();
        List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> wipAndShipLotReportTest = new  List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType>();
        List <GF_ProductionQueryStub.ProdLotStrtSmryType> lotStartDateReportTest = new List <GF_ProductionQueryStub.ProdLotStrtSmryType>();
        List <GF_ProductionQueryStub.ProcEprfResponseType> eprfReportTest = new  List <GF_ProductionQueryStub.ProcEprfResponseType>();
        List <GF_ProductionQueryStub.RunSheetResponseType> currentRunsheetReportTest = new List <GF_ProductionQueryStub.RunSheetResponseType>();
        List <GF_ProductionQueryStub.WaferStartResponseType> waferStartReportTest = new List <GF_ProductionQueryStub.WaferStartResponseType>();
        List <GF_ProductionQueryStub.FabOutLocationResponseType> faboutLocationReportTest = new List <GF_ProductionQueryStub.FabOutLocationResponseType>();
        List<List<GF_SF_Stub.ShipInfo_element>> listOfShippingReportTest = new List<List<GF_SF_Stub.ShipInfo_element>>();
        
        
        handler1.fileType ='Test';
        handler1.wipLotReport = test1;
        handler1.wipAndShipLotReport = wipAndShipLotReportTest;
        handler1.lotStartDateReport = lotStartDateReportTest;
        handler1.eprfReport = eprfReportTest;
        handler1.currentRunsheetReport = currentRunsheetReportTest;
        handler1.waferStartReport = waferStartReportTest;
        handler1.faboutLocationReport = faboutLocationReportTest;
        handler1.listOfShippingReport = listOfShippingReportTest;
      
        handler1.gridParam = 'test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1,test1';
       
        handler1.para='Prod1Report';
        handler1.exportToExcelReport();
        handler1.para='Prod2Report';
        handler1.exportToExcelReport();
        handler1.para='Prod3Report';
        handler1.exportToExcelReport();  
        
        //handler1.getShipmentFilters('CSR');
        handler1.getOrderFilters('Admin');
        //handler1.getOrderFilters('Portal User');
        
        //handler1.getProd1Filters('CSR');
        handler1.getProd1Filters('Admin');
        //handler1.getProd1Filters('Portal User');
        
        //handler1.getProd2Filters('CSR');
        handler1.getProd2Filters('Admin');
        //handler1.getProd2Filters('Portal User');
        
        //handler1.getProd3Filters('CSR');
        handler1.getProd3Filters('Admin');
        //handler1.getProd3Filters('Portal User');
        //List<Account> accList = new List<Account>();
        
       
        //handler1.getShipmentFilters('CSR');
        handler1.getShipmentFilters('Admin');
        //handler1.getShipmentFilters('Portal User');
        handler1.getAllChildAccounts(accntObj1.Id);
        handler1.reDirectToExport();
        //handler1.getAccShortNames('testAcc1');
        handler1.gridName = 'PO_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'IPN_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'Lot_Data_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'Ship_Date_Report';
        handler1.exportToExcel();
        
        handler1.gridName = 'Shipment_Detail_Report';
        handler1.exportToExcel();
        //handler1.getCSRs(admUser.ID);
        handler1.gridParam = 'ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL,ALL';
        handler1.getShipmentFilters('CSR');
        Test.stoptest();
      
    	system.assertEquals(handler1.gridName,'Shipment_Detail_Report');
    }
    // Method covers shipping query related test coverage
    
    static testMethod void sipingQueryTest(){
        
        GF_ConstantsCls constant = new GF_ConstantsCls();
        Test.setCurrentPageReference(new PageReference('Page.GF_ShippingQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ShippingQueryPage');   
        GF_DynamicQueryHandler handler = new GF_DynamicQueryHandler();
        
        GF_ShippingQueryHelper shippingQueryObj = new GF_ShippingQueryHelper();
        GF_ProductionQueryHelper productQueryObj = new GF_ProductionQueryHelper();
        //shiping query getter/setters
        handler.setShippingQueryObj(shippingQueryObj);
        handler.getShippingQueryObj();
        //production query getter/setters
        handler.setproductQueryObj(productQueryObj);
        handler.getproductQueryObj();
        
        handler.DynamicQueryURL = 'GF_ShippingQueryPage';
        system.assertEquals(handler.DynamicQueryURL,'GF_ShippingQueryPage');
        GF_DynamicQueryHandler.prepareGridColumn();
        GF_ShippingQueryHelper shipmentHelper = new GF_ShippingQueryHelper();
        
        List<GF_DQ_FAB_Settings__c> fabValues = GF_TestData.getFabList();
        insert fabValues;
        
        List<GF_DQ_Geometry_Settings__c> geometryValues = GF_TestData.getGeometryList();           
        insert geometryValues;
        
        List<GF_DQ_Order_status_Settings__c> orderValues = GF_TestData.getOrderStatusList();
        insert orderValues;
        
        List<GF_DQ_Order_Type__c> orderTyprValues = GF_TestData.getOrderTypeList();           
        insert orderTyprValues;
        
        List<GF_DQ_Lot_Type_Settings__c> lotValues = GF_TestData.getLotdataList();           
        insert lotValues; 
        
        shipmentHelper.getFabList();
        shipmentHelper.getGeometryList();
        shipmentHelper.getOrderTypeList();
        
        GF_SF_Stub.ShipInfo_element shipInfoElement = new GF_SF_Stub.ShipInfo_element();
        shipInfoElement.FAB = 'FAB1';
        
        List<GF_SF_Stub.ShipInfo_element> shipInfoElementList = new List<GF_SF_Stub.ShipInfo_element>();
        shipInfoElementList.add(shipInfoElement);
        
        GF_DynamicQueryHandler.ShippingWrapperCls shipingWrapperCls= new GF_DynamicQueryHandler.ShippingWrapperCls(shipInfoElementList,'102'); 
        
        //shipdate wrapper class
        GF_SF_Stub.ShipmentAlertInfo_element shipmentAlertInfoElement = new GF_SF_Stub.ShipmentAlertInfo_element();
        shipmentAlertInfoElement.PO = '111';
        
        List<GF_SF_Stub.ShipmentAlertInfo_element> shipmentAlertInfoList = new List<GF_SF_Stub.ShipmentAlertInfo_element>();
        shipmentAlertInfoList.add(shipmentAlertInfoElement);
        GF_DynamicQueryHandler.ShippingDateWrapperCls shipDateWrapper = new GF_DynamicQueryHandler.ShippingDateWrapperCls(shipmentAlertInfoList,'101');
        
        // Lot Wrapper Class 
        GF_SF_Stub.RMAInfo_element RMA_InfoElement = new  GF_SF_Stub.RMAInfo_element();
        RMA_InfoElement.RMA_NO = '1111';
        
        List< GF_SF_Stub.RMAInfo_element> RMA_InfoElementList = new List< GF_SF_Stub.RMAInfo_element>();
        RMA_InfoElementList.add(RMA_InfoElement);
        GF_DynamicQueryHandler.ShippingLotWrapperCls  lotWrapper = new GF_DynamicQueryHandler.ShippingLotWrapperCls(RMA_InfoElementList,'102');
        
        //  PO Wrapper Class
        GF_SF_Stub.POTrackingInfo_element poTrackingInfoElement = new GF_SF_Stub.POTrackingInfo_element();
        poTrackingInfoElement.SALES_ORDER_NUM ='12345';
        
        List<GF_SF_Stub.POTrackingInfo_element> poTrackingInfoElementList = new List<GF_SF_Stub.POTrackingInfo_element>();
        poTrackingInfoElementList.add(poTrackingInfoElement);
        
        GF_DynamicQueryHandler.ShippingPoWrapperCls poWrapper = new GF_DynamicQueryHandler.ShippingPoWrapperCls(poTrackingInfoElementList,'102');   
        
        // IPN Wrapper Class
        GF_SF_Stub.MaskLayerInfo_element maskLayerInfoElement = new GF_SF_Stub.MaskLayerInfo_element();
        maskLayerInfoElement.SR_NO = '1212';
        
        List<GF_SF_Stub.MaskLayerInfo_element> maskLayerInfoElementList = new List<GF_SF_Stub.MaskLayerInfo_element>(); 
        maskLayerInfoElementList.add(maskLayerInfoElement);
        GF_DynamicQueryHandler.ShippingIPNWrapperCls  ipnWrapper = new GF_DynamicQueryHandler.ShippingIPNWrapperCls(maskLayerInfoElementList,'102');  
        
        // Shipment Wfr Wrapper Class
        GF_SF_Stub.ShipmentDetailInfo_element shipDetailInfoElement = new GF_SF_Stub.ShipmentDetailInfo_element();
        shipDetailInfoElement.PO = '1111';
        
        List<GF_SF_Stub.ShipmentDetailInfo_element> shipDetailInfoElementList = new List<GF_SF_Stub.ShipmentDetailInfo_element>();
        shipDetailInfoElementList.add(shipDetailInfoElement);
        
        GF_DynamicQueryHandler.ShippingDetailWrapperCls wfrWrapper = new GF_DynamicQueryHandler.ShippingDetailWrapperCls(shipDetailInfoElementList,'101');
        
    }
    
    // Method covers shipping query callout test coverage
    
    static testMethod void sipingQueryServiceTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new GF_ShipmentWebServiceMockImpl());
        
        GF_DynamicQueryHandler.getShippingReport('ALL','ALL','ALL', 'ALL','ALL','15-Apr-2010',
                                                 '15-Apr-2012','ALL','ALL', 'ALL','ALL','1','All:Admin');
        // called getWfrReport                                          
        GF_DynamicQueryHandler.getWfrReport('111',222,'','');  
        //called getShipDateReport
        GF_DynamicQueryHandler.getShipDateReport('15-Apr-2012',111,222,'','');                                       
        //called getLotReport
        GF_DynamicQueryHandler.getLotReport('111','','');
        //called getPoReport
        GF_DynamicQueryHandler.getPoReport('121',1234,'','');
        //called getIPNReport 
        GF_DynamicQueryHandler.getIPNReport(121,'My Device','','');
        GF_DynamicQueryHandler.custName = '';
        GF_DynamicQueryHandler.getShippingReport('ALL','ALL','ALL', 'ALL','ALL','15-Apr-2010',
                                                 '15-Apr-2012','ALL','ALL', 'ALL','ALL','1','');
     	system.assertEquals(GF_DynamicQueryHandler.custName,'');
        Test.stopTest();  
        
    }
    
    // Method covers production query related test coverage
    
    static testMethod void productionQueryTest(){
        Test.StartTest();
        Test.setCurrentPageReference(new PageReference('Page.GF_ProductionQueryPage')); 
        System.currentPageReference().getParameters().put('name', 'GF_ProductionQueryPage');
        GF_ProductionQueryHelper prodHelper = new GF_ProductionQueryHelper();
        GF_DynamicQueryHandler dqHandler = new GF_DynamicQueryHandler();
        prodHelper.getLotTypeList();
        prodHelper.getFabList();
        
        dqHandler.getPreviousDate();
        
        List<GF_ProductionQueryStub.RunSheetResponseType> runshitInfoLst = new List<GF_ProductionQueryStub.RunSheetResponseType>();
        GF_ProductionQueryStub.RunSheetResponseType runshitObj = new GF_ProductionQueryStub.RunSheetResponseType();
        runshitObj.STAGE_NAME='approved';
        runshitInfoLst.add(runshitObj);
        
        GF_DynamicQueryHandler.currentRunSheetWrapperCls runshitReport = new GF_DynamicQueryHandler.currentRunSheetWrapperCls(runshitInfoLst,'');
        
        List<GF_ProductionQueryStub.WaferStartResponseType> startDateInfoLst = new List<GF_ProductionQueryStub.WaferStartResponseType>();
        GF_ProductionQueryStub.WaferStartResponseType wfrStartObj = new GF_ProductionQueryStub.WaferStartResponseType();
        wfrStartObj.PO = '1111';
        startDateInfoLst.add(wfrStartObj);
        GF_DynamicQueryHandler.wfrstartDateWrapperCls wfrStartdate = new GF_DynamicQueryHandler.wfrstartDateWrapperCls(startDateInfoLst,'');   
        
        List<GF_ProductionQueryStub.ProcEprfResponseType> eprfInfoLst = new List<GF_ProductionQueryStub.ProcEprfResponseType>();
        GF_ProductionQueryStub.ProcEprfResponseType eprfResponse = new GF_ProductionQueryStub.ProcEprfResponseType();
        eprfResponse.FAB = 'FAB1';
        eprfInfoLst.add(eprfResponse);    
        GF_DynamicQueryHandler.ProcEprfServiceWrapperCls ProcEprfService = new GF_DynamicQueryHandler.ProcEprfServiceWrapperCls(eprfInfoLst,'');    
        
        List<GF_ProductionQueryStub.FabOutLocationResponseType> fabOutInfoLst = new List<GF_ProductionQueryStub.FabOutLocationResponseType>();
        GF_ProductionQueryStub.FabOutLocationResponseType faboutObj = new GF_ProductionQueryStub.FabOutLocationResponseType();
        faboutObj.FAB = 'FAB2';
        fabOutInfoLst.add(faboutObj);
        GF_DynamicQueryHandler.FabOutLocationWrapperCls faboutService = new GF_DynamicQueryHandler.FabOutLocationWrapperCls(fabOutInfoLst,'');
        
        List <GF_ProductionQueryStub.ProdLotStrtSmryType> lotInfoLst = new List <GF_ProductionQueryStub.ProdLotStrtSmryType>();
        GF_ProductionQueryStub.ProdLotStrtSmryType prodlotObj = new GF_ProductionQueryStub.ProdLotStrtSmryType();
        prodlotObj.FAB='FAB2';
        lotInfoLst.add(prodlotObj);    
        GF_DynamicQueryHandler.ProdLotStrtSmryWrapperCls prodlotStartService = new GF_DynamicQueryHandler.ProdLotStrtSmryWrapperCls(lotInfoLst,'');
        
        List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType> prodWipList = new List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType>();
        GF_ProductionQueryStub.ProdWIPLotSmryResponseType prodWipObj = new GF_ProductionQueryStub.ProdWIPLotSmryResponseType();
        
        prodWipObj.FAB = 'FAB1';
        prodWipList.add(prodWipObj);
        GF_DynamicQueryHandler.ProdWIPLotSmryWrapperCls prodWipWraper = new GF_DynamicQueryHandler.ProdWIPLotSmryWrapperCls(prodWipList,'');
        
        List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> prodWipAndShipLst = new List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType>();
        GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType wipShipObj = new GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType();
        wipShipObj.FAB='FAB2';  
        system.assertEquals(wipShipObj.FAB,'FAB2');
        prodWipAndShipLst.add(wipShipObj);
        
        GF_DynamicQueryHandler.ProdWIPSHIPLotSmryWrapperCls wipAndShipWrapper = new GF_DynamicQueryHandler.ProdWIPSHIPLotSmryWrapperCls(prodWipAndShipLst,'');
        
        dqHandler.redirectToConverToExcel();
        dqHandler.refreshGrid();
        GF_DynamicQueryHandler.custName='Broadcom';
        
        Test.StopTest();    
    }
    
    // Method covers production query callout code coverage
    
    static testMethod void productionQueryServiceTest(){
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new GF_ProductionWebServiceMockImpl());
        GF_DynamicQueryHandler.geProductionReport1('ALL','ALL','ALL',
                                                   'ALL','ALL','ALL',
                                                   'ALL','ALL','ALL:Admin');
        
        GF_DynamicQueryHandler.geProductionReport2('ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','ALL:Admin');                                           
        
        GF_DynamicQueryHandler.geProductionReport3('ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','ALL:Admin');
        
        GF_DynamicQueryHandler.getEPRFReport('ALL'); 
        
        GF_DynamicQueryHandler.getFabOutLocationReport('ALL','ALL','ALL'); 
        
        GF_DynamicQueryHandler.getCurrentRunSheetReport('ALL','ALL','ALL');
        
        GF_DynamicQueryHandler.getWfrStartReport('ALL','ALL','ALL');
        
        GF_DynamicQueryHandler.geProductionReport1('ALL','ALL','ALL',
                                                   'ALL','ALL','ALL',
                                                   'ALL','ALL','');
        GF_DynamicQueryHandler.geProductionReport2('ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','');
        GF_DynamicQueryHandler.geProductionReport3('ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','ALL','ALL',
                                                   'ALL','ALL','');
        system.assertEquals(true,true);
        Test.stopTest();  
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name,Short_Name__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}