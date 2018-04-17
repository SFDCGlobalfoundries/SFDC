/*
    Author: Ariz Solito
    Description: Test class for ProcessReportCntrlr
    History: 
        Asolito     03192014    - Code creation.
*/
@isTest(SeeAllData=true)
public with sharing class ProcessReportCntrlrTest {

    static testMethod void testClass(){
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();               
        
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
            hv_voltages__c = '1',
            io_voltages__c = '1',
            core_voltages__c = '1',
            tech_type__c = 'type1'            
        ); 
        insert pr;             
        
        test.startTest();
        
        PageReference pageRef = Page.ProcessReport;
        pageRef.getParameters().put('geometry','0.028UM');
        pageRef.getParameters().put('ptnumber','PT00001');
        pageRef.getParameters().put('ptName','28HPP');
        pageRef.getParameters().put('masklayer','aa');
        pageRef.getParameters().put('pidnumbmer','P1');
        pageRef.getParameters().put('processname','XYZ12');        
        Test.setCurrentPageReference(pageRef);
        
        ProcessReportCntrlr ctrl = new ProcessReportCntrlr();
        
        //call the instance methods              
        ctrl.getGeometryList();
        ctrl.getPTNameList(); 
        ctrl.getOptionalColumns();
        ctrl.first();
        ctrl.next();
        ctrl.previous();
        ctrl.last();             
        
        //add columns
        ctrl.addedColumns = 'Top Metal';
        ctrl.addColumns();
        
        //do sort
        ctrl.sortField = 'PID Number';
        ctrl.sortTYpe = 'asc';       
        ctrl.sort();       
        
        ctrl.sortTYpe = 'desc';       
        ctrl.sort();       
        
        //run filter process
        ctrl.query();
        
        //generate report on the list
        PageReference pageRef2 = Page.ProcessReport;
        pageRef2.getParameters().put('geometry','0.028UM');
        pageRef2.getParameters().put('ptnumber','PT00001');
        pageRef2.getParameters().put('ptName','28HPP');
        pageRef2.getParameters().put('masklayer','aa');
        pageRef2.getParameters().put('pidnumbmer','P1');
        pageRef2.getParameters().put('processname','XYZ12');
        pageRef2.getParameters().put('iovoltage','1');
        pageRef2.getParameters().put('hvvoltage','1');
        pageRef2.getParameters().put('corevoltage','1');
        pageRef2.getParameters().put('techtype','type1');
        pageRef2.getParameters().put('generate','pdf');
        Test.setCurrentPageReference(pageRef2);
        
        ctrl = new ProcessReportCntrlr();                       
        
        test.stopTest();                
    }
}