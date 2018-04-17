/**********************************************************************************************************************************************
Trigger:       LeadTrigger
Object:        Lead
Events:        Before insert, Before update, After update
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  20/05/2014
Reason:        (*)Trigger to check the Active flag on Contact when lead is converted
               (*)Trigger to detect region with the following logic:
                    (1)  If Company Name Contains “Qualcomm” then Region “US-Qualcomm”
                    (2)  Address Country is “US” 
                         (a)  State Code is in EASTERN States list States then Region is “US-EAST”
                         (b)  State Code is in WESTERN States list States then Region is “US-WEST”
                    (3)  Country is in “Americas” other than “US” then Region is “Americas”
                    (4)  Country is “Korea” OR “Japan” then Region “Korea Japan”
                    (5)  Country is “China”, “Hong Kong”, “Macau” or “Taiwan” then Region is “Greater China”
                    (6)  Country is in “ASIA” list other than “China”, “Japan”, “Korea”, “Hong Kong”, “Macau” 
                         and “Taiwan” then Region “EMEA - ROA”
                    (7)  Country is in “Africa” list then Region “EMEA - ROA”
                    (8)  Country is in “EUROPE” list then Region “EMEA - ROA”
                    (9)  Country is in “Oceania” list then Region “EMEA - ROA”
                    (10) If above rules are not satisfied then Region is “Other – Region”

Change Log:    Created     -     JOYDEV     -     20/05/2014     
Change Log:    Updated     -     JOYDEV     -     24/05/2014  
               [Reason] Plan was to enable Country code and State Codes for lead Corporate Country and Corporate State. 
                        Currently Salesforce dose not support this functionality for Custom Fields. 
                        It needs to change from Country Code to Country Name keeping the State Code for Corporate State as it it.           
**********************************************************************************************************************************************/

trigger LeadTrigger on Lead (before insert, before update, after update, after Insert) {
    
    if(Trigger.isBefore) {
        /*call lead utility class method*/
        LeadUtil.AssignRegions(Trigger.New, Trigger.isUpdate, Trigger.NewMap, Trigger.OldMap);
        
        
        //Added as part of lead improvement process- Devendra
        Group leadConversionQueue = [Select Id from Group where Type = 'Queue' AND Name = 'Default Lead Queue' LIMIT 1];
        for(Lead leadObj :  trigger.new){
            if(leadObj.ownerid==leadConversionQueue.id){
                leadObj.ownerid=leadObj.createdbyid;
            }
        }
            
    } else if(Trigger.isAfter && Trigger.isUpdate) {
        /*Merged from trigger "LeadConversionTrigger" - BEGIN*/
        List<Lead> leadList = new List<Lead>();

        for(Lead leadObj :  trigger.new){
            leadList.add(leadObj);
        }
        
        ClsLeadConversionTrigHandler.onLeadConversion(leadList);
        /*Merged from trigger "LeadConversionTrigger" - END*/
    }

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        LeadUtil.upateDepartment(Trigger.new);
        if(trigger.new.size() == 1 && Trigger.isUpdate  && DeniedPartyListHelperClass.multipleTimeFire){
             /*
             Following code will work only for single record DML Operations
             Reason : To avoid time out exception for multiple looping to find Unauthorized.
             Solution: If we want bulk operations then need to validate denied part list using batch apex once.
                       Using "Unauthorized validated" field we can have how many records need to validate
             Advantage : It will not effect not any existing functionality
             */
              DeniedPartyListHelperClass.multipleTimeFire = false;
              for(Lead validateCustomer:Trigger.new){
                  Boolean executeDeniedParlist = true;
                  Lead oldLead = New Lead();
                  if(trigger.isupdate){ 
                      oldLead = Trigger.oldMap.get(validateCustomer.Id);
                  }
                  
                  if((oldLead.Unauthorized__c == True && validateCustomer.Unauthorized__c == false)){
                      executeDeniedParlist = false;
                      validateCustomer.Unauthorized_Percentage__c = null;
                      validateCustomer.Unauthorized_Modified_Date__c = system.today();
                  }
                  if((oldLead.Company == validateCustomer.Company) && !validateCustomer.DPL_HelperFld__c){
                      executeDeniedParlist = true;
                      validateCustomer.DPL_HelperFld__c = true;
                  }else if((oldLead.Company == validateCustomer.Company)){
                       executeDeniedParlist = false;
                  }
                  
                  
                  if(oldLead.Corporate_Address_1__c != validateCustomer.Corporate_Address_1__c && 
                                                       validateCustomer.Unauthorized_Percentage__c != null){
                      executeDeniedParlist = true;
                  }
                  
                  if(oldLead.Corporate_Country__c != validateCustomer.Corporate_Country__c && 
                                                       validateCustomer.Unauthorized_Percentage__c != null){
                      executeDeniedParlist = true;
                  }
                  
                  if(executeDeniedParlist){
                      DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(validateCustomer.Company,
					validateCustomer.Corporate_Address_1__c,
					null,
					validateCustomer.Corporate_Country__c,
					validateCustomer.id,
					null);
                      validateCustomer.Unauthorized__c = validateVar.unauthorized;
                      validateCustomer.Unauthorized_Percentage__c = validateVar.percentageCalculation;
                      if(validateCustomer.Unauthorized_Modified_Date__c!=null && !test.isRunningTest())validateCustomer.Unauthorized_Modified_Date__c = null;
                  }
              }
        }
    }
  
  if(Trigger.isAfter && Trigger.isUpdate && LeadUtil.sendEmail){
        LeadUtil.sendMail(Trigger.new, Trigger.oldMap);
    }
	if(Trigger.isInsert && Trigger.isAfter){        
        LeadUtil.leadAssignment(Trigger.newMap.keySet());
    }
}