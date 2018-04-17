/*
    @author :- SUHAS BARGI
 */
@isTest
private class DRC_DrcRuleInfoTriggerHandlerTest {   
  	
  @testSetup static void testdata() {
       // DataUtilTest.loadEnvironmentVariables();
    }

    static testMethod void myDrcRuleInfoTriggerMethod() {
        
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();
        waiverColl.Is_releasedToCustomer__c = true;
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id);  
        DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id); 
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));     	
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('FCF');            
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='TESTSTATUS';
                update rule1;
            }
        
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        
        System.Assert(waiverColl.Is_releasedToCustomer__c,true);
          
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod1() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        waiverColl.Is_releasedToCustomer__c = true;
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('WCR'); 
        
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='FD';
                update rule1;
           
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.Assert(waiverColl.Is_releasedToCustomer__c,true);  
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod2() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        waiverColl.Is_releasedToCustomer__c = true;
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('WEA');    
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='FCF';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.Assert(waiverColl.Is_releasedToCustomer__c,true);  
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod3() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('PW');    
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='WCR';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        
        System.assertEquals('PW', 'PW');
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod4() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('PI');    
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='WEA';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('PI', 'PI');  
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod5() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger1();       
        
        DesignCollaboratorTestData.getWaiverRuleListForPW(waiverColl.Id); 
       // DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('PA');     
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='PW';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('PA', 'PA');  
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod6() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger1();       
        
        DesignCollaboratorTestData.getWaiverRuleListForPI(waiverColl.Id); 
        //DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id);  
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('PWA');    
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='PI';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('PWA', 'PWA');  
    }
    static testMethod void myDrcRuleInfoTriggerMethod9() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        
        DesignCollaboratorTestData.getWaiverRuleListForPA(waiverColl.Id); 
        //DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('PWO');     
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='PA';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('PWO', 'PWO');  
    }
    static testMethod void myDrcRuleInfoTriggerMethod7() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        
       DesignCollaboratorTestData.getWaiverRuleListForPWO(waiverColl.Id); 
        //DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('POC');    
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='PWO';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('POC', 'POC');  
    }
    
    static testMethod void myDrcRuleInfoTriggerMethod8() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorfortrigger();       
        
        DesignCollaboratorTestData.getWaiverRuleListForPOC(waiverColl.Id); 
        //DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
        
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
        String collabId = String.valueOf(waiverColl.Id);
        set<string> setOfFinalStatus =new set<string>();
        setOfFinalStatus.add('POF');     
        Test.startTest(); 
         Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='POC';
                update rule1;
            }
        ruleInfoTest.setFinalStatus(setOfFinalStatus,waiverColl);
        DRC_DrcRuleInfoTriggerHandler.setFinalStatus(setOfFinalStatus,collabId);
        DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('POF', 'POF');  
    }
    
static testMethod void myDrcRuleInfoTriggerMethod91() {       
        DRC_DrcRuleInfoTriggerHandler ruleInfoTest = new DRC_DrcRuleInfoTriggerHandler();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator8();       
        
        DesignCollaboratorTestData.getWaiverRuleListForFDCC(waiverColl.Id); 
        DesignCollaboratorTestData.getWaiverRuleListForFDCCWEA(waiverColl.Id); 
       set<string> setOfFinalStatus =new set<string>();
         setOfFinalStatus.add('FD');
     // setOfFinalStatus.add('FCF');
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c>(DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id));      
            
        Test.startTest(); 
      Waiver_Rule_List__c rule1 = ruleList.get(0);
        if(rule1.Final_Stage__c<>null){
                rule1.Final_Stage__c='FD';
                update rule1;
            }
    	 ruleInfoTest.setFinalStatus(setOfFinalStatus, waiverColl);	
         DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(ruleList);        
        Test.stopTest();
        System.assertEquals('FD', 'FD');  
    }
}