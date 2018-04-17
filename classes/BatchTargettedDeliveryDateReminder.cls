/*
Type Name: BatchTargettedDeliveryDateReminder 
Author: UCM Cognizant
Reason: This class implements to send Email alert for Targeted Delivery Date 
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
global class BatchTargettedDeliveryDateReminder implements Database.Batchable<SObject>,Database.Stateful{
    Map<Bug__c,List<CC_List__c>> bugUser = new Map<Bug__c,List<CC_List__c>> ();
    final string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id  
    final string orgWideEmail = System.Label.Bug_OrgWideEmailAddress;
    final string strOrgId = UserInfo.getOrganizationId();      
    final string strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + strOrgId;
    Public string htmlBody;
    Public List<Bug__c> bugList = new List<Bug__c>();
    
    global database.querylocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT   id,Targetted_Delivery_Date__c,Name,(select user__c,Email__c from CC_Lists__r) 
                                         FROM     Bug__c 
                                         WHERE    Targetted_Delivery_Date__c =: system.today()+3]);
        
        
    
    }   
    global void execute(Database.BatchableContext BC,List<Bug__c> bugList){     
     list < Messaging.Singleemailmessage > emailList = new list < Messaging.Singleemailmessage > ();   
        try{
            for(Bug__c eachBug: bugList){
                if(eachBug.CC_Lists__r != null){
                    bugUser.put(eachBug,eachBug.CC_Lists__r);    
                }
            }        
            if(bugUser.size()>0){
            for (Bug__c bug: bugUser.keyset()){
                List<CC_List__c> uList = bugUser.get(bug);
                List<string> userId = new List<string>();
                for(CC_List__c uId : uList){
                    Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage ();
                    htmlBody = setHtmlBodyForFile(bug);
                    email.setHtmlBody(htmlBody); 
                    string subject = 'WR -'+bug.Name+ ': Pending For Solution Approval';
                    email.setSubject(subject);
                    email.setTargetObjectId(uId.user__c);
                    email.setSaveAsActivity(false);
                    email.setOrgWideEmailAddressId(orgWideEmail);
                    email.setSaveAsActivity(false);
                    emailList.add(email);              
                }
                
            }
            if (emailList.size() > 0) {
                Messaging.sendEmail(emailList);
            }
            }
            }
        catch(exception e){
            CaseHandlerUtility.trackException('BatchTargettedDeliveryDateReminder.execute',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    public string setHtmlBodyForFile(bug__c bugRec) {                                                         
        htmlBody = '<table><tr><td>' +
                        '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                        '<tr><td>' +
                        'Dear User'+                                    
                        '</tr></td>' +
                        '<tr><td>' +
                        'Please refer to the following link for accessing the record: '+
                         '</tr></td>' +
                        '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugRec.id + '<br><br>' +
                        '</td></tr>' +
                        '<tr><td>' +
                        'Targeted Delivery Date : ' + bugRec.Targetted_Delivery_Date__c + '. <br>' + ' <br>' +
                        'Kindly take necessary action.'+
                        
                        '</td></tr>' +
                        '<tr><td>' +
                        'Thank you,'+
                        '</tr></td>' +
                        '<tr><td>' +
                         'GLOBALFOUNDRIES'+
                        '</tr></td>' +
                        '</table>';
        return htmlbody;
    }
    global void finish(Database.BatchableContext bc){

    }
}