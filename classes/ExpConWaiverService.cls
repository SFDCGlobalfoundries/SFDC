/*
    Author: Anirban Roy
    Description: This webservice sends the Export Control Waiver Notification to the GTC and cc to AM/FE/system.crm@globalfoundries.com.
    History: 
        ARoy      09092013    - Code creation.
        ARoy      10172013    - Added check for reserve mailing capacity to prevent getting error 
                                due to daily email limit.
        Vijay 	  02052014	  - updated code to support the Internal Device Functionality. Added getAccountAdminEmailIds method.        						
*/
global class ExpConWaiverService {  
    
    public static List<Messaging.SingleEmailMessage> sendMsgs = new List<Messaging.SingleEmailMessage>();
    public static Set<String> internalDeviceRecTypeSet = new Set<String>{'Internal_Device','Internal_Device_Read_Only'};
    
    // Static method to be invoked on 'Request Export Control Waiver' button call
    webservice static String sendNotification(String devId, String userEmail, String userProfile){
        try{
			String retStr = '';
            Device__c dev =  [select    id,
                                        opportunity_program__c,
                                        Export_Control_Waiver_Flag__c,
                                        Export_Control_Waiver_Flag_Request__c,
                                        Account__c,
                                        RecordType.DeveloperName,
                                        Owner.Email
                              from      Device__c
                              where     id = :devId];
            
            boolean isUserAuth = false;
            Map<String, List<String>> ccAddressMap = new Map<String, List<String>>(); 
            List<String> ccAddressList = new List<String>();
           
            if(internalDeviceRecTypeSet.contains(dev.RecordType.DeveloperName) && dev.Account__c != null){
            	String accountAdminRole = (EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') != null)? EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') :'Account Administrator';
            	ccAddressMap = getAccountAdminEmailIds(new Set<Id>{dev.Account__c}, new List<String>{accountAdminRole});
            	if(ccAddressMap.get(dev.Account__c) != null){
	            	ccAddressList = ccAddressMap.get(dev.Account__c);
            	}
	            if(dev.Owner.Email != null){
	            	ccAddressList.add(dev.Owner.Email);
	            }
	            System.debug('------In Internal Device Loop----'+ccAddressList);
            }else{
            	ccAddressMap = getAMFEMailIds(new List<String>{dev.opportunity_program__c});
	            ccAddressList = ccAddressMap.get(dev.opportunity_program__c);
	            System.debug('------In Device Loop----'+ccAddressList);
            }
            
            if(userProfile == 'System Administrator'){
                isUserAuth = true;
            }else{
            	for(String ccAddress : ccAddressList){
                    if(ccAddress.contains(userEmail)){
                        isUserAuth = true;
                    }
                }
            }
            if(!isUserAuth){
                return 'Not Authorized';    
            }
                              
            if(dev.Export_Control_Waiver_Flag_Request__c == false){
                
                String expConWaiverRequestTemp = EnvironmentVariable.get('DEVICE_EXP_CON_WAIVER_REQUEST_TEMP');
                //Fetching the email template 
                EmailTemplate temp = [SELECT id from EmailTemplate where name = :expConWaiverRequestTemp];
                List<String> toAddressList = getGTCUserMailIds();
                
                if(toAddressList.size()>0){
                    dev.Export_Control_Waiver_Flag_Request__c = true;
                    update dev;                 
                    sendEmail(temp.id, devId, toAddressList, ccAddressList);
                    if(sendMsgs.size()>0){
                        Messaging.sendEmail(sendMsgs);
                        retStr = 'OK';
                    }else{
                        retStr = 'MailError';   
                    }
                }else{
                    retStr = 'NoToAddress';
                }
            }else{
                retStr = 'ExpConSet';
            }
            return retStr;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
    
    //Send Mail method to GTC users and ccing AM, FE and system.crm@globalfoundries.com 
    public static void sendEmail(String tempId, String devId, List<String> toAddressList, List<String> ccAddressList){
        //Send the email template
        try{
            Integer noOfToRecipient = 0;
            Integer noOfCCRecipient = 0;
            if(toAddressList!=null){
                noOfToRecipient = toAddressList.size();
            }
            if(ccAddressList!=null){
                noOfCCRecipient = ccAddressList.size();
            }
            Messaging.reserveSingleEmailCapacity(noOfToRecipient+noOfCCRecipient);
            List<Messaging.SingleEmailMessage> templates = EmailUtil.generateEmailTemplate(tempId,
                                                                                           devId,
                                                                                           toAddressList,
                                                                                           ccAddressList);                  
            for(Messaging.SingleEmailMessage t :templates){
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setToAddresses(t.getToAddresses());
                msg.setCcAddresses(t.getCcAddresses());
                msg.setHTMLBody(t.getHTMLBody());
                msg.setPlainTextBody(t.getPlainTextBody());
                msg.setSubject(t.getSubject());
                sendMsgs.add(msg);
            }
        }catch(Exception e){}                   
    }
        
    // get mail ids for the Users having Team Role as FE and AM
    public static Map<String,List<String>> getAMFEMailIds(List<String> opptyProgIdList){        
        
        String OPPTY_PROG_TM_ROLE_FTS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS');
        String OPPTY_PROG_TM_ROLE_AM = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM');
        String devSystemCRMEmailId = EnvironmentVariable.get('DEVICE_SYS_CRM_EMAILID');
        String OPPTY_PROG_TM_ROLE_FAE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FAE');
		String OPPTY_PROG_TM_ROLE_PAM = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PAM');
        
        Map<String,List<Opportunity_Program_Team_Member__c>> emailIdsFEAMMap = new Map<String,List<Opportunity_Program_Team_Member__c>>();
        Map<String, List<String>> emailAMFEMap = new Map<String, List<String>>();
        
        //get the oppty team members                     
        for(Opportunity_Program_Team_Member__c m : [select  team_role__c,
                                                            user__r.email,
                                                            opportunity_program__c, Is_FAE__c
                                                    from    Opportunity_Program_Team_Member__c
                                                    where   opportunity_program__c = :opptyProgIdList]){
                                                        
            if(emailIdsFEAMMap.containsKey(m.opportunity_program__c)){
                emailIdsFEAMMap.get(m.opportunity_program__c).add(m);
            }else{
                emailIdsFEAMMap.put(m.opportunity_program__c,new List<Opportunity_Program_Team_Member__c>{m});
            }
        }
         
        for(String opptyId : emailIdsFEAMMap.keySet()){
            List<Opportunity_Program_Team_Member__c> opptTMList = emailIdsFEAMMap.get(opptyId);    
            List<String> emailIdsFEAMList = new List<String>();
            for(Opportunity_Program_Team_Member__c m : opptTMList){
                if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_FTS)){                  
                    emailIdsFEAMList.add(m.user__r.email);
                }else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_AM)){
                    emailIdsFEAMList.add(m.user__r.email);
                }else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_PAM) && m.Is_FAE__c){
                    emailIdsFEAMList.add(m.user__r.email);
                }else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_FAE)){
                    emailIdsFEAMList.add(m.user__r.email);
                }
            }                                                                                                                                                            
            emailIdsFEAMList.add(devSystemCRMEmailId);
            emailAMFEMap.put(opptyId,emailIdsFEAMList); 
        }      
        return emailAMFEMap;
    }
    
    // get mail ids for the Users having Role as GTC
    public static List<String> getGTCUserMailIds(){
        
        String GTC_ROLE = EnvironmentVariable.get('GTC_ROLE');
        
        // get the users
        List<String> emailIdsGTCUserList = new List<String>();
        
        for(User usr : [select  email 
                        from    User
                        where   userRoleId in (select id from UserRole where name = :GTC_ROLE)]){
            emailIdsGTCUserList.add(usr.email);
        }
        return emailIdsGTCUserList;
    }
   
	
	/**
     * This method is used to get the email Ids of specifed team Role users from Account Team Proxy 
     *
     * @param   accountIdList				List of Account object Ids
     * @param   teamRoleList				List of Team Roles
     * @return  accountUserEmailIdListMap	Map of Account and List User Email Ids    
     */        
     public static Map<String,List<String>> getAccountAdminEmailIds(Set<Id> accountIdSet, List<String> teamRoleList){
    	Map<String,List<String>> accountUserEmailIdListMap = new Map<String,List<String>>();
    	if((accountIdSet != null && !accountIdSet.isEmpty()) && (teamRoleList != null && !teamRoleList.isEmpty())){
	    	List<Account_Team_Proxy__c> atpList = [SELECT Id, User__r.Email, Account__c FROM Account_Team_Proxy__c WHERE Account__c =: accountIdSet AND Team_Role__c =:teamRoleList];
	    	if(!atpList.isEmpty()){
	    		for(Account_Team_Proxy__c atp :atpList){
	    			if(!accountUserEmailIdListMap.containsKey(atp.Account__c)){
	    				accountUserEmailIdListMap.put(atp.Account__c, new List<String>());
	    			}
	    			accountUserEmailIdListMap.get(atp.Account__c).add(atp.User__r.Email);
	    		}
	    	}
    	}
    	return accountUserEmailIdListMap;
    }
}