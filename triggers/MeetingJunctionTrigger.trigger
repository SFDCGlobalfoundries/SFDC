/*
    Author: Anirban Roy        
    Description: Trigger on Meeting Junction object.
    History: 
      ARoy  03202014    - Code Creation
*/

trigger MeetingJunctionTrigger on Meeting_Junction__c (before insert, before update) {
            
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){     
            
        Set<Id> gmplInsertIds = new Set<Id>();
        
        for(Meeting_Junction__c mt : trigger.new){
            if(mt.GMPL_BX009__c != null){
                gmplInsertIds.add(mt.GMPL_BX009__c);
            }
        }        
        
        // Auto-populating the dates from GMPL to Meeting Junction
        //**********************************************************************************//
        if(gmplInsertIds.size()>0){
    		Map<Id, GMPL_BX009__c> gmplBx009Map 
    				= new Map<Id, GMPL_BX009__c>([select	Id
    											  			, G0_Target_Date__c
    											  			, G1_Target_Date__c
    											  			, G3_Target_Date__c
    											  			, G6_Target_Date__c
    											  			//, PCR_Target_Date__c
    											  			, G0_Commit_Date__c
    											  			, G1_Commit_Date__c
    											  			, G3_Commit_Date__c
    											  			, G6_Commit_Date__c
    											  			//, PCR_Commit_Date__c
    											  			, G0_Actual_Date__c
    											  			, G1_Actual_Date__c
    											  			, G3_Actual_Date__c
    											  			, G6_Actual_Date__c
    											  			//, PCR_Actual_Date__c
    											  			, G0_Plan_Date__c
    											  			, G1_Plan_Date__c
    											  			, G3_Plan_Date__c
    											  			, G6_Plan_Date__c
    											  			//, PCR_Plan_Date__c
    											  			, G0_Trend_Date__c
    											  			, G1_Trend_Date__c
    											  			, G3_Trend_Date__c
    											  			, G6_Trend_Date__c
    											  			//, PCR_Trend_Date__c
    											   from		GMPL_BX009__c
    											   where	Id in :gmplInsertIds
    											  ]);
    											  
        	if(gmplBx009Map != null && !gmplBx009Map.isEmpty()){
        		for(Meeting_Junction__c mt : trigger.new){
        			if(mt.GMPL_BX009__c != null && gmplBx009Map.containsKey(mt.GMPL_BX009__c)){
        				
        				if(mt.G0_Target_Date__c == null){
        					mt.G0_Target_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G0_Target_Date__c;
        				}
        				if(mt.G1_Target_Date__c == null){
        					mt.G1_Target_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G1_Target_Date__c;
        				}
        				if(mt.G3_Target_Date__c == null){
        					mt.G3_Target_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G3_Target_Date__c;
        				}
        				if(mt.G6_Target_Date__c == null){
        					mt.G6_Target_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G6_Target_Date__c;
        				}
        				/*if(mt.PCR_Target_Date__c == null){
        					mt.PCR_Target_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).PCR_Target_Date__c;
        				}*/
        				
        				
        				if(mt.G0_Commit_Date__c == null){
        					mt.G0_Commit_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G0_Commit_Date__c;
        				}
        				if(mt.G1_Commit_Date__c == null){
        					mt.G1_Commit_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G1_Commit_Date__c;
        				}
        				if(mt.G3_Commit_Date__c == null){
        					mt.G3_Commit_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G3_Commit_Date__c;
        				}
        				if(mt.G6_Commit_Date__c == null){
        					mt.G6_Commit_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G6_Commit_Date__c;
        				}
        				/*if(mt.PCR_Commit_Date__c == null){
        					mt.PCR_Commit_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).PCR_Commit_Date__c;
        				}*/
        				
        				
        				if(mt.G0_Actual_Date__c == null){
        					mt.G0_Actual_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G0_Actual_Date__c;
        				}
        				if(mt.G1_Actual_Date__c == null){
        					mt.G1_Actual_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G1_Actual_Date__c;
        				}
        				if(mt.G3_Actual_Date__c == null){
        					mt.G3_Actual_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G3_Actual_Date__c;
        				}
        				if(mt.G6_Actual_Date__c == null){
        					mt.G6_Actual_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G6_Actual_Date__c;
        				}
        				/*if(mt.PCR_Actual_Date__c == null){
        					mt.PCR_Actual_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).PCR_Actual_Date__c;
        				}*/
        				
        				if(mt.G0_Plan_Date__c == null){
        					mt.G0_Plan_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G0_Plan_Date__c;
        				}
        				if(mt.G1_Plan_Date__c == null){
        					mt.G1_Plan_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G1_Plan_Date__c;
        				}
        				if(mt.G3_Plan_Date__c == null){
        					mt.G3_Plan_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G3_Plan_Date__c;
        				}
        				if(mt.G6_Plan_Date__c == null){
        					mt.G6_Plan_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G6_Plan_Date__c;
        				}
        				/*if(mt.PCR_Plan_Date__c == null){
        					mt.PCR_Plan_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).PCR_Plan_Date__c;
        				}*/
        				
        				if(mt.G0_Trend_Date__c == null){
        					mt.G0_Trend_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G0_Trend_Date__c;
        				}
        				if(mt.G1_Trend_Date__c == null){
        					mt.G1_Trend_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G1_Trend_Date__c;
        				}
        				if(mt.G3_Trend_Date__c == null){
        					mt.G3_Trend_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G3_Trend_Date__c;
        				}
        				if(mt.G6_Trend_Date__c == null){
        					mt.G6_Trend_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).G6_Trend_Date__c;
        				}
        				/*if(mt.PCR_Trend_Date__c == null){
        					mt.PCR_Trend_Date__c = gmplBx009Map.get(mt.GMPL_BX009__c).PCR_Trend_Date__c;
        				}*/
        			}
        		}
        	} 
    	}    	
    	//**********************************************************************************//            
    }    
    
}