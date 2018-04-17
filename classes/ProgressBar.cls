/**
* @ Author : Navneet Rajput
* @ Company : Globalfoundries
* @ Description : Class help to build progress bar, it will receive inputs from progressbar component 
				  and decide which stage need to show	
**/

public with sharing class ProgressBar {

	public string applicationName { get;set; }
	public string workflowStatus { get;set; }
	private string baseUrl { get;set; }
	private Map<String,String> mapOfpBarStatusImgs;
	//public Wavier_Collaborator__c collaborator { get;set; }
	public sObject sObjectName { get;set; } 
	
	public ProgressBar(){
		// get all status images from customer setting and set as per the workflow/PTSR status
		this.setPbarImages();
	}
	
	// Method will return respective image on the basis of status related information
	// received from waiver collaborator page. It will distingish customer view and internal view at run time 
	// and show waiver collaborator progress bar accordingly
	
	public string getImage(){
		
		if (!mapOfpBarStatusImgs.isEmpty() && sObjectName <> NULL){
			
			if (UserInfo.getUserType() == 'Standard') {
                if (applicationName == 'DFM' || applicationName == 'DRC') {
                    
                    DFM_ProgressBarHandler dfmPBar = new DFM_ProgressBarHandler();
                    Wavier_Collaborator__c waiverCollaborator = (Wavier_Collaborator__c) sObjectName;
                    baseUrl = dfmPBar.getStatusImg4Drc(waiverCollaborator,mapOfpBarStatusImgs);
                    
                }
				
			} else {
				
                  if (applicationName == 'DFM' || applicationName == 'DRC' ){
                    DFM_ProgressBarHandler dfmPBar = new DFM_ProgressBarHandler();
                    Wavier_Collaborator__c waiverCollaborator = (Wavier_Collaborator__c) sObjectName;
                    baseUrl = dfmPBar.getStatusImg4DrcCustomer(waiverCollaborator,mapOfpBarStatusImgs);
                     
                 }
			}	 	 
		}
		
		return baseUrl;
	}
	
	//Method will fetch designwaiver images related values from custom setting 
	//and prepare map of Image as a key and base Url of Image as value
	
	private void setPbarImages(){
		
		mapOfpBarStatusImgs = new map<String,String>();
		List<Progress_Bar__c> lst_pBar = Progress_Bar__c.getall()<>NULL ? Progress_Bar__c.getall().values():NULL;
		
		if (lst_pBar <> NULL && !lst_pBar.isEmpty()){
			for (Progress_Bar__c pBar : lst_pBar) {
				mapOfpBarStatusImgs.put(pBar.Name,pBar.Status_Image__c);
			}	
		}	
	}
}