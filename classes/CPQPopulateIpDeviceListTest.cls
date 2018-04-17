/**
* Author: Prosenjit Saha
* Description: This class Updates all IP related product records with Latest IP design Kit value along with 
               the IP device List Values. This values will be used in the Apttus Proposal document. Please refer 
               to case ID : 00005668 for more details.

* History:
*     PSaha          02132014     - code creation.
*     
**/

@isTest(SeeAllData=false)
private class CPQPopulateIpDeviceListTest{
    
    /*
    * Method Name:     createProduct
    * Return Type:     Product2
    * Parameter  :     NA
    * Reason     :     This method creates Product Test Data. 
    */
    static Product2 createProduct(){
        Product2 TestProd = new Product2();
            TestProd.ProductCode                 = 'Test Product';
            TestProd.Product_External_ID__c      = 'Test Product';
            TestProd.APTPS_IP_Lifecycle__c       = 'Approved';
            TestProd.APTPS_IP_Type__c            = 'AMS';
            TestProd.APTPS_IP_Vendors__c         = 'GF';
            TestProd.Family                      = 'IPs';
            TestProd.Name                        = 'Test IP Product';
        insert TestProd;
        Return TestProd;
    }
    
    /*
    * Method Name:     createIP
    * Return Type:     IP__c
    * Parameter  :     ID
    * Reason     :     This method creates IP Test Data. 
    */
    static IP__c createIP(ID BaseIP){
        IP__c TestIP = new IP__c();
            TestIP.IPNumber__c            = BaseIP;
            TestIP.Name                   = 'Test Product';
            TestIP.Latest_Version__c      = 'Test Product';
            TestIP.IP_Device_List__c      = 'A;b;c;d';
        insert TestIP;
        return TestIP;
    }
    
    /*
    * Method Name:     createIP
    * Return Type:     IP__c
    * Parameter  :     ID
    * Reason     :     This method creates Base IP Test Data. 
    */
    static Base_IP__c createBaseIP(){
        Base_IP__c TestBaseIP = new Base_IP__c ();
            TestBaseIP.Name            = 'Test Product';
            TestBaseIP.IP_Number__c    = 'Test Product';
            TestBaseIP.Ip_Type__c      = 'AMS';
        insert TestBaseIP ;
        return TestBaseIP ;
    }
    
    /*
    * Method Name:     CPQPopulateIpDeviceListTestMethod
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method Tests populateIpDeviceList method of the  CPQPopulateIpDeviceList class.
    */
    @isTest static  void saveClose(){
        product2 TestProduct = createProduct();
        Base_IP__c TestBaseIP = createBaseIP();
        IP__c TestIP = createIP(TestBaseIP.ID);   
        CPQPopulateIpDeviceList TestController = new CPQPopulateIpDeviceList();
        test.startTest();
            TestController.populateIpDeviceList();
        test.stopTest();
    
    }
    
}