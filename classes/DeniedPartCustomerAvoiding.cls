/**
* Author: KOKA GOPI
* Project: DeniedPartCustomerAvoiding util class used for all below classes and triggers
        Triggers:
        ----------
            LeadTrigger
            AccountTrigger
            DeviceMaskSetTitleTrigger
            ExpCntrlFormTrigger
            DeniedPartyListTrigger

       Classes:
       ---------
            DeniedPart_UnauthorizedAccountBatch
            DeniedPart_UnauthorizedDeviceBatch
            DeniedPart_UnauthorizedECFBatch
            DeniedPart_UnauthorizedLeadBatch
            DeniedPart_UnauthorizedDeniedPartyBatch
            DeniedPartyListHelperClass

* Description: Util Class used for to find "Unauthorized" records from Account,Lead,Device__C & Export_Control_Form__c
**/

Public Class DeniedPartCustomerAvoiding{
    public Static Set<ID> acccsrIdsList = New Set<ID>();
    Public Static validatedResponse validateCustomer(String companyName,String corporateAddress,String billingAddress,String CountryCode,String recordID,List<ID> acccsrIds){
        //To validate response and updated values to Sobject
        validatedResponse response;
        try{
            if(acccsrIds!=null && acccsrIds.size()>0){
                acccsrIdsList.addAll(acccsrIds);
            }
            //calculate percentage Match
            integer percentageCalculation = 0;
            
            //Default values to remove from companyName
            Map<String, DeniedPartListRegularwords__c> avoidRegularwaords = DeniedPartListRegularwords__c.getAll();
            List<String> splitSpace = New List<String>();
            if(companyName!=null && companyName!=''){
                splitSpace = companyName.split('\\ ');
            }
            
            Set<String> collectallWords = New Set<String>();
            if(splitSpace.size()>0){
                collectallWords.addAll(splitSpace);
            }
            
            for(String regularWords: avoidRegularwaords.keySet()){
                if(collectallWords.contains(regularWords))
                    collectallWords.remove(regularWords);
            }
            //Searching data from Denied Part Object
            
            string header = 'Record Id, Company Name , Address , Country \n';
            string deniedPartListRecords = header ;
            
            //Updating percentage
            List<String> assigingPercentage = New List<String>();
            for(String s:collectallWords){
                //if character contains more than 3 characters only need to search from DB
                if(s.length()>3) 
                assigingPercentage.add('%'+s+'%');
            }
            system.debug(assigingPercentage);
            String validateString = 'SELECT id,COMPANY_NAME__c,ADDRESS_LINE__c,COUNTRY__c FROM Denied_Party_List__c WHERE ';
            
            validateString += 'COMPANY_NAME__c LIKE : assigingPercentage AND ADDRESS_LINE__c!= null AND COUNTRY__c!=null';
     
            List<Denied_Party_List__c> unauthorizedObj = Database.Query(validateString);
            system.debug('===>'+unauthorizedObj.size());
            if(unauthorizedObj.size()>0){
                DeniedPartListMetaDataHardCoded__c dpld = DeniedPartListMetaDataHardCoded__c.getInstance('Percentage');
                if(dpld!=null){
                    percentageCalculation = integer.valueof(dpld.NamePercentage__c);
                    
                    Boolean countryValidated = true;
                    Boolean addressValidated = true;
                    for(integer i=0;i<unauthorizedObj.size();i++){
                        if(corporateAddress!=null && corporateAddress!=''){
                            if((unauthorizedObj[i].ADDRESS_LINE__c!=null && unauthorizedObj[i].ADDRESS_LINE__c!='') && unauthorizedObj[i].ADDRESS_LINE__c.containsIgnoreCase(corporateAddress)){
                                if(percentageCalculation<100 && addressValidated){
                                    percentageCalculation += integer.valueof(dpld.Address__c);
                                    addressValidated = false;
                                }
                            }
                        }
                        if(CountryCode!=null && CountryCode!=''){
                            if((unauthorizedObj[i].COUNTRY__c!=null && unauthorizedObj[i].COUNTRY__c!='') && unauthorizedObj[i].COUNTRY__c.containsIgnoreCase(CountryCode)){
                                if(percentageCalculation<100 && countryValidated){
                                    percentageCalculation += integer.valueof(dpld.Country__c);
                                    countryValidated = false;
                                }
                            }
                        }
                        
                        
                        string recordString = '"'+unauthorizedObj[i].id+'","'+unauthorizedObj[i].COMPANY_NAME__c+'","'+unauthorizedObj[i].ADDRESS_LINE__c+'","'+unauthorizedObj[i].COUNTRY__c +'"\n"';
                        deniedPartListRecords = deniedPartListRecords +recordString;
                    }
                }
            }
            response = New validatedResponse();
            Schema.DescribeSObjectResult deviceKey = Device__c.sObjectType.getDescribe();
            Schema.DescribeSObjectResult ecfKey = Export_Control_Form__c.sObjectType.getDescribe();
            
            integer pc = 50;
            if((recordID!=null && recordID.substring(0,3)==deviceKey.getKeyPrefix()) || 
              (recordID!=null && recordID.substring(0,3)==ecfKey.getKeyPrefix())){
                pc = 50;
            }
            
            if(percentageCalculation >= pc){
                response.unauthorized = true;
                response.percentageCalculation = percentageCalculation;
                
                //To send Email to Group users
                sendMyTemplate(recordID,Blob.valueOf(deniedPartListRecords));
            }else{
                response.unauthorized = false;
                response.percentageCalculation = percentageCalculation;
            }
        }Catch(DMLException e){
            throw new CommonException('Could not be Processed. Please Contact DPL Team.');
        }
        return response;
    }
    
    Public Class validatedResponse{
        Public Boolean unauthorized;
        Public integer percentageCalculation;
        Public Boolean EmailNotification;
    } 
    public class CommonException extends Exception {}
    public static list<String> ccEmailAddress = New list<String>();
    public static List<String> getMailAddresses(){
          List<ID> mailList = new List<ID>();
          if(acccsrIdsList.size()>0){
              mailList.addAll(acccsrIdsList);
          }
          List<String> mailAddresses = new List<String>();
          List<Group> g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'Legal Team'];
          if(g.size()>0){
              Set<id> onlyGroupEmails = New Set<Id>();
              for (GroupMember gm : g[0].groupMembers){
                   mailList.add(gm.userOrGroupId);
                   onlyGroupEmails.add(gm.userOrGroupId);
              }
              
              User[] usr = [SELECT email FROM user WHERE id IN :mailList];
              for(User u : usr){
                  if(!u.email.contains('test') && onlyGroupEmails.contains(u.id)){
                      mailAddresses.add(u.email);
                  }
                  if(acccsrIdsList.contains(u.id)){
                      ccEmailAddress.add(u.email);
                  }
              }
          }
          return mailAddresses;
    }
    
    private static void sendMyTemplate(String mergedObjectId,blob attachmentBlob) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setHtmlBody('<b>Dear Legal Team,<br/><br/>Application has identified a denied party which has been entered into the application.<br/><br/> Kindly refer the below link and validate :</b><br/><br/><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mergedObjectId+'><b>click here</b></a>');
     // mail.setFromAddress('noReply@Salesforce.com');
      mail.setSubject('Alert:Probable Denied Customer Identified');
      OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress WHERE Address=:'noreply-salesforce@globalfoundries.com'];
      mail.setOrgWideEmailAddressId(owa.id);
      mail.setToAddresses(getMailAddresses());
      mail.setCcAddresses(ccEmailAddress);
      //For attchments
      List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        efa.setFileName('DeniedPartListData.csv');
        efa.setBody(attachmentBlob);
        fileAttachments.add(efa);
        mail.setFileAttachments(fileAttachments);
        if(mergedObjectId!=null && Boolean.valueOf(system.Label.DPL_EnableEmail)){
                Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
        }
    }
}