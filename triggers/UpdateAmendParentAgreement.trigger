/*
Type Name:Parent agreement assocition process
Author: Cognizant
Created Date: 6 -Mar-2014
Reason: This is the trigger for populate the parent agreement association. 
Test Class: ClsCaseAssignmentProcessHandlerTest
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger UpdateAmendParentAgreement on Apttus__APTS_Related_Agreement__c (after insert,after update) {

  Set<Id> relatedArmntIds = trigger.newMap.keySet();
  
  //get the Agreement details based on the Releated Agreements 
  Map<Id, Apttus__APTS_Agreement__c > mapArmnt = new Map<Id, Apttus__APTS_Agreement__c > ([SELECT Id,Apttus__FF_Agreement_Number__c,Apttus__Parent_Agreement__c 
                                                FROM Apttus__APTS_Agreement__c where Id IN(SELECT Apttus__APTS_Contract_To__c FROM Apttus__APTS_Related_Agreement__c 
                                                WHERE Id IN :relatedArmntIds )]);               
                     
        List<Apttus__APTS_Agreement__c> lstAgrmntUpdate = new List<Apttus__APTS_Agreement__c>();
        
     //loop through the Related Agreement and update the Parent Agreement        
        for(Apttus__APTS_Related_Agreement__c relatedArmnt : Trigger.new){
        
           Apttus__APTS_Agreement__c armnt  = mapArmnt.get(relatedArmnt.Apttus__APTS_Contract_To__c);
          
             if(armnt != null){ 
                 //armnt.Apttus__Parent_Agreement__c = relatedArmnt.Agreement_from_ID__c; 
                 armnt.Apttus__Parent_Agreement__c = relatedArmnt.Apttus__APTS_Contract_From__c; 
                 lstAgrmntUpdate.add(armnt );
             }
          }
    // Update the Agreement details with Parent Agreement 
    try{
        if(lstAgrmntUpdate.size()>0 ){ 
                update lstAgrmntUpdate;
           }
     }
    
   catch (Exception e){
    for(Apttus__APTS_Agreement__c ar : lstAgrmntUpdate) { ar.addError('The following exception has occurred: ' + e.getMessage()); }  
     }          
  
}