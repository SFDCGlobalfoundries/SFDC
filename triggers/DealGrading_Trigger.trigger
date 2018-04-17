/*Type name: DealGrading_Trigger
Author: Vijay Vemuru
Description: This is a Trigger on DealGrading object 
History: 5/2/2016    - Code creation */
trigger DealGrading_Trigger on Deal_Grading__c (After update, After insert, Before update, before insert) {

    if(!IntegrationUserUtil.isSkipTrigger()) {
                    
       //After Insert/Update
		if(trigger.isInsert && Trigger.IsBefore) {
	   		DealGrading_Only1DGPerOPP.Only1DgPerOpp2(Trigger.new);  //call this method to make sure that we have only 1 Deal grading per Oppty
		}
        if((Trigger.Isupdate || Trigger.IsInsert) && Trigger.IsAfter){
            DealGrading_UpdateDGOnOPP.updateOPP(Trigger.new);  //calls the method to update fields from Deal Grading to OPP
        
            if(trigger.isInsert) {
                List<opportunity> oppList = new List<Opportunity>(); 
                for(Deal_Grading__c dg : trigger.new){
                    if(dg.Deal_Grading_status__c != 'Previously Approved'){
                        oppList.add(new opportunity(id=dg.opportunity1__c,Deal_Grading_Status__c= 'Draft'));                    
                    } else {
                        oppList.add(new opportunity(id=dg.opportunity1__c,Deal_Grading_Status__c= dg.Deal_Grading_status__c));
                    }
                }
                
                if(!oppList.isEmpty()){
                    update oppList;
                }
            }                      
       }       
       if(trigger.isbefore && trigger.isInsert) {
            DealGrading_ClipLevel cl=new  DealGrading_ClipLevel();      //calling the class to implement clip level
                    cl.Implementcliplevel(Trigger.new);
       }                                                                                                 
            
        if(Trigger.IsUpdate && Trigger.IsBefore){
           DealGrading_ClipLevel cl=new  DealGrading_ClipLevel();
           cl.Implementcliplevel(Trigger.new);
    
           DealGrading_CreateSnapShot.DeleteExistingSnapshot(Trigger.New,trigger.oldmap); //Call this method to delete existing snapshots to avoid dulication of records
           DealGrading_CreateSnapShot.createSnapshot(trigger.new,trigger.oldMap); //call the method to create a snapshot from Quaterly Revenue        
         }
    } 
}