/*
    Author: Cognizant
    Description: Apex test class for DRTSearchExtn class
    History: 
    Debasish      05/05/2014    - Apex code created
    Meenakshmi    13/52014     - test Class code created in the existing frame of the class
*/
@istest(SeeAllData=false)
public class DRTSearchExtnTest
{

@testSetup static void testdata() {        
        
        SwiftDataUtilityTest.customSystemData();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'Meenakshmi Account');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');                 
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Meenakshmi Corporate Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Meenakshmi City');                
        fieldValueMap.put('Corporate_Country__c', 'Cuba');
        fieldValueMap.put('Bill_To_Address_1__c', 'Meenakshmi Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Meenakshmi City');            
        fieldValueMap.put('Bill_To_Country__c', 'Congo');        
        fieldValueMap.put('Fab_9_10__c','No');
        //fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        fieldValueMap.put('Short_Name__c','ShortOne');
        
        AccountDataFactory.createAccount(fieldValueMap);
}


 /*
   This test method tests the below functionality of the class DRTSearchExtn 
    constructor 
    exportToExcel()
    exportToPdf()
    searchDRTCustomer()
    searchDRTType()
    searchDRTMST()
    searchDRTStatus()
    searchDRTNumber()
    callPagination()
    searchDRT()
    pagination()
    sortDRT()
    sortAscending()
    sortDescending()
    openDRT()
 */
    
  public static testMethod void TestDRTSearchExtn ()
  {
            account acc = getAccount('Meenakshmi Account');
            
            Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MYMST');
      
           insert mst;
                
          DRT__C drt = new DRT__C(Name='MYMST_PRIME_DRT_035.001',Status__c='Active', Type__c='PRIME',
                                      Mask_Set_Title__c = mst.id,Customer_Name__c=acc.id);
                                  
          insert drt;
         
          test.startTest();         
          Test.setCurrentPage(Page.VFDRTSearch);
          ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
          DRTSearchExtn objDRTSearchExtn = new DRTSearchExtn (new apexpages.StandardController(drt));
           
            objDRTSearchExtn.slno=10;
            objDRTSearchExtn.customerName=acc.id;
            Pagereference pagerefExcel=objDRTSearchExtn.exportToExcel();
           system.assertNotEquals(pagerefExcel,null);        
         
            Pagereference pagerefPDF=objDRTSearchExtn.exportToPdf();
           system.assertNotEquals(pagerefPDF,null);        
            
           objDRTSearchExtn.searchDRTCustomer();
            objDRTSearchExtn.searchDRTType();
            objDRTSearchExtn.searchDRTMST();
            objDRTSearchExtn.searchDRTStatus();    
            objDRTSearchExtn.callPagination();  
            system.assertEquals(objDRTSearchExtn.counter ,1);
           
            objDRTSearchExtn.searchDRT();
            system.assertEquals(objDRTSearchExtn.isDrtTableActive,true); 
            system.assertNotEquals(objDRTSearchExtn.DRTList,null);
            
            objDRTSearchExtn.pagination();
            objDRTSearchExtn.columnName= 'drt' ;
            objDRTSearchExtn.sortAscending();   
            objDRTSearchExtn.sortDescending();  
            
            
        ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL+'/VFDRTSearchToPdf?renderType=pdf');
          DRTSearchExtn objDRTSearchExtn1 = new DRTSearchExtn (new apexpages.StandardController(drt));
            
            objDRTSearchExtn1.slno=10;
            objDRTSearchExtn1.customerName=acc.id;
            objDRTSearchExtn1.drtType='PRIME';
            objDRTSearchExtn1.maskSetTitle='Test';
            objDRTSearchExtn1.drtStatus='Active';
            objDRTSearchExtn1.drtNumber='1';
            
            objDRTSearchExtn1.searchDRT();
             objDRTSearchExtn1.columnName= 'status' ;
            objDRTSearchExtn1.sortAscending();   
            objDRTSearchExtn1.sortDescending(); 
            
            
          test.stopTest();
      //}
  }
  
  private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}