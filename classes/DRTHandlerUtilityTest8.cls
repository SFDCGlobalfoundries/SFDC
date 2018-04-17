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
private class DRTHandlerUtilityTest8 {

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
   fetchChipsForDeletion()
 */  
    @isTest
    public static void fetchChipsForDeletionTest(){
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__c drt=drtList[0];
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, oppr.Id,opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        Chip_Detail__c chip_detail = SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        
        list<DRTHandlerUtility.ChipWrapper> lstDRTChipWrapper = new list<DRTHandlerUtility.ChipWrapper>();
        DRTHandlerUtility.ChipWrapper objChipWrapper;
        for(PRIME_DRT_Chip_Association__c chipObj : pdcaList){
            objChipWrapper = new DRTHandlerUtility.ChipWrapper(chipObj.Mask_Set_Title__c,chipObj.Name);
            lstDRTChipWrapper.add(objChipWrapper);
        }
        
        list<string> chipsForDeletion1 = DRTHandlerUtility.fetchChipsForDeletion(drt.Name, lstDRTChipWrapper);
        system.assertEquals(chipsForDeletion1.size(), 0);
        list<string> chipsForDeletion2 = DRTHandlerUtility.fetchChipsForDeletion('', lstDRTChipWrapper);
        system.assertEquals(chipsForDeletion1.size(), 0);
        test.stopTest();
    }
    
    /*
       This test method tests the below functionality of the class DRTHandlerUtility
       handleErrorOnPLMTecnService()
    */ 
    @isTest
    public static void handleErrorOnPLMTecnServiceTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Exception ex;
        try{
            acc.Id='123';
            update acc;
        }catch(Exception e){
            ex=e;   
        }
        DRTHandlerUtility.handleErrorOnPLMTecnService(ex,new list<String>{'Account'},new list<String>{'Account'},'Test Mail');    
        
    }   
    
    
    /*
       This test method tests the below functionality of the class DRTHandlerUtility
       handleErrorOnPTRF_AUPD()
    */ 
    @isTest
    public static void handleErrorOnPTRF_AUPDTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Exception ex;
        try{
            acc.Id='123';
            update acc;
        }catch(Exception e){
            ex=e;   
        }
        DRTHandlerUtility.handleErrorOnPTRF_AUPD(ex,new set<String>{'Account'},'ptrf','Test Mail');     
    }
    
     /*
    This test method tests the below functionality of the class DRTHandlerUtility isGFEmployee()
   */     
   @isTest
   public static void testIsGFEmployee(){
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
            boolean b = DRTHandlerUtility.isGFEmployee(userObj.ID);
            system.assert(b==false);
        }
        test.stopTest();
    }
}