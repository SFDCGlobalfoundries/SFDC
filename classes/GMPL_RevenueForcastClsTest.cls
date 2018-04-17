/*
    Author: Navneet Rajput
    Description: This is the test class for the GMPL_RevenueForcastCls class.  
    History:
        NRajput        03202014    - code creation.
        ARoy           05272014    - modified code for Case 00023658.
        DBiswal        04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class GMPL_RevenueForcastClsTest {    
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Account acct=new Account();  
        acct=(Account)Account.sObjectType.newSObject(NULL,true);
        acct.Name = 'Test';
        acct.short_name__c='TESTACC';
        insert acct;
         
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acct.Id;
        update env;        
    }
    
    static testMethod void GMPL_AfterInsertTriggerhandlerTest() {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        List<GMPL_BX009__c> listOfGmplRecords = GMPL_RevenueForcastClsTest.getBulkGMPLRecords();
        List<GMPL_BX009__c> listOfUpdatedGmplRecords = new List<GMPL_BX009__c>();
        try {
        
            Test.startTest();
            //Handles test coverage for after insert operations
            if (listOfGmplRecords!=null && !listOfGmplRecords.isEmpty()){
                insert listOfGmplRecords;
                System.assert(listOfGmplRecords.size()>0);
            }
            
            // Handles after update operations
            
            if (listOfGmplRecords!=null && !listOfGmplRecords.isEmpty()){
                for (GMPL_BX009__c gmpl: listOfGmplRecords){
                    gmpl.Product_Start_Date__c = String.valueOf(System.today().year());
                    listOfUpdatedGmplRecords.add(gmpl);
                }
                
                if (listOfUpdatedGmplRecords!=null && !listOfUpdatedGmplRecords.isEmpty()){
                    update listOfUpdatedGmplRecords;
                    System.assert(listOfUpdatedGmplRecords.size()>0);
                }
            }
            Test.stopTest();
            
        } catch (Exception e){
            system.debug('Exception ======> '+e.getMessage());
            Boolean customException =  e.getMessage().contains('Invalid Data') ? true : false;
            System.AssertEquals(customException, true);
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }     
        
    }

    // Test Method covers Revenue forcasting related functionality of GMPL 
    static testMethod void GMPL_RevenueForcastClsTest(){
        //DataUtilTest.loadEnvironmentVariables();
        Test.startTest();
        
            GMPL_BX009__c gmpl = new GMPL_BX009__c();
            gmpl.Product_Start_Date__c = String.valueOf(System.today().year());
            insert gmpl;
            
            // Positive scenarios
            List<Revenue_Forecast__c> listOfRevenueForcastingRecords = GMPL_RevenueForcastClsTest.getBulkRevenueForcastingRecords(gmpl.Id);
            System.currentPageReference().getParameters().put('id', gmpl.id);
            GMPL_RevenueForcastCls revenueClsObj = new GMPL_RevenueForcastCls(new ApexPages.StandardSetController(listOfRevenueForcastingRecords));
            
            revenueClsObj.gmplId=gmpl.id;
            revenueClsObj.rowIndex=1;
            
            revenueClsObj.addNewRow();
            //revenueClsObj.removeSelectedRow();
            revenueClsObj.deleteLastYear();
            revenueClsObj.SaverevenueForcastingInfo();
            revenueClsObj.cancel();
            
            // Negative Scenarios
            try {
                List<Revenue_Forecast__c> listOfSelectedRecords = new List<Revenue_Forecast__c>();
                
                Revenue_Forecast__c revenueObj1 = new Revenue_Forecast__c();
                revenueObj1.Year__c = String.valueOf(System.today().year());
                revenueObj1.GMPL_BX009__c = gmpl.Id;
                revenueObj1.Average_Sales_Price__c=0.0;
                revenueObj1.Quantity__c=0;
                
                Revenue_Forecast__c revenueObj2 = new Revenue_Forecast__c();
                revenueObj2.Year__c = String.valueOf(System.today().year());
                revenueObj2.GMPL_BX009__c = gmpl.Id;
                revenueObj2.Average_Sales_Price__c=0.0;
                revenueObj2.Quantity__c=0;
                
                listOfSelectedRecords.add(revenueObj1);
                listOfSelectedRecords.add(revenueObj2);
                
                insert listOfSelectedRecords;
                 
                GMPL_RevenueForcastCls newRevenueObj = new GMPL_RevenueForcastCls(new ApexPages.StandardSetController(listOfSelectedRecords));
                newRevenueObj.gmplId = null;
                newRevenueObj.rowIndex = -1;
          
                Test.setCurrentPage(Page.GMPL_RevenueForcastPage);
                List<Apexpages.Message> msgs = ApexPages.getMessages();
                boolean isErrorMessage = false;
                newRevenueObj.addNewRow();
                //newRevenueObj.removeSelectedRow();
                revenueClsObj.deleteLastYear();
                newRevenueObj.SaverevenueForcastingInfo();
                //newRevenueObj.listOfRevenueForcastRecords = listOfSelectedRecords;
                newRevenueObj.listOfRevenueForcastRecords = null;
                for(Apexpages.Message msg : msgs){
                    if (msg.getDetail().contains('ERROR: Error while deleting revenue forcasting record.')){
                        isErrorMessage  = true;
                        system.assert(isErrorMessage);
                    } else if (msg.getDetail().contains('Warning: Year need not be blank or duplicate.')){
                        isErrorMessage  = true;
                        system.assert(isErrorMessage);
                    } else if (msg.getDetail().contains('ERROR: Record not saved successfully. Please contact System Administrator.')){
                        isErrorMessage  = true;
                        system.assert(isErrorMessage);
                    } else if (msg.getDetail().contains('INFO: Last Year Deleted Successfully.')){
                        isErrorMessage  = true;
                        system.assert(isErrorMessage);
                    }  
                }
            
            } catch (Exception e){
                System.Assert(e.getMessage().contains('DML'));
            }
            
        Test.stopTest();
    }
    
    // Test Method covers Revenue forcasting related functionality of GMPL
    static testMethod void GMPL_RevenueForcastClsTest1(){
        User usr = GMPL_RevenueForcastClsTest.createUser();
        system.runAs(usr){
            Group grp = [select Id from Group where DeveloperName = 'CE_Admin_Group' limit 1];
            GroupMember gm = new GroupMember(GroupId = grp.Id, UserOrGroupId = UserInfo.getUserId());
            try{
                insert gm;
            }catch(Exception e){
                system.debug('Error while group member insertion :: '+e.getMessage());
            }
        }
        
        GMPL_BX009__c gmpl = new GMPL_BX009__c();
        gmpl.Product_Start_Date__c = String.valueOf(System.today().year());
        insert gmpl;
        
        Test.startTest();      
            // User permission            
            List<Revenue_Forecast__c> listOfRevenueForcastingRecords = new List<Revenue_Forecast__c>(); 
            System.currentPageReference().getParameters().put('id', gmpl.id);            
            boolean isErrorMessage = false;
            GMPL_RevenueForcastCls revenueClsObj;
            
            System.runAs(usr){
                revenueClsObj = new GMPL_RevenueForcastCls(new ApexPages.StandardSetController(listOfRevenueForcastingRecords));
                Test.setCurrentPage(Page.GMPL_RevenueForcastPage);
                List<Apexpages.Message> msgs = ApexPages.getMessages();
                
                revenueClsObj.deleteLastYear();
                for(Apexpages.Message msg : msgs){
                    if (msg.getDetail().contains('User is having Read Only access on GMPL/BX009 record.')){
                        isErrorMessage  = true;
                        system.assert(isErrorMessage);
                    }else if (msg.getDetail().contains('INFO: Last Year Deleted Successfully.')){
                        isErrorMessage  = true;
                        system.assert(isErrorMessage);
                    }
                }                
            }
            
        Test.stopTest();
        
    }
    
    // Create User
    private static User createUser(){
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='TestFirstName2002',
                                                  Last_Name__c='TestLastName2002',
                                                  Employee_ID__c='Test2002',
                                                  Login_ID__c='test2002',
                                                  Email_Address__c='test2002@test.com');
        insert hcm;
        Profile p = [select id from Profile where name = 'GF CE'];
        User u = new User(alias = 'ts2002', email='test2002@test.com',
                          emailencodingkey='UTF-8', lastname='TestLast2002', firstname='TestFirst2002', languagelocalekey='en_US',
                          localesidkey='en_US',timezonesidkey='America/Los_Angeles', username='test2002@test.com',communitynickname='ts2002',
                          profileid = p.Id,FederationIdentifier='Test2002');
        insert u;
        return u;
    }
    
    // Common method returns bulk records of GMPL_BX009 records.
    private static List<GMPL_BX009__c> getBulkGMPLRecords(){
        List<GMPL_BX009__c> listOfGmplRecords = new List<GMPL_BX009__c>();
        for (Integer i=0;i<=10;i++){
            GMPL_BX009__c gmplObj = new GMPL_BX009__c();
            gmplObj.Product_Start_Date__c=String.valueOf(System.today().year()+i);
            listOfGmplRecords.add(gmplObj);
        }
        return listOfGmplRecords;
    }
    
    // Common method returns list of revenueForcasting records
    private static List<Revenue_Forecast__c> getBulkRevenueForcastingRecords(Id gmplId){
        
        List<Revenue_Forecast__c> listOfSelectedIds = new List<Revenue_Forecast__c>();
        for (Integer i=0;i<=8;i++){
            Revenue_Forecast__c revenueObj = new Revenue_Forecast__c();
            revenueObj.Year__c = String.valueOf(System.today().year()+i);
            revenueObj.GMPL_BX009__c = gmplId;
            revenueObj.Average_Sales_Price__c=0.0;
            revenueObj.Quantity__c=0;
            
            listOfSelectedIds.add(revenueObj);
        }
        return listOfSelectedIds;
    }
    
    
}