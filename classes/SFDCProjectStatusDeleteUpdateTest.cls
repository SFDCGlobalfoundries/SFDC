/*
    Author: Art
    Created Date: Mar/28/2013 
    Description: Test class for SFDCProjectStatusDeleteUpdate
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectStatusDeleteUpdateTest{

    static testMethod void doTest1(){
        test.startTest();
       SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        Date weekEndingDate = Date.newInstance(2013,1,15);
        SFDC_Project_Status__c newProStatus = new SFDC_Project_Status__c(Week_Ending_Date__c = weekEndingDate);
        newProStatus.Project__c = newPro.id;
        
        insert newProStatus;
        
        newProStatus.Week_Ending_Date__c = Date.newInstance(2013,1,25);
        try
        {
          update newProStatus;
          System.assert(false,'update should fail');
        }catch(Exception expected){}
        
        weekEndingDate = Date.newInstance(2013,2,15);
        newProStatus = new SFDC_Project_Status__c(Week_Ending_Date__c = weekEndingDate);
        newProStatus.Project__c = newPro.id;
        
        insert newProStatus;
        try
        {
        delete newProStatus;
        System.assert(false,'delete should fail');
        }catch(Exception expected){}
        test.stopTest();

    }
}