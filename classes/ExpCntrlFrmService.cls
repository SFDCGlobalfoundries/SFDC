/*
    Author: Anirban Roy
    Description: This webservice puts the record to On-hold or remove On-Hold. 
                 Called from 'On-Hold','Remove on-hold' button.
    History: 
        ARoy          06262013    - Code creation.
        NBustillos    10012013    - Updated code to also retrieve HtmlValue field on Email Template query.
        ARoy          10022013    - Modified the subject line of the Reopen Export Control Form.
        ARoy          10032013    - Updated the link of the Reopen Export Control Form email body.
        ARoy          10172013    - Added check for reserve mailing capacity to prevent getting error 
                                    due to daily email limit.
*/
global class ExpCntrlFrmService {
    
    // Static variables
    public static String roleGTC = EnvironmentVariable.get('GTC_ROLE');
    public static String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public static String expConStatusSubmit = EnvironmentVariable.get('EXP_CON_STATUS_SUBMIT');
    public static String expConStatusOnhold = EnvironmentVariable.get('EXP_CON_STATUS_ONHOLD');
    
    // Change record type of Export Control Form
    webservice static String changeRecordType(String expConFrmId, String name) {
        try{
            String returnMsg = 'NOT OK';
            String sObjectType = EnvironmentVariable.get('EXPORT_CONTROL_OBJECT_NAME');
            String expConPageLayoutLock = EnvironmentVariable.get('EXP_CON_PG_LAYOUT_LOCK');
            String expConPageLayoutMain = EnvironmentVariable.get('EXP_CON_PG_LAYOUT_MAIN');
            String usrRole = '';
            String profName = '';
            
            Id usrRoleId = UserInfo.getUserRoleId();
            List<UserRole> usrRoleList = [select name from UserRole where Id = :usrRoleId limit 1];
            if(usrRoleList.size()>0){
                usrRole = usrRoleList[0].Name;
            }
            
            Id profId = UserInfo.getProfileId();
            List<Profile> profNameList = [select name from Profile where Id = :profId limit 1];
            if(profNameList.size()>0){
                profName = profNameList[0].Name;
            }
            
            if(usrRole == roleGTC || profName == sysAdmin){
                
                Export_Control_Form__c expConForm = [select Id, Status__c, RecordTypeId                                           
                                                        from Export_Control_Form__c where
                                                        Id = :expConFrmId limit 1];
                if((expConForm.Status__c ==expConStatusSubmit && name == expConPageLayoutLock) 
                        || (expConForm.Status__c ==expConStatusOnhold && name == expConPageLayoutMain)){                    
                    RecordType rt = [select Id from RecordType where 
                                     Name = :name and 
                                     SobjectType = :sObjectType limit 1];
                                     
                    if(expConForm != null && rt != null){           
                        expConForm.RecordTypeId = rt.Id;
                        if(expConForm.Status__c == expConStatusSubmit){
                            expConForm.Status__c = expConStatusOnhold;
                        }else if(expConForm.Status__c == expConStatusOnhold){
                            expConForm.Status__c = expConStatusSubmit;
                        }
                        update expConForm;
                        returnMsg = 'OK';
                    }                   
                }else if(expConForm.Status__c !=expConStatusSubmit && name == expConPageLayoutLock){
                    returnMsg = 'NotSubmitted';
                }else if(expConForm.Status__c !=expConStatusOnhold && name == expConPageLayoutMain){
                    returnMsg = 'NotOnHold';
                }               
            }else{
                returnMsg = 'NotPermitted';             
            }
            return returnMsg;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
    
    webservice static String reOpenRec(String expConFrmId) {
        try{
            String expConStatusApproved = EnvironmentVariable.get('EXP_CON_STATUS_APPROVED');
            String expConStatusPendingResubmission = EnvironmentVariable.get('EXP_CON_STATUS_PENDING_RESUBMISSION');           
            String returnMsg = 'NOT OK';
            String usrRole = '';
            String profName = '';
            
            Id usrRoleId = UserInfo.getUserRoleId();
            List<UserRole> usrRoleList = [select name from UserRole where Id = :usrRoleId limit 1];
            if(usrRoleList.size()>0){
                usrRole = usrRoleList[0].Name;
            }
            
            Id profId = UserInfo.getProfileId();
            List<Profile> profNameList = [select name from Profile where Id = :profId limit 1];
            if(profNameList.size()>0){
                profName = profNameList[0].Name;
            }
            
            if(usrRole == roleGTC || profName == sysAdmin){                                     
                Export_Control_Form__c expConForm = [select Id, Status__c,Name,
                                                    OwnerId__c,Last_Assigned_Customer_User__c, 
                                                    Last_Assigned_Customer_User__r.Email,
                                                    LastModifiedBy__c                                       
                                                    from Export_Control_Form__c where
                                                    Id = :expConFrmId limit 1];
                if(expConForm != null && expConForm.Status__c == expConStatusApproved){
                    expConForm.Status__c = expConStatusPendingResubmission;
                    expConForm.OwnerId__c = expConForm.Last_Assigned_Customer_User__c;
                    update expConForm;
                    sendMail(expConForm);
                    returnMsg = 'OK';
                }else if(expConForm != null && expConForm.Status__c != expConStatusApproved){
                    returnMsg = 'NotApproved';
                }
            }else{
                returnMsg = 'NotPermitted';             
            }
            return returnMsg;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
    
    //send the Mail 
    private static void sendMail(Export_Control_Form__c expConForm){        
        
        // get the email template
        EmailTemplate emailTemp = [SELECT id, Subject, Body, HtmlValue from EmailTemplate where name = 'Reopen Export Control Form'];
        String emailTempBody = emailTemp.HtmlValue;
        String emailSub = emailTemp.Subject;
        String expName = expConForm.Name!=null?expConForm.Name:'';
        emailSub = emailSub.replace('{!Export_Control_Form__c.Name}',expName);
        String devId;
        
        // sending the mail
        String[] toAddresses = new String[] {expConForm.Last_Assigned_Customer_User__r.Email};      
        List<String> ccAddresses = new List<String>();
        
        List<Device_Export_Control_Junction__c> devExpConJuncList = [select         id,
                                                                                    Device_Name__c,
                                                                                    Device__c,
                                                                                    CRM_Device_ID__c,
                                                                                    Project_Name__c
                                                                     from           Device_Export_Control_Junction__c
                                                                     where          Export_Control_Form__c = :expConForm.Id 
                                                                     order by       createdDate asc];
        
        if(devExpConJuncList!=null && devExpConJuncList.size()>0){ 
            devId = devExpConJuncList[0].Device__c;        
        }
        
        Id accountId = DeviceHelper.getAccountIdbyDeviceId(devId);
        ccAddresses.addAll(DeviceHelper.getFEAMEmails(accountId));

        String textBody = null;
        String htmlBody = getEmailBody(expConForm, emailTempBody, devExpConJuncList); 
        String replyTo = 'do-not-reply@globalfoundries.com';
        String senderDisplayName = 'No Reply';
        try{
            Integer noOfToRecipient = 0;
            Integer noOfCCRecipient = 0;
            if(toAddresses!=null){
                noOfToRecipient = toAddresses.size();
            }
            if(ccAddresses!=null){
                noOfCCRecipient = ccAddresses.size();
            }
            Messaging.reserveSingleEmailCapacity(noOfToRecipient+noOfCCRecipient);
            EmailUtil.sendEmail(emailSub, textBody, htmlBody, toAddresses, ccAddresses, replyTo, senderDisplayName);
        }catch(Exception e){
            system.debug('Error in sending mail===>'+e.getMessage());
        }
                            
    }
    
    private static String getEmailBody(Export_Control_Form__c expConForm, String emailBody, List<Device_Export_Control_Junction__c> devExpConJuncList){
        
        String lastModByName = expConForm.LastModifiedBy__c!=null?expConForm.LastModifiedBy__c:'';
        String expName = expConForm.Name!=null?expConForm.Name:'';
        String expConLink = EmailUtil.getSFLink('/apex/ExportControlEdit?id=' + expConForm.Id);
        if(expConLink==null){
            expConLink='';
        }
        
        if(expConLink!=''){
            expConLink = ' <a href='+expConLink+'>'+expConLink+'</a>';
        }

        emailBody = emailBody.replace('{!Export_Control_Form__c.Name}', expName);
        emailBody = emailBody.replace('{!Export_Control_Form__c.LastModifiedBy__c}', lastModByName);        
        emailBody = emailBody.replace('{!Export_Control_Form__c.Link}',expConLink);
        
        String deviceTable = '<table border="1" cellpadding="2"><th>CRM Device ID</th><th>CRM Device Name</th><th>Project Name</th>';
        for(Device_Export_Control_Junction__c devExpConJunc : devExpConJuncList){
            deviceTable += '<tr><td>'+(devExpConJunc.CRM_Device_ID__c!=null?devExpConJunc.CRM_Device_ID__c:'')+'</td>';
            deviceTable += '<td>'+(devExpConJunc.Device_Name__c!=null?devExpConJunc.Device_Name__c:'')+'</td>';
            deviceTable += '<td>'+(devExpConJunc.Project_Name__c!=null?devExpConJunc.Project_Name__c:'')+'</td></tr>';
        }
        deviceTable += '</table>'; 
        emailBody = emailBody.replace('#DEVICELIST#', deviceTable);
        emailBody = emailBody.replace('<![CDATA[','');
        emailBody = emailBody.replace(']]>','');
        return emailBody;
        
    }  
}