/**
* Author: Sreedhar Karukonda
* This class is handler class used in "AgreementToSignatoryTrigger"
* Class queris updated agreements and related accounts. Then Account Valid Tech Geos is updated based Signatories related to each account
* Timeline: 
* Created March 5, 2015
  Changes:
  DBiswal    01042018    Changes for NDA Sync issue to PLM.(line no. 60-116)
  DBiswal    02012018    Canged company Address logic in line no. 110.
**/

/*
* This class is intentionally without sharing. 
* Reason is :  we are updating Account which is private. Even user does not have edit permissions on related account record, 
* he should be able to update Agrement and so does account
*/

public without sharing class AgreemntSignatureSyncHandler {
    private AgreemntSignatureSyncHandler() {
        
    }

    private static AgreemntSignatureSyncHandler singletonHandler{get; set;}
    /*
    * Singleton Implementation
    */
    public static AgreemntSignatureSyncHandler handler{
        get{
            if(singletonHandler == null) singletonHandler = new AgreemntSignatureSyncHandler();
            return singletonHandler;
        }
        set;
    }

    /*
    * This method returns true if an agreement is active by checking status and status category
    */
    public boolean isActiveAgreementSignatory(Signatory__c ndaSignatory){
        if(AgreementSyncHandler.handler.activeStatuses.get(ndaSignatory.Status_Category__c) != null &&
          AgreementSyncHandler.handler.activeStatuses.get(ndaSignatory.Status_Category__c).contains(ndaSignatory.Status__c) ){
             return true; 
          }
        return false;
    }

    /**
    * This is called from 
    *
    **/
    public void onAfterInsert(Map<Id, Signatory__c> newSignatures){
        if(!AgreementSyncHandler.agreementsInProcess){
            Map<Id, Apttus__APTS_Agreement__c> accountToAgreementMap = new Map<Id, Apttus__APTS_Agreement__c>();

            Set<Id> activatedSignatories = new Set<Id>();
            for(Id signatureId : newSignatures.keySet()){
                if(//After update agreement will be active?
                    isActiveAgreementSignatory(newSignatures.get(signatureId))
                ){
                    Id agreementID = newSignatures.get(signatureId).Agreement__c;
                    accountToAgreementMap.put(newSignatures.get(signatureId).Account__c, new Apttus__APTS_Agreement__c(Id= agreementID));
                }
                
                //DBiswal 01042018
                if(newSignatures.get(signatureId).Status__c == 'Activated'){
                    activatedSignatories.add(signatureId);
                }
            }

            updateAccounts(accountToAgreementMap);
            try{
                if(activatedSignatories.size() > 0){
                    callNdaService(activatedSignatories);
                }
            } catch(Exception e){
                ApplicationLogWrapper alw = new ApplicationLogWrapper();
                alw.source = GFAgreementActivateController.class.getName();
                alw.sourceFunction ='onAfterInsert()';
                alw.ApplicationName='NDA Management';
                alw.referenceId ='';
                alw.referenceInfo='Agreement';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
            }
        }
    }

    public void callNdaService(Set<Id> signId){
        for(Signatory__c s :[SELECT Id,Agreement_Type__c,Account_Street__c,Account_Street_2__c,Account_Street_3__c,Account_Street_4__c,Account_City__c,Account_State__c,Account_Country__c,Account__r.Short_Name__c,Account__r.name,Agreement__r.Geometries__c,Agreement__r.Purpose__c,
                            Agreement__r.Apttus__FF_Agreement_Number__c,Agreement__r.Type__c,Agreement__r.Apttus__Requestor__r.HCM_Login_ID__c,Agreement__r.Apttus__Requestor__r.FirstName,Agreement__r.Apttus__Requestor__r.LastName,Agreement__r.Reviewer__r.FirstName,
                            Agreement__r.Reviewer__r.LastName,Agreement__r.GF_Contract_Start_Date__c,Agreement__r.GF_Contract_End_Date__c,Agreement__r.Apttus__Contract_Start_Date__c,Agreement__r.Apttus__Contract_End_Date__c FROM Signatory__c WHERE ID IN: signId]){
            if(s.Agreement_Type__c.contains('NDA') && !s.Agreement_Type__c.contains('GENERAL') && !s.Agreement_Type__c.contains('Legacy') && !s.Agreement_Type__c.contains('TD')){
                String originator = '';
                String approver = '';
                if(s.Agreement__r.Apttus__Requestor__r.HCM_Login_ID__c != null){            
                    originator =  s.Agreement__r.Apttus__Requestor__r.FirstName + ' ' + s.Agreement__r.Apttus__Requestor__r.LastName + ' (' + s.Agreement__r.Apttus__Requestor__r.HCM_Login_ID__c.toLowerCase() + ')';
                    approver = s.Agreement__r.Reviewer__r.FirstName  + ' ' + s.Agreement__r.Reviewer__r.LastName + ' (' + s.Agreement__r.Apttus__Requestor__r.HCM_Login_ID__c.toLowerCase() + ')';
                }
                else{
                    originator =  s.Agreement__r.Apttus__Requestor__r.FirstName + ' ' + s.Agreement__r.Apttus__Requestor__r.LastName;
                    approver = s.Agreement__r.Reviewer__r.FirstName  + ' ' + s.Agreement__r.Reviewer__r.LastName; 
                }        
                Date startDate = s.Agreement__r.GF_Contract_Start_Date__c;
                Date endDate = s.Agreement__r.GF_Contract_End_Date__c;
                if(startDate == null){startDate = s.Agreement__r.Apttus__Contract_Start_Date__c;}
                if(endDate == null){endDate = s.Agreement__r.Apttus__Contract_End_Date__c;}
                String CompanyAddress ='';
                CompanyAddress = ''+s.Account_Street__c+''+s.Account_Street_2__c+''+s.Account_Street_3__c+''+s.Account_Street_4__c+'';
                CompanyAddress += ' ' + s.Account_City__c + ', '+ s.Account_State__c + ', '+ s.Account_Country__c;
                System.debug('deepti '+s.Account__r.Short_Name__c+' **** '+s.Account__r.name+' **** '+s.Agreement__r.Geometries__c+' **** '+s.Account__r.name+' **** '+
                CompanyAddress +' **** '+s.Agreement__r.Purpose__c+' **** '+ s.Agreement__r.Apttus__FF_Agreement_Number__c+' **** '+s.Agreement__r.Type__c+' **** '+originator+' **** '+
                approver+' **** '+startDate+' **** '+endDate);
                NDA_NDAService.activateNDA(s.Account__r.Short_Name__c,s.Account__r.name,s.Agreement__r.Geometries__c,s.Account__r.name,
                CompanyAddress,s.Agreement__r.Purpose__c,s.Agreement__r.Apttus__FF_Agreement_Number__c,s.Agreement__r.Type__c,originator,
                approver,startDate,endDate,endDate);
            }
        }
    }
    
    /**
    *
    *
    **/
    public void onAfterDelete(Map<Id, Signatory__c> oldSignatures){
        if(!AgreementSyncHandler.agreementsInProcess){
            Map<Id, Apttus__APTS_Agreement__c> accountToAgreementMap = new Map<Id, Apttus__APTS_Agreement__c>();

            Set<Id> activatedSignaturesAgreements = new Set<Id>();
            for(Id signatureId : oldSignatures.keySet()){
                if(//After update agreement will be active?
                    (isActiveAgreementSignatory(oldSignatures.get(signatureId)))
                ){
                    Id agreementID = oldSignatures.get(signatureId).Agreement__c;
                    accountToAgreementMap.put(oldSignatures.get(signatureId).Account__c, new Apttus__APTS_Agreement__c(Id= agreementID));
                }
            }
            System.debug('ACCOUNTS AFFETCTED : ' + accountToAgreementMap);
            updateAccounts(accountToAgreementMap);
        }
    }


    /*
    *  Updates accounts related to given Agreements. Account related to agreement via agreement record or via Signatures/Tags on the agreement
    */
    private void updateAccounts( Map<Id, Apttus__APTS_Agreement__c> accountToAgreementMap){
        Map<Id, Account> accountsMap = new Map<Id, Account>();
            
        if(accountToAgreementMap.size() > 0){
            List<Account> accountsNeedSync = new List<Account>();

            System.debug( 'QUERY FOR SIGNATURES OF THE ACCOUNTS : ' + 'SELECT Id, Name, Has_Valid_NDA__c, Valid_Tech_Geos__c, (SELECT Id, Geometries__c, Status__c, Status_Category__c, Agreement__c, Agreement__r.Geometries__c, Agreement__r.GF_Contract_End_Date__c FROM Signatories__r WHERE '+AgreementSyncHandler.convertToMapToString(AgreementSyncHandler.handler.activeStatuses,'Status_Category__c', 'Status__c')+' AND Agreement__r.RecordTypeId in '+ AgreementSyncHandler.convertToListToString(AgreementSyncHandler.handler.syncRequiredRecordTypeIds) + ' order by Agreement__r.GF_Contract_End_Date__c desc) FROM Account WHERE Id in ' + AgreementSyncHandler.convertToListToString(accountToAgreementMap.keySet()));
            
            List<Account> relatedAccounts = (List<Account>)Database.query('SELECT Id, Name, Has_Valid_NDA__c, Valid_Tech_Geos__c, (SELECT Id, Geometries__c, Status__c, Status_Category__c, Agreement__c, Agreement__r.GF_Contract_End_Date__c, Agreement__r.Geometries__c, Agreement__r.CreatedDate FROM Signatories__r WHERE '+AgreementSyncHandler.convertToMapToString(AgreementSyncHandler.handler.activeStatuses,'Status_Category__c', 'Status__c')+ ' AND Agreement__r.RecordTypeId in '+ AgreementSyncHandler.convertToListToString(AgreementSyncHandler.handler.syncRequiredRecordTypeIds) +' order by Agreement__r.GF_Contract_End_Date__c desc) FROM Account WHERE Id in ' + AgreementSyncHandler.convertToListToString(accountToAgreementMap.keySet()));
            
            accountsMap.putAll(relatedAccounts);
            System.debug('RELATED ACCOUNTS : ' + relatedAccounts);
            AgreementSyncHandler.handler.doSyncForAccounts(accountsMap);
        }
    }   
}