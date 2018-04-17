/*************************************************************************************************************************************************************
@ Class:          Waiver_TriggerHandler
@ Version:        1.0
@ Author:         Mallika
@ Purpose:        This Handler class is handling the events of Waiver Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
**************************************************************************************************************************************************************/
public class Waiver_TriggerHandler extends TriggerHandler{
   
    public Waiver_TriggerHandler(){
       
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Mallika
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/    
    public override void afterUpdate(){
        
        if(trigger.isupdate){
          for(Waivers__c Waiver: (List<Waivers__c>)trigger.new)
          {
           if((Waiver.Approval_Status__c == 'Approved')&& (Waiver.Waiver_Applied_to_with_values_as_below__c=='' || Waiver.Waiver_Applied_to_with_values_as_below__c==null))  {
        
           Waiver.addError('please fill required field for approval Waiver applied quality level Steps to follow > Click Back button > Cancel Waiver approval > Unlock record > fill Waiver applied quality level as P level Only/All');
         
           }
          }
        
        }
      
        
    }
}