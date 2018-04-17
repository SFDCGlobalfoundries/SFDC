public with sharing class CustomerItemTriggerHandler {
    public static boolean alreadyRanThisLogic{get; set;}
    /**
     *   Invokes correct handlers as per the context of Trigger and available registered handlers
     */
    public static void handle(List<Customer_Item__c> customerItems){
        if(CustomerItemTriggerHandler.alreadyRanThisLogic != true){
            CustomerItemTriggerHandler.alreadyRanThisLogic = true;
            List<Customer_Item__c> orangeCustomerItems = new List<Customer_Item__c>();
            List<Customer_Item__c> redCustomerItems = new List<Customer_Item__c>();
            for(Customer_Item__c item : customerItems){
                if(item.Sold_To__c != null) redCustomerItems.add(item);
                else orangeCustomerItems.add(item);
            }
            if(!redCustomerItems.isEmpty()){
                handleRedDevices(redCustomerItems);
            }
            if(!orangeCustomerItems.isEmpty()){
                handleOrangeItems(orangeCustomerItems);
            }
        }
    }
    
    
    public static void handleRedDevices(List<Customer_Item__c> customerItems){
        Set<String> soldToSalesOrgs = new Set<String>();
        Set<String> productNumbers = new Set<String>();
        for(Customer_Item__c item: customerItems){
            if(item.Sold_To__c != null && item.Sales_Org__c != null){
                String soldToSalesOrg = item.Sold_To__c.leftPad(6,'0')+'-'+item.Sales_Org__c;
                item.Soldto_SalesOrg__c = soldToSalesOrg;
                soldToSalesOrgs.add(soldToSalesOrg);
            }
            if(item.MD_Part_Number__c != null){
              productNumbers.add(item.MD_Part_Number__c);  
            }
        }
        
        List<Account_Sales_Org__c> accSalesOrgs = [SELECT Id, Soldto_SalesOrg__c, Account_Name__c  from Account_Sales_Org__c where Soldto_SalesOrg__c in : soldToSalesOrgs];
        Map<String, Id> soldToId = new Map<String, Id>();
        for(Account_Sales_Org__c accSoldTo: accSalesOrgs){
            soldToId.put(accSoldTo.Soldto_SalesOrg__c, accSoldTo.Account_Name__c);
        }
        
        List<ERP_Device__c> devices = [SELECT Id, Part_Number__c from ERP_Device__c where Part_Number__c in : productNumbers];
        Map<String, Id> productToId = new Map<String, Id>();
        for(ERP_Device__c dev: devices){
            productToId.put(dev.Part_Number__c, dev.Id);
        }
        
        /**
         * Check if all required fields are loaded. if not add an error. 
         * Required field details are in ERP_Device_Required_Fields__c custom setting.
         **/
        List<ERP_Device_Required_Fields__c> redRequiredFields = [SELECT Id, Name, SObject__c, Message__c FROM ERP_Device_Required_Fields__c where SObject__c = 'Customer_Item__c'];
        for(Customer_Item__c item: customerItems){
            //Map Account
            if(item.Soldto_SalesOrg__c != null) item.Customer__c = soldToId.get(item.Soldto_SalesOrg__c);
            //Map Product
            if(item.MD_Part_Number__c  != null) item.ERP_Device__c = productToId.get(item.MD_Part_Number__c );
            
            boolean requiredFieldMissing = false;
            String errorMessage = '';
            item.Integrity_Error_Flag__c = true;
            item.Integrity_Error__c = errorMessage;
            for(ERP_Device_Required_Fields__c requiredField : redRequiredFields){
                if(item.get(requiredField.Name) == null || item.get(requiredField.Name) == ''){
                    errorMessage += (requiredField.Message__c + '*** ');
                    requiredFieldMissing = true;
                }
            }
            if(requiredFieldMissing){
             item.Integrity_Error_Flag__c = true;
             item.Integrity_Error__c = errorMessage;
            }
        }
    }
    public static void handleOrangeItems(List<Customer_Item__c> customerItems){
        //Colect all Customer short names to create Reference to 
        Set<String> accountShartNames = new Set<String>();
        Set< String > devicesErpIds = new Set< String >();
        
        for(Customer_Item__c customerItem : customerItems){
            if(customerItem.Customer__c == null){
                accountShartNames.add(customerItem.Customer_Short_Name__c);
            }
            if(customerItem.ERP_Device_Inventory_Id__c != null && customerItem.ERP_Device__c == null){
                devicesErpIds.add(customerItem.ERP_Device_Inventory_Id__c);
            }
        }
        if(!accountShartNames.isEmpty()){
            List<Account> accounts = [SELECT Id, Name, Short_Name__c FROM Account WHERE Short_Name__c IN : accountShartNames];
            // Create map between short name and account id
            Map<String, Id> shortNameToAccountId = new Map<String, Id>();
            for(Account acc: accounts){
                shortNameToAccountId.put(acc.Short_Name__c, acc.Id);
            }
            for(Customer_Item__c customerItem : customerItems){
                if(customerItem.Customer_Short_Name__c != null && shortNameToAccountId.get(customerItem.Customer_Short_Name__c) != null && customerItem.Customer__c == null){
                    customerItem.Customer__c = shortNameToAccountId.get(customerItem.Customer_Short_Name__c);
                }
            }
        }
        if(!devicesErpIds.isEmpty()){
            List<ERP_Device__c> erpDeviceBasedOnInventoryId = [SELECT ERP_Inventory_Id__c, Id, Name from ERP_Device__c where ERP_Inventory_Id__c in  :devicesErpIds ORDER BY ERP_Inventory_Id__c];
            System.debug(erpDeviceBasedOnInventoryId);
            System.debug(devicesErpIds);
            Map<String, List<ERP_Device__c>> deviceNameToErpDevices = new Map<String, List<ERP_Device__c>>();
            for(ERP_Device__c erpDevice: erpDeviceBasedOnInventoryId){
                if(deviceNameToErpDevices.get(erpDevice.ERP_Inventory_Id__c) == null){
                    deviceNameToErpDevices.put(erpDevice.ERP_Inventory_Id__c, new List<ERP_Device__c>{erpDevice});
                }else{
                    deviceNameToErpDevices.get(erpDevice.ERP_Inventory_Id__c).add(erpDevice);
                }
            }
            for(Customer_Item__c customerItem : customerItems){
                if(deviceNameToErpDevices.get(customerItem.ERP_Device_Inventory_Id__c) != null){
                    if(deviceNameToErpDevices.get(customerItem.ERP_Device_Inventory_Id__c).size() == 1){
                        customerItem.ERP_Device__c = deviceNameToErpDevices.get(customerItem.ERP_Device_Inventory_Id__c)[0].Id;
                    }
                }
            }
        }
    }
}