/*
    Author: Ariz Solito
    Description: Test class for ProcessTechnologyIPReportCntrlr
    History: 
        Asolito     01272014    - Code creation.
*/
@isTest(SeeAllData=false)
public with sharing class ProcessTechnologyIPReportCntrlrTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    //Test method for internal user
    static testMethod void testClass(){
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Base_IP__c ip = new Base_IP__c(
            name = 'IP00001',
            description__c = 'DesignWare Cores HDMI RX PHY 1.4 at 3.4Gbps in GF 28nm HPP',
            geometry__c = '028nm',
            ip_vendor__c = 'vendor1',
            ip_type__c = 'CMOS',
            lifecycle__c = 'EOL',
            ip_number__c = 'PT00001',
            metal_layers__c = 'aa,bb,cc',
            Display_in_IP_Catalog__c  = 'Yes'
                                               
        );
        insert ip;
        
        IP__c ipKit = new IP__c(
            name = 'IP00001-00',
            ipNumber__c = ip.id,
            device_list__c = 'dev1',
            metal_stack_list__c = 'M1'
        );
        insert ipKit;
        
        Process_Technology__c pt = new Process_Technology__c(
            name = 'PT00001',
            pt_number__c = 'PT00001',
            ip_geometry_technology__c = '28HPP;18UM',
            tech_geometry__c = '0.028UM',
            Lifecycle__c ='5years',
            Description__c = 'Cores HDMI RX',
            Long_Description__c = 'Cores HDMI RX PHY 1.4 at 3.4Gbps in GF 28nm'                ,
            Tech_Type__c = 'Standard',
            Sub_Tech_Type__c = 'St-Parallel'                            
        );
        insert pt;
        
        IP_PT_Map__c junction  = new IP_PT_Map__c(
            ipNumber__c = ip.id,
            pt_number__c = pt.id            
        );
        insert junction;
        
        IP_Merge__c ipMerge = new IP_Merge__c(
            name = 'IP00001-M00',
            ipNumber__c = ip.id
        );
        insert ipMerge;

        //11192014 DBiswal - Added inserting of Process__c record
        Process__c process = new Process__c(
            Name = 'Process-1001',
            Process_Technology__c = pt.name,
            Process_Type__c = 'Absolute',
            Associated_PID__c = '0.014UM',
            Process_Owner__c = 'Aram',
            Process_Dev_Status__c = 'Completed',
            Org_ID__c = 'TE121'
        );
        insert process;        
        
        test.startTest();
        
        PageReference pageRef = Page.ProcessTechnologyIPReport;
        pageRef.getParameters().put('ptnumber','PT00001');
        pageRef.getParameters().put('iptype','CMOS');
        pageRef.getParameters().put('ipvendor','vendor1');
        pageRef.getParameters().put('iplifecycle','EOL');
        pageRef.getParameters().put('devicename','dev1');
        pageRef.getParameters().put('ipname','DesignWare');             
        pageRef.getParameters().put('metalstacks','M1');
        pageRef.getParameters().put('vendorPriceBookID','V1');
        pageRef.getParameters().put('offsetValue','0');
        Test.setCurrentPageReference(pageRef);
        
        ProcessTechnologyIPReportCntrlr ctrl = new ProcessTechnologyIPReportCntrlr();
        
        //call the instance methods        
        ctrl.getIPLifecycleList();
        ctrl.getIPVendorList();
        ctrl.getIPTypeList();
        ctrl.getPTNameList(); 
        ctrl.getOptionalColumns();
        ctrl.getAddedOptionalColumns();
        ctrl.refreshVendor();
        ctrl.first();
        ctrl.next();
        ctrl.previous();
        ctrl.last();
        ctrl.exportToPDF();
        ctrl.exportToExcel(); 
        
        //do show details
        //select all
        ctrl.showDetails();       
        
        //deselect all
        ctrl.showDetails();
        
        //do metal stacks filter 
        ctrl.metalStacks = 'aa';
        ctrl.query();
        
        //do add columns
        ctrl.addedColumns = 'Metal Layers';
        ctrl.addColumns();
        
        //do sort
        ctrl.sortField = 'IP ID';
        ctrl.sortType = 'asc';       
        ctrl.sort();                     
        
        //generate report on the list
        PageReference pageRef2 = Page.ProcessTechnologyIPReport;
        pageRef2.getParameters().put('ptnumber','PT00001');
        pageRef2.getParameters().put('iptype','CMOS');
        pageRef2.getParameters().put('ipvendor','vendor1');
        pageRef2.getParameters().put('iplifecycle','EOL');
        pageRef2.getParameters().put('devicename','dev1');
        pageRef2.getParameters().put('ipname','DesignWare'); 
        pageRef2.getParameters().put('generate','pdf'); 
        pageRef2.getParameters().put('cols','Pvts');
        pageRef2.getParameters().put('ipdetails','IP00001'); 
        pageRef.getParameters().put('metalstacks','M1'); 
        pageRef.getParameters().put('vendorPriceBookID','V2');
        pageRef.getParameters().put('offsetValue','0');
        Test.setCurrentPageReference(pageRef2);
        
        ctrl = new ProcessTechnologyIPReportCntrlr();  
        ctrl.getIPLifecycleList();
        ctrl.getIPVendorList();
        ctrl.getIPTypeList();
        ctrl.getPTNameList(); 
        ctrl.getOptionalColumns();
        ctrl.getAddedOptionalColumns();
        ctrl.refreshVendor();
        ctrl.first();
        ctrl.next();
        ctrl.previous();
        ctrl.last();
        
        //do metal stacks filter 
        ctrl.metalStacks = 'aa';
        ctrl.query();
        //ctrl.matchedMetalStacks(ctrl.metalStacks);
        //do add columns
        ctrl.addedColumns = 'Metal Layers';
        //ctrl.metalStacks = 'bb';
        ctrl.addColumns();
        //ctrl.matchedMetalStacks('bb');
        
        //do sort
        ctrl.sortField = 'IP ID';
        ctrl.sortType = 'asc';       
        ctrl.sort();      
        test.stopTest();                
    }
    
    //Test method for IP vendor users
    static testMethod void testClass2(){
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
            
        Account acc= getAccount('Test Account 007'); 
        
        Contact con = new Contact(
                firstName = 'test', 
                lastName = 'test',
                accountId = acc.id,
                department__c = 'Design'
        );
        insert con;
        
        Profile profileRec = [select id from Profile where Profile.Name = 'Customer Portal Admin' limit 1];
        User u = new User(alias = 'ts', 
                          email='testaccs@test.com',
                          emailencodingkey='UTF-8', 
                          lastname='TestLast', 
                          firstname='TestFirst', 
                          languagelocalekey='en_US',
                          localesidkey='en_US', 
                          profileid = profileRec.Id,
                          timezonesidkey='America/Los_Angeles',
                          username='testaccss@test.com',
                          communitynickname='tss',
                          FederationIdentifier='Test',
                          isActive = true,
                          contactid = con.id
       );
       insert u;
                
                         
       System.runAs(u){                         
        
        Base_IP__c ip = new Base_IP__c(
            name = 'IP00001',
            description__c = 'DesignWare Cores HDMI RX PHY 1.4 at 3.4Gbps in GF 28nm HPP',
            geometry__c = '028nm',
            ip_vendor__c = 'vendor1',
            ip_type__c = 'CMOS',
            lifecycle__c = 'EOL',
            ip_number__c = 'PT00001',
            metal_layers__c = 'aa,bb,cc',
            Display_in_IP_Catalog__c  = 'Yes'
                                               
        );
        insert ip;
        
        IP__c ipKit = new IP__c(
            name = 'IP00001-00',
            ipNumber__c = ip.id,
            device_list__c = 'dev1',
            metal_stack_list__c = 'M1'
        );
        insert ipKit;
        
        Process_Technology__c pt = new Process_Technology__c(
            name = 'PT00001',
            pt_number__c = 'PT00001',
            ip_geometry_technology__c = '28HPP;18UM',
            tech_geometry__c = '0.028UM',
            Lifecycle__c ='5years',
            Description__c = 'Cores HDMI RX',
            Long_Description__c = 'Cores HDMI RX PHY 1.4 at 3.4Gbps in GF 28nm'                ,
            Tech_Type__c = 'Standard',
            Sub_Tech_Type__c = 'St-Parallel'                            
        );
        insert pt;
        
        IP_PT_Map__c junction  = new IP_PT_Map__c(
            ipNumber__c = ip.id,
            pt_number__c = pt.id            
        );
        insert junction;
        
        IP_Merge__c ipMerge = new IP_Merge__c(
            name = 'IP00001-M00',
            ipNumber__c = ip.id
        );
        insert ipMerge;

        //11192014 DBiswal - Added inserting of Process__c record
        Process__c process = new Process__c(
            Name = 'Process-1001',
            Process_Technology__c = pt.name,
            Process_Type__c = 'Absolute',
            Associated_PID__c = '0.014UM',
            Process_Owner__c = 'Aram',
            Process_Dev_Status__c = 'Completed',
            Org_ID__c = 'TE121'
        );
        insert process;        
        
        test.startTest();
        
        PageReference pageRef = Page.ProcessTechnologyIPReport;
        pageRef.getParameters().put('ptnumber','PT00001');
        pageRef.getParameters().put('iptype','CMOS');
        pageRef.getParameters().put('ipvendor','vendor1');
        pageRef.getParameters().put('iplifecycle','EOL');
        pageRef.getParameters().put('devicename','dev1');
        pageRef.getParameters().put('ipname','DesignWare');             
        pageRef.getParameters().put('metalstacks','M1');
        pageRef.getParameters().put('vendorPriceBookID','V1');
        pageRef.getParameters().put('offsetValue','0');
        Test.setCurrentPageReference(pageRef);
        
        ProcessTechnologyIPReportCntrlr ctrl = new ProcessTechnologyIPReportCntrlr();
        
        //call the instance methods        
        ctrl.getIPLifecycleList();
        ctrl.getIPVendorList();
        ctrl.getIPTypeList();
        ctrl.getPTNameList(); 
        ctrl.getOptionalColumns();
        ctrl.getAddedOptionalColumns();
        ctrl.refreshVendor();
        ctrl.first();
        ctrl.next();
        ctrl.previous();
        ctrl.last();
        ctrl.exportToPDF();
        ctrl.exportToExcel(); 
        
        //do show details
        //select all
        ctrl.showDetails();       
        
        //deselect all
        ctrl.showDetails();
        
        //do metal stacks filter 
        ctrl.metalStacks = 'aa';
        ctrl.query();
        
        //do add columns
        ctrl.addedColumns = 'Metal Layers';
        ctrl.addColumns();
        
        //do sort
        ctrl.sortField = 'IP ID';
        ctrl.sortType = 'asc';       
        ctrl.sort();                     
        
        //generate report on the list
        PageReference pageRef2 = Page.ProcessTechnologyIPReport;
        pageRef2.getParameters().put('ptnumber','PT00001');
        pageRef2.getParameters().put('iptype','CMOS');
        pageRef2.getParameters().put('ipvendor','vendor1');
        pageRef2.getParameters().put('iplifecycle','EOL');
        pageRef2.getParameters().put('devicename','dev1');
        pageRef2.getParameters().put('ipname','DesignWare'); 
        pageRef2.getParameters().put('generate','pdf'); 
        pageRef2.getParameters().put('cols','Pvts');
        pageRef2.getParameters().put('ipdetails','IP00001'); 
        pageRef.getParameters().put('metalstacks','M1'); 
        pageRef.getParameters().put('vendorPriceBookID','V2');
        pageRef.getParameters().put('offsetValue','0');
        Test.setCurrentPageReference(pageRef2);
        
        ctrl = new ProcessTechnologyIPReportCntrlr();  
        ctrl.getIPLifecycleList();
        ctrl.getIPVendorList();
        ctrl.getIPTypeList();
        ctrl.getPTNameList(); 
        ctrl.getOptionalColumns();
        ctrl.getAddedOptionalColumns();
        ctrl.refreshVendor();
        ctrl.first();
        ctrl.next();
        ctrl.previous();
        ctrl.last();
        
        //do metal stacks filter 
        ctrl.metalStacks = 'aa';
        ctrl.query();
        //ctrl.matchedMetalStacks(ctrl.metalStacks);
        //do add columns
        ctrl.addedColumns = 'Metal Layers';
        //ctrl.metalStacks = 'bb';
        ctrl.addColumns();
        //ctrl.matchedMetalStacks('bb');
        
        //do sort
        ctrl.sortField = 'IP ID';
        ctrl.sortType = 'asc';       
        ctrl.sort();      
        test.stopTest(); 
        }               
    }
    
    private static Account getAccount(string AccountName){
        Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName and Owner.UserRoleId != NULL limit 1];
        return acc;
    }
}