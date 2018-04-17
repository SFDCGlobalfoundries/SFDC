/*
    Author: 
    Description: This is the trigger to update 4Qtrend based on user entry for Qscore. 
    History:
        Mset     05012017    - Created Trigger. 
*/
trigger CustomerSatisfaction on Customer_Satsfaction__c (Before Insert,Before Update) {
new CustomerSatisfaction_TriggerHandler().run();

}