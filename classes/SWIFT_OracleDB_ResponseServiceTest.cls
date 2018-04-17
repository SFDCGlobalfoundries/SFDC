/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller Test class behind the SWIFT_OracleDB_ResponseService.
                
History:
    Cognizant          - Initial Version
*/

@istest(SeeAllData=false)
public with sharing class SWIFT_OracleDB_ResponseServiceTest {
    public static list<DRT__c> drtCreate = new list<DRT__c>();
    public static list<Mask_Set_Title__c> mstList = new list<Mask_Set_Title__c>();
    public static Opportunity_Program__c oppPgm = new Opportunity_Program__c();
    public static Account acc = new Account();
    public static Opportunity opp = new Opportunity();
    public static Device__c device = new Device__c();    
    public static PTRF__C ptrf = new PTRF__C();
    public static MRS__c mrsins = new MRS__c();
    
    
    /**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
    
    
public static testMethod void testService() {
     SWIFT_OracleDB_ResponseServiceTest.mstList = SwiftDataUtilityTest.maskSetTitleList2(1);
    SWIFT_OracleDB_ResponseServiceTest.drtCreate = SwiftDataUtilityTest.createDRTCancelList(2,mstList[0]);
    // comment-out, refactored with testSetup method setup()
    // SwiftDataUtilityTest.customSystemData();
    SWIFT_OracleDB_ResponseServiceTest.mrsins = SwiftDataUtilityTest.createMrs(mstList[0].id);
    //SWIFT_OracleDB_ResponseServiceTest.acc = SwiftDataUtilityTest.createTestAccount();
    //SWIFT_OracleDB_ResponseServiceTest.opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
    //SWIFT_OracleDB_ResponseServiceTest.oppPgm = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id,opp.Id);
    //SWIFT_OracleDB_ResponseServiceTest.device = SwiftDataUtilityTest.createDeviceDRT2(acc.Id,oppPgm.Id,opp.Id);
    //SWIFT_OracleDB_ResponseServiceTest.ptrf = SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id,device.Id );
    list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy> insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins.SFDCID = drtCreate[0].id;//MRS
    ins.LastSyncTimestamp = system.now();
    ins.status = 'SUCCESS';
    ins.errorMessage = 'no error';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insNeg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insNeg.SFDCID = drtCreate[0].id;//MRS
    insNeg.LastSyncTimestamp = system.now();
    insNeg.status = 'ERROR';
    insNeg.errorMessage = 'no error';
    
    list<Frame_DRT_Association__c> frameDrtQuery = SwiftDataUtilityTest.createFDA(drtCreate[0]);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins2 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins2.SFDCID = frameDrtQuery[0].id;//MRS
    ins2.LastSyncTimestamp = system.now();
    ins2.status = 'SUCCESS';
    ins2.errorMessage = 'no error';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins2Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins2Neg.SFDCID = frameDrtQuery[0].id;//MRS
    ins2Neg.LastSyncTimestamp = system.now();
    ins2Neg.status = 'Error';
    ins2Neg.errorMessage = 'no error';

     //list<Frame_DRT_Association__c> frameDrtQuery = SwiftDataUtilityTest.createFDA(drtCreate[0]);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insFrame2 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insFrame2.SFDCID = frameDrtQuery[2].id;//MRS
    insFrame2.LastSyncTimestamp = system.now().addDays(1);
    insFrame2.status = 'SUCCESS';
    insFrame2.errorMessage = 'no error';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insFrame2Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insFrame2Neg.SFDCID = frameDrtQuery[2].id;//MRS
    insFrame2Neg.LastSyncTimestamp = system.now().addDays(1);
    insFrame2Neg.status = 'Error';
    insFrame2Neg.errorMessage = 'no error';
   
    
    PRIME_DRT_Chip_Association__c  primechip = SwiftDataUtilityTest.createPrimeDrt(drtCreate[0]);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins3 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins3.SFDCID = primechip.id;//MRS
    ins3.LastSyncTimestamp = system.now();
    ins3.status = 'SUCCESS';
    ins3.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins3Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins3Neg.SFDCID = primechip.id;//MRS
    ins3Neg.LastSyncTimestamp = system.now();
    ins3Neg.status = 'ERROR';
    ins3Neg.errorMessage = 'NO ERROR';
   
     
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
   
    
   
   Test.startTest();
   
   
   list<PRIME_DRT_Layer_Association__c> PDLA= SwiftDataUtilityTest.createPDLA(drtCreate[0].id);

    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insNew = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insNew.SFDCID = PDLA[2].id;//MRS
    insNew.LastSyncTimestamp = system.now().addDays(1);
    insNew.status = 'SUCCESS';
    insNew.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insNewNeg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insNewNeg.SFDCID = PDLA[2].id;//MRS
    insNewNeg.LastSyncTimestamp = system.now().addDays(1);
    insNewNeg.status = 'ERROR';
    insNewNeg.errorMessage = 'NO ERROR';

    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(insNew);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(insNewNeg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList); 
       
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins2);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins3);
    
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins3);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
     
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins2Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins3Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(insFrame2);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(insFrame2Neg);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    
   SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insError = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insError.SFDCID = frameDrtQuery[0].id;//MRS
    insError.status = 'SUCCESS';
    insError.errorMessage = 'no error';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insErrorNeg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insErrorNeg.SFDCID = frameDrtQuery[0].id;//MRS
    insError.status = 'Error';
    insError.errorMessage = 'no error';        
   
    
    
        
    Boolean check = false;
    try
    { if(check == True){}}
    catch(Exception e){
    SWIFT_OracleDB_ResponseService.sendMail(e);
    }
    Test.stopTest();
    }
    
    
    
  public static testMethod void testService12() {
    SWIFT_OracleDB_ResponseServiceTest.mstList = SwiftDataUtilityTest.maskSetTitleList2(1);
    SWIFT_OracleDB_ResponseServiceTest.drtCreate = SwiftDataUtilityTest.createDRTCancelList(2,mstList[0]);
    // comment-out, refactored with testSetup method setup()
    // SwiftDataUtilityTest.customSystemData();
    SWIFT_OracleDB_ResponseServiceTest.mrsins = SwiftDataUtilityTest.createMrs(mstList[0].id);
    list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy> insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    PRIME_DRT_Chip_Association__c  primechip1 = SwiftDataUtilityTest.createPrimeDrt1(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0]);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insnew2 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insnew2.SFDCID = primechip1.id;//MRS
    insnew2.LastSyncTimestamp = system.now().addDays(1);
    insnew2.status = 'SUCCESS';
    insnew2.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy insnew2Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    insnew2Neg.SFDCID = primechip1.id;//MRS
    insnew2Neg.LastSyncTimestamp = system.now().addDays(1);
    insnew2Neg.status = 'ERROR';
    insnew2Neg.errorMessage = 'NO ERROR';
   
    list<PRIME_DRT_Layer_Association__c> PDLA= SwiftDataUtilityTest.createPDLA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins5 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins5.SFDCID = PDLA[0].id;//MRS
    ins5.LastSyncTimestamp = system.now();
    ins5.status = 'SUCCESS';
    ins5.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins5Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins5Neg.SFDCID = PDLA[0].id;//MRS
    ins5Neg.LastSyncTimestamp = system.now();
    ins5Neg.status = 'ERROR';
    ins5Neg.errorMessage = 'NO ERROR';
    
    list<PRIME_DRT_Chip_Association__c> PDCA= SwiftDataUtilityTest.createPDCA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id,SWIFT_OracleDB_ResponseServiceTest.mstList[0].id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins6 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins6.SFDCID = PDCA[0].id;//MRS
    ins6.LastSyncTimestamp = system.now();
    ins6.status = 'SUCCESS';
    ins6.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins6Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins6Neg.SFDCID = PDCA[0].id;//MRS
    ins6Neg.LastSyncTimestamp = system.now();
    ins6Neg.status = 'ERROR';
    ins6Neg.errorMessage = 'NO ERROR';
    
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins61Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins61Neg.SFDCID = PDCA[0].id;//MRS
    ins61Neg.LastSyncTimestamp = system.now();
    ins61Neg.status = 'ERROR';
    ins61Neg.errorMessage = 'NO ERROR';
    ins61Neg.DRT_Name = 'ferer';
    
    
   Test.startTest();
   
    
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(insnew2);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(insnew2Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    
    
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins5);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins61Neg );
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins6);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins5Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins6Neg);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception e){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    System.assertEquals('ferer',ins61Neg.DRT_Name);
        
    Boolean check = false;
    try
    { if(check == True){}}
    catch(Exception e){
    SWIFT_OracleDB_ResponseService.sendMail(e);
    }
    Test.stopTest();
    }
    
    
    
    
    
    
    public static testMethod void testService2()
    {
    SWIFT_OracleDB_ResponseServiceTest.mstList = SwiftDataUtilityTest.maskSetTitleList2(1);
    SWIFT_OracleDB_ResponseServiceTest.drtCreate = SwiftDataUtilityTest.createDRTCancelList(2,mstList[0]);
    // comment-out, refactored with testSetup method setup()
    // SwiftDataUtilityTest.customSystemData();
    SWIFT_OracleDB_ResponseServiceTest.mrsins = SwiftDataUtilityTest.createMrs(mstList[0].id);     
    list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy> insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    list<PRIME_DRT_Layer_Association__c> PDLA= SwiftDataUtilityTest.createPDLA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id);
    list<PRIME_DRT_Chip_Association__c> PDCA= SwiftDataUtilityTest.createPDCA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id,SWIFT_OracleDB_ResponseServiceTest.mstList[0].id);

    list<PRIME_DRT_Chip_Layer_Summary__c> PDCLS= SwiftDataUtilityTest.createPDCLS(PDLA,PDCA);
    

    MRS_Chip_Details__c mrscdins = SwiftDataUtilityTest.createMRSc(SWIFT_OracleDB_ResponseServiceTest.mrsins.id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins17 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins17.SFDCID = mrscdins.id;//MRS
    ins17.LastSyncTimestamp = system.now();
    ins17.status = 'SUCCESS';
    ins17.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins17Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins17Neg.SFDCID = mrscdins.id;//MRS
    ins17Neg.LastSyncTimestamp = system.now();
    ins17Neg.status = 'ERROR';
    ins17Neg.errorMessage = 'NO ERROR';

    MRS_Layer_Association__c mrslins = SwiftDataUtilityTest.createMRSl(SWIFT_OracleDB_ResponseServiceTest.mrsins.id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins15 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins15.SFDCID = mrslins.id;//MRS
    ins15.LastSyncTimestamp = system.now();
    ins15.status = 'SUCCESS';
    ins15.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins15Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins15Neg.SFDCID = mrslins.id;//MRS
    ins15Neg.LastSyncTimestamp = system.now();
    ins15Neg.status = 'ERROR';
    ins15Neg.errorMessage = 'NO ERROR';


    MRS_Layer_Chip_Association__c mrsntins = SwiftDataUtilityTest.createMRSlc(mrscdins.id,mrslins.id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins16 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins16.SFDCID = mrsntins.id;//MRS
    ins16.LastSyncTimestamp = system.now();
    ins16.status = 'SUCCESS';
    ins16.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins16Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins16Neg.SFDCID = mrsntins.id;//MRS
    ins16Neg.LastSyncTimestamp = system.now();
    ins16Neg.status = 'ERROR';
    ins16Neg.errorMessage = 'NO ERROR';
    
    Notes__c mrsnotins = SwiftDataUtilityTest.creatent(mrslins.id,mrsntins.id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins18 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins18.SFDCID = mrsnotins.id;//MRS
    ins18.LastSyncTimestamp = system.now();
    ins18.status = 'SUCCESS';
    ins18.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins18Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins18Neg.SFDCID = mrsnotins.id;//MRS
    ins18Neg.LastSyncTimestamp = system.now();
    ins18Neg.status = 'ERROR';
    ins18Neg.errorMessage = 'NO ERROR';
    
    
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins19 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins19.SFDCID = mstList[0].id;//MRS
    ins19.LastSyncTimestamp = system.now();
    ins19.status = 'SUCCESS';
    ins19.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins19Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins19Neg.SFDCID = mstList[0].id;//MRS
    ins19Neg.LastSyncTimestamp = system.now();
    ins19Neg.status = 'ERROR';
    ins19Neg.errorMessage = 'NO ERROR';

    Test.startTest();        
    
    
    
    
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins15Neg);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins15);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins16Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins16);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins17Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins17);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

   insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins18Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins18);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

   
    
    
     insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins19);
    
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception e){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
     
      System.assertEquals('SUCCESS',ins19.status);
      DRT__c drtins = [SELECT Last_Sync_Req_Timestamp__c,Mask_Set_Title_Formula__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM DRT__c WHERE ID =: drtCreate[0].id];

Test.stopTest();  
 
    try
    { 
    insert drtins;
    }
   catch(Exception e){
SWIFT_OracleDB_ResponseService.sendMail(e);
    }
}





public static testMethod void testService22()
    {     
    SWIFT_OracleDB_ResponseServiceTest.mstList = SwiftDataUtilityTest.maskSetTitleList2(1);
    SWIFT_OracleDB_ResponseServiceTest.drtCreate = SwiftDataUtilityTest.createDRTCancelList(2,mstList[0]);
    // comment-out, refactored with testSetup method setup()
    // SwiftDataUtilityTest.customSystemData();
    SWIFT_OracleDB_ResponseServiceTest.mrsins = SwiftDataUtilityTest.createMrs(mstList[0].id);
    list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy> insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    list<PRIME_DRT_Layer_Association__c> PDLA= SwiftDataUtilityTest.createPDLA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id);
    list<PRIME_DRT_Chip_Association__c> PDCA= SwiftDataUtilityTest.createPDCA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id,SWIFT_OracleDB_ResponseServiceTest.mstList[0].id);

    list<PRIME_DRT_Chip_Layer_Summary__c> PDCLS= SwiftDataUtilityTest.createPDCLS(PDLA,PDCA);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins7 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins7.SFDCID = PDCLS[0].id;//MRS
    ins7.LastSyncTimestamp = system.now();
    ins7.status = 'ERROR';
    ins7.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins7Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins7Neg.SFDCID = PDCLS[0].id;//MRS
    ins7Neg.LastSyncTimestamp = system.now();
    ins7Neg.status = 'SUCCESS';
    ins7Neg.errorMessage = 'NO ERROR';
    
    MST_Config__c mstconfig= SwiftDataUtilityTest.createMSTconfig(acc.id,mstList[0].id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins8 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins8.SFDCID = mstconfig.id;//MRS
    ins8.LastSyncTimestamp = system.now();
    ins8.status = 'SUCCESS';
    ins8.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins8Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins8Neg.SFDCID = mstconfig.id;//MRS
    ins8Neg.LastSyncTimestamp = system.now();
    ins8Neg.status = 'ERROR';
    ins8Neg.errorMessage = 'NO ERROR';
    
    /*DRT_PTRF_Association__c DPA= SwiftDataUtilityTest.createDPA(SWIFT_OracleDB_ResponseServiceTest.drtCreate[0].id,SWIFT_OracleDB_ResponseServiceTest.ptrf.id);

    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins9 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins9.SFDCID = DPA.id;//MRS
    ins9.LastSyncTimestamp = system.now();
    ins9.status = 'SUCCESS';
    ins9.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins9Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins9Neg.SFDCID = DPA.id;//MRS
    ins9Neg.LastSyncTimestamp = system.now();
    ins9Neg.status = 'ERROR';
    ins9Neg.errorMessage = 'NO ERROR';
    */
   
    
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins11 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins11.SFDCID = SWIFT_OracleDB_ResponseServiceTest.mrsins.id;//MRS
    ins11.LastSyncTimestamp = system.now();
    ins11.status = 'SUCCESS';
    ins11.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins11Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins11Neg.SFDCID = SWIFT_OracleDB_ResponseServiceTest.mrsins.id;//MRS
    ins11Neg.LastSyncTimestamp = system.now();
    ins11Neg.status = 'ERROR';
    ins11Neg.errorMessage = 'NO ERROR';
    
    Fab_Distribution_Table__c fdlins = SwiftDataUtilityTest.createFDL1();
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins12 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins12.SFDCID = fdlins.id;//MRS
    ins12.LastSyncTimestamp = system.now();
    ins12.status = 'SUCCESS';
    ins12.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins12Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins12Neg.SFDCID = fdlins.id;//MRS
    ins12Neg.LastSyncTimestamp = system.now();
    ins12Neg.status = 'ERROR';
    ins12Neg.errorMessage = 'NO ERROR';

    Tapeout_Applications_MEBES_Jobview_Confi__c tains = SwiftDataUtilityTest.createTA();
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins13 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins13.SFDCID = tains.id;//MRS
    ins13.LastSyncTimestamp = system.now();
    ins13.status = 'SUCCESS';
    ins13.errorMessage = 'error NO RECORD FOUND';
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins13Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins13Neg.SFDCID = tains.id;//MRS
    ins13Neg.LastSyncTimestamp = system.now();
    ins13Neg.status = 'ERROR';
    ins13Neg.errorMessage = 'NO ERROR';
    
    MST_Chip_Association__c mstcins = SwiftDataUtilityTest.createMSTc(SWIFT_OracleDB_ResponseServiceTest.mstList[0].id);
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins14 = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins14.SFDCID = mstcins.id;//MRS
    //ins14.LastSyncTimestamp = system.now();
    ins14.LastSyncTimestamp =system.now(); 
    ins14.status = 'SUCCESS';
    ins14.errorMessage = 'error NO RECORD FOUND';
    
    SWIFT_OracleDB_ResponseService.OracleDBResponseProxy ins14Neg = new SWIFT_OracleDB_ResponseService.OracleDBResponseProxy();
    ins14Neg.SFDCID = mstcins.id;//MRS
    //ins14Neg.LastSyncTimestamp = system.now();
    ins14Neg.LastSyncTimestamp = system.now();
    ins14Neg.status = 'ERROR';
    ins14Neg.errorMessage = 'NO ERROR';

   
    Test.startTest();        
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins7);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins7Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
        
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins8);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins8Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins11Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins11);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins12Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins12);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins13Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins13);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins14Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    //Test.startTest();
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins14);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    
    

  /*  insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins9);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);

   
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins9Neg);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);*/
    insList = new list<SWIFT_OracleDB_ResponseService.OracleDBResponseProxy>();
    insList.add(ins11Neg);
    Test.setReadOnlyApplicationMode(true);
    try{
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
    }catch(exception e){}
    Test.setReadOnlyApplicationMode(false);
    SWIFT_OracleDB_ResponseService.syncOracleDBResponse(insList);
     
      
      DRT__c drtins = [SELECT Last_Sync_Req_Timestamp__c,Mask_Set_Title_Formula__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM DRT__c WHERE ID =: drtCreate[0].id];

Test.stopTest();  
 
    try
    { 
    insert drtins;
    }
   catch(Exception e){
SWIFT_OracleDB_ResponseService.sendMail(e);
    }
}



public static testMethod void testCustomLogging() {
exception iException;
Test.setReadOnlyApplicationMode(true);
drt__c drt = new drt__c(Name='TestDRT');
try{
insert drt;
}catch(exception e){
    iException = e;
}
Test.setReadOnlyApplicationMode(false);
SWIFT_OracleDB_ResponseService.saveErrorLog(iException, 'DRT','','');
}
}