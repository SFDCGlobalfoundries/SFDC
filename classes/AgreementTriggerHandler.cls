/*
Type Name: AgreementTriggerHandler
Author: Cognizant NDA Team 
Created Date: 05-June-2013
Reason: This is the class to update the account information in the signatory. 
Test Class: AgreementToSignatoryTriggerTest
Change History: 
Author: 
Modified Date: 
Reason: 
……..

DBiswal    12122017    Changes for Ciphercloud enhancements.
*/

public class AgreementTriggerHandler{

    private boolean m_isExecuting = false;    
    private integer batchSize = 0;  
    List<String> agmntIds = new List<String>();  
    List<String> accountIds = new List<String>();  
      
    Map <String,Schema.RecordTypeInfo> recordTypes = Apttus__APTS_Agreement__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map <String,Schema.RecordTypeInfo> SigrecordTypes = Signatory__c.sObjectType.getDescribe().getRecordTypeInfosByName();
   //Get the record type id of from the Map based on the Name
    Id RecTypeId = recordTypes.get(System.Label.NDA_RecordType).getRecordTypeId();
    Id Multi_RecTypeId = recordTypes.get(System.Label.NDA_Multi_Party_Record_Type).getRecordTypeId();
    Id OtherParty_RecTypeId = recordTypes.get(System.Label.NDA_Other_Party_Rec_Type).getRecordTypeId(); 
    Id NDA_Agreement_SignatoryId = SigrecordTypes.get(System.Label.NDA_Agreement_Signatory).getRecordTypeId(); 
    // Get the record types id's for DS NDA  
    Id DS_RecTypeId = recordTypes.get(System.Label.DS_2_Party_NDA).getRecordTypeId();
    Id DS_Multi_RecTypeId = recordTypes.get(System.Label.DS_Multi_Party_NDA).getRecordTypeId();
    Id DS_OtherParty_RecTypeId = recordTypes.get(System.Label.DS_Other_Party_NDA).getRecordTypeId(); 
    //get the record types for General NDA
    Id GN_RecTypeId = recordTypes.get(System.Label.GENERAL_NDA).getRecordTypeId();
    Id GN_OtherParty_RecTypeId = recordTypes.get(System.Label.GENERAL_Other_Party_NDA).getRecordTypeId(); 
    Id GN_Multi_RecTypeId  = recordTypes.get(System.Label.TD_Multi_Party_NDA).getRecordTypeId();   
    //get the record types for TD NDA
    Id TD_RecTypeId = recordTypes.get(System.Label.TD_2_Party_NDA).getRecordTypeId();
    Id TD_OtherParty_RecTypeId = recordTypes.get(System.Label.TD_Other_Party_NDA).getRecordTypeId(); 
    Id TD_Multi_RecTypeId  = recordTypes.get(System.Label.GENERAL_Multi_Party_NDA).getRecordTypeId(); 
    //get recordtypes for ciphercloud - DBiswal 12122017
    Id SAMS_RecTypeId  = recordTypes.get(Environment_Variable__c.getInstance('CLM_RTYPE_SAMS_FEDS_2PARTY').Value__c).getRecordTypeId();
    Id SAMS_Multi_RecTypeId  = recordTypes.get(Environment_Variable__c.getInstance('CLM_RTYPE_SAMS_FEDS_MULTIPARTY').Value__c).getRecordTypeId();
            
   public AgreementTriggerHandler(boolean isExecuting, integer size) {        
     
       m_isExecuting = isExecuting;        
        batchSize = size;    }
        
    public static boolean isExecuting = true;    
    public static boolean executeOnce() {        
                return isExecuting;    } 
                 
    public void  OnBeforeInsertOrUpdateAgreement(Apttus__APTS_Agreement__c[]  agmnt ){
            UpdateAgreementTechGeos(agmnt );}
            
    public void  OnAfterInsertAgreement(Apttus__APTS_Agreement__c[]  agmnt ){          
            OnAfterInserAgreements(agmnt );}
              
     public void  OnAfterUpdateAgreement(Apttus__APTS_Agreement__c[]  agmnt, Map < ID, Apttus__APTS_Agreement__c > AgmntsMap ){
            OnAfterUpdateAgreements(agmnt, AgmntsMap );}  
         
    /**
    This function is implementated update the recrod from AgreementTrigger.
    @method name: OnAfterUpdateAgreements
    @trigger: AgreementToSignatoryTrigger 
    @event: After Update
    @parameter: list of the agreements, list of the old agreements map
    @return : NA.
    **/
    
   private void  OnAfterUpdateAgreements(Apttus__APTS_Agreement__c[] agmnts, Map < ID, Apttus__APTS_Agreement__c > AgmntsMap){
       
        List<Apttus__APTS_Agreement__c> lstAgrmnt = new List<Apttus__APTS_Agreement__c>();
        List<Signatory__c> signatoryList1 = new List<Signatory__c>();
        List<Signatory__c>  singList = new List<Signatory__c>();             
        List<String> sigIds = new List<String>();  
        List<Signatory__c>  updatesingListInsert = new List<Signatory__c>();  
        List<Apttus__APTS_Agreement__c> lstAgrmntInsert = new List<Apttus__APTS_Agreement__c>();
              
       for(Apttus__APTS_Agreement__c agmnt : agmnts){ 
        if(!(agmnt.Apttus__Status_Category__c == 'In Effect' || agmnt.Apttus__Status_Category__c == 'Expired')){
        if(!(agmnt.Apttus__Status_Category__c == 'Request' && agmnt.Apttus__Status__c == 'In Amendment')){
            if(agmnt.ID != null){ agmntIds.add(agmnt.ID); }
            if(agmnt.Apttus__Account__c != null){ accountIds.add(agmnt.Apttus__Account__c);} 
            lstAgrmnt.add(agmnt);
            
            }
           }
          }
       if(agmntIds.size() > 0){ 
        signatoryList1 = [select Id, InsertSource__c,Contact__c , Account__c,Agreement__c 
                                  from Signatory__c where Agreement__c in :agmntIds];
            }
                                                                                                    
            //Insert the record into signatory                              
            Signatory__c sgu1 = new Signatory__c();
            Signatory__c sgu2 = new Signatory__c();
            Signatory__c sgu3 = new Signatory__c();
            Signatory__c sgu4 = new Signatory__c();
            Signatory__c sgu0 = new Signatory__c();
            Integer blnDel = 0;   
       
      for(Apttus__APTS_Agreement__c agUpdt : lstAgrmnt){
        if(agUpdt.Region__c != null) {blnDel = 1;} 
        
        List<Signatory__c>  singListAgmnt = new List<Signatory__c>(); 
        
        for(Signatory__c  sg : signatoryList1){
         if(sg.Agreement__c == agUpdt.Id){
            singListAgmnt.add(sg);
         }
        }
        
       for(integer j=0; j< singListAgmnt.size(); j++){
        Signatory__c s = singListAgmnt[j];
        if(agUpdt.Id == s.Agreement__c){ 
        if(j == 0){ 
        sgu0 = s; 
        if (agUpdt.Apttus__Account__c != null){
        sgu0.Account__c = agUpdt.Apttus__Account__c;
        sgu0.RecordTypeId = NDA_Agreement_SignatoryId;
        sigIds.add(s.Id); 
        if (agUpdt.Apttus__Primary_Contact__c != null){
        sgu0.Contact__c = agUpdt.Apttus__Primary_Contact__c;}
        singList.add(sgu0 );}
        }       
        if(j== 1){
        sgu1 = s; 
        if (agUpdt.Account_2__c != null){
        sgu1.Account__c = agUpdt.Account_2__c;
        sgu1.RecordTypeId = NDA_Agreement_SignatoryId;
        sigIds.add(sgu1.Id);
        if (agUpdt.Contact_2__c != null){
        sgu1.Contact__c = agUpdt.Contact_2__c;}
        singList.add(sgu1);}      
        }       
        if(j == 2){
        sgu2 = s; 
        if (agUpdt.Account_3__c != null){
        sgu2.Account__c = agUpdt.Account_3__c;
        sgu2.RecordTypeId = NDA_Agreement_SignatoryId;
        sigIds.add(sgu2.Id);
        if (agUpdt.Contact_3__c != null){
        sgu2.Contact__c = agUpdt.Contact_3__c;}
        singList.add(sgu2);}      
        }       
        if(j == 3){
        sgu3 = s;
        if (agUpdt.Account_4__c != null){
        sgu3.Account__c = agUpdt.Account_4__c;
        sgu3.RecordTypeId = NDA_Agreement_SignatoryId;
        sigIds.add(sgu3.Id);
        if (agUpdt.Contact_4__c != null){
        sgu3.Contact__c = agUpdt.Contact_4__c;} 
        singList.add(sgu3);}       
        }       
        if(j == 4){ 
        sgu4 = s;
        if (agUpdt.Account_5__c != null){
        sgu4.Account__c = agUpdt.Account_5__c;
        sgu4.RecordTypeId = NDA_Agreement_SignatoryId; 
        sigIds.add(sgu4.Id);
        if (agUpdt.Contact_5__c != null){
        sgu4.Contact__c = agUpdt.Contact_5__c;} 
        singList.add(sgu4);}
        }
       } 
      }
     }        
     for(Apttus__APTS_Agreement__c agmntIns : agmnts){
        //changes for ciphercloud - DBiswal 12122017
        Boolean cipherFlag = false;
        if(agmntIns.RecordTypeId == SAMS_Multi_RecTypeId && agmntIns.T_Purpose__c != null){
            cipherFlag = true;
        }
        Apttus__APTS_Agreement__c  oldAgmnt = AgmntsMap.get(agmntIns.Id);  
        if(agmntIns.Purpose__c != null && agmntIns.Account_2__c != null && oldAgmnt.Account_2__c == null && (agmntIns.RecordTypeId == DS_OtherParty_RecTypeId || agmntIns.RecordTypeId == OtherParty_RecTypeId || agmntIns.RecordTypeId == GN_OtherParty_RecTypeId || agmntIns.RecordTypeId == TD_OtherParty_RecTypeId  )){
               lstAgrmntInsert.add(agmntIns );} 
         if((agmntIns.Purpose__c != null || cipherFlag) && agmntIns.Account_3__c != null && oldAgmnt.Account_3__c == null){ 
            lstAgrmntInsert.add(agmntIns );} 
         if((agmntIns.Purpose__c != null || cipherFlag) && agmntIns.Account_4__c != null && oldAgmnt.Account_4__c == null){ 
            lstAgrmntInsert.add(agmntIns );} 
         if((agmntIns.Purpose__c != null || cipherFlag) && agmntIns.Account_5__c != null && oldAgmnt.Account_5__c == null){ 
            lstAgrmntInsert.add(agmntIns );} 
     }
    /// insert for Signatory
    for(Apttus__APTS_Agreement__c agInsert : lstAgrmntInsert){
            Signatory__c sa2  = new Signatory__c();
            Signatory__c sa3  = new Signatory__c();
            Signatory__c sa4  = new Signatory__c();
            Signatory__c sa5  = new Signatory__c();
            
             if(agInsert.Account_2__c != null){
                 sa2.Account__c = agInsert.Account_2__c;
                 sa2.RecordTypeId = NDA_Agreement_SignatoryId;
                 sa2.Agreement__c = agInsert.Id;         
                 updatesingListInsert.add(sa2);}
                
             if(agInsert.Account_3__c != null){
                 sa3.Account__c = agInsert.Account_3__c;
                 sa3.RecordTypeId = NDA_Agreement_SignatoryId;
                 sa3.Agreement__c = agInsert.Id; 
                 updatesingListInsert.add(sa3); }
                
             if(agInsert.Account_4__c != null){
                 sa4.Account__c = agInsert.Account_4__c;
                 sa4.RecordTypeId = NDA_Agreement_SignatoryId;
                 sa4.Agreement__c = agInsert.Id;
                 updatesingListInsert.add(sa4);}
                 
             if(agInsert.Account_5__c != null){
                 sa5.Account__c = agInsert.Account_5__c;
                 sa5.RecordTypeId = NDA_Agreement_SignatoryId;
                 sa5.Agreement__c = agInsert.Id;
                 updatesingListInsert.add(sa5);}
              }
        
       List<Signatory__c> signatoryListDel = new List<Signatory__c>();
       for(Apttus__APTS_Agreement__c agUpdt1 : lstAgrmnt){
          if(singList.size()> 1 || agUpdt1.Purpose__c != null)  {
            signatoryListDel = [SELECT Id, Contact__c , Account__c,Agreement__c 
                              FROM Signatory__c WHERE Id NOT IN :sigIds AND Agreement__c IN :agmntIds ]; 
            }}   
        try{ 
        
         if(singList.size()>0) {
             update singList; 
          }
         if(signatoryListDel.size()> 0 ){
              delete signatoryListDel;}
        
         if(updatesingListInsert.size()> 0 ){
                    insert updatesingListInsert; }
        }
        catch (Exception e){
            for(Apttus__APTS_Agreement__c a : lstAgrmnt)    {      
            a.addError('The following exception has occurred: ' + e.getMessage());} } 
          }  
    
          
    /**
    This function is implementated insert the recrod from AgreementTrigger.
    @method name: OnAfterInserAgreements
    @trigger: AgreementToSignatoryTrigger 
    @event: After Insert
    @parameter: list of the agreements
    @return : NA.
    **/   
    private void OnAfterInserAgreements(Apttus__APTS_Agreement__c[]  agmnts){
    
        //loop through all the agreements and collect the necessary lists 
           List<String> agmntIds = new List<String>();  
           List<String> accountIds = new List<String>();         
           Map<String,Signatory__c> sigIdMap = new Map<String,Signatory__c>();
           List<Signatory__c>  singList = new List<Signatory__c>();  
           List<Signatory__c>  singList1 = new List<Signatory__c>();  
           List<Signatory__c>  updatesingListInsert = new List<Signatory__c>();        
           List<Apttus__APTS_Agreement__c> lstAgrmnt = new List<Apttus__APTS_Agreement__c>();
           List<Apttus__APTS_Agreement__c> lstAgrmntInsert = new List<Apttus__APTS_Agreement__c>();
   
       // Dont create the record if the status in Amendment        
        for(Apttus__APTS_Agreement__c agmnt : agmnts){
           if(!(agmnt.Apttus__Status_Category__c == 'Request' && agmnt.Apttus__Status__c == 'In Amendment') || (agmnt.Apttus__Status_Category__c == 'In Effect') || (agmnt.Apttus__Status_Category__c == 'Expired'))
           { 
           if(agmnt.ID != null){ agmntIds.add(agmnt.ID); }
           if(agmnt.Apttus__Account__c != null){  accountIds.add(agmnt.Apttus__Account__c);}       
           lstAgrmnt.add(agmnt); }

       Signatory__c sg = new Signatory__c();
       Signatory__c sg1 = new Signatory__c();
       Signatory__c sg2 = new Signatory__c();
       Signatory__c sg3 = new Signatory__c();
       Signatory__c sg4 = new Signatory__c();
      List<Signatory__c> signatoryList = [select Id, Contact__c , Account__c,Agreement__c 
                              from Signatory__c where Agreement__c in :agmntIds]; 
   
    for(Signatory__c s: signatoryList){
         sigIdMap.put(s.Agreement__c + '_'+s.Account__c,s);} 
    
    if(signatoryList.size()==  0 ){
    
        for(Apttus__APTS_Agreement__c ag :  lstAgrmnt){                                
              if(ag.RecordTypeId == RecTypeId || ag.RecordTypeId == Multi_RecTypeId || ag.RecordTypeId == OtherParty_RecTypeId ||
                                   ag.RecordTypeId == DS_RecTypeId || ag.RecordTypeId == DS_Multi_RecTypeId || ag.RecordTypeId == DS_OtherParty_RecTypeId ||
                                   ag.RecordTypeId == GN_RecTypeId || ag.RecordTypeId == GN_Multi_RecTypeId || ag.RecordTypeId == GN_OtherParty_RecTypeId || 
                                   ag.RecordTypeId == TD_RecTypeId || ag.RecordTypeId == TD_Multi_RecTypeId || ag.RecordTypeId == TD_OtherParty_RecTypeId || 
                                   ag.RecordTypeId == SAMS_RecTypeId || ag.RecordTypeId == SAMS_Multi_RecTypeId){
   
                System.debug('Mapping process Insert ' + sigIdMap.get(ag.id + '_' + ag.Apttus__Account__c));
                
                if(sigIdMap.get(ag.id + '_' + ag.Apttus__Account__c)==null){                
                    if(ag.Apttus__Account__c != null){sg.Account__c = ag.Apttus__Account__c;sg.RecordTypeId = NDA_Agreement_SignatoryId;}
                    if(ag.Apttus__Primary_Contact__c != null){sg.Contact__c = ag.Apttus__Primary_Contact__c;}
                    if(ag.ID != null) {sg.Agreement__c = ag.ID;}               
                    singList1.add(sg);   
                  }
                if(ag.RecordTypeId == Multi_RecTypeId || ag.RecordTypeId == OtherParty_RecTypeId || 
                                ag.RecordTypeId == DS_Multi_RecTypeId || ag.RecordTypeId == DS_OtherParty_RecTypeId ||
                                ag.RecordTypeId == GN_Multi_RecTypeId || ag.RecordTypeId == GN_OtherParty_RecTypeId || 
                                ag.RecordTypeId == TD_Multi_RecTypeId || ag.RecordTypeId == TD_OtherParty_RecTypeId || 
                                ag.RecordTypeId == SAMS_Multi_RecTypeId){   
     
                    sg1.RecordTypeId = NDA_Agreement_SignatoryId;
                    if(ag.ID != null) {sg1.Agreement__c = ag.ID;}                                            
                    singList1.add(sg1);   
                    sg2.RecordTypeId = NDA_Agreement_SignatoryId;
                    if(ag.ID != null) {sg2.Agreement__c = ag.ID;}   
                    singList1.add(sg2);
                    sg3.RecordTypeId = NDA_Agreement_SignatoryId;
                    if(ag.ID != null) {sg3.Agreement__c = ag.ID;}      
                    singList1.add(sg3);    
                    sg4.RecordTypeId = NDA_Agreement_SignatoryId;
                    if(ag.ID != null) {sg4.Agreement__c = ag.ID;}  
                    singList1.add(sg4);  
                    }
                   }
                  }
                 }
          try{
           if(singList1.size() > 0 && Trigger.isInsert){ 
             insert singList1;} 
           }
         catch (Exception e){
        for(Apttus__APTS_Agreement__c a : lstAgrmnt){      
            a.addError('The following exception has occurred: ' + e.getMessage());}  
         }        
       }
     }   
     
     /**
    This function is implementated select the Geometries from AgreementTrigger.
    @method name: UpdateAgreementTechGeos
    @trigger: AgreementToSignatoryTrigger 
    @event: Before Insert
    @parameter: list of the agreements
    @return : NA.
    **/   
     
    private void  UpdateAgreementTechGeos(Apttus__APTS_Agreement__c[] agmnts ){

       for(Apttus__APTS_Agreement__c agmnt : agmnts ){
            if(agmnt.Does_NDA_Cover_All_Geometries__c == 'Yes' && agmnt.Geometries__c == null){      
                       Schema.DescribeFieldResult fieldResult = Agreement_Geometries__c.Geometries__c.getDescribe();
                       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                         list<SelectOption> options = new list<SelectOption>();
                         Set<string> originalvalues = new Set<string>();     
                         string selectedvalue=''; 
                         for (Schema.PicklistEntry a : ple){ 
                             options.add(new SelectOption(a.getLabel(), a.getValue())); 
                             originalvalues.add(a.getValue());
                            }
                         for(integer i=0;i<options.size();i++) {           
                          if(i==0)               
                            selectedvalue = options[i].getValue();            
                        else               
                            selectedvalue += ';'+options[i].getValue();
                         }                      
                       if( selectedvalue != '' || selectedvalue != null){
                         agmnt.Geometries__c = selectedvalue;}
                        
                        System.debug('Option values' + options);
                        System.debug('Selected values' + selectedvalue);
                      }    
                   }
                }
             }