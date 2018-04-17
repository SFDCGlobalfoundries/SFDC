/*
  Author: Anirban Roy
  Description: This is the helper class for CPQ Configuration Approval Controller.
  History:
    ARoy        09222014    - code creation. 
    Nbajaj      23-Aug-17   -cpq Sprint10 case- 00069734
    Description: added code to insert PDF file of config record in attachement and send email to config submitter.             
*/

public class CPQConfigurationApprovalHelper{
    
    // Method to populate the ATP FAE users and submit the approval process
    public void submitForApproval(Apttus_Proposal__Proposal__c configuration){                
        Id userId = UserInfo.getUserId();
        CPQTempCS__c TempCS = CPQTempCS__c.getValues('CPQTemplate');		
        String templateName = TempCS.Template_Name__c;  		
       
        if(UserInfo.getUserType() == 'CustomerSuccess' || UserInfo.getUserType() == 'PowerCustomerSuccess' || test.isRunningTest() ){            
            
            // reset all approvers
            configuration.Approver_User_1__c = null;
            configuration.Approver_User_2__c = null;
            configuration.Approver_User_3__c = null;
            configuration.Approver_User_4__c = null;
            configuration.Approver_User_5__c = null;
            configuration.Approver_User_6__c = null;
            configuration.Approver_User_7__c = null;
            configuration.Approver_User_8__c = null;
            configuration.Approver_User_9__c = null;
            configuration.Approver_User_10__c = null;
            
            List<Apttus_Proposal__Proposal__Share> propShareList = new List<Apttus_Proposal__Proposal__Share>();
            Integer ctr = 0;
            List<Account_Team_Proxy__c> lstATP = [SELECT Id , Name, User__c,User__r.isActive,Team_Role__c 
                                                FROM Account_Team_Proxy__c
                                                WHERE User__r.isActive=true//added by sunita
                                                    AND Account__c = :configuration.Apttus_Proposal__Account__c
                                                    AND ( Team_Role__c='Field Application Engineer' 
                                                       OR Team_Role__c='Primary Field Technical Support' 
                                                       OR Team_Role__c='Primary Field Application Engineer' 
                                                       OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                       OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                ORDER BY Team_Role__c desc LIMIT 10];
                       //Njain 08Jun16 Sorting the ATP keeping the PFAE on top
            lstATP= Utility.getSortedFAE(lstATP);
            for(Account_Team_Proxy__c atp : lstATP){
                if(ctr==0){
                    configuration.Approver_User_1__c = atp.User__c;
                }else if(ctr==1){
                     configuration.Approver_User_2__c = atp.User__c;
                }else if(ctr==2){
                     configuration.Approver_User_3__c = atp.User__c;
                }else if(ctr==3){ 
                    configuration.Approver_User_4__c = atp.User__c;
                }else if(ctr==4){
                    configuration.Approver_User_5__c = atp.User__c;
                }else if(ctr==5){
                    configuration.Approver_User_6__c = atp.User__c;
                }else if(ctr==6){
                    configuration.Approver_User_7__c = atp.User__c;
                }else if(ctr==7){
                    configuration.Approver_User_8__c = atp.User__c;
                }else if(ctr==8){
                    configuration.Approver_User_9__c = atp.User__c;
                }else if(ctr==9){
                    configuration.Approver_User_10__c = atp.User__c;
                }
                Apttus_Proposal__Proposal__Share propShare = new Apttus_Proposal__Proposal__Share();
                propShare.ParentId = configuration.Id;
                propShare.UserOrGroupId = atp.User__c;
                propShare.AccessLevel = 'edit';
                propShareList.add(propShare);
                ctr++;
            }
            
            update configuration;
            system.debug('configuration:'+configuration);                
            
           if(propShareList.size()>0){
                 /*---------------------------added by sunita----------------*/  
                String errmess='';
                 Database.insert(propShareList, false); //added by sunita
                
                 Database.SaveResult[] srList = Database.insert(propShareList, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        errmess=err.getmessage();
                        errmess=errmess+'\n';
                        }
                }
               } 
               
              GlobalUtility.logMessage('Error','CPQConfigurationApprovalHelper','submitForApproval','','Exception while submitting configuration rec in approval process',errmess,'','Apttus CPQ',null,0);
           
              /*---------------------------added by sunita----------------*/    }
            
            // submit the record for approval
            if(configuration.Approver_User_1__c != null){
             try{
               Approval.ProcessSubmitRequest oRequest = new Approval.ProcessSubmitRequest();
                oRequest.setObjectId(configuration.Id);
                Approval.ProcessResult oResult = Approval.process(oRequest); 
                /*-----nbajaj- case-00069734-----*/
                 CPQInsertAttachement.createAttachement(configuration.Id,userId,false,templateName);
                }catch(Exception excp){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No applicable approval process was found'));    
            GlobalUtility.logMessage('Error','CPQConfigurationApprovalHelper','submitForApproval','','Exception while submitting configuration rec in approval process',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
                     
            }  
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No FAE user present in Account Team Proxy.'));
            }
        }else if(UserInfo.getUserType() == 'Standard'){
            Approval.ProcessSubmitRequest oRequest = new Approval.ProcessSubmitRequest();
            try{
            oRequest.setObjectId(configuration.Id);
            Approval.ProcessResult oResult = Approval.process(oRequest); 
            /*-----nbajaj- case-00069734-----*/
            CPQInsertAttachement.createAttachement(configuration.Id,userId,false,templateName);	 
            }catch(Exception excp){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No applicable approval process was found'));
           GlobalUtility.logMessage('Error','CPQConfigurationApprovalHelper','submitForApproval','','Exception while submitting configuration rec in approval process',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
            
        }   }   
    }
}