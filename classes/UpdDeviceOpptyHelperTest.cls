/* Author :- Suvajit Majumder 
   VijayVemuru 08122016    - Added test method for Deal Grading Clip Level Implementation as the field value is updated on Opportunity .  
 * */
@isTest
private class UpdDeviceOpptyHelperTest  
{
public static Account accObj;
public static Opportunity oppty;
@testSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
        Test.startTest();
        Id acc=DeviceUtilTest.createAccount();
        
        Id opp=DeviceUtilTest.createOpp(acc,'0.014UM');
        Test.stopTest();
    }
    public static Device__c createDevice(string acctId,string opptyId,string geometry,string status) 
    {
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.014UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        Mask_Set_Title__c MST= DeviceUtilTest.createMaskSetTtitleObj('MSTTRT1');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MST.id);
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICE');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c',status);
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Reason_For_Status_On_Hold__c','Test');
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
     
    static testmethod void UpdDeviceOpptyHelperTestMethod()
    
    {
        
        accObj = getAccount('MYTEST ACCOUNT1-Test');
        
        oppty = getOpportunity('Test Opportunity');
        
        User usr = [Select id from user where profile.name = 'System Administrator' and IsActive = true limit 1];
        system.runas(usr){
        Device__c dev=createDevice(accObj.Id,oppty.Id,'0.014UM','On Hold');            
        }
        test.startTest();
        Opportunity opp1=[select id,name,stageName from Opportunity where id=:oppty.Id];
        opp1.Fab_Assignment_1__c='Fab 6';
        opp1.StageName='8. Lost';
        system.runas(usr){
            update opp1;  
        }     
        test.stopTest();
               
    }  
    static testmethod void UpdDeviceOpptyHelperTestMethod2()
    {
        
        //Id acc=DeviceUtilTest.createAccount();
        //Id opp=DeviceUtilTest.createOpp(acc,'0.014UM');
        accObj = getAccount('MYTEST ACCOUNT1-Test');
        oppty = getOpportunity('Test Opportunity');
        test.startTest();
        Device__c dev=createDevice(accObj.Id,oppty.Id,'0.014UM','Active');
        
        
        opportunity opp2 = new opportunity(id=oppty.Id);
        opp2.Fab_Assignment_1__c = 'Fab 5';
        opp2.StageName='9. Dropped';
        update opp2;
        test.stoptest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];        
        return acct;
    }    
    private static Opportunity getOpportunity(string opptyName)
    {
        Opportunity oppt = [SELECT Id, Name FROM Opportunity Where Name =: opptyName];        
        return oppt;
    }    
}