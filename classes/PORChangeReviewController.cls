/*
    Author: Anirban Roy
    Description: This is the controller extension class for POR Change Review for creation of POR Change Review.  
    History:
        ARoy        06032014    - code creation.
        ARoy		06092014	- code modified to add validation on POR creation based on PLC Next Gate as PLR.
*/

public class PORChangeReviewController {
	
	// Variable Declaration
	private ApexPages.StandardController controller; 
	private String porLkp = EnvironmentVariable.get('POR_GMPL_LKP_ID');
    
    // Constructor
    public PORChangeReviewController(ApexPages.StandardController controller){
        this.controller = controller;
    }   
    
    // Method to validate the creation of PCR only when PCR Status = 'Closed' or no PCR exists
    public PageReference init(){        
        
        // GMPL/BX009 lookup id and name from POR Change Review
        String porId = ApexPages.currentPage().getParameters().get(porLkp+'_lkid');
        String porName = ApexPages.currentPage().getParameters().get(porLkp);         
        
        // Query to get the GMPL/BX009 to check the PLC Next Gate Status = 'PLR'
        List<GMPL_BX009__c> gmplList = [select		Id
		        									, PLC_Next_Gate__c
		        						from 		GMPL_BX009__c
		        						where		Id = :porId
		        						and			PLC_Next_Gate__c = 'PLR'
		        					   ];
        
        // Error message shown if the PLC Next Gate is not PLR
        if(gmplList == null || gmplList.size() == 0){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_Codes__c.getInstance('POR_CR_VLD_ON_PLC_NEXT_GATE').Message__c));
            return null;
        }
        // Query to get POR Change Review where PCR Status != 'Closed'
        List<POR_Change_Review__c> porList = [select	id
        									  from		POR_Change_Review__c
        									  where		Program_Affected__c = :porId
        									  and		PCR_Status__c != 'Closed'       									 			
        									 ];
        
        // Check for existing POR with PCR Status as Open/BCCB Review/PC Review.      
        if(porList != null && porList.size() > 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_Codes__c.getInstance('POR_CREATE_VALIDATION').Message__c));
            return null;
        }else{
            // Return to the POR Change Review edit page
            String retUrl = ApexPages.currentPage().getParameters().get('retURL');
            system.debug('retUrl***************'+retUrl);
            PageReference pr = new PageReference('/'+POR_Change_Review__c.sObjectType.getDescribe().getKeyPrefix()+'/e?retURL='+retUrl+'&nooverride=1&'+porLkp+'='+porName);
            pr.setRedirect(true);
            return pr;
        }                
        
    }
    
    // Cancel functionality
    public PageReference cancel(){
        return controller.cancel();
    }
}