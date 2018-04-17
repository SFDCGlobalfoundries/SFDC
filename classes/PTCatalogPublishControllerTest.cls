@isTest
private class PTCatalogPublishControllerTest {
        @testSetup
         static void testDataSetup(){
            DataUtilTest.loadEnvironmentVariables();
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
            
         }
        static Id createAccount() {
        // Create Account
        Account testAcct = getAccount('testing901');
        return testAcct.Id;
    }
    
    //static method to create product configuration
    static Apttus_Config2__ProductConfiguration__c  createProductConfig(String propID){
        Apttus_Config2__ProductConfiguration__c tempconfig = new Apttus_Config2__ProductConfiguration__c();
            tempconfig.name = 'testconfig';
            tempconfig.Apttus_QPConfig__Proposald__c = propID;
            tempconfig.Apttus_Config2__Status__c = 'Finalized';
        insert tempconfig ;
        return tempconfig;
    }
    
    static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c',processGeometry);  
        fieldValueMap.put('Process_Family__c','Super Low Power');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
       
    }
    
    static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
        static testMethod void DeviceTriggerTest1() {        
            string acctId = PTCatalogPublishControllerTest.createAccount();
            string opptyId = PTCatalogPublishControllerTest.createOpp(acctId, '0.60UM');
            string opptyProgramId = PTCatalogPublishControllerTest.createOppProg(acctId, opptyId);
            
            //Creation of Process Technology
       
           
            
            test.startTest();
             Process_Technology__c PT = new Process_Technology__c(
                name = 'PT002929',
                PT_number__c = 'PT002929',
                Catalog_Publication__c = true
            );
            insert PT;
            // Create Device
            /*
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICEZAIH12345677';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Mobility';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Actual_Tapeout_Date__c = date.today().adddays(2);
            device.Actual_Tapeout_Date_GMT__c = date.today().adddays(2);
            device.Stage__c = 'Solutioning';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Customer MPW';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'DVMST12345';
            device.CRMDID__c = 'CDID0000001.00';
            device.Device_Type__c = 'Base';
            device.Process_Technology_2__c = PT.Id;
            */
            Device__c device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
            device.Actual_Tapeout_Date__c = date.today().adddays(2);
            device.Actual_Tapeout_Date_GMT__c = date.today().adddays(2);
            device.Stage__c = 'Tapeout';
            insert device;
            system.debug('=====> ' + [select id,Actual_Tapeout_Date_GMT__c  from device__c where id = :device.Id]);
            Apttus_Proposal__Proposal__c prop = createProposal(acctId, opptyId, device.Id, Null, Null); 
            
             List<Apttus_Config2__LineItem__c> lineitem = new List<Apttus_Config2__LineItem__c>();
             //[select     ID,name,Apttus_Config2__ConfigurationId__c from     Apttus_Config2__LineItem__c Limit     1];   
             
             Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(Name = 'Test');
             insert prodConfig;
             Apttus_Config2__LineItem__c lineitem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__LineNumber__c = 1 , Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__PrimaryLineNumber__c = 20,Apttus_Config2__ConfigurationId__c = prodConfig.Id);
             lineitem.add(lineitem1);
             insert lineitem;                                               
            //Apttus_Config2__ProductConfiguration__c prodconfig = createProductConfig(prop.Id); 
            Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c = prop.Id, Apttus_QPConfig__ConfigurationId__c = prodConfig.Id);
            insert proposalLineItem;
            
           
            List<Apttus_Config2__ProductAttributeValue__c> ProdAttributeValueList = new List<Apttus_Config2__ProductAttributeValue__c  >();
            for(Apttus_Config2__LineItem__c LineItems : lineitem){
              Apttus_Config2__ProductAttributeValue__c TempProdAtt = new Apttus_Config2__ProductAttributeValue__c();
              TempProdAtt.Apttus_Config2__LineItemId__c    = LineItems.id;
              ProdAttributeValueList.add(TempProdAtt);
            }  
            insert ProdAttributeValueList;                                               
            
          //Scribe_Width_Base_Table__c base = new Scribe_Width_Base_Table__c(Process_Technology__c = '2blps',Actual_tapeout_date_for_dashboard__c = date.today());
            //insert base;
            Scribewidth_Calculator_Settings__c setting = new Scribewidth_Calculator_Settings__c(Actual_tapeout_date_for_dashboard__c = date.today(),SetupOwnerId = UserInfo.getUserId());
            insert setting;
           PTCatalogPublishController cpq = new PTCatalogPublishController();
           
           PT.Catalog_Publication__c = false;
           update PT;
            cpq = new PTCatalogPublishController();
        test.stopTest();
        
    }
        
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     //Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true);
        
        insert proposal;
        return proposal;
    }  
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }   

}