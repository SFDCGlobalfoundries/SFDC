/**********************************************************************************************************************************************
Class:         CPQMLGPLUStriggerHandler
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha (PS)
Created Date:  03-24-2015
Reason:        This class has used as the trigger helper class. 
                   1) During chaging the status to 'Ready to Load' of CPQ MLGPLUS record it checks 
                        whether any Bundle product record with the same PT number is created?
                            - if Yes : --do nothing--
                            - if NO  : 
                                # Create a bundle product record with the PT number provided in teh CPQ MLGPLUS record
                                # Create Product Group member records to create default attributes for the product. 
Change Log:    
               ARoy 06152015  - Modified code to include Serial number. 
                   
**********************************************************************************************************************************************/
public class CPQMLGPLUStriggerHandler{
    public static Boolean isRun = true;
    public void bundleProductHandler(List<CPQ_MLGPLUS__c> mlgList){
        if(isRun){
            system.debug('[Debug: inside bundleProductHandler block]'+mlgList);
            Map<String,Map<String,Product2>> MapBundlePTID = new Map<String,Map<String,Product2>>();
            map<String,String> Product2MLGMap = new map<String,String>();
            list<String> PTnumberList = new List<String>();
            map<string,string> ProcessTechMap = new Map<String,String>();
            Map<String,Product2> InsertProductMap = new Map<String,Product2>();
            if(mlgList.size() > 0){
                List<Product2> ListProdInsert = new List<Product2>();
                Map<String,Product2> MapBundleProduct = new Map<String,Product2>();
                
                for(Product2 prod: [SELECT      id
                                                , name
                                                , PT_Number__c 
                                                , Apttus_Config2__ConfigurationType__c
                                                , ProductCode
                                                , Catalog_Type__c
                                                , Product_External_ID__c
                                    FROM        Product2 
                                    WHERE       Apttus_Config2__ConfigurationType__c = 'Bundle']){
                    
                    if(!MapBundlePTID.containsKey(prod.Catalog_Type__c)){
                        Map<String,Product2> tempMap = new Map<String,Product2>();
                        tempMap.put(prod.PT_Number__c , prod);                  
                        MapBundlePTID.put(prod.Catalog_Type__c, tempMap );      
                    }           
                    else{
                        MapBundlePTID.get(prod.Catalog_Type__c).put(prod.PT_Number__c , prod);
                    }       
                }
                for(CPQ_MLGPLUS__c mlg: mlgList){
                    PTnumberList.add(mlg.Process_Technology__c);
                }
                for(Process_Technology__c ptrec : [select id, name from  Process_Technology__c where name IN :PTnumberList]){
                    ProcessTechMap.put(ptrec.name,ptrec.id);
                }
                for(CPQ_MLGPLUS__c mlg: mlgList){
                    if( MapBundlePTID.containsKey(mlg.Catalog_Type__c) ){
                        if(!MapBundlePTID.get(mlg.Catalog_Type__c).containsKey(mlg.Process_Technology__c) ){
                            Product2 temprod = bundleProductInsert(mlg,ProcessTechMap) ; 
                            ListProdInsert.add(temprod);
                            Product2MLGMap.put(temprod.Product_External_ID__c, mlg.id);
                            system.debug('[debug: Product External ID-->1]'+temprod.Product_External_ID__c);
                            system.debug('[debug: Catalog type-->1]'+mlg.Catalog_Type__c);
                            system.debug('[debug: Process_Technology -->1]'+mlg.Process_Technology__c);
                        }
                        else{
                            Product2MLGMap.put(MapBundlePTID.get(mlg.Catalog_Type__c).get(mlg.Process_Technology__c).Product_External_ID__c,mlg.id);
                            MapBundleProduct.put(MapBundlePTID.get(mlg.Catalog_Type__c).get(mlg.Process_Technology__c).Product_External_ID__c
                                                    , MapBundlePTID.get(mlg.Catalog_Type__c).get(mlg.Process_Technology__c)); 
                                    
                        }                        
                    }
                    else{
                        Product2 temprod = bundleProductInsert(mlg,ProcessTechMap) ; 
                        ListProdInsert.add(temprod);
                        Product2MLGMap.put(temprod.Product_External_ID__c, mlg.id);
                        system.debug('[debug: Product External ID-->2]'+temprod.Product_External_ID__c);
                    }       
                }
                
                if(ListProdInsert.size()>0){
                    insert ListProdInsert;    
                    for(Product2 Prod : ListProdInsert)     {
                        Map<String,Product2> tempMap = new Map<String,Product2>();
                        tempMap.put(prod.PT_Number__c , prod);  
                        MapBundlePTID.put(Prod.catalog_Type__c, tempMap); 
                        InsertProductMap.put(Prod.Product_External_ID__c , prod);
                        MapBundleProduct.put(Prod.Product_External_ID__c , Prod);
                    }                           
                }    
                loadDefaultAttributeSettings(ListProdInsert,Product2MLGMap, MapBundleProduct);  
                Map<String,String> GroupMemberMap = new map<String,String>();
                for(CPQ_MLGPLUS__c mlg: mlgList){
                    if(MapBundlePTID.ContainsKey(mlg.Catalog_Type__c) && MapBundlePTID.get(mlg.Catalog_Type__c).containsKey(mlg.Process_Technology__c)){
                        mlg.Bundle_Product__c = MapBundlePTID.get(mlg.Catalog_Type__c).get(mlg.Process_Technology__c).id; 
                        if(!InsertProductMap.containskey(MapBundlePTID.get(mlg.Catalog_Type__c).get(mlg.Process_Technology__c).Product_External_ID__c)){
                            GroupMemberMap.put(MapBundlePTID.get(mlg.Catalog_Type__c).get(mlg.Process_Technology__c).id , mlg.id);
                            updateExistingPTProdAtt(GroupMemberMap);
                        }
                    }
                }      
            }
        }
    }
    public void updateExistingPTProdAtt(Map<String,String> GroupMemberMap){
        List<Apttus_Config2__ProductAttributeGroupMember__c> UpdateGroupMemberList = new List<Apttus_Config2__ProductAttributeGroupMember__c>();
        for(Apttus_Config2__ProductAttributeGroupMember__c GrpMem : [SELECT id
                                                                            , name 
                                                                            , Apttus_Config2__ProductId__c
                                                                            , Apttus_Config2__ProductId__r.Product_External_ID__c
                                                                    FROM    Apttus_Config2__ProductAttributeGroupMember__c
                                                                    WHERE   Apttus_Config2__ProductId__c IN :GroupMemberMap.keyset()]){
            GrpMem.CPQ_MLGPLUS__c = GroupMemberMap.get(GrpMem.Apttus_Config2__ProductId__c);
            UpdateGroupMemberList.add(GrpMem);
        }
        if(UpdateGroupMemberList.size()>0 ){
            update UpdateGroupMemberList ; 
        }
    }
    public Map<String,List<Apttus_Config2__ProductAttributeGroupMember__c>> checkAttributeGroup(set<String> ListProdExtID){
        Map<String,List<Apttus_Config2__ProductAttributeGroupMember__c>> GrpMemberMap = new Map<String,List<Apttus_Config2__ProductAttributeGroupMember__c>>();
        for(Apttus_Config2__ProductAttributeGroupMember__c GrpMem : [SELECT id
                                                                            , name 
                                                                            , Apttus_Config2__ProductId__c
                                                                            , Apttus_Config2__ProductId__r.Product_External_ID__c
                                                                    FROM    Apttus_Config2__ProductAttributeGroupMember__c
                                                                    WHERE   Apttus_Config2__ProductId__r.Product_External_ID__c IN :ListProdExtID]){
            if(!GrpMemberMap.containsKey(GrpMem.Apttus_Config2__ProductId__r.Product_External_ID__c)){
                List<Apttus_Config2__ProductAttributeGroupMember__c> tempList = new List<Apttus_Config2__ProductAttributeGroupMember__c>();
                tempList.add(GrpMem);
                GrpMemberMap.put(GrpMem.Apttus_Config2__ProductId__r.Product_External_ID__c , tempList);
            }   
            else{
                GrpMemberMap.get(GrpMem.Apttus_Config2__ProductId__r.Product_External_ID__c).add(GrpMem);
            }
        }
        return GrpMemberMap;
        
    }
    public Product2 bundleProductInsert(CPQ_MLGPLUS__c mlg, Map<String,String> ProcessTechMap){
        Product2 bundleProd = new Product2();
            bundleProd.Product_External_ID__c                   = mlg.Catalog_Type__c == 'First Source' ? mlg.Parent_Product_External_ID__c :  mlg.Parent_Product_External_ID__c +'_'+mlg.Catalog_Type__c ; 
            bundleProd.ProductCode                              = mlg.Catalog_Type__c == 'First Source' ? mlg.Parent_Product_External_ID__c :  mlg.Parent_Product_External_ID__c +'_'+mlg.Catalog_Type__c ; 
            bundleProd.Apttus_Config2__IconSize__c              = '72x72';
            bundleProd.Apttus_Config2__ConfigurationType__c     = 'Bundle';
            bundleProd.Geometry__c                              = mlg.Geometry__c ; 
            bundleProd.Apttus_Config2__HasAttributes__c         = TRUE ;
            bundleProd.Apttus_Config2__HasDefaults__c           = FALSE; 
            bundleProd.Apttus_Config2__HasOptions__c            = TRUE ; 
            bundleProd.Apttus_Config2__HasSearchAttributes__c   = FALSE ; 
            bundleProd.Apttus_Config2__Customizable__c          = TRUE ; 
            bundleProd.Name                                     = mlg.Parent_Product_Name__c ; 
            bundleProd.PT_Number__c                             = mlg.Process_Technology__c;
            bundleProd.IsActive                                 = TRUE; 
            bundleProd.Apttus_Config2__Uom__c                   = 'Each';
            bundleProd.Catalog_Type__c                          = mlg.Catalog_Type__c; 
            bundleProd.Family                                   = 'PT\'s';
            bundleProd.IP_PT_ID__c                              = ProcessTechMap.get(mlg.Process_Technology__c);
        return bundleProd;
    }
    public List<Apttus_Config2__ProductAttributeGroupMember__c> loadDefaultAttributeSettings (List<Product2> ListProdInsert
                                                                                                , map<String,String> Product2MLGMap
                                                                                                , Map<String,Product2> MapBundleProduct){
        system.debug('[Debug: Attribute Settings: ]');
        List<Apttus_Config2__ProductAttributeGroupMember__c> grpmemList = new List<Apttus_Config2__ProductAttributeGroupMember__c> ();
        List<CPQ_Attribute_Settings__c> ListDefaultAttributes = CPQ_Attribute_Settings__c.getall().values();
        List<Apttus_Config2__ProductAttributeGroup__c> grpLists = new List<Apttus_Config2__ProductAttributeGroup__c>();
        Map<String,integer> attributeNamesVsSequenceMap = new Map<String,integer>();
        for(CPQ_Attribute_Settings__c attribute : ListDefaultAttributes){
            attributeNamesVsSequenceMap.put(attribute.Attribute_Group_Ext_ID__c,attribute.Sequence__c.intValue());
        }
        Map<String,List<Apttus_Config2__ProductAttributeGroupMember__c>> AttibuteCheckMap = new Map<String,List<Apttus_Config2__ProductAttributeGroupMember__c>>();
        AttibuteCheckMap = checkAttributeGroup(Product2MLGMap.keyset());
        grpLists = [select  id
                            , name
                            , Apttus_Config2__BusinessObject__c
                            , Apttus_Config2__Description__c
                            , Product_Attribute_Group_External_Id__c
                            , Apttus_Config2__TwoColumnAttributeDisplay__c
                    from    Apttus_Config2__ProductAttributeGroup__c
                    where   Product_Attribute_Group_External_Id__c 
                    in      :attributeNamesVsSequenceMap.keyset()];
        for(String BundleProdExtID : Product2MLGMap.keyset()){
            if(!AttibuteCheckMap.containsKey(BundleProdExtID)){
                for(Apttus_Config2__ProductAttributeGroup__c grp : grpLists){
                    Apttus_Config2__ProductAttributeGroupMember__c TempGrpMember = new Apttus_Config2__ProductAttributeGroupMember__c();
                        TempGrpMember.name = grp.name;
                        TempGrpMember.Apttus_Config2__AttributeGroupId__c = grp.id; 
                        TempGrpMember.Apttus_Config2__Sequence__c = attributeNamesVsSequenceMap.get(grp.Product_Attribute_Group_External_Id__c);
                        TempGrpMember.Apttus_Config2__ProductId__c = MapBundleProduct.get(BundleProdExtID).id; 
                        TempGrpMember.Attribute_GroupMember_External_ID__c = BundleProdExtID + '_'+grp.Product_Attribute_Group_External_Id__c ; 
                        TempGrpMember.CPQ_MLGPLUS__c = Product2MLGMap.containskey(BundleProdExtID) 
                                                        ? Product2MLGMap.get(BundleProdExtID)
                                                        : null; 
                    grpmemList.add(TempGrpMember);
                }
            }
            else{
                for(Apttus_Config2__ProductAttributeGroupMember__c PAgrpmem : AttibuteCheckMap.get(BundleProdExtID)){
                    PAgrpmem.CPQ_MLGPLUS__c = Product2MLGMap.containskey(BundleProdExtID) 
                                                ? Product2MLGMap.get(BundleProdExtID)
                                                : null; 
                }
            }
            
        }
        upsert grpmemList Attribute_GroupMember_External_ID__c ; 
        return grpmemList;
    }
    
    // Method to get the latest attachment and if its csv then parse and populate MLG Record.
    public void getLatestAttachment(List<CPQ_MLGPLUS__c> mlgList){
        
        List<Id> mlgIds = new List<Id>();        
        for(CPQ_MLGPLUS__c mlgplus : mlgList){
            if(mlgplus.From_Datamart__c) {
              continue;
            }
            mlgIds.add(mlgplus.Id);
        }
                
        Map<Id,Id> mlgplusEmailMap = new Map<Id,Id>();
        Map<Id,MLG_Email__c> mlgplusEmailMap1 = new Map<Id,MLG_Email__c>();        
        
        // Check for the MLG Email record which has the latest version and insert in a map
        for(MLG_Email__c mlgEmail : [select   id 
                                              , createddate
                                              , version__c
                                              , CPQ_MLGPLUS__c                                               
                                     from     MLG_Email__c 
                                     where    CPQ_MLGPLUS__c in :mlgIds
                                    ]){
            if(mlgplusEmailMap1.containsKey(mlgEmail.CPQ_MLGPLUS__c) 
                && mlgplusEmailMap1.get(mlgEmail.CPQ_MLGPLUS__c).Version__c < mlgEmail.Version__c){
                mlgplusEmailMap.put(mlgEmail.CPQ_MLGPLUS__c, mlgEmail.Id);
                mlgplusEmailMap1.put(mlgEmail.CPQ_MLGPLUS__c, mlgEmail);  
            }else if(!(mlgplusEmailMap1.containsKey(mlgEmail.CPQ_MLGPLUS__c))){
                mlgplusEmailMap.put(mlgEmail.CPQ_MLGPLUS__c, mlgEmail.id);
                mlgplusEmailMap1.put(mlgEmail.CPQ_MLGPLUS__c, mlgEmail);
            }            
        }
        
        // Get the latest attachment from the MLG Email object
        Map<Id,Attachment> attEmailMap = new Map<Id,Attachment>();
        for(Attachment att : [select    id
                                        , parentid
                                        , contentType
                                        , Body
                                        , createddate
                                        , name
                              from      Attachment
                              where     parentid in :mlgplusEmailMap.values()
                             ]){
            if(attEmailMap.containsKey(att.parentid) 
                && attEmailMap.get(att.parentid).createddate < att.createddate){
                attEmailMap.put(att.parentid, att);        
            }else if(!(attEmailMap.containsKey(att.parentid))){
                attEmailMap.put(att.parentid, att);
            }    
        }        
        
        // Check if the attachment is csv or show error message
        Map<Id, Attachment> attMLGEmailMap = new Map<Id, Attachment>();
        Map<Id,String> errorMap = new Map<Id,String>();
        for(Id idMLGPLUS : mlgplusEmailMap.keySet()){
            if(attEmailMap.containsKey(mlgplusEmailMap.get(idMLGPLUS))){
                Attachment att = attEmailMap.get(mlgplusEmailMap.get(idMLGPLUS));
                attMLGEmailMap.put(idMLGPLUS, att);
                if(!att.name.contains('.csv')){                  
                    errorMap.put(idMLGPLUS, 'The attachment file format is not .csv.');
                }
            }    
        }                    
        
        // Parse the csv file and insert data into MLG Record object.        
        List<CPQ_MLG_Error_Log__c> errLoglist = new List<CPQ_MLG_Error_Log__c>();
        Map<String, MLG_Record__c> prevMLGRecMap = new Map<String, MLG_Record__c>();
        Map<String, MLG_Record__c> currMLGRecMap = new Map<String, MLG_Record__c>();
        List<String> orderKeyList = new List<String>();
                
        for(MLG_Record__c mlgRec : [select    Feature_Group__c
                                              , IO_Voltage_V__c
                                              , Core_Voltage_V__c
                                              , Feature_Description__c
                                              , Model_Name__c
                                              , Additional_Mask_s__c
                                              , FEOL_BEOL__c
                                              , CPQ_MLGPLUS__c
                                              , Version__c
                                              , Is_Delete_Flag__c
                                              , Serial_Number__c
                                    from      MLG_Record__c
                                    where     CPQ_MLGPLUS__c in :mlgIds
                                    and       Is_Delete_Flag__c = false
                                    and       Feature_Group__c != 'Attribute Rule'
                                   ]){
            prevMLGRecMap.put(mlgRec.CPQ_MLGPLUS__c+mlgRec.Model_Name__c, mlgRec);            
        }        
        system.debug('prevMLGRecMap ==> '+prevMLGRecMap);
        
        for(CPQ_MLGPLUS__c mlgPlus : mlgList){
            if(attMLGEmailMap.containsKey(mlgPlus.Id) && !(errorMap.containsKey(mlgPlus.Id))){
                try{
                    Attachment att = attMLGEmailMap.get(mlgPlus.Id);
                    //system.debug('attachment body ==>'+blobToString(att.Body,'UTF-8'));                
                    List<List<String>> attBodyList = parseCSV(blobToString(att.Body,'UTF-8'),false);                                        
                    Boolean isHeaderError = false;
                    //system.debug('[debug: attBodyList -->]'+attBodyList);
                    //Boolean isMaskError = false;
                    Integer i=0; 
                    for(List<String> strList : attBodyList){                                                                                             
                        if(i>0 && !isHeaderError){// && !isMaskError
                            MLG_Record__c mlgRec = new MLG_Record__c();
                            mlgRec.Feature_Group__c = strList[0]!=''?strList[0].replaceAll('�','').replaceAll('"','').trim():null;
                            mlgRec.Serial_Number__c = Integer.valueOf(strList[1]);
                            mlgRec.IO_Voltage_V__c = strList[2]!=''?strList[2].trim():null;
                            mlgRec.Core_Voltage_V__c = strList[3]!=''?strList[3].trim():null;
                            mlgRec.Feature_Description__c = strList[4]!=''?strList[4].replaceAll('�','').replaceAll('"','').trim():null;
                            mlgRec.Model_Name__c = (strList[5]==''||strList[5]=='N/A')?strList[4].replaceAll('�','').replaceAll('"','').trim():strList[5].replaceAll('�','').replaceAll('"','').trim();
                            mlgRec.Additional_Mask_s__c = (strList[6]!=''||strList[6]!='N/A')?strList[6].replaceAll('�','').replaceAll('"','').trim():null;                           
                            
                            mlgRec.FEOL_BEOL__c = strList[7]!=''?strList[7].replaceAll('�','').replaceAll('"','').trim():null;
                            mlgRec.CPQ_MLGPLUS__c = mlgPlus.Id;
                            //mlgRecList.add(mlgRec);
                            if(currMLGRecMap.containsKey(mlgRec.CPQ_MLGPLUS__c+mlgRec.Model_Name__c)){
                                errorMap.put(mlgPlus.Id,'Model name cannot be duplicate.');
                                break;
                            }else{
                                currMLGRecMap.put(mlgRec.CPQ_MLGPLUS__c+mlgRec.Model_Name__c, mlgRec);
                                orderKeyList.add(mlgRec.CPQ_MLGPLUS__c+mlgRec.Model_Name__c);
                            }                                                     
                        }
                        i++;
                    }
                    //system.debug('attBodyList ==>'+attBodyList);
                }catch(Exception e){
                    system.debug('Error occured while parsing the csv ==> '+e.getMessage());
                    errorMap.put(mlgPlus.Id, 'Error occured while parsing the csv.'+e.getMessage());
                }
            }
        }        
        
        List<MLG_Record__c> insertMlgRecList = new List<MLG_Record__c>();
        List<MLG_Record__c> updateMlgRecList = new List<MLG_Record__c>();
        
        system.debug('orderKeyList ==> '+ orderKeyList);
        
        if(errorMap.size() == 0){
            for(String key : orderKeyList){
                if(!prevMLGRecMap.containsKey(key)){
                    MLG_Record__c rec = currMLGRecMap.get(key);
                    rec.Version__c = '#'+mlgplusEmailMap1.get(rec.CPQ_MLGPLUS__c).Version__c+'#';
                    insertMlgRecList.add(rec);
                }else if(prevMLGRecMap.containsKey(key)){
                    MLG_Record__c currRec = currMLGRecMap.get(key);
                    MLG_Record__c prevRec = prevMLGRecMap.get(key);
                    currRec.Additional_Mask_s__c = currRec.Additional_Mask_s__c==''?null:currRec.Additional_Mask_s__c;
                    if(currRec.Feature_Group__c == prevRec.Feature_Group__c 
                        && currRec.IO_Voltage_V__c == prevRec.IO_Voltage_V__c
                            && currRec.Core_Voltage_V__c == prevRec.Core_Voltage_V__c 
                                && currRec.Feature_Description__c == prevRec.Feature_Description__c
                                    && currRec.Additional_Mask_s__c == prevRec.Additional_Mask_s__c 
                                        && currRec.FEOL_BEOL__c == prevRec.FEOL_BEOL__c){
                        if(!(prevRec.Version__c.contains('#'+mlgplusEmailMap1.get(currRec.CPQ_MLGPLUS__c).Version__c+'#')) || (prevRec.Serial_Number__c != currRec.Serial_Number__c)){
                            if(!(prevRec.Version__c.contains('#'+mlgplusEmailMap1.get(currRec.CPQ_MLGPLUS__c).Version__c+'#'))){
                                prevRec.Version__c = prevRec.Version__c + mlgplusEmailMap1.get(currRec.CPQ_MLGPLUS__c).Version__c + '#';
                            }
                            prevRec.Serial_Number__c = currRec.Serial_Number__c;
                            updateMlgRecList.add(prevRec);
                        }                    
                    }else if(currRec.Feature_Group__c != prevRec.Feature_Group__c 
                            || currRec.IO_Voltage_V__c != prevRec.IO_Voltage_V__c
                                || currRec.Core_Voltage_V__c != prevRec.Core_Voltage_V__c 
                                    || currRec.Feature_Description__c != prevRec.Feature_Description__c
                                        || currRec.Additional_Mask_s__c != prevRec.Additional_Mask_s__c 
                                            || currRec.FEOL_BEOL__c != prevRec.FEOL_BEOL__c){
                        if(!(prevRec.Version__c.contains('#'+mlgplusEmailMap1.get(currRec.CPQ_MLGPLUS__c).Version__c+'#'))){
                            currRec.Version__c = '#'+mlgplusEmailMap1.get(currRec.CPQ_MLGPLUS__c).Version__c+'#';    
                            insertMlgRecList.add(currRec);
                        }else if(prevRec.Version__c.contains('#'+mlgplusEmailMap1.get(currRec.CPQ_MLGPLUS__c).Version__c+'#')){
                            prevRec.Feature_Group__c = currRec.Feature_Group__c;
                            prevRec.IO_Voltage_V__c = currRec.IO_Voltage_V__c;
                            prevRec.Core_Voltage_V__c = currRec.Core_Voltage_V__c;
                            prevRec.Feature_Description__c = currRec.Feature_Description__c;
                            prevRec.Additional_Mask_s__c = currRec.Additional_Mask_s__c;
                            prevRec.FEOL_BEOL__c = currRec.FEOL_BEOL__c;
                            prevRec.Serial_Number__c = currRec.Serial_Number__c;
                            updateMlgRecList.add(prevRec);    
                        }                         
                    }
                }
            }
            
            // Populate the version of the existing records in MLG Record and mark the Is Delete Flag to true.
            for(String key : prevMLGRecMap.keySet()){
                if(!currMLGRecMap.containsKey(key)){
                    MLG_Record__c rec = prevMLGRecMap.get(key);
                    rec.Version__c = rec.Version__c + mlgplusEmailMap1.get((prevMLGRecMap.get(key)).CPQ_MLGPLUS__c).Version__c + '#';
                    rec.Is_Delete_Flag__c = true;
                    updateMlgRecList.add(rec);
                }    
            }
            
            // Insert records into MLG Record object
            if(insertMlgRecList.size() > 0){
                system.debug('insertMlgRecList ==>'+insertMlgRecList);
                Database.SaveResult[] srlist = Database.insert(insertMlgRecList,true);
            }
            
            // Update records into MLG Record object
            if(updateMlgRecList.size() > 0){
                system.debug('updateMlgRecList ==>'+updateMlgRecList);
                Database.SaveResult[] srlist = Database.update(updateMlgRecList,true);
            }
        }
        
        // Error handling when file format is not csv        
        for(Id mlgplusId : errorMap.keySet()){
            errLoglist.add(getCPQMLGErrorLog('File Format Error',errorMap.get(mlgplusId),mlgplusId));           
        }                
        
        
        // Insert records into CPQ MLG Error Log object
        List<Id> errLogIds = new List<Id>();
        Map<Id,Id> errMlgIdMap = new Map<Id,Id>();
        if(errLoglist.size()>0){
            Database.SaveResult[] srlist = Database.insert(errLoglist,true);
            for(Database.SaveResult sr : srlist){
                if(sr.isSuccess()){
                    errLogIds.add(sr.getId());
                }
            }
            for(CPQ_MLG_Error_Log__c errLog : [select    id
                                                         , CPQ_MLGPLUS__c
                                               from      CPQ_MLG_Error_Log__c
                                               where     id in :errLogIds
                                              ]){
                errMlgIdMap.put(errLog.CPQ_MLGPLUS__c, errLog.Id);        
            }
            List<Attachment> attList = new List<Attachment>();
            for(Id mlgplusId : errorMap.keySet()){
                if(attMLGEmailMap.containsKey(mlgplusId)){
                    Attachment att = attMLGEmailMap.get(mlgplusId);
                    Attachment att1 = new Attachment();                
                    att1.Name = att.Name;
                    att1.Body = att.body;
                    att1.ParentId = errMlgIdMap.get(mlgplusId);
                    attList.add(att1);
                }            
            }
            if(attList.size()>0){
                Database.SaveResult[] saveResultlist = Database.insert(attList,true);
            } 
            isRun = false;
        }
                 
        RecordType rt = [select id from RecordType where developername = 'CPQ_MLGPLUS_Read_Only'];
        for(CPQ_MLGPLUS__c mlgPlus : mlgList){  
            if(mlgplus.From_datamart__c) {
                continue;
            }      
            // If any error occurs while parsing the csv, revert the status to Unprocessed
            if(errorMap.containsKey(mlgPlus.Id)){
                mlgPlus.Status__c = 'Unprocessed';
                mlgPlus.Error_Type__c = 'CSV File Read Error.';    
            }else{
                // Change the record type to read only and flag the record as success. Also populate the processed version.
                mlgPlus.Error_Type__c = 'Success';
                mlgPlus.Processed_Version__c = mlgplusEmailMap1.containsKey(mlgPlus.Id)!=null?mlgplusEmailMap1.get(mlgPlus.Id).Version__c:null;
                mlgPlus.RecordTypeId = rt.Id;
            }
        }    
    }    
    
    // Insert record into the CPQ MLG Error Log object
    private CPQ_MLG_Error_Log__c getCPQMLGErrorLog(String errorType, String errorDesc, Id mlgplusId){       
        CPQ_MLG_Error_Log__c errLog = new CPQ_MLG_Error_Log__c();
        errLog.Error_Type__c = errorType;
        errLog.Error_Description__c = errorDesc;
        errLog.CPQ_MLGPLUS__c = mlgplusId;
        return errLog;    
    }
    
    // Method to parse a csv file and return a list of list of string
    private List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields;       
    }        
    
    // Method to convert Blob to String
    private String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
}