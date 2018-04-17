@isTest(seeAllData=false)
public class RMA_Invoice_Extension_Test{

    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
    
    public static testmethod void TestSearchInvoice(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            Invoice__c inv=[select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
            
            Test.setCurrentPage(Page.RMA_Invoice);    
            ApexPages.currentPage().getParameters().put('custName', acc.Customer_Number__c);
            ApexPages.currentPage().getParameters().put('fabName',inv.Fab_Group__c);
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));
            invextn.size=1;
            invextn.invoiceNumber=inv.Invoice_Number__c;
            invextn.lotNumber=inv.Lot_Name__c;
            invextn.rmaBy='Wafer';
            invextn.SearchInvoice();
            invextn.rmaBy='Die';
            invextn.SearchInvoice();
        Test.stopTest();
    }
    
    public static testmethod void TestInsertReturnInvoice1(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        Account acc = [select id from account limit 1];
                
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            
            Test.setCurrentPage(Page.RMA_Invoice);    
            RMA_Invoice_Extension invextn = new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn.rmaBy = 'Wafer';
            invextn.InsertReturnInvoice();
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));
            invextn.InsertReturnInvoice();
        Test.stopTest();
    }
     
    public static testmethod void TestInsertReturnInvoice2(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        Account acc = [select id,Customer_Number__c from account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            Invoice__c inv=[select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
            
            Test.setCurrentPage(Page.RMA_Invoice);    
            
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));
            
            List<SelectOption> rightoptions = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = RMA_Return_Invoice__c.Wafer_Id_CSR_Submission__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
            for( Schema.PicklistEntry f : ple)
                rightoptions.add(new SelectOption(f.getLabel(), f.getValue()));
             
            invextn.rightOptions=  rightoptions ; 
            
            ApexPages.currentPage().getParameters().put('custName', acc.Customer_Number__c);
            ApexPages.currentPage().getParameters().put('fabName',inv.Fab_Group__c);
            invextn.rmaBy='Wafer';
            
            invextn.InsertReturnInvoice();
        Test.stopTest();
    }
    
    public static testmethod void TestInsertReturnInvoiceDieBlankQty(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        Account acc = [select id,Customer_Number__c from account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            Invoice__c inv=[select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
            
            Test.setCurrentPage(Page.RMA_Invoice);    
            
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));
            
            List<SelectOption> rightoptions = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = RMA_Return_Invoice__c.Wafer_Id_CSR_Submission__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
            for( Schema.PicklistEntry f : ple)
                rightoptions.add(new SelectOption(f.getLabel(), f.getValue()));
             
            invextn.rightOptions=  rightoptions ; 
            
            ApexPages.currentPage().getParameters().put('custName', acc.Customer_Number__c);
            ApexPages.currentPage().getParameters().put('fabName',inv.Fab_Group__c);
            invextn.rmaBy='Die';
            invextn.dieQuantity = '';
            invextn.InsertReturnInvoice();
            invextn.dieQuantity = '5';
            invextn.waferYield = '5';
            invextn.adjustedPrice = '10';
            invextn.scrapLimit = '5';
            invextn.InsertReturnInvoice();
        Test.stopTest();
    }
    
    public static testmethod void TestInsertReturnInvoiceDieQty(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            
            Test.setCurrentPage(Page.RMA_Invoice);    
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));
            Invoice__c inv = [select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c,Unit_Selling_Price__c,Bill_Quantity__c,
                                Part_Number__c,Invoice_Date__c,Process_Name__c,Purchase_Order_Number__c,Die_Selling_Price__c
                              from Invoice__c limit 1];
            ApexPages.currentPage().getParameters().put('custName', acc.Customer_Number__c);
            ApexPages.currentPage().getParameters().put('fabName',inv.Fab_Group__c);
            
            List<SelectOption> rightoptions = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = RMA_Return_Invoice__c.Wafer_Id_CSR_Submission__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
            for( Schema.PicklistEntry f : ple)
                rightoptions.add(new SelectOption(f.getLabel(), f.getValue()));
            invextn.rightOptions=  rightoptions ; 
            invextn.rmaBy='Die';
            invextn.dieQuantity = '5';
            invextn.waferYield = '5';
            invextn.adjustedPrice = '10';
            invextn.scrapLimit = '5';
            invextn.InsertReturnInvoice();
        Test.stopTest();
    }
    
    public static testmethod void TestDeleteReturnInvoice(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            Invoice__c inv=[select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
        
            Test.setCurrentPage(Page.RMA_Invoice);    
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));
            invextn.RItoDelete=(String)rmainvrec.id;
            invextn.DeleteReturnInvoice();
            Integer c=[select count() from RMA_Return_Invoice__c];
            System.assertEquals(1,c);
        Test.stopTest();
    }
        
    public static testmethod void TestFetchDetail(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesAgere(1,acc);
        RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
        RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
        Invoice__c inv=[select id,Intercompany__c,Wafer_Id__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
        
        Test.setCurrentPage(Page.RMA_Invoice);    
        
        RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
        invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));  
        RMA_Invoice_Extension.InvoiceWrapper obj=new RMA_Invoice_Extension.InvoiceWrapper(inv,True,inv.Intercompany__c);
        invextn.selectedInvWrap=obj;
        invextn.lstInvoiceWrapperRecs.add(obj);
        invextn.FetchDetail(); 
        Test.stopTest();
     }
     
     
    public static testmethod void TestEditReturnInvoice(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesAgere(1,acc);
        RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
        RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
        Invoice__c inv=[select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
        
        Test.setCurrentPage(Page.RMA_Invoice);    
        
        RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
        invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));   
        invextn.RItoDelete=(String)rmainvrec.id;
        invextn.EditReturnInvoice();
        Test.stopTest();
    }
    
    public static testmethod void TestEditReturnInvoiceForFab9(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesAgere(1,acc);
        RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
        RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c = \'Fab 9\' limit 1');
        Invoice__c inv=[select id,Fab_Group__c,Invoice_Number__c,Lot_Name__c from Invoice__c where Id =: rmainvrec.Invoice__c limit 1];
        
        Test.setCurrentPage(Page.RMA_Invoice);    
        RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
        invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec));   
        invextn.RItoDelete=(String)rmainvrec.id;
        invextn.EditReturnInvoice();
        Test.stopTest();
    }
    
    public static testmethod void TestReturnToRMA(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
            
        Test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesAgere(1,acc);
        RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
        RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
        
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec)); 
            PageReference pg=invextn.ReturnToRMA();
            System.assert(True,pg.getURL().containsIgnoreCase('RMA_Edit')); 
        Test.stopTest(); 
    }  
    
    
    public static testmethod void TestWrapper(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
            
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
        
        Invoice__c inv=[select id,Intercompany__c,Unit_Selling_Price__c,Bill_Quantity__c,Part_Number__c,Invoice_Date__c,Invoice_Number__c,Lot_Name__c,Process_Name__c,
                        Purchase_Order_Number__c from Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
        
        Invoice__c invRec = new Invoice__c();
        invRec.Lot_Name__c = 'testLotTest';
        invRec.Fab_Code__c = 'FS1';
        invRec.Fab_Group__c = 'FAB 1';
        invRec.Bill_Quantity__c = 100;
        invRec.Customer_Name__c = [select id from Account limit 1][0].Id;
        invRec.GDPW__c = 1234;
        invRec.Invoice_Date__c = System.Today()-5;
        invRec.Invoice_Number__c = '999999';
        invRec.Item_Type__c = 'US';
        invRec.Part_Number__c = 'qwerty2';
        invRec.Process_Name__c = 'testProcess2';
        invRec.Purchase_Order_Number__c = 'PO12345';
        invRec.Sales_Order_Number__c = 'SO12345';
        invRec.Unit_Selling_Price__c = 100;
        invRec.Wafer_Id__c = '1;2;3;4;5';
        invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
        insert invRec;
        
            RMA_Invoice_Extension invextn=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            invextn= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec)); 
            RMA_Invoice_Extension.InvoiceWrapper obj=new RMA_Invoice_Extension.InvoiceWrapper(invRec,True,invRec.Intercompany__c);
            invextn.selectedInvWrap=obj;
            invextn.rmaBy = 'Die';
            invextn.waferYield='4';
            invextn.adjustedPrice='20.9';
            invextn.scrapLimit='21.3';
            
            List<SelectOption> rightoptions = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = RMA_Return_Invoice__c.Wafer_Id_CSR_Submission__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
            for( Schema.PicklistEntry f : ple)
                rightoptions.add(new SelectOption(f.getLabel(), f.getValue()));
             
            invextn.rightOptions=  rightoptions ;
            invextn.RItoDelete=rmainvrec.id; 
            invextn.InsertReturnInvoice();
        Test.stopTest();
    }
       
    public static testMethod void testPagination(){ 
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        Account acc = [select id,Customer_Number__c from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            RMA__c rmaRec1 = RMA_TestDataUtility.createRMAForFab9(1, acc); 
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec1, acc);
            RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c where Fab_Formula__c <> \'Fab 9\' limit 1');
            Invoice__c inv=[SELECT Id,Fab_Group__c,Intercompany__c,Unit_Selling_Price__c,Bill_Quantity__c,Part_Number__c,
                            Invoice_Date__c,Invoice_Number__c,Lot_Name__c,Process_Name__c,Purchase_Order_Number__c,Wafer_Id__c  
                        FROM Invoice__c where Id=: rmainvrec.Invoice__c limit 1];
            List<Invoice__c > listinv=new List<Invoice__c >();
            listinv.add(inv);
            
            RMA_Invoice_Extension p=new RMA_Invoice_Extension(new ApexPages.StandardController(new RMA_Return_Invoice__c()));
            p= new RMA_Invoice_Extension(new ApexPages.StandardController(rmainvrec)); 
            PageReference pageRef = Page.RMA_Invoice;  
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('custName', acc.Customer_Number__c);
            ApexPages.currentPage().getParameters().put('fabName',inv.Fab_Group__c);
            ApexPages.StandardSetController ctrl= new ApexPages.StandardSetController (listinv);
            
            p.getFormFactors();
            p.setCon=ctrl;
            p.getInvoiceWrapperRecords();
            p.Next();
            p.First();
            p.Last();
            p.Previous();
        Test.stopTest();
    }
}