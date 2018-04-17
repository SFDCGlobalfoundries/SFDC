/*Author: Vijay Vemuru
Description:This Test class is used to test the clip and client level implementaion, it creates test records for Clip and Client level exemptions and also updates the opportunity to match the criteria
History:
6/23/2016     code creation
*/

@isTest
public class DealGrading_CliplevelTest{
@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        }
        
//Creating Opportunity
public static Opportunity createOpp(){
       
       Account testAcct=[SELECT id from Account LIMIT 1];
       Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity 1';
        testOppty.AccountId = testAcct.Id;
        
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '65CMOS';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Fab_Assignment_1__c = 'FAB 3';
        testOppty.Process_Geometry__c = '0.028UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        testOppty.Years_of_Production__c = 1;
        testOppty.Total_Program_Value__c  = 100000;
        testOppty.GF_Target_Share__c      = 10;
        testOppty.Product_Line__c         = 'ASIC'; 
       
        Insert testOppty;   
        return testOppty;

                    }
 
    public static testmethod void  CreateClipLevel() {
                  
        List<Clip_Level_Exemption__c> clList=new List<Clip_Level_Exemption__c>();
        Clip_Level_Exemption__c tcl=new Clip_Level_Exemption__c();
            tcl.Name='Rule101';
            tcl.Target_Process_Node__c='65CMOS';
            tcl.Brand__c='ASIC';
            tcl.LTR_Min__c = -0.10;
            tcl.Type_of_Exception__c='Clip level';
            tcl.Active__c=true;
        insert tcl;
         
        Opportunity   newopp    =   DealGrading_CliplevelTest.createOpp();
        Account testAcct        =   [SELECT id from Account LIMIT 1];    
             
           //create test record  for Clip level
           
        Clip_Level_Exemption__c testcl=new Clip_Level_Exemption__c();
            testcl.Name='Rule101';
            testcl.Target_Process_Node__c='65CMOS';
            testcl.Brand__c='ASIC';
            testcl.LTR_Min__c = -0.10;
            testcl.Type_of_Exception__c='Clip level';
            testcl.Active__c=true;
            testcl.Account__c = testAcct.id;
        insert testcl;
        
        Clip_Level_Exemption__c testcl1=new Clip_Level_Exemption__c();
            testcl1.Name                    =   'Rule102';
            testcl1.LTR_Min__c              =   -0.25;
            testcl1.Type_of_Exception__c    =   'Client Exemption';
            testcl1.Active__c               =   true;
            testcl1.Account__c              =   testAcct.id;
        insert testcl1;
                 
            Deal_Grading__c testdg              =   new Deal_Grading__c();
                testdg.Opportunity1__c          =   newopp.Id;
                testdg.Result__c                =   'Decision Pending'; 
                testdg.Deal_Grading_Status__c   =   'Draft';
            insert testdg;
            
        test.starttest();
                 
            newopp.Market_Segment__c = 'Mobility';
            newopp.Process_Platform__c = 'GF Baseline';
            newopp.Fab_Split__c = 100;
            newopp.Fab_Assignment_1__c = 'FAB 7';
            newopp.Process_Geometry__c = '0.065UM';
            newopp.Process_Family__c = 'CMOS';
            newopp.Target_Process_Node__c='65CMOS';
            newopp.Product_Line__c='ASIC';
            newopp.Opportunity_Sourcing_Type__c='First Source';
            newopp.CloseDate = date.newinstance(2016, 07, 21);
            newopp.Years_of_Production__c=6;            
            newopp.X1st_Product_Production_Date__c=date.newInstance(2016,6,22);   
        update newopp;
        
            String oppId=newopp.Id;    
            system.AssertEquals('ASIC',newopp.Product_Line__c);
           
                    //generating Quaterly revenue
            List<Quarterly_Revenue_Object__c> qtrRevList = [select ASP__c,Volume__c from Quarterly_Revenue_Object__c where Opportunity__c = :oppId];
            List<Quarterly_Revenue_Object__c> qtrUpdateList =new List<Quarterly_Revenue_Object__c>();
                
                for(Quarterly_Revenue_Object__c qtrRev : qtrRevList){
                    qtrRev.ASP__c = 12000;
                    qtrRev.Volume__c = 4000;
                    qtrUpdateList.add(qtrRev);
                }       
                
                update qtrUpdateList;
                
                newopp.Deal_Grading_Result__c  =   'Deal Grading Not Required';
                newopp.Deal_Grading_Status__c  =   'Bid - Review Not Required';
                update newOpp;
                testcl1.LTR_Min__c = -0.20;
                testcl.active__C = false;
                update testcl1;
               
        test.stoptest();
        
    } 
}