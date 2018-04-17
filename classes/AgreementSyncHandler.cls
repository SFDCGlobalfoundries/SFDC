/**
* Author: Sreedhar Karukonda 
* Timeline: 
*    Created: Jan 28, 2015
*    Modified: July 26, 2017
*    rtalwari - 'Adding a new Account record flag "Valid_NDA_with_ASIC_Clause__c" to indicate a valid ASIC NDA is in effect in method "doSyncForAccounts". 
**/

/*
* This class is intentionally without sharing. 
* Reason is :  we are updating Account which is private. Even user does not have edit permissions on related account record, 
* he should be able to update Agrement and so does account
*/
public without sharing class AgreementSyncHandler {
  
  private AgreementSyncHandler() {}

  /**
  * Used to skip trigger on "All Associated Agreement Signatures(Signature__c)" object
  **/
  public static boolean agreementsInProcess{
    get{
      if(agreementsInProcess == null) agreementsInProcess = false;
      return agreementsInProcess;
    }
    set;
  }

  /**
  * Used to skip recursive trigger invokation 
  **/
  public static boolean skipRecursiveTriggerInvokation{
    get{
      if(skipRecursiveTriggerInvokation == null) skipRecursiveTriggerInvokation = false;
      return skipRecursiveTriggerInvokation;
    }
    set;
  }

  /*
  * Map of Id and Agreement
  * This holds Agreement record which are activated and which are deactivated and geometries changed
  */
  private Map<Id, Apttus__APTS_Agreement__c> syncRequiredAgreeements{
    get{
      if(syncRequiredAgreeements == null) syncRequiredAgreeements = new Map<Id, Apttus__APTS_Agreement__c>();
      return syncRequiredAgreeements;
    }
    set;
  }

  private static AgreementSyncHandler singletonHandler{get; set;}
  /*
  * Singleton Implementation
  */
  public static AgreementSyncHandler handler{
    get{
      if(singletonHandler == null) singletonHandler = new AgreementSyncHandler();
      return singletonHandler;
    }
    set;
  }
    
    /**
     * Valid status 
     * GFV_NDA_Account_Sync_Settings__c custom Setting has configuration details. 
     * The custom label format is Status Category1->Status1\nStatus Category2->Status1
     * Example:
     *  In Effect->Activated
     *  In Effect->Being Amended
     * 
  **/
    public Map<String, Set<String>> activeStatuses{
        get{
          if(activeStatuses == null){
                activeStatuses = new Map<String, Set<String>>();
              String activeStatusSettings = AgreementSyncHandler.handler.syncSettings.get('ndaSyncApplicableTo');
              if(activeStatusSettings == null) throw new GFV_NDA_Sync_Exception('Please look at "GFV NDA Account Sync Settings" for "ndaSyncApplicableTo" settings');
              List<String> statusesSplit = activeStatusSettings.split('\n');
              for(String statusStr: statusesSplit){
                    if(statusStr != ''){
                      statusStr = statusStr.trim();
                        List<String> statusSplit = statusStr.split('->');
                        if(statusSplit.size() == 2 ){
                            String category = statusSplit[0].trim();
                            String status = statusSplit[1].trim();
                            // Status Category is not yet included into map, Add it to map and add Statua in to Status set.
                            if(activeStatuses.get(category) == null){
                                activeStatuses.put(category, new Set<String>{status});                                
                            }else{
                              // Status Category is already included into map, Add Statuts in to Status set.
                               activeStatuses.get(category).add(status);  
                            }
                        }
                    }
              }
          }
            return activeStatuses;
      }
        private set;
    }
    
    /*
  * This method returns true if an agreement is active by checking status and status category
  */
    public boolean isActiveAgreement(Apttus__APTS_Agreement__c nda){
        if(AgreementSyncHandler.handler.activeStatuses.get(nda.Apttus__Status_Category__c) != null &&
          AgreementSyncHandler.handler.activeStatuses.get(nda.Apttus__Status_Category__c).contains(nda.Apttus__Status__c) ){
             return true; 
          }
        return false;
    }

    /**
    * Sync Settings from "GFV_NDA_Account_Sync_Settings__c"
    * 
    **/

    public Map<String, String> syncSettings{
      get{
        if(syncSettings == null){
          syncSettings = new Map<String, String>();
          Map<String, GFV_NDA_Account_Sync_Settings__c> syncSettingsRecords = GFV_NDA_Account_Sync_Settings__c.getAll();
          for(GFV_NDA_Account_Sync_Settings__c setting : syncSettingsRecords.values()){
            syncSettings.put(setting.Name, setting.Value__c);
          }
        }
        return syncSettings;
      }
      private set;
    }


     /**
     * Sync require Record Types Ids. Agreement Object is common obeject for all types of contracts.
     * Sync is applicable to only NDA contracts esp. Sales and DS NDAs.
     * Agreements_Record_Types_Require_Sync containes comma seperated record type  developer names
     **/
    public Set<Id> syncRequiredRecordTypeIds{
        get{
            if(syncRequiredRecordTypeIds == null){
                String syncRequiredRecordTypesSetting = AgreementSyncHandler.handler.syncSettings.get('syncApplicableRecordTypes');
                if(syncRequiredRecordTypesSetting == null) throw new GFV_NDA_Sync_Exception('Please look at "GFV NDA Account Sync Settings" for "syncApplicableRecordTypes" setting');
                List<String> recordTypeDevNames = syncRequiredRecordTypesSetting.split('\n');
                for(Integer idx = 0; idx < recordTypeDevNames.size(); idx++){
                  recordTypeDevNames[idx] = recordTypeDevNames[idx].trim();
                }
                Map<Id, RecordType> recordTypesMap = new Map<Id, RecordType>([SELECT Id FROM RecordType where DeveloperName in :recordTypeDevNames and SobjectType = 'Apttus__APTS_Agreement__c']);
                syncRequiredRecordTypeIds = recordTypesMap.keySet();
            }
            return syncRequiredRecordTypeIds;
        }
        private set;
    }
    

    /**
  * This will be called from Agreement Trigger. This method sync agreements in folowing cases:
  *   1. Processes agreements which are active when created.
  * This method processes 
  * @newAgreements map of after update agreement records
  * 
  **/
  public void onAfterInsert(Map<Id, Apttus__APTS_Agreement__c> newAgreements){
    if(!AgreementSyncHandler.skipRecursiveTriggerInvokation){
      AgreementSyncHandler.agreementsInProcess = true;
      for(Id agreementId : newAgreements.keySet()){
        if(AgreementSyncHandler.handler.isActiveAgreement(newAgreements.get(agreementId))){ //Is crreated agreement is active?
          AgreementSyncHandler.handler.syncRequiredAgreeements.put(agreementId, newAgreements.get(agreementId));
        }
      }
      AgreementSyncHandler.handler.updateAccounts(AgreementSyncHandler.handler.syncRequiredAgreeements);
      AgreementSyncHandler.agreementsInProcess = false;
    }
  }

  /**
  * This will be called from Agreement Trigger. This method sync agreements in folowing cases:
  *   1. Active before update
  *  2. Activated in the update
  *  3. Already active and geometries list is changed
  * This method processes 
  * @oldAgreements map of before update agreement records
  * @newAgreements map of after update agreement records
  * 
  **/
  public void onAfterUpdate(Map<Id, Apttus__APTS_Agreement__c> oldAgreements, Map<Id, Apttus__APTS_Agreement__c> newAgreements){
    if(AgreementSyncHandler.skipRecursiveTriggerInvokation == false){
      AgreementSyncHandler.agreementsInProcess = true;
        for(Id agreementId : oldAgreements.keySet()){
          if(
            // Before update agreement was active and now it is not active (DEACTIVATED)
            ((AgreementSyncHandler.handler.isActiveAgreement(oldAgreements.get(agreementId)) && !AgreementSyncHandler.handler.isActiveAgreement(newAgreements.get(agreementId))) ||
            // Before update agreement was not active and now it is  active (ACTIVATED)
            (!AgreementSyncHandler.handler.isActiveAgreement(oldAgreements.get(agreementId)) && AgreementSyncHandler.handler.isActiveAgreement(newAgreements.get(agreementId)) ) ||
            // Agreement is Active and Geometries Changed
            (AgreementSyncHandler.handler.isActiveAgreement(newAgreements.get(agreementId)) && oldAgreements.get(agreementId).Geometries__c != newAgreements.get(agreementId).Geometries__c) ) &&
            (AgreementSyncHandler.handler.syncRequiredRecordTypeIds.contains(newAgreements.get(agreementId).RecordTypeId) || AgreementSyncHandler.handler.syncRequiredRecordTypeIds.contains(oldAgreements.get(agreementId).RecordTypeId))
          ){
                        //System.assert(false, newAgreements.get(agreementId).RecordTypeId);
            AgreementSyncHandler.handler.syncRequiredAgreeements.put(agreementId, newAgreements.get(agreementId));
            System.debug('AGREEMENT IS QUALIFIED FOR SYNC : ' + AgreementSyncHandler.handler.syncRequiredAgreeements);
          }
        }
        AgreementSyncHandler.handler.updateAccounts(AgreementSyncHandler.handler.syncRequiredAgreeements);
        AgreementSyncHandler.agreementsInProcess = false;
    }
  }

  /*
  * SYNCS ACCOUNTS By quering NDA Signatories on the Account 
  */
  public void doSyncForAccounts(Map<Id, Account> accountsMap){
    try{
      List<Account> accountsNeedSync = new List<Account>();
      for(Account acnt : accountsMap.values()){
        acnt.Latest_NDA_Expiration_Date__c = null;
        acnt.Has_Valid_NDA__c = false;
        acnt.Valid_Tech_Geos__c = '';
        acnt.Latest_ASIC_expiration_date__c = null;
        acnt.Valid_NDA_with_ASIC_Clause__c = false;
        Set<String> thisAccountGeometries = new Set<String>();
        for(Signatory__c signatory: acnt.Signatories__r){
          if(acnt.Latest_NDA_Expiration_Date__c == null){
            acnt.Latest_NDA_Expiration_Date__c = signatory.Agreement__r.GF_Contract_End_Date__c;
          }
          if(signatory.Agreement__r.Geometries__c != null){
            thisAccountGeometries.addAll(signatory.Agreement__r.Geometries__c.split(';'));
          }
          acnt.Has_Valid_NDA__c = true;
            if(date.valueOf(signatory.Agreement__r.CreatedDate) >= date.parse((Environment_Variable__c.getInstance('ASIC acquisition date').Value__c))){
                 acnt.Valid_NDA_with_ASIC_Clause__c = true;
              
                if(acnt.Latest_ASIC_expiration_date__c == null){
                   acnt.Latest_ASIC_expiration_date__c = signatory.Agreement__r.GF_Contract_End_Date__c; 
                }
                
            }
        }
                
        // SORT GEOMETRIES
        List<String> sortedGeometries = new List<String>();
        sortedGeometries.addAll(thisAccountGeometries);
        sortedGeometries.sort();
        for(String geometry : sortedGeometries){
          if(acnt.Valid_Tech_Geos__c == ''){
            acnt.Valid_Tech_Geos__c = geometry ;
          }else{
            acnt.Valid_Tech_Geos__c = acnt.Valid_Tech_Geos__c + ';'  + geometry;
          }
        }
        accountsNeedSync.add(acnt);
      }
            System.debug('HOTFIX TEST : ' + accountsNeedSync);
      List<Database.SaveResult> accountUpdateResult = Database.update(accountsNeedSync, false);
      // STAGE ALL AGREEMENT STATUS
      Map<Id, Agreement_To_Account_Sync_Status__c> statusUpdateForAgreements = new Map<Id, Agreement_To_Account_Sync_Status__c>();
      
      for(Account accnt : accountsMap.values()){
        for(Signatory__c fsignatory: accountsMap.get(accnt.Id).Signatories__r){
          statusUpdateForAgreements.put(fsignatory.Agreement__c, new Agreement_To_Account_Sync_Status__c(Upsert_Reference__c=fsignatory.Agreement__c, 
                                                                                                Agreement__c = fsignatory.Agreement__c,
                                                                                                Sync_Error_Message__c ='Sync successfully completed on ' + Datetime.now(), 
                                                                                                Sync_Failed__c = false));  
        }
      }

      String errorMesaages = '';
      Boolean  isThereAnError = false;
      for( Integer index =0; index < accountUpdateResult.size(); index++){
        if(!accountUpdateResult[index].isSuccess()){
          Account failedAccount = accountsMap.get(accountsNeedSync[index].Id);
          String fullAccountURL = '<a href ="'+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + failedAccount.Id+ '">'+ failedAccount.Name+'</a>';
          System.debug('#211 ACCOUNT FAILED SYNC : ' + failedAccount);
          for(Signatory__c fsignatory: failedAccount.Signatories__r){
            if(statusUpdateForAgreements.get(fsignatory.Agreement__c) != null && !statusUpdateForAgreements.get(fsignatory.Agreement__c).Sync_Error_Message__c.startsWith('Sync successfully completed on') ){
              statusUpdateForAgreements.get(fsignatory.Agreement__c).Sync_Error_Message__c += '\n\nACCOUNT NAME : '+ failedAccount.Name +' \n Exception Message: '+ accountUpdateResult[index].getErrors();
            }else{
              if(accountUpdateResult[index].getErrors().size() > 0){
                statusUpdateForAgreements.put(fsignatory.Agreement__c, new Agreement_To_Account_Sync_Status__c(Upsert_Reference__c=fsignatory.Agreement__c, Agreement__c = fsignatory.Agreement__c,
                            Sync_Error_Message__c ='ACCOUNT NAME : '+ failedAccount.Name +' \n Exception Message: '+ accountUpdateResult[index].getErrors()[0].getMessage(), 
                            Sync_Failed__c = true));
              }else{
                statusUpdateForAgreements.put(fsignatory.Agreement__c, new Agreement_To_Account_Sync_Status__c(Upsert_Reference__c=fsignatory.Agreement__c, Agreement__c = fsignatory.Agreement__c,
                            Sync_Error_Message__c ='ACCOUNT NAME : '+ failedAccount.Name +' \n Exception Message: '+ accountUpdateResult[index].getErrors(), 
                            Sync_Failed__c = true));
              }
            }
          }
          isThereAnError = true;
          errorMesaages += 'Failed account : ' + fullAccountURL +'<br/>Failed with message  : '+ accountUpdateResult[index].getErrors() +'<br/><br/>'; 
        }
      }
            
      if(statusUpdateForAgreements.size() > 0 ){
        //AVOID RECURSIVE CALLING 
        AgreementSyncHandler.skipRecursiveTriggerInvokation = true; 
        System.debug('HOT FIX UPDATE AGREEMENT : ' + statusUpdateForAgreements.values());

        Database.upsert(statusUpdateForAgreements.values(), Schema.Agreement_To_Account_Sync_Status__c.Upsert_Reference__c, false);
        // ON ERROR SEND AN EMAIL
        if(isThereAnError) AgreementSyncHandler.sendEmail(errorMesaages);
      }
    }catch(Exception ex){
            System.debug('HOTFIX TEST EXCEPTION : ' + ex);
      String errorMesaages = '';
      Map<Id, Agreement_To_Account_Sync_Status__c> failedAgreementsInCatch = new Map<Id, Agreement_To_Account_Sync_Status__c>();
            Set<Id> agreementIds = new Set<Id>();
      for(Account accnt : accountsMap.values()){
        Account faieldAccount = accountsMap.get(accnt.Id);
        for(Signatory__c fsignatory: faieldAccount.Signatories__r){
          agreementIds.add(fsignatory.Agreement__c);
        }
        errorMesaages += faieldAccount.Name +' Failed with message \t : '+ ex.getMessage() +'\n';
      }
      for(Id aid: agreementIds){
        failedAgreementsInCatch.put(aid, new Agreement_To_Account_Sync_Status__c(Upsert_Reference__c= aid,  Agreement__c = aid,
                                              Sync_Error_Message__c ='Exception : '+ ex.getMessage(), 
                                              Sync_Failed__c = true));
        }   
      System.debug('HOT FIX FAILED AGREEMENT : ' + failedAgreementsInCatch);       
      AgreementSyncHandler.skipRecursiveTriggerInvokation = true;
      Database.upsert(failedAgreementsInCatch.values(), Schema.Agreement_To_Account_Sync_Status__c.Upsert_Reference__c, false);
      AgreementSyncHandler.sendEmail(errorMesaages);
    }
  }

  /*
  *  Updates accounts related to given Agreements. Account related to agreement via agreement record or via Signatures/Tags on the agreement
  */
  private void updateAccounts(Map<Id, Apttus__APTS_Agreement__c> processTheseAgreemnt){
    Map<Id, Account> accountsMap = new Map<Id, Account>();
    if(processTheseAgreemnt.size() > 0){
      List<Signatory__c> relatedSignatories = [SELECT Id, Account__c FROM Signatory__c WHERE Agreement__c in :processTheseAgreemnt.keySet()];
      Set<Id> accountIds = new Set<Id>();
      for(Signatory__c signatory: relatedSignatories){
        if(signatory.Account__c != null)
          accountIds.add(signatory.Account__c);
      }
      if(accountIds.size() > 0){
        System.debug( 'QUERY FOR SIGNATURES OF THE ACCOUNTS : ' + 
                    'SELECT Id, Name, Has_Valid_NDA__c, Valid_Tech_Geos__c, (SELECT Id, Geometries__c, Status__c, Status_Category__c, Agreement__r.GF_Contract_End_Date__c, Agreement__r.Geometries__c FROM Signatories__r WHERE '+convertToMapToString(AgreementSyncHandler.handler.activeStatuses,'Status_Category__c', 'Status__c')+
                    ' AND Agreement__r.RecordTypeId in '+convertToListToString(AgreementSyncHandler.handler.syncRequiredRecordTypeIds)
                    +' order by Agreement__r.GF_Contract_End_Date__c desc) FROM Account WHERE Id in ' + convertToListToString(accountIds) );

        List<Account> relatedAccounts = (List<Account>)Database.query(
            'SELECT Id, Name, Has_Valid_NDA__c, Valid_Tech_Geos__c,Valid_NDA_with_ASIC_Clause__c,Latest_ASIC_expiration_date__c, (SELECT Id, Geometries__c, Status__c, Status_Category__c, Agreement__r.GF_Contract_End_Date__c, Agreement__r.Geometries__c, Agreement__r.CreatedDate  FROM Signatories__r WHERE '+
              convertToMapToString(AgreementSyncHandler.handler.activeStatuses,'Status_Category__c', 'Status__c')+ 
                                         ' AND Agreement__r.RecordTypeId in '+ convertToListToString(AgreementSyncHandler.handler.syncRequiredRecordTypeIds) +
                                         ' order by Agreement__r.GF_Contract_End_Date__c desc) FROM Account WHERE Id in ' + convertToListToString(accountIds));
        accountsMap.putAll(relatedAccounts);

        // SYNCS ACCOUNT BY QUERING SINGNATORIES
        AgreementSyncHandler.handler.doSyncForAccounts(accountsMap);
      }
    }
  }

  /*
  * Converts list of Strings to comma seperated literals
  */
  public static String convertToListToString(Set<Id> ids){
    String returnString = '(';
    for(String str: ids){
      if(returnString == '('){
        returnString +='\''+str+'\''; 
      }else{
        returnString +=',\''+str+'\''; 
      }
    }
    returnString += ')';
    return returnString;
  }

  /*
  * Converts active NDA Status Category and Status to Queriable string
  * 
  * FROM: 
  *   Terminated->Superceeded
  *   In Effect->Activated
  *   In Effect->Being Amended
  * TO : 
  *   (Status_Category__c = 'In Effect' AND  (Status__c ='Activated' OR Status__c = 'Being Amended')) OR Status_Category__c = 'Terminated' AND  (Status__c ='Superceeded'))
  */
  public static String convertToMapToString(Map<String, Set<String>> stringsMap, String categoryFieldName, String statusFieldName){
    String returnString = '';
    for(String categoryVal : stringsMap.keySet()){
      String thisStatusCategory = ' ( ';
      // Example : (Status_Category__c = 'In Effect' AND  (Status__c ='Activated' OR Status__c = 'Being Amended'))
      if(categoryVal != null && stringsMap.get(categoryVal) != null){
        //( Status_Category__c = 'In Effect'
        thisStatusCategory += (categoryFieldName + '=\'' + categoryVal+'\'');
        //(Status__c ='Activated' or Status__c = 'Being Amended')
        String thisStatuses = '';
        for(String status : stringsMap.get(categoryVal)){
          if( thisStatuses == ''){
            thisStatuses = '( ' + statusFieldName + ' = \'' +status + '\' ';
          }else{
            thisStatuses +=  ' OR ' +statusFieldName  + '= \'' +status + '\' ';
          }
        }
        if( thisStatuses != ''){
          thisStatuses = thisStatuses + ' )';
          thisStatusCategory += (' AND ' + thisStatuses + ' )');
        } else{
          thisStatusCategory += ')';
        }
      }
      if(returnString == ''){
        returnString = thisStatusCategory;
      }else{
        returnString += ' OR ' + thisStatusCategory;
      }
    }
    return returnString;
  }

  /*
  * SEND EMAIL
  */ 
  public static void sendEmail(String message){
    Messaging.reserveSingleEmailCapacity(2);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String toAddressesString = AgreementSyncHandler.handler.syncSettings.get('errorEmailsTo');
    if(toAddressesString == null) throw new GFV_NDA_Sync_Exception('Please look at "GFV NDA Account Sync Settings" for "errorEmailsTo" settings');
    List<String> toAddresses = toAddressesString.split('\n');
    for(Integer idx = 0; idx < toAddresses.size(); idx++){
      toAddresses[idx] = toAddresses[idx].trim();
    }
    
    mail.setToAddresses(toAddresses);
    mail.setSenderDisplayName('Salesforce Error');
    String emailSubject = AgreementSyncHandler.handler.syncSettings.get('errorEmailSubject');
    if(emailSubject == null) throw new GFV_NDA_Sync_Exception('Please look at "GFV NDA Account Sync Settings" for "errorEmailSubject" settings');
    mail.setSubject(emailSubject);
    mail.setBccSender(false);
    mail.setUseSignature(false);
    mail.setPlainTextBody(message);
    mail.setHtmlBody(message);
    if(!Test.isRunningTest())
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }

  public class GFV_NDA_Sync_Exception extends Exception{}

}