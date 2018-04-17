@isTest
public class clsEHSQualityCertificationOnFVTest {
    public static testmethod void test1(){
        DataUtilTest.LoadATPEnvVariables();      
         Map<String,Object> fieldValueMap = New Map<String,Object>();        
        fieldValueMap.put('Name','test1');
        fieldValueMap.put('Stage__c','Active');
        fieldValueMap.put('Short_Name__c','TestAcct');
        fieldValueMap.put('Site_Department__c','siteDept');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','Transactional');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
       fieldValueMap.put('Process_Tech_Interested__c','Mature');
        fieldValueMap.put('Region__c','GC');
        fieldValueMap.put('Sales_Territory__c','US-West');
       fieldValueMap.put('Copy_Address__c',true);
       fieldValueMap.put('Corporate_Address_1__c','Corporate Address 2');
       fieldValueMap.put('Corporate_Country__c','Afghanistan'); 
        fieldValueMap.put('Bill_To_Address_1__c','Test Address 2');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
       fieldValueMap.put('FE_Territory__c','APJ-FE-CHINA');       
       fieldValueMap.put('Total_Employee__c',100);  
    
    //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl;     
        
    Account account1 = AccountDataFactory.createAccount(fieldValueMap);
        Other_EHS_CSR_Certificate__c ehs = new Other_EHS_CSR_Certificate__c();
        ehs.Certificate_Title__c = 'Test EHC';
        ehs.Certificate_Type__c = 'Material Declaration';
        ehs.Effective_Date__c = system.today();
        ehs.Expiry_Date__c = system.today()+3;
        ehs.Fabs__c = 'CORPORATE';
        insert ehs;
        
        system.currentPageReference().getParameters().put('Id', ehs.Id);
        ClsEHSQualityCertificationOnFV obj = new ClsEHSQualityCertificationOnFV();
        obj.qcReportins = ehs;
        obj.qcId = ehs.Id;
        obj.getQcAccessData();
        obj.getlstCertTypeOptions();
        obj.certificateGroup = 'MD';
        obj.getlstCertTypeOptions();
        obj.Search();
        obj.certificateGroup = 'REACH';
        obj.getlstCertTypeOptions();
        obj.Search();
        obj.certificateGroup = 'CMRT';
        obj.getlstCertTypeOptions();
        obj.onClickRedirect();
        obj.onLoadIframeAction();
        obj.srcFVUrl = 'testURL';
        obj.Search();
    }
}