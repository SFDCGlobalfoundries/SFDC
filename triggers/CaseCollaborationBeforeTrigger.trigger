/*
Type Name: CaseCollaborationBeforeTrigger 
Author: Cognizant
Created Date: 13-May-2014
Reason: This is the trigger for preventing users to unSubscribe others accouns users
Test Class: 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger CaseCollaborationBeforeTrigger on Case_Collaboration__c(before update) {

    private final static List < User > userList = [select Id, ContactId, Contact.AccountId from User where id = : UserInfo.getUserId() Limit 1];

    for (Case_Collaboration__c caseObj: trigger.new) {
        if (UserInfo.getUserType() != 'Standard') {
             
            if (userList != null && userList.size() > 0 && userList[0].Contact.AccountId!=null) {
                if (caseObj.Account_Contact__c != null && userList[0].Contact.AccountId != caseObj.Account_Contact__c) {
                    //caseObj.addError('You are not allowed to subscribe or unsubscribe other accounts contact.');
                    caseObj.addError(Label.CC_to_Case_edit_permission_not_allowed);
                }
            }

        }
    }
}