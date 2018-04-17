@isTest(seeAllData=false)
public class PsaPscControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    //Method to test Approval of Business Category RMA
    static testmethod void testPsaPscController(){
       User sysAdmin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
       system.runas(sysAdmin){
           
            String accId = DesignExecutionUtill_Test.accountId;
            String oppId = DesignExecutionUtill_Test.opportunityId;
            string opptyProgramId = DeviceUtilTest.createOppProg(accId,oppId);
            Device__c dev = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 8',
                                Account__c = accId,
                                Opportunity_Program__c = opptyProgramId,
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
                                ECCN_Technology__c = 'dsd',
                                is3D_offering__c = 'No',
                                Contract_Control_Flag__c = 'Yes',  
                                Enabled_via_previous_MPW_1__c ='No'
                                );   

            insert dev;
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
                
            
           test.StartTest();
            ApexPages.currentPage().getParaMeters().put('deviceId',dev.id);
            PsaPscController psd = new PsaPscController();
            psd.selectedValue = '2';
            psd.getpscpicklist();
            psd.Submitflag();
            psd.Submit();
            psd.cancelbu();
            psd.getpscpicklistflag();
            
            dev.Contract_Control_Flag__c = 'No';
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
           test.StopTest();
         }
    }
}