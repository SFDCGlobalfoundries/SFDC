public class MultipleBillToAddressController{
    public Id accId {get;set;}
    public Account_Address__c newBillTo {get;set;}   
    
    public MultipleBillToAddressController(ApexPages.StandardController controller) {
        accId = ApexPages.currentPage().getParameters().get('accId');         
        newBillTo = (Account_Address__c)controller.getRecord(); 
        newBillTo.account__c = accId;
        newBillTo.type__c = 'Bill To Address';
        newBillTo.status__c = 'Pending';
       
    }

    public PageReference saveBillTo(){        
        Boolean addressExist = false;
        Boolean addressLocExist = false;
        try{
           
           Bill_To_Address_Number__c billNoCS = Bill_To_Address_Number__c.getValues('Update Bill To Address No');
           Decimal billAddNumb = billNoCS.Bill_To_Address_Number__c;
                      
           newBillTo.Bill_To_Address_Number__c =  String.valueof(Integer.valueof(billAddNumb));
           
           List<Account_Address__c> existAccAddress = [Select location__c,Address_1__c,Country__c,Postal_Zip_Code__c from Account_address__c where account__c =: accId and type__c = 'Bill To Address'];
           
           for(Account_Address__c addr : existAccAddress){
               if(newBillTo.location__c != null && addr.location__c == newBillTo.location__c){
                   addressLocExist = true;
               }
           }
           
           if(addressLocExist){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Bill To Location should be unique for this account.');
               ApexPages.addMessage(myMsg);  
               return null;
           }
           
           for(Account_Address__c addr : existAccAddress){
               if(addr.Address_1__c == newBillTo.Address_1__c 
                   && addr.Country__c == newBillTo.Country__c && addr.Postal_Zip_Code__c == newBillTo.Postal_Zip_Code__c){
                     addressExist = true;      
               }
           } 
           
           if(!addressExist){        
               insert newBillTo;
           }
           else{
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Bill To Address already exists i.e. Combination of Address Line 1, Country and Bill To Postal/Zip Code already exists with this account.');
               ApexPages.addMessage(myMsg);  
               return null;
           }
           
           billNoCS.Bill_To_Address_Number__c += 1;
           update billNoCS;
           
           PageReference pg = new PageReference('/'+accId);
           return pg;           
        }
        catch(Exception e){            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg); 
            return null;                   
        }
    }
    
    
}