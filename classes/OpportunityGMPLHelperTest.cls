/*
    Author: Anirban Roy
    Description: This is the test class for the OpportunityGMPLHelper class.  
    History:
        ARoy        05012014    - code creation.
        ARoy        06042014    - modified code for Case # 00024000.
*/

@isTest(SeeAllData=false)
public class OpportunityGMPLHelperTest{

    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing501');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }   
    
    // Creation of an Account
    static Id createAccount(){
                     Account acct= getAccount('testing501'); 
                    return acct.id;
       }
    
    // Creation of an opportunity
    static Opportunity createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');        
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(Id acctId){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Geometry__c = '10';
        gmplBX009.Family__c = 'TestFamily1';
        gmplBX009.Variant__c = 'TestVar1';
        gmplBX009.Option__c = 'TestOpt1';
        gmplBX009.Fab__c = 'FAB 1';
        gmplBX009.Account__c = acctId;
        gmplBX009.Product_Start_Date__c = String.valueOf(System.Today().year());
        try{
            insert gmplBX009;
        }catch(Exception ex){}
        return gmplBX009;
    }
    
    static Id createGMPLOppJun(Id oppId, Id gmplId){
        GMPL_Opportunity__c gmplOpp = new GMPL_Opportunity__c(GMPL_BX009__c = gmplId, Opportunity__c = oppId);
        insert gmplOpp;
        return gmplOpp.Id;   
    }
    
    static testMethod void createGMPLBX009OppTest(){
        
        Id acctId = OpportunityGMPLHelperTest.createAccount();
        Opportunity opp = OpportunityGMPLHelperTest.createOpp(acctId);
        
        GMPL_BX009__c gmpl = OpportunityGMPLHelperTest.createGMPL(acctId);               
        gmpl.G0_Disposition__c = 'Approved to BX009';
        gmpl.Status__c = 'Active';
        update gmpl;
        
        Id gmplOppId = OpportunityGMPLHelperTest.createGMPLOppJun(opp.Id,gmpl.Id);
        
        Test.startTest();
        
        try{
            OpportunityGMPLHelper.hasRun = false;
            opp.StageName = '8. Lost';
            
            update opp;
        }catch(Exception exp){
            system.assert(exp.getMessage().contains('Opportunity cannot be made Lost/Dropped/Void if active BX009(s) exists.'));
        }       
        
        Test.stopTest();
        
    }
    private static Account getAccount(string AccountName)
            {
                Account acct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acct;
            }  
    

}