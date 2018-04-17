/*
    Author: Sreedhar Karukonda
    Description: This is Trigger handler for Device PEOL Object. Sends email to Account Manager of the Customer, 
                    who's devices are PEOLed and Posts chatter message in to Account chatter feed
    History: 
    skarukon      09/22/2015    - Apex code created    
*/

public class DevicePEOLRequestTriggerHandler {
    /**
     *   Invokes correct handlers as per the context of Trigger and available registered handlers
     */
    public static void handle()
    {   
        if(Trigger.isInsert && Trigger.isBefore){
            DevicePEOLUtility.assignPrimaryCSRFromAccount((List<Device_PEOL_Request__c>)Trigger.new);
        } 
        else if(Trigger.isInsert && Trigger.isAfter){
           handleRequest(null, (Map<Id, Device_PEOL_Request__c>)Trigger.newMap);
        }
        else if(Trigger.isUpdate && Trigger.isAfter){
            submitToAIA((Map<Id, Device_PEOL_Request__c>)Trigger.oldMap, (Map<Id, Device_PEOL_Request__c>)Trigger.newMap);
            handleRequest((Map<Id, Device_PEOL_Request__c>)Trigger.oldMap, (Map<Id, Device_PEOL_Request__c>)Trigger.newMap);
        }
    }

    /**
    * Collects all PEOL Request Details and Sends email to all related primary account managers 
    * and posts message to related accpounmt chatter feed
    **/
    private static void handleRequest(Map<Id, Device_PEOL_Request__c> oldPeolRequests, Map<Id, Device_PEOL_Request__c> newPeolRequests) {
        try{
            Set<Id> peolNotificationIds = new Set<Id>();
            if(oldPeolRequests == null){
                peolNotificationIds = newPeolRequests.keySet();
            }else{
                for(Id requestId: newPeolRequests.keySet()){
                    if(newPeolRequests.get(requestId).Status__c != oldPeolRequests.get(requestId).Status__c && newPeolRequests.get(requestId).Status__c  != 'In-process'){
                        peolNotificationIds.add(requestId);
                    }
                }
            }
            if(!peolNotificationIds.isEmpty()){
                // Collect all email messages
                List<Messaging.Singleemailmessage> emailMessages = new List<Messaging.Singleemailmessage>();
    
                // Collect all chatter posts to post in to Accounts
                List<FeedItem> chatterPosts = new List<FeedItem>();
                for(List<Device_PEOL_Request__c> peolRequests: [SELECT Id, Name, Status__c, Customer__c, Customer__r.Name, Customer__r.Account_Manager__c, Customer__r.Account_Manager__r.Name, 
                                                                Customer__r.Account_Manager__r.Email, CreatedBy.Name, CreatedBy.Email,  LastModifiedBy.Name, LastModifiedBy.Email,
                                                                (SELECT Id, Name, ERP_Device__c, ERP_Device__r.Name, Fab__c, ERP_Status_Message__c, Last_Time_Ship_Date__c, Last_Time_Buy_Date__c FROM Device_PEOL_Request_Details__r)
                                                                FROM Device_PEOL_Request__c where Id in :peolNotificationIds]){
                    for(Device_PEOL_Request__c devPEOLRequest : peolRequests){
                        if(devPEOLRequest.Customer__c != null && devPEOLRequest.Customer__r.Account_Manager__c != null && devPEOLRequest.Device_PEOL_Request_Details__r.size() > 0){
                           EmailAndChatterDetails emailAndPost =  new EmailAndChatterDetails(devPEOLRequest);
                           emailMessages.add(emailAndPost.email);
                           chatterPosts.add(emailAndPost.chatterPost);
                        }
                    }
                }
                //SEND EMAILS
                if(!Test.isRunningTest() && emailMessages.size() > 0)  Messaging.sendEmail(emailMessages);
                //POST MESSAGES in ACCOUNT Records
                if(chatterPosts.size() > 0) insert chatterPosts;
            }
        }catch(Exception ex){
            for(Device_PEOL_Request__c peolRequest: newPeolRequests.values()){
                peolRequest.addError('LINE NUMBER :' +ex.getLineNumber() +' '+ex.getMessage() );
            }
        }
    }

    public class EmailAndChatterDetails{
        public String htmlContent{get; set;}
        public String plainContent{get; set;}
        public String recipientName{get; set;}
        public Messaging.Singleemailmessage email { get; set; }
        public FeedItem chatterPost{get; set;}

        public EmailAndChatterDetails(Device_PEOL_Request__c request){
            createEmailBody(request);
            email = createEmail(request);
            this.chatterPost = new FeedItem();
            this.chatterPost.ParentId = Request.Customer__c;
            this.chatterPost.Body = this.plainContent;
        }
        private Messaging.Singleemailmessage createEmail(Device_PEOL_Request__c request){
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
            if(request.Customer__r.Account_Manager__c != null){
                email.setReplyTo(request.createdBy.Email);
                email.setSenderDisplayName(request.createdBy.Name);
                email.setTargetObjectId(request.Customer__r.Account_Manager__c);
                email.setSaveAsActivity(false);
                email.setSubject('[Notification] Pending End of life request for devices is submitted');
                email.setHtmlBody(htmlContent);
                email.setPlainTextBody(plainContent);
            }
            return email;
        }


        private void createEmailBody(Device_PEOL_Request__c request){
            String  DEVICE_REQUEST_PEOL_EMAIL_HEADER = UtilsString.isNotBlank(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_EMAIL_HEADER')) ?
                                            EnvironmentVariable.get('DEVICE_REQUEST_PEOL_EMAIL_HEADER') : 'Following devices are submitted for Pending End of Life.';

            this.htmlContent = 'Dear ' + request.Customer__r.Account_Manager__r.Name+',<br/>';
            this.plainContent ='Dear ' + request.Customer__r.Account_Manager__r.Name+',\n';
            this.htmlContent = this.htmlContent + DEVICE_REQUEST_PEOL_EMAIL_HEADER +'<br/>';
            this.plainContent = this.plainContent + DEVICE_REQUEST_PEOL_EMAIL_HEADER +'\n';

            //Link to PEOL Record
            this.htmlContent = this.htmlContent +'<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ request.Id+'>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ request.Id+'</a><br/><br/>';
            
            String rowTemplate = '<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>{5}</td></tr>';
            String plainRowTemplate = 'Customer : {0} \n Device : {1} \n Last time buy: {2} \n Last Time ship: {3} \n Status: {4} \n Created By: {5} \n\n\n';
            if(request.Device_PEOL_Request_Details__r != null && !request.Device_PEOL_Request_Details__r.isEmpty()){
                this.htmlContent = this.htmlContent + '<table width="100%" border="1"><thead style="background-color:orange"><tr style="font-weight:900"><th>Customer</th><th>Device</th><th>Last time buy</th><th>Last Time ship</th><th>Status</th><th>Created By</th></tr></thead><tbody>';
                for(Device_PEOL_Request_Detail__c requestDetail: request.Device_PEOL_Request_Details__r){
                    String tableRow = String.format(rowTemplate, new List<String>{request.Customer__r.Name, requestDetail.ERP_Device__r.Name, requestDetail.Last_Time_Buy_Date__c.format(), requestDetail.Last_Time_Ship_Date__c.format(), request.Status__c, request.CreatedBy.Name});
                    this.htmlContent = this.htmlContent + tableRow;
                    this.plainContent = this.plainContent + String.format(plainRowTemplate, new List<String>{request.Customer__r.Name, requestDetail.ERP_Device__r.Name, requestDetail.Last_Time_Buy_Date__c.format(), requestDetail.Last_Time_Ship_Date__c.format(), request.Status__c, request.CreatedBy.Name});
                }
                this.htmlContent = this.htmlContent +'</tbody></table>';
            }
        }
    }

    /**
    * After CRS approval Data is submitted to AIA to update in ERP
    **/
    private static void submitToAIA(Map<Id, Device_PEOL_Request__c> oldPeolRequests, Map<Id, Device_PEOL_Request__c> newPeolRequests){
        List<Id> approvedPEOLRequests = new List<Id>();
        for(Id requestId: newPeolRequests.keySet()){
            if(newPeolRequests.get(requestId).Status__c == 'In-process' && newPeolRequests.get(requestId).Status__c != oldPeolRequests.get(requestId).Status__c){
                approvedPEOLRequests.add(requestId);
            }
        }
        if(!approvedPEOLRequests.isEmpty()){
            DevicePEOLRequestIntegration.doCallout(approvedPEOLRequests);
        }
    }
}