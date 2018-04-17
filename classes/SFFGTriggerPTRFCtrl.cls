/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Standard Foundry Frame Generation 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-03-10 - Created
<Devendra Babu Itraju> 2017-09-06- Updated 
**/
public without sharing class SFFGTriggerPTRFCtrl {
	
	@future(callout=true)
	public static void createPTRF(string frameId,string sessionIdval){
		SFFG_Standard_Foundry_Frame__c Frame;
		try{
		if(frameId!=null){
			 String OrganizationId=UserInfo.getOrganizationId();
	         String ActionId;
	         String SessionId=sessionIdval;
	         string fullURL = URL.getSalesforceBaseUrl().toExternalForm() ;
	         String EnterpriseUrl=fullURL+'/services/Soap/c/36.0/'+OrganizationId;
	         String PartnerUrl;
	         SFFGCreationService.SFFG_Prime_Die_xcNotification[] Notification = new List<SFFGCreationService.SFFG_Prime_Die_xcNotification>();
	         
	         SFFGCreationService.SFFG_Prime_Die_xcNotification frameElement=new SFFGCreationService.SFFG_Prime_Die_xcNotification();
	         
	         SFFGCreationService.SFFG_Standard_Foundry_Frame_xc FrameXc=new SFFGCreationService.SFFG_Standard_Foundry_Frame_xc();
	         
	         SFFGCreationService.SFFG_Prime_Die_xc[] primeDieList=new List<SFFGCreationService.SFFG_Prime_Die_xc>();
	         
	         List<SFFG_Standard_Foundry_Frame__c> FrameList=[SELECT Backend_Process_ID__c,Backgrind_Thickness__c,CRM_DID_Modified_Timestamp__c,
	         CRM_Device_ID__c,Cancellation_Reason__c,Configuration_Option__c,Configuration_Type__c,Customer_Short_Name__c,
	         Operation_Type__c,PTRF_Number__c,Requester_Username__c,Revision__c,SWIFT_Action__c,SWIFT_Error__c,
	         Spec_Config_Table_ID__c,CreatedById,CreatedDate,Device__r.MS_SFDC_Synch_Time__c,Device__c,Fab__c,Name,SFFG_Frame_Status__c,LG_Configuration__c,
	         SWIFT_Status__c,SystemModstamp FROM SFFG_Standard_Foundry_Frame__c where  id=:frameId limit 1];
    		
    		if(FrameList!=null && FrameList.size()>0){
    			Frame=FrameList.get(0);
    			
	    		List<SFFG_Prime_Die__c> pdTempList=[Select SystemModstamp, Standard_Foundry_Frame__c,	Size_X_um__c,Size_Y_um__c,
	    												Foundry_to_Add_CrackStop__c,Foundry_to_add_Guardring__c,Die_Anti_clock_wise_Rotation__c,
	    												Name, Id, CreatedDate, CreatedById From SFFG_Prime_Die__c
	    												 where Standard_Foundry_Frame__c=:Frame.id];
	    												 
	    		if(pdTempList!=null && pdTempList.size()>0){
	    			for(SFFG_Prime_Die__c pd:pdTempList){
	    				SFFGCreationService.SFFG_Prime_Die_xc pdXc=new SFFGCreationService.SFFG_Prime_Die_xc();
	    				pdXc.Die_Anti_clock_wise_Rotation_xc=pd.Die_Anti_clock_wise_Rotation__c;
				        pdXc.Foundry_to_Add_CrackStop_xc=checkNull(pd.Foundry_to_Add_CrackStop__c);
				        pdXc.Foundry_to_add_Guardring_xc=checkNull(pd.Foundry_to_add_Guardring__c);
				        pdXc.Name=pd.Name;
				        pdXc.Size_X_um_xc=string.valueof(pd.Size_X_um__c);
				        pdXc.Size_Y_um_xc=string.valueof(pd.Size_Y_um__c);
				        primeDieList.add(pdXc);
				        
    				}
	    		}
	    		
	    		string dtString=Frame.Device__r.MS_SFDC_Synch_Time__c;
	    		string syncTime='';
	    		if(dtString!=null){
					dtString=dtString.replace('T',' ');
					dtString=dtString.replace('Z','');
					datetime syncTimedt=datetime.valueof(dtString);
					syncTime=syncTimedt.format('YYYY-MM-dd HH:mm:ss');
	    		}
	    		
	    		FrameXc.Backend_Process_ID_xc=checkNull(Frame.Backend_Process_ID__c);
				FrameXc.Backgrind_Thickness_xc=checkNull(Frame.Backgrind_Thickness__c);
				FrameXc.CRM_DID_Modified_Timestamp_xc=checkNull(syncTime);
				FrameXc.CRM_Device_ID_xc=checkNull(Frame.CRM_Device_ID__c);
				FrameXc.Cancellation_Reason_xc=checkNull(Frame.Cancellation_Reason__c);
				FrameXc.LG_Configuration_xc=checkNull(Frame.LG_Configuration__c);
				FrameXc.Configuration_Type_xc=checkNull(Frame.Configuration_Type__c);
				FrameXc.Customer_Short_Name_xc=checkNull(Frame.Customer_Short_Name__c);
				FrameXc.PrimeDieDetails=primeDieList;
				FrameXc.Operation_Type_xc=checkNull(Frame.Operation_Type__c);
				FrameXc.PTRF_Number_xc=checkNull(Frame.PTRF_Number__c);
				FrameXc.Requester_Username_xc=checkNull(Frame.Requester_Username__c);
				FrameXc.Revision_xc=checkNull(Frame.Revision__c);
				FrameXc.SFFG_Frame_Status_xc=checkNull(Frame.SFFG_Frame_Status__c);
				FrameXc.SWIFT_Action_xc=checkNull(Frame.SWIFT_Action__c);
				FrameXc.SWIFT_Error_xc=checkNull(Frame.SWIFT_Error__c);
				FrameXc.Spec_Config_Table_ID_xc=checkNull(Frame.Spec_Config_Table_ID__c);
				FrameXc.Standard_Foundry_Frame_xc=checkNull(Frame.Id);
				FrameXc.SystemModstamp=Frame.SystemModstamp;
    		}
    		
    		frameElement.id=FrameXc.Standard_Foundry_Frame_xc;
    		frameElement.sObject_x=FrameXc;
    		
    		Notification.add(frameElement);
    		
    		
			SFFGCreationService.Notification proxyClass= new SFFGCreationService.Notification();
			string endpoint='';
			endpoint=(SFFG_Configuration__c.getInstance('AIA Endpoint')!=null)?SFFG_Configuration__c.getInstance('AIA Endpoint').Value__c:'';
			proxyClass.endpoint_x=endpoint;
			proxyClass.timeout_x=20000;
			
			string Certificate=(Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c!=null)?Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c:'';
			proxyClass.clientCertName_x=Certificate;
			string retVal = proxyClass.notifications(OrganizationId,null,SessionId,EnterpriseUrl,null,Notification);
			frame=new SFFG_Standard_Foundry_Frame__c(id=FrameId);
			if(retVal.equalsignorecase('success')){
				frame.SWIFT_Status__c='Pending';
			}else{
				frame.SWIFT_Status__c='Error';
			}
			
			frame.SWIFT_Response__c=retVal;
			update frame;
			//to do future call error 
		}
	}
	catch(Exception E){
		frame.SWIFT_Response__c=e.getmessage();
		update frame;
	}
	}
	
	public static string checkNull(string val) {
		if(val!=null){
			return val;
		}else{
			return '';
		}
	}
    
    public static void sendErrorEmail(SFFG_Standard_Foundry_Frame__c frame,string retVal){

        	
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
	        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        	List<String> sendTo = new List<String>();
		        string ccEmail='';
		        string toList=(SFFG_Configuration__c.getInstance('ErrorNotificationMailList')!=null)?SFFG_Configuration__c.getInstance('ErrorNotificationMailList').Value__c:'';
				for(string s:toList.split(';')){
					if(String.isNotBlank(s))sendTo.add(s);
				}
        		List<SFFG_Standard_Foundry_Frame__c> FrameList=[SELECT CreatedBy.Email,Device__r.Name,Device__r.Account__c,
                                                                    Id,Name,SWIFT_Response__c,
                                                                    SWIFT_Status__c
                                                                      FROM SFFG_Standard_Foundry_Frame__c 
                                                                     where  id=:frame.id limit 1];
        		
        
        		String accountId = FrameList[0].Device__r.Account__c;
                List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();
                set<string> feList = new set<string>();
                if(accountId != ''){
                proxyList = [select User__c, User__r.Name, User_Email__c, Team_Role__c, Is_FAE__c from Account_Team_Proxy__c 
                  where Account__c =: accountId and Team_Role__c IN 
                  (:SFFG_Constants.ACCT_TM_PRXY_TM_RL_PAM, :SFFG_Constants.ACCT_TM_PRXY_TM_RL_AM,
                  :SFFG_Constants.ACCT_TM_PRXY_TM_RL_FAE,
                  :SFFG_Constants.ACCT_TM_PRXY_TM_RL_PFTS) 
                  order by Team_Role__c desc];
                    if(!proxyList.isEmpty()){
                        for(Account_Team_Proxy__c p: proxyList){
                            if( p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_FAE || 
                                p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_PFTS ||
                                (p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_PAM && p.Is_FAE__c == TRUE) ||
                                (p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_AM  && p.Is_FAE__c == TRUE)){
                                feList.add(p.User_Email__c);
                            }
                        }
                    }
                }
        		sendTo.addall(feList);
        		sendTo.add(FrameList[0].CreatedBy.Email);
				ccEmail=(SFFG_Configuration__c.getInstance('TapeOutCenter Email')!=null)?SFFG_Configuration__c.getInstance('TapeOutCenter Email').Value__c:'';
		      	mail.setToAddresses(sendTo);
			    mail.setCcAddresses(new List<string>{ccEmail,userinfo.getuseremail()});
			    mail.setReplyTo('noreply-salesforce@globalfoundries.com');
        		OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where displayname= 'Salesforce, Noreply'];
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
	            mail.setsubject('Error: Device '+FrameList[0].Device__r.Name+' Frame PTRF trigger unsuccessful');
	            String body = 'Standard Frame Generation triggered from Device is unsuccessful.,<br/>';        
	            body += 'Swift has returned Error with the following response.<br/><br/>';
        		body += 'SWIFT Status:'+FrameList[0].SWIFT_Status__c+'<br/>';
        		body += 'SWIFT Response: '+FrameList[0].SWIFT_Response__c+'<br/><br/>';
        
	            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/SFFGFrameDetails?id='+frame.Device__c;
	            body += '<a href="'+hyperLink+'">Click here to open</a>';
	            body += '<br/><br/>Please contact your Foundry Field Engineer for more details.';
	            mail.setHtmlBody(body);
	            mails.add(mail);
			    if(!test.isrunningtest())Messaging.sendEmail(mails);
    }

}