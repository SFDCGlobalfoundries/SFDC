/*
 @class: FMSEmailTemplates
 @CreatedBy: Inshu Misra
 @CreatedDate: 24 Aug, 2016
 @Description: Class created to have all the email templates used for FMS notifications...#IM
 @Modifications-
    Date            Name            Comments
    23-Nov-2016     Inshu Misra     modified the parameters to send emails when save button is clicked
    30-Nov-2016     Inshu Misra     added logic for device creation notification
    6-Dec-2016      Inshu Misra     Added code for exception framework...#IM
    08-Feb-2017 Inshu Misra     modified to include the reason for state change in respective email template
    12-June-2017  Ram Rai      Issue 354 fixed
    21-June-2017    Inshu Misra     Fixed unnecessary email on RIT form Update...#IM
    17-July-2017    Inshu Misra     Step Plan Reviewers Email Issue #423
    25-Aug-2017     ARoy            Modifiying the email link for external and internal users 
 *
 */
public class FMSEmailTemplates {
    public static String Form_Create_Subject_SP = 'Preliminary Step Plan is awaiting your review (FMS form ID ${form.name})';
    public static String Form_Create_Subject = '${form.customer}: New GLOBALFOUNDRIES form created (${form.name})';
    public static String Form_Create_Body_SP = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>The Preliminary Step Plan for FMS Step Plan form ID ${form.id} is ready for your approval or rejection. Please submit your response at your earliest convenience in order to avoid delays to Release to Mask Build (RTM) cycle times.<br/><br/>Steps for completion:<br/>1. View the Preliminary Step Plan using this link:<br/>${form.externalUrl}<br/>2. Select "Approve" or "Reject" within the form. Please be specific regarding reasons when selecting "Reject".<br/>3. Save & Exit the form using the buttons at the bottom of the page.<br/>4. Submit the form. From Actions menu: select the "Submit Step Plan Rejection" or "Submit Step Plan Approval".<br/>5. Rejected Preliminary Step Plans will repeat the process until an approved Step Plan is completed.<br/><br/>If you require additional assistance, please work with your Technical Representative or forward this email with your comments to {SF Email address}.';//Update Email Links By Aroy - 25082017
    public static String Form_Create_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>A new form was recently created on Salesforce.<br/><br/>You are receiving this notice because this form meets the criteria for one of your subscriptions or you have been automatically subscribed because you previously created, edited, or changed the status of this form.<br/><br/><b>Form creator</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of creation</b>: ${misc.current_timestamp}<br/><br/><b>Form name (ID)</b>: ${form.name} (${form.id})<br/><b>Form description</b>: ${form.description}<br/><b>Form state</b>: ${form.state}<br/><br/><b>Form type</b>: ${template.type}<br/><br/>The form can be viewed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${form.internalUrl}<br/><br/><b>Customer Portal :</b> ${form.externalUrl}';//Update Email Links By Aroy - 25082017
    public static String Form_Url_info = '<br/><br/>If you do not yet have access to Salesforce or cannot view the questionnaire, please contact your GLOBALFOUNDRIES sales representative or field applications engineer.';
    public static String Form_Email_Footer = '<br/><br/>Thank you.<br/><br/>==============================================================';
    public static String Form_Email_Footer_SP = '<br/>This is a system generated e-mail. Please do not reply to this email.';
    public static String Form_Edit_Subject = '${form.customer}: GLOBALFOUNDRIES form edited (${form.name})';
    public static String Form_Edit_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>An existing form was recently edited on Salesforce.<br/><br/>You are receiving this notice because this form meets the criteria for one of your subscriptions or you have been automatically subscribed because you previously created, edited, or changed the status of this form.<br/><br/><b>Form editor</b>: ${event.first_name} ${event.last_name} &nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of edit</b>: ${misc.current_timestamp}<br/><br/><b>Form name (ID)</b>: ${form.name} (${form.id})<br/><b>Form description</b>: ${form.description}<br/><b>Form state</b>: ${form.state}<br/><br/><b>Form type</b>: ${template.type}<br/><br/>${form.change_history}<br/><br/>The form can be viewed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${form.internalUrl}<br/><br/><b>Customer Portal :</b> ${form.externalUrl}';//Update Email Links By Aroy - 25082017
    public static String Blank_Form_Warning_Subject = 'ACTION REQUIRED - Your empty form will be deleted - ${form.customer}: (${form.name})';
    public static String Blank_Form_Warning_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>You have created or subscribed to an empty form on Salesforce. The form does not contain any saved information.<br/><br/>The form will be automatically deleted in {XX} days unless you answer at least one question and save the form. You must take action to prevent deletion. This e-mail is your only warning.<br/><br/><b>Form creator</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of creation</b>: ${misc.current_timestamp}<br/><br/><b>Form name (ID)</b>: ${form.name} (${form.id})<br/><b>Form description</b>: ${form.description}<br/><b>Form state</b>: ${form.state}<br/><br/><b>Form type</b>: ${template.type}<br/><br/>The form can be accessed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${form.internalUrl}<br/><br/><b>Customer Portal :</b> ${form.externalUrl}';//Update Email Links By Aroy - 25082017
    public static String Form_Delete_Subject = '${form.customer}: GLOBALFOUNDRIES form deleted (${form.name})';
    public static String Form_Delete_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>An existing form was recently deleted on Salesforce. This form can no longer be retrieved.<br/><br/>You are receiving this notice because this form meets the criteria for one of your subscriptions or you have been automatically subscribed because you previously created, edited, or changed the status of this form.<br/><br/><b>User who deleted</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of deletion</b>: ${misc.current_timestamp}<br/><br/><b>Deleted form name (ID)</b>: ${form.name} (${form.id})<br/><b>Deleted form description</b>: ${form.description}<br/><b>Deleted form state</b>: ${form.state}<br/><br/><b>Form type</b>: ${template.type}<br/><br/>No link is available to this form because it has been deleted.';
    public static String Form_State_Change_Subject = '${form.customer}: GLOBALFOUNDRIES form state change: ${form.state} (${form.name})';
    public static String Form_State_Change_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>An existing form was recently edited on Salesforce.<br/><br/>You are receiving this notice because this form meets the criteria for one of your subscriptions or you have been automatically subscribed because you previously created, edited, or changed the status of this form.<br/><br/><b>User who made state change</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of state change</b>: ${misc.current_timestamp}<br/><br/><b>Form name (ID)</b>: ${form.name} (${form.id})<br/><b>Form description</b>: ${form.description}<br/><b>Form old state</b>: ${form.oldstate}<br/><b>Form new state</b>: ${form.state}<br/><b>Reason for State Change</b>: ${form.reasonStateChange}<br/><br/><b>Form type</b>: ${template.type}<br/>The form can be viewed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${form.internalUrl}<br/><br/><b>Customer Portal :</b> ${form.externalUrl}';//Update Email Links By Aroy - 25082017
    public static String OLD_DRAFT_FORM_WARNING_Subject = 'ACTION REQUIRED - Your inactive draft form will be deleted - ${form.customer}: (${form.name})';
    public static String OLD_DRAFT_FORM_WARNING_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>You have created or subscribed to an inactive draft form on Salesforce. The form has not been edited in {XXX} days.<br/><br/>The form will be automatically deleted in {YYY} days unless you edit/save or submit the form. You must take action to prevent deletion.<br/><br/><b>Form creator</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of last edit</b>: ${misc.current_timestamp}<br/><br/><b>Form name (ID)</b>: ${form.name} (${form.id})<br/><b>Form description</b>: ${form.description}<br/><b>Form state</b>: ${form.state}<br/><br/><b>Form type</b>: ${template.type}<br/><br/>The form can be accessed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${form.internalUrl}<br/><br/><b>Customer Portal :</b> ${form.externalUrl}';//Update Email Links By Aroy - 25082017
    public static String OLD_FORM_WARNING_Subject_SP = 'REMINDER - Preliminary Step Plan is awaiting your review (FMS form ID ${form.name})';
    public static String OLD_FORM_WARNING_Body_SP = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>This is a reminder for you to approve or reject the Preliminary Step Plan for FMS Step Plan form ID ${form.id}. Please note that delays to the Step Plan approval will impact Release to Mask Build (RTM) cycle times.<br/><br/>Steps for completion:<br/>1. View the Preliminary Step Plan using this link:<br/>${form.externalUrl}<br/>2. Select "Approve" or "Reject" within the form. Please be specific regarding reasons when selecting "Reject".<br/>3. Save & Exit the form using the buttons at the bottom of the page.<br/>4. Submit the form. From Actions menu: select the "Submit Step Plan Rejection" or "Submit Step Plan Approval".<br/>5. Rejected Preliminary Step Plans will repeat the process until an approved Step Plan is completed.<br/>If you require additional assistance, please work with your Foundry Technical Representative.';//Update Email Links By Aroy - 25082017
    public static String Form_Subscription_on_Behalf_Subject = '${form.customer}: Form subscription (${form.name})';
    public static String Form_Subscription_on_Behalf_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>Another user has subscribed on your behalf to a form on Salesforce. You will now receive automatic notices for future events on this form, such as edits, state changes, or deletion. Other existing subscriptions will not be affected.<br/><br/><b>User who subscribed you</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Company (ID)</b>: ${form.customer} (${form.customer.id})<br/><b>Date/time of subscription</b>: ${misc.current_timestamp}<br/><br/><b>Form name (ID)</b>: ${form.name} (${form.id})<br/><b>Form description</b>: ${form.description}<br/><b>Form state</b>: ${form.state}<br/><br/><b>Form type</b>: ${template.type}<br/><br/>The form can be viewed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${form.internalUrl}<br/><br/><b>Customer Portal :</b> ${form.externalUrl}<br/><br/>If you wish to remove your subscription, go to the form and click the &quot;Unsubscribe from this form&quot; link in the &quot;Possible form actions&quot; menu.';//Update Email Links By Aroy - 25082017
    public static String Form_History_Table = '<table border="1" cellpadding="0" cellspacing="0" width="75%"><caption><left><b>List of Modified Fields</b></left></caption><thead><tr><td scope="col"><b>Field Name</b></td><td scope="col"><b>Old Value</b></td><td scope="col"><b>New Value</b></td></tr></thead><tbody>{col}</tbody></table>';
    public static String Form_URL_Error = 'Please contact the administrator for the URL';
    public static String Create_Device = 'Create Device';

    public static Boolean SendEditEmail = true;
    public static String Device_Create_Subject = '${account}: New Device has been created (${device.name})';
    public static String Device_Create_Body = 'Dear GLOBALFOUNDRIES FMS user,<br/><br/>A new device was recently created on Salesforce.<br/><br/><b>Device creator</b>: ${event.first_name} ${event.last_name}&nbsp;&lt; ${event.email} &gt;<br/><br/><b>Account (ID)</b>: ${form.customer} (${form.customer.id})<br/><br/><b>Date/time of creation</b>: ${misc.current_timestamp}<br/><br/><b>Device name </b>: ${device.name} <br/><br/><b>Device Description</b>: ${device.description}<br/><br/><b>Opportunity Program</b>: ${oppty}<br/><br/><b>Opportunity</b>: ${opportunity}<br/><br/><b>Device Sourcing</b>: ${device.sourcing}<br/><br/><b>Device Purpose</b>: ${device.purpose}<br/><br/>Please assign the correct Opportunity and Opportunity Program to the device.<br/>The device can be viewed via the link below. You will be prompted to enter your Salesforce user ID and password.<br/><br/><b>Internal Globalfoundries Portal :</b> ${device.internalUrl}<br/><br/><b>Customer Portal :</b> ${device.externalUrl}';//Update Email Links By Aroy - 25082017
    public static Boolean isRIT = false;
    public static DateTime lmDate = System.now();
    
    /*
     @MethodName: getFormCreateTemplate
     @Parameters: Form_Management_System__c fms
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent when the form is created...#IM
     @Modifications-
      17 Jul-2017		Inshu Misra			Modified against 423              
      *
     */

    public static EmailTemplateGeneral getFormCreateTemplate(Form_Management_System__c fms){
        String subject = Form_Create_Subject;
        
        String body = Form_Create_Body+Form_Url_info+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, fms, null, Label.Form_Create_Email);
        return gen;
    }
    // Code Added By Ram Rai for Issue #423
    public static EmailTemplateGeneral getFormCreateTemplateSP(Form_Management_System__c fms){
        String subject = Form_Create_Subject_SP;  
        //Modified against 423...#IM              
        String body = (Form_Create_Body_SP+Form_Email_Footer+Form_Email_Footer_SP); 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        
        emailContent(gen, fms, null, Label.Form_Create_Email_SP);
        
        return gen;
    }
    /*
     @MethodName: getFormEditTemplate
     @Parameters: Form_Management_System__c fms
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent when the form is edited...#IM
     @Modifications-
     *
     */
    public static EmailTemplateGeneral getFormEditTemplate(Form_Management_System__c fms, Form_Management_System__c fmsOld){
        String subject = Form_Edit_Subject;
        String body = Form_Edit_Body+Form_Url_info+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, fms, fmsOld, Label.Form_Edit_Email);
 
        return gen;
    }
    /*
     @MethodName: getBlankFormWarningTemplate
     @Parameters: Form_Management_System__c fms
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent as a warning to delete the blank form if not worked upon for 28 days...#IM
     @Modifications-
     *
     */
    public static EmailTemplateGeneral getBlankFormWarningTemplate(Form_Management_System__c fms){
        String subject = Blank_Form_Warning_Subject;
        String body = Blank_Form_Warning_Body+Form_Url_info+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, fms, null, Label.Form_Blank_Warning_Email);
 
        return gen;
    }
    /*
     @MethodName: getFormDeleteTemplate
     @Parameters: Form_Management_System__c fmsOld
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent when the form is deleted...#IM
     @Modifications-
     *
     */
    public static EmailTemplateGeneral getFormDeleteTemplate(Form_Management_System__c fmsOld){
        String subject = Form_Delete_Subject;
        String body = Form_Delete_Body+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, null, fmsOld, Label.Form_Delete_Email);
 
        return gen;
    }
    /*
     @MethodName: getFormStateChangeTemplate
     @Parameters: Form_Management_System__c fms, Form_Management_System__c fmsOld
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent when the form state is changed...#IM
     @Modifications-
     *
     */
    public static EmailTemplateGeneral getFormStateChangeTemplate(Form_Management_System__c fms, Form_Management_System__c fmsOld){
        String subject = Form_State_Change_Subject;
        String body = Form_State_Change_Body+Form_Url_info+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, fms, fmsOld, Label.Form_State_Edit_Email);
 
        return gen;
    }
    /*
     @MethodName: getOldDraftWarningTemplate
     @Parameters: Form_Management_System__c fms
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent as a warning when Form is left in Draft State for long...#IM
     @Modifications-
     *
     */
    public static EmailTemplateGeneral getOldDraftWarningTemplate(Form_Management_System__c fms){
        //modified against Issue#423....#IM
        String subject = (fms.Form_Type__c == Label.Form_Type_SP)?OLD_FORM_WARNING_Subject_SP:OLD_DRAFT_FORM_WARNING_Subject;
        String body = (fms.Form_Type__c == Label.Form_Type_SP)?(OLD_FORM_WARNING_Body_SP+Form_Email_Footer+Form_Email_Footer_SP):(OLD_DRAFT_FORM_WARNING_Body+Form_Url_info+Form_Email_Footer); 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        //modified against Issue#423....#IM
        if(fms.Form_Type__c == Label.Form_Type_SP){
            emailContent(gen, fms, null, Label.Form_Create_Email_Sp);
        }else{
            emailContent(gen, fms, null, Label.Form_Old_Warning_Email);
        }
        return gen;
    }
    /*
     @MethodName: getFormSubscriptionOnYourBehalfTemplate
     @Parameters: Form_Management_System__c fms
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to get the template that is sent when subscription is made on behalf of the user...#IM
     @Modifications-
     *
     */
    public static EmailTemplateGeneral getFormSubscriptionOnYourBehalfTemplate(Form_Management_System__c fms){
        String subject = Form_Subscription_on_Behalf_Subject;
        String body = Form_Subscription_on_Behalf_Body+Form_Url_info+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, fms, null, Label.Form_On_Behalf_Email);         
        return gen;
    }
    
    /*
     @MethodName: getDeviceCreateTemplate
     @Parameters: Device__c device
     @ReturnType: EmailTemplateGeneral
     @Author: Inshu Misra
     @CreatedDate: 30 Nov,2016
     @Description: to get the template that is sent when the device is created...#IM
     @Modifications-
     *
     */

    public static EmailTemplateGeneral getDeviceCreateTemplate(Device__c device){
        String subject = Device_Create_Subject;
        String body = Device_Create_Body+Form_Url_info+Form_Email_Footer; 
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        gen.setSubject(subject);
        gen.setBody(body);
        emailContent(gen, device, null, Create_Device);
        return gen;
    }
    /*
     @MethodName: emailContent
     @Parameters: EmailTemplateGeneral etg, SObject obj, SObject objOld, String tempType
     @ReturnType: void
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to build the content of the email based on the selected scenario...#IM
     @Modifications-
        Date            Name            Comments
        30-Nov-2016     Inshu Misra     modified the parameters to make the method more generic and included the logic to send notification on device creation...#IM
        08-Feb-2017     Inshu Misra     modified to include the reason for state change in respective email template
        17-Feb-2017     Inshu Misra     modified the date format
     *
     */    
    private static void emailContent(EmailTemplateGeneral etg, SObject obj, SObject objOld, String tempType){
        String subject = etg.getSubject();
        String body = etg.getBody();
        if(tempType == Create_Device){
            Device__c device = (Device__c)obj;
            subject = subject.replace('${account}', device.Account__r.Name);
            subject = subject.replace('${device.name}', device.Name);
            body = body.replace('${event.first_name} ${event.last_name}', device.createdBy.Name);
            body = body.replace('${event.email}', device.createdBy.Email);
            body = body.replace('${form.customer}', device.Account__r.Name);
            body = body.replace('${form.customer.id}', getSAPAccID(device.Account__c));
            body = body.replace('${misc.current_timestamp}', formatDate(device.CreatedDate));
            body = body.replace('${device.name}', device.Name);
            body = body.replace('${device.description}', ((device.Device_Description__c!=null)?device.Device_Description__c:''));
            body = body.replace('${oppty}', device.Opportunity_Program__r.Name);
            body = body.replace('${opportunity}', device.Opportunity2__r.Name);
            body = body.replace('${device.sourcing}', device.Device_Sourcing__c);
            body = body.replace('${device.purpose}', ((device.Device_Purpose__c!=null)?device.Device_Purpose__c:''));
            body = body.replace('${device.internalUrl}', getURL(Create_Device, device.Id,'Internal'));//Update Email Links By Aroy - 25082017 
            body = body.replace('${device.externalUrl}', getURL(Create_Device, device.Id,'External'));//Update Email Links By Aroy - 25082017        
        }else{
            Form_Management_System__c fms = (Form_Management_System__c)obj;
            Form_Management_System__c fmsOld = (Form_Management_System__c)objOld;

            if(tempType != Label.Form_Create_Email_Sp){
                subject = subject.replace('${form.customer}', (tempType == Label.Form_Delete_Email)?((fmsOld.Customer__c != null && fmsOld.Customer__c != '')?fmsOld.Customer__c:''):((fms.Customer__c != null && fms.Customer__c != '')?fms.Customer__c:''));
                subject = subject.replace('${form.name}', (tempType == Label.Form_Delete_Email)?(fmsOld.Form_Name__c != null?fmsOld.Form_Name__c:''):(fms.Form_Name__c != null?fms.Form_Name__c:''));
            
                body = body.replace('${event.first_name} ${event.last_name}', (tempType == Label.Form_Blank_Warning_Email||tempType == Label.Form_Old_Warning_Email)?(fms.CreatedBy.Name != null?fms.CreatedBy.Name:''):UserInfo.getName());
                body = body.replace('${event.email}', (tempType == Label.Form_Blank_Warning_Email||tempType == Label.Form_Old_Warning_Email)?(fms.CreatedBy.Email != null?fms.CreatedBy.Email:''):UserInfo.getUserEmail());
                body = body.replace('${form.customer}', (tempType == Label.Form_Delete_Email)?((fmsOld.Customer__c != null && fmsOld.Customer__c != '')?fmsOld.Customer__c:''):((fms.Customer__c != null && fms.Customer__c != '')?fms.Customer__c:''));
                body = body.replace('${form.customer.id}', (tempType == Label.Form_Delete_Email)?getSAPAccID(fmsOld.Customer_Name__c):getSAPAccID(fms.Customer_Name__c));
                body = body.replace('${misc.current_timestamp}', (tempType == Label.Form_Create_Email||tempType == Label.Form_Blank_Warning_Email)?formatDate(fms.CreatedDate):formatDate(System.now()));
                body = body.replace('${form.name}', (tempType == Label.Form_Delete_Email)?(fmsOld.Form_Name__c != null?fmsOld.Form_Name__c:''):(fms.Form_Name__c != null?fms.Form_Name__c:''));
                body = body.replace('${form.description}', (tempType == Label.Form_Delete_Email)?(fmsOld.Form_Description__c != null?fmsOld.Form_Description__c:''):(fms.Form_Description__c != null?fms.Form_Description__c:''));
                body = body.replace('${form.state}', (tempType == Label.Form_Delete_Email)?(fmsOld.State_of_the_Form__c != null?fmsOld.State_of_the_Form__c:''):(fms.State_of_the_Form__c != null?fms.State_of_the_Form__c:''));
                body = body.replace('${template.type}', (tempType == Label.Form_Delete_Email)?(fmsOld.Form_Type__c != null?fmsOld.Form_Type__c:''):(fms.Form_Type__c != null?fms.Form_Type__c:''));
            }else{
            //423
                subject = subject.replace('${form.name}', fms.Parent_Form_Id__c != null?(fms.Parent_Form_Id__r.Name != null?fms.Parent_Form_Id__r.Name:''):(fms.Name != null?fms.Name:''));
            }
            
            if(tempType != Label.Form_Delete_Email){
                body = body.replace('${form.internalUrl}', getURL(fms.Form_Type__c, String.valueOf(fms.ID),'Internal'));//Update Email Links By Aroy - 25082017 
                body = body.replace('${form.externalUrl}', getURL(fms.Form_Type__c, String.valueOf(fms.ID),'External'));//Update Email Links By Aroy - 25082017
            }
            if(tempType == Label.Form_Edit_Email){
                body = body.replace('${form.change_history}', changeHistory(fms, fmsOld));
                body = body.replace('${form.id}', (fms.Form_Type__c == Label.Form_Type_SP && fms.Parent_Form_Id__c != null)?(fms.Parent_Form_Id__r.Name != null?fms.Parent_Form_Id__r.Name:''):(fms.Name != null?fms.Name:''));//423
            }
            if(tempType == Label.Form_State_Edit_Email){
                subject = subject.replace('${form.state}', fms.State_of_the_Form__c != null?fms.State_of_the_Form__c:'');
                body = body.replace('${form.oldstate}', fmsOld.State_of_the_Form__c != null?fmsOld.State_of_the_Form__c:'');
                body = body.replace('${form.reasonStateChange}', fms.Mandatory_State_Change_Comments__c != null?fms.Mandatory_State_Change_Comments__c:'');
                body = body.replace('${form.id}', (fms.Form_Type__c == Label.Form_Type_SP && fms.Parent_Form_Id__c != null)?(fms.Parent_Form_Id__r.Name != null?fms.Parent_Form_Id__r.Name:''):(fms.Name != null?fms.Name:''));//423
            }
            if(tempType == Label.Form_Blank_Warning_Email){
                body = body.replace('{XX}', String.valueOf(fms.Days_left_for_deletion__c));
                if(fms.Form_Type__c != Label.Form_Type_SP){
                    subject = subject.replace('empty form', 'empty preliminary form');
                    body = body.replace('empty form', 'empty preliminary form');
                }
            }
            if(tempType == Label.Form_Old_Warning_Email){
                body = body.replace('{XXX}', String.valueOf(28-fms.Days_left_for_deletion__c));
                body = body.replace('{YYY}', String.valueOf(fms.Days_left_for_deletion__c));
                if(fms.Form_Type__c != Label.Form_Type_SP){
                    subject = subject.replace('draft form', 'preliminary form that is waiting for review');
                    body = body.replace('draft form', 'preliminary form that is waiting for review');
                }
            }     
            body = body.replace('${form.id}', (tempType == Label.Form_Delete_Email)?(fmsOld.Name != null?fmsOld.Name:''):(fms.Name != null?fms.Name:''));//423
        }
        etg.setSubject(subject);
        etg.setBody(body);
    }
    /*
     @MethodName: changeHistory
     @Parameters: Form_Management_System__c fms
     @ReturnType: String
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to build the table for Form Edit History...#IM
     @Modifications-
     *
     */
    private static String changeHistory(Form_Management_System__c fms, Form_Management_System__c fmsOld){
        String table = Form_History_Table;
        String col = '';
        for(Form_System_History__c hist:getHistory(fms, fmsOld)){
            col += '<tr><td>'+hist.Field_Name__c+'</td><td>'+(hist.Old_Value__c!=null?hist.Old_Value__c:'')+'</td><td>'+(hist.New_Value__c != null?hist.New_Value__c:'')+'</td></tr>';
        }
        table = table.replace('{col}', col);
        return table;
    }
    /*
     @MethodName: getHistory
     @Parameters: Form_Management_System__c fms
     @ReturnType: List<Form_System_History__c>
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to retrieve the Form Edit History...#IM
     @Modifications-
     *
     */
    public static List<Form_System_History__c> getHistory(Form_Management_System__c fms, Form_Management_System__c fmsOld){
        List<Form_System_History__c> historyList = new List<Form_System_History__c>();
        DateTime fmsModDate = fms.LastModifiedDate;
        if(isRIT){
            fmsModDate = lmDate;
        }
        String query = 'select Field_Name__c, New_Value__c, Old_Value__c,CreatedDate from Form_System_History__c where Main_Form__c =\''+ fms.ID +'\'and CreatedDate >=: fmsModDate and Field_Name__c != \'Days left for deletion\' and Field_Name__c != \'History Time\' and Field_Name__c != \'ReviewedBy\'';
        historyList = Database.query(query);
        Map<String, Form_System_History__c> his = new Map<String, Form_System_History__c>();
        for(Form_System_History__c h: historyList){
            if(!his.keySet().contains(h.Field_Name__c)){
                his.put(h.Field_Name__c, h);
            }else{
                his.get(h.Field_Name__c).New_Value__c = h.New_Value__c;
            }
            if(his.get(h.Field_Name__c).Old_Value__c == h.New_Value__c){
                his.remove(h.Field_Name__c);
            }
        }
        return his.values();
    }
    /*
     @MethodName: getSAPAccID
     @Parameters: String customer
     @ReturnType: String
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to retrieve the corresponding customer ID...#IM
     @Modifications-
     *
     */ 
    public static String getSAPAccID(String customer){
        String sapID = '';
        List<Account> accList = new List<Account>([SELECT id, Name, SAP_Account_Number__c FROM Account WHERE Id = :customer LIMIT 1]);  
        if(accList.size() > 0 && accList[0].SAP_Account_Number__c != null){ 
            sapID = accList[0].SAP_Account_Number__c.subString(0,6);   
        }
        return sapID;
    }
    /*
     @MethodName: getURL
     @Parameters: String formType, String formID
     @ReturnType: String
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: to build the URL to view the particular form...#IM
     @Modifications-
     *
     */
    public static String getURL(String formType, String formID, String custType){
        Form_Type_URL__c typeUrl = Form_Type_URL__c.getInstance(formType);
        String finalUrl = (typeURL != null && !String.isBlank(typeURL.view_Page__c))?(custType=='Internal'?EnvironmentVariable.get('SFDC_INSTANCE'):EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL'))+'/apex/'+typeURL.view_Page__c+'?Id='+formID:Form_URL_Error;//Update Email Links By Aroy - 25082017
        return finalUrl;
    }
    /*
     @MethodName: createTemplate
     @Parameters: SObject obj, SObject objOld, String temptype, Set<String> userIds
     @ReturnType: Messaging.SingleEmailMessage
     @Author: Inshu Misra
     @CreatedDate: 24 Aug,2016
     @Description: generic method to build the different templates for FMS...#IM
     @Modifications-
    Date      Name        Comments
    30-Nov-2016    Inshu Misra      modified the declaration to make method more generic and modified the definition to send email notification when the device is created
     *
     */
    public static Messaging.SingleEmailMessage createTemplate(SObject obj, SObject objOld, String tempType, Set<String> userIds){
        
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        EmailTemplateGeneral gen = new EmailTemplateGeneral();
        if(tempType == Create_Device){
          Device__c device = (Device__c)obj;
            gen = getDeviceCreateTemplate(device);
        }else{
            Form_Management_System__c fms = (Form_Management_System__c)obj;
            Form_Management_System__c fmsOld = (Form_Management_System__c)objOld;
            if(tempType == Label.Form_Create_Email){
                gen = getFormCreateTemplate(fms);
            }
            if(tempType == Label.Form_Edit_Email && !getHistory(fms, fmsOld).isEmpty()){
                gen = getFormEditTemplate(fms, fmsOld);
            }
            if(tempType == Label.Form_Blank_Warning_Email){
                gen = getBlankFormWarningTemplate(fms);
            }
            if(tempType == Label.Form_Delete_Email){
                gen = getFormDeleteTemplate(fmsOld);
            }
            if(tempType == Label.Form_State_Edit_Email){
                gen = getFormStateChangeTemplate(fms, fmsOld);
            }
            if(tempType == Label.Form_Old_Warning_Email){
                gen = getOldDraftWarningTemplate(fms);
            }
            if(tempType == Label.Form_On_Behalf_Email){
                gen = getFormSubscriptionOnYourBehalfTemplate(fms);
            }
            //added against Issue #423
            if(tempType == Label.Form_Create_Email_SP){
                gen = getFormCreateTemplateSP(fms);                
            }
        }
        if(gen.getSubject() != null && gen.getBody() != null){
            msg.setBccAddresses(new List<String>(userIds));
            msg.setSubject(gen.getSubject());
            msg.setOrgWideEmailAddressId(Label.FMS_From_Address_Id);
            msg.setHtmlBody(gen.getBody().unescapeHtml3());
            return msg;
        }
        
        return null;
    }
    /*
     @MethodName: getSubscribers
     @Parameters: Set<Id> fmsIds, String event
     @ReturnType: Map<Id, Set<String>>
     @Author: Inshu Misra
     @CreatedDate: 25 Aug,2016
     @Description: to get the respective subscribers of the modified/created/deleted forms...#IM
     @Modifications-
     *
     */
    public static Map<Id, Set<String>> getSubscribers(Set<Id> fmsIds, String event){
        Map<Id, Set<String>> fmsIdSubscribersMap = new Map<Id, Set<String>>();
       
        List<FMS_Subscription__c> searchId = new List<FMS_Subscription__c>();
        Set<id> searchIdSet = new Set<id>();
        
        searchId = [select Saved_Search_Id__c from FMS_Subscription__c where Form_Id__c in:fmsIds and Saved_Search_Id__c!=null];
        for(FMS_Subscription__c fm:searchId){
            searchIdSet.add(fm.Saved_Search_Id__c);
        }
        
        String query = 'select Form_Id__c, User_Name__c from FMS_Subscription__c where  Form_Id__c in:{fmsIds}  and Active__c = true and (MySubscriptionId__r.Subscribed_All__c = true OR Saved_Search_Id__c !=null) and {Form_Event} = true';
        query=query.replace('{fmsIds}', 'fmsIds');
        query=query.replace('{searchIdSet}','searchIdSet');
        query=query.replace('{Form_Event}', 
            (event == Label.Form_Create_Email)?'Form_Inserted__c'
            :(event == Label.Form_Edit_Email)?'Form_Updated__c'
            :(event == Label.Form_State_Edit_Email)?'Form_Status_Change__c'
            :'Form_Deleted__c');
        
        for(FMS_Subscription__c sub : Database.query(query)){
            if(fmsIdSubscribersMap.get(sub.Form_Id__c) == null || fmsIdSubscribersMap.get(sub.Form_Id__c).isEmpty()){
                fmsIdSubscribersMap.put(sub.Form_Id__c,new Set<String>()); 
            } 
            fmsIdSubscribersMap.get(sub.Form_Id__c).add(sub.User_Name__c);
        }
        return fmsIdSubscribersMap;
    }
        /*
     @MethodName: sendEmailOnSave
     @Parameters: Form_Management_System__c formObj, Boolean next
     @ReturnType: void
     @Author: Inshu Misra
     @CreatedDate: 21 Sep,2016
     @Description: to prevent sending email on click of next button and storing history time for sending the email further...#IM
     @Modifications-
   Date       Name      Comments
   23-Nov-2016  Inshu Misra    modified the parameters to send emails when save button is clicked
     *
     */
    public static void sendEmailOnSave(Form_Management_System__c formObj, Boolean next, Boolean prev){
        if(formObj != null){
            if(next || prev){
                FMSEmailTemplates.SendEditEmail = false;
                if(formObj.History_Time__c == null){
                    formObj.History_Time__c = System.now();
                }
            }else{
                formObj.History_Time__c = null;
            }
        }
    }
    /*
     @MethodName: sendEmailOnCancel
     @Parameters: Form_Management_System__c formObj
     @ReturnType: void
     @Author: Inshu Misra
     @CreatedDate: 21 Sep,2016
     @Description: to send email when Cancel button is clicked if there are fields updated at the time of form creation/updation...#IM
     @Modifications-
     *
     */
    public static void sendEmailOnCancel(Form_Management_System__c formObj){
        formObj.History_Time__c = null;
        
        try{
            update formObj;
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSEmailTemplates.class.getName(), 'sendEmailOnCancel(Form_Management_System__c formObj)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        

    }
    
    /*
     @MethodName: sendNotificationOnDeviceCreation
     @Parameters: Device__c device
     @ReturnType: void
     @Author: Inshu Misra
     @CreatedDate: 30 Nov,2016
     @Description: to send the email notification to all the respective subscribers whenever the form is inserted/updated/deleted...#IM
     @Modifications-
     *
     */
    public static void sendNotificationOnDeviceCreation(String deviceId) {
        Device__c device = [select Id, Account__r.Name, Name, createdBy.Name, createdBy.Email, Account__c, CreatedDate, Device_Description__c, Opportunity_Program__r.Name, Device_Sourcing__c, Device_Purpose__c,Opportunity2__r.Name from Device__c where Id =: deviceId];
        Boolean isExternalUser = false;
        if (UserInfo.getUserType()!='Standard'){
            isExternalUser = true;            
        } 
        if(isExternalUser){
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            Set<String> IdSubMap = getReceivers(device); 
            if (IdSubMap != null && !IdSubMap.isEmpty()) {
                messages.add(createTemplate(device, null, Create_Device, IdSubMap));
            }
            if (messages != null && !messages.isEmpty()) {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, false);
                for (Messaging.SendEmailResult res: results) {
                    if (!res.success) {
                        System.debug('The email failed to be sent: ' + res.errors[0].message);
                    }
                }
            }
        }
    }
    /*
    @MethodName: sendNotificationOnRITFormCreation
    @Parameters: Form_Management_System__c fms
    @ReturnType: void
    @Author: Inshu Misra
    @CreatedDate: 20 Jun,2017
    @Description: to send the email notification alongwith RIT Dropbox changes to all the respective subscribers whenever the RIT form is updated...#IM
    @Modifications-
    *
    */
    public static void sendNotificationOnRITFormCreation(Form_Management_System__c fms) {
        List < Messaging.SingleEmailMessage > messages = new List < Messaging.SingleEmailMessage > ();
        Set<Id> fmsIdSet = new Set<Id>();
        fmsIdSet.add(fms.Id);
        FMSEmailTemplates.isRIT = true;
        Map < Id, Set < String >> IdSubEditMap = FMSEmailTemplates.getSubscribers(fmsIdSet, Label.Form_Edit_Email); 
        if(IdSubEditMap.get(fms.Id) != null && !IdSubEditMap.get(fms.Id).isEmpty() && FMSEmailTemplates.createTemplate(fms, null, Label.Form_Edit_Email, IdSubEditMap.get(fms.Id)) != null){
            messages.add(FMSEmailTemplates.createTemplate(fms, null, Label.Form_Edit_Email, IdSubEditMap.get(fms.Id))); 
        }
        if(!messages.isEmpty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, false); 
            for (Messaging.SendEmailResult res: results){
                if(!res.success){
                    System.debug('The email failed to be sent: ' + res.errors[0].message);
                }
            }
        }
    }
    
    /*
     @MethodName: getReceivers
     @Parameters: Device__c device
     @ReturnType: Set<String>
     @Author: Inshu Misra
     @CreatedDate: 30 Nov,2016
     @Description: to get the recepients of the device creation notification...#IM
     @Modifications-
     *
     */
    public static Set<String> getReceivers(Device__c device){
        Set<String> receiverSet = new Set<String>();
        
        for(Account_Team_Proxy__c acc: [select Account__c, User__c, Team_Role__c from Account_Team_Proxy__c where Team_Role__c in ('Field Application Engineer', 'Primary Account Manager', 'Account Manager', 'Primary Field Application Engineer') and Account__c =: device.Account__c]){
            receiverSet.add(acc.User__c);
        }
        return receiverSet;
    }

    /*
    @MethodName: getStepPlanReviewers
    @Parameters: Form_Management_System__c fms
    @ReturnType: Set<Id>
    @Author: Inshu Misra
    @CreatedDate: 19 July,2017
    @Description: method to call step plan reviewers
    @Modifications-
    *
    */
    public static Set<String> getStepPlanReviewers(Form_Management_System__c fms){
        String str = fms.SelAppId__c;
        Set<String> idSet = new Set<String>();
        if(fms.SelAppId__c !=null){
            for(String key : str.split(';')){                    
                idSet.add(key);
            }  
        }                
        return idSet;
    }

    /*
    @MethodName: getPrimaryStepPlanMap
    @Parameters: Form_Management_System__c fms
    @ReturnType: Map<Id, Form_Management_System__c>
    @Author: Inshu Misra
    @CreatedDate: 19 July,2017
    @Description: method to call primary step plan information
    @Modifications-
    *
    */
    public static Map<Id, Form_Management_System__c> getPrimaryStepPlanMap(List<Form_Management_System__c> fmsNew){
        Map<Id,Form_Management_System__c> fmMap = new Map<Id,Form_Management_System__c>();
        Map<Id, Form_Management_System__c> finalMap = new Map<Id, Form_Management_System__c>();
        Set<Id> formParentIds = new Set<Id>();
        for(Form_Management_System__c forms:fmsNew){
            if(forms.Form_Type__c  == Label.Form_Type_SP && forms.Parent_Form_Id__c != null){
                formParentIds.add(forms.Parent_Form_Id__c);
            }
        }
        fmMap = new Map<Id, Form_Management_System__c>([select id,name,Form_Type__c,Selection__c, Mandatory_State_Change_Comments__c, Parent_Form_Id__c,Parent_Form_Id__r.Name,State_of_the_Form__c,Customer__c,Form_Name__c,Customer_Name__c,CreatedDate,Form_Description__c from Form_Management_System__c where Form_Type__c =:Label.Form_Type_SP and Id in: formParentIds]);
        for(Form_Management_System__c forms:fmsNew){
            if(forms.Form_Type__c  == Label.Form_Type_SP && forms.Parent_Form_Id__c != null){
                finalMap.put(forms.Id, fmMap.get(forms.Parent_Form_Id__c));
            }else{
                finalMap.put(forms.Id, forms);
            }
        }
        return finalMap;
    }
    
    /*
     @MethodName: formatDate
     @Parameters: DateTime inputDate
     @ReturnType: String
     @Author: Inshu Misra
     @CreatedDate: 17 Feb,2017
     @Description: to get input DateTime formatted as MMM dd, yyyy HH:mm:ss...#IM
     @Modifications-
     *
     */
    public static String formatDate(DateTime inputDate){
        return inputDate.formatGmt('MMM dd, yyyy HH:mm:ss') + ' GMT';
    }
}