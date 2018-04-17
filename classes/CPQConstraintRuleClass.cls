public class CPQConstraintRuleClass{
    public Map<string,Product2> ProductCodeVsProductMap ;
    public void ConstraintRuleActionConditionInsert(Product2 Prod){
        ProductCodeVsProductMap = new Map<String,Product2>();
        String querystr = 'SELECT id, name, Product_External_ID__c FROM product2 where Product_External_ID__c LIKE \'%'+ Prod.Product_External_ID__c +'%\' OR Family = \'Mask Layers\'';
        for(product2 pro: database.query(querystr)){
            system.debug('ProsenjitTest******'+pro.Product_External_ID__c );
            ProductCodeVsProductMap.put(pro.Product_External_ID__c , pro);
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
                             Product_Name__c
                  FROM       CPQ_MLG__c 
                  WHERE      Product_Name__r.Product_External_ID__c = :Prod.Product_External_ID__c];
        map<String ,string> ConstraintRuleMap = new map<String ,string>();
        ConstraintRuleMap = getConstraintRule(Prod,ListMlg);
        
        
        //******Constraint Rule Condition insert******
        List<Apttus_Config2__ConstraintRuleCondition__c> FinalConstraintRuleCondition = new List<Apttus_Config2__ConstraintRuleCondition__c>();
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, 'DNWELL_'+Prod.Product_External_ID__c , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, Prod.Product_External_ID__c+'_Default Masksets' , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, 'Packaging_Flip_Chip_'+Prod.Product_External_ID__c , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, 'Packaging_Wirebond_'+Prod.Product_External_ID__c , ConstraintRuleMap , Prod));
            FinalConstraintRuleCondition.add(getProdConstraintCondition(FALSE, Prod.Product_External_ID__c+' Geometry Validation' , ConstraintRuleMap , Prod));
            
            for(CPQ_MLG__c mlg: ListMlg){
                if(mlg.Model_Name__c != NULL && mlg.ADDITIONAL_MASK_S__C != NULL){
                    product2 tempProd = ProductCodeVsProductMap.get(Prod.Product_External_ID__c+'_'+mlg.Model_Name__c );
                    FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(Prod.Product_External_ID__c+'_'+mlg.Model_Name__c , ConstraintRuleMap,tempProd ));
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
        for(Apttus_Config2__ConstraintRuleCondition__c test : FinalConstraintRuleCondition){
            System.debug('ProsenjitTest^^^^^^^^^^^^^^^^^^^ConstraintRuleCondition:'+test);
        }
        Upsert FinalConstraintRuleCondition Constraint_Rule_Condition_External_ID__c;
        //******Constraint Rule Condition insert******
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
        for(String MaskLayer : mlg.ADDITIONAL_MASK_S__C.split(',')){
            Apttus_Config2__ConstraintRuleAction__c TempConstraintRuleAction = new Apttus_Config2__ConstraintRuleAction__c ();
                TempConstraintRuleAction.Apttus_Config2__ActionDisposition__c            = 'Warning';
                TempConstraintRuleAction.Apttus_Config2__ActionIntent__c                 = 'Auto Include';
                TempConstraintRuleAction.Apttus_Config2__ActionType__c                   = 'Inclusion';
                TempConstraintRuleAction.Apttus_Config2__AutoInclude__c                  = FALSE;              
                if(mlg.FEATURE_GROUP__C == 'Metal Options'){
                    TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c         = ConstraintRuleMap.get(ConstraintRuleName+'_'+MaskLayer.trim());
                }    
                else{
                    TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c         = ConstraintRuleMap.get(ConstraintRuleName);
                }
                TempConstraintRuleAction.Name                                            = ConstraintRuleName+'_'+MaskLayer.trim();
                TempConstraintRuleAction.Constraint_Rule_Action_External_ID__c           = ConstraintRuleName+'_'+MaskLayer.trim();
                TempConstraintRuleAction.Apttus_Config2__AutoExclude__c                  = FALSE;
                TempConstraintRuleAction.Apttus_Config2__MatchInAsset__c                 = FALSE;
                TempConstraintRuleAction.Apttus_Config2__MatchInCartOptions__c           = FALSE;
                TempConstraintRuleAction.Apttus_Config2__MatchInOptions__c               = TRUE;
                TempConstraintRuleAction.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
                TempConstraintRuleAction.Apttus_Config2__ProductId__c                    = ProductCodeVsProductMap.get(MaskLayer.trim()).id;
                TempConstraintRuleAction.Apttus_Config2__ProductScope__c                 = 'Product';
            ConstraintRuleActionRetunList.add(TempConstraintRuleAction);    
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
            System.debug('ProsenjitTEST Debug----constraint rule insert'+crule.Name);
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
}