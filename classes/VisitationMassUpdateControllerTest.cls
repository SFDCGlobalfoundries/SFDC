@isTest(SeeAllData = false)
private class VisitationMassUpdateControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        DataUtilTest.loadVisitationSetting();
    
    Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Financial_Territory__c', 'Greater China');        
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Manager__c',userinfo.getuserid());
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Id createAccount(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Financial_Territory__c', 'Greater China');        
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Manager__c',userinfo.getuserid());
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        return AccountDataFactory.createAccount(fieldValueMap).id;
        
    }
    static testMethod void myUnitTest() {
      Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Visitation_Record__c vr = new Visitation_Record__c(Account__c = acctId, 
                                                            End_Date__c = system.today().addDays(5),
                                                            Visit_Type__c = 'Visit from Customer', 
                                                            visit_location__c = 'Singapore',
                                                            Purpose__c = 'Negotiations',
                                                            Requested_Executives__c = 'Alexie Lee;Ana Hunter',
                                                            Visit_Name__c = 'Visit Test',
                                                            Visitation_Host__c = userinfo.getuserid(),
                                                            Territory_Head_for_Approval__c = '005900000010Yk8',
                                                            Start_Date__c =  system.today(),
                                                            NDA_In_Effect_YN__c = 'No',
                                                            Fab__c = 'Fab 3;Fab 3E',
                                                            Customer_Status__c = '2. Confirmed'
        
                                                            );
                                                            
        insert vr;
        
        VisitationMassUpdateController ctrl = new VisitationMassUpdateController();
        ctrl.dummyVR.Account__c = acctId;
        ctrl.dummyVR.Visit_Location__c = 'Singapore';
        ctrl.dummyVR.Visit_Type__c = 'Visit from Customer';
        ctrl.dummyVR.Fab__c = 'Fab 3';
        ctrl.searchExe = '[Alexie Lee]';
        ctrl.searchStage= '[2. Confirmed]';
        ctrl.searchST = '[Greater China]';
        ctrl.searchVisitation();
        ctrl.massUpdate();
        if(ctrl.wrappers.size() > 0){
            ctrl.wrappers[0].isChecked = true;
            ctrl.wrappers[0].vstRec.Alexie_Lee__c = 'C';
        }
        ctrl.massUpdate();
        ctrl.beginning();
        ctrl.previous();
        ctrl.next();
        ctrl.end();
        ctrl.getDisableNext();
        ctrl.getDisablePrevious();
        ctrl.getPageNumber();
        ctrl.getDisplayRecordStart();
        ctrl.getDisplayRecordEnd();
        ctrl.getTotalRecords();
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}