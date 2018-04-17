/*
Type Name: BNPNotifyRequestCatcherCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 21/08/2016
Description: This class is call from 'Notify Request Catcher' button to notify Request Catcher.
Test Class: 
Change History:
*/
Global class BNPNotifyRequestCatcherCtrl{
    
    /**
    *  The Purpose of this method is to send email notification to Primary and Backup Request Catcher.
    *  @name <BNPNotifyRequestCatcher>
    *  @param <String> 
    *  @return <String>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    WebService static String BNPNotifyRequestCatcher(String requestInfoId){
        Request_Information__c requestInfo = [SELECT id, RecordType.DeveloperName, Account__r.Name, Opportunity__r.Name, RFI_Request_Number__c, RFQ_Request_Number__c, Backup_Request_Catcher__c, Backup_Request_Catcher__r.Email, Primary_Request_Catcher__c, Primary_Request_Catcher__r.Email, CreatedById, CreatedBy.Name, CreatedDate from Request_Information__c WHERE id =: requestInfoId];
        if(requestInfo.Primary_Request_Catcher__c != Null || requestInfo.Backup_Request_Catcher__c != Null){
            system.debug('Primary RC:' +requestInfo.Primary_Request_Catcher__r.Email);
            system.debug('Backup RC:' +requestInfo.Backup_Request_Catcher__r.Email);
            List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            List<String> taskassigneeEmailList = new List<String>();
            if(requestInfo.Primary_Request_Catcher__c != Null){
                taskassigneeEmailList.add(requestInfo.Primary_Request_Catcher__r.Email);
            }
            if(requestInfo.Backup_Request_Catcher__c != Null){
                taskassigneeEmailList.add(requestInfo.Backup_Request_Catcher__r.Email);
            }
            singleMail.setToAddresses(taskassigneeEmailList);
            if(requestInfo.RecordType.DeveloperName == 'RFI'){
                singleMail.setSubject('New RFI Request for ' +requestInfo.Account__r.Name+ ' is created');
            }
            if(requestInfo.RecordType.DeveloperName == 'RFQ'){
                singleMail.setSubject('New RFQ Request for ' +requestInfo.Account__r.Name+ ' is created');
            }
            String body;
            if(requestInfo.RecordType.DeveloperName == 'RFI'){
                body = 'A new RFI request, Request #' +requestInfo.RFI_Request_Number__c+' has been created by ' +requestInfo.CreatedBy.Name+ ' on ' +requestInfo.CreatedDate;
            }
            if(requestInfo.RecordType.DeveloperName == 'RFQ'){
                body = 'A new RFQ request, Request #' +requestInfo.RFQ_Request_Number__c+' has been created by ' +requestInfo.CreatedBy.Name+ ' on ' +requestInfo.CreatedDate;
            }
            body+= '<br/>';
            body+= '<br/>';
            body+= 'You have been assigned as a Request Catcher.';
            body+= '<br/>';
            body+= '<br/>';
            body+= 'CUSTOMER :' +requestInfo.Account__r.Name;
            body+= '<br/>';
            body+= 'OPPY CONTROL # :' +requestInfo.Opportunity__r.Name;
            body += '<br/>';
            body += '<br/>';
            body+= 'Use this link to go to the DIW Tool: ';
            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+requestInfo.id;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+requestInfo.id+'">'+hyperLink+'</a>';
            singleMail.setHtmlBody(body);
            newMails.add(singleMail);
            if(!newMails.isEmpty()){
                try{
                    Messaging.sendEmail(newMails);
                }catch(Exception excp){
                    GlobalUtility.logMessage('Error','BNPNotifyRequestCatcherCtrl','BNPNotifyRequestCatcher','','Exception while sending notification to Request Catcher',String.valueof(excp.getMessage()),'','BnP',excp,0);
                }
            }
            return 'Notification send to Request Catcher';
        }else{
            return 'Please enter value for Request Catcher before sending notification';
        }
    }
}