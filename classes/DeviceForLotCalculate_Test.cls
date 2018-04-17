/*
    Author: Anirban Roy
    Description: This class is the test class for the DeviceForLotCalculate class. 
    History:
        ARoy        06192013    - code creation.   
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.   
        Ashwini     03302015    - Refactoring test class.
        Devendra  10142015      - Updated to fix device validation error                           
*/
@isTest(SeeAllData=false)
public class DeviceForLotCalculate_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                            
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }

    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }        
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Id createMaskSetTtitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1'); 
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    
    static Device__c createDevice(Id accId, Id oppProgId){
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MSTId);
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1947');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Single Layer Reticle (SLR)');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    /*static Device__c createDevice1(Id accId, Id oppId, Id oppProgId,Id mpwId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1000';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.MPW_Train_Number__c = mpwId;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Enabled_via_previous_MPW_1__c = 'No';
        dev.Fab__c = 'Fab 3';
        
        insert dev;
        return dev; 
    }
    
    static Device__c createDevice2(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE2000';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,11,20);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Enabled_via_previous_MPW_1__c = 'No';
        dev.Fab__c = 'Fab 3';
        
        insert dev;
        return dev; 
    }*/
    
    static Lot_Start_Quarter__c retrieveLSQ(){
        
        List<Lot_Start_Quarter__c> lotStrQtrList  = [select Id,Quarter_1_End_Date__c,Quarter_1_Start_Date__c,
                                                Quarter_2_End_Date__c,Quarter_2_Start_Date__c,Quarter_3_End_Date__c,
                                                Quarter_3_Start_Date__c,Quarter_4_End_Date__c,Quarter_4_Start_Date__c,
                                                Year__c from Lot_Start_Quarter__c 
                                                where Year__c=2013 limit 1];
        Lot_Start_Quarter__c lsqObj;
        if(lotStrQtrList.size()>0){
            lotStrQtrList[0].Quarter_1_Start_Date__c = date.newInstance(2013,1,1);
            lotStrQtrList[0].Quarter_1_End_Date__c = date.newInstance(2013,3,31);
            lotStrQtrList[0].Quarter_2_Start_Date__c = date.newInstance(2013,4,1);
            lotStrQtrList[0].Quarter_2_End_Date__c = date.newInstance(2013,6,30);
            lotStrQtrList[0].Quarter_3_Start_Date__c = date.newInstance(2013,7,1);
            lotStrQtrList[0].Quarter_3_End_Date__c = date.newInstance(2013,9,30);
            lotStrQtrList[0].Quarter_4_Start_Date__c = date.newInstance(2013,10,1);
            lotStrQtrList[0].Quarter_4_End_Date__c = date.newInstance(2013,12,31);
            update lotStrQtrList[0];
            lsqObj = lotStrQtrList[0];
        }else{
            Lot_Start_Quarter__c lsq = 
                                new Lot_Start_Quarter__c(Quarter_1_Start_Date__c = date.newInstance(2013,1,1),
                                                         Quarter_1_End_Date__c = date.newInstance(2013,3,31),
                                                         Quarter_2_Start_Date__c = date.newInstance(2013,4,1),
                                                         Quarter_2_End_Date__c = date.newInstance(2013,6,30),
                                                         Quarter_3_Start_Date__c = date.newInstance(2013,7,1),
                                                         Quarter_3_End_Date__c = date.newInstance(2013,9,30),
                                                         Quarter_4_Start_Date__c = date.newInstance(2013,10,1),
                                                         Quarter_4_End_Date__c = date.newInstance(2013,12,31),
                                                         Year__c=2013);
            insert lsq;
            lsqObj = lsq;
        }
        return lsqObj;
        
    }
    
    static Lot_Start_Delay_Maintenance__c retrieveLSDM(){
        List<Lot_Start_Delay_Maintenance__c> lotStrDlyMntList = [select Geometry__c,Id,Quarter_1_Delay__c,Quarter_2_Delay__c,
                                                      Quarter_3_Delay__c,Quarter_4_Delay__c,Tapeout_type__c,Year__c 
                                                      from Lot_Start_Delay_Maintenance__c where Geometry__c = '0.09UM' 
                                                      and Tapeout_type__c = 'Customer MPW' and Year__c = 2013 limit 1];
        Lot_Start_Delay_Maintenance__c lsdmObj;
        if(lotStrDlyMntList.size()>0){
            lotStrDlyMntList[0].Quarter_1_Delay__c = 4;
            lotStrDlyMntList[0].Quarter_2_Delay__c = 5;
            lotStrDlyMntList[0].Quarter_3_Delay__c = 6;
            lotStrDlyMntList[0].Quarter_4_Delay__c = 7;
            update lotStrDlyMntList[0];
            lsdmObj = lotStrDlyMntList[0];
        }else{
            Lot_Start_Delay_Maintenance__c lsdm = new Lot_Start_Delay_Maintenance__c(Geometry__c = '0.09UM',
                                                                                    Tapeout_type__c = 'Customer MPW',
                                                                                    Year__c = 2013,
                                                                                    Quarter_1_Delay__c = 4,
                                                                                    Quarter_2_Delay__c = 5,
                                                                                    Quarter_3_Delay__c = 6,
                                                                                    Quarter_4_Delay__c = 7);
            insert lsdm;
            lsdmObj = lsdm;
        }
        return lsdmObj;
    }
    
    static MPW_Train_Maintenance__c retrieveMPWTrainMnt(){
        List<MPW_Train_Maintenance__c> mpwTrainMntList = [select Delay__c, Id, Name from MPW_Train_Maintenance__c
                                                where Name = 'MPW1999' limit 1];
        MPW_Train_Maintenance__c mpwObj;
        if(mpwTrainMntList.size()>0){
            mpwTrainMntList[0].Delay__c = 6;
            update mpwTrainMntList[0];
            mpwObj = mpwTrainMntList[0];
        }else{
            MPW_Train_Maintenance__c mpw = new MPW_Train_Maintenance__c(Delay__c = 6,
                                                              Name = 'MPW1999',
                                                              Status__c = 'Active',
                                                              Close_Date__c = date.newInstance(2013,9,30),
                                                              Open_Date__c = date.newInstance(2013,8,30),
                                                              Customer_Tapeout_Date__c = date.newInstance(2013,11,30),
                                                              Other_Tapeout_Date__c = date.newInstance(2013,12,30));
                                                              
            insert mpw;
            mpwObj = mpw;
        }       
        return mpwObj;
    }
    
    static testMethod void calcForecastLotStartDateTest1(){
        //DataUtilTest.loadEnvironmentVariables(); 
        Test.startTest();
        
        // Data creation
        User user = DeviceForLotCalculate_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceForLotCalculate_Test.createOpp(acctId);
        String oppProgId = DeviceForLotCalculate_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceForLotCalculate_Test.createOppProgTmMem(oppProgId, user.id);
        Lot_Start_Quarter__c lssqObj = DeviceForLotCalculate_Test.retrieveLSQ();
        Lot_Start_Delay_Maintenance__c lsdmObj = DeviceForLotCalculate_Test.retrieveLSDM();
        
        Device__c dev = createDevice(acctId,oppProgId);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,5);
        //update dev;
        
        List<Device__c> devObjList = [select Forecasted_Lot_Start_Date__c from Device__c 
                                     where Id = :dev.Id];
        //system.assert(devObjList[0].Forecasted_Lot_Start_Date__c == date.newInstance(2013,3,9)); 
        
        Test.stopTest();
        
    }
    
    static testMethod void calcForecastLotStartDateTest2(){
        //DataUtilTest.loadEnvironmentVariables(); 
        Test.startTest();
        
        // Data creation
        User user = DeviceForLotCalculate_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceForLotCalculate_Test.createOpp(acctId);
        String oppProgId = DeviceForLotCalculate_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceForLotCalculate_Test.createOppProgTmMem(oppProgId, user.id);
        Lot_Start_Quarter__c lssqObj = DeviceForLotCalculate_Test.retrieveLSQ();
        Lot_Start_Delay_Maintenance__c lsdmObj = DeviceForLotCalculate_Test.retrieveLSDM();
        MPW_Train_Maintenance__c mpwObj = DeviceForLotCalculate_Test.retrieveMPWTrainMnt();
        
        Device__c dev1 = createDevice(acctId,oppProgId);
        dev1.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,7,2);
        //update dev1;
        
        List<Device__c> devObjList1 = [select Forecasted_Lot_Start_Date__c from Device__c 
                                     where Id = :dev1.Id];
        
       // system.assert(devObjList1[0].Forecasted_Lot_Start_Date__c == date.newInstance(2013,7,14));
        
        Test.stopTest();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}