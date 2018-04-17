/*
    Author: Yash Kumar
    Description: Test class for OppInformalQuoteItemMassEditController
    History:
        Yash 15062013    - Code Creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
            
*/


@isTest(seeAllData=false)
public class OppInformalQuoteItemMassEditTest{

   @testSetup static void testdata() {
       DataUtilTest.loadEnvironmentVariables();
       
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing501');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
        
        Map<String,Object> opportunityValueMap = new Map<String,Object>();
        opportunityValueMap.put('Name', 'Test Opportunity1'); 
        opportunityValueMap.put('AccountId', acc.Id); 
        opportunityValueMap.put('StageName', '1. Discovery'); 
        opportunityValueMap.put('CloseDate', Date.Today().addDays(10)); 
        opportunityValueMap.put('Target_Process_Node__c', '14XM'); 
        opportunityValueMap.put('Market_Segment__c', 'Mobility'); 
        opportunityValueMap.put('Process_Platform__c', 'GF Baseline'); 
        opportunityValueMap.put('Fab_Split__c', 100); 
        opportunityValueMap.put('Process_Geometry__c', '0.028UM'); 
        opportunityValueMap.put('Process_Family__c', 'Super Low Power'); 
        
        OpportunityDataFactory.createOpportunity(opportunityValueMap);
   }
   
    private static Account getAccount(string AccountName){
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
    private static Opportunity getOpportunity(String oppName) {
        Opportunity opp = [SELECT Id FROM Opportunity Where Name =: oppName];
        return opp;
    }

   static testMethod void doTestOppInformalQuoteItemMassEdit(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
        ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.id);
        fieldValueMap.put('Name','ABC');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');                
        fieldValueMap.put('Marketing_Recommendation__c','Recommend for Approval');
         
        Opportunity opp = getOpportunity('Test Opportunity1');
         
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
        try{
			Informal_Quote__c info11 = new Informal_Quote__c(Competitor1__c=comp.id,Yield_Commit__c='NO',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',List_Price__c=true,Budgetary_Quote_Status__c='Pending Approval Pricing'); 
			insert info11;
			
			Informal_Quote__c info4 = new Informal_Quote__c(Competitor1__c=comp1.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Total_Area_of_CPU__c=null,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Pending Approval Primary FAE'); 
			insert info4;
			
			Informal_Quote__c info9 = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp1.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft'); 
			insert info9;
        }
        catch(exception e){
            System.debug('ERROR:' + e);

        }
        
        Test.startTest();
		
		Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft',List_Price__c=true,Volume_break__c=true); 
        insert info;
        
        Informal_Quote__c info1 = new Informal_Quote__c(Competitor1__c=comp1.id,Yield_Commit__c='NO',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Pending Approval TE'); 
        insert info1;
       
        Informal_Quote__c info2 = new Informal_Quote__c(Competitor1__c=comp2.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Pending Approval Pricing'); 
        insert info2;
        
		Informal_Quote__c info3 = new Informal_Quote__c(Competitor1__c=comp2.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft'); 
        insert info3;
        
		Budgetary_Quote_Item__c qr1 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert qr1;       
        
		Budgetary_Quote_Item__c qr2 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info1.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 2), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert qr2;      
        
		Budgetary_Quote_Item__c qr3 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info2.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 3), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert qr3;
        
		Budgetary_Quote_Item__c qr4 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info3.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 3), List_Price__c = 100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert qr4;
        
		List<Budgetary_Quote_Item__c> qrList = new List<Budgetary_Quote_Item__c>(); 
        List<Budgetary_Quote_Item__c> sList = new List<Budgetary_Quote_Item__c>(); 
        slist.add(qr2);
        slist.add(qr3);
        slist.add(qr1);
        boolean chkvalid=false;
       
        Id qtrId = (Id)System.currentPageReference().getParameters().put('id',info2.id);
                
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(slist);        
        OppInformalQuoteItemMassEditController ctrl = new OppInformalQuoteItemMassEditController(stdSetController);
        stdSetController.setSelected(sList); 
        qrList = [select id,Sales_Requested_Price__c,Pricing_Approved_Price__c from Budgetary_Quote_Item__c where Budgetary_Quote__c=:info.id];
        ctrl.cancel();       
        /*ctrl.checkVisibility('System Administrator');
        ctrl.checkVisibility('GF Biz Ops Pricing');
        
        ctrl.checkVisibility('GF Integration');
        ctrl.checkVisibility('GF Finance'); */
        ctrl.checkVisibility('System Administrator');
        ctrl.checkVisibility('GF Biz Ops Pricing');
        ctrl.checkVisibility('GF Sales User');
        ctrl.checkVisibility('GF Finance');
       // ctrl.checkVisibility('GF Product Marketing');
        //ctrl.checkVisibility('GF Global Adminss');
        //system.debug('@@@@@@@@@@@@@@qtrId'+qtrId);
        List<Budgetary_Quote_Item__c> chklist;  
        chklist = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , 
        CreatedDate,Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c,
        name, Sales_Requested_Price__c, Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c,
        Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,
        Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,
        Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,
        Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,
        Budgetary_Quote__r.Competitor_2_Quarter__c from Budgetary_Quote_Item__c where Budgetary_Quote__c=:qtrId];
        
		ctrl.Save();
           
        List<Budgetary_Quote_Item__c> tlist = ctrl.getSelectedSorted();
        
        System.assert(tlist.size()==3);
        Budgetary_Quote_Item__c first = tlist.get(0);    
        
        first.Sales_Requested_Price__c=102;
        first.Pricing_Approved_Price__c=0; 
        update first;
        System.assert(first.Id == qr1.Id);
        Test.stopTest();
	}
    
    static Account createAccount() {
        // Create Account
        Account testAcct = getAccount('testing501');         
        return testAcct;
    }
    
    static Opportunity createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity 1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');                
        fieldValueMap.put('Marketing_Recommendation__c','Recommend for Approval');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }
    static Competitors__c createCompetitors() {
		Competitors__c comp = new Competitors__c();
		comp.Name='Test123456';
		comp.Order_Type__c='Wafer';
		Insert comp;
        
        return comp;
    }
    
	static Informal_Quote__c createInformalQuote(Id compid,Id OppId,Id testAcctId) {
        // Create InformalQuote
        Informal_Quote__c testInfo = new Informal_Quote__c();
        testInfo.Years_of_Product__c=1;
        testInfo.X1st_Product_Date__c=system.today();
        testInfo.Competitor1__c=compid;
        testInfo.Yield_Commit__c='YES';
        testInfo.Existing_Device__c='NO';
        testInfo.account__c=testAcctId;
        testInfo.Business_Deal_Proposal__c='Requote Existing Business';
        testInfo.Opportunity__c=OppId;
        testInfo.Product_Category__c='Wafer';
        testInfo.Process_Geometry__c='0.014UM';
        testInfo.Process_ID__c='100';
        testInfo.Budgetary_Quote_Status__c='Draft';
        testInfo.List_Price__c=true;
        testInfo.Volume_break__c=true;
        Insert testInfo;
        
        return testInfo;
    }
	
    static Informal_Quote__c createInformalQuote1(Id compid,Id OppId,Id testAcctId) {
        // Create InformalQuote
        Informal_Quote__c testInfo = new Informal_Quote__c();
        testInfo.Years_of_Product__c=1;
        testInfo.X1st_Product_Date__c=system.today();
        testInfo.Competitor1__c=compid;
        testInfo.Yield_Commit__c='YES';
        testInfo.Existing_Device__c='NO';
        testInfo.account__c=testAcctId;
        testInfo.Business_Deal_Proposal__c='Requote Existing Business';
        testInfo.Opportunity__c=OppId;
        testInfo.Product_Category__c='Wafer';
        testInfo.Process_Geometry__c='0.014UM';
        testInfo.Process_ID__c='100';
        testInfo.Budgetary_Quote_Status__c='Pending Approval Pricing';
        testInfo.List_Price__c=true;
        testInfo.Volume_break__c=true;
        Insert testInfo;
        
        return testInfo;
    }
    
	static Informal_Quote__c createInformalQuote2(Id compid,Id OppId,Id testAcctId) {
        // Create InformalQuote
        Informal_Quote__c testInfo = new Informal_Quote__c();
        testInfo.Years_of_Product__c=1;
        testInfo.X1st_Product_Date__c=system.today();
        testInfo.Competitor1__c=compid;
        testInfo.Yield_Commit__c='YES';
        testInfo.Existing_Device__c='NO';
        testInfo.account__c=testAcctId;
        testInfo.Business_Deal_Proposal__c='Requote Existing Business';
        testInfo.Opportunity__c=OppId;
        testInfo.Product_Category__c='Wafer';
        testInfo.Process_Geometry__c='0.014UM';
        testInfo.Process_ID__c='100';
        testInfo.Budgetary_Quote_Status__c='Pending Approval TE';
        testInfo.List_Price__c=true;
        testInfo.Volume_break__c=true;
        Insert testInfo;
        
        return testInfo;
    }
    
	static Budgetary_Quote_Item__c createBugInformalQuote(Id infoid) {
		Budgetary_Quote_Item__c qr1 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = infoid, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100);
		insert qr1;  
		return qr1;
    }
	
    static Budgetary_Quote_Item__c createBugInformalQuote1(Id infoid) {
		Budgetary_Quote_Item__c qr2 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = infoid, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 2), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200);
		insert qr2;  
		return qr2;
    }
    
	static testmethod void runTestInfo(){ 
        Test.startTest();
        try{
			Account acc = createAccount();
			Opportunity oppty = createOpportunity(acc.id);
			Competitors__c comp=createCompetitors();
			
			Informal_Quote__c Info=createInformalQuote(comp.id,oppty.id,acc.id);
			
			Budgetary_Quote_Item__c BudInfo=createBugInformalQuote(Info.id);
			
			List<Budgetary_Quote_Item__c> sList = new List<Budgetary_Quote_Item__c>(); 
			slist.add(BudInfo);
			
			info.Budgetary_Quote_Status__c='Pending Approval Pricing';
			Update info;
			
			boolean chkvalid=false;
		   
			Id qtrId = (Id)System.currentPageReference().getParameters().put('id',info.id);
					
			ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(slist);        
			OppInformalQuoteItemMassEditController ctrl = new OppInformalQuoteItemMassEditController(stdSetController);
			stdSetController.setSelected(sList); 
        }
        catch(exception e){
            System.debug('ERROR:' + e);

        }
        
        Test.stopTest();
    }  
    
	static testmethod void runTestInfo1(){ 
        Test.startTest();
        try{
			Account acc = createAccount();
			Opportunity oppty = createOpportunity(acc.id);
			Competitors__c comp=createCompetitors();
			
			Informal_Quote__c Info=createInformalQuote1(comp.id,oppty.id,acc.id);
			
			Budgetary_Quote_Item__c BudInfo=createBugInformalQuote1(Info.id);
			
			List<Budgetary_Quote_Item__c> sList = new List<Budgetary_Quote_Item__c>(); 
			slist.add(BudInfo);
			
			boolean chkvalid=false;
		   
			Id qtrId = (Id)System.currentPageReference().getParameters().put('id',info.id);
					
			ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(slist);        
			OppInformalQuoteItemMassEditController ctrl = new OppInformalQuoteItemMassEditController(stdSetController);
			stdSetController.setSelected(sList); 
        }
        catch(exception e){
            System.debug('ERROR:' + e);

        }
        
        Test.stopTest();
    }  
    static testmethod void runTestInfo2(){ 
        Test.startTest();
        try{
			Account acc = createAccount();
			Opportunity oppty = createOpportunity(acc.id);
			Competitors__c comp=createCompetitors();
			
			Informal_Quote__c Info=createInformalQuote2(comp.id,oppty.id,acc.id);
			
			Budgetary_Quote_Item__c BudInfo=createBugInformalQuote1(Info.id);
			
			List<Budgetary_Quote_Item__c> sList = new List<Budgetary_Quote_Item__c>(); 
			slist.add(BudInfo);
			
			info.Budgetary_Quote_Status__c='Pending Approval TE';
			Update info;
			
			boolean chkvalid=false;
		   
			Id qtrId = (Id)System.currentPageReference().getParameters().put('id',info.id);
					
			ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(slist);        
			OppInformalQuoteItemMassEditController ctrl = new OppInformalQuoteItemMassEditController(stdSetController);
			stdSetController.setSelected(sList); 
        }
        catch(exception e){
            System.debug('ERROR:' + e);
		}
        
        Test.stopTest();
    }  
    
    static testMethod void runTestInfo3(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
		ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
        
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
        Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft',List_Price__c=true,Volume_break__c=true); 
        insert info;
        
		Budgetary_Quote_Item__c qr1 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert qr1;       
        
        Budgetary_Quote_Item__c budgetaryQuoteItem = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=7, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 200,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=null,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert budgetaryQuoteItem;
        try{
            info.Budgetary_Quote_Status__c = 'Pending Approval TE';
            update info;
        }
        catch(Exception e){}
    }
    
    static testMethod void runTestInfo4(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
		ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
         
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
        Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft',List_Price__c=true,Volume_break__c=true); 
        insert info;
        
        List<Budgetary_Quote_Item__c> budgetaryQuoteItemList = new List<Budgetary_Quote_Item__c>();
        
        Budgetary_Quote_Item__c qr1 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=20, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 20,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        budgetaryQuoteItemList.add(qr1);       
        
        Budgetary_Quote_Item__c qr2 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=70, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 70,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        budgetaryQuoteItemList.add(qr2); 
        
        Budgetary_Quote_Item__c qr3 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=100, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        budgetaryQuoteItemList.add(qr3); 
        
        Budgetary_Quote_Item__c qr4 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=10, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 10,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        budgetaryQuoteItemList.add(qr4); 
        
        insert budgetaryQuoteItemList;
        
        info.Budgetary_Quote_Status__c = 'Pending Approval TE';
        //update info;
    }
    
    static testMethod void runTestInfo5(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
		ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
          
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
        Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='NO',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft',List_Price__c=true,Volume_break__c=true); 
        insert info;
        Budgetary_Quote_Item__c qr1 = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=0, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 100,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert qr1;       
        
        Budgetary_Quote_Item__c budgetaryQuoteItem = new Budgetary_Quote_Item__c(Budgetary_Quote__c = info.Id, Sales_Requested_Price__c=102, Pricing_Approved_Price__c=7, Start_Date__c= date.newinstance(2012, 4, 1), List_Price__c = 200,Competitors_1_Volume__c=100,Competitor_1_Price_US__c=200,Competitor_1_Complexity__c='200',Box_Score__c=200,cost__c=50,Yield_Commit_information_for_customer__c=100,Yield_Commit_information_for_Pricing__c=200,Yield_Commit_information_for_TE__c=100);
        insert budgetaryQuoteItem;
        try{
            info.Budgetary_Quote_Status__c = 'Pending Approval TE';
            update info;
        }
        catch(Exception e){}
    }
    
    static testMethod void runTestInfo6(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
		ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
          
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
       
        Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Pending Approval TE',List_Price__c=true,Volume_break__c=true); 
         try{
            insert info;
        }
        catch(Exception e){}
    }
    
    static testMethod void runTestInfo7(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
        ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
          
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
        Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Pending Approval Pricing',List_Price__c=true,Volume_break__c=true); 
        try{
            insert info;
        }
        catch(Exception e){}
        
    }
    
    static testMethod void runTestInfo8(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
		ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
          
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
		Test.startTest();
        
		Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft',List_Price__c=true,Volume_break__c=true); 
         
        info.X1st_Product_Date__c= date.newinstance(2016, 1, 1);
        insert info;
        //update info;
       
        List<Budgetary_Quote_Item__c> budgetaryQuoteItemList = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,           Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name, Sales_Requested_Price__c,Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c, Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,            Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c, Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,Budgetary_Quote__r.Budgetary_Quote_Status__c,                Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,Budgetary_Quote__r.Yield_Commit__c,             Budgetary_Quote__r.Competitor_2_Quarter__c,Budgetary_Quote__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =: info.Id];
        
        Integer i = 0;
        for(Budgetary_Quote_Item__c obj : budgetaryQuoteItemList){
            if(i == 0){
                obj.Pricing_Approved_Price__c = 100;
                obj.List_Price__c = 100;
            }
            else if(i == 1){
                obj.Pricing_Approved_Price__c = 70;
                obj.List_Price__c = 70;
            }
            else if(i == 2){
                obj.Pricing_Approved_Price__c = null;
                obj.List_Price__c = null;
            }
            else if(i == 3){
                obj.Pricing_Approved_Price__c = 50;
                obj.List_Price__c = 50;
            }
        }
        
        update budgetaryQuoteItemList;
        
        info.X1st_Product_Date__c = date.newinstance(2016, 6, 1);
        update info;
        Test.stopTest();
    }
    
    static testMethod void runTestInfo9(){ 

		insert new ConstantProcessGeometry__c(Name = '0.014UM', value__c = '14NM'); 
        
		ProfileName__c settings = new ProfileName__c();
        ProfileName__c settings1 = new ProfileName__c();
        ProfileName__c settings2 = new ProfileName__c();
        ProfileName__c settings3 = new ProfileName__c();
            
        settings = new ProfileName__c();
        settings.name ='System Administrator';
        settings.ProfileAccess__c = 'E';
        
        settings1 = new ProfileName__c();
        settings1.name ='GF Biz Ops Pricing';
        settings1.ProfileAccess__c = 'P';
        
        settings2 = new ProfileName__c();
        settings2.name ='GF Sales User';
        settings2.ProfileAccess__c = 'S';
        
        settings3 = new ProfileName__c();
        settings3.name ='GF Finance';
        settings3.ProfileAccess__c = 'F';
        
        Account_Team_Roles__c roless = new Account_Team_Roles__c();
        roless.name='ROLE_PRIMARY_FIELD_ENGINEER';
        roless.Role__c='Field Application Engineer';
        insert roless ;
        
        Insert settings;
        Insert settings1;
        Insert settings2;
        Insert settings3;
                
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Account_Team_Roles__c(Name = 'ROLE_PRIMARY_FIELD_ENGINEER', Role__c = 'Field Application Engineer'));
        database.insert(listSObj, false);        
            
        Account acc= getAccount('testing501'); 
        
        Opportunity opp = getOpportunity('Test Opportunity1');
          
        Competitors__c comp= new Competitors__c(Name='test156413',Order_Type__c='Wafer');
        insert comp;
        Competitors__c comp1= new Competitors__c(Name='test256413',Order_Type__c='Wafer');
        insert comp1;
        Competitors__c comp2= new Competitors__c(Name='test356413',Order_Type__c='Wafer');
        insert comp2;
        
        Test.startTest();
        Informal_Quote__c info = new Informal_Quote__c(Years_of_Product__c=1,X1st_Product_Date__c=system.today(),Competitor1__c=comp.id,Yield_Commit__c='YES',Existing_Device__c='NO',account__c=acc.id,Business_Deal_Proposal__c='Requote Existing Business',Opportunity__c=opp.id,Product_Category__c='Wafer',Process_Geometry__c='0.014UM',Process_ID__c='100',Budgetary_Quote_Status__c='Draft',List_Price__c=true,Volume_break__c=true); 
         
        info.X1st_Product_Date__c= date.newinstance(2016, 1, 1);
        insert info;
        //update info;
       
        List<Budgetary_Quote_Item__c> budgetaryQuoteItemList = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,           Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name, Sales_Requested_Price__c,Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c, Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,            Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c, Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,Budgetary_Quote__r.Budgetary_Quote_Status__c,                Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,Budgetary_Quote__r.Yield_Commit__c,             Budgetary_Quote__r.Competitor_2_Quarter__c,Budgetary_Quote__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =: info.Id];
        
        Integer i = 0;
        for(Budgetary_Quote_Item__c obj : budgetaryQuoteItemList){
            obj.Yield_Commit_information_for_customer__c = 100;
            obj.Competitors_1_Volume__c = 100;
            obj.Competitor_1_Complexity__c = 'test';
            obj.Competitor_1_Price_US__c = 100;
            
            obj.Yield_Commit_information_for_Pricing__c = 100;
            obj.Pricing_Approved_Price__c = NULL;
        }
        
        update budgetaryQuoteItemList;
        
        info.X1st_Product_Date__c = date.newinstance(2016, 6, 1);
        info.Budgetary_Quote_Status__c = 'Pending Approval Pricing';
        info.Competitor1__c = NULL;
        info.List_Price__c = FALSE;
        info.Yield_Commit__c = 'NO';
        
        try{
            update info;
        }
        catch(Exception e){}
        
        i = 0;
        for(Budgetary_Quote_Item__c obj : budgetaryQuoteItemList){
            obj.Yield_Commit_information_for_customer__c = 100;
            obj.Competitors_1_Volume__c = 100;
            obj.Competitor_1_Complexity__c = 'test';
            obj.Competitor_1_Price_US__c = 100;
            
            obj.Yield_Commit_information_for_Pricing__c = 100;
            obj.Pricing_Approved_Price__c = 0;
        }
        
        //update budgetaryQuoteItemList;
        
        info.X1st_Product_Date__c = date.newinstance(2016, 6, 1);
        info.Budgetary_Quote_Status__c = 'Pending Approval Pricing';
        info.Competitor1__c = NULL;
        info.List_Price__c = FALSE;
        info.Yield_Commit__c = 'NO';
        
        try{
            update info;
        }
        catch(Exception e){}
        
        Test.stopTest();
    }
}