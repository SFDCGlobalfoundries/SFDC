/*
 Type Name: ClsMyWafersTest
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'ClsMyWafers' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     03262015    - Updated code for refactoring of test class.
    Rahul M     22/dec/2016 - Increased code coverage
*/

@isTest
private class ClsMyWafersTest 
{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    /**
        This method helps to test the PortalTabAccess record List for My wafers to check its all elements are set as 'True'
        and test the Page Redirection phase.
        
        @method name: testClsMyWafers
       
     */
    static testmethod void testClsMyWafers()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = new Account();
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            
            acctObj.Name='TestAccount';
            acctObj.Site_Department__c = 'Site1';
            acctObj.Sub_Type__c = 'Direct';
            acctObj.Transaction_Type__c = 'Transactional';
            acctObj.Region__c = 'APJ';
            acctObj.Bill_To_Address_1__c='Delta Estate';
            acctObj.Bill_To_City__c = 'Delta Estate';
            acctObj.Bill_To_Country__c = 'SINGAPORE';
            acctObj.Corporate_Address_1__c = 'Street';
            acctObj.Corporate_City__c = 'Delta Estate';
            acctObj.Corporate_Country__c = 'SINGAPORE';
            
            insert acctObj;
            
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'Shyam';
            userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            
            Profile pp = [Select Id from Profile where Name='System Administrator']; 
            User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
            system.runas(ur){
                insert userObj;
            }
            
            Test.startTest();
            //portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.Wafer_Start__c = true;
            portaltabObj.WIP_Status__c = true;
            portaltabObj.Tax_Invoice__c = true; 
            portaltabObj.Shipping_Query__c = true; 
            portaltabObj.Shipment_Detail_Unsort_and_Sort__c = true; 
            portaltabObj.Shipment_Alert_Report__c = true; 
            portaltabObj.Ship_Alert_by_Location__c = true;
            portaltabObj.ROM_Blanket__c = true;
            portaltabObj.Production_Query__c = true; 
            portaltabObj.Packaging_List_Report__c = true;
            portaltabObj.Order_Query__c = true; 
            portaltabObj.Order_Acknowledgement__c = true; 
            portaltabObj.On_Time_Delivery__c = true; 
            portaltabObj.NRE_Invoice__c = true; 
            portaltabObj.Lot_Control_table__c = true; 
            portaltabObj.Forecast_Fab_Cycle_Time__c = true;
            portaltabObj.Finish_Goods_Report__c = true;
            portaltabObj.Fab_Out_Schedule__c = true; 
            portaltabObj.Custom_Shipment_Report__c = true; 
            portaltabObj.Credit_and_Debit_Note__c = true; 
            portaltabObj.Certificate_of_Compliance__c = true; 
            portaltabObj.Billing__c = true; 
            portaltabObj.Purchase_Order_Tracking__c = true; 
            portaltabObj.Backlog__c = true; 
            portaltabObj.Shipping__c = true;
            portaltabObj.Production__c = true;
            portaltabObj.Orders__c = true;
            portaltabObj.Account_Statement__c  = true;
         
            insert portaltabObj;
            portaltabObj.User__c = userObj.Id;
            update portaltabObj;            
            
            System.runAs(userObj)
            {
                
                ClsMyWafers  clsMyWafersObj = new ClsMyWafers ();
                
               // clsMyWafersObj.getRowList();
                clsMyWafersObj.Page = 'orders';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'production';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'shipping';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'forecastfabcycle';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'waferst';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'wipstat';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'fabout';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'finishreport';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'lotcontrol';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'mfgreport';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'scrapreport';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'waferscrap';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'lothistory';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'fabwip';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'acctstate';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'bklog';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'billing';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'creditdebitnote';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'orderack';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'romblanket';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'nreinvoice';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'taxinvoice';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'purchaseorder';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'orderreport';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'compliancecert';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'otd';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'packagingrpt';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'shipmentrpt';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'shipmentalert';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'shipmentdetail';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'shipalert';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'prodquery';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'orderquery';
                clsMyWafersObj.redirect();
                clsMyWafersObj.Page = 'shippingquery';
                clsMyWafersObj.redirect();
                
                
               
                System.assertEquals(true, clsMyWafersObj.showorderLink);
              //  System.assertEquals(true, clsMyWafersObj.showshippSection);
              
              clsMyWafersObj.disablepackinglist = false;
              clsMyWafersObj.disableTaxInvoice2 = false;
              clsMyWafersObj.disableorderack2 = false;
              clsMyWafersObj.Page = 'mywafershome';
              clsMyWafersObj.redirect(); 
              clsMyWafersObj.Page = 'cycletime';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'engineeringwip';
              clsMyWafersObj.redirect(); 
              clsMyWafersObj.Page = 'globalshuttlempwwip';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'poLeadTime';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Order';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Shipment';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Early Warning';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Wip Status';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Wip Lot Gate History';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Nonet Lot';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Packing List2';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Tax Invoice2';
              clsMyWafersObj.redirect(); 
              clsMyWafersObj.Page = 'Order Ack2';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Personal reports';
              clsMyWafersObj.redirect();
              clsMyWafersObj.Page = 'Fab9/10Subscription';
              clsMyWafersObj.redirect();
            }
             Test.stopTest();
    }
    
    
    /**
        This method helps to test the PortalTabAccess record List for My wafers to check its all elements are set as 'False'.
        
        
        @method name: testClsMyWafersPTA
       
     */
    static testmethod void testClsMyWafersPTA()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = new Account();
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            
            acctObj.Name='TestAccount2';
            acctObj.Site_Department__c = 'Site11';
            acctObj.Sub_Type__c = 'Direct';
            acctObj.Transaction_Type__c = 'Transactional';
            acctObj.Region__c = 'APJ';
            acctObj.Bill_To_Address_1__c='Delta Estate';
            acctObj.Bill_To_City__c = 'Delta Estate';
            acctObj.Bill_To_Country__c = 'SINGAPORE';
            acctObj.Corporate_Address_1__c = 'Street';
            acctObj.Corporate_City__c = 'Delta Estate';
            acctObj.Corporate_Country__c = 'SINGAPORE';
            
            
            insert acctObj;
            
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon2';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con2@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'John1205';
            userObj.Email='John1205@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='John1205@test.com';
            userObj.Portal_Login__c = 'xyz1205';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            
            Profile pp = [Select Id from Profile where Name='System Administrator']; 
            User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
            system.runas(ur){      
                insert userObj;
            }
            
            Test.startTest();
            //portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.Wafer_Start__c = false;
            portaltabObj.WIP_Status__c = false;
            portaltabObj.Tax_Invoice__c = false; 
            portaltabObj.Shipping_Query__c = false; 
            portaltabObj.Shipment_Detail_Unsort_and_Sort__c = false; 
            portaltabObj.Shipment_Alert_Report__c = false; 
            portaltabObj.Ship_Alert_by_Location__c = false;
            portaltabObj.ROM_Blanket__c = false;
            portaltabObj.Production_Query__c = false; 
            portaltabObj.Packaging_List_Report__c = false;
            portaltabObj.Order_Query__c = false; 
            portaltabObj.Order_Acknowledgement__c = false; 
            portaltabObj.On_Time_Delivery__c = false; 
            portaltabObj.NRE_Invoice__c = false; 
            portaltabObj.Lot_Control_table__c = false; 
            portaltabObj.Forecast_Fab_Cycle_Time__c = false;
            portaltabObj.Finish_Goods_Report__c = false;
            portaltabObj.Fab_Out_Schedule__c = false; 
            portaltabObj.Custom_Shipment_Report__c = false; 
            portaltabObj.Credit_and_Debit_Note__c = false; 
            portaltabObj.Certificate_of_Compliance__c = false; 
            portaltabObj.Billing__c = false; 
            portaltabObj.Purchase_Order_Tracking__c = false; 
            portaltabObj.Backlog__c = false; 
            portaltabObj.Shipping__c = false;
            portaltabObj.Production__c = false;
            portaltabObj.Orders__c = false;
            portaltabObj.Account_Statement__c  = false;
            portaltabObj.GFV_Fab9_10_Reports__c = true;
            insert portaltabObj;
            
            portaltabObj.User__c = userObj.Id;
            update portaltabObj;
            
            System.runAs(userObj)
            {
                
                ClsMyWafers  clsMyWafersObj = new ClsMyWafers ();
                
                
                //System.assertEquals(false, clsMyWafersObj.showorderLink);
                //System.assertEquals(false, clsMyWafersObj.showproductionLink);
            }
            Test.stopTest();
    }
}