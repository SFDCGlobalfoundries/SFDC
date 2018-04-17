/*
    Author:         Tanuka Sengupta
    Description:    Utility apex class for Account Region field update of Device and Opportunity Program object
    History: 
    TSeng           25052013    -     Apex code created
    TSeng           04062013    -     Apex code modified
    TLai			25062013	-	  Apex code modifeid
*/

public with sharing class AccountChangeRegionUtil { 
    /*
    This asynchrounous method updates the Account Region field of Opportunity Program and 
    Device records of the current account with the Region value
    */
    @future
    public static void regionChangeAction(Id currentAccountId) {
        Account currentAccount = [Select Id,
                                         Name,
                                         Region__c
                                    From Account
                                   Where Id =: currentAccountId];
                                   
        List<Opportunity_Program__c> childOppPrograms = [Select Id,
                                                                Account__r.Id,
                                                                SetGroup__c
                                                                From Opportunity_Program__c
                                                                Where Account__r.Id =: currentAccount.Id];
        
        List<Device__c> childDevices =  [Select Id,
                                                Account__r.Id,
                                                SetGroup__c
                                                From Device__c
                                                Where Account__r.Id =: currentAccount.Id];    
        if(childOppPrograms != null) {                                 
            for(Opportunity_Program__c childOppProgram : childOppPrograms) {
                childOppProgram.SetGroup__c = currentAccount.Region__c;
            }
            
            system.debug('DEBUG:++ >> ' + childOppPrograms);
            update childOppPrograms;
        }
        
        if(childDevices != null) {                                 
            for(Device__c childDevice : childDevices) {
                childDevice.SetGroup__c = currentAccount.Region__c;
            }
              
            system.debug('DEBUG:++ >> ' + childDevices);
            update childDevices;
        }                                                  
    }
}