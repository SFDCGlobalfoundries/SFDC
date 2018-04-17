@isTest
private class Test_CPQScribeWidthCalculatorController {

   
        static Id createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
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
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = processGeometry; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        return testOppty.Id;
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
        // Load Environment Variables  
        DataUtilTest.loadEnvironmentVariables();
        
        string acctId = Test_CPQScribeWidthCalculatorController.createAccount();
        string opptyId = Test_CPQScribeWidthCalculatorController.createOpp(acctId, '0.60UM');
        string opptyProgramId = Test_CPQScribeWidthCalculatorController.createOppProg(acctId, opptyId);
        
        
            // Create Device
           /* Device__c device = new Device__c();
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
            device.Stage__c = 'Solutioning';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Customer MPW';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'DVMST12345';
            device.CRMDID__c = 'CDID0000001.00';
            device.Device_Type__c = 'Base';*/
            Device__c device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
            insert device;
            test.startTest();
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
            
            /*
             List<Apttus_Config2__LineItem__c> lineitem = [select     ID,name,Apttus_Config2__ConfigurationId__c     
                                                            from     Apttus_Config2__LineItem__c 
                                                           Limit     1];
             for(Apttus_Config2__LineItem__c line : lineitem) {
               line.Apttus_Config2__ConfigurationId__c = prop.Id;
             }        
             update lineitem;
             List<Apttus_Config2__ProductAttributeValue__c> ProdAttributeValueList = new List<Apttus_Config2__ProductAttributeValue__c  >();
        for(Apttus_Config2__LineItem__c LineItems : lineitem) {
            Apttus_Config2__ProductAttributeValue__c TempProdAtt = new Apttus_Config2__ProductAttributeValue__c();
                TempProdAtt.Apttus_Config2__LineItemId__c    = LineItems.id;
            ProdAttributeValueList.add(TempProdAtt);
        }  
        insert ProdAttributeValueList;
           system.debug('--->' + [Select Id, Device__c from Apttus_Proposal__Proposal__c where id = :lineitem[0].Apttus_Config2__ConfigurationId__c]);
            */
            Scribe_Width_Base_Table__c base = new Scribe_Width_Base_Table__c(Process_Technology__c = '2blps');
            insert base;
           CPQScribeWidthCalculatorController cpq = new CPQScribeWidthCalculatorController(new ApexPages.StandardController(device));
           cpq.saveDie();
           
           CPQScribewidthdataPullerExt ext = new CPQScribewidthdataPullerExt(new ApexPages.StandardController(device));
           
           CPQScribeWidthOutputExt ext1 = new CPQScribeWidthOutputExt(new ApexPages.StandardController(prop));
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
                                                     //Mask_Set__c = szMaskSet,
                                                     //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true);
        
        insert proposal;
        return proposal;
    }   

}