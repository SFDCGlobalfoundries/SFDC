/*
    Author: Anirban Roy
    Description: This is the test class for PORChangeReviewController class.  
    History:
        ARoy        06032014    - code creation.
        ARoy		06092014	- modified code for POR Creation validation on PLC Nect Gate = PLR
*/

@isTest(SeeAllData=true) 
public class PORChangeReviewControllerTest {
	
	// Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Product_Start_Date__c = String.valueOf(System.Today().year());
        gmplBX009.G3_Disposition__c = 'Approved';
        gmplBX009.PLC_Next_Gate__c = 'PLR';
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL1(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Product_Start_Date__c = String.valueOf(System.Today().year());
        gmplBX009.G3_Disposition__c = 'Approved';
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of POR Change Review
    static POR_Change_Review__c createPCR(Id gmplId){
        POR_Change_Review__c pcr = new POR_Change_Review__c();
        pcr.Change_Level__c = 'New Variant - Within Budget & No impact to other programs';
        pcr.PCR_Disposition__c = 'Escalate to BCCB';
        pcr.Program_Affected__c = gmplId;
        insert pcr;
        return pcr;
    }
    
    // Test method for creation of POR Change Review record
    static testMethod void createPORChangeReviewTest(){
    
		GMPL_BX009__c gmplBX009Obj = PORChangeReviewControllerTest.createGMPL();
        
        Test.startTest();               
	        PageReference pageRef = Page.PORChangeReviewCreate;
         	Test.setCurrentPage(pageRef);         	
	        ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('POR_GMPL_LKP_ID')+'_lkid',gmplBX009Obj.Id);
         	ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('POR_GMPL_LKP_ID'),gmplBX009Obj.Name);
	        
	        POR_Change_Review__c pcr = new POR_Change_Review__c();
            ApexPages.StandardController controller = new ApexPages.StandardController(pcr);
            PORChangeReviewController por = new PORChangeReviewController(controller);
            PageReference pgr = por.init();
            system.assert(pgr!=null);
            pgr = por.cancel();       
        Test.stopTest();
        
    }
    
    // Test method for validation on creation of POR Change Review record
    static testMethod void createPORChangeReviewValidTest1(){
    
		GMPL_BX009__c gmplBX009Obj = PORChangeReviewControllerTest.createGMPL();
		POR_Change_Review__c pcr1 = PORChangeReviewControllerTest.createPCR(gmplBX009Obj.Id);
        
        Test.startTest();               
	        PageReference pageRef = Page.PORChangeReviewCreate;
         	Test.setCurrentPage(pageRef);
         	ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('POR_GMPL_LKP_ID')+'_lkid',gmplBX009Obj.Id);
         	ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('POR_GMPL_LKP_ID'),gmplBX009Obj.Name);
	        
	        POR_Change_Review__c pcr2 = new POR_Change_Review__c();
            ApexPages.StandardController controller = new ApexPages.StandardController(pcr2);
            PORChangeReviewController por = new PORChangeReviewController(controller);
            try{
            	PageReference pgr = por.init();
            }catch(Exception e){
            	system.assert(e.getMessage().contains('New POR for GMPL/BX009 cannot be created when' 
            				+' POR Change Review record(s) for that GMPL/BX009 exists with PCR Status'
            				+' as Open, BCCB Review or PC Review.'));
            }       
        Test.stopTest();
        
    }
    
    // Test method for validation on creation of POR Change Review record when PLC Next Gate is not PLR
    static testMethod void createPORChangeReviewValidTest2(){
    
		GMPL_BX009__c gmplBX009Obj = PORChangeReviewControllerTest.createGMPL1();
        
        Test.startTest();               
	        PageReference pageRef = Page.PORChangeReviewCreate;
         	Test.setCurrentPage(pageRef);
         	ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('POR_GMPL_LKP_ID')+'_lkid',gmplBX009Obj.Id);
         	ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('POR_GMPL_LKP_ID'),gmplBX009Obj.Name);
	        
	        POR_Change_Review__c pcr = new POR_Change_Review__c();
            ApexPages.StandardController controller = new ApexPages.StandardController(pcr);
            PORChangeReviewController por = new PORChangeReviewController(controller);
            try{
            	PageReference pgr = por.init();
            }catch(Exception e){
            	system.assert(e.getMessage().contains('New PCR for GMPL/BX009 can only be created if the PLC Next Gate is PLR.'));
            }       
        Test.stopTest();
        
    }
	
}