/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a InternalDeviceTestUtil class. It contains method to prepare the test data for internal device functionality.
 *             
 * History:
 * <Vijay>     04012015 - Test class created
 * 
 */
@isTest
public class InternalDeviceTestUtil {

    public static Account createAccount(String name, String stage, String shortName, String siteDept, String subType, 
                                String transactionType,String accountProfile, String processTech, String region, 
                                String feTerritory, String salesTerritory, String finacialTerritory, Boolean copyAddress, String corporateAddress1,
                                String city, String corporateCountry, String billingAddress1, String organizationUnit, Integer totalEmployee){
       
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', name);            
        fieldValueMap.put('stage__c', stage);   
        fieldValueMap.put('short_name__c', shortName);     
        fieldValueMap.put('sub_type__c', subType);
        fieldValueMap.put('site_department__c', siteDept);          
        fieldValueMap.put('transaction_type__c', transactionType); 
        fieldValueMap.put('account_profile__c', accountProfile);  
        fieldValueMap.put('Process_Tech_Interested__c', processTech);                        
        fieldValueMap.put('region__c', region);   
        fieldValueMap.put('financial_territory__c', finacialTerritory);  
        fieldValueMap.put('Copy_Address__c', copyAddress);    
        fieldValueMap.put('Corporate_Address_1__c', corporateAddress1);          
        fieldValueMap.put('Corporate_City__c', city);                
        fieldValueMap.put('Corporate_Country__c', corporateCountry);
        fieldValueMap.put('Bill_To_Address_1__c', billingAddress1);          
        fieldValueMap.put('Organization_Unit__c', organizationUnit);            
        fieldValueMap.put('total_employee__c', totalEmployee);        
        fieldValueMap.put('Fab_9_10__c','No');

        return AccountDataFactory.createAccount(fieldValueMap);                        
       /*return new Account(Name = name, stage__c = stage, short_name__c = shortName,
                          site_department__c = siteDept, sub_type__c = subType, transaction_type__c = transactionType, 
                          account_profile__c = accountProfile,
                          Process_Tech_Interested__c = processTech , region__c = region, FE_Territory__c =feTerritory , Sales_Territory__c = salesTerritory,
                          financial_territory__c = finacialTerritory , Copy_Address__c = copyAddress ,
                          Corporate_Address_1__c = corporateAddress1, Corporate_City__c = city,Corporate_Country__c = corporateCountry ,
                          Bill_To_Address_1__c = billingAddress1, Organization_Unit__c = organizationUnit, total_employee__c = totalEmployee);*/
    }
   
    public static User createUser(String alias, String email, String lastName, String firstName,
                            String profileId, String userName, String federationIdentifier) {
        return new User(alias = alias, email=email, emailencodingkey='UTF-8', 
                        lastname=lastname, languagelocalekey='en_US', localesidkey='en_US', 
                        profileid = profileId, timezonesidkey='America/Los_Angeles', 
                        username=username, FederationIdentifier = federationIdentifier);
    }
   
    public static HCM_Employee__c createHCMEmployee(String loginId, String lastName, String firstName, String departmentName, String emailAddress, String jobTitle, 
                                                    String phoneNumber, String employeeId){
        return new HCM_Employee__c(Login_ID__c = loginId, Last_Name__c = lastName, First_Name__c = firstName, Department_Name__c = departmentName,
                                    Email_Address__c = emailAddress, Job_Title__c = jobTitle,Phone_Number__c = phoneNumber, Employee_ID__c = employeeId);
    }
   
    public static Device__c createDevice(String name, String fab, String stage, String status, String confienceLevelTapeout, Date orginalForecastedTPDate,
                                            String siebelDeviceId, String tapeoutType, Id accountId, String geometry, String processFamily){
    
        return new Device__c(Name = name, Fab__c = fab, Stage__c = stage, Status__c = status, 
                                                Confidence_Level_Tapeout__c = confienceLevelTapeout, Original_Forecasted_Tapeout_Date__c = orginalForecastedTPDate, 
                                                Siebel_Device_ID__c = siebelDeviceId,Tapeout_Type__c = tapeoutType, Account__c = accountId, 
                                                Internal_Device_Geometry__c = geometry, Internal_Device_Process_Family__c = processFamily);
    }
   
    public static Export_Control_Form__c createExportControlForm(Id userId, String prodDesc, String phone, String weaponProduct, String militaryProd, 
                                                                    String itarProd, String usEarProd, String nonUsEarProd, Id harmonizedSysId, String otherHrmonizedSys,
                                                                    String status){
        return new Export_Control_Form__c(OwnerId__c = userId, Product_Description__c = prodDesc, Phone__c = phone, Weapon_Product__c = weaponProduct, 
                                            Military_App_Product__c = militaryProd, ITAR_Product__c = itarProd, US_EAR_Product__c = usEarProd, 
                                            Non_US_EAR_Product__c = nonUsEarProd, Harmonized_System__c = harmonizedSysId, Other_Harmonized_System__c = otherHrmonizedSys,
                                            status__c = status);
    }
    
    public static Export_Control_HS_Code__c createExportCntrlHSCode(String hsCode, String hsDesc){
        return new Export_Control_HS_Code__c(HS_Code__c = hsCode, HS_Description__c = hsDesc);
        
    }
    
    public static Device_Export_Control_Junction__c createDeviceExportControlJunc(Id deviceId, Id exportControlFormId){
        return new Device_Export_Control_Junction__c(device__c = deviceId, export_control_form__c = exportControlFormId);
    }
    
    public static Contact createContact(String firstName, String lastName, Id accountId, String email,
                                       String role, String dept, Boolean isPortalUserCreated, Boolean isPortalUserActive){
       return new Contact(FirstName = firstName, lastName = lastName, AccountId = accountId, Email = email,
                          Role__c = role, Department__c = dept, Is_Portal_User_Created__c = isPortalUserCreated,
                          Is_Portal_User_Active__c=isPortalUserActive);
    }
    
        
}