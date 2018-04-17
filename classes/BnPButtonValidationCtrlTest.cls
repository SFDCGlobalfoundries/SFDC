/**
   @Author <Cognizant Technology Solutions>
   @name <BnPButtonValidationCtrlTest>
   @CreateDate <06/23/2017>
   @Description <Apex Test Class For BnPButtonValidationCtrl>
   @Version <>
   @reference <>
 */
@isTest
public class BnPButtonValidationCtrlTest{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    Static testMethod void BNPButValDelTypeDet() 
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            fieldValueOppMap.put('Product_Line__c', 'ASIC');
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            Customer_Requirement__c  cr = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueserviceMap = new Map<String,Object>();
            fieldValueserviceMap.put('Technical_Requirement__c',cr.id);
            Service__c   service = BNP_DataFactory.createService(fieldValueserviceMap); 
             
            Map<String,Object> fieldValuewaferMap = new Map<String,Object>();
            fieldValuewaferMap.put('Technical_Requirement__c',cr.Id);
            Wafer_Data__c WaferData  = BNP_DataFactory.createWaferData(fieldValuewaferMap);
        
            Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',cr.Id);
            fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
            
            Map<String,Object> fieldValueModuleMap = new Map<String,Object>();
            fieldValueModuleMap.put('Technical_Requirement__c',cr.Id);
            fieldValueModuleMap.put('Chip_1__c',ChipData.Id);
            Module_Data__c ModuleData  = BNP_DataFactory.createModuleData(fieldValueModuleMap);
            
            Map<String,Object> fieldValuePackageDataMap = new Map<String,Object>();
            fieldValuePackageDataMap.put('Technical_Requirement__c',cr.Id);
            fieldValuePackageDataMap.put('Module_Data__c',ModuleData.Id); 
            Package_Data__c  PackageData  = BNP_DataFactory.createPackageData(fieldValuePackageDataMap);
            
            Map<String,Object> fieldValueDesignMap = new Map<String,Object>();
            fieldValueDesignMap.put('Customer_Requirement__c',cr.Id);
            Design__c Designdata = BNP_DataFactory.createDesign(fieldValueDesignMap);
            
            List<BnPButtonValidationFieldMapping__c> custsettingList = new List<BnPButtonValidationFieldMapping__c>();
            BnPButtonValidationFieldMapping__c custsetting1 = new BnPButtonValidationFieldMapping__c();
            custsetting1.Name = '1001';
            custsetting1.Deliverable_Type_Name__c = 'All';
            custsetting1.Field_Api__c = 'Design_Win_Region__c';
            custsetting1.Field_Label__c = 'Opportunity :Design Win Region';
            custsetting1.isRecordPresent__c = false;
            custsetting1.Object_Name__c = 'Opportunity';
            custsetting1.Product_Line__c = 'All';
            custsetting1.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting1);
            
            BnPButtonValidationFieldMapping__c custsetting2 = new BnPButtonValidationFieldMapping__c();
            custsetting2.Name = '1002';
            custsetting2.Deliverable_Type_Name__c = 'All';
            custsetting2.Field_Api__c = 'Design_Win_Territory__c';
            custsetting2.Field_Label__c = 'Opportunity : Design Win Territory';
            custsetting2.isRecordPresent__c = false;
            custsetting2.Object_Name__c = 'Opportunity';
            custsetting2.Product_Line__c = 'ASIC';
            custsetting2.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting2);
            
            BnPButtonValidationFieldMapping__c custsetting3 = new BnPButtonValidationFieldMapping__c();
            custsetting3.Name = '1003';
            custsetting3.Deliverable_Type_Name__c = 'All';
            custsetting3.Field_Api__c = 'MD_part_name__c';
            custsetting3.Field_Label__c = 'Option :GF Part Name';
            custsetting3.isRecordPresent__c = false;
            custsetting3.Object_Name__c = 'Option';
            custsetting3.Product_Line__c = 'All';
            custsetting3.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting3);
            
            BnPButtonValidationFieldMapping__c custsetting4 = new BnPButtonValidationFieldMapping__c();
            custsetting4.Name = '1004';
            custsetting4.Deliverable_Type_Name__c = 'All';
            custsetting4.Field_Api__c = 'End_customer_project__c';
            custsetting4.Field_Label__c = 'Option :End customer project';
            custsetting4.isRecordPresent__c = false;
            custsetting4.Object_Name__c = 'Option';
            custsetting4.Product_Line__c = 'ASIC';
            custsetting4.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting4);
            
            /*BnPButtonValidationFieldMapping__c custsetting5 = new BnPButtonValidationFieldMapping__c();
            custsetting5.Name = '1005';
            custsetting5.Deliverable_Type_Name__c = 'All';
            custsetting5.Field_Api__c = 'Project_Name__c';
            custsetting5.Field_Label__c = 'Device :Project Name';
            custsetting5.isRecordPresent__c = false;
            custsetting5.Object_Name__c = 'Device';
            custsetting5.Product_Line__c = 'All';
            custsetting5.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting5);
            
            BnPButtonValidationFieldMapping__c custsetting6 = new BnPButtonValidationFieldMapping__c();
            custsetting6.Name = '1006';
            custsetting6.Deliverable_Type_Name__c = 'All';
            custsetting6.Field_Api__c = 'Device_Purpose__c';
            custsetting6.Field_Label__c = 'Device :Device Purpose';
            custsetting6.isRecordPresent__c = false;
            custsetting6.Object_Name__c = 'Device';
            custsetting6.Product_Line__c = 'ASIC';
            custsetting6.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting6);*/
            
            BnPButtonValidationFieldMapping__c custsetting7 = new BnPButtonValidationFieldMapping__c();
            custsetting7.Name = '1007';
            custsetting7.Deliverable_Type_Name__c = 'All';
            custsetting7.Field_Api__c = 'Package_Conductor_Layers__c';
            custsetting7.Field_Label__c = 'Design:Package Conductor Layers';
            custsetting7.isRecordPresent__c = false;
            custsetting7.Object_Name__c = 'Design';
            custsetting7.Product_Line__c = 'All';
            custsetting7.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting7);
            
            BnPButtonValidationFieldMapping__c custsetting8 = new BnPButtonValidationFieldMapping__c();
            custsetting8.Name = '1008';
            custsetting8.Deliverable_Type_Name__c = 'All';
            custsetting8.Field_Api__c = 'Total_Levels_of_Metal__c';
            custsetting8.Field_Label__c = 'Design:Total Levels of Metal';
            custsetting8.isRecordPresent__c = true;
            custsetting8.Object_Name__c = 'Design';
            custsetting8.Product_Line__c = 'All';
            custsetting8.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting8);
            
            BnPButtonValidationFieldMapping__c custsetting9 = new BnPButtonValidationFieldMapping__c();
            custsetting9.Name = '1009';
            custsetting9.Deliverable_Type_Name__c = 'All';
            custsetting9.Field_Api__c = 'Package_style__c';
            custsetting9.Field_Label__c = 'Design:Package style';
            custsetting9.isRecordPresent__c = false;
            custsetting9.Object_Name__c = 'Design';
            custsetting9.Product_Line__c = 'ASIC';
            custsetting9.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting9);
            
            BnPButtonValidationFieldMapping__c custsetting10 = new BnPButtonValidationFieldMapping__c();
            custsetting10.Name = '1010';
            custsetting10.Deliverable_Type_Name__c = 'All';
            custsetting10.Field_Api__c = 'Package_total_lead_count__c';
            custsetting10.Field_Label__c = 'Design:Package total lead count';
            custsetting10.isRecordPresent__c = true;
            custsetting10.Object_Name__c = 'Design';
            custsetting10.Product_Line__c = 'ASIC';
            custsetting10.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting10);
            
            BnPButtonValidationFieldMapping__c custsetting11 = new BnPButtonValidationFieldMapping__c();
            custsetting11.Name = '1011';
            custsetting11.Deliverable_Type_Name__c = 'All';
            custsetting11.Field_Api__c = 'Active_side_interconnect_technology__c';
            custsetting11.Field_Label__c = 'Wafer:Active side interconnect technology';
            custsetting11.isRecordPresent__c = false;
            custsetting11.Object_Name__c = 'Wafer';
            custsetting11.Product_Line__c = 'All';
            custsetting11.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting11);
            
            BnPButtonValidationFieldMapping__c custsetting12 = new BnPButtonValidationFieldMapping__c();
            custsetting12.Name = '1012';
            custsetting12.Deliverable_Type_Name__c = 'All';
            custsetting12.Field_Api__c = 'Active_side_C4_mask_layer__c';
            custsetting12.Field_Label__c = 'Wafer:Active side C4 mask layer';
            custsetting12.isRecordPresent__c = true;
            custsetting12.Object_Name__c = 'Wafer';
            custsetting12.Product_Line__c = 'All';
            custsetting12.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting12);
            
            BnPButtonValidationFieldMapping__c custsetting13 = new BnPButtonValidationFieldMapping__c();
            custsetting13.Name = '1013';
            custsetting13.Deliverable_Type_Name__c = 'All';
            custsetting13.Field_Api__c = 'Active_side_redistribution_layer__c';
            custsetting13.Field_Label__c = 'Wafer:Active side redistribution layer';
            custsetting13.isRecordPresent__c = false;
            custsetting13.Object_Name__c = 'Wafer';
            custsetting13.Product_Line__c = 'ASIC';
            custsetting13.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting13);
            
            BnPButtonValidationFieldMapping__c custsetting14 = new BnPButtonValidationFieldMapping__c();
            custsetting14.Name = '1014';
            custsetting14.Deliverable_Type_Name__c = 'All';
            custsetting14.Field_Api__c = 'Back_side_grind__c';
            custsetting14.Field_Label__c = 'Wafer:Back side grind';
            custsetting14.isRecordPresent__c = true;
            custsetting14.Object_Name__c = 'Wafer';
            custsetting14.Product_Line__c = 'ASIC';
            custsetting14.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting14);
            
            BnPButtonValidationFieldMapping__c custsetting15 = new BnPButtonValidationFieldMapping__c();
            custsetting15.Name = '1015';
            custsetting15.Deliverable_Type_Name__c = 'All';
            custsetting15.Field_Api__c = 'Chip_interconnect_technology__c';
            custsetting15.Field_Label__c = 'Chip:Chip interconnect technology';
            custsetting15.isRecordPresent__c = false;
            custsetting15.Object_Name__c = 'Chip';
            custsetting15.Product_Line__c = 'All';
            custsetting15.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting15);
            
            BnPButtonValidationFieldMapping__c custsetting16 = new BnPButtonValidationFieldMapping__c();
            custsetting16.Name = '1016';
            custsetting16.Deliverable_Type_Name__c = 'All';
            custsetting16.Field_Api__c = 'Additional_chip_details__c';
            custsetting16.Field_Label__c = 'Chip:Additional chip details';
            custsetting16.isRecordPresent__c = true;
            custsetting16.Object_Name__c = 'Chip';
            custsetting16.Product_Line__c = 'All';
            custsetting16.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting16);
            
            BnPButtonValidationFieldMapping__c custsetting17 = new BnPButtonValidationFieldMapping__c();
            custsetting17.Name = '1017';
            custsetting17.Deliverable_Type_Name__c = 'All';
            custsetting17.Field_Api__c = 'Chip_Tj_maximum_C__c';
            custsetting17.Field_Label__c = 'Chip:Chip Tj (maximum) ( C )';
            custsetting17.isRecordPresent__c = false;
            custsetting17.Object_Name__c = 'Chip';
            custsetting17.Product_Line__c = 'ASIC';
            custsetting17.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting17);
            
            BnPButtonValidationFieldMapping__c custsetting18 = new BnPButtonValidationFieldMapping__c();
            custsetting18.Name = '1018';
            custsetting18.Deliverable_Type_Name__c = 'All';
            custsetting18.Field_Api__c = 'Chip_Tj_minimum_C__c';
            custsetting18.Field_Label__c = 'Chip:Chip Tj (minimum) ( C )';
            custsetting18.isRecordPresent__c = true;
            custsetting18.Object_Name__c = 'Chip';
            custsetting18.Product_Line__c = 'ASIC';
            custsetting18.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting18);
            
            BnPButtonValidationFieldMapping__c custsetting19 = new BnPButtonValidationFieldMapping__c();
            custsetting19.Name = '1019';
            custsetting19.Deliverable_Type_Name__c = 'All';
            custsetting19.Field_Api__c = 'Chip_carrier_type__c';
            custsetting19.Field_Label__c = 'Package:Chip carrier type';
            custsetting19.isRecordPresent__c = false;
            custsetting19.Object_Name__c = 'Package';
            custsetting19.Product_Line__c = 'All';
            custsetting19.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting19);
            
            BnPButtonValidationFieldMapping__c custsetting20 = new BnPButtonValidationFieldMapping__c();
            custsetting20.Name = '1020';
            custsetting20.Deliverable_Type_Name__c = 'All';
            custsetting20.Field_Api__c = 'Additional_description_for_other_package__c';
            custsetting20.Field_Label__c = 'Package:Additional description for other package';
            custsetting20.isRecordPresent__c = true;
            custsetting20.Object_Name__c = 'Package';
            custsetting20.Product_Line__c = 'All';
            custsetting20.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting20);
            
            BnPButtonValidationFieldMapping__c custsetting21 = new BnPButtonValidationFieldMapping__c();
            custsetting21.Name = '1021';
            custsetting21.Deliverable_Type_Name__c = 'All';
            custsetting21.Field_Api__c = 'Package_type__c';
            custsetting21.Field_Label__c = 'Package:Package type';
            custsetting21.isRecordPresent__c = false;
            custsetting21.Object_Name__c = 'Package';
            custsetting21.Product_Line__c = 'ASIC';
            custsetting21.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting21);
            
            BnPButtonValidationFieldMapping__c custsetting22 = new BnPButtonValidationFieldMapping__c();
            custsetting22.Name = '1022';
            custsetting22.Deliverable_Type_Name__c = 'All';
            custsetting22.Field_Api__c = 'Particle_emission_rate__c';
            custsetting22.Field_Label__c = 'Package:Particle emission rate';
            custsetting22.isRecordPresent__c = true;
            custsetting22.Object_Name__c = 'Package';
            custsetting22.Product_Line__c = 'ASIC';
            custsetting22.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting22);
            
            BnPButtonValidationFieldMapping__c custsetting23 = new BnPButtonValidationFieldMapping__c();
            custsetting23.Name = '1023';
            custsetting23.Deliverable_Type_Name__c = 'All';
            custsetting23.Field_Api__c = 'Module_Burn_In__c';
            custsetting23.Field_Label__c = 'Module:Module Burn-In';
            custsetting23.isRecordPresent__c = false;
            custsetting23.Object_Name__c = 'Module';
            custsetting23.Product_Line__c = 'All';
            custsetting23.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting23);
            
            BnPButtonValidationFieldMapping__c custsetting24 = new BnPButtonValidationFieldMapping__c();
            custsetting24.Name = '1024';
            custsetting24.Deliverable_Type_Name__c = 'All';
            custsetting24.Field_Api__c = 'Scan_bake_and_tape__c';
            custsetting24.Field_Label__c = 'Module:Scan, bake and tape';
            custsetting24.isRecordPresent__c = true;
            custsetting24.Object_Name__c = 'Module';
            custsetting24.Product_Line__c = 'All';
            custsetting24.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting24);
            
            BnPButtonValidationFieldMapping__c custsetting25 = new BnPButtonValidationFieldMapping__c();
            custsetting25.Name = '1025';
            custsetting25.Deliverable_Type_Name__c = 'All';
            custsetting25.Field_Api__c = 'Cap_lid_PN__c';
            custsetting25.Field_Label__c = 'Module:Cap/lid PN';
            custsetting25.isRecordPresent__c = false;
            custsetting25.Object_Name__c = 'Module';
            custsetting25.Product_Line__c = 'ASIC';
            custsetting25.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting25);
            
            BnPButtonValidationFieldMapping__c custsetting26 = new BnPButtonValidationFieldMapping__c();
            custsetting26.Name = '1026';
            custsetting26.Deliverable_Type_Name__c = 'All';
            custsetting26.Field_Api__c = 'Number_of_decoupling_capacitor_sites__c';
            custsetting26.Field_Label__c = 'Module:Number of decoupling capacitor sites';
            custsetting26.isRecordPresent__c = true;
            custsetting26.Object_Name__c = 'Module';
            custsetting26.Product_Line__c = 'ASIC';
            custsetting26.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting26);
            
            BnPButtonValidationFieldMapping__c custsetting27 = new BnPButtonValidationFieldMapping__c();
            custsetting27.Name = '1027';
            custsetting27.Deliverable_Type_Name__c = 'All';
            custsetting27.Field_Api__c = 'Description__c';
            custsetting27.Field_Label__c = 'Service:Description';
            custsetting27.isRecordPresent__c = false;
            custsetting27.Object_Name__c = 'Service';
            custsetting27.Product_Line__c = 'All';
            custsetting27.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting27);
            
            BnPButtonValidationFieldMapping__c custsetting28 = new BnPButtonValidationFieldMapping__c();
            custsetting28.Name = '1028';
            custsetting28.Deliverable_Type_Name__c = 'All';
            custsetting28.Field_Api__c = 'Description__c';
            custsetting28.Field_Label__c = 'Service:Description';
            custsetting28.isRecordPresent__c = true;
            custsetting28.Object_Name__c = 'Service';
            custsetting28.Product_Line__c = 'All';
            custsetting28.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting28);
            
            BnPButtonValidationFieldMapping__c custsetting29 = new BnPButtonValidationFieldMapping__c();
            custsetting29.Name = '1029';
            custsetting29.Deliverable_Type_Name__c = 'All';
            custsetting29.Field_Api__c = 'Description__c';
            custsetting29.Field_Label__c = 'Service:Description';
            custsetting29.isRecordPresent__c = false;
            custsetting29.Object_Name__c = 'Service';
            custsetting29.Product_Line__c = 'ASIC';
            custsetting29.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting29);
            
            BnPButtonValidationFieldMapping__c custsetting30 = new BnPButtonValidationFieldMapping__c();
            custsetting30.Name = '1030';
            custsetting30.Deliverable_Type_Name__c = 'All';
            custsetting30.Field_Api__c = 'Description__c';
            custsetting30.Field_Label__c = 'Service:Description';
            custsetting30.isRecordPresent__c = true;
            custsetting30.Object_Name__c = 'Service';
            custsetting30.Product_Line__c = 'ASIC';
            custsetting30.Validation_Type__c = 'TryforFit';
            custsettingList.add(custsetting30);
            insert custsettingList;
            
            test.startTest();
            System.currentPageReference().getParameters().put('trId', cr.id);
            System.currentPageReference().getParameters().put('buttonType', 'TryforFit');
            BnPButtonValidationCtrl bnpButValCtrl = new BnPButtonValidationCtrl();
            PageReference  myVf = bnpButValCtrl.checkButtonValidation();
            system.AssertEquals(null, myVf);
            bnpButValCtrl.rfiPageRedirection();
            bnpButValCtrl.cancel();
            bnpButValCtrl.ok();
            test.stopTest();
            
        }
    }
    Static testMethod void BNPButValNewReqInfo() 
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            fieldValueOppMap.put('Product_Line__c', 'ASIC');
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            fieldValueOptionMap.put('Deliverable_Type__c','Module');
            Customer_Requirement__c  cr = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueserviceMap = new Map<String,Object>();
            fieldValueserviceMap.put('Technical_Requirement__c',cr.id);
            Service__c   service = BNP_DataFactory.createService(fieldValueserviceMap); 
             
            Map<String,Object> fieldValuewaferMap = new Map<String,Object>();
            fieldValuewaferMap.put('Technical_Requirement__c',cr.Id);
            Wafer_Data__c WaferData  = BNP_DataFactory.createWaferData(fieldValuewaferMap);
        
            Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',cr.Id);
            fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
            
            Map<String,Object> fieldValueModuleMap = new Map<String,Object>();
            fieldValueModuleMap.put('Technical_Requirement__c',cr.Id);
            fieldValueModuleMap.put('Chip_1__c',ChipData.Id);
            Module_Data__c ModuleData  = BNP_DataFactory.createModuleData(fieldValueModuleMap);
            
            Map<String,Object> fieldValuePackageDataMap = new Map<String,Object>();
            fieldValuePackageDataMap.put('Technical_Requirement__c',cr.Id);
            fieldValuePackageDataMap.put('Module_Data__c',ModuleData.Id); 
            Package_Data__c  PackageData  = BNP_DataFactory.createPackageData(fieldValuePackageDataMap);
            
            Map<String,Object> fieldValueDesignMap = new Map<String,Object>();
            fieldValueDesignMap.put('Customer_Requirement__c',cr.Id);
            Design__c Designdata = BNP_DataFactory.createDesign(fieldValueDesignMap);
            
            List<BnPButtonValidationFieldMapping__c> custsettingList = new List<BnPButtonValidationFieldMapping__c>();
            BnPButtonValidationFieldMapping__c custsetting1 = new BnPButtonValidationFieldMapping__c();
            custsetting1.Name = '1001';
            custsetting1.Deliverable_Type_Name__c = 'Module';
            custsetting1.Field_Api__c = 'Design_Win_Region__c';
            custsetting1.Field_Label__c = 'Opportunity :Design Win Region';
            custsetting1.isRecordPresent__c = false;
            custsetting1.Object_Name__c = 'Opportunity';
            custsetting1.Product_Line__c = 'All';
            custsetting1.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting1);
            
            BnPButtonValidationFieldMapping__c custsetting2 = new BnPButtonValidationFieldMapping__c();
            custsetting2.Name = '1002';
            custsetting2.Deliverable_Type_Name__c = 'Module';
            custsetting2.Field_Api__c = 'Design_Win_Territory__c';
            custsetting2.Field_Label__c = 'Opportunity : Design Win Territory';
            custsetting2.isRecordPresent__c = false;
            custsetting2.Object_Name__c = 'Opportunity';
            custsetting2.Product_Line__c = 'ASIC';
            custsetting2.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting2);
            
            BnPButtonValidationFieldMapping__c custsetting3 = new BnPButtonValidationFieldMapping__c();
            custsetting3.Name = '1003';
            custsetting3.Deliverable_Type_Name__c = 'Module';
            custsetting3.Field_Api__c = 'MD_part_name__c';
            custsetting3.Field_Label__c = 'Option :GF Part Name';
            custsetting3.isRecordPresent__c = false;
            custsetting3.Object_Name__c = 'Option';
            custsetting3.Product_Line__c = 'All';
            custsetting3.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting3);
            
            BnPButtonValidationFieldMapping__c custsetting4 = new BnPButtonValidationFieldMapping__c();
            custsetting4.Name = '1004';
            custsetting4.Deliverable_Type_Name__c = 'Module';
            custsetting4.Field_Api__c = 'End_customer_project__c';
            custsetting4.Field_Label__c = 'Option :End customer project';
            custsetting4.isRecordPresent__c = false;
            custsetting4.Object_Name__c = 'Option';
            custsetting4.Product_Line__c = 'ASIC';
            custsetting4.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting4);
            
            /*BnPButtonValidationFieldMapping__c custsetting5 = new BnPButtonValidationFieldMapping__c();
            custsetting5.Name = '1005';
            custsetting5.Deliverable_Type_Name__c = 'Module';
            custsetting5.Field_Api__c = 'Project_Name__c';
            custsetting5.Field_Label__c = 'Device :Project Name';
            custsetting5.isRecordPresent__c = false;
            custsetting5.Object_Name__c = 'Device';
            custsetting5.Product_Line__c = 'All';
            custsetting5.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting5);
            
            BnPButtonValidationFieldMapping__c custsetting6 = new BnPButtonValidationFieldMapping__c();
            custsetting6.Name = '1006';
            custsetting6.Deliverable_Type_Name__c = 'Module';
            custsetting6.Field_Api__c = 'Device_Purpose__c';
            custsetting6.Field_Label__c = 'Device :Device Purpose';
            custsetting6.isRecordPresent__c = false;
            custsetting6.Object_Name__c = 'Device';
            custsetting6.Product_Line__c = 'ASIC';
            custsetting6.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting6);*/
            
            BnPButtonValidationFieldMapping__c custsetting7 = new BnPButtonValidationFieldMapping__c();
            custsetting7.Name = '1007';
            custsetting7.Deliverable_Type_Name__c = 'Module';
            custsetting7.Field_Api__c = 'Package_Conductor_Layers__c';
            custsetting7.Field_Label__c = 'Design:Package Conductor Layers';
            custsetting7.isRecordPresent__c = false;
            custsetting7.Object_Name__c = 'Design';
            custsetting7.Product_Line__c = 'All';
            custsetting7.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting7);
            
            BnPButtonValidationFieldMapping__c custsetting8 = new BnPButtonValidationFieldMapping__c();
            custsetting8.Name = '1008';
            custsetting8.Deliverable_Type_Name__c = 'Module';
            custsetting8.Field_Api__c = 'Total_Levels_of_Metal__c';
            custsetting8.Field_Label__c = 'Design:Total Levels of Metal';
            custsetting8.isRecordPresent__c = true;
            custsetting8.Object_Name__c = 'Design';
            custsetting8.Product_Line__c = 'All';
            custsetting8.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting8);
            
            BnPButtonValidationFieldMapping__c custsetting9 = new BnPButtonValidationFieldMapping__c();
            custsetting9.Name = '1009';
            custsetting9.Deliverable_Type_Name__c = 'Module';
            custsetting9.Field_Api__c = 'Package_style__c';
            custsetting9.Field_Label__c = 'Design:Package style';
            custsetting9.isRecordPresent__c = false;
            custsetting9.Object_Name__c = 'Design';
            custsetting9.Product_Line__c = 'ASIC';
            custsetting9.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting9);
            
            BnPButtonValidationFieldMapping__c custsetting10 = new BnPButtonValidationFieldMapping__c();
            custsetting10.Name = '1010';
            custsetting10.Deliverable_Type_Name__c = 'Module';
            custsetting10.Field_Api__c = 'Package_total_lead_count__c';
            custsetting10.Field_Label__c = 'Design:Package total lead count';
            custsetting10.isRecordPresent__c = true;
            custsetting10.Object_Name__c = 'Design';
            custsetting10.Product_Line__c = 'ASIC';
            custsetting10.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting10);
            
            BnPButtonValidationFieldMapping__c custsetting11 = new BnPButtonValidationFieldMapping__c();
            custsetting11.Name = '1011';
            custsetting11.Deliverable_Type_Name__c = 'Module';
            custsetting11.Field_Api__c = 'Active_side_interconnect_technology__c';
            custsetting11.Field_Label__c = 'Wafer:Active side interconnect technology';
            custsetting11.isRecordPresent__c = false;
            custsetting11.Object_Name__c = 'Wafer';
            custsetting11.Product_Line__c = 'All';
            custsetting11.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting11);
            
            BnPButtonValidationFieldMapping__c custsetting12 = new BnPButtonValidationFieldMapping__c();
            custsetting12.Name = '1012';
            custsetting12.Deliverable_Type_Name__c = 'Module';
            custsetting12.Field_Api__c = 'Active_side_C4_mask_layer__c';
            custsetting12.Field_Label__c = 'Wafer:Active side C4 mask layer';
            custsetting12.isRecordPresent__c = true;
            custsetting12.Object_Name__c = 'Wafer';
            custsetting12.Product_Line__c = 'All';
            custsetting12.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting12);
            
            BnPButtonValidationFieldMapping__c custsetting13 = new BnPButtonValidationFieldMapping__c();
            custsetting13.Name = '1013';
            custsetting13.Deliverable_Type_Name__c = 'Module';
            custsetting13.Field_Api__c = 'Active_side_redistribution_layer__c';
            custsetting13.Field_Label__c = 'Wafer:Active side redistribution layer';
            custsetting13.isRecordPresent__c = false;
            custsetting13.Object_Name__c = 'Wafer';
            custsetting13.Product_Line__c = 'ASIC';
            custsetting13.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting13);
            
            BnPButtonValidationFieldMapping__c custsetting14 = new BnPButtonValidationFieldMapping__c();
            custsetting14.Name = '1014';
            custsetting14.Deliverable_Type_Name__c = 'Module';
            custsetting14.Field_Api__c = 'Back_side_grind__c';
            custsetting14.Field_Label__c = 'Wafer:Back side grind';
            custsetting14.isRecordPresent__c = true;
            custsetting14.Object_Name__c = 'Wafer';
            custsetting14.Product_Line__c = 'ASIC';
            custsetting14.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting14);
            
            BnPButtonValidationFieldMapping__c custsetting15 = new BnPButtonValidationFieldMapping__c();
            custsetting15.Name = '1015';
            custsetting15.Deliverable_Type_Name__c = 'Module';
            custsetting15.Field_Api__c = 'Chip_interconnect_technology__c';
            custsetting15.Field_Label__c = 'Chip:Chip interconnect technology';
            custsetting15.isRecordPresent__c = false;
            custsetting15.Object_Name__c = 'Chip';
            custsetting15.Product_Line__c = 'All';
            custsetting15.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting15);
            
            BnPButtonValidationFieldMapping__c custsetting16 = new BnPButtonValidationFieldMapping__c();
            custsetting16.Name = '1016';
            custsetting16.Deliverable_Type_Name__c = 'Module';
            custsetting16.Field_Api__c = 'Additional_chip_details__c';
            custsetting16.Field_Label__c = 'Chip:Additional chip details';
            custsetting16.isRecordPresent__c = true;
            custsetting16.Object_Name__c = 'Chip';
            custsetting16.Product_Line__c = 'All';
            custsetting16.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting16);
            
            BnPButtonValidationFieldMapping__c custsetting17 = new BnPButtonValidationFieldMapping__c();
            custsetting17.Name = '1017';
            custsetting17.Deliverable_Type_Name__c = 'Module';
            custsetting17.Field_Api__c = 'Chip_Tj_maximum_C__c';
            custsetting17.Field_Label__c = 'Chip:Chip Tj (maximum) ( C )';
            custsetting17.isRecordPresent__c = false;
            custsetting17.Object_Name__c = 'Chip';
            custsetting17.Product_Line__c = 'ASIC';
            custsetting17.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting17);
            
            BnPButtonValidationFieldMapping__c custsetting18 = new BnPButtonValidationFieldMapping__c();
            custsetting18.Name = '1018';
            custsetting18.Deliverable_Type_Name__c = 'Module';
            custsetting18.Field_Api__c = 'Chip_Tj_minimum_C__c';
            custsetting18.Field_Label__c = 'Chip:Chip Tj (minimum) ( C )';
            custsetting18.isRecordPresent__c = true;
            custsetting18.Object_Name__c = 'Chip';
            custsetting18.Product_Line__c = 'ASIC';
            custsetting18.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting18);
            
            BnPButtonValidationFieldMapping__c custsetting19 = new BnPButtonValidationFieldMapping__c();
            custsetting19.Name = '1019';
            custsetting19.Deliverable_Type_Name__c = 'Module';
            custsetting19.Field_Api__c = 'Chip_carrier_type__c';
            custsetting19.Field_Label__c = 'Package:Chip carrier type';
            custsetting19.isRecordPresent__c = false;
            custsetting19.Object_Name__c = 'Package';
            custsetting19.Product_Line__c = 'All';
            custsetting19.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting19);
            
            BnPButtonValidationFieldMapping__c custsetting20 = new BnPButtonValidationFieldMapping__c();
            custsetting20.Name = '1020';
            custsetting20.Deliverable_Type_Name__c = 'Module';
            custsetting20.Field_Api__c = 'Additional_description_for_other_package__c';
            custsetting20.Field_Label__c = 'Package:Additional description for other package';
            custsetting20.isRecordPresent__c = true;
            custsetting20.Object_Name__c = 'Package';
            custsetting20.Product_Line__c = 'All';
            custsetting20.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting20);
            
            BnPButtonValidationFieldMapping__c custsetting21 = new BnPButtonValidationFieldMapping__c();
            custsetting21.Name = '1021';
            custsetting21.Deliverable_Type_Name__c = 'Module';
            custsetting21.Field_Api__c = 'Package_type__c';
            custsetting21.Field_Label__c = 'Package:Package type';
            custsetting21.isRecordPresent__c = false;
            custsetting21.Object_Name__c = 'Package';
            custsetting21.Product_Line__c = 'ASIC';
            custsetting21.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting21);
            
            BnPButtonValidationFieldMapping__c custsetting22 = new BnPButtonValidationFieldMapping__c();
            custsetting22.Name = '1022';
            custsetting22.Deliverable_Type_Name__c = 'Module';
            custsetting22.Field_Api__c = 'Particle_emission_rate__c';
            custsetting22.Field_Label__c = 'Package:Particle emission rate';
            custsetting22.isRecordPresent__c = true;
            custsetting22.Object_Name__c = 'Package';
            custsetting22.Product_Line__c = 'ASIC';
            custsetting22.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting22);
            
            BnPButtonValidationFieldMapping__c custsetting23 = new BnPButtonValidationFieldMapping__c();
            custsetting23.Name = '1023';
            custsetting23.Deliverable_Type_Name__c = 'Module';
            custsetting23.Field_Api__c = 'Module_Burn_In__c';
            custsetting23.Field_Label__c = 'Module:Module Burn-In';
            custsetting23.isRecordPresent__c = false;
            custsetting23.Object_Name__c = 'Module';
            custsetting23.Product_Line__c = 'All';
            custsetting23.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting23);
            
            BnPButtonValidationFieldMapping__c custsetting24 = new BnPButtonValidationFieldMapping__c();
            custsetting24.Name = '1024';
            custsetting24.Deliverable_Type_Name__c = 'Module';
            custsetting24.Field_Api__c = 'Scan_bake_and_tape__c';
            custsetting24.Field_Label__c = 'Module:Scan, bake and tape';
            custsetting24.isRecordPresent__c = true;
            custsetting24.Object_Name__c = 'Module';
            custsetting24.Product_Line__c = 'All';
            custsetting24.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting24);
            
            BnPButtonValidationFieldMapping__c custsetting25 = new BnPButtonValidationFieldMapping__c();
            custsetting25.Name = '1025';
            custsetting25.Deliverable_Type_Name__c = 'Module';
            custsetting25.Field_Api__c = 'Cap_lid_PN__c';
            custsetting25.Field_Label__c = 'Module:Cap/lid PN';
            custsetting25.isRecordPresent__c = false;
            custsetting25.Object_Name__c = 'Module';
            custsetting25.Product_Line__c = 'ASIC';
            custsetting25.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting25);
            
            BnPButtonValidationFieldMapping__c custsetting26 = new BnPButtonValidationFieldMapping__c();
            custsetting26.Name = '1026';
            custsetting26.Deliverable_Type_Name__c = 'Module';
            custsetting26.Field_Api__c = 'Number_of_decoupling_capacitor_sites__c';
            custsetting26.Field_Label__c = 'Module:Number of decoupling capacitor sites';
            custsetting26.isRecordPresent__c = true;
            custsetting26.Object_Name__c = 'Module';
            custsetting26.Product_Line__c = 'ASIC';
            custsetting26.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting26);
            
            BnPButtonValidationFieldMapping__c custsetting27 = new BnPButtonValidationFieldMapping__c();
            custsetting27.Name = '1027';
            custsetting27.Deliverable_Type_Name__c = 'Module';
            custsetting27.Field_Api__c = 'Description__c';
            custsetting27.Field_Label__c = 'Service:Description';
            custsetting27.isRecordPresent__c = false;
            custsetting27.Object_Name__c = 'Service';
            custsetting27.Product_Line__c = 'All';
            custsetting27.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting27);
            
            BnPButtonValidationFieldMapping__c custsetting28 = new BnPButtonValidationFieldMapping__c();
            custsetting28.Name = '1028';
            custsetting28.Deliverable_Type_Name__c = 'Module';
            custsetting28.Field_Api__c = 'Description__c';
            custsetting28.Field_Label__c = 'Service:Description';
            custsetting28.isRecordPresent__c = true;
            custsetting28.Object_Name__c = 'Service';
            custsetting28.Product_Line__c = 'All';
            custsetting28.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting28);
            
            BnPButtonValidationFieldMapping__c custsetting29 = new BnPButtonValidationFieldMapping__c();
            custsetting29.Name = '1029';
            custsetting29.Deliverable_Type_Name__c = 'Module';
            custsetting29.Field_Api__c = 'Description__c';
            custsetting29.Field_Label__c = 'Service:Description';
            custsetting29.isRecordPresent__c = false;
            custsetting29.Object_Name__c = 'Service';
            custsetting29.Product_Line__c = 'ASIC';
            custsetting29.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting29);
            
            BnPButtonValidationFieldMapping__c custsetting30 = new BnPButtonValidationFieldMapping__c();
            custsetting30.Name = '1030';
            custsetting30.Deliverable_Type_Name__c = 'Module';
            custsetting30.Field_Api__c = 'Description__c';
            custsetting30.Field_Label__c = 'Service:Description';
            custsetting30.isRecordPresent__c = true;
            custsetting30.Object_Name__c = 'Service';
            custsetting30.Product_Line__c = 'ASIC';
            custsetting30.Validation_Type__c = 'BidnQuote';
            custsettingList.add(custsetting30);
            insert custsettingList;
            
            test.startTest();
            System.currentPageReference().getParameters().put('trId', cr.id);
            System.currentPageReference().getParameters().put('buttonType', 'BidnQuote');
            BnPButtonValidationCtrl bnpButValCtrl = new BnPButtonValidationCtrl();
            PageReference  myVf = bnpButValCtrl.checkButtonValidation();
            system.AssertNotEquals(null, myVf);
            bnpButValCtrl.rfiPageRedirection();
            bnpButValCtrl.cancel();
            bnpButValCtrl.ok();
            test.stopTest();
            
        }
    }
}