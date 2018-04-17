/*
Author: Shyam Ravindra Nair
Description: Apex class will act as extension to CuSRApprovalViewForm page.
History:
SNair     22122014     - code creation
SNair     02012015     - added logic for AM.
SNair     04012015     - added logic to navigate automatically to CuSR Form.
SNair     03022015     - added logic Approve and Reject.
SNair     04022015     - added for field validation.
SNair     05022015     - added for field validation.
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/
public class CuSRApprovalViewFormExtension{

    public String recordID{get;set;}
    public CuSR_Approval_Process__c cusrApproval{get;set;}
    public CuSR_Form__c cusrForm{get;set;}
    public String fromCuSRForm{get;set;}
    public String cusrId{get;set;}
    public User loggedInUser{get;set;}
    public Profile loggedInProfile{get;set;}
    public boolean validateAMFields{get;set;}
    public Set<Id> amApproverIdList{get;set;}

    public CuSRApprovalViewFormExtension(ApexPages.StandardController sc){
        loggedInUser = [select Id, Name from User where Id =: userInfo.getUserId()];
        loggedInProfile = [select Id, Name from Profile where Id =: userInfo.getProfileId()];
        cusrApproval = (CuSR_Approval_Process__c)sc.getRecord();
        recordID = cusrApproval.Id;
        fromCuSRForm = ApexPages.currentPage().getParameters().get('fromForm');
        cusrId = ApexPages.currentPage().getParameters().get('cusrFormId'); 
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        if(recordID == null || recordID == ''){
            cusrApproval = new CuSR_Approval_Process__c();
        }
        else{
            String cusrApprovalFields = utilClass.getAllFields('CuSR_Approval_Process__c');
            String cusrApprovalQuery  = 'select '+cusrApprovalFields+' from CuSR_Approval_Process__c where Id = \''+recordID+'\'';
            cusrApproval = Database.query(cusrApprovalQuery);
            String cusrFormFields = utilClass.getAllFields('CuSR_Form__c');
            String cusrFormQuery = 'select '+cusrFormFields+' from CuSR_Form__c where Id = \''+cusrApproval.CuSR_Form__c+'\'';
            cusrForm = Database.query(cusrFormQuery);   
        }
    }
    
    public pageReference back(){
        pageReference pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
        if(cusrApproval.Site__c == 'Dresden'){
            pgRef.getParameters().put('tabname','dresden');
            pgRef.getParameters().put('dresdensubtabname','dresdenapproval');
        }
        else if(cusrApproval.Site__c == 'Singapore'){
            pgRef.getParameters().put('tabname','singapore');
            pgRef.getParameters().put('singaporesubtabname','singaporeapproval');
        }
        else if(cusrApproval.Site__c == 'Malta'){
            pgRef.getParameters().put('tabname','malta');
            pgRef.getParameters().put('maltasubtabname','maltaapproval');
        }
        else if(cusrApproval.Site__c == 'Essex Junction'){
            pgRef.getParameters().put('tabname','essexjunction');
            pgRef.getParameters().put('essexjunctionsubtabname','essexjunctionapproval');
        }
        else if(cusrApproval.Site__c == 'East Fishkill'){
            pgRef.getParameters().put('tabname','eastfishkill');
            pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillapproval');
        }
        else if(cusrApproval.Site__c == 'ASIC'){
            pgRef.getParameters().put('tabname','asic');
            pgRef.getParameters().put('asicsubtabname','asicapproval');
        }
        else if(cusrApproval.Type_of_Approver__c == 'AM'){
            pgRef.getParameters().put('tabname','am');
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public void validateAMFields(){
        validateAMFields = true;
        if(cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c == null || cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c == ''){
                validateAMFields = false;
                cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c.addError('Please make a selection.');
        }
        if(cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c == null || cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c == ''){
                validateAMFields = false;
                cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c.addError('Please make a selection.');
        }
        if(cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c == 'No' && (cusrApproval.If_No_Please_provide_justification__c == '' || cusrApproval.If_No_Please_provide_justification__c == null)){
                validateAMFields = false;
                cusrApproval.If_No_Please_provide_justification__c.addError('Please give justification.');
        }
        if(cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c == 'No' && (cusrApproval.If_No_Please_provide_justification_2__c == '' || cusrApproval.If_No_Please_provide_justification_2__c == null)){
                validateAMFields = false;
                cusrApproval.If_No_Please_provide_justification_2__c.addError('Please give justification.');
        }
        if(cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c == 'Yes' && (cusrApproval.Pricing_quote_reference_number__c == '' || cusrApproval.Pricing_quote_reference_number__c == null)){
                validateAMFields = false;
                cusrApproval.Pricing_quote_reference_number__c.addError('Please enter the Pricing Quote Reference Number.');
        }
    }
    
    public pageReference saveAMData(){
        validateAMFields();
        if(!validateAMFields){
                return null;
        }
        else{
                cusrApproval.Am_Info_Added__c = true;
                update cusrApproval;
                pageReference pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','am');
                pgRef.setRedirect(true);
                return pgRef;
        }
    }
    
    public pageReference amApproved(){
        validateAMFields();
        if(!validateAMFields){
                return null;
        }
        else{
                Id workItemId;
                cusrApproval.AM_Approved_By__c = loggedInUser.Id;
                update cusrApproval;
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(cusrApproval.Comments__c);
                req.setAction('Approve');
                if(loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                    workItemId = getWorkItemIdForAdmin(cusrApproval.Id);
                }
                else{
                    workItemId = getWorkItemId(cusrApproval.Id, loggedInUser.Id);
                }
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
                pageReference pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','am');
                pgRef.setRedirect(true);
                return pgRef;
        }
    }
    
    public pageReference amRejected(){
        validateAMFields();
        if(!validateAMFields){
                return null;
        }
        else{
                Id workItemId;
                update cusrApproval;
                amApproverIdList = new Set<Id>();
                if(cusrApproval.Approver1__c != null){
                    amApproverIdList.add(cusrApproval.Approver1__c);
                }
                if(cusrApproval.Approver2__c != null){
                    amApproverIdList.add(cusrApproval.Approver2__c);
                }
                if(cusrApproval.Approver3__c != null){
                    amApproverIdList.add(cusrApproval.Approver3__c);
                }
                if(cusrApproval.Approver4__c != null){
                    amApproverIdList.add(cusrApproval.Approver4__c);
                }
                if(cusrApproval.Approver5__c != null){
                    amApproverIdList.add(cusrApproval.Approver5__c);
                }
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(cusrApproval.Comments__c);
                req.setAction('Reject');
                if(loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                    workItemId = getWorkItemIdForAdmin(cusrApproval.Id);
                }
                else{
                    workItemId = getWorkItemId(cusrApproval.Id, loggedInUser.Id);
                }
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
                sendEmailAfterAMRejection();
                pageReference pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','am');
                pgRef.setRedirect(true);
                return pgRef;
        }
    }
    
    public void sendEmailAfterAMRejection(){
        List<CuSR_Approval_Process__c> cusrApprovalList = new List<CuSR_Approval_Process__c>(); 
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        Set<Id> ccIdSet = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        if(cusrForm.Customer_Name__c != null){
            Account acc = [select Id, Name from Account where Id =: cusrForm.Customer_Name__c];
            String fieldsAccountTeamProxy = utilClass.getAllFields('Account_Team_Proxy__c');
            fieldsAccountTeamProxy += ', User__r.Name';
            String queryAccountTeamProxy = 'select '+fieldsAccountTeamProxy+' from Account_Team_Proxy__c where Account__c = \''+acc.Id+'\' and Team_Role__c = \'Customer Engineer\'';
            List<Account_Team_Proxy__c> accountTeamProxyList = Database.query(queryAccountTeamProxy);
            //Group pmGroup = new Group();
            for(Account_Team_Proxy__c ce : accountTeamProxyList){
                if((ce.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c) || (ce.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c) || (ce.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c) || (ce.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c) || (ce.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c) || (ce.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c) || (ce.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c) || (ce.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c) || (ce.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c) || (ce.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c) || (ce.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c)){
                    ccIdSet.add(ce.User__c);    
                }
            }
            String approvalFields = utilClass.getAllFields('CuSR_Approval_Process__c');
            String queryApproval = 'select '+approvalFields+' from CuSR_Approval_Process__c where CuSR_Form__c =\''+cusrForm.Id+'\'';
            cusrApprovalList = database.query(queryApproval);
            if(cusrApprovalList.size() > 0){
                for(CuSR_Approval_Process__c cusrApp: cusrApprovalList){
                    if(cusrApp.Approver1__c != null){
                        ccIdSet.add(cusrApp.Approver1__c);
                    }
                    if(cusrApp.Approver2__c != null){
                        ccIdSet.add(cusrApp.Approver2__c);
                    }
                    if(cusrApp.Approver3__c != null){
                        ccIdSet.add(cusrApp.Approver3__c);
                    }
                    if(cusrApp.Approver4__c != null){
                        ccIdSet.add(cusrApp.Approver4__c);
                    }
                    if(cusrApp.Approver5__c != null){
                        ccIdSet.add(cusrApp.Approver5__c);
                    } 
                }
            }
            if(amApproverIdList.size() > 0){
                for(Id approverId: amApproverIdList){
                    ccIdSet.add(approverId);
                }
            } 
            User pmApprover = [select Id, Email from User where Id =: cusrForm.PM_Approved_By__c];   
            List<User> ccUserList = [select Id, Name, Email from User where Id IN: ccIdSet];
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            List<String> ccList = new List<String>();
            
            ccList.add(pmApprover.Email);
            for(User c: ccUserList){
                ccList.add(c.Email);
            }
            singleMail.setTargetObjectId(cusrForm.OwnerId);
            singleMail.setCcAddresses(ccList);
            singleMail.saveAsActivity = false;
            singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for Account '+acc.Name+' is Rejected by Account Manager');
            String body = 'Dear User,';
            body += '<br/>';
            body += '<br/>';
            body += 'Customer Specific Request '+cusrForm.Name+' for Account '+acc.Name+' is Rejected by Account Manager.';
            body += '<br/>';
            body += 'Please click the below link to access the record.';
            body += '<br/>';
            body += '<br/>';
            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
            //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
            body += '<br/>';
            body += '<br/>';
            body += 'Thank you,';
            body += '<br/>';
            body += 'For further clarification/query , please contact the Initiator of the CuSR.';
            body += '<br/>';
            body += 'This is a system generated auto email. Please do not reply.';
            singleMail.setHtmlBody(body);
            mails.add(singleMail);
        }
        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }   
    }
    
    public Id getWorkItemId(Id targetObjectId, Id approverUserId)
    {
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id, p.actorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId and p.actorId =: approverUserId]){
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    public Id getWorkItemIdForAdmin(Id targetObjectId)
    {
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    public pageReference actionOnPageLoad(){
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String cusrApprovalId = '';
        fromCuSRForm = ApexPages.currentPage().getParameters().get('fromForm');
        cusrApprovalId = ApexPages.currentPage().getParameters().get('id');
        if(cusrApprovalId != null || cusrApprovalId != ''){
            String cusrApprovalFields = utilClass.getAllFields('CuSR_Approval_Process__c');
            String cusrApprovalQuery  = 'select '+cusrApprovalFields+' from CuSR_Approval_Process__c where Id = \''+recordID+'\'';
            cusrApproval = Database.query(cusrApprovalQuery);
            String cusrFormFields = utilClass.getAllFields('CuSR_Form__c');
            String cusrFormQuery = 'select '+cusrFormFields+' from CuSR_Form__c where Id = \''+cusrApproval.CuSR_Form__c+'\'';
            cusrForm = Database.query(cusrFormQuery);
        }
        if(fromCuSRForm == 'true'){
            return null;    
        }
        else{
            pageReference pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
            if(cusrApproval.Site__c == 'Dresden'){
                pgRef.getParameters().put('tabname','dresden');
                pgRef.getParameters().put('dresdensubtabname','dresdenapproval');
            }
            else if(cusrApproval.Site__c == 'Singapore'){
                pgRef.getParameters().put('tabname','singapore');
                pgRef.getParameters().put('singaporesubtabname','singaporeapproval');
            }
            else if(cusrApproval.Site__c == 'Malta'){
                pgRef.getParameters().put('tabname','malta');
                pgRef.getParameters().put('maltasubtabname','maltaapproval');
            }
            else if(cusrApproval.Site__c == 'Essex Junction'){
                pgRef.getParameters().put('tabname','essexjunction');
                pgRef.getParameters().put('essexjunctionsubtabname','essexjunctionapproval');
            }
            else if(cusrApproval.Site__c == 'East Fishkill'){
                pgRef.getParameters().put('tabname','eastfishkill');
                pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillapproval');
            }
            else if(cusrApproval.Site__c == 'ASIC'){
                pgRef.getParameters().put('tabname','asic');
                pgRef.getParameters().put('asicsubtabname','asicapproval');
            }
            else if(cusrApproval.Type_of_Approver__c == 'AM'){
                pgRef.getParameters().put('tabname','am');
            }
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
}