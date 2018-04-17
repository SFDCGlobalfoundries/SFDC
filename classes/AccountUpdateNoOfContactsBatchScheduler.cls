/*
    Author: Anirban Roy
    Description: This is a scheduler class for AccountUpdateNoOfContactsBatch.
    History: 
        ZAmbat      05272014    - Code creation.
*/

global class AccountUpdateNoOfContactsBatchScheduler implements Schedulable {
	global void execute(SchedulableContext sc){
         database.executeBatch(new AccountUpdateNoOfContactsBatch(), 1);
    }
}