/*
    Author: Ariz Solito
    Description: Apex outbound webservice class for NPI Validator sync
                 Business Rules inside the syncDatamart method:
                 
                 1. Duplicate model name validation of feature list coming from datamart
                 2. Populate IO Voltage or Core Voltage depending of the Feature Group
                 3. Flag for delete existing feature list not found in the new data coming from datamart
    History: 
    Asolito      08/02/2016    - Apex code created
*/
global class DatamartMLGPlusService {

    global class MLGPlus {
        webservice String geometry;
        webservice String parentProductName;
        webservice String parentProductExternalID;
        webservice String status;
        webservice String catalogType;
        webservice String processedVersion;
        webservice Boolean fromDatamart;
        webservice Boolean isFinal;
    }
       
    global class MLGRecord {
        webservice Integer serialNumber;
        webservice String modelName;
        webservice String version;
        webservice String featureGroup;
        webservice String featureDescription;
        webservice String additionalMasks;   
        webservice String FEOLBEOL;
        webservice String voltage;
        webservice String MLGPlusID;             
    }
    
    public static void logError(String productName,String message){
        ApplicationLogWrapper log = new ApplicationLogWrapper();
        log.source = 'DatamartMLGPlusService';
        log.sourceFunction = 'createMLGPlus()';
        log.applicationName = 'Apptus CPQ';
        log.logMessage = 'ERROR in ' + productName +': '+ message;
        log.debugLevel = 'ERROR';            
        GlobalUtility.logMessage(log);
    }  
    
    webservice static String syncDatamart(MLGPlus mainRec, List<MLGRecord> MLGRecords){
        String resp = createMLGPlus(mainRec);
        
        if(resp.contains('ERROR')){
            logError(mainRec.parentProductName,resp);
            
            return resp; 
        } else {
            String status = createMLGRecords(resp,MLGRecords); 
            
            if(status.contains('ERROR')){
                logError(mainRec.parentProductName,status);
                
                return status;
            }              
        }
        return 'SUCCESS';    
    }
    
    private static String createMLGPlus(MLGPlus mainRec){
        CPQ_MLGPlus__c rec = new CPQ_MLGPlus__c(
            geometry__c = mainRec.geometry,
            parent_product_name__c = mainRec.parentProductName,
            process_technology__c = mainRec.parentProductName,
            status__c = mainRec.status,
            catalog_type__c = mainRec.catalogType,
            from_datamart__c = mainRec.fromDatamart,
            final__c = mainRec.isFinal,
            processed_version__c = mainRec.processedVersion,
            parent_product_external_ID__c = mainRec.parentProductExternalID
        );
        
        try {
            upsert rec parent_product_external_ID__c;
        } catch (Exception e){                                   
            return 'ERROR: '+e;
        }
        
        return rec.id;
    }
    
    private static String createMLGRecords(String MLGPlusID, List<MLGRecord> MLGRecords){
        String status = '';
        
        Map<String, MLG_Record__c> prevMLGRecMap = new Map<String, MLG_Record__c>();                
        
        for(MLG_Record__c rec : [SELECT feature_group__c,IO_voltage_v__c,core_voltage_v__c,
                                        feature_description__c,model_name__c,additional_mask_s__c,
                                        FEOL_BEOL__c,CPQ_MLGPlus__c,version__c,
                                        is_delete_flag__c,serial_number__c
                                   FROM MLG_Record__c
                                   WHERE CPQ_MLGPLUS__c =:MLGPlusID
                                   AND is_delete_flag__c = false
                                   AND feature_group__c <> 'Attribute Rule']){
            String key;
            if(UtilsString.isNotBlank(rec.model_name__c) && rec.model_name__c <> 'N/A'){
                key = rec.model_name__c;
            } else {
                key = rec.feature_description__c;
            }
                                               
            prevMLGRecMap.put(key, rec);                                               
        }
        
        Map<String, MLG_Record__c> currMLGRecMap = new Map<String, MLG_Record__c>();        
        
        for(MLGRecord rec: MLGRecords){            
            String key;
            
            if(UtilsString.isNotBlank(rec.modelName) && rec.modelName <> 'N/A'){
                key = rec.modelName;
            } else {
                key = rec.featureDescription;
            }
            
            if(currMLGRecMap.containsKey(key)){
                status += 'ERROR: Model name cannot be duplicate -' + key +'\n';                
            } else {
                //check if voltage is IO or Core
                String IOVoltage;
                String coreVoltage;
                if(!String.isBlank(rec.featureGroup)){
                    if(rec.featureGroup.toUpperCase().contains('CORE FET') || 
                       rec.featureGroup.toUpperCase().contains('CAPACITOR')){
                        coreVoltage = rec.voltage;
                    } else if(rec.featureGroup.toUpperCase().contains('IO FET') || 
                              rec.featureGroup.toUpperCase().contains('I/O FET')){
                        IOVoltage = rec.voltage;
                    }
                }
                
                MLG_Record__c r = new MLG_Record__c(
                    feature_group__c = rec.featureGroup,
                    IO_voltage_v__c = IOVoltage,
                    core_voltage_v__c = coreVoltage,
                    feature_description__c = rec.featureDescription,
                    model_name__c = rec.modelName == NULL ? rec.featureDescription : rec.modelName,
                    additional_mask_s__c = rec.additionalMasks,
                    FEOL_BEOL__c = rec.FEOLBEOL,
                    CPQ_MLGPlus__c = MLGPlusID,
                    version__c = '#' + rec.version + '#',
                    serial_number__c = rec.serialNumber    
                );
                
                currMLGRecMap.put(key,r);
            }
        }    
        
        //stop processing if duplicate error is found
        if(status.contains('ERROR')){
           
            return status;
            
        } else {           
            List<MLG_Record__c> insertMlgRecList = new List<MLG_Record__c>();
            List<MLG_Record__c> updateMlgRecList = new List<MLG_Record__c>();                                   
            
            for(String key: currMLGRecMap.keySet()){
                //update feature detail
                if(prevMLGRecMap.containsKey(key)){
                    MLG_Record__c currRec = currMLGRecMap.get(key);
                    MLG_Record__c prevRec = prevMLGRecMap.get(key);
                    
                    prevRec.Feature_Group__c = currRec.Feature_Group__c;
                    prevRec.IO_Voltage_V__c = currRec.IO_Voltage_V__c;
                    prevRec.Core_Voltage_V__c = currRec.Core_Voltage_V__c;
                    prevRec.Feature_Description__c = currRec.Feature_Description__c;
                    prevRec.Additional_Mask_s__c = currRec.Additional_Mask_s__c;
                    prevRec.FEOL_BEOL__c = currRec.FEOL_BEOL__c;
                    prevRec.Serial_Number__c = currRec.Serial_Number__c;
                    prevRec.version__c = currRec.version__c;
                    updateMlgRecList.add(prevRec);    
                     
                //new feature   
                } else {
                    MLG_Record__c rec = currMLGRecMap.get(key);                    
                    insertMlgRecList.add(rec);        
                }          
            }
            
            // Populate the version of the existing records in MLG Record and mark the Is Delete Flag to true.
            for(String key : prevMLGRecMap.keySet()){
                if(!currMLGRecMap.containsKey(key)){
                    MLG_Record__c rec = prevMLGRecMap.get(key);
                    rec.Is_Delete_Flag__c = true;
                    updateMlgRecList.add(rec);
                }    
            }
            
            // Insert records into MLG Record object
            if(insertMlgRecList.size() > 0){                
                Database.SaveResult[] srlist = Database.insert(insertMlgRecList,true);
                 
                //log errors if any               
                for(Database.SaveResult sr : srlist){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()) {
                            status += 'ERROR ' + err.getStatusCode() + ':' + err.getMessage() + '\n';  
                        }
                    }           
                }                              
            }
            
            // Update records into MLG Record object
            if(updateMlgRecList.size() > 0){                
                Database.SaveResult[] srlist = Database.update(updateMlgRecList,true);
                
                //log errors if any               
                for(Database.SaveResult sr : srlist){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()) {
                            status += 'ERROR ' + err.getStatusCode() + ':' + err.getMessage() + '\n';  
                        }
                    }           
                }  
            }  
        }                                                    
        return status;
    }                  
}