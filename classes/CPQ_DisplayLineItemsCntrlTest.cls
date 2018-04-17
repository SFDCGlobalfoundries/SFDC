/*
    Author: Shivam Sharma
    Description: This Class serves as the Test class for the "CPQ_DisplayProposalLineItemsController" and "CPQ_DisplayProposalAttributesController" classes
        Shivam     06132017    - Code creation.
        Shiva Karna 03052018 - Updated code for handling line item and device code coverage
*/ 
@isTest(SeeAllData=false)
public class CPQ_DisplayLineItemsCntrlTest{
    static Apttus_Proposal__Proposal__c config;
    static Product2 ParentProduct;
    static Apttus_Config2__PriceList__c plist;
    
    @testVisible static List<CPQ_PDF_Fields__mdt> customMetadata { 
    get {
        if ( customMetadata == null )
            customMetadata = [ SELECT DeveloperName,MasterLabel,OrderOfFields__c,Value__c FROM CPQ_PDF_Fields__mdt ]; 
        return customMetadata;
    } set; }
    
     @testSetup 
     static void testDataSetup1(){
     DataUtilTest.loadEnvironmentVariables();
     }
        static void testDataSetup(){
        
        Id acc = createAccount();
        Opportunity opp = createOpp(acc);
        Opportunity_Program__c oppProg = createOppProg(acc,opp.Id);
        Device__c dev = createDevice(acc, opp.Id, oppProg.Id);  
        
        plist = new Apttus_Config2__PriceList__c(Name = 'Test Price List', Apttus_Config2__Active__c = true, Apttus_Config2__Type__c = 'Standard'); 
        insert plist;
        
        config = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Approval_Stage__c='Draft',Apttus_Proposal__Opportunity__c=opp.id,
        Device__c=dev.id,Apttus_Proposal__Proposal_Name__c = 'Test Configuration', Apttus_QPConfig__PriceListId__c = plist.Id);//,RecordTypeId = recType.Id
        insert config;
        
        ParentProduct = new Product2(Name = 'Test Process Technology', Product_External_ID__c = 'Test Process Technology', Family = 'PTs'); 
        insert ParentProduct;
    }
    public static testmethod void test_CPQ_DisplayProposalLineItems(){        
        testDataSetup();
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            Apttus_Proposal__Proposal_Line_Item__c pli1 = new Apttus_Proposal__Proposal_Line_Item__c();
            pli1.Option_Section_Name_Static__c = 'Test Section';
            pli1.Option_Product_Family_Static__c = 'Devices';
            pli1.Apttus_Proposal__Proposal__c = config.id;
            pli1.Apttus_Proposal__Product__c = ParentProduct.id;
            pli1.Option_Name_Static__c = 'Option 1';
            
            Apttus_Proposal__Proposal_Line_Item__c pli2 = new Apttus_Proposal__Proposal_Line_Item__c();
            pli2.Option_Section_Name_Static__c = 'Test Section';
            pli2.Option_Product_Family_Static__c = 'Devices';
            pli2.Apttus_Proposal__Proposal__c = config.id;
            pli2.Apttus_Proposal__Product__c = ParentProduct.id;
            pli2.Option_Name_Static__c = 'Option 2';
            
            lstPLI.add(pli1);
            lstPLI.add(pli2);
        try{
            insert lstPLI;
        }catch(Exception ex){
            System.assert(FALSE, 'Insertion of proposalLineItems failed! '+ex.getMessage());
        }
        PageReference pageRef = Page.CPQ_DisplayProposalLineItems;
        pageRef.getParameters().put('id', null);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(config);
        CPQ_DisplayProposalLineItemsController controllerInstance = new CPQ_DisplayProposalLineItemsController(sc);
    
        pageRef.getParameters().put('id', String.valueOf(config.Id));
        Test.setCurrentPage(pageRef);
        controllerInstance = new CPQ_DisplayProposalLineItemsController(sc);
    }
    //Static method to create Account test record
static id createAccount(){
     Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT'); 
        fieldValueMap.put('stage__c', 'Unqualified');                          
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore'); 
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');              
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('short_name__c','TAC');

        return AccountDataFactory.createAccount(fieldValueMap).id;  
    }
    public static Opportunity createOpp(Id acctId){
            Opportunity opp = new Opportunity(Name = 'Test Opportunity',AccountId = acctId,StageName = '1. Discovery',
                                              Market_Segment__c = 'Automotive',Target_Process_Node__c = '14XM', Process_Platform__c = 'GF Baseline',Opportunity_Sourcing_Type__c = 'First Source',Fab_Split__c = 100,
                                              CloseDate = date.newinstance(2012, 12, 21),Process_Geometry__c = '0.014UM',Fab_Assignment_1__c = 'FAB 1',Process_Family__c = 'Super Low Power');
            insert opp;
            return opp;
    }
     //Static method to create Opportunity Program test record
    public static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
            Opportunity_Program__c opProg = 
                        new Opportunity_Program__c(Name = 'Test OppProg',Account__c = acctId,Opportunity__c = oppId);
            insert opProg;
            return opProg;
        }
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
    
    RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Internal Device' And
                                     SobjectType = 'Device__C'];
    Device__c dev = new Device__c(Name = 'TESTDEVICE1313',Stage__c = 'Design In',
                                          Status__c = 'Active',Account__c = accId,Opportunity2__c = oppId,Opportunity_Program__c = oppProgId, Market_Segment__c = 'Automotive',Semiconductor_Device__c = 'Analog Regulator',End_Application__c = 'Body',Device_Sourcing__c = '3rd Source',ITAR_Flag__c='TBD',Is_ITAR__c='Need to check ITAR/RED Zone status',Secure_Device__c='No',Secure_Device_Level__c='Not Applicable',
                                          Tapeout_Type__c = 'Single Product',Siebel_Device_ID__c = '0987654321',
                                          IP_Gap__c = false,Requested_from_Configuration__c = true,Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                                          Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                                          Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                                          Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                                          Confidence_Level_Tapeout__c = '100',IP_Declaration_User_Ids__c = userinfo.getuserid() ,
                                          Fab__c = 'Fab 3');//,recordtypeid=recType.id);
     insert dev;
     return dev;    
    }    
            
    public static testmethod void test_CPQ_DisplayAttributes(){
        testDataSetup();
        
        Test.startTest();
        
        Id cartId = addBundleToCart(config.ID, ParentProduct.ID);
        System.assert(cartId<>NULL, 'Cart creation unsuccessful!');
      
        Apttus_Config2__ProductAttributeGroup__c attibuteGroup = new Apttus_Config2__ProductAttributeGroup__c(Name = 'Solutioning', Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c');
        insert attibuteGroup;
        Apttus_Config2__ProductAttribute__c attribute = new Apttus_Config2__ProductAttribute__c(Apttus_Config2__AttributeGroupId__c = attibuteGroup.Id, Apttus_Config2__Field__c = 'Die_Size_X_mm__c', Apttus_Config2__Sequence__c = 1);
        insert attribute;
        Apttus_Config2__ProductAttribute__c attribute1 = new Apttus_Config2__ProductAttribute__c(Apttus_Config2__AttributeGroupId__c = attibuteGroup.Id, Apttus_Config2__Field__c = 'Die_Size_Y_mm__c', Apttus_Config2__Sequence__c = 2);
        insert attribute1;
        Apttus_Config2__ProductAttributeGroupMember__c groupMember = new Apttus_Config2__ProductAttributeGroupMember__c(Apttus_Config2__AttributeGroupId__c = attibuteGroup.Id, Apttus_Config2__ProductId__c = ParentProduct.Id, Apttus_Config2__Sequence__c = 1);
        insert groupMember;
              
        Apttus_Config2__ProductConfiguration__c ConfigProd = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c=config.id,Apttus_Config2__BusinessObjectId__c=config.id,
        Apttus_Config2__Status__c = 'Finalized');
        Insert ConfigProd;
        
        Apttus_Config2__PriceListItem__c plitem= new Apttus_Config2__PriceListItem__c(Apttus_Config2__ProductId__c=ParentProduct.id,
                    Apttus_Config2__ChargeType__c='Standard Price',apttus_Config2__PriceListId__c=plist.id);
        insert plitem;
    
        Apttus_Proposal__Proposal_Line_Item__c  ApLine = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=config.id,
        Apttus_QPConfig__ItemSequence__c=1,
        Apttus_QPConfig__LineNumber__c=2,
        Apttus_QPConfig__ConfigurationId__c=ConfigProd.id,
        Apttus_QPConfig__PriceListId__c=plist.id,
        Apttus_QPConfig__PriceListItemId__c=plitem.id,Apttus_QPConfig__LineType__c = 'Product/Service');
        insert ApLine;
        
        Apttus_Config2__LineItem__c n = new Apttus_Config2__LineItem__c(
        Apttus_Config2__ProductId__c=ParentProduct.id,
        Apttus_Config2__ConfigurationId__c=ConfigProd.id,
        Apttus_Config2__ItemSequence__c=1,
        Apttus_Config2__LineNumber__c=2,
        Apttus_Config2__PriceListId__c=plist.id,
        Apttus_Config2__LineType__c='Product/Service',
        Apttus_Config2__LineStatus__c='New',Apttus_Config2__PriceType__c='One Time',
        Apttus_Config2__Description__c='test',Apttus_Config2__ClassificationHierarchy__c='GLOBALFOUNDRIES Offering | 40nm',
        Apttus_Config2__Quantity__c=1,Apttus_Config2__IsQuantityModifiable__c=true,Apttus_Config2__Frequency__c='One Time',
        Apttus_Config2__SellingFrequency__c='One Time',Apttus_Config2__BasePriceMethod__c='Per Unit',
        Apttus_Config2__SellingTerm__c=1,
        Apttus_Config2__Term__c=1,Apttus_Config2__AllowRemoval__c=true,Apttus_Config2__AllocateGroupAdjustment__c=true,
        Apttus_Config2__PriceListItemId__c = plitem.id,
        Apttus_Config2__Uom__c='Each',
        Apttus_Config2__RollupPriceMethod__c='Per Unit',Apttus_Config2__AllowManualAdjustment__c=true,
        Apttus_Config2__AllowableAction__c='Unrestricted',        
        Apttus_Config2__Customizable__c=true,Apttus_Config2__ConfigStatus__c='Complete',
        Apttus_Config2__ConstraintCheckStatus__c='Complete',Apttus_Config2__PriceMethod__c='Per Unit',
        Apttus_Config2__PrimaryLineNumber__c=98,Apttus_Config2__IsPrimaryLine__c=true,
        Apttus_Config2__ParentBundleNumber__c=2 ,Apttus_Config2__PricingStatus__c='Complete',
        Apttus_Config2__SyncStatus__c='Synchronized');
        
        Insert N;
    
        Apttus_Config2__ProductAttributeValue__c ApPrdInser = new Apttus_Config2__ProductAttributeValue__c(Bumping_for_FC__c='OSAT', Bump_Opening_Needed__c=true,
        Die_Size_X_mm__c=20,Die_Size_Y_mm__c=20,
        Die_Thickness_in_package__c='ss',Package_Type__c='FC-PBGA (Lid)',Apttus_Config2__LineItemId__c = N.id,
        Die_Size_is_Pre_Shrink_Post_Rotation__c='post shrink and pre rotation');
        Insert ApPrdInser;
                
        PageReference pageRef = Page.CPQ_DisplayProposalAttributes;
        pageRef.getParameters().put('id', null);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(config);
        system.debug(''+sc);
        CPQ_DisplayProposalAttributesController controllerInstance = new CPQ_DisplayProposalAttributesController(sc);
    
    
        pageRef.getParameters().put('id', String.valueOf(config.Id));
        Test.setCurrentPage(pageRef);
        controllerInstance = new CPQ_DisplayProposalAttributesController(sc);
        CPQ_DisplayProposalAttributesController.allattributeDetails c1 = new CPQ_DisplayProposalAttributesController.allattributeDetails('ITAR','ITAR');    
        Test.stopTest();
    }
    public static Id addBundleToCart(Id proposalID, Id bundleProductID){
        if([Select Apttus_QPConfig__PriceListId__c from Apttus_Proposal__Proposal__c where Id = :proposalID].Apttus_QPConfig__PriceListId__c == null){
            System.debug('@@@@@@@@@@ Proposal.Apttus_QPConfig__PriceListId__c --> null : no price list assigned to Proposal '+ proposalID);
            return null;
        }
        Id cartId = createCart(proposalID);
        if(cartId != null && bundleProductID != null){
            addBundleToExistingCart(cartId, bundleProductID);
        }
        return cartId;
    }
    public static Id createCart(Id proposalID){
        if(proposalId == null)
            return null;
        Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
            request.QuoteId = proposalID;
        Apttus_CPQApi.CPQ.CreateCartResponseDO response = Apttus_CPQApi.CPQWebService.createCart(request);
            System.debug('@@@@@@@@@@@@@@@@ Cart Id  = '+response.CartId);
        return response.CartId;
    }
    public static boolean addBundleToExistingCart(Id cartId, Id bundleProductID){
        Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
                request.CartId = cartId;
                request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
                request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
                request.SelectedBundle.SelectedProduct.ProductId = bundleProductID;
                request.SelectedBundle.SelectedProduct.Quantity = 1;
                request.SelectedBundle.SelectedProduct.Comments = 'Product '+bundleProductID+', Added to Cart '+cartId+', through Custom Apex';
                    System.debug('@@@@@@@@@@@@@ Product '+bundleProductID+', Added to Cart '+cartId+', through Custom Apex');
                request.SelectedBundle.SelectedOptions = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();//null;
                
            Apttus_CPQApi.CPQ.AddBundleResponseDO response = Apttus_CPQApi.CPQWebService.addBundle(request);
            System.debug('@@@@@@@@@@ Apttus_CPQApi.CPQ.AddBundleResponseDO response : response.LineNumber = '+response.LineNumber);
            if(response.LineNumber != null)
                return finalizeCart(cartId);
        return false;
    }
    public static Boolean saveCart(Id cartId){
        try{
            fireConstraintRules(cartId);
            Apttus_Config2__ProductConfiguration__c cart = [Select id, Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where id=: cartId];
            cart.Apttus_Config2__Status__c = 'Saved';
            update cart;
            return true;
        }catch(Exception ex){
            System.debug('@@@@@@@@@@@@@@ Exception encounterred while trying to update the status of the cart with id = '+cartId);
            return false;
        }
    }
    public static Boolean finalizeCart(Id cartId){
        try{
            Apttus_Config2__ProductConfiguration__c cart = [Select id, Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where id=: cartId];
            cart.Apttus_Config2__Status__c = 'Finalized';
            update cart;
            return true;
        }catch(Exception ex){
            System.debug('@@@@@@@@@@@@@@ Exception encounterred while trying to update the status of the cart with id = '+cartId);
            return false;
        }
    }
    public static void fireConstraintRules(Id cartID){
        Apttus_CPQApi.CPQWebService.associateConstraintRules(cartID, null);
        // For rules that are not marked as Check on Finalization
        Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, false);
    }
}