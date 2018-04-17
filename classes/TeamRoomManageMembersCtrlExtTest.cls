/*
    Author: Anirban Roy
    Description: Test class for TeamRoomManageMembersCtrlExt
    History:
    ARoy  12022013  - Code Creation
*/
@isTest
public class TeamRoomManageMembersCtrlExtTest
{

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 009');            
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
    static testMethod void doTestTeamRoomMngMemCntrlrExt(){
        test.startTest();
        List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'TestEnvironmentVariablesData');
        List<SObject> lstErrorCodes = Test.loadData(Error_Codes__c.sObjectType,'TestErrorCodesData');
        Account acc= getAccount('Test Account 009');
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 007',Team_Room_Description__c = 'Meeting Team Room',Primary_Account__c=acc .id);
        insert tmRm;
        apexpages.currentpage().getparameters().put('id',tmRm.id);
        
        Group grp = new Group(Name='GlobalFoundries Group', Type = 'Regular');
        insert grp;
        
        Team_Room_Member__c tmRmMem = new Team_Room_Member__c();
        tmRmMem.Group_Id__c = grp.id;
        tmRmMem.Group_Selected__c=true;
        tmRmMem.Is_Group__c = true;
        tmRmMem.Team_Room__c = tmRm.id; 
        tmRmMem.Access__c = 'Read/Write';
        insert tmRmMem;
        
        Team_Room_Member__c tmRmMem2 = new Team_Room_Member__c();
        tmRmMem2.User__c=UserInfo.getUserId();
        tmRmMem2.Group_Selected__c=true;
        tmRmMem2.Is_Group__c = false;
        tmRmMem2.Team_Room__c = tmRm.id;
        tmRmMem.Access__c = 'Read/Write'; 
        insert tmRmMem2;
        
        Team_Room_Member__c tmRmMem3 = new Team_Room_Member__c();
        tmRmMem3.Group_Id__c = grp.id;
        tmRmMem3.Group_Selected__c=false;
        tmRmMem3.Is_Group__c = true;
        tmRmMem3.Team_Room__c = tmRm.id; 
        tmRmMem.Access__c = 'Read';
        insert tmRmMem3;
        
        
        TeamRoomManageMembersCtrlExt tmRmMngMemCtrlExt = new TeamRoomManageMembersCtrlExt(); 
        
        
        
        PageReference pgRef1 = tmRmMngMemCtrlExt.Save();
        
        PageReference pgRef = tmRmMngMemCtrlExt.addNewRow();
        System.assert(pgRef==null);
        test.stopTest();
             
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acc;
    }
    
}