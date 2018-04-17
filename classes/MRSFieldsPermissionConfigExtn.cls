/*
Type Name: MRSFieldsPermissionConfigExtn
Author: Cognizant 
Created Date: 18-April-2014
Reason: This is a controller class for VFMRSFieldsPermissionConfig page
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
 */
global class MRSFieldsPermissionConfigExtn
{

    public boolean savedSuccessfully {get; set;}
       
    public List<MRS_Fields_Permission_Config__c> lstMRSFieldsPermissionConfig {get; set;} 
     
    public MRSFieldsPermissionConfigExtn(ApexPages.StandardController controller)
    {      
        savedSuccessfully = false;      
        lstMRSFieldsPermissionConfig = new List<MRS_Fields_Permission_Config__c>();
        
        for(MRS_Fields_Permission_Config__c obj:[select Id, Name, CustomerRemoteJobviewFrame__c, CustomerRemoteJobviewPrime__c, DRW__c, FoundryRemoteJobviewFrame__c, 
        FoundryRemoteJobviewPrime__c, FrameMockupCustomer__c, FrameMockupFoundry__c, GDSOUTReviewCustomer__c, GDSOUTReviewFoundry__c, MEBESJobviewCustomer__c,
        MEBESJobviewFoundry__c, MEBESJobviewGlobalShuttle__c, MEBESJobviewMDP__c, MEBESJobviewTapeoutAPPLICATIONS__c, MEBESJobviewTapeoutCenter__c, MEBESJobviewTDTIMPW__c,
        MEBESReceivedFrame__c, MEBESReceivedPrime__c, ORC__c, SendDataFrame__c, SendDataPrime__c from MRS_Fields_Permission_Config__c]){
            lstMRSFieldsPermissionConfig.add(obj);  
        }      
        //Map<String,MRS_Fields_Permission_Config__c> mapPFPC = MRS_Fields_Permission_Config__c.getAll();              
        //lstMRSFieldsPermissionConfig.addAll(mapPFPC.values());       
    }
        
    public void saveValues(){   
        try{
            
            update lstMRSFieldsPermissionConfig;

            savedSuccessfully = true;
            
            
        }catch(DMLException e){ 
           
        }        
     }        
}