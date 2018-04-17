/**
* Author: Yathish NS 
* Project: NPI Report  
* Description: Test class for NPIGenerateReports class
**/
@isTest(SeeAllData=false)
public class NPIGenerateReportsTest {
    @testSetup static void testdata() {       
        }
    static testmethod void NPIGenerateReportsTest(){
       
         User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
         System.runAs(admin){
            DataUtilTest.loadEnvironmentVariables();
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
           
            Account acc;
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'India');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMap.put('Authorized_for_ASIC_business__c','Yes');
            acc =  AccountDataFactory.createAccount(fieldValueMap);
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Name','TESTDEVICEZAIH12345678');            
            fieldValueMap1.put('Fab__c' ,'FAB 2');        
            fieldValueMap1.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap1.put('Market_Segment__c' ,'Automotive');          
            fieldValueMap1.put('Semiconductor_Device__c','Analog Amplifier');                          
            fieldValueMap1.put('End_Customer__c' , 'Test Customer');        
            fieldValueMap1.put('Stage__c' ,'Design In');          
            fieldValueMap1.put('Status__c' , 'Active');                
            fieldValueMap1.put('Siebel_Device_ID__c' , '1234567890');
            fieldValueMap1.put('Tapeout_Type__c' ,'Customer MPW');          
            fieldValueMap1.put('PLM_Device_ID__c' ,'ANBQP60ACO8CH-U01');            
            fieldValueMap1.put('Device_Mask_Set_Title__c' ,'MSTTRT');        
            fieldValueMap1.put('Confidence_Level_Tapeout__c' ,'100');
            fieldValueMap1.put('Original_Forecasted_Tapeout_Date__c' , date.today().addDays(7));
            fieldValueMap1.put('CRMDID__c' ,'CDID0000001.00');        
            fieldValueMap1.put('Device_Type__c' , 'Base');
            fieldValueMap1.put('reticle_type__c' , 'Small Field Reticle (SFR)');
            fieldValueMap1.put('End_Application__c' , 'Body');
            Device__c Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            Dev1.Name = 'dev12';
            dev1.Actual_Tapeout_Date_GMT__c = system.today() - 50;
            update dev1;
            
            Map<String,Object> fieldValueMap2 = new Map<String,Object>();
            fieldValueMap2.put('Name','TESTDEVICEZAIH123456781');            
            fieldValueMap2.put('Fab__c' ,'FAB 2');        
            fieldValueMap2.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap2.put('Market_Segment__c' ,'Automotive');          
            fieldValueMap2.put('Semiconductor_Device__c','Analog Amplifier');                          
            fieldValueMap2.put('End_Customer__c' , 'Test Customer');        
            fieldValueMap2.put('Stage__c' ,'Design In');          
            fieldValueMap2.put('Status__c' , 'Active');                
            fieldValueMap2.put('Siebel_Device_ID__c' , '123456789012');
            fieldValueMap2.put('Tapeout_Type__c' ,'Customer MPW');          
            fieldValueMap2.put('PLM_Device_ID__c' ,'ANBQP60ACO8CH-U011');            
            fieldValueMap2.put('Device_Mask_Set_Title__c' ,'MSTTRT');        
            fieldValueMap2.put('Confidence_Level_Tapeout__c' ,'101');
            fieldValueMap2.put('Original_Forecasted_Tapeout_Date__c' , date.today().addDays(8));
            fieldValueMap2.put('CRMDID__c' ,'CDID0000001.002');        
            fieldValueMap2.put('Device_Type__c' , 'Base');
            fieldValueMap2.put('reticle_type__c' , 'Small Field Reticle (SFR)');
            fieldValueMap2.put('End_Application__c' , 'Body');
            Device__c Dev2 = DeviceDataFactory.createDevice(fieldValueMap2);
            Dev2.Name = '';
            dev2.PLM_Device_ID__c='plmdev1';
            dev2.Actual_Tapeout_Date_GMT__c = system.today() - 150;
            update dev2;
            
            ShippingReport__c sr = new ShippingReport__c();
            sr.CHARTERED_PART_NAME__c = dev1.Name;
            sr.IS_ELIGIBLE_TO_NPI__c = false;
            sr.SHIP_DATE__c = system.today() - 2;
            sr.SHIP_QTY__c = '310';
            
            insert sr;
            ShippingReport__c sr3 = new ShippingReport__c();
            sr3.CHARTERED_PART_NAME__c = dev2.PLM_Device_ID__c;
            sr3.IS_ELIGIBLE_TO_NPI__c = false;
            sr3.SHIP_DATE__c = system.today() - 200;
            sr3.SHIP_QTY__c = '300';
            insert sr3;
            DateTime yesterday = DateTime.now().adddays(-1);
            Test.setCreatedDate(sr.id,yesterday);
            NPIReportBatchToEmails__c emails1 = new NPIReportBatchToEmails__c();
            emails1.name = 'Test Email1';
            emails1.ToAddresses__c = 'yathish.ns@jktech.com;yathish.ns@globalfoundries.com';
            insert emails1;
            NPIGenerateReports genNPI = new NPIGenerateReports();
            database.executeBatch(genNPI,10);
            
            ShippingReport__c sr1 = new ShippingReport__c();
            sr1.CHARTERED_PART_NAME__c = dev2.Name;
            sr1.IS_ELIGIBLE_TO_NPI__c = true;
            sr1.SHIP_DATE__c = system.today() - 6;
            sr1.SHIP_QTY__c = '200';
            insert sr1;
            
            NPI_Report__c nr = new NPI_Report__c();
            nr.Account__c = acc.Id;
            nr.Hit_300_Wafer__c = 'No';
            nr.Device__c = dev2.Id;
            nr.Shipment_Date__c = system.today() - 6;
            nr.Shipment_Quantity__c = 200;
            nr.Days_to_Hit_300_Wafer__c = 10;
            nr.DaysElapsed__c = 40;
            insert nr;
            
            NPIReportBatchToEmails__c emails = new NPIReportBatchToEmails__c();
            emails.name = 'Test Email';
            emails.ToAddresses__c = 'yathish.ns@jktech.com;yathish.ns@globalfoundries.com';
            insert emails;
            
            NPINextSHIPFetchTime__c nst = new NPINextSHIPFetchTime__c();
            nst.Name = 'NPIBatchProcessInfo1';
            nst.LastShipProcessTime__c = system.today() - 1;
            nst.LastSuccessfulShipProcessTime__c = system.today() - 1;
            insert nst;
            NPIGenerateReports genNPI1 = new NPIGenerateReports();
            database.executeBatch(genNPI1,10);
        
        }
    }

}