/**
*   Author: Prosenjit Saha
*   Description: This is Handler class for CPQAttributeRuleTrigger
*   History:
*       PSaha          05052015     - code creation.
*     
**/
public class CPQAttributeRuleTriggerHandler {
    public void upsertHandler(List<Attribute_Rule__c> triggeredRec){
        Map<String,String> CPQMLGProdExtMap = new Map<String,String>();
        List<MLG_Record__c> MLGRecList = new List<MLG_Record__c>();
        for(Attribute_Rule__c ARul : [select    id
                                                , name
                                                , CPQ_MLGPLUS__r.Parent_Product_External_ID__c
                                                , CPQ_MLGPLUS__r.Process_Technology__c
                                                , CPQ_MLGPLUS__c
                                                , CPQ_MLGPLUS__r.Bundle_Product__r.Productcode
                                      FROM      Attribute_Rule__c
                                      WHERE     id
                                      IN        :triggeredRec]){
            CPQMLGProdExtMap.put(ARul.id , ARul.CPQ_MLGPLUS__r.Bundle_Product__r.Productcode);
        }
        for(Attribute_Rule__c ARule: triggeredRec){
            if(ARule.HasChildRule__c == false){
                MLG_Record__c mlgrec = new MLG_Record__c();
                    mlgrec.Additional_Mask_s__c         = ARule.Mask_Layers__c ; 
                    mlgrec.Feature_Description__c       = ARule.name ; 
                    mlgrec.Feature_Group__c             = 'Attribute Rule'; 
                    mlgrec.FEOL_BEOL__c                 = 'BEOL' ; 
                    mlgrec.CPQ_MLGPLUS__c               = ARule.CPQ_MLGPLUS__c;
                    mlgrec.Version__c                   = null; 
                    mlgrec.Model_Name__c                = ARule.Attribute_Field_API_Name__c ; 
                    mlgrec.Device_List__c               = ARule.Attribute_Field_Value__c; 
                    mlgrec.MLG_External_ID__c           = CPQMLGProdExtMap.containsKey(ARule.id) && ARule.Parent_Rule__c == null ? CPQMLGProdExtMap.get(ARule.id)+'_'+ARule.Attribute_Field_API_Name__c: CPQMLGProdExtMap.get(ARule.id)+'_'+ARule.Attribute_Field_API_Name__c+ ARule.Parent_Rule__c; //added CPQ MLGPLUS Id in order to make the external field unique : change done for the Case# 49711 automation
                    mlgrec.Parent_Attribute_Rule_ID__c  = ARule.Parent_Rule__c ;
                MLGRecList.add(mlgrec);
            }
        }
        if(MLGRecList.size() > 0){
            upsert MLGRecList MLG_External_ID__c; 
        }
    }
    
    public void deleteHandler(List<Attribute_Rule__c> triggeredRec){
        List<String> ExtIdList = new List<String>();
        Map<String,String> CPQMLGProdExtMap = new Map<String,String>();
        for(Attribute_Rule__c ARul : [select    id
                                                , name
                                                , CPQ_MLGPLUS__r.Parent_Product_External_ID__c
                                                , CPQ_MLGPLUS__r.Process_Technology__c
                                                , CPQ_MLGPLUS__c
                                                , CPQ_MLGPLUS__r.Bundle_Product__r.Productcode
                                      FROM      Attribute_Rule__c
                                      WHERE     id
                                      IN        :triggeredRec
                                      AND       CPQ_MLGPLUS__r.Bundle_Product__c != null]){
            CPQMLGProdExtMap.put(ARul.id , ARul.CPQ_MLGPLUS__r.Bundle_Product__r.Productcode);
        }
        for(Attribute_Rule__c ARule :  triggeredRec){
             if(CPQMLGProdExtMap.containsKey(ARule.id)){
                 ExtIdList.add(CPQMLGProdExtMap.get(ARule.id)+'_'+ARule.Attribute_Field_API_Name__c ) ;
             }
             if(ARule.HasChildRule__c == TRUE){
                 ExtIdList.add(ARule.id);
             }
        }
        List<MLG_Record__c> DeleteMLGRec = new List<MLG_Record__c>();
        DeleteMLGRec = [select id,MLG_External_ID__c,Parent_Attribute_Rule_ID__c from MLG_Record__c where MLG_External_ID__c IN :ExtIdList OR Parent_Attribute_Rule_ID__c IN :ExtIdList ];
        if(DeleteMLGRec.size()>0){
            delete DeleteMLGRec;
        }
    }
    
}