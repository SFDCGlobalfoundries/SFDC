/*************************************************************************************************************************************************************
@ Apex Class:     MTATEmail Inactive MTAT Users
@ Author:         Sridhar Gopireddy (Sridhar.gopireddy@globalfoundries.com)
@ Purpose:        This class sends list of inactive users to Business on a daily basis
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 29.12.2016 / Sridhar Gopireddy / Created the class.
**************************************************************************************************************************************************************/
global class MTATEmailInactiveMTATUsers implements Schedulable{
    
    global void execute(SchedulableContext sc){
        sendEmailInactiveMtatUses();
    }

    public void sendEmailInactiveMtatUses(){
        //Get List of Inactive mtat users past one day
        List<HCM_Employee__c> hcmList=[SELECT id,Name,Location_Description__c,First_Name__c,Last_Name__c,LastModifiedDate,Email_Address__c,Status__c from HCM_Employee__c where Status__c='Inactive' and SystemModstamp > :Date.today().addDays(-1)];
        List<HCM_Employee__c> hcmInactiveList =new List<HCM_Employee__c>();
        
        for(HCM_Employee__c he : hcmList){
            if(he.Status__c=='Inactive' && he.Status__c!='Active'){
                hcmInactiveList .add(he);
            }
        }
        //  CSV Sheet Header
        String csvHeader='Location ,FirstName,LastName,Email ID,Status,LastModifiedDate \n';
        String inactiveUsersList=csvHeader;
        
        if(hcmInactiveList.size()>0){
            for(HCM_Employee__c he : hcmList){
                String inactiveUser=he.Location_Description__c+','+he.First_Name__c+','+he.Last_Name__c+','+he.Email_Address__c+','+he.Status__c+','+he.LastModifiedDate+'\n';
                inactiveUsersList+=inactiveUser;
            }
            try{
            Messaging.EmailFileAttachment csvattcmnt= new Messaging.EmailFileAttachment();
            blob csvBlob=Blob.valueof(inactiveUsersList);
            String csvName='InactiveMTATUsersListPastOneDay.csv';
            csvattcmnt.setFileName(csvName);
            csvattcmnt.setBody(csvBlob);
            
            Messaging.SingleEmailMessage singEmail= new  Messaging.SingleEmailMessage();
            
            String [] toAddresses = new List<String>{'June.mulheron@globalfoundries.com'}; 
            singEmail.setToAddresses (toAddresses);
            String subject='Inactive MTAT Users List In Past One Day';
            singEmail.setSubject(subject);
            singEmail.setPlainTextBody('Inactive MTAT Users List In Past One Day');
            singEmail.setFileAttachments (new Messaging.EmailFileAttachment []{csvAttcmnt});
            Messaging.sendEmail(new Messaging.SingleEmailMessage [] {singEmail});
            }
            catch(Exception e){
                System.debug('Exception Occured - Class: MTATEmailInactiveMTATUsers .sendEmailInactiveMtatUses' + 
            'Line Number: ' + e.getLineNumber() + ' Type: ' + e.getTypeName() + ' Message: ' + e.getMessage());
            //GlobalUtility.logMessage('ERROR:','MTATEmailInactiveMTATUsers ','sendEmailInactiveMtatUses','','',e.getMessage(),'','MTATApplication',e,0);
            }
        }
    }
}