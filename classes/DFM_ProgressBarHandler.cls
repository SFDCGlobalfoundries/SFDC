/**
* @ Author : Navneet Rajput
* @ Company : Globalfoundries
* @ Description : Class handles DFM waiver collaborator progress bar operations
* @History : Mohan 10/01/2017   
**/

public with sharing class DFM_ProgressBarHandler {
    
    private string baseUrl;
    
    public DFM_ProgressBarHandler(){
        
    } 
    
        
    // Code for DRC
    
    public String getStatusImg4Drc(Wavier_Collaborator__c collaborator,Map<String,String> mapOfpBarStatusImgs) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        String progressBarStatus = collaborator.Progressbar_staus__c;
       // System.debug('sGfAcceptsRisk__c>>>>>'+  collaborator.isGfAcceptsRisk__c);
        
        if (collaborator.DFMServiceOption__c <>null && !(collaborator.DFMServiceOption__c.trim().toLowerCase()=='waiver request')){
        	
        	if(waiverStatus == 'Open' && workflowStatus == 'Pending'&& collaborator.Progressbar_staus__c.equalsIgnoreCase('Initiated')) {
                    
                        baseUrl = 'Initiated_Shortflow';
                        
		        }else if (waiverStatus == 'Open' && collaborator.Progressbar_staus__c.equalsIgnoreCase('PENDING_DFM') || collaborator.Progressbar_staus__c.equalsIgnoreCase('Pending for DFM')){                       
                 	baseUrl = 'PENDING_DFM';
                }else if (workflowStatus == 'Closed' && !collaborator.Is_Sync_with_AIA__c) {
                	baseUrl = 'DFM_SIMPLIFIED_CLOSED';
                }else if (waiverStatus == 'VCP' && workflowStatus == 'Cancel' && collaborator.Is_Submit_4_DFM_Apprval__c){
		        	baseUrl = 'Cancelled_DFM';
	        	
		        	
		        }else if (waiverStatus == 'VCP' && workflowStatus == 'Cancel' && !collaborator.Is_Submit_4_DFM_Apprval__c && collaborator.Progressbar_staus__c.equalsIgnoreCase('Cancelled')){
			        	baseUrl = 'Cancelled_Shortflow';
		        
		        } 
        	   	
            		
           }else {          	  
                        
             if(waiverStatus == 'Open' && workflowStatus == 'Pending'&& collaborator.Progressbar_staus__c.equalsIgnoreCase('Initiated')) {
                    
                        baseUrl = 'Initiated';
        }
        else if (((waiverStatus == 'Open' || waiverStatus == 'Approved') || workflowStatus == 'Pending')  && collaborator.Progressbar_staus__c <> null && collaborator.Progressbar_staus__c.equalsIgnoreCase('Review_Disposition')) {//CHECK progress bar for Disposition flag aswell
                baseUrl = 'Internal_Review';//mapOfpBarStatusImgs.get('Internal_Review');  // && !collaborator.Is_Sync_with_AIA__c deleted and added OR condition for workflow an status          
        }
        else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {            
            baseUrl = 'Execution';//mapOfpBarStatusImgs.get('Execution');
        }
        else if ((waiverStatus == 'Open' || waiverStatus=='DRC RUN ONLY - No Review' || waiverStatus=='DRC Run Only - No Review' ) && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_FAE';//mapOfpBarStatusImgs.get('Pending_FAE');
           
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PA')  && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_FAE';//mapOfpBarStatusImgs.get('Pending_FAE');
           
        } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c =='Pending For Foundry'){
            
            baseUrl = 'Pending_Foundry';//mapOfpBarStatusImgs.get('Pending_Foundry');
           
           
        } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_Customer';//mapOfpBarStatusImgs.get('Pending_Customer');
           
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PWA') && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_Customer';//mapOfpBarStatusImgs.get('Pending_Customer'); 
             
        
            
        } else if (workflowStatus == 'Closed'){ if(collaborator.IsGfAcceptsRisk__c){ baseUrl = 'Internal_Closed';/*mapOfpBarStatusImgs.get('Internal_Closed');*/ }else{   baseUrl = 'Internal_Closed_1';/*mapOfpBarStatusImgs.get('Internal_Closed_1');*/  }
            
            
        }else if (workflowStatus == 'Cancel' && !collaborator.Is_Sync_with_AIA__c){  baseUrl = 'CANCELLED';//mapOfpBarStatusImgs.get('CANCELLED');
        	if(collaborator.Progressbar_staus__c=='Review_Disposition_Cancelled'){
	        	baseUrl = 'Review_Disposition_Cancelled';
	    	}
        } else if (workflowStatus == 'Cancel' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c <> null && collaborator.Progressbar_staus__c !=''){
            //Add condition to check if it got cancelled after FAE / Customer / Foundry
            if(collaborator.Progressbar_staus__c == 'Pending for FAE'||collaborator.Progressbar_staus__c == 'Pending_FAE_Cancelled'){ baseUrl = 'Pending_FAE_Cancelled';//mapOfpBarStatusImgs.get('Pending_FAE_Cancelled');
            }else if(collaborator.Progressbar_staus__c == 'Pending For Customer'||collaborator.Progressbar_staus__c == 'Pending_Customer_Cancelled'){  baseUrl = 'Pending_Customer_Cancelled';//mapOfpBarStatusImgs.get('Pending_Customer_Cancelled');
            }else if(collaborator.Progressbar_staus__c=='Pending For Foundry'||collaborator.Progressbar_staus__c == 'Pending_Foundry_Cancelled'){
            baseUrl = 'Pending_Foundry_Cancelled';//mapOfpBarStatusImgs.get('Pending_Foundry_Cancelled');
            }
        } else if (workflowStatus == 'Cancel'){  baseUrl = 'CANCELLED';//mapOfpBarStatusImgs.get('CANCELLED');
        } 
        }
        
        return baseUrl; 
    }
    
   // Code for DRC
    
    public String  getStatusImg4DrcCustomer(Wavier_Collaborator__c collaborator,Map<String,String> mapOfpBarStatusImgs) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        
       if (collaborator.DFMServiceOption__c <>null && !(collaborator.DFMServiceOption__c.trim().toLowerCase()=='waiver request')){
        	
        	if(waiverStatus == 'Open' && collaborator.Progressbar_staus__c.equalsIgnoreCase('Initiated')) {
                    baseUrl = 'Initiated_Shortflow';
                        
		        }else if (waiverStatus == 'Open' && collaborator.Progressbar_staus__c.equalsIgnoreCase('PENDING_DFM') || collaborator.Progressbar_staus__c.equalsIgnoreCase('Pending for DFM')){                       
                 	baseUrl = 'PENDING_DFM';
                }else if (workflowStatus == 'Closed' && !collaborator.Is_Sync_with_AIA__c) {
                	baseUrl = 'DFM_SIMPLIFIED_CLOSED';
                }else if (waiverStatus == 'VCP' && workflowStatus == 'Cancel' && collaborator.Is_Submit_4_DFM_Apprval__c){
		        	baseUrl = 'Cancelled_DFM';
	      		}else if (waiverStatus == 'VCP' && workflowStatus == 'Cancel' && !collaborator.Is_Submit_4_DFM_Apprval__c && collaborator.Progressbar_staus__c.equalsIgnoreCase('Cancelled')){
			        	baseUrl = 'Cancelled_Shortflow';
		        } 
        	  }else {
        if (waiverStatus == 'Open' && workflowStatus == 'Pending'
                    && collaborator.Is_Submit_4_DFM_Apprval__c){
                        
                        baseUrl = 'DFM_CUSTOMER_PENDING_VIEW';//mapOfpBarStatusImgs.get('DFM_CUSTOMER_PENDING_VIEW');
                        
        } 
         else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && collaborator.Progressbar_staus__c <> null && collaborator.Progressbar_staus__c.equalsIgnoreCase('Review_Disposition')) {//CHECK progress bar for Disposition flag aswell
                baseUrl = 'Review_Disposition';//mapOfpBarStatusImgs.get('Review_Disposition');   //  && !collaborator.Is_Sync_with_AIA__c removed by MOHAN         
        
         }else if(collaborator.Progressbar_staus__c <> null && (collaborator.Progressbar_staus__c=='Pending For FAE' || collaborator.Progressbar_staus__c=='Pending for FAE')) {
             
             baseUrl = 'Review_Disposition';
              
        }
        else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {            
            baseUrl = 'Execution_External';//mapOfpBarStatusImgs.get('Execution');
        }
        else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c =='Pending For Foundry'){
            
            baseUrl = 'Pending_Foundry_External';//mapOfpBarStatusImgs.get('Pending_Foundry_External');
           
        }else if (waiverStatus == 'Open' && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_Customer_External';//mapOfpBarStatusImgs.get('Pending_Customer_External');
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PA')  && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_Customer_External';//mapOfpBarStatusImgs.get('Pending_Customer_External');
        }
        else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_Customer_External';//mapOfpBarStatusImgs.get('Pending_Customer_External');
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PWA') && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
            baseUrl = 'Pending_Customer_External';//mapOfpBarStatusImgs.get('Pending_Customer_External');
        }else if (workflowStatus == 'Closed' && !collaborator.Is_Sync_with_AIA__c) {
                baseUrl = 'DFM_SIMPLIFIED_CLOSED';//mapOfpBarStatusImgs.get('DFM_SIMPLIFIED_CLOSED');
             
        }else if (workflowStatus == 'Closed'){ if(collaborator.IsGfAcceptsRisk__c){ baseUrl = 'External_Closed';/*mapOfpBarStatusImgs.get('External_Closed');*/ }else{ baseUrl = 'External_Closed_1';/*mapOfpBarStatusImgs.get('External_Closed_1');*/ }
            
        }else if (workflowStatus == 'Cancel' && !collaborator.Is_Sync_with_AIA__c){
            //Add condition to check if it got cancelled after FAE / Customer / Foundry
            baseUrl = 'CANCELLED';//mapOfpBarStatusImgs.get('CANCELLED');
            if(collaborator.Progressbar_staus__c=='Review_Disposition_Cancelled'){
	        	baseUrl = 'Review_Disposition_Cancelled_External';
	    	}
        } else if (workflowStatus == 'Cancel' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c <> null && collaborator.Progressbar_staus__c !=''){
            
            if(collaborator.Progressbar_staus__c== 'Pending for FAE'){ baseUrl = 'CANCELLED';//mapOfpBarStatusImgs.get('CANCELLED');
            }else if(collaborator.Progressbar_staus__c== 'Pending For Customer'||collaborator.Progressbar_staus__c== 'Pending_Customer_Cancelled'){ baseUrl = 'Pending_Customer_Cancelled_External';//mapOfpBarStatusImgs.get('Pending_Customer_Cancelled_External');
            }else if(collaborator.Progressbar_staus__c=='Pending For Foundry'||collaborator.Progressbar_staus__c== 'Pending_Foundry_Cancelled'){
            baseUrl = 'Pending_Foundry_Cancelled_External';//mapOfpBarStatusImgs.get('Pending_Foundry_Cancelled_External');
            }
            
        } else if (workflowStatus == 'Cancel'){ baseUrl = 'CANCELLED';//mapOfpBarStatusImgs.get('CANCELLED');
        } 
            
        }
        return baseUrl; 
    }
    
   
}