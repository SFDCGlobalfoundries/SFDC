/*
/*
Project      : FoundryView
Name         : FV_DPrecordUpdate
Author       : GF- Prajnith Karra
Created Date : 21/1/2015
Reason       : This class updated the Document Provisionaing records based on PDK bundle. 
               This class is usefull to run in developer console when ever there is an data patch
               // FV_DPrecordUpdate.updateDPrecord('ur15digitID'); 
*/
public class FV_DPrecordUpdate
{

    
    
    public static void updateDPrecord(string subPdkId )
    {
               
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Set<Id>> wlSpecAccMap = new Map<Id,Set<Id>>();
        List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
        map<ID,Document_Provisioning__c> mapOfDP = new map<ID,Document_Provisioning__c>();
        
        for (Sub_PDK_Spec__c pdkSpec : [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                        FROM    Sub_PDK_Spec__c
                                        WHERE   Sub_PDK__c = : subPdkId
                                        AND     Design_Spec__r.Release_Status__c!='General Release'
                                        AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                        AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                        AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']){
                                            
                                    
            if(pdkSpec<>NULL){
                
                if (pdkSpec.Design_Spec__r.Release_Status__c!='Internal Use Only' && pdkSpec.Design_Spec__r.Release_Status__c!='Stepper Tooling Forms'
                    && pdkSpec.Design_Spec__r.Release_Status__c!='Reticle Grade Table' && pdkSpec.Design_Spec__r.Release_Status__c!='Stepper Tooling Forms'){
                    
                    if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!whiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                whiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            }
                        }
                        
                    } else {
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!nonWhiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                nonWhiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            }
                        }
                    }   
                }
            } 
        } // END OF for loop
               
        //prepare Map of spec as key and list of white list accounts associated with that spec  
        if(whiteListSpecs<>NULL && !whiteListSpecs.isEmpty()){
            for(White_List__c wl : [Select Id,Design_Spec__c,Account__c 
                                    From White_List__c 
                                    where Design_Spec__c IN : whiteListSpecs.keySet()]){                                                                    
                if(wl<>Null){                       
                    if (!wlSpecAccMap.containsKey(wl.Design_Spec__c)){
                        wlSpecAccMap.put(wl.Design_Spec__c, new Set<Id>());
                    } //else {
                        wlSpecAccMap.get(wl.Design_Spec__c).add(wl.Account__c);
                    //}
                }
            } 
        }
        // Get accounts from subpdk 
        list<Document_Provisioning__c> lstDP = new list<Document_Provisioning__c>();
        lstDP = [SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,PDK_Spec_Names__c,Pdk_Specs_DeProvisioned__c,
                                                    Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,isProvUpdate__c,isDeProUpdate__c 
                                            FROM    Document_Provisioning__c WHERE Sub_PDK__c =: subPdkId
                                            AND     Status__c = 'Provisioned'];
        
        for(Document_Provisioning__c dp : lstDP){
            
            String specs = '';
            String subPdkSpecs = '';
            String pdkAssociations = '';
            String specName = '';
            if (dp<>NULL){
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                        if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(specId) && 
                            wlSpecAccMap.get(specId).contains(dp.AccountID__c)){                            
                            // Add spec id to dp design spec
                            if(whiteListSpecs.containsKey(specId)){                                
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                            } //END OF WHITELIST SPEC IF BLOCK
                        }
                    } // End of whitelist for loop
                }// end of whitelist if                
                if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){                      
                    for (Id specId : nonWhiteListSpecs.keySet()){
                        if (specs ==''){
                            if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){                                
                                if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                    specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                else
                                    specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';                                     
                            }
                        } else {
                            if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                    specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                else    
                                    specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                            }
                        }
                    } // End of nonWhiteListSpec for loop
                }// End of non white list if                
                if (!String.isBlank(specs)){
                   dp.isProvUpdate__c = false;
                   dp.PdkSpecs__c = specs;    
                }
                
                mapOfDP.put(DP.ID,DP);
            }          
        }//End of Document provisioning list iterator for loop
        
        // update spec names too
			List<Design_Spec__c> specList = [Select OpenText_ID_formula__c,Name from Design_Spec__c];
			Map<String,String> mapOfOTidandSpecName = new Map<String,String>();
			for(Design_Spec__c spec : specList){
				mapOfOTidandSpecName.put(spec.OpenText_ID_formula__c,spec.Name);
			}
        
          for (Document_Provisioning__c dp : lstDP){
			String specNames = '';
			dp.isDeProUpdate__c = false;
			dp.isProvUpdate__c = false;
			if(dp.PDK_Spec_Names__c!=null && dp.PdkSpecs__c!=null){
			for(String s : dp.PdkSpecs__c.split(';')){
					if(specNames==''){
						if(mapOfOTidandSpecName.get(s.split(':')[0])!=null)
							specNames = mapOfOTidandSpecName.get(s.split(':')[0]);
					}	
					else{
						if(mapOfOTidandSpecName.get(s.split(':')[0])!=null)
							specNames = specNames +';'+'\n'+mapOfOTidandSpecName.get(s.split(':')[0]);
					}		
			       } 
				dp.PDK_Spec_Names__c = specNames;
				if(mapOfDP.containsKey(dp.ID)){
					mapOfDP.get(dp.ID).PDK_Spec_Names__c = specNames;
				}				
				}
				
			}
			
			if(mapOfDP != null && !mapOfDP.isEmpty()){
				update mapOfDP.values();
			}					
        
    }

}