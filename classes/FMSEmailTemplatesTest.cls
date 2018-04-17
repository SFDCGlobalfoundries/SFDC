/*
     @class: FMSEmailTemplatesTest
     @CreatedBy: Inshu Misra
     @CreatedDate: 13 Sep, 2016
     @Description: to test the FMS Email Templates functionality...#IM
     @Modifications-
     *
     */

    @isTest
    public class FMSEmailTemplatesTest {
        

        @testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
        }

        public static Account createAccount1() {

            Account accountObj = new Account(name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill1', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', Corporate_Country__c = 'Austria', Fab_9_10__c = 'Yes',
             SAP_Account_Number__c = '006104', Tech_Geo_Granted__c = '0.007UM',Sold_to_VAT_Registration_Number__c=123.1); 
            insert accountObj;

            return accountObj;
        }

        public static Id mainFromCreate(Id accId, Id devId){

            Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
            fmsMainForm.Form_Name__c = 'testMAinForm';
            fmsMainForm.Customer_Name__c = accId;
            fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
            fmsMainForm.Technology__c = 'BiCMOS 7WL (SiGe 7WL)';
            fmsMainForm.Device__C = devId;
            insert fmsMainForm;

            return fmsMainForm.id;
        }
        
        static Id createAccount() { 
            // Create Account
            RecordType rt = [
                SELECT      Id
                FROM        RecordType
                WHERE       SObjectType = 'Account'
                            AND Name = 'Customer'
            ];
            
            Account testAcct = new Account();
            testAcct.Name = 'Test Account1';
            testAcct.SAP_Account_Number__c = '001234';   //Changing SAP_Account_ID__c to SAP_Account_Number__c - 17-Nov-2016  -- Ashwin Dash
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
            testAcct.Short_Name__c = 'TestAcct1';
            testAcct.Fab_9_10__c = 'Yes';
            testAcct.Sold_to_VAT_Registration_Number__c=123.1;
            Insert testAcct;   
            return testAcct.Id;
        }

        public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
            Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
            dev.Confidence_Level_Tapeout__c = '100';
            dev.Expose_Device_to_Customer__c = false ; 
            dev.Fab__c = 'Fab 3';
            dev.Assigned_Process_ID__c = processId;
            dev.Enabled_via_previous_MPW_1__c='No';
            dev.CRMDID__c = '123456';
            dev.Name = 'TestDevice67';
            dev.Device_ID__c = 'testing222';
            dev.Device_Description__c = 'Test';
            dev.Device_Purpose__c = 'Test';
            dev.Account__c = accId;
            insert dev;
            return dev; 
        }
        
        static testmethod void FormEmailTemplatesTest(){ 
            
            Test.startTest();
            
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            Id accId = createAccount();
            Id mainFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
            List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
            fms.add(new Form_Management_System__c(Customer_Name__c = accId, recordTypeID = mainFormRecordTypeId, Form_Name__c = 'some name', State_of_the_Form__c = 'Draft'));
            
            FMSEmailTemplates.SendEditEmail = true;
            insert fms;

            fms[0].State_of_the_Form__c = 'Submitted';
            update fms[0];
            Form_Management_System__c fms2 = fms[0];
            
            Form_Management_System__c fms1 = [Select Name, Mandatory_State_Change_Comments__c, Customer_Name__c, Customer__c, CreatedBy.Name, CreatedBy.Email, Customer_Name__r.Name, Form_Name__c, Form_Description__c, State_of_the_Form__c, Form_Type__c, CreatedDate, Days_left_for_deletion__c from Form_Management_System__c where id =:fms[0].Id];
            Test.stopTest();
            FMSEmailTemplates.sendEmailOnCancel(fms[0]);
            FMSEmailTemplates.sendEmailOnSave(fms[0], true, true);
            FMSEmailTemplates.sendEmailOnSave(fms[0], false, true);
            FMSEmailTemplates.sendEmailOnSave(fms[0], true, false);
            FMSEmailTemplates.sendEmailOnSave(fms[0], false, false);
            FMSEmailTemplates.getBlankFormWarningTemplate(fms1);
            FMSEmailTemplates.getOldDraftWarningTemplate(fms1);
            FMSEmailTemplates.getFormSubscriptionOnYourBehalfTemplate(fms[0]);
            FMSEmailTemplates.sendNotificationOnRITFormCreation(fms[0]);
            FMSEmailTemplates.getFormStateChangeTemplate(fms[0], fms2);
            delete fms;
            
        }  

        static testmethod void FormEmailTemplatesTest1(){ 
            
            Account accountObj;
            Id mainFormId;
            Device__c dev;

            User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(thisUser){
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
                insert skipUser;

                accountObj = createAccount1();

                String oppId = DeviceChecklistTestDataUtils.createOpp(accountObj.Id);
                String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accountObj.Id, oppId);
                Process__c p = DeviceChecklistTestDataUtils.createProcess();
                dev = createDevice(accountObj.Id,oppId,oppProgId,p.Id); 

                Device__c device1 = [Select Id, Name, Account__c, Device_Description__c, Device_Sourcing__c, Device_Purpose__c, Account__r.Name, createdBy.Name, createdBy.Email, CreatedDate, Opportunity_Program__r.Name, Opportunity2__r.Name from Device__c where Id =: dev.Id];

                Test.StartTest();
                    FMSEmailTemplates.getDeviceCreateTemplate(device1);
                    FMSEmailTemplates.sendNotificationOnDeviceCreation(String.ValueOf(device1.Id));
                Test.stopTest();
            }

            
        }       
    }