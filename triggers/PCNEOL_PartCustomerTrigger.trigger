/*    
  Author:  Global Foundries
  Description: This trigger is calling two methods in Handler Class SendTriggerEmail method(Sends Email to portal user ) & SendEmailtoPrimarys method(Sends Email to all Primarys)
  History:  
  Change History:
  Modified On:
  Reason: 
*/

trigger PCNEOL_PartCustomerTrigger on PCN_EOL__c (After update){
    Set<Id> pcneolIds = new Set<Id>();
     
    for(PCN_EOL__c pcneol: Trigger.new){
        if(Trigger.isUpdate)
        {
          if(Trigger.IsAfter){
           if(pcneol.LODNotify1__c==true || pcneol.LODNotify2__c==true || pcneol.LODNotify2__c==true){
                PCNEOL_EmaiHandler.sendTriggerEmail(pcneol);
            }
           if(pcneol.EOL_Stage__c=='Awaiting BU Program Mgr Approval'){
                PCNEOL_EmaiHandler.SendEmailtoPrimarys(pcneol);
           }
          }
        }
      }
}