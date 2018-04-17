/*
*   Author: NIHARIKA
*   Description:  Test Class for ERPDeviceSPMBOM
*   History: 
*   Niharika     - Class created 
	Gopi Koka	 - Modified class to cover schdule "ERPDeviceWithPartsHubScheduler" class and batch class   
*/
@isTest(SeeAllData=false)
public class ERPDeviceWithPartsHubBatchTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    static testMethod void testMethod1() {
        try{
            List<BOM__c> bomList = new  List<BOM__c>();
            BOM__c bom1 = getBOMData('0000000L4005');
            bomList.add(bom1);
            BOM__c bom2 = getBOMData('0000023F9766');
            bomList.add(bom2);
            
            Level_Code_Parts__c settingLevel = new Level_Code_Parts__c();
            settingLevel.Name = '31';
            settingLevel.Level_Code__c = '31';
            insert settingLevel;
            
            Level_Code_Parts__c settingLevel1 = new Level_Code_Parts__c();
            settingLevel1.Name = '30';
            settingLevel1.Level_Code__c = '30';
            insert settingLevel1;
            
            ERP_Batch_Completion_Date__c setting = new ERP_Batch_Completion_Date__c();
            setting.Name = 'CompletionDateValue';
            setting.Completion_Date__c = bom1.CreatedDate - (1/4.8);
            insert setting;
            
            getERPDeviceData();
            /*Database.BatchableContext bc;
            ERPDeviceWithPartsHubBatch erpBatch = new ERPDeviceWithPartsHubBatch();
            Test.startTest();  
            Database.executeBatch(erpBatch);
            Test.stopTest();  
            */
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            Test.startTest(); 
            String jobId = System.schedule('Test Class Run', CRON_EXP, new ERPDeviceWithPartsHubScheduler() ); 
            Test.stopTest(); 
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            GlobalUtility.logMessage('Error','ERPDeviceWithPartsHubBatchTest','testMethod1','','Exception while running test method',String.valueof(e.getMessage()),'','SPD',e,0);
        }
    }
    public static BOM__c getBOMData(String component) {  
        
        BOM__c bom = new BOM__c();
        try{
            bom.Change_Number__c ='10000N41442A';
            bom.Component__c = component;
            bom.Parent__c ='0000000L4004';
            bom.Part_BasicName__c ='MASK';
            bom.Part_Classification__c='BEOL Master Chip Asm';
            bom.Part_Ecrelease_Status__c='Release';
            bom.Part_Labof_Design__c='85DL';
            bom.Part_Level_Code__c='25';
            bom.Part_Short_Desc__c='GLASS MOLY';
            bom.Primary_Or_Optional_For__c='Primary';
            bom.Technology__c='SIGE8HP';
            bom.CreatedDate =System.now();
            bom.LastModifiedDate = System.now();
            insert bom;
        }catch(Exception e){
            ApexPages.addMessages(e);
            GlobalUtility.logMessage('Error','ERPDeviceWithPartsHubBatchTest','getBOMData','','Exception while running test method',String.valueof(e.getMessage()),'','SPD',e,0);
        }
        return bom;
    }
    public static ERP_Device__c getERPDeviceData() {     
        ERP_Device__c erpDevice = new ERP_Device__c();
        try{
            erpDevice.PSANew__c ='AAAAAZZ';
            erpDevice.PSCNew__c='0000025';
            erpDevice.Part_Number__c='0000000L4004';
            erpDevice.ITARNew__c ='No';
            insert erpDevice;
        }catch(Exception e){
            ApexPages.addMessages(e);
            GlobalUtility.logMessage('Error','ERPDeviceWithPartsHubBatchTest','getERPDeviceData','','Exception while running test method',String.valueof(e.getMessage()),'','SPD',e,0);
        }
        return erpDevice;
    }
}