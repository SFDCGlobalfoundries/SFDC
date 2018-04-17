/*
Author:  Yash Kumar
    Description: Creates Opportunity Process test class 
    
    History:
        Yashkumar 12052013    - code creation.
*/

@isTest
private class GetOpportunityProcessTest {

   
     static testMethod void OpportunityProc() {
      test.startTest();
        
        
            OpportunityProcess__c oppprces =new OpportunityProcess__c();
          
            oppprces.Geometry__c ='0.028UM';
                    oppprces.Process_Family__c ='Super Low Power';
                    oppprces.FAB__c ='FAB 1';
                    oppprces.Process_ID__c='434-343-34';
                    
            
            
            insert oppprces;
            
     
     }
    

}