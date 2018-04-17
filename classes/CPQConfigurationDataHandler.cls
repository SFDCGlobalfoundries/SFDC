/**********************************************************************************************************************************************
Class:         CPQConfigurationDataHandler
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha (PS)
Created Date:  04-09-2015
Reason:        This class handles all the data loading activities in the configurator master database.  
           
Change Log:     Ravi Teja.B Modified On 22/02/17 for Case#00061409
                   
**********************************************************************************************************************************************/
public class CPQConfigurationDataHandler {
    
    public static List<MLG_Record__c> ListMLG = new List<MLG_Record__c>();
    //for compound attribute Rules
    public Map<string,List<MLG_Record__c>> CompundRuleMap = new Map<string,List<MLG_Record__c>>();
    
    /**********************************************************************************************************************************************
     Method name:       processTechLoad
     Parameter:         1. Process tech - Bundle Product 
                        2. List of pricelists to be associated. If no pricelist is mentioned then consider this to be avialable for all 
                        Price lists.  
     Return type:       N/A           
    **********************************************************************************************************************************************/
    public void processTechLoad(Product2 ParentProduct
                                , List<string> PriceListNames
                                , String CatalogType
                                , CPQ_MLGPLUS__c mlgplus
                                , Map<String,String> CatNameToAttIDMap ){
         
        // :: Variable decalaration ::
        Map<string,Product2> MapRelatedProducts = new Map<string,Product2>(); // All related products 
        List<Apttus_Config2__ClassificationName__c> ProductCategoryList = new List<Apttus_Config2__ClassificationName__c>(); // Category list
        map<String ,string> ConstraintRuleMap = new map<String ,string>(); //Map of Constraint rule external ID to Record ID
        List<Apttus_Config2__ConstraintRuleAction__c> FinalListConstraintRuleAction = new List<Apttus_Config2__ConstraintRuleAction__c>(); //constraint rule actions
        String CurrentVersion = '%#'+  mlgplus.Processed_Version__c + '#%' ; 
        system.debug('[debug: CurrentVersion ===]'+CurrentVersion);
        //Update IP data in the MLG Records
        if(CatalogType == 'First Source'){
            insertIpMLGplus(ParentProduct, mlgplus);    
        }
        
        //get Price Lists
        for(Related_Price_Lists__c relPL : [select id,CPQ_MLGPLUS__c, Price_List__r.name from Related_Price_Lists__c where CPQ_MLGPLUS__c = :mlgplus.id]){
            PriceListNames.add(relPL.Price_List__r.name);
        }
        
        //get all realted MLG PLUS:
        ListMLG =[SELECT    ID
                            , Additional_Mask_s__c
                            , Core_Voltage_V__c
                            , Feature_Description__c
                            , Feature_Group__c
                            , FEOL_BEOL__c
                            , IO_Voltage_V__c
                            , Model_Name__c
                            , Product_Name__c
                            , IP_Number__c
                            , IP_Type__c
                            , IP_Vendor__c
                            , LifeCycle__c
                            , Device_List__c
                            , name
                            , Serial_Number__c
                            , IP_Metal_Stack__c
                            , Version__c 
                            , MLG_External_ID__c
                            , Parent_Attribute_Rule_ID__c
                 FROM       MLG_Record__c
                 WHERE      CPQ_MLGPLUS__c = :mlgplus.ID
                 AND        (Version__c 
                 LIKE       :CurrentVersion
                 OR         Feature_Group__c = 'Attribute Rule'
                 OR         Feature_Group__c = 'IP')
                 ORDER BY   Serial_Number__c];
        system.debug('[debug: MLG records]:'+ListMLG);
        
        // Create a savepoint while metadata update
        //Savepoint sp = Database.setSavepoint();   
        //create related products 
        MapRelatedProducts = ProductInsert(ParentProduct, CatNameToAttIDMap);
        //create new category
        createAndUpdateCategoryHierarchy(mlgplus.Geometry__c);   
        //get categories:
        ProductCategoryList = getCategoryMap(ParentProduct.Catalog_Type__c , ParentProduct.product_external_Id__c);
        //create all associations under this. 
        createDataAssociations (    ProductCategoryList
                                  , ParentProduct   
                                  , PriceListNames
                                  , CatalogType
                                  , MapRelatedProducts.values());
        //create product attribute rule and product attribute rule action
        createProductAttributeRule(ParentProduct); 
        //Attribute creation is handled in trigger on the MLG PLUS
        //Create Constraint Rule        
        ConstraintRuleMap = getConstraintRule(ParentProduct , MapRelatedProducts);
        //create constraint rule conditions
        createConstraintRuleConditions(ConstraintRuleMap, ParentProduct, MapRelatedProducts);
        //create constraint rule action
        FinalListConstraintRuleAction = constraintRuleActionActionInsert( ConstraintRuleMap, ParentProduct, MapRelatedProducts);
        //clean up data:
        dataCleanUp(ParentProduct , MapRelatedProducts , FinalListConstraintRuleAction) ;
        // Rollback to the previous null value
        //Database.rollback(sp);
               
        //create new add new attribute values
        //createPicklistValues(ListMLG,mlgplus.Process_Technology__c); 
    
        
    }
    /*---------------------------------------------- Utility Methods -------------------------------------------------- */
    
    
    /**********************************************************************************************************************************************
     Method name:       ProductInsert
     Reason:            This method Inserts all the related product records and updates bundle product record with BEOL and FEOL mask List.
     Parameter:         1. Process tech - Bundle Product 
     Return type:       Map of Product ext ID to Product: all related Products           
    **********************************************************************************************************************************************/
    public Map<String,product2> ProductInsert(  product2 ParentProduct
                                                , Map<String,String> CatNameToAttIDMap){
                                            

        // All related products, will be used to insert in the product object.
        List<Product2> ProductFinalList = new List<Product2>();
        
        // FEOL and BEOL masks string
        Set<String> FEOLMasks =new set<String>(); 
        Set<String> BEOLMasks =new set<String>();
        
        //Related IP ID list
        List<String> IPIDList = new List<String>(); 
        
        //IP ID vs record ID map
        Map<String,String> MapIPvsID = new Map<String,String>();
        
        //Final Beol and Feol.
        String FinalFEOL ;
        String FinalBEOL ;
        
        //Retrieving IP ID and record Ids for MapIPvsID. 
        for(Base_IP__c baseIP : [SELECT    id,
                                           Name
                                 FROM      Base_IP__c]){
            MapIPvsID.put(baseIP.name, baseIP.id);    
        }
        
        //variable to store geometry value. 
        String strGeom; 
        //if the geometry contains nm then change the geomerty value to UM format.
        if( !ParentProduct.Geometry__c.contains('>') 
            && ParentProduct.Geometry__c.contains('UM')){
            Integer geom = Integer.valueOf(decimal.valueOf(ParentProduct.Geometry__c.replace('UM',''))*1000);
            system.debug('DEBUG: PS: Length of the string'+String.valueOf(geom).length());
            String geomValue = String.valueOf(geom); 
            
            system.debug('DEBUG: PS: geomvalue string'+ geomValue);
            strGeom = geomValue + 'nm';
        }
        //else UM value would be considered
        else{
            strGeom = ParentProduct.Geometry__c == '>0.18UM'  ? '>180nm' : ParentProduct.Geometry__c;
        }
        
        //Retrieving data from MLG+ object for this PT.
        for(MLG_Record__c mlg : ListMLG){      
            System.debug('[Debug: Mask set: ]:'+mlg.Feature_Description__c+'[Mask Sets-->]'+mlg.Additional_Mask_s__c);                        
            //retrieving MLG+ records to insert in the product object. 
            if( mlg.Feature_Group__c != 'Always Included'
                &&     mlg.Feature_Group__c != 'DNWELL'
                &&     mlg.Feature_Group__c != 'Packaging'
                &&     mlg.Feature_Group__c != 'Attribute Rule'){
                    //preparing all devices/IPs/metal stacks products for insertation.
                    ProductFinalList.add(getProduct(mlg,ParentProduct,MapIPvsID, CatNameToAttIDMap, strGeom));  
            } 
            system.debug('[debug: Check additional masks]'+String.isblank(mlg.Additional_Mask_s__c));
            //get all FEOL and BEOL masks and add in the FEOLMasks and BEOLMasks list.
            if(!String.isblank(mlg.Additional_Mask_s__c) && mlg.Additional_Mask_s__c != 'N/A' && mlg.Additional_Mask_s__c.trim() != '-' && mlg.Additional_Mask_s__c != 'NA'){                
                if(mlg.FEOL_BEOL__c == 'FEOL'){
                    set<String> getFEOLMaskLayersSet = new Set<String>();
                    getFEOLMaskLayersSet = getMaskLayers(mlg.Additional_Mask_s__c);
                    if(getFEOLMaskLayersSet.size()>0){
                        FEOLMasks.addAll(getFEOLMaskLayersSet );
                    }
                    system.debug('[debug: FEOL masks]'+FEOLMasks);
                }
                else if(mlg.FEOL_BEOL__c == 'BEOL'){
                    set<String> getBEOLMaskLayersSet = new Set<String>();
                    getBEOLMaskLayersSet = getMaskLayers(mlg.Additional_Mask_s__c);
                    if(getBEOLMaskLayersSet .size()>0){
                        BEOLMasks.addAll(getBEOLMaskLayersSet );
                    }
                    system.debug('[debug: BEOL masks]'+BEOLMasks);
                } 
                            
            }
        }  //end of for loop MLG_Record__c
        
        //Preparing Final string to update feol and beol field.
        for(String str: FEOLMasks){
             if(FinalFEOL == NULL){
                 FinalFEOL = str;
             }  
             else{
                 FinalFEOL = FinalFEOL  + ' ' + str;
             }
        }  
        for(String str: BEOLMasks){
             if(FinalBEOL == NULL){
                 FinalBEOL = str;
             }  
             else{
                 FinalBEOL = FinalBEOL + ' ' + str;
             }
        }   
        
        String FEOLBEOLString = FinalFEOL + ' ' + FinalBEOL ;
        //preparing mask products to upsert. 
        ProductFinalList.addAll(getMaskLayersProducts(FEOLBEOLString ));
                
        //Preparing Parent Bundle product for update.
        ParentProduct.FEOL__c                                 = FinalFEOL ;
        ParentProduct.BEOL__c                                 = FinalBEOL ;
        ParentProduct.Apttus_Config2__ConfigurationType__c    = 'Bundle';
        ParentProduct.Apttus_Config2__HasAttributes__c        = TRUE;
        ParentProduct.Apttus_Config2__HasDefaults__c          = FALSE;
        ParentProduct.Apttus_Config2__HasOptions__c           = TRUE;
        ParentProduct.Apttus_Config2__HasSearchAttributes__c  = FALSE;
        ParentProduct.Apttus_Config2__Customizable__c         = TRUE;   
        ParentProduct.Apttus_Config2__Uom__c                  = 'Each';
        ParentProduct.Apttus_Config2__IconId__c               = CatNameToAttIDMap.containskey(strGeom) ? CatNameToAttIDMap.get(strGeom) : ParentProduct.Apttus_Config2__IconId__c;
        system.debug('[debug: BEOL masks]'+BEOLMasks);
        system.debug('[debug: FEOL masks]'+FEOLMasks);
        system.debug('[debug: Final FEOL/BEOL String]'+FEOLBEOLString );
        system.debug('[debug: ProductFinalList]'+ProductFinalList );
        system.debug('[debug: Parent Product]'+ParentProduct);
        
        //upsert all related products
        Upsert ProductFinalList Product_External_ID__c;
        
        //Update parent Bundle product.
        Update ParentProduct;
        
        // Populate IP Icon
        List<Product2> ipProductList = new list<Product2>();
        Map<String,Product2> ProductCodeVsProductMap = new Map<String,Product2>();
        for(Product2 prod : ProductFinalList){
            ProductCodeVsProductMap.put(prod.Product_External_ID__c , prod);
        }        
        return ProductCodeVsProductMap;
    }
    
    /**********************************************************************************************************************************************
     Method name:       getProduct
     Reason:            This method prepares all the related option products required for a bundle product.
     Parameter:         1. MLG record 
                        2. Process tech - Bundle Product 
                        3. Map of IP name and record ID
     Return type:       Option product record.           
    **********************************************************************************************************************************************/
    public product2 getProduct( MLG_Record__c mlg
                                , product2 ParentProduct
                                , map<String, String> MapIPvsID
                                , Map<String,String> CatNameToAttIDMap
                                , String strGeom){
        
        //in case mlg record is related to IP
        ID IPID;
        if(MapIPvsID.containsKey(mlg.IP_Number__c)){
            IPID = MapIPvsID.get(mlg.IP_Number__c); // populate IPID 
        }
        
        //new option product. 
        product2 prod = new product2();
        
        // for metal option products
        if(mlg.Feature_Group__c == 'Metal Options'){
            prod.Product_External_ID__c                 = mlg.Feature_Description__c + '_'+ParentProduct.Product_External_ID__c;
            prod.ProductCode                            = mlg.Feature_Description__c + '_'+ParentProduct.Product_External_ID__c;
            prod.IsActive                               = TRUE;
            prod.Apttus_Config2__ConfigurationType__c   = 'Option';
            prod.Apttus_Config2__HasAttributes__c       = FALSE;
            prod.Apttus_Config2__HasDefaults__c         = FALSE;
            prod.Apttus_Config2__HasOptions__c          = FALSE;
            prod.Apttus_Config2__HasSearchAttributes__c = FALSE;
            prod.Apttus_Config2__Customizable__c        = FALSE;
            prod.Family                                 = 'Metal Stacks';
            prod.Name                                   = mlg.Feature_Description__c;
            prod.Apttus_Config2__Uom__c                 = 'Each';
        }else{//for IP / device option 
            // ---- for IP section---
            if(mlg.Feature_Group__c != 'IP'){//----- for Option device section ---- 
                if(mlg.Model_Name__c != NULL && mlg.Model_Name__c != 'N/A' && mlg.Model_Name__c != 'NA' ){
                //|| mlg.Model_Name__c != '' || mlg.Model_Name__c != 'N/A')
                    prod.Product_External_ID__c                 = ParentProduct.Product_External_ID__c + '_'+ mlg.Model_Name__c ;
                }
                else{
                    prod.Product_External_ID__c                 = ParentProduct.Product_External_ID__c + '_'+ mlg.Feature_Description__c ;    
                }
                prod.Description                            = mlg.Model_Name__c;
                prod.ProductCode                            = prod.Product_External_ID__c;
                prod.IsActive                               = TRUE;
                prod.Apttus_Config2__ConfigurationType__c   = 'Option';
                prod.APTPS_Core_Voltage__c                  = String.valueOf(mlg.Core_Voltage_V__c);
                prod.Geometry__c                            = ParentProduct.Geometry__c;
                prod.Apttus_Config2__HasAttributes__c       = FALSE;
                prod.Apttus_Config2__HasDefaults__c         = FALSE;
                prod.Apttus_Config2__HasOptions__c          = FALSE;
                prod.Apttus_Config2__HasSearchAttributes__c = FALSE;
                prod.APTPS_IO_Voltage__c                    = String.valueOf(mlg.IO_Voltage_V__c);
                prod.Mask_Sets__c                           = mlg.Additional_Mask_s__c;
                prod.Apttus_Config2__Customizable__c        = FALSE;
                prod.Family                                 = 'Devices';
                prod.Name                                   = mlg.Feature_Description__c ;
                prod.Apttus_Config2__Uom__c                 = 'Each';
            }else{ 
                prod.Product_External_ID__c                 = mlg.IP_Number__c;
                prod.ProductCode                            = mlg.IP_Number__c;
                prod.Description__c                            = mlg.IP_Number__c + '\r\nIP Type:'+mlg.IP_Type__c+'\r\nVendor: '+mlg.IP_Vendor__c+'\r\nLifecycle: '+mlg.LifeCycle__c;
                //prod.Long_Description__c                    = '<br><br><strong><span style="color: #0070c0; "><span style="font-family: calibri,sans-serif; "><span style="font-size: 11.0pt; "><a href="https://c.cs5.visual.force.com/apex/View_PT_IP_Details?Entity=IP&Id='+IPID+'" target="_blank"><span style="color: #0070c0; ">IP Detail</span></a></span></span></span></strong>';
                prod.IsActive                               = TRUE;
                prod.Geometry__c                            = ParentProduct.Geometry__c;
                prod.Apttus_Config2__IconId__c              = CatNameToAttIDMap.containsKey(strGeom) ? CatNameToAttIDMap.get(strGeom) : prod.Apttus_Config2__IconId__c; 
                prod.Apttus_Config2__ConfigurationType__c   = 'Option';
                prod.Apttus_Config2__HasAttributes__c       = FALSE;
                prod.Apttus_Config2__HasDefaults__c         = FALSE;
                prod.Apttus_Config2__HasOptions__c          = FALSE;
                prod.Apttus_Config2__HasSearchAttributes__c = FALSE;
                prod.APTPS_IP_Lifecycle__c                  = mlg.LifeCycle__c;
                prod.APTPS_IP_Type__c                       = mlg.IP_Type__c;
                prod.APTPS_IP_Vendors__c                    = mlg.IP_Vendor__c;
                prod.Apttus_Config2__Customizable__c        = FALSE;
                prod.Family                                 = 'IPs';
                //prod.Name                                   = mlg.Feature_Description__c ;
                //Added By Ravi Teja.B for Case#00061409
                if(mlg.Feature_Description__c != null && mlg.Feature_Description__c != ''){
                    prod.Name = '('+mlg.Feature_Description__c.replaceAll('[^\\x00-\\x7F]', '')+')'+ ' ' + '('+mlg.IP_Number__c+')';
                }
                prod.Apttus_Config2__Uom__c                 = 'Each';
                prod.IP_Device_List__c                      = mlg.Device_List__c;
                prod.APTPS_Metal_Stack__c                   = mlg.IP_Metal_Stack__c;
                prod.Description                            = mlg.IP_Metal_Stack__c;
                prod.IP_PT_ID__c                            = IPID;
                prod.Apttus_Config2__IconId__c              = null;
                
            }
        }
        system.debug('[debug: test Product external ID and MLG record]'+prod.Product_External_ID__c+'##########'+mlg);
        system.debug('[debug: test Product name]'+prod.name);
        return prod;            
    }
    
    
    /**********************************************************************************************************************************************
     Method name:       getMaskLayers
     Reason:            This method prepares final masks
     Parameter:         1. String of mask sets. 
     Return type:       final FEOL and BEOL masks         
    **********************************************************************************************************************************************/
    public Set<String> getMaskLayers(String MaskSets){
        Set<string> FinalString = new Set<String>();
        for(String masks: MaskSets.Split(',')){
            if(masks != NULL && !String.isBlank(masks.trim())){
                FinalString.add(masks.trim());
            }
        }       
        system.debug('[debug: final FEOL/ BEOL string]'+FinalString);
        return FinalString;
    }
    
    /**********************************************************************************************************************************************
     Method name:       getMaskLayersProducts
     Reason:            This method prepares mask layer products
     Parameter:         1. String of mask set name 
     Return type:       mask set product      
    **********************************************************************************************************************************************/
    public List<Product2> getMaskLayersProducts(String MaskString){
                
        List<product2> MaskProductList = new List<Product2>();  // Final mask product list.     
        Set<String> CheckDuplicate = new Set<String>(); //this set is used to make unique mask values.
        
        //prepare products
        for(String mask : MaskString.Split(' ')){//start mask loop
            system.debug('[debug: Mask Name:]'+mask);
            if(mask != 'null' && !CheckDuplicate.contains(mask)){
                product2 TempProd = new Product2();
                    TempProd.Product_External_ID__c                 = mask;
                    TempProd.ProductCode                            = mask;
                    TempProd.IsActive                               = TRUE;
                    TempProd.Apttus_Config2__ConfigurationType__c   = 'Option';
                    TempProd.Apttus_Config2__HasAttributes__c       = FALSE;
                    TempProd.Apttus_Config2__HasDefaults__c         = FALSE;
                    TempProd.Apttus_Config2__HasOptions__c          = FALSE;
                    TempProd.Apttus_Config2__HasSearchAttributes__c = FALSE;
                    TempProd.Apttus_Config2__Customizable__c        = FALSE;
                    TempProd.Family                                 = 'Mask Layers';
                    TempProd.Name                                   = mask;
                    TempProd.Apttus_Config2__Uom__c                 = 'Each';
                MaskProductList.add(TempProd );            
                CheckDuplicate.add(mask);
            }
        } //end mask loop
        system.debug('[debug: MaskProductList]'+MaskProductList);
        return MaskProductList;
    }
    /**********************************************************************************************************************************************
     Method name:       getCategoryList
     Reason:            This method prepares all the categories related to parent Product
     Parameter:         1. String: Parent Product external ID
     Return type:       List of Category records.  
    **********************************************************************************************************************************************/
    public list<Apttus_Config2__ClassificationName__c> getCategoryMap(String CatalogType, String ProductExtId){
        List<Apttus_Config2__ClassificationName__c> InsertCategoryList = new List<Apttus_Config2__ClassificationName__c> ();
        //List<String> CategoryList = new List<String>{'Metal_Stacks','IPs','Devices','Mask_Sets','Additional_Questions'};
        CPQ_Settings__c cpqProdCategories = CPQ_Settings__c.getValues('CPQ_Product_Categories');
        Map<String, id> InsertCategoryMap = new Map<String,id>();
        system.debug('[debug: CategoryList ]'+ cpqProdCategories.Value__c);
        for(String str: cpqProdCategories.Value__c.split(',')){
            if(CatalogType == 'First Source' || ( CatalogType != 'First Source' &&  str != 'IPs')){
                Apttus_Config2__ClassificationName__c TempCategory = new Apttus_Config2__ClassificationName__c();
                TempCategory.Apttus_Config2__Active__c         = TRUE;
                TempCategory.Category_External_ID__c           = ProductExtId+'_'+str;
                TempCategory.Apttus_Config2__HierarchyLabel__c = str.replace('_',' ');     
                TempCategory.Name                              = ProductExtId+'_'+str;
                TempCategory.Apttus_Config2__Type__c           = 'Option Group';
                InsertCategoryList.add(TempCategory );
            }
        }
        upsert InsertCategoryList Category_External_ID__c; 
        system.debug('[debug: Insert Category List]'+InsertCategoryList);        
        return InsertCategoryList ; 
    }
    
    /**********************************************************************************************************************************************
     Method name:       createAndUpdateCategoryHierarchy
     Reason:            This method creates and updates Category Hierarchy records
     Parameter:         1. Geometry
     Return type:       N/A  
    **********************************************************************************************************************************************/
    public void createAndUpdateCategoryHierarchy(String geometry){
        
        
        List<Apttus_Config2__ClassificationHierarchy__c> TempHierarchyList = [select     id
                                                                                         , name
                                                                                         , Apttus_Config2__Label__c
                                                                                         , Category_Hierarchy_External_ID__c
                                                                                         , Apttus_Config2__AncestorId__c
                                                                                         , Apttus_Config2__PrimordialId__c
                                                                                         , Apttus_Config2__Left__c
                                                                                         , Apttus_Config2__Right__c
                                                                                         , Apttus_Config2__LargeImageSize__c
                                                                                         , Apttus_Config2__ExpandedByDefault__c
                                                                                         , Apttus_Config2__DefaultSearchCategory__c
                                                                                         , Apttus_Config2__Level__c
                                                                                         , Apttus_Config2__IsHidden__c
                                                                                         , Apttus_Config2__HierarchyId__c 
                                                                              from       Apttus_Config2__ClassificationHierarchy__c 
                                                                              where      Apttus_Config2__HierarchyId__r.Name = 'GLOBALFOUNDRIES Offering' 
                                                                              order by   Apttus_Config2__Left__c asc];
        
        Boolean isNewGeo = false;
        Decimal geolst = 0.0;
        for(Apttus_Config2__ClassificationHierarchy__c cH : TempHierarchyList){
            if(cH.Apttus_Config2__Label__c.contains('nm')){
                Decimal geom = Decimal.valueOf(cH.Apttus_Config2__Label__c.replace('nm','').replace('>',''))/1000;
                geolst = geom;
            }
            if( !cH.Apttus_Config2__Label__c.contains('>') 
                && cH.Apttus_Config2__Label__c.contains('nm') && !geometry.contains('>')){
                Decimal geom = Decimal.valueOf(cH.Apttus_Config2__Label__c.replace('nm',''))/1000;

                Decimal geoDec = Decimal.valueOf(geometry.replace('UM',''));
                if(geoDec == geom){
                    isNewGeo = true;
                }
            }else if(cH.Apttus_Config2__Label__c.contains('>') && geometry.contains('>')){
                Decimal geom = Decimal.valueOf(cH.Apttus_Config2__Label__c.replace('nm','').replace('>',''))/1000;
                Decimal geoDec = Decimal.valueOf(geometry.replace('UM','').replace('>',''));

                if(geoDec == geom){
                    isNewGeo = true;
                }
            }            
        }
        
        if(!isNewGeo){
            Boolean isCheck = false;           
            Decimal geoVal = Decimal.valueOf(geometry.replace('UM','').replace('>',''));
            String strGeoVal = geometry.contains('>')?('>'+(String.valueOf(Integer.valueOf(geoVal*1000))+'nm')):(String.valueOf(Integer.valueOf(geoVal*1000))+'nm');
            List<Apttus_Config2__ClassificationHierarchy__c> classHierarchyList = new List<Apttus_Config2__ClassificationHierarchy__c>();
            for(Apttus_Config2__ClassificationHierarchy__c cH : TempHierarchyList){
                if(cH.Apttus_Config2__Label__c == 'Product Catalog' || cH.Apttus_Config2__Label__c == 'GLOBALFOUNDRIES Offering'){
                    cH.Apttus_Config2__Right__c = cH.Apttus_Config2__Right__c + 2;
                    classHierarchyList.add(cH);
                }
                if(cH.Apttus_Config2__Label__c == 'Product Catalog'
                    && geolst==0.0
                    && !isCheck){
                    Apttus_Config2__ClassificationHierarchy__c chNew = cH.clone(false,true);
                    chNew.name = strGeoVal;
                    chNew.Apttus_Config2__Label__c = strGeoVal;
                    chNew.Category_Hierarchy_External_ID__c = strGeoVal;                        
                    chNew.Apttus_Config2__Left__c = chNew.Apttus_Config2__Left__c + 1;
                    chNew.Apttus_Config2__Right__c = chNew.Apttus_Config2__Left__c + 1;
                    classHierarchyList.add(chNew);
                    isCheck = true;
                }
                if(cH.Apttus_Config2__Label__c.contains('nm')
                     && !isCheck){
                    Decimal geom = Decimal.valueOf(cH.Apttus_Config2__Label__c.replace('nm','').replace('>',''))/1000;
                    if(geoVal < geom || (geoVal==geom && geom==geolst && cH.Apttus_Config2__Label__c.contains('>'))){
                        Apttus_Config2__ClassificationHierarchy__c chNew = cH.clone(false,true);
                        chNew.name = strGeoVal;
                        chNew.Apttus_Config2__Label__c = strGeoVal;
                        chNew.Category_Hierarchy_External_ID__c = strGeoVal;
                        classHierarchyList.add(chNew);
                        ch.Apttus_Config2__Left__c = ch.Apttus_Config2__Right__c + 1;
                        ch.Apttus_Config2__Right__c = ch.Apttus_Config2__Left__c + 1;
                        classHierarchyList.add(ch);
                        isCheck = true;
                    }else if(geoVal>=geom && geom==geolst && !(cH.Apttus_Config2__Label__c.contains('>'))){
                        Apttus_Config2__ClassificationHierarchy__c chNew = cH.clone(false,true);
                        chNew.name = strGeoVal;
                        chNew.Apttus_Config2__Label__c = strGeoVal;
                        chNew.Category_Hierarchy_External_ID__c = strGeoVal;                        
                        chNew.Apttus_Config2__Left__c = chNew.Apttus_Config2__Right__c + 1;
                        chNew.Apttus_Config2__Right__c = chNew.Apttus_Config2__Left__c + 1;
                        classHierarchyList.add(chNew);
                        isCheck = true;
                    }
                }else if(isCheck && cH.Apttus_Config2__Label__c != 'Product Catalog'){
                    cH.Apttus_Config2__Left__c = cH.Apttus_Config2__Right__c + 1;
                    cH.Apttus_Config2__Right__c = cH.Apttus_Config2__Left__c + 1;
                    classHierarchyList.add(cH);
                }
                
            }
            if(classHierarchyList.size()>0){
                upsert classHierarchyList Category_Hierarchy_External_ID__c; 
            }    
        }    
    }
    
    /**********************************************************************************************************************************************
     Method name:       createDataAssociations
     Reason:            This method prepares all the category hierarchy related data
     Parameter:         1. List of categories: related to the product
                        2. Parent Product: Bundle Product
                        3. List of pricelists
                        4. Catalog type from the MLG PLUS
                        5. All related products.
     Return type:       N/A  
    **********************************************************************************************************************************************/
    public void createDataAssociations (List<Apttus_Config2__ClassificationName__c> InsertCategoryList
                                        , Product2 ParentProduct
                                        , List<String> PriceListNames
                                        , String CatalogType
                                        , list<Product2> RelatedProducts ){
        
        //Map of Category external Id and record ID. 
        Map<String,ID> InsertCategoryMap = new Map<String,id>();
        //preparing InsertCategoryMap Map
        for(Apttus_Config2__ClassificationName__c ClassificationName : InsertCategoryList){
            InsertCategoryMap.put(ClassificationName.Category_External_ID__c , ClassificationName.id);
        }
        
        // Custom settings for IP types allowed in Configurator.
        CPQ_Settings__c cpqIPTypes = CPQ_Settings__c.getValues('CPQ_IP_Types'); 
        //Map of IP decive type Map: <IP or Device Type , IP or Device> 
        Map<String,string> IPDeviceTypeMap = new Map<string,String>(); 
        // Set of IP Type values.
        Set<String> IPType = new Set<String>(); 
        
        //preparing IPDeviceTypeMap and IPType
        if(ParentProduct.catalog_Type__c == 'First Source'){
            for(String str: cpqIPTypes.Value__c.split(',')){
                IPType.add(str);
                IPDeviceTypeMap.put(str,'IPs');
            }
        }
        
        //Map of Category Hierarchy and Record ID 
        Map<String, id> MapHierarchy = new Map<String,id>();
        //Map of Product Option group External ID and Feature Group External ID
        Map<String,string> optGrpEXIDvsFeatureGrpmap = new Map<String,String>();
        // Set of feature groups
        Set<String> featureGroupSet = new Set<String>();
        // List of feature groups- Used to make the ordered configuration.
        list<String> featureGroupList = new list<String>();
        // If IP is available the insert records. 
        Boolean hasIP = false;
        
        //retrieving data from MLG plus
        for(MLG_Record__c mlg : ListMLG){ // start MLG records loop.
            if(mlg.Feature_Group__c != 'Always included'
                &&     mlg.Feature_Group__c != 'DNWELL'
                &&     mlg.Feature_Group__c != 'Packaging'
                &&     mlg.Feature_Group__c != 'Metal Options'
                &&     mlg.Feature_Group__c != 'Attribute Rule'){
                // Check if the PT has IP present. 
                if(!String.isBlank(mlg.IP_Type__c)){
                    hasIP = true;
                
                }else if(!String.isBlank(mlg.Model_Name__c) && mlg.Model_Name__c != 'N/A' && mlg.Model_Name__c != 'NA'){
                    IPDeviceTypeMap.put(mlg.Feature_Group__c,'Devices');
                    
                    if(!String.isblank(mlg.Feature_Group__c) && !featureGroupSet.Contains(mlg.Feature_Group__c.trim())){
                        featureGroupSet.add(mlg.Feature_Group__c.trim());
                        featureGroupList.add(mlg.Feature_Group__c.trim());
                    }
                    
                    optGrpEXIDvsFeatureGrpmap.put(ParentProduct.Product_External_ID__c + '_'+ mlg.Model_Name__c.trim() , mlg.Feature_Group__c);
                }
            }//end of if condition
        }// end MLG records loop.
        
        integer NoOfDeviceTypes = featureGroupSet.size(); // No of Device types
        integer NoOfIPTypes = IPType.size();// No of IP types
        if(IPType.size() > 0 ) featureGroupList.addAll(IPType); // Feature Group List.
                
        //List of product option groups to be inserted. 
        List<Apttus_Config2__ProductOptionGroup__c> ProductOptionList = new List<Apttus_Config2__ProductOptionGroup__c>();
        //List of the Parent Hierarchy records to be inserted. 
        List<Apttus_Config2__ClassificationHierarchy__c> ListParentHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
        
        //preparing data for level 1 hierarchy:
        for(Apttus_Config2__ClassificationName__c categoryValue : InsertCategoryList){//start Category loop
            
            // Hierarchy record preparation
            Apttus_Config2__ClassificationHierarchy__c TempHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
                TempHierarchy.Category_Hierarchy_External_ID__c         = categoryValue.Category_External_ID__c;
                TempHierarchy.Apttus_Config2__Label__c                  = categoryValue.Apttus_Config2__HierarchyLabel__c.replace('_',' ')  ;
                TempHierarchy.Name                                      = categoryValue.Category_External_ID__c;
                TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
                if( categoryValue.Category_External_ID__c.contains('Metal_Stacks')                   
                    || categoryValue.Category_External_ID__c.contains('Mask_Sets') ){
                        TempHierarchy.Apttus_Config2__ExpandedByDefault__c  = FALSE;
                }
                else{
                    TempHierarchy.Apttus_Config2__ExpandedByDefault__c = TRUE;
                }
                TempHierarchy.Apttus_Config2__HierarchyId__c            = InsertCategoryMap.get(categoryValue.Category_External_ID__c);
                
                TempHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
                TempHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
                TempHierarchy.Apttus_Config2__Level__c                  = 0;
                TempHierarchy.Apttus_Config2__Left__c                   = 1;
                TempHierarchy.Apttus_Config2__MaxOptions__c             = 999;
                TempHierarchy.Apttus_Config2__MinOptions__c             = 0;
                TempHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
                TempHierarchy.Apttus_Config2__Right__c                  = getRightValue(TempHierarchy.Name,NoOfDeviceTypes ,NoOfIPTypes );
                System.debug('[Debug: Hierarchy check:]'+TempHierarchy);
            ListParentHierarchy.add(TempHierarchy);
            
            // Product Option Group Record Preparation: 
            Apttus_Config2__ProductOptionGroup__c TempProductOptionGroup = new Apttus_Config2__ProductOptionGroup__c();
                TempProductOptionGroup.Apttus_Config2__IsHidden__c          = FALSE;
                if( categoryValue.Category_External_ID__c.contains('Metal_Stacks')
                    || categoryValue.Category_External_ID__c.contains('EDA_Tool_Selection')
                    || categoryValue.Category_External_ID__c.contains('Mask_Sets') ){ //Start Metal Stack/Additional Questions/ Mask Sets condition
                    
                        TempProductOptionGroup.Apttus_Config2__IsLeaf__c        = TRUE;
                        TempProductOptionGroup.Apttus_Config2__Level__c         = 0;
                        TempProductOptionGroup.Apttus_Config2__RootSequence__c  = categoryValue.Category_External_ID__c.contains('Metal_Stacks') ? 1 : categoryValue.Category_External_ID__c.contains('EDA_Tool_Selection') ? 5 : categoryValue.Category_External_ID__c.contains('Mask_Sets')? 4: null ;
                        TempProductOptionGroup.Apttus_Config2__IsHidden__c      = categoryValue.Category_External_ID__c.contains('Mask_Sets') ? TRUE : FALSE ;

                }//End Metal Stack/Additional Questions/ Mask Sets condition
                else{ //Start IP and Device condition
                
                   TempProductOptionGroup.Apttus_Config2__IsHidden__c =     (hasIP == false && (categoryValue.Category_External_ID__c.contains('IPs'))) ?  TRUE :  FALSE;
                    TempProductOptionGroup.Apttus_Config2__IsLeaf__c        = FALSE;
                    TempProductOptionGroup.Apttus_Config2__Level__c         = 0;
                    TempProductOptionGroup.Apttus_Config2__RootSequence__c = categoryValue.Category_External_ID__c.contains('Devices') ? 3 : 2;                 
                }  // End  IP and Device condition     
                TempProductOptionGroup.Apttus_Config2__IsPicklist__c        = categoryValue.Category_External_ID__c.contains('Metal_Stacks')?TRUE:FALSE;    
                TempProductOptionGroup.Apttus_Config2__MaxOptions__c        = 99;
                TempProductOptionGroup.Apttus_Config2__MinOptions__c        = 0;
                TempProductOptionGroup.Apttus_Config2__ModifiableType__c    = 'Variable';
                TempProductOptionGroup.Apttus_Config2__ProductId__c         = ParentProduct.id;
                TempProductOptionGroup.Product_Option_Grp_External_ID__c    = categoryValue.Category_External_ID__c;
                TempProductOptionGroup.Apttus_Config2__Left__c              = 1;
                TempProductOptionGroup.Apttus_Config2__Right__c             = getRightValue(TempHierarchy.Name,NoOfDeviceTypes ,NoOfIPTypes );
                TempProductOptionGroup.Apttus_Config2__Sequence__c          = 0;
            
            ProductOptionList.add(TempProductOptionGroup);         
        }// end category loop.
        
        //Upsert Parent Hierarchy records.
        upsert ListParentHierarchy Category_Hierarchy_External_ID__c ;
        
        //Creating Map Hierarchy: will be used in the child Hierarchy record preparation and Prod option component creation. 
        for(Apttus_Config2__ClassificationHierarchy__c classhierarchy : ListParentHierarchy){
            MapHierarchy.put(classhierarchy.Category_Hierarchy_External_ID__c , classhierarchy.ID);
        
        }
        
        //---create 2nd level hierarchy and related option group---
        //Left And right Count variables.
        integer IPCount = 2; 
        integer DeviceCount = 2;
        
        //Final List of child Hierarchy
        List<Apttus_Config2__ClassificationHierarchy__c> ListchildHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
        
        for(String featureGroup : featureGroupList ){//Start Feature Group loop
            
            //Hierarchy record preparation.
            Apttus_Config2__ClassificationHierarchy__c TempHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
                TempHierarchy.Apttus_Config2__AncestorId__c             = MapHierarchy.get(ParentProduct.product_external_Id__c+ '_'+IPDeviceTypeMap.get(featureGroup));
                TempHierarchy.Category_Hierarchy_External_ID__c         = ParentProduct.product_external_Id__c+ '_'+featureGroup;
                TempHierarchy.Apttus_Config2__Label__c                  = featureGroup.replace('_',' ') ;
                TempHierarchy.Name                                      = ParentProduct.product_external_Id__c+ '_'+featureGroup;
                TempHierarchy.Apttus_Config2__PrimordialId__c           = MapHierarchy.get(ParentProduct.product_external_Id__c+ '_'+IPDeviceTypeMap.get(featureGroup));
                TempHierarchy.Apttus_Config2__HideAllSearchFilters__c   = FALSE;
                TempHierarchy.Apttus_Config2__HierarchyId__c            = InsertCategoryMap.get(ParentProduct.product_external_Id__c+ '_'+IPDeviceTypeMap.get(featureGroup));
                TempHierarchy.Apttus_Config2__IncludeInTotalsView__c    = TRUE;
                TempHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
                TempHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
                TempHierarchy.Apttus_Config2__Level__c                  = 0;
                TempHierarchy.Apttus_Config2__MaxOptions__c             = 99;
                TempHierarchy.Apttus_Config2__MinOptions__c             = 0;
                TempHierarchy.Apttus_Config2__Modifiable__c             = TRUE;                             
                TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = (featureGroup == 'AMS') ? TRUE : FALSE;               
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c      = (featureGroup == 'AMS') ? TRUE : FALSE;   
                TempHierarchy.Apttus_Config2__Left__c                   = (IPDeviceTypeMap.get(featureGroup ) == 'Devices') ? DeviceCount++ : IPCount++;
                TempHierarchy.Apttus_Config2__Right__c                  =  (IPDeviceTypeMap.get(featureGroup ) == 'Devices') ? DeviceCount++ : IPCount++;                                                                                                                               
                System.debug('[Debug: Hierarchy child check]:'+ParentProduct.product_external_Id__c+ '_'+IPDeviceTypeMap.get(featureGroup)+':'+ParentProduct.product_external_Id__c+ '_'+featureGroup+':'+TempHierarchy);
            ListchildHierarchy.add(TempHierarchy);
            
            // Product Option Group Record Preparation: 
            Apttus_Config2__ProductOptionGroup__c TempProductOptionGroup = new Apttus_Config2__ProductOptionGroup__c();
                TempProductOptionGroup.Apttus_Config2__IsHidden__c          = FALSE;
                TempProductOptionGroup.Apttus_Config2__IsLeaf__c            = TRUE;
                TempProductOptionGroup.Apttus_Config2__Level__c             = 1;  
                TempProductOptionGroup.Apttus_Config2__IsPicklist__c        = FALSE;            
                TempProductOptionGroup.Apttus_Config2__MaxOptions__c        = 999;
                TempProductOptionGroup.Apttus_Config2__MinOptions__c        = 0;
                TempProductOptionGroup.Apttus_Config2__ModifiableType__c    = 'Variable';
                TempProductOptionGroup.Apttus_Config2__ProductId__c         = ParentProduct.id;
                TempProductOptionGroup.Product_Option_Grp_External_ID__c    = ParentProduct.product_external_Id__c+ '_'+featureGroup;
                TempProductOptionGroup.Apttus_Config2__Left__c              = TempHierarchy.Apttus_Config2__Left__c;
                TempProductOptionGroup.Apttus_Config2__Right__c             = TempHierarchy.Apttus_Config2__Right__c;
                TempProductOptionGroup.Apttus_Config2__Sequence__c          = 0;
                TempProductOptionGroup.APTTUS_CONFIG2__ROOTSEQUENCE__C      = (IPDeviceTypeMap.get(featureGroup ) == 'Devices') ? 2 : 1 ;      
            ProductOptionList.add(TempProductOptionGroup);         
        } //End Feature Group loop
        System.debug('[debug: Hierarchy List]:' +ListchildHierarchy);
        
        //upsert Child Hierarchy 
        upsert ListchildHierarchy Category_Hierarchy_External_ID__c ;
        
        //Adding child Hierarchies in the MapHierarchy
        for(Apttus_Config2__ClassificationHierarchy__c classhierarchy : ListchildHierarchy){
            MapHierarchy.put(classhierarchy.Category_Hierarchy_External_ID__c , classhierarchy.ID);
        }
        
        //Map of Product Option group ext Id and record ID
        Map<String,Id> MapProductOptionGrp = new Map<String,Id>();
        // create Product Option groups:  
        MapProductOptionGrp = createProductOptionGroups(ProductOptionList , MapHierarchy, ParentProduct.Product_External_ID__c, IPDeviceTypeMap);   
        
        //associate option products in the configurator.
        CreateProdAssociation( CatalogType
                                , PriceListNames 
                                , optGrpEXIDvsFeatureGrpmap
                                , MapProductOptionGrp
                                , ParentProduct
                                , RelatedProducts);         
    }
    
    /**********************************************************************************************************************************
     Method name:       createProductAttributeRule
     Reason:            This method creates Product Attribute Rule and Product Attribute Rule Action for IO Voltage, Core Voltage and 
                        Packaging dependencies. 
     Parameter:         Product
     Return type:       N/A
    **********************************************************************************************************************************/
    public void createProductAttributeRule(Product2 prod){
                
        List<Apttus_Config2__ProductAttributeRule__c> prodAttValList = new List<Apttus_Config2__ProductAttributeRule__c>();
        
        Set<String> nameProdAttVal = new Set<String>();
        String prodAttRuleName = prod.ProductCode+'_Attribute_Rule';
        
        for(Apttus_Config2__ProductAttributeRule__c par : [select    id
                                                                      , name
                                                                      , Apttus_Config2__ProductScope__c
                                                                      , Product_Attribute_Rule_External_ID__c  
                                                            from      Apttus_Config2__ProductAttributeRule__c
                                                            where     Name in ('Wirebond_Attribute_Rule','Flip_Chip_Attribute_Rule',:prodAttRuleName)]){
            nameProdAttVal.add(par.Name);
            if(!(par.Apttus_Config2__ProductScope__c.contains(prod.Id)) && par.Name != prodAttRuleName)
            {
                par.Apttus_Config2__ProductScope__c += ';' + prod.Id;
                prodAttValList.add(par);
            }
        }                
        
        if(nameProdAttVal.isEmpty() || !(nameProdAttVal.contains(prodAttRuleName))){
            // Product Attribute Rule for Bundle product
            Apttus_Config2__ProductAttributeRule__c paRule = new Apttus_Config2__ProductAttributeRule__c();
            paRule.Name = prodAttRuleName;
            paRule.Product_Attribute_Rule_External_ID__c = prodAttRuleName;
            paRule.Apttus_Config2__AccountScope__c = 'All';
            paRule.Apttus_Config2__ProductFamilyScopeOper__c = 'in';
            paRule.Apttus_Config2__ProductFamilyScope__c = 'All';
            paRule.Apttus_Config2__ProductGroupScopeOper__c = 'in';
            paRule.Apttus_Config2__ProductGroupScope__c = 'All';
            paRule.Apttus_Config2__ProductScopeOper__c = 'in';
            paRule.Apttus_Config2__ProductScope__c = prod.Id;
            paRule.Apttus_Config2__ConditionCriteriaExpression__c = '$.Apttus_Config2__AttributeValueId__r.APTPS_ProcessTechnology__c==\''+prod.PT_Number__c+'\'';
            prodAttValList.add(paRule);
        }
        
        if(prodAttValList.size()>0){
            upsert prodAttValList Product_Attribute_Rule_External_ID__c;
        }
        
        List<Apttus_Config2__ProductAttributeRule__c> paR = [select id from Apttus_Config2__ProductAttributeRule__c where name = :prodAttRuleName];
        
        Set<string> CoreVoltages = new Set<String>();
        Set<String> IOVoltages = new Set<String>();
        for(MLG_Record__c mlg : ListMLG){
            if(mlg.IO_Voltage_V__c != null 
                && mlg.IO_Voltage_V__c != 'NA' 
                && mlg.IO_Voltage_V__c != 'N/A'){
                IOVoltages.add(mlg.IO_Voltage_V__c);
            }
            if(mlg.Core_Voltage_V__c != null 
                && mlg.Core_Voltage_V__c != 'NA' 
                && mlg.Core_Voltage_V__c != 'N/A'){
                CoreVoltages.add(mlg.Core_Voltage_V__c);
            }
        }
        
        String coreVoltagesStr = '';
        String ioVoltagesStr = '';
        Integer i=0;
        
        for(String str : CoreVoltages){
          if(i==0){
              coreVoltagesStr = '\''+str + ';';
              i++;
          }else{
              coreVoltagesStr += str + ';';
          }     
        }
        if(coreVoltagesStr != ''){
            coreVoltagesStr += '\''; 
        }
        i=0;
        for(String str : IOVoltages){
          if(i==0){
              ioVoltagesStr = '\''+str + ';';
              i++;
          }else{
              ioVoltagesStr += str + ';';
          }     
        }
        if(ioVoltagesStr != ''){
            ioVoltagesStr += '\''; 
        }
        
        List<Apttus_Config2__ProductAttributeRuleAction__c> paRuleActionList = new List<Apttus_Config2__ProductAttributeRuleAction__c>();
        Apttus_Config2__ProductAttributeRuleAction__c paAttRuleAction1 
                        = getProductAttributeRuleAction(prod.ProductCode+'_Attribute_Rule_Action_Allow_IO_Voltages',
                                                        'Apttus_Config2__ProductAttributeValue__c.IO_Voltage__c',
                                                        ioVoltagesStr,
                                                        'Allow',
                                                        paR[0].Id
                                                        );
                                                        
        Apttus_Config2__ProductAttributeRuleAction__c paAttRuleAction2 
                        = getProductAttributeRuleAction(prod.ProductCode+'_Attribute_Rule_Action_Allow_Core_Voltages',
                                                        'Apttus_Config2__ProductAttributeValue__c.core_voltagae__c',
                                                        coreVoltagesStr,
                                                        'Allow',
                                                        paR[0].Id
                                                        );                                                
        
        paRuleActionList.add(paAttRuleAction1);
        paRuleActionList.add(paAttRuleAction2);
        
        upsert paRuleActionList Product_Attribute_Rule_Action_Ext_ID__c;

    }
    
    
    /**********************************************************************************************************************************
     Method name:       getProductAttributeRuleAction
     Reason:            This method retrieves the Product Attribute Rule Action 
     Parameter:         1. Product Attribute Rule Action Name
                        2. Target Attribute
                        3. Value Expression
                        4. Action
                        5. Product Attribute Rule Id
     Return type:       Product Attribute Rule Action
    **********************************************************************************************************************************/
    public Apttus_Config2__ProductAttributeRuleAction__c getProductAttributeRuleAction(String actionName, String targetAttribute, String value, String action, String prodAttrId){
        Apttus_Config2__ProductAttributeRuleAction__c paRuleAction = new Apttus_Config2__ProductAttributeRuleAction__c();
        paRuleAction.Name = actionName;
        paRuleAction.Product_Attribute_Rule_Action_Ext_ID__c = actionName;
        paRuleAction.Apttus_Config2__Field__c = targetAttribute;
        paRuleAction.Apttus_Config2__ValueExpression__c = value;
        paRuleAction.Apttus_Config2__ProductAttributeRuleId__c = prodAttrId;
        paRuleAction.Apttus_Config2__AccountScopeOper__c = 'in';
        paRuleAction.Apttus_Config2__ProductFamilyScopeOper__c = 'in';
        paRuleAction.Apttus_Config2__ProductFamilyScope__c = 'All';
        paRuleAction.Apttus_Config2__ProductGroupScopeOper__c = 'in';
        paRuleAction.Apttus_Config2__ProductGroupScope__c = 'All';
        paRuleAction.Apttus_Config2__ProductScopeOper__c = 'in';
        paRuleAction.Apttus_Config2__ProductScope__c = 'All';
        paRuleAction.Apttus_Config2__Action__c = action;
        return paRuleAction;
    }   
    
    /*********************************************************************************************************************************/
    
    /**********************************************************************************************************************************************
     Method name:       getRightValue
     Reason:            This method Returns value of the right field of particular node for product option group and product hierachy. 
     Parameter:         1. String: Category Name
                        2. Integer: No of deviceTypes. 
                        3. Integer: NO of Ip Types.
     Return type:       integer: values of the right node. 
    **********************************************************************************************************************************************/
    public integer getRightValue(String CategoryName,integer NoOfDeviceTypes , integer NoOfIPTypes){
        if( CategoryName.contains('Metal_Stacks')||
            CategoryName.contains('EDA_Tool_Selection') ||
            CategoryName.contains('Mask_Sets') ){
            return 2;
        }
        else{
            if(CategoryName.contains('Devices')){
                return (NoOfDeviceTypes*2 + 2);
            }
            else if(CategoryName.contains('IPs')){
                return (NoOfIPTypes*2 + 2);
            }
            else{
                return null;
            }
        }
    }
    
    /**********************************************************************************************************************************************
     Method name:       createProductOptionGroups
     Reason:            This method creates Product option groups.  
     Parameter:         
     Return type:       Map of 
    **********************************************************************************************************************************************/
    public Map<String,Id> createProductOptionGroups (List<Apttus_Config2__ProductOptionGroup__c> ProductOptionList
                                                        , Map<String,Id> MapHierarchy 
                                                        , string ProductExtId
                                                        , Map<String,string> IPDeviceTypeMap){
        List<Apttus_Config2__ProductOptionGroup__c> FinalProductOptionList = new List<Apttus_Config2__ProductOptionGroup__c>();
        for(Apttus_Config2__ProductOptionGroup__c prodOptGrp :ProductOptionList){
            prodOptGrp.Apttus_Config2__OptionGroupId__c                    =  MapHierarchy.get(prodOptGrp.Product_Option_Grp_External_ID__c);
            if(prodOptGrp.Product_Option_Grp_External_ID__c.contains('_IPs')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Metal_Stacks')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_EDA_Tool_Selection')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Mask_Sets')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Devices')){
            
                prodOptGrp.Apttus_Config2__ParentOptionGroupId__c              =  NULL;
                prodOptGrp.Apttus_Config2__RootOptionGroupId__c                =  MapHierarchy.get(prodOptGrp.Product_Option_Grp_External_ID__c);
            }
            else{
                prodOptGrp.Apttus_Config2__ParentOptionGroupId__c              =  MapHierarchy.get(ProductExtId+'_'+IPDeviceTypeMap.get(prodOptGrp.Product_Option_Grp_External_ID__c.replace(ProductExtId+'_',''))); 
                prodOptGrp.Apttus_Config2__RootOptionGroupId__c                =  MapHierarchy.get(ProductExtId+'_'+IPDeviceTypeMap.get(prodOptGrp.Product_Option_Grp_External_ID__c.replace(ProductExtId+'_',''))); 
            }
            system.debug('[debug: finalproductoption group]'+prodOptGrp);
            FinalProductOptionList.add(prodOptGrp);
        }
        upsert FinalProductOptionList Product_Option_Grp_External_ID__c;
        Map<String,Id> MapProductOption = new Map<String,Id>();
        for(Apttus_Config2__ProductOptionGroup__c prodOptionGrp: FinalProductOptionList ){
            MapProductOption.put(prodOptionGrp.Product_Option_Grp_External_ID__c, prodOptionGrp.ID);
        }
        return MapProductOption;
    }
    
    /**********************************************************************************************************************************************
     Method name:       getProductOptionComponent
     Reason:            This method returns Product Option components   
     Parameter:         
     Return type:       Product option component: Load ready record.  
    **********************************************************************************************************************************************/
    public Apttus_Config2__ProductOptionComponent__c getProductOptionComponent(Map<String,string>optGrpEXIDvsFeatureGrpmap, Map<String,Id>MapProductOption, product2 prod,product2 ParentProduct, integer ComponentCount ){
        system.debug('[debug: Product name]'+prod.name);
        Apttus_Config2__ProductOptionComponent__c TempProdOptionComponent = new Apttus_Config2__ProductOptionComponent__c();
            TempProdOptionComponent.Apttus_Config2__AllowCloning__c        = FALSE;
            TempProdOptionComponent.Apttus_Config2__ComponentProductId__c  = prod.id;
            TempProdOptionComponent.Apttus_Config2__Default__c             = FALSE;
            TempProdOptionComponent.Apttus_Config2__Modifiable__c          = FALSE;
            TempProdOptionComponent.Apttus_Config2__ParentProductId__c     = ParentProduct.id;            
            TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= prod.family == 'Mask Layers' ? MapProductOption.get(ParentProduct.Product_External_ID__c +'_Mask_Sets') : prod.family == 'Metal Stacks' ? MapProductOption.get(ParentProduct.Product_External_ID__c +'_Metal_Stacks') : prod.family == 'Devices' ? MapProductOption.get(ParentProduct.Product_External_ID__c +'_'+optGrpEXIDvsFeatureGrpmap.get(prod.Product_External_ID__c )) : prod.family == 'IPs' ? MapProductOption.get(ParentProduct.Product_External_ID__c +'_'+prod.APTPS_IP_Type__c) : prod.family == 'Additional Questions' ? MapProductOption.get(ParentProduct.Product_External_ID__c +'_EDA_Tool_Selection') : null;
            TempProdOptionComponent.Option_Component_External_ID__c        = prod.Product_External_ID__c.contains(ParentProduct.Product_External_ID__c)? prod.Product_External_ID__c: ParentProduct.Product_External_ID__c+ '_'+ prod.Product_External_ID__c;
            TempProdOptionComponent.Apttus_Config2__RelationshipType__c    = 'Option';
            TempProdOptionComponent.Apttus_Config2__Required__c            = FALSE;
            TempProdOptionComponent.Apttus_Config2__Sequence__c            = ComponentCount;
        return TempProdOptionComponent;
    }
    
    
    /**********************************************************************************************************************************************
     Method name:       getProductClassification
     Reason:            This method returns Product Classification record.   
     Parameter:         
     Return type:       Product option component: Load ready record.  
    **********************************************************************************************************************************************/
    public Apttus_Config2__ProductClassification__c getProductClassification(   String TypeProd
                                                                                , Product2 IPProd
                                                                                , Map<String,String>MapClassificationHierarchyIP){
        //variable to store geometry value. 
        String strGeom; 
        //if the geometry contains nm then change the geomerty value to UM format.
        if( !IPProd.Geometry__c.contains('>') 
            && IPProd.Geometry__c.contains('UM')){
            Integer geom = Integer.valueOf(decimal.valueOf(IPProd.Geometry__c.replace('UM',''))*1000);
            system.debug('DEBUG: PS: Length of the string'+String.valueOf(geom).length());
            String geomValue = String.valueOf(geom); 
            
            system.debug('DEBUG: PS: geomvalue string'+ geomValue);
            strGeom = geomValue + 'nm';
        }
        //else UM value would be considered
        else{
            strGeom = IPProd.Geometry__c == '>0.18UM' ? '>180nm' : IPProd.Geometry__c;
        }
        
        Apttus_Config2__ProductClassification__c TempProdCalssification = new Apttus_Config2__ProductClassification__c ();
        
        if(TypeProd == 'IP'){
            String ipType = MapClassificationHierarchyIP.containsKey(IPProd.APTPS_IP_Type__c) ? IPProd.APTPS_IP_Type__c : 'OTHER';
            TempProdCalssification.Apttus_Config2__ClassificationId__c    = MapClassificationHierarchyIP.get(ipType);
            TempProdCalssification.Product_Classification_External_ID__c  = IPProd.Product_External_ID__c + '_'+ ipType;
        }
        else{
            TempProdCalssification.Apttus_Config2__ClassificationId__c    = MapClassificationHierarchyIP.get(IPProd.Catalog_Type__c == 'First Source' ? strGeom.toUpperCase() : (strGeom+'_2nd').toUpperCase());    
            TempProdCalssification.Product_Classification_External_ID__c  = IPProd.Product_External_ID__c  + '_' +  strGeom.toUpperCase();
        }
        TempProdCalssification.Apttus_Config2__DefaultQuantity__c         = 1; 
        TempProdCalssification.Apttus_Config2__MaxQuantity__c             = 1;
        TempProdCalssification.Apttus_Config2__MinQuantity__c             = 0;
        TempProdCalssification.Apttus_Config2__Modifiable__c              = TRUE;
        TempProdCalssification.Apttus_Config2__ProductId__c               = IPProd.ID;
        system.debug('[Debug:temp Product Classification: ]'+TempProdCalssification);
        return TempProdCalssification;
    }
    
    /**********************************************************************************************************************************************
     Method name:       getPriceListItem
     Reason:            This method returns price list items 
     Parameter:         1. List of price list: for which this product is applicable
     `                  2. Product record
     Return type:       Price list item: Load ready record.  
    **********************************************************************************************************************************************/
    public List<Apttus_Config2__PriceListItem__c> getPriceListItem (List<Apttus_Config2__PriceList__c> ListPriceList 
                                                                    , product2 prod ){
        List<Apttus_Config2__PriceListItem__c> FinalPrcList = new List<Apttus_Config2__PriceListItem__c>();
        for(Apttus_Config2__PriceList__c PrcList : ListPriceList){
            //preparing price list item record
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
                TempPriceListItem.Apttus_Config2__PriceListId__c                   = PrcList.ID;
                TempPriceListItem.Apttus_Config2__PriceMethod__c                   = 'Per Unit';
                TempPriceListItem.Apttus_Config2__PriceType__c                     = 'One Time';
                TempPriceListItem.Apttus_Config2__PriceUom__c                      = 'Each';
                TempPriceListItem.Apttus_Config2__ProductId__c                     = prod.id; 
                TempPriceListItem.PriceListItemExternal_ID__c                      = prod.Product_External_ID__c +'_'+PrcList.name;
            FinalPrcList.add(TempPriceListItem);
        }
        Return FinalPrcList;
    }    
    
    public void CreateProdAssociation(String CatalogType
                                        , List<String> PriceListNames 
                                        , Map<String,string>optGrpEXIDvsFeatureGrpmap
                                        , Map<String,Id> MapProductOption
                                        , Product2 ParentProduct
                                        , List<Product2> RelatedProducts){
        List<Apttus_Config2__ProductOptionComponent__c> InsertProdOptionComp = new List<Apttus_Config2__ProductOptionComponent__c>();
        List<Apttus_Config2__PriceListItem__c> InsertPriceListItem = new List<Apttus_Config2__PriceListItem__c>();
        List<Apttus_Config2__ProductClassification__c> IPProdClassification = new List<Apttus_Config2__ProductClassification__c>();
        List<Product2> IPProduct = new List<Product2>();
        CPQ_Settings__c CatalogTypeHierarchy = CPQ_Settings__c.getValues(CatalogType);
        CPQ_Settings__c cpqSetting3 = CPQ_Settings__c.getValues('IP_Lifecycle_Exeption');
        System.debug('[Debug: Catalog type: Expected(First Source)]'+ CatalogType);
        System.debug('[Debug: Catalog type Value : Expected(GLOBALFOUNDRIES Offering)]'+ CatalogTypeHierarchy.Value__c);
        Map<String,String> MapClassificationHierarchyIP = new Map<String,String>();
        for(Apttus_Config2__ClassificationHierarchy__c classHierarchy : [SELECT    ID
                                                                                   , NAME
                                                                                   , Category_Hierarchy_External_ID__c
                                                                                   , Apttus_Config2__HierarchyId__c
                                                                                   , Apttus_Config2__HierarchyId__r.name
                                                                         FROM      Apttus_Config2__ClassificationHierarchy__c 
                                                                         WHERE     Apttus_Config2__HierarchyId__r.name = :CatalogTypeHierarchy.Value__c
                                                                         AND       Category_Hierarchy_External_ID__c != null]){
            System.debug('[Debug: Category ext ID]'+ classHierarchy.Category_Hierarchy_External_ID__c);
            MapClassificationHierarchyIP.put(classHierarchy.Category_Hierarchy_External_ID__c.toUpperCase(),classHierarchy.ID);
        }
        List<Apttus_Config2__PriceList__c> ListPriceList = new List<Apttus_Config2__PriceList__c> ();
        if(PriceListNames.size()==0)
        { 
             system.debug('We are in True part>>>');         
             ListPriceList = [SELECT id,name from Apttus_Config2__PriceList__c];
        }
        
        else
        {
             system.debug('We are in False part>>>');         
             ListPriceList = [SELECT id,name from Apttus_Config2__PriceList__c where Name IN:PriceListNames];
        
        }
        integer ComponentCount = 1;
        for(product2 prod : RelatedProducts){
                if(prod.Family != 'IPs' || prod.APTPS_IP_Lifecycle__c != cpqsetting3.Value__c){
                    InsertProdOptionComp.add(getProductOptionComponent(optGrpEXIDvsFeatureGrpmap, MapProductOption,prod,ParentProduct,ComponentCount++ ));
                }
                
                InsertPriceListItem.addAll(getPriceListItem(ListPriceList ,prod));
                if(prod.Family == 'IPs'){
                    IPProdClassification.add(getProductClassification('IP',prod,MapClassificationHierarchyIP));
                }
                
        }
      
        for(product2 aqProd : [select id,Product_External_ID__c,APTPS_IP_Type__c,family,name from product2 where family = 'Additional Questions' order by name]){
            InsertProdOptionComp.add(getProductOptionComponent(optGrpEXIDvsFeatureGrpmap, MapProductOption,aqProd,ParentProduct,ComponentCount++ ));
        }
        
        IPProdClassification.add(getProductClassification('Product', ParentProduct, MapClassificationHierarchyIP));
        InsertPriceListItem.addAll(getPriceListItem(ListPriceList ,ParentProduct));
        upsert InsertProdOptionComp Option_Component_External_ID__c;
        upsert InsertPriceListItem PriceListItemExternal_ID__c;
        system.debug('[debug:IPProdClassification -->]'+IPProdClassification);
        upsert IPProdClassification Product_Classification_External_ID__c  ;        
    }
    
    /**********************************************************************************************************************************************
     Method name:       getConstraintRule
     Reason:            This method Creates Constraint rules 
     Parameter:         1. Parent Product
     `                  2. List of MLG records
     Return type:       Map: Constraint rule name to Constraint rule ID
    **********************************************************************************************************************************************/
    public Map<String,String> getConstraintRule(Product2 Prod, Map<String,Product2> MapRelatedProducts){
        List<Apttus_Config2__ConstraintRule__c> FinalConstraintRuleList = new List<Apttus_Config2__ConstraintRule__c>();
        Map<String,String> FinalConstraintRuleMap = new Map<String,string>(); //Key: Constraint rule name && Value: Constraint rule ID;
        for(MLG_Record__c mlg: ListMlg){
            
            // Add constraint rule for devices.
            if(mlg.Model_Name__c != NULL && mlg.ADDITIONAL_MASK_S__C != NULL && mlg.Model_Name__c != 'N/A' && mlg.Model_Name__c != 'NA' && mlg.ADDITIONAL_MASK_S__C != 'N/A' && mlg.ADDITIONAL_MASK_S__C != 'NA' && mlg.Parent_Attribute_Rule_ID__c == null){
                system.debug('[debug:mlg name]'+mlg.Model_Name__c);
                FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_'+mlg.Model_Name__c));
            }
            
            // Add constraint rule for metal options
            if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                FinalConstraintRuleList.add(getTempConstraintRule(mlg.FEATURE_DESCRIPTION__C+'_'+Prod.Product_External_ID__c));    
                if(mlg.ADDITIONAL_MASK_S__C != NULL){
                    for(String mask : mlg.ADDITIONAL_MASK_S__C.Split(',')){
                        FinalConstraintRuleList.add(getTempConstraintRule(mlg.FEATURE_DESCRIPTION__C+'_'+Prod.Product_External_ID__c+'_'+mask.trim()));    
                    }
                }
            }
            // Add Constraint Rule for IPs
            if(mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL && MapRelatedProducts.containskey(mlg.IP_Number__c)){
                FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_'+mlg.IP_Number__c)); 
            }
            if(mlg.Parent_Attribute_Rule_ID__c != NULL){
                if(!CompundRuleMap.containsKey(mlg.Parent_Attribute_Rule_ID__c)){
                    List<MLG_Record__c> tempMlg = new List<MLG_Record__c>();
                    tempMlg.add(mlg);
                    CompundRuleMap.put(mlg.Parent_Attribute_Rule_ID__c,tempMlg);
                }else{
                    CompundRuleMap.get(mlg.Parent_Attribute_Rule_ID__c).add(mlg);
                }
            }
        }
        //general records
        FinalConstraintRuleList.add(getTempConstraintRule('DNWELL_'+Prod.Product_External_ID__c));
        FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_Default Masksets'));
        FinalConstraintRuleList.add(getTempConstraintRule('Packaging_Flip_Chip_'+Prod.Product_External_ID__c));
        FinalConstraintRuleList.add(getTempConstraintRule('Packaging_Wirebond_'+Prod.Product_External_ID__c));
        FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+' Geometry Validation'));
        for(String str: CompundRuleMap.keyset()){
            FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_'+CompundRuleMap.get(str)[0].Feature_Description__c.left(CompundRuleMap.get(str)[0].Feature_Description__c.length()-2)));
        }
      
        upsert FinalConstraintRuleList Constraint_Rule_External_Id__c;
        
        for(Apttus_Config2__ConstraintRule__c crule : FinalConstraintRuleList){
           FinalConstraintRuleMap.put(crule.Constraint_Rule_External_Id__c, crule.id);
            /*::::::::::::::::::::testing purpose:::::::::::::::::*/
            System.debug('[debug: Constraint Rule Name]: '+crule.Name);
        }
        return FinalConstraintRuleMap;
    }
    
    /**********************************************************************************************************************************************
     Method name:       getTempConstraintRule
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule record.
    **********************************************************************************************************************************************/
    public Apttus_Config2__ConstraintRule__c getTempConstraintRule(String ConstraintRuleName){
        system.debug('[debug: constraint Rule Ext ID:]'+ConstraintRuleName);
        Apttus_Config2__ConstraintRule__c TempConstraintRule = new Apttus_Config2__ConstraintRule__c();
            TempConstraintRule.Apttus_Config2__Active__c                = TRUE;
            TempConstraintRule.Constraint_Rule_External_Id__c           = ConstraintRuleName;
            TempConstraintRule.Name                                     = ConstraintRuleName;
            TempConstraintRule.Apttus_Config2__MatchInAsset__c          = FALSE;
            TempConstraintRule.Apttus_Config2__MatchInOptions__c        = FALSE;
            TempConstraintRule.Apttus_Config2__MatchInPrimaryLines__c   = FALSE;
        return TempConstraintRule;
    }
    
    /**********************************************************************************************************************************************
     Method name:       createConstraintRuleConditions
     Reason:            This method returns Constraint rule Conditions load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule record.
    **********************************************************************************************************************************************/
    public void createConstraintRuleConditions(map<String,string> ConstraintRuleMap
                                           , Product2 ParentProduct 
                                           , Map<string,Product2> ProductCodeVsProductMap){
        
        List<Apttus_Config2__ConstraintRuleCondition__c> FinalConstraintRuleCondition = new List<Apttus_Config2__ConstraintRuleCondition__c>();
        FinalConstraintRuleCondition.add(getProdConstraintCondition('General', 'DNWELL_'+ParentProduct.Product_External_ID__c , ConstraintRuleMap , ParentProduct, null));
        FinalConstraintRuleCondition.add(getProdConstraintCondition('General', ParentProduct.Product_External_ID__c+'_Default Masksets' , ConstraintRuleMap , ParentProduct, null));
        FinalConstraintRuleCondition.add(getProdConstraintCondition('General', 'Packaging_Flip_Chip_'+ParentProduct.Product_External_ID__c , ConstraintRuleMap , ParentProduct, null));
        FinalConstraintRuleCondition.add(getProdConstraintCondition('General', 'Packaging_Wirebond_'+ParentProduct.Product_External_ID__c , ConstraintRuleMap , ParentProduct, null));
        FinalConstraintRuleCondition.add(getProdConstraintCondition('General', ParentProduct.Product_External_ID__c+' Geometry Validation' , ConstraintRuleMap , ParentProduct, null));
        list<string> deviceList = new list<String>();
        for(MLG_Record__c mlg: ListMlg){
            //devices
            if((mlg.Model_Name__c != NULL && mlg.ADDITIONAL_MASK_S__C != NULL && mlg.Feature_Group__c != 'Attribute Rule') || (mlg.Feature_Group__c == 'Attribute Rule' && mlg.Parent_Attribute_Rule_ID__c == NULL)){
                product2 tempProd = ProductCodeVsProductMap.get(ParentProduct.Product_External_ID__c+'_'+mlg.Model_Name__c );
                if(tempProd != null){
                    FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(ParentProduct.Product_External_ID__c+'_'+mlg.Model_Name__c , ConstraintRuleMap,tempProd ));
                    deviceList.add(mlg.Model_Name__c);
                }
            }
            
            if(mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL){
                product2 tempProd = ProductCodeVsProductMap.get(mlg.IP_Number__c);
                if(tempProd != null){
                    FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(ParentProduct.Product_External_ID__c+'_'+ mlg.IP_Number__c , ConstraintRuleMap,tempProd ));
                }
            }
            
            //metal options
            if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                FinalConstraintRuleCondition.add(getProdConstraintCondition('Metal', mlg.FEATURE_DESCRIPTION__C, ConstraintRuleMap , ParentProduct, null));    
                if(mlg.ADDITIONAL_MASK_S__C != NULL){
                    Product2 TempMetalProd = ProductCodeVsProductMap.get(mlg.FEATURE_DESCRIPTION__C+'_'+ParentProduct.Product_External_ID__c);
                    for(String mask : mlg.ADDITIONAL_MASK_S__C.Split(',')){
                        FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(mlg.FEATURE_DESCRIPTION__C+'_'+ParentProduct.Product_External_ID__c+'_'+mask.trim() , ConstraintRuleMap, TempMetalProd ));    
                    }
                }
            }
            //Attribute Rule
            if(mlg.FEATURE_GROUP__C == 'Attribute Rule' && mlg.ADDITIONAL_MASK_S__C != NULL && mlg.Parent_Attribute_Rule_ID__c == NULL){
                FinalConstraintRuleCondition.add(getProdConstraintCondition('Attribute'
                                                                            , mlg.MLG_External_ID__c.contains(ParentProduct.Product_External_ID__c) ? mlg.MLG_External_ID__c : ParentProduct.Product_External_ID__c+'_'+ mlg.MLG_External_ID__c 
                                                                            , ConstraintRuleMap 
                                                                            , ParentProduct
                                                                            , mlg)); 
            }
        }
        
        for(String RuleID : CompundRuleMap.keyset()){
            FinalConstraintRuleCondition.add(getConstraintCompoundCondition( ParentProduct.Product_External_ID__c+'_'+CompundRuleMap.get(RuleID)[0].Feature_Description__c.left(CompundRuleMap.get(RuleID)[0].Feature_Description__c.length()-2)
                                                                            , ConstraintRuleMap 
                                                                            , ParentProduct
                                                                            , CompundRuleMap.get(RuleID))); 
        }
        
        Upsert FinalConstraintRuleCondition Constraint_Rule_Condition_External_ID__c;
        system.debug('All condiions: ' + deviceList);
    }
    
    
    /**********************************************************************************************************************************************
     Method name:       getConstraintCompoundCondition
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule record.
    **********************************************************************************************************************************************/ 
    public Apttus_Config2__ConstraintRuleCondition__c getConstraintCompoundCondition( String ConstraintRuleName 
                                                                                    , map<String ,string> ConstraintRuleMap
                                                                                    , Product2 Prod
                                                                                    , List<MLG_Record__c> mlgList){
        Apttus_Config2__ConstraintRuleCondition__c TempConstraintRuleCond = new Apttus_Config2__ConstraintRuleCondition__c();
            String FormulaString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ ' ; 
            String condExpr = '],"condExpr" : "1';
            String FieldValue1 ; 
            String FieldValue2 ; 
            for(integer i=1 ; i<= mlgList.size(); i++){
                FormulaString  = FormulaString + '{"RowNum" : '+i+',"FieldValue" : "'+mlgList[i-1].Device_List__c+'", "FieldType" : "STRING","FieldName" : "Apttus_Config2__AttributeValueId__r.'+mlgList[i-1].Model_Name__c+'","FieldLabel" : "'+mlgList[i-1].Model_Name__c+'","CompOper" : "equal to","BoolOper" : "AND"},'; 
                if(i>1){ 
                    condExpr = condExpr + ' AND '+ i ;
                    FieldValue1 = FieldValue1 + ',"Apttus_Config2__AttributeValueId__r.' +mlgList[i-1].Model_Name__c +'"' ; 
                    FieldValue2 = FieldValue2 + ' AND ('+mlgList[i-1].Model_Name__c+'=' + mlgList[i-1].Device_List__c +')';
                }
                if(i==1){
                    FieldValue1 = '"Apttus_Config2__AttributeValueId__r.'+mlgList[i-1].Model_Name__c +'"'; 
                    FieldValue2 = '('+mlgList[i-1].Model_Name__c+'=' + mlgList[i-1].Device_List__c +')';
                }
            }
            FormulaString = FormulaString.substring(0,FormulaString.length()-1);            
            FormulaString = FormulaString + condExpr + '","childFilter" : null},"fields" : [ ' + FieldValue1 +'],"exprStr" : "' +FieldValue2+ '"}' ; 
            
            TempConstraintRuleCond.Apttus_Config2__ConditionCriteria__c            = FormulaString ;
            TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
            TempConstraintRuleCond.Name                                            = ConstraintRuleName;
            TempConstraintRuleCond.Constraint_Rule_Condition_External_ID__c        = TempConstraintRuleCond.Name ;
            TempConstraintRuleCond.Apttus_Config2__MatchInAsset__c                 = FALSE;
            TempConstraintRuleCond.Apttus_Config2__MatchInCartOptions__c           = FALSE;
            TempConstraintRuleCond.Apttus_Config2__MatchInLocation__c              = FALSE;
            TempConstraintRuleCond.Apttus_Config2__MatchInOptions__c               = FALSE;
            TempConstraintRuleCond.Apttus_Config2__MatchInPrimaryLines__c          = TRUE;
            TempConstraintRuleCond.Apttus_Config2__ProductId__c                    = Prod.Id;
            TempConstraintRuleCond.Apttus_Config2__ProductScope__c                 = 'Product';
        return TempConstraintRuleCond;
    }
    
    
    /**********************************************************************************************************************************************
     Method name:       getProdConstraintCondition
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule record.
    **********************************************************************************************************************************************/ 
    public Apttus_Config2__ConstraintRuleCondition__c getProdConstraintCondition(String ConditionType 
                                                                                , String ConstraintRuleName 
                                                                                , map<String ,string> ConstraintRuleMap
                                                                                , Product2 Prod
                                                                                , MLG_Record__c mlg){
        if(ConstraintRuleMap.containsKey(ConstraintRuleName) || ConstraintRuleMap.containsKey(ConstraintRuleName+'_'+Prod.Product_External_ID__c )){
            Apttus_Config2__ConstraintRuleCondition__c TempConstraintRuleCond = new Apttus_Config2__ConstraintRuleCondition__c();
                if(ConditionType == 'General'){
                    TempConstraintRuleCond.Apttus_Config2__ConditionCriteria__c            = getConditionCriteria(ConstraintRuleName,FALSE, null);
                    TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
                    TempConstraintRuleCond.Name                                            = ConstraintRuleName;
                    
                }
                else if(ConditionType == 'Metal'){ 
                    TempConstraintRuleCond.Apttus_Config2__ConditionCriteria__c            = getConditionCriteria(ConstraintRuleName,TRUE,null);
                    TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName+'_'+Prod.Product_External_ID__c );
                    TempConstraintRuleCond.Name                                            = ConstraintRuleName+'_'+Prod.Product_External_ID__c ;
                }
                else if(ConditionType == 'Attribute'){
                    TempConstraintRuleCond.Apttus_Config2__ConditionCriteria__c            = getConditionCriteria(ConstraintRuleName,FALSE, mlg);
                    TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
                    TempConstraintRuleCond.Name                                            = ConstraintRuleName;
                }
                TempConstraintRuleCond.Constraint_Rule_Condition_External_ID__c        = TempConstraintRuleCond.Name ;
                TempConstraintRuleCond.Apttus_Config2__MatchInAsset__c                 = FALSE;
                TempConstraintRuleCond.Apttus_Config2__MatchInCartOptions__c           = FALSE;
                TempConstraintRuleCond.Apttus_Config2__MatchInLocation__c              = FALSE;
                TempConstraintRuleCond.Apttus_Config2__MatchInOptions__c               = FALSE;
                TempConstraintRuleCond.Apttus_Config2__MatchInPrimaryLines__c          = TRUE;
                TempConstraintRuleCond.Apttus_Config2__ProductId__c                    = Prod.Id;
                TempConstraintRuleCond.Apttus_Config2__ProductScope__c                 = 'Product';
            return TempConstraintRuleCond;
        }else{
            return null;
        }
    }
    
    /**********************************************************************************************************************************************
     Method name:       getConditionCriteria
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule record.
    **********************************************************************************************************************************************/ 
    public String getConditionCriteria(String ConstraintRuleName, Boolean ISMetalOption , MLG_Record__c mlg){
        String FinalConditionString;
        system.debug('[debug: ConstraintRuleName]-->'+ConstraintRuleName);
        if(ISMetalOption == FALSE){
            if(ConstraintRuleName.contains('DNWELL_')){
                FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "Yes", "FieldType" : "PICKLIST","FieldName" : "Apttus_Config2__AttributeValueId__r.APTPS_DNWELL_Needed__c","FieldLabel" : "Deep Nwell (Triple well) Needed","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.APTPS_DNWELL_Needed__c" ],"exprStr" : "(DNWELL Needed = Yes)"}';
            }                             
            else if(ConstraintRuleName.contains('Packaging_Flip_Chip_')){                              
                FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "Flip Chip","FieldType" : "PICKLIST","FieldName" : "Apttus_Config2__AttributeValueId__r.APTPS_Packaging_Option__c","FieldLabel" : "Packaging Option","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.APTPS_Packaging_Option__c" ],"exprStr" : "(Packaging Option = Flip Chip)"}';
            } 
            else if(ConstraintRuleName.contains('Packaging_Wirebond_')){                              
                FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "Wirebond","FieldType" : "PICKLIST","FieldName" : "Apttus_Config2__AttributeValueId__r.APTPS_Packaging_Option__c","FieldLabel" : "Packaging Option","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.APTPS_Packaging_Option__c" ],"exprStr" : "(Packaging Option = Wirebond)"}';
            } 
            else if(ConstraintRuleName.contains('Geometry Validation')){ 
                String str = ConstraintRuleName.subString(0,2);                             
                FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "'+str+'","FieldType" : "STRING","FieldName" : "APT_PS_Allowed_Geometries__c","FieldLabel" : "Allowed Geometries","CompOper" : "does not contain","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "APT_PS_Allowed_Geometries__c" ],"exprStr" : "(Allowed Geometries LIKE '+str+')"}';
            }  
            else if(mlg != null && mlg.Feature_Group__c == 'Attribute Rule' && mlg.Parent_Attribute_Rule_ID__c == NULL){
                FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "'+mlg.Device_List__c+'", "FieldType" : "STRING","FieldName" : "Apttus_Config2__AttributeValueId__r.'+mlg.Model_Name__c+'","FieldLabel" : "'+mlg.Feature_Description__c+'","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.'+mlg.Model_Name__c+'" ],"exprStr" : "( '+mlg.Feature_Description__c +' = '+mlg.Device_List__c+')"}';
            }                             
        }
        
        else{
            FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "'+ConstraintRuleName+'","FieldType" : "PICKLIST","FieldName" : "Apttus_Config2__AttributeValueId__r.APTPS_Metal_Options__c","FieldLabel" : "Metal Options","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.APTPS_Metal_Options__c" ],"exprStr" : "(Metal Options = '+ConstraintRuleName+'"}';
        }
        return FinalConditionString;
    }
    
    /**********************************************************************************************************************************************
     Method name:       getTempConstraintRuleCondition
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule record.
    **********************************************************************************************************************************************/ 
    public Apttus_Config2__ConstraintRuleCondition__c getTempConstraintRuleCondition(String ConstraintRuleName , map<String ,string> ConstraintRuleMap, product2 ProductCon ){
        Apttus_Config2__ConstraintRuleCondition__c TempConstraintRuleCond = new Apttus_Config2__ConstraintRuleCondition__c();
        TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
        TempConstraintRuleCond.Name                                            = ConstraintRuleName;
        TempConstraintRuleCond.Constraint_Rule_Condition_External_ID__c        = ConstraintRuleName;
        TempConstraintRuleCond.Apttus_Config2__MatchInAsset__c                 = FALSE;
        TempConstraintRuleCond.Apttus_Config2__MatchInCartOptions__c           = FALSE;
        TempConstraintRuleCond.Apttus_Config2__MatchInLocation__c              = FALSE;
        TempConstraintRuleCond.Apttus_Config2__MatchInOptions__c               = TRUE;
        TempConstraintRuleCond.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
        TempConstraintRuleCond.Apttus_Config2__ProductId__c                    = ProductCon.Id;
        TempConstraintRuleCond.Apttus_Config2__ProductScope__c                 = 'Product';
        return TempConstraintRuleCond;
    }   
    
    /**********************************************************************************************************************************************
     Method name:       ConstraintRuleActionActionInsert
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule action record.
    **********************************************************************************************************************************************/ 
    public List<Apttus_Config2__ConstraintRuleAction__c>  constraintRuleActionActionInsert( map<String ,string> ConstraintRuleMap
                                                                                            , product2 ParentProduct
                                                                                            , map<string,Product2> ProductCodeVsProductMap){
        List<Apttus_Config2__ConstraintRuleAction__c> FinalListConstraintRuleAction = new List<Apttus_Config2__ConstraintRuleAction__c>();
        List<String> ConstraintRuleActionExtID = new List<String>();
        
        for(String RuleID : CompundRuleMap.keyset()){
            FinalListConstraintRuleAction.addAll(   getConstraintRuleAction ( CompundRuleMap.get(RuleID)[0]
                                                                            , ConstraintRuleMap
                                                                            , ParentProduct.Product_External_ID__c+'_'+CompundRuleMap.get(RuleID)[0].Feature_Description__c.left(CompundRuleMap.get(RuleID)[0].Feature_Description__c.length()-2)
                                                                            , ParentProduct.Product_External_ID__c
                                                                            , ProductCodeVsProductMap)); 
        }
        
        for(MLG_Record__c mlg: ListMlg){
            if(mlg.ADDITIONAL_MASK_S__C != NULL && mlg.Parent_Attribute_Rule_ID__c == null ){
                if(mlg.FEATURE_GROUP__C == 'Always included'){
                    FinalListConstraintRuleAction.addAll(getConstraintRuleAction(   mlg
                                                                                    , ConstraintRuleMap
                                                                                    ,'Default Masksets'
                                                                                    ,ParentProduct.Product_External_ID__c
                                                                                    , ProductCodeVsProductMap  ));        
                }
                else if(mlg.FEATURE_GROUP__C != 'Packaging'){
                    FinalListConstraintRuleAction.addAll(getConstraintRuleAction(mlg
                                                                                 , ConstraintRuleMap
                                                                                 , (mlg.FEATURE_GROUP__C != 'Metal Options' ) ? mlg.Model_Name__c : mlg.Feature_Description__c
                                                                                 , ParentProduct.Product_External_ID__c
                                                                                 , ProductCodeVsProductMap ));
                }
            }
            
            //IPs
            if(mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL){
                FinalListConstraintRuleAction.addAll(getConstraintRuleAction(mlg
                                                                             , ConstraintRuleMap
                                                                             , mlg.IP_Number__c
                                                                             , ParentProduct.Product_External_ID__c
                                                                             , ProductCodeVsProductMap ));
            }
        }  
        upsert FinalListConstraintRuleAction Constraint_Rule_Action_External_ID__c;
        return FinalListConstraintRuleAction; 
    }
    
    
    
    /**********************************************************************************************************************************************
     Method name:       getConstraintRuleAction
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule action record.
    **********************************************************************************************************************************************/ 
    public List<Apttus_Config2__ConstraintRuleAction__c> getConstraintRuleAction (  MLG_Record__c mlg
                                                                                    , map<String ,string> ConstraintRuleMap
                                                                                    , String ConstraintRule
                                                                                    , String ParentProductExtID
                                                                                    , map<string,Product2> ProductCodeVsProductMap){
        String ConstraintRuleName = (mlg.FEATURE_GROUP__C != 'Metal Options' && mlg.FEATURE_GROUP__C != 'DNWELL' && mlg.FEATURE_GROUP__C != 'Packaging' && mlg.FEATURE_GROUP__C != 'Attribute Rule') ? ParentProductExtID+'_'+ConstraintRule :  mlg.FEATURE_GROUP__C == 'DNWELL' ? 'DNWELL'+'_'+ParentProductExtID : mlg.FEATURE_GROUP__C == 'Attribute Rule' && mlg.Parent_Attribute_Rule_ID__c == null ? mlg.MLG_External_ID__c : (mlg.FEATURE_GROUP__C == 'Attribute Rule' && mlg.Parent_Attribute_Rule_ID__c != null)  ? ConstraintRule: ConstraintRule+'_'+ParentProductExtID;
        Map<string,Product2> deviceVsProductMap = new Map<string,Product2> (); //Device option product map: model name vs product
        for(product2 pro: ProductCodeVsProductMap.values()){
            if(pro.family == 'Devices' && pro.Description != NULL){
                for(String devCode : pro.Description.trim().split(',')){
                    if(!String.isBlank(devCode.trim())){
                        deviceVsProductMap.put(devCode.trim(), pro);
                    }
                }
            }
        }
        List<Apttus_Config2__ConstraintRuleAction__c> ConstraintRuleActionRetunList = new List<Apttus_Config2__ConstraintRuleAction__c>();  
        if(!String.isblank(mlg.ADDITIONAL_MASK_S__C)){
            for(String MaskLayer : mlg.ADDITIONAL_MASK_S__C.split(',')){
                if(!string.isBlank(MaskLayer) && ProductCodeVsProductMap.containskey(MaskLayer.trim())){
                    MaskLayer = MaskLayer.trim();
                    Apttus_Config2__ConstraintRuleAction__c TempConstraintRuleAction = new Apttus_Config2__ConstraintRuleAction__c ();
                        TempConstraintRuleAction.Apttus_Config2__ActionDisposition__c            = 'Warning';
                        TempConstraintRuleAction.Apttus_Config2__ActionIntent__c                 = 'Auto Include';
                        TempConstraintRuleAction.Apttus_Config2__ActionType__c                   = 'Inclusion';
                        TempConstraintRuleAction.Apttus_Config2__AutoInclude__c                  = FALSE;    
                        //system.debug('[debug: ConstraintRuleMap--]'+ ConstraintRuleName+'_'+MaskLayer);          
                        if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                            //system.debug('[debug: ConstraintRuleMap--]'+ ConstraintRuleMap.get(ConstraintRuleName+'_'+MaskLayer)); 
                            TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c         = ConstraintRuleMap.get(ConstraintRuleName+'_'+MaskLayer);
                        }    
                        else{
                            //system.debug('[debug: ConstraintRuleMap--]'+ ConstraintRuleMap.get(ConstraintRuleName)); 
                            TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c         = ConstraintRuleMap.get(ConstraintRuleName);
                        }
                        TempConstraintRuleAction.Name                                            = ConstraintRuleName+'_'+MaskLayer;
                        TempConstraintRuleAction.Constraint_Rule_Action_External_ID__c           = ConstraintRuleName+'_'+MaskLayer;
                        TempConstraintRuleAction.Apttus_Config2__AutoExclude__c                  = FALSE;
                        TempConstraintRuleAction.Apttus_Config2__MatchInAsset__c                 = FALSE;
                        TempConstraintRuleAction.Apttus_Config2__MatchInCartOptions__c           = FALSE;
                        TempConstraintRuleAction.Apttus_Config2__MatchInOptions__c               = TRUE;
                        TempConstraintRuleAction.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
                        TempConstraintRuleAction.Apttus_Config2__ProductId__c                    = ProductCodeVsProductMap.get(MaskLayer).id;
                        TempConstraintRuleAction.Apttus_Config2__ProductScope__c                 = 'Product';
                    ConstraintRuleActionRetunList.add(TempConstraintRuleAction);    
                }
            }
        }      
        
        if(mlg.FEATURE_GROUP__C == 'Metal Options' && ConstraintRuleMap.containsKey(ConstraintRuleName) ){
            Apttus_Config2__ConstraintRuleAction__c TempConstraintRuleAction = new Apttus_Config2__ConstraintRuleAction__c ();
                //system.debug('[debug: ConstraintRuleMap--]'+ ConstraintRuleName); 
                TempConstraintRuleAction.Apttus_Config2__ActionDisposition__c            = 'Warning';
                TempConstraintRuleAction.Apttus_Config2__ActionIntent__c                 = 'Auto Include';
                TempConstraintRuleAction.Apttus_Config2__ActionType__c                   = 'Inclusion';
                TempConstraintRuleAction.Apttus_Config2__AutoInclude__c                  = FALSE;
                TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
                TempConstraintRuleAction.Name                                            = ConstraintRuleName;
                TempConstraintRuleAction.Constraint_Rule_Action_External_ID__c           = ConstraintRuleName;
                TempConstraintRuleAction.Apttus_Config2__AutoExclude__c                  = FALSE;
                TempConstraintRuleAction.Apttus_Config2__MatchInAsset__c                 = FALSE;
                TempConstraintRuleAction.Apttus_Config2__MatchInCartOptions__c           = FALSE;
                TempConstraintRuleAction.Apttus_Config2__MatchInOptions__c               = TRUE;
                TempConstraintRuleAction.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
                TempConstraintRuleAction.Apttus_Config2__ProductId__c                    = ProductCodeVsProductMap.get(ConstraintRuleName).id;
                TempConstraintRuleAction.Apttus_Config2__ProductScope__c                 = 'Product';
            ConstraintRuleActionRetunList.add(TempConstraintRuleAction);
        }
        if(ConstraintRuleMap.containsKey(ConstraintRuleName) && mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL ) {
            for(String devCode : mlg.Device_List__c.split(',')){
                
                if(!String.isEmpty(devCode) && deviceVsProductMap.containsKey(devCode.trim())){
                    devCode = devCode.trim();
                    Product2 DevPord = deviceVsProductMap.get(devCode);
                    Apttus_Config2__ConstraintRuleAction__c TempConstraintRuleAction         = new Apttus_Config2__ConstraintRuleAction__c ();
                    TempConstraintRuleAction.Apttus_Config2__ActionDisposition__c            = 'Warning';
                    TempConstraintRuleAction.Apttus_Config2__ActionIntent__c                 = 'Auto Include';
                    TempConstraintRuleAction.Apttus_Config2__ActionType__c                   = 'Inclusion';
                    TempConstraintRuleAction.Apttus_Config2__AutoInclude__c                  = FALSE;              
                    TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
                    TempConstraintRuleAction.Name                                            = ConstraintRuleName+'_'+ devCode;
                    TempConstraintRuleAction.Constraint_Rule_Action_External_ID__c           = ConstraintRuleName+'_'+ devCode;
                    TempConstraintRuleAction.Apttus_Config2__AutoExclude__c                  = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInAsset__c                 = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInCartOptions__c           = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInOptions__c               = TRUE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__ProductId__c                    = DevPord.id;
                    TempConstraintRuleAction.Apttus_Config2__ProductScope__c                 = 'Product';
                    ConstraintRuleActionRetunList.add(TempConstraintRuleAction);
                }
            }
            
        }
        return ConstraintRuleActionRetunList;
    }
    /**********************************************************************************************************************************************
     Method name:       insertIpMLGplus
     Reason:            This method returns Constraint rule load ready records. 
     Parameter:         1. String: Constraint Rule name
     Return type:       Constraint rule action record.
    **********************************************************************************************************************************************/ 
    public static void insertIpMLGplus(product2 ParentProduct, CPQ_MLGPLUS__c mlgplus){
        list<MLG_Record__c> deleteIPs = [select id from MLG_Record__c where Product_Name__c = :ParentProduct.id and Feature_Group__c = 'IP' ];
        if(deleteIPs.size() > 0)
            delete deleteIPs;
        
        
        List<AggregateResult> argList  = [SELECT count(id) FROM MLG_Record__c where product_name__r.Product_External_ID__c = :ParentProduct.Product_External_ID__c];
        integer seq = (integer)argList[0].get('expr0') + 1;
        list<MLG_Record__c> result = new list<MLG_Record__c>();
        if(ParentProduct.PT_Number__c != NULL){
            set<String> ipSet = new set<String>();
            for(IP_PT_Map__c  mapping : [select id,IPNumber__r.name , PT_Number__r.name from IP_PT_Map__c where PT_Number__r.name = :ParentProduct.PT_Number__c]){
                ipSet.add(mapping.IPNumber__r.name);
            }
            
            if(ipSet.size() > 0){
                CPQ_Settings__c cpqSetting2 = CPQ_Settings__c.getValues('IP_Lifecycles');
                for(base_ip__c baseIp : [select (select name,IP_Vendor__c,Lifecycle__c,IP_Device_List__c,Metal_Stack_List__c from IP_Design_Kit__R where Latest_Design_Kit__c = true), 
                                                IP_Type__c,
                                                name,
                                                description__c,
                                                Lifecycle__c,
                                                Ip_Vendor__c
                                        from base_ip__c where name in :ipSet]){
                    
                    system.debug('[debug: baseIP:: ]'+baseIp);
                    if(baseIp.IP_Design_Kit__r.size() > 0 ){
                        IP__c ipDk = baseIp.IP_Design_Kit__r[0];
                        //only 3 types of lifecyles will be considered. Refer to custom setting CPQ_Settings__c.IP_Lifecycles
                        if(!String.isblank(ipDk.LifeCycle__c) && cpqSetting2.Value__c.contains(ipDk.LifeCycle__c)){
                            boolean flag = false;
                            for(string lifecycle : cpqSetting2.Value__c.split(',')){
                                if(lifecycle == ipDk.LifeCycle__c)  {
                                    flag = true;
                                    break;
                                }
                            }
                            if(!flag) continue;
                            //Added condition ->END
                            MLG_Record__c mlg = new MLG_Record__c();
                            mlg.IP_Number__c                            =       baseIp.name;
                            mlg.IP_Type__c                              =       baseIp.IP_Type__c;
                            mlg.IP_Vendor__c                            =       baseIp.Ip_Vendor__c;                           
                            mlg.Product_Name__c                         =       ParentProduct.id;
                            mlg.Serial_Number__c                        =       seq++;
                            mlg.Feature_Description__c                  =       baseIp.description__c ;
                            mlg.Feature_Group__c                        =       'IP';
                            mlg.MLG_External_ID__c                      =       ParentProduct.PT_Number__c + '_' + baseIp.name;                          
                            mlg.Device_List__c                          =       ipDk.IP_Device_List__c;
                            mlg.IP_Metal_Stack__c                       =       ipDk.Metal_Stack_List__c;
                            mlg.LifeCycle__c                            =       ipDk.LifeCycle__c;
                            mlg.CPQ_MLGPLUS__c                          =       mlgplus.id; 
                            result.add(mlg);
                        }                        
                    }                   
                }               
                if(result.size() > 0) {
                    upsert result MLG_External_ID__c;
                }
            }
        }        
        system.debug('[debug: ]: '+result.size() + ' IP(s) are loaded in MLG+');
    }
    
    /**********************************************************************************************************************************************
     Method name:       dataCleanUp
     Reason:            This method identifies the product records for data clean up  
     Parameter:         1. Product: parent Product
                        2. Map of Product external Id and Product: all related products inserted. 
     Return type:       Constraint rule action record.
    **********************************************************************************************************************************************/
    public void dataCleanUp(Product2 ParentProduct
                            , Map<String,Product2> MapRelatedProducts
                            , List<Apttus_Config2__ConstraintRuleAction__c> FinalListConstraintRuleAction ){
        Map<String, String> DeleteProdMap = new Map<String, String>(); //product external id , product ID
        Map<String, String> DeleteProdIDMap = new Map<String, String>(); //product external id , product ID
        Map<String, String> AllComponentMap = new Map<String, String>(); //Product External ID, Product ID
        Map<String,Apttus_Config2__ConstraintRuleAction__c> ConstraintRuleActionExtID = new Map<String,Apttus_Config2__ConstraintRuleAction__c>();
        for(Apttus_Config2__ConstraintRuleAction__c consAction : FinalListConstraintRuleAction){
            ConstraintRuleActionExtID.put(consAction.Constraint_Rule_Action_External_ID__c,consAction);
        }
        for( Apttus_Config2__ProductOptionComponent__c prodComp : [SELECT   id
                                                                            , Apttus_Config2__ParentProductId__c
                                                                            , Apttus_Config2__ParentProductId__r.Product_External_ID__c
                                                                            , Apttus_Config2__ComponentProductId__c 
                                                                            , Apttus_Config2__ComponentProductId__r.Product_External_ID__c
                                                                            , Apttus_Config2__ComponentProductId__r.family
                                                                   FROM     Apttus_Config2__ProductOptionComponent__c
                                                                   WHERE    Apttus_Config2__ParentProductId__r.id  = :ParentProduct.id ]){
            AllComponentMap.put(prodComp.Apttus_Config2__ComponentProductId__r.Product_External_ID__c, prodComp.Apttus_Config2__ComponentProductId__c);                                                     
            if(!MapRelatedProducts.containsKey(prodComp.Apttus_Config2__ComponentProductId__r.Product_External_ID__c) 
                && prodComp.Apttus_Config2__ComponentProductId__r.family != 'Additional Questions'
                && prodComp.Apttus_Config2__ComponentProductId__r.family != 'RF'){
                DeleteProdMap.put(prodComp.Apttus_Config2__ComponentProductId__r.Product_External_ID__c, prodComp.Apttus_Config2__ComponentProductId__r.family);
                DeleteProdIDMap.put(prodComp.Apttus_Config2__ComponentProductId__r.Product_External_ID__c, prodComp.Apttus_Config2__ComponentProductId__c);     
            }                                                                   
        }
        if(DeleteProdMap != NULL){
            deleteProductAssociations(DeleteProdMap, DeleteProdIDMap, AllComponentMap, ConstraintRuleActionExtID,ParentProduct); 
        }
    }
    /**********************************************************************************************************************************************
     Method name:       deleteProductAssociations
     Reason:            This method handles all the data clean up
     Parameter:         1. Delete Product Map
     Return type:       
    **********************************************************************************************************************************************/
    public void deleteProductAssociations(  Map<String, String> DeleteProdMap 
                                            , Map<String, String> DeleteProdIDMap
                                            , Map<String, String> AllComponentMap
                                            , Map<String,Apttus_Config2__ConstraintRuleAction__c> ConstraintRuleActionExtID
                                            , Product2 ParentProduct ){
        list<Apttus_Config2__ConstraintRule__c> rulelist =  new list<Apttus_Config2__ConstraintRule__c>();
        List<String> ProdExtIDList = new list<string>();
        List<String> AllConstriantRule = new List<String>();
        List<Product2> DeleteProd = new List<Product2>();
        set<String> deletedConstraintRuleIDs = new set<String>();
        List<Apttus_Config2__ConstraintRuleAction__c> deleteConstrainteRuleAction  = new List<Apttus_Config2__ConstraintRuleAction__c>();
        for(Apttus_Config2__ConstraintRuleCondition__c ConsCondition : [select  id
                                                                                , Apttus_Config2__ConstraintRuleId__c
                                                                                , Apttus_Config2__ProductId__c
                                                                                , Apttus_Config2__ProductId__r.Product_External_ID__c
                                                                                , Apttus_Config2__ProductId__r.family
                                                                                , Apttus_Config2__ProductId__r.IP_Device_List__c
                                                                                , Apttus_Config2__ConstraintRuleId__r.name
                                                                                , Apttus_Config2__ConstraintRuleId__r.Constraint_Rule_External_Id__c
                                                                                , Apttus_Config2__ProductScope__c
                                                                        from    Apttus_Config2__ConstraintRuleCondition__c
                                                                        where   Apttus_Config2__ProductId__r.Product_External_ID__c 
                                                                        IN      :AllComponentMap.keyset()
                                                                        AND     Apttus_Config2__ProductScope__c = 'Product']){
            AllConstriantRule.add(ConsCondition.Apttus_Config2__ConstraintRuleId__c);
            if(DeleteProdMap.containskey(ConsCondition.Apttus_Config2__ProductId__r.Product_External_ID__c) 
                && ConsCondition.Apttus_Config2__ProductId__r.family != 'IPs'
                && ConsCondition.Apttus_Config2__ProductId__r.family != 'RF'){
                rulelist.add(new Apttus_Config2__ConstraintRule__c( id = ConsCondition.Apttus_Config2__ConstraintRuleId__c));
                deletedConstraintRuleIDs.add(ConsCondition.Apttus_Config2__ConstraintRuleId__c);
            }                                                                   
        }
        for(Apttus_Config2__ConstraintRuleAction__c ConstraintRuleAction : [select  id
                                                                                    , name 
                                                                                    , Apttus_Config2__ConstraintRuleId__c
                                                                                    , Apttus_Config2__ConstraintRuleId__r.Constraint_Rule_External_Id__c
                                                                                    , Constraint_Rule_Action_External_ID__c
                                                                                    , Apttus_Config2__ProductId__r.Product_External_ID__c
                                                                            from    Apttus_Config2__ConstraintRuleAction__c
                                                                            where   Apttus_Config2__ConstraintRuleId__c IN :AllConstriantRule]){
            if( !ConstraintRuleActionExtID.containsKey(ConstraintRuleAction.Constraint_Rule_Action_External_ID__c)
                && AllComponentMap.containskey(ConstraintRuleAction.Apttus_Config2__ProductId__r.Product_External_ID__c)
                && !deletedConstraintRuleIDs.contains(ConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c) ){
                    deleteConstrainteRuleAction.add(new Apttus_Config2__ConstraintRuleAction__c (id = ConstraintRuleAction.id));
            } 
        }
        if(rulelist.size() > 0){
            delete rulelist;
        }
        if(deleteConstrainteRuleAction.size()>0 ){
            delete deleteConstrainteRuleAction; 
        }
        for(string optionProd : DeleteProdMap.keyset()){
            //if family is not IP or Masks
            if(DeleteProdMap.get(optionProd) != 'IPs' 
                && DeleteProdMap.get(optionProd) != 'Mask Layers' 
                && DeleteProdMap.get(optionProd) != 'Additional Questions'
                && DeleteProdMap.get(optionProd) != 'RF'){
                ProdExtIDList.add(optionProd);
            }
        }
        list<Apttus_Config2__PriceListItem__c> pliList = [select    id 
                                                                    , Apttus_Config2__ProductId__c
                                                                    , Apttus_Config2__ProductId__r.Product_External_ID__c
                                                          from      Apttus_Config2__PriceListItem__c 
                                                          where     Apttus_Config2__ProductId__r.Product_External_ID__c 
                                                          IN        :ProdExtIDList];
        if(pliList.size() > 0){
            delete pliList;
        }
        list<Apttus_Config2__ProductOptionComponent__c> pocList = [select   id 
                                                                            , Apttus_Config2__ComponentProductId__c
                                                                            , Apttus_Config2__ComponentProductId__r.Product_External_ID__c
                                                                   from     Apttus_Config2__ProductOptionComponent__c 
                                                                   where    Apttus_Config2__ComponentProductId__r.Product_External_ID__c 
                                                                   IN       :DeleteProdMap.keyset()
                                                                   AND      Apttus_Config2__ProductOptionGroupId__r.Apttus_Config2__ProductId__c = :ParentProduct.id ];
        if(pocList.size() > 0){
            delete pocList;
        }
        for(string str : ProdExtIDList){
            DeleteProd.add(new Product2 (id = DeleteProdIDMap.get(str)));
        }
        if(DeleteProd.size()> 0 ){
            delete DeleteProd; 
        }
    }
    
    
    /**********************************************************************************************************************************************
     Method name:       createPicklistValues
     Reason:            This method adds new picklist values in the product attribute value object for following fields:
                            1. Process Technology
                            2. Metal Options
                            3. Supported IO voltage
                            4. Supported Core voltage. 
                            
                        Please Note: Adding dependency is still a manual process
     Parameter:         1. List of MLG records
                        2. String : PTNumber
     Return type:       NA
    **********************************************************************************************************************************************/
    public static void createPicklistValues(String PTnumber){
        List<string> CoreVoltages = new List<String>();
        List<String> IOVoltages = new List<String>();
        List<String> MetalOptions = new List<String>();
        for(MLG_Record__c mlg : ListMLG){
            if(mlg.Feature_Group__c == 'Metal Options' || mlg.Feature_Group__c == 'Metal Stacks'){
                MetalOptions.add(mlg.Feature_Description__c);
            }
            if(mlg.IO_Voltage_V__c != null 
                && mlg.IO_Voltage_V__c != 'NA' 
                && mlg.IO_Voltage_V__c != 'N/A'){
                IOVoltages.add(mlg.IO_Voltage_V__c);
            }
            if(mlg.Core_Voltage_V__c != null 
                && mlg.Core_Voltage_V__c != 'NA' 
                && mlg.Core_Voltage_V__c != 'N/A'){
                CoreVoltages.add(mlg.Core_Voltage_V__c);
            }
        }
        //calling meta data handler method:
        CPQMetadataMethodHandler.attributeUpdatePicklist(   PTnumber
                                                            , MetalOptions
                                                            , CoreVoltages
                                                            , IOVoltages );
    }
    
    /**********************************************************************************************************************************************
     Method name:       createErrorRecord
     Reason:            This method adds new Error incase there is any error during metadata Update.                    
     Parameter:         1. CPQ_MLG__C -- CPQ MLG
                        2. String ErrorMessage
     Return type:       NA
    **********************************************************************************************************************************************/
    public static void createErrorRecord (String mlgID , String ErrorMessage){
        List<CPQ_MLG_Error_Log__c> errLoglist = new List<CPQ_MLG_Error_Log__c>();
            CPQ_MLG_Error_Log__c errLog = new CPQ_MLG_Error_Log__c();
            errLog.Error_Type__c = 'Metadata Update Error';
            errLog.Error_Description__c = ErrorMessage;
            errLog.CPQ_MLGPLUS__c = mlgID;
        errLoglist.add(errLog);
        insert errLoglist ;
    }
}