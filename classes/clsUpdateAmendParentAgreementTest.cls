/*
    Author: Cognizant
    Description: This is the test class for Related Agreement Trigger.  
    History:
        KMondam 03-2-2014 code creation.
        --
        Ashwini     05142015    - Updated code for refactoring of test class.
*/

@isTest(SeeAllData=false)
private class clsUpdateAmendParentAgreementTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
static TestMethod void InsertRelatedAgreementTest() {
     
 //DataUtilTest.loadEnvironmentVariables(); 
 // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };         
          insert ndaSyncSettings;
    Account acctNDA = new Account (
            Short_Name__c = 'NdaTestAcct',
            Account_Profile__c='Fabless - Emerging',
            Financial_Territory__c='US-West',
            Process_Tech_Interested__c='Mature (> 0.11um)',
            Total_Employee__c=7,
            Bill_To_Location__c='Santa Clara',
            Target_Account__c='Yes',
            Revenue_Potential__c='Low Potential',
            Sales_Territory__c='US-East',
            FE_Territory__c='US-FE-West',
            Name='Test NDA Account1',
            Site_Department__c='IT',
            Sub_Type__c='Indirect',
            Transaction_Type__c='Non-Transactional',
            Region__c='US',
            Bill_To_Address_1__c='NDATest Address',
            Bill_To_City__c='NdaTest City',
            Bill_To_Country__c='India',
            Corporate_Address_1__c = 'NdaTest Address 1',
            Corporate_Address_2__c = 'NdaTest Address 2',
            Corporate_Address_3__c = 'NdaTest Address 3',
            Corporate_Address_4__c = 'NdaTest Address 4',
            Corporate_City__c = 'NdaTest City',
            Corporate_State__c = 'NdaTest State',
            Corporate_Country__c = 'NdaTest Country',
            Corporate_Postal_Zip_Code__c = '95539',
            Copy_Address__c = true,
            Stage__c = 'Unqualified'
    
    
    );
    
    insert acctNDA;
    
    Contact conNDA = new  Contact(
                firstName = 'testNDA', 
                lastName = 'testNda',
                accountId = acctNDA.id
            ); 
              
    Apttus__APTS_Agreement__c armntTo = new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA2', 
        Apttus__Account__c = acctNDA.Id,
        Apttus__Primary_Contact__c = conNDA.Id,
        GF_Department_Name__c = 'Sales', 
        Region__c = 'US East',
        Purpose__c = 'Testing', 
        Type__c = 'None',
        Apttus__Status_Category__c = 'Request',
        GF_Contract_Start_Date__c = date.today(),
        GF_Contract_End_Date__c = date.today()+ 10,
        Apttus__Status__c='Request',
        geometries__c='0.010UM'+'\\;'+'0.11UM',
        How_many_Other_Parties_for_the_NDA__c = '1'
        );
        Test.startTest();
       insert armntTo; 
     
      Apttus__APTS_Related_Agreement__c relatedAgmnt= new Apttus__APTS_Related_Agreement__c(

       Name = 'Current Agreement',
       Apttus__Relationship_From_Type__c = 'Is Amended By',
       Apttus__APTS_Contract_To__c = armntTo.Id,
       Apttus__Relationship_To_Type__c = 'Is Amendment For'
       );  
       
    insert  relatedAgmnt;   
    Test.stopTest();
 }
 }