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
@isTest
private class DRTHandlerUtilityTest4 {

    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
    @testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   validateDRTTableData()
   validateMaskLayerData()
   validateMaskLayerContentData()
    */ 
    @isTest
    public static void validateDRTTableDataTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        
        DRT__c drt=drtList[0];
        
        drt.Customer_Name__c=acc.Id;
        drt.Tech_Geo__c = '0.01UM';
        drt.Name='MYMST_PRIME_DRT_035.001';
        
        update drt;
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS2(pdlaList,pdcaList);
        
        test.startTest();
        //positive test
        DRTHandlerUtility.DRTErrorDetails ed1=new DRTHandlerUtility().validateDRTTableData(drt,pdcaList,pdlaList,pdcls);
        system.assertNotEquals(ed1, null);
        //negative test - duplicate chip name
        String chip1=pdcaList[0].name;
        String chip2=pdcaList[1].name;
        pdcaList[0].name=pdcaList[1].name;
        DRTHandlerUtility.DRTErrorDetails ed2=new DRTHandlerUtility().validateDRTTableData(drt,pdcaList,pdlaList,pdcls);
        system.assertNotEquals(ed2, null);
        // Duplicate combination of mask layer
        
        pdlaList[0].name='12';
        pdlaList[0].Retrofit_Mask_Rev__c='TT';
        pdlaList[0].Retrofit_ROM_Code__c='TT123';
        
        pdlaList[1].name='12';
        pdlaList[1].Retrofit_Mask_Rev__c='TT';
        pdlaList[1].Retrofit_ROM_Code__c='TT123';
        
        DRTHandlerUtility.DRTErrorDetails ed3=new DRTHandlerUtility().validateDRTTableData(drt,pdcaList,pdlaList,pdcls);
        system.assertNotEquals(ed3, null);
        // DRT cannot be activated if there are 'Shipped' mask layers in MRS
        MRS__c mrsObj = SwiftDataUtilityTest.createMRS(mstList[0].Id);
        
        MRS_Layer_Association__c mrsLA = new MRS_Layer_Association__c(Name='12',MRS__c = mrsObj.Id,Mask_Layer_Rev__c='TT',
                                                                     ROM_Code__c='TT123',Layer_Status__c='Shipped',Tech_Geo__c = '0.01UM');
        
        insert mrsLA;
        
        // DRT cannot be activated if there are DRTs present with same combination
        DRTHandlerUtility.ErrorDetails edMRS = new DRTHandlerUtility().validateMaskLayerData(pdlaList,drt);
        
        DRT__c dupDRT = new DRT__c(Name='MYMST_PRIME_DRT_075.001', Customer_Name__c = acc.Id,Mask_Set_Title__c = mstList[0].Id, Type__c = 'PRIME', Status__c='Active',Tech_Geo__c = '0.01UM');
        insert dupDRT;        
        list<Prime_DRT_Layer_Association__c> dupPDLALst = new  list<Prime_DRT_Layer_Association__c>();
        Prime_DRT_Layer_Association__c dupPdla1 = new Prime_DRT_Layer_Association__c(DRT__c = dupDRT.Id, Name='12',Retrofit_Mask_Rev__c='TT',Retrofit_ROM_Code__c='TT123');
        insert dupPdla1;
        dupPDLALst.add(dupPdla1);
        
        DRTHandlerUtility.ErrorDetails ed4=new DRTHandlerUtility().validateMaskLayerData(dupPDLALst,dupDRT);
        system.assertNotEquals(ed4, null);
        pdcls[0].Mask_Layer_Rev__c=null;
        pdcls[0].ROM_Code__c='RR4567';
        DRTHandlerUtility.ErrorDetails ed5=new DRTHandlerUtility().validateMaskLayerContentData(pdcls,drt);
        system.assertNotEquals(ed5, null);
        test.stopTest();
        
    }
    
     /*
   This test method tests the below functionality of the class DRTHandlerUtility
   validateFrameTableData()
    */ 
    @isTest
    public static void validateFrameTableDataTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(2);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(2,mstList[0]);
        
        DRT__c drt1=drtList[0];
        
        drt1.Customer_Name__c=acc.Id;
        drt1.Tech_Geo__c = '0.01UM';
        drt1.Name='MYMST_PRIME_DRT1_035.001';
        drt1.Mask_Set_Title__c=mstList[0].Id;
        update drt1;
        
        DRT__c drt2=drtList[1];
        
        drt2.Customer_Name__c=acc.Id;
        drt2.Tech_Geo__c = '0.01UM';
        drt2.Name='MYMST_PRIME_DRT2_035.001';
        drt2.Mask_Set_Title__c=mstList[1].Id;
        update drt2;
        
        
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt1);
        fdaList[0].Mask_Set_Title__c=null;
        fdaList[0].Mask_Layer_No__c='';
        fdaList[0].Retrofit_Mask_Rev__c=''; 
        fdaList[0].Mask_Rev__c='';
        
       test.startTest();
       DRTHandlerUtility.ErrorDetails ed1=new DRTHandlerUtility().validateFrameTableData(drt1,fdaList);
       system.assertNotEquals(ed1, null);
       DRTHandlerUtility.ErrorDetails ed2=new DRTHandlerUtility().validateFrameTableData(drt2,fdaList);
       system.assertNotEquals(ed2, null);
       
       fdaList[0].Mask_Set_Title__c=mstList[0].Id;
       fdaList[0].Mask_Layer_No__c='10';
       fdaList[0].Retrofit_Mask_Rev__c='AA'; 
       fdaList[0].Mask_Rev__c='123';
       
       update fdaList[0];
       // DRT cannot be activated if there are 'Shipped' mask layers in MRS
       MRS__c mrsObj = SwiftDataUtilityTest.createMRS(mstList[0].Id);
            
       MRS_Layer_Association__c mrsLA = new MRS_Layer_Association__c(Name='10',MRS__c = mrsObj.Id,Mask_Layer_Rev__c='AA',
                                                                         ROM_Code__c='123',Layer_Status__c='Shipped',Tech_Geo__c = '0.01UM');
            
       insert mrsLA;
       DRTHandlerUtility.ErrorDetails edMRS = new DRTHandlerUtility().validateFrameTableData(drt1,fdaList); 
            
       DRT__c dupDRT = new DRT__c(Name='MYMST_FRAME_DRT_075.001', Customer_Name__c = acc.Id,Mask_Set_Title__c = mstList[0].Id, Type__c = 'FRAME', Status__c='Active',Tech_Geo__c = '0.01UM');
       insert dupDRT;        
       list<Frame_DRT_Association__c> dupFDALst = new  list<Frame_DRT_Association__c>();
       Frame_DRT_Association__c dupFDA1 = new Frame_DRT_Association__c(DRT__c = dupDRT.Id, Mask_Layer_No__c='10',Retrofit_Mask_Rev__c='AA',Retrofit_ROM_Code__c=fdaList[0].Retrofit_ROM_Code__c);
       insert dupFDA1;
       dupFDALst.add(dupFDA1);
           
       DRTHandlerUtility.ErrorDetails ed4=new DRTHandlerUtility().validateFrameTableData(dupDRT,dupFDALst);
       system.assertNotEquals(ed4, null);   
       DRTHandlerUtility.AuditTrail objAuditTrail = new DRTHandlerUtility.AuditTrail(string.valueOf(system.today()),'test','test','test','test','test');  
       test.stopTest();
   }
    
       /*
   This test method tests the below functionality of the class DRTHandlerUtility
   AuditTrail()
    */ 
    @isTest
    public static void fetchDRTAuditTrailTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(2,mstList[0]);
        
        DRT__c drt=drtList[0];
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT_035.001';
        update drt;
        
        system.assertEquals(drt.Name,'MYMST_PRIME_DRT_035.001');
        
        DRT__c drt2=new DRT__c();
        drt2.Copied_From__c=drt.Id;
        
        DRT__c drt3=new DRT__c();
        drt2.Old_Rev_DRT__c=drt.Id;
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        pdlaList[0].name='10';
        pdlaList[0].isCreatedLater__c = true;
        pdlaList[1].name='20';
        pdlaList[1].IsSoftDeleted__c = true;
        
        update pdlaList;
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        pdcaList[0].name='tt123';
        pdcaList[0].isCreatedLater__c = true;
        
        pdcaList[1].name='tt456';
        pdcaList[1].IsSoftDeleted__c = true;
        
        update pdcaList;
        
        list<DRT__History> lstDRTHistory = DRTHandlerUtility.fetchDRTHistory(drt.Id);
        list<PRIME_DRT_Chip_Association__History> lstPrimeDRTChipAssocHistory = DRTHandlerUtility.fetchPrimeDRTChipAssocHistory(drt.Id);
        list<PRIME_DRT_Layer_Association__History> lstPrimeDRTLayerAssocHistory = DRTHandlerUtility.fetchPrimeDRTLayerAssocHistory(drt.Id);
        
        DRT__History drt_his1 = new DRT__History();
        drt_his1.Field = 'created';
        drt_his1.Parent = drt2; 
        
        DRT__History drt_his2 = new DRT__History();
        drt_his2.Field = 'created';
        drt_his2.Parent = drt3; 
        
        DRT__History drt_his4 = new DRT__History();
        drt_his4.Field = 'name';
        drt_his4.Parent = drt; 
        
        lstDRTHistory.clear();
        lstDRTHistory.add(drt_his1);
        lstDRTHistory.add(drt_his2);
        lstDRTHistory.add(drt_his4);
        
        PRIME_DRT_Chip_Association__History pdca_history=new PRIME_DRT_Chip_Association__History();
        pdca_history.Field ='created';
        pdca_history.ParentId = pdcaList[0].Id;
        pdca_history.Parent=pdcaList[0];
        
        PRIME_DRT_Chip_Association__History pdca_history2=new PRIME_DRT_Chip_Association__History();
        pdca_history2.Field ='IsSoftDeleted__c';
        pdca_history2.ParentId = pdcaList[1].Id;
        pdca_history2.Parent=pdcaList[1];
        
        PRIME_DRT_Chip_Association__History pdca_history3=new PRIME_DRT_Chip_Association__History();
        pdca_history3.Field ='Name';
        pdca_history3.ParentId = pdcaList[1].Id;
        pdca_history3.Parent=pdcaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history1 = new PRIME_DRT_Layer_Association__History();
        pdla_history1.Field='created';
        pdla_history1.Parent=pdlaList[0];
        
        PRIME_DRT_Layer_Association__History pdla_history2 = new PRIME_DRT_Layer_Association__History();
        pdla_history2.Field='IsSoftDeleted__c';
        pdla_history2.Parent=pdlaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history3 = new PRIME_DRT_Layer_Association__History();
        pdla_history3.Field='Name';
        pdla_history3.Parent=pdlaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history4 = new PRIME_DRT_Layer_Association__History();
        pdla_history4.Field='Retrofit_Mask_Rev__c';
        pdla_history4.Parent=pdlaList[1];
        
        PRIME_DRT_Layer_Association__History pdla_history5 = new PRIME_DRT_Layer_Association__History();
        pdla_history5.Field='Retrofit_ROM_Code__c';
        pdla_history5.Parent=pdlaList[1];
        
        test.startTest();
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history},new list<PRIME_DRT_Layer_Association__History>{pdla_history1});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history2},new list<PRIME_DRT_Layer_Association__History>{pdla_history2});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history3},new list<PRIME_DRT_Layer_Association__History>{pdla_history3});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history3},new list<PRIME_DRT_Layer_Association__History>{pdla_history4});
        DRTHandlerUtility.fetchDRTAuditTrail(drt,lstDRTHistory,new list<PRIME_DRT_Chip_Association__History>{pdca_history3},new list<PRIME_DRT_Layer_Association__History>{pdla_history5});
        // jun17
        DRTHandlerUtility.AuditTrail objAuditTrail = new DRTHandlerUtility.AuditTrail(string.valueOf(system.today()),'test','test','test','test','test');
        test.stopTest();
    }
    
        /*
       This test method tests the below functionality of the class DRTHandlerUtility fetchCustomerName() For Customer User
     */     
    @isTest
    public static void fetchCustomerNameTestCustomer(){
        
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
        User userObj = new User();
        
        Contact conobj=new Contact();

        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acc.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
                                  
        insert conobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            userObj.Alias = 'Shyam';
            userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            //userObj.userRoleId = usrRole.Id;
                        
            insert userObj;
        }
        
        test.startTest();
        System.runAs(userObj) {
            list<Account> accountList=new DRTHandlerUtility().fetchCustomerName();
            system.assert(accountList != null);
        }
        test.stopTest();
    }
    
   
    
}