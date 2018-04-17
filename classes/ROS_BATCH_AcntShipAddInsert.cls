global class ROS_BATCH_AcntShipAddInsert implements Database.Batchable<SObject>{
     
     List<Account> accountList;
     date compDate = System.today()-7;   
     RecordType RecType = [SELECT id FROM RecordType Where SobjectType = 'Account' and DeveloperName = 'Suppliers'];
     
     global Database.queryLocator start(Database.BatchableContext ctx){
        return Database.getQueryLocator([Select acc.name,acc.Id,acc.Bill_To_Address_1__c,acc.Bill_To_Address_2__c,acc.Bill_To_State__c,acc.Bill_To_Postal_Zip_Code__c,acc.Bill_To_Country__c  From Account acc where acc.CreatedDate >=: compDate AND acc.Bill_To_Address_1__c !=: null AND acc.RecordTypeId !=: RecType.Id]);
     }
     
    global void execute(Database.BatchableContext BC, List<Account> accountList ){
        List<Shipping_Address__c> newshippingAddresss=new List<Shipping_Address__c>();
        for(Account a: accountList){
            Shipping_Address__c shippingAddress=new Shipping_Address__c();
            shippingAddress.Address1__c = a.Bill_To_Address_1__c;
            shippingAddress.Address2__c = a.Bill_To_Address_2__c;
            shippingAddress.Shipping_State__c = a.Bill_To_State__c;
            shippingAddress.zip_code__c = a.Bill_To_Postal_Zip_Code__c;
            shippingAddress.Shipping_Country__c = a.Bill_To_Country__c;
            shippingAddress.System_Generated__c = true;
            shippingAddress.Account__c = a.Id;
            shippingAddress.Company_Name__c = a.name;
            newshippingAddresss.add(shippingAddress);
        }
        insert newshippingAddresss;            
    }
     
    global void finish(Database.BatchableContext BC){
        system.debug('Batch Job for Account Shipping Address Complete');
    }
}