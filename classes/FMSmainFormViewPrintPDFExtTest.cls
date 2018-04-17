/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the test logic for FMSMainFormViewExtCont Class.
 * @ Date :- 17/10/2016
 * @ Change History :-  
 **/
@isTest(SeeAllData = false)
public class FMSmainFormViewPrintPDFExtTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();                      
    }
    
    static testMethod void formMainViewExtTest() {
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            Account accountObj= new Account();
        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept1');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Lee');                
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
            fieldValueMap.put('short_name__c', 'TESTrec');
            fieldValueMap.put('Customer_Number__c', '10101');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueMap.put('SAP_Account_Number__c', '005193');
            fieldValueMap.put('Customer_Category__c', 'TFA');
            fieldValueMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            accountObj= AccountDataFactory.createAccount(fieldValueMap);
    
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Form_Name__c = 'testForm';
            fmsRec.TypeOfData__c = 'Post Design Service (Cheese and Fill)';
            fmsRec.Customer_Name__c = accountObj.id;
            fmsRec.Name__c = 'test';
            fmsRec.Email__c = 'test@emil.com';
            fmsRec.Phone__c = '4533435435';
            fmsRec.NamePrimary__c = 'Mr Testcon1r11r';
            fmsRec.QuoteOnly__c = 'No';
            fmsRec.State_of_the_Form__c = 'SubmittedForQuote';
            fmsRec.Packaging_Services__c = 'Yes';
            fmsRec.PackageRequirement__c = 'Customer Existing Package';
            fmsRec.QuoteOnly_Old_Value__c = 'Yes';
            fmsRec.Technology__c = 'CMS90WG (CMOS9WG)';
            INSERT fmsRec;
            
            Test.startTest();
                PageReference pageRef = Page.FMSMainFormViewPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', fmsRec.id);
        
                FMSmainFormViewPrintPDFExt mainviewExt = new FMSmainFormViewPrintPDFExt(new ApexPages.StandardController(fmsRec));
            Test.stopTest();
        } 
    }
    
    static testMethod void formMainViewExtTestMethod2() {
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Account accountObj= new Account();
        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept1');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Lee');                
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
            fieldValueMap.put('short_name__c', 'TESTrec');
            fieldValueMap.put('Customer_Number__c', '10101');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueMap.put('SAP_Account_Number__c', '005193');
            fieldValueMap.put('Customer_Category__c', 'TFA');
            fieldValueMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            accountObj= AccountDataFactory.createAccount(fieldValueMap);
            
            ContentVersion content=new ContentVersion(); 
            content.Title='Header_Picture1'; 
            content.PathOnClient='/' + content.Title + '.jpg'; 
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            content.VersionData=bodyBlob; 
            //content.LinkedEntityId=sub.id;
            content.origin = 'H';
            insert content; 
    
            List<FMS_Mapping_Table__c> fmstables = new List<FMS_Mapping_Table__c>();
                
            FMS_Mapping_Table__c fmstable = new FMS_Mapping_Table__c();
            fmsTable.Field__c = 'Metallization';
            fmsTable.Technology__c = 'CMS90WG (CMOS9WG)';
            fmsTable.DB_Value__c = 'Test Metal';
            fmsTable.UI_Value__c = 'Test UI##RD##01##test';
    
            fmsTables.addAll(new List<FMS_Mapping_Table__c>{fmsTable});
                
            insert fmsTables;
                 
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Form_Name__c = 'testForm';
            fmsRec.TypeOfData__c = 'Post Design Service (Cheese and Fill)';
            fmsRec.Customer_Name__c = accountObj.id;
            fmsRec.Name__c = 'test';
            fmsRec.Email__c = 'test@emil.com';
            fmsRec.Phone__c = '4533435435';
            fmsRec.NamePrimary__c = 'Mr Testcon1r11r';
            fmsRec.MetallizationOpts__c = 'Test Metal';
            fmsRec.QuoteOnly__c = 'Yes';
            fmsRec.State_of_the_Form__c = 'SubmittedForQuote';
            fmsRec.Packaging_Services__c = 'No';
            fmsRec.PackageRequirement__c = 'Customer Existing Package';
            fmsRec.HasReleaseGuidelines__c = 'No';
            fmsRec.ProductName__c = 'Testprod';
            fmsRec.ProductRevision__c = 'test222';
            fmsRec.ItarData__c  = 'No';
            fmsRec.HazardousUse__c = 'No';
            fmsRec.Technology__c = 'CMS90WG (CMOS9WG)';
            fmsRec.ReleaseProcessFlow__c = 'TestRel';
            fmsRec.TestServices__c = 'Yes';
            fmsRec.Chip_Interconnect__c = 'Wirebond';
            fmsRec.IntConBumpSource__c = 'No (21L2039)';
            fmsRec.ProjectedTapeout__c = date.newinstance(2016, 10, 10);
            fmsRec.SourcingLocation__c = 'GLOBALFOUNDRIES (Vermont, USA)';
            fmsRec.LastMetalUsed__c  = 'TestMetal';
            fmsRec.Waivers__c = 'No';
            fmsRec.NumMetalLayers__c = 'TestNumMetal';
            fmsRec.Passivation__c = 'testPas';
            fmsRec.Custom_Features__c = 'No';
            fmsRec.NotMfgFeatures__c = 'No';
            fmsRec.StepPlanCustomRequirement1__c = 'No';
            fmsRec.DataCheckingOptions__c = 'Full';
            fmsRec.ServiceOptions__c = 'Backside Grind';
            fmsRec.OtherServiceFeatures__c = 'testOthere';
            fmsRec.DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)';
            fmsRec.Deliverable__c = 'TestDeliv';
            fmsRec.Premerge__c = 'No';
            fmsRec.DeliverableSplit__c = 'No';
            fmsRec.Chipedgedesign__c = 'No';
            fmsRec.DesignDelivered__c = 'Oasis';
            fmsRec.EnhancedWiring__c = 'No';
            fmsRec.NumThickCuLevels__c = 'TestNum';
            fmsRec.BacksideGrindThickness__c = '480 um';
            //fmsRec.CLL__c = 'NO CLL (IBMLS)';
            fmsRec.FinalPassivation__c = 'TestFinal';
            fmsRec.LineFront__c = 'No';
            fmsRec.NonstandardCLL__c = 'TestNon';
            fmsRec.ShippingLabelCLL__c = 'TestShip';
            fmsRec.SubstrateType__c = 'p++ SX 1 mOhm-cm with 14um epi (84Y8840)';
            fmsRec.SubstratePartNumber__c = 'TestSub';
            fmsRec.NumOfDesigns__c = 2;
            fmsRec.NumOfFEOLDesigns__c = 4;
            fmsRec.NumOfBEOLDesigns__c = 2;
            fmsRec.MaxChipPower__c = '>5W';
            fmsRec.PinOneID__c = 'Using the appropriate layer to identify pin numbering';
            fmsRec.IpIdentification__c = 'No';
            fmsRec.DesignKitOthers__c = 'TestDes';
            fmsRec.C4LaminatePkg__c = 'No';
            fmsRec.ChamferedCorner__c = 'No';
            fmsRec.OtherC4PadLayout__c = 'TestOther';
            fmsRec.WireBondLayout__c = 'Staggered';
            fmsRec.WireBondPad__c = 4;
            fmsRec.WireBondPadPitch__c = 5;
            fmsRec.PickMap__c = 'No';
            fmsRec.WorstCaseTj__c = '<100C';
            fmsRec.DieXSize__c = 2;
            fmsRec.DieYSize__c =3;
            fmsRec.InputMethod__c = 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment';
            fmsRec.FileAttachment__c = content.Id;
            fmsRec.ECCN_attachmentName__c = content.Id;
            fmsRec.AppName__c = 'TestUSer1;';
            fmsRec.AppEmail__c = 'TestUSer1@rt.com;';
            
            INSERT fmsRec;
            test.startTest();
                PageReference pageRef = Page.FMSMainFormViewPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', fmsRec.id);
        
                FMSmainFormViewPrintPDFExt mainviewExt = new FMSmainFormViewPrintPDFExt(new ApexPages.StandardController(fmsRec));
                mainviewExt.getFormId();
                mainViewExt.renderChipEdgeDesign();
                mainViewExt.techFeaturePage();
                mainViewExt.getdataCheckingOptsList();
                mainViewExt.getMetalizationOption();
                mainViewExt.getconfigData();
    
            Test.stopTest();
        }
    }

    static testMethod void formMainViewExtTestMethod3() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Account accountObj= new Account();
        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept1');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Lee');                
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
            fieldValueMap.put('short_name__c', 'TESTrec');
            fieldValueMap.put('Customer_Number__c', '10101');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueMap.put('SAP_Account_Number__c', '005193');
            fieldValueMap.put('Customer_Category__c', 'TFA');
            fieldValueMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            accountObj= AccountDataFactory.createAccount(fieldValueMap);
                 
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Customer_Name__c = accountObj.id;
            fmsRec.QuoteOnly__c = 'No';
            fmsRec.QuoteOnly_Old_Value__c = 'Yes';
            
            INSERT fmsRec;
            test.startTest();
                PageReference pageRef = Page.FMSMainFormViewPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', fmsRec.id);
        
                FMSmainFormViewPrintPDFExt mainviewExt = new FMSmainFormViewPrintPDFExt(new ApexPages.StandardController(fmsRec));
    
            Test.stopTest(); 
        }
    }

    static testMethod void formMainViewExtTestMethod4() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Account accountObj= new Account();
        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept1');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Lee');                
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
            fieldValueMap.put('short_name__c', 'TESTrec');
            fieldValueMap.put('Customer_Number__c', '10101');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueMap.put('SAP_Account_Number__c', '000278');
            fieldValueMap.put('Customer_Category__c', 'TFA');
            fieldValueMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            accountObj= AccountDataFactory.createAccount(fieldValueMap);
                 
            Form_Management_System__c formObj = new Form_Management_System__c();
            formObj.Customer_Name__c = accountObj.id;
            formObj.QuoteOnly__c = 'No';
            formObj.Technology__c = 'CSOI 7RF';
            formObj.Packaging_Services__c = 'No';
            formObj.LastMetalUsed__c = 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)';
            formObj.Passivation__c = 'LV (01L6998)';
            formObj.Chip_Interconnect__c = 'C4 flip chip';
    
            INSERT formObj;
            test.startTest();
                PageReference pageRef = Page.FMSMainFormViewPage;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', formObj.id);
        
                FMSmainFormViewPrintPDFExt mainviewExt = new FMSmainFormViewPrintPDFExt(new ApexPages.StandardController(formObj));

            Test.stopTest(); 
        }
    }
    
    static testMethod void formMainViewExtTestMethod5() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            test.startTest();
            Account accountObj= new Account();
        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept1');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Lee');                
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
            fieldValueMap.put('short_name__c', 'TESTrec');
            fieldValueMap.put('Customer_Number__c', '10101');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueMap.put('SAP_Account_Number__c', '002009');
            fieldValueMap.put('Customer_Category__c', 'TFA');
            fieldValueMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            accountObj= AccountDataFactory.createAccount(fieldValueMap);
                 
            Form_Management_System__c formObj = new Form_Management_System__c();
            formObj.Customer_Name__c = accountObj.id;
            formObj.Technology__c = 'CMOS 9RFe';
    
            INSERT formObj;
    
            PageReference pageRef = Page.FMSMainFormViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', formObj.id);
    
            FMSmainFormViewPrintPDFExt mainviewExt = new FMSmainFormViewPrintPDFExt(new ApexPages.StandardController(formObj));
    
            Test.stopTest(); 
        }
    }

    static testMethod void formMainViewExtTestMethod6() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Account accountObj= new Account();
        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept1');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Lee');                
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
            fieldValueMap.put('short_name__c', 'TESTrec');
            fieldValueMap.put('Customer_Number__c', '10101');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
            fieldValueMap.put('Fab_9_10__c', 'Yes'); 
            fieldValueMap.put('SAP_Account_Number__c', '005193');
            fieldValueMap.put('Customer_Category__c', 'TFA');
            fieldValueMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
            accountObj= AccountDataFactory.createAccount(fieldValueMap);
    
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Form_Name__c = 'testForm';
            fmsRec.Customer_Name__c = accountObj.id;
            
            INSERT fmsRec;
    
            Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware', Product_External_ID__c = '1323233');
            insert prod;
                
            Id pricebookId = Test.getStandardPricebookId();
                
            PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
            insert standardPrice;
                
            Apttus_Proposal__Proposal__c aptt = new Apttus_Proposal__Proposal__c(FMS_Proposal__c = fmsRec.Id);
            insert aptt;
                
            Apttus_Proposal__Proposal_Line_Item__c apttLine = new Apttus_Proposal__Proposal_Line_Item__c();
            apttLine.Apttus_Proposal__Proposal__c = aptt.Id;
            apttLine.Apttus_Proposal__Product__c = prod.Id;
            apttLine.Apttus_QPConfig__OptionId__c = prod.Id;
            insert apttLine;
                
            Apttus_Config2__ClassificationName__c classiName = new Apttus_Config2__ClassificationName__c();
            classiName.Name = 'Test Classification';
            classiName.Apttus_Config2__HierarchyLabel__c = 'Test';
            classiName.Category_External_ID__c = '1234';
            insert classiName;
            
            Apttus_Config2__ClassificationHierarchy__c classHier = new Apttus_Config2__ClassificationHierarchy__c();
            classHier.Name = 'Test Name';
            classHier.Apttus_Config2__HierarchyId__c = classiName.Id;
            classHier.Apttus_Config2__Label__c = 'test label';
            classHier.Category_Hierarchy_External_ID__c = '12334';
            insert classHier;
            
            
            Apttus_Config2__ProductOptionGroup__c apttConfgrp = new Apttus_Config2__ProductOptionGroup__c ();
            apttConfgrp.Apttus_Config2__OptionGroupId__c = classHier.Id;
            apttConfgrp.Apttus_Config2__Sequence__c = 1;
            apttConfgrp.Apttus_Config2__ProductId__c = prod.Id;
            apttConfgrp.Apttus_Config2__IsHidden__c = false;
            insert apttConfgrp;
                
            Apttus_Config2__ProductOptionComponent__c apttConf = new Apttus_Config2__ProductOptionComponent__c();
            apttConf.Apttus_Config2__ComponentProductId__c = prod.Id;
            apttConf.Apttus_Config2__ProductOptionGroupId__c = apttConfgrp.Id;
            apttConf.Apttus_Config2__Sequence__c = 0;
            insert apttConf;
            
            test.startTest();
            PageReference pageRef = Page.FMSMainFormViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
    
            FMSmainFormViewPrintPDFExt mainviewExt = new FMSmainFormViewPrintPDFExt(new ApexPages.StandardController(fmsRec));
            mainViewExt.getconfigData();
    
            Test.stopTest(); 
        }
    }

}