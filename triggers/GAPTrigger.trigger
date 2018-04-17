/********************************************************************************************************
    Trigger Name:  GAPTrigger
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This trigger update the GAP status in the BX041 level. 
                   #GAP_Closed__c = true -->  NO GAP
                   #GAP_Closed__c = false --> GAP
    Created by:    PS 
    Event:         After Insert and After update
    Change History:
      Author: 
      Modified Date: 
      Reason:
 
*********************************************************************************************************/



trigger GAPTrigger on Gap_Analysis_Form__c (after insert, after update) {
	if(!IntegrationUserUtil.isSkipTrigger()){
	    map<id,List<Gap_Analysis_Form__c>> mapbx041 = new map<id,List<Gap_Analysis_Form__c >>();
	    List<BX_041__c> finalList = new List<BX_041__c>(); //list to update BX041 records
	    set<id> BX041IDS = new set<id>();
	    
	    //***Creating map between BX041 and Gap analysis records under this***
	    for(Gap_Analysis_Form__c  ga : trigger.new){
	    	/**if(trigger.isinsert 
	    	|| trigger.isupdate && (ga.APTS_Status__c != trigger.oldmap.get(ga.id).APTS_Status__c // when status is changed 
	    							|| (ga.APTS_Status__c == 'Closed' && (ga.APTS_Comments__c != trigger.oldmap.get(ga.id).APTS_Comments__c || ga.APTS_Resolution__c != trigger.oldmap.get(ga.id).APTS_Resolution__c ))
	    						    ))**/
	        BX041IDS.add(ga.BX_041__c);    
	    }
	    MAP<ID,BX_041__c> BX041Map = new MAP<ID,BX_041__c>(
	                                [SELECT id,
	                                        name,
	                                        GAP_Closed__c 
	                                 FROM   BX_041__c
	                                 WHERE  ID 
	                                 IN     :BX041IDS]);
	    
	    for(Gap_Analysis_Form__c  ga : [SELECT    id,
	                                              BX_041__c,
	                                              APTS_Comments__c,
	                                              Gap_Name__c,
	                                              Question_Metadata__c,
	                                              Question_Metadata__r.Mandatory__c,
	                                              APTS_Resolution__c,
	                                              APTS_Status__c
	                                   FROM       Gap_Analysis_Form__c
	                                   WHERE      BX_041__c 
	                                   IN         :BX041IDS]){
	        if(mapbx041.get(ga.BX_041__c) == null){
	            mapbx041.put(ga.BX_041__c,new List<Gap_Analysis_Form__c >{ga});    
	        }    
	        else{
	            mapbx041.get(ga.BX_041__c).add(ga);    
	        }
	    }
	    
	    //*******checking for validation********
	    for(id bx :mapbx041.keyset() ){
	        integer flagcount = 0;//Setting the flag to 0 first
	        for(Gap_Analysis_Form__c  ga :mapbx041.get(bx) ){
	        		        	
	            if(ga.APTS_Status__c == 'No Gap/NA' || ga.APTS_Status__c == 'Closed' || ga.APTS_Status__c == 'No' || ga.Question_Metadata__r.Mandatory__c == true ){
	                if(ga.APTS_Comments__c == null && ga.APTS_Resolution__c== null && ga.APTS_Status__c  == 'Closed' && ga.Question_Metadata__r.Mandatory__c == false){
	                    flagcount++; break;                     
	                }
	                if(ga.Question_Metadata__r.Mandatory__c == true && ga.APTS_Status__c == 'None'){
	                	flagcount++; break; 
	                } 
	            }
	            else{
	                flagcount++ ;  break;       
	            }            
	        }
	        BX_041__c tempbx = BX041Map.get(bx);
	        if(flagcount == 0 ){ // flagcount == 0 signifies NO GAP
	            
	            if(tempbx.GAP_Closed__c == false){
	                tempbx.GAP_Closed__c = true; 
	                finalList.add(tempbx);
	            }
	                   
	        }
	        else{
	            if(tempbx.GAP_Closed__c == true){
	                tempbx.GAP_Closed__c = false;
	                finalList.add(tempbx);
	            }
	        }
	        
	        
	    }
	    system.debug(logginglevel.error, finalList);
	    if(finalList.size()>0){update finalList;}//updating BX041 list
	        
	}
}