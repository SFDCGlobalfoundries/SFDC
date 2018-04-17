public class ApproverValidatorUtil {

    public static boolean validateQueueMember(List < sobject > TriggeredConfig) {
        boolean isValid = true;

        String profileName = [Select Id, Name from Profile where Id =: userinfo.getProfileId()].Name;
        if (profileName.contains('Admin')) {
            return isValid;
        }
        getApprovalDetail(TriggeredConfig);

        return isValid;
    }

    public static map < string, ProcessInstanceStep > getApprovalDetail(List < sobject > TriggeredConfig) {
        set < string > setConfigId = new set < string > ();
        String profileName = [Select Id, Name from Profile where Id =: userinfo.getProfileId()].Name;

        for (sobject obj: TriggeredConfig) {
            if (Approval.isLocked(obj.Id)) {
                setConfigId.add(obj.Id);
            }
        }
        map < string, ProcessInstanceStep > mapProcess = new Map < string, ProcessInstanceStep > ();
        set < string > setGroupId = new set < string > ();

        for (ProcessInstanceStep obj: [Select p.ProcessInstance.TargetObjectId, p.ProcessInstanceId, p.OriginalActor.Type, p.OriginalActorId, p.ActorId, stepstatus, createddate, OriginalActor.Name From ProcessInstanceStep p where ProcessInstance.LastModifiedById =: Userinfo.getUserId() and ProcessInstance.TargetObjectId IN: setConfigId and StepStatus = 'Approved'
                order by CreatedDate desc, ProcessInstance.CreatedDate desc limit 1
            ]) {

            mapProcess.put(get15DigitSubstring(obj.ProcessInstance.TargetObjectId), obj);
            string strOriginalActorId = obj.OriginalActorId;
            if (obj.OriginalActorId != null && strOriginalActorId.startsWith('00G')) {
                setGroupId.add(obj.OriginalActorId);
            }
        }

        if (setGroupId.size() > 0) {
            Map < String, Set < string >> mapGroupMemberId = new Map < String, Set < string >> ();
            for (GroupMember objGroupMember: [Select g.UserOrGroupId, g.GroupId From GroupMember g where GroupId IN: setGroupId]) {
                String strUserOrGroupId = get15DigitSubstring(objGroupMember.UserOrGroupId);
                if (objGroupMember.UserOrGroupId != null && strUserOrGroupId.startsWith('005')) { //only pick user
                    String strGroupId = get15DigitSubstring(objGroupMember.GroupId);
                    if (mapGroupMemberId.get(strGroupId) == null) {
                        mapGroupMemberId.put(strGroupId, new Set < string > ());
                    }
                    mapGroupMemberId.get(strGroupId).add(strUserOrGroupId);
                }
            }

            for (sobject config: TriggeredConfig) {
                string strProposalId = get15DigitSubstring(config.id);
                if (mapProcess.get(strProposalId) != null) {
                    ProcessInstanceStep objProcess = mapProcess.get(strProposalId);
                    system.debug('objProcess===' + objProcess);
                    system.debug(' objProcess.OriginalActor.Name===' + objProcess.OriginalActor.Name);

                    if (!Test.isRunningTest() && mapGroupMemberId.get(get15DigitSubstring(objProcess.OriginalActorId)) != null && !mapGroupMemberId.get(get15DigitSubstring(objProcess.OriginalActorId)).contains(get15DigitSubstring(UserInfo.getUserId()))) {

                        config.addError('<br><br><font size="3" color="red"> Only Authorized Users from ' + objProcess.OriginalActor.Name + ' Team are allowed to approve this Configuration.</font><br><br> ' +
                            'Click <a href=/' + config.id + '>here </a>  to return to the configuration page', false);
                        // isValid=false;
                        mapProcess.remove(strProposalId);

                    }
                }
            }
        }

        return mapProcess;
    }

    private static string get15DigitSubstring(string strId) {
        return strId.substring(0, 15);
    }

    /*public static Map < string, string > getUserType(List < sobject > TriggeredConfig) {
        Map < string, string > mapUserType = new Map < string, string > ();

        String profileName = [Select Id, Name from Profile where Id =: userinfo.getProfileId()].Name;
        String strType = '';
        if (UserInfo.getUserType() != 'Standard') {
            strType = 'Unauthorized';
        }

        if (profileName.contains('Admin')) {
            strType = 'Admin';
        }

        if (strType != '') {
            for (sobject config: TriggeredConfig) {
                mapUserType.put(config.id, strType);
            }
        } else {
            Map < string, ProcessInstanceStep > mapProcess = getApprovalDetail(TriggeredConfig);
            for (sobject config: TriggeredConfig) {
                strType = 'Unauthorized';
                string strProposalId = get15DigitSubstring(config.id);
                if (mapProcess.get(strProposalId) != null) {
                    String strQueueName = mapProcess.get(strProposalId).OriginalActor.Name;
                    if (strQueueName.startsWithIgnoreCase('Packaging Users')) {
                        strType = 'PackagingUser';
                    }
                    if (strQueueName.startsWithIgnoreCase('PI/YE Users')) {
                        strType = 'PIYEUser';
                    }
                }
                mapUserType.put(config.id, strType);
            }
        }

        return mapUserType;
    }*/
    /*public static void setApproverDetail(Apttus_Proposal__Proposal__c configuration) {
        setApproverDetail(new List < Apttus_Proposal__Proposal__c > { configuration });
    }*/

    public static void setApproverDetail(List < Apttus_Proposal__Proposal__c > lstconfiguration,boolean isAssignFAE) {
        Set < id > setConfigId = new set < id > ();
        map < string, set < string >> mapUserId = new map < string, set < string >> ();
        map < id, Apttus_Proposal__Proposal__c > mapConfig = new map < id, Apttus_Proposal__Proposal__c > ();

        for (Apttus_Proposal__Proposal__c obj: lstconfiguration) {
            setConfigId.add(obj.id);
            mapConfig.put(obj.id, obj);
        }
      
    
        set < string > setFabName = new set < string > ();
        set < string > setPTNumber = new set < string > ();
        set < string > setAccount = new set < string > ();

        List < Apttus_Proposal__Proposal__c > lstConfig = [select id, Fab_Name__c, Process_Technology_Lookup__r.Name, Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where id IN: setConfigId];
        for (Apttus_Proposal__Proposal__c objConfig: lstConfig) {
           if (objConfig.Fab_Name__c != null && objConfig.Fab_Name__c != '') {
                setFabName.add(objConfig.Fab_Name__c);
           }
            if (objConfig.Process_Technology_Lookup__r.Name != null && objConfig.Process_Technology_Lookup__r.Name != '') {
                setPTNumber.add('%' + objConfig.Process_Technology_Lookup__r.Name + '%');
            }
            setAccount.add(objConfig.Apttus_Proposal__Account__c);
        }
        //String strFABName=objConfig.Fab_Name__c;
        //String strPTNUmber=objConfig.Process_Technology_Lookup__r.Name;

    if(!isAssignFAE){
        Set < string > setUserId = new set < string > ();

        String soql = 'select id,PT_Number__c,Fab__c,Approver__c  from ConfiguratorApprovalMatrix__c where Application__c=\'Configurator\' and Fab__c IN:setFabName and PT_Number__c like:setPTNumber and  Approver__r.isActive=true';

        /*if(strPTNUmber!=null && strPTNUmber!=''){
             strPTNUmber ='%' + strPTNUmber  + '%';
            soql=soql+' and PT_Number__c like:strPTNUmber';
        }*/

        for (ConfiguratorApprovalMatrix__c obj: database.query(soql)) {
            List < string > lstPT = obj.PT_Number__c != null ? obj.PT_Number__c.split(',') : new List < string > ();
            string key = '';
            if (lstPT.size() > 0) {
                for (string str: lstPT) {
                    key = (obj.Fab__c + str).toLowerCase();
                    if (mapUserId.get(key) == null) {
                        mapUserId.put(key, new set < string > ());
                    }
                    mapUserId.get(key).add(obj.Approver__c);
                } 
            }
        }
    }
        ConfiguratorApprovalSetting__c objConfiguratorApprovalSetting = ConfiguratorApprovalSetting__c.getOrgDefaults();
        integer proxylimit = (objConfiguratorApprovalSetting.Maximum_Approver__c != null) ? Integer.valueOf(objConfiguratorApprovalSetting.Maximum_Approver__c) : 15;

        proxylimit = proxylimit > 25 ? 25 : proxylimit; //Kanishk: we can't set more than 25 approver 
        
         
        Map < string, set < string >> mapAccountProxy = new Map < string, set < string >> ();
         String soqlQuery='SELECT User__c, Team_Role__c, Account__c from Account_Team_Proxy__c'+
                          ' WHERE User__r.isActive = true and Account__c IN: setAccount';
                          
          if(isAssignFAE){
          	soqlQuery=soqlQuery+' AND ( Team_Role__c=\'Field Application Engineer\''+ 
                                ' OR Team_Role__c=\'Primary Field Technical Support\' '+ 
                                ' OR Team_Role__c=\'Primary Field Application Engineer\''+ 
                                ' OR ( Team_Role__c = \'Account Manager\' AND Is_FAE__c = TRUE)'+
                                ' OR ( Team_Role__c = \'Primary Account Manager\' AND Is_FAE__c = TRUE) )';
          }else{
          	soqlQuery=soqlQuery+' AND Team_Role__c = \'Customer Engineer\' ';
          } 
          
          soqlQuery=soqlQuery+' limit: proxylimit';               
       
        for (Account_Team_Proxy__c obj: database.query(soqlQuery)) {

            if (mapAccountProxy.get(obj.Account__c) == null) {
                mapAccountProxy.put(obj.Account__c, new set < string > ());
            }
            mapAccountProxy.get(obj.Account__c).add(obj.User__c);
        }
        //setUserId.add('00590000001ddHn');
        for (Apttus_Proposal__Proposal__c objConfig: lstConfig) {
        	resetAllValue(proxylimit,objConfig);
            string strKey = objConfig.Fab_Name__c + objConfig.Process_Technology_Lookup__r.Name;
            if(strKey!=null && strKey!=''){
            	strKey=strKey.toLowercase();
            }
            set < string > setAllApprover = new Set < string > ();
            if (mapAccountProxy.get(objConfig.Apttus_Proposal__Account__c) != null) {
                setAllApprover.addAll(mapAccountProxy.get(objConfig.Apttus_Proposal__Account__c));
            }
             if(!isAssignFAE && (mapAccountProxy.get(objConfig.Apttus_Proposal__Account__c)==null || mapAccountProxy.get(objConfig.Apttus_Proposal__Account__c).size()==0) 
             && objConfiguratorApprovalSetting.id!=null && objConfiguratorApprovalSetting.Default_CE__c!=null && objConfiguratorApprovalSetting.Default_CE__c!=''){
            	 setAllApprover.addAll(objConfiguratorApprovalSetting.Default_CE__c.split(','));
            }
            if (mapUserId.get(strKey) != null) {
                setAllApprover.addAll(mapUserId.get(strKey));
            }
             if (setAllApprover.size() == 0) {
             	setAllApprover=getDefaultApprover(objConfiguratorApprovalSetting);
             }
            if (setAllApprover.size() > 0) {
                setApprover(setAllApprover, mapConfig.get(objConfig.id), proxylimit);
            }
        }

    } 
    
    private static set<string> getDefaultApprover(ConfiguratorApprovalSetting__c objConfiguratorApprovalSetting){
    	set<string> setApprover=new Set<string>();
    	if(objConfiguratorApprovalSetting.id!=null && objConfiguratorApprovalSetting.Default_Approver__c!=null && objConfiguratorApprovalSetting.Default_Approver__c!=''){
    		setApprover.addAll(objConfiguratorApprovalSetting.Default_Approver__c.split(','));
    	}
    	
    	return setApprover;
    }
    
    private static void resetAllValue(integer proxylimit,Apttus_Proposal__Proposal__c configuration){
    	 set < string > setObjectField = new set < string > ();
    	 for (string strField: Schema.SObjectType.Apttus_Proposal__Proposal__c.fields.getMap().keySet()) {
            setObjectField.add(strField.toUppercase());
        }
         for (integer ii = 1; ii <= proxylimit; ii++) {
         	string keyField = 'Approver_User_' + ii + '__c';
         	configuration.put(keyField, null);
         }
        
    }
    private static void setApprover(Set < string > setUserId, Apttus_Proposal__Proposal__c configuration, integer proxylimit) {
        set < string > setObjectField = new set < string > ();
        list < string > lst = new List < string > ();
        lst.addAll(setUserId);

        for (string strField: Schema.SObjectType.Apttus_Proposal__Proposal__c.fields.getMap().keySet()) {
            setObjectField.add(strField.toUppercase());
        }

        for (integer ii = 0; ii < lst.size(); ii++) {
            string keyField = 'Approver_User_' + (ii + 1) + '__c';
            if (setObjectField.contains(keyField.toUppercase())) {
                configuration.put(keyField, lst.get(ii));
            }
        }
        if (lst.size() > 0 && proxylimit > lst.size()) {
            integer startIndex = lst.size() + 1;
            //PIYECE_Approver_1 should not be blank . needs to populate first approver to all blank approver list
            for (integer ii = startIndex; ii <= proxylimit; ii++) {
                string keyField = 'Approver_User_' + ii + '__c';
                if (setObjectField.contains(keyField.toUppercase())) {
                    configuration.put(keyField, lst.get(0));
                }
            }
        }
    }

    public static void setEmailtoCEApprover(List < Apttus_Proposal__Proposal__c > lstconfiguration) {
        set < string > setAccount = new set < string > ();
        List < Messaging.SingleEmailMessage > lstSingleEmailMessage = new List < Messaging.SingleEmailMessage > ();

        for (Apttus_Proposal__Proposal__c objConfig: lstconfiguration) {
            setAccount.add(objConfig.Apttus_Proposal__Account__c);
        }

        Map < string, set < string >> mapAccountProxy = new Map < string, set < string >> ();
        for (Account_Team_Proxy__c obj: [SELECT User__c, Team_Role__c, Account__c from Account_Team_Proxy__c
                WHERE User__r.isActive = true and Account__c IN: setAccount
                AND Team_Role__c = 'Customer Engineer'
            ]) {

            if (mapAccountProxy.get(obj.Account__c) == null) {
                mapAccountProxy.put(obj.Account__c, new set < string > ());
            }
            mapAccountProxy.get(obj.Account__c).add(obj.User__c);
        }



        OrgWideEmailAddress[] owdEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
        String strDefaultAddress = '';
        if (owdEmail != null && owdEmail.size() > 0) {
            strDefaultAddress = owdEmail.get(0).Id;
        }

        EmailTemplate objTemplate = [Select id from EmailTemplate where developername = 'CUSTOMER_ENGINEER_NOTIFICATION'];
        /* contact id is needed for custom object to set as setWhatId otherwise object detail will not populated in template body*/
        String contactId = null;
        List < Contact > lstEmail = new List < Contact > ();

        lstEmail = [select id from contact where email = 'noreply@salesforce.com'
            limit 1
        ];
        if (lstEmail.size() == 0) {
            contactId = [select id from contact where email != null limit 1].id;
        } else {
            contactId = lstEmail.get(0).id;
        }




        for (Apttus_Proposal__Proposal__c objConfig: lstconfiguration) {
            if (mapAccountProxy.get(objConfig.Apttus_Proposal__Account__c) != null) {
                List < String > toAddress=new list<string>();
                toAddress.addAll(mapAccountProxy.get(objConfig.Apttus_Proposal__Account__c));
                lstSingleEmailMessage.add(createEmailNotificationEnvelop(String.valueOf(objConfig.id),
                    strDefaultAddress, String.valueOf(objTemplate.id),toAddress , contactId));
            }
        }
        if (lstSingleEmailMessage != null && lstSingleEmailMessage.size() > 0) {
            Messaging.sendEmail(lstSingleEmailMessage);
        }
    }
   
   @TestVisible
    private static Messaging.SingleEmailMessage createEmailNotificationEnvelop(String TargetID, string owdEmail, string templateId,
        List < String > toAddress, String contactId) {

        if (test.IsRunningTest() == true && toAddress.size()==0) {
            toAddress = new String[] { 'no-reply@salesforce.com' };
        }


        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(contactId);

        /* the targetObjectId is supplied as the WhoId field for template rendering but isn’t a recipient of the email*/
        mail.setTreatTargetObjectAsRecipient(false);
        //mail.setTargetObjectId(ActorID);

        List < String > lstTempCCAddress = new List < String > ();

        if (toAddress != null && toAddress.size() > 100) {
            List < List < String >> lstSublist = makeSublist(toAddress, 100);
            toAddress = lstSublist.get(0);
 
            if (lstSublist.size() > 1) {
                lstSublist = makeSublist(lstSublist.get(1), 25);
                lstTempCCAddress = lstSublist.get(0);
            }
        }

        mail.setToAddresses(toAddress);
        if (lstTempCCAddress != null && lstTempCCAddress.size() > 0) {
            mail.setBCCAddresses(lstTempCCAddress);
        }

        mail.setTemplateId(templateId);
        if (owdEmail != null && owdEmail != '') {
            mail.setOrgWideEmailAddressId(owdEmail);
        }
        mail.saveAsActivity = false;
        mail.setWhatId(TargetID);
        return mail;
    }
    
 @TestVisible
    private static List < List < String >> makeSublist(List < String > lstOrginalList, Integer sublislSize) {
        List < List < String >> lstSublist = new List < List < String >> ();
        List < String > lstTemlSublist = new List < String > ();

        if (lstOrginalList == null) {
            return null;
        }

        for (integer ii = 0; ii < lstOrginalList.size(); ii++) {
            if (ii > 0 && (Math.mod((ii), sublislSize)) == 0) {
                lstSublist.add(lstTemlSublist);
                lstTemlSublist = new List < String > ();
            }

            lstTemlSublist.add(lstOrginalList.get(ii));
        }
        lstSublist.add(lstTemlSublist);

        return lstSublist;
    }

}