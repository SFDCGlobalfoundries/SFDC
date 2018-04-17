/*
 @class: FMSRITDropboxTriggerHandlerTest
 @CreatedBy: Anirban Roy
 @CreatedDate: 21 June, 2017
 @Description: Test class for the FMSRITDropboxTriggerHandler class.
 @Modifications-
 *
 */

@isTest
public class FMSRITDropboxTriggerHandlerTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables(); 

        Map<String,Object> accFieldMap = new Map<String,Object>{'Name' => 'GLOBAL FOUNDRIES','Site_Department__c' => 'Test Site 1', 'Sub_Type__c' => 'Direct', 'Transaction_Type__c' => 'Transactional',
            'Region__c' => 'APJ', 'Corporate_Address_1__c' => 'Test Bill To Address 1', 'Corporate_City__c' => 'Singapore', 'Corporate_Country__c' => 'Singapore'  };       
        accFieldMap.put('Fab_9_10__c','Yes');
        accFieldMap.put('Customer_Category__c','TFA');
        accFieldMap.put('Tech_Geo_Granted__c','0.007UM'+';'+'0.010UM');
        accFieldMap.put('SAP_Account_Number__c', '006104');

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');  
        System.runAs(thisUser){ 
            try{
                Account acc = AccountDataFactory.createAccount(accFieldMap);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandlerTest.class.getName(), 'testDataSetup()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }

    static Account getAccount(String name){
        Account acc = [select id, Name from Account where name = :name];
        return acc;
    }

    static Map<String,Object> CreatefieldValueFormMap(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        fieldValueFormMap.put('UniqueWebRDTSId__c', '111111');
        return fieldValueFormMap;
    }
    
    static testmethod void fmsRITTriggerTest(){

        Account accobj = getAccount('GLOBAL FOUNDRIES');

        Id ritFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Submission (RIT)').getRecordTypeId(); 
        FMSEmailTemplates.SendEditEmail = false;
        
        Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
        Form_Management_System__c fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);

		Test.startTest();
        FMSEmailTemplates.SendEditEmail = false;
        Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
        Form_Management_System__c fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms1 = [select id from Form_Management_System__c where recordtypeid=:ritFormRecordTypeId];
            FMS_RIT_Drop_Box__c ritdropbox = new FMS_RIT_Drop_Box__c();
            ritdropbox.Package_Id__c = '100';
            ritdropbox.Package_Name__c = 'Test';
            ritdropbox.Form_Id__c = fmsMainRec.Id;
            ritdropbox.senderEmail__c = 'test@globalfoundries.com';
            ritdropbox.SentDate__c = System.now();
            ritdropbox.Drop_Box_File_Name__c = 'package';
            ritdropbox.Drop_Box_File_Size__c = '3012';
            ritdropbox.File_Type__c = 'Design File';
            ritdropbox.recordtypeid = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('Main Zip File').getRecordTypeId();

            try{
                insert ritdropbox;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandlerTest.class.getName(), 'fmsRITTriggerTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            System.assertNotEquals(null, ritdropbox.Id);
            
            FMS_RIT_Drop_Box__c ritdropbox1 = new FMS_RIT_Drop_Box__c();
            ritdropbox1.Package_Id__c = '101';
            ritdropbox1.Package_Name__c = 'Test1';
            ritdropbox1.Form_Id__c = fmsMainRec.Id;
            ritdropbox1.senderEmail__c = 'test@globalfoundries.com';
            ritdropbox1.SentDate__c = System.now();
            ritdropbox1.File_Type__c = 'TAR / TGZ / ZIP / Other Archive';
            ritdropbox1.recordtypeid = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('File Name').getRecordTypeId();
            ritdropbox1.FMS_RIT_Drop_Box__c = ritdropbox.id;

            try{
                insert ritdropbox1;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandlerTest.class.getName(), 'fmsRITTriggerTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            System.assertNotEquals(null, ritdropbox1.Id);
            
            FMS_RIT_Drop_Box__c ritdropbox2 = new FMS_RIT_Drop_Box__c();
            ritdropbox2.Package_Id__c = '102';
            ritdropbox2.Package_Name__c = 'Test2';
            ritdropbox2.Form_Id__c = fmsMainRec.Id;
            ritdropbox2.senderEmail__c = 'test@globalfoundries.com';
            ritdropbox2.SentDate__c = System.now();
            ritdropbox2.File_Type__c = 'TAR / TGZ / ZIP / Other Archive';
            ritdropbox2.recordtypeid = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('TopCell Name').getRecordTypeId();
            ritdropbox2.FMS_RIT_Drop_Box__c = ritdropbox1.id;

            try{
                insert ritdropbox2;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandlerTest.class.getName(), 'fmsRITTriggerTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            System.assertNotEquals(null, ritdropbox2.Id);
            
            ritdropbox.Package_Name__c = 'Test1';
            ritdropbox.File_Type__c = 'TAR / TGZ / ZIP / Other Archive';

            try{
                update ritdropbox;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandlerTest.class.getName(), 'fmsRITTriggerTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            System.assertEquals('TAR / TGZ / ZIP / Other Archive', ritdropbox.File_Type__c);
            
            System.assertNotEquals(ritdropbox,null); 
            try{
                delete ritdropbox;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandlerTest.class.getName(), 'fmsRITTriggerTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }        
		Test.stopTest();
    }
}