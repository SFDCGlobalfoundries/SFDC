/*
Type Name: Maskshop_Configuration_SWIFT_BUPD 
Author: Cognizant 
Created Date: 05/23/2014
Reason: This trigger will be fired before update of any Maskshop Configuration record.
            It checks Maskshop Alias. If modified alias is already present in any Maskshop Configuration record, then
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
trigger Maskshop_Configuration_SWIFT_BUPD on Maskshop_Configuration__c (before update) {

    set<string> setMCAll=new set<string>();
    
    for(Maskshop_Configuration__c objMC:[select name from Maskshop_Configuration__c]){
        setMCAll.add(objMC.name);
    }    

   for(Maskshop_Configuration__c obj:trigger.new){
  
    if(Trigger.oldMap.get(obj.Id).name!=Trigger.newMap.get(obj.Id).name)
    {
        if(setMCAll.contains(obj.name))
        {
            obj.addError('Error: Maskshop Alias (' + obj.name + ') exists in Maskshop Released Notification Distribution List Table. Please re-specify');
        }

    }
    }
}