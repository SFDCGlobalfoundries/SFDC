/**
    Class Name:    MultiplePIDDeviceUpdateTriggerHandler 
    Author:        Prosenjit Saha(PS)
    Description:   This class handles multiple PID assignment. called from DeviceUpdateTrigger.
                        * if assigned process ID in device is updated then this class will start its' operation.  
                        * if assigned PID in device level is not present in the assigned processes present under a particular device,
                          then insert this PID under that device as a primary process. 
                        * if assigned PID in the device level is already present in the assigned processes present under a device,
                          ,then update that assigned process as primary process.
                        * if a process is marked as a primary process under a device other than the assigned process ID, then make 
                          that assigned process as non-primary assigned process. 
    History: 
        PSaha    12102013    - Code creation.
        TLai     02102014    - Change logic when PID reassigned.
    
**/
public class MultiplePIDDeviceUpdateTriggerHandler{
    
    /**
    @Method Name:    multiplePIDassignmentMethod
    @Return Type:    void
    @parameter:      DeviceList = trigger.new AND OldDeviceMap = trigger.oldMap AND NewDeviceMap = trigger.newMap
    @Reason:         This method handles multiple PID assignment
    **/
    public void multiplePIDassignmentMethod(List<Device__c> DeviceList , Map<id,Device__c> OldDeviceMap , Map<id,Device__c> NewDeviceMap){
        //declaring variables 
        set<Assigned_Process__c> UpdateAssignedProcessSet = new set<Assigned_Process__c>(); //set of assigned process to update 
        Set<Assigned_Process__c> InsertAssignedProcessSet = new Set<Assigned_Process__c>(); //set of assigned process to insert 
        List<Assigned_Process__c> UpdateAssignedProcessList = new List<Assigned_Process__c>(); //List of assigned process to update 
        List<Assigned_Process__c> InsertAssignedProcessList = new List<Assigned_Process__c>(); //List of assigned process to insert 
        /***map of deive id vs Map of process id vs assigned process Map<DeviceID,Map<processID,assignedProcessRecord>> ***/
        Map<ID,Assigned_Process__c> mapDeviceIDvsProcess = new Map<ID, Assigned_Process__c>();
        
        //generating mapDeviceIDvsProcess. 
        for(Assigned_Process__c ap : [SELECT    id,
                                                Device__c,
                                                Primary_Process__c,
                                                Process__c
                                      FROM      Assigned_Process__c
                                      WHERE     Device__c
                                      IN        :DeviceList
                                      	AND		Primary_Process__c = true]){

        	mapDeviceIDvsProcess.put(ap.Device__c,ap);
        }//end of for loop.
        
        //following loop identifies the update set and insert set of the assigned process 
        for(Device__c dev : DeviceList){
        
            //if assigned PID value has been changed in the device level then proceed. 
            if( dev.Assigned_Process_ID__c != NULL && 
                NewDeviceMap.get(dev.id).Assigned_Process_ID__c != OldDeviceMap.get(dev.id).Assigned_Process_ID__c ){
                
                //if this process ID is not present in the assigned process records created under a particular device.
                if(mapDeviceIDvsProcess.containsKey(dev.id)){
                	Assigned_Process__c ap = mapDeviceIDvsProcess.get(dev.id);
                	ap.Process__c = dev.Assigned_Process_ID__c;
                	ap.Primary_Process__c  = true;

                	UpdateAssignedProcessSet.add(ap);
                	
                }else {
                    //creating temp assigned process data to add in the assigned  process insert set
                    Assigned_Process__c ap = new Assigned_Process__c();
                    ap.Device__c           = dev.id;
                    ap.Process__c          = dev.Assigned_Process_ID__c;
                    ap.Primary_Process__c  = true;

                    InsertAssignedProcessSet.add(ap);
                } 
                
            }//end of if
        }//end of for loop
        
        //as set can't be used in DML operations.
        UpdateAssignedProcessList.addAll(UpdateAssignedProcessSet);
        InsertAssignedProcessList.addAll(InsertAssignedProcessSet);
        
        //following block insert assigned process records.
        if(InsertAssignedProcessList != NULL){
            Database.insert(InsertAssignedProcessList, false); //inserting assigned process 
        }
        
        //following block update assigned process records.
        if(UpdateAssignedProcessList != NULL){
            Database.SaveResult[] srList = Database.update( UpdateAssignedProcessList,false); //updating assigned process
        }
    }//end of method.


}