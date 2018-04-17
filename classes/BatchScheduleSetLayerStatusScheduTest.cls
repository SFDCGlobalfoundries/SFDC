/**
 * Classes Covered:
 * + BatchScheduleSetLayerStatusSchedulable
 * + BatchScheduleSetLayerStatusSchedulable2
 *
 * @createdDate 8-May-2015
 */
@isTest
private class BatchScheduleSetLayerStatusScheduTest {

	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}

	/**
    * Class covered: BatchScheduleSetLayerStatusSchedulable
    */
    static testMethod void myUnitTest() {
        
        string CORN_EXP = '0 0 0 1 4 ?';
	   	string jobid = system.schedule('my batch job', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
    }
    
    //
    static testMethod void myUnitTest5() {
        
        string CORN_EXP = '0 0 0 1 4 ?';
	   	string jobid = system.schedule('my batch job', CORN_EXP, new BatchScheduleSetLayerChipSchedulable() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
    }
    
    /**
    * Class covered: BatchScheduleSetLayerStatusSchedulable2
    */
    static testMethod void myUnitTest2() {
        
        string CORN_EXP = '0 0 0 1 4 ?';
	   	string jobid = system.schedule('my batch job', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable2() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
    }
    
    /**
    * Class covered: SetLayerStatus_Service
    */
    static testMethod void myUnitTest3() {
        
        string CORN_EXP = '0 0 0 1 4 ?';
	   	string jobid = system.schedule('my batch job1', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable2() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
	   	
	   	CORN_EXP = '0 3 0 1 4 ?';
	   	jobid = system.schedule('my batch job2', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable2() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
	   	
	   	CORN_EXP = '0 5 0 1 4 ?';
	   	jobid = system.schedule('my batch job3', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable2() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
	   	
	   	CORN_EXP = '0 7 0 1 4 ?';
	   	jobid = system.schedule('my batch job4', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable2() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
	   	
	   	CORN_EXP = '0 9 0 1 4 ?';
	   	jobid = system.schedule('my batch job5', CORN_EXP, new BatchScheduleSetLayerStatusSchedulable2() );
	   	//CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
	   	
	   	SetLayerStatus_Service.invokeJobToCalculateLayerStatus();
    }
    
    static testMethod void myUnitTest4() {
    	
    	User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        System.runAs(sysAdminUser){      
        	// comment-out, refactor with testSetup method setup()      
            //---------------------------------------------//
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release');
            insert objPTRF;
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            system.assertEquals(objDRTPTRF.PTRF__c,objPTRF.Id);
            system.assertEquals(objDRTPTRF.DRT__c,objDRT.Id);
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
            objMRSLCA1=MRSHandlerUtility.setDRTLayerChipDefaultValues(objMRSLCA1);
            system.assertEquals(objMRSLCA1.Prime_MEBES_Received__c, null);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            
            Test.setCurrentPage(Page.VFMRSRetriggerRollup);
            ApexPages.currentPage().getParameters().put('id',objMST.Id); 
            MRSRetriggerRollup mrsController = new MRSRetriggerRollup(new ApexPages.StandardController(objMST));
            mrsController.calculateMRSLayerStatus();
            mrsController.pollingStatus();
            mrsController.returnToMST();
            mrsController.continueLayerStatusCalculate();
            
            Test.setCurrentPage(Page.VFMRSRetriggerRollupLayer);
            ApexPages.currentPage().getParameters().put('id',objMST.Id); 
            MRSRetriggerRollupLayer mrsController1 = new MRSRetriggerRollupLayer(new ApexPages.StandardController(objMST));
            mrsController1.calculateMRSLayerStatus();
            mrsController1.pollingStatus();
            mrsController1.returnToMST();
            
        }
    }
}