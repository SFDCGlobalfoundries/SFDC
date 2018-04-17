/**
* @author       :   Ankit Singhal
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to choose Scrapped Reticles and then generate Scrapped reticles Document and Attach to Account,with Email sent to Customer 
                    Button on Account   
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        ASinghal        10/09/2013          Created the Class
        NJain           21/04/2014          Added the check for Fab 1 for fetching Company Name and Address
**/

public with sharing class ROS_GenerateScrapController {
    public List<Reticle__c> LScrapReticles{get;set;}
    public Id CertificateId;
    public boolean IsGenerated{get;set;}
    public String ControllerSelectedIds{get;set;}
    public Account currentRecord{get;set;}
    public ROS_Disposal_Certificate__c CertificateRecord{get;set;}
    public String ScrappingCompany{get;set;}
    public String ScrappingCompanyAddress{get;set;}
    public String AuthorizedUser{get;set;}


    public ROS_GenerateScrapController() { 
    
        CertificateId= ApexPages.currentPage().getParameters().get('resultId'); 

        CertificateRecord= [Select Name,Id,account__c,Scrap_Date__c,Authorizing_User__c,Designation__c from ROS_Disposal_Certificate__c where Id=:CertificateId];

        //AuthorizedUser=[select id,name from user where id=:CertificateRecord.Authorizing_User__c].Name;
        AuthorizedUser=CertificateRecord.Authorizing_User__c;
        currentRecord= [select Id,Name,Phone,Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Corporate_Postal_Zip_Code__c from account where id=:CertificateRecord.Account__c];

        LScrapReticles=new List<Reticle__c>([Select Id,Name,GlobalFoundries_Device_ID__c,ROS_Status__c,FabStr__c from Reticle__c where Disposal_Certificate__c=:CertificateId]);
    
        boolean IsFab3 = LScrapReticles[0].fabstr__c.contains('FAB 3');
        //Nikhil-- 21/04/2014
        boolean IsFab1 = LScrapReticles[0].fabstr__c.contains('FAB 1'); 
        
        if (IsFab3 && !IsFab1){
            ScrappingCompany            = ROS_Vendor_Name__c.getValues('FAB 3E').Company_Name__c;
            ScrappingCompanyAddress     = ROS_Vendor_Name__c.getValues('FAB 3E').Address__c;
        }else if(IsFab1){
            ScrappingCompany            = ROS_Vendor_Name__c.getValues('FAB 1').Company_Name__c;
            ScrappingCompanyAddress     = ROS_Vendor_Name__c.getValues('FAB 1').Address__c;
        }
        else{
            ScrappingCompany            = ROS_Vendor_Name__c.getValues('Other').Company_Name__c;
            ScrappingCompanyAddress     = ROS_Vendor_Name__c.getValues('Other').Address__c;
        }
             
    }
     
    public PageReference attachfile(){
        String filename=ScrappingCompany+'_'+CertificateRecord.Scrap_Date__c+'_Scrap_Certificate.pdf';
        pagereference scrappage=page.rosvf_scrappdf;
        scrappage.setRedirect(false);
        blob body;
        if(!Test.isRunningTest()){
            body = scrappage.getContent();
        }else{
            body = blob.valueOf('Test');
        }
        attachment pdf = new attachment();
        pdf.Name=filename;
        pdf.body = body;
        pdf.ParentId = CertificateId;
        pdf.isPrivate = false;
        insert pdf ;
        return scrappage;
    }
    
    public void sendscrapcertificatetocustomer(String filename,Blob body){
        System.debug('------->'+filename+'//////////'+body);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('ROS Scrap Certificate PDF');
        String [] toAddresses = new String[] {'dummyMail@test.com'};
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('Please find attached ROS Scrap Certificate Pdf');
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setContentType('application/pdf');
        efa.setFileName(filename); 
        efa.setBody(body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
    }

}