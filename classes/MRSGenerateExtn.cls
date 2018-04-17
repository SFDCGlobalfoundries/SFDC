/*
Type Name:    MRSGenerateExtn 
Author:       Cognizant 
Created Date: 26-August-2014
Reason: This is the class for making Perform Tapeout Options. 
Change History:

*/

public class MRSGenerateExtn{
     
     //Variable declaration
     public String ptrfId;
     
     /** Constructor **/
     public MRSGenerateExtn(ApexPages.StandardController controller) {        
        ptrfId = ApexPages.CurrentPage().getparameters().get('id');
        
     }
     
     /**
        This method generates the MRS on clicking Generate MRS button on PTRF page layout. 
        @method name: generateMRSLayerChipAssociation
        @parameter:   None.
        @return :     Pagereference.
     **/
     
     public pageReference generateMRSLayerChipAssociation(){
        Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();       
        PTRF__c ptrfRecord = [select Id,Status__c from PTRF__c where Id=:ptrfId];
        List<MRS_Layer_Chip_Association__c> lstMRSLCA = new List<MRS_Layer_Chip_Association__c>();
        set<String> setPTRFIds = new set<String>();
        if(ptrfId!=null && ptrfId!=''){
            if(ptrfRecord.Status__c=='Perform Tapeout Options'){               
                setPTRFIds.add(ptrfId);
                
                //MRSHandlerUtility.addingPTRFToMRSFuture(setPTRFIds);
                MRSHandlerUtility.addingPTRFToMRS(setPTRFIds);
                //==================================
                
                lstMRSLCA.clear();
                lstMRSLCA = [select Id from MRS_Layer_Chip_Association__c where PTRF__c=:ptrfId LIMIT 1];                   
                ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.INFO,' '+mapErrorCodes.get('MRS_GENERATED').Message__c);
                ApexPages.addMessage(myMsg);                                              
            }else{
                ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' '+mapErrorCodes.get('MRS_PTRF_NOT_PTO').Message__c);
                ApexPages.addMessage(myMsg);    
            }           
        }    
         return null;
     }
     
     /**
        This method returns from the VF page to PTRF standard page layout. 
        @method name: returnToPTRF
        @parameter:   None.
        @return :     Pagereference.
     **/
     
     public PageReference returnToPTRF(){
        PageReference page = new PageReference('/'+ptrfId);
        return page;
     }
}