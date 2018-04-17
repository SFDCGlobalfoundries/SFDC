/*
Project      : FoundryView 2.0 Iteration-2 
Name         : clsIntegrationUtil
Author       : Cognizant 
Created Date : 21-May-2013
Reason       : This webservice class is used to absorb Design Spec, PDK, 
               White List, Patch and NDA expiration information inbound
               to Salesforce.com from OpenText via Oracle AIA orchestration. 
Change History: Case-00002470
Author       : 
Modified Date: Nov-07-2013
Reason       : Suppressing White List Errors.
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
Author: Cognizant 
Modified Date:23/07/2014
Reason: Case 22610
Modified : 23/11/2015 - Prajnith Karra
Author - Global Foundries
Reason - CTASK0097362 Mark is Last version to the same value in existing Master PDK when OT Updates to OBSOLETE

??..
??..
 */


global class clsIntegrationUtil {

    /** Integrating Design Specs Start
     **/

    /***
        Class Name: WrapperDesignSpec
        Type: Inner 
        Use: Wrapper, using to hold inbound Design Spec records 
     ***/
    
    global class WrapperDesignSpec{

        webservice Integer openTextId;
        webservice Integer parentId;
        webservice Integer oldRevisionId;
        webservice String documentTitle;
        webservice String documentNumber;
        webservice String revision;
        webservice String lifecyclePhase;
        webservice String locationFab;
        webservice DateTime revisionReleaseDate;
        webservice String specificationReleaseList;
        webservice String functionalOwnership;
        webservice String specificationType;
        webservice String technologyType;
        webservice String technology;        
        webservice String technologyGeometry;
        webservice String source;
        webservice String pdkVersion;
        webservice String deVersion;
        webservice String specificationSubClass;// contains ASIC Flag for Normal Spec
        webservice String specificationOwner;
        webservice String specificationReleaseCategory;
        webservice String commodityType;
        webservice String description;        
        // Prajnith ASIC - ASIC paramters for PDK              
        webservice String ASICIP; // Link to IP
        webservice String RestrictedIP;
                      

    }

    /** Map of the Record Type Ids of Design Spec object **/
    private static Map<String,String> mapDesignSpecsRecordTypeId=new Map<String,String>();
    /** Map of Design Spec Owners **/
    private static Map<String,String> mapDesignSpecsOwnerId=new Map<String,String>();
    /** Map of PDK Owners **/
    private static Map<String,String> mapPDKsOwnerId=new Map<String,String>(); 
    private static Map<Decimal,String> mapDesignSpecsInserted =new Map<Decimal,String>();
    private static Map<Decimal,String> mapPDKSpecsInserted =new Map<Decimal,String>();
    
    //Commented for omission of PDK Spec Reparenting Part
    /** Added for Reparenting Latest PDK Spec to Latest PDK Start **/
   /* private static Map<Decimal,String> mapPDKSpecsLatestVersionInserted=new Map<Decimal,String>();*/
    /** Added for Reparenting Latest PDK Spec to Latest PDK End **/
        
    private static Map<Decimal,String> mapPDKPatchSpecsInserted =new Map<Decimal,String>();
    private static Map<Decimal,String> mapPDKPatchToPDK =new Map<Decimal,String>();
    private static Map<String,String> mapSubPDKToPDK =new Map<String,String>();
    private static Map<String,String> mapPDKPatchToSubPDK =new Map<String,String>();
    private static Set<String> setDesignSpecIdsUpdated =new Set<String>();
    public static Map<String, Spec_Owner__c> mapSpecOwner = Spec_Owner__c.getAll(); 
    
    /**
        This webservice method is the inbound integration entry touchpoint method for Design Spec Integration.

        @method name: integrateSpec
        @parameter:   List of records of WrapperDesignSpec inner class, holding the inbound Design Spec attributes.
        @return :     List of String responses to be returned to the calling procedure.
     **/

    webService static List<String> integrateSpec(List<WrapperDesignSpec> DesignSpecInboundaRecList) {
        
        List<Decimal> inboundOTIdList = new List<Decimal>(); 
        List<Decimal> inboundParentIdList = new List<Decimal>();         
        List<String> retValList = new List<String>() ; 
        /** Set of incoming Owners for Specs **/
        Set<String> inboundOwnerId = new Set<String>();
        Set<String> setPDKIds = new Set<String>();
        Set<String> setSubPDKIds = new Set<String>();        
        
        //Commented for omission of Sub PDK assignment part
      /*  List<Sub_PDK_Spec__c> lstSubPDKSpec = new List<Sub_PDK_Spec__c>() ;
        Map<String, String> mapOriginalToInboundDocNums = new Map<String, String>();
        Map<String, String> mapOriginalPDKSpecIdsToDocNums = new Map<String, String>();
        Map<String, Set<String>> mapInboundDocNumsToSubPDKIds = new Map<String, Set<String>>();    */  
        System.debug(' *** Size of DesignSpecInboundaRecList List is *** ' + DesignSpecInboundaRecList.size());
        
        if(DesignSpecInboundaRecList!=null && DesignSpecInboundaRecList.size()>0){
            
            /** put all incoming OpenText Ids in to a list **/
            for(WrapperDesignSpec obj:DesignSpecInboundaRecList){
                if(obj.openTextId!=null){
                    inboundOTIdList.add(obj.openTextId);
                }
                if(obj.parentId!=null){                 
                    inboundParentIdList.add(obj.parentId);
                    //Commented for omission of Sub PDK assignment part
                    /*if(obj.documentNumber!=null && obj.documentNumber.contains('_')){
                        mapOriginalToInboundDocNums.put(obj.documentNumber.split('_')[0],obj.documentNumber);
                    }*/
                }
                /** Put all incoming Owners into Sets **/
                if(obj.specificationOwner!=null){
                    inboundOwnerId.add(obj.specificationOwner.toLowerCase()); 
                }
            }
            
            /** Finding out the Original PDK Spec corresponding to the PDK Patch Spec coming through the integration channel **/
            //Commented for omission of Sub PDK assignment part
           /* if(mapOriginalToInboundDocNums!=null && mapOriginalToInboundDocNums.size()>0){
                for(Design_Spec__c objDS:[Select Id, Document_Number__c from Design_Spec__c where Document_Number__c IN:mapOriginalToInboundDocNums.keySet()]){
                    mapOriginalPDKSpecIdsToDocNums.put(objDS.Id,mapOriginalToInboundDocNums.get(objDS.Document_Number__c)); 
                }           
            }*/
            
            if(inboundParentIdList!=null && inboundParentIdList.size()>0){
                
                /** Finding out the Original PDK Patch when the parent Id of the incoming PDK Spec is a PDK Patch Id **/
                for(PDK_Patch__c objPDKPatch:[Select Id, OpenText_Id__c, PDK__c from PDK_Patch__c where OpenText_Id__c IN: inboundParentIdList]){
                    mapPDKPatchSpecsInserted.put(objPDKPatch.OpenText_Id__c, objPDKPatch.Id);
                    mapPDKPatchToPDK.put(objPDKPatch.OpenText_Id__c,objPDKPatch.PDK__c);
                    setPDKIds.add(objPDKPatch.PDK__c);      
                }
                
                /** Finding out the Original PDK when the parent Id of the incoming PDK Spec is a PDK Id **/
                for(PDK__c objPDK:[Select Id, OpenText_Id__c from PDK__c where OpenText_Id__c IN: inboundParentIdList]){
                    mapPDKSpecsInserted.put(objPDK.OpenText_Id__c, objPDK.Id);      
                }
                
                //Commented for omission of PDK Spec Reparenting Part
                /** Added for Reparenting Latest PDK Spec to Latest PDK Start **/
                /** Finding out the Latest Version PDK for the PDK Spec Revision Updates **/
               /* for(PDK__c objPDK:[Select Id, Old_Revision_ID__c, OpenText_Id__c from PDK__c where Old_Revision_ID__c IN: inboundParentIdList]){
                    mapPDKSpecsLatestVersionInserted.put(objPDK.Old_Revision_ID__c, objPDK.Id);      
                }*/
                /** Added for Reparenting Latest PDK Spec to Latest PDK End **/
                
            }
            
            //Commented for omission of Sub PDK assignment part
           /* if(setPDKIds!=null && setPDKIds.size()>0){
                
                 // Finding out all the child Sub PDKs corresponding to a Master PDK Id 
                for(Sub_PDK__c objSubPDK: [Select Id, Name, PDK__c from Sub_PDK__c where PDK__c IN: setPDKIds]){
                    setSubPDKIds.add(objSubPDK.Id);
                    mapSubPDKToPDK.put(objSubPDK.Id,objSubPDK.PDK__c);  
                }
                
                // Creating a Map linking PDK Spec Ids to its corresponding set of Sub PDK Ids
                if(setSubPDKIds!=null && setSubPDKIds.size()>0){
                    for(Sub_PDK_Spec__c objSubPDKSpec:[Select Id, Name, Design_Spec__c, Sub_PDK__c from Sub_PDK_Spec__c where Sub_PDK__c IN: setSubPDKIds
                    AND Design_Spec__c IN:mapOriginalPDKSpecIdsToDocNums.keySet()]){
                        //mapPDKPatchToSubPDK.put(mapSubPDKToPDK.get(objSubPDKSpec.Sub_PDK__c),objSubPDKSpec.Sub_PDK__c);
                        Set<String> tempSet = new Set<String>();
                        String specId = mapOriginalPDKSpecIdsToDocNums.get(objSubPDKSpec.Design_Spec__c);
                            
                        if(mapInboundDocNumsToSubPDKIds!=null){                     
                            if(mapInboundDocNumsToSubPDKIds.containsKey(specId)){
                                tempSet = mapInboundDocNumsToSubPDKIds.get(specId) ;
                            }
                            tempSet.add(objSubPDKSpec.Sub_PDK__c);
                            mapInboundDocNumsToSubPDKIds.put(specId , tempSet);
                        }
                        //mapInboundDocNumsToSubPDKIds.put(mapOriginalPDKSpecIdsToDocNums.get(objSubPDKSpec.Design_Spec__c),objSubPDKSpec.Sub_PDK__c);  
                    }   
                }   
            }*/
    
            if(inboundOTIdList!=null && inboundOTIdList.size()>0){
                    
                mapDesignSpecsRecordTypeId = fetchAllRecTypeIdsMap('Design_Spec__c');
                Map<Decimal,Design_Spec__c> existingSpecsMap = new Map<Decimal,Design_Spec__c>() ;
                Map<Decimal,List<White_List__c>> existingChildWhiteListsMap = new Map<Decimal,List<White_List__c>>() ;
                List<White_List__c> listWhiteListWithNewParent = new List<White_List__c> ();
                Set<Decimal> setFreshInsertSpec = new Set<Decimal>();
                Set<Decimal> setRevisionInsertSpec = new Set<Decimal>();                
                Set<Id> setNormUpdate = new Set<Id>();
    
                existingSpecsMap = fetchAllSpecsByOTIds(inboundOTIdList);
                system.debug('existingSpecsMap**'+existingSpecsMap);
    
                /** Querying on User table for valid Owner by HCM Login Id through fetchAllSpecsOwnersByIds method **/
                if(inboundOwnerId!=null && inboundOwnerId.size()>0){
                    mapDesignSpecsOwnerId.putAll(fetchAllSpecsOwnersByIds(inboundOwnerId));     
                }
                
                List<Design_Spec__c> upsertSpecList = new List<Design_Spec__c>() ;                
                
                /** Deletion of PDK Spec when incoming Release Status is Remove - Start **/
                List<Design_Spec__c> deleteSpecList = new List<Design_Spec__c>() ;
                Set<Id> deleteSpecIds = new Set<Id>() ;
                /** Deletion of PDK Spec when incoming Release Status is Remove - End **/
    
                for(WrapperDesignSpec objInboundWrap : DesignSpecInboundaRecList){
                    
                    /*
                    @ If Loop:      If there is an existing Design Spec corresponding to the inbound Open Text Id, then upsert
                    @ Else Loop:    If there no Design Spec corresponding to the inbound Open Text Id, then insert    
                    */
                    if(existingSpecsMap.containsKey(objInboundWrap.openTextId)){
                        
                        /** Deletion of PDK Spec when incoming Release Status is Remove - Start **/
                        if(objInboundWrap.specificationReleaseCategory!=null && objInboundWrap.specificationReleaseCategory.toLowercase().trim()=='remove'){
                            String str = objInboundWrap.openTextId+':'+objInboundWrap.oldRevisionId+':Success:'+existingSpecsMap.get(objInboundWrap.openTextId).Id;
                            retValList.add(str);
                            deleteSpecList.add(existingSpecsMap.get(objInboundWrap.openTextId));
                            deleteSpecIds.add(existingSpecsMap.get(objInboundWrap.openTextId).Id);      
                        }
                        /** Deletion of PDK Spec when incoming Release Status is Remove - End **/
                        
                        else{
                            
                            Design_Spec__c d1 = new Design_Spec__c() ; /* insert or update */
        
                            d1 = existingSpecsMap.get(objInboundWrap.openTextId) ;
        
                            /*
                            @ If Loop:      If revision value is same then only update
                            @ Else Loop:    If value of revision is changed then both insert and update    
                            */
                            if(d1.Revision__c==objInboundWrap.revision){
                                Design_Spec__c d3 = prepareDesignSpecRec(objInboundWrap) ;          
                                d3.Id = d1.Id ;
                                d3.Is_Latest_Revision__c  = d1.Is_Latest_Revision__c; // Prajnith K
                                if(d1.Is_Latest_Revision__c == false)
                                d3.Name = objInboundWrap.documentNumber + ' ('+d1.Revision__c+')';                                 
                                setNormUpdate.add(d3.Id);                
                                upsertSpecList.add(d3) ;
                            }
                            
                            else{                                                                                            
                                    Design_Spec__c d2 = prepareDesignSpecRec(objInboundWrap) ; /* update */
                                    d2.Id = d1.Id ;
                                    d2.Is_Latest_Revision__c  = d1.Is_Latest_Revision__c; // Prajnith K  
                                    if(d1.Is_Latest_Revision__c == false)
                                    d2.Name = objInboundWrap.documentNumber + ' ('+d1.Revision__c+')';
                                
                                    setDesignSpecIdsUpdated.add(d2.Id);                       
                                    upsertSpecList.add(d2) ;
                                    
                                    /** Insert in case of Design Specs and not in case of PDK Specs **/
                                   // skip cloning when OBSOLETE and Revision changes happend - Prajnith
                                   //&& d1.Is_Latest_Revision__c == true
                                   // && d1.Is_Latest_Revision__c == false                                  
                                    if(objInboundWrap.parentId==null){
                                        d1.OpenText_ID__c = objInboundWrap.oldRevisionId ;
                                        d1.Name = objInboundWrap.documentNumber + ' ('+d1.Revision__c+')';                                  
                                        d1.Id = null;
                                        d1.Is_Latest_Revision__c = false; // Prajnith K
                                        if(objInboundWrap.lifecyclePhase != 'OBSOLETE'){
                                            setRevisionInsertSpec.add(d1.OpenText_ID__c);
                                            upsertSpecList.add(d1) ;                        
                                        }                
                                                                                
                                    }
                                    // for ASIC PDK requirement
                                    if(objInboundWrap.parentId !=null ){
                                        system.debug('PK**'+objInboundWrap.parentId );
                                        d1.OpenText_ID__c = objInboundWrap.oldRevisionId ;
                                        d1.Name = objInboundWrap.documentNumber + ' ('+d1.Revision__c+')';                                  
                                        d1.Id = null;
                                        d1.ParentID__c = objInboundWrap.parentId;                                        
                                        d1.Is_Latest_Revision__c = false; // Prajnith K
                                        if(objInboundWrap.lifecyclePhase != 'OBSOLETE'){
                                            setRevisionInsertSpec.add(d1.OpenText_ID__c);
                                            upsertSpecList.add(d1) ;                        
                                        }                
                                                                                
                                    }
                                                                        
                                                                                                 
                            
                            }
                        }
       
                    }
                    else{
                        setFreshInsertSpec.add(objInboundWrap.openTextId);
                        // Prajnith
                        Design_Spec__c d4 = prepareDesignSpecRec(objInboundWrap) ;
                        if(objInboundWrap.lifecyclePhase != 'OBSOLETE' )
                            d4.Is_Latest_Revision__c = true;
                        if(objInboundWrap.parentId == null && objInboundWrap.lifecyclePhase == 'OBSOLETE')
                            d4.Name = objInboundWrap.documentNumber + ' ('+objInboundWrap.revision+')';                           
                        upsertSpecList.add(d4) ;
                    }
    
    
                }/* end for */
    
                try{                
                    if(upsertSpecList!=null && upsertSpecList.size()>0){
                        /* Database Upsert Operation on Design Spec
                         */                  
                        Database.UpsertResult[] db_upsert_res = Database.upsert(upsertSpecList, DEsign_Spec__c.Fields.ID,   FALSE) ; 
        
                        Integer pointerInt = 0 ;
        
                        for(Database.UpsertResult er : db_upsert_res){ 
                            String retMsg = '' ;
                            
                            /*
                            @ If Loop:      If Database Upsert operation is a success, sending return value as OpenTextId:OldRevisionId:Success:SalesforceId
                            @ Else Loop:    If Database Upsert operation is a failure, sending return value as OpenTextId:OldRevisionId:Error:ErrorMessage    
                            */
                            if(er.isSuccess())
                            {
                                
                                /** Normal Update */
                                if(setNormUpdate!=null && setNormUpdate.contains(er.getId())){
                                    retMsg = upsertSpecList.get(pointerInt).OpenText_ID__c + ':' + upsertSpecList.get(pointerInt).Old_Revision_ID__c + ':Success:'+er.getId() ;  
                                }
                                /** Fresh Insert*/
                                else if(setFreshInsertSpec!=null && setFreshInsertSpec.contains(upsertSpecList.get(pointerInt).OpenText_ID__c)){
                                    retMsg = upsertSpecList.get(pointerInt).OpenText_ID__c + ':' + upsertSpecList.get(pointerInt).Old_Revision_ID__c + ':Success:'+er.getId() ;
                                    
                                    //Commented for omission of Sub PDK assignment part
                                    /** Inserting records into Sub PDK Spec object for associating Design Spec to its set of Sub PDKs **/
                                  /*  if(upsertSpecList.get(pointerInt).Document_Number__c!=null && mapInboundDocNumsToSubPDKIds!=null
                                    && mapInboundDocNumsToSubPDKIds.containsKey(upsertSpecList.get(pointerInt).Document_Number__c)){
                                        for(String subPDKId: mapInboundDocNumsToSubPDKIds.get(upsertSpecList.get(pointerInt).Document_Number__c)){
                                            Sub_PDK_Spec__c objSPDKSpec = new Sub_PDK_Spec__c();
                                            objSPDKSpec.Design_Spec__c = upsertSpecList.get(pointerInt).Id;
                                            objSPDKSpec.Sub_PDK__c = subPDKId;
                                            lstSubPDKSpec.add(objSPDKSpec);
                                        }                                           
                                    }  */
                                }
                                /** Revision Insert*/
                                else if(setRevisionInsertSpec!=null && setRevisionInsertSpec.contains(upsertSpecList.get(pointerInt).OpenText_ID__c)){
                                    mapDesignSpecsInserted.put(upsertSpecList.get(pointerInt).OpenText_ID__c, er.getId());
        
                                }
                                /** Revision Update*/
                                else{
                                    retMsg = upsertSpecList.get(pointerInt).OpenText_ID__c + ':' + upsertSpecList.get(pointerInt).Old_Revision_ID__c + ':Success:'+er.getId() ;
                                }
                            }
                            else
                            {
                                retMsg = upsertSpecList.get(pointerInt).OpenText_ID__c  + ':' + upsertSpecList.get(pointerInt).Old_Revision_ID__c + ':Error:'+er.getErrors() ;
                            }
                            if(retMsg!=null && retMsg.trim()!=''){
                                retValList.add(retMsg) ;
                            }                       
                            pointerInt++ ;           
                        }
                        System.debug('Size of retValList is' + retValList.size() + ' and Value is ' + retValList);
                    }
                       
                    
                    if(setDesignSpecIdsUpdated!=null && setDesignSpecIdsUpdated.size()>0){
                        existingChildWhiteListsMap.putAll(fetchChildWhiteListsBySpecIds(setDesignSpecIdsUpdated));      
                    }
    
                    if(mapDesignSpecsInserted!=null && mapDesignSpecsInserted.size()>0 && existingChildWhiteListsMap!=null && existingChildWhiteListsMap.size()>0){
                        listWhiteListWithNewParent.addAll(reparentAndUpdateWhiteList(mapDesignSpecsInserted,existingChildWhiteListsMap));   
                    }
    
                    if(listWhiteListWithNewParent!=null && listWhiteListWithNewParent.size()>0){
                        upsertReparentedWhiteListRecords(listWhiteListWithNewParent);   
                    }
                    
                    //Commented for omission of Sub PDK assignment part
                    /* if(lstSubPDKSpec!=null && lstSubPDKSpec.size()>0){
                        insertSubPDKSpecRecords(lstSubPDKSpec);   
                    }*/
                    
                    /** Deletion of PDK Spec when incoming Release Status is Remove - Start **/ 
                    if(deleteSpecIds!=null && deleteSpecIds.size()>0){
                        deleteProvisionings(deleteSpecIds);
                        deleteSubPDKSpecs(deleteSpecIds);                     
                    }                 
                    if(deleteSpecList!=null && deleteSpecList.size()>0){
                        deletePDKSpecs(deleteSpecList);                       
                    }
                    /** Deletion of PDK Spec when incoming Release Status is Remove - End **/
    
                }
                catch(DmlException e)
                {
                    System.debug(e) ;
                }  
                catch(Exception e)
                {
                    System.debug(e) ;
                }
    
            } /* end if */
        }
        else{
            retValList.add('No Specification Data Received From Source.');
        }

        return retValList;

    } /* end method */
    
    /** Deletion of PDK Spec when incoming Release Status is Remove - Start **/
    
    /**
        This method deletes the PDK Specs through DML Delete operation.

        @method name: deletePDKSpecs
        @parameter:   List of existing PDK Specs to be deleted.
        @return :     None.
     **/

    public static void deletePDKSpecs(List<Design_Spec__c> deleteSpecList){

        try{
            if(deleteSpecList!=null && deleteSpecList.size()>0){          
                delete deleteSpecList;
            }               
        }/* end try */
        catch(DmlException e){          
            System.debug(' *** Exception in deleting PDK Specs is --> ' + e.getMessage());           
        }

    }
    
    /**
        This method deletes the Provisioning Records corresponding to PDK Specs through DML Delete operation.

        @method name: deleteProvisionings
        @parameter:   List of existing PDK Specs to be deleted.
        @return :     None.
     **/

    public static void deleteProvisionings(Set<Id> deleteSpecIds){
        
        List<Document_Provisioning__c> deleteProvs = [Select Id, Design_Spec__c from Document_Provisioning__c where Design_Spec__c IN:deleteSpecIds];
        
        try{
            if(deleteProvs!=null && deleteProvs.size()>0){            
                delete deleteProvs;
            }               
        }/* end try */
        catch(DmlException e){          
            System.debug(' *** Exception in deleting Document Provisionings is --> ' + e.getMessage());           
        }

    }
    
    /**
        This method deletes the Sub PDK Spec Records corresponding to PDK Specs through DML Delete operation.

        @method name: deleteSubPDKSpecs
        @parameter:   List of existing PDK Specs to be deleted.
        @return :     None.
     **/

    public static void deleteSubPDKSpecs(Set<Id> deleteSpecIds){
        
        List<Sub_PDK_Spec__c> deleteSPS = [Select Id, Design_Spec__c from Sub_PDK_Spec__c where Design_Spec__c IN:deleteSpecIds];
        
        try{
            if(deleteSPS!=null && deleteSPS.size()>0){            
                delete deleteSPS;
            }               
        }/* end try */
        catch(DmlException e){          
            System.debug(' *** Exception in deleting Sub PDK Specs is --> ' + e.getMessage());           
        }

    }
       
    /** Deletion of PDK Spec when incoming Release Status is Remove - End **/
    
        /**
        This method fetches all the Record Types corresponding to a particular SObject. Hence this method can be reused for fetching all the 
        Record Types of any SObject.

        @method name: fetchAllRecTypeIdsMap
        @parameter:   String containing the name of the SObject corresponding to which the Record Types need to be retrieved.
        @return :     Map of Record Types of the particular SObject taken as input.
     **/

    public static Map<String,String> fetchAllRecTypeIdsMap(String objtype)
    {
        
        Map<String,String> mapRecTypes = new Map<String,String>() ;

        try{
            List<RecordType> recTypeList = new List<RecordType>() ;
            recTypeList = [SELECT Id,Name FROM RecordType where SobjectType=:objtype] ;
            for(RecordType tempRecordType:recTypeList){
                mapRecTypes.put(tempRecordType.Name,tempRecordType.Id);
            }
        }
        catch(Exception e){
            System.debug('Generated Error '+e) ;
        }
        
        return mapRecTypes ;
    }


    /**
        This method fetches all the Design Specs from Database through SOQL query when a List of Open Text Ids is provided as input.

        @method name: fetchAllSpecsByOTIds
        @parameter:   List of Open Text Ids of Design Specs which need to be queried from database.
        @return :     Map of Design Spec records having the Key as the Open Text Ids provided as inputs.
     **/

    public static Map<Decimal,Design_Spec__c> fetchAllSpecsByOTIds(List<Decimal> OTIdsList)
    {

        List<Design_Spec__c> fetchSpecRes = new List<Design_Spec__c>() ;
        Map<Decimal,Design_Spec__c> fetchSpecsMap = new Map<Decimal,Design_Spec__c>() ; 
        fetchSpecRes = [Select 
                        Technology_Type__c, Technology_Geometry__c, 
                        Specification_sub_class__c, Specification_Type__c, 
                        Specification_Release_List_Long__c, // CR # 4562 ? Field replaced 
                        Specification_Owner__c, Source__c, 
                        Revision__c, Revision_Release_Date__c, Release_Status__c, 
                        RecordTypeId, ParentID__c, 
                        PDK__c, PDK_Version__c,Is_Latest_Revision__c, 
                        OwnerId, OpenText_ID__c, 
                        Old_Revision_ID__c, Name, 
                        Location_Fab__c, Lifecycle_Phase__c, 
                        Id, Functional_Ownership__c, 
                        Document_Number__c, Document_Title__c, DE_Version__c, 
                        Commodity_Type_for_material_spec__c 
                        From 
                        Design_Spec__c 
                        WHERE 
                        OpenText_ID__c IN : OTIdsList];


        for(Design_Spec__c sp : fetchSpecRes){

            fetchSpecsMap.put(sp.OpenText_ID__c, sp) ;
        }

        return fetchSpecsMap ;  
    }

    /**
        This method retrieves the list of White List records corresponding to every Design Spec for which a new Revision has come, so that the
        retrieved White List records can be reparented to the newly inserted Older Version of the Design Spec .

        @method name: fetchChildWhiteListsBySpecIds
        @parameter:   Set of existing Design Spec Ids for which a Revision has come.
        @return :     Map of lists of Existing White Lists corresponding to a particular Design Spec.
     **/

    public static Map<Decimal,List<White_List__c>> fetchChildWhiteListsBySpecIds(Set<String> existingDesignSpecsId){     
        Map<Decimal,List<White_List__c>> childWhiteListsMap = new Map<Decimal,List<White_List__c>>() ;    
        for(White_List__c objWL:[Select Account__c, Design_Spec__c, Account_Short_Name__c, Open_Text_Id__c, Old_Revision_Id__c from White_List__c 
                                 where Design_Spec__c IN:existingDesignSpecsId]){
            List<White_List__c> tempList = new List<White_List__c>();
            Decimal dSpecOldRevId = objWL.Old_Revision_Id__c;

            if(childWhiteListsMap!=null){ 
                if(childWhiteListsMap.containsKey(dSpecOldRevId)){
                    tempList = childWhiteListsMap.get(dSpecOldRevId) ;
                }
                tempList.add(objWL);
                childWhiteListsMap.put(dSpecOldRevId , tempList);
            }  
        }       
        return childWhiteListsMap;
    }

    /**
        This method reparents the White Lists of the Design Specs for which a new revision has come  .

        @method name: reparentAndUpdateWhiteList
        @parameter:   1. Map of Design Spec Ids of the newly inserted Old Versioned Design Spec
                      2. Map of existing White Lists to be reparented and updated after reparenting.
        @return :     List of Existing White Lists after reparenting to be sent for DML Update operation.
     **/

    public static List<White_List__c> reparentAndUpdateWhiteList(Map<Decimal,String> mapDSInserted, Map<Decimal,List<White_List__c>> existingChildWLMap){

        List<Decimal> listInsertedOpenTextIds = new List<Decimal>();
        List<White_List__c> listOfReparentedWhiteList = new List<White_List__c>();

        listInsertedOpenTextIds.addAll(mapDSInserted.keySet());
        for(Decimal objOpenTextId: listInsertedOpenTextIds){
            if(existingChildWLMap.containsKey(objOpenTextId)){
                listOfReparentedWhiteList.addAll(changeWhiteListParent(mapDSInserted.get(objOpenTextId),existingChildWLMap.get(objOpenTextId)));    
            }   
        }
        return listOfReparentedWhiteList;

    }

    /**
        This method changes the parent Design Spec Id of the corresponding White Lists for which reparenting is to be done .

        @method name: changeWhiteListParent
        @parameter:   1. String containing the new parent Design Spec Id of which the White Lists will become child.
                      2. List of existing White Lists to be reparented to the new parent Design Spec Id taken as input.
        @return :     List of modified Existing White Lists after changing the Parent Design Spec Id.
     **/

    public static List<White_List__c> changeWhiteListParent (String newParentSpecId, List<White_List__c> existingWhiteListsToBeReparented){

        List<White_List__c> listOfChangedWhiteList = new List<White_List__c>();

        for(White_List__c objWL: existingWhiteListsToBeReparented){
            objWL.Design_Spec__c =  newParentSpecId;
            listOfChangedWhiteList.add(objWL);
        }

        return listOfChangedWhiteList;
    }

    /**
        This method updates the White Lists corresponding to the Design Specs through DML Update operation after reparenting them.

        @method name: upsertReparentedWhiteListRecords
        @parameter:   List of existing White Lists to be updated.
        @return :     None.
     **/

    public static void upsertReparentedWhiteListRecords(List<White_List__c> listWhiteListToBeUpserted){

        try{          
            update listWhiteListToBeUpserted;               
        }/* end try */
        catch(DmlException e){          
            System.debug(' *** Exception is --> ' + e.getMessage());           
        }

    }
    
    /**
        This method inserts the Sub PDK Spec records corresponding to the Design Specs through DML Insert operation.

        @method name: insertSubPDKSpecRecords
        @parameter:   List of existing Sub PDK Spec records to be inserted.
        @return :     None.
     **/
    
    //Commented for omission of Sub PDK assignment part
   /* static void insertSubPDKSpecRecords(List<Sub_PDK_Spec__c> lstSubPDKSpec){

        try{
            System.debug('Value of List is ' + lstSubPDKSpec);          
            insert lstSubPDKSpec;               
        }// end try
        catch(DmlException e){          
            System.debug(' *** Exception is --> ' + e.getMessage());           
        }

    }*/

    /**
        This method queries on the User Object by retrieving Owner via HCM Login Id to assign to the Design Spec Record Owner Id.

        @method name: fetchAllSpecsOwnersByIds
        @parameter:   Set of string of Owner HCM Login information flowing inbound to Salesforce.Com.
        @return :     Map of existing User information queried through HCM Login Ids.
     **/

    public static Map<String,String> fetchAllSpecsOwnersByIds(Set<String> setSpecOwners){
        Map<String,String> fetchSpecsOwnersMap = new Map<String,String>() ;
        for(User objUser: [Select Id, HCM_Login_Id__c from User where HCM_Login_Id__c IN: setSpecOwners AND IsActive=True AND UserType!='CsnOnly']){
            fetchSpecsOwnersMap.put(objUser.HCM_Login_Id__c.toLowerCase(), objUser.Id);
        }
        return fetchSpecsOwnersMap; 
    }

    /**
        This method prepares the Design Spec records for upsert operation by assigning the inbound Design Spec attributes to the
        Design Spec custom fields on the Design Spec object on Salesforce.Com.

        @method name: prepareDesignSpecRec
        @parameter:   Instance of the WrapperDesignSpec inner class which contains the Design Spec attributes inbound to Salesforce.Com.
        @return :     Prepared single Design Spec record which will be sent lated for Upsert operation.
     **/

    public static Design_Spec__c prepareDesignSpecRec(WrapperDesignSpec inboundRec){   
        
        //Commented for omission of PDK Spec Reparenting Part
        /** Added for Reparenting Latest PDK Spec to Latest PDK Start **/
       // Set <Decimal> setPDKSpecsRevisionChanged = new Set <Decimal>();
        /** Added for Reparenting Latest PDK Spec to Latest PDK End **/
        
        Design_Spec__c objDesignSpec = new Design_Spec__c();
        objDesignSpec.OpenText_ID__c = inboundRec.openTextId;
        objDesignSpec.Name = inboundRec.documentNumber;
        objDesignSpec.Document_Title__c = inboundRec.documentTitle;
        objDesignSpec.Old_Revision_ID__c = inboundRec.oldRevisionId;
        objDesignSpec.ParentID__c = inboundRec.parentId;
        objDesignSpec.Document_Number__c = inboundRec.documentNumber;
        //objDesignSpec.Description__c = inboundRec.description;//commented by cognizant for Case 22610
        objDesignSpec.Spec_Description__c = inboundRec.description;//added by cognizant for Case 22610
        //Commented for omission of PDK Spec Reparenting Part
        /** Added for Reparenting Latest PDK Spec to Latest PDK Start **/
       /* if((inboundRec.parentId!=null) && (objDesignSpec.Revision__c!=inboundRec.revision)){
            setPDKSpecsRevisionChanged.add(inboundRec.parentId);                
        }*/
        /** Added for Reparenting Latest PDK Spec to Latest PDK End **/
        
        objDesignSpec.Revision__c = inboundRec.revision;
        objDesignSpec.Lifecycle_Phase__c = inboundRec.lifecyclePhase;
        objDesignSpec.Location_Fab__c = inboundRec.locationFab;
        if(inboundRec.revisionReleaseDate!=null){
            objDesignSpec.Revision_Release_Date__c = inboundRec.revisionReleaseDate;
        }
        objDesignSpec.Specification_Release_List_Long__c= inboundRec.specificationReleaseList; // CR # 4562 ? Field replaced
        objDesignSpec.Functional_Ownership__c = inboundRec.functionalOwnership;
        objDesignSpec.Specification_Type__c = inboundRec.specificationType;
        objDesignSpec.Technology_Type__c = inboundRec.technologyType;
        // added by Prajnith
        objDesignSpec.Technology__c = inboundRec.technology;        
        objDesignSpec.Technology_Geometry__c = inboundRec.technologyGeometry;
        objDesignSpec.Source__c = inboundRec.source;
        objDesignSpec.PDK_Version__c = inboundRec.pdkVersion;
        objDesignSpec.DE_Version__c = inboundRec.deVersion;
        objDesignSpec.Specification_sub_class__c = inboundRec.specificationSubClass;
        //objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = inboundRec.specificationOwner;
        // ASIC Changes
      //  objDesignSpec.Specification_ASIC_IP__c = inboundRec.ASICIP;         
//        objDesignSpec.Specification_Restricted_IP__c = inboundRec.RestrictedIP;
                                  
        /* Assigning spec owner by searching from HCM Login Id else defaulting by a specific owner */
        if(inboundRec.specificationOwner!=null && inboundRec.specificationOwner.trim()!=''){
            if(mapDesignSpecsOwnerId!=null && mapDesignSpecsOwnerId.containsKey(inboundRec.specificationOwner.toLowerCase())){
                objDesignSpec.OwnerId = mapDesignSpecsOwnerId.get(inboundRec.specificationOwner.toLowerCase());
            }
            else{
                objDesignSpec.OwnerId = mapSpecOwner.get('Default').UserId__c;
            }
           
        }
        else{
            objDesignSpec.OwnerId = mapSpecOwner.get('Default').UserId__c;  
        }

        objDesignSpec.Commodity_Type_for_material_spec__c = inboundRec.commodityType;
        objDesignSpec.Release_Status__c = inboundRec.specificationReleaseCategory;

        /**
            @if parentId is not null the recordType is PDK Specs
            @if parentId is null and specificationReleaseCategory field is obselete then the recordType is Obsolete Specs**
            @if parentId is null and specificationReleaseCategory field is not obselete then the recordType is Design Specs**
         **/

        if(inboundRec.parentId!=Null){
            objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('PDK Specs');            
            if(mapPDKSpecsInserted!=null && mapPDKSpecsInserted.containsKey(inboundRec.parentId)){
                objDesignSpec.PDK__c=mapPDKSpecsInserted.get(inboundRec.parentId);
            }
            else if(mapPDKPatchSpecsInserted!=null && mapPDKPatchSpecsInserted.containsKey(inboundRec.parentId)){
                objDesignSpec.PDK_Patch__c=mapPDKPatchSpecsInserted.get(inboundRec.parentId);
                //Commented for omission of Sub PDK assignment part
              // objDesignSpec.PDK__c=mapPDKPatchToPDK.get(inboundRec.parentId); 
            }
            
            //Commented for omission of PDK Spec Reparenting Part
            /** Added for Reparenting Latest PDK Spec to Latest PDK Start **/
           /* System.debug('Value of mapPDKSpecsLatestVersionInserted is '+mapPDKSpecsLatestVersionInserted);
            System.debug('Value of inboundRec.parentId is '+inboundRec.parentId);
            if(mapPDKSpecsLatestVersionInserted!=null && mapPDKSpecsLatestVersionInserted.containsKey(inboundRec.parentId) && 
            setPDKSpecsRevisionChanged!=null && setPDKSpecsRevisionChanged.contains(inboundRec.parentId)){
                objDesignSpec.PDK__c=mapPDKSpecsLatestVersionInserted.get(inboundRec.parentId);
            }*/
            /** Added for Reparenting Latest PDK Spec to Latest PDK End **/
            
        }
        else if(inboundRec.lifecyclePhase!=null && inboundRec.lifecyclePhase.toLowercase()=='obsolete'){
            objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('Obsolete Specs');
        }
        else{
            objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('Design Specs');
        }

        return objDesignSpec;

    }


    /** Integrating Design Specs End
     **/


    /** Integrating White List Start
     **/

    /***
        Class Name: wrapperWhiteList
        Type: Inner 
        Use: Wrapper, using to hold inbound White List records 
     ***/

    global class wrapperWhiteList{

        webservice String description;        
        webservice String accountShort;
        webservice Decimal designSpecOTId;
        webservice Integer oldRevisionId;

    }

    private static Map<String,White_List__c> mapOfExistingWhiteLists = new Map<String,White_List__c>();

    /**
        This webservice method is the inbound integration entry touchpoint method for White List Integration.

        @method name: integrateWhiteList
        @parameter:   List of records of wrapperWhiteList inner class, holding the inbound White List attributes.
        @return :     String response of Success/Failure to be returned to the calling procedure.
     **/

    webService static String integrateWhiteList(List<wrapperWhiteList> objWhiteListInsertMsgList) {

        List<White_List__c> listWhiteList=new List<White_List__c>();
        List<White_List__c> listOfWhiteListToBeDeleted=new List<White_List__c>();
        Map<String,String> mapWhiteListRecordTypeId=new Map<String,String>();    
        Set<String> setIncomingAcc = new Set<String>();
        Set<Decimal> setIncomingDesignSpec = new Set<Decimal>();
        Set<Decimal> setIncomingSubPDK = new Set<Decimal>();
        Map<String,String> mapAccountIds = new Map<String,String>();
        Map<Decimal,String> mapDesignSpecIds = new Map<Decimal,String>();
        Map<Decimal,String> mapSubPDKIds = new Map<Decimal,String>();
        List<String> listOfExistingWhiteLists = new List<String>();
        Set<String> setOfExistingWhiteLists = new Set<String>();        
        List<String> exceptionMsg = new List<String>();
        String retValString = '';    

        mapWhiteListRecordTypeId = fetchAllRecTypeIdsMap('White_List__c') ;
        
        if(objWhiteListInsertMsgList!=null && objWhiteListInsertMsgList.size()>0){
            
            for(wrapperWhiteList objWhiteListInsertMsg: objWhiteListInsertMsgList){
                if(objWhiteListInsertMsg.accountShort!=null && objWhiteListInsertMsg.accountShort!=''){
                    setIncomingAcc.add(objWhiteListInsertMsg.accountShort.toLowerCase()); 
    
                } 
                if(objWhiteListInsertMsg.designSpecOTId!=null){
                    setIncomingDesignSpec.add(objWhiteListInsertMsg.designSpecOTId);
                }                
            }
    
            if(setIncomingAcc!=null && setIncomingAcc.size()>0){
                for(Account acc:[Select Id, Name, Short_Name__c from Account where Short_Name__c IN: setIncomingAcc]){
                    mapAccountIds.put(acc.Short_Name__c,acc.Id);         
                }
            }
    
            if(setIncomingDesignSpec!=null && setIncomingDesignSpec.size()>0){
                for(Design_Spec__c dspec:[Select Id, Name, OpenText_Id__c from Design_Spec__c where OpenText_Id__c IN: setIncomingDesignSpec]){
                    mapDesignSpecIds.put(dspec.OpenText_Id__c,dspec.Id);    
                }
    
                /** Populating Lists of Existing White Lists
                 **/
                listOfExistingWhiteLists.addAll(fetchExistingWhiteLists(mapDesignSpecIds.values()));
                system.debug('***listOfExistingWhiteLists**'+listOfExistingWhiteLists);
                if(listOfExistingWhiteLists!=null && listOfExistingWhiteLists.size()>0){
                    setOfExistingWhiteLists.addAll(listOfExistingWhiteLists);
    
                    /** If the Existing White List of a Design Spec is not present in the incoming White Lists,
                        then they are added to a List, so that the White Lists can be deleted.
                     **/
                    for(String existingWhiteList: listOfExistingWhiteLists){
                        if(setIncomingAcc!=null && setIncomingAcc.size()>0 && !setIncomingAcc.contains(existingWhiteList)){
                            listOfWhiteListToBeDeleted.add(mapOfExistingWhiteLists.get(existingWhiteList));            
                        }
                    }
    
                }
    
    
            }
                
            for(wrapperWhiteList objWhiteListInsertMsg: objWhiteListInsertMsgList)
            {
                /** If Loop: If this is an existing White List for the Design Spec, then nothing needs to be done
                    Else Loop: But if the incoming White List does not exist, then the new White List needs to be inserted 
                 **/
                if(setOfExistingWhiteLists!=null && setOfExistingWhiteLists.size()>0 && setOfExistingWhiteLists.contains(objWhiteListInsertMsg.accountShort)){
                    /*do nothing*/
                     retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':'+objWhiteListInsertMsgList.get(0).oldRevisionId+':Success:';                    
                   
                }
    
                else{
                    White_List__c newWhiteList = new White_List__c (); 
                      
                    /* Account is mandatory */        
                    if(mapAccountIds!=null && mapAccountIds.containsKey(objWhiteListInsertMsg.accountShort.toLowerCase()) && mapDesignSpecIds!=null && mapDesignSpecIds.containsKey(objWhiteListInsertMsg.designSpecOTId)){
                        newWhiteList.Account__c = mapAccountIds.get(objWhiteListInsertMsg.accountShort.toLowerCase());
    
                        /* Set other fields */
                        // commented for char limit 255
                        //newWhiteList.Description__c = objWhiteListInsertMsg.description;
                        if(objWhiteListInsertMsg.designSpecOTId!=null){
                            //if(mapDesignSpecIds!=null && mapDesignSpecIds.containsKey(objWhiteListInsertMsg.designSpecOTId)){
                                newWhiteList.Design_Spec__c = mapDesignSpecIds.get(objWhiteListInsertMsg.designSpecOTId);
                            //}
    
                            if(mapWhiteListRecordTypeId.containsKey('Design Spec')){ // Setting Record Type = Design Spec 
                                newWhiteList.recordTypeId = mapWhiteListRecordTypeId.get('Design Spec');    
                            }                                                       
                        }
                        
                        listWhiteList.add(newWhiteList);
                    }          
                    else{
                        // Changes for Case-00002470:Suppressing WhiteList Error
                        //retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':'+objWhiteListInsertMsgList.get(0).oldRevisionId+':WLError:White List Error ';
                        //retValString = objWhiteListInsertMsg.designSpecOTId+':'+objWhiteListInsertMsg.oldRevisionId+':Error:White List Account Short Name not matching with existing Salesforce.Com Account Short Name';    
                    }
                    
                } 
    
            }
    
    
    
            try{
                if(listWhiteList!=null && listWhiteList.size()>0)
                {
                                                          
                    Database.UpsertResult[] db_upsert_res = Database.upsert(listWhiteList, White_List__c.Id,    false) ; 
    
                    Boolean AllInboundSuccessFlag = true ;
    
                    for(Database.UpsertResult er : db_upsert_res){ 
                        
                        System.debug(' *** Value of Success flag is *** ' + er.isSuccess());
                        if(!er.isSuccess()){
                            AllInboundSuccessFlag = false ;
                        }
                    }
                    if(AllInboundSuccessFlag){
                        retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':'+objWhiteListInsertMsgList.get(0).oldRevisionId+':Success:';
                    }
                    else if(!AllInboundSuccessFlag){
                        // Changes for Case-00002470:Suppressing WhiteList Error
                        //retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':'+objWhiteListInsertMsgList.get(0).oldRevisionId+':WLError:';
                    }
    
                }/* end if */
                //else{
                    //retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':'+objWhiteListInsertMsgList.get(0).oldRevisionId+':WLError:White List Error ';
                    //retValString = 'No White List Sent:Error' ;
                //}
    
            }/* end try */
            catch(DmlException e){
    
                // Changes for Case-00002470:Suppressing WhiteList Error
                //retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':Error:';
    
            }
            catch(Exception e){
                // Changes for Case-00002470:Suppressing WhiteList Error
                //retValString = objWhiteListInsertMsgList.get(0).designSpecOTId+':Error:';
    
            }
    
            /** If the List of White Lists To Be Deleted is non-null and non-empty, then this List needs to be deleted.
             **/        
            if(listOfWhiteListToBeDeleted!=null && listOfWhiteListToBeDeleted.size()>0){
                deletePreviousWhiteList(listOfWhiteListToBeDeleted);
            }           
        
        }
        else{
            retValString = 'No White List Data Received From Source.';
        }               
        System.debug('Value of retValString is ' + retValString);
        
        return retValString ;


    }

    /**
        This method fetches the List of Existing White Lists corresponding to the particular Design Spec by querying 
        into the White List object.

        @method name: fetchExistingWhiteLists
        @parameter:   List of Design Spec Ids for which a List of Existing White Lists needs to be retrieved via SOQL Query into White List object.
        @return :     List of White List Account Short Names.
     **/

    public static List<String> fetchExistingWhiteLists(List<String> dSpecIds){

        List<String> listWhiteLists = new List<String>();
        for(White_List__c wList: [Select Account__c, Account_Short_Name__c, Design_Spec__c from White_List__c 
                                  where Design_Spec__c IN: dSpecIds]){
            listWhiteLists.add(wList.Account_Short_Name__c); 
            mapOfExistingWhiteLists.put(wList.Account_Short_Name__c,wList);                     
        }
        return listWhiteLists;
    }
    
    /**
        This method deletes the List of Previous Existing White Lists corresponding to the particular Design Spec through DML Delete operation.
        
        @method name: deletePreviousWhiteList
        @parameter:   List of Previous Existing White Lists to be deleted.
        @return :     None.
     **/
     
    public static void deletePreviousWhiteList(List<White_List__c> listWhiteList){

        try{            
            delete listWhiteList;                     
        }
        catch(DmlException e){           
            System.debug(e);           
        }
        
    }

    /** Integrating White List End
     **/

    /** Integrating PDK Start
     **/

    /***
        Class Name: wrapperPDK
        Type: Inner 
        Use: Wrapper, using to hold inbound PDK records 
     ***/

    global class wrapperPDK{

        webservice Integer openTextId;       
        webservice Integer oldRevisionId;
        webservice String pdkId;
        webservice String description;
        webservice String pdkDoctitle;
        webservice String pdkVersion;
        webservice String technology;
        webservice String techGeometry;
        webservice String pdkLifecyclePhase;
        webservice DateTime pdkRevisionReleaseDate;
        webservice String pdkLocationFab;
        webservice String pdkSubClass;
        webservice String pdkSpecificationOwner;
        webservice String pdkFunctionalOwnership;
        webservice String pdkSpecificationType;
        // Prajnith ASIC        
        webservice String BusinessCategory; // ASIC Flag
       // Ashish Jadhav     
        webservice String pdkTechnologyNode;        

    }

    /**
        This webservice method is the inbound integration entry touchpoint method for PDK Integration.

        @method name: integratePDK
        @parameter:   List of records of 
        
         inner class, holding the inbound PDK attributes.
        @return :     List of String responses to be returned to the calling procedure.
     **/

    webService static List<String> integratePDK(List<wrapperPDK> objPDKInsertMsgList) {

        List<Decimal> inboundOTextIdList = new List<Decimal>(); 
        List<PDK__c> listPDK = new List<PDK__c>();
        List<String> pdkIdList = new List<String>();
        List<String> exceptionMsg = new List<String>(); 
        /** Set of incoming Owners for PDKs **/
        Set<String> inboundOwnerId = new Set<String>();
        System.debug(' *** Size of objPDKInsertMsgList List is *** ' + objPDKInsertMsgList.size());
        
        if(objPDKInsertMsgList!=null && objPDKInsertMsgList.size()>0){
            
            /* put all incoming OpenText Ids in to a list */
            for(wrapperPDK obj:objPDKInsertMsgList){
                if(obj.openTextId!=null){
                    inboundOTextIdList.add(obj.openTextId);
                }
                 /** Put all incoming Owners into Sets **/
                if(obj.pdkSpecificationOwner!=null){
                    inboundOwnerId.add(obj.pdkSpecificationOwner.toLowerCase()); 
                }
            }   
            
            /** Querying on User table for valid Owner by HCM Login Id through fetchAllSpecsOwnersByIds method **/
            if(inboundOwnerId!=null && inboundOwnerId.size()>0){
                mapPDKsOwnerId.putAll(fetchAllSpecsOwnersByIds(inboundOwnerId));     
            }
                
            Map<Decimal,PDK__c> existingPDKsMap = new Map<Decimal,PDK__c>() ;
            Set<Decimal> setVersionInsertPDK = new Set<Decimal>();
            existingPDKsMap = fetchAllPDKsByOTIds(inboundOTextIdList);
    
            for(wrapperPDK objInboundWrap : objPDKInsertMsgList){
    
                if(existingPDKsMap!=null && existingPDKsMap.containsKey(objInboundWrap.openTextId)){
    
                    PDK__c d1 = new PDK__c() ; /* insert or update */
    
                    d1 = existingPDKsMap.get(objInboundWrap.openTextId) ;
    
                    /*
                    @ If Loop: If version value is same then only update
                    @ Else Loop: If value of version changed then both insert and update    
                     */
                    if(d1.PDK_Version__c==objInboundWrap.pdkVersion){
    
                        PDK__c d3 = preparePDKRec(objInboundWrap) ;          
                        d3.Id = d1.Id ;
                        d3.Is_Latest_Version__c  = d1.Is_Latest_Version__c; // Prajnith K 12/04/2015
                        
                        //d3.Name= d1.Name;     
                        //d3.Name= objInboundWrap.pdkDocTitle + ' ' + objInboundWrap.pdkVersion;//modified by cognizant for Case 2585
                                                             
                        listPDK.add(d3) ;
                    }
                    else{
    
                        PDK__c d2 = preparePDKRec(objInboundWrap) ; /* update */              
                        d2.Id = d1.Id;
                        d2.Is_Latest_Version__c = d1.Is_Latest_Version__c; // Prajnith K 12/04/2015
                        d1.OpenText_ID__c = objInboundWrap.oldRevisionId ;               
                        d1.Id = null; 
                        d1.Is_Latest_Version__c = false; // Prajnith K 12/04/2015
                                                
                        setVersionInsertPDK.add(d1.OpenText_ID__c);                               
                        listPDK.add(d2) ;                        
                        listPDK.add(d1) ;    
                    }
    
    
                }
                else{
                    // Prajnith K 12/04/2015
                    // Mast is Latest version to True when Master PDK is created for First Time
                    PDK__c d4 = preparePDKRec(objInboundWrap) ; /* insert */  
                     d4.Is_Latest_Version__c = true; 
                    listPDK.add(d4) ;
                }
    
    
            }/* end for */
    
            try{
                Database.UpsertResult[] db_upsert_res = Database.upsert(listPDK,  PDK__c.Fields.ID,  FALSE) ; 
    
                Integer pointerInt = 0 ;
    
                for(Database.UpsertResult er : db_upsert_res){ 
                    String retMsg = '' ;
                    if(er.isSuccess())
                    {
                        /** Revision Insert*/
                        if(setVersionInsertPDK!=null && setVersionInsertPDK.contains(listPDK.get(pointerInt).OpenText_ID__c)){
                            //do nothing   
                        }
                        else{
                            retMsg = listPDK.get(pointerInt).OpenText_ID__c + ':' + listPDK.get(pointerInt).Old_Revision_ID__c + ':Success:'+er.getId() ;
                        }
                    }
                    else
                    {
                        retMsg = listPDK.get(pointerInt).OpenText_ID__c + ':' + listPDK.get(pointerInt).Old_Revision_ID__c + ':Error:'+er.getErrors() ;
                    }
                    if(retMsg!=null && retMsg.trim()!=''){
                        pdkIdList.add(retMsg) ;
                    } 
                    pointerInt++ ;          
                }
                System.debug('Size of pdkIdList is' + pdkIdList.size() + ' and Value is ' + pdkIdList);
    
            }
            catch(DmlException e)
            {
                System.debug(e) ;
            }  
            catch(Exception e)
            {
                System.debug(e) ;
            }
        }
        else{
            pdkIdList.add('No PDK Data Received From Source.');
        }

        return pdkIdList ;



    }

    /**
        This method fetches all the PDKs from Database through SOQL query when a List of Open Text Ids is provided as input.

        @method name: fetchAllPDKsByOTIds
        @parameter:   List of Open Text Ids of PDKs which need to be queried from database.
        @return :     Map of PDK records having the Key as the Open Text Ids provided as inputs.
     **/

    public static Map<Decimal,PDK__c> fetchAllPDKsByOTIds(List<Decimal> OTIdsList)
    {
        // added is Latest version field Prajnith K 12/04/2015
        List<PDK__c> fetchPDKRes = new List<PDK__c>() ;
        Map<Decimal,PDK__c> fetchPDKsMap = new Map<Decimal,PDK__c>() ; 
        fetchPDKRes = [Select 
                       Id, Name, Description__c, Old_Revision_ID__c,Master_PDK_Full_Name__c,Is_Latest_Version__c,
                       OpenText_ID__c, ParentID__c, PDK_DocTitle__c,
                       PDK_Functional_Ownership__c, PDK_Lifecycle_Phase__c, 
                       PDK_Location_Fab__c, PDK_Revision_Release_Date__c, 
                       PDK_Specification_Owner__c, PDK_Sub_class__c, PDK_Version__c, 
                       Tech_Geometry__c, Technology__c, PDK_Id__c ,Master_PDK_ASIC__c,TechnologyNode__c
                       From 
                       PDK__c 
                       WHERE 
                       OpenText_ID__c IN : OTIdsList];


        for(PDK__c sp : fetchPDKRes){

            fetchPDKsMap.put(sp.OpenText_ID__c, sp) ;
        }

        return fetchPDKsMap ;  
    }

    /**
        This method prepares the PDK records for upsert operation by assigning the inbound PDK attributes to the
        PDK custom fields on the PDK object on Salesforce.Com.

        @method name: preparePDKRec
        @parameter:   Instance of the wrapperPDK inner class which contains the PDK attributes inbound to Salesforce.Com.
        @return :     Prepared single PDK record which will be sent lated for Upsert operation.
     **/

    public static PDK__c preparePDKRec(wrapperPDK inboundRec){

        PDK__c objPDK = new PDK__c();
        String str = inboundRec.pdkDocTitle + ' ' + inboundRec.pdkVersion;
        if(str.length()>80)
            objPDK.Name = str.substring(0,80);
        else
            objPDK.Name = str;  
        objPDK.Master_PDK_Full_Name__c = inboundRec.pdkDocTitle + ' ' + inboundRec.pdkVersion;
        objPDK.PDK_DocTitle__c = inboundRec.pdkDocTitle;
        objPDK.OpenText_ID__c = inboundRec.openTextId;
        objPDK.Description__c = inboundRec.description;
        objPDK.Old_Revision_ID__c = inboundRec.oldRevisionId;        
        objPDK.PDK_Functional_Ownership__c = inboundRec.pdkFunctionalOwnership;
        objPDK.PDK_Lifecycle_Phase__c = inboundRec.pdkLifecyclePhase;
        objPDK.PDK_Location_Fab__c = inboundRec.pdkLocationFab;
        objPDK.PDK_Specification_Owner__c = inboundRec.pdkSpecificationOwner;
        // ASIC Changes        
        objPDK.Master_PDK_ASIC__c = (inboundRec.BusinessCategory == 'true'?true:false); 
        objPDK.TechnologyNode__c = inboundRec.pdkTechnologyNode;    
        
        /* Assigning PDK owner by searching from HCM Login Id else defaulting by a specific owner */
        if(inboundRec.pdkSpecificationOwner!=null && inboundRec.pdkSpecificationOwner.trim()!=''){
            if(mapPDKsOwnerId!=null && mapPDKsOwnerId.containsKey(inboundRec.pdkSpecificationOwner.toLowerCase())){
                objPDK.OwnerId = mapPDKsOwnerId.get(inboundRec.pdkSpecificationOwner.toLowerCase());
            }
            else{
                objPDK.OwnerId = mapSpecOwner.get('Default').UserId__c;
            }
           
        }
        else{
            objPDK.OwnerId = mapSpecOwner.get('Default').UserId__c; 
        }
        
        if(inboundRec.pdkRevisionReleaseDate!=null){
            objPDK.PDK_Revision_Release_Date__c = inboundRec.pdkRevisionReleaseDate;
        }
        objPDK.PDK_Sub_class__c = inboundRec.pdkSubClass;
        objPDK.PDK_Version__c = inboundRec.pdkVersion;
        objPDK.Tech_Geometry__c = inboundRec.techGeometry;
        objPDK.Technology__c = inboundRec.technology;
        objPDK.PDK_ID__c = inboundRec.pdkId;
        // commented by Prajnith K - 12/04/2015  
        // As this value is not received  from OT, now Update the value based on Existing value      
        //objPDK.Is_Latest_Version__c = true;                 

        return objPDK;

    }

    /** Integrating PDK End
     **/ 

    /** Integrating PDK Patch Start
     **/

    /***
        Class Name: wrapperPDKPatch
        Type: Inner 
        Use: Wrapper, using to hold inbound PDK Patch records 
     ***/

    global class wrapperPDKPatch{

        webservice Integer openTextId;
        webservice Integer parentId;               
        webservice String pdkPatchId;
        webservice String description;
        webservice String pdkPatchDoctitle;
        webservice String parentPdkVersion;
        webservice String technology;
        webservice String techGeometry;
        webservice String pdkPatchLifecyclePhase;
        webservice String pdkPatchLocationFab;
        webservice String pdkPatchSubClass;
        webservice String pdkPatchSpecificationOwner;
        webservice String pdkPatchFunctionalOwnership;
        webservice Integer pdkPatchCounter;
        
        /** New fields added in Integration Channel **/
        webservice String pdkVersion;
        webservice String pdkRevision;
        webservice DateTime pdkRevisionReleaseDate;
        webservice String pdkSpecificationType;
        webservice String pdkParentPDKId;
        // Prajnith ASIC         
        webservice String RestrictedIP;
        webservice String ASICIP; // link to IP       
        // Ashish Jadhav
        webservice String pdkPatchTechnologyNode;
        /** New fields added in Integration Channel **/

    }

    private static Map<Decimal,PDK__c> existingPDKs = new Map<Decimal,PDK__c>() ;

    /**
        This webservice method is the inbound integration entry touchpoint method for PDK Patch Integration.

        @method name: integratePDKPatch
        @parameter:   List of records of wrapperPDKPatch inner class, holding the inbound PDK Patch attributes.
        @return :     List of String responses to be returned to the calling procedure.
     **/

    webService static List<String> integratePDKPatch(List<wrapperPDKPatch> objPDKPatchInsertMsgList) {
        
        List<Decimal> inboundOpenTextIdList = new List<Decimal>();
        List<Decimal> inboundParentIdList = new List<Decimal>(); 
        List<PDK_Patch__c> listPDKPatch = new List<PDK_Patch__c>();
        List<String> pdkPatchIdList = new List<String>();
        List<String> exceptionMsg = new List<String>(); 
        Map<Decimal,PDK_Patch__c> existingPDKPatchesMap = new Map<Decimal,PDK_Patch__c>() ;
        System.debug('*** Size of objPDKPatchInsertMsgList is *** '+objPDKPatchInsertMsgList.size());
        
        if(objPDKPatchInsertMsgList!=null && objPDKPatchInsertMsgList.size()>0){
        
            /* put all incoming OpenText Ids in to a list */
            for(wrapperPDKPatch obj:objPDKPatchInsertMsgList){
                if(obj.openTextId!=null){
                    inboundOpenTextIdList.add(obj.openTextId);
                }
                if(obj.parentId!=null){
                    inboundParentIdList.add(obj.parentId);
                }
            }   
            
            existingPDKPatchesMap = fetchAllPDKPatchesByOTIds(inboundOpenTextIdList);
            existingPDKs = fetchAllPDKsByOTIds(inboundParentIdList);
            System.debug('*** Size of existingPDKs is *** '+existingPDKs.size()+' *** and value is *** '+existingPDKs);
    
            for(wrapperPDKPatch objInboundWrap : objPDKPatchInsertMsgList){
                
                if(existingPDKPatchesMap!=null && existingPDKPatchesMap.containsKey(objInboundWrap.openTextId)){
    
                    PDK_Patch__c d1 = new PDK_Patch__c() ; /* insert or update */
    
                    d1 = existingPDKPatchesMap.get(objInboundWrap.openTextId) ;
        
                    PDK_Patch__c d3 = preparePDKPatchRec(objInboundWrap) ;          
                    d3.Id = d1.Id ;
                    listPDKPatch.add(d3) ;
                }
                else{                                    
                    listPDKPatch.add(preparePDKPatchRec(objInboundWrap)) ;              
                }   
            }/* end for */
    
            try{
                Database.UpsertResult[] db_upsert_res = Database.upsert(listPDKPatch,  PDK_Patch__c.Fields.ID,  FALSE) ; 
    
                Integer pointerInt = 0 ;
    
                for(Database.UpsertResult er : db_upsert_res){ 
                    String retMsg = '' ;
                    if(er.isSuccess())
                    {
                        retMsg = listPDKPatch.get(pointerInt).OpenText_ID__c + ':NULL:Success:'+er.getId();
                    }
                    else
                    {
                        retMsg = listPDKPatch.get(pointerInt).OpenText_ID__c + ':NULL:Error:'+er.getErrors() ;
                    }
                    pdkPatchIdList.add(retMsg);                  
                    pointerInt++ ;          
                }
                System.debug('*** Size of pdkPatchIdList is *** '+pdkPatchIdList.size()+' *** and Value is *** '+pdkPatchIdList);
    
            }
            catch(DmlException e)
            {
                System.debug(e) ;
            }  
            catch(Exception e)
            {
                System.debug(e) ;
            }
        }
        else{
            pdkPatchIdList.add('No PDK Patch Data Received From Source.');
        }
        
        return pdkPatchIdList ;

    }
    
     /**
        This method fetches all the PDK Patches from Database through SOQL query when a List of Open Text Ids is provided as input.

        @method name: fetchAllPDKPatchesByOTIds
        @parameter:   List of Open Text Ids of PDK Patches which need to be queried from database.
        @return :     Map of PDK Patches records having the Key as the Open Text Ids provided as inputs.
     **/

    public static Map<Decimal,PDK_Patch__c> fetchAllPDKPatchesByOTIds(List<Decimal> OTIdsList)
    {

        List<PDK_Patch__c> fetchPDKPatchRes = new List<PDK_Patch__c>() ;
        Map<Decimal,PDK_Patch__c> fetchPDKPatchMap = new Map<Decimal,PDK_Patch__c>() ; 
        fetchPDKPatchRes = [Select 
                       Id, Name, Description__c, Master_PDK_Parent_PDK_Version__c,PDK_Patch_Full_Name__c, 
                       OpenText_ID__c, PDK_Parent_PDK_ID__c, PDK_Id__c,
                       Patch_PDK_Lifecycle_Phase__c, PDK__c,PDK_Patch_Doc_Title__c,
                       Patch_PDK_Location_Fab__c, PDK_Revision_Release_Date__c, 
                       Patch_PDK_Specification_Owner__c, Patch_PDK_Sub_class__c, PDK_Version__c, 
                       Tech_Geometry__c, Technology__c,PDK_Patch_TechnologyNode__c
                       From 
                       PDK_Patch__c 
                       WHERE 
                       OpenText_ID__c IN : OTIdsList];


        for(PDK_Patch__c sp : fetchPDKPatchRes){

            fetchPDKPatchMap.put(sp.OpenText_ID__c, sp) ;
        }

        return fetchPDKPatchMap ;  
    }

/*-----------------------------added by cognizant  for the Case 00004324------------------------------------------------------------------*/
/**
This Method is to uptate Contact object based on user creation in OpenText system. 
By Federation Id, it searches on User and also the related Contact. 
Then update the Contact record.

**/

webService static String updateContactOnOTUserCreation(String strUserOTId, String strFederationId, Boolean booUserFoundInOT)
{
    String retMsg = '' ; 
     
    if(strUserOTId!=null && strUserOTId!='' && strFederationId!=null && strFederationId!='')
    {
        try{
        
            User u = [SELECT Id, ContactId, Contact.UserFoundInOT__c, FederationIdentifier FROM USER 
                     WHERE  FederationIdentifier =: strFederationId]     ;
        
            if(u != null && u.ContactId!=null)
            { 
           
                Contact c  = new Contact() ;
                c.Id =     u.ContactId ; 
                c.UserFoundInOT__c     =     booUserFoundInOT     ; 
                update c ; 
                retMsg = strUserOTId+'|Success'    ;
          
            }
            else{
                retMsg = strUserOTId+'|Exception|User not found in SFDC OR User is not tagged with Contact'    ;
            }
        }
        catch(Exception ex){
            retMsg = strUserOTId+'|Exception|'+ex    ;
        }
    }
    else{
        retMsg = strUserOTId+'_'+strFederationId+'|Error|OTId or FedId Missing'    ; 
    }
    
    return retMsg ;
}

   
/*--------------------------------------------------------------------------------------------------------------------*/    
       
    /**
        This method prepares the PDK Patch records for upsert operation by assigning the inbound PDK Patch attributes to the
        PDK Patch custom fields on the PDK Patch object on Salesforce.Com.

        @method name: preparePDKPatchRec
        @parameter:   Instance of the wrapperPDKPatch inner class which contains the PDK Patch attributes inbound to Salesforce.Com.
        @return :     Prepared single PDK Patch record which will be sent lated for Upsert operation.
     **/

    public static PDK_Patch__c preparePDKPatchRec(wrapperPDKPatch inboundRec){

        PDK_Patch__c objPDKPatch = new PDK_Patch__c();
        if(existingPDKs!=null && existingPDKs.containsKey(inboundRec.parentId)){
            /** Master PDK is mandatory **/
            objPDKPatch.PDK__c = existingPDKs.get(inboundRec.parentId).Id; 
        }
        else{
            objPDKPatch.PDK__c = null; 
        }        
        objPDKPatch.OpenText_ID__c = inboundRec.openTextId;
        objPDKPatch.PDK_Id__c = inboundRec.pdkPatchId;
        objPDKPatch.Description__c = inboundRec.description;
        objPDKPatch.Patch_PDK_Lifecycle_Phase__c = inboundRec.pdkPatchLifecyclePhase;
        objPDKPatch.Patch_PDK_Location_Fab__c = inboundRec.pdkPatchLocationFab;
        objPDKPatch.Patch_PDK_Specification_Owner__c = inboundRec.pdkPatchSpecificationOwner;
        objPDKPatch.Patch_PDK_Sub_class__c = inboundRec.pdkPatchSubClass;       
        objPDKPatch.Tech_Geometry__c = inboundRec.techGeometry;        
        objPDKPatch.Technology__c = inboundRec.technology;
        
        /** New fields added in Integration Channel **/
        String str = inboundRec.pdkPatchDoctitle + ' ' + inboundRec.pdkVersion;
        if(str.length()>80)
            objPDKPatch.Name = str.substring(0,80);
        else
            objPDKPatch.Name = str; 
        objPDKPatch.PDK_Patch_Full_Name__c = inboundRec.pdkPatchDoctitle + ' ' + inboundRec.pdkVersion;
        
        //objPDKPatch.Name = inboundRec.pdkPatchDoctitle + ' ' + inboundRec.pdkVersion;
        objPDKPatch.PDK_Patch_Doc_Title__c = inboundRec.pdkPatchDoctitle;
        objPDKPatch.PDK_Version__c = inboundRec.pdkVersion;
        objPDKPatch.PDK_Specification_Type__c = inboundRec.pdkSpecificationType;
        objPDKPatch.PDK_Parent_PDK_ID__c = inboundRec.pdkParentPDKId;
        // ASIC Changes                        
    //    objPDKPatch.Master_PDK_Patch_ASICIP__c = (inboundRec.ASICIP == 'true'?true:false); 
//        objPDKPatch.Master_PDK_Patch_Restricted_IP__c = inboundRec.RestrictedIP;
        // Added new field 
        objPDKPatch.PDK_Patch_TechnologyNode__c= inboundRec.pdkPatchTechnologyNode; 
        
        objPDKPatch.PDK_Revision__c = inboundRec.pdkRevision;
        objPDKPatch.Master_PDK_Parent_PDK_Version__c = inboundRec.parentPdkVersion;
        objPDKPatch.Master_PDK_Patch_Counter__c = inboundRec.pdkPatchCounter;
        if(inboundRec.pdkRevisionReleaseDate!=null){
            objPDKPatch.PDK_Revision_Release_Date__c = inboundRec.pdkRevisionReleaseDate;
        }
        /** New fields added in Integration Channel **/

        return objPDKPatch;

    } 

    /** Integrating PDK Patch End
     **/
    
/*-----------------------------Added by cognizant  for the Case 00004563 starts------------------------------------------------------------------*/

/**
This Method is to update Account record based on account creation in OpenText system. 
Based on Account short name, it searches the account and updates the Account record.
**/


webService static String updateAccOnCreationInOT(String accOpenTextID,String strAccShortName , Boolean booAccFoundInOT) {
    String retMsg = '' ; // Variable to return status message of operation

    if(accOpenTextID!=null && accOpenTextID!='' && strAccShortName !=null && strAccShortName!='' )
    {
        try{
        
        // Fetch the account record on the  account short name

            //Account accRec = new Account() ; 
            List<Account> accList = [SELECT Id, Has_Valid_NDA__c,Tech_Geo_Granted__c,Valid_Tech_Geos__c,Account_Present_In_OT__c FROM Account
                     WHERE  Short_Name__c=: strAccShortName LIMIT 1]     ;
        
            Account accRec = !accList.isEmpty()?accList.get(0):null;
            
            if(accRec  != null)
            { 
            //Update retrieved account record based on the flag parameter passed
                
                accRec.Account_Present_In_OT__c      = booAccFoundInOT; 
                update accRec ; 
                retMsg = accOpenTextID+'-'+strAccShortName +'|Success| '+'Has Valid NDA:'+accRec.Has_Valid_NDA__c ;
          
            }
            else{
                retMsg = accOpenTextID+'|Exception|Account not found in SFDC'    ;
            }
        }
         catch(DMLException ex){
            retMsg = '|DML Exception occured in updating account with OT Id '+accOpenTextID
            +' and short name '+strAccShortName+'|' +ex    ;
        }
        catch(Exception ex){
            retMsg = accOpenTextID+'-'+strAccShortName +'|Exception|'+ex    ;
        }
    }
    else{
        retMsg = accOpenTextID+'-'+strAccShortName+'|Error|OT Id or Account short name missing'    ; 
    }
    
    return retMsg ;
}

/*---------------------- Added by cognizant  for the Case 00004563 ends --------------------*/
}