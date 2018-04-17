public class CustomerSetupFormSAP{
    
    public List<Account> accList {get;set;}
    public List<Account_Address__c> accAddList {get;set;} 
    public List<Account_Address__c> accBillAddList {get;set;} 
    List<Account_Address__c> updateBillAddList = new List<Account_Address__c>();         
    public List<Account_Address__c> accTotalBillAddList = new List<Account_Address__c>();
    public String keyContact {get;set;}    
    public String keyContactPhone {get;set;}
    public String keyShipContact {get;set;}
    public String keyShipContactPhone {get;set;}
    public String otherContact {get;set;}
    public String otherContactPhone {get;set;}
    public String alternateContact {get;set;}
    public String alternateContactPhone {get;set;}
    public Boolean billAddressSame {get;set;}
    public Boolean shipAddressSame {get;set;}
    public Boolean newCustomer {get;set;}
    public string doSave {get;set;}
    public Id emailTargetId; 
    public String accountPayableContName {get;set;}
    public String accountPayableContEmail {get;set;}
    public String accountPayableContPhone {get;set;} 
    public Boolean newBillToAddress {get;set;}
    public Boolean newShipToAddress {get;set;}
    public Boolean newSoldToAddress {get;set;} 
    
    public CustomerSetupFormSAP(){
        Integer keyContactCount = 0;
        Integer keyShipContactCount = 0;
        Integer alternateContactCount = 0;
        Integer otherContactCount = 0;
        doSave = ApexPages.currentPage().getParameters().get('doSave');
        accAddList = new List<Account_Address__c>(); 
        accBillAddList = new List<Account_Address__c>();                         
        
        String accQuery = 'SELECT ';
        
        accQuery += describeObjectFields('Account');
        accQuery += ' FROM Account WHERE id = ' + '\'' + ApexPages.currentPage().getParameters().get('id') + '\'';
        accList = database.query(accQuery);
        
        String type = 'Ship To Address';
        Boolean isPrimary = true;
        String statusShipTo = 'Pending';
        String accPendingAddQuery = 'SELECT ';
        
        accPendingAddQuery += describeObjectFields('Account_Address__c');
        accPendingAddQuery += ' FROM Account_Address__c WHERE Type__c =: type and status__c =: statusShipTo and account__c = ' + '\'' + ApexPages.currentPage().getParameters().get('id') + '\'';
        //' FROM Account_Address__c WHERE Type__c =: type and Is_Primary_Address__c =: isPrimary and account__c = ' + '\'' + ApexPages.currentPage().getParameters().get('id') + '\'';
        accAddList = database.query(accPendingAddQuery);
        
        String billType = 'Bill To Address';   
        Boolean addSentToOM = false;     
        List<String> statusBillTo = new List<String>{'Approved','Inactive'};
        String accTotalBillAddQuery = 'SELECT ';
        
        accTotalBillAddQuery += describeObjectFields('Account_Address__c');
        accTotalBillAddQuery += ' FROM Account_Address__c WHERE Type__c =: billType and status__c in : statusBillTo and account__c = ' + '\'' + ApexPages.currentPage().getParameters().get('id') + '\'';        
        accTotalBillAddList = database.query(accTotalBillAddQuery);
        
        if(!accTotalBillAddList.isEmpty()){
            for(Account_Address__c add : accTotalBillAddList){                
                if(add.Is_Primary_Address__c){
                    accBillAddList.add(add);
                }
                else{
                    if(add.Address_Sent_To_OM__c == false){
                        accBillAddList.add(add);
                    }
                }
            }
        }

        
        if(accAddList.isEmpty()){
            String accPrimaryAddQuery = 'SELECT ';        
            accPrimaryAddQuery += describeObjectFields('Account_Address__c');
            accPrimaryAddQuery += ' FROM Account_Address__c WHERE Type__c =: type and Is_Primary_Address__c =: isPrimary and account__c = ' + '\'' + ApexPages.currentPage().getParameters().get('id') + '\'';
            accAddList = database.query(accPrimaryAddQuery);
        }
        
        
        if(!accAddList.isEmpty()){
            if(accAddList[0].Address_1__c == accList[0].Bill_To_Address_1__c && accAddList[0].Address_2__c == accList[0].Bill_To_Address_2__c
                && accAddList[0].City__c == accList[0].Bill_To_City__c && accAddList[0].State__c == accList[0].Bill_To_State__c
                && accAddList[0].Country__c == accList[0].Bill_To_Country__c && accAddList[0].Postal_Zip_Code__c == accList[0].Bill_To_Postal_Zip_Code__c){
                        shipAddressSame = true;
            }
            if(accList[0].Bill_To_Address_1__c == accList[0].Corporate_Address_1__c && accList[0].Bill_To_Address_2__c == accList[0].Corporate_Address_2__c
                && accList[0].Bill_To_City__c == accList[0].Corporate_City__c && accList[0].Bill_To_State__c == accList[0].Corporate_State__c
                && accList[0].Bill_To_Country__c == accList[0].Corporate_Country__c && accList[0].Bill_To_Postal_Zip_Code__c == accList[0].Corporate_Postal_Zip_Code__c){
                        billAddressSame = true;
            }                    
        }          
        
        if((!accList[0].Bill_To_Address_Change__c && !accList[0].Ship_To_Address_Change__c && !accList[0].Sold_To_Address_Change__c && accList[0].Stage__c == 'Authorized' 
            && accList[0].Approval_Request__c == 'Promote to Authorized' && accList[0].Approval_Status__c == 'Approved') || accList[0].New_SAP_Customer__c){
                newCustomer = true;                
        } 
        else{
            newBillToAddress = accList[0].Bill_To_Address_Change__c;
            newShipToAddress = accList[0].Ship_To_Address_Change__c;
            newSoldToAddress = accList[0].Sold_To_Address_Change__c;              
        } 
        
        if(!accBillAddList.isEmpty() && accBillAddList.size()>1 && !accList[0].New_SAP_Customer__c){
            newBillToAddress = true;
        }
                   
        for(Contact con:[SELECT id,role__c,phone,firstname,lastname,Is_Portal_User_Active__c,Is_Primary_Sold_to_Customer__c,name,Email FROM Contact WHERE accountid=:ApexPages.currentPage().getParameters().get('id')]){                          
                if(con.role__c.contains('Sold To Customer')){
                    if(con.Is_Primary_Sold_to_Customer__c && keyContactCount == 0){
                        keyContact = con.name;
                        keyContactPhone = con.phone;
                        keyContactCount++;
                    }
                    if(alternateContactCount == 0){
                        alternateContactCount++;
                        alternateContact = con.name;
                        alternateContactPhone = con.phone;
                    }
                    if(otherContactCount == 0){
                        otherContactCount++;
                        otherContact = con.name;
                        otherContactPhone = con.phone;
                    }
                }
                
                if(con.role__c.contains('Primary Accounts Payable')){
                    accountPayableContName = con.name;
                    accountPayableContEmail = con.email;
                    accountPayableContPhone = con.phone;
                }                           
        }
        
        if(!accBillAddList.isEmpty()){
            for(Account_Address__c add : accBillAddList){
                if(add.Address_Sent_To_OM__c == false){
                    add.Address_Sent_To_OM__c = true;  
                    updateBillAddList.add(add);
                }
            }
        } 
                           
    }
        
    public String describeObjectFields(String objctName){
        String fieldNameStr = '';
        
        Map<String,Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objctName);
        Map<String,Schema.SObjectField> SObjectFieldMap = SObjectTypeObj.getDescribe().fields.getMap();
        
        for(Schema.SObjectField fld : SObjectFieldMap.values()){
            Schema.DescribeFieldResult dfLst = fld.getDescribe();
            fieldNameStr += dfLst.getName() + ' ,';
        }
        
        return fieldNameStr.substring(0,fieldNameStr.length()-1);
    }
          
      public void savePDF(){ 
       
        if(accList[0].SAP_Form_Sent_To_OM__c == true || doSave=='No'){ 
          return; 
        } 
        
        try{
            PageReference pagePdf = new PageReference('/apex/CustomerSetupFormSAP?id='+accList[0].id+'&doSave=No'); 
            Blob pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
            
            Attachment a = new Attachment(); 
            a.Body = pdfPageBlob; 
            a.ParentID = accList[0].Id; 
            a.Name = 'Customer Form - ' + accList[0].Name + '.pdf'; 
            a.Description = 'Account'; 
            insert a; 
            
            
            List<User> userToAdd = [select name, email from user where id in (select userorgroupid from groupmember where group.name = 'AR Group') and isActive = true];
            List<Contact> con = [Select id from contact where email =: userinfo.getUserEmail()];
                        
            List<String> emailList = new List<String>();
            EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Send SAP Customer Form'];        
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            email.setWhatId(accList[0].id);        
            emailTargetId = con[0].id;                
            email.setTargetObjectId(emailTargetId);        
            email.setTemplateId(template.id);                   
           
            for(User usr:userToAdd){                   
                emailList.add(usr.email);
            }
            
            for(Account_Team_Proxy__c atp : [Select User_Email__c,Team_Role__c from Account_Team_Proxy__c where Account__c =: accList[0].Id]){
                if(atp.Team_Role__c.contains('Customer Service Rep')){
                    emailList.add(atp.User_Email__c);
                }
            }
           
            email.setToAddresses(emailList);
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
            email.setFileAttachments(fileAttachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                   
            if(!updateBillAddList.isEmpty()){
                update updateBillAddList;
            }
            
            Account acc = new Account(id=accList[0].id);
            acc.SAP_Form_Sent_To_OM__c = true; 
            acc.Sold_To_Address_Change__c = false;
            acc.Ship_To_Address_Change__c = false;
            acc.Bill_To_Address_Change__c = false;
            acc.New_SAP_Customer__c = false;
            update acc;
            
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        } 
      }
}