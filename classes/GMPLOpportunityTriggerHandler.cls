/*
    Author: Anirban Roy
    Description: This is the handler class for GMPL Opportunity Trigger.  
    History:
        ARoy        04232014    - code creation.
*/

public class GMPLOpportunityTriggerHandler {
    
    // Insert method for GMPL/BX009 Date
    public static void gmplBX009ProdToDateInsert(List<GMPL_Opportunity__c> gmplBX009s){
        Set<Id> gmplBX009Ids = new Set<Id>();
        Set<Id> opIds = new Set<Id>();
        Map<Id,Set<Id>> gmplOpIdMap = new Map<Id,Set<Id>>();

        for(GMPL_Opportunity__c gmplOpp : gmplBX009s){
            if(gmplOpp.Opportunity__c != null){
                gmplBX009Ids.add(gmplOpp.GMPL_BX009__c);
                opIds.add(gmplOpp.Opportunity__c);
                
                if(!gmplOpIdMap.isEmpty() && !gmplOpIdMap.containsKey(gmplOpp.Opportunity__c)){
                    gmplOpIdMap.get(gmplOpp.Opportunity__c).add(gmplOpp.GMPL_BX009__c);     
                }else{
                    gmplOpIdMap.put(gmplOpp.Opportunity__c, new Set<Id>{gmplOpp.GMPL_BX009__c});        
                }

            }
        }
        if(gmplBX009Ids.size()>0){
            getGMPLBX009(gmplBX009Ids, opIds, gmplOpIdMap);
        }
    }
    
    //Update method for GMPL/BX009 Date only when Opportunity is updated
    public static void gmplBX009ProdToDateUpdate(List<GMPL_Opportunity__c> gmplBX009s, Map<Id, GMPL_Opportunity__c> oldGMPLBX009s){
        Set<Id> gmplBX009Ids = new Set<Id>();
        Set<Id> opIds = new Set<Id>();
        Map<Id,Set<Id>> gmplOpIdMap = new Map<Id,Set<Id>>();
        
        for(GMPL_Opportunity__c gmplOpp : gmplBX009s){
            if(gmplOpp.Opportunity__c != null && gmplOpp.Opportunity__c != oldGMPLBX009s.get(gmplOpp.Id).Opportunity__c){
                gmplBX009Ids.add(gmplOpp.GMPL_BX009__c);
                opIds.add(gmplOpp.Opportunity__c);
                
                if(!gmplOpIdMap.isEmpty() && !gmplOpIdMap.containsKey(gmplOpp.Opportunity__c)){
                    gmplOpIdMap.get(gmplOpp.Opportunity__c).add(gmplOpp.GMPL_BX009__c);     
                }else{
                    gmplOpIdMap.put(gmplOpp.Opportunity__c, new Set<Id>{gmplOpp.GMPL_BX009__c});        
                }
            }
        }
        if(gmplBX009Ids.size()>0){
            getGMPLBX009(gmplBX009Ids, opIds, gmplOpIdMap);
        }
    }
    
    
    // Method to copy value from GMPL Opportunity Date to GMPL Date
    private static void getGMPLBX009(Set<Id> gmplBX009Ids, Set<Id> opIds, Map<Id,Set<Id>> gmplOpIdMap){
        
        // Retrieving Opportunity First Product To Date and map against GMPL Id
        Map<Id,Date> gmplIdPrdDateMap = new Map<Id,Date>();
        for(Opportunity op : [select    Id
                                        , X1st_Product_TO_Date__c
                              from      Opportunity
                              where     Id in :opIds 
                             ]){
            
            if(!gmplOpIdMap.isEmpty() && gmplOpIdMap.containsKey(op.Id)){
                for(Id gmplId : gmplOpIdMap.get(op.Id)){
                    gmplIdPrdDateMap.put(gmplId,op.X1st_Product_TO_Date__c);
                }
            }                   
        }
        
        // Populate the First Product Test Chip Tapeout Commit and Expected from the Opportunity First Product To Date
        List<GMPL_BX009__c> gmplBX009List = new List<GMPL_BX009__c>();
        Boolean isUpdateNeeded = false;
        for(GMPL_BX009__c gmplBX009 : [ select  Id
                                                , First_Product_Test_Chip_Tape_out_Commi__c
                                                , Fst_Product_Test_Chip_Tape_out_Expected__c
                                        from    GMPL_BX009__c
                                        where   Id in :gmplBX009Ids                               
                                      ]){
            if(!gmplIdPrdDateMap.isEmpty() && gmplIdPrdDateMap.containsKey(gmplBX009.Id)){
                isUpdateNeeded = false;
                if(gmplIdPrdDateMap.get(gmplBX009.Id) != null
                    && (gmplIdPrdDateMap.get(gmplBX009.Id) < gmplBX009.First_Product_Test_Chip_Tape_out_Commi__c 
                        || gmplBX009.First_Product_Test_Chip_Tape_out_Commi__c == null)){
                    gmplBX009.First_Product_Test_Chip_Tape_out_Commi__c = gmplIdPrdDateMap.get(gmplBX009.Id);
                    isUpdateNeeded = true;
                }
                if(gmplIdPrdDateMap.get(gmplBX009.Id) != null
                    && (gmplIdPrdDateMap.get(gmplBX009.Id) < gmplBX009.Fst_Product_Test_Chip_Tape_out_Expected__c
                        || gmplBX009.Fst_Product_Test_Chip_Tape_out_Expected__c == null)){
                    gmplBX009.Fst_Product_Test_Chip_Tape_out_Expected__c = gmplIdPrdDateMap.get(gmplBX009.Id);
                    isUpdateNeeded = true;
                }
                if(isUpdateNeeded){
                    gmplBX009List.add(gmplBX009);
                }
            }       
        }       

        if(gmplBX009List.size()>0){
            update gmplBX009List;   
        }
    }
}