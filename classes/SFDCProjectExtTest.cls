/*
    Author: Win
    Description: Test class for SFDCProjectExt
    Test cases: 
    1. Test findCurrentStage with return of stage result.
    2. Test findCurrentStage with return null.
    3. Test findCurrentStage with Completed stage conditions.
    4. Test Trigger SFDCProjectBeforeInsertUpdate for error.
    5. Test Trigger SFDCProjectInsertUpdate with User having role 'IT Project Manager'.
    6. Test Trigger SFDCProjectBeforeDelete.
*/

@isTest
public class SFDCProjectExtTest{

    //test #1.
    static testMethod void doTestReturnStageResult(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Stage__c newStage = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='User Request');
        insert newStage;
        System.assert(newStage != null);
        newStage.SFDC_Project__c = newPro.id;
        update newStage;
        
        //newPro.Current_Stage__c = newStage.id;
        //update newPro;
        
        SFDC_Project_Milestone__c milestone = new SFDC_Project_Milestone__c (Name='Test Milestone', Stage__c = newStage.id);
        insert milestone;
        //System.assert(milestone != null);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newPro);
        SFDCProjectExt sfdcProjectExt = new SFDCProjectExt (controller);
        
        System.assertEquals(sfdcProjectExt.CurrentStageName, 'Test Stage');
        System.assertEquals(sfdcProjectExt.CurrentMilestoneName , 'Test Milestone');
        delete newPro; //extended test to Trigger SFDCProjectBeforeDelete.
        
        test.stopTest();
    }
    
    //test #2.
    static testMethod void doTestReturnNullStageResult(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Stage__c newStage = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='Invalid Stage Name');
        insert newStage;
        System.assert(newStage != null);
        newStage.SFDC_Project__c = newPro.id;
        update newStage;
        
        SFDC_Project_Milestone__c milestone = new SFDC_Project_Milestone__c (Name='Test Milestone', Stage__c = newStage.id);
        insert milestone;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newPro);
        SFDCProjectExt sfdcProjectExt = new SFDCProjectExt (controller);
        
        System.assertNotEquals(sfdcProjectExt.CurrentStageName, 'Test Stage');
        //System.assertEquals(sfdcProjectExt.CurrentMilestoneName , 'Test Milestone');
        
        test.stopTest();
    }
    
    //test #3.
    static testMethod void doTestCompletedStage(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Stage__c newStage = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='User Request');
        insert newStage;
        System.assert(newStage != null);
        newStage.SFDC_Project__c = newPro.id;
        newStage.Completed__c = Boolean.valueOf('true');
        update newStage;
        
        SFDC_Project_Milestone__c milestone = new SFDC_Project_Milestone__c (Name='Test Milestone', Stage__c = newStage.id);
        insert milestone;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newPro);
        SFDCProjectExt sfdcProjectExt = new SFDCProjectExt (controller);
        
        System.assertEquals(sfdcProjectExt.CurrentStageName, 'Test Stage');
        //System.assertEquals(sfdcProjectExt.CurrentMilestoneName , 'Test Milestone');
        
        test.stopTest();
    }
    
    //test #4.
    static testMethod void doTestSFDCProjectBeforeInsertUpdate(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=100);
        
        try {
            insert newPro;
        } catch (DmlException e) {
            //Assert Error Message
            System.assert( e.getMessage().contains('Priority Sequence value cannot be greater than the total number of SFDC Projects num_projects'));                  
        }
        
        test.stopTest();
    }
    
    //test #5.
    static testMethod void doTestSFDCProjectInsertUpdate(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        SFDC_Project_Member__c newMember = new SFDC_Project_Member__c(SFDC_Project__c=newPro.id);
       /* List<User> userList = [SELECT Id FROM User WHERE IsActive = true and User.Profile.Name = 'System Administrator' LIMIT 1];*/
    
        List<User> userList = [SELECT Id FROM User WHERE IsActive = true and User.Profile.Name = 'GF Integration' LIMIT 1];
        User u = userList.get(0);
        newMember.User__c = u.id;
        newMember.Role__c = 'IT Project Manager';
        insert newMember;
        
        System.debug('win: newMember='+newMember);
        update newPro;
        
        //extended the test to update logic in Trigger "SFDC_Project_Member_Update" by updating the Role.
        newMember.Role__c = 'IT Project Manager - new';
        update newMember;
        
        //extended the test to delete logic in Trigger "SFDCProjectMemberTrigger" by deleting the member.
        SFDC_Project_Member__c dupMember = newMember.clone();
        insert dupMember;
        //runAs admin.
        System.runAs(u){ 
            SFDC_Project__Share trs = 
                new SFDC_Project__Share(ParentId=dupMember.SFDC_Project__c, UserOrGroupId=dupMember.User__c,AccessLevel = 'Read');
            insert trs;
            dupMember.Access__c = 'Read/Write';
            update dupMember;
        }
        delete dupMember;
        
        test.stopTest();
    }
    
    //test #6.
    static testMethod void SFDCProjectBeforeDelete(){
        test.startTest(); //start new governor limit
        
        //initialize variables, populate data structures
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        delete newPro;
        
        test.stopTest();
    }
}