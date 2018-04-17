/*
    Author: Ariz Solito
    Description: Test class for ProcessOpentextMashupCntrlr
    History: 
        Asolito     22082014    - Code creation.
*/
@isTest(seeAllData=true)
public class ProcessOpentextMashupCntrlrTest {

    static testMethod void testClass(){
    
        Process_Technology__c pt = new Process_Technology__c(
            name = 'PT00001',
            pt_number__c = 'PT00001',
            ip_geometry_technology__c = '28HPP',
            tech_geometry__c = '0.028UM'                
        );
        insert pt;
        
        Process__c pr = new Process__c(
            name = 'XYZ12',
            pid_number__c = 'P1',
            process_technology__c = 'PT00001',
            tech_geometry__c = '0.028UM',
            mask_layers__c = 'aa,bb,cc',
            main_design_rule__c = '12345',
            frame_table_spec__c = '12345',
            drc_runset__c = '12345;12345',
            EPSpec__c = '12345',
            ETSpec__c = '123456',
            main_generation_rule_spec__c = 'm1',
            generation_rule_spec__c = 'g1',
            process_flow_runsheet_spec__c = 'p1',
            interconnect_spec__c = 'p2',
            spice_model__c = 's1;s2'                       
        ); 
        insert pr;             
        
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.standardController(pr);
        ProcessOpentextMashupCntrlr ctrl = new ProcessOpentextMashupCntrlr(sc);               
    }
    
}