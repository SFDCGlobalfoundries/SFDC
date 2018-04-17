/*
Type Name: MRSHandlerUtility_For_LogicalOperation
Author: Cognizant 
Created Date: 16-oCTOBER-2014
Author: Saurav Mukherjee
*/

public class MRSHandlerUtility_For_LogicalOperation {

    /**
        @Method:updateLogicalOperation
        @param: List<Id>
        @return: void
        @Description : This method will update the Logical Operation if PTRF is cancelled.
    **/
    
    public static void updateLogicalOperation(List<Id> ptrfIdList) {
        
        List<Mask_Layer__c> maskLayerlst = [SELECT Name,Mask_Layer_Number__c,Mask_Layer_Rev__c,ROM_Code__c,PTRF_Tech_Geo_Value__c,PTRF__r.MaskSetTitle__c 
                                    FROM Mask_Layer__c
                                    WHERE LogicalOperationType__c ='TECN'
                                    AND Tapeout__c = true 
                                    AND PTRF__c IN :ptrfIdList];
        
        Set<String> uniqueKeySt = new Set<String>();
        
        for(Mask_Layer__c layerObj : maskLayerlst){
            String uniqueKey;
             if(layerObj.ROM_Code__c != null){
                 uniqueKey = layerObj.PTRF__r.MaskSetTitle__c+layerObj.Mask_Layer_Number__c+layerObj.Mask_Layer_Rev__c+layerObj.ROM_Code__c+layerObj.PTRF_Tech_Geo_Value__c;
                }else{
                 uniqueKey = layerObj.PTRF__r.MaskSetTitle__c+layerObj.Mask_Layer_Number__c+layerObj.Mask_Layer_Rev__c+layerObj.PTRF_Tech_Geo_Value__c;
                }
            uniqueKeySt.add(uniqueKey);
        }
        
        List<MRS_Layer_Association__c> LAList = [SELECT Id,Name FROM MRS_Layer_Association__c WHERE Layer_Unique_Identifier__c IN:uniqueKeySt];
        
        Map<String,List<String>> LAMap = new Map<String,List<String>>();
        Map<String,String> MLMap = new Map<String,String>();
        Map<String,String> TempMap = new Map<String,String>();
        Map<String,String> FinalMap = new Map<String,String>();
        List<AggregateResult> aggR = new List<AggregateResult>();
        List<String> PTRFIds = new List<String>();
        
        aggR = [select Layer__c,Layer__r.Layer_Name__c,PTRF__c from MRS_Layer_Chip_Association__c where Layer__C in:LAList AND PTRF__r.Status__c = 'Perform Tapeout Options' group by Layer__c,Layer__r.Layer_Name__c,PTRF__c];
        
        for(AggregateResult obj : aggR){
            List<String> tempStr = new List<String>();
            if(LAMap.containsKey(String.valueOf(obj.get('Layer__c')))){
                tempStr = LAMap.get(String.valueOf(obj.get('Layer__c')));
                tempStr.add(String.valueOf(obj.get('Layer_Name__c')+'|'+obj.get('PTRF__c')));
                LAMap.put(String.valueOf(obj.get('Layer__c')),tempStr);
            }
            else {
                tempStr.add(String.valueOf(obj.get('Layer_Name__c')+'|'+obj.get('PTRF__c')));
                LAMap.put(String.valueOf(obj.get('Layer__c')),tempStr);
            }
            PTRFIds.add(String.valueOf(obj.get('PTRF__c')));
        }
        
        List<Mask_Layer__c> MLList = new List<Mask_Layer__c>();
        
        MLList = [SELECT Name, PTRF__c, LogicalOperation__c FROM Mask_Layer__c WHERE LogicalOperationType__c = 'TECN' AND PTRF__c IN:PTRFIds];
        
        for(Mask_Layer__c obj : MLList){
            if(String.valueOf(obj.LogicalOperation__c) != null){
                MLMap.put(String.valueOf(obj.Name+'|'+obj.PTRF__c),String.valueOf(obj.LogicalOperation__c));
            }
            
        }
        
        for(String obj : LAMap.keySet()){
            String str='';
            for(String objstr : LAMap.get(obj)){
                if(MLMap.get(objstr) != null){
                    str+=MLMap.get(objstr)+';';
                }
            }
            str=str.removeEnd(';');
            TempMap.put(obj,str);
        }
        
        for(String objId : TempMap.keySet()){
            
            List<String> strList = TempMap.get(objId).split(';');
            String FinalString = '';
            Set<String> setStr = new Set<String>();
            setStr.addAll(strList);    
            for(String objStr : setStr){
                FinalString+=objStr+';';
            }
            FinalString = FinalString.removeEnd(';');
            if(FinalString != null){
                FinalMap.put(objId,FinalString);
            }
        }
        
        List<MRS_Layer_Association__c> listToBeUpdated = new List<MRS_Layer_Association__c>();
        
        for(MRS_Layer_Association__c obj : LAList){
            if(!FinalMap.containsKey(String.valueOf(obj.Id))){
                FinalMap.put(String.valueOf(obj.Id),'');
            }
        }
        
        for(String str : FinalMap.keySet()){
            MRS_Layer_Association__c tempObj = new MRS_Layer_Association__c(Id=str);
            tempObj.LogicalOperation__c = FinalMap.get(str);
            if(FinalMap.get(str) != ''){
                tempObj.LogicalOperationType__c = 'TECN';
            }
            else{
                tempObj.LogicalOperationType__c = '';
            }
            
            listToBeUpdated.add(tempObj);
        }
        
        try {
            update listToBeUpdated;
        }
        catch(Exception exp){
        }
    }
}