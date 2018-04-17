/*
* @ Author :- Navneet Rajput
* @ Company :- CTS
* @ Date  :- 18/11/2014
* @ Description :- Utility class hanldes all provisioning logic oof PDK,Package, Specs
* @ Change History :- 
**/

public without sharing class FV_DocumentProvisioningUtil {
    
    /* 
    * @ Author :- Navneet Rajput
    * @ Company :- CTS
    * @ Date  :- 18/11/2014
    * @ Description :- Method help to provision pdk at account level ,when bundle is created and provision at firt time
                      also, it will help user to provision if bundle is of type white list and account is added after provision 
                      is done for bundle. In this case newly added bundle will be get auto provisioned. 
    * @ Change History :- 
    **/

    public static void provisionNewPDK (Sub_PDK__c subpdk,List<Account> lstOfSelectedAccounts){
        //Map holds white list specs (spec release status) records. 
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        // Map holds specs which doesnt have release status as white list
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        // Map holds ids of sub pdk associations which is junction between SubPDk and DesignSpecs. 
        Map<Id,Sub_PDK_Spec__c> specAssociationMap = new Map<Id,Sub_PDK_Spec__c>();
        // Below map will be hold id as spec and set of account ids which are related to that perticular spec
        Map<Id,Set<Id>> wlSpecAccMap = new Map<Id,Set<Id>>();
        // list will be used for mass provision of document provisioning records
        List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
        // Below status field will identify type of bundle whether it is white list or specific account release or internal release or general release
        // or specific account release with account owner required permission
        String pdkStatus = subpdk.Release_Status__c!=Null ? subpdk.Release_Status__c :'';
        // Below string will hold information of already provisioned account with comma seperated values
        String accAlreadyProNames = '';
        Id docProPDKRtype;
        if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName()<>NULL){
            if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('PDK Record Type')<>NULL){
                docProPDKRtype = Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('PDK Record Type').getRecordTypeId();
            }   
        }  
        
        try{
            for(Sub_PDK_Spec__c  pdkSpec : [SELECT  id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM    Sub_PDK_Spec__c
                                            WHERE   Sub_PDK__c = : subpdk.Id
                                            AND     Design_Spec__r.Release_Status__c!='General Release'
                                            AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                            AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                            AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']) {
            
                system.debug('pdkSpec>>>>>>>>>>>>>> '+ pdkSpec);
                if(pdkSpec<>NULL){    
                    if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                        system.debug('Inside If WhiteList Specs >>>>>>>>>');
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!whiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                // prepare whitelist spec map
                                whiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            }
                        }
                        
                    } else {
                        system.debug('Inside Else>>>>>>..Before >>>>>>>'+nonWhiteListSpecs);
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!nonWhiteListSpecs.containsKey(pdkSpec.Design_Spec__c)){
                                // prepare non white list map
                                nonWhiteListSpecs.put(pdkSpec.Design_Spec__c,pdkSpec);
                            }
                        }
                        system.debug('Inside Else>>>>>>..After >>>>>>>'+nonWhiteListSpecs);
                        system.debug('specAssociationMap>>>>>>>>>>'+specAssociationMap);
                    }   
                }                                               
            } // END OF FOR LOOP
            //prepare Map of spec as key and list of white list accounts associated with that spec  
            if(whiteListSpecs<>NULL && !whiteListSpecs.isEmpty()){
                for(White_List__c wl : [Select Id,Design_Spec__c,Account__c 
                                        From White_List__c 
                                        where Design_Spec__c IN : whiteListSpecs.keySet()]){
                                            
                    system.debug('White List ### '+wl);                     
                    if(wl<>Null){                       
                        if (!wlSpecAccMap.containsKey(wl.Design_Spec__c)){
                            wlSpecAccMap.put(wl.Design_Spec__c, new Set<Id>());
                        } //else {
                            // prepare map of design spec and list of account associated with that spec
                            // it will help to identify user while account level provisioning and if that selected account 
                            // is available in white list of this map then this spec will be send to OT for provisioning else it will not be send to OT for provisioning
                            wlSpecAccMap.get(wl.Design_Spec__c).add(wl.Account__c);
                        //}
                    }
                } 
            }
            system.debug('wlSpecAccMap>>>>>>>>>>>>>>>>>> '+wlSpecAccMap);
            // List of selected account send for provisioning from UI
            if (lstOfSelectedAccounts<>Null && !lstOfSelectedAccounts.isEmpty()){
                for (Account acc : lstOfSelectedAccounts){
                    String specs = '';
                    String subPdkSpecs = '';
                    String pdkAssociations = '';
                    String specName = '';
                    Document_Provisioning__c DP = new Document_Provisioning__c();
                    if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                        for (Id specId : whiteListSpecs.keySet()){
                            if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(specId) && 
                                wlSpecAccMap.get(specId).contains(acc.Id)){
                                // Add spec id to dp design spec
                                //if(whiteListSpecs.containsKey(specId)){ 
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        //specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;    
                                        else 
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if (whiteListSpecs.get(specId).OTID__c!=NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get

(specId).OTID__c; 
                                        else 
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                            }
                        } // End of whitelist for loop
                    } 
                       
                    if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){    
                        system.debug('Inside nonWhiteListSpecs>>>>>>>>');
                        for (Id specId : nonWhiteListSpecs.keySet()){
                            if (specs ==''){
                                if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                    system.debug('Specs before >>>>>>>>>>>'+nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                    if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                        specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                    else 
                                        specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                        system.debug('Specs After>>>>>>>>..'+specs);
                                }
                            } else {
                                if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                    if (nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                        specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get

(specId).OTID__c;
                                    else 
                                        specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';  
                                }
                            }
                        } // End of nonWhiteListSpec for loop
                    }
                    system.debug('specs>>>>>>>>>>'+specs);
/*----------------------PDK Specs to send to OT will be NONE instead of empty---------------------------------------*/                    
                    if (String.isBlank(specs)){
                        DP.PdkSpecs__c = 'NONE'; 
                    }
                    system.debug('specs>>>>>>>>>>'+specs);
/*----------------------PDK Specs to send to OT will be NONE instead of empty---------------------------------------*/   
                    
                    if (!String.isBlank(specs)){
                        DP.PdkSpecs__c = specs; 
                    }
                    if(pdkStatus!='' && pdkStatus.equalsIgnoreCase('Specific Account Release with Spec owner Approval')){
                        DP.Status__c = 'Sent For Approval';
                    } else if(pdkStatus!='Internal Use only') {
                        DP.Status__c = 'Provisioning In Progress';
                    }
                    DP.Acc_Short_Name__c = acc.Short_Name__c;
                    DP.AccountID__c = acc.Id;
                    DP.Sub_PDK__c = subpdk.Id;// We need to Send Sub_PDK_OpenText_Id__c formula field in Outbound message
                    // Prepared list of DP 
                    if(docProPDKRtype<>NULL){
                        DP.recordTypeId = docProPDKRtype;
                    }
                    lstOfDP.add(DP);
                } // End of Account iterator for loop
                system.debug('lstOfDP >>>>>>> ###### '+lstOfDP);
                if(lstOfDP<>Null && !lstOfDP.isEmpty()){
                    insert lstOfDP;
                }
            }
            
        } catch (Exception e){
            system.debug('Exception e :: '+e.getMessage());
        }
    }

    /*
    * @ Author :- Navneet Rajput
    * @ Company :- CTS
    * @ Date  :- 20/11/2014
    * @ Description :- Method help to provision pdk at account level ,when bundle is updated and added new records for provisioning.
                      if bundle is already provisioned and user has updated bundle and selected new spec and save the record then 
                      only selected records will be send to OT for provisioning.     
    * @ Change History :- 
    **/
    
     public static boolean updatePdkProvisioning(List<Sub_PDK_Spec__c> listOfSubPdkSpecs){
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Set<Id> setOfPDKIds = new Set<Id>();
        Set<Id> setOfWLDesignSpecIds = new Set<Id>();
        Map<Id,Set<Id>> wlSpecAccMap = new Map<Id,Set<Id>>();
        Map<Id,String> nonwlSpecOTMap=new Map<Id,String>();
        List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
        Boolean isTrue = false;
        for (Sub_PDK_Spec__c pdkSpec : [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                        FROM    Sub_PDK_Spec__c
                                        WHERE   //Sub_PDK__c = : subpdk.Id AND
                                        Id IN : listOfSubPdkSpecs
                                        AND     Design_Spec__r.Release_Status__c!='General Release'
                                        AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                        AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                        AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']){
                                                                         
            if(pdkSpec<>NULL){
                if(pdkSpec.Sub_PDK__c!=null)
                    setOfPDKIds.add(pdkSpec.Sub_PDK__c);
                if (pdkSpec.Design_Spec__r.Release_Status__c!='Internal Use Only' && pdkSpec.Design_Spec__r.Release_Status__c!='Stepper Tooling Forms'
                    && pdkSpec.Design_Spec__r.Release_Status__c!='Reticle Grade Table' && pdkSpec.Design_Spec__r.Release_Status__c!='Stepper Tooling Forms'){
                    
                    if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!whiteListSpecs.containsKey(pdkSpec.id)){
                                whiteListSpecs.put(pdkSpec.id,pdkSpec);
                            }
                            setOfWLDesignSpecIds.add(pdkSpec.Design_Spec__c);
                        }
                        
                    } else {
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!nonWhiteListSpecs.containsKey(pdkSpec.id)){
                                nonWhiteListSpecs.put(pdkSpec.id,pdkSpec);
                                nonwlSpecOTMap.put(pdkSpec.id,pdkSpec.OTID__c);
                            }
                        }
                    }   
                }
            } 
        } // END OF for loop
        system.debug('nonWhiteListSpecs>>>>>>>>>>>>>>>>'+nonWhiteListSpecs);
        system.debug('whiteListSpecs>>>>>>>>>>>>>>>>>>'+whiteListSpecs);
        //prepare Map of spec as key and list of white list accounts associated with that spec  
        if(setOfWLDesignSpecIds<>NULL && !setOfWLDesignSpecIds.isEmpty()){
            for(White_List__c wl : [Select Id,Design_Spec__c,Account__c 
                                    From White_List__c 
                                    where Design_Spec__c IN : setOfWLDesignSpecIds]){
                                        
                system.debug('White List ### '+wl);                     
                if(wl<>Null){                       
                    if (!wlSpecAccMap.containsKey(wl.Design_Spec__c)){
                        wlSpecAccMap.put(wl.Design_Spec__c, new Set<Id>());
                    } //else {
                        wlSpecAccMap.get(wl.Design_Spec__c).add(wl.Account__c);
                    //}
                }
            } 
        }
        
        system.debug('wlSpecAccMap>>>>>>>>>>>>>>>>>>'+wlSpecAccMap);
        // Get accounts from subpdk 
        for(Document_Provisioning__c dp : [SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,Pdk_Specs_DeProvisioned__c,Sub_PDK__c,
                                                    Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,isProvUpdate__c,isDeProUpdate__c 
                                            FROM    Document_Provisioning__c WHERE Sub_PDK__c IN: setOfPDKIds 
                                            AND     Status__c = 'Provisioned']){
            
            String specs = '';
            String subPdkSpecs = '';
            String pdkAssociations = '';
            String specName = '';
            if (dp<>NULL){
                system.debug('Document Provisioning Record >>>>>>>>>>>.'+dp);
               // dp.isProvUpdate__c = true;
               /* if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                        if(wlSpecAccMap<>Null && wlSpecAccMap.containskey(whiteListSpecs.get(specId).Design_Spec__c) && 
                            wlSpecAccMap.get(whiteListSpecs.get(specId).Design_Spec__c).contains(dp.AccountID__c) && whiteListSpecs.get(specId).Sub_PDK__c == dp.Sub_PDK__c){
                            system.debug('White List Condition Satisfied >>>>>>>'); 
                            // Add spec id to dp design spec
                            if(whiteListSpecs.containsKey(specId)){
                                system.debug('white list contais Spec '); 
                                if(specs==''){
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                            } //END OF WHITELIST SPEC IF BLOCK
                        }
                    } // End of whitelist for loop
                }// end of whitelist if*/
                system.debug('End of White List Spec !!!!!!!!!!!!!'+specs);
                if(nonWhiteListSpecs<>Null && !nonWhiteListSpecs.isEmpty()){
                    system.debug('Noe white list specs !!!!!!!!!!!!!');    
                    for (Id specId : nonWhiteListSpecs.keySet()){
                    if(nonWhiteListSpecs.get(specId).Sub_PDK__c == dp.Sub_PDK__c){
/*------------------------------------------------------------------------------------------------*/
                    
                           //no change 
                           dp.isProvUpdate__c = true;
                           system.debug('yes change >>>>>.');
 
                                system.debug('white list contais Spec '); 
                                if(specs==''){
                                
                                system.debug('if  else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                 system.debug('else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs +';'+String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = specs +';'+String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                          
                         }//end of else
/*---------------------------------------------------------------------------------------------------*/                    
                      /*  if(nonWhiteListSpecs.get(specId).Sub_PDK__c == dp.Sub_PDK__c){
                            if (specs ==''){
                                if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                    system.debug('Specs before >>>>>>>>>>>'+nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c);
                                    if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                        specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                    else
                                        specs = String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE'; 
                                        system.debug('Specs After>>>>>>>>..'+specs);
                                }
                            } else {
                                if(!String.isBlank(String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                    if(nonWhiteListSpecs.get(specId).OTID__c<>NULL)
                                        specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+nonWhiteListSpecs.get(specId).OTID__c;
                                    else    
                                        specs = specs+';'+ String.valueOf(nonWhiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                }
                            }
                        }  */   
                    } // End of nonWhiteListSpec for loop
                }// End of non white list if
                system.debug('specs>>>>>>>>>>>>>>>>>'+specs);
                if (!String.isBlank(specs)){
                    if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL){
                        DP.PDK_Provisoin_To_Updated_Specs__c = DP.PDK_Provisoin_To_Updated_Specs__c +';'+specs;
                    } else {
                        DP.PDK_Provisoin_To_Updated_Specs__c = specs;
                    }
                }
                //DP.Sync_With_OpenText__c = false;
                lstOfDP.add(DP);
            }          
        }//End of Document provisioning lilstOfDP >>>>>>>>>>>>>>>st iterator for loop
        if (lstOfDP<>NULL && !lstOfDP.isEmpty()){
            isTrue = true;
            update lstOfDP; 
        } 
        return isTrue;
    }//END OF updatePdkProvisioning
 /*---------------------------------plm--------------------------------------------------------------*/
       public static boolean updatePdkProvisioningforWL(List<Sub_PDK_Spec__c> listOfSubPdkSpecs){
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Set<Id> setOfPdkIds = new Set<Id>();
        Map<Id,String> wlSpecAccMap = new Map<Id,String>();
        Map<Id,List<String>> MapOfDsandAccList=new Map<Id,List<String>>();
        List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
        List<String> accList = new List<String>();
        Boolean isTrue = false;
        for (Sub_PDK_Spec__c pdkSpec : [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                

Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Specification_Release_List_long__c,Design_Spec__r.Document_Title__c
                                        FROM    Sub_PDK_Spec__c
                                        WHERE   //Sub_PDK__c = : subpdk.Id AND
                                                Id IN : listOfSubPdkSpecs
                                        AND     Design_Spec__r.Release_Status__c!='General Release'
                                        AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                        AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                        AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']){
                                                                         
            if(pdkSpec<>NULL){
                system.debug('pdkSpec >>>>>>>>>>>>>>>>>>');
                if(pdkSpec.Sub_PDK__c <>NULL)
                    setOfPdkIds.add(pdkSpec.Sub_PDK__c);
                  if (pdkSpec.Design_Spec__r.Release_Status__c!=null && pdkSpec.Design_Spec__c!=null)
                  {
                    if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!whiteListSpecs.containsKey(pdkSpec.id)){
                                whiteListSpecs.put(pdkSpec.id,pdkSpec);
                                wlSpecAccMap.put(pdkSpec.Design_Spec__c,pdkSpec.Design_Spec__r.Specification_Release_List_long__c);
                            }
                        }
                        
                    } 
                }
            } 
        } // END OF for loop
        
        List<Design_Spec__c> lstDS=[Select  id,Specification_Release_List_Long__c 
                                            from Design_Spec__c where id IN :wlSpecAccMap.keyset()];
        for(Design_Spec__c objDS: lstDS){
          accList = new List<String>();
           if(objDS.Specification_Release_List_Long__c!=null){ // CR # 4562 ? Field replaced
                if(objDS.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    accList.add(objDS.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                }
                
                MapOfDsandAccList.put(objDS.Id,accList);
            }
            }
     /*--------------------------------plm----------------------------------------------------------------------*/
        for(Document_Provisioning__c dp : [SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,Pdk_Specs_DeProvisioned__c,
                                                    Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,isProvUpdate__c,isDeProUpdate__c,Sub_PDK__c
                                            FROM    Document_Provisioning__c where Sub_PDK__c IN: setOfPdkIds
                                            AND     Status__c = 'Provisioned']){
            
            String specs = '';
            String specstoDeprov='';
            String subPdkSpecs = '';
            String pdkAssociations = '';
            String specName = '';
            if (dp<>NULL){
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                    for (Id specId : whiteListSpecs.keySet()){
                     
                     if(MapOfDsandAccList<>null && MapOfDsandAccList.containskey(whiteListSpecs.get(specId).Design_Spec__c) && whiteListSpecs.get

(specId).Sub_PDK__c==dp.Sub_PDK__c)
                    {
                    system.debug('MapOfDsandAccList>>>>'+MapOfDsandAccList);
                    for(String acc :MapOfDsandAccList.get(whiteListSpecs.get(specId).Design_Spec__c))
                    {
                    system.debug('acc >>>>'+acc);
                    if(acc==dp.AccountID__r.Short_Name__c)
                    {
                            dp.isProvUpdate__c = true;

 
                            // Add spec id to dp design spec
                            if(whiteListSpecs.containsKey(specId)){
                                system.debug('white list contais Spec '); 
                                if(specs==''){
                                
                                system.debug('if  else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                 system.debug('else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get

(specId).OTID__c;
                                        else
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                            } //END OF WHITELIST SPEC IF BLOCK
                        
                        
                       } 
                       }
                       }
                    
                }// end of whitelist if
              
              }  
/*---------------------------------plm--------------------------------------------*/              
              if (!String.isBlank(specs)){
                   
                    if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL){
                        DP.PDK_Provisoin_To_Updated_Specs__c = DP.PDK_Provisoin_To_Updated_Specs__c +';'+specs;
                       
                    } else {
                        DP.PDK_Provisoin_To_Updated_Specs__c = specs;
                       
                    }
                }
                if (!String.isBlank(specstoDeprov)){
                   
                    if(DP.Pdk_Specs_DeProvisioned__c<>NULL){
                        DP.Pdk_Specs_DeProvisioned__c = DP.Pdk_Specs_DeProvisioned__c +';'+specstoDeprov;
                       
                    } else {
                        DP.Pdk_Specs_DeProvisioned__c = specstoDeprov;
                       
                    }
                }
                system.debug('lstOfDP dppp>>>>>>>>>>>>>>>>> '+DP);
                lstOfDP.add(DP);
            }          
        }//End of Document provisioning lilstOfDP >>>>>>>>>>>>>>>st iterator for loop
        system.debug('lstOfDP >>>>>>>>>>>>>>>>> '+lstOfDP);
        if (lstOfDP<>NULL && !lstOfDP.isEmpty()){
            isTrue = true;
            update lstOfDP; 
        } 
        return isTrue;
    }//END OF updatePdkProvisioning
    

 /*-------------------------------------plm----------------------------------------------------------------*/   
 
  public static boolean updatePdkProvisioningforWLnoChange(List<Sub_PDK_Spec__c> listOfSubPdkSpecs){
        Map<Id,Sub_PDK_Spec__c> whiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Map<Id,Sub_PDK_Spec__c> nonWhiteListSpecs = new Map<Id,Sub_PDK_Spec__c>();
        Set<Id> setOfPdkIds = new Set<Id>();
        Map<Id,Id> WhiteListSpecsandPDK = new Map<Id,Id>();//plm
        Map<Id,String> wlSpecAccMap =new Map<Id,String>();
        Map<Id,String> wlSpecOTMap=new Map<Id,String>();
        Map<Id,List<String>> MapOfDsandAccList =new Map<Id,List<String>>();
        Map<Id,Set<String>> MapOfDsandAccSet=new Map<Id,Set<String>>();
         List<String> accList = new List<String>();
         Set<String> accSet = new Set<String>();
        List<Document_Provisioning__c> lstOfDP = new List<Document_Provisioning__c>();
        Boolean isTrue = false;
        for (Sub_PDK_Spec__c pdkSpec : [SELECT 

Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,Design_Spec__r.Specification_Release_List_long__c,
                                                Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                        FROM    Sub_PDK_Spec__c
                                         WHERE   //Sub_PDK__c = : subpdk.Id AND
                                                Id IN : listOfSubPdkSpecs
                                        AND     Design_Spec__r.Release_Status__c!='General Release'
                                        AND     Design_Spec__r.Release_Status__c!='Internal Use Only'
                                        AND     Design_Spec__r.Specification_Type__c!='Stepper Tooling Forms'
                                        AND     Design_Spec__r.Specification_Type__c!='Reticle Grade Table']){                             
            if(pdkSpec<>NULL){
                system.debug('pdkSpec >>>>>>>>>>>>>>>>>>');
                if(pdkSpec.Sub_PDK__c <>NULL)
                    setOfPdkIds.add(pdkSpec.Sub_PDK__c);
                  if (pdkSpec.Design_Spec__r.Release_Status__c!=null && pdkSpec.Design_Spec__c!=null)
                  {
                    if (pdkSpec.Design_Spec__r.Release_Status__c.toLowerCase().contains('white list')){
                        if(pdkSpec.Design_Spec__r.OpenText_ID__c!=Null){
                            if(!whiteListSpecs.containsKey(pdkSpec.id)){
                                whiteListSpecs.put(pdkSpec.id,pdkSpec);
                                wlSpecAccMap.put(pdkSpec.Design_Spec__c,pdkSpec.Design_Spec__r.Specification_Release_List_long__c);
                                wlSpecOTMap.put(pdkSpec.id,pdkSpec.OTID__c);
                            }
                        }
                        
                    } 
                }
            } 
        } // END OF for loop
        List<Design_Spec__c> lstDS=[Select  id,Specification_Release_List_Long__c 
                                            from Design_Spec__c where id IN :wlSpecAccMap.keyset()];
        for(Design_Spec__c objDS: lstDS){
          accList = new List<String>();
          accSet=new Set<String>();
           if(objDS.Specification_Release_List_Long__c!=null){ // CR # 4562 ? Field replaced
                if(objDS.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                    accSet.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    
                    accList.add(objDS.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                    accSet.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }
                
                MapOfDsandAccList.put(objDS.Id,accList);
                MapOfDsandAccSet.put(objDS.Id,accSet);
            }
            }
         
/*--------------------------------plm----------------------------------------------------------------------*/
        for(Document_Provisioning__c dp : [SELECT Id,Status__c,AccountID__c,AccountID__r.Short_Name__c,PdkSpecs__c,Pdk_Specs_DeProvisioned__c,
                                                    Sync_With_OpenText__c,PDK_Provisoin_To_Updated_Specs__c,isProvUpdate__c,isDeProUpdate__c,Sub_PDK__c
                                            FROM    Document_Provisioning__c WHERE Sub_PDK__c IN: setOfPdkIds
                                            AND     Status__c = 'Provisioned']){
            
            String specs = '';
            String specstoDeprov='';
            String subPdkSpecs = '';
            String pdkAssociations = '';
            String specName = '';
            if (dp<>NULL){
                system.debug('Document Provisioning Record >>>>>>>>>>>.'+dp);
               // dp.isProvUpdate__c = true;
                //DP.isDeProUpdate__c = false;
                boolean samespec =false;
                if(whiteListSpecs<>Null && !whiteListSpecs.isEmpty()){
                   for (Id specId : whiteListSpecs.keySet())
                    {
                     
                    system.debug('for spec id>>>>');
                    if(MapOfDsandAccList<>null && MapOfDsandAccList.containskey(whiteListSpecs.get(specId).Design_Spec__c) && whiteListSpecs.get(specId).Sub_PDK__c == dp.Sub_PDK__c)
                    {
                    system.debug('MapOfDsandAccList>>>>'+MapOfDsandAccList);
                    if(MapOfDsandAccSet.get(whiteListSpecs.get(specId).Design_Spec__c).contains(dp.AccountID__r.Short_Name__c))
                    {
                    for(String acc :MapOfDsandAccList.get(whiteListSpecs.get(specId).Design_Spec__c))
                    {
                    system.debug('acc >>>>'+acc);
                    if(acc==dp.AccountID__r.Short_Name__c)
                    {
                      
                        /*if(wlSpecOTMap!=Null && dp.PdkSpecs__c!=null && wlSpecOTMap.containskey(specId) && wlSpecOTMap.get(specId)!=null && dp.PdkSpecs__c.contains(wlSpecOTMap.get(specId))){
                           //no change 
                           
                           system.debug('no change >>>>>.');
                       } */
                       //else 
                          //  {
                           //no change 
                           dp.isProvUpdate__c = true;
                           system.debug('yes change >>>>>.');
 
                            // Add spec id to dp design spec
                            if(whiteListSpecs.containsKey(specId)){
                                system.debug('white list contais Spec '); 
                                if(specs==''){
                                
                                system.debug('if  else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specs = String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                 system.debug('else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get

(specId).OTID__c;
                                        else
                                            specs = specs +';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                            } //END OF WHITELIST SPEC IF BLOCK
                        // }//end of else
                         }
                        }  
                       } 
                       else 
                       
                       {
                        system.debug('White List Condition not Satisfied >>>>>>>'); 
                       //dp.isProvUpdate__c = true;
                       DP.isDeProUpdate__c = true;
 
                        if(whiteListSpecs.containsKey(specId))
                        {
                         system.debug('white list contais Spec '); 
                                if(specstoDeprov==''){
                                
                                system.debug('if  else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specstoDeprov= String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get

(specId).OTID__c;
                                        else
                                            specstoDeprov= String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }
                                } else {
                                 system.debug('else>>>>>'); 
                                    if(!String.isBlank(String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c))){
                                        if(whiteListSpecs.get(specId).OTID__c<>NULL)
                                            specstoDeprov= specstoDeprov+';'+String.valueOf(whiteListSpecs.get

(specId).Design_Spec__r.OpenText_ID__c)+':'+whiteListSpecs.get(specId).OTID__c;
                                        else
                                            specstoDeprov= specstoDeprov+';'+String.valueOf(whiteListSpecs.get(specId).Design_Spec__r.OpenText_ID__c)+':'+'NONE';
                                    }   
                                }
                        
                        }
                       
                       }
                       
                    }//acclist for
                   
                }//spec id for
              
              }  // end of whitelist if
/*---------------------------------plm--------------------------------------------*/              
              

                system.debug('specs>>>>>>>>>>>>>>>>>'+specstoDeprov);
                if (!String.isBlank(specs)){
                
                system.debug('!String.isBlank(specs');
                   
                    if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL){
                        DP.PDK_Provisoin_To_Updated_Specs__c = DP.PDK_Provisoin_To_Updated_Specs__c +';'+specs;
                       
                    } else {
                        DP.PDK_Provisoin_To_Updated_Specs__c = specs;
                       
                    }
                }
                
                 if (!String.isBlank(specstoDeprov) && samespec==false){
                  system.debug('specstoDeprov&&&'); 
                    if(DP.Pdk_Specs_DeProvisioned__c<>NULL){
                        DP.Pdk_Specs_DeProvisioned__c = DP.Pdk_Specs_DeProvisioned__c +';'+specstoDeprov;
                       
                    } else {
                        DP.Pdk_Specs_DeProvisioned__c = specstoDeprov;
                       
                    }
                }
                lstOfDP.add(DP);
            }          
        }//End of Document provisioning lilstOfDP >>>>>>>>>>>>>>>st iterator for loop
        system.debug('lstOfDP >>>>>>>>>>>>>>>>> '+lstOfDP);
        if (lstOfDP<>NULL && !lstOfDP.isEmpty()){
            isTrue = true;
            update lstOfDP; 
        } 
        return isTrue;
    }//END OF updatePdkProvisioning
    
 /*-------------------------------------plm----------------------------------------------------------------*/    

    /*
    * @ Author :- Navneet Rajput
    * @ Company :- CTS
    * @ Date  :- 15/11/2014
    * @ Description :- Method will help to deprovision accounts when it is removed from white list of PDK bundle 
                        or user explicitly click on deprovision button  
    * @ Param :- subPdkId (bundle id)
                 List<AccountIds> (list of account ids selected from front end)                  
    * @ Change History :- 
    **/
    
    public static boolean deprovisionPDK(Id subpdkid,List<ID> accList){ 
        system.debug('Inside whiteListToSendForDeprovision>>>>>>>>>>>>>>>>');
        List<Document_Provisioning__c> lstOfDpToDeprovision = new List<Document_Provisioning__c>();
        Boolean isTrue = false;
        Map <Id,Set<String>> accPdkOtIdMap = new Map<Id,Set<String>>();
         List<Document_Provisioning__c> listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c
                                                            FROM Document_Provisioning__c
                                                            WHERE Status__c = 'Provisioned'
                                                            AND AccountID__c IN : accList
                                                            AND Sub_PDK__c =:subpdkid];
        system.debug('listOfDpRecords >>>>>>>>'+listOfDpRecords);
        if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for(Document_Provisioning__c DP : listOfDpRecords){
                if (!accPdkOtIdMap.containsKey(DP.AccountID__c)){
                  accPdkOtIdMap.put(DP.AccountID__c, new Set<String>());
                } else {
                    system.debug('DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c >>>>>>'+DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c);
                    if(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c<>NULL)
                        accPdkOtIdMap.get(DP.AccountID__c).add(String.valueOf(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c));
                }
            }
        }
        try {
            if (accList<>NULL && !accList.isEmpty()){
                for (Document_Provisioning__c DP : [SELECT Id,Status__c,AccountID__c,Bundle_OT_ID__c,
                                                            Pdk_Specs_DeProvisioned__c,Sync_With_OpenText__c,
                                                            PdkSpecs__c,PDK_Associations__c,is_De_Prov_From_UI__c
                                                    FROM Document_Provisioning__c 
                                                    WHERE Sub_PDK__c =: subpdkid 
                                                    AND Status__c = 'Provisioned' 
                                                    AND AccountID__c IN : accList]){
                    if(DP<>NULL){                                   
                        String bundleOtIds = '';
                        DP.Status__c = 'De-Provisioning In Progress';
                        DP.PdkSpecs__c = 'NONE'; 
                        if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){
                           dp.is_De_Prov_From_UI__c=true;   
                        }
                        //DP.Sync_With_OpenText__c = false;
                        //DP.Pdk_Specs_DeProvisioned__c = DP.PdkSpecs__c;
                        //DP.PdkSpecs__c ='';
                        if (accPdkOtIdMap<>NULL && accPdkOtIdMap.containsKey(DP.AccountID__c)){
                            for(String str : accPdkOtIdMap.get(DP.AccountID__c)){
                                if(str<>NULL && str!=''){
                                    if (bundleOtIds==''){
                                        bundleOtIds = str;
                                    } else {
                                        bundleOtIds = bundleOtIds+';'+str;
                                    }
                                }   
                            }
                        }
                        if(!String.isBlank(bundleOtIds)){
                            DP.Bundle_OT_ID__c = bundleOtIds;   
                        }
                        lstOfDpToDeprovision.add(DP);
                    }                    
                }                       
            }
            system.debug('lstOfDpToDeprovision>>>>>>>>>>>'+lstOfDpToDeprovision);
            if (lstOfDpToDeprovision<>NULL && !lstOfDpToDeprovision.isEmpty()){
                isTrue = true;
                update lstOfDpToDeprovision;
            }
        } catch (Exception e){
            system.debug('Exception ::  '+e.getMessage());
        }
        return isTrue;
    }
// Prajnith 
    public static boolean deprovisionPDKBulk(set<ID> subpdkids,List<ID> accList){ 
        system.debug('Inside whiteListToSendForDeprovision>>>>>>>>>>>>>>>>');
        List<Document_Provisioning__c> lstOfDpToDeprovision = new List<Document_Provisioning__c>();
        Boolean isTrue = false;
        Map <Id,Set<String>> accPdkOtIdMap = new Map<Id,Set<String>>();
         List<Document_Provisioning__c> listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c
                                                            FROM Document_Provisioning__c
                                                            WHERE Status__c = 'Provisioned'
                                                            AND AccountID__c IN : accList
                                                            AND Sub_PDK__c IN: subpdkids];
        system.debug('listOfDpRecords >>>>>>>>'+listOfDpRecords);
        if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for(Document_Provisioning__c DP : listOfDpRecords){
                if (!accPdkOtIdMap.containsKey(DP.AccountID__c)){
                  accPdkOtIdMap.put(DP.AccountID__c, new Set<String>());
                } else {
                    system.debug('DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c >>>>>>'+DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c);
                    if(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c<>NULL)
                        accPdkOtIdMap.get(DP.AccountID__c).add(String.valueOf(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c));
                }
            }
        }
        try {
            if (accList<>NULL && !accList.isEmpty()){
                for (Document_Provisioning__c DP : [SELECT Id,Status__c,AccountID__c,Bundle_OT_ID__c,
                                                            Pdk_Specs_DeProvisioned__c,Sync_With_OpenText__c,
                                                            PdkSpecs__c,PDK_Associations__c,is_De_Prov_From_UI__c
                                                    FROM Document_Provisioning__c 
                                                    WHERE Sub_PDK__c IN: subpdkids
                                                    AND Status__c = 'Provisioned' 
                                                    AND AccountID__c IN : accList]){
                    if(DP<>NULL){                                   
                        String bundleOtIds = '';
                        DP.Status__c = 'De-Provisioning In Progress';
                        DP.PdkSpecs__c = 'NONE'; 
                        if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){
                           dp.is_De_Prov_From_UI__c=true;   
                        }
                        //DP.Sync_With_OpenText__c = false;
                        //DP.Pdk_Specs_DeProvisioned__c = DP.PdkSpecs__c;
                        //DP.PdkSpecs__c ='';
                        if (accPdkOtIdMap<>NULL && accPdkOtIdMap.containsKey(DP.AccountID__c)){
                            for(String str : accPdkOtIdMap.get(DP.AccountID__c)){
                                if(str<>NULL && str!=''){
                                    if (bundleOtIds==''){
                                        bundleOtIds = str;
                                    } else {
                                        bundleOtIds = bundleOtIds+';'+str;
                                    }
                                }   
                            }
                        }
                        if(!String.isBlank(bundleOtIds)){
                            DP.Bundle_OT_ID__c = bundleOtIds;   
                        }
                        lstOfDpToDeprovision.add(DP);
                    }                    
                }                       
            }
            system.debug('lstOfDpToDeprovision>>>>>>>>>>>'+lstOfDpToDeprovision);
            if (lstOfDpToDeprovision<>NULL && !lstOfDpToDeprovision.isEmpty()){
                isTrue = true;
                update lstOfDpToDeprovision;
            }
        } catch (Exception e){
            system.debug('Exception ::  '+e.getMessage());
        }
        return isTrue;
    }
    
    /*
    * @ Author :- Navneet Rajput
    * @ Company :- CTS
    * @ Date  :- 15/16/2014
    * @ Description :- Method will help to deprovision accounts when bundle is already provisioned and 
                      user has updated bundle like diselect already provisioned spec and only spec which is 
                      diselected will send to OT for deprovisioning 
    * @ Param :- subPdkId (bundle id)
                 List<SubPDKSpecs> (list of subpdkspecs which is junction between subPDK and designSpecs)                    
    * @ Change History :- 
    **/
    
    public static boolean deProvisionUpdatePDK(Set<Id> setOfPdkIds,List<Sub_PDK_Spec__c> listOfSubPdkSpecs){
        system.debug('Inside deProvisionUpdatePDK >>>>>>>>>>>>>>>>>>>>>>>'+listOfSubPdkSpecs);
        List<Document_Provisioning__c> listOfDP = new List<Document_Provisioning__c>();
        Boolean isProvisioned = false;
        
        Map <Id,Set<String>> accPdkOtIdMap = new Map<Id,Set<String>>();
         List<Document_Provisioning__c> listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c
                                                            FROM Document_Provisioning__c
                                                            WHERE (Status__c = 'Provisioned' OR Status__c ='Provisioning In Progress')
                                                            AND Sub_PDK__c != NULL
                                                            AND Sub_PDK__c NOT IN :setOfPdkIds];
        system.debug('listOfDpRecords >>>>>>>>'+listOfDpRecords); 
        if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for(Document_Provisioning__c DP : listOfDpRecords){
                if (!accPdkOtIdMap.containsKey(DP.AccountID__c)){
                  accPdkOtIdMap.put(DP.AccountID__c, new Set<String>());
                } //else {
                system.debug('DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c >>>>>>'+DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c);
                if(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c<>NULL){
                    accPdkOtIdMap.get(DP.AccountID__c).add(String.valueOf(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c));
                }   
                //}
            }
        }
        system.debug('accPdkOtIdMap>>>>>>'+accPdkOtIdMap);
        try{
            for (Document_Provisioning__c DP : [SELECT Id,Status__c,AccountID__c,Sync_With_OpenText__c,PdkSpecs__c,isDeProUpdate__c,isProvUpdate__c,Sub_PDK__c,
                                                        PDK_Associations__c,Pdk_Specs_DeProvisioned__c,Sub_Pdk_Spec_Id__c,PDK_Spec_Names__c ,PDK_Provisoin_To_Updated_Specs__c           
                                                FROM    Document_Provisioning__c 
                                                WHERE   Sub_PDK__c =: setOfPdkIds 
                                                AND     Status__c = 'Provisioned']){
                                                    
                if (DP<>NULL && listOfSubPdkSpecs<>NULL && !listOfSubPdkSpecs.isEmpty()){
                    String bundleOtIds = '';
                   // DP.isDeProUpdate__c = true;
                    //dp.isProvUpdate__c = false;
                    for (Sub_PDK_Spec__c sPdkSpec : listOfSubPdkSpecs){
                        if(sPdkSpec.Sub_PDK__c == DP.Sub_PDK__c){
                         if(sPdkSpec.Design_Spec__r.Release_Status__c=='General Release')
                            {
                            if (sPdkSpec.OTID__c==NULL)
                            {
                                sPdkSpec.OTID__c = 'NONE';
                                }
                            
                            system.debug('enter general release');
                            system.debug('sPdkSpec.Design_Spec__r.Name$$$'+sPdkSpec.Design_Spec__r.Name);
                            system.debug('sPdkSpec.Design_Spec__r.Name$$$'+sPdkSpec.Design_Spec__r.Name);
                            
                           
                            dp.PDK_Spec_Names__c=dp.PDK_Spec_Names__c.remove(sPdkSpec.Design_Spec__r.Name);
                            
                            dp.PdkSpecs__c=dp.PdkSpecs__c.remove(String.valueOf(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c);
                            
                            }
                           
                            else if(sPdkSpec.Design_Spec__r.Release_Status__c!='General Release')
                            {
                            DP.isDeProUpdate__c = true;
                            if (sPdkSpec.OTID__c==NULL){
                                sPdkSpec.OTID__c = 'NONE';
                            }
                            if (String.isBlank(DP.Pdk_Specs_DeProvisioned__c)){
                                DP.Pdk_Specs_DeProvisioned__c = String.valueOf(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c;
                                /*if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL && !String.isBlank(DP.PDK_Provisoin_To_Updated_Specs__c)){
                                    DP.PDK_Provisoin_To_Updated_Specs__c='';
                                }*/
                            } else {
                                DP.Pdk_Specs_DeProvisioned__c = DP.Pdk_Specs_DeProvisioned__c +';'+String.valueOf

(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c;
                                /*if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL && !String.isBlank(DP.PDK_Provisoin_To_Updated_Specs__c)){
                                    DP.PDK_Provisoin_To_Updated_Specs__c='';
                                }*/
                            }
                        } 
                       }    
                    }
                    system.debug('DP.Pdk_Specs_DeProvisioned__c>>>>>>>>>>>> '+DP.Pdk_Specs_DeProvisioned__c);
                    //DP.Sync_With_OpenText__c = false;
                    
                    
                    if (accPdkOtIdMap<>NULL && accPdkOtIdMap.containsKey(DP.AccountID__c)){
                        for(String str : accPdkOtIdMap.get(DP.AccountID__c)){
                            if(str<>NULL && str!=''){
                                if (bundleOtIds==''){
                                    bundleOtIds = str;
                                } else {
                                    bundleOtIds = bundleOtIds+';'+str;
                                }
                            }   
                        }
                    }
                    system.debug('bundleOtIds >>>>>>> '+bundleOtIds);
                    if(!String.isBlank(bundleOtIds)){
                        DP.Bundle_OT_ID__c = bundleOtIds;   
                    }
                    listOfDP.add(DP);
                }                                       
            }
            system.debug('deprovisioning Specs >>>>>>>>>>>>>>'+listOfDP);
            if (listOfDP<>NULL && !listOfDP.isEmpty()){
                isProvisioned = true;
                update listOfDP;
            }
        } catch (Exception e){
            system.debug('Exception  ::  '+e.getMessage());
        }
        system.debug('isProvisioned>>>>>>>>>>>>>.'+isProvisioned);
        return isProvisioned;
    } // END OF deProvisionUpdatePDK
    
    /*---------------------------------------changes for making the isdeletionNeeded flag true when specs are removed from PDK-------------*/
      public static boolean deProvisionUpdatePDKforSpecRemove(Set<Id> setOfPdkIds,List<Sub_PDK_Spec__c> listOfSubPdkSpecs){
        system.debug('Inside deProvisionUpdatePDK >>>>>>>>>>>>>>>>>>>>>>>'+listOfSubPdkSpecs);
        List<Document_Provisioning__c> listOfDP = new List<Document_Provisioning__c>();
        Boolean isProvisioned = false;
        
        Map <Id,Set<String>> accPdkOtIdMap = new Map<Id,Set<String>>();
         List<Document_Provisioning__c> listOfDpRecords =[SELECT Sub_PDK__r.Sub_PDK_OpenText_Id__c,AccountID__c,isDeletionNeeded__c
                                                            FROM Document_Provisioning__c
                                                            WHERE (Status__c = 'Provisioned' OR Status__c ='Provisioning In Progress')
                                                            AND Sub_PDK__c != NULL
                                                            AND Sub_PDK__c NOT IN :setOfPdkIds];
        system.debug('listOfDpRecords >>>>>>>>'+listOfDpRecords); 
        if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){
            for(Document_Provisioning__c DP : listOfDpRecords){
                if (!accPdkOtIdMap.containsKey(DP.AccountID__c)){
                  accPdkOtIdMap.put(DP.AccountID__c, new Set<String>());
                } //else {
                system.debug('DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c >>>>>>'+DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c);
                if(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c<>NULL){
                    accPdkOtIdMap.get(DP.AccountID__c).add(String.valueOf(DP.Sub_PDK__r.Sub_PDK_OpenText_Id__c));
                }   
                //}
            }
        }
        system.debug('accPdkOtIdMap>>>>>>'+accPdkOtIdMap);
        try{
            for (Document_Provisioning__c DP : [SELECT Id,Status__c,AccountID__c,Sync_With_OpenText__c,PdkSpecs__c,isDeletionNeeded__c,isDeProUpdate__c,isProvUpdate__c,Sub_PDK__c,
                                                        PDK_Associations__c,Pdk_Specs_DeProvisioned__c,Sub_Pdk_Spec_Id__c,PDK_Spec_Names__c ,PDK_Provisoin_To_Updated_Specs__c           
                                                FROM    Document_Provisioning__c 
                                                WHERE   Sub_PDK__c =: setOfPdkIds 
                                                AND     Status__c = 'Provisioned']){
                                                    
                if (DP<>NULL && listOfSubPdkSpecs<>NULL && !listOfSubPdkSpecs.isEmpty()){
                    String bundleOtIds = '';
                    
                    //dp.isProvUpdate__c = false;
                    for (Sub_PDK_Spec__c sPdkSpec : listOfSubPdkSpecs){
                        if(sPdkSpec.Sub_PDK__c == DP.Sub_PDK__c){
                        system.debug('sPdkSpec.Design_Spec__r.Release_Status__c>>>>>>'+sPdkSpec.Design_Spec__r.Release_Status__c);
                            if(sPdkSpec.Design_Spec__r.Release_Status__c=='General Release')
                            {
                            if (sPdkSpec.OTID__c==NULL)
                            {
                                sPdkSpec.OTID__c = 'NONE';
                                }
                            system.debug('enter general release');
                            system.debug('sPdkSpec.Design_Spec__r.Name$$$'+sPdkSpec.Design_Spec__r.Name);
                            system.debug('sPdkSpec.Design_Spec__r.Name$$$'+sPdkSpec.Design_Spec__r.Name);
                            dp.PDK_Spec_Names__c=dp.PDK_Spec_Names__c.remove(sPdkSpec.Design_Spec__r.Name);
                            dp.PdkSpecs__c=dp.PdkSpecs__c.remove(String.valueOf(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c);
                            }
                           
                            else if(sPdkSpec.Design_Spec__r.Release_Status__c!='General Release')
                            {
                            DP.isDeProUpdate__c = true;
                            DP.isDeletionNeeded__c= true;
                            system.debug('enter others');
                            if (sPdkSpec.OTID__c==NULL){
                                sPdkSpec.OTID__c = 'NONE';
                            }
                            if (String.isBlank(DP.Pdk_Specs_DeProvisioned__c)){
                                DP.Pdk_Specs_DeProvisioned__c = String.valueOf(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c;
                                /*if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL && !String.isBlank(DP.PDK_Provisoin_To_Updated_Specs__c)){
                                    DP.PDK_Provisoin_To_Updated_Specs__c='';
                                }*/
                            } else {
                                DP.Pdk_Specs_DeProvisioned__c = DP.Pdk_Specs_DeProvisioned__c +';'+String.valueOf(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c;
                                /*if(DP.PDK_Provisoin_To_Updated_Specs__c<>NULL && !String.isBlank(DP.PDK_Provisoin_To_Updated_Specs__c)){
                                    DP.PDK_Provisoin_To_Updated_Specs__c='';
                                }*/
                            }
                        } 
                      }   
                    }
                    system.debug('DP.Pdk_Specs_DeProvisioned__c>>>>>>>>>>>> '+DP.Pdk_Specs_DeProvisioned__c);
                    //DP.Sync_With_OpenText__c = false;
                    if (accPdkOtIdMap<>NULL && accPdkOtIdMap.containsKey(DP.AccountID__c)){
                        for(String str : accPdkOtIdMap.get(DP.AccountID__c)){
                            if(str<>NULL && str!=''){
                                if (bundleOtIds==''){
                                    bundleOtIds = str;
                                } else {
                                    bundleOtIds = bundleOtIds+';'+str;
                                }
                            }   
                        }
                    }
                    system.debug('bundleOtIds >>>>>>> '+bundleOtIds);
                    if(!String.isBlank(bundleOtIds)){
                        DP.Bundle_OT_ID__c = bundleOtIds;   
                    }
                    listOfDP.add(DP);
                }                                       
            }
            system.debug('deprovisioning Specs >>>>>>>>>>>>>>'+listOfDP);
            if (listOfDP<>NULL && !listOfDP.isEmpty()){
                isProvisioned = true;
                update listOfDP;
            }
        } catch (Exception e){
            system.debug('Exception  ::  '+e.getMessage());
        }
        system.debug('isProvisioned>>>>>>>>>>>>>.'+isProvisioned);
        return isProvisioned;
    } // END OF deProvisionUpdatePDK
    
    /*----------------------changes for making the isdeletionNeeded flag true when specs are removed from PDK-----------------------------------*/
} // END OF FV_DocumentProvisioningUtil