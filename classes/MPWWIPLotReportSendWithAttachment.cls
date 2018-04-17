public with sharing class MPWWIPLotReportSendWithAttachment {

   /*This method will be used in batch*/
   
    public static void sendEmailToCustomer(string strUserName) {
        //List<Messaging.SingleEmailMessage> mail = new List<Messaging.SingleEmailMessage>();

        /*TODO: Send multiple email in single thread*/

        OrgWideEmailAddress[] owdEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
        
        User objUser=[Select id,UserName,Name ,Email from User where UserName=:strUserName];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        PageReference objPage = Page.MPWCustomerWIPExcel;
        objPage.getParameters().put('fromDt', '');
        objPage.getParameters().put('toDt', '');
         objPage.getParameters().put('1bf6628702622c8',strUserName);
        objPage.setRedirect(true);

        Blob contentdata = Test.isRunningTest()?Blob.valueOf('test'):objPage.getContent();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();

        efa.setFileName('MPWWIPLotReport.xls');
        efa.setBody(contentdata);

        if (owdEmail.size() > 0) {
            email.setOrgWideEmailAddressId(owdEmail.get(0).Id);
        }

        email.setSubject('MPW WIP Lot Report ');
        email.setToAddresses(new List < string > {objUser.Email });
        email.setPlainTextBody('MPW WIP Lot Report');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });

        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }

}