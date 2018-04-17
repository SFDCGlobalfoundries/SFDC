/*
*@ Author		:- Navneet Rajput 
*@ Company		:- Cognizant technology
*@ Date			:- 26/06/2014
*@ Description	:- Scheduler for documentProvisioningBatchableCls, It helps to schedule class after every 30 mintues
*@ History		:- #CR
*/

global with sharing class FV_ScheduleDocumentrProvisioningCls implements Schedulable{

	global void execute(SchedulableContext SC) {
      FV_DocumentProvisioningBatchCls dProvisioning = new FV_DocumentProvisioningBatchCls();
      database.executeBatch(dProvisioning, 50);
   }
	
}