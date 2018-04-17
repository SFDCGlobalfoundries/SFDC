public without sharing class DesignWaiverCollaboratorDetailsView {
     
     public Wavier_Collaborator__c collaborator {get;set;} 
     public Pagereference redirectPage {get;set;}  
     public string url {get;set;}
     public String currentId {get; set;}
     public Id dfmId;
     
     public DesignWaiverCollaboratorDetailsView(ApexPages.standardController stdController){
         
         dfmId = stdController.getRecord().Id;
         collaborator = getWaiverCollaborator(dfmId);
         
     }
     
     private Wavier_Collaborator__c getWaiverCollaborator(Id dfmId){
                 
         return [Select Id, PTSR_Service_Type__c from Wavier_Collaborator__c where Id=: dfmId];
     }
     
     public Pagereference redirectTo(){
     
         if(collaborator.PTSR_Service_Type__c.contains('DFM')) {
            // url = '/apex/DesignWaiverCollaboratorPage';
            url = '/apex/DRCWaiverCollaboratorPage';
         }
         if(collaborator.PTSR_Service_Type__c.contains('DRC')) {
             url = '/apex/DRCWaiverCollaboratorPage';
         }
         
         redirectPage = new PageReference (url);
         redirectPage.getParameters().put('Id',dfmId);
         redirectPage.setRedirect(true);
         return redirectPage;
     }
}