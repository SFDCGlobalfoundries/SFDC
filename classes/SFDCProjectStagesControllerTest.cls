/*
    Author: Win
    Created Date: Feb/22/2013 
    Description: Test class for SFDCProjectStagesController
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectStagesControllerTest{

    static testMethod void doTest(){
        test.startTest();
        
        SFDC_Project__c proj = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert proj;
        
        SFDC_Project_Stage__c stage = new SFDC_Project_Stage__c(Name='User Request',Name__c='User Request',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage.Start_Date__c = Date.newInstance(2013,1,1);
        stage.End_Date__c = Date.newInstance(2013,1,30);
        insert stage;
        
        SFDC_Project_Stage__c stage2 = new SFDC_Project_Stage__c(Name='Approved for Assessment',Name__c='Approved for Assessment',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage2.Start_Date__c = Date.newInstance(2013,2,1);
        stage2.End_Date__c = Date.newInstance(2013,2,28);
        insert stage2;
        
        SFDC_Project_Stage__c stage3 = new SFDC_Project_Stage__c(Name='Assessment & Vendor Evaluation',Name__c='Assessment & Vendor Evaluation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage3.Start_Date__c = Date.newInstance(2013,3,1);
        stage3.End_Date__c = Date.newInstance(2013,3,30);
        insert stage3;
        
        SFDC_Project_Stage__c stage4 = new SFDC_Project_Stage__c(Name='Recommendation',Name__c='Recommendation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage4.Start_Date__c = Date.newInstance(2013,4,1);
        stage4.End_Date__c = Date.newInstance(2013,4,28);
        insert stage4;
        
        SFDC_Project_Stage__c stage5 = new SFDC_Project_Stage__c(Name='Approved for Implementation',Name__c='Approved for Implementation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage5.Start_Date__c = Date.newInstance(2013,5,1);
        stage5.End_Date__c = Date.newInstance(2013,5,28);
        insert stage5;
        
        SFDC_Project_Stage__c stage6 = new SFDC_Project_Stage__c(Name='Implementation Planning',Name__c='Implementation Planning',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage6.Start_Date__c = Date.newInstance(2013,6,1);
        stage6.End_Date__c = Date.newInstance(2013,6,28);
        insert stage6;
        
        SFDC_Project_Stage__c stage7 = new SFDC_Project_Stage__c(Name='Implementation',Name__c='Implementation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage7.Start_Date__c = Date.newInstance(2013,7,1);
        stage7.End_Date__c = Date.newInstance(2013,7,28);
        insert stage7;
        
        SFDC_Project_Stage__c stage8 = new SFDC_Project_Stage__c(Name='Build & Destroy',Name__c='Build & Destroy',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage8.Start_Date__c = Date.newInstance(2013,8,1);
        stage8.End_Date__c = Date.newInstance(2013,8,28);
        insert stage8;
        
        SFDC_Project_Stage__c stage9 = new SFDC_Project_Stage__c(Name='Post-Deployment Review',Name__c='Post-Deployment Review',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage9.Start_Date__c = Date.newInstance(2013,9,1);
        stage9.End_Date__c = Date.newInstance(2013,9,28);
        insert stage9;
        
        SFDC_Project_Stage__c stage10 = new SFDC_Project_Stage__c(Name='Complete',Name__c='Complete',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage10.Start_Date__c = Date.newInstance(2013,10,1);
        stage10.End_Date__c = Date.newInstance(2013,10,28);
        insert stage10;
        
        
        PageReference pr = new PageReference('/apex/SFDCProjectStages?id='+proj.id);
        Test.setCurrentPage(pr);
        
        SFDCProjectStagesController controller = new SFDCProjectStagesController();
        
        controller.Cancel();
        controller.Save();
        test.stopTest();
    }
    
    
    static testMethod void doTestSkipError(){
        test.startTest();
        
        SFDC_Project__c proj = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert proj;
        
        SFDC_Project_Stage__c stage = new SFDC_Project_Stage__c(Name='User Request',Name__c='User Request',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = true);
        stage.Start_Date__c = Date.newInstance(2013,1,1);
        stage.End_Date__c = Date.newInstance(2013,1,30);
        insert stage;
        
        SFDC_Project_Stage__c stage2 = new SFDC_Project_Stage__c(Name='Approved for Assessment',Name__c='Approved for Assessment',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage2.Start_Date__c = Date.newInstance(2013,2,1);
        stage2.End_Date__c = Date.newInstance(2013,2,28);
        insert stage2;
        
        SFDC_Project_Stage__c stage3 = new SFDC_Project_Stage__c(Name='Assessment & Vendor Evaluation',Name__c='Assessment & Vendor Evaluation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage3.Start_Date__c = Date.newInstance(2013,3,1);
        stage3.End_Date__c = Date.newInstance(2013,3,30);
        insert stage3;
        
        SFDC_Project_Stage__c stage4 = new SFDC_Project_Stage__c(Name='Recommendation',Name__c='Recommendation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage4.Start_Date__c = Date.newInstance(2013,4,1);
        stage4.End_Date__c = Date.newInstance(2013,4,28);
        insert stage4;
        
        SFDC_Project_Stage__c stage5 = new SFDC_Project_Stage__c(Name='Approved for Implementation',Name__c='Approved for Implementation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage5.Start_Date__c = Date.newInstance(2013,5,1);
        stage5.End_Date__c = Date.newInstance(2013,5,28);
        insert stage5;
        
        SFDC_Project_Stage__c stage6 = new SFDC_Project_Stage__c(Name='Implementation Planning',Name__c='Implementation Planning',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage6.Start_Date__c = Date.newInstance(2013,6,1);
        stage6.End_Date__c = Date.newInstance(2013,6,28);
        insert stage6;
        
        SFDC_Project_Stage__c stage7 = new SFDC_Project_Stage__c(Name='Implementation',Name__c='Implementation',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage7.Start_Date__c = Date.newInstance(2013,7,1);
        stage7.End_Date__c = Date.newInstance(2013,7,28);
        insert stage7;
        
        SFDC_Project_Stage__c stage8 = new SFDC_Project_Stage__c(Name='Build & Destroy',Name__c='Build & Destroy',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage8.Start_Date__c = Date.newInstance(2013,8,1);
        stage8.End_Date__c = Date.newInstance(2013,8,28);
        insert stage8;
        
        SFDC_Project_Stage__c stage9 = new SFDC_Project_Stage__c(Name='Post-Deployment Review',Name__c='Post-Deployment Review',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage9.Start_Date__c = Date.newInstance(2013,9,1);
        stage9.End_Date__c = Date.newInstance(2013,9,28);
        insert stage9;
        
        SFDC_Project_Stage__c stage10 = new SFDC_Project_Stage__c(Name='Complete',Name__c='Complete',SFDC_Project__c = proj.id, Completed__c = false, Skip__c = false);
        stage10.Start_Date__c = Date.newInstance(2013,10,1);
        stage10.End_Date__c = Date.newInstance(2013,10,28);
        insert stage10;
        
        
        
        PageReference pr = new PageReference('/apex/SFDCProjectStages?id='+proj.id);
        Test.setCurrentPage(pr);
        
        SFDCProjectStagesController controller = new SFDCProjectStagesController();
        
        //controller.Cancel();
        controller.Save();
        test.stopTest();
    }
    
    
    static testMethod void doTestStageCompletion(){
        test.startTest();
        SFDCProjectStagesController controller = new SFDCProjectStagesController();
        
        //initialize variables, populate data structures
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        controller.Project = newPro;
        
        SFDC_Project_Stage__c newStage = new SFDC_Project_Stage__c(Name='Test Stage',Name__c='User Request');
        insert newStage;
        System.assert(newStage != null);
        newStage.SFDC_Project__c = newPro.id;
        update newStage;
        controller.Stages.add(newStage);
        
        try {
            //newStage.Start_Date__c = Date.newInstance('4/27/2013'); //test end date < start date. //date.parse('4/27/2013'); mm/dd/yyyy. 
            newStage.Start_Date__c = Date.newInstance(2013,27,4);
            newStage.End_Date__c =  Date.newInstance(2013,27,5); // date.parse('3/27/2013');
            update newStage;
            //controller.Save();
        } catch (DmlException e) {
            //Assert Error Message
            System.assert( e.getMessage().contains('Stage: User Request, End Date of 2013-03-27 00:00:00 cannot be less than Start Date of 2013-04-27 00:00:00'));
        }
        newStage.Start_Date__c = date.newInstance(2013,27,4); //test end date < start date. //date.parse('3/27/2013');
        newStage.End_Date__c = Date.newInstance(2013,27,5);   //date.parse('5/27/2013');          
        newStage.Completed__c = Boolean.valueOf('true');
        update newStage;
        System.debug('win: newStage='+newStage);
        controller.Save();
        test.stopTest();
    }
    
    

}