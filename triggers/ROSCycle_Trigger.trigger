trigger ROSCycle_Trigger on ROS_Cycle__c (before Insert,before update,after update,after insert){

    if(System.Label.IsActive_ROSCycle_Trigger.equalsIgnoreCase('true')){
        
        if(Trigger.isInsert && Trigger.isBefore){
            List<ROS_Cycle__c> lstExistingCycles = new List<ROS_Cycle__c>();
            Set<ROS_Cycle__c> setNewROScycles   = new Set<ROS_Cycle__c>();
            lstExistingCycles = [select id,name,Cycle_Start_Date__c, Cycle_End_Date__c from ROS_Cycle__c];
            
            for(ROS_Cycle__c existingROScycle: lstExistingCycles){
                if(existingROScycle.Cycle_End_Date__c == NULL){
                    for(ROS_Cycle__c rosCycle:Trigger.new){
                        rosCycle.addError('Current cycle is still open. Please close the same to automatically create a new Cycle.');
                    }
                    break;
                }
            }
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            String cycleName;
            Date StartDate;
            Set<String> setExistingCycles = new Set<String>();
            
            for(ROS_Cycle__c existingROScycle: Trigger.new){
                if(existingROScycle.Cycle_End_Date__c != NULL && Trigger.oldMap.get(existingROScycle.Id).Cycle_End_Date__c == NULL){
                    cycleName = existingROScycle.Next_cycle_Name__c;
                    StartDate = existingROScycle.Cycle_End_Date__c+1;
                }
            }
            if(cycleName != NULL && StartDate != NULL){
                for(ROS_Cycle__c existingCycle: [select id,name from ROS_Cycle__c]){
                    setExistingCycles.add(existingCycle.name);
                }
                if(setExistingCycles.contains(cycleName)){
                    for(ROS_Cycle__c cycleRec: Trigger.new){
                        cycleRec.addError('Cycle already exists with the same name as mentioned in Next Cycle Name.');
                    }
                }else{
                    ROS_Cycle__c newROSCycle = new ROS_Cycle__c();
                    newROSCycle.Name = cycleName ;
                    newROSCycle.Cycle__c = cycleName ;
                    newROSCycle.Cycle_Start_Date__c = StartDate ;
                    newROSCycle.Cycle_End_Date__c = NULL;
                    insert newROSCycle;
                }
            }
        }
        
    }
}