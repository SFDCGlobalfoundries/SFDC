/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- Foundry View 2.0
* @ Description     :- Class handles operations related to package status change from Draft to any other release status.
                       cases handles like :- change release status from any release status to Draft then packge need to be de-provision
                                             status change from Draft to specific account release then it need to restrict if child spec doesn't have
                                             Specific release status.   
* @ Date            :- 10 July 2014
* @ Change History  :- 
**/

public with sharing class FV_EditPackageCls{
    
    public Package__c designPackage{get;set;}
    public String oldReleaseStatus {get;set;}
    public Integer countOfprovisionedDocuments{get;set;}
    
    // Standard set controller after overriding edit button to add conformation popup on save button
    public FV_EditPackageCls(ApexPages.StandardController controller) {
        
        ID pkgId = controller.getRecord().Id;
        //designpackage = new Package__c(); 
        system.debug('packageRecord>>>>>>>>>>>>>>>>>'+pkgId);
        
        if (pkgId<>Null){
            designPackage = [SELECT Name,
                                    Id,
                                    Ownerid,
                                    Locked__c,
                                    Technology_Type__c,
                                    Package_Release_Status__c,
                                    Tech_Geometry__c,
                                    Package_Description__c,
                                    Process_Type__c,
                                    Package_Version__c,
                                    OpenText_Id__c,
                                    DateTime_Last_Synced_With_OpenText__c,
                                    OpenText_Error_Message__c,
                                    Sync_With_OpenText__c,
                                    Document_Numbers_Associated__c,
                                    Accounts_Provisioned_To__c
                            FROM    Package__c
                            WHERE   Id =:pkgId limit 1];
        }
        system.debug('designPackage>>>>>>>>>>>>>>>>>>>>>>'+designPackage);
        oldReleaseStatus = designPackage.Package_Release_Status__c<>Null?designPackage.Package_Release_Status__c:'';
        
        countOfprovisionedDocuments = [SELECT count()
        							   FROM	  Document_Provisioning__c
									   WHERE  Design_Package__c=:pkgId 
									   AND	  User__c!=NULL
									   AND    Status__c='Provisioned'];
		
		system.debug('countOfprovisionedDocuments>>>>>>>>>>>'+countOfprovisionedDocuments);							   
        system.debug('oldReleaseStatus>>>>>>>>>>>>>>>>'+oldReleaseStatus);
    }

    // Method restrict general relase status to any other release status (if specs dont have general relase spec)
    // Method update package record if release status is change from draft to any other status ans vice versa
     
     public PageReference savePackage(){
        
        system.debug('Inside Save Package >>>>');
        try{
            // Condition will execute only when package release status is General Release status
            if (designPackage<>Null && designPackage.Package_Release_Status__c=='General Release'){
                // check for general release of package is allowed only when its associates specs are general release spec status
                Set<ID> setOfSpecIds = new Set<ID>();
                String errorMsg ='';
                // Package specification is junction object between design spec and package object
                List<Package_Spec__c> listOfpkgSpecs = new List<Package_Spec__c>([Select    Id, 
                                                                                            Design_Spec__c, 
                                                                                            Package__c 
                                                                                from        Package_Spec__c
                                                                                where       Package__c =:designPackage.Id 
                                                                                AND         Design_Spec__c!=null 
                                                                                AND         Design_Spec__r.Release_Status__c!='General Release']);
                                                                                 
                //Following condition will execute only when it will have design specs without General Release status
                if(listOfpkgSpecs!=null && !listOfpkgSpecs.isEmpty()){ 
                    for(Package_Spec__c specId : listOfpkgSpecs){
                        setOfSpecIds.add(specId.Design_Spec__c);
                    }
                    //iterated and prepared set of packageSpec ids and get list of designSpec records
                    if (setOfSpecIds!=null && !setOfSpecIds.isEmpty()){
                        List<Design_Spec__c> listOfSpecifications = new List<Design_Spec__c>([select Id,
                                                                                                     Name,
                                                                                                     Release_status__c 
                                                                                              from   Design_Spec__c 
                                                                                              where  Id IN :setOfSpecIds]);
                         
                         // prepare error message from all designSpecs which dont have release status as general Release status                                                                   
                         if(listOfSpecifications!=null && !listOfSpecifications.isEmpty()){
                            for(Design_Spec__c specification : listOfSpecifications){
                                errorMsg = errorMsg+specification.Name +';';    
                            }
                         }                                                                     
                    }                                                           
                }
                // Return error message 
                if (errorMsg!='' && errorMsg!=null){
                    ApexPages.Message customErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                            system.label.GENERAL_RELASE_STATUS_NOT_ALLOWED+errorMsg); 
                    ApexPages.addMessage(customErrorMsg);
                    return null;
                }                                                           
            }
            // Update package record
            if (designPackage!=null){
                update designPackage;
            }
            system.debug('designPackage.id>>>>>>>>>>>>>>>>>>>'+designPackage);
            return new pagereference('/'+designPackage.id);
            
        } catch(Exception e){
             system.debug('e.getMessage()>>>>>>>>>>'+e.getMessage());
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
             ApexPages.addMessage(myMsg);
             
             return null;
        }
        //system.debug('page>>>>>>>>>>>>>'+page);
        return new pagereference('/'+designPackage.id);
     }
    
}