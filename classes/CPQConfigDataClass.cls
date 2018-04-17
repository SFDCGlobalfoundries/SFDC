public class CPQConfigDataClass{

    public Boolean hasAllPriceList {get;set;}
    //public List<CPQ_MLG__c> ListFaultyMlg = new List<CPQ_MLG__c>();
    public void CategoryInsert(Product2 ParentProduct,List<string> PriceListNames){
        //step2: create products
        List<Product2> RelatedProducts = new List<Product2>();
        RelatedProducts = ProductInsert(ParentProduct,false);
        CPQ_Settings__c cpqSetting3 = CPQ_Settings__c.getValues('IP_Lifecycle_Exeption');
        List<Apttus_Config2__ClassificationName__c> InsertCategoryList = new List<Apttus_Config2__ClassificationName__c> ();
        List<String> CategoryList = new List<String>{'Metal_Stacks','IPs','Devices','Mask_Sets','Additional_Questions'};
        Map<String, id> InsertCategoryMap = new Map<String,id>();
        system.debug('CategoryList '+CategoryList );
        String ProductExtId = ParentProduct.product_external_Id__c;
        for(String str: CategoryList){
            Apttus_Config2__ClassificationName__c TempCategory = new Apttus_Config2__ClassificationName__c();
            TempCategory.Apttus_Config2__Active__c         = TRUE;
            TempCategory.Category_External_ID__c           = ProductExtId+'_'+str;
            TempCategory.Apttus_Config2__HierarchyLabel__c = str.replace('_',' ');     
            TempCategory.Name                              = ProductExtId+'_'+str;
            TempCategory.Apttus_Config2__Type__c           = 'Option Group';
            InsertCategoryList.add(TempCategory );
        }
        upsert InsertCategoryList Category_External_ID__c; 
        system.debug('prosenjitTEST:::::::::::::'+InsertCategoryList);
        for(Apttus_Config2__ClassificationName__c ClassificatioName : InsertCategoryList){
            InsertCategoryMap.put(ClassificatioName.Category_External_ID__c , ClassificatioName.id);
        }
        //Step3:
        Map<String,string> IPDeviceTypeMap = new Map<string,String>{'AMS'=>'IPs','LOGIC'=>'IPs','IO'=>'IPs','PHYS'=>'IPs','MEMORY'=>'IPs','OTHER'=>'IPs', 'NVM'=>'IPs'};
       
        Set<String> IPType = new Set<String>{'AMS','NVM','LOGIC','IO','PHYS','MEMORY','OTHER'};
        Map<String, id> MapHierarchy = new Map<String,id>();
        Map<String,List<CPQ_MLG__c>> ProductOptionMap = new Map<String,List<CPQ_MLG__c>>();
        Map<String,string> optGrpEXIDvsFeatureGrpmap = new Map<String,String>();
        Set<String> featureGroupSet = new Set<String>();
        list<String> featureGroupList = new list<String>();
        Boolean hasIP = false;
        for(CPQ_MLG__c mlg : [SELECT    ID,
                                        Additional_Mask_s__c,
                                        Core_Voltage_V__c,
                                        Feature_Description__c,
                                        Feature_Group__c,
                                        FEOL_BEOL__c,
                                        IO_Voltage_V__c,
                                        Model_Name__c,
                                        Product_Name__c,
                                        IP_Number__c,
                                        IP_Type__c,
                                        IP_Vendor__c,
                                        LifeCycle__c,
                                        Device_List__c,
                                        name,
                                        Serial_Number__c,
                                        IP_Metal_Stack__c
                                FROM    CPQ_MLG__c
                                WHERE   Product_Name__c = :ParentProduct.ID
                                AND     Feature_Group__c != 'Always included'
                                AND     Feature_Group__c != 'DNWELL'
                                AND     Feature_Group__c != 'Packaging'
                                AND     Feature_Group__c != 'Metal Options'
                                ORDER BY Serial_Number__c]){
            if(!String.isBlank(mlg.IP_Type__c)){
                hasIP = true;
            
            }else if(!String.isBlank(mlg.Model_Name__c) && mlg.Model_Name__c != 'N/A'){
                IPDeviceTypeMap.put(mlg.Feature_Group__c,'Devices');
                
                if(!String.isblank(mlg.Feature_Group__c) && !featureGroupSet.Contains(mlg.Feature_Group__c.trim())){
                    featureGroupSet.add(mlg.Feature_Group__c.trim());
                    featureGroupList.add(mlg.Feature_Group__c.trim());
                }
                
                optGrpEXIDvsFeatureGrpmap.put(ParentProduct.Product_External_ID__c + '_'+ mlg.Model_Name__c.trim() , mlg.Feature_Group__c);
            }
        }
        
        integer NoOfDeviceTypes = featureGroupSet.size();
        integer NoOfIPTypes = IPType.size();
        featureGroupList.addAll(IPType);
        
        //create 1st level hierarchy and option group
        List<Apttus_Config2__ProductOptionGroup__c> ProductOptionList = new List<Apttus_Config2__ProductOptionGroup__c>();
        List<Apttus_Config2__ClassificationHierarchy__c> ListParentHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
        for(Apttus_Config2__ClassificationName__c category : InsertCategoryList){
            Apttus_Config2__ClassificationHierarchy__c TempHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
            TempHierarchy.Category_Hierarchy_External_ID__c         = category.Category_External_ID__c;
            TempHierarchy.Apttus_Config2__Label__c                  = category.Apttus_Config2__HierarchyLabel__c ;
            TempHierarchy.Name                                      = category.Category_External_ID__c;
            TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
            if( category.Category_External_ID__c.contains('Metal_Stacks')||                    
                category.Category_External_ID__c.contains('Mask_Sets') ){
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c = FALSE;
                //TempHierarchy.Apttus_Config2__IsLeaf__c            = 'Yes' ;
            }
            else{
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c = TRUE;
                //TempHierarchy.Apttus_Config2__IsLeaf__c            = 'No';
            }
            TempHierarchy.Apttus_Config2__HierarchyId__c            = InsertCategoryMap.get(category.Category_External_ID__c);
            
            TempHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
            TempHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
            TempHierarchy.Apttus_Config2__Level__c                  = 0;
            TempHierarchy.Apttus_Config2__Left__c                   = 1;
            TempHierarchy.Apttus_Config2__MaxOptions__c             = 99;
            TempHierarchy.Apttus_Config2__MinOptions__c             = 0;
            TempHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
            TempHierarchy.Apttus_Config2__Right__c                  = getRightValue(TempHierarchy.Name,NoOfDeviceTypes ,NoOfIPTypes );
            System.debug('Hierarchy check*****************'+TempHierarchy);
            ListParentHierarchy.add(TempHierarchy);
           /****************************************Product Option Group****************************************/
            Apttus_Config2__ProductOptionGroup__c TempProductOptionGroup = new Apttus_Config2__ProductOptionGroup__c();
            TempProductOptionGroup.Apttus_Config2__IsHidden__c          = FALSE;
            if( category.Category_External_ID__c.contains('Metal_Stacks')||
                category.Category_External_ID__c.contains('Additional_Questions') ||
                category.Category_External_ID__c.contains('Mask_Sets') ){
                
                TempProductOptionGroup.Apttus_Config2__IsLeaf__c        = TRUE;
                TempProductOptionGroup.Apttus_Config2__Level__c         = 0;
                if(category.Category_External_ID__c.contains('Metal_Stacks')){
                    TempProductOptionGroup.Apttus_Config2__RootSequence__c = 5;
                    TempProductOptionGroup.Apttus_Config2__IsHidden__c      = TRUE;
                }
                else if(category.Category_External_ID__c.contains('Additional_Questions')){
                    TempProductOptionGroup.Apttus_Config2__RootSequence__c = 4;
                    TempProductOptionGroup.Apttus_Config2__IsHidden__c     = FALSE;
                }
                else if(category.Category_External_ID__c.contains('Mask_Sets')){
                    TempProductOptionGroup.Apttus_Config2__RootSequence__c = 3;
                    TempProductOptionGroup.Apttus_Config2__IsHidden__c      = TRUE;
                }
            }
            else{
            
               TempProductOptionGroup.Apttus_Config2__IsHidden__c =  
               (hasIP == false && (category.Category_External_ID__c.contains('IPs')))
                    ?  TRUE
                    :  FALSE;
                TempProductOptionGroup.Apttus_Config2__IsLeaf__c        = FALSE;
                TempProductOptionGroup.Apttus_Config2__Level__c         = 0;
                if(category.Category_External_ID__c.contains('Devices')){
                    TempProductOptionGroup.Apttus_Config2__RootSequence__c = 2;
                }
                else{
                    TempProductOptionGroup.Apttus_Config2__RootSequence__c = 1;
                }
            }        
            TempProductOptionGroup.Apttus_Config2__IsPicklist__c        = FALSE;    
            TempProductOptionGroup.Apttus_Config2__MaxOptions__c        = 99;
            TempProductOptionGroup.Apttus_Config2__MinOptions__c        = 0;
            TempProductOptionGroup.Apttus_Config2__ModifiableType__c    = 'Variable';
            //TempProductOptionGroup.Apttus_Config2__OptionGroupId__c     = 
            TempProductOptionGroup.Apttus_Config2__ProductId__c         = ParentProduct.id;
           TempProductOptionGroup.Product_Option_Grp_External_ID__c    = category.Category_External_ID__c;
            TempProductOptionGroup.Apttus_Config2__Left__c              = 1;
            TempProductOptionGroup.Apttus_Config2__Right__c             = getRightValue(TempHierarchy.Name,NoOfDeviceTypes ,NoOfIPTypes );
            //TempProductOptionGroup.Apttus_Config2__RootOptionGroupId__c = 
            TempProductOptionGroup.Apttus_Config2__Sequence__c          = 0;
            
            ProductOptionList.add(TempProductOptionGroup);         
        }
        upsert ListParentHierarchy Category_Hierarchy_External_ID__c ;
        for(Apttus_Config2__ClassificationHierarchy__c classhierarchy : ListParentHierarchy){
            MapHierarchy.put(classhierarchy.Category_Hierarchy_External_ID__c , classhierarchy.ID);
        
        }
        
        //create 2nd level hierarchy and related option group
        integer IPCount = 2; 
        integer DeviceCount = 2;
        List<Apttus_Config2__ClassificationHierarchy__c> ListchildHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
        for(String featureGroup : featureGroupList ){
            Apttus_Config2__ClassificationHierarchy__c TempHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
            TempHierarchy.Apttus_Config2__AncestorId__c             = MapHierarchy.get(ProductExtId+ '_'+IPDeviceTypeMap.get(featureGroup));
            TempHierarchy.Category_Hierarchy_External_ID__c         = ProductExtId+ '_'+featureGroup;
            TempHierarchy.Apttus_Config2__Label__c                  = featureGroup.replace('_',' ') ;
            TempHierarchy.Name                                      = ProductExtId+ '_'+featureGroup;
            TempHierarchy.Apttus_Config2__PrimordialId__c           = MapHierarchy.get(ProductExtId+ '_'+IPDeviceTypeMap.get(featureGroup));
            TempHierarchy.Apttus_Config2__HideAllSearchFilters__c   = FALSE;
            TempHierarchy.Apttus_Config2__HierarchyId__c            = InsertCategoryMap.get(ProductExtId+ '_'+IPDeviceTypeMap.get(featureGroup));
            TempHierarchy.Apttus_Config2__IncludeInTotalsView__c    = TRUE;
            TempHierarchy.Apttus_Config2__IsHidden__c               = FALSE;
            TempHierarchy.Apttus_Config2__IsPicklist__c             = FALSE;
            TempHierarchy.Apttus_Config2__Level__c                  = 0;
            TempHierarchy.Apttus_Config2__MaxOptions__c             = 99;
            TempHierarchy.Apttus_Config2__MinOptions__c             = 0;
            TempHierarchy.Apttus_Config2__Modifiable__c             = TRUE;
            
            if(featureGroup == 'AMS'){
                TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = TRUE;
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c      = TRUE;
            }
            else{
                TempHierarchy.Apttus_Config2__DefaultSearchCategory__c  = FALSE;
                TempHierarchy.Apttus_Config2__ExpandedByDefault__c      = FALSE;
            }
            
            if(IPDeviceTypeMap.get(featureGroup ) == 'Devices'){
                TempHierarchy.Apttus_Config2__Left__c                   = DeviceCount++;
                TempHierarchy.Apttus_Config2__Right__c                  = DeviceCount++;
            }
            else{
                TempHierarchy.Apttus_Config2__Left__c                   = IPCount++;
                TempHierarchy.Apttus_Config2__Right__c                  = IPCount++;
            }
            
            System.debug('Hierarchy child check******'+ProductExtId+ '_'+IPDeviceTypeMap.get(featureGroup)+'********'+ProductExtId+ '_'+featureGroup+'***********'+TempHierarchy);
            ListchildHierarchy.add(TempHierarchy);
            /****************************************Product Option Group****************************************/
            Apttus_Config2__ProductOptionGroup__c TempProductOptionGroup = new Apttus_Config2__ProductOptionGroup__c();
            TempProductOptionGroup.Apttus_Config2__IsHidden__c          = FALSE;
            TempProductOptionGroup.Apttus_Config2__IsLeaf__c            = TRUE;
            TempProductOptionGroup.Apttus_Config2__Level__c             = 1;  
            TempProductOptionGroup.Apttus_Config2__IsPicklist__c        = FALSE;            
            TempProductOptionGroup.Apttus_Config2__MaxOptions__c        = 99;
            TempProductOptionGroup.Apttus_Config2__MinOptions__c        = 0;
            TempProductOptionGroup.Apttus_Config2__ModifiableType__c    = 'Variable';
            //TempProductOptionGroup.Apttus_Config2__OptionGroupId__c     = 
            //TempProductOptionGroup.Apttus_Config2__ParentOptionGroupId__c = 
            TempProductOptionGroup.Apttus_Config2__ProductId__c         = ParentProduct.id;
            TempProductOptionGroup.Product_Option_Grp_External_ID__c    = ProductExtId+ '_'+featureGroup;
            TempProductOptionGroup.Apttus_Config2__Left__c              = TempHierarchy.Apttus_Config2__Left__c;
            TempProductOptionGroup.Apttus_Config2__Right__c             = TempHierarchy.Apttus_Config2__Right__c;
            //TempProductOptionGroup.Apttus_Config2__RootOptionGroupId__c = 
            TempProductOptionGroup.Apttus_Config2__Sequence__c          = 0;
            if(IPDeviceTypeMap.get(featureGroup ) == 'Devices'){
                TempProductOptionGroup.APTTUS_CONFIG2__ROOTSEQUENCE__C  = 2;
            }else{
                TempProductOptionGroup.APTTUS_CONFIG2__ROOTSEQUENCE__C  = 1;
            }
            
            ProductOptionList.add(TempProductOptionGroup);         
        }
        System.debug('LIST123' +ListchildHierarchy);
        upsert ListchildHierarchy Category_Hierarchy_External_ID__c ;
        for(Apttus_Config2__ClassificationHierarchy__c classhierarchy : ListchildHierarchy){
            MapHierarchy.put(classhierarchy.Category_Hierarchy_External_ID__c , classhierarchy.ID);
        }
        
        List<Apttus_Config2__ProductOptionGroup__c> FinalProductOptionList = new List<Apttus_Config2__ProductOptionGroup__c>();
        for(Apttus_Config2__ProductOptionGroup__c prodOptGrp :ProductOptionList){
            prodOptGrp.Apttus_Config2__OptionGroupId__c                    =  MapHierarchy.get(prodOptGrp.Product_Option_Grp_External_ID__c);
            if(prodOptGrp.Product_Option_Grp_External_ID__c.contains('_IPs')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Metal_Stacks')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Additional_Questions')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Mask_Sets')
               ||prodOptGrp.Product_Option_Grp_External_ID__c.contains('_Devices')){
            
                prodOptGrp.Apttus_Config2__ParentOptionGroupId__c              =  NULL;
                prodOptGrp.Apttus_Config2__RootOptionGroupId__c                =  MapHierarchy.get(prodOptGrp.Product_Option_Grp_External_ID__c);
            }
            else{
                prodOptGrp.Apttus_Config2__ParentOptionGroupId__c              =  MapHierarchy.get(ProductExtId+'_'+IPDeviceTypeMap.get(prodOptGrp.Product_Option_Grp_External_ID__c.replace(ProductExtId+'_',''))); 
                prodOptGrp.Apttus_Config2__RootOptionGroupId__c                =  MapHierarchy.get(ProductExtId+'_'+IPDeviceTypeMap.get(prodOptGrp.Product_Option_Grp_External_ID__c.replace(ProductExtId+'_',''))); 
            }
            system.debug('ProsenjitTEST*******finalproductoption'+prodOptGrp);
            FinalProductOptionList.add(prodOptGrp);
        }
        upsert FinalProductOptionList Product_Option_Grp_External_ID__c;
        Map<String,Id> MapProductOption = new Map<String,Id>();
        for(Apttus_Config2__ProductOptionGroup__c prodOptionGrp: FinalProductOptionList ){
            MapProductOption.put(prodOptionGrp.Product_Option_Grp_External_ID__c, prodOptionGrp.ID);
        }
        
        //step 7,8&10:
        List<Apttus_Config2__ProductOptionComponent__c> InsertProdOptionComp = new List<Apttus_Config2__ProductOptionComponent__c>();
        List<Apttus_Config2__PriceListItem__c> InsertPriceListItem = new List<Apttus_Config2__PriceListItem__c>();
        List<Apttus_Config2__ProductClassification__c> IPProdClassification = new List<Apttus_Config2__ProductClassification__c>();
        List<Product2> IPProduct = new List<Product2>();
        
        Map<String,String> MapClassificationHierarchyIP = new Map<String,String>();
        for(Apttus_Config2__ClassificationHierarchy__c classHierarchy : [SELECT    ID,
                                                                                   NAME,
                                                                                   Category_Hierarchy_External_ID__c
                                                                         FROM      Apttus_Config2__ClassificationHierarchy__c 
                                                                         WHERE     Category_Hierarchy_External_ID__c
                                                                         IN        ('Phys','AMS','Other','IO','Logic','Memory','14nm','20nm','28nm','35nm', '40nm','55nm','65nm','130nm','160nm','180nm','>180nm')]){
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
                
                System.debug('IMPORTANT:PROSENJIT&&&&&&&&&&&&&'+getPriceListItem(ListPriceList ,prod));
                InsertPriceListItem.addAll(getPriceListItem(ListPriceList ,prod));
                if(prod.Family == 'IPs'){
                    IPProdClassification.add(getProductClassification('IP',prod,MapClassificationHierarchyIP));
                }
                
        }
      
        for(product2 aqProd : [select id,Product_External_ID__c,APTPS_IP_Type__c,family from product2 where family = 'Additional Questions' order by name]){
            InsertProdOptionComp.add(getProductOptionComponent(optGrpEXIDvsFeatureGrpmap, MapProductOption,aqProd,ParentProduct,ComponentCount++ ));
        }
        
        IPProdClassification.add(getProductClassification('Product', ParentProduct, MapClassificationHierarchyIP));
        InsertPriceListItem.addAll(getPriceListItem(ListPriceList ,ParentProduct));
        upsert InsertProdOptionComp Option_Component_External_ID__c;
        upsert InsertPriceListItem PriceListItemExternal_ID__c;
        upsert IPProdClassification Product_Classification_External_ID__c      ;
        
        //create product attribute group member from Custom settings
        
        CPQ_Settings__c cpqSetting = CPQ_Settings__c.getValues('AttributeGroups');
        set<String> grpSet = new set<String>();
        for(String groupExId : cpqSetting.value__c.split(',') ){
            grpSet.add(groupExId);
        }
        list<Apttus_Config2__ProductAttributeGroupMember__c> attbGrpMbmList = new list<Apttus_Config2__ProductAttributeGroupMember__c>();
        for(Apttus_Config2__ProductAttributeGroup__c grp : [select id, name,Apttus_Config2__Description__c,Product_Attribute_Group_External_Id__c  from Apttus_Config2__ProductAttributeGroup__c where Product_Attribute_Group_External_Id__c in :grpSet]){
            Apttus_Config2__ProductAttributeGroupMember__c member = new Apttus_Config2__ProductAttributeGroupMember__c();
            member.name                                 =   grp.name;
            member.Apttus_Config2__AttributeGroupId__c  =   grp.id;
            member.Apttus_Config2__ProductId__c         =   ParentProduct.id;
            member.Attribute_GroupMember_External_ID__c =   ParentProduct.Product_External_ID__c + '_' + grp.Product_Attribute_Group_External_Id__c;
            if(grp.name == 'Technology Information'){
                member.Apttus_Config2__Sequence__c      =   1;
            }else if(grp.name== 'Packaging'){
                member.Apttus_Config2__Sequence__c      =   3;
            }else if(grp.name== 'Solutioning'){
                member.Apttus_Config2__Sequence__c      =   4;
            }else if(grp.name== 'Internal Group- Do not touch'){
                member.Apttus_Config2__Sequence__c      =   5;
            }else if(grp.name== 'Metal Options'){
                member.Apttus_Config2__Sequence__c      =   2;
            }
           
            if(member.Apttus_Config2__Sequence__c != null)
                attbGrpMbmList.add(member);
        }
        system.debug('Thomas ' +attbGrpMbmList);
        upsert attbGrpMbmList Attribute_GroupMember_External_ID__c;
        
        
     
    }
    
    public Apttus_Config2__ProductClassification__c getProductClassification(String TypeProd, Product2 IPProd, Map<String,String>MapClassificationHierarchyIP){
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
            strGeom = IPProd.Geometry__c == '>0.18UM' 
                        ? '>180nm'
                        : IPProd.Geometry__c;
        }
        
        Apttus_Config2__ProductClassification__c TempProdCalssification = new Apttus_Config2__ProductClassification__c ();
        
        if(TypeProd == 'IP'){
            String ipType = MapClassificationHierarchyIP.containsKey(IPProd.APTPS_IP_Type__c) ? IPProd.APTPS_IP_Type__c : 'OTHER';
            TempProdCalssification.Apttus_Config2__ClassificationId__c    = MapClassificationHierarchyIP.get(ipType);
            TempProdCalssification.Product_Classification_External_ID__c  = IPProd.Product_External_ID__c + '_'+ ipType;
        }
        else{
            TempProdCalssification.Apttus_Config2__ClassificationId__c    = MapClassificationHierarchyIP.get(strGeom.toUpperCase());    
            TempProdCalssification.Product_Classification_External_ID__c  = IPProd.Product_External_ID__c  + '_' +  strGeom.toUpperCase();
        }
        TempProdCalssification.Apttus_Config2__DefaultQuantity__c         = 1; 
        TempProdCalssification.Apttus_Config2__MaxQuantity__c             = 1;
        TempProdCalssification.Apttus_Config2__MinQuantity__c             = 0;
        TempProdCalssification.Apttus_Config2__Modifiable__c              = TRUE;
        TempProdCalssification.Apttus_Config2__ProductId__c               = IPProd.ID;
        
        return TempProdCalssification;
    }
    
    public List<Apttus_Config2__PriceListItem__c> getPriceListItem (List<Apttus_Config2__PriceList__c> ListPriceList , product2 prod ){
        List<Apttus_Config2__PriceListItem__c> FinalPrcList = new List<Apttus_Config2__PriceListItem__c>();
        for(Apttus_Config2__PriceList__c PrcList : ListPriceList){
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
    public Apttus_Config2__ProductOptionComponent__c getProductOptionComponent(Map<String,string>optGrpEXIDvsFeatureGrpmap, Map<String,Id>MapProductOption, product2 prod,product2 ParentProduct, integer ComponentCount ){
        Apttus_Config2__ProductOptionComponent__c TempProdOptionComponent = new Apttus_Config2__ProductOptionComponent__c();
            TempProdOptionComponent.Apttus_Config2__AllowCloning__c        = FALSE;
            TempProdOptionComponent.Apttus_Config2__ComponentProductId__c  = prod.id;
            TempProdOptionComponent.Apttus_Config2__Default__c             = FALSE;
            TempProdOptionComponent.Apttus_Config2__Modifiable__c          = FALSE;
            TempProdOptionComponent.Apttus_Config2__ParentProductId__c     = ParentProduct.id;
            if(prod.family == 'Mask Layers'){
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_Mask_Sets');
            }
            else if(prod.family == 'Metal Stacks'){
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_Metal_Stacks');
            }
            else if(prod.family == 'Devices'){
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_'+optGrpEXIDvsFeatureGrpmap.get(prod.Product_External_ID__c ));
            }
            else if(prod.family == 'IPs'){
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_'+prod.APTPS_IP_Type__c);
            
            }
            else if(prod.family == 'Additional Questions'){
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_Additional_Questions');
            }
            
            TempProdOptionComponent.Option_Component_External_ID__c        = prod.Product_External_ID__c.contains(ParentProduct.Product_External_ID__c)? prod.Product_External_ID__c: ParentProduct.Product_External_ID__c+ '_'+ prod.Product_External_ID__c;
            TempProdOptionComponent.Apttus_Config2__RelationshipType__c    = 'Option';
            TempProdOptionComponent.Apttus_Config2__Required__c            = FALSE;
            TempProdOptionComponent.Apttus_Config2__Sequence__c            = ComponentCount;
        return TempProdOptionComponent;
    }
    
    public integer getRightValue(String CategoryName,integer NoOfDeviceTypes , integer NoOfIPTypes){
        if( CategoryName.contains('Metal_Stacks')||
            CategoryName.contains('Additional_Questions') ||
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
    
    //Insert into Product2
    public List<Product2> ProductInsert(product2 ParentProduct, boolean IsValidate){
        system.debug('PSJIT:TEST::::::');
        List<Product2> ProductFinalList = new List<Product2>();
        Set<String> FEOLMasks =new set<String>(); 
        Set<String> BEOLMasks =new set<String>();
        List<String> IPIDList = new List<String>(); 
        Map<String,String> MapIPvsID = new Map<String,String>();
        String FinalFEOL ;
       String FinalBEOL ;
        for(Base_IP__c baseIP : [SELECT    id,
                                           Name
                                 FROM      Base_IP__c]){
            MapIPvsID.put(baseIP.name, baseIP.id);   
        }
        system.debug('PSJIT:TEST::::::');
        for(CPQ_MLG__c mlg : [SELECT    ID,
                                        Additional_Mask_s__c,
                                        Core_Voltage_V__c,
                                        Feature_Description__c,
                                        Feature_Group__c,
                                        FEOL_BEOL__c,
                                        IO_Voltage_V__c,
                                        Model_Name__c,
                                        Product_Name__c,
                                        IP_Number__c,
                                        IP_Type__c,
                                        IP_Vendor__c,
                                        LifeCycle__c,
                                        Device_List__c,
                                        name,
                                        Serial_Number__c,
                                        IP_Metal_Stack__c
                                FROM    CPQ_MLG__c
                                WHERE   Product_Name__c = :ParentProduct.ID
                                ORDER BY Serial_Number__c]){
                                //AND     Feature_Group__c != 'Always included'
                                //AND     Feature_Group__c != 'DNWELL'
                                //AND     Feature_Group__c != 'Packaging'])
            if( mlg.Feature_Group__c != 'Always Included'
                &&     mlg.Feature_Group__c != 'DNWELL'
                &&     mlg.Feature_Group__c != 'Packaging'){
                    ProductFinalList.add(getProduct(mlg,ParentProduct,MapIPvsID));  
            } 
            if(!String.isblank(mlg.Additional_Mask_s__c) && mlg.Additional_Mask_s__c != 'N/A'){
                
                if(mlg.FEOL_BEOL__c == 'FEOL'){
                    set<String> getFEOLMaskLayersSet = new Set<String>();
                    getFEOLMaskLayersSet = getMaskLayers(mlg.Additional_Mask_s__c);
                    if(getFEOLMaskLayersSet.size()>0){
                        FEOLMasks.addAll(getFEOLMaskLayersSet );
                    }
                    system.debug('PSJIT:TEST::::::FEOL'+FEOLMasks);
                }
                else if(mlg.FEOL_BEOL__c == 'BEOL'){
                    set<String> getBEOLMaskLayersSet = new Set<String>();
                    getBEOLMaskLayersSet = getMaskLayers(mlg.Additional_Mask_s__c);
                    if(getBEOLMaskLayersSet .size()>0){
                        BEOLMasks.addAll(getBEOLMaskLayersSet );
                    }
                    system.debug('PSJIT:TEST::::::BEOL'+BEOLMasks);
                } 
                            
            }
        }   
        system.debug('PSJIT:TEST::::::');
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
        ProductFinalList.addAll(getMaskLayersProducts(FEOLBEOLString ));
        ParentProduct.FEOL__c                                 = FinalFEOL ;
        ParentProduct.BEOL__c                                 = FinalBEOL ;
        ParentProduct.Apttus_Config2__ConfigurationType__c    = 'Bundle';
        ParentProduct.Apttus_Config2__HasAttributes__c        = TRUE;
        ParentProduct.Apttus_Config2__HasDefaults__c          = FALSE;
        ParentProduct.Apttus_Config2__HasOptions__c           = TRUE;
       ParentProduct.Apttus_Config2__HasSearchAttributes__c  = FALSE;
        ParentProduct.Apttus_Config2__Customizable__c         = TRUE;   
        ParentProduct.Apttus_Config2__Uom__c                  = 'Each';
        system.debug('final&&&&&&&&&&&&&&&&&&'+FEOLBEOLString );
        integer i = 1;
        if(IsValidate == FALSE){
            
            system.debug('Prosenjit test::::ProductFinalList'+ProductFinalList );
            system.debug('Prosenjit Test::::::::::::::*****'+ParentProduct);
            Upsert ProductFinalList Product_External_ID__c;
            Update ParentProduct;
            
            // Populate IP Icon
            List<Product2> ipProductList = new list<Product2>();
            for(Product2 prod : ProductFinalList){
               if(prod.family == 'IPs'){
                    ipProductList.add(prod);
                }
            }
            
            /*
            if(ipProductList.size() > 0 ){
                new RefFlowDataLoad().updateIcons(ipProductList);
            }
            
            
            catch(exception e){
                system.debug('EXCEPTION###########'+e);
            } */
        }
        return ProductFinalList;
    }

//utility method
public List<Product2> getMaskLayersProducts(String MaskString){
    List<product2> MaskProductList = new List<Product2>();
    Set<String> CheckDuplicate = new Set<String>();
    for(String mask : MaskString.Split(' ')){
        system.debug('we are here check:'+mask);
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
                system.debug('we are here');
            MaskProductList.add(TempProd );            
            CheckDuplicate.add(mask);
        }
    }
    system.debug('PROSENJIT TEST::::::MaskProductList'+MaskProductList);
    return MaskProductList;
}

//utility method
public Set<String> getMaskLayers(String MaskSets){
    Set<string> FinalString = new Set<String>();
    for(String masks: MaskSets.Split(',')){
        if(masks != NULL && !String.isBlank(masks.trim())){
            FinalString.add(masks.trim());
        }
    }       
    system.debug('PROSENJIT TEST::::::'+FinalString);
    return FinalString;
}


//utility method
public product2 getProduct(CPQ_MLG__c mlg, product2 ParentProduct, map<String, String> MapIPvsID){
    ID IPID;
    if(MapIPvsID.containsKey(mlg.IP_Number__c)){
        IPID = MapIPvsID.get(mlg.IP_Number__c);
    }
    product2 prod = new product2();
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
    }
    else{//for IP / device option 
        if(mlg.Feature_Group__c != 'IP'){
            if(mlg.Model_Name__c != NULL ){
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
        }
        else{
            prod.Product_External_ID__c                 = mlg.IP_Number__c;
            prod.ProductCode                            = mlg.IP_Number__c;
            prod.Description__c                            = mlg.IP_Number__c + '\r\nIP Type:'+mlg.IP_Type__c+'\r\nVendor: '+mlg.IP_Vendor__c+'\r\nLifecycle: '+mlg.LifeCycle__c;
            //prod.Long_Description__c                    = '<br><br><strong><span style="color: #0070c0; "><span style="font-family: calibri,sans-serif; "><span style="font-size: 11.0pt; "><a href="https://c.cs5.visual.force.com/apex/View_PT_IP_Details?Entity=IP&Id='+IPID+'" target="_blank"><span style="color: #0070c0; ">IP Detail</span></a></span></span></span></strong>';
            prod.IsActive                               = TRUE;
            prod.Geometry__c                            = ParentProduct.Geometry__c;
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
            prod.Name                                   = mlg.Feature_Description__c ;
            prod.Apttus_Config2__Uom__c                 = 'Each';
            prod.IP_Device_List__c                      = mlg.Device_List__c;
            prod.APTPS_Metal_Stack__c                   = mlg.IP_Metal_Stack__c;
            prod.Description                            = mlg.IP_Metal_Stack__c;
            prod.IP_PT_ID__c                            = IPID;
            prod.Apttus_Config2__IconId__c              = null;
            
        }
    }
    system.debug('Product name%%%%%%%%'+prod.Product_External_ID__c+'##########'+mlg);
    system.debug('Product name^^^^^^^^^^^^^'+prod.name);
    if(prod.Product_External_ID__c.contains('null')|| prod.Product_External_ID__c.contains('NULL')){
        //ListFaultyMlg.add(mlg);
    }
    return prod;
    
            
    }
    
    /* Create Constraint Rule */
    public Map<string,Product2> ProductCodeVsProductMap ;
    public Map<string,Product2> deviceVsProductMap ;
    public void ConstraintRuleActionConditionInsert(Product2 Prod){
        ProductCodeVsProductMap = new Map<String,Product2>();
        deviceVsProductMap = new Map<String,Product2>();
        String querystr = 'SELECT id, name, Product_External_ID__c,family, Description FROM product2 where Product_External_ID__c LIKE \'%'+ Prod.Product_External_ID__c +'%\' OR Family = \'Mask Layers\' ';
        for(product2 pro: database.query(querystr)){
            //system.debug('ProsenjitTest******'+pro.Product_External_ID__c );
            ProductCodeVsProductMap.put(pro.Product_External_ID__c , pro);
            // 09/10/2014 Tlai populate DevCode vs DevProduct map
            if(pro.family == 'Devices' && pro.Description != NULL){
                for(String devCode : pro.Description.trim().split(',')){
                    if(!String.isBlank(devCode.trim())){
                        deviceVsProductMap.put(devCode.trim(), pro);
                    }
                }
            }
        }
        List<CPQ_MLG__c> ListMlg = new List<CPQ_MLG__c>();
        ListMlg = [SELECT    name,
                            Additional_Mask_s__c,
                             Core_Voltage_V__c,
                             Feature_Description__c,
                             Feature_Group__c,
                             FEOL_BEOL__c,
                             IO_Voltage_V__c,
                             Model_Name__c,
                             Product_Name__c,
                             IP_Number__c,
                             Device_List__c
                  FROM       CPQ_MLG__c 
                  WHERE      Product_Name__r.Product_External_ID__c = :Prod.Product_External_ID__c];
        //09/10/2014 Tlai -> retrieve IP option product
        List<String> IpList = new list<String>();
        for(CPQ_MLG__c mlg : ListMlg){
            if(mlg.IP_Number__c != null){
                IpList.add(mlg.IP_Number__c);
            }
        }
        
        if(IpList.size() > 0){
            for(Product2 ipProd:[SELECT id, name, Product_External_ID__c,family, Description FROM product2 where Product_External_ID__c in : IpList]){
                ProductCodeVsProductMap.put(ipProd.Product_External_ID__c , ipProd);
            }
        }
        //******Constraint Rule upsert******          
        map<String ,string> ConstraintRuleMap = new map<String ,string>();
        ConstraintRuleMap = getConstraintRule(Prod,ListMlg);
        
        
        //******Constraint Rule Condition insert******
        List<Apttus_Config2__ConstraintRuleCondition__c> FinalConstraintRuleCondition = new List<Apttus_Config2__ConstraintRuleCondition__c>();
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, 'DNWELL_'+Prod.Product_External_ID__c , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, Prod.Product_External_ID__c+'_Default Masksets' , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, 'Packaging_Flip_Chip_'+Prod.Product_External_ID__c , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, 'Packaging_Wirebond_'+Prod.Product_External_ID__c , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, Prod.Product_External_ID__c+' Geometry Validation' , ConstraintRuleMap , Prod));
            list<string> deviceList = new list<String>();
            for(CPQ_MLG__c mlg: ListMlg){
                //devices
                if(mlg.Model_Name__c != NULL && mlg.ADDITIONAL_MASK_S__C != NULL){
                    product2 tempProd = ProductCodeVsProductMap.get(Prod.Product_External_ID__c+'_'+mlg.Model_Name__c );
                    if(tempProd != null){
                        FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(Prod.Product_External_ID__c+'_'+mlg.Model_Name__c , ConstraintRuleMap,tempProd ));
                        deviceList.add(mlg.Model_Name__c);
                    }
                }
                
                //9/10/2014 Tlai : Constraint Rule for IPs
                if(mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL){
                    product2 tempProd = ProductCodeVsProductMap.get(mlg.IP_Number__c);
                    if(tempProd != null){
                        FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(Prod.Product_External_ID__c+'_'+ mlg.IP_Number__c , ConstraintRuleMap,tempProd ));
                    }
                }
                
                //metal options
                if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                    FinalConstraintRuleCondition.add(getProdConstraintCondition(TRUE, mlg.FEATURE_DESCRIPTION__C, ConstraintRuleMap , Prod));    
                    if(mlg.ADDITIONAL_MASK_S__C != NULL){
                        Product2 TempMetalProd = ProductCodeVsProductMap.get(mlg.FEATURE_DESCRIPTION__C+'_'+Prod.Product_External_ID__c);
                        for(String mask : mlg.ADDITIONAL_MASK_S__C.Split(',')){
                            FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(mlg.FEATURE_DESCRIPTION__C+'_'+Prod.Product_External_ID__c+'_'+mask.trim() , ConstraintRuleMap, TempMetalProd ));    
                        }
                    }
                }
            }
        
        Upsert FinalConstraintRuleCondition Constraint_Rule_Condition_External_ID__c;
        system.debug('All condiions: ' + deviceList);
        //******Constraint Rule Action insert******
        ConstraintRuleActionActionInsert(ListMlg,ConstraintRuleMap,Prod);
    }
    
    //******Constraint Rule Action insert******
    public void ConstraintRuleActionActionInsert(List<CPQ_MLG__c> ListMlg, map<String ,string> ConstraintRuleMap, product2 ParentProduct){
        List<Apttus_Config2__ConstraintRuleAction__c> FinalListConstraintRuleAction = new List<Apttus_Config2__ConstraintRuleAction__c>();
        for(CPQ_MLG__c mlg: ListMlg){
            if(mlg.ADDITIONAL_MASK_S__C != NULL){
                if(mlg.FEATURE_GROUP__C == 'Always included'){
                    FinalListConstraintRuleAction.addAll(getConstraintRuleAction(mlg,ConstraintRuleMap,'Default Masksets',ParentProduct.Product_External_ID__c ));        
                }
                else{
                    FinalListConstraintRuleAction.addAll(getConstraintRuleAction(mlg
                                                                                 ,ConstraintRuleMap
                                                                                 ,(mlg.FEATURE_GROUP__C != 'Metal Options' )
                                                                                         ? mlg.Model_Name__c 
                                                                                         : mlg.Feature_Description__c
                                                                                 ,ParentProduct.Product_External_ID__c ));
                }
            }
            
            //IPs
            if(mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL){
                FinalListConstraintRuleAction.addAll(getConstraintRuleAction(mlg
                                                                                 ,ConstraintRuleMap
                                                                                 ,mlg.IP_Number__c
                                                                                 ,ParentProduct.Product_External_ID__c ));
            }
        }   
        for(Apttus_Config2__ConstraintRuleaction__c test : FinalListConstraintRuleAction){
            System.debug('ProsenjitTest^^^^^^^^^^^^^^^^^^^ConstraintRuleAction:'+test);
        }    
        upsert FinalListConstraintRuleAction Constraint_Rule_Action_External_ID__c;
    }
    
    public List<Apttus_Config2__ConstraintRuleAction__c> getConstraintRuleAction (CPQ_MLG__c mlg, map<String ,string> ConstraintRuleMap, String ConstraintRule, String ParentProductExtID){
        String ConstraintRuleName = (mlg.FEATURE_GROUP__C != 'Metal Options' && mlg.FEATURE_GROUP__C != 'DNWELL' 
                                      && mlg.FEATURE_GROUP__C != 'Packaging')
                                          ? ParentProductExtID+'_'+ConstraintRule 
                                          : ConstraintRule+'_'+ParentProductExtID;
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
                        if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                            TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c         = ConstraintRuleMap.get(ConstraintRuleName+'_'+MaskLayer);
                        }    
                        else{
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
        
        if(mlg.FEATURE_GROUP__C == 'Metal Options'){
            Apttus_Config2__ConstraintRuleAction__c TempConstraintRuleAction = new Apttus_Config2__ConstraintRuleAction__c ();
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
        //09/10/2014 Tlai ->IPs
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
    
    public Apttus_Config2__ConstraintRuleCondition__c getProdConstraintCondition(Boolean ISMetalOption , String ConstraintRuleName , map<String ,string> ConstraintRuleMap, Product2 Prod){
        Apttus_Config2__ConstraintRuleCondition__c TempConstraintRuleCond = new Apttus_Config2__ConstraintRuleCondition__c();
            if(ISMetalOption == FALSE){
                TempConstraintRuleCond.Apttus_Config2__ConditionCriteria__c            = getConditionCriteria(ConstraintRuleName,FALSE);
                TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
                TempConstraintRuleCond.Name                                            = ConstraintRuleName;
                
            }
            else{ 
                TempConstraintRuleCond.Apttus_Config2__ConditionCriteria__c            = getConditionCriteria(ConstraintRuleName,TRUE);
                TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName+'_'+Prod.Product_External_ID__c );
                TempConstraintRuleCond.Name                                            = ConstraintRuleName+'_'+Prod.Product_External_ID__c ;
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
    }
    
    public String getConditionCriteria(String ConstraintRuleName, Boolean ISMetalOption ){
        String FinalConditionString;
        if(ISMetalOption == FALSE){
            if(ConstraintRuleName.contains('DNWELL_')){
                FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "True", "FieldType" : "BOOLEAN","FieldName" : "Apttus_Config2__AttributeValueId__r.APTPS_DNWELL_Needed__c","FieldLabel" : "DNWELL Needed","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.APTPS_DNWELL_Needed__c" ],"exprStr" : "(DNWELL Needed = True)"}';
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
        }
        
        else{
            FinalConditionString = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","filter" : {"predicates" : [ {"RowNum" : 1,"FieldValue" : "'+ConstraintRuleName+'","FieldType" : "PICKLIST","FieldName" : "Apttus_Config2__AttributeValueId__r.APTPS_Metal_Options__c","FieldLabel" : "Metal Options","CompOper" : "equal to","BoolOper" : "AND"} ],"condExpr" : "1","childFilter" : null},"fields" : [ "Apttus_Config2__AttributeValueId__r.APTPS_Metal_Options__c" ],"exprStr" : "(Metal Options = '+ConstraintRuleName+'"}';
        }
        return FinalConditionString;
    }
    
    
    
    public Map<String,String> getConstraintRule(Product2 Prod, List<CPQ_MLG__c> ListMlg){
        List<Apttus_Config2__ConstraintRule__c> FinalConstraintRuleList = new List<Apttus_Config2__ConstraintRule__c>();
        Map<String,String> FinalConstraintRuleMap = new Map<String,string>(); //Key: Constraint rule name && Value: Constraint rule ID;
        for(CPQ_MLG__c mlg: ListMlg){
            // devices
            if(mlg.Model_Name__c != NULL && mlg.ADDITIONAL_MASK_S__C != NULL){
                FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_'+mlg.Model_Name__c));
            }
            
            //metal options
            if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                FinalConstraintRuleList.add(getTempConstraintRule(mlg.FEATURE_DESCRIPTION__C+'_'+Prod.Product_External_ID__c));    
                if(mlg.ADDITIONAL_MASK_S__C != NULL){
                    for(String mask : mlg.ADDITIONAL_MASK_S__C.Split(',')){
                        FinalConstraintRuleList.add(getTempConstraintRule(mlg.FEATURE_DESCRIPTION__C+'_'+Prod.Product_External_ID__c+'_'+mask.trim()));    
                    }
                }
            }
            //9/10/2014 Tlai : Constraint Rule for IPs
            if(mlg.IP_Number__c != NULL && mlg.Device_List__c != NULL && ProductCodeVsProductMap.containskey(mlg.IP_Number__c)){
                FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_'+mlg.IP_Number__c)); 
            }
        }
        //general records
        FinalConstraintRuleList.add(getTempConstraintRule('DNWELL_'+Prod.Product_External_ID__c));
        FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+'_Default Masksets'));
        FinalConstraintRuleList.add(getTempConstraintRule('Packaging_Flip_Chip_'+Prod.Product_External_ID__c));
        FinalConstraintRuleList.add(getTempConstraintRule('Packaging_Wirebond_'+Prod.Product_External_ID__c));
        FinalConstraintRuleList.add(getTempConstraintRule(Prod.Product_External_ID__c+' Geometry Validation'));
      
        upsert FinalConstraintRuleList Constraint_Rule_External_Id__c;
        
        for(Apttus_Config2__ConstraintRule__c crule : FinalConstraintRuleList){
           FinalConstraintRuleMap.put(crule.Constraint_Rule_External_Id__c, crule.id);
            /*::::::::::::::::::::testing purpose:::::::::::::::::*/
            //System.debug('ProsenjitTEST Debug----constraint rule insert'+crule.Name);
        }
        return FinalConstraintRuleMap;
    }
    
    //utility method
    public Apttus_Config2__ConstraintRule__c getTempConstraintRule(String ConstraintRuleName){
        Apttus_Config2__ConstraintRule__c TempConstraintRule = new Apttus_Config2__ConstraintRule__c();
            TempConstraintRule.Apttus_Config2__Active__c                = TRUE;
            TempConstraintRule.Constraint_Rule_External_Id__c           = ConstraintRuleName;
            TempConstraintRule.Name                                     = ConstraintRuleName;
            TempConstraintRule.Apttus_Config2__MatchInAsset__c          = FALSE;
            TempConstraintRule.Apttus_Config2__MatchInOptions__c        = FALSE;
            TempConstraintRule.Apttus_Config2__MatchInPrimaryLines__c   = FALSE;
        return TempConstraintRule;
    }
    /*Constraint Rule End*/
    
    //09/10/2014 Tlai
    //query 3 fields PT_Number__c,Product_External_ID__c & id of Product2
    public static void insertIpMLGplus(product2 ParentProduct){
        list<CPQ_MLG__c> deleteIPs = [select id from CPQ_MLG__c where Product_Name__c = :ParentProduct.id and Feature_Group__c = 'IP' ];
        if(deleteIPs.size() > 0)
            delete deleteIPs;
        
        
        List<AggregateResult> argList  = [SELECT count(id) FROM CPQ_MLG__c where product_name__r.Product_External_ID__c = :ParentProduct.Product_External_ID__c];
        integer seq = (integer)argList[0].get('expr0') + 1;
        list<CPQ_MLG__c> result = new list<CPQ_MLG__c>();
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
                    
                    
                    if(baseIp.IP_Design_Kit__r.size() > 0 ){
                        IP__c ipDk = baseIp.IP_Design_Kit__r[0];
                        //20/11/2014 Tlai : Added condition -> only 3 types of lifecyles will be considered. Refer to custom setting CPQ_Settings__c.IP_Lifecycles
                        if(!String.isblank(ipDk.LifeCycle__c) && cpqSetting2.Value__c.contains(ipDk.LifeCycle__c)){
                            boolean flag = false;
                            for(string lifecycle : cpqSetting2.Value__c.split(',')){
                                if(lifecycle == ipDk.LifeCycle__c)  {
                                    flag = true;
                                    break;
                                }
                            }
                            if(!flag) continue;
                            //20/11/2014 Tlai : Added condition ->END
                            CPQ_MLG__c mlg = new CPQ_MLG__c();
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
                            result.add(mlg);
                        }
                        
                    }
                    
                }
                
                if(result.size() > 0) {
                    upsert result MLG_External_ID__c;
                }
            }
        }
        
        system.debug(result.size() + ' IP(s) are loaded in MLG+');
    }
    
    public static void removeAll(String PTNumber, boolean remConstraintRule){
        String filterPTNumber = '%'+ PTNumber + '%';
        
        if(remConstraintRule){
            //0 remove contraint rules
            list<Apttus_Config2__ConstraintRule__c> rulelist =  [SELECT name ,Constraint_Rule_External_Id__c FROM Apttus_Config2__ConstraintRule__c where name like :filterPTNumber];
            if(rulelist.size() > 0){
                delete rulelist;
            }
        }
        
        
        /***/
        set<string> ipSet  = new set<String>();
        set<id> ipProdSet = new set<id>();
        for(IP_PT_Map__c ip_pt_map : [SELECT id, IPNumber__r.name,PT_Number__r.Name, IP_Type__c FROM IP_PT_Map__c where PT_Number__r.Name = :PTNumber]){
            ipSet.add(ip_pt_map.IPNumber__r.name );
        }
        
        if(ipSet.size() > 0){           
            for(IP_PT_Map__c ip_pt_map : [SELECT id, IPNumber__r.name,PT_Number__r.Name, IP_Type__c FROM IP_PT_Map__c where PT_Number__r.Name != :PTNumber and IPNumber__r.name in :ipSet]){
                ipSet.remove(ip_pt_map.IPNumber__r.name);
            }
            
            for(Product2 prod: [Select id from product2 where Product_External_ID__c in : ipSet]){
                ipProdSet.add(prod.id);
            }
        }
        /****/
        //1 Remove Product Attribute Group Member
        // master is Product Attribute Group which cannot be removed.
        // use product Product_External_ID__c
        list<Apttus_Config2__ProductAttributeGroupMember__c> attbGrpMbList = [select id from Apttus_Config2__ProductAttributeGroupMember__c where Apttus_Config2__ProductId__r.Product_External_ID__c like :filterPTNumber ];
        if(attbGrpMbList.size() > 0)
            delete attbGrpMbList;
            
        //2 remove Apttus_Config2__ProductClassification__c 
        // master Category Hierarchy (under offerings) which cannot be remove
        // remove bundle , IPs will be kept
        list<Apttus_Config2__ProductClassification__c> pclist = [select id from Apttus_Config2__ProductClassification__c where Product_Classification_External_ID__c like :filterPTNumber];
        if(pclist.size() > 0)
            delete pclist;
        if(ipProdSet.size() > 0){
            list<Apttus_Config2__ProductClassification__c> pclist2 = [select id from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c in : ipProdSet];
            if(pclist2.size() > 0)
                delete pclist2;
        }
        
        //3 remove Apttus_Config2__PriceListItem__c
        // master price list
        // mask layer and IP no need to be removed
        list<Apttus_Config2__PriceListItem__c> pliList = [select id from Apttus_Config2__PriceListItem__c where PriceListItemExternal_ID__c like :filterPTNumber or Apttus_Config2__ProductId__c = null];
        if(pliList.size() > 0)
            delete pliList;
        if(ipProdSet.size() > 0){
            list<Apttus_Config2__PriceListItem__c> pliList2 = [select id from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c in : ipProdSet];
            if(pliList2.size() > 0)
                delete pliList2;
        }
        
        //4 remove Apttus_Config2__ProductOptionComponent__c 
        //no master-detail field
        //use parent product Product_External_ID__c
        list<Apttus_Config2__ProductOptionComponent__c> pocList = [select id from Apttus_Config2__ProductOptionComponent__c where Apttus_Config2__ParentProductId__r.Product_External_ID__c like :filterPTNumber];
        if(pocList.size() > 0)
            delete pocList;
        //5 remove Apttus_Config2__ProductOptionGroup__c
        //master Category Hierarchy
        /*list<Apttus_Config2__ProductOptionGroup__c> pogList = [ select id from Apttus_Config2__ProductOptionGroup__c where Product_Option_Grp_External_ID__c like :filterPTNumber];
        if(pogList.size() > 0)
            delete pogList;
            */
        //6 remove Apttus_Config2__ClassificationHierarchy__c
        // master Category
        /*list<Apttus_Config2__ClassificationHierarchy__c> chList = [select id from Apttus_Config2__ClassificationHierarchy__c where Category_Hierarchy_External_ID__c  like :filterPTNumber];
        if(chList.size() > 0)
            delete chList;
        */
        
        //7 reomve Apttus_Config2__ClassificationName__c
        // no master
        list <Apttus_Config2__ClassificationName__c> cnList = [select id from Apttus_Config2__ClassificationName__c where Category_External_ID__c like :filterPTNumber];
        if(cnList.size() > 0)
            delete cnList;
            
        //8 remove product2
        //no master
        // Delete Devices Product
        list<product2> proList = [select id from product2 where  Apttus_Config2__ConfigurationType__c = 'Option' and Product_External_ID__c like :filterPTNumber ];
        if(proList.size() > 0)
            delete proList;
        //remove IPs product only associated with Specific PT
        if(ipProdSet.size() > 0){
            list<product2> proList2 = [select id from product2 where  id in :ipProdSet];
            if(proList2.size() > 0)
                delete proList2;
        }
        
    }
    
    
}