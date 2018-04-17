/**
* Author: Sakthivel
* Project: DIW 
* Description: This Test_DesignExecutionWaiverController class will be used to test waiver capability flow on DE track
**/
@isTest(seeAllData=false)
private class DesignExecutionWaiverController_Test {
  @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static testMethod void getWaiverCapabilityRTDetailTest(){
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        List<SelectOption> listOptions = deWaiver.getWaiverCapabilityRTDetail();
        system.assert(!listOptions.isEmpty());
    }
    
    private static testMethod void waiverCapabilityDetailsTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
         User u = new User(
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
        );
        Insert u;
        w.Add_Approver__c = u.Id;
        Update w;
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTP';  
        deWaiver.recordTypeName ='RTP';  
        deWaiver.waiverExtVal = w.Design_Execution__c+':RTP';
        deWaiver.IDRdt = 'test';
        
        Design_Execution__c de = [Select Id, Customer_Design_Specification__c from Design_Execution__c where id =:w.Design_Execution__c];
        system.currentPageReference().getParameters().put('deId', de.Id);
        system.currentPageReference().getParameters().put('deid', de.Id);
        system.currentPageReference().getParameters().put('RTName', 'RTP');
        system.currentPageReference().getParameters().put('se', '1');
        system.currentPageReference().getParameters().put('cdsId', de.Customer_Design_Specification__c);
        deWaiver.cdsId = de.Customer_Design_Specification__c;
        deWaiver.wId = w.Id;
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        deWaiver.waiversDetail = waiver;
        deWaiver.waiversDetail.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        deWaiver.waiversDetail.Section__c = 'Sign Off Module Methodology';
        deWaiver.waiversDetail.Waiver_Type__c = 'RTL'; 
        deWaiver.getWaiverList();
        deWaiver.getWaiverToDisplay();
        deWaiver.saveWaiverDetail();
       // deWaiver.waiverApproverEmail= 'abc@test.com';
        deWaiver.AddWaiverApprover();
        test.stopTest();
    }
    
    private static testMethod void pageRedirectionTest(){
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();  
        de = [Select Id, Customer_Design_Specification__c from Design_Execution__c where id =:de.Id];
        system.currentPageReference().getParameters().put('deId', de.Id);
        system.currentPageReference().getParameters().put('cdsid', de.Customer_Design_Specification__c);
        
        DesignExecutionWaiverController deSignOff = new DesignExecutionWaiverController();
        deSignOff.selectedRT ='RTP';
        deSignOff.waiversDetail = null;
        Pagereference page = deSignOff.OpenWaiverForm();
        system.assert(page !=null);
        system.assert(page.getUrl() !=null);
        
        Pagereference page1 = deSignOff.cancelExecutionDetail();
        system.assert(page1 !=null);
        system.assert(page1.getUrl() !=null);
        
    }   
    
    private static testMethod void waiverCapabilityTypeTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTP';  
        deWaiver.recordTypeName ='RTP';  
        deWaiver.waiverExtVal = w.Design_Execution__c+':RTP';
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        deWaiver.waiversDetail = waiver;
        deWaiver.waiversDetail.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        deWaiver.waiversDetail.Section__c = 'Sign Off Module Methodology';
        deWaiver.waiversDetail.Waiver_Type__c = '-None-';  
        deWaiver.saveWaiverDetail();  
        test.stopTest();
    }
     private static testMethod void waiverCapabilityNewWaiverTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTP';  
        deWaiver.recordTypeName ='RTP';  
        deWaiver.waiverExtVal = w.Design_Execution__c+':RTP';
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        deWaiver.waiversDetail = waiver;
        deWaiver.waiversDetail.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        deWaiver.waiversDetail.Section__c = 'Sign Off Module Methodology';
        deWaiver.waiversDetail.Waiver_Type__c = '';  
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail();
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTLTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTL';  
        deWaiver.recordTypeName ='RTL';  
        //deWaiver.waiverExtVal = w.Design_Execution__c+':RTP';
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTL';  
        waiver.Approval_Status__c = 'Approved';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail();  
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTMTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTM';  
        deWaiver.recordTypeName ='RTM';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTM';  
        waiver.Approval_Status__c = 'Approved';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail();  
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTMCancelTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTM';  
        deWaiver.recordTypeName ='RTM';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTM';  
        waiver.Approval_Status__c = 'Cancel';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail();  
        deWaiver.recordTypeName = null;
        deWaiver.wId = null;
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTMRejectedTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTM';  
        deWaiver.recordTypeName ='RTM';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTM';  
        waiver.Approval_Status__c = 'Rejected';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail();  
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTMReviewTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTM';  
        deWaiver.recordTypeName ='RTM';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTM';  
        waiver.Approval_Status__c = 'Review';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail();  
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTCCancelTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTC';  
        deWaiver.recordTypeName ='RTC';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTC';  
        waiver.Approval_Status__c = 'Cancel';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail(); 
        deWaiver.getWaiverToDisplayList();      
        test.stopTest();
    }
     private static testMethod void waiverCapabilityRTCApprovedTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTC';  
        deWaiver.recordTypeName ='RTC';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTC';  
        waiver.Approval_Status__c = 'Approved';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail(); 
        deWaiver.getWaiverToDisplayList();      
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTCReviewTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTC';  
        deWaiver.recordTypeName ='RTC';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTC';  
        waiver.Approval_Status__c = 'Review';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail(); 
        deWaiver.getWaiverToDisplayList();      
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTCRejectedTest(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        DesignExecutionStaticValue__c deStatic = new DesignExecutionStaticValue__c();
        deStatic.Name = 'None';
        deStatic.Value__c ='-None-';
        insert deStatic;
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTC';  
        deWaiver.recordTypeName ='RTC';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTC';  
        waiver.Approval_Status__c = 'Rejected';
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        
        deWaiver.recordTypeName =null;
        deWaiver.saveWaiverDetail(); 
        deWaiver.getWaiverToDisplayList();      
        test.stopTest();
    }
    private static testMethod void waiverCapabilityRTCTest1(){
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        system.assert(null != waiver);  
        system.debug('de::::'+w.Design_Execution__c);
        system.debug('waiver:::::'+waiver);
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTC';  
        deWaiver.recordTypeName ='RTC';  
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        waiver.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        waiver.Section__c = 'Sign Off Module Methodology';
        waiver.Waiver_Type__c = 'RTC';  
        waiver.Design_Execution__c = deWaiver.deId;
        Insert waiver;
        deWaiver.NewWaiver();
        deWaiver.Table();
        deWaiver.getwaiverSummaryMap();
        deWaiver.saveWaiverDetail(); 
        deWaiver.getWaiverToDisplayList();      
        test.stopTest();
    }
    private static testMethod void waiverCapabilitySendEmailTest(){
      
       Contact contact = InternalDeviceTestUtil.createContact('Test Contact', 'Test Contact', DesignExecutionUtill_Test.accountId, 'noreply@salesforce.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        Test.startTest();
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];

        system.assert(null != waiver);  
        system.debug('waiver:::::'+waiver);
        system.debug('de::::'+w.Design_Execution__c);
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTP';  
        deWaiver.recordTypeName ='RTP';  
        deWaiver.waiverExtVal = w.Design_Execution__c+':RTP';
        
        Design_Execution__c de = [Select Id, Customer_Design_Specification__c from Design_Execution__c where id =:w.Design_Execution__c];
        system.debug('de::::'+de.Id);
        system.debug('de::::'+de.Customer_Design_Specification__c);
        system.currentPageReference().getParameters().put('deId', de.Id);
        system.currentPageReference().getParameters().put('deid', de.Id);
        system.currentPageReference().getParameters().put('RTName', 'RTP');
        system.currentPageReference().getParameters().put('se', '1');
        system.currentPageReference().getParameters().put('cdsid', de.Customer_Design_Specification__c);
        
        system.currentPageReference().getParameters().put('toAddressStr', de.Customer_Design_Specification__c);
        system.currentPageReference().getParameters().put('additionalAddress', de.Customer_Design_Specification__c);
        deWaiver.cdsId = de.Customer_Design_Specification__c;
        deWaiver.waiverDetails();
        waiver = new  Waivers__c();
        deWaiver.waiversDetail = waiver;
        deWaiver.waiversDetail.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
        deWaiver.waiversDetail.Section__c = 'Sign Off Module Methodology';
        deWaiver.waiversDetail.Waiver_Type__c = 'RTL';    
        
        deWaiver.getWaiverList();
        
        deWaiver.saveWaiverDetail();
        //check for attachment
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        system.debug('waiverId::'+w.Id);
        attach.parentId=w.Id;
        deWaiver.waiverAttachment = attach;
        insert attach;
        
        deWaiver.wId = w.Id;
        deWaiver.toAddressStr = 'test1@test.com,test2@test.com';
        deWaiver.additionalAddress = 'test1@test.com,test2@test.com';
        system.currentPageReference().getParameters().put('toAddressStr', 'test1@test.com,test2@test.com');
        system.currentPageReference().getParameters().put('additionalAddress', 'test1@test.com,test2@test.com');
        set<string> setEmailAddresses = new set<string>();
        setEmailAddresses.addAll(deWaiver.toAddressStr.split('[,;]'));
        deWaiver.convertToList(setEmailAddresses);
        deWaiver.sendWaiverEmail();
        
        //check for attachment
        Attachment attach1=new Attachment();     
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob1;
        attach1.parentId=w.Id;
        deWaiver.waiverAttachment = attach1;
        insert attach1;
        deWaiver.sendWaiverEmail();
        deWaiver.fetchEmailDetails();
        deWaiver.EditWaiver();
        test.stopTest();
    }
    
    private static testMethod void waiverCapabilityAttachmentTest(){
        
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Waivers__c waiver = DesignExecutionUtill_Test.createsingleWaiverRecord();  
        Waiver_SMEs__c waiverSME = DesignExecutionUtill_Test.createsingleWaiverSMERecord();  
        Waivers__c w = [Select Id, Design_Execution__c from Waivers__c where id =:waiver.Id];
        Account acct=AgreementTestDataFactory.GenerateAccount(NULL,'MYTEST ACCOUNT');
        insert acct;      
        Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
        insert con;
        Contact c = [Select Id, Email From Contact where id =:con.Id];

        
        system.assert(null != waiver);  
        system.assert(null != acct);  
        system.assert(null != c);  
        Test.startTest();
        DesignExecutionWaiverController deWaiver = new DesignExecutionWaiverController();
        system.currentPageReference().getParameters().put('wId', w.Id);
        system.currentPageReference().getParameters().put('se', '1');
        system.currentPageReference().getParameters().put('toAddressStr', 'test1@test.com,test2@test.com');
        system.currentPageReference().getParameters().put('additionalAddress', 'test1@test.com,test2@test.com');

        deWaiver.wId = w.Id;    
        deWaiver.deId = w.Design_Execution__c;    
        deWaiver.deId = w.Design_Execution__c;  
        deWaiver.selectedRT ='RTP';  
        deWaiver.recordTypeName ='RTP';  
        deWaiver.waiverExtVal = w.Design_Execution__c+':RTP';
        deWaiver.toAddressStr = 'test1@test.com,test2@test.com';
        deWaiver.additionalAddress = 'test1@test.com,test2@test.com';
        //check for attachment
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        system.debug('waiverId::'+w.Id);
        attach.parentId=w.Id;
        deWaiver.waiverAttachment = attach;
        insert attach;
        deWaiver.sendWaiverEmail();
        deWaiver.getSOMAttachmentId();
        deWaiver.SaveWaiverAttachment();
        Test.stopTest();
    }
    
}