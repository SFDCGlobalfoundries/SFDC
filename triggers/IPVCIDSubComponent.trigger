/*
    Author: Ariz Solito
    Description: Apex trigger IP declaration form matching and VCID Component conversion
    History: 
    Asolito      07/01/2013    - Apex coded created
*/
trigger IPVCIDSubComponent on IP_VCID_Sub_Component__c (after insert, after update, before insert, before update) {

    if(Trigger.isAfter){    
        //call conversion method
        if(!VCIDComponentConversion.hasConversionRun){
            List<String> processRecs = new List<String>();  
            for(IP_VCID_Sub_Component__c t: trigger.new){
                processRecs.add(t.id);
            }       
            VCIDComponentConversion.convertToVCIDComponent(processRecs);            
        }
    }
}