/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Standard Foundry Frame Generation 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-03-10 - Created
**/
public with sharing class SFFGFrameGenTriggerHandlerCtrl {
	
	public static void sendNotification(set<id> idSet,boolean isPTRFUpdate) {
    	//for getting keyset of ids
    	Map<Id, List<Account_Team_Proxy__c>> frameFAEListMap = new Map<Id, List<Account_Team_Proxy__c>>();
    	
    	List<SFFG_Standard_Foundry_Frame__c> FrameList=[SELECT  Id, SWIFT_PTRF_ID__c,device__r.Account__c,Device__c,Device__r.Name,Device__r.Geometry_NM__c,  
											        	Device__r.Device_Mask_Set_Title__c FROM SFFG_Standard_Foundry_Frame__c where  id IN :idSet];
    	
    	//seto of account ids
    	set<id> accIds=new set<id>();
    	for(SFFG_Standard_Foundry_Frame__c f : frameList) {
		     accIds.add(f.device__r.Account__c);
		}
    	
        
        if(!accIds.isEmpty()){
        List<Account_Team_Proxy__c> proxyList = [select User__c, User__r.Name,Account__c, User_Email__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN :accIds and Team_Role__c IN ('Field Application Engineer','Primary Field Application Engineer') order by Team_Role__c desc];
            if(!proxyList.isEmpty()){
                for(Account_Team_Proxy__c p: proxyList){
                    if(p.Team_Role__c == 'Field Application Engineer' || p.Team_Role__c == 'Primary Field Application Engineer'){
                        if(frameFAEListMap.containskey(p.Account__c)){
                        	frameFAEListMap.get(p.Account__c).add(p);
                        }else{
                        	List<Account_Team_Proxy__c> feList = new List<Account_Team_Proxy__c>();
                        	feList.add(p);
                        	frameFAEListMap.put(p.Account__c,feList);
                        }
                    }
                }
            }
        }
    	
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(SFFG_Standard_Foundry_Frame__c f : frameList){
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	List<String> sendTo = new List<String>();
        	List<String> ccList = new List<String>();
	        for(Account_Team_Proxy__c p: frameFAEListMap.get(f.Device__r.Account__c)){
		      	sendTo.add(p.User_Email__c);
	        }
	        string ccEmail='';
	        
	        integer  procGeo;
	        
	        
            if(f.Device__r.Geometry_NM__c!=null){
            	procGeo=integer.valueof(f.Device__r.Geometry_NM__c.replace('NM',''));
				if(procGeo>=22)ccEmail=(SFFG_Configuration__c.getInstance('TapeOutCenter Email')!=null)?SFFG_Configuration__c.getInstance('TapeOutCenter Email').Value__c:'';
				else ccEmail=(SFFG_Configuration__c.getInstance('TD TSD TDTI Email')!=null)?SFFG_Configuration__c.getInstance('TD TSD TDTI Email').Value__c:'';
		      	mail.setToAddresses(sendTo);
		      	ccList.add(ccEmail);
		      	string toList=(SFFG_Configuration__c.getInstance('FrameEmailNotificationList')!=null)?SFFG_Configuration__c.getInstance('FrameEmailNotificationList').Value__c:'';
				for(string s:toList.split(';')){
					if(String.isNotBlank(s))ccList.add(s);
				}
				
			    mail.setCcAddresses(ccList);
			    mail.setReplyTo('noreply-salesforce@globalfoundries.com');
	           
	            String body = 'Hi Tapeout Centre,<br/><br/>';
	            if(isPTRFUpdate){
	            	 mail.setSubject('Device '+f.Device__r.Device_Mask_Set_Title__c+':Frame PTRF Submitted');
		            body += 'Frame PTRF has been created for device '+f.Device__r.Device_Mask_Set_Title__c+' <br/><br/>';
		            body += 'Please review.<br/>';
	            }else{
	            	 mail.setSubject('Device '+f.Device__r.Device_Mask_Set_Title__c+':Frame details Updated');
	            	body += 'Frame generation requirement are updated for device '+f.Device__r.Device_Mask_Set_Title__c+' <br/><br/>';
		            body += 'Please review and feedback cycletime impact to FAE.<br/>';
		            body += '<br/>';
	            }
	            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/SFFGFrameDetails?id='+f.Device__c;
	            body += '<a href="'+hyperLink+'">Click here to open</a>';
	            body += '<br/><br/>Thanks,<br/>Salesforce Admin<br/>';
	            mail.setHtmlBody(body);
	            mailList.add(mail);
	        }
	        Messaging.sendEmail(mailList);
        }
    }

}