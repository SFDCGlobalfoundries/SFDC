@isTest(seeAllData=false)
private class MRSPatchJobviewersSchedulableTest {

    @testSetup static void initData(){
        Test.startTest();
        SwiftDataUtilityTest.customSystemData();
        
        //DataUtilTest.loadEnvironmentVariables();
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
        Test.stopTest();
    }
    
    @isTest
    private static void testPatchJobviewers(){
        User sysAdminUser = [SELECT Id,Name, Email FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
        
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            // Create Account
            
            Account parentParentacctObj = getAccount('Test Account 007'); 
            
            
            // Create Contact
            Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=parentParentacctObj.Id, Email='testjv@test123.com', Department__c='Design;Procurement');
            insert conobj;
        
            // retrieve portal profile
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            
            // Create User
            User userObj = new User(Alias = 'Shyam', Email='testjv@test123.com', EmailEncodingKey='UTF-8', LastName='Paul',
                LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
                UserName='testjv@test123.com', Portal_Login__c = 'xyz', contactId = conobj.Id, IsActive = true);   
            insert userObj;
            
            Portal_Tab_Access__c portalTabObj = new Portal_Tab_Access__c(
                                                        Account__c=parentParentacctObj.Id ,My_Devices__c = true,My_Wafers__c=true,PDK_Design_Documents__c=true,
                                                      Product_Services__c=true,Electrical_Test__c=true,Wafer_Inspection__c=true,Yield_Sort_ETest_Reporting__c=true, PTRF__c=true);
            insert portalTabObj; 
            portalTabObj.User__c = userObj.Id;
            update portalTabObj;
            Test.startTest();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST0010');
            insert objMST;
            
            PTRF__c PTRFobj = new PTRF__c();
            PTRFobj.Name = 'PTRF 2';
            PTRFobj.Order_Type__c = 'Test Order Type';
            PTRFobj.Status__c = 'Open';
            PTRFobj.Prime_Tapeout__c    = true;
            PTRFobj.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj.Customer__c = parentParentacctObj.ID;
            PTRFobj.MaskSetTitle__c = objMST.Id;
            PTRFobj.tech_Geo_Value__c = '0.019UM';
            
            insert PTRFobj;
            
            List<PTRF_JobViewer_Info__c> jvList = new List<PTRF_JobViewer_Info__c>();
            
            PTRF_JobViewer_Info__c jv = new PTRF_JobViewer_Info__c();
            jv.PTRF__c              = PTRFobj.ID;
            jv.Jobview__c           = 'Customer';
            jv.Email_Address__c     = 'testjv@test123.com';
            jvList.add( jv );
            
            insert jvList;
            
            //Test.startTest();
            
            MRSPatchJobviewersSchedulable scheduler = new MRSPatchJobviewersSchedulable();
            String sch = '0 0 23 * * ?'; 
            System.schedule('PatchJobviewers' + sch, sch, scheduler); 
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testLogException() {
        try{
            Integer i = Integer.valueOf('1.o');
        }catch(Exception ex){
            MRSPatchJobviewersSchedulable.handleJobviewerPatchError(ex);
        }
    }
    
    private static Account getAccount(string AccountName)
            {
                Account parentParentacctObj = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return parentParentacctObj ;
            }  
}