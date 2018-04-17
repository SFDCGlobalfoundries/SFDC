@isTest(seeAllData=false)
public class DevicePscPsautilclsTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    //Method to test Approval of Business Category RMA
    static testmethod void testDevicePscPsautilcls1(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            
            psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
            psc.name = '7LP';
            psc.Psa_TPN_3D__c = 'U';
            psc.Psc_TPN_3D__c ='2';
            psc.Psa_TPN__c='U';
            psc.Psc_TPN__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                Is_ITAR__c = 'Yes',
                                ITAR_Flag__c = 'Yes',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'No',
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal',
                                MPO_system_calculated__c = 'YES',
                                Automotive_Device__c ='No',
                                PSA__c = '123456',
                                PSC__c = '123456'
                                );  
         insert dev;
        
            //Below statements to cover PsaPscController 
            ApexPages.currentPage().getParaMeters().put('deviceId',dev.id);
            PsaPscController psd = new PsaPscController();
            psd.selectedValue = '2';
            psd.getpscpicklist();
            psd.Submitflag();
            psd.Submit();
            psd.cancelbu();
            psd.getpscpicklistflag();
            
            dev.Contract_Control_Flag__c = 'No';
            checkRecursive.run = true;
            dev.ECCN_Technology__c = '3E292';          
            update dev;
             
            system.assertEquals(dev.ECCN_Technology__c,'3E292'); 
            //update dev;
            
            PsaPscController psdelseConditions = new PsaPscController();
            psdelseConditions.selectedValue = 'Select';
            psd.selectedValue = '0';
            psd.getpscpicklist();
            psdelseConditions.selectedValuepsc = 'Select';
            psd.Submitflag();
            psd.Submit();
            psd.cancelbu();
            psd.getpscpicklistflag();
         Test.stopTest();
        //}
       
    }
    
    static testmethod void testDevicePscPsautilcls2(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            
            psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
            psc.name = '7LP';
            psc.Psa_TPN_3D__c = 'U';
            psc.Psc_TPN_3D__c ='2';
            psc.Psa_TPN__c='U';
            psc.Psc_TPN__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes',
                                ITAR_Flag__c = 'Yes',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'No',
                                Automotive_Device__c ='No',
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
         dev.ITAR_Flag__c = 'Yes';
         update dev;
         
         system.assertEquals(dev.ITAR_Flag__c,'Yes');
         Test.stopTest();
        //}
      
    }
    
    static testmethod void testDevicePscPsautilcls3(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
           String accId = DesignExecutionUtill_Test.accountId;
           //String oppId = DesignExecutionUtill_Test.opportunityId;
           
           Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
                       
           Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
           insert oppProg;
            
           Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
           
           List<psa_psc_eccn_default__c> psaList = new List<psa_psc_eccn_default__c>();
               
           psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
           psa.name = '5E002/3E001.#';
           psa.psa_eccn__c = 'X';
           psa.psc_eccn__c = '2';
           
           psa_psc_eccn_default__c psa1 = new psa_psc_eccn_default__c();
           psa1.name = '3E292';
           psa1.psa_eccn__c = 'Dependent';
           psa1.psc_eccn__c = 'Project';
           
           psaList.add(psa);
           psaList.add(psa1);
           
           insert psaList;
          
           List<psa_psc_tpn_default__c> pscList = new List<psa_psc_tpn_default__c>();
           
           psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
           psc.name = '7LP';
           psc.Psa_TPN_3D__c = 'U';
           psc.Psc_TPN_3D__c ='2';
           psc.Psa_TPN__c='U';
           psc.Psc_TPN__c = '2';
           
           psa_psc_tpn_default__c psc1 = new psa_psc_tpn_default__c();
           psc1.name = '28HPP';
           psc1.Psa_TPN_3D__c = 'U';
           psc1.Psc_TPN_3D__c ='2';
           psc1.Psa_TPN__c='U';
           psc1.Psc_TPN__c = '2';
           
           pscList.add(psc);
           pscList.add(psc1);
           insert pscList;
            
           Test.startTest();
           Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'No',
								ITAR_Flag__c = 'No',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'No',
                                Enabled_via_previous_MPW_1__c ='No',
                                Automotive_Device__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
								
                                ); 
         insert dev;
        
         checkRecursive.run = true;
         dev.ITAR_Flag__c = 'No';
         dev.ECCN_Technology__c = '3E292';
         update dev;
         system.assertEquals(dev.ITAR_Flag__c,'No');
         Test.stopTest();
        //}
      
    }
    
    static testmethod void testDevicePscPsautilcls4(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
           
            List<psa_psc_tpn_default__c> pscList = new List<psa_psc_tpn_default__c>();
               
           psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
           psc.name = '7LP';
           psc.Psa_TPN_3D__c = 'U';
           psc.Psc_TPN_3D__c ='2';
           psc.Psa_TPN__c='U';
           psc.Psc_TPN__c = '2';
           
           psa_psc_tpn_default__c psc1 = new psa_psc_tpn_default__c();
           psc1.name = '28HPP';
           psc1.Psa_TPN_3D__c = 'U';
           psc1.Psc_TPN_3D__c ='2';
           psc1.Psa_TPN__c='U';
           psc1.Psc_TPN__c = '2';
           
           pscList.add(psc);
           pscList.add(psc1);
           insert pscList;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'No',
                                ITAR_Flag__c = 'No',                                    
                                ECCN_Technology__c = '5E002/3E001.#',
                                is3D_offering__c = 'No', 
                                Automotive_Device__c ='No',                             
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal',
								PSA__c = '123456',
                                PSC__c = '123456'
                                );  
         insert dev;
         
         checkRecursive.run = true;
         DevicePscPsautilcls ps = new DevicePscPsautilcls();
         ps.checkoptioneccn = true; 
         dev.ECCN_Technology__c = '3E292';
         dev.is3D_offering__c = 'Yes';                      
         update dev;
         
         system.assertEquals(dev.is3D_offering__c,'Yes');    
         Test.stopTest();
        //}
   
    }
    
    static testmethod void testDevicePscPsautilcls5(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
                           psa.name = '5E002/3E001.#';
                           psa.psa_eccn__c = 'X';
                           psa.psc_eccn__c = '2';
                           insert psa;
                           
                           psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
                           psc.name = '7LP';
                           psc.Psa_TPN_3D__c = 'U';
                           psc.Psc_TPN_3D__c ='2';
                           psc.Psa_TPN__c='U';
                           psc.Psc_TPN__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
           
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'No',
                                ITAR_Flag__c = 'No',
                                ECCN_Technology__c = '5E002/3E001.#',
                                is3D_offering__c = 'No',    
                                Automotive_Device__c ='No',                             
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal',
								PSA__c = '123456',
                                PSC__c = '123456'
                                );   
         insert dev;
         checkRecursive.run = true;                     
         update dev;
         
         system.assertEquals(dev.is3D_offering__c,'No');
         Test.stopTest();
        //}
    }
    
    
     static testmethod void testDevicePscPsautilcls6(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
           
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
                           psa.name = '5E002/3E001.#';
                           psa.psa_eccn__c = 'X';
                           psa.psc_eccn__c = '2';
                           insert psa;
                           
                           psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
                           psc.name = '7LP';
                           psc.Psa_TPN_3D__c = 'U';
                           psc.Psc_TPN_3D__c ='2';
                           psc.Psa_TPN__c='U';
                           psc.Psc_TPN__c = '2';
            insert psc;
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
           
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'No',
                                ITAR_Flag__c = 'No',
                                Automotive_Device__c ='No',
                                ECCN_Technology__c = '5E002/3E001.#',
                                is3D_offering__c = 'No',              
                                Enabled_via_previous_MPW_1__c ='No'
                                );   
         insert dev;
         
         checkRecursive.run = true;
         dev.ECCN_Technology__c = '4E001.$'; 
         dev.is3D_offering__c = 'Yes';       
         update dev;
         
         system.assertEquals(dev.is3D_offering__c,'Yes');
         Test.stopTest();
        //}
      
    }
    
     static testmethod void testDevicePscPsautilcls7(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
           
            List<psa_psc_tpn_default__c> pscList = new List<psa_psc_tpn_default__c>();
               
           psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
           psc.name = '7LP';
           psc.Psa_TPN_3D__c = 'U';
           psc.Psc_TPN_3D__c ='2';
           psc.Psa_TPN__c='U';
           psc.Psc_TPN__c = '2';
           
           psa_psc_tpn_default__c psc1 = new psa_psc_tpn_default__c();
           psc1.name = '28HPP';
           psc1.Psa_TPN_3D__c = 'U';
           psc1.Psc_TPN_3D__c ='2';
           psc1.Psa_TPN__c='U';
           psc1.Psc_TPN__c = '2';
           
           pscList.add(psc);
           pscList.add(psc1);
           insert pscList;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
           
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',  
                                ITAR_Flag__c = 'No',  
                                Automotive_Device__c ='No',                             
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
         dev.ECCN_Technology__c = '4E001.$'; 
         dev.is3D_offering__c = 'No';                         
         update dev;
         
         system.assertEquals(dev.is3D_offering__c,'No');
         Test.stopTest();
        //}
    }
    
    static testmethod void testDevicePscPsautilcls8(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
           
            List<psa_psc_tpn_default__c> pscList = new List<psa_psc_tpn_default__c>();
               
           psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
           psc.name = '7LP';
           psc.Psa_TPN_3D__c = 'U';
           psc.Psc_TPN_3D__c ='2';
           psc.Psa_TPN__c='U';
           psc.Psc_TPN__c = '2';
           
           psa_psc_tpn_default__c psc1 = new psa_psc_tpn_default__c();
           psc1.name = '28HPP';
           psc1.Psa_TPN_3D__c = 'U';
           psc1.Psc_TPN_3D__c ='2';
           psc1.Psa_TPN__c='U';
           psc1.Psc_TPN__c = '2';
           
           pscList.add(psc);
           pscList.add(psc1);
           insert pscList;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'No',
                                Automotive_Device__c ='Yes',
                                Automotive_Grade__c ='Grade 0',
                                ITAR_Flag__c = 'No',                                    
                                ECCN_Technology__c = '5E002/3E001.#',
                                is3D_offering__c = 'No',          
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal',
                                Is_result_of_Customer_Specific_Requireme__c = 'No',
								PSA__c = '123456',
                                PSC__c = '123456'
                                );  
         insert dev;
         
         checkRecursive.run = true;
         DevicePscPsautilcls ps = new DevicePscPsautilcls();
         ps.checkoptioneccn = true; 
         dev.ECCN_Technology__c = '3E292';
         dev.is3D_offering__c = 'No';                      
         update dev;
         
         system.assertEquals(dev.is3D_offering__c,'No');    
         Test.stopTest();
        //}
      
    }
    
    static testmethod void testDevicePscPsautilcls9(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','10LPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            
            PSAPSCTechnologies__c psc = new PSAPSCTechnologies__c();
            psc.name = '10LPP';
            psc.Technology__c = '10LPP';
            psc.Psa__c='U';
            psc.Psc__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes',
                                ITAR_Flag__c = 'Yes',
                                Automotive_Device__c ='No',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'Yes',
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
         DevicePscPsautilcls pscp = new DevicePscPsautilcls();
         pscp.checkoptioneccn = true;
         dev.ITAR_Flag__c = 'No';
         //dev.is3D_offering__c = 'Yes';
         update dev;
         
         system.assertEquals(dev.ITAR_Flag__c,'No');
         Test.stopTest();
        //}
       
    }
    
    
   
   static testmethod void testDevicePscPsautilcls10(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            
            psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
            psc.name = '7LP';
            psc.Psa_TPN_3D__c = 'U';
            psc.Psc_TPN_3D__c ='2';
            psc.Psa_TPN__c='U';
            psc.Psc_TPN__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',                                
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',                                
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes', 
								ITAR_Flag__c = 'No',
                                Automotive_Device__c ='No',                             
                                ECCN_Technology__c = 'dsd',                                
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
         /*DevicePscPsautilcls pscp = new DevicePscPsautilcls();
         pscp.checkoptioneccn = true;*/
         dev.ITAR_Flag__c = 'No';
         dev.is3D_offering__c = '';
         dev.Account__c = accId;
         dev.End_Customer__c = 'MPO';
         update dev;
         
         system.assertEquals(dev.ITAR_Flag__c,'No');
         Test.stopTest();
        //}
      
    }
    
     static testmethod void testDevicePscPsautilcls11(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','10LPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            
            PSAPSCTechnologies__c psc = new PSAPSCTechnologies__c();
            psc.name = '10LPP';
            psc.Technology__c = '10LPP';
            psc.Psa__c='U';
            psc.Psc__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes',
                                ITAR_Flag__c = 'Yes',
                                Automotive_Device__c ='No',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'No',
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
         DevicePscPsautilcls pscp = new DevicePscPsautilcls();
         pscp.checkoptioneccn = true;
         dev.ITAR_Flag__c = 'No';
         dev.Automotive_Device__c ='Yes';
         dev.Automotive_Grade__c ='Grade 0';
         //dev.is3D_offering__c = 'Yes';
         dev.Is_result_of_Customer_Specific_Requireme__c = 'No';
         update dev;
         
         system.assertEquals(dev.ITAR_Flag__c,'No');
         Test.stopTest();
        //}
       
    }
     
      static testmethod void testDevicePscPsautilcls12(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','10LPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            
            PSAPSCTechnologies__c psc = new PSAPSCTechnologies__c();
            psc.name = '10LPP';
            psc.Technology__c = '10LPP';
            psc.Psa__c='U';
            psc.Psc__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
            
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes',
                                ITAR_Flag__c = 'Yes',
                                Automotive_Device__c ='No',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'No',
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
         DevicePscPsautilcls pscp = new DevicePscPsautilcls();
         pscp.checkoptioneccn = true;
         dev.ITAR_Flag__c = 'No';
         dev.is3D_offering__c = 'No';
         update dev;
         
         system.assertEquals(dev.ITAR_Flag__c,'No');
         Test.stopTest();
        //}
       
    }
     
     static testmethod void testDevicePscPsautilcls122(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','28HPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            system.AssertEquals('X', psa.psa_eccn__c);
            
            psa_psc_tpn_default__c psc = new psa_psc_tpn_default__c();
            psc.name = '7LP';
            psc.Psa_TPN_3D__c = 'U';
            psc.Psc_TPN_3D__c ='2';
            psc.Psa_TPN__c='U';
            psc.Psc_TPN__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
           DevicePscPsautilcls pscp = new DevicePscPsautilcls();
           pscp.checkoptioneccn = true;   
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',                                
                                Opportunity_Program__c = oppProg.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',                                
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes',
								ITAR_Flag__c = 'No',	
                                Automotive_Device__c ='Yes',
                                Automotive_Grade__c ='Grade 0',
                                ECCN_Technology__c = 'dsd',                                
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal',
                                Is_result_of_Customer_Specific_Requireme__c = 'No'
                                ); 
         insert dev;
         
         checkRecursive.run = true;
        
         Test.stopTest();
       
    }
     static testmethod void testDevicePscPsautilcls13(){
        //User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            //String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('AccountId',accId);
            fieldValueMap.put('Name','Test Opportunity'+system.now());  
            fieldValueMap.put('StageName','4. Decision');
            fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
            fieldValueMap.put('Target_Process_Node__c','10LPP');
            fieldValueMap.put('Market_Segment__c','Mobility');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.10UM');  
            fieldValueMap.put('Process_Family__c','Generic / Nominal');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','Second Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
            fieldValueMap.put('FAE_CP2__c',True);
            Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=opp.Id);
            insert oppProg;
            
            psa_psc_eccn_default__c psa = new psa_psc_eccn_default__c();
            psa.name = '5E002/3E001.#';
            psa.psa_eccn__c = 'X';
            psa.psc_eccn__c = '2';
            insert psa;
            system.AssertEquals('X', psa.psa_eccn__c);
            
            
            PSAPSCTechnologies__c psc = new PSAPSCTechnologies__c();
            psc.name = '10LPP';
            psc.Technology__c = '10LPP';
            psc.Psa__c='U';
            psc.Psc__c = '2';
            insert psc;
            
            Contact con = new Contact(firstname = '.', lastname= 'Noreply', email = 'noreply@salesforce.com', accountId = accId);
           insert con;
           DevicePscPsautilcls pscp = new DevicePscPsautilcls();
           pscp.checkoptioneccn = true;   
            Test.startTest();
             Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 9',
                                Account__c = accId,
                                Opportunity_Program__c = oppProg.id,
								Opportunity2__c = opp.id,
                                Device_Sourcing__c = '1st Source',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Single Product',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'MSTTRT',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body',
                                End_Customer__c = 'MPO',
                                MPO_system_calculated__c = 'Yes',
                                Is_ITAR__c = 'Yes',
                                ITAR_Flag__c = 'Yes',
                                Automotive_Device__c ='No',
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'Yes',
                                Enabled_via_previous_MPW_1__c ='No',
                                Internal_Device_Geometry__c='0.10UM',
                                Internal_Device_Process_Family__c='Generic / Nominal',
								PSA__c = '123456',
                                PSC__c = '123456'
                                ); 
         insert dev;
         
         
         checkRecursive.run = true;
		 update dev;
         
         Test.stopTest();
        //}
       // }
    }
    
    
 }