/**
* @ Author :- Kunal Patil
* @ Company :- CTS 
* @ Description :- Class handles PDK spec associations failure  
                   
* @ Date :- 6/7/2015
* @ Change History :- 
**/

global class FV_RetriggerPdkSpecAssociation {
	webservice static String retriggerPdkSpecs(String subPdkId){
		try{
			if(subPdkId!=null && subPdkId!=''){
				Sub_PDK__c subPDK = getSubPdkRecord(subPdkId);
        		subPDK.isRetrigger__c = true;
        		subPDK.Ready_For_Provisioning__c = false;
        		subPDK.PDK_Failure_Specs__c = null;
        		if(subPDK.PDK_Event__c != null && subPDK.PDK_Event__c !='')
        			subPDK.PDK_Event__c = subPDK.PDK_Event__c+';'+Userinfo.getFirstName()+' '+Userinfo.getLastName()+' '+'Retriggered';
        		else
        			subPDK.PDK_Event__c = Userinfo.getFirstName()+' '+Userinfo.getLastName()+' '+'Retriggered';						
        		list<Sub_PDK_Spec__c> subPdkSpecs = getSubPdkSpeclist(subPdkId);
            	String PdkSpecs = '';
            	if(subPdkSpecs!=null && subPdkSpecs.size()>0){
            		for(Sub_PDK_Spec__c PDKSpec: subPdkSpecs){
                		if(PdkSpecs == '' || PdkSpecs == NULL){
                			if(PDKSpec.OTID__c==null)
                				PdkSpecs = PDKSpec.id+':NONE:'+PDKSpec.Design_Spec_OpenTextId__c;
                			else
                				PdkSpecs = PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;	
                		}	
                		else{
                			if(PDKSpec.OTID__c==null)	
                				PdkSpecs = PdkSpecs+';'+PDKSpec.id+':NONE:'+PDKSpec.Design_Spec_OpenTextId__c;
                			else
                				PdkSpecs = PdkSpecs+';'+PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;
                		}	
            		}
            	}
            	if(PdkSpecs!='' && PdkSpecs!=null)
               		subPdk.Pdk_Spec_Associations__c = PdkSpecs;
        		update subPDK;									
			}
			return 'Request Submitted successfully. Please verify in FV after 10 minutes.';
		} catch (Exception Erro){
			return 'Error :: '+Erro.getMessage();
		}
	}
	static list<Sub_PDK_Spec__c> getSubPdkSpeclist(String subPdkId){
    	return [select id,Design_Spec__c,Design_Spec__r.Name,Sub_PDK__c,OTID__c,Design_Spec__r.Release_Status__c,
	    		Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c,Design_Spec_OpenTextId__c 
	    		from Sub_PDK_Spec__c 
	    		where sub_pdk__c =: subpdkid];
    }
    static Sub_PDK__c getSubPdkRecord(String subPdkId){
    	List<Sub_PDK__c> subPdklist = new List<Sub_PDK__c>();
    	subPdklist = [select PDK_Event__c from Sub_PDK__c where id=:subPdkId];
    	if(subPdklist.size()>0){
    		return subPdklist.get(0);
    	}
    	else
    		return null;
    }
}