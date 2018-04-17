/**
* Author: Prosenjit Saha
* Description: This class Updates all IP related product records with Latest IP design Kit value along with 
               the IP device List Values. This values will be used in the Apttus Proposal document. Please refer 
               to case ID : 00005668 for more details.

* History:
*     PSaha          02132014     - code creation.
*     
**/


public class CPQPopulateIpDeviceList{
    /*
    @Method Name:    populateIpDeviceList
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This class will be called from the Anonymous block to populate intended data in the product records.
    */
    Public void populateIpDeviceList(){
        List<String> IPIDList = new List<String>();
        Map<Product2,String> MapProductVsProductCode = new Map<Product2,String>();
        Map<String,string> MapProductCodeVsDeviceList = new Map<String,String>();
        Map<String,String> MapProductCodeVsIPDesginKitName = new Map <String,String>();
        //get all product records related to IP in the following block
        for(Product2 prod : [SELECT     id,
                                        Name,
                                        IP_device_list__c, //new field to be added
                                        ProductCode,
                                        Family,
                                        IP_Design_Kit_Name__c // new field to be added. 
                            FROM        Product2
                            WHERE       Family = 'IPs']){
                            
            system.debug('Prosenjit Debug:: ProductID'+prod.id);
            MapProductVsProductCode.put(prod,prod.ProductCode);
        }
        //create map between IP Id and Ip design Kit name/IP Device List. 
        for(IP__c IPdesignKit : [SELECT     id,
                                            Name,
                                            IP_Device_List__c,
                                            Latest_Version__c,
                                            IPNumber__r.name,
                                            IPNumber__c,
                                            Latest_Design_Kit__c
                                FROM        IP__c
                                WHERE       IPNumber__r.name 
                                IN          :MapProductVsProductCode.values()]){
            if(IPdesignKit.Latest_Design_Kit__c == TRUE){
                MapProductCodeVsDeviceList.put(IPdesignKit.IPNumber__r.name, IPdesignKit.IP_Device_List__c);
                MapProductCodeVsIPDesginKitName.put(IPdesignKit.IPNumber__r.name, IPdesignKit.name);
            }
        }
        //This is the final list to update.
        List<Product2> FinalProductUpdate = new List<Product2>();
        
        //populate value in the following section. 
        for(Product2 prod : MapProductVsProductCode.keyset()){
            prod.IP_device_list__c = MapProductCodeVsDeviceList.get(prod.ProductCode);
            prod.IP_Design_Kit_Name__c = MapProductCodeVsIPDesginKitName.get(prod.ProductCode);
            FinalProductUpdate.add(prod);
        }
        System.debug('Prosenjit Debug:: FinalProductList'+FinalProductUpdate);
        Update FinalProductUpdate;//update products.
    }

}