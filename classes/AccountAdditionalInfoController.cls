public class AccountAdditionalInfoController{

    Id accId;
    public List<Contact> conList {get;set;}
    public Contact newCon {get;set;} 
    public Contact newConAccPayable {get;set;}   
    public Boolean createNewContact {get;set;}
    public String selectedContact {get;set;}
    public Boolean sgtTaxDetails {get;set;}
    public Boolean usTaxDetails {get;set;}
    public Boolean additionalInfoNeeded {get;set;}
    public String acctStage {get;set;}
    public String approvalRequest {get;set;}
    public List<Account_Address__c> accAddress {get;set;}
    public Account_Address__c newShipAdd {get;set;}
    public Boolean createNewShipToAdd {get;set;}
    public List<Account> accList {get;set;}
    public Integer pendingAddressCount {get;set;}
    public Boolean changeShipToAddressOnly {get;set;}
    public Boolean shipToAddressExist {get;set;}
    public String primaryAddress {get;set;}
    public String primaryContact {get;set;}
    public Boolean taxExcempt {get;set;}
    public String billToCountry {get;set;}
    public String addType = 'Ship To Address';
    public Account_Address__c existingShipTo {get;set;}
    public String existingShipToId {get;set;}
    public Boolean retrieveExistingShipToAdd{get;set;}
    public List<Contact> accPayableConList {get;set;}
    public String conRole = 'Primary Accounts Payable';
    public String soldToConRole = 'Sold To Customer';
    public List<Contact> allContactList {get;set;}
    public Boolean showAllContact {get;set;}
    public String selectedConForAccPayable {get;set;}
    public Boolean createNewContactPayable {get;set;}
    public Boolean accPayableContactExist {get;set;}
    public Boolean soldToContactExist {get;set;}
    public List<Contact> allNonSoldToConList {get;set;}
    public Boolean showAllNonSoldToContacts {get;set;}
    public String selectedConForSoldTo {get;set;}
    public String vatRegMandateCountry {get;set;}
    public Boolean soldToAddQuestion {get;set;}
    public Boolean soldToQuestReadOnly {get;set;}
    public String oldValueChemical;
    public String oldValueUSExport;
    public String oldValueMilitaryEndUser;
    public String oldValueRussiaOrUkraine;
    public String oldValueMissiles;
    public String oldValueNuclear;
    public String oldValueEmail;
    public String oldValueName;
    public String oldValueMilitaryUse;
    public String sapAccountNumber {get;set;}
    
    public AccountAdditionalInfoController() {
        retrieveExistingShipToAdd = false;  
        soldToAddQuestion = true;      
        accId = ApexPages.currentPage().getParameters().get('id');
        
        vatRegMandateCountry = 'Austria Belgium Bulgaria Croatia Cyprus Czech Republic Denmark Germany Hungary Italy Luxembourg Malta Netherlands Poland Slovakia Spain United Kingdom';
                
        if(accId != null){
            
            String conQuery = 'SELECT ';       
            conQuery += describeObjectFields('Contact');
            conQuery += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + soldToConRole + '\'' + ')'; 
            conList = database.query(conQuery);
            if(!conList.isEmpty()){
                soldToContactExist = true;
            }
            
            String conQuery1 = 'SELECT ';       
            conQuery1 += describeObjectFields('Contact');
            conQuery1 += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + conRole + '\'' + ')'; 
            accPayableConList = database.query(conQuery1);
            
            if(!accPayableConList.isEmpty()){
                accPayableContactExist = true;
            }
             
            String accAddQuery = 'SELECT ';       
            accAddQuery += describeObjectFields('Account_Address__c');
            accAddQuery += ' FROM Account_Address__c WHERE account__c = ' + '\'' + accId + '\'' + ' AND Type__c = ' + '\'' + addType + '\''; 
            accAddress = database.query(accAddQuery);
                                   
            if(!accAddress.isEmpty()){
                shipToAddressExist = true;
                for(Account_Address__c addr : accAddress){
                    if(addr.status__c == 'Pending'){
                        pendingAddressCount = 1;
                        break;
                    }
                }
            }
            else{
                pendingAddressCount = 0;
            }            
            
            String accQuery = 'SELECT ';       
            accQuery += describeObjectFields('Account');
            accQuery += ' FROM Account WHERE id = ' + '\'' + accId + '\''; 
            accList = database.query(accQuery); 
            
            oldValueChemical = accList[0].Sold_To_Chemical_Biological_Sysytem__c;
            oldValueUSExport = accList[0].Sold_To_Is_Contrary_to_US_Export_Laws__c;
            oldValueMilitaryEndUser = accList[0].Sold_To_Is_Military_End_User__c;
            oldValueRussiaOrUkraine = accList[0].Sold_To_Is_Related_to_Russia_or_Ukraine__c;
            oldValueMissiles = accList[0].Sold_To_Missiles_Related_Activity__c;
            oldValueNuclear = accList[0].Sold_To_Nuclear_Fuel_Related_Activity__c;
            oldValueEmail = accList[0].Sold_To_Proliferation_Info_By_Email__c;
            oldValueName = accList[0].Sold_To_Proliferation_Info_By_Name__c;
            oldValueMilitaryUse = accList[0].Sold_To_Subject_to_Military_End_Use__c;
                    
            if(accList[0].Approval_Request__c == 'Account Details Change'  || (((accList[0].Approval_Request__c == 'Promote to Authorized' && accList[0].Stage__c == 'Qualified') || (accList[0].Stage__c == 'Unqualified' && (accList[0].Approval_Request__c == 'Promote to Authorized' || accList[0].Approval_Request__c == 'Promote to Qualified'))) && accList[0].SAP_Account_Number__c != null)){
                 if(accList[0].Account_Name_Change_Request__c != null || accList[0].Corporate_Country_Change_Request__c != null){
                     soldToAddQuestion = true;
                     accList[0].Sold_To_Chemical_Biological_Sysytem__c = '';
                     accList[0].Sold_To_Is_Contrary_to_US_Export_Laws__c = '';
                     accList[0].Sold_To_Is_Military_End_User__c = '';
                     accList[0].Sold_To_Is_Related_to_Russia_or_Ukraine__c = '';
                     accList[0].Sold_To_Missiles_Related_Activity__c = '';
                     accList[0].Sold_To_Nuclear_Fuel_Related_Activity__c = '';
                     accList[0].Sold_To_Proliferation_Info_By_Email__c = '';
                     accList[0].Sold_To_Proliferation_Info_By_Name__c = '';
                     accList[0].Sold_To_Subject_to_Military_End_Use__c = '';
                 }
                 else{
                     soldToAddQuestion = false;
                 }
                 soldToQuestReadOnly = false;
                 
                 if(accList[0].Bill_To_Address_1_Change_Request__c != null || accList[0].Bill_To_Address_2_Change_Request__c != null || accList[0].Bill_To_Address_3_Change_Request__c != null
                 || accList[0].Bill_To_Address_4_Change_Request__c != null || accList[0].Bill_To_City_Change_Request__c != null || accList[0].Bill_To_Country_Change_Request__c != null
                 || accList[0].Bill_To_Postal_Code_Change_Request__c != null || accList[0].Bill_To_State_Change_Request__c != null || accList[0].Bill_To_Location_Change_Request__c != null
                 || accList[0].Primary_Bill_To_Address_Change_Request__c != null){
                     accList[0].Bill_To_Address_Change__c = true;
                 }
                 if(accList[0].Corporate_Address_1_Change_Request__c != null || accList[0].Corporate_Address_2_Change_Request__c != null || accList[0].Corporate_Address_3_Change_Request__c != null
                 || accList[0].Corporate_Address_4_Change_Request__c != null || accList[0].Corporate_City_Change_Request__c != null || accList[0].Corporate_Country_Change_Request__c != null
                 || accList[0].Corporate_Postal_Zip_Code_Request_Change__c != null || accList[0].Corporate_State_Change_Request__c != null){
                     accList[0].Sold_To_Address_Change__c = true;
                 }
            } 
            else if(accList[0].Approval_Request__c == 'Ship To Address Change') {
                changeShipToAddressOnly = true;
                soldToQuestReadOnly = true;
            }                                   
            renderCountryTaxDetails();
        }        
    }
    
    public void editSoldToQuestionaire(){
        soldToAddQuestion = true;
    }
    
    public void cancelSoldToQuestionaire(){
        soldToAddQuestion = false;
    }
    
    public void saveSoldToQuestionaire(){
        try{
            update accList[0];
            soldToAddQuestion = false;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);            
        }        
    }
    
    public void setTaxExemptForNonUS(){
        if(existingShipTo != null && existingShipTo.id != null && existingShipTo.country__c != 'USA' && existingShipTo.country__c != 'Singapore' 
            && existingShipTo.Shipments_exported_from_USA__c == 'Yes' && existingShipTo.Who_will_be_Exporter_of_Record__c == 'Customer'){
            
            existingShipTo.US_Taxable__c = 'No';
            existingShipTo.US_Tax_Exempt__c = 'Yes';
            existingShipTo.Certificate_Type__c = 'Export Claim and WRIT (If Customer is Exporter of Record)';
        }
        else{
            if(newShipAdd != null && newShipAdd.country__c != 'USA' && newShipAdd.country__c != 'Singapore' 
                && newShipAdd.Shipments_exported_from_USA__c == 'Yes' && newShipAdd.Who_will_be_Exporter_of_Record__c == 'Customer'){
                
                newShipAdd.US_Taxable__c = 'No';
                newShipAdd.US_Tax_Exempt__c = 'Yes';
                newShipAdd.Certificate_Type__c = 'Export Claim and WRIT (If Customer is Exporter of Record)';
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
    
    public void createNewContact(){
        createNewContact = true;
        showAllContact = false;
        createNewContactPayable = false;
        retrieveExistingShipToAdd = false;
        createNewShipToAdd = false;
        newCon = new Contact();
        if(accId != null){
            newCon.accountId = accId;
        }
        newCon.role__c = 'Sold To Customer';
    }
    
    public void saveContact(){                
        
        List<Contact> contactsToUpdate = new List<Contact>();
        try{
            List<Contact> redundantContact = [Select id from Contact where email =: newCon.email];
            if(redundantContact.isEmpty()){
                insert newCon;
            }
            else{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact with same email address is already associated with this Account')); return;               
            }
            
            createNewContact = false;
            showAllNonSoldToContacts = false;
                       
            if(newCon.Is_Primary_Sold_to_Customer__c){
                for(Contact con:[SELECT id from Contact WHERE accountid =: newCon.accountId AND Is_Primary_Sold_to_Customer__c = true and id !=: newCon.id]){
                    con.Is_Primary_Sold_to_Customer__c = false;
                    contactsToUpdate.add(con);
                }                
            }
            if(!contactsToUpdate.isEmpty()){
                update contactsToUpdate;
            }
            
            String conQuery = 'SELECT ';       
            conQuery += describeObjectFields('Contact');
            conQuery += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + soldToConRole + '\'' + ')'; 
            conList = database.query(conQuery);                     
        }
        catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));            
        }        
        soldToContactExist = true;       
    }
    
    public void cancelContact(){
        createNewContact = false;
    }
    
    public void showAllNonSoldToContacts(){
        showAllNonSoldToContacts = true; 
        showAllContact = false;
        createNewContact = false;
        retrieveExistingShipToAdd = false;
        createNewContact = false;        
        createNewShipToAdd = false;
                          
        String conQuery = 'SELECT ';       
        conQuery += describeObjectFields('Contact');
        conQuery += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c excludes (' + '\'' + soldToConRole + '\'' + ')'; 
        allNonSoldToConList = database.query(conQuery); 
    }
    
    public void cancelSoldToAccSelectCreate(){
        showAllNonSoldToContacts = false;
        createNewContact = false;
    }
    
    public void updateExisConToSoldToCust(){
            showAllNonSoldToContacts = false;
            createNewContact = false;
            List<Contact> contactsUpdate = new List<Contact>();
            
            try{                
                contactsUpdate = [Select id,role__c from Contact where id=: Id.valueOf(selectedConForSoldTo)];
                If(contactsUpdate[0].role__c != null){
                    if(!contactsUpdate[0].role__c.contains('Sold To Customer')){
                       contactsUpdate[0].role__c += ';Sold To Customer '; 
                    }
                }
                else{
                    contactsUpdate[0].role__c = 'Sold To Customer';
                }
                               
                update contactsUpdate[0];
                
                String conQuery = 'SELECT ';       
                conQuery += describeObjectFields('Contact');
                conQuery += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + soldToConRole + '\'' + ')'; 
                conList = database.query(conQuery);                                
            }               
            catch(Exception e){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));                   
            }   
            soldToContactExist = true;
    } 
    
    public void createNewShipToAdd(){        
        createNewContact = false;
        showAllContact = false;
        createNewContactPayable = false;
        retrieveExistingShipToAdd = false;
        createNewShipToAdd = true;
        showAllNonSoldToContacts = false;
        
        newShipAdd = new Account_Address__c();
        if(accId != null){
            newShipAdd.account__c= accId;
        }
        newShipAdd.type__c = 'Ship To Address';
    }
    
    public void saveNewShipToAdd(){                
        
        List<Account_Address__c> addressToUpdate = new List<Account_Address__c>();
        
        if(!accAddress.isEmpty()){
                accList[0].Ship_To_Address_Change__c = true;
        }
        else{
            newShipAdd.Is_Primary_Address__c = true;
        }
        try{            
            if(accList[0].stage__c != 'Authorized'){
                newShipAdd.status__c = 'Approved';                
            }
            else{
                 newShipAdd.status__c = 'Pending';
            }
            insert newShipAdd;  
            
            shipToAddressExist = true;          
            if(newShipAdd.Is_Primary_Address__c){
                for(Account_Address__c addr:[SELECT id from Account_Address__c WHERE account__c =: newShipAdd.account__c AND Is_Primary_Address__c = true and id !=: newShipAdd.id and type__c = 'Ship To Address']){
                    addr.Is_Primary_Address__c = false;
                    addressToUpdate.add(addr);
                }                
            }
            if(!addressToUpdate.isEmpty()){
                update addressToUpdate;
            }
            
            String accAddQuery = 'SELECT ';       
            accAddQuery += describeObjectFields('Account_Address__c');
            accAddQuery += ' FROM Account_Address__c WHERE account__c = ' + '\'' + accId + '\'' + ' AND Type__c = ' + '\'' + addType + '\''; 
            accAddress = database.query(accAddQuery);
            
            if(!accAddress.isEmpty()){
                for(Account_Address__c addr : accAddress){
                    if((addr.status__c == 'Pending' && accList[0].Stage__c == 'Authorized') || (addr.status__c == 'Approved' && accList[0].Stage__c != 'Authorized')){
                        pendingAddressCount = 1;
                        break;
                    }
                }
            }
            else{
                pendingAddressCount = 0;
            } 
            
            createNewShipToAdd = false;           
        }
        catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }        
    }
    
    public void cancelNewShipToAdd(){
        createNewShipToAdd = false;
        newShipAdd = new Account_Address__c();
    }
    
    public void retrieveExistingShipToAdd(){
            createNewContact = false;
            showAllContact = false;
            createNewContactPayable = false;
            retrieveExistingShipToAdd = true;
            createNewShipToAdd = false;
            showAllNonSoldToContacts = false;
            system.debug('existingShipToId-->'+existingShipToId);
            String accAddQuery = 'SELECT ';       
            accAddQuery += describeObjectFields('Account_Address__c');
            accAddQuery += ' FROM Account_Address__c WHERE account__c = ' + '\'' + accId + '\'' + ' AND Type__c = ' + '\'' + addType + '\'' + ' AND id = ' + '\'' + Id.valueOf(existingShipToId) + '\''; 
            existingShipTo = database.query(accAddQuery);
    }
    
    public void updateExistingShipTo(){
          
        List<Account_Address__c> addressToUpdate = new List<Account_Address__c>();      
        try{
            upsert existingShipTo;
            
            if(existingShipTo.Is_Primary_Address__c){
                for(Account_Address__c addr:[SELECT id from Account_Address__c WHERE account__c =: existingShipTo.account__c AND Is_Primary_Address__c = true and id !=: existingShipTo.id and type__c = 'Ship To Address']){
                    addr.Is_Primary_Address__c = false;
                    addressToUpdate.add(addr);
                }                
            }
            if(!addressToUpdate.isEmpty()){
                update addressToUpdate;
            }
            
            String accAddQuery = 'SELECT ';       
            accAddQuery += describeObjectFields('Account_Address__c');
            accAddQuery += ' FROM Account_Address__c WHERE account__c = ' + '\'' + accId + '\'' + ' AND Type__c = ' + '\'' + addType + '\''; 
            accAddress = database.query(accAddQuery);
            
            retrieveExistingShipToAdd = false;
        }
        catch(Exception e){            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));            
        }
    }
    
    public void cancelExistingShipTo(){
        retrieveExistingShipToAdd = false;
        existingShipTo = new Account_Address__c();
    }
    
    public PageReference save(){
        PageReference pg; 
        Approval.ProcessSubmitRequest req;
        try{   
            if(!accAddress.isEmpty()){                
                shipToAddressExist = true;
            }         
            
            if(!accPayableConList.isEmpty()){
                accPayableContactExist = true;
            }
            
            if(!conList.isEmpty()){
                soldToContactExist = true;
            }
            
            if(accList[0].Stage__c == 'Unqualified' && accList[0].Approval_Request__c == 'Promote to Qualified'){
                if(accList[0].SAP_Account_Number__c != null){
                    accList[0].Stage__c = 'Qualified';
                    accList[0].Approval_Status__c = 'Approved';
                }
                else{
                    req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting request for approval automatically using Trigger');
                    req.setObjectId(accId);        
                    Approval.ProcessResult result = Approval.process(req);
                    if(accList[0].market_segment__c == 'Testchip'){
                        accList[0].stage__c = 'Qualified';
                    }
                }
            }                    
            else{
                if(accList[0].Approval_Request__c != 'Ship To Address Change'){
                    req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting request for approval automatically using Trigger');
                    req.setObjectId(accId);        
                    Approval.ProcessResult result = Approval.process(req);
                }
            }
            
            
            if(newShipAdd != null && newShipAdd.id != null && accList[0].Stage__c == 'Authorized'){
                req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for Ship to Address approval automatically using Trigger');
                req.setObjectId(newShipAdd.id);        
                Approval.ProcessResult result = Approval.process(req);
            }  
                       
            accList[0].SAP_Form_Sent_To_OM__c = false;
            
            if((oldValueChemical != null && oldValueUSExport != null && oldValueMilitaryEndUser != null && oldValueRussiaOrUkraine != null
                && oldValueMissiles != null && oldValueNuclear != null && oldValueEmail != null && oldValueName != null && oldValueMilitaryUse != null)
                && (oldValueChemical != accList[0].Sold_To_Chemical_Biological_Sysytem__c || oldValueUSExport != accList[0].Sold_To_Is_Contrary_to_US_Export_Laws__c ||
                oldValueMilitaryEndUser != accList[0].Sold_To_Is_Military_End_User__c || oldValueRussiaOrUkraine != accList[0].Sold_To_Is_Related_to_Russia_or_Ukraine__c ||
                oldValueMissiles != accList[0].Sold_To_Missiles_Related_Activity__c || oldValueNuclear != accList[0].Sold_To_Nuclear_Fuel_Related_Activity__c ||
                oldValueEmail != accList[0].Sold_To_Proliferation_Info_By_Email__c || oldValueName != accList[0].Sold_To_Proliferation_Info_By_Name__c ||
                oldValueMilitaryUse != accList[0].Sold_To_Subject_to_Military_End_Use__c)
                ){
                
                accList[0].Sold_To_Address_Change__c = true;   
            }
            update accList[0];
            
            pg = new PageReference('/'+accId);            pg.setRedirect(true); return pg;                                              
        }
        catch(DMLException dme){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dme.getMessage());
            ApexPages.addMessage(myMsg);
            additionalInfoNeeded = false;
            return null;
        }
        catch(Exception e){
            ApexPages.Message myMsg;
            if(req.getComments().contains('Ship to Address')){
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This record does not meet the entry criteria or initial submitters of any active approval processes. Please look for the Approval Request value for adding new Ship To Address');
            }  
            else{         
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This record does not meet the entry criteria or initial submitters of any active approval processes. Please contact your administrator for assistance. Please look for the missing fields in Manage Approval Readiness section.');
            }
            ApexPages.addMessage(myMsg);
            additionalInfoNeeded = false;
            return null;
        }                
    }        
    
    public PageReference cancel(){
        PageReference pg = new PageReference('/'+accId);
        pg.setRedirect(true);
        return pg;
    }
        
    public void renderCountryTaxDetails(){
        if(accList[0].Bill_To_Country__c == 'Singapore'){
            sgtTaxDetails = true;
            usTaxDetails = false;
            billToCountry = 'Singapore';
        }
        else if(accList[0].Bill_To_Country__c == 'United States' || accList[0].Bill_To_Country__c == 'USA'){
            usTaxDetails = true;
            sgtTaxDetails = false;
            billToCountry = 'USA';
        }
    }
    
    public PageReference validateToDisplayAdditionalInfo(){
        PageReference pg;
        Account acc = [SELECT Fab_9_10__c,Stage__c,Approval_Request__c, Authorized_for_ASIC_business__c, SAP_Account_Number__c FROM Account WHERE id=: accId];
        acctStage = acc.stage__c;
        approvalRequest = acc.Approval_Request__c;
        sapAccountNumber = acc.SAP_Account_Number__c;
        
        if(((acc.Fab_9_10__c == 'No' || 
			 acc.Fab_9_10__c == null)  && 
			 (acc.Authorized_for_ASIC_business__c == 'No' || acc.Authorized_for_ASIC_business__c == null)) ||
            (acc.Approval_Request__c != 
			  'Account Details Change' && acc.Approval_Request__c != 'Ship To Address Change' && acc.stage__c == 'Authorized')){             
            try{                            
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval automatically using Trigger');
                req1.setObjectId(accId);        
                Approval.ProcessResult result = Approval.process(req1);
            
                return new PageReference('/'+accId).setRedirect(true);
            }
            catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This record does not meet the entry criteria or initial submitters of any active approval processes. Please contact your administrator for assistance. Please look for the missing fields in Manage Approval Readiness section.');
                ApexPages.addMessage(myMsg);
                additionalInfoNeeded = false;
                return null;                
            }  
        } 
        else{
            additionalInfoNeeded = true;
            return null;
        }       
    }
      
    public void makePrimaryAddress(){        
        List<Account_Address__c> primaryToUpdate = new List<Account_Address__c>();
        
        for(Account_Address__c addr:[SELECT id from Account_Address__c WHERE account__c =: accId AND Is_Primary_Address__c = true and id !=: Id.valueOf(primaryAddress) and type__c = 'Ship To Address']){
                    addr.Is_Primary_Address__c = false;
                    primaryToUpdate.add(addr);
        }
        
        try{            
            Account_Address__c aac = new Account_Address__c();
            aac.id = Id.valueOf(primaryAddress);
            aac.Is_Primary_Address__c = true;
            primaryToUpdate.add(aac);
            
            if(!primaryToUpdate.isEmpty()){
                update primaryToUpdate;
            }
            
            String accAddQuery = 'SELECT ';       
            accAddQuery += describeObjectFields('Account_Address__c');
            accAddQuery += ' FROM Account_Address__c WHERE account__c = ' + '\'' + accId + '\'' + ' AND Type__c = ' + '\'' + addType + '\''; 
            accAddress = database.query(accAddQuery);            
        }        
        catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(myMsg);
        }
    } 
    
    public void makePrimaryContact(){
        List<Contact> primaryContacts = new List<Contact>();
                    
        for(Contact con:[SELECT id from Contact WHERE accountid =: accId AND Is_Primary_Sold_to_Customer__c = true and id !=: Id.valueOf(primaryContact)]){
            con.Is_Primary_Sold_to_Customer__c = false;
            primaryContacts.add(con);
        } 
        
        try{
            Contact newCon = [SELECT role__c, Is_Primary_Sold_to_Customer__c from Contact WHERE id =: Id.valueOf(primaryContact)];                       
            newCon.Is_Primary_Sold_to_Customer__c = true;
            if(!newCon.role__c.contains('Sold To Customer')){
                newCon.role__c += ';Sold To Customer ';
            }
            primaryContacts.add(newCon);
            
            if(!primaryContacts.isEmpty()){
                update primaryContacts;
            } 
            
            String conQuery = 'SELECT ';       
            conQuery += describeObjectFields('Contact');
            conQuery += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + soldToConRole + '\'' + ')'; 
            conList = database.query(conQuery);                       
        }               
        catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(myMsg);
        }   
    }
    //Display all contacts
    public void showAllContacts(){
            showAllContact = true;
            createNewContact = false;
            retrieveExistingShipToAdd = false;
            createNewContact = false;        
            createNewShipToAdd = false;
            showAllNonSoldToContacts = false;
            String allConQuery = 'SELECT ';       
            allConQuery += describeObjectFields('Contact');
            allConQuery += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c excludes (' + '\'' + conRole + '\'' + ')'; 
            allContactList = database.query(allConQuery);
    }
    
    public void updateExisConToAccPayable(){
            showAllContact = false;
            List<Contact> contactsUpdate = new List<Contact>();
            
            try{                
                for(Contact con: [SELECT role__c,id from Contact WHERE accountId = : accId]){                                                            
                    String newRole = con.role__c; 
                    system.debug('newRole -->'+newRole);                   
                    if(String.valueOf(con.id).contains(selectedConForAccPayable)){
                        if(newRole.contains('Accounts Payable')){
                            if(newRole.contains(';')){
                                newRole = newRole.remove(';Accounts Payable');
                            }
                            else{
                                newRole = newRole.remove('Accounts Payable');
                            }
                            system.debug('newRole1 -->'+newRole);                             
                        }
                        if(!newRole.contains('Primary Accounts Payable')){
                            newRole += ';Primary Accounts Payable '; 
                            system.debug('newRole2 -->'+newRole);                            
                        }
                    }
                    else{
                        if(newRole.contains('Primary Accounts Payable')){
                            if(!newRole.contains(';Accounts Payable')){
                                newRole += ';Accounts Payable ';    
                                system.debug('newRole3 -->'+newRole);                             
                            }
                            newRole = newRole.remove('Primary Accounts Payable'); 
                            system.debug('newRole4 -->'+newRole);                            
                        }                        
                    }  
                    system.debug('newRole5 -->'+newRole); 
                    con.role__c = newRole; 
                    contactsUpdate.add(con);                 
                }                
                
                if(!contactsUpdate.isEmpty()){
                    update contactsUpdate;
                } 
                
                String conQuery1 = 'SELECT ';       
                conQuery1 += describeObjectFields('Contact');
                conQuery1 += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + conRole + '\'' + ')'; 
                accPayableConList = database.query(conQuery1);
                
                accPayableContactExist = true;                                      
            }               
            catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                    ApexPages.addMessage(myMsg);
            }   
    }
    
    public void newPrimaryAccPayForm(){
        createNewContactPayable = true;
        newConAccPayable = new Contact();
        if(accId != null){
            newConAccPayable.accountId = accId;
        }
        newConAccPayable.role__c = 'Primary Accounts Payable';
    }  
    
    public void cancelPrimaryAccPayCreation(){
        createNewContactPayable = false;
    }
    
    public void cancelPrimaryAccSelectCreate(){
        showAllContact = false;
        createNewContactPayable = false;
    } 
    
    public void newPrimaryAccPayCreation(){
        
        List<Contact> contactUpdate = new List<Contact>();
        try{
            List<Contact> redundantContact = [Select id 
											  from Contact 
											  where email =: newConAccPayable.email];
            if(redundantContact.isEmpty()){
               insert newConAccPayable;
            }
            else{ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Contact with same email address is already associated with this Account');
                ApexPages.addMessage(myMsg);      return;               
            }
            
            showAllContact = false;
            createNewContactPayable = false;
            accPayableContactExist = true;
            
            for(Contact con: [SELECT id, role__c from Contact WHERE accountid =: newConAccPayable.accountId AND role__c includes ('Primary Accounts Payable') and id !=: newConAccPayable.id]){                                                            
                    String newRole = con.role__c;                    
                                        
                    if(newRole.contains('Primary Accounts Payable')){
                        if(!newRole.contains(';Accounts Payable')){
                            newRole += ';Accounts Payable ';
                        }
                        newRole = newRole.remove('Primary Accounts Payable');
                    }                        
                     
                    con.role__c = newRole; 
                    contactUpdate.add(con);                 
            }
            
            if(!contactUpdate.isEmpty()){
                update contactUpdate;
            }
            
            String conQuery1 = 'SELECT ';       
            conQuery1 += describeObjectFields('Contact');
            conQuery1 += ' FROM Contact WHERE accountid = ' + '\'' + accId + '\'' + ' AND Role__c includes (' + '\'' + conRole + '\'' + ')'; 
            accPayableConList = database.query(conQuery1);
        }
        catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                    ApexPages.addMessage(myMsg);
            }
    }      
}