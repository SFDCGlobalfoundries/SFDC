/*
Author: Bhavana Mohan
Company: Cognizant
Description: PTRF_SWIFT_BUPD
History:
created     27/6/2014     
*/

trigger PTRF_SWIFT_BUPD on PTRF__c (before update) 
{
    
    Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
    String pname = p.name;
    for(PTRF__c ptrf : Trigger.new)
    {
    
    
     if(Trigger.oldMap.get(ptrf.id).Status__c == 'Perform Tapeout Options'  && ptrf.status__c=='Open' && pname.tolowercase().indexof('integration')!=-1){
         ptrf.addError('PTRF status cannot be changed from Perform Tapeout Options to Open.');
     }
     if(Trigger.oldMap.get(ptrf.id).Frame_Status__c != Trigger.newMap.get(ptrf.id).Frame_Status__c && (Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Complete' || Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Completed'))
        {
          // ptrf.FG_Start_Completed__c = True;
           ptrf.Frame_Status__c = 'Completed';    
          
        }
        
        if(Trigger.oldMap.get(ptrf.id).Frame_Status__c != Trigger.newMap.get(ptrf.id).Frame_Status__c && (Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Frame Generation' ||  Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Rerun'))
        {
             ptrf.Frame_Status__c = 'Frame Generation';    
            
        }
       // if(Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Completed' && (Trigger.oldMap.get(ptrf.id).Frame_Status__c == 'Frame Generation' || Trigger.oldMap.get(ptrf.id).Frame_Status__c == 'Rerun'))
        //{
       // ptrf.Frame_Status__c = 'Frame Generation'; 
       // }
        if(Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c != Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c &&(Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'Completed' || Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'Complete'))
        {
          ptrf.DRC_DRW_Status__c = 'Completed'; 
         }
        
        if(Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c != Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c &&( Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'DRW' || Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'Start'))
        {
          ptrf.DRC_DRW_Status__c = 'DRW';
        }
        if(Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c == 'Completed' && (Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'Start' || Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'DRW'))
        {
        ptrf.DRC_DRW_Status__c = 'Completed'; 
        }
    }
     
}