/*****************************************************************************
    Class Name: BaseIPTriggerHelper
    CR Number: CHG0044518
    Author: Ravi Teja.B    
    Description: IP Trigger Helper Class
    Created Date:15-11-2017 {DD-MM-YYYY}
******************************************************************************/
public class BaseIPTriggerHelper {
    Public Map<Id,Base_IP__c> triggerOldMap;
    Public Map<Id,Base_IP__c> triggerNewMap;
    public BaseIPTriggerHelper(){
        triggerOldMap = (Map<Id,Base_IP__c>) trigger.oldMap;
        triggerNewMap = (Map<Id,Base_IP__c>) trigger.newMap;
    }
    /*************************************************
    Method Name: RecordTypeAssignment
    Description: Assigning Record Type based on the IP
                 Type.
    Parameters : 
    Return Type: Void              
    **************************************************/
    public void RecordTypeAssignment(){
        Id OtherRTId = Schema.SObjectType.Base_IP__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        for(Base_IP__c ip: (List<Base_IP__c>) trigger.new){
            if(ip.Ip_Type__c != null){
                Schema.RecordTypeInfo RT = Schema.SObjectType.Base_IP__c.getRecordTypeInfosByName().get(ip.Ip_Type__c.toUpperCase());
                if(RT != null)
                    ip.RecordTypeId = RT.getRecordTypeId();
                else
                    ip.RecordTypeId = OtherRTId;
            }
            else{
                ip.RecordTypeId = OtherRTId;
            } 
        }
    }
    /*
    Method Name:    actDeactProducts 
    Author:        Ravi Teja.B
    Description:   This method is for making products active/deactive inorder show/hide from the configurator based on Display in catalog field on IP.
    History: 
    Ravi Teja.B           25022018     - Code Create.
    */
    public void actDeactProducts(){
        Map<String,Boolean> ipCodesActDeactMap = new Map<String,Boolean>();
        for(Base_IP__c ip: triggerNewMap.values()){
            if(ip.Display_in_IP_Catalog__c != null){
                if(ip.Display_in_IP_Catalog__c != triggerOldmap.get(ip.Id).Display_in_IP_Catalog__c){
                    if(ip.Display_in_IP_Catalog__c.toUpperCase() == 'YES')
                        ipCodesActDeactMap.put(ip.Name,true);
                    else if(ip.Display_in_IP_Catalog__c.toUpperCase() == 'NO')
                            ipCodesActDeactMap.put(ip.Name,false);
                }
            }
        }
        if(!ipCodesActDeactMap.isEmpty()){
            List<Product2> prodListtoUpdate = new List<Product2>();
            List<Apttus_Config2__PriceListItem__c> pliToUpdate = new List<Apttus_Config2__PriceListItem__c>();
            for(Product2 prod : [Select Id, IsActive, ProductCode,(Select Id, Apttus_Config2__Active__c, Apttus_Config2__PriceListId__r.Name from Apttus_Config2__PriceLists__r) from Product2 where ProductCode in: ipCodesActDeactMap.keyset()]){
                if(prod.ProductCode != null){
                    if(ipCodesActDeactMap.get(prod.ProductCode) == false){
                        prod.isActive = ipCodesActDeactMap.get(prod.ProductCode);
                        prodListtoUpdate.add(prod);
                    }
                    else{
                        prod.isActive = ipCodesActDeactMap.get(prod.ProductCode);
                        prodListtoUpdate.add(prod);
                        for(Apttus_Config2__PriceListItem__c pli: prod.Apttus_Config2__PriceLists__r){
                            if(!pli.Apttus_Config2__Active__c){
                                if(!prod.ProductCode.startswith('IPE')){
                                    pli.Apttus_Config2__Active__c = ipCodesActDeactMap.get(prod.ProductCode);
                                    pliToUpdate.add(pli);
                                }
                                else if(prod.ProductCode.startswith('IPE') && pli.Apttus_Config2__PriceListId__r.Name.contains('GLOBALFOUNDRIES Internal')) {
                                    pli.Apttus_Config2__Active__c = ipCodesActDeactMap.get(prod.ProductCode);
                                    pliToUpdate.add(pli);
                                }
                            }
                        }
                    }
                }
            }
            if(!prodListtoUpdate.isEmpty())
                update prodListtoUpdate;
            if(!pliToUpdate.isEmpty())
                update pliToUpdate;
        }

    }
}