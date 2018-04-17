/*
Author: Niharika Modi
Description: Apex class for scheduling ERPDeviceWithPartsHubBatch
Created Date: 17th April,2017
*/
global class ERPDeviceWithPartsHubScheduler implements Schedulable{

    global void execute(SchedulableContext SC){
    	ERPDeviceWithPartsHubBatch bc=new ERPDeviceWithPartsHubBatch();
    	Database.executeBatch(bc);
    }
    
    //for testing purpose through devconsole
    //global ERPDeviceWithPartsHubScheduler(){ 
    //	ERPDeviceWithPartsHubBatch bc=new ERPDeviceWithPartsHubBatch();
    //	Database.executeBatch(bc,50);
    //}
}