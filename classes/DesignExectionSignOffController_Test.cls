/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This Test_DesignExectionSignOffController class will be used to test singOff module flow on DE track
**/
@isTest(seeAllData =false)
private class DesignExectionSignOffController_Test {
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static testMethod void getSignOffRTDetailTest(){
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        List<SelectOption> listOptions = deSignOff.getSignOffRTDetail();
        system.assert(!listOptions.isEmpty());
    }
    
    private static testMethod void signOffModueDetailsTest(){
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        Sign_off_Module__c som = DesignExecutionUtill_Test.createsingleSignOFFRecord();        
        Test.startTest();
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        deSignOff.deId = de.Id;
        deSignOff.signOffModueDetails();
        som = new  Sign_off_Module__c();
        som = deSignOff.signOffModue;
        system.assert(null != som);
        test.stopTest();   
    }
    
    private static testMethod void getUserLavelNewRecordAccessTest(){          
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        //deSignOff.deId = de.Id;   
        User user = DesignExecutionUtill_Test.createUser();
        System.runAs(user){
        Test.startTest();
            User u = new User();
            u = user;
            u.Alias ='Test1';
            update u;
            List<PermissionSet> listOfPermissionSet_User = [SELECT id, Name FROM PermissionSet 
                                            where PermissionSet.Name IN: new List<String>{
                                                        label.DIWApplicationEngineer,
                                                        label.DIWPhysicalDesignEngineer, 
                                                        label.DIWDesignCenterEngineer,
                                                        label.DIWProductEngineer }];
            // Assign the above inserted user for the above Permission Set.
            List<PermissionSetAssignment> listOdPermissionSet = new List<PermissionSetAssignment>();
            for(PermissionSet perObj :listOfPermissionSet_User){
                PermissionSetAssignment psaUsers = new PermissionSetAssignment();
                psaUsers.AssigneeId = u.Id;
                psaUsers.PermissionSetId = perObj.Id;
                listOdPermissionSet.add(psaUsers);
            }
            insert listOdPermissionSet;
            System.assert(listOdPermissionSet !=null);
            deSignOff.getUserLavelSignOffAccess();
            system.assert(deSignOff.signOffModue !=null);
            system.assert(deSignOff.signOffApprover !=null);
            
           system.assertEquals(deSignOff.signOffApprover.aeApproval, false);
           system.assertEquals(deSignOff.signOffApprover.dceApproval, false);  
           system.assertEquals(deSignOff.signOffApprover.rtlCheckPointApproval, false);    
           system.assertEquals(deSignOff.signOffApprover.dceReviewdApproval, false);   

        test.stopTest();
        }    
    }
    
    private static testMethod void getUserLavelExistingRecordAccessTest(){
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        //deSignOff.deId = de.Id;   
        User user = DesignExecutionUtill_Test.createUser();
        System.runAs(user){
        Test.startTest();
            User u = new User();
            u = user;
            u.Alias ='Test1';
            update u;
            List<PermissionSet> listOfPermissionSet_User = [SELECT id, Name FROM PermissionSet 
                                            where PermissionSet.Name IN: new List<String>{
                                                        label.DIWApplicationEngineer,
                                                        label.DIWPhysicalDesignEngineer, 
                                                        label.DIWDesignCenterEngineer,
                                                        label.DIWProductEngineer }];
            // Assign the above inserted user for the above Permission Set.
            List<PermissionSetAssignment> listOdPermissionSet = new List<PermissionSetAssignment>();
            for(PermissionSet perObj :listOfPermissionSet_User){
                PermissionSetAssignment psaUsers = new PermissionSetAssignment();
                psaUsers.AssigneeId = u.Id;
                psaUsers.PermissionSetId = perObj.Id;
                listOdPermissionSet.add(psaUsers);
            }
            insert listOdPermissionSet;
            Sign_off_Module__c som = DesignExecutionUtill_Test.createsingleSignOFFRecord();
            som = [select Id, Name, Design_Execution__c, Stage__c, SignOffExternalId__c from Sign_off_Module__c where id =:som.Id];
            deSignOff.recordTypeName = som.Stage__c;
            deSignOff.deId = som.Design_Execution__c;
            deSignOff.signOffModueDetails();
            deSignOff.showPopup();
            deSignOff.closePopup();    
            deSignOff.getUserLavelSignOffAccess();
            system.assert(deSignOff.signOffApprover !=null);
            system.assertEquals(deSignOff.signOffApprover.aeApproval, true);
            system.assertEquals(deSignOff.signOffApprover.dceApproval, true);   
            system.assertEquals(deSignOff.signOffApprover.rtlCheckPointApproval, true); 
            system.assertEquals(deSignOff.signOffApprover.dceReviewdApproval, true);
            Test.stopTest();
        }
    }    
    
    private static testMethod void saveSignOffTest(){
        Test.startTest();    
        Design_Execution__c deObj =  DesignExecutionUtill_Test.createsingleDERecord();
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        deSignOff.signOffModueDetails();
        deSignOff.getUserLavelSignOffAccess();
        deSignOff.deId = deObj.Id;
        deSignOff.recordTypeName = 'RTP';
        deSignOff.signOffApprover.AEChecked = true;
        deSignOff.signOffApprover.DCEChecked = true;
        deSignOff.signOffApprover.PDChecked = true;
        deSignOff.signOffApprover.PEChecked = true;
        deSignOff.CustomerReviewed = true;
        deSignOff.CustomerChecked = true;
        deSignOff.saveSignOffDetail();

        List<Sign_off_Module__c> lstSOM = [select Id,Name from Sign_off_Module__c Where Design_Execution__c=:deObj.Id ];
        //check for attachment
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=lstSOM[0].id;
        deSignOff.signOffAttachment = attach;       
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=lstSOM[0].id;
        deSignOff.customerApprovalAttachment = attach;
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob2;
        attach.parentId=lstSOM[0].id;
        deSignOff.signOffAttachmentRTC = attach;  
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob3;
        attach.parentId=lstSOM[0].id;
        deSignOff.signOffAttachmentRTM = attach;  
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob4=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob4;
        attach.parentId=lstSOM[0].id;
        deSignOff.signOffAttachmentTMD = attach; 
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob5=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob5;
        attach.parentId=lstSOM[0].id;
        deSignOff.signOffAttachmentTDI = attach; 
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob6=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob6;
        attach.parentId=lstSOM[0].id;
        deSignOff.signOffAttachmentQLD = attach; 
        
        attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob7=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob7;
        attach.parentId=lstSOM[0].id;
        deSignOff.customerApprovalAttachmentRTM = attach; 
        
        //designoff.recordTypeName = 'RTM DT';
        designoff.recordTypeName = 'RTM RIT A/B';
        designoff.signOffModue = new Sign_off_Module__c();
        delete lstSOM;
        deSignOff.saveSignOffRTMDetail();
        system.assert(lstSOM !=null);
        system.assert(!lstSOM.isEmpty());
        system.assertEquals(lstSOM.size(), 1);
        
        lstSOM.add([select Id,Name from Sign_off_Module__c Where Design_Execution__c=:deObj.Id ]);
        system.assert(lstSOM !=null);
        system.assert(!lstSOM.isEmpty());
        system.assertEquals(lstSOM.size(), 2);
        
        deSignOff.getSOMAttachmentId();
        Test.stopTest();        
    }
    
    private static testMethod void pageRedirectionTest(){
        Test.startTest();    
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();  
        List<DesignExecutionStaticValue__c> deStatic = new List<DesignExecutionStaticValue__c>();
        DesignExecutionStaticValue__c des1 = new DesignExecutionStaticValue__c(Name ='Sign Off RTC DT Ready', Value__c='Hello Test Error');
        deStatic.add(des1);
        DesignExecutionStaticValue__c des2 = new DesignExecutionStaticValue__c(Name ='Sign Off RTC RIT B', Value__c='Hello Test Error');
        deStatic.add(des2);
        DesignExecutionStaticValue__c des3 = new DesignExecutionStaticValue__c(Name ='SignOff RTM DT', Value__c='Hello Test Error');
        deStatic.add(des3);
        DesignExecutionStaticValue__c des4 = new DesignExecutionStaticValue__c(Name ='SignOff RTM RIT B', Value__c='Hello Test Error');
        deStatic.add(des4);
        insert deStatic;
        
        de = [Select Id, Customer_Design_Specification__c from Design_Execution__c where id =:de.Id];
        Map<String,Object> fieldSignOffMap = new Map<String,Object>();
        fieldSignOffMap.put('Design_Execution__c', de.Id);
        fieldSignOffMap.put('SignOffExternalId__c', de.Id +':RTP');
        fieldSignOffMap.put('Application_Engineer__c', true);
        fieldSignOffMap.put('Field_Design_Center_Engineer__c', true);
        fieldSignOffMap.put('Physical_Design_Engineer__c', true);
        fieldSignOffMap.put('Product_Engineer__c', true);
        fieldSignOffMap.put('DCE_RTL_Checkpoin__c', true);
        fieldSignOffMap.put('DCE_Review_Approved__c', true);
        Sign_off_Module__c sfm = DesignExecutionSignOff_DataFactory.createDesignExectionSignOffModule(fieldSignOffMap);
        
        system.currentPageReference().getParameters().put('deId', de.Id);
        system.currentPageReference().getParameters().put('cdsid', de.Customer_Design_Specification__c);
        
    // Put Id into the current page Parameters
    system.currentPageReference().getParameters().put('cancelDT', 'false');
    system.currentPageReference().getParameters().put('enableCreateRTDTButton', 'false');
            
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        deSignOff.selectedRT ='RTP';
    
        Pagereference page = deSignOff.OpenDesignPhaseForm();
        system.assert(page !=null);
        system.assert(page.getUrl() !=null);
        
        Pagereference page1 = deSignOff.cancelExecutionDetail();
        system.assert(page1 !=null);
        system.assert(page1.getUrl() !=null);
        
        Pagereference page2 = deSignOff.RequoteExecutionDetail();
        /*system.assert(page2 !=null);
        system.assert(page2.getUrl() !=null);*/
        
        Pagereference page3 = deSignOff.readExecutionDetail();        
        system.assert(page3 !=null);
        system.assert(page3.getUrl() !=null);
        
        Pagereference page5 = deSignOff.OpenSignOffForm();        
        system.assert(page5 !=null);
        system.assert(page5.getUrl() !=null);
        
        Pagereference page6 = deSignOff.resetSignOffDetail();        
        system.assert(page6 !=null);
        system.assert(page6.getUrl() !=null);
        Test.stopTest();        
    } 
    
     private static testMethod void sendSignOffTeamMemberEmailTest(){ 
       Contact contact = InternalDeviceTestUtil.createContact('Test Contact', 'Test Contact', DesignExecutionUtill_Test.accountId, 'noreply@salesforce.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
       Test.startTest();     
       Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();  
        de = [Select Id, Customer_Design_Specification__c from Design_Execution__c where id =:de.Id];
        system.currentPageReference().getParameters().put('deId', de.Id);
        system.currentPageReference().getParameters().put('cdsid', de.Customer_Design_Specification__c);
        
    // Put Id into the current page Parameters
    system.currentPageReference().getParameters().put('cancelDT', 'false');
    system.currentPageReference().getParameters().put('enableCreateRTDTButton', 'false');
            
        DesignExecutionSignOffController deSignOff = new DesignExecutionSignOffController();
        deSignOff.selectedRT ='RTC RIT B ready';
        deSignOff.sendSignOffTeamMemberEmail();
        deSignOff.updateDEActualDateReady(de.Id,'RTM DT',system.today());
        deSignOff.updateDEActualDateReady(de.Id,'RTM RIT A',system.today());
        deSignOff.updateDEActualDateReady(de.Id,'RTM RIT A/B',system.today());
        deSignOff.updateDEActualDateReady(de.Id,'RTM RIT B',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTF',system.today());
        deSignOff.updateDEActualDate(de.Id,'EFF',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTP',system.today());
        deSignOff.updateDEActualDate(de.Id,'EFP',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTL',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTC DT ready',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTC RIT B ready',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTC RIT A ready',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTM RIT A ready',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTC RIT A/B ready',system.today());
		deSignOff.updateDEActualDate(de.Id,'RTM RIT B',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTM RIT A',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTM DT',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTM RIT B ready',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTM DT ready',system.today());
        deSignOff.updateDEActualDate(de.Id,'RTM RIT A/B',system.today());   
        deSignOff.viewSignOffRT();
        deSignOff.listOfApprovedMileStoneRecords();
        Test.stopTest();    
     }
}