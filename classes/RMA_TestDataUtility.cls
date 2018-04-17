/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class acts as a utility class for creating test data related to RMA.
 * History:
 *    SurendranadhNune 09022016  -   Created.
 *                            
 **/
@isTest(seeAllData=false)
public class RMA_TestDataUtility {
    
    public static List<RMA_Return_Invoice__c> createRMAReturnInvoice(RMA__c rmaRec, Account acc){
         
         List<RMA_Return_Invoice__c> rmaRIList = new List<RMA_Return_Invoice__c>();
         Invoice__c inv = createInvoices(1, acc)[0];
         RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
         rmaRI.rma__c = rmaRec.id;
         rmaRI.invoice__c = inv.id;
         rmaRI.Lot_Number__c = inv.lot_name__c;
         rmaRI.manufacturing_lot__c = inv.Manufacturing_Lot__c;
         rmaRI.Bill_Quantity__c = 20;
         rmaRI.Device__c = 'testDevice'; 
         rmaRI.Invoice_Number__c = '123456';
         rmaRI.Invoice_Date__c = System.Today()-5;
         rmaRI.Purchase_Order_Number__c = 'PO12345';
         rmaRI.Process__c = 'testProcess';
         rmaRI.Scrap_Limit__c = 29;
         rmaRI.Wafer_Die_Unit_Price__c = 50;
         rmaRI.Wafer_Id_CSR_Submission__c = '1;2;3;4;5';
         rmaRI.Wafer_Yield__c = 50;
         rmaRIList.add(rmaRI);
         insert rmaRIList;
         return rmaRIList;
    }
    
    public static List<RMA_Return_Invoice__c> createRMAReturnInvoice1Million(RMA__c rmaRec, Account acc){
         
         List<RMA_Return_Invoice__c> rmaRIList = new List<RMA_Return_Invoice__c>();
         Invoice__c inv = createInvoices1Million(1, acc)[0];
         RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
         rmaRI.rma__c = rmaRec.id;
         rmaRI.invoice__c = inv.id;
         rmaRI.Lot_Number__c = inv.lot_name__c;
         rmaRI.manufacturing_lot__c = inv.Manufacturing_Lot__c;
         rmaRI.Bill_Quantity__c = 20;
         rmaRI.Device__c = 'testDevice2'; 
         rmaRI.Invoice_Number__c = '789789789';
         rmaRI.Invoice_Date__c = System.Today()-5;
         rmaRI.Purchase_Order_Number__c = 'PO12345';
         rmaRI.Process__c = 'testProcess';
         rmaRI.Scrap_Limit__c = 29;
         rmaRI.Wafer_Die_Unit_Price__c = 1000000;
         rmaRI.Wafer_Id_CSR_Submission__c = '1;2;3;4;5';
         rmaRI.Wafer_Yield__c = 50;
         rmaRI.Fab_Group__c = inv.Fab_Group__c;
         rmaRI.RMA_By__c = 'Wafer';
         rmaRIList.add(rmaRI);
         insert rmaRIList;
         return rmaRIList;
    }
    
    public static List<RMA_Return_Invoice__c> createRMAReturnInvoiceForFab9(RMA__c rmaRec, Account acc){
         
         List<RMA_Return_Invoice__c> rmaRIList = new List<RMA_Return_Invoice__c>();
         Invoice__c inv = createInvoicesForFab9(1, acc)[0];
         RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
         rmaRI.rma__c = rmaRec.id;
         rmaRI.invoice__c = inv.id;
         rmaRI.Lot_Number__c = inv.lot_name__c;
         rmaRI.Fab_Group__c = 'FAB 9';
         rmaRI.manufacturing_lot__c = inv.Manufacturing_Lot__c;
         rmaRI.Bill_Quantity__c = 20;
         rmaRI.Device__c = 'testDevice'; 
         rmaRI.Invoice_Number__c = '123456';
         rmaRI.Invoice_Date__c = System.Today()-5;
         rmaRI.Purchase_Order_Number__c = 'PO12345';
         rmaRI.Process__c = 'testProcess';
         rmaRI.Scrap_Limit__c = 29;
         rmaRI.Wafer_Die_Unit_Price__c = 50;
         rmaRI.Wafer_Id_Fab_9_10_CSR_Submission__c = '1;2;3;4;5';
         rmaRI.Wafer_Qty_Fab_9_10_CSR_Submission__c = 5;
         rmaRI.Wafer_Yield__c = 50;
         rmaRI.RMA_By__c = 'Wafer';
         rmaRIList.add(rmaRI);
         insert rmaRIList;
         return rmaRIList;
    }
    
    public static List<RMA_Return_Invoice__c> createRMAReturnInvoiceOld(RMA__c rmaRec, Account acc){
         
         List<RMA_Return_Invoice__c> rmaRIList = new List<RMA_Return_Invoice__c>();
         Invoice__c inv = createInvoicesOld(1, acc)[0];
         RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
         rmaRI.rma__c = rmaRec.id;
         rmaRI.invoice__c = inv.id;
         rmaRI.Lot_Number__c = inv.lot_name__c;
         rmaRI.manufacturing_lot__c = inv.Manufacturing_Lot__c;
         rmaRI.Bill_Quantity__c = 20;
         rmaRI.Device__c = 'testDevice'; 
         rmaRI.Invoice_Number__c = '123456';
         rmaRI.Invoice_Date__c = System.Today()-400;
         rmaRI.Purchase_Order_Number__c = 'PO12345';
         rmaRI.Process__c = 'testProcess';
         rmaRI.Scrap_Limit__c = 29;
         rmaRI.Wafer_Die_Unit_Price__c = 50;
         rmaRI.Wafer_Id_CSR_Submission__c = '1;2;3;4;5';
         rmaRI.Wafer_Yield__c = 50;
         rmaRIList.add(rmaRI);
         insert rmaRIList;
         return rmaRIList;
    }
    
    public static List<RMA_Return_Invoice__c> createRMAReturnInvoiceForFab7(RMA__c rmaRec, Account acc){
         
         List<RMA_Return_Invoice__c> rmaRIList = new List<RMA_Return_Invoice__c>();
         Invoice__c inv = createInvoicesForFab7(1, acc)[0];
         RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
         rmaRI.rma__c = rmaRec.id;
         rmaRI.invoice__c = inv.id;
         rmaRI.Lot_Number__c = inv.lot_name__c;
         rmaRI.manufacturing_lot__c = inv.Manufacturing_Lot__c;
         rmaRI.Bill_Quantity__c = 20;
         rmaRI.Device__c = 'testDevice'; 
         rmaRI.Invoice_Number__c = '123456';
         rmaRI.Invoice_Date__c = System.Today()-5;
         rmaRI.Purchase_Order_Number__c = 'PO12345';
         rmaRI.Process__c = 'testProcess';
         rmaRI.Scrap_Limit__c = 29;
         rmaRI.Wafer_Die_Unit_Price__c = 50;
         rmaRI.Wafer_Id_CSR_Submission__c = '1;2;3;4;5';
         rmaRI.Wafer_Yield__c = 50;
         rmaRIList.add(rmaRI);
         insert rmaRIList;
         return rmaRIList;
    }
    
    public static List<RMA_Vendor_Code__c> createRMAVendorCode(String lotNo){
        List<RMA_Vendor_Code__c> lstRMAVendorCode = new List<RMA_Vendor_Code__c>();
        RMA_Vendor_Code__c rmaVendorCode = new RMA_Vendor_Code__c(Fab_Group__c='FAB 7',Lot_Id__c=lotNo,Wafer_Id_DW__c=lotNo+'.11',Unique_Field__c=lotNo+'-'+lotNo+'.11');
        lstRMAVendorCode.add(rmaVendorCode);
        insert lstRMAVendorCode;
        return lstRMAVendorCode;
    }
   
   public static Account createAccount(){
        
        Account acc= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'TEST rec');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Lee');                
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        fieldValueMap.put('short_name__c', 'TESTrec');
        fieldValueMap.put('Customer_Number__c', '10101');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueMap.put('financial_territory__c', 'Japan Korea');
        //fieldValueMap.put('Copy_Address__c', 'true');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
        acc= AccountDataFactory.createAccount(fieldValueMap);
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential';
        update acc;
        
        /*Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact; */
        
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 5];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = ulist[0].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );            
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                User__c = ulist[1].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Customer Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(
                User__c = ulist[2].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Backup Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        Account_Team_Proxy__c atp4 = new Account_Team_Proxy__c(
                User__c = ulist[3].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Field Application Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        
        List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp2,atp3,atp4};             
        insert atps;
        
        acc.Approval_Request__c = 'Promote to Authorized';
        acc.Approval_Status__c='Approved';
        update acc;
            
        acc.Stage__c = 'Authorized';
        acc.Copy_Address__c = false;
        update acc;
        
        return acc;            
   }
   
   public static Account createAccountForFab9(){
        
        Account acc= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'TEST rec Fab 9');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');
        fieldValueMap.put('Corporate_City__c', 'Lee');                
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        fieldValueMap.put('short_name__c', 'TESTrecfab9');
        fieldValueMap.put('Customer_Number__c', '10100');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueMap.put('financial_territory__c', 'Japan Korea');
        //fieldValueMap.put('Copy_Address__c', 'true');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
        acc= AccountDataFactory.createAccount(fieldValueMap);
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential';
        update acc;
        
        /* Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact; */
        
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 5];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = ulist[0].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );            
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                User__c = ulist[1].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Backup Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(
                User__c = ulist[2].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Field Application Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        Account_Team_Proxy__c atp4 = new Account_Team_Proxy__c(
                User__c = ulist[3].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Customer Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        
        List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp2,atp3,atp4};             
        insert atps;
        
        acc.Approval_Request__c = 'Promote to Authorized';
        acc.Approval_Status__c='Approved';
        update acc;
            
        acc.Stage__c = 'Authorized';
        acc.Copy_Address__c = false;
        update acc;
        
        return acc;
   }
   
   public static RMA__c createRMA(Integer no, Account acc){
        RMA__c rmaRec = new RMA__c();
        rmaRec.Fab__c = 'FAB 1';
        rmaRec.Customer__c = acc.Id;
        rmaRec.RMA_By__c = 'Wafer';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        insert rmaRec;
        return rmaRec;
    }
    
    public static RMA__c createRMAForFab9(Integer no, Account acc){
        RMA__c rmaRec = new RMA__c();
        rmaRec.Fab__c = 'FAB 9';
        rmaRec.Customer__c = acc.Id;
        rmaRec.RMA_By__c = 'Wafer';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.Product_Line__c = 'RF';
        rmaRec.Business_Unit__c = 'RF';
        rmaRec.Business_Category__c = 'ASIC';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.ReasonCode__c = 'R20';
        insert rmaRec;
        return rmaRec;
    }
    
    public static RMA__c createRMAForFab7(Integer no, Account acc){
        RMA__c rmaRec = new RMA__c();
        rmaRec.Fab__c = 'FAB 7';
        rmaRec.Customer__c = acc.Id;
        rmaRec.RMA_By__c = 'Wafer';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        insert rmaRec;
        return rmaRec;
    }
    
    public static List<RMA_Attachment__c> createRMAAttachment(RMA__c rmaRec){
        List<RMA_Attachment__c> lstRMAAttch = new List<RMA_Attachment__c>();
        //for resoure links
        //for RMA Info section
        RMA_Attachment__c rmaInfoLnk = new RMA_Attachment__c(Resource_URL__c = 'test info',Description__c = 'test desc',RMA__c = rmaRec.Id,Section__c = 'RMA Information');
        lstRMAAttch.add(rmaInfoLnk);
        
        ContentVersion doc1 = new ContentVersion();
        string before = 'Testing base 64 encode'; 
        Blob beforeblob = Blob.valueOf(before);
        doc1.Title = 'title';
        doc1.PathOnClient = 'title.txt';
        doc1.VersionData = beforeblob;
        insert doc1;
        
        RMA_UploadAttachmentsAndLinksExtn.insertRMAAttachment(rmaRec.id, (String)doc1.Id, RMA_Constants.RMA_INFORMATION, doc1.PathOnClient);
        
        //for Disposition of Wafer
        RMA_Attachment__c rmaDOWLnk = new RMA_Attachment__c(Resource_URL__c = 'test DOW',Description__c = 'test desc',RMA__c = rmaRec.Id,Section__c = 'Disposition of Wafers');
        lstRMAAttch.add(rmaDOWLnk);
        
        ContentVersion doc2 = new ContentVersion();
        doc2.Title = 'title';
        doc2.PathOnClient = 'title.txt';
        doc2.VersionData = beforeblob;
        insert doc2;
        
        RMA_UploadAttachmentsAndLinksExtn.insertRMAAttachment(rmaRec.id, (String)doc2.Id, RMA_Constants.DISPOSITION_OF_WAFER, doc2.PathOnClient);
        
        //for Techical Validation
        RMA_Attachment__c rmaTVLnk = new RMA_Attachment__c(Resource_URL__c = 'test TV',Description__c = 'test desc',RMA__c = rmaRec.Id,Section__c = 'Technical Validation');
        lstRMAAttch.add(rmaTVLnk);
        
        ContentVersion doc3 = new ContentVersion();
        doc3.Title = 'title';
        doc3.PathOnClient = 'title.txt';
        doc3.VersionData = beforeblob;
        insert doc3;
        
        RMA_UploadAttachmentsAndLinksExtn.insertRMAAttachment(rmaRec.id, (String)doc3.Id, RMA_Constants.TECHNICAL_VALIDATION, doc3.PathOnClient);
        
        insert lstRMAAttch;
        
        return lstRMAAttch;
    }
    
    public static void createRMAccessUser(String rmaId){
        List<RMA_Access_User__c> accessList = new List<RMA_Access_User__c>();
        accessList.add(new RMA_Access_User__c(RMA__c=rmaId,User__c=userInfo.getUserId(),Category__c='Notify/Circulate'));
        accessList.add(new RMA_Access_User__c(RMA__c=rmaId,User__c=userInfo.getUserId(),Category__c='Non Fab'));
        accessList.add(new RMA_Access_User__c(RMA__c=rmaId,User__c=userInfo.getUserId(),Category__c='Return Wafer'));
        accessList.add(new RMA_Access_User__c(RMA__c=rmaId,User__c=userInfo.getUserId(),Category__c='Scrap Certificate'));
        accessList.add(new RMA_Access_User__c(RMA__c=rmaId,User__c=userInfo.getUserId(),Category__c='Fab'));
        accessList.add(new RMA_Access_User__c(RMA__c=rmaId,User__c=userInfo.getUserId(),Category__c='Turnkey'));
        insert accessList;
    }
    
   public static List<Invoice__c> createInvoices(Integer no, Account acc){
        List<Manufacturing_Lot__c> mfLots = createManufacturingLots(1);
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=1; i<=no; i++){
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot' + i;
            invRec.Fab_Code__c = 'FS1';
            invRec.Fab_Group__c = 'FAB 1';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            invoiceList.add(invRec);
        }
        insert invoiceList;
        return invoiceList;
    }
    
    public static List<Invoice__c> createInvoices1Million(Integer no, Account acc){
        //List<Manufacturing_Lot__c> mfLots = createManufacturingLots(1);
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=1; i<=no; i++){
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLotMil' + i;
            invRec.Fab_Code__c = 'FS1';
            invRec.Fab_Group__c = 'FAB 1';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '789789789';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 1000000;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            invoiceList.add(invRec);
        }
        insert invoiceList;
        return invoiceList;
    }
    
    public static List<Invoice__c> createInvoicesForFab9(Integer no, Account acc){
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=1; i<=no; i++){
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot' + i;
            invRec.Fab_Code__c = 'FS9';
            invRec.Fab_Group__c = 'FAB 9';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            invoiceList.add(invRec);
        }
        insert invoiceList;
        return invoiceList;
    }
    
    public static List<Invoice__c> createInvoicesOld(Integer no, Account acc){
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=1; i<=no; i++){
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot' + i;
            invRec.Fab_Code__c = 'FS9';
            invRec.Fab_Group__c = 'FAB 9';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-400;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            invoiceList.add(invRec);
        }
        insert invoiceList;
        return invoiceList;
    }
    
    public static List<Invoice__c> createInvoicesForFab7(Integer no, Account acc){
        List<Manufacturing_Lot__c> mfLots = createManufacturingLotsForFab7(1);
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=1; i<=no; i++){
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot' + i;
            invRec.Fab_Code__c = 'FS7';
            invRec.Fab_Group__c = 'FAB 7';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            invoiceList.add(invRec);
        }
        insert invoiceList;
        return invoiceList;
    }
    
   public static List<Manufacturing_Lot__c> createManufacturingLots(Integer no){
        List<Manufacturing_Lot__c> mfLots = new List<Manufacturing_Lot__c>();
        for(Integer i=1; i<=no; i++){
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Manufacturing_Lot_Id__c = 'testLot' + i;
            mfgLot.Fab_Code__c = 'FS1';
            mfLots.add(mfgLot);
        }
        insert mfLots;
        return mfLots;
    }
    
    public static List<Manufacturing_Lot__c> createManufacturingLotsForFab7(Integer no){
        List<Manufacturing_Lot__c> mfLots = new List<Manufacturing_Lot__c>();
        for(Integer i=1; i<=no; i++){
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Manufacturing_Lot_Id__c = 'testLot' + i;
            mfgLot.Fab_Code__c = 'FS7';
            mfLots.add(mfgLot);
        }
        insert mfLots;
        return mfLots;
    }
    
    public static Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [SELECT p.Id from ProcessInstanceWorkitem p
                                                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId
                                                  AND p.ProcessInstance.Status = 'Pending'])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    //Agere Customer methods
    public static List<Manufacturing_Lot__c> createManufacturingLotsAgere(Integer no){
        List<Manufacturing_Lot__c> mfLots = new List<Manufacturing_Lot__c>();
        for(Integer i=1; i<=no; i++){
            Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
            mfgLot.Manufacturing_Lot_Id__c = 'testLotAgere' + i;
            mfgLot.Fab_Code__c = 'FS5';
            mfLots.add(mfgLot);
        }
        insert mfLots;
        return mfLots;
    }
    
    public static List<Invoice__c> createInvoicesAgere(Integer no, Account acc){
        List<Manufacturing_Lot__c> mfLots = createManufacturingLotsAgere(1);
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=1; i<=no; i++){
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLotAgere' + i;
            invRec.Fab_Code__c = 'FS5';
            invRec.Fab_Group__c = 'FAB 5';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            invoiceList.add(invRec);
        }
        insert invoiceList;
        return invoiceList;
    }
    
    public static List<RMA_Return_Invoice__c> createRMAReturnInvoiceAgere(RMA__c rmaRec, Account acc){
         
         List<RMA_Return_Invoice__c> rmaRIList = new List<RMA_Return_Invoice__c>();
         Invoice__c inv = createInvoicesAgere(1, acc)[0];
         RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
         rmaRI.rma__c = rmaRec.id;
         rmaRI.invoice__c = inv.id;
         rmaRI.Lot_Number__c = inv.lot_name__c;
         rmaRI.manufacturing_lot__c = inv.Manufacturing_Lot__c;
         rmaRI.Bill_Quantity__c = 20;
         rmaRI.Device__c = 'testDevice'; 
         rmaRI.Invoice_Number__c = '123456';
         rmaRI.Invoice_Date__c = System.Today()-5;
         rmaRI.Purchase_Order_Number__c = 'PO12345';
         rmaRI.Process__c = 'testProcess';
         rmaRI.Scrap_Limit__c = 29;
         rmaRI.Wafer_Die_Unit_Price__c = 50;
         rmaRI.Wafer_Id_CSR_Submission__c = '1;2;3;4;5';
         rmaRI.Wafer_Yield__c = 50;
         rmaRIList.add(rmaRI);
         insert rmaRIList;
         return rmaRIList;
                    
    }
    
    public static RMA__c createRMAAgere(Integer no, Account acc){
        RMA__c rmaRec = new RMA__c();
        rmaRec.Fab__c = 'FAB 5';
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Customer__c = acc.Id;
        rmaRec.RMA_By__c = 'Wafer';
        rmaRec.Customer_Request_Date__c = System.TODAY();
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        insert rmaRec;
        return rmaRec;
    }
    
    //Create Agere Account
    public static Account createAccountAgere(){
        
        Account acc= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'AVAGO test');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');
        fieldValueMap.put('Corporate_City__c', 'Lee');                
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        fieldValueMap.put('short_name__c', 'agere');
        fieldValueMap.put('Customer_Number__c', '10156');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueMap.put('financial_territory__c', 'Japan Korea');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
        acc= AccountDataFactory.createAccount(fieldValueMap);
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential';
        update acc;
        
        Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact;
        
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 5];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = ulist[0].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test2'
            );            
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                User__c = ulist[1].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Customer Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(
                User__c = ulist[2].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Field Application Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        Account_Team_Proxy__c atp4 = new Account_Team_Proxy__c(
                User__c = ulist[3].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Backup Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
            
        List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp2,atp3,atp4};
        insert atps;
        
        acc.Approval_Request__c = 'Promote to Authorized';
        acc.Approval_Status__c='Approved';
        update acc;
            
        acc.Stage__c = 'Authorized';
        acc.Copy_Address__c = false;
        update acc;
        
        return acc;
   }
   
   //test data for RMA_EmailNotification__c
   public static RMA_EmailNotification__c createEmailNotification(String Name, String AccessImpact, String BusinessCategory, 
                                                                  String ccAddress, String DispositionOfWafer, String Fab, 
                                                                  String OldStage, String NewStage, String template, String toAddress, 
                                                                  Integer reminder, Boolean attachment){
        RMA_EmailNotification__c rmaEmail = new RMA_EmailNotification__c();
        rmaEmail.Name = Name;
        rmaEmail.Access_Impact__c = AccessImpact;
        rmaEmail.Business_Category__c = BusinessCategory;
        rmaEmail.CC_Address__c = ccAddress;
        rmaEmail.Disposition_of_Wafers__c = DispositionOfWafer;
        rmaEmail.Fab__c = Fab;
        rmaEmail.Old_Workflow_Stage__c = OldStage;
        rmaEmail.New_Workflow_Stage__c = NewStage;
        rmaEmail.Template_Name__c = template;
        rmaEmail.TO_address__c = toAddress;
        rmaEmail.Reminder_Number__c = reminder;
        rmaEmail.Is_Active__c = true;
        rmaEmail.Attachment__c = attachment;
        insert rmaEmail;
        return rmaEmail;
   }
   
}