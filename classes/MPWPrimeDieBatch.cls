global class MPWPrimeDieBatch implements Database.Batchable<sObject>{
    public String strQueryCustom;
    
    public MPWPrimeDieBatch(String strQueryTemp) {
        strQueryCustom = strQueryTemp;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String strQueryDefault = 'SELECT Id, Name, Prime_Die_Name__c, MPW_Train__c, Design_Package_Accepted_Date__c, ';
        strQueryDefault += ' Final_GDS_PTRF_Submitted_Date__c, MPW_Form__r.Customer_Company_Name__c, ';
        strQueryDefault += ' Initial_Design_Package_Accepted_Date__c, Initial_GDS_PTRF_Submitted_Date__c, ';
        strQueryDefault += ' Final_PTSR_Submitted_Date__c, MPW_Form_Status__c, Customer_Tapeout_Date__c, LastModifiedDate FROM MPW_Prime_Die__c ';
        strQueryDefault += ' WHERE Prime_Die_Name__c != NULL AND MPW_Form__r.Customer_Company_Name__c != NULL AND ';
        strQueryDefault += ' MPW_Form_Status__c LIKE \'%Accepted%\' AND MPW_Train__c LIKE \'MPW%\' '; 
        strQueryDefault += ' AND Customer_Tapeout_Date__c >= LAST_N_DAYS:30 AND Customer_Tapeout_Date__c <= NEXT_N_DAYS:30 ';
        strQueryDefault += ' ORDER BY CreatedDate DESC';
        String query = strQueryCustom != null ? strQueryCustom : strQueryDefault;
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, List<MPW_Prime_Die__c> scope){
        List<MPW_Prime_Die__c> lstPrimeDieToBeUpdate = new List<MPW_Prime_Die__c>();
        Set<String> setPrimeDieName = new Set<String>();
        Set<String> setPrimeDieTrain = new Set<String>();
        Map<String, Chip_Detail__c> mapFinalChipDetail = new Map<String, Chip_Detail__c>();
        Map<String, Chip_Detail__c> mapInitialChipDetail = new Map<String, Chip_Detail__c>();
        Map<String, PTRF__History> mapFinalPTRFHistory = new Map<String, PTRF__History>();
        Map<String, PTRF__History> mapInitialPTRFHistory = new Map<String, PTRF__History>();
        Map<String, Chip_Detail__c> mapPTRF = new Map<String, Chip_Detail__c>();
        Map<String, Wavier_Collaborator__c> mapWC = new Map<String, Wavier_Collaborator__c>();
        
        try {
            for(MPW_Prime_Die__c oPD : scope) {
                setPrimeDieName.add(oPD.Prime_Die_Name__c);
                setPrimeDieTrain.add(oPD.MPW_Train__c);
            }
            
            for(Chip_Detail__c oCD : [SELECT Id, Name, PTRF__c, PTRF__r.MaskSetTitle__c, PTRF__r.MaskSetTitle__r.Name, PTRF__r.Customer__c, 
                                        PTRF__r.Status__c, PTRF__r.Prime_Tapeout__c, PTRF__r.DRC_DRW_Status__c, PTRF__r.CreatedDate
                                        FROM Chip_Detail__c
                                        WHERE Name IN : setPrimeDieName 
                                        AND PTRF__c != NULL AND PTRF__r.MaskSetTitle__c != NULL 
                                        AND PTRF__r.MaskSetTitle__r.Name IN : setPrimeDieTrain AND PTRF__r.Customer__c != NULL
                                        AND PTRF__r.Prime_Tapeout__c = TRUE AND PTRF__r.DRC_DRW_Status__c = 'Completed'
                                        AND PTRF__r.Status__c != 'Cancel' AND PTRF__r.Status__c != 'Deleted' 
                                        ORDER BY CreatedDate DESC ]) {
                mapPTRF.put(oCD.PTRF__c, oCD);
                
                if(Test.isRunningTest()){
                    String strKey = oCD.PTRF__r.MaskSetTitle__r.Name.toUpperCase() + '_' + oCD.Name.toUpperCase() + '_' + oCD.PTRF__r.Customer__c;
                    PTRF__History oPTRFHistory = new PTRF__History();
                    mapFinalPTRFHistory.put(strKey, oPTRFHistory);
                    mapFinalChipDetail.put(strKey, oCD);
                    mapInitialPTRFHistory.put(strKey, oPTRFHistory);
                    mapInitialChipDetail.put(strKey, oCD);
                } 
            }
            
            for(PTRF__History oPTRFHistory : [SELECT Id, ParentId, Field, OldValue, NewValue, CreatedDate 
                                                FROM PTRF__History 
                                                WHERE ParentId IN : mapPTRF.keySet() AND Field = 'DRC_DRW_Status__c' ORDER BY CreatedDate DESC]) {
                String strKey = mapPTRF.get(oPTRFHistory.ParentId).PTRF__r.MaskSetTitle__r.Name.toUpperCase() + '_' + mapPTRF.get(oPTRFHistory.ParentId).Name.toUpperCase() + '_' + mapPTRF.get(oPTRFHistory.ParentId).PTRF__r.Customer__c;
                if(!mapFinalPTRFHistory.containsKey(strKey) && oPTRFHistory.OldValue != 'Completed' && oPTRFHistory.NewValue == 'Completed') {
                    mapFinalPTRFHistory.put(strKey, oPTRFHistory);
                    mapFinalChipDetail.put(strKey, mapPTRF.get(oPTRFHistory.ParentId));
                }
            }
            
            for(PTRF__History oPTRFHistory : [SELECT Id, ParentId, Field, OldValue, NewValue, CreatedDate 
                                                FROM PTRF__History 
                                                WHERE ParentId IN : mapPTRF.keySet() AND Field = 'DRC_DRW_Status__c' ORDER BY CreatedDate ASC]) {
                String strKey = mapPTRF.get(oPTRFHistory.ParentId).PTRF__r.MaskSetTitle__r.Name.toUpperCase() + '_' + mapPTRF.get(oPTRFHistory.ParentId).Name.toUpperCase() + '_' + mapPTRF.get(oPTRFHistory.ParentId).PTRF__r.Customer__c;
                if(!mapInitialPTRFHistory.containsKey(strKey) && oPTRFHistory.OldValue != 'Completed' && oPTRFHistory.NewValue == 'Completed') {
                    mapInitialPTRFHistory.put(strKey, oPTRFHistory);
                    mapInitialChipDetail.put(strKey, mapPTRF.get(oPTRFHistory.ParentId));
                }
            }
            
            for(Wavier_Collaborator__c oWC : [SELECT Id, Name, Mask_Set_Title__c, CRM_Device__c, CRM_Device__r.Name, 
                                            Submitted_Date__c, PTSR_Service_Type__c, Account__c
                                            FROM Wavier_Collaborator__c 
                                            WHERE PTSR_Service_Type__c = 'DRC Service Request' 
                                            AND Mask_Set_Title__c != NULL AND Mask_Set_Title__c IN : setPrimeDieTrain
                                            AND CRM_Device__c != NULL AND Submitted_Date__c != NULL
                                            ORDER BY Submitted_Date__c DESC]) {
                if(!mapWC.containsKey(oWC.CRM_Device__r.Name)) {
                    String strKey = oWC.CRM_Device__r.Name.toUpperCase() + '_' + oWC.Account__c;
                    mapWC.put(strKey, oWC);
                }
            }
            
            for(MPW_Prime_Die__c oPD : scope) {
                String strKey = oPD.MPW_Train__c.toUpperCase() + '_' + oPD.Prime_Die_Name__c.toUpperCase() + '_' + oPD.MPW_Form__r.Customer_Company_Name__c;

                oPD.Design_Package_Accepted_Date__c = mapFinalPTRFHistory.containsKey(strKey) ? mapFinalPTRFHistory.get(strKey).CreatedDate : null;
                
                oPD.Final_GDS_PTRF_Submitted_Date__c = mapFinalChipDetail.containsKey(strKey) ? mapFinalChipDetail.get(strKey).PTRF__r.CreatedDate : null;
                
                oPD.Initial_Design_Package_Accepted_Date__c = mapInitialPTRFHistory.containsKey(strKey) ? mapInitialPTRFHistory.get(strKey).CreatedDate : null;
                
                oPD.Initial_GDS_PTRF_Submitted_Date__c = mapInitialChipDetail.containsKey(strKey) ? mapInitialChipDetail.get(strKey).PTRF__r.CreatedDate : null;
                
                oPD.Final_PTSR_Submitted_Date__c = mapWC.containsKey(strKey) ? mapWC.get(strKey).Submitted_Date__c : null;
                
                lstPrimeDieToBeUpdate.add(oPD);
            }
            
            if(lstPrimeDieToBeUpdate.size() > 0) {
                update lstPrimeDieToBeUpdate;
            }
        }
        Catch(Exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, 'MPWPrimeDieBatch', 'execute()', '', 'MPW Prime Die Batch');
        }
    }
   
    global void finish(Database.BatchableContext BC){
        
    }
}