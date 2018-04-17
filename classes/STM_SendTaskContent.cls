public with sharing class STM_SendTaskContent{
    
    STMTask__c taskRecord = new STMTask__c();
    
    public List<SelectedAttachmentWrapper> lstAttWrapper{get;set;}
    public String subject { get; set; }
    public String body { get; set; }
    public Boolean Allselected{get;set;}
    public Boolean showContactCreation{get;set;}    
    public static Integer toDelIdent {get; set;}
    public static Integer addCount {get; set;}    
    public List<ContactWrapper> wrappers {get; set;}
    public List<STM_Contact__c> lstContactsSelected{get;set;}
    
    private Integer nextIdent=0;    
    
    public STM_SendTaskContent(ApexPages.StandardController controller) {
        String stmTaskId =  controller.getId();
        taskRecord = (STMTask__c)controller.getRecord();
        lstAttWrapper = new List<SelectedAttachmentWrapper>();
        showContactCreation = FALSE;
        wrappers = new List<ContactWrapper>();
        
        List<FeedItem> lstFeedItemsToQuery = STM_SystemMode.queryFeedItem(stmTaskId );
        //for(FeedItem att: [select id,ContentFileName,ContentSize,RelatedRecordId FROM FeedItem where ParentId = :stmTaskId and Type='ContentPost']){
        for(FeedItem att: lstFeedItemsToQuery){
            SelectedAttachmentWrapper attWrapperRec = new SelectedAttachmentWrapper(att);
            attWrapperRec.IsChecked = False;
            attWrapperRec.attmnt = att;
            lstAttWrapper.add(attWrapperRec);        
        }
        
        lstContactsSelected = new List<STM_Contact__c>();
        searchContacts();
    }

    public class SelectedAttachmentWrapper{
        public FeedItem attmnt{get;set;}
        public Boolean IsChecked{get;set;} 
        public SelectedAttachmentWrapper(FeedItem att) {
            attmnt    = att;
            IsChecked = false;
        }
        public SelectedAttachmentWrapper(FeedItem att,Boolean isChecked) {
            this.attmnt    = att;
            this.IsChecked = isChecked  ;
        }
    }
    
    public PageReference showContactBlock(){
        showContactCreation = True;
        return NULL;
    }
    
    public PageReference saveContacts(){
        try{
            List<Contact> lstContacts = new List<Contact>();
            List<String> lstExistingEmails = new List<String>();
            List<STM_Contact__c> lstSTMContacts = new List<STM_Contact__c>();
            for (ContactWrapper wrap : wrappers){
                wrap.con.AccountId = taskRecord.Account__c;
                lstContacts.add(wrap.con);
                lstExistingEmails.add(wrap.con.Email);
            }
            
            List<Contact> lstExistingContact = [select id,Name,Email from Contact where AccountId = :taskRecord.Account__c 
                                                   and Email in :lstExistingEmails];
            if(lstExistingContact != NULL && !lstExistingContact.isEmpty()){
                string errorMessage= '<b>Following Contact(s) already exists with same Email Ids:</b><br/>';
                for(Contact c:lstExistingContact){
                    errorMessage += '&nbsp;&nbsp;&nbsp;&nbsp;'+ c.Name +' (<i>' + c.Email + '</i>)<br/>';
                }                
                errorMessage += 'Go to Report Profile and then associate existing Contact.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
            }else{
                insert lstContacts; // Inserting the new Contacts
                for (Contact c: lstContacts){
                    STM_Contact__c stmContact = new STM_Contact__c();
                    stmContact.Contact__c = c.Id;
                    stmContact.Report_Profile__c = taskRecord.Report_Project_Profile__c;
                    lstSTMContacts.add(stmContact);
                }
                insert lstSTMContacts; //Inserting the STM Contact under the Report Profile of the Current Task
                
                showContactCreation = FALSE;
                searchContacts();
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured:'+e.getMessage()));
        }
        return NULL;
    }
    
    public void searchContacts(){
        nextIdent = 0;
        wrappers.clear();
        lstContactsSelected.clear();
        
        for (Integer idx=0; idx<1; idx++){
            wrappers.add(new ContactWrapper(nextIdent++));
        }
                
        lstContactsSelected = [SELECT Id,Contact__c,Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Contact__r.Email 
                                FROM STM_Contact__c
                                WHERE 
                                    Report_Profile__c = :taskRecord.Report_Project_Profile__c and 
                                    Contact__r.EmailBouncedDate = NULL];
        
    }
    
    public void delWrapper(){
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrappers.size(); idx++){
            if (wrappers[idx].ident==toDelIdent){
                toDelPos=idx;
            }
        }        
        if (-1!=toDelPos){
            wrappers.remove(toDelPos);
        }
    }
    
    public void addRows(){
        for (Integer idx=0; idx<addCount; idx++){
            wrappers.add(new ContactWrapper(nextIdent++));
        }
    }
    
    public class ContactWrapper{
        public Contact con{get; set;}
        public Integer ident{get; set;}
        public ContactWrapper(Integer inIdent){
            ident=inIdent;            
            con=new Contact(FirstName='New Contact ' + ident);
        }
    }
    
    
    public PageReference sendEmail() {
        
        List<FeedItem> lstAttachmmetsSelected = new List<FeedItem>();        
        if(lstAttWrapper != NULL && !lstAttWrapper.isEmpty()){
            for(SelectedAttachmentWrapper selAttch : lstAttWrapper){
                if(selAttch.isChecked == True){
                    lstAttachmmetsSelected.add(selAttch.attmnt);
                }
            }
        }
        
        if(lstContactsSelected.isEmpty()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please associate atleast one Contact under the Report Profile to send the Email to.'));
            return NULL;
        }
        if(lstAttachmmetsSelected.isEmpty()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one Attachment.'));
            return NULL;
        }
        
        //Preparing Content Attachments
        List<String> lstContentVersionId = new List<String>();
        for(FeedItem att: lstAttachmmetsSelected){
            lstContentVersionId.add(att.RelatedRecordId);
        }
        List<ContentDistribution> lstContentAttachments = [SELECT Id, Name, DistributionPublicUrl, ContentVersionId   
                                                            FROM ContentDistribution WHERE ContentVersionId in :lstContentVersionId];
        List<Document> lstDocumentForLogo= [select id from Document where Name = 'GF Logo' limit 1];
        String STM_GFLOGO_Id ='';
        if(!lstDocumentForLogo.isEmpty()){
            STM_GFLOGO_Id = lstDocumentForLogo[0].Id;
        }
        
        List<Messaging.SingleEmailMessage> lstSingleMailMessages = new List<Messaging.SingleEmailMessage>();
        string baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
        string orgId   = UserInfo.getOrganizationId();
        
        //++Set the HTML Body of the email
            String htmlBody = '';
            String contactInfo = '';
            String attachmentInfo = '';
            
            //Include the attachment information
            if(lstContentAttachments != NULL && !lstContentAttachments.isEmpty()){
                integer i=1;
                for(ContentDistribution cd: lstContentAttachments){
                    attachmentInfo += 'Attachment '+i+': '+ cd.Name + '<br/>URL: ' + cd.DistributionPublicUrl + '<br/><br/>';
                    i=i+1;
                }
            }
            //Including all the Contact Information who have been notified.
            contactInfo += 'Following Contact(s) have been notified:<br/>';
            integer j=1;
            for(STM_Contact__c cntct: lstContactsSelected){
                contactInfo += 'Contact '+ j + ': ' + cntct.Contact__r.Name + ' (' + cntct.Contact__r.Email + ') <br/>';
                j=j+1;
            }
            
        //--Set the HTML Body of the email
        
        for(STM_Contact__c con: lstContactsSelected){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage ();
            mail.setTargetObjectId(con.Contact__c);
            mail.setSubject('STM RPT: ' + taskRecord.Name);
            
            if(STM_GFLOGO_Id != ''){
                htmlBody  = '<img src="'+baseURL+'/servlet/servlet.FileDownload?file='+STM_GFLOGO_Id+'&oid='+orgId+'" alt="Company Logo"/>';
            }
            htmlBody += '<br/>Hi,<br/><br/>Please find the following attachment(s) related to the Task: '+taskRecord.Name+'<br/><br/>';
            htmlBody += attachmentInfo + contactInfo+ '<br/>Thanks,<br/>GlobalFoundries';
            system.debug('##htmlBody ##'+htmlBody);
            
            mail.setHtmlBody(htmlBody);
            mail.setWhatId(taskRecord.Id);
            mail.setSaveAsActivity(false);
            lstSingleMailMessages.add(mail);
        }
        try{            
            Messaging.SendEmailResult [] result = Messaging.sendEmail(lstSingleMailMessages);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Email Successfully Sent !'));
            
            //Creating a feed post for email sent
            FeedItem f = new FeedItem();
            f.ParentId = taskRecord.Id;
            f.body     = 'Following attachment(s) has been sent through email:\n\n'+attachmentInfo.replaceAll('<br/>','\n') + contactInfo.replaceAll('<br/>','\n');
            f.Title    = 'Sent to Customer via Email';
            f.type     = 'TextPost';
            insert f;
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Exception Occurred. Please contact System Administrator !'));
            System.Debug('###Exception Occured###'+e.getMessage());
        }
        return null;
    }
    
}