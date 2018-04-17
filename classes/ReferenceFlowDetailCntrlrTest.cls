/*
    Author: Ariz Solito
    Description: Apex test class for ReferenceFlowDetailcntrlr
    History: 
        Asolito     17062014    - Code creation.
        Sunil Arora 01092014    - Added Department__c='Design' into contact object.    
*/
@isTest(seeAllData=false)
public class ReferenceFlowDetailCntrlrTest {

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'testing901');            
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

    static Id createAccount(){
        Account acc= getAccount('testing901'); 
        return acc.Id;
    }
    
    static Id createContact(Id acctId){
        Contact con = new Contact(
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            accountId = acctId,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c='Design'
        );
        insert con;
        return con.Id;
    }
    
    static Id createPortalUser(Id conId){
        User portalUser = new User(
            contactId = conId,
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsrT',
            profileId = '00e90000001AT3e',
            timezonesidkey='America/Los_Angeles', 
            username='testing00@test.com',
            FederationIdentifier='Test2015'
        );   
        insert portalUser;
        return portalUser.Id;
    }
    
    static Id createDesignSpec(){
        Design_Spec__c design = new Design_Spec__c(
            name = 'RFL-999999',
            technology_geometry__c = '0.028UM',
            opentext_id__c = 99999
        );
        insert design;
        return design.Id;
    }
    
    static Id createTechRefFile(){
        Tech_File__c tech = new Tech_File__c(
            name = 'RFL-999999',
            specification_type__c = 'Reference Flows'
        );
        insert tech;
        return tech.Id;
    }
    
    static Id createTechWPFile(){
        Tech_File__c tech = new Tech_File__c(
            name = 'WP-999999',
            specification_type__c = 'White Papers'
        );
        insert tech;
        return tech.Id;
    }
    
    static testMethod void testMethod1(){
        
        Id acctId = createAccount();
        test.startTest();
        Id conId = createContact(acctId);        
        Id portalUserId = createPortalUser(conId);
        Id desSpecId = createDesignSpec();
        Id techFileId = createTechRefFile();
               
        
        
        PageReference pageRef = Page.ReferenceFlowDetail;
        pageRef.getParameters().put('id',techFileId);
        Test.setCurrentPageReference(pageRef);
        
        ReferenceFlowDetailCntrlr ctrl = new ReferenceFlowDetailCntrlr(); 
        
        test.stopTest();               
        
    }
    
    static testMethod void testMethod2(){
        
        Id acctId = createAccount();
        test.startTest();
        Id conId = createContact(acctId);
        Id portalUserId = createPortalUser(conId);
        Id desSpecId = createDesignSpec();
        Id techFileId = createTechWPFile();
        
        
        
        PageReference pageRef = Page.ReferenceFlowDetail;
        pageRef.getParameters().put('id',techFileId);
        Test.setCurrentPageReference(pageRef);
        
        ReferenceFlowDetailCntrlr ctrl = new ReferenceFlowDetailCntrlr();
        ctrl.sendNotification(); 
        
        test.stopTest();               
        
    } 
    
    private static Account getAccount(string AccountName)
            {
                Account acct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acct;
            }       
}