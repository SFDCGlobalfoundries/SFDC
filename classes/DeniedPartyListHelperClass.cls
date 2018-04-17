/*
Type Name: DeniedPartyListHelperClass
Author: JK Technosoft
Created Date: 12-08-2016
Reason: DeniedPartyListHelperClass used to excute logic from "UnauthorizedLeadBatch" & "DeniedPartyListTrigger" 
……..
……..
*/
Public Class DeniedPartyListHelperClass{
    //following variable used to stop multiple times triggering to stop emails
    Public static Boolean multipleTimeFire = true;
        Public static void DeniedPartyList(List<Denied_Party_List__c> DPLRecords){
            if(DPLRecords.size()>0){
                //Denied Partlist data to find "unauthorized" records from "Lead","Account","Device__c"
                List<String> companyNames = New List<String>();
                for(Denied_Party_List__c dpl:DPLRecords){
                    if(dpl.COMPANY_NAME__c!=null && dpl.COMPANY_NAME__c!=''){
                        companyNames.add(dpl.COMPANY_NAME__c);
                    }
                }
                
                //Lead Object
                List<lead> allLeads = [SELECT id,Company,Corporate_Address_1__c,Corporate_Country__c FROM Lead WHERE (Company=:companyNames AND Unauthorized_Modified_Date__c=:null)];
                if(allLeads.size()>0){
                    DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(allLeads[0].Company,
                                                                                                                                allLeads[0].Corporate_Address_1__c,
                                                                                                                                null,
                                                                                                                                allLeads[0].Corporate_Country__c,
                                                                                                                                allLeads[0].id,
                                                                                                                                null);
                    allLeads[0].Unauthorized__c = validateVar.unauthorized;
                    allLeads[0].Unauthorized_Percentage__c = validateVar.percentageCalculation;
                    Update allLeads[0];
                }
                
                //Account Object
                List<Account> allAccounts = [SELECT id,Account_Name__c,Corporate_Address_1__c,Corporate_Country__c,Name FROM Account WHERE (Name=:companyNames AND Unauthorized_Modified_Date__c=:null)];
                if(allAccounts.size()>0){
                    DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(allAccounts[0].Name,
                                                                                                                                allAccounts[0].Corporate_Address_1__c,
                                                                                                                                null,
                                                                                                                                allAccounts[0].Corporate_Country__c,
                                                                                                                                allAccounts[0].id,
                                                                                                                                null);
                    allAccounts[0].Unauthorized__c = validateVar.unauthorized;
                    allAccounts[0].Unauthorized_Percentage__c = validateVar.percentageCalculation;
                    Update allAccounts[0];
                }
                
                //Device Object
                List<Device__c> allDevice = [SELECT id,End_Customer__c FROM Device__c WHERE (End_Customer__c=:companyNames AND Unauthorized_Modified_Date__c=:null)];
                if(allDevice.size()>0){
                    DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(allDevice[0].End_Customer__c,
                                                                                                                                    null,
                                                                                                                                    null,
                                                                                                                                    null,
                                                                                                                                    allDevice[0].id,
                                                                                                                                    null);
                    allDevice[0].Unauthorized__c = validateVar.unauthorized;
                    allDevice[0].Unauthorized_Percentage__c = validateVar.percentageCalculation;
                    Update allDevice[0];
                }
                /*        
                //Export Control Form
                List<Export_Control_Form__c> allECF = [SELECT id,End_User_Customer_Name__c FROM Export_Control_Form__c WHERE (End_User_Customer_Name__c=:companyNames AND Unauthorized_Modified_Date__c!=null)];
                if(allLeads.size()>0){
                    DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(allECF[0].End_User_Customer_Name__c,
                                                                                                                                    null,
                                                                                                                                    null,
                                                                                                                                    null,
                                                                                                                                    allECF[0].id,
                                                                                                                                    null);
                    allECF[0].Unauthorized__c = validateVar.unauthorized;
                    allECF[0].Unauthorized_Percentage__c = validateVar.percentageCalculation;
                    Update allECF[0];
                }
                */  
            }
      }
}