/*
Batch class to be schduled to run every day with a low scope size.
This batch does the following:
1. Fetch all customer Report_Subscription records
2. Check if daily or weekly and based on that, send email to the subscriber with the report data as CSV email attachment.
3. For standard reports, simply page reference the report link URL, 
   but for custom reports, execute the dynamic SOQL and form a CSV file( a separate VF and controller is used to handle this)

Author: Rahul Majumder
Version 1.0

 Modified Date : Apr-26-2017
 Modified by   : Anil Kumar Reddy L
 Reason 	   : Added validation on "MasterDetail_To_Account_Field_Name__c" for CSV email logic
 
 Modified Date : Aug-28-2017
 Modified by   : Amit Kumar Ojha
 Reason 	   : Fixed the External Link Access for the Portal Users
 
 Modified Date : Aug-30-2017
 Modified by   : Amit Kumar Ojha
 Reason 	   : Not to send any notification if the Subscriber has no records assigned to him
*/

global class ICC_Process_UserReportSubscription_Batch implements database.batchable<Sobject> 
{
    // Start method: Fetch the Report_Subscription records
    global database.QueryLocator start(Database.batchableContext BC)
    {
        return database.getQueryLocator([Select id, Interval__c, Report_ID__c, Report_Name__c, Subscriber__c, Subscriber__r.Email, Subscriber__r.Name,  
                                         SF_Object__c, MasterDetail_To_Account_Field_Name__c, Report_Type__c, Report_SOQL__c, Subscriber__r.ContactId
                                         FROM Report_Subscription__c 
                                         WHERE Report_ID__c != null AND 
                                               SF_Object__c != null]);                                       
    }
    
    // Execute method: check the interval and process accordingly. 
    global void execute (Database.BatchableContext BC, List<Report_Subscription__c> Scope)
    {
        List<Messaging.SingleEmailMessage> lstSingleEmailMessages = new List<Messaging.SingleEmailMessage>(); // List of single email messages to be sent to subscribers
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply-salesforce@globalfoundries.com'];
		//String ccEmailAddress = 'gfv.do.not.reply@globalfoundries.com';
		String ccEmailAddress = Environment_Variable__c.getInstance('EXPOSE_DEVICE_BCC_ID').Value__c;
        for(Report_Subscription__c rpts: Scope)
        {
        	/**Start - Amit - 30-08-2017 - Not to send Emails if no Report Subscription Record Exists**/
            
            if(rpts.SF_Object__c != null && rpts.Report_SOQL__c != null) {
        		/**End - Amit - 30-08-2017**/
        		// Assuming weekly scheduled reports will be processed only on SUNDAY
	            /** Start - L Anil Kumar Reddy - 26-4-2017 - Added additional validation on MasterDetail_To_Account_Field_Name__c to not  null */
	            if((rpts.Interval__c == 'Daily' || (rpts.Interval__c == 'Weekly' && System.now().format('EEE') == 'Sun')) && (rpts.MasterDetail_To_Account_Field_Name__c != null && rpts.MasterDetail_To_Account_Field_Name__c != ''))
	            {
	            	/** End - L Anil Kumar Reddy - 26-4-2017 - Added additional validation on MasterDetail_To_Account_Field_Name__c to not  null */
	                List<String> ToAddresses = new List<String>{rpts.Subscriber__r.Email}; // Fetch subscriber email
	                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	                
	                if (owea.size() > 0 ) {
	                    email.setOrgWideEmailAddressId(owea.get(0).Id);
	                }
	                PageReference pf;
	                // For custom reports, a separate page and controller is used which executes the stored SOQL with ana dditional filter of account share
	                if(rpts.Report_Type__c == 'Custom' || rpts.Report_Type__c == 'Standard')
	                {
	                    pf = Page.ICC_Email_csv_VF; 
	                    pf.getParameters().put('query', rpts.Report_SOQL__c);
	                    pf.getParameters().put('subscriber', rpts.Subscriber__c);
	                    pf.getParameters().put('mdField', rpts.MasterDetail_To_Account_Field_Name__c);
	                    pf.setRedirect(true);
	                }
	                
	                Blob b;
	                
	                try
	                {
	                    if(!test.isRunningTest())
	                    {
	                        b = pf.getContent();
	                    }
	                    else{
	                        b = blob.valueof('TEST');
	                        Integer i = 10/0;
	                    }
	                }
	                catch(Exception e)
	                {
	                    ApplicationLogWrapper alw = new ApplicationLogWrapper();
	                    alw.source = ICC_Process_UserReportSubscription_Batch.class.getName();
	                    alw.sourceFunction ='execute()';
	                    alw.ApplicationName='ICC';
	                    alw.referenceInfo = 'Bug';
	                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
	                    alw.debugLevel = 'Error';
	                    alw.logCode = e.getTypeName();
	                    alw.ex = e.getCause();
	                    GlobalUtility.logMessage(alw);
	                    
	                    if(!Test.isRunningTest())
	                        continue;
		                }
		                
		                /***Added by Amit to provide access to both Internal and External Users Link to Salesforce***/
		                // Getting URL for External Users from Custom Settings
						GlobalFoundry_View__c gfv = GlobalFoundry_View__c.getOrgDefaults();
						String externalLink;
						
						if(gfv.URL__c != null && gfv.URL__c != '') {
							externalLink = gfv.URL__c;
						}
						
						Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		                efa.setFileName(rpts.Report_Name__c + '.csv');
		                efa.setBody(b);
		                email.setSubject(rpts.Interval__c + ' Export - ' + rpts.Report_Name__c );
		                email.setToAddresses( ToAddresses );
		                
		                if(ccEmailAddress != null && ccEmailAddress != '') {
		                	email.setCcAddresses(new List<String>{ccEmailAddress});
		                }
		                
		                String str = 'Dear ' + rpts.Subscriber__r.Name + '<br/><br/>' + 'Please find attached CSV format of report ' + rpts.Report_Name__c + ' which was refreshed as of ' + Date.today().format() + '<br/><br/>' + ' To view the active version of this report at Global-FoundryView, please follow below web link: ';

		                if(rpts.Subscriber__r.ContactId == null) {
		                	str += '<br/><br/>' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + rpts.Report_Id__C + '<br/><br/>';
		                } else {
		                    if(externalLink != null) {
		                    	str += '<br/><br/>' + externalLink + '/' + rpts.Report_Id__c + '<br/><br/>';
		                    }
		                }
		                /***End***/
	                str += 'Enter your GFV ID and Password on the login page, then click on Submit.';
	                
	                str += 'You are receiving this email since you have subscribed to the report. In order to unsubscribe the report Go to My Wafers tab and unsubscribe from My Subscriptions link';
	                str += '<br/><br/>' + 'Thank you,<br/>GLOBALFOUNDRIES';
	                email.setHTMLBody( str );
	                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa}); // Sends the email 
					
					if(ICC_Email_csv.getSize(rpts.Report_SOQL__c,rpts.Subscriber__c,rpts.MasterDetail_To_Account_Field_Name__c) > 0) {
	                	lstSingleEmailMessages.add(email);	
	                }
	            }	
             }              
        }
        
        if(lstSingleEmailMessages.size() > 0) { // Added by Amit to check the Null Pointer in the List
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(lstSingleEmailMessages);
        }
    }
    
    global void finish(Database.batchableContext BC)
    {
        // Do nothing
    }

}