/*
    Type Name: RefFlowDataLoad
    Author: Prosenjit Saha 
    Created Date: 2nd-June-2014
    Reason: This class is used to automate Reference Flow data load
    Change History:
    Author: 
    Modified Date: 
    Reason: 
    ……..
    ……..
    
*/

public class RefFlowDataLoad{
    public List<String> PTnumberList = new List<String>(); //This list contains PT numbers. Used for extract configurable products from SFDC database. 
    
    public List<Product2> ListBundleProduct = new List<Product2>(); //This List contains configurable products extracted on the basis of the PTnumberList. 
    
    //Map<Key= External ID of the classification hierarchy , Value= classification hierarchy record>: used to build relationship between child classification hierarchies.
    public Map<String,Apttus_Config2__ClassificationHierarchy__c> MapClassification = new Map<String,Apttus_Config2__ClassificationHierarchy__c>();
    
    //List contains Reference flow related products to be inserted as the options of reference flow.
    public List<Product2> ListProduct = new List<Product2>();
    
    public Map<String,String> CustomMapRefFlow = new Map<String,String>(); // *key=Ref flow name *value = ref flow type. This map is created from the custom settings.(requried reference flows)
    
    public Map<String,Product2> ParentProdMap = new Map<String,Product2>(); //*key= external id of configurable products *value= configurable products
    
    //*** not required---- public Map<String,List<Product2>> MapParentVsRefFlow = new Map<String,List<Product2>> (); // *key= Product ext ID of configurable products *value = List of the RF products
    
    public Map<String,Product2> MapPTnumvsConfigProd = new  Map<String,Product2> ();// *Key= PT number of the Config products | *value= config products
    
    
    /***
    This is the method will be called from schedulable class to automate the data loading batch process. 
        
        @method name: configRefFlow
        @parameter:   NA
        @return :     none
    ***/    
    public void configRefFlow(){
        
        List<Reference_Flow_List__c> CustomRefFlow = Reference_Flow_List__c.getall().values();  //List of reference flows: get from custom settings 
        List<String> RefFlowTypes = new List<String>{'Digital Reference Flow', 'AMS Reference Flow', 'White Paper'}; //All the reference flow types from the custom settings: "AMS reference flow", "Digital Reference Flow", "white Paper"
        //Set<String>  RefFlowTypesSet = new Set<String>(); //to get unique reference flow types
        
        
        //get information from the custom settings
        for(Reference_Flow_List__c refflow : CustomRefFlow){
            CustomMapRefFlow.put(refflow.name,refflow.Reference_Flow_Type__c);
            /*
            if(!RefFlowTypesSet.contains(refflow.Reference_Flow_Type__c)){
                RefFlowTypes.add(refflow.Reference_Flow_Type__c);
            }
            RefFlowTypesSet.add(refflow.Reference_Flow_Type__c); */
        } 
        
        
        
        system.debug('Prosenjit:Debug::***test custom settings-->>'+RefFlowTypes);
        system.debug('Prosenjit:Debug::***test custom settings-->>CustomMapRefFlow'+CustomMapRefFlow);
        
        //Map of Tech files to get the reference flow details. 
        Map<String,Tech_File__c> TechFileMap = new Map<String,Tech_File__c>();
        
        //Map of Design Specs: *Key: design spec name and *value: design spec record. 
        Map<String,Design_Spec__c> SpecMap = new Map<String,Design_Spec__c>();
        
        //get tech files and desgin specs related to the required reference flows
        if(CustomMapRefFlow != NULL){
            for( Tech_File__c techfiles:[SELECT     id,
                                                    Name,
                                                    Design_Manual__c,
                                                    Doc_Rev__c,
                                                    Document_Title__c,
                                                    Lifecycle__c,
                                                    EDA_Tool_Supported__c,
                                                    PT_Number__c,
                                                    Specification_Type__c,
                                                    Spice_Model_Type__c,
                                                    Technology_Geometry__c,
                                                    Technology_Type__c,
                                                    Compatible_PT__c,
                                                    IP_Vendor__c
                                        FROM        Tech_File__c
                                        WHERE       NAME
                                        IN          :CustomMapRefFlow.KeySet()
                                        order by    name]){
                TechFileMap.put(techfiles.Name, techfiles);
            }
            for(Design_Spec__c desSpec : [SELECT    id,
                                                    name,
                                                    Description__c,
                                                    PDK_Version__c
                                          FROM      Design_Spec__c
                                          WHERE     Name
                                          IN        :CustomMapRefFlow.KeySet()]){
                SpecMap.put(desSpec.name,desSpec);          
            }
        }
        system.debug('Prosenjit Debug:::SpecMap'+SpecMap);
        
        //Product map: Key: PT number of the required Reference flows, value: inserted/updated product of the reference flows used to create options for reference flow.
        Map<String,Product2> RefFlowProdMap = new Map<String,Product2>();
        
        //Create/update reference flow products and get the RefFlowProdMap as return value
        RefFlowProdMap  =   insertProduct (TechFileMap.values(),SpecMap);
        
        //list of IDs of the bundle/ config proudcts related to the reference flow.
        List<ID> BundleProductID = new List<ID>(); 
        
        system.debug('Prosenjit Debug:::RefFlowProdMap######'+RefFlowProdMap);
        
        ListBundleProduct =     [SELECT         id,
                                                name,
                                                ProductCode,
                                                Family,
                                                Apttus_Config2__ConfigurationType__c,
                                                PT_Number__c,
                                                Product_External_ID__c
                                 FROM           Product2
                                 WHERE          Apttus_Config2__ConfigurationType__c = 'Bundle' 
                                 AND            PT_Number__c 
                                 IN             :PTnumberList]; 
        if(ListBundleProduct.size()>0){
            /*
            for(Product2 Prod : ListBundleProduct){
                ParentProdMap.put(prod.Product_External_ID__c,Prod);
                if(RefFlowProdMap.keySet().contains(Prod.PT_Number__c)){
                    if(!MapParentVsRefFlow.keySet().contains(Prod.Product_External_ID__c)){
                        List<Product2> tempProd = new List<Product2>();
                        tempProd.add(RefFlowProdMap.get(Prod.PT_Number__c));
                        MapParentVsRefFlow.put(Prod.Product_External_ID__c,tempProd);
                    }
                    else{
                        MapParentVsRefFlow.get(Prod.Product_External_ID__c).add(RefFlowProdMap.get(Prod.PT_Number__c));
                    }
                }       
            }
            */
            //create MapPTnumvsConfigProd and BundleProductID.
            for(Product2 Prod : ListBundleProduct){
                MapPTnumvsConfigProd.put(Prod.PT_Number__c,Prod);
                BundleProductID.add(Prod.ID);
            }
        }
        
        system.debug('Prosenjit::debug:::: MapPTnumvsConfigProd'+MapPTnumvsConfigProd);
        //ListProduct   = RefFlowProdMap.values();
        system.debug('prosenjit debug:::ListProduct'+ListProduct);
        
        //call insertCategoryStructure method to insert/update entire category structure in the browse catalog and configurator.
        insertCategoryStructure (RefFlowTypes,CustomMapRefFlow,ListProduct);
        
        //Call insertProductOptionComponent method to insert/update all the relationships between reference flow options(products) and catagor
        insertProductOptionComponent(RefFlowTypes);
        
        //Insert/update ALL the reference flow products in the price lists available so that they can apear in the browse catalog.
        insertPriceList(ListProduct);
        
        //Update product icons to display icons in the browse catalog.
        updateIcons(ListProduct);
        
        //Upsert Compare records.
        upsertCompareReferenceFlow(ListProduct,TechFileMap,SpecMap);
        
        //Automate batch jobs after insert/update all the reference flow data. ****YET TO GET INFORMATION FROM APTTUS*****
        runBatchJob(BundleProductID);
    }
    
    /***
    This is the method insert/update reference flow related products
        
        @method name: insertProduct
        @parameter:   List of Tech files and map of the PT number vs spec record.
        @return :     Map of PT number vs products of the inserted/updated reference flows.
    ***/
    public Map<String,Product2> insertProduct(List<Tech_File__c> TechFileList, Map<String,Design_Spec__c> SpecMap ){
        //Map of PT number vs products of the inserted/updated reference flows.
        Map<String,Product2> RefFlowProdMap = new Map<String,Product2>();
        
        //prepare reference flow products to create and update reference flows.
        for(Tech_File__c tfile : TechFileList){
            PTnumberList.add(tfile.PT_Number__c);
            Product2 tempProd= new Product2();
                tempProd.Name                                   =   tfile.Document_Title__c;                
                tempProd.Product_External_ID__c                 =   tfile.Name;
                tempProd.ProductCode                            =   tfile.Name;
                tempProd.PT_Number__c                           =   tfile.PT_Number__c;
                tempProd.Description__c                         =   SpecMap.get(tfile.name).Description__c;
                tempProd.Description                            =   SpecMap.get(tfile.name).Description__c;
                tempProd.Family                                 =   'RF';
                tempProd.IP_PT_ID__c                            =   tfile.Id;
                tempProd.IsActive                               =   true;
                tempProd.Apttus_Config2__ConfigurationType__c   =   'Option';
                tempProd.Apttus_Config2__HasAttributes__c       =   false;
                tempProd.Apttus_Config2__HasDefaults__c         =   false;
                tempProd.Apttus_Config2__HasOptions__c          =   false;
                tempProd.Apttus_Config2__HasSearchAttributes__c =   false;
                tempProd.Apttus_Config2__Customizable__c        =   false;
                tempProd.Apttus_Config2__Uom__c                 =   'Each'; 
                tempProd.Geometry__c                            =   tfile.Technology_Geometry__c.subString(0,7);
            ListProduct.add(tempProd);
            if(tfile.PT_Number__c != NULL){
                RefFlowProdMap.put(tfile.PT_Number__c,tempProd);
            }
        }
        system.debug('Prosenjit::debug:::Productlistsize'+ListProduct.size());
        
        //create/update reference flow related products.
        if(ListProduct.size()>0){
            try{
                upsert  ListProduct Product_External_ID__c;
                system.debug('PS Debug::::InsertProductList'+ListProduct);
            }
            catch(exception e){}
            return RefFlowProdMap;
        }
        else{
            return NULL;
        }       
    }   
    
    
    /***
    This is the method insert/update reference flow Catagory structure inside browse catalog.
        
        @method name: insertCategoryStructure
        @parameter:   1. List of reference flow types
                      2. CustomMapRefFlow: *key=Ref flow name *value = ref flow type.
                      3. List of referencce flow products. 
        @return :     none
    ***/
    public void insertCategoryStructure(List<String> RefFlowTypes, Map<String,String> CustomMapRefFlow, List<Product2> ListProduct){
        //get the Parent catagory record:'GLOBALFOUNDRIES Offering'
        Apttus_Config2__ClassificationName__c gfofferingCategory =  [SELECT     id,
                                                                                name,
                                                                                Category_External_ID__c
                                                                       FROM     Apttus_Config2__ClassificationName__c
                                                                       WHERE    Category_External_ID__c = 'GLOBALFOUNDRIES Offering'
                                                                       LIMIT    1];
        //get the Parent catagory hierarchy record:'GLOBALFOUNDRIES Offering'                                                                       
        Apttus_Config2__ClassificationHierarchy__c gfofferingCategoryHierarchy = [SELECT    id,
                                                                                            name,
                                                                                            Category_Hierarchy_External_ID__c,
                                                                                            Apttus_Config2__Right__c
                                                                                   FROM     Apttus_Config2__ClassificationHierarchy__c
                                                                                   WHERE    Category_Hierarchy_External_ID__c = 'GLOBALFOUNDRIES Offering'
                                                                                   LIMIT    1];
        String RefName  ='Reference Flow'; //RefName variable will be used throughout the implementation.
        
        //get the 'right' count of the 'GLOBALFOUNDRIES Offering'. This will be used to arrange reference flow structure in the expected order.
        Integer CategoryHierarchyLeft   = Integer.valueOf(gfofferingCategoryHierarchy.Apttus_Config2__Right__c);
        
        //Map of reference flow type and category hierarchy. 
        Map<string,Apttus_Config2__ClassificationHierarchy__c> RefTypeMap = new Map<string,Apttus_Config2__ClassificationHierarchy__c>();
        
        //Map of category name and category hierarchy. This will be used to create category hierarchy for config products. 
        Map<String,Apttus_Config2__ClassificationName__c> ClassificationName = new Map<String,Apttus_Config2__ClassificationName__c>();
        
        /**********************************Step 2*************************************/
        //insert reference flow category for all the products
        for(Product2 prod : ListBundleProduct){
            Apttus_Config2__ClassificationName__c tempCategory = new Apttus_Config2__ClassificationName__c();
                tempCategory.Apttus_Config2__Active__c          =   TRUE;
                tempCategory.Category_External_ID__c            =   prod.Product_External_ID__c+'_'+RefName;
                tempCategory.Apttus_Config2__HierarchyLabel__c  =   RefName;    
                tempCategory.Name                               =   prod.Product_External_ID__c+'_'+RefName;
                tempCategory.Apttus_Config2__Type__c            =   'Option Group';
            ClassificationName.put(tempCategory.Category_External_ID__c,tempCategory);
        }
        try{
            upsert ClassificationName.values() Category_External_ID__c;
            system.debug('PS Debug:: ClassificationName'+ClassificationName.values());
        }
        catch(exception e){}
        
        /**********************************Step 3*************************************/
        //insert Category Hierarchy for all products of Reference flow
        List<Apttus_Config2__ClassificationHierarchy__c> ListCatHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
        for(Product2 prod : ListBundleProduct){
            Apttus_Config2__ClassificationHierarchy__c TempHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
                TempHierarchy.Category_Hierarchy_External_ID__c         = prod.Product_External_ID__c+'_'+RefName;
                TempHierarchy.Apttus_Config2__Label__c                  = RefName ;
                TempHierarchy.Name                                      = prod.Product_External_ID__c+'_'+RefName;
                TempHierarchy.Apttus_Config2__AncestorId__c             = null;
                TempHierarchy.Apttus_Config2__PrimordialId__c           = null;
                TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c      = FALSE;
                TempHierarchy.Apttus_Config2__HierarchyId__c            = ClassificationName.get(prod.Product_External_ID__c+'_'+RefName).id;
                TempHierarchy.Apttus_Config2__IncludeInTotalsView__c    = TRUE;
                TempHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
                TempHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;                    
                TempHierarchy.Apttus_Config2__HideAllSearchFilters__c   = FALSE;
                TempHierarchy.Apttus_Config2__Level__c                  = 0;
                TempHierarchy.Apttus_Config2__Left__c                   = 1;
                TempHierarchy.Apttus_Config2__MaxOptions__c             = 99;
                TempHierarchy.Apttus_Config2__MinOptions__c             = 1;
                TempHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
                TempHierarchy.Apttus_Config2__Right__c                  = 2*RefFlowTypes.size() + 2 ;
            System.debug('Prosenjit Debug:: child Hierarchy check from products*****************'+TempHierarchy);
            ListCatHierarchy.add(TempHierarchy);    
            MapClassification.put(prod.Product_External_ID__c+'_'+RefName, TempHierarchy);
        }
        try{
            upsert MapClassification.values() Category_Hierarchy_External_ID__c;
        }
        catch(exception e){}
        
        /**********************************Step 4*************************************/
        //insert Reference Flow under Globalfoundries Offering--- 
        integer countleft = 1;
        Apttus_Config2__ClassificationHierarchy__c RefFlowHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
            RefFlowHierarchy.Category_Hierarchy_External_ID__c         = RefName;
            RefFlowHierarchy.Apttus_Config2__Label__c                  = RefName;
            RefFlowHierarchy.Name                                      = RefName;
            RefFlowHierarchy.Apttus_Config2__AncestorId__c             = gfofferingCategoryHierarchy.id;
            RefFlowHierarchy.Apttus_Config2__PrimordialId__c           = gfofferingCategoryHierarchy.id;
            RefFlowHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
            RefFlowHierarchy.Apttus_Config2__ExpandedByDefault__c      = FALSE;
            RefFlowHierarchy.Apttus_Config2__HierarchyId__c            = gfofferingCategory.id;
            RefFlowHierarchy.Apttus_Config2__IncludeInTotalsView__c    = TRUE;
            RefFlowHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
            RefFlowHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
            RefFlowHierarchy.Apttus_Config2__Level__c                  = 0;
            RefFlowHierarchy.Apttus_Config2__Left__c                   = CategoryHierarchyLeft;
            RefFlowHierarchy.Apttus_Config2__MaxOptions__c             = 99;
            RefFlowHierarchy.Apttus_Config2__MinOptions__c             = 1;
            RefFlowHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
            RefFlowHierarchy.Apttus_Config2__Right__c                  = CategoryHierarchyLeft + (2*RefFlowTypes.size()) + 1;
        System.debug('Prosenjit Debug:: Hierarchy check*****************'+RefFlowHierarchy);
        RefTypeMap.put(RefFlowHierarchy.Category_Hierarchy_External_ID__c,RefFlowHierarchy);
        
        //prepare reference flow catalog structure for config products
        for(Product2 prod : ListBundleProduct){
            for(String CatType : RefFlowTypes){
                Apttus_Config2__ClassificationHierarchy__c tempRefFlowHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
                    tempRefFlowHierarchy.Category_Hierarchy_External_ID__c         = prod.Product_External_ID__c+'_'+CatType;
                    tempRefFlowHierarchy.Apttus_Config2__Label__c                  = CatType;
                    tempRefFlowHierarchy.Name                                      = prod.Product_External_ID__c+'_'+CatType;
                    tempRefFlowHierarchy.Apttus_Config2__AncestorId__c             = MapClassification.get(prod.Product_External_ID__c+'_'+RefName).id;
                    tempRefFlowHierarchy.Apttus_Config2__PrimordialId__c           = MapClassification.get(prod.Product_External_ID__c+'_'+RefName).id;
                    tempRefFlowHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
                    tempRefFlowHierarchy.Apttus_Config2__ExpandedByDefault__c      = FALSE;
                    tempRefFlowHierarchy.Apttus_Config2__HierarchyId__c            = ClassificationName.get(prod.Product_External_ID__c+'_'+RefName).id;
                    tempRefFlowHierarchy.Apttus_Config2__IncludeInTotalsView__c    = TRUE;
                    tempRefFlowHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
                    tempRefFlowHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
                    tempRefFlowHierarchy.Apttus_Config2__Level__c                  = 0;
                    tempRefFlowHierarchy.Apttus_Config2__Left__c                   = countleft;
                    tempRefFlowHierarchy.Apttus_Config2__MaxOptions__c             = 99;
                    tempRefFlowHierarchy.Apttus_Config2__MinOptions__c             = 1;
                    tempRefFlowHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
                    tempRefFlowHierarchy.Apttus_Config2__Right__c                  = ++ countleft;
                MapClassification.put(tempRefFlowHierarchy.Category_Hierarchy_External_ID__c,tempRefFlowHierarchy);
                RefTypeMap.put(tempRefFlowHierarchy.Category_Hierarchy_External_ID__c,tempRefFlowHierarchy);
            }
        }
        try{
            system.debug('Prosenjit Debug::::+++++++'+RefTypeMap.values());
            upsert RefTypeMap.values() Category_Hierarchy_External_ID__c;
            system.debug('Prosenjit Debug::::+++++++reftypesmap'+RefTypeMap.values());
        }
        catch(exception e){}
            
        /**********************************Step 5*************************************/
        //create reference flow catalog structure under tab called reference flow.
        List<Apttus_Config2__ClassificationHierarchy__c>  ListRefFlowTypeHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();    
        for(String CatType : RefFlowTypes){
            Apttus_Config2__ClassificationHierarchy__c TempHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
                TempHierarchy.Category_Hierarchy_External_ID__c         = CatType;
                TempHierarchy.Apttus_Config2__Label__c                  = CatType ;
                TempHierarchy.Name                                      = CatType;
                TempHierarchy.Apttus_Config2__AncestorId__c             = RefTypeMap.get(RefName).id;
                TempHierarchy.Apttus_Config2__PrimordialId__c           = gfofferingCategoryHierarchy.id;
                if(CatType == 'AMS Reference Flow'){
                    TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = TRUE;
                }
                else{
                    TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
                }
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c      = FALSE;
                TempHierarchy.Apttus_Config2__HierarchyId__c            = gfofferingCategory.id;
                TempHierarchy.Apttus_Config2__IncludeInTotalsView__c    = TRUE;
                TempHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
                TempHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
                TempHierarchy.Apttus_Config2__Level__c                  = 0;
                TempHierarchy.Apttus_Config2__Left__c                   = ++ CategoryHierarchyLeft ;
                TempHierarchy.Apttus_Config2__MaxOptions__c             = 99;
                TempHierarchy.Apttus_Config2__MinOptions__c             = 1;
                TempHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
                TempHierarchy.Apttus_Config2__Right__c                  = ++ CategoryHierarchyLeft ;
                TempHierarchy.Apttus_Config2__SearchFilterFields__c     = 'Geometry__c';
            System.debug('Prosenjit Debug:: child Hierarchy check*****************'+TempHierarchy);
            ListRefFlowTypeHierarchy.add(TempHierarchy);               
            RefTypeMap.put(CatType,TempHierarchy);            
        }
        
        CategoryHierarchyLeft = CategoryHierarchyLeft +2;
        gfofferingCategoryHierarchy.Apttus_Config2__Right__c        = CategoryHierarchyLeft;
        try{
            upsert ListRefFlowTypeHierarchy Category_Hierarchy_External_ID__c;
            //update gfofferingCategoryHierarchy;          
        }
        catch(exception e){}
        
        /**************************Step 7******************************/
        //Insert reference flow products in the product classification object. 
        List<Apttus_Config2__ProductClassification__c> ListClassification = new List<Apttus_Config2__ProductClassification__c>();
        for(Product2 prod : ListProduct){           
            Apttus_Config2__ProductClassification__c tempClassification = new Apttus_Config2__ProductClassification__c();
                tempClassification.Apttus_Config2__ClassificationId__c      =   RefTypeMap.get(CustomMapRefFlow.get(prod.Product_External_ID__c)).id;
                tempClassification.Apttus_Config2__DefaultQuantity__c       =   1;
                tempClassification.Apttus_Config2__MaxQuantity__c           =   1;
                tempClassification.Apttus_Config2__MinQuantity__c           =   0;
                tempClassification.Apttus_Config2__Modifiable__c            =   TRUE;
                tempClassification.Apttus_Config2__ProductId__c             =   prod.id;
                tempClassification.Product_Classification_External_ID__c    =   CustomMapRefFlow.get(prod.ProductCode)+'_'+prod.ProductCode;
            ListClassification.add(tempClassification);
        }
        try{
            upsert ListClassification Product_Classification_External_ID__c;
        }
        catch(exception e){}
       
    }//end of method insertCategoryStructure
    
     /***
    This is the method insert/update product option components. This will create the options under different category.
        
        @method name: insertProductOptionComponent
        @parameter:   List of reference flow types
        @return :     none
    ***/   
    public void insertProductOptionComponent(List<String> RefFlowTypes){
        
        // Map of product option group external ID and product option group record. This will be used to get the product option groups to assiciate corresponding options.
        Map<String,Apttus_Config2__ProductOptionGroup__c> MapProductOptionGrp = new Map<String,Apttus_Config2__ProductOptionGroup__c>();
        
        //List of product option component
        List<Apttus_Config2__ProductOptionComponent__c> listinsertProductOptionComp = new List<Apttus_Config2__ProductOptionComponent__c>();
        
        //Following section insert/update product option groups
        IF(ListBundleProduct.size()>0){
            for(product2 BundleProd : ListBundleProduct){
                Apttus_Config2__ProductOptionGroup__c tempProdOption = new Apttus_Config2__ProductOptionGroup__c();
                    tempProdOption.Apttus_Config2__IsHidden__c              =   FALSE;
                    tempProdOption.Apttus_Config2__IsLeaf__c                =   FALSE;  
                    tempProdOption.Apttus_Config2__IsPicklist__c            =   FALSE;
                    tempProdOption.Apttus_Config2__Level__c                 =   0;
                    tempProdOption.Apttus_Config2__MaxOptions__c            =   99;
                    tempProdOption.Apttus_Config2__MinOptions__c            =   0;
                    tempProdOption.Apttus_Config2__ModifiableType__c        =   'Variable';
                    tempProdOption.Apttus_Config2__OptionGroupId__c         =   MapClassification.get(BundleProd.Product_External_ID__c+'_Reference Flow').id;
                    tempProdOption.Apttus_Config2__ParentOptionGroupId__c   =   NULL;
                    tempProdOption.Apttus_Config2__ProductId__c             =   BundleProd.id;
                    tempProdOption.Product_Option_Grp_External_ID__c        =   BundleProd.Product_External_ID__c+'_Reference Flow';
                    tempProdOption.Apttus_Config2__Left__c                  =   1;
                    tempProdOption.Apttus_Config2__Right__c                 =   2*RefFlowTypes.size() + 2;
                    tempProdOption.Apttus_Config2__RootOptionGroupId__c     =   MapClassification.get(BundleProd.Product_External_ID__c+'_Reference Flow').id;
                    tempProdOption.Apttus_Config2__RootSequence__c          =   6;
                    tempProdOption.Apttus_Config2__Sequence__c              =   0;  
                MapProductOptionGrp.put(tempProdOption.Product_Option_Grp_External_ID__c, tempProdOption);  
            }
            
            //Variable to order the product option components- Left/Right apttus count. 
            integer countclassification = 2;
            
            //following section creates product option groups for different Reference flow category. 
            for(product2 BundleProd : ListBundleProduct){       
                for(String typeRef : RefFlowTypes ){
                    Apttus_Config2__ProductOptionGroup__c tempProdOptionchild = new Apttus_Config2__ProductOptionGroup__c();
                        tempProdOptionchild.Apttus_Config2__IsHidden__c             =   FALSE;
                        tempProdOptionchild.Apttus_Config2__IsLeaf__c               =   TRUE;  
                        tempProdOptionchild.Apttus_Config2__IsPicklist__c           =   FALSE;
                        tempProdOptionchild.Apttus_Config2__Level__c                =   1;
                        tempProdOptionchild.Apttus_Config2__MaxOptions__c           =   99;
                        tempProdOptionchild.Apttus_Config2__MinOptions__c           =   0;
                        tempProdOptionchild.Apttus_Config2__ModifiableType__c       =   'Variable';
                        tempProdOptionchild.Apttus_Config2__OptionGroupId__c        =   MapClassification.get(BundleProd.Product_External_ID__c+'_'+typeRef).id;
                        tempProdOptionchild.Apttus_Config2__ParentOptionGroupId__c  =   MapClassification.get(BundleProd.Product_External_ID__c+'_Reference Flow').id;
                        tempProdOptionchild.Apttus_Config2__ProductId__c            =   BundleProd.id;
                        tempProdOptionchild.Product_Option_Grp_External_ID__c       =   BundleProd.Product_External_ID__c+'_'+typeRef;
                        tempProdOptionchild.Apttus_Config2__Left__c                 =   countclassification;
                        tempProdOptionchild.Apttus_Config2__Right__c                =   ++ countclassification;
                        tempProdOptionchild.Apttus_Config2__RootOptionGroupId__c    =   MapClassification.get(BundleProd.Product_External_ID__c+'_Reference Flow').id;
                        tempProdOptionchild.Apttus_Config2__RootSequence__c         =   6;
                        tempProdOptionchild.Apttus_Config2__Sequence__c             =   0;  
                        ++ countclassification;
                    MapProductOptionGrp.put(tempProdOptionchild.Product_Option_Grp_External_ID__c, tempProdOptionchild);        
                }
            }   
            try{
                upsert MapProductOptionGrp.values() Product_Option_Grp_External_ID__c;
            }
            catch(exception e){}
            
            //
            integer sequencenum = 1;
            
            //Following section insert/update options under classification group.
            for(Product2 refProd : ListProduct){
                Apttus_Config2__ProductOptionComponent__c tempProdComp = new Apttus_Config2__ProductOptionComponent__c();
                    tempProdComp.Apttus_Config2__AllowCloning__c            =   FALSE;
                    tempProdComp.Apttus_Config2__ComponentProductId__c      =   refProd.id;
                    tempProdComp.Apttus_Config2__Default__c                 =   FALSE;
                    tempProdComp.Apttus_Config2__Modifiable__c              =   FALSE;
                    if(MapPTnumvsConfigProd.keySet().contains(refProd.PT_Number__c)){
                        tempProdComp.Apttus_Config2__ParentProductId__c         =   MapPTnumvsConfigProd.get(refProd.PT_Number__c).id;
                        tempProdComp.Apttus_Config2__ProductOptionGroupId__c    =   MapProductOptionGrp.get(MapPTnumvsConfigProd.get(refProd.PT_Number__c).Product_External_ID__c+'_'+CustomMapRefFlow.get(refProd.Product_External_ID__c)).id;
                        tempProdComp.Option_Component_External_ID__c            =   MapPTnumvsConfigProd.get(refProd.PT_Number__c).Product_External_ID__c+'_'+refProd.Product_External_ID__c;
                    }
                    else{
                        tempProdComp.Option_Component_External_ID__c            =   refProd.Product_External_ID__c;
                    }                   
                    tempProdComp.Apttus_Config2__RelationshipType__c        =   'Option';
                    tempProdComp.Apttus_Config2__Required__c                =   FALSE;
                    tempProdComp.Apttus_Config2__Sequence__c                =   sequencenum;
                                            
                    sequencenum++;
                listinsertProductOptionComp.add(tempProdComp);
            }
                    
            
            try{
                upsert listinsertProductOptionComp Option_Component_External_ID__c;
            }
            catch(exception e){}
        }
    } //end of method insertProductOptionComponent
    
    /***
    This is the method insert/update product in different price lists. 
        
        @method name: insertPriceList
        @parameter:   List of reference flow products.
        @return :     none
    ***/   
    public void insertPriceList(List<Product2> listProd){
        
        //List of price list items to insert under different price list.
        List<Apttus_Config2__PriceListItem__c> PriceListListitemInsert = new List<Apttus_Config2__PriceListItem__c>();
        
        //Create pricelist items for all the price list available.
        for(Apttus_Config2__PriceList__c pricelist :    [SELECT     id,
                                                                    name
                                                        FROM        Apttus_Config2__PriceList__c]){
            for(Product2 prod :listProd ){
                Apttus_Config2__PriceListItem__c TempPriceListItem = new Apttus_Config2__PriceListItem__c ();
                    TempPriceListItem.Apttus_Config2__Active__c                        = TRUE;
                    TempPriceListItem.Apttus_Config2__AllocateGroupAdjustment__c       = TRUE;
                    TempPriceListItem.Apttus_Config2__AllowManualAdjustment__c         = TRUE;
                    TempPriceListItem.Apttus_Config2__AllowProration__c                = FALSE;
                    TempPriceListItem.Apttus_Config2__AutoCascadeQuantity__c           = FALSE;
                    TempPriceListItem.Apttus_Config2__AutoCascadeSellingTerm__c        = FALSE;
                    TempPriceListItem.Apttus_Config2__RollupPriceToBundle__c           = TRUE;
                    TempPriceListItem.Apttus_Config2__ChargeType__c                    = 'Standard Price';
                    TempPriceListItem.Apttus_Config2__EnableCommitment__c              = FALSE;
                    TempPriceListItem.Apttus_Config2__EnablePriceRamp__c               = FALSE;
                    TempPriceListItem.Apttus_Config2__IsQuantityReadOnly__c            = FALSE;
                    TempPriceListItem.Apttus_Config2__IsSellingTermReadOnly__c         = FALSE;
                    TempPriceListItem.Apttus_Config2__IsUsageTierModifiable__c         = FALSE;
                    TempPriceListItem.Apttus_Config2__ListPrice__c                     = 0;
                    TempPriceListItem.Apttus_Config2__PriceIncludedInBundle__c         = FALSE;
                    TempPriceListItem.Apttus_Config2__PriceListId__c                   = pricelist.id;
                    TempPriceListItem.Apttus_Config2__PriceMethod__c                   = 'Per Unit';
                    TempPriceListItem.Apttus_Config2__PriceType__c                     = 'One Time';
                    TempPriceListItem.Apttus_Config2__PriceUom__c                      = 'Each';
                    TempPriceListItem.Apttus_Config2__ProductId__c                     = prod.id; 
                    TempPriceListItem.PriceListItemExternal_ID__c                      = prod.Product_External_ID__c + '_'+ pricelist.name;                                 
                PriceListListitemInsert.add(TempPriceListItem);             
            }                                                   
        }
        if(PriceListListitemInsert.size()>0){
            try{
                upsert PriceListListitemInsert PriceListItemExternal_ID__c;
            }
            catch(exception e){}
        }
    }// end of insertPriceList method
    
    
    /***
    This is the method Updates all product icon in the product level to make them appear in the Browse catalog
        
        @method name: updateIcons
        @parameter:   List of reference flow products.
        @return :     none
    ***/ 
    public void updateIcons(List<Product2> listProd){
        
        //Map of Static resource name and the static resource for the geometry images
        Map<String,StaticResource> mapStaticImages = new Map<String,StaticResource>();
        
        //get all the static resources
        List<StaticResource> resourceimage = [SELECT    id,
                                                        Body,
                                                        name
                                                FROM    StaticResource
                                                WHERE   name 
                                                LIKE    'geoImage%']    ;
                                                
        //put statis resources in the map                                                
        for(StaticResource statres : resourceimage){
            mapStaticImages.put(statres.name,statres);
        }
        
        //Map of reference flow products and attachments to insert.
        Map<Product2,Attachment> MapInsertAttachment = new Map<Product2,Attachment> ();
        
        //following section generates all the attachments for different ref flow products.
        for(Product2 prod : listProd){
            if(prod.Apttus_Config2__IconId__c == '' || prod.Apttus_Config2__IconId__c == null){
                double Geometry = double.valueOf(prod.Geometry__c.replace('UM','')) ;
                Attachment attachlogo = new Attachment();
                    attachlogo.ParentId     =   prod.id;
                    attachlogo.name         =   integer.valueOf(Geometry*1000) + 'nm';
                    attachlogo.body         =   mapStaticImages.get('geoImage_'+integer.valueOf(Geometry*1000) + 'nm').body;
                    attachlogo.IsPrivate    =   FALSE;  
                MapInsertAttachment.put(prod,attachlogo);
            }
        }
        
        //insert attachments.
        insert MapInsertAttachment.values();
        
        //update products with attachment IDs.
        List<Product2> UpdateProd = new List<Product2>();
        
        for(Product2 Tempprodupdate: MapInsertAttachment.keySet()){
            Tempprodupdate.Apttus_Config2__IconId__c    = MapInsertAttachment.get(Tempprodupdate).id;
            UpdateProd.add(Tempprodupdate);
        }
        try{
            update UpdateProd;
        }
        catch(exception e){}
    } // end of updateIcons method
    
    /***
    This is the method runs all the Apttus Maintenance jobs automatically.
        
        @method name: runBatchJob
        @parameter:   List of reference flow products.
        @return :     none
    ***/ 
    public void runBatchJob(List<ID> ProdID){
        Apttus_Config2.BundleUpdateJob bundleJob = new Apttus_Config2.BundleUpdateJob(ProdID);
        //bundleJob.BundleUpdateJob(listProd);
    }
    /************* Yet to automate this.. wating for respornse from apttus ******************/
    
    /***
    This is the method runs all the Apttus Maintenance jobs automatically.
        
        @method name: upsertCompareReferenceFlow
        @parameter:   1. List of reference flow products.
                      2. Map of reference flow name and tech files
                      3. Map of reference flow name and Specification
        @return :     none
    ***/
    public void upsertCompareReferenceFlow(List<Product2> listProd,Map<String,Tech_File__c> TechFileMap, Map<String,Design_Spec__c> SpecMap ){
        
        //insert/update reference flow feature set
        Apttus_Config2__FeatureSet__c tempFeatureSet = new Apttus_Config2__FeatureSet__c();
            tempFeatureSet.Apttus_Config2__Description__c   = 'Reference Flow Information';
            tempFeatureSet.Feature_Set_External_Id__c       = 'Reference Flow Information';
            tempFeatureSet.Name                             = 'Reference Flow Information';
            tempFeatureSet.Apttus_Config2__Sequence__c      = 14;
        try{
            Upsert tempFeatureSet Feature_Set_External_Id__c;
        }
        catch(exception e){}
        
        //List of all features. List is used to get the features in orderly manner. 
        List<String> FeatureList = new List<String>{'Number','Document Title','Lifecycle Phase' ,'Rev',  'Description' , 'PDK(Version)', 'Design Manual',
                                                    'EDA Tool Supported',  'IP Vendor', 'PT Number', 'Compatible PT', 'Technology Geometry', 'Technology Type'};
                                                    
        //Map of feature name and API name of corresponding field.                                                  
        Map<String,String> FeatureMapRF = new Map<String,String>{  'Number' => 'Name', 'Document Title' => 'Document_Title__c', 'Lifecycle Phase' => 'Lifecycle__c', 
                                                                    'Rev' => 'Doc_Rev__c', 'Description' => 'Description__c' , 'PDK(Version)' => 'PDK_Version__c', 'Design Manual' => 'Design_Manual__c' , 
                                                                    'EDA Tool Supported' => 'EDA_Tool_Supported__c' , 'IP Vendor' => 'IP_Vendor__c' , 'PT Number' => 'PT_Number__c' , 
                                                                    'Compatible PT' => 'Compatible_PT__c', 'Technology Geometry' => 'Technology_Geometry__c' , 'Technology Type' => 'Technology_Geometry__c' };
        
        //Map of feature name and feature record to insert/update.
        Map<String,Apttus_Config2__Feature__c> MapFeature = new Map<String,Apttus_Config2__Feature__c>();
        integer SequenceCount = 1;
        for(String featuresRF: FeatureList){
            Apttus_Config2__Feature__c tempFeature = new Apttus_Config2__Feature__c();
                tempFeature.Apttus_Config2__Description__c  =   featuresRF;
                tempFeature.Feature_External_Id__c          =   featuresRF;
                tempFeature.Name                            =   featuresRF;
                tempFeature.Apttus_Config2__Sequence__c     =   SequenceCount++;
                tempFeature.Apttus_Config2__FeatureSetId__c =   tempFeatureSet.id;
            MapFeature.put(tempFeature.Name, tempFeature);
        }
        try{
            upsert MapFeature.values() Feature_External_Id__c;
        }
        catch(exception e){}
        
        //following section generates all the product feature values used in the product compare page.
        List<Apttus_Config2__ProductFeatureValue__c> ListFeatureValue = new List<Apttus_Config2__ProductFeatureValue__c>();
        for(Product2 Prod : listProd ){
            for(String featuresRF :  FeatureMapRF.keySet()){
                Apttus_Config2__ProductFeatureValue__c tempProdFeatureValue = new Apttus_Config2__ProductFeatureValue__c();
                    tempProdFeatureValue.Apttus_Config2__FeatureId__c           =   MapFeature.get(featuresRF).id;
                    tempProdFeatureValue.Apttus_Config2__IsIncluded__c          =   TRUE;
                    tempProdFeatureValue.Apttus_Config2__ProductId__c           =   Prod.ID;
                    tempProdFeatureValue.Product_Feature_Value_External_ID__c   =   Prod.ProductCode+'_'+featuresRF;
                    system.debug('PS:Debug::featuresRF'+featuresRF);
                    if(featuresRF != 'Description' && featuresRF != 'PDK(Version)' ){
                        system.debug('PS:Debug::featuresRF***inside if'+featuresRF);
                        tempProdFeatureValue.Apttus_Config2__Value__c       =   String.valueOf(TechFileMap.get(Prod.ProductCode).get(FeatureMapRF.get(featuresRF)));
                    }
                    else{
                        tempProdFeatureValue.Apttus_Config2__Value__c       =   String.valueOf(SpecMap.get(Prod.ProductCode).get(FeatureMapRF.get(featuresRF)));
                    }
                ListFeatureValue.add(tempProdFeatureValue);
            }
        }
        
        try{
            upsert ListFeatureValue Product_Feature_Value_External_ID__c;
        }
        catch(exception e){}
        
    }// end of upsertCompareReferenceFlow method
} //end of class