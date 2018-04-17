/**
* Author:       Inshu Misra
* Date:         30 Jun, 2017
* Project:      Test Class Automation  
* Description:  This data factory class will be used to create FMS data in different Test classes
**/

@isTest
public class FMSDataFactory {
    public enum FormType{MAIN,IMC,RIT,DDR,SP}
    public enum FileType{Dropbox,Design,TopCell}
    public static User testUser = createUser();
    public static PermissionSet fmsAdminPermissionSet{
        get{
            if(fmsAdminPermissionSet == null) {
                List<PermissionSet> PersmissionsTemp = [SELECT Id,
                                                       Name, 
                                                       Label, 
                                                       ProfileId, 
                                                       Profile.Name 
                                                  FROM PermissionSet
                                                 WHERE Name = 'FMS_Admin_Users'];
               if(PersmissionsTemp.size() < 1){
                   System.assert(false, 'FMS_Admin_Users permission set is required');
               }
               fmsAdminPermissionSet = PersmissionsTemp[0];
            }
            return fmsAdminPermissionSet;
        }
        set;
    }
    
    public static void intUserCreation(){
        IntegrationUsers__c intUser = new IntegrationUsers__c();
        intUser.Is_Integration_User__c = true;
        intUser.Name = 'Curr User';
        intUser.SetupOwnerId = UserInfo.getUserId();
        intUser.Skip_Trigger__c = true;
        intUser.Skip_Validation_Rule__c = true;
        insert intUser;
    }
    
    static User createUser(){
        //intUserCreation();
        //Profile GFadminprofile = [SELECT Id FROM Profile WHERE Name= 'GF FAE/FTS']; 
        /*String uEmail='standarduser'+ DateTime.now().getTime()+'@testorg.com';
        User GFAdminUser = new User(Alias = 'standt', Email=uEmail, 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = GFadminprofile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName=uEmail);
        insert GFAdminUser;*/
        User GFAdminUser = [select id from User where profile.Name = 'GF FAE/FTS' and IsActive=true limit 1];
        System.assert(GFAdminUser.id != null);
        System.runAs(GFAdminUser){
            List<PermissionSetAssignment> permission = new List<PermissionSetAssignment>([select AssigneeId, PermissionSetId from PermissionSetAssignment where AssigneeId =: GFAdminUser.id and PermissionSetId =: fmsAdminPermissionSet.Id]);
            if(permission.isEmpty()){
                PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = GFAdminUser.id, PermissionSetId = fmsAdminPermissionSet.Id);
                insert psa;
            }
        }
        return GFAdminUser;
    }

    public static Form_Management_System__c createFMSRecord(Map<String, Object> fieldValueMapFMS, FormType setFormType, Boolean isInsert){
        doValidation(fieldValueMapFMS, setFormType);
        Form_Management_System__c fObj;
        if(setFormType == FormType.MAIN){
            fObj = new Form_Management_System__c(
                Form_Name__c = 'Test Main Form', 
                Form_Description__c = 'Test Description',
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId());
        }else if(setFormType == FormType.IMC){
            fObj = new Form_Management_System__c(
                Form_Name__c = 'Test IMC Form', 
                Form_Description__c = 'Test Description',
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId());
        }else if(setFormType == FormType.RIT){
            fObj = new Form_Management_System__c(
                Form_Name__c = 'Test RIT Form', 
                Form_Description__c = 'Test Description',
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Submission (RIT)').getRecordTypeId());
        }else if(setFormType == FormType.DDR){
            fObj = new Form_Management_System__c(
                Form_Name__c = 'Test DDR Form', 
                Form_Description__c = 'Test Description',
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Return (DDR)').getRecordTypeId());
        }else if(setFormType == FormType.SP){
            fObj = new Form_Management_System__c(
                Form_Name__c = 'Test SP Form', 
                Form_Description__c = 'Test Description',
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId());
        }
        for(String fieldName: fieldValueMapFMS.keySet()){
            fObj.put(fieldName, fieldValueMapFMS.get(fieldName));        
        }
        if(isInsert && fObj != null){
            insert fObj;
        }
        return fObj;
    }
    
    public static List<Form_Management_System__c> createFMSRecords(List<Map<String, Object>> fieldValueMapFMSList, FormType setFormType){
        List<Form_Management_System__c> fmsList = new List<Form_Management_System__c>();
        for(Map<String,Object> fmsMap : fieldValueMapFMSList){
            fmsList.add(createFMSRecord(fmsMap, setFormType, false));
        }
        if(!fmsList.isEmpty()){
            insert fmsList;
        }
        return fmsList;
    }
    
    public static FMS_RIT_Drop_Box__c createFMSRITDropboxRecord(Map<String, Object> fieldValueMapRITDB, FileType setFileType, Boolean isInsert){
        doRITValidation(fieldValueMapRITDB, setFileType);
        FMS_RIT_Drop_Box__c ritObj;
        if(setFileType == FileType.Dropbox){
            ritObj = new FMS_RIT_Drop_Box__c(
                Drop_Box_File_Name__c = 'Test Dropbox1', File_Type__c = 'Design File',
                Package_Name__c = 'TestPkg',
                SentDate__c = System.now() -20, senderEmail__c = 'fdryrel@globalfoundries.com',
                RecordTypeId = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('Main Zip File').getRecordTypeId());
        }else if(setFileType == FileType.Design){
            ritObj = new FMS_RIT_Drop_Box__c(
                Design_File_Name__c = 'TestD1',
                RecordTypeId = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('File Name').getRecordTypeId());
        }else if(setFileType == FileType.TopCell){
            ritObj = new FMS_RIT_Drop_Box__c(
                TopCellName__c = 'TestD1',
                RecordTypeId = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('TopCell Name').getRecordTypeId());
        }
        for(String fieldName: fieldValueMapRITDB.keySet()){
            ritObj.put(fieldName, fieldValueMapRITDB.get(fieldName));        
        }
        if(isInsert && ritObj != null){
            insert ritObj;
        }
        return ritObj;
    }

    public static List<FMS_RIT_Drop_Box__c> createFMSRITDropboxRecords (List<Map<String, Object>> fieldValueMapRITDBList, FileType setFileType){
        List<FMS_RIT_Drop_Box__c> fRITList = new List<FMS_RIT_Drop_Box__c>();
        for(Map<String,Object> ritMap : fieldValueMapRITDBList){
            fRITList.add(createFMSRITDropboxRecord(ritMap, setFileType, false));
        }
        if(!fRITList.isEmpty()){
            insert fRITList;
        }
        return fRITList;
    }

    public static void doRITValidation(Map<String,Object> fieldValueMapRITDB, FileType setFileType){
        if (fieldValueMapRITDB.get('Form_Id__c') == null){
            throw new DataFactoryException ('Form_Id__c must be passed in as a field to be updated in the parameter passed to the method');
        }
        if(setFileType == FileType.Dropbox){
            if(fieldValueMapRITDB.get('File_Id__c') == null || fieldValueMapRITDB.get('Package_Id__c') == null){
                throw new DataFactoryException ('File_Id__c and Package_Id__c must be passed in as a field to be updated in the parameter passed to the method');
            }
        }else if(fieldValueMapRITDB.get('FMS_RIT_Drop_Box__c') == null){
            throw new DataFactoryException ('FMS_RIT_Drop_Box__c value must be passed in as a field to be updated in the parameter passed to the method for TopCell and Design files');
        }
    }            
    public static void doValidation(Map<String,Object> fieldValueMapFMS, FormType setFormType){
        if (fieldValueMapFMS.get('Customer_Name__c') == null){
            throw new DataFactoryException ('Customer_Name__c must be passed in as a field to be updated in the parameter passed to the method');
        }
        if(setFormType != FormType.MAIN && setFormType != FormType.SP && (fieldValueMapFMS.get('Parent_Form_Id__c') == null || fieldValueMapFMS.get('Main_Form_Id__c') == null)){
            throw new DataFactoryException ('Parent_Form_Id__c and Main_Form_Id__c values must be passed in as a field to be updated in the parameter passed to the method for the addendum forms');
        }
    }
}