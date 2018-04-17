/**********************************************************************************************************************************************
Class:         CPQMetadataStatusController 
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha
Created Date:  05/08/2015
Reason:        Displays Metadata Status for the MLG plus. 
**********************************************************************************************************************************************/
public class CPQMetadataStatusController {
    public Map<String,String> StatusRow {get; set;}
    public List<String> ColumnList {get;set;}
    public Map<string, List<String>> MLGValuesMap ; 
    public Boolean ButtonDisplay {get;set;}
    public Boolean ButtonClicked {get;set;}
    public Boolean ShowMessage {get;set;}
    String MLGPLUSID  ;
    public CPQMetadataStatusController(ApexPages.StandardController controller) {
        ButtonDisplay = false ; 
        ButtonClicked = false ;
        ColumnList = new List<String>();
        StatusRow  = new Map<String,String>();
        MLGValuesMap  = new Map<string, List<String>> ();
        MLGPLUSID  = ApexPages.currentPage().getParameters().get('Id') ; 
        CPQ_Settings__c cpqAttributeMetadata = CPQ_Settings__c.getValues('Attribute Metadata Fields');
        List<MLG_Record__c> mlgRecords = new List<MLG_Record__c>();
        for(MLG_Record__c mlg:  [select   id
                                        , Core_Voltage_V__c
                                        , Feature_Group__c
                                        , Feature_Description__c
                                        , IO_Voltage_V__c
                                        , name
                                        , Version__c 
                                        , CPQ_MLGPLUS__c 
                                        , CPQ_MLGPLUS__r.Processed_Version__c
                                        , CPQ_MLGPLUS__r.Process_Technology__c 
                              from      MLG_Record__c 
                              where     CPQ_MLGPLUS__c = :MLGPLUSID ] ){
           if( mlg.CPQ_MLGPLUS__r.Processed_Version__c != null && mlg.Version__c != null && mlg.Version__c.contains('#'+mlg.CPQ_MLGPLUS__r.Processed_Version__c+'#')){
               mlgRecords.add(mlg);
               if(mlg.CPQ_MLGPLUS__r.Process_Technology__c != NULL && !MLGValuesMap.containsKey(cpqAttributeMetadata.Value__c.split(',')[0])){
                   List<String> tempList1 = new List<String>();
                   tempList1.add( mlg.CPQ_MLGPLUS__r.Process_Technology__c);
                   MLGValuesMap.put(cpqAttributeMetadata.Value__c.split(',')[0] ,tempList1);
               }
               if(mlg.Feature_Group__c == 'Metal Options' || mlg.Feature_Group__c == 'Metal Stacks'){
                    if(!MLGValuesMap.containsKey(cpqAttributeMetadata.Value__c.split(',')[1])){
                        List<String> tempList2 = new List<String>();
                        tempList2.addAll(mlg.Feature_Description__c.split(','));
                        MLGValuesMap.put(cpqAttributeMetadata.Value__c.split(',')[1] ,tempList2 );
                    }
                    else {
                        MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[1]).addAll(mlg.Feature_Description__c.split(','));
                    }
                }
                if(mlg.IO_Voltage_V__c != null 
                    && mlg.IO_Voltage_V__c != 'NA' 
                    && mlg.IO_Voltage_V__c != 'N/A'){
                    if(!MLGValuesMap.containsKey(cpqAttributeMetadata.Value__c.split(',')[2])){
                        List<String> tempList3 = new List<String>();
                        tempList3.addAll( mlg.IO_Voltage_V__c.split(','));
                        MLGValuesMap.put(cpqAttributeMetadata.Value__c.split(',')[2] ,tempList3 );
                    }
                    else{
                        MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[2]).addAll(mlg.IO_Voltage_V__c.split(','));
                    }
                }
                if(mlg.Core_Voltage_V__c != null 
                    && mlg.Core_Voltage_V__c != 'NA' 
                    && mlg.Core_Voltage_V__c != 'N/A'){
                    if(!MLGValuesMap.containsKey(cpqAttributeMetadata.Value__c.split(',')[3])){
                        List<String> tempList4 = new List<String>();
                        tempList4.addAll( mlg.Core_Voltage_V__c.split(','));
                        MLGValuesMap.put(cpqAttributeMetadata.Value__c.split(',')[3] ,tempList4  );
                    }
                    else{
                        MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[3]).addAll(mlg.Core_Voltage_V__c.split(','));
                    }
                }
           }
        }
        if(mlgRecords != null && MLGValuesMap.keyset().size() > 0){
            ColumnList.add('Status');
            StatusRow.put('Status','Status of Metadata');
            Map<String,String> tempMap = new Map<String,String>();
            tempMap = getStatus(cpqAttributeMetadata ) ; 
            if(tempMap != NULL){
                StatusRow.putAll(tempMap  );
            }
            for(String str: cpqAttributeMetadata.Value__c.split(',')){
                ColumnList.add(str);
                ButtonDisplay = StatusRow.get(str) == 'Not Updated'
                                    ? true
                                    : ButtonDisplay ;
            }
        }
        
        ShowMessage = StatusRow.keyset().size() > 0 ? false : true ; 
    }
    public void metadataLoad(){
        ButtonClicked = TRUE; 
        CPQ_Settings__c cpqAttributeMetadata = CPQ_Settings__c.getValues('Attribute Metadata Fields');
        String PTnumber ; 
        Set<string> MetalOptionsSet = new Set<String>();
        Set<string> CoreVoltagesSet = new Set<String>();
        Set<string> IOVoltagesSet   = new Set<String>();
        if(MLGValuesMap.containskey(cpqAttributeMetadata.Value__c.split(',')[1])) { MetalOptionsSet.addAll(MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[1])); }
        if(MLGValuesMap.containskey(cpqAttributeMetadata.Value__c.split(',')[2])) { IOVoltagesSet.addAll(MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[2])) ; } 
        if(MLGValuesMap.containskey(cpqAttributeMetadata.Value__c.split(',')[3])) { CoreVoltagesSet.addAll(MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[3])) ; }
        List<string> CoreVoltages = new List<string> ();
        List<String> IOVoltages   = new List<string> ();
        List<String> MetalOptions = new List<string> ();
        MetalOptions.addAll(MetalOptionsSet);
        IOVoltages.addAll(IOVoltagesSet);
        CoreVoltages.addAll(CoreVoltagesSet);
        PTnumber = MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[0])[0] ; 
        try{
            //calling meta data handler method:
            CPQMetadataMethodHandler.attributeUpdatePicklist(   PTnumber
                                                            , MetalOptions
                                                            , CoreVoltages
                                                            , IOVoltages );
            
        }
        catch(exception e){
            CPQConfigurationDataHandler.createErrorRecord(MLGPLUSID , e.getMessage() );
        }
    }
    
    public Map<String,String> getStatus(CPQ_Settings__c  cpqAttributeMetadata ) {
        system.debug('[debug: MLGValuesMap-->]'+MLGValuesMap);
        Map<String,String> finalStatus  = new Map<String,String>();
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        
        Schema.Describesobjectresult dsr = gdMap.get('Apttus_Config2__ProductAttributeValue__c').getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        system.debug('[debug]: fieldMap ***'+fieldMap );
        for(integer i=0 ; i < cpqAttributeMetadata.Value__c.split(',').size() ; i++  ){
            Set<String> xPicklistValues = new Set<String>();
            String StatusValue = 'Updated';
            system.debug('[debug: check API VALUE '+cpqAttributeMetadata.MetaData_API_name__c.split(',')[i]);
            Schema.DescribeFieldResult FieldResult = fieldMap.containskey(cpqAttributeMetadata.MetaData_API_name__c.split(',')[i]) 
                                                        ? fieldMap.get(cpqAttributeMetadata.MetaData_API_name__c.split(',')[i]).getDescribe()
                                                        : null;
            system.debug('[debug: check field result'+FieldResult );                        
            if(FieldResult  != NULL  ){
                List<Schema.PicklistEntry> PickValues = FieldResult.getPicklistValues();
                for(Schema.PicklistEntry f : PickValues){
                    xPicklistValues.add(f.getLabel()); 
                    system.debug('[Debug: xPTValue]'+ f.getLabel() );
                }
            }          
            if( MLGValuesMap.containskey(cpqAttributeMetadata.Value__c.split(',')[i])){        
                for(String metadatavalue : MLGValuesMap.get(cpqAttributeMetadata.Value__c.split(',')[i])){
                    String metadatavalueMod = metadatavalue.trim().replace('"','');
                    if(!xPicklistValues.contains(metadatavalueMod)){
                        StatusValue = 'Not Updated';
                    }
                }
            }else{
                StatusValue = 'Updated';
            }
            finalStatus.put(cpqAttributeMetadata.Value__c.split(',')[i] , StatusValue);
        }
        system.debug('[debug]:: finalStatus'+finalStatus);
        return finalStatus; 
    }

}