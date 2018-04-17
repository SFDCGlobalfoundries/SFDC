/*
@class: FMSSubscribeSearchCtrlTest
@CreatedBy: Inshu Misra
@CreatedDate: 4 Oct, 2016
@Description: to test subscribe search controller...#IM
@Modifications-
    //27-07-2017    Anirban Roy    Added apostrophe in Account Name, Product Name and Product Revision
*
*/
@isTest
public class FMSSubscribeSearchCtrlTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  
        Id accId = createAccount();
        Form_Management_System__c fms = createFMSForm(accId);
    }
    
    static Id createAccount() { 
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        //27-07-2017    Anirban Roy    Modified for Account Name : added apostrophe in Account Name
        Map<String,Object> accFieldMap = new Map<String,Object>{'Name' => 'GLOBAL FOUNDRIES\'S','Site_Department__c' => 'Test Site 1', 'Sub_Type__c' => 'Direct', 'Transaction_Type__c' => 'Transactional',
            'Region__c' => 'APJ', 'Corporate_Address_1__c' => 'Test Bill To Address 1', 'Corporate_City__c' => 'Singapore', 'Corporate_Country__c' => 'Singapore'  };       
                accFieldMap.put('Fab_9_10__c','Yes');
        accFieldMap.put('Customer_Category__c','TFA');
        accFieldMap.put('Tech_Geo_Granted__c','0.007UM'+';'+'0.010UM');
        accFieldMap.put('SAP_Account_Number__c', '006104');
        Account acc = AccountDataFactory.createAccount(accFieldMap);
        return acc.Id;
    }
    
    static Form_Management_System__c getFMSForm(){
        return [select Id, State_of_the_Form__c, Form_Description__c, Customer_Name__c from Form_Management_System__c limit 1];
    }
    
    static Form_Management_System__c createFMSForm(String accId){
        Id mainFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        Map<String,Object> fieldValueMFormMap = new Map<String,Object>();
        fieldValueMFormMap.put('Customer_Name__c',accId); 
        fieldValueMFormMap.put('recordTypeID',mainFormRecordTypeId); 
        fieldValueMFormMap.put('Form_Name__c','some name');
        fieldValueMFormMap.put('State_of_the_Form__c','Modified');
        fieldValueMFormMap.put('Form_Description__c','modified description');
        FMSEmailTemplates.SendEditEmail = true;
        Form_Management_System__c fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
        return fmsMainRec;
    }
    
    static testmethod void testMethod1(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
            //27-07-2017 Anirban Roy  Added apostrophe in Product Name and Product Revision
            filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = fms.Customer_Name__c,
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)', Form_State__c = 'Draft', Last_Modified_From__c = System.today()-2, Last_Modified_To__c = System.today(), Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product\'s', Product_Revision__c = 'rev\'1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'type 1', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value'));
            Database.insert(filtList,false);        
            
            FMS_Subscription__c subs = new FMS_Subscription__c();
            subs.Saved_Search_Id__c = filtList[0].Id;
            subs.Form_Deleted__c = true;
            subs.Form_Inserted__c = true;
            subs.Form_Status_Change__c = true;
            subs.Form_Updated__c = true;
            Database.insert(subs,false);
            
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','editsub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));
        }
    }

    static testmethod void testMethod2(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             
            filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = fms.Customer_Name__c,
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'All;', Product_Revision__c = 'All;', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'type 1', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value'));
            Database.insert(filtList,false);        
            
            FMS_Subscription__c subs = new FMS_Subscription__c();
            subs.Saved_Search_Id__c = filtList[0].Id;
            
            Database.insert(subs,false);
            
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','editsub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));
        }
    }
    
    static testmethod void testMethod3(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
            //27-07-2017 Anirban Roy  Added 'All;' in Product Name and Product Revision
            filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', ModifiedDateOptions__c='alldates', Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
  PO_Submission__c = 'submission', Product_Name__c = 'All;', Product_Revision__c = 'All;', Release_Process__c = 'process 1', 
  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod4(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod5(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(CreationDateOptions__c = '1day', ModifiedDateOptions__c = '1day',Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod6(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(CreationDateOptions__c = '1week', ModifiedDateOptions__c = '1week',Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod7(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(CreationDateOptions__c = '2weeks', ModifiedDateOptions__c = '2weeks',Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod8(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(CreationDateOptions__c = '1month', ModifiedDateOptions__c = '1month',Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod9(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(CreationDateOptions__c = '6months', ModifiedDateOptions__c = '6months',Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
    
    static testmethod void testMethod10(){
        System.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fms = getFMSForm();
            List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
             filtList.add(new FMS_Search_Filter__c(CreationDateOptions__c = '1year', ModifiedDateOptions__c = '1year',Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = 'All',
                                                  Design_Submission_Type__c = 'Single Chip (one GDS)'+';'+'Multi-Chiplet Design'+';'+'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                                                  PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                                                  Step_Plan_Input_Method__c = 'Std Process: via FMS questions'+';'+'Std Process: via FMS Ques & attachment'+';'+'Adv Process: via XML file attachment', Submission_Type__c = 'Final Submission'+';'+'Prelim - Checking Only'+';'+'Prelim - Checking and Design Services'+';'+'Prelim - Design Services only'+';'+'Prelim - Features Extraction Report', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                                                  Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'All Test Form', Tapeout_Date_Projection__c = System.Today()));
            Database.insert(filtList,false);        
            PageReference pageRef = Page.FMSSubscribeSearch;            
            Test.setCurrentPage(pageRef);
            System.currentPageReference().getParameters().put('Id',filtList[0].Id);
            System.currentPageReference().getParameters().put('tnx','sub');
            FMSSubscribeSearchCtrl ctrl = new FMSSubscribeSearchCtrl();
            PageReference pr = ctrl.submit();
            system.assert(pr.getUrl().contains('/apex/FormManagementMainPage'));   
        }
    }
}