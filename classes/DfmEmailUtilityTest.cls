/*
	@Author :- Abhita Bansal
 */
@isTest
private class DfmEmailUtilityTest {

    static testMethod void myDFMEmailUtilityMethod() {
        
        List<String> toAddresses = new list<String>();
        Set<Id> custIds = new Set<Id>();
        
        list<User> user = DesignCollaboratorTestData.getUserTestData();
        User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];
        
        custIds.add(user[0].Id);
        toAddresses = DfmUtilityCls.getEmailIds(custIds);
        
        Test.startTest();
        
        DfmEmailUtility dfmEmail = new DfmEmailUtility(toAddresses, null, null);
        
        dfmEmail.senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName());
        dfmEmail.subject('Test');
        dfmEmail.htmlBody('Test Body');
        dfmEmail.useSignature(true);
        dfmEmail.replyTo(currentUser.Email);
        dfmEmail.plainTextBody('Test Plain Body');
        //dfmEmail.fileAttachments();
        dfmEmail.sendEmail();
        
        Test.stopTest();
    }
}