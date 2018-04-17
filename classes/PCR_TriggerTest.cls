/*
    Author: 
    Description: This is the test class for PCR_Trigger(POR_Change_Review__c). 
    History:
        Yash kumar        07082014    - Created a new trigger test class.
*/ 
@isTest
public class PCR_TriggerTest{

    static testMethod void doTestPCR_Trigger(){
        test.startTest();
        GMPL_BX009__c GMPL= new GMPL_BX009__c(Geometry__c='20',Project__c='test Project',Family__c='LPM',Variant__c='CV04',Product_Start_Date__c='2011');
        insert GMPL;
                
        POR_Change_Review__c POR= new  POR_Change_Review__c(PCR_Status__c='Open',PC_Review_Date__c=system.today(),Program_Affected__c=GMPL.id,Change_Level__c='test');
        insert POR;
        POR_Change_Review__c POR1= new  POR_Change_Review__c(PCR_Status__c='Closed',PC_Review_Date__c=system.today(),Program_Affected__c=GMPL.id,Change_Level__c='test');
        insert POR1;
        POR_Change_Review__c POR2= new  POR_Change_Review__c(PCR_Status__c='BCCB Review',PC_Review_Date__c=system.today(),Program_Affected__c=GMPL.id,Change_Level__c='test');
        insert POR2;
        test.stopTest();

    }

}