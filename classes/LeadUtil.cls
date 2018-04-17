/***************************************************************************************************************************************
Class:         LeadUtil
----------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  21/05/2014
Reason:        Helper class to be used from controller class and lead triggers.

Change Log:    Created     -     JOYDEV     -     21/05/2014  
Change Log:    Updated     -     JOYDEV     -     24/05/2014  
               [Reason] Plan was to enable Country code and State Codes for lead Corporate Country and Corporate State. 
                        Currently Salesforce dose not support this functionality for Custom Fields. 
                        It needs to change from Country Code to Country Name keeping the State Code for Corporate State as it it.
Change Log:    Updated     -     JOYDEV     -     10/06/2014  
               [Reason] New logic: 
                        Marketing User can create leads in 3 Ways
                        1. Create lead in Sfdc Lead tab
                        2. User can load Lead using lead import wizard
                        3. Leads created in Act-On are synchronized with Salesforce
                          
                        (*) If Lead is created in Leads Tab, then Lead is assigned based on Region user selected using Lead assignment 
                            rules. (Region is set in the UI as required field, don’t apply region evaluation and set HotLead = Yes)
                        
                        (*) If lead is imported using lead import wizard, then leads should be assigned only if record has "Hot Lead" 
                            set to "Yes" using Lead assignment rules. If Hot Lead = No then assign it to  "Archive Lead Queue” 
                      
                        (*) If lead is created from "Act-On API User" then lead should be assigned to "Act-On Lead Admin Queue". If lead 
                            is  unqualified (Hot Lead = No) Lead then Act-On Admin should be assigning it to "Archive Lead Queue” 
Change Log:    Updated     -     JOYDEV     -     17/07/2014
               [Reason] New logic:
                        (*) Using  “Corporate Country” and “Corporate State” evaluate "Marketing Territory”, logic is same as previous 
                            “Region” evaluation Logic.

                        (*) Based on  “Corporate Country” and “Corporate State”, we need to evaluate “Region” and “Sales Territory” of 
                            Lead record. 
                      
               [Example]:   *---------------------------*-------------*-------------*------------------------*-------------------------*
                            | Country Name              | State Code  | Region      | Sales Territory        | Marketing Territory     |  
                            *---------------------------+-------------+-------------+------------------------+-------------------------*
                            | India                     |             | EUR         | EMEA-ROA               | EMEA-ROA                |
                            | USA                       | CA          | US          | US-West                | US-WEST                 |
                            | USA NY                    | NY          | US          | US-East                | US-EAST                 |
                            | China                     |             | APJ         | Greate China           | Greater China           | 
                            | Korea                     |             | APJ         | Japan Korea            | Korea Japan             | 
                            | South Africa              |             | EUR         | EMEA-ROA               | EMEA-ROA                |
                            | France                    |             | EUR         | EMEA-ROA               | EMEA-ROA                |
                            | Company Name ~ "Qualcomm" |             | US          | QUALCOMM               | US-Qualcomm             |
                            | Brazil                    |             | US          | US-West                | Americas                |      
                            *---------------------------*-------------*-------------*------------------------*-------------------------*
Change Log:     Updated
                [Mareting Territory Names needs to be camel case and "Korea Japan" needs to be "Japan Korea". This makes naming consistant with others fields]
                Updated US-WEST to US-West, US-EAST to US-East
Change Log:     Updated
                [Reason]
                    (*) Act-On User Name moved to Custom Label: Campaign_Management_Act_On_API_User
Change Log:    Updated     -     JOYDEV     -     06/08/2014
               [Reason] New logic for Marketing Territory evaluation:
                        (*) US-Major (Qualcomm, Marvell, Broadcom, Nvidia, AMD): Use Custom Setting for Company Names, in 
                            future we need to add/Remove, we don’thave to change the code
                        (*) US: Previously Corporate State was involved in evaluation, remove logic on Corporate state. 
                                Also, all countries in North/South America are assigned to “US” Marketing Territory
Change Log:    Updated     -     JOYDEV     -     07/08/2014
               [Reason] New logic:
                        (*) No Calculations of Marketing Territory, Place Marketing Territory in Country Codes custom 
                            settings.                               
                        (*) Change Country names to lower/upper case and use same case to query data from Custom setting.
                        (*) US Major companies should be checked based on contained logic.
                        (*) US Major custom setting should contain Marketing territory.
Change Log:    Updated     -     ZAmbat     -     10/28/2014
               [Reason] Updated code as per CASE 35698.                        
****************************************************************************************************************************************/

public class LeadUtil {

    private static final String US = 'USA';
    private static final String OTHER_REGION = 'Other – Region';
    private static final String ACT_ON_API_USER = Label.Campaign_Management_Act_On_API_User;
    
    public static Boolean sendEmail = true;
    
    /** 
    *  method:         AssignRegions
    *  args:           leads ("Trigger.New" from the calling trigger "LeadRegionTrigger")
    *  return type:    none
    *  purpose:        this method detects lead region called from trigger "LeadRegionTrigger"
    **/
    public static void AssignRegions(List<Lead> leads, Boolean isUpdate, 
                                     Map<Id, Lead> leadNewMap, Map<Id, Lead> leadOldMap){
        Map <String, Country_ISO__c> CountryISOMap = new Map <String, Country_ISO__c>();
        Map <String, Majors__c> MajorMap = new Map <String, Majors__c>(); 
        String USMajors = EnvironmentVariable.get('US-Majors');
        String RUS = EnvironmentVariable.get('US');
        String USEast = EnvironmentVariable.get('US-East');
        String USSales = EnvironmentVariable.get('US Sales');
        
        for(Country_ISO__c iso : Country_ISO__c.getAll().Values()) {
            CountryISOMap.put(iso.Name.toLowerCase(), iso);
        }
        
        for(Majors__c maj : Majors__c.getAll().Values()) {
            MajorMap.put(maj.Name.toLowerCase(), maj);
        }
        
        for(Lead ld : leads) {
            /*skip loop if state or country is not changed for before update*/
            if((isUpdate && 
                leadNewMap.get(ld.Id).Marketing_Territory__c == leadOldMap.get(ld.Id).Marketing_Territory__c &&
                leadNewMap.get(ld.Id).Company == leadOldMap.get(ld.Id).Company &&
                leadNewMap.get(ld.Id).Corporate_Country__c == leadOldMap.get(ld.Id).Corporate_Country__c &&
                leadNewMap.get(ld.Id).Corporate_State__c == leadOldMap.get(ld.Id).Corporate_State__c &&
                leadNewMap.get(ld.Id).Hot_Lead__c == leadOldMap.get(ld.Id).Hot_Lead__c &&
                leadNewMap.get(ld.Id).Region__c == leadOldMap.get(ld.Id).Region__c)){ 
                continue;        
            } 
            /*skip loop if lead is imported using lead import wizard without being a Hot Lead*/
            else if(!isUpdate &&
                    ld.Region__c == Null &&
                    ld.Marketing_Territory__c == Null &&
                    ld.Hot_Lead__c == False){ 
                continue;
            }
            /*Mark lead as hot lead if Lead is created from Leads Tab and skip rest of the logic*/
            else if(!isUpdate &&
                    ld.Region__c != Null &&
                    ld.Region__c != '') {  
                ld.Hot_Lead__c = True;
                continue;
            }
            /*skip if lead is created from "Act-On API User" then lead should be assigned to "Act-On Lead Admin Queue"*/
            else if(!isUpdate && ld.CreatedBy.Name == ACT_ON_API_USER){
                continue; 
            }
            
            String szCountry = (ld.Corporate_Country__c != Null ? 
                                ld.Corporate_Country__c.toLowerCase() : Null);
            String szCompany = ld.Company.toLowerCase();
            Boolean isMajor = False;
            String szMajor;
            String szMajorZone;
            
            Country_ISO__c countryIso = (CountryISOMap.containsKey(szCountry) ? 
                                         CountryISOMap.get(szCountry) :
                                         Null);
                                                     
            for(Majors__c usm : MajorMap.values()) {
                if(szCompany.contains(usm.Name.toLowerCase())) {
                    isMajor = True;
                    szMajor = usm.Marketing_Territory__c;
                    
                    break;
                }
            }
            
            if(szCountry == US) {
                Map <String, US_States_Codes__c> StateCodesMap = US_States_Codes__c.getAll();
                szMajorZone = StateCodesMap.get(ld.Corporate_State__c).Zone__c;
            }
            
            if(isMajor) {
                // ZAmbat 10282014
                /*ld.Region__c = 'US';
                ld.Sales_Territory__c = szMajorZone;
                ld.Marketing_Territory__c = szMajor;*/
                ld.Classification__c = 'MAJORS';
                ld.Region__c = USMajors;
                if (szCompany.toLowerCase() == 'amd') {
                    ld.Sales_Territory__c = 'AMD';  
                } else if (szCompany.toLowerCase() == 'broadcom') {
                    ld.Sales_Territory__c = 'BRCM';
                } else if (szCompany.toLowerCase() == 'marvell') {
                    ld.Sales_Territory__c = 'MRVL';
                } else if (szCompany.toLowerCase() == 'nvidia') {
                    ld.Sales_Territory__c = 'NVDA';
                } else if (szCompany.toLowerCase() == 'qualcomm') {
                    ld.Sales_Territory__c = 'QCOM   ';
                }
            } else if (szCountry == US) {
                ld.Classification__c = USSales;
                ld.Region__c = RUS;
                ld.Sales_Territory__c = szMajorZone;
                ld.Marketing_Territory__c = szMajor;
            } else if(countryIso != Null) {
                ld.Classification__c = USSales;
                ld.Region__c = countryIso.Region__c;
                ld.Sales_Territory__c = (szCountry == US ? szMajorZone : countryIso.Sales_Territory__c);
                ld.Marketing_Territory__c = countryIso.Marketing_Territory__c;
            }
            else if(countryIso == Null) {
				if(leadOldMap!=null){
					if(ld.Region__c==leadOldMap.get(ld.Id).Region__c){
						ld.Classification__c = USSales;
						ld.Region__c = USEast;
						ld.Sales_Territory__c = 'US West1';
						ld.Marketing_Territory__c = 'US West1';
					}
				}
            }else {
                ld.Classification__c = null;
                ld.Region__c = Null;
                ld.Sales_Territory__c = Null;
                ld.Marketing_Territory__c = OTHER_REGION;
            }
        }
    }
    
    public static void upateDepartment(List<Lead> leadList){
        
        for(Lead leadObj :  leadList){
            
            leadObj.Created_By_Id__c = leadObj.CreatedById;
            
            if(leadObj.Market_Segment__c != null){
                
                leadObj.Market_Segment2__c = leadObj.Market_Segment__c;
            }
        }
    }
    
    
    public static void sendMail(List<Lead> leadList, Map<Id, Lead> oldLeadMap){
         System.debug('leadList : ' + leadList);
         System.debug('oldLeadMap : ' + oldLeadMap);
         Set<Id> userIdSet = new Set<Id>();
         Set<Id> queueIdSet = new Set<Id>();
         
         Set<Id> leadIdSet = new Set<Id>();
         
         for(Lead leadObj :  leadList){
            
            if(leadObj.Status == 'Submitted for Review' && oldLeadMap.get(leadObj.Id).Status != 'Submitted for Review'){
                
                leadIdSet.add(leadObj.Id);
                
                if( String.valueOf(leadObj.OwnerId).startsWith('00G') ){
                    queueIdSet.add(leadObj.OwnerId);
                }
                else{
                    userIdSet.add(leadObj.OwnerId);
                }
            }
         }
         
         if(leadIdSet.size() < 1){
            return;
         }
         
         List<GroupMember> groupMemberList = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN : queueIdSet];
         Map<Id, Id> userGroupIdMap = new Map<Id, Id>();
         for(GroupMember gm : groupMemberList){
            
            userIdSet.add(gm.UserOrGroupId);
            userGroupIdMap.put(gm.UserOrGroupId, gm.GroupId);
         }
         
         List<User> userList = [SELECT Id, Email FROM User WHERE Id IN : userIdSet];
         
         Map<Id, List<String>> userIdEmailListMap = new Map<Id, List<String>>();
         List<String> tempEmailList;
         
         for(User userObj : userList){
            if(userObj.Email != null){
                if(userIdEmailListMap.get(userObj.Id) != null){
                    
                    userIdEmailListMap.get(userObj.Id).add(userObj.Email);
                }
                else{
                    tempEmailList = new List<String>();
                    tempEmailList.add(userObj.Email);
                    userIdEmailListMap.put(userObj.Id, tempEmailList);
                }
                
                if(userGroupIdMap.get(userObj.Id) != null){
                    if(userIdEmailListMap.get(userGroupIdMap.get(userObj.Id)) != null){
                        
                        userIdEmailListMap.get(userGroupIdMap.get(userObj.Id)).add(userObj.Email);
                    }
                    else{
                        tempEmailList = new List<String>();
                        tempEmailList.add(userObj.Email);
                        userIdEmailListMap.put(userGroupIdMap.get(userObj.Id), tempEmailList);
                    }
                }
            }
         }
         
         Organization organizationObj = [SELECT Name FROM Organization];
         
         List<EmailTemplate> emailTemplateList = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE developerName = 'Leads_GF_New_Lead_Assignment'];
         
         String subject = '';
         String body = '';
         
         if(emailTemplateList.size() > 0 && emailTemplateList[0].Body != null){
            body = emailTemplateList[0].Body;
         }
         
         if(emailTemplateList.size() > 0 && emailTemplateList[0].Subject != null){
            subject = emailTemplateList[0].Subject;
         }
         
         if(organizationObj != null && organizationObj.Name != null){
            subject = subject.replace('{!Organization.Name}', organizationObj.Name);
         }
         else{
            subject = subject.replace('{!Organization.Name}', '');
         }
         
         Messaging.SingleEmailMessage email;
         
         String leadLink = URL.getSalesforceBaseUrl().toExternalForm() + '/';
         
         leadList = [SELECT Id, Status, OwnerId, Region__c, CreatedBy.Name, CreatedDate, Owner.Name, LeadSource, Company, Account_Type__c, Process_Tech_Interested__c, How_did_you_hear_about_GLOBALFOUNDRIES__c, Point_of_Contact_at_GLOBALFOUNDRIES__c, Purpose_for_Registration__c, X1st_Product_TO_Date__c, Geometry_Requested_by_Customer__c, FirstName, LastName, Email, Phone FROM Lead WHERE Id IN : leadIdSet];
         
         for(Lead leadObj :  leadList){
            
            if(leadObj.Status == 'Submitted for Review' 
               && oldLeadMap.get(leadObj.Id).Status != 'Submitted for Review'
               && leadObj.OwnerId != null
               && userIdEmailListMap.get(leadObj.OwnerId) != null
               && userIdEmailListMap.get(leadObj.OwnerId).size() > 0){
                
                email = new Messaging.SingleEmailMessage();
                
                if(leadObj.Region__c != null){
                    subject = subject.replace('{!Lead.Region__c}', leadObj.Region__c);
                }
                else{
                    subject = subject.replace('{!Lead.Region__c}', '');
                }
                
                email.setSubject(subject);
                
                if(leadObj.CreatedBy.Name != null){
                    body = body.replace('{!Lead.CreatedBy}', leadObj.CreatedBy.Name);
                }
                else{
                    body = body.replace('{!Lead.CreatedBy}', '');
                }
                
                if(leadObj.CreatedDate != null){
                    body = body.replace('{!Lead.CreatedDate}', String.valueOf(leadObj.CreatedDate));
                }
                else{
                    body = body.replace('{!Lead.CreatedDate}', '');
                }
                
                if(leadObj.Owner.Name != null){
                    body = body.replace('{!Lead.OwnerFullName}', leadObj.Owner.Name);
                }
                else{
                    body = body.replace('{!Lead.OwnerFullName}', '');
                }
                
                body = body.replace('{!Lead.Link}', leadLink + leadObj.Id);
                
                if(leadObj.LeadSource != null){
                    body = body.replace('{!Lead.LeadSource}', leadObj.LeadSource);
                }
                else{
                    body = body.replace('{!Lead.LeadSource}', '');
                }
                
                if(leadObj.Company != null){
                    body = body.replace('{!Lead.Company}', leadObj.Company);
                }
                else{
                    body = body.replace('{!Lead.Company}', '');
                }
                
                if(leadObj.Region__c != null){
                    body = body.replace('{!Lead.Region__c}', leadObj.Region__c);
                }
                else{
                    body = body.replace('{!Lead.Region__c}', '');
                }
                
                if(leadObj.Account_Type__c != null){
                    body = body.replace('{!Lead.Account_Type__c}', leadObj.Account_Type__c);
                }
                else{
                    body = body.replace('{!Lead.Account_Type__c}', '');
                }
                
                if(leadObj.Process_Tech_Interested__c != null){
                    body = body.replace('{!Lead.Process_Tech_Interested__c}', leadObj.Process_Tech_Interested__c);
                }
                else{
                    body = body.replace('{!Lead.Process_Tech_Interested__c}', '');
                }
                
                if(leadObj.How_did_you_hear_about_GLOBALFOUNDRIES__c != null){
                    body = body.replace('{!Lead.How_did_you_hear_about_GLOBALFOUNDRIES__c}', leadObj.How_did_you_hear_about_GLOBALFOUNDRIES__c);
                }
                else{
                    body = body.replace('{!Lead.How_did_you_hear_about_GLOBALFOUNDRIES__c}', '');
                }
                
                if(leadObj.Point_of_Contact_at_GLOBALFOUNDRIES__c != null){
                    body = body.replace('{!Lead.Point_of_Contact_at_GLOBALFOUNDRIES__c}', leadObj.Point_of_Contact_at_GLOBALFOUNDRIES__c);
                }
                else{
                    body = body.replace('{!Lead.Point_of_Contact_at_GLOBALFOUNDRIES__c}', '');
                }
                
                if(leadObj.Purpose_for_Registration__c != null){
                    body = body.replace('{!Lead.Purpose_for_Registration__c}', leadObj.Purpose_for_Registration__c);
                }
                else{
                    body = body.replace('{!Lead.Purpose_for_Registration__c}', '');
                }
                
                if(leadObj.X1st_Product_TO_Date__c != null){
                    body = body.replace('{!Lead.X1st_Product_TO_Date__c}', String.valueOf(leadObj.X1st_Product_TO_Date__c));
                }
                else{
                    body = body.replace('{!Lead.X1st_Product_TO_Date__c}', '');
                }
                
                if(leadObj.Geometry_Requested_by_Customer__c != null){
                    body = body.replace('{!Lead.Geometry_Requested_by_Customer__c}', leadObj.Geometry_Requested_by_Customer__c);
                }
                else{
                    body = body.replace('{!Lead.Geometry_Requested_by_Customer__c}', '');
                }
                
                if(leadObj.FirstName != null){
                    body = body.replace('{!Lead.FirstName}', leadObj.FirstName);
                }
                else{
                    body = body.replace('{!Lead.FirstName}', '');
                }
                
                if(leadObj.LastName != null){
                    body = body.replace('{!Lead.LastName}', leadObj.LastName);
                }
                else{
                    body = body.replace('{!Lead.LastName}', '');
                }
                
                if(leadObj.Email != null){
                    body = body.replace('{!Lead.Email}', leadObj.Email);
                }
                else{
                    body = body.replace('{!Lead.Email}', '');
                }
                
                if(leadObj.Phone != null){
                    body = body.replace('{!Lead.Phone}', leadObj.Phone);
                }
                else{
                    body = body.replace('{!Lead.Phone}', '');
                }
                
                email.setPlainTextBody(body);
                
                email.setToAddresses(userIdEmailListMap.get(leadObj.OwnerId));
                
                if(! Test.isRunningTest()){
                    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                }
                
                LeadUtil.sendEmail = false;
            }
         }
     }
	@future 
    public static void leadAssignment (Set<Id> leadIdSet){
        
        List<Lead> leadList = [SELECT Id,OwnerId,Owner.Name FROM Lead WHERE Id IN : leadIdSet];
         String QueueNames=Led_Queues__c.getInstance().Queue_Names__c;
        List<String> QueueList = QueueNames.split(',');        
        Map<String,Group> QueueIdSet=new Map<String,Group>([select Id,Name from Group where  Type = 'Queue' AND NAME IN:QueueList]);
        AssignmentRule asr = [select id ,Name from AssignmentRule where SobjectType = 'Lead' and Active = true and Name='GF Lead Routing' LIMIT 1]; 
       
        if(asr != NULL && leadList.size() > 0){
        
            Database.DMLOptions dmo;
        
            for(Lead leadObj : leadList){
                
                if(!QueueIdSet.containsKey(leadObj.OwnerId)){
                    System.debug(QueueIdSet.containsKey(leadObj.OwnerId)+':::::::'+asr.Id+'___'+asr.Name+'_____'+leadObj.OwnerId+'________'+leadObj.Owner.Name);
                    dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.assignmentRuleId=asr.Id; 
                    dmo.EmailHeader.triggerUserEmail = true; 
                    leadObj.setOptions(dmo); 
                    System.debug(leadObj.getOptions()+':::::::');
                }
            }
           
            System.debug('leadAssignment : ' + leadList);
            update leadList;
        }
    }	 
	 
	 
}