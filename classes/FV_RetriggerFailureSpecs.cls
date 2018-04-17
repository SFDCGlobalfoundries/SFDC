/**
* @ Author :- Navneet Rajput
* @ Company :- CTS 
* @ Description :- Class handles PDK spec failure provisioning and de-provisioning  
                   
* @ Date :- 12/9/2014
* @ Change History :- 
**/

global class FV_RetriggerFailureSpecs {

	webservice static String provFailureSpecs(String dpID){
		try{
			//String DELIMETER ='&&';
			 Document_Provisioning__c dp = [SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,
        										  		PDK_Provisoin_To_Updated_Specs__c,isProvUpdate__c,PDK_Failure_DeProSpecs__c,
        										  		PDK_Failure_Specs__c,isDeProUpdate__c,Sub_PDK__c 
        										FROM 	Document_Provisioning__c WHERE ID =: dpID 
        										AND 	Status__c IN ('Provisioned','De-Provisioned','Provisioning In Progress','De-Provisioning In Progress') limit 1];
        										
        	 if (dp<>NULL && !String.isBlank(dp.PDK_Failure_Specs__c)){
        	 	if (!String.isBlank(dp.PDK_Failure_Specs__c) && (dp.Status__c=='Provisioned' || dp.Status__c=='Provisioning In Progress')){
        	 		// Call provision update
        	 		dp.isProvUpdate__c = true;
        	 		dp.isDeProUpdate__c = false;
        	 		String fSpec='';
        	 		if(dp.PDK_Failure_Specs__c<>NULL && !String.isBlank(dp.PDK_Failure_Specs__c)){
        	 			fSpec= FV_RetriggerFailureSpecs.getFinalSpecs(dp.PDK_Failure_Specs__c);
        	 			dp.PDK_Provisoin_To_Updated_Specs__c = fSpec;
        	 		} 
        	 		
        	 		update dp;
        	 	}
        	 	if (!String.isBlank(dp.PDK_Failure_DeProSpecs__c) || dp.Status__c == 'De-Provisioned' || dp.Status__c=='De-Provisioning In Progress'){
        	 		// Call deprovision update
        	 		dp.isProvUpdate__c = false;
        	 		dp.isDeProUpdate__c = true;
        	 		String fSpec='';
        	 		
        	 		if(dp.PDK_Failure_DeProSpecs__c<>NULL && !String.isBlank(dp.PDK_Failure_DeProSpecs__c)){
        	 			fSpec = FV_RetriggerFailureSpecs.getFinalSpecs(dp.PDK_Failure_DeProSpecs__c);
	        	 		dp.Pdk_Specs_DeProvisioned__c = fSpec;
        	 		}
        	 		
        	 		//prepare list of sub pdks in which account is present
        	 		List<Document_Provisioning__c> listOfDP = new List<Document_Provisioning__c>();
					Boolean isProvisioned = false;
					String bundleOtIds = '';
					
					Map <Id,Set<String>> accPdkOtIdMap = new Map<Id,Set<String>>();
			    	/* List<Document_Provisioning__c> listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c
			    	 													FROM Document_Provisioning__c
			    	 													WHERE Status__c = 'Provisioned'
			    	 													AND Sub_PDK__c != NULL
			    	 													AND Sub_PDK__c!= :dp.Sub_PDK__c];
			    	system.debug('listOfDpRecords >>>>>>>>'+listOfDpRecords);
			    	if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){*/
			    	
			    	for(Document_Provisioning__c DP1 : [SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c
		    	 													FROM Document_Provisioning__c
		    	 													WHERE Status__c = 'Provisioned'
		    	 													AND Sub_PDK__c != NULL
		    	 													AND Sub_PDK__c!= :dp.Sub_PDK__c]){
		    	 		
		    	 		if(DP1<>NULL){												
				    		if (!accPdkOtIdMap.containsKey(DP1.AccountID__c)){
			                  accPdkOtIdMap.put(DP1.AccountID__c, new Set<String>());
			                } //else {
		                	system.debug('DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c >>>>>>'+DP1.Sub_PDK__r.Sub_PDK_OpenText_Id__c);
		                	if(DP1.Sub_PDK__r.Sub_PDK_OpenText_Id__c<>NULL)
		                   		accPdkOtIdMap.get(DP1.AccountID__c).add(String.valueOf(DP1.Sub_PDK__r.Sub_PDK_OpenText_Id__c));
			                //}
		    	 		}
			    	}
			    	//}
        	 		
        	 		if (accPdkOtIdMap<>NULL && accPdkOtIdMap.containsKey(dp.AccountID__c)){
						for(String str : accPdkOtIdMap.get(dp.AccountID__c)){
							if(str<>NULL && str!=''){
								if (bundleOtIds==''){
									bundleOtIds = str;
								} else {
									bundleOtIds = bundleOtIds+';'+str;
								}
							}	
						}
					}
					if(!String.isBlank(bundleOtIds)){
						dp.Bundle_OT_ID__c = bundleOtIds;	
					}
					
        	 		update dp;
        	 	}
        	 }									
			return 'Request Submited successfully. Please verify in FV after 10 minutes.';
		} catch (Exception Erro){
			return 'Error :: '+Erro.getMessage();
		}
	}
	// Returm final set of string with combition of Spec : Association
	private static String getFinalSpecs(String fSpec){
		List<String> tempPdkSec = fSpec.Split(';');
 		String finalPdkSpecs ='';
 		for (String spec : tempPdkSec){
 			if (finalPdkSpecs==''){
 				if (!String.isBlank(spec.split('&&')[0])){
 					finalPdkSpecs = spec.split('&&')[0];
 				}
 			} else {
 				if (!String.isBlank(spec.split('&&')[0])){
 					finalPdkSpecs = finalPdkSpecs+';'+spec.split('&&')[0]; 
 				}
 			}
 		}
 		return finalPdkSpecs;
	}
}