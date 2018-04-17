/*Author: SREEDHAR KARUKONDA
    Description: This trigger dose nothing... Legacy code... We can not remove code element in FASTDEPLOY.. So I am keeping this, otherwise we can delete.   
    History:
    02102014	- Removed all logic from this trigger and added a statement to get code coverage 
*/
trigger DeviceChecklistTaskRayTaskTrigger on TASKRAY__Project_Task__c (after insert) {
	//To get code Coverage
	boolean nothing = true;
}