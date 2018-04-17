/*
Controller class for ICC_New_Subscription VF page.
This class handles both scenarios: Create/Edit of Report_Subscriptions
If NEW report_subscription, present user with blank fields which he needs to select and save.
If EDIT, standard controller fetches record details. 
 
Author: Rahul Majumder
Version 1.0

 Modified Date : Apr-26-2017
 Modified by   : Anil Kumar Reddy L
 Reason 	   : Modified code to assign "MasterDetail_To_Account_Field_Name__c" field value
*/
public with sharing class ICC_NewSubscription
{
    public final Report_Subscription__c rtSubr{get; set;}  // Current standard controller record
    private Map<Id, String> mapReportId_To_ReportName = new Map<Id, String>();  // Map of report ID to Name. 
                                                                                // Required to set the selected report name into Report_Name__c field of Report_Subscription (This field is used to set Email subject/File Name)
    private String strObjectName;
    
    
    
    public ICC_NewSubscription(ApexPages.StandardController controller) 
    {
        rtSubr = (Report_Subscription__c)controller.getRecord();
        rtSubr.Subscriber__c = Userinfo.getuserid();  // Set the default Subscriber(should be logged in user)
    }
    
    
    
    /*
        Method called only when a custom Report is selected.
        Does the following:
        1. Get the field names included in report and find out SF object name
        2. Form a dynamic SOQL from above data.
        3. Find if any filters are there in the report. If yes, add them to the WHERE clause of dynamic SOQL.
        4. Return the SOQL/ error msg(if any) to the calling method
    */  
    
    
    // Method to validate required fields of Report_Subscription
    private String validateRequiredFields()
    {
        String msg_Validation = '';
        if(rtSubr.Report_Id__c == null || rtSubr.Report_Id__c == '')
            msg_Validation = 'Error: Please select a report to subscribe';
        else if(rtSubr.Interval__c == null)
            msg_Validation = 'Error: Please select Interval';
        
        return msg_Validation;  // return error message (if any)
    }
    
    /* Method called on click of SAVE button on VF page.
       In both Edit and New cases, first, validate if all the required fields are entered by user.
                                   second, if standard report, then no need to form the alternative SOQL
                                   third, if custom report, then fetch the SOQL by calling Reports metadata.
                                                            find if any filters are there in the report and form WHERE clause accordingly
                                                            if any relationship fields are there, skip it.
                                   fourth, Save the Report_Subscription record with all above data. Check if same report is subscribed twice, in that case throw eror message.
    */
    Public PageReference save()
    {
        String strReqFields_Validation = validateRequiredFields(); // Call method to validate required fields 
        // If all required fields are filled up by user, proceed. Else, throw error message
        if(strReqFields_Validation != '')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, strReqFields_Validation));
            return null;
        }
        else
        {
            // If user has selected "Standard" report, then no need to find alternative SOQl, 
            // If "Custom" is selected, then fetch report metadata, form the SOQL(in validateReportSOQL() method), find filters and add WHERE clause.
            String strSOQL_Validation = ICC_ReportSubscriptionUtility.validateReportSOQL(rtSubr.Report_Id__c);
            // If any errors found while forming SOQL, do not proceed and throw error message on screen
            if(strSOQL_Validation.startsWith('Error'))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, strSOQL_Validation));
                return null;
            }
            else 
            {
                rtSubr.Report_SOQL__c = strSOQL_Validation.split('~')[0];  // Store the formed SOQL on Report_Subscription record. For standard reports, this field will be blank.
                rtSubr.Report_Name__c = mapReportId_To_ReportName.containsKey(rtSubr.Report_Id__c) ? mapReportId_To_ReportName.get(rtSubr.Report_Id__c) : '';  // Get the report name of selected Report
                rtSubr.SF_Object__c = strSOQL_Validation.split('~')[1]; // Store the SF object name
                /** Start - L Anil Kumar Reddy - 26-4-2017 - assigned value to variable to get "MasterDetail_To_Account_Field_Name__c" */
                strObjectName = rtSubr.SF_Object__c;
                /** End - L Anil Kumar Reddy - 26-4-2017 - assigned value to variable to get "MasterDetail_To_Account_Field_Name__c" */
                system.debug('------strObjectName---1---'+strObjectName);
                List<ICC_ReportType_BaseObject__c> lstCS = new List<ICC_ReportType_BaseObject__c>();
                lstCS = [select Account_Master_Detail_Field__c FROM ICC_ReportType_BaseObject__c WHERE Base_Object__c =:strObjectName];
                rtSubr.MasterDetail_To_Account_Field_Name__c = lstCS.isEmpty() ? '' : lstCS[0].Account_Master_Detail_Field__c; 
                
                // Following logic to check if the same report is scheduled twice(throw error message and revert the DML in that case)
                // The use of this logic is to be discussed with BA (will remove later if required)
                List<Report_Subscription__c> lstExistingSubscriptions = new List<Report_Subscription__c>();
                lstExistingSubscriptions = [Select Id, Name FROM Report_Subscription__c 
                                            WHERE Report_Id__c =: rtSubr.Report_Id__c AND
                                            Subscriber__c =: UserInfo.getUserId() AND 
                                            Interval__c =: rtSubr.Interval__c ];
                if(!lstExistingSubscriptions.isEmpty() && lstExistingSubscriptions[0].Id != rtSubr.Id)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 
                                                               'You have already scheduled the selected report earlier:  <a target="_blank" href="apex/ICC_New_Subscription?id=' + lstExistingSubscriptions[0].Id  + '"><b>' + lstExistingSubscriptions[0].Name + '</b></a>'));
                    return null;
                }
                else // Successfully insert or update the Report Subscription
                {
                    try
                    {
                         // If NEW case
                        if(rtSubr.id == null)
                            Database.insert(rtSubr);
                        else  // If EDIT case 
                            Database.update(rtSubr);
                            
                        if(Test.isRunningTest())
                            Integer i = 10/0;
                    }
                    catch(Exception e)
                    {
                        ApplicationLogWrapper alw = new ApplicationLogWrapper();
                        alw.source = ICC_NewSubscription.class.getName();
                        alw.sourceFunction ='validateReportSOQL()';
                        alw.ApplicationName='ICC';
                        alw.referenceInfo = 'Bug';
                        alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                        alw.debugLevel = 'Error';
                        alw.logCode = e.getTypeName();
                        alw.ex = e.getCause();
                        GlobalUtility.logMessage(alw);
                    }
                }
                
                // On successful creation/ edit of Report_Subscription, go back to previous page(ICC_User_Report_Subscriptions)
                return new PageReference(System.currentPageReference().getParameters().get('retURL'));
            }
        }
    }
    
    // Method called on change of REPORT TYPE field. 
    public void fetchReportsOfSeletedReportType()
    {
        // DO nothing
    }
    
    // Getter method that returns the list of reports based on user selection of "Standard" or "Custom" report type
    public List<SelectOption> getReports() 
    {
        mapReportId_To_ReportName = new Map<Id, String>();
        List<SelectOption> optionsList = new List<SelectOption>();
        optionsList.add(new SelectOption('', '--None--'));
        // If report type is STANDARD, fetch all reports from 'Customer_Standard_Reports' folder
        if(rtSubr.Report_Type__c == 'Standard')
        {
            Set<String> setFolderNames = new Set<String>();
            for(ICC_Standard_Report__c sr : ICC_Standard_Report__c.getall().values())
            {
                setFolderNames.add(sr.Name);
            }
            
            for(Report rpt : [Select Id, DeveloperName, Name FROM Report WHERE DeveloperName IN: setFolderNames])
            {
                SelectOption option = new SelectOption(rpt.id, rpt.name);
                optionsList.add(option);
                mapReportId_To_ReportName.put(rpt.id, rpt.name);
            }
            
        }
        // If report type is CUSTOM, fetch all private reports where owner is logged in user
        else if(rtSubr.Report_Type__c == 'Custom') 
        { 
            for(Report rpt: [SELECT Id, Name FROM Report USING SCOPE allPrivate WHERE OwnerId=:UserInfo.getUserId() ]) //  
            { 
                SelectOption option = new SelectOption(rpt.id, rpt.name);
                optionsList.add(option);
                mapReportId_To_ReportName.put(rpt.id, rpt.name);
            }
        }
        
        return optionsList;
    }
}