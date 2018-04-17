/***************************************************************************************************************************
Class:         QS_TestUtil
----------------------------------------------------------------------------------------------------------------------------
Author:        Prathamesh Kshirsagar
Created Date:  3/11/2014
Reason:        
Change Log:    Created     -     -     3/11/2014
               Updated     -     -     12/14/2016
***************************************************************************************************************************/
@isTest
public class QS_TestUtil{

   public static User createPortalUser(String alias, String email, String lastName, String firstName,
                            String profileId, String contactId, String userName) {
        return new User(alias = alias, email=email, emailencodingkey='UTF-8', 
                        lastname=lastname, languagelocalekey='en_US', localesidkey='en_US', 
                        profileid = profileId, contactId=contactId, timezonesidkey='America/Los_Angeles', 
                        username=username); 
   }
   
   public static Account createAccount(String name, String stage, String shortName, String siteDept, String subType, 
                                String transactionType,String accountProfile, String processTech, String region, 
                                String feTerritory, String salesTerritory, String finacialTerritory, Boolean copyAddress, 
                                       String corporateAddress1,
                                String city, String corporateCountry, String billingAddress1, String organizationUnit, Integer totalEmployee){
                                
       return new Account(Name = name, stage__c = stage, short_name__c = shortName,
                          site_department__c = siteDept, sub_type__c = subType, transaction_type__c = transactionType, 
                          account_profile__c = accountProfile,
                          Process_Tech_Interested__c = processTech , region__c = region, FE_Territory__c =feTerritory , Sales_Territory__c = salesTerritory,
                          financial_territory__c = finacialTerritory , Copy_Address__c = copyAddress ,
                          Corporate_Address_1__c = corporateAddress1, Corporate_City__c = city,Corporate_Country__c = corporateCountry ,
                          Bill_To_Address_1__c = billingAddress1, Organization_Unit__c = organizationUnit, total_employee__c = totalEmployee);
   }
   
   public static Contact createContact(String firstName, String lastName, Id accountId, String email,
                                       String role, String dept, Boolean isPortalUserCreated, Boolean isPortalUserActive){
       return new Contact(FirstName = firstName, lastName = lastName, AccountId = accountId, Email = email,
                          Role__c = role, Department__c = dept, Is_Portal_User_Created__c = isPortalUserCreated,
                          Is_Portal_User_Active__c=isPortalUserActive);
   }
   public static Portal_Tab_Access__c createportaTabAccess(Id accId, Boolean pcrb){
         return new Portal_Tab_Access__c(Account__c = accId,PCRB__c = pcrb);
                            }

    public static PWCA_publication__c  createPWCAPublication(String waferId, Date validTill, String typeOfMetalLayer,
                                                             String typeOfDocument, String technologyNode, String targetUsedInMetal,
                                                             String regionalSite, String noOfMetalLayer, String lotId, String fab,
                                                             String dopantUesd, String documentStatus, String deviceId, Id accountId){
        return new PWCA_publication__c(Wafer_ID__c = waferId, Valid_Till__c = validTill+ 5, Type_of_Metal_Layers__c = typeOfMetalLayer,
                                        Type_of_Document__c = typeOfDocument, Technology_Node__c = technologyNode, Targets_used_in_metal_deposition__c = targetUsedInMetal,
                                        Regional_Site_Approval__c  = regionalSite, No_of_Metal_Layers__c = noOfMetalLayer, Lot_ID__c = lotId, Fab__c = fab,
                                        Dopants_Used_for_Implantation__c = dopantUesd, Document_Status__c = documentStatus, Device_ID__c = deviceId,
                                        Customer_Of_Wafer__c = accountId);
    
    }
    
    public static PWCA_Attachments__c createPWCAAttachment(Id pwcaPublicationId, String fileName){ 
        return new PWCA_Attachments__c (PWCA_Publication__c = pwcaPublicationId, File_Name__c = fileName);
     
    }
    
    public static PWCAAssociated_Customers__c createPWCAAssociatedCustomer(Id accountId, Id pwcaPublicationId){
        return  new PWCAAssociated_Customers__c(Account__c = accountId,PWCA_Publication__c = pwcaPublicationId);
    }
    
    public static Error_Codes__c createErrorCode(String name, String message){
        return  new Error_Codes__c(Name = name, Message__c = message);
    }
    
    public static Environment_Variable__c createENVariable(String name, String value){
        return  new Environment_Variable__c(Name = name, Value__c = value);
    }
    
    public static Quality_Certificate__c createQualityCertificate(String certType, String stage, String title, String fab, Date expDate){
        return new Quality_Certificate__c (Certificate_Type__c = certType, Stage__c = stage, Certificate_Title__c = title, fabs__c =fab, Expiry_Date__c= expDate);
    } 
      public static Other_EHS_CSR_Certificate__c createEHSCertificate(String certType, String stage, String title, String fab, Date expDate){
        return new Other_EHS_CSR_Certificate__c(Certificate_Type__c = certType, Stage__c = stage, Certificate_Title__c = title, fabs__c =fab, Expiry_Date__c= expDate);
    }
     
    public static QC_Access_List__c createQCAssociatedCustomer(Id accountId, Id qualityCertificateId){
        return new QC_Access_List__c(Account__c = accountId, Quality_Certificate__c = qualityCertificateId);
    }
    public static EHS_Access_List__c createEHSAssociatedCustomer(Id accountId, Id qualityCertificateId){
        return new EHS_Access_List__c(Account__c = accountId, Other_EHS_CSR_Disclosures__c = qualityCertificateId);
    }
    public static Shipment_Internal__c createShipment_Internal(String name,Id accId){
        return new Shipment_Internal__c(Name = name,Account__c = accId);
    }
    public static Shipment_Line_Internal__c createShipment_Line_Internal(String name,Id shipmentinterId,Id accId,String ibmpart){
        return new Shipment_Line_Internal__c(Name = name,Shipment__c = shipmentinterId,Ultimate_Customer_Account__c = accId,IBM_Part_Num__c	=ibmpart);
    }
     public static PCN_EOL__c createPCNEOL(String name, String fab,String lmpa, String pkgtypeffect, String stage,String resion,Boolean lod1,Boolean lod2,Boolean lod3,String affnumbers,Date LOD,Date LSD,Date EOS){
        return new PCN_EOL__c (Name = name, Fab__c =fab,LMT_Affected__c= lmpa, Package_Type_Affected__c= pkgtypeffect, EOL_Stage__c= stage,Reason_for_the_discontinuance__c = resion,LODNotify1__c=lod1,LODNotify2__c=lod2,LODNotify3__c=lod3,Affected_Part_Numbers__c = affnumbers,Last_Order_Date__c = LOD,Last_Ship_Date__c = LSD,End_of_Service_and_Support_Date__c=EOS);
    } 
     public static Part_Customer_Infomation__c createPartCustomers(Id eolId,Id shipInterId,Id accId){
        return new Part_Customer_Infomation__c (End_Of_Life__c=eolId,Shipment_Line_Internal__c= shipInterId,Account__c=accId);
    }  
    public static UploadQC__c createUpdoadQC(String fileName, Date expDate, Id qualityCertificateId){
        return new UploadQC__c(File_Name__c = fileName, Expiry_Date__c = expDate, Quality_Certificate__c = qualityCertificateId);
    }
      
    
}