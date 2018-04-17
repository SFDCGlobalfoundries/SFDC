trigger ComponentTeamTrigger on Component_team__c (before insert) {
    //before isnsert method sets the WR lookup from PDK
    
    if(trigger.isinsert)
           new WorkRequestTriggerHandler().SetWRNoforComponentTeam(trigger.new);
}