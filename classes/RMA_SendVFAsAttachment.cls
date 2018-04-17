/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This is the class for sending the Visualforce content as attachment to an email.
* History       :   
        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    30-Jun-16     Created the Class
        Nikhil Jain    26-Oct-16     Moving the logic of webservice into this class to avoid callout loop.
**/

public class RMA_SendVFAsAttachment{

    @future(callout=true)
    public static void sendVF(String TO_EmailId, String CC_EmailId, String userSessionId, String RMAid, String templateId, String pageType){
        //Njain- 26Oct16 -- Moving the logic of webservice to this class as getContent is now future itself. No need for webservice callout.
        List<String> TO_EmailIds = new List<String>();
        List<String> CC_EmailIds = new List<String>();
        if(TO_EmailId != NULL && TO_EmailId.trim() != NULL && TO_EmailId.trim() != ''){
            TO_EmailIds = TO_EmailId.split(',');
        }
        if(CC_EmailId != NULL && CC_EmailId.trim() != NULL && CC_EmailId.trim() != ''){
            CC_EmailIds = CC_EmailId.split(',');
        }
        List<Messaging.EmailFileAttachment> lstEFA = new List<Messaging.EmailFileAttachment>();
        
        PageReference ref1,ref2;
        if(pageType == 'CustPerf' || pageType == 'ReturnScrap'){
            ref1 = Page.RMA_CustomerPorforma_PDF;
            ref1.getParameters().put('id',RMAid);
            ref1.getParameters().put('type','proforma');
            ref1.setRedirect(true);
            Blob b = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : ref1.getContentAsPDF();
            
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName('CustomerPerforma.pdf');
            efa1.setBody(b);
            lstEFA.add(efa1);
            
        }
        if(pageType == 'ScrapCert' || pageType == 'ReturnScrap'){
            ref2 = Page.RMA_Scrap_Certificate_PDF;
            ref2.getParameters().put('id',RMAid);
            ref2.getParameters().put('type','scrap');
            ref2.setRedirect(true);
            Blob b = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') :ref2.getContentAsPDF();
            
            Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();
            efa2.setFileName('ScrapCertificate.pdf');
            efa2.setBody(b);
            lstEFA.add(efa2);
        }
        
        // Create Dummy Contact before sending the Email
        Contact con = new Contact();
        con.FirstName = 'NoReply';
        con.LastName = 'Salesforce.com';
        con.Email = 'noreply@salesforce.com';
        insert con;
        
        List<String> bccList = new List<String>();
        bccList.add(RMA_CONSTANTS.EMAIL_SERVICE_ADDRESS);
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateId);
        
        if(TO_EmailIds != NULL && !TO_EmailIds.isEmpty()){
            email.setToAddresses(TO_EmailIds);
        }
        if(CC_EmailIds != NULL && !CC_EmailIds.isEmpty()){
            email.setCCAddresses(CC_EmailIds);
        }
        email.setBccAddresses(bccList);
        email.setTargetObjectId(con.Id);
        email.setWhatId(RMAid);
        email.setSaveAsActivity(false);
        
        email.setFileAttachments(lstEFA);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        //Deleting the Dummy Contact
        if(Con != NULL && Con.Id != NULL){
            delete con;
        }
    }
}