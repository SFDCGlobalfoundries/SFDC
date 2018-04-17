/*
    Author: Ariz Solito
    Description: Apex test class for VCIDConversionBatch
    History: 
        Asolito     07/23/2013    - Code creation.
*/
@isTest//(SeeAllData=false)    
public with sharing class VCIDConversionBatch_Test {

    //test method for the class     
    static testMethod void testClass(){     
        Test.startTest();
        
        IP_VCID_Sub_Component__c subComp = new IP_VCID_Sub_Component__c(
            CRM_DID__c = '1234567890-TEST',
            processID__c = '12345',
            vendor__c = 'test vendor',
            library__c = 'subComp1',
            technology__c = '0.014'
        ); 
        insert subComp;
        
        String query = 'SELECT id,CRM_DID__c,processID__c,technology__c,library__c,vendor__c, '+
                       '        customer__c,converted_IP_VCID_Component__c '+
                       '  FROM IP_VCID_Sub_Component__c '+
                       '  WHERE id = \''+ subComp.id + '\'';

        //Call the conversion batch
        VCIDConversionBatch job = new VCIDConversionBatch(query);
        Database.executebatch(job,10);
        
        Test.stopTest();
    }                               
}