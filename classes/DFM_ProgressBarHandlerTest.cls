/**
* @ Author : Abhita Bansal
* @ Company : Globalfoundries
**/
@isTest
private class DFM_ProgressBarHandlerTest {
	
	public static List<Progress_Bar__c> progBarDataList = DesignCollaboratorTestData.getProgressBarData();
	public static Map<String,String> mapOfpBarStatusImgs = DesignCollaboratorTestData.getProgressBarMap(progBarDataList);
	
    static testMethod void myProgressBarHandlerMethod1() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator1311();
    	waiverCollaborator.Progressbar_staus__c = 'Pending_Customer_Cancelled';       
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
        
        Test.stopTest();
        
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending_Customer_Cancelled','Pending_Customer_Cancelled');
    }
    static testMethod void myProgressBarHandlerMethod2() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator1311();
    	waiverCollaborator.Progressbar_staus__c = 'Pending_Foundry_Cancelled';       
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
        
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending_Foundry_Cancelled','Pending_Foundry_Cancelled');
    }
    static testMethod void myProgressBarHandlerMethod21() {
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator21();
    	 Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c = 'Closed'];      
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
        
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Closed','Closed');
    }
    
     static testMethod void myProgressBarHandlerMethod3() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator22();
        waiverCollaborator.Waiver_Status__c='PI';
        waiverCollaborator.Progressbar_staus__c='Pending';
         waiverCollaborator.Is_Sync_with_AIA__c=true;
             update waiverCollaborator;
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending','Pending'); 
    }
    static testMethod void myProgressBarHandlerMethod31() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator22();
        waiverCollaborator.Waiver_Status__c='PI';
        waiverCollaborator.Progressbar_staus__c='Pending_Customer_External';
         waiverCollaborator.Is_Sync_with_AIA__c=true;
             update waiverCollaborator;
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending_Customer_External','Pending_Customer_External');
    }
    static testMethod void myProgressBarHandlerMethod32() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator22();
        waiverCollaborator.Waiver_Status__c='Open';
        waiverCollaborator.Progressbar_staus__c='Pending_Customer_External';
         waiverCollaborator.Is_Sync_with_AIA__c=true;
             update waiverCollaborator;
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending_Customer_External','Pending_Customer_External');
    }
    static testMethod void myProgressBarHandlerMethod33() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator23();
        waiverCollaborator.Waiver_Status__c='PWA';
        waiverCollaborator.Is_Sync_with_AIA__c=true;
        waiverCollaborator.Progressbar_staus__c='Pending_Customer';
        
             update waiverCollaborator;
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending_Customer','Pending_Customer');
    }
    
    
    static testMethod void myProgressBarHandlerMethod4() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator22();
        waiverCollaborator.PTSR_Status__c='Cancel';
        waiverCollaborator.Progressbar_staus__c='Pending for FAE';
             update waiverCollaborator;
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Pending for FAE','Pending for FAE');
    }
    static testMethod void myProgressBarHandlerMethod5() {
    	
    	DesignCollaboratorTestData.getWaiverCollaborator31();
        Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where DFMServiceOption__c='DFM Services and Analysis'];   
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'DFM Services and Analysis','DFM Services and Analysis');
    }
     static testMethod void myProgressBarHandlerMethod6() {
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator31();
        
        waiverCollaborator1.Progressbar_staus__c='PENDING_DFM';
        
             update waiverCollaborator1;
       Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c='PENDING_DFM'];
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'PENDING_DFM','PENDING_DFM');
    }
     static testMethod void myProgressBarHandlerMethod7() {
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator14();
       
               update waiverCollaborator1;
      Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c='Initiated'];
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Initiated','Initiated'); 
    }
    static testMethod void myProgressBarHandlerMethod71() {
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator141();
       
               update waiverCollaborator1;
      Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c='Review_Disposition'];
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Review_Disposition','Review_Disposition');
    }
    static testMethod void myProgressBarHandlerMethod72() {
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator142();
       
              update waiverCollaborator1;
      Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c='Execution'];
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Execution','Execution');
    }
    
     static testMethod void myProgressBarHandlerMethod8() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator33();
        waiverCollaborator.Progressbar_staus__c='PENDING_DFM';
        
            update waiverCollaborator;
      
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'PENDING_DFM','PENDING_DFM'); 
    }
    static testMethod void myProgressBarHandlerMethod9() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator33();
         waiverCollaborator.Waiver_Status__c ='Closed'; 
        waiverCollaborator.Is_Sync_with_AIA__c =False;
            update waiverCollaborator;
      
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c = 'Closed','Closed');
    }
    static testMethod void myProgressBarHandlerMethod10() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator33();
        waiverCollaborator.Waiver_Status__c ='VCP'; 
        waiverCollaborator.Is_Submit_4_DFM_Apprval__c =True;
        waiverCollaborator.Is_Sync_with_AIA__c=true;
            update waiverCollaborator;
      
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Waiver_Status__c ='VCP','VCP');
    }
    static testMethod void myProgressBarHandlerMethod11() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator33();
        waiverCollaborator.Waiver_Status__c ='VCP'; 
        waiverCollaborator.Is_Submit_4_DFM_Apprval__c =False;
        update waiverCollaborator;
      
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Waiver_Status__c ='VCP','VCP');
    }
    static testMethod void myProgressBarHandlerMethod12() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator32();
        waiverCollaborator.Waiver_Status__c ='Closed'; 
        waiverCollaborator.Progressbar_staus__c='PENDING_DFM';
        waiverCollaborator.Is_Sync_with_AIA__c =False;
        update waiverCollaborator;
      
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c ='PENDING_DFM','PENDING_DFM');
    }
    static testMethod void myProgressBarHandlerMethod13() {
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator34();
        
                   update waiverCollaborator1;
      Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c='Cancelled'];
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c ='Cancelled','Cancelled');
    }
    static testMethod void myProgressBarHandlerMethod14() {	
    	
    	Wavier_Collaborator__c waiverCollaborator1 = DesignCollaboratorTestData.getWaiverCollaborator35();
        
            update waiverCollaborator1;
       Wavier_Collaborator__c waiverCollaborator=[select id,DFMServiceOption__c, Waiver_Status__c,Progressbar_staus__c,Workflow_Status__c,Is_Submit_4_DFM_Apprval__c,Is_Sync_with_AIA__c,IsGfAcceptsRisk__c from Wavier_Collaborator__c where Progressbar_staus__c='Cancelled'];
        Test.startTest();
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c ='Cancelled','Cancelled');
    }
    static testMethod void myProgressBarHandlerMethod15() {
    	
    	Wavier_Collaborator__c waiverCollaborator = DesignCollaboratorTestData.getWaiverCollaborator33();
    	waiverCollaborator.Is_Submit_4_DFM_Apprval__c=True;
    	 waiverCollaborator.Progressbar_staus__c='DFM_CUSTOMER_PENDING_VIEW';
    	
             update waiverCollaborator;
        Test.startTest();
        
        
	        DFM_ProgressBarHandler progBarHandler = new DFM_ProgressBarHandler();
	        progBarHandler.getStatusImg4Drc(waiverCollaborator, mapOfpBarStatusImgs);
	        progBarHandler.getStatusImg4DrcCustomer(waiverCollaborator, mapOfpBarStatusImgs);
              
        Test.stopTest();
        System.assertEquals(waiverCollaborator.Progressbar_staus__c ='DFM_CUSTOMER_PENDING_VIEW','DFM_CUSTOMER_PENDING_VIEW');
    }
}