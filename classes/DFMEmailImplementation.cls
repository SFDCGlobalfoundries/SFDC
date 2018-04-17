/*
* @ Author :- SUHAS BARGI
* @ Date :- 4 MAR 2016
* @ Description :- Email templates for DFM Records
* @ Change History : Suhas bargi - Added changes for L0 and S0 - 10/08/2016 
*/

public without sharing class DFMEmailImplementation { 
    
    private static Set<Id> PIYE_Users; 
    private static Set<Id> QA_Users;
    private static Set<Id> FabWaiverTeamUsers; 
    
    
    
    // get chip details related to waiver collaborator
    public static List<Waiver_Rule_List__c> getWaiverRuleList(Id drcId1){
        List<Waiver_Rule_List__c> waiverRuleList= [SELECT Account_Manager_Approver__c,Prime_Die_Name__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,RecallApprovalProcess__c,Disagree__c,Old_Image_Path__c,Warning__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:drcId1 order by LastModifiedDate desc];        
        
        return waiverRuleList;           
    }
    
    
    //S1 - DFM user submit the DFM Services Report into Collaborator
    //Review DFM Services Report @Collaborator
    //Approve= Approve to release DFM Services report;  
    //Reject= Push report back to DFM User
    
    public static void DFMServicesApprovalRequest(Wavier_Collaborator__c collaborator){
        
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        List<String> toAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));    
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
           waiverCollaboratorURL = System.Label.DFM_Internal_URL+ '/';
        }
        
        Transient String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Services Collaboration';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>DFM Services Report Approval</h3><br><br><br>'
            
            +'Action Required: Review DFM Services Report in the collaborator <br><br>'                        
            + System.Label.DFM_Internal_URL+ '/'  + collaborator.Id+'<br><br><br>'
            
            +'• Approve  = Approve to release DFM Services report;  <br><br>'
            +'• Reject  = Reject report and Push back to DFM User <br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMServicesApprovalRequest()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }   
        
    }
    
    
    //S2: Item S1 is “Approve”. No action required
    public static void DFMServicesApprovalConfirmation(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        /*Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        } */
        Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);   
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));       
       
        
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Services Collaboration';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>DFM Services Report </h3><br><br><br>'
            
            +'Your request for DFM Services for  '+collaborator.Name+', '+collaborator.Mask_Set_Title__c+'  has been completed. The DFM Services Report is available for your access. <br><br>'                    
           +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
	}
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMServicesApprovalConfirmation()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
    }
    
    //S3: Item S1 is “Reject”. Info DFM User to resubmit the DFM Services Report
    public static void DFMServicesRejectionConfirmation(Wavier_Collaborator__c collaborator){
        
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));     
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Services Collaboration';
        
        // Prepare email body
        String body = '<html>'
            
            +'<h3> <b>Title: </b>DFM Services Report Rejection</h3><br><br><br>'
            
            +'<b> Action Required:</b>  The DFM Services Report for  '+collaborator.Name+', '+collaborator.Mask_Set_Title__c+'  has been rejected. Please check and resubmit. <br><br>'
            +'Collaborator Workflow Status: '+ 'Pending for DFM' +' <br><br><br>'
            +'Access the following URL to see DFM Services Report: <br>'
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMServicesRejectionConfirmation()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
    }
    
    
    
    //S0: Acknowledgement of DFM Services Request : Collaborator is triggered by PTSR to initiate a short flow 
    public static void collaboratorAcknowledgementForShortFlow(Id collaboratorId){
         Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        Set<Id> custIds =  new Set<Id>();
        custIds = DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        Set<Id> contactIds = new Set<Id>();
        List<Portal_Tab_Access__c> accessSetup = [SELECT Id,User__c FROM Portal_Tab_Access__c where PTRF__c=true and Account__r.Short_Name__c=:collaborator.Account_Short_Name__c]; 
        for(Portal_Tab_Access__c accessSetupObj:accessSetup ){
            contactIds.add(accessSetupObj.User__c);
        }
        System.debug('>>>>>>>'+contactIds);        
        System.debug('>>>>>>>'+custIds);
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);  
        if(contactIds<>null && !contactIds.isEmpty()){
        toAddresses.addAll(DfmUtilityCls.getEmailIds(contactIds));
        }
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+',  '+collaborator.Account_Name__c+', DFM Services Collaboration';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b> Acknowledgement of DFM Services Request </h3><br><br><br>'
            
            +'This is to acknowledge your request for DFM Services.  A Collaboration number '+collaborator.Name+' has been created for your design '+collaborator.Mask_Set_Title__c+'.You may visit the following link to check the flow status of your request:<br><br>'                    
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
             +'Access to above links is provided for respective salesforce.com users only. In case you do not have access, please contact your GLOBALFOUNDRIES representative (e.g. Field Application Engineer).'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
             }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'collaboratorAcknowledgementForShortFlow()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
        
    }
    
    //L0: Collaborator is triggered by PTSR to initiate a long flow : Acknowledgement of DFM Review Request	
    public static void collaboratorAcknowledgementForLongFlow(Id collaboratorId){
         Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
        Set<Id> custIds = DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        
        Set<Id> contactIds = new Set<Id>();
        List<Portal_Tab_Access__c> accessSetup = [SELECT Id,User__c FROM Portal_Tab_Access__c where PTRF__c=true and Account__r.Short_Name__c=:collaborator.Account_Short_Name__c]; 
        for(Portal_Tab_Access__c accessSetupObj:accessSetup ){
            contactIds.add(accessSetupObj.User__c);
        }
       
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);  
        if(contactIds<>null && !contactIds.isEmpty()){
        toAddresses.addAll(DfmUtilityCls.getEmailIds(contactIds));
        }
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));            
        
        
        List<Chip__c> chiplist=[select id,Chip_Name__c from Chip__c where Wavier_Collaborator__c=:collaborator.id];
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+',  '+collaborator.Account_Name__c+', DFM Waiver Collaboration ';
            
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b> Acknowledgement of DFM Review Request </h3><br><br>'
            
            +'This is to acknowledge your request for DFM Review.  A Collaboration number '   +collaborator.Name+' has been created for your design :<br><br>';     
            
            body+= '<table border=1 cellspacing="0" cellpadding="3" >';
          if(chiplist.size()>0) body+='<tr> <th>Prime Die</th> ';
            integer count=0;
            if(chiplist.size()>0) {
           for(Chip__c chipname : chiplist)  {
            if(count<=10){
               body+='<tr> <td>'+chipname.Chip_Name__c +' </td> ';
                    count++;
            } 
            }
            }
           body+='</table> <br/>' ; 
           body+=' You may visit the following link to check the flow status of your request:<br><br>'                    
            
             +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
             +'Access to above links is provided for respective salesforce.com users only. In case you do not have access, please contact your GLOBALFOUNDRIES representative (e.g. Field Application Engineer).'
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
              }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'collaboratorAcknowledgementForLongFlow()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    //Item L1, L2, L5, L6, L7a , L10, L11, L15 Template  13/01/2017 Phase 3 Sprint1
    //L1: DFM Review Report sent from Mantis AND all GF-Review-result = “PA” . No action required - [Deprecated]
    public static void DFMReviewSummaryNotification4AllPA(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        setUpPiyeAndQAUsers(collaborator); 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'           
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'           
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    public static void DFMJobRevertedL15(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        setUpPiyeAndQAUsers(collaborator); 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
           /* +'There has been an administrative change of status in the Design Waiver Collaborator. Please kindly login and check.<br>Sorry for any inconvenience caused.<br><br>'           
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'           
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'*/
             +'There has been a request to revert the Waiver Review status. Please kindly login to the Design Waiver Collaborator for the latest status.<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    public static void DFMJobRevertedL16(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        setUpPiyeAndQAUsers(collaborator); 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
        Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        Set<Id> setOfAllApprovers = new Set<Id>();
        if (DE_Users<>NULL && !DE_Users.isEmpty()){ 
            setOfAllApprovers.addAll(DE_Users   );
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = new  List<String> ();      
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Reset of Foundry-to- risk Approval Request '+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            +'Title: Reset of Foundry-to- risk Approval Request <br><br><br>'
            +'There has been an administrative reset of the Foundry-to- Risk Approval Request of the above in the Design Waiver Collaborator.<br><br>'   
            +'Please kindly login and re-enter your option.<br>'        
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'           
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            + System.Label.DFM_Internal_URL+ '/'  + collaborator.Id+'<br><br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //Item L15 Template  13/01/2017 Phase 3 Sprint1
    //L1: DFM Review Report sent from Mantis AND all GF-Review-result = “PA” . No action required - [Deprecated]
    public static void DFMReviewSummaryNotificationL15(Wavier_Collaborator__c collaborator,String custId){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }else if(custId <> null && !String.isEmpty(custId)){
            for (String str : custId.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        setUpPiyeAndQAUsers(collaborator); 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> bccAddresses = new List<String>();
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);     
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        toAddresses.addAll(DfmUtilityCls.getEmailIds(setOfFAEs));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'           
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'           
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //Customer notification to FAE on rule selection having FCD's
     public static void DFMReviewSummaryNotification4AllPA1(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
       
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+' Pending For Foundry '+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'           
            +'Collaborator Workflow Status: '+ ' Pending For Foundry ' +' <br><br>'           
            +'Access the following URL to login to the Design Waiver Collaborator: <br>'
            + System.Label.DFM_Internal_URL+ '/'  + collaborator.Id+'<br><br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    public static void DFMJobClosureNotification(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        Set<Id> submitter =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        toAddresses.addAll(DfmUtilityCls.getEmailIds(submitter));
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+ ' Closed '+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            +'Collaborator Workflow Status: '+ ' Closed ' +' <br><br>'
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //method overload for Id param
    public static void DFMReviewSummaryNotification4AllPA(Id collaboratorId){
      Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
       
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //Item L3,L4 Template  13/01/2017 Phase 3 Sprint1
    public static void DFMReviewSummaryNotificationL3L4(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        
        Set<Id> submitter =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);    
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        system.debug('toAddresses@@@'+toAddresses);
        if(collaborator.Progressbar_staus__c=='Closed') {
        system.debug('Submitter mails '+DfmUtilityCls.getEmailIds(submitter));
        toAddresses.addAll(DfmUtilityCls.getEmailIds(submitter));
        
        }
        system.debug('toAddresses>>>'+toAddresses);
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            ccAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
        }
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator: <br>'
            +waiverCollaboratorURL+ collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4AllPA()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    //L2: DFM Review Report sent from Mantis AND if GF-Review-result = “PA” or “PWA” or “PW” AND
    // at least one GF-Review-result = “PW” or “PWA” . No action required
    
    public static void DFMReviewSummaryNotification4PW(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));         
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
            
            
         
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
        }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification4PW()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
    }
    
    
    //Template  - Release of DRC Report to Customer
    
    public static void drcReleaseReportToCustomer(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmUserIds));
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        //Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status: '+ ' Pending For FAE '+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ 'Pending For FAE '+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator: <br>'
            +waiverCollaboratorURL+ collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        
       
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail(); 
             }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'drcReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
    }
    
    //L3a: DFM Review Report sent from Mantis AND no rule has “eFD” AND at least one rule has GF- Review-result =(“FDCCFCC” OR “iFD”)
    
    //Action: Release approval for DFM Review Report to customer 
    // @Collaborator
    // Proceed to release = Trigger Collaborator to release the DFM Review Report and email notify the customer
    public static void DFMReleaseofReport2CustL3a(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> bccAddresses = new List<String>();
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            ccAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
        }
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        Transient String waiverRuleListFD='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Integer fDruleCount =0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if((rules.Stage__c=='FD' || rules.Stage__c=='IFD'|| rules.Stage__c=='FCC')&& (fDruleCount<9)){               
                waiverRuleListFD+= '<tr>';                 
                if(rules.Design_Rule_Name__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                waiverRuleListFD+='</tr>';
                
                
                
                fDruleCount++;       
            }   
        }
        
        waiverRuleListFD += '</table>';
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        Transient String subject='Your Approval is required:  '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Waiver Collaboration ';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>Release of DFM Review Report to Customer </h3><br>'
            
            +'The DFM Review Report for '+collaborator.Mask_Set_Title__c+' has following non-waived rules: <br><br>' 
            + waiverRuleListFD
            +'<br><br>Action Required: Waiver report is pending your review and approval for release to customer in the DFM Waiver Collaborator  <br>' 
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +'Please select respective Customer and Account Manager in Collaborator.<br>'   
            +'<br><br><br><p><font color="#FF0000"><b> Proceed to release =</b></font> '            
            +'Release DFM Review Report in Collaborator to notify customer to take respective action.</p><br><br><br>'
            
            +'Collaborator Workflow Status: '+ 'Pending for FAE' +' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details:<br>' //TODO
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
             }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReleaseofReport2CustL3a()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
        
        
        
    }
    
    
    //L3b: DFM Review Report sent from Mantis AND at least one rule has “eFD”
    //Action: Release approval for DFM Review Report to customer 
    // @Collaborator
    // Proceed to release = Trigger Collaborator to release the DFM Review Report and email notify the customer
    public static void DFMReleaseofReport2CustL3b(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            
            Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> setOfAllApprovers = new Set<Id>();
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            ccAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
        }
        
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        Transient String waiverRuleListFD='<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id); 
        Integer fDruleCount =0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if((rules.Stage__c=='eFD')&& !(fDruleCount>9)){
                
                
                waiverRuleListFD+= '<tr>';                 
                if(rules.Design_Rule_Name__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Rule_Description__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Stage__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <>null){
                    waiverRuleListFD+='<td bgcolor="white"> '+rules.Final_Stage__c+ '  </td>   ' ;
                }else{
                    waiverRuleListFD+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                waiverRuleListFD+='</tr>';
                
                
                
                fDruleCount++;       
            }   
        }
        
        waiverRuleListFD += '</table>';
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        Transient String subject='Your Approval is required:  '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Waiver Collaboration ';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>Release of DFM Review Report to Customer </h3><br><br>'
            
            +'<h3> The DFM Review Report for '+collaborator.Mask_Set_Title__c+' has following <b> non-waived rules which have been rejected for risk waiver or exceptional arrangement:</b> </h3> <br><br>' 
            + waiverRuleListFD
            +'<br><br>Action Required: Waiver report is pending your review and approval for release to customer in the DFM Waiver Collaborator  <br>' 
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +'Please select respective Customer and Account Manager in Collaborator.<br>'   
            +'<br><br><br><p><font color="#FF0000"><b> Proceed to release =</b></font> '            
            +'Release DFM Review Report in Collaborator to notify customer the rejection.</p><br><br><br>'
            
            +'Collaborator Workflow Status: '+' Pending for FAE '+'<br> <br>'
            +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details:<br>' //TODO
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReleaseofReport2CustL3b()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
        
        
    }
    
    
    //L4: DFM Review Report sent from Mantis AND in Stage “pending FAE” >2days. THEN IF Release Report pending for every 24hrs until closed
    //Release approval for DFM Review Report to customer
    //@Collaborator
    //Proceed to release = Trigger Collaborator to release the DFM Review Report and email notify the customer
    public static void DFM_Reminder_ReleaseofReport2Cust(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            
            Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> ccAddresses = new List<String>();
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status: '+ ' Pending For FAE '+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ 'Pending For FAE '+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator: <br>'
            +waiverCollaboratorURL+ collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
             }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFM_Reminder_ReleaseofReport2Cust()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
    }
    
    
    //L5: Item L3 is “Proceed to release”
    //@Collaborator
    //Customer to select one of the following option:
    //1) Customer agrees to fix the non-waived violations and resubmit
    //2) Customer wants the device to proceed for manufacturing and accepts risk liability due to the unfixed violations
    public static void ResponseRequired4DFMReviewReport(Wavier_Collaborator__c collaborator){
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};        
            Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));

        
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            ccAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
        }
        
        
         bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+ ' Pending For FAE '+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ 'Pending For Customer '+' <br><br>'
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
                }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'ResponseRequired4DFMReviewReport()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
    }
    
    //L6 : Item L5 is pending > 2 days. THEN for every 24hrs until item L5 is closed
    //@Collaborator
    //Customer to select one of the following option:
    //1) Customer agrees to fix the non-waived violations and resubmit
    //2) Customer wants the device to proceed for manufacturing and accepts risk liability due to the unfixed violations
    
    public static void ReminderResponseRequired4DFMReviewReport(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
       
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = new List<String>();
        List<String> bccAddresses = new List<String>();
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));        
        bccAddresses.add('suhasramdas.bargi@globalfoundries.com');
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
              }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'ReminderResponseRequired4DFMReviewReport()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
    }
    
    //L7: At least one GF-Review-result = (“FCC” OR “iFD” OR “eFD”) for >2days. THEN IF Release Report pending for every 24hrs until closed
    //Discuss with customer to encourage a response (agree-to-fix or accept-risk). If no positive response, FAE can trigger for foundry-to-risk approval at the Collaborator
    
    public static void NotificationofCustomerDecisionForReport(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        Set<Id> setOfAllApprovers = new Set<Id>();
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        setUpPiyeAndQAUsers(collaborator); 
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};        
            Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;        
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);  
       // ccAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
       
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmUserIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));       
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        
        //System.debug('>>>>>>>> getWaiverRuleList is getting called with >>>  '+collaborator.Id);
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);     
        // System.debug('>>>>>>>> getWaiverRuleList is getting called with >>>  '+waiverRuleList.size());
       
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        //Subject: <PTSR Service type> Design Waiver Status < External Collaborator status>: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status '+collaborator.Progressbar_staus__c+': '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'There has been a change of status in the Design Waiver Collaborator. Please kindly login and check.<br>'
            
            +'Collaborator Workflow Status: '+ collaborator.Progressbar_staus__c+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator: <br>'
            + System.Label.DFM_Internal_URL+ '/'  + collaborator.Id+'<br><br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
               }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'NotificationofCustomerDecisionForReport()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
    } 
    
    //L8 : FAE trigger foundry-to-risk approval AND at least one rules with Customer final status  = (“FCC” OR “iFD”)
    //Approve/reject by clicking a button in the email body in case of same decision for all open rules:
    //Approve
    //Reject
    //Or open Collaborator for individual selection.
    public static void FoundryToRiskApproval(Wavier_Collaborator__c collaborator,Set<Id> waiverRuleSet){
        
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;        
        Set<Id> setOfAllApprovers = new Set<Id>();
        QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1').keySet():NULL;
        
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};        
            Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        setUpPiyeAndQAUsers(collaborator);
        
        if (DE_Users<>NULL && !DE_Users.isEmpty()){ 
            setOfAllApprovers.addAll(DE_Users   );
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        
        /*L8 a - To  => PIYE, De, QA, AM
			cc =- FAE, Fab waiver team , DRB (DRC)
			URL to Manageall page
		*/
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        //manager & users email which displays approval items list
        /*L8b - 
		To => DFM Manager
		cc => DFM user
		URL to internal collaborator */
        List<String> toAddresses1 = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> ccAddresses1 = DfmUtilityCls.getEmailIds(dfmUserIds);
        
        DfmEmailUtility emailUtilDFMManagers = new DfmEmailUtility(toAddresses1,ccAddresses1,bccAddresses);
        
        List<String> uRoles1 = new List<String>{'Primary Field Application Engineer'};
            Set<Id> setOfFAEs1 = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles1);
        List<String> primaryFAEs = DfmUtilityCls.getEmailIds(setOfFAEs1);
        String primaryFAE;
        if(primaryFAEs <> null && !primaryFAEs.isEmpty()){
            primaryFAE = primaryFAEs.get(0);
        }
        for(String priAM: primaryFAEs){
          if(primaryFAE <> null){
          primaryFAE +=' ; ';
          primaryFAE +=priAM;
          }else{
          primaryFAE=priAM;
          }
        }
        
        List<String> atpManagers1 = new List<String>{'Primary Account Manager'};
            Set<Id> AM_Users1 = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers1);
        List<String> primaryAMs = DfmUtilityCls.getEmailIds(AM_Users1);
        String primaryAM;
        if(primaryAMs <> null && !primaryAMs.isEmpty()){
            primaryAM = primaryAMs.get(0);
        }
        
        for(String priAM: primaryAMs){
          if(primaryAM <> null){
          primaryAM +=' ; ';
          primaryAM +=priAM;
          }else{
          primaryAM=priAM;
          }
        }
        
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);     
        
        Integer fccCount =0;
        Transient String ruleListString = '<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Integer count = 0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if((waiverRuleSet.contains(rules.Id)) && (rules.Final_Stage__c=='FCD' ||rules.Stage__c=='iFD' ||rules.Stage__c=='IFD' ||rules.Stage__c=='FCC') && fccCount<9){
                ruleListString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c<>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Rule_Description__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <> null){
                    ruleListString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <> null){
                    ruleListString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                ruleListString+='</tr>';
                fccCount++;
                
            }
        }
        ruleListString+=' </table>'; 
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        //<PTSR Service type> Design Waiver requesting Foundry-to-Risk: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver requesting Foundry-to-Risk: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>Request Foundry-to-risk Approval</h3><br>'
            
            +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+' have been waived by '+collaborator.FAB__c+' '
            +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules. <br>'
            +'Your approval is required for foundry to accept risk for the below mentioned rules '
            +'(Will communicate as <b> Exceptional Arrangement </b> to the customer once a member from each of the approval groups approves):<br><br>'
            +ruleListString
            +'<br><br> 1) Approve /Reject for all Open rules : <br>'
            +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
            +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
            +'<b>Please contact FAE '+primaryFAE+' and Account Manager '+primaryAM+' before you choose to reject.</b><br><br> '
            +'2) If you need detailed disposition, please open Collaborator<br>'
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +' for approval.<br><br>'
            +'Note:<br> Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br>'
            +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
            +'Collaborator Workflow Status: '+' Pending For Foundry '+' <br><br>'
            
            +'</html>';
            
            Transient String Managerbody = '<html>'
            
            +'<h3> <b>Title: </b>Request Foundry-to-risk Approval</h3><br>'
            
            +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+' have been waived by '+collaborator.FAB__c+' '
            +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules. <br>'
            +'Your approval is required for foundry to accept risk for the below mentioned rules '
            +'(Will communicate as <b> Exceptional Arrangement </b> to the customer once a member from each of the approval groups approves):<br><br>'
            +ruleListString
            +'<br><br> 1) Approve /Reject for all Open rules : <br>'
            +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
            +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
            +'<b>Please contact FAE '+primaryFAE+' and Account Manager '+primaryAM+' before you choose to reject.</b><br><br> '
            +'2) If you need detailed disposition, please open Collaborator<br>'
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +' for approval.<br><br>'
            +'Note:<br> Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br>'
            +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
            +'Collaborator Workflow Status: '+' Pending For Foundry '+' <br><br>'
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            
            emailUtilDFMManagers.htmlBody(Managerbody)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
             }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'FoundryToRiskApproval()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
        
    }
    
    //L9 : FAE trigger foundry-to-risk approval AND open for >2d. THEN IF foundry-to-risk pending for every 24hrs until closed
    //Approve/reject by clicking a button in the email body in case of same decision for all open rules:
    //Approve
    //Reject
    //Or open Collaborator for individual selection.
    
    public static void ReminderFoundryToRiskApproval(Id collaboratorId){
        Wavier_Collaborator__c collaborator = getWaiverCollaborator(collaboratorId);
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;        
        Set<Id> setOfAllApprovers = new Set<Id>();
        
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};        
            Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        setUpPiyeAndQAUsers(collaborator);
        
        if (DE_Users<>NULL && !DE_Users.isEmpty()){ 
            setOfAllApprovers.addAll(DE_Users   );
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        
        /*L8 a - To  => PIYE, De, QA, AM
			cc =- FAE, Fab waiver team , DRB (DRC)
			URL to Manageall page
		*/
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfAllApprovers);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 

        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        //manager & users email which displays approval items list
        /*L8b - 
		To => DFM Manager
		cc => DFM user
		URL to internal collaborator */
        List<String> toAddresses1 = DfmUtilityCls.getEmailIds(dfmManagerIds);
        List<String> ccAddresses1 = DfmUtilityCls.getEmailIds(dfmUserIds);
        
        DfmEmailUtility emailUtilDFMManagers = new DfmEmailUtility(toAddresses1,ccAddresses1,bccAddresses);
        
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);     
        
        Integer fccCount =0;
        Transient String ruleListString = '<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        Integer count = 0;
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if((rules.Final_Stage__c!='WCR' && rules.Final_Stage__c!='FCF' && rules.Final_Stage__c!='PI' && rules.Final_Stage__c!='PW' && rules.Final_Stage__c!='PWA' && rules.Final_Stage__c!='PA') && (fccCount<9)){
                ruleListString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c<>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Rule_Description__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                 if(rules.Prime_Die_Name__c<>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <> null){
                    ruleListString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <> null){
                    ruleListString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                ruleListString+='</tr>';
                fccCount++;
                
            }
        }
        ruleListString+=' </table>'; 
        
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        //<PTSR Service type> Design Waiver requesting Foundry-to-Risk: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver requesting Foundry-to-Risk: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>Foundry-to-Risk Approval  </h3><br>'
            
            +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+' have been waived by '+collaborator.FAB__c+' '
            +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules.<br> '
            +'Your approval is required for foundry to accept risk for the below mentioned rules'
            +'(Will communicate as <b>Exceptional Arrangement</b> to the customer once a member from each of the approval groups approves):<br>'
            +ruleListString
            +'<br><br> 1) If your decision is the same for all of the above rules, you can click on <Approve> or <Reject> directly. <br>'
            +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
            +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
            +'<b>Please contact FAE <FAE> and Account Manager <AM> before you choose to reject. </b><br><br>'
            +'2) If you need detailed disposition, please open Collaborator <hyperlink to Collaborator> for approval.<br>'
            +'Note: <br>Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br><br>'
            +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
            +'Collaborator Workflow Status: '+ ' Pending For Foundry'+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details: <br>' //TODO
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
            
            
            Transient String Managerbody = '<html>'
            
            +'<h3> <b>Title: </b>Foundry-to-Risk Approval  </h3><br>'
            
            +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+' have been waived by '+collaborator.FAB__c+' '
            +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules.<br> '
            +'Your approval is required for foundry to accept risk for the below mentioned rules'
            +'(Will communicate as <b>Exceptional Arrangement</b> to the customer once a member from each of the approval groups approves):<br>'
            +ruleListString
            +'<br><br> 1) If your decision is the same for all of the above rules, you can click on <Approve> or <Reject> directly. <br>'
            +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
            +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
            +'<b>Please contact FAE <FAE> and Account Manager <AM> before you choose to reject. </b><br><br>'
            +'2) If you need detailed disposition, please open Collaborator <hyperlink to Collaborator> for approval.<br>'
            +'Note: <br>Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br><br>'
            +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
            +'Collaborator Workflow Status: '+ ' Pending For Foundry'+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details: <br>' //TODO
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            
        emailUtilDFMManagers.htmlBody(Managerbody)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'ReminderFoundryToRiskApproval()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
    }
    
    
    
    //L12 : Job is closed AND at least one rule is FinalWaiverStatus = (“FD”)
    //Notification of DFM Review Result and Job closure - No Action required.Design is rejected.
    public static void DFMReviewSummaryNotification3(Wavier_Collaborator__c collaborator){
        
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        
        Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        List<String> uRoles1 = new List<String>{'Primary Field Application Engineer'};
            Set<Id> setOfFAEs1 = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles1);
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        
        
        Set<Id> setOfAllApprovers = new Set<Id>();
        Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        setUpPiyeAndQAUsers(collaborator);
        
        if (DE_Users<>NULL && !DE_Users.isEmpty()){ 
            setOfAllApprovers.addAll(DE_Users   );
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        List<String> ccAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        List<String> primaryFAEs = DfmUtilityCls.getEmailIds(setOfFAEs1);
        String primaryFAE;
        if(primaryFAEs <> null && !primaryFAEs.isEmpty()){
            primaryFAE = primaryFAEs.get(0);
        }
        
        for(String priAM: primaryFAEs){
          if(primaryFAE <> null){
          primaryFAE +=' ; ';
          primaryFAE +=priAM;
          }else{
          primaryFAE=priAM;
          }
        }
        
        
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            ccAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(setOfAllApprovers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        
        List<Waiver_Rule_List__c> waiverRuleList = getWaiverRuleList(collaborator.Id);     
        
        Integer fdCount =0;
        String ruleListString = '<table border=1 cellspacing="0" cellpadding="3" bgcolor="grey"> '
            +'<tr> <td bgcolor="#E6E6E6"><b> Design Rule Name </b></td> <td bgcolor="#E6E6E6"><b> Rule Description</b> </td> <td bgcolor="#E6E6E6"><b> Prime Die</b> </td>'
            +'<td bgcolor="#E6E6E6"><b> GF Review Result </b></td> <td bgcolor="#E6E6E6"><b> Final Status </b></td> </tr> ' ;
        
        
        for(Waiver_Rule_List__c rules : waiverRuleList) {
            if((rules.Final_Stage__c=='iFD'|| rules.Final_Stage__c=='FD')&& (fdCount<9)){
                ruleListString+='<tr>';
                if(rules.Design_Rule_Name__c <>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Design_Rule_Name__c+ '  </td>   ' ;
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Rule_Description__c<>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Rule_Description__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Prime_Die_Name__c<>null){
                    ruleListString+='<td bgcolor="white"> '+rules.Prime_Die_Name__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Stage__c <> null){
                    ruleListString+='<td bgcolor="white"> '+rules.Stage__c+'</td>  ';
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                if(rules.Final_Stage__c <> null){
                    ruleListString+='<td bgcolor="white"> '+rules.Final_Stage__c+'</td> '; 
                }else{
                    ruleListString+='<td bgcolor="white"> '+''+ '  </td>   ' ;
                }
                ruleListString+='</tr>';
                fdCount++;
                
            } 
        }
        ruleListString+=' </table>'; 
        
        
        
        Transient String subject='Notification: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c+', DFM Waiver Collaboration ';
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title:</b> Customer Design Rejected  </h3><br>'
            
            +'We regret to inform you that '+collaborator.Account_Name__c+' design in  '+collaborator.PTSR_Number__c+' for '+collaborator.Mask_Set_Title__c+' has been rejected for the following rules: <br>'
            
            + ruleListString
            
            +'<br> Should you require any services for design fixing guidelines or design optimization please do not hesitate to contact '+ primaryFAE + ' for further discussion? <br>'
            +'<b> Action Required:</b> Please kindly take actions to fix the violations and resubmit.<br>'
            +'<br><br>Collaborator Workflow Status: '+collaborator.Workflow_Status__c+' <br>'
            
            +'<br>Access the following URL for Customer login to the Design Waiver Collaborator:<br>'
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'Abbreviation: <br>'
      +'FD = Failed Design  <br>'

            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
           }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMReviewSummaryNotification3()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              } 
        
        
    }
    
    //L13: Job Cancelled . No Action needed
    public static void DFMJobCancellation(Wavier_Collaborator__c collaborator){
        
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        
         Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(custIds);
        toAddresses.addAll(DfmUtilityCls.getEmailIds(setOfFAEs));
        
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            toAddresses.addAll(DfmUtilityCls.getEmailIds(AM_Users));
        }
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> bccAddresses = DfmUtilityCls.getEmailIds(dfmUserIds);        
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        List<String> ccAddresses = new List<String>();
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        
       
        //<PTSR Service type> Design Waiver Request cancellation: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Request cancellation: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+', '+collaborator.Account_Name__c;
        
        // Prepare email body
        Transient String body = '<html>'
            
            +'Services/Review Request  for  '+collaborator.Account_Name__c+' design in  '+collaborator.PTSR_Number__c+' for '+collaborator.Mask_Set_Title__c+' has been <b> cancelled </b> <br>'
            
            +'<br>Access the following URL to login to the Design Waiver Collaborator Job: <br>' //TODO
            +System.Label.DFM_Customer_URL+'/' + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
            }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMJobCancellation()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
        
        
        
    }
    
    
    
    //L14: When super user submit a revert to flow status “Review”
    public static void DFMJobRevertedL14(Wavier_Collaborator__c collaborator){
        
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
            Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
       
        //Set<Id> custIds =  DfmUtilityCls.getCustomers(collaborator.Created_By_Shortname__c,collaborator.Submitted_By_Shortname__c);
        Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
        Set<Id> dwcAllEmails= DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_All_Emails').keySet():NULL; 
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        //setUpPiyeAndQAUsers(collaborator);                
        //toAddresses.addAll(DfmUtilityCls.getEmailIds(FabWaiverTeamUsers));
        List<String> ccAddresses =  new List<String>();    
        List<String> bccAddresses = new List<String>();
        bccAddresses.addAll(DfmUtilityCls.getEmailIds(dwcAllEmails));
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmUserIds));
        ccAddresses.addAll(DfmUtilityCls.getEmailIds(dfmManagerIds));    
            DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        
        
        
        
        //<PTSR Service type> Design Waiver Status Revert: <Collaborator-number>, <PTSR-XXXX-X> <Maskset name>_<Primedie name>, <Customer Name>
        Transient String subject=collaborator.PTSR_Service_Type__c+' Design Waiver Status Revert: '+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+' , '+collaborator.Account_Name__c;
        
        Transient String body = '<html>'
            +'There has been a request to revert the Waiver Review status. Please kindly login to the Design Waiver Collaborator for the latest status.<br><br>'
           
            
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();
         }
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DFMEmailImplementation', 'DFMJobRevertedL14()', String.valueOf(collaborator.Id), 'DFM email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }
        
        
    }
    
    
    public static void setUpPiyeAndQAUsers(Wavier_Collaborator__c collaborator){
        //system.debug('Inside setUpPiyeAndQAUsers ########## ');
        // collaborator = getWaiverCollaborator(drcId);
        // prepare To addresses   
        if (collaborator.FAB__c.contains('1')){
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1').keySet():NULL;      
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;
        } else if (collaborator.FAB__c.contains('8')){
            
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8').keySet():NULL;
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team').keySet():NULL;
        }  else if (collaborator.FAB__c.contains('7')){
            
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7').keySet():NULL;
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team').keySet():NULL;
        }  else if (collaborator.FAB__c.contains('9')){
            
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9').keySet():NULL;
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team').keySet():NULL;
        } 
        
        
    }
    
    // retrive customer specific waiver collaborator records
    public static Wavier_Collaborator__c getWaiverCollaborator(Id drcId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : getFields()) {
            query += f.getFieldPath() + ', ';
        }
        
        query +=  'Account_Manager_Approver1__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,'
            +'Approval_Field_Engineer__c,CreatedById,CreatedDate,Customer_Full_Name__c,'           
            +'DRB_Group_uIds__c,Selected_Customers__c,'       
            +'Id,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,Is_releasedToCustomer__c,'
            +'LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,MantisId__c,'
            +'Prime_Die_Name__c  '
            +' FROM Wavier_Collaborator__c WHERE Id =:drcId LIMIT 1';
        
        return Database.query(query);
    }
    
     
    
    // get waiver collaborator field information from respective field sets
    public static List<Schema.FieldSetMember> getFields() {
        boolean isStandardUser;
        boolean isPortalUser ;
        boolean isDfmUser ;
        boolean isDfmManager;
        if (UserInfo.getUserType()!='Standard'){
            isStandardUser = false;
            isPortalUser = true;
            return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_Custome_View.getFields();
            
        } else {
            //system.debug('String.ValueOf(UserInfo.getUserId()) >>>>>>>>> '+String.ValueOf(UserInfo.getUserId()));
            //system.debug('Condition satisfied Its portal User >>>>>>>>>>');
            isStandardUser = true;
            isPortalUser = false;
            
        }
        return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_FAE_View.getFields();
    }
    
 
    
    
}