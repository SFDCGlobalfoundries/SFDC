/*
Type Name: BugMassEditControllerTest
Author: UCM Cognizant
Reason: This class is test class for BugMassEditController.
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
@isTest(SeeAllData = false)
public class BugMassEditControllerTest{
    static testMethod void massBugUpdate() {
        Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CAD Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.recordtypeid= cadRecordTypeId ;
        insert b;

        bug__c b1 = new bug__c();
        b1.Bug_Title__c = 'test abc';
        b1.Product_technology__c = 'CAD Environment';
        b1.Component__c = 'Documentation';
        b1.recordtypeid= cadRecordTypeId ;
        insert b1;

        List<Bug__c> bugList = [SELECT name FROM Bug__c LIMIT 20];
        test.starttest();
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(bugList);
        setCtr.setSelected(new Bug__c[]{b1});        
        BugMassEditController  controller = new BugMassEditController(setCtr);        
        controller.getFieldTypeOptions();
        controller.getStep();
        controller.getResolution();
        controller.callHttpRequest();
        controller.step2();
        controller.step3();
        
        controller.resolutionDetails  = '';
        controller.stStatus = 'closed';
        controller.step3();
        
        controller.resolutionDetails  = 'test';
        controller.stStatus = 'closed';
        controller.step3();
        
        controller.stResolution = null;
        controller.res = 'Resolution;';
        
        controller.step3();
        controller.stResolution = 'test';
        controller.step3();
        
        controller.dmTeamClassification = 'test';
        controller.resolutionDetl = 'test';
        controller.step3();
        
        controller.resolutionDetails = '';
        controller.step3();
        
        controller.ststatus = 'New';
        controller.stResolution = 'Moved To DMM';
        controller.resolutionDetails = 'Test';
        controller.fieldName = 'Status__c';
        controller.step4();
        controller.step1();
        controller.ExportExcelSuccessLog();
        controller.ExportExcelErrorLog();
        test.stoptest();
    }
        static testMethod void massBugUpdateWithPDKBug() {
        Id pdkRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
        bug__c b = new bug__c();

        bug__c b1 = new bug__c();
        b1.Bug_Title__c = 'test abc';
        b1.Product_technology__c = '110G';
        b1.Component__c = 'DFM';
        b1.Version__c = 'unspecified';
        b1.recordtypeid= pdkRecordTypeId;
        insert b1;
        List<Bug__c> bugList = [SELECT name FROM Bug__c LIMIT 20];
        test.starttest();
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(bugList);
        setCtr.setSelected(new Bug__c[]{b1});
        BugMassEditController  controller = new BugMassEditController(setCtr);        
        controller.getFieldTypeOptions();
        controller.getStep();
        controller.getResolution();
        controller.callHttpRequest();
        controller.step2();
        controller.step3();
        controller.ststatus = 'Closed';
        controller.stResolution = 'Fixed';
        controller.dmTeamClassification = 'Typo';
        controller.resolutionDetails = 'Test';
        controller.fieldName = 'Status__c';
        controller.step4();
        controller.step1();
        controller.ExportExcelSuccessLog();
        controller.ExportExcelErrorLog();
        test.stoptest();
    }
      static testMethod void massBugUpdateWithPDKBugError() {
        Id pdkRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
        bug__c b = new bug__c();

        bug__c b1 = new bug__c();
        b1.Bug_Title__c = 'test abc';
        b1.Product_technology__c = '110G';
        b1.Component__c = 'DFM';
        b1.Version__c = 'unspecified';
        b1.recordtypeid = pdkRecordTypeId;
        b1.Resolution_Details__c = 'testing';
        insert b1;
        List<Bug__c> bugList = [SELECT name FROM Bug__c LIMIT 20];
        test.starttest();
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(bugList);
        setCtr.setSelected(new Bug__c[]{b1});
        BugMassEditController  controller = new BugMassEditController(setCtr);
        
        BugMassEditController.BugWrapper  wrapcontroller = new BugMassEditController.BugWrapper(bugList[0]);
        
        
        controller.getFieldTypeOptions();
        controller.getStep();
        controller.getResolution();
        controller.callHttpRequest();
        controller.step2();
        controller.step3();
        controller.ststatus = 'Resolved';
        controller.stResolution = 'Fixed';
        controller.dmTeamClassification = 'Typo';
        controller.resolutionDetails = 'Test';
        controller.fieldName = 'Status__c';
        controller.step4();
        controller.step1();
        controller.ExportExcelErrorLog();
        for(BugMassEditController.BugWrapper rec : controller.bugwrapperlist){
            rec.selected = false;
        }
        controller.step2();
        
        test.stoptest();
    }
       
    
    static testMethod void massUpdateWithoutAnyBug() {
        Id pdkRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
        bug__c b = new bug__c();

        bug__c b1 = new bug__c();
        b1.Bug_Title__c = 'test abc';
        b1.Product_technology__c = '110G';
        b1.Component__c = 'DFM';
        b1.Version__c = 'unspecified';
        b1.recordtypeid= pdkRecordTypeId;
        insert b1;
        List<Bug__c> bugList = [SELECT name FROM Bug__c LIMIT 20];
        test.starttest();
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(bugList);
        setCtr.setSelected(new Bug__c[]{b1});
        BugMassEditController  controller = new BugMassEditController(setCtr); 
        
        try{
            controller.bugId = null;
            controller.callHttpRequest();
        }
        
        catch(exception e){
        
        }
    }
    static testMethod void massupdateCustomSetting() {
        Id pdkRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
        bug__c b = new bug__c();

        bug__c b1 = new bug__c();
        b1.Bug_Title__c = 'test abc';
        b1.Product_technology__c = '110G';
        b1.Component__c = 'DFM';
        b1.Version__c = 'unspecified';
        b1.recordtypeid= pdkRecordTypeId;
        insert b1;
        List<Bug__c> bugList = [SELECT name FROM Bug__c LIMIT 20];
        test.starttest();
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(bugList);

        setCtr.setSelected(new Bug__c[]{b1});
        BugMassEditController  controller = new BugMassEditController(setCtr);
        
        BugStatusResolutionMapping__c CustomSetting = new BugStatusResolutionMapping__c();
        CustomSetting.Resolution__c = 'test';
        CustomSetting.name = 'Closed';
        insert CustomSetting;
        
        controller.ststatus = 'Closed';
        controller.getResolution();
        controller.chatterComment = 'chatter';
        controller.step4();
    }

}