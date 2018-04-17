/*
Type Name: Maskshop_Configuration_SWIFT_BINS 
Author: Cognizant 
Created Date: 5/23/2014
Reason: This trigger will be fired before insertion of any Maskshop Configuration record.
            It checks Maskshop Alias. If specified name is already present in any  Maskshop Configuration record, then
            this trigger would prompt the system to re-specify a new name and would not let the system save the data.
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/
trigger Maskshop_Configuration_SWIFT_BINS on Maskshop_Configuration__c (before insert) {

    set<string> setMCAll=new set<string>();
    
    for(Maskshop_Configuration__c objMC:[select name from Maskshop_Configuration__c]){
        setMCAll.add(objMC.name);
    }    
    for(Maskshop_Configuration__c objMC:trigger.new){
        if(setMCAll.contains(objMC.name))
        {
            objMC.addError('Error: Maskshop Alias (' + objMC.name + ') exists in Maskshop Released Notification Distribution List Table. Please re-specify');
        }
    }
}