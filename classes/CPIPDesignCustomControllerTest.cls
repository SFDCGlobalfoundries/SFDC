/*
    Author: Anirban Roy
    Description: This is the test class for CPIPDesignCustomController class.
    History:
        ARoy    03112015    - code creation.          
*/

@isTest(SeeAllData=false)
public class CPIPDesignCustomControllerTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
        
     }
    // Test method for IP Design Kit Customization
    static testMethod void cpqIPCustomizationTest(){
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            //Setup the Proposal test record types and cause the insert trigger to excecute
            Account acc = getAccount('MYTEST ACCOUNT1');        
            
            Opportunity opp = createOpp(acc.Id);        
            
            Team_Room__c tmrm = createTeamroom(acc.Id);
            Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
            Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
                Id pcId = createProdConfig(proposal.Id);
                //Create Proposal Process Tech Line Items
                Product2 ip1 = createOptionProduct('Test IP 1', 'IPs', 'TESTIP0001', 'AA');
                
                insert(new List<Product2>{ip1});
                
                Base_IP__c ip = createIP();
                createIPdesignKit(ip.Id);
                Apttus_Proposal__Proposal_Line_Item__c prop = createProposalLineItem(1, proposal.Id, ip1.Id, pcId);
                List<Configurator_Plus_Question__c> configQuesList = createConfigPlusQustion();
                
                Test.setCurrentPage(Page.CPIPDesignCustom);
                ApexPages.currentPage().getParameters().put('Id',ip.Id);
                ApexPages.currentPage().getParameters().put('ipn','IP00001-01');
                ApexPages.currentPage().getParameters().put('pnum','PT00034');       
                ApexPages.currentPage().getParameters().put('ptGeometry','0.028UM');
                ApexPages.currentPage().getParameters().put('propId',prop.Id);
            
            
            
                CPIPDesignCustomController ipDes = new CPIPDesignCustomController();
                ipDes.ipDesKitName = 'IP00001-02';
                ipDes.ipCustomStatus = 'Approved';
                List<SelectOption> optIPDesVerList = ipDes.getIPDesignKitVersions();
                List<SelectOption> optIPDesStatusList = ipDes.getIPDesignKitStatus();
                
                PageReference pgr = ipDes.save();
                pgr = ipDes.cancel();            
                pgr = ipDes.printPage();
            Test.stopTest();
        }        
    }
    
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szProductFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        //insert prod;
        return prod;
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
                                                     /*Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create Teamroom test record
    static Team_Room__c createTeamroom(Id accId){
        Team_Room__c tmrm = new Team_Room__c(Name = 'TESTTEAMROOM1313',
                                             Team_Room_Description__c= 'Team room Description ... ',Primary_Account__c=accId); //TBD
        insert tmrm;
        return tmrm; 
    }
    
    //Static method to create Teamroom test record
    static Team_Room_Member__c createTeamroomMember(Id tmrmId){
        Team_Room_Member__c tmrmmbr = 
                    new Team_Room_Member__c(User__c = UserInfo.getUserId(),
                                            Team_Room_Role__c = 'Moderator',
                                            Team_Room__c = tmrmId);
        insert tmrmmbr;
        return tmrmmbr; 
    }
    
    //Static method to create product test record
    static Product2 createOptionProduct(String szName, String szFamily, String szCode, String szMaskSet){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        //insert prod;
        return prod;
    }
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId, Id pcId){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, 'PROCESSTECHCOM0001');
        insert prod;
                                                         
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                         Apttus_QPConfig__ItemSequence__c = iNumber,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId,
                                                         Apttus_QPConfig__OptionId__c = optId/*,
                                                         Apttus_QPConfig__AttributeValueId__c = attrib.Id*/);
                                                         
        insert proposalLineItem;                
        
        return proposalLineItem;
    }        
    
    //Static method to create Account test record
    static Account createAccount(){
        RecordType recType = [Select Id 
                                From RecordType 
                               Where Name='Customer'  And
                                     SobjectType = 'Account'];
                               
        Account acc = new Account(Name = 'Test Account1',
                                  RecordTypeId = recType.id,
                                  Site_Department__c = 'IT',
                                  Sub_Type__c = 'Indirect',
                                  Transaction_Type__c = 'Non-Transactional',
                                  Region__c = 'US',
                                  Bill_To_Address_1__c = 'Test Address',
                                  Bill_To_City__c = 'Test City',
                                  Bill_To_Country__c = 'India',
                                  Corporate_Address_1__c = 'Test Address',
                                  Corporate_City__c = 'Test City',
                                  Corporate_Country__c = 'India');
        
        insert acc;
        return acc;
    }
    
    //Static method to create Opportunity test record
    static Opportunity createOpp(Id acctId){
      
      Map<String,Object> fieldValueMap = new Map<String,Object>();
      fieldValueMap.put('Name','Test Opportunity');
      fieldValueMap.put('AccountId',acctId);
      fieldValueMap.put('StageName','1. Discovery');
      fieldValueMap.put('Market_Segment__c','Automotive');
      fieldValueMap.put('Target_Process_Node__c','14XM');
      fieldValueMap.put('Process_Platform__c','GF Baseline');
      fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');
      fieldValueMap.put('Fab_Split__c',100);
      fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));
      fieldValueMap.put('Process_Geometry__c','0.014UM');
      fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
      fieldValueMap.put('Process_Family__c','Super Low Power');
      
      return OpportunityDataFactory.createOpportunity(fieldValueMap);
    }
    
    //Static method to create Opportunity Program test record
    static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        insert opProg;
        return opProg;
    }
    
    //Static method to create Device test record
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1313'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Account__c',accId); 
        fieldValueMap.put('Opportunity2__c',oppId); 
        fieldValueMap.put('Opportunity_Program__c',oppProgId); 
        fieldValueMap.put('Market_Segment__c','Automotive'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator'); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Device_Sourcing__c','3rd Source'); 
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('Siebel_Device_ID__c','0987654321'); 
        fieldValueMap.put('IP_Gap__c',false); 
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20)); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));   
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('Requested_from_Configuration__c',true);      
        fieldValueMap.put('Forecasted_Lot_Start_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('IP_Declaration_User_Ids__c',userinfo.getuserid());
        
        return DeviceDataFactory.createDevice(fieldValueMap);  
    }
    
    static void createIPdesignKit(Id baseIp){
        List<IP__c> ipList = new List<IP__c>();
        IP__c ip1 = new IP__c(Name = 'IP00001-01',IP_Type__c = 'NVM',PH1_QA_Status__c = 'NCR', IPNumber__c = baseIp, IP_Device_List__c = 'abc');
        IP__c ip2 = new IP__c(Name = 'IP00001-02',IP_Type__c = 'NVM',PH1_QA_Status__c = 'NCR', IPNumber__c = baseIp, IP_Device_List__c = 'def');
        IP__c ip3 = new IP__c(Name = 'IP00001-03',IP_Type__c = 'NVM',PH1_QA_Status__c = 'NCR', IPNumber__c = baseIp, IP_Device_List__c = 'ghi');
        ipList.add(ip1);
        ipList.add(ip2);
        ipList.add(ip3);
        insert ipList;
    }
    
    static Base_IP__c createIP(){
        Base_IP__c baseIp = new Base_IP__c(Name = 'IP00001',IP_Type__c = 'NVM', IP_Number__c = 'IP00001');
        insert baseIp;
        return baseIp;
    }
    
    //static method to create Configurator Plus Questions
    static List<Configurator_Plus_Question__c> createConfigPlusQustion(){
        List<Configurator_Plus_Question__c> FinalQstnList = new List<Configurator_Plus_Question__c>();
        List<String> IPQstnTypes = new List<String>{'NVM','IO','Memory','AMS'};
        for(String QstType : IPQstnTypes){
            Configurator_Plus_Question__c TempNewQstn = new Configurator_Plus_Question__c(  Active__c = TRUE 
                                                    , Data_Type__c = 'Text'
                                                    , Question_Type__c = 'IP Questions'
                                                    , Question_Name__c = 'Test Qstn'
                                                    , IP_Type__c = QstType);
          FinalQstnList.add(TempNewQstn);  
        }
        insert FinalQstnList; 
        return FinalQstnList ; 
    }
    
    static Id createProdConfig(Id configId){
        Apttus_Config2__ProductConfiguration__c pc = new Apttus_Config2__ProductConfiguration__c();
        pc.Apttus_QPConfig__Proposald__c = configId;
        insert pc;
        return pc.id;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}