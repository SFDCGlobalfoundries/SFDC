/*
Type Name: DesignSpecTriggerHandler
Author: Cognizant 
Created Date: 11-June-2013
Reason: 
Change History:
Author: Cognizant 
Modified Date: 9/1/2014
Reason: Change in the PDK name
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
Author: Cognizant 
Modified Date:07/04/2014
Reason: Change for CR # 00014659
Author: Cognizant 
Modified Date:16/07/2014
Reason: Change for CR # 00029532
Author: Cognizant 
Modified Date:07/11/2014
Reason: Change for CR # 00036067
Author: Cognizant 
Modified Date: 29/04/2015
Reason: Change in the PDK name
??..
??..
*/

public class DesignSpecTriggerHandler{
    
    /**
        This method deprovisions all the existing provisionings, 
        
        s all the existing White Lists and deletes all the Team Room Documents
        when the Release Status of a Spec is changed from White List to anything other than White List.

        @method name: mergeInternalReleaseRecords
        @parameter:   Set of Design Spec Ids
        @return :     None.
     **/
     
    public static void mergeInternalReleaseRecords(Set<Id> setDSpecIds){
    
        List<Document_Provisioning__c> lstDocProv = new List<Document_Provisioning__c>();
        List<Team_Room_Doc__c> lstTeamRoomDoc = new List<Team_Room_Doc__c>();
        List<White_List__c> lstWhiteList = new List<White_List__c>();
        Set<Id> setOfPdkIds = new Set<Id>();
        if(setDSpecIds!=null && setDSpecIds.size()>0){
            
            lstDocProv = [Select Id, Name,AccountID__r.Short_Name__c,Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c,Design_Spec__c,Design_Spec__r.Specification_Release_List_long__c,Design_spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c,Status__c from Document_Provisioning__c where Design_Spec__c IN:setDSpecIds];//designspec status change
            lstTeamRoomDoc = [Select Id, Name, Design_Spec__c from Team_Room_Doc__c where Design_Spec__c IN:setDSpecIds];
            lstWhiteList = [Select Id, Name, Design_Spec__c from White_List__c where Design_Spec__c IN:setDSpecIds];
            
            if(lstDocProv!=null && lstDocProv.size()>0){
                updateDocumentProvisionigOnStatusChange(lstDocProv);         
            }
            if(lstTeamRoomDoc!=null && lstTeamRoomDoc.size()>0){
                deleteTeamRoomDoc(lstTeamRoomDoc);  
            }
            if(lstWhiteList!=null && lstWhiteList.size()>0){
                deleteWhiteList(lstWhiteList);  
            }
            //Added by navneet to support new PDK design
            //We need to deprovision spec which are present in DPK bundle as well
           /* List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                                FROM Sub_PDK_Spec__c             
                                                WHERE Design_Spec__c IN :setDSpecIds];
                                             
            if(sPDkSpecs<>NULL && !sPDkSpecs.isEmpty()){
                for(Sub_PDK_Spec__c sPDK : sPDkSpecs){
                    if(sPDK.Sub_PDK__c<>NULL){
                        setOfPdkIds.add(sPDK.Sub_PDK__c);
                    }
                }
                //Added by Kunal Bulkification to avoid 101:SOQL error
                FV_DocumentProvisioningUtil.deProvisionUpdatePDK(setOfPdkIds,sPDkSpecs);
            }*/
            // End of code to update spec depro info in bundle
        }
    } 
    /*
    * When Design spec release status change to General Release from any other status
    * Method will delete that spec  related DP records
    * @ Date :- 8/2/2016
    * @ Author :- Kunal
    ***/
    public static void deleteDPRecordsOfGrDesignSpec(Set<Id>setDSpecIds){
        if(setDSpecIds!=null && setDSpecIds.size()>0){
            try{
                Delete [select id from Document_Provisioning__c where Design_Spec__c IN:setDSpecIds];    
            }
            Catch(Exception ex){
                system.debug('Error thrown while delete'+ex);
            }
        }    
    }
    /*
    * When Design spec release status change to specific account release from any other status
    * Method provision all PDK related or individual design spec related DP records
    * @ Date :- 1/3/2015
    * @ Author :- Navneet
    ***/
    public static void provOnStatusChageToSAR(Set<Id>setDSpecIds){
        //Added by navneet to support new PDK design
        //We need to deprovision spec which are present in DPK bundle as well
        system.debug('provOnStatusChageToSAR>>>>>>>>>>>');
        List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM Sub_PDK_Spec__c             
                                            WHERE Design_Spec__c IN :setDSpecIds]; 
            if(sPDkSpecs<>NULL && !sPDkSpecs.isEmpty()){
                //Added by Kunal Bulkification to avoid 101:SOQL error
                FV_DocumentProvisioningUtil.updatePdkProvisioning(sPDkSpecs);
            }
        // End of code to update spec depro info in bundle
    }
    
   
/*------------------------plm--------------------------------------------------------------*/
/*public static void provOnStatusChageToWLfromInternal(Set<Id>setDSpecIds){
        //Added by navneet to support new PDK design
        //We need to deprovision spec which are present in DPK bundle as well
        system.debug('provOnStatusChageToWLfromInternal>>>>>>>>>>>'+setDSpecIds);
        List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Sub_PDK__r.Id,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM Sub_PDK_Spec__c             
                                            WHERE Design_Spec__c IN :setDSpecIds]; 
         
        Set<Id> setofsubpdk=new Set<Id>();
        for(Sub_PDK_Spec__c pdkspecs : sPDkSpecs )
        {
        setofsubpdk.add(pdkspecs.Sub_PDK__r.Id);
        
        }
        
         system.debug('setofsubpdk>>>>>>>>>>>'+setofsubpdk);
        FV_DocumentProvisioningUtil.updatePdkProvisioningforWL(setofsubpdk);                             
         
    }

 public static void provOnStatusChageToWL(Set<Id>setDSpecIds){
        //Added by navneet to support new PDK design
        //We need to deprovision spec which are present in DPK bundle as well
        system.debug('provOnStatusChageToWL>>>>>>>>>>>'+setDSpecIds);
        List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Sub_PDK__r.Id,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM Sub_PDK_Spec__c             
                                            WHERE Design_Spec__c IN :setDSpecIds]; 
         
        Set<Id> setofsubpdk=new Set<Id>();
        for(Sub_PDK_Spec__c pdkspecs : sPDkSpecs )
        {
        setofsubpdk.add(pdkspecs.Sub_PDK__r.Id);
        
        }
        system.debug('setofsubpdk>>>>>>>>>>>'+setofsubpdk);
        FV_DocumentProvisioningUtil.updatePdkProvisioningforWLnoChange(setofsubpdk);                             
         
    }*/
    
    public static void provOnStatusChageToWLfromInternal(Set<Id>setDSpecIds){
        //Added by navneet to support new PDK design
        //We need to deprovision spec which are present in DPK bundle as well
        system.debug('provOnStatusChageToSAR>>>>>>>>>>>');
        List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM Sub_PDK_Spec__c             
                                            WHERE Design_Spec__c IN :setDSpecIds]; 
            if(sPDkSpecs<>NULL && !sPDkSpecs.isEmpty()){
                //Added by Kunal Bulkification to avoid 101:SOQL error
                FV_DocumentProvisioningUtil.updatePdkProvisioningforWL(sPDkSpecs);
            }
        // End of code to update spec depro info in bundle
    }
    
    public static void provOnStatusChageToWL(Set<Id>setDSpecIds){
        //Added by navneet to support new PDK design
        //We need to deprovision spec which are present in DPK bundle as well
        system.debug('provOnStatusChageToSAR>>>>>>>>>>>');
        List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                            FROM Sub_PDK_Spec__c             
                                            WHERE Design_Spec__c IN :setDSpecIds]; 
         
            if(sPDkSpecs<>NULL && !sPDkSpecs.isEmpty()){
                //Added by Kunal Bulkification to avoid 101:SOQL error
                FV_DocumentProvisioningUtil.updatePdkProvisioningforWLnoChange(sPDkSpecs);
            }
        // End of code to update spec depro info in bundle
    }
/*--------------------------------------------------------------------------------------------------*/    
    // Set flag for document provisioning Trigger to avoid repetive execution of trigger
    public static boolean isBeforeExecuted = false;
    public static boolean isAfterExecuted = false;
    
    public static void isBeforeExecuted(){
        
        isBeforeExecuted=true;
        //return isBeforeExecuted;
    }
    
    public static void isAfterExecuted(){
        
        isAfterExecuted = true;
       // return isAfterExecuted; 
    }
    
/*------------------------plm---------------------------------------------------------------------------*/        
    /**
        This method deprovisions the document provisioning records.

        @method name: updateDocumentProvisioning
        @parameter:   List of Document Provisioning records to be updated to De-provisioned.
        @return :     None.
     **/
 public static void updateDocumentProvisioning(List<Document_Provisioning__c> lstDocProv){  
        
        List<Document_Provisioning__c> lstDocProvToUpdate = new List<Document_Provisioning__c>();
        List<String> accList=new List<String>();
        Map<Id,List<String>> MapOfDsandAccList=new Map<Id,List<String>>();
        
        if(lstDocProv!=null && lstDocProv.size()>0){
/*-----------------designspec status change--------------------------------*/        
            for(Document_Provisioning__c objDP: lstDocProv)
            {
            
            system.debug('objDP.Design_spec__r.Release_Status__c%%%'+objDP.Design_spec__r.Release_Status__c);
            
            if(objDP.Sub_PDK__c!=null && objDP.Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c=='OBSOLETE')
            {
            objDP.Status__c = 'De-Provisioning In Progress';
             lstDocProvToUpdate.add(objDP);
            }
            else if(objDP.Design_spec__c!=null && objDP.Design_spec__r.Release_Status__c!='General Release')
            {
            system.debug('entr ds');
            system.debug('objDP.Design_spec__r.Lifecycle_Phase__c'+objDP.Design_spec__r.Lifecycle_Phase__c);
                        system.debug('if$$$');
            objDP.Status__c = 'De-Provisioning In Progress';
             lstDocProvToUpdate.add(objDP); 
            } 
            
            }
/*-----------------designspec status change--------------------------------*/  
            // PDK spec Obsolete
                            
            }
            try{
                if(!lstDocProvToUpdate.isEmpty())
                update lstDocProvToUpdate;  
            }
            catch(Exception ex){
                System.debug(ex);
            }   
        }       
    
/*-----------------------------------------------------------------------------*/         
     public static void updateDocumentProvisionigOnStatusChange(List<Document_Provisioning__c> lstDocProv){  
        
        List<Document_Provisioning__c> lstDocProvToUpdate = new List<Document_Provisioning__c>();
        List<String> accList=new List<String>();
        Map<Id,List<String>> MapOfDsandAccList=new Map<Id,List<String>>();
        if(lstDocProv!=null && lstDocProv.size()>0){
/*-----------------designspec status change--------------------------------*/        
            for(Document_Provisioning__c objDP: lstDocProv)
            {
              accList = new List<String>();
              if( objDP.Design_spec__r.Specification_Release_List_Long__c!=null)
              {
                 if(objDP.Design_spec__r.Specification_Release_List_Long__c.contains(';')) // CR # 4562 ? Field replaced
                {
                    accList.addAll(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 ? Field replaced  
                }   
                else
                
                {
                    accList.add(objDP.Design_spec__r.Specification_Release_List_Long__c.toLowerCase()); // CR # 4562 ? Field replaced
                }
                MapOfDsandAccList.put(objDP.Design_Spec__c,accList);
                }
             }   
        }
        if(lstDocProv!=null && lstDocProv.size()>0){
/*-----------------designspec status change--------------------------------*/        
            for(Document_Provisioning__c objDP: lstDocProv)
            {
            boolean accfound=false;
            if(MapOfDsandAccList!=null && MapOfDsandAccList.get(objDP.Design_Spec__c)!=null)
            {
            for(String acc :MapOfDsandAccList.get(objDP.Design_Spec__c))
                {
                 if(acc==objDP.AccountID__r.Short_Name__c)
                 {
                  accfound = true;
                 }
                
                 }
             }   
             
             
            system.debug('objDP.Design_spec__r.Release_Status__c%%%'+objDP.Design_spec__r.Release_Status__c);
            
          
            if(objDP.Design_spec__r.Release_Status__c!=null && objDP.Design_spec__r.Release_Status__c.contains('Specific Account Release') && objDP.Status__c!='De-Provisioned')
            {
            system.debug('else$$$');
                objDP.Status__c = 'Provisioning In Progress';
                lstDocProvToUpdate.add(objDP); 
            } 
            else if(objDP.Design_spec__r.Release_Status__c!=null && objDP.Design_spec__r.Release_Status__c.contains('Release to White list') &&  accfound ==true && objDP.Status__c!='De-Provisioned')
                    
            {
            system.debug('else$$$');
                objDP.Status__c = 'Provisioning In Progress';
                lstDocProvToUpdate.add(objDP); 
            } 
            else if(objDP.Design_spec__r.Release_Status__c!=null && objDP.Design_spec__r.Release_Status__c.contains('Release to White list') &&  accfound ==false && objDP.Status__c!='De-Provisioned')
                    
            {
               system.debug('else$$$');
                objDP.Status__c = 'De-Provisioning In Progress';
                lstDocProvToUpdate.add(objDP); 
            }
           
            }
/*-----------------designspec status change--------------------------------*/  
                            
            }
            try{
                update lstDocProvToUpdate;  
            }
            catch(Exception ex){
                System.debug(ex);
            }   
        }       
    
    
    public static void shareSpectoPLMlist(List<Design_Spec__c> lstDesignSpecAutoProv){
        
        Map<String, List<String>> mapDSIdToAccLists = new Map<String, List<String>>();
        Map<String, List<String>> mapAccSNToUserIds = new Map<String, List<String>>();
        Set<String> setAllAccIds = new Set<String>();
        List<Document_Provisioning__c> lstDocProvToAutoInsert = new List<Document_Provisioning__c>();
        
        if(lstDesignSpecAutoProv!=null && lstDesignSpecAutoProv.size()>0){
            for(Design_Spec__c objDS: lstDesignSpecAutoProv){
                List<String> accList = new List<String>();
                if(objDS.Specification_Release_List_Long__c.contains(';')){ // CR # 4562 - Field replaced
                    accList.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';'));    // CR # 4562 - Field replaced   
                }   
                else{
                    accList.add(objDS.Specification_Release_List_Long__c.toLowerCase());    // CR # 4562 - Field replaced 
                }
                setAllAccIds.addAll(accList);
                mapDSIdToAccLists.put(objDS.Id,accList);
            }
            
            if(setAllAccIds!=null && setAllAccIds.size()>0){
                for(User objUser:[Select Id, Parent_Account_Short_Name__c from User where Parent_Account_Short_Name__c IN: setAllAccIds AND isActive=true]){
                    
                    List<String> tempUserIds = new List<String>();
                    String accShortName = objUser.Parent_Account_Short_Name__c;     
                    if(mapAccSNToUserIds!=null){ 
                        if(mapAccSNToUserIds.containsKey(accShortName)){
                            tempUserIds = mapAccSNToUserIds.get(accShortName) ;
                        }
                        tempUserIds.add(objUser.Id);
                        mapAccSNToUserIds.put(accShortName , tempUserIds);
                    }      
                }   
            }
            
            for(Design_Spec__c objDS: lstDesignSpecAutoProv){
                List<String> accList = new List<String>();
                accList.addAll(mapDSIdToAccLists.get(objDS.Id));
                if(accList!=null && accList.size()>0){
                    for(String accShortName: accList){
                        if(mapAccSNToUserIds!=null && mapAccSNToUserIds.containsKey(accShortName)){
                            for(String userId: mapAccSNToUserIds.get(accShortName)){
                                Document_Provisioning__c objDP = new Document_Provisioning__c();
                                objDP.User__c = userId;
                                objDP.Design_Spec__c = objDS.Id;
                                objDP.Status__c = 'Provisioned';
                                objDP.Spec_Owner__c = objDS.OwnerId;
                                lstDocProvToAutoInsert.add(objDP);
                            }
                        }  
                    }   
                }
            }
            
            if(lstDocProvToAutoInsert!=null && lstDocProvToAutoInsert.size()>0){
                
                try{
                    insert lstDocProvToAutoInsert;  
                }
                catch(Exception ex){
                    System.debug(ex);
                }   
            }       
        }   
    }
    /**
        This method deletes the team room doc records.

        @method name: deleteTeamRoomDoc
        @parameter:   List of Team Room records to be deleted.
        @return :     None.
     **/
     
    public static void deleteTeamRoomDoc(List<Team_Room_Doc__c> lstTeamRoomDoc){   
        
        if(lstTeamRoomDoc!=null && lstTeamRoomDoc.size()>0){
            
            try{
                delete lstTeamRoomDoc;  
            }
            catch(Exception ex){
                System.debug(ex);
            }   
        }   
    }
    
    /**
        This method deletes the white list records.

        @method name: deleteWhiteList
        @parameter:   List of White List records to be deleted.
        @return :     None.
     **/
     
    public static void deleteWhiteList(List<White_List__c> lstWhiteList){  
        
        if(lstWhiteList!=null && lstWhiteList.size()>0){
            
            try{
                delete lstWhiteList;    
            }
            catch(Exception ex){
                System.debug(ex);
            }   
        }   
    }
    
    /**
        This method deprovisions all the provisionings related to the Specs marked as Obsolete.

        @method name: deProvisionObsoleteSpec
        @parameter:   1. List of Spec records which have been marked as Obsolete.
                      2. Set of Spec record Ids of Specs which have been marked as Obsolete.
        @return :     None.
     **/
     
    public static void deProvisionObsoleteSpec(List<Design_Spec__c> lstDesignSpecToProvisioned,Set<Id> setDesignSpecIdsToObsolete){
        
        List<Document_Provisioning__c> lstDocProvToObsolete = new List<Document_Provisioning__c>();
        
        if(lstDesignSpecToProvisioned!=null && lstDesignSpecToProvisioned.size()>0){
            Map<String,String> mapDesignSpecsRecordTypeId = fetchAllRecTypeIdsMap('Design_Spec__c');
            for(Design_Spec__c objDesignSpec:lstDesignSpecToProvisioned){
                objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('Obsolete Specs');
            }
            for(Document_Provisioning__c objDP: [Select Id,Design_spec__r.RecordType.Name,Status__c,Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c,AccountID__r.Short_Name__c,Design_Spec__r.Specification_Release_List_long__c, Design_Spec__c ,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c from Document_Provisioning__c where Design_Spec__c IN:setDesignSpecIdsToObsolete
            AND Status__c NOT IN ('De-Provisioned','Rejected')]){
                lstDocProvToObsolete.add(objDP);    
            }
            
            if(lstDocProvToObsolete!=null && lstDocProvToObsolete.size()>0){                
                updateDocumentProvisioning(lstDocProvToObsolete);
            }           
        }       
    }
    
   /**
        This method deprovisions all the provisionings related to the Specs marked as Obsolete.

        @method name: deProvisionObsoleteSpec
        @parameter:   1. List of Spec records which have been marked as Obsolete.
                      2. Set of Spec record Ids of Specs which have been marked as Obsolete.
        @return :     None.
     **/
    public static boolean isObsoleteCall = false; 
    public static void deProvisionPDKSpecObsolete(List<Design_Spec__c> lstDesignSpecToProvisioned,Set<Id> setDesignSpecIdsToObsolete){
        
        List<Document_Provisioning__c> lstDocProvToObsolete = new List<Document_Provisioning__c>();
        set<ID> designSpecIds = new set<ID>();
        
        if(lstDesignSpecToProvisioned!=null && lstDesignSpecToProvisioned.size()>0){
            Map<String,String> mapDesignSpecsRecordTypeId = fetchAllRecTypeIdsMap('Design_Spec__c');
            for(Design_Spec__c objDesignSpec:lstDesignSpecToProvisioned){
                objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('Obsolete Specs');
                designSpecIds.add(objDesignSpec.ID);                
            }            
                        
          system.debug('***designSpecIds***'+designSpecIds);    
                  
          map<ID,list<Sub_PDK_spec__c>>  PDK_SubPdkMap = new map<ID,list<Sub_PDK_spec__c>>(); // pdk bundle id, sub pdk spec list                                     
          for(Sub_PDK_spec__c objspec:[Select Id,Sub_PDK__c,Design_Spec__c,Design_Spec__r.OpenText_ID__c,Design_Spec__r.Name,OTID__c  from Sub_PDK_spec__c where Design_Spec__c in:designSpecIds])
          {          
                // Modified by Prajnith K
                if(objspec.Sub_PDK__c != null){             
                    if(!PDK_SubPdkMap.containskey(objspec.Sub_PDK__c)){
                        PDK_SubPdkMap.put(objspec.Sub_PDK__c, new list<Sub_PDK_spec__c>());
                        PDK_SubPdkMap.get(objspec.Sub_PDK__c).add(objspec);
                    }
                    else{
                        PDK_SubPdkMap.get(objspec.Sub_PDK__c).add(objspec);
                    }
                }
          }
                 // remove the pdk association ids from DP before deleting.
          if(!PDK_SubPdkMap.keyset().isEmpty()){
            isObsoleteCall = true;              
            updateDocuProv(PDK_SubPdkMap);
          }
          
        }       
    }
    
        
    /**
        This method provisions all the provisionings related to the Specs marked as Released from Obsolete.

        @method name: provisionReleasedSpec
        @parameter:   1. List of Spec records which have been marked as Released from Obsolete.
                      2. Set of Spec record Ids of Specs which have been marked as Released from Obsolete.
        @return :     None.
     **/
     
    public static void provisionReleasedSpec(List<Design_Spec__c> lstDesignSpecToProvisioned,Set<Id> setDesignSpecIdsToReleased){
        
        //List<Document_Provisioning__c> lstDocProvToReleased = new List<Document_Provisioning__c>();
        
        if(lstDesignSpecToProvisioned!=null && lstDesignSpecToProvisioned.size()>0){
            Map<String,String> mapDesignSpecsRecordTypeId = fetchAllRecTypeIdsMap('Design_Spec__c');
            for(Design_Spec__c objDesignSpec:lstDesignSpecToProvisioned){
                if(objDesignSpec.PDK__c!=null){
                    objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('PDK Specs');
                }
                else{
                    objDesignSpec.RecordTypeId=mapDesignSpecsRecordTypeId.get('Design Specs');
                }
            }
            /*for(Document_Provisioning__c objDP: [Select Id, Status__c, Design_Spec__c from Document_Provisioning__c where Design_Spec__c IN:setDesignSpecIdsToReleased]){
                objDP.Status__c = 'Provisioned';
                lstDocProvToReleased.add(objDP);    
            }
            
            if(lstDocProvToReleased!=null && lstDocProvToReleased.size()>0){
                try{
                    update lstDocProvToReleased;    
                }
                catch(Exception ex){
                    System.debug(ex);
                }   
            }*/           
        }
    }
    
    /**
        This method deprovisions all the provisionings related to the Specs marked as General Release or Internal use only.

        @method name: deProvisionInternalSpecs
        @parameter:   Set of Spec record Ids of Specs which have been marked as General Release or Internal use only.
        @return :     None.
     **/
     
    public static void deProvisionInternalSpecs (Set<Id> setDesignSpecIdsToInternal){
        
        List<Document_Provisioning__c> lstDocProvToInternal = new List<Document_Provisioning__c>();
        Set<Id> setOfPdkIds = new Set<Id>();
        if(setDesignSpecIdsToInternal!=null && setDesignSpecIdsToInternal.size()>0){
        
            for(Document_Provisioning__c objDP: [Select Id, Status__c,Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c,AccountID__r.Short_Name__c,Design_Spec__r.Specification_Release_List_long__c, Design_Spec__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c from Document_Provisioning__c where Design_Spec__c IN:setDesignSpecIdsToInternal]){
                lstDocProvToInternal.add(objDP);    
            }
            
            if(lstDocProvToInternal!=null && lstDocProvToInternal.size()>0){                
                updateDocumentProvisioning(lstDocProvToInternal);
            }
            //Added by navneet to support new PDK design
            //We need to deprovision spec which are present in DPK bundle as well
            List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,Design_Spec__r.Name,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                                FROM Sub_PDK_Spec__c             
                                                WHERE Design_Spec__c IN :setDesignSpecIdsToInternal];
                                             
            Map<Id,List<Sub_PDK_Spec__c>> mapOfSPdkAndSPdkSpecs = new Map<Id,List<Sub_PDK_Spec__c>>();
            if(sPDkSpecs<>NULL && !sPDkSpecs.isEmpty()){
                for(Sub_PDK_Spec__c sPDK : sPDkSpecs){
                    if(sPDK.Sub_PDK__c<>NULL){
                        if (!mapOfSPdkAndSPdkSpecs.containsKey(sPDK.Sub_PDK__c)){
                            mapOfSPdkAndSPdkSpecs.put(sPDK.Sub_PDK__c,new List<Sub_PDK_Spec__c>());
                        }
                        mapOfSPdkAndSPdkSpecs.get(sPDK.Sub_PDK__c).add(sPDK);
                        setOfPdkIds.add(sPDK.Sub_PDK__c);
                    }
                }
                system.debug('mapOfSPdkAndSPdkSpecs>>>>>>>>>>>'+mapOfSPdkAndSPdkSpecs);
                if(mapOfSPdkAndSPdkSpecs<>NULL){
                    //for (Id pdkId : mapOfSPdkAndSPdkSpecs.keySet()){
                        // This method need to bulkify, due to time constraint not bulkifing at this moment
                        FV_DocumentProvisioningUtil.deProvisionUpdatePDK(setOfPdkIds,sPDkSpecs);
                    //}
                }
            }
            // End of code to update spec depro info in bundle           
        }       
    }
/*------------------------plm status change of spec------------------------------------------------*/
            /**
        This method deprovisions all the provisionings related to the Specs marked as General Release or Internal use only.

        @method name: deProvisionWhiteListSpecs 
        @parameter:   Set of Spec record Ids of Specs which have been marked as General Release or Internal use only.
        @return :     None.
     **/
     
    public static void deProvisionWhiteListSpecs (Set<Id> setDesignSpecIdsToWhiteList){
        
        List<Document_Provisioning__c> lstDocProvToWL= new List<Document_Provisioning__c>();
        Set<Id> setOfPdkIds = new Set<Id>();
        if(setDesignSpecIdsToWhiteList!=null && setDesignSpecIdsToWhiteList.size()>0){
        
            for(Document_Provisioning__c objDP: [Select Id, Status__c,Design_Spec__r.Specification_Release_List_long__c, Design_Spec__c,Design_spec__r.Lifecycle_Phase__c,Design_spec__r.Release_Status__c from Document_Provisioning__c where Design_Spec__c IN:setDesignSpecIdsToWhiteList]){
                lstDocProvToWL.add(objDP);    
            }
            
           /* if(lstDocProvToWL!=null && lstDocProvToWL.size()>0){                
                updateDocumentProvisioning(lstDocProvToWL);
            }*/
            //Added by navneet to support new PDK design
            //We need to deprovision spec which are present in DPK bundle as well
            List<Sub_PDK_Spec__c> sPDkSpecs = [SELECT Id,name,Sub_PDK__c,Design_Spec__c,OTID__c,Design_Spec__r.Release_Status__c,Design_Spec__r.Name,
                                                    Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c
                                                FROM Sub_PDK_Spec__c             
                                                WHERE Design_Spec__c IN :setDesignSpecIdsToWhiteList];
                                             
            Map<Id,List<Sub_PDK_Spec__c>> mapOfSPdkAndSPdkSpecs = new Map<Id,List<Sub_PDK_Spec__c>>();
            if(sPDkSpecs<>NULL && !sPDkSpecs.isEmpty()){
                for(Sub_PDK_Spec__c sPDK : sPDkSpecs){
                    if(sPDK.Sub_PDK__c<>NULL){
                        if (!mapOfSPdkAndSPdkSpecs.containsKey(sPDK.Sub_PDK__c)){
                            mapOfSPdkAndSPdkSpecs.put(sPDK.Sub_PDK__c,new List<Sub_PDK_Spec__c>());
                        }
                        mapOfSPdkAndSPdkSpecs.get(sPDK.Sub_PDK__c).add(sPDK);
                        setOfPdkIds.add(sPDK.Sub_PDK__c);
                    }
                }
                system.debug('mapOfSPdkAndSPdkSpecs>>>>>>>>>>>'+mapOfSPdkAndSPdkSpecs);
                if(mapOfSPdkAndSPdkSpecs<>NULL){
                    //for (Id pdkId : mapOfSPdkAndSPdkSpecs.keySet()){
                        // This method need to bulkify, due to time constraint not bulkifing at this moment
                        FV_DocumentProvisioningUtil.deProvisionUpdatePDK(setOfPdkIds,sPDkSpecs);
                    //}
                }
            }
            // End of code to update spec depro info in bundle           
        }       
    }
/*----------------------------------------------------------------------------------------------------*/    
    /* Method Added by Cognizant on 25062014 for CR#27641 Start */
    
    /**
        This method triggers the Approval Process for all the provisioning records having Status as Sent for Approval.

        @method name: submitApprovalProcessHighVolume
        @parameter:   List of provisioning records having status as Sent for Approval.
        @return :     None.
     **/
    public static void submitApprovalProcessHighVolume(List<Document_Provisioning__c> lstDPSentForApproval){
 
        List<Document_Provisioning__c> lstDPSentForAppChunk = new List<Document_Provisioning__c>() ; 
        
        for(Document_Provisioning__c dp : lstDPSentForApproval){
            Document_Provisioning__c dProvisioning = new Document_Provisioning__c();
            dProvisioning.isSendForApproval__c=false;
            dProvisioning.Id= dp.Id;
            lstDPSentForAppChunk.add(dProvisioning) ;
        }
        if(lstDPSentForAppChunk!=null && !lstDPSentForAppChunk.isEmpty() && lstDPSentForAppChunk.size()<=50){
            update lstDPSentForAppChunk;
            submitApprovalProcess(lstDPSentForAppChunk);
        } 
    }
    /* Method Added by Cognizant on 25062014 for CR#27641 End */
    
    /**
        This method triggers the Approval Process for all the provisioning records having Status as Sent for Approval.

        @method name: submitApprovalProcess
        @parameter:   List of provisioning records having status as Sent for Approval.
        @return :     None.
     **/
     
    public static void submitApprovalProcess(List<Document_Provisioning__c> lstDPSentForApproval){
    
       List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> (); //Added for 22625

        if(lstDPSentForApproval!=null && lstDPSentForApproval.size()>0){
            for(Document_Provisioning__c objDP: lstDPSentForApproval){
                
                /** Create the new approval request to submit **/
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(objDP.Id);
                requests.add(req); //Added for 22625
            }
            /** Submit the approval request for processing **/ 
                Approval.ProcessResult[] processResults = null;
                try{
                    processResults = Approval.process(requests,false);
                }
                catch (System.DmlException e) {
                    System.debug('Exception Is ' + e.getMessage());
                } 
            /*Modified for 22625 ends*/
        }   
    }
    
    /**
        This method fetches all the Record Types corresponding to a particular SObject. Hence this method can be reused for fetching all the 
        Record Types of any SObject.

        @method name: fetchAllRecTypeIdsMap
        @parameter:   String containing the name of the SObject corresponding to which the Record Types need to be retrieved.
        @return :     Map of Record Types of the particular SObject taken as input.
     **/

    public static Map<String,String> fetchAllRecTypeIdsMap(String objtype)
    {
        
        Map<String,String> mapRecTypes = new Map<String,String>() ;

        try{
            List<RecordType> recTypeList = new List<RecordType>() ;
            recTypeList = [SELECT Id,Name FROM RecordType where SobjectType=:objtype] ;
            for(RecordType tempRecordType:recTypeList){
                mapRecTypes.put(tempRecordType.Name,tempRecordType.Id);
            }
        }
        catch(Exception e){
            System.debug('Generated Error '+e) ;
        }
        
        return mapRecTypes ;
    }
    
    /**
        This method removes the provisioning for inactive users.
        
        @method name: removeProvisioningForInactiveUsers
        @parameter:   Set of Ids of Inactivated Portal Users and set of Ids of corresponding Portal Users.
        @return :     none
    **/ 
         
   public static void removeProvisioningForInactiveUsers(Set<Id> userIds){
        
        List<Document_Provisioning__c> lstDocProvsToDeprovision = new List<Document_Provisioning__c>();
        if(userIds!=null && !(userIds.isEmpty())){
            for(Document_Provisioning__c dp:[Select Id, User__c, Status__c from Document_Provisioning__c where User__c IN:userIds and Status__c!='De-Provisioned']){
                dp.Status__c = 'De-Provisioned';
                lstDocProvsToDeprovision.add(dp);   
            }
            if(lstDocProvsToDeprovision!=null && lstDocProvsToDeprovision.size()>0){
                 try{
                     update lstDocProvsToDeprovision;
                 }
                 catch(DmlException ex){
                     System.debug('***Exception faced in updating Document Provisioning is*** ' + ex);
                 }
             }  
        }   
   }
   
   /**
        This future method removes the provisioning for inactive users.
        
        @method name: removeProvisioningForInactiveUsersFuture
        @parameter:   Set of Ids of Inactivated Portal Users and set of Ids of corresponding Portal Users.
        @return :     none
    **/ 
       
   @future
   public static void removeProvisioningForInactiveUsersFuture(Set<Id> userIds){
        
        removeProvisioningForInactiveUsers(userIds);
   }
   
   /**
        This method creates the Team Room Provisioning records by adding Team Room Members to a Team Room.

        @method name: createTeamRoomProvisioningByAddingMembers
        @parameter:   List of Team Room Member records added to a Team Room.
        @return :     None.
     **/
     
   public static void createTeamRoomProvisioningByAddingMembers(List<Team_Room_Member__c> lstTeamRoomMember){
        
        set<String> setUserIds = new set<String>();
        map<String,String> mapUserIdsToUserType = new map<String,String>();
        map<Id,List<Id>> mapTeamRoomIdsToUserIds = new map<Id,List<Id>>();
        if(lstTeamRoomMember!=null && lstTeamRoomMember.size()>0){
            for (Team_Room_Member__c objTRM: lstTeamRoomMember){
                setUserIds.add(objTRM.User__c); 
            }
            if(setUserIds!=null && setUserIds.size()>0){
                for(User objUser:[Select Id, UserType from User where Id IN:setUserIds]){
                    mapUserIdsToUserType.put(objUser.Id,objUser.UserType);      
                }
            }
            for (Team_Room_Member__c objTRM: lstTeamRoomMember){
                if(mapUserIdsToUserType.get(objTRM.User__c)=='PowerCustomerSuccess'){
                    
                    List<Id> tempUserIdList = new List<Id>();
                    String teamRoomId = objTRM.Team_Room__c;
                    
                    if(mapTeamRoomIdsToUserIds!=null){                      
                        if(mapTeamRoomIdsToUserIds.containsKey(teamRoomId)){
                            tempUserIdList = mapTeamRoomIdsToUserIds.get(teamRoomId) ;
                        }
                        tempUserIdList.add(objTRM.User__c);
                        mapTeamRoomIdsToUserIds.put(teamRoomId , tempUserIdList);
                    }                           
                }
                    
            }
            if(mapTeamRoomIdsToUserIds!=null && mapTeamRoomIdsToUserIds.size()>0){
                ClsProvisioningHandler controller = new ClsProvisioningHandler();
                controller.doProvision(mapTeamRoomIdsToUserIds, 'TeamRoom');        
            }
        }
            
   }
   
   /**
        This method creates the Team Room Provisioning records by adding Team Room Docs to a Team Room.

        @method name: createTeamRoomProvisioningByAddingDocs
        @parameter:   List of Team Room Doc records added to a Team Room.
        @return :     None.
     **/
     
   public static void createTeamRoomProvisioningByAddingDocs(List<Team_Room_Doc__c> lstTeamRoomDoc){
        
        set<String> setUserIds = new set<String>();
        map<String,String> mapUserIdsToUserType = new map<String,String>();
        set<String> setTeamRoomIds = new set<String>();
        map<Id,List<Id>> mapTeamRoomIdsToUserIds = new map<Id,List<Id>>();
        if(lstTeamRoomDoc!=null && lstTeamRoomDoc.size()>0){
            for(Team_Room_Doc__c trd:lstTeamRoomDoc){
                setTeamRoomIds.add(trd.Team_Room__c);
            }
            if(setTeamRoomIds!=null && setTeamRoomIds.size()>0){
                for (Team_Room_Member__c objTRM:  [Select Id, User__c, Team_Room__c from Team_Room_Member__c where Team_Room__c IN:setTeamRoomIds]){
                    setUserIds.add(objTRM.User__c); 
                }
                if(setUserIds!=null && setUserIds.size()>0){
                    for(User objUser:[Select Id, UserType from User where Id IN:setUserIds]){
                        mapUserIdsToUserType.put(objUser.Id,objUser.UserType);      
                    }
                }
                for (Team_Room_Member__c objTRM: [Select Id, User__c, Team_Room__c from Team_Room_Member__c where Team_Room__c IN:setTeamRoomIds]){
                    if(mapUserIdsToUserType.get(objTRM.User__c)=='PowerCustomerSuccess'){
                        
                        List<Id> tempUserIdList = new List<Id>();
                        String teamRoomId = objTRM.Team_Room__c;
                        
                        if(mapTeamRoomIdsToUserIds!=null){                      
                            if(mapTeamRoomIdsToUserIds.containsKey(teamRoomId)){
                                tempUserIdList = mapTeamRoomIdsToUserIds.get(teamRoomId) ;
                            }
                            tempUserIdList.add(objTRM.User__c);
                            mapTeamRoomIdsToUserIds.put(teamRoomId , tempUserIdList);
                        }                           
                    }
                        
                }
                if(mapTeamRoomIdsToUserIds!=null && mapTeamRoomIdsToUserIds.size()>0){
                    ClsProvisioningHandler controller = new ClsProvisioningHandler();
                    controller.doProvision(mapTeamRoomIdsToUserIds, 'TeamRoom');        
                }   
            }   
        }           
            
   }
   
   /**
        This method deprovisions the Team Room Provisioning records by removing Team Room Members from a Team Room.

        @method name: teamRoomDeprovisioningByRemovingMembers
        @parameter:   List of Team Room Member records removed from a Team Room.
        @return :     None.
     **/
     
   public static void teamRoomDeprovisioningByRemovingMembers(List<Team_Room_Member__c> lstTeamRoomMember){
    
        map<String,String> mapSpecIdsToTeamRoomId = new map<String,String>();
        map<String,String> mapPackageIdsToTeamRoomId = new map<String,String>();
        map<String,String> mapSubPDKIdsToTeamRoomId = new map<String,String>();
        map<Id,List<Id>> mapSpecIdsToUserIds = new map<Id,List<Id>>();
        map<Id,List<Id>> mapPackageIdsToUserIds = new map<Id,List<Id>>();
        map<Id,List<Id>> mapSubPDKIdsToUserIds = new map<Id,List<Id>>();
        
        set<String> setUserIds = new set<String>();
        set<String> setTRIds = new set<String>();
        map<String,String> mapUserIdsToUserType = new map<String,String>();
        
        if(lstTeamRoomMember!=null && lstTeamRoomMember.size()>0){
            for (Team_Room_Member__c objTRM: lstTeamRoomMember){
                setUserIds.add(objTRM.User__c);
                setTRIds.add(objTRM.Team_Room__c);  
            }

            if(setTRIds!=null && setTRIds.size()>0){
                for(Team_Room_Doc__c trd:[Select Design_Spec__c, Design_Package__c, Sub_PDK__c, Team_Room__c from Team_Room_Doc__c where Team_Room__c IN:setTRIds]){
                    if(trd.Design_Spec__c!=null){
                        mapSpecIdsToTeamRoomId.put(trd.Design_Spec__c,trd.Team_Room__c);                    
                    }
                    else if(trd.Design_Package__c!=null){
                        mapPackageIdsToTeamRoomId.put(trd.Design_Package__c,trd.Team_Room__c);  
                    }
                    else if(trd.Sub_PDK__c!=null){
                        mapSubPDKIdsToTeamRoomId.put(trd.Sub_PDK__c,trd.Team_Room__c);  
                    }                       
                }   
                        
            }
            
            for(Document_Provisioning__c dp: [Select Id, Design_Spec__c, Design_Package__c, Sub_PDK__c, Status__c, User__c, Team_Rooms_Provisioned_for__c 
            from Document_Provisioning__c where ((Design_Spec__c IN:mapSpecIdsToTeamRoomId.keySet()) OR (Design_Package__c IN:mapPackageIdsToTeamRoomId.keySet())
            OR (Sub_PDK__c IN:mapSubPDKIdsToTeamRoomId.keySet())) AND Status__c='Provisioned' AND User__c IN:setUserIds] ){
                
                if(dp.Design_Spec__c!=null){
                    if(dp.Team_Rooms_Provisioned_for__c!=null && dp.Team_Rooms_Provisioned_for__c.contains(mapSpecIdsToTeamRoomId.get(dp.Design_Spec__c))){
                        List<Id> tempUserIdList = new List<Id>();
                        String specId = dp.Design_Spec__c;
                            
                        if(mapSpecIdsToUserIds!=null){                      
                            if(mapSpecIdsToUserIds.containsKey(specId)){
                                tempUserIdList = mapSpecIdsToUserIds.get(specId) ;
                            }
                            tempUserIdList.add(dp.User__c);
                            mapSpecIdsToUserIds.put(specId , tempUserIdList);
                        }       
                    }
                }
                else if(dp.Design_Package__c!=null){
                    if(dp.Team_Rooms_Provisioned_for__c!=null && dp.Team_Rooms_Provisioned_for__c.contains(mapPackageIdsToTeamRoomId.get(dp.Design_Package__c))){
                        List<Id> tempUserIdList = new List<Id>();
                        String specId = dp.Design_Package__c;
                            
                        if(mapPackageIdsToUserIds!=null){                       
                            if(mapPackageIdsToUserIds.containsKey(specId)){
                                tempUserIdList = mapPackageIdsToUserIds.get(specId) ;
                            }
                            tempUserIdList.add(dp.User__c);
                            mapPackageIdsToUserIds.put(specId , tempUserIdList);
                        }       
                    }
                }
                else if(dp.Sub_PDK__c!=null){
                    if(dp.Team_Rooms_Provisioned_for__c!=null && dp.Team_Rooms_Provisioned_for__c.contains(mapSubPDKIdsToTeamRoomId.get(dp.Sub_PDK__c))){
                        List<Id> tempUserIdList = new List<Id>();
                        String specId = dp.Sub_PDK__c;
                            
                        if(mapSubPDKIdsToUserIds!=null){                        
                            if(mapSubPDKIdsToUserIds.containsKey(specId)){
                                tempUserIdList = mapSubPDKIdsToUserIds.get(specId) ;
                            }
                            tempUserIdList.add(dp.User__c);
                            mapSubPDKIdsToUserIds.put(specId , tempUserIdList);
                        }       
                    }
                }
                    
            }
            
            ClsProvisioningHandler controller = new ClsProvisioningHandler();
            if(mapSpecIdsToUserIds!=null && mapSpecIdsToUserIds.size()>0){              
                controller.deProvisioningMethod(mapSpecIdsToUserIds, 'TeamRoomSpec');       
            }
            if(mapSubPDKIdsToUserIds!=null && mapSubPDKIdsToUserIds.size()>0){              
                controller.deProvisioningMethod(mapSubPDKIdsToUserIds, 'TeamRoomSubPDK');       
            }
            if(mapPackageIdsToUserIds!=null && mapPackageIdsToUserIds.size()>0){                
                controller.deProvisioningMethod(mapPackageIdsToUserIds, 'TeamRoomPackage');     
            }           
            
        }
                                
   }
   
   /**
        This method deprovisions the Team Room Provisioning records by removing Team Room Docs from a Team Room.

        @method name: teamRoomDeprovisioningByRemovingDocs
        @parameter:   List of Team Room Doc records removed from a Team Room.
        @return :     None.
     **/
     
   public static void teamRoomDeprovisioningByRemovingDocs(List<Team_Room_Doc__c> lstTeamRoomDoc){
    
        map<String,String> mapSpecIdsToTeamRoomId = new map<String,String>();
        map<String,String> mapPackageIdsToTeamRoomId = new map<String,String>();
        map<String,String> mapSubPDKIdsToTeamRoomId = new map<String,String>();
        map<Id,List<Id>> mapSpecIdsToUserIds = new map<Id,List<Id>>();
        map<Id,List<Id>> mapPackageIdsToUserIds = new map<Id,List<Id>>();
        map<Id,List<Id>> mapSubPDKIdsToUserIds = new map<Id,List<Id>>();
        
        if(lstTeamRoomDoc!=null && lstTeamRoomDoc.size()>0){        
            for(Team_Room_Doc__c trd:lstTeamRoomDoc){
                if(trd.Design_Spec__c!=null){
                    mapSpecIdsToTeamRoomId.put(trd.Design_Spec__c,trd.Team_Room__c);                    
                }
                else if(trd.Design_Package__c!=null){
                    mapPackageIdsToTeamRoomId.put(trd.Design_Package__c,trd.Team_Room__c);  
                }
                else if(trd.Sub_PDK__c!=null){
                    mapSubPDKIdsToTeamRoomId.put(trd.Sub_PDK__c,trd.Team_Room__c);  
                }                       
            } 
            for(Document_Provisioning__c dp: [Select Id, Design_Spec__c, Design_Package__c, Sub_PDK__c, Status__c, User__c, Team_Rooms_Provisioned_for__c 
            from Document_Provisioning__c where ((Design_Spec__c IN:mapSpecIdsToTeamRoomId.keySet()) OR (Design_Package__c IN:mapPackageIdsToTeamRoomId.keySet())
            OR (Sub_PDK__c IN:mapSubPDKIdsToTeamRoomId.keySet())) AND Status__c='Provisioned'] ){
                
                if(dp.Design_Spec__c!=null){
                    if(dp.Team_Rooms_Provisioned_for__c!=null && dp.Team_Rooms_Provisioned_for__c.contains(mapSpecIdsToTeamRoomId.get(dp.Design_Spec__c))){
                        List<Id> tempUserIdList = new List<Id>();
                        String specId = dp.Design_Spec__c;
                            
                        if(mapSpecIdsToUserIds!=null){                      
                            if(mapSpecIdsToUserIds.containsKey(specId)){
                                tempUserIdList = mapSpecIdsToUserIds.get(specId) ;
                            }
                            tempUserIdList.add(dp.User__c);
                            mapSpecIdsToUserIds.put(specId , tempUserIdList);
                        }       
                    }
                }
                else if(dp.Design_Package__c!=null){
                    if(dp.Team_Rooms_Provisioned_for__c!=null && dp.Team_Rooms_Provisioned_for__c.contains(mapPackageIdsToTeamRoomId.get(dp.Design_Package__c))){
                        List<Id> tempUserIdList = new List<Id>();
                        String specId = dp.Design_Package__c;
                            
                        if(mapPackageIdsToUserIds!=null){                       
                            if(mapPackageIdsToUserIds.containsKey(specId)){
                                tempUserIdList = mapPackageIdsToUserIds.get(specId) ;
                            }
                            tempUserIdList.add(dp.User__c);
                            mapPackageIdsToUserIds.put(specId , tempUserIdList);
                        }       
                    }
                }
                else if(dp.Sub_PDK__c!=null){
                    if(dp.Team_Rooms_Provisioned_for__c!=null && dp.Team_Rooms_Provisioned_for__c.contains(mapSubPDKIdsToTeamRoomId.get(dp.Sub_PDK__c))){
                        List<Id> tempUserIdList = new List<Id>();
                        String specId = dp.Sub_PDK__c;
                            
                        if(mapSubPDKIdsToUserIds!=null){                        
                            if(mapSubPDKIdsToUserIds.containsKey(specId)){
                                tempUserIdList = mapSubPDKIdsToUserIds.get(specId) ;
                            }
                            tempUserIdList.add(dp.User__c);
                            mapSubPDKIdsToUserIds.put(specId , tempUserIdList);
                        }       
                    }
                }   
                
            }
            ClsProvisioningHandler controller = new ClsProvisioningHandler();
            if(mapSpecIdsToUserIds!=null && mapSpecIdsToUserIds.size()>0){              
                controller.deProvisioningMethod(mapSpecIdsToUserIds, 'TeamRoomSpec');       
            }
            if(mapSubPDKIdsToUserIds!=null && mapSubPDKIdsToUserIds.size()>0){              
                controller.deProvisioningMethod(mapSubPDKIdsToUserIds, 'TeamRoomSubPDK');       
            }
            if(mapPackageIdsToUserIds!=null && mapPackageIdsToUserIds.size()>0){                
                controller.deProvisioningMethod(mapPackageIdsToUserIds, 'TeamRoomPackage');     
            }
        }                       
   }
    
    /**
        This method deprovisions the Spec Provisioning records when a Spec is deassociated from a Sub PDK.

        @method name: deassociateSpecFromSubPDK
        @parameter:   List of Sub PDK Spec records where a Spec is deassociated from a Sub PDK.
        @return :     None.
     **/
        
    public static void deassociateSpecFromSubPDK(List<Sub_PDK_Spec__c>  lstSubPDKSpec){
        
        Map<String, String> mapSpecToSubPDK = new Map<String, String>();
        Map<String, List<Document_Provisioning__c>> mapSpecToDocProv = new Map<String,List<Document_Provisioning__c>>(); // Added by Cognizant for CR # 00014659
        Set<String> setSpecIds = new Set<String>();
        List<Document_Provisioning__c> lstDocProvUpdate = new List<Document_Provisioning__c>();
        
        

        System.Debug('List size---'+lstSubPDKSpec.size());
        System.Debug('List val ---'+lstSubPDKSpec);        
            
            if(lstSubPDKSpec!=null && lstSubPDKSpec.size()>0){
            for(Sub_PDK_Spec__c sps: lstSubPDKSpec){
                mapSpecToSubPDK.put(sps.Design_Spec__c,sps.Sub_PDK__c); 
                setSpecIds.add(sps.Design_Spec__c); 
            }

        System.Debug('Dspec set ---'+setSpecIds);        
        System.Debug('Spec sub pdk map ---'+mapSpecToSubPDK);
        
            /** Added by Cognizant for CR # 00014659 starts**/
 
            if(setSpecIds!=null && setSpecIds.size()>0){
                for(Document_Provisioning__c objDP:[Select Id,name,Sub_PDK__c,Design_Package__c,Sub_PDK_Provisioned_for__c,Design_Spec__c FROM Document_Provisioning__c WHERE (Design_Spec__c IN:setSpecIds and Design_Package__c=null and  Sub_PDK__c=null and Unique_Id__c!=null and Design_Spec__c !=null)]){//modified by cognizant for Case 00036067
                    {
                        if(!mapSpecToDocProv.containsKey(objDP.Design_Spec__c))
                            mapSpecToDocProv.put(objDP.Design_Spec__c,new List<Document_Provisioning__c>{objDP});       
                        else
                            mapSpecToDocProv.get(objDP.Design_Spec__c).add(objDP);      
                    }
                }

         
        System.Debug('Spec doc prov map ---'+mapSpecToDocProv);
        
                
                if(mapSpecToDocProv!=null && mapSpecToDocProv.size()>0){
            System.Debug('Inside mthd if---');
                    for(String specId:mapSpecToDocProv.keySet()){ 
                        System.Debug('Inside for ---');
            
                        for(Document_Provisioning__c objDP : mapSpecToDocProv.get(specId)) 
            {
            String str = '';
            System.Debug('Doc prov rec ---'+objDP );
                        Set<String> nameSubPDKs = new Set<String>();
                        if(objDP.Sub_PDK_Provisioned_for__c!=null && objDP.Sub_PDK_Provisioned_for__c.contains(';')){
                            System.Debug('Inside Sub_PDK_Provisioned_for__c check ---');
                nameSubPDKs.addAll(objDP.Sub_PDK_Provisioned_for__c.split(';'));
                            objDP.Status__c = 'Provisioned';    
                        }
                        else{
                System.Debug('Inside else ---');
                            nameSubPDKs.add(objDP.Sub_PDK_Provisioned_for__c);
                            objDP.Status__c = 'De-Provisioned';
                        }

            System.Debug('Inside Sub_PDK_Provisioned_for  ---'+nameSubPDKs);
                        if(nameSubPDKs!=null && nameSubPDKs.size()>1){

            System.Debug('Inside nameSubPDKs check---');
                            for(String name:nameSubPDKs){
                                if(mapSpecToSubPDK.get(specId)!=name){
                                    if(str == ''){
                                        str = name;
                                    }
                                    else{
                                        str = str + ';' + name;
                                    }   
                                }   
                            }
                System.Debug('str val---'+str);
                            objDP.Sub_PDK_Provisioned_for__c = str; 
                        }
                        else{
                            System.Debug('Inside nameSubPDKs else---');                        
                            objDP.Sub_PDK_Provisioned_for__c = '';
                        }
                        lstDocProvUpdate.add(objDP);
            }
                    }
                 
        /** Added by Cognizant for CR # 00014659 ends**/ 

           
                    if(lstDocProvUpdate!=null && lstDocProvUpdate.size()>0){
                    
                         try{
                             update lstDocProvUpdate;
                         }
                         catch(DmlException ex){
                             System.debug('***Exception faced in Provisioning Update Is** ' + ex);
                         }
                     }
                }
                
            }
        }   
    }
    
    /**
        This method assigns the Old Revision of the Specs to a Locked Package.

        @method name: assignOldSpecToLockedPackage
        @parameter:   1. List of Spec records where a Spec is part of a Locked Package.
                      2. Set of Spec record Ids where a Spec is part of a Locked Package.
                      3. Map of revision Ids to Salesforce Ids of a Spec record.
        @return :     None.
     **/
     
     public static void assignOldSpecToLockedPackage(List<Design_Spec__c>  lstSpec, Set<Id>  setSpecIds, Map<Decimal,String> mapRevisionIdsToIds){
            
            Map<String, String> mapNewSpecIdsToOldSpecIds = new Map<String, String>();
            List<Package_Spec__c> lstPackageSpecToUpdate = new List<Package_Spec__c>();
            Map<String, Set<String>> mapSpecIdToPkgIds = new Map<String, Set<String>>();
            List<Document_Provisioning__c> lstProvsToInsert = new List<Document_Provisioning__c>();
            List<Document_Provisioning__c> lstProvsToUpdate = new List<Document_Provisioning__c>();
            
            if(mapRevisionIdsToIds!=null && mapRevisionIdsToIds.size()>0){
                                
                for(Design_Spec__c objDS:[Select Id, OpenText_Id__c from Design_Spec__c where OpenText_Id__c IN:mapRevisionIdsToIds.keySet()]){
                    if(mapRevisionIdsToIds.containsKey(objDS.OpenText_Id__c)){
                        mapNewSpecIdsToOldSpecIds.put(mapRevisionIdsToIds.get(objDS.OpenText_Id__c),objDS.Id);      
                    }       
                }
                
                if(setSpecIds!=null && setSpecIds.size()>0){
                                                    
                    for(Package_Spec__c objPS:[Select Id, Design_Spec__c, Package__c from Package_Spec__c where Design_Spec__c IN:setSpecIds 
                    AND Package_Is_Locked__c = true]){
                        
                        Set<String> tempSet = new Set<String>();
                        String specId = objPS.Design_Spec__c;
                            
                        if(mapSpecIdToPkgIds!=null){                        
                            if(mapSpecIdToPkgIds.containsKey(specId)){
                                tempSet = mapSpecIdToPkgIds.get(specId) ;
                            }
                            tempSet.add(objPS.Package__c);
                            mapSpecIdToPkgIds.put(specId , tempSet);
                        }
                            
                        if(mapNewSpecIdsToOldSpecIds!=null && mapNewSpecIdsToOldSpecIds.containsKey(objPS.Design_Spec__c)){
                            objPS.Design_Spec__c = mapNewSpecIdsToOldSpecIds.get(objPS.Design_Spec__c);
                            lstPackageSpecToUpdate.add(objPS);
                        }       
                    }
                    
                    if(lstPackageSpecToUpdate!=null && lstPackageSpecToUpdate.size()>0){
                        for(Document_Provisioning__c dp: [Select Id, Status__c, Design_Spec__c, Packages_Provisioned_for__c, Spec_Level_Provisioning__c,
                            User__c from Document_Provisioning__c where Design_Spec__c IN:setSpecIds]){
                                                
                            String str = '';
                            String strnew = ''; 
                            List<String> pckgNameList = new List<String>();
                            List<String> pckgNameListFinal = new List<String>(); 
                            List<String> pckgNameListForInsert = new List<String>(); 
                                                    
                            if(dp.Packages_Provisioned_for__c!=null){
                                if(dp.Packages_Provisioned_for__c.contains(';')){
                                    pckgNameList.addAll(dp.Packages_Provisioned_for__c.split(';'));     
                                }
                                else{
                                    pckgNameList.add(dp.Packages_Provisioned_for__c);   
                                }
                                
                                if(pckgNameList!=null && pckgNameList.size()>0){
                                    for(String s: pckgNameList){
                                        if(mapSpecIdToPkgIds!=null && mapSpecIdToPkgIds.containsKey(dp.Design_Spec__c) && !mapSpecIdToPkgIds.get(dp.Design_Spec__c).contains(s)){
                                            pckgNameListFinal.add(s);   
                                        }
                                        else{
                                            pckgNameListForInsert.add(s);   
                                        }   
                                    }
                                    if(pckgNameListFinal!=null && pckgNameListFinal.size()>0){
                                        str = pckgNameListFinal[0];
                                        if(pckgNameListFinal.size()>1){
                                            for(Integer i=1;i<pckgNameListFinal.size();i++){
                                                str = str + ';' + pckgNameListFinal[i];                                     
                                            }
                                        }
                                        dp.Packages_Provisioned_for__c = str;           
                                    }
                                    else{
                                        dp.Status__c = 'De-Provisioned' ;   
                                        dp.Packages_Provisioned_for__c = str;           
                                    }
                                }       
                            }
                            if(dp.Spec_Level_Provisioning__c){
                                dp.Status__c = 'Provisioned' ;          
                            }                                               
                            
                            Document_Provisioning__c dpNew = new Document_Provisioning__c();
                            dpNew.Status__c = 'Provisioned' ;                   
                            dpNew.User__c = dp.User__c;
                            
                            if(mapNewSpecIdsToOldSpecIds!=null && mapNewSpecIdsToOldSpecIds.containsKey(dp.Design_Spec__c)){
                                dpNew.Design_Spec__c = mapNewSpecIdsToOldSpecIds.get(dp.Design_Spec__c);        
                            }
                            if(pckgNameListForInsert!=null && pckgNameListForInsert.size()>0){
                                strnew = pckgNameListForInsert[0];
                                if(pckgNameListForInsert.size()>1){
                                    for(Integer i=1;i<pckgNameListForInsert.size();i++){
                                        strnew = strnew + ';' + pckgNameListForInsert[i];                                       
                                    }
                                }
                                dpNew.Packages_Provisioned_for__c = strnew;     
                            }
                            
                            lstProvsToUpdate.add(dp);
                            lstProvsToInsert.add(dpNew);
                        
                        }
                    }
                    
                    if(lstPackageSpecToUpdate!=null && lstPackageSpecToUpdate.size()>0){
                        
                         try{
                             update lstPackageSpecToUpdate;
                         }
                         catch(DmlException ex){
                             System.debug('***Exception faced in updating Package Spec is*** ' + ex);
                         }
                     }
                     
                     if(lstProvsToUpdate!=null && lstProvsToUpdate.size()>0){
                        
                         try{
                             update lstProvsToUpdate;
                         }
                         catch(DmlException ex){
                             System.debug('***Exception faced in updating Provisioning is*** ' + ex);
                         }
                     }
                     
                     if(lstProvsToInsert!=null && lstProvsToInsert.size()>0){
                        
                         try{
                             insert lstProvsToInsert;
                         }
                         catch(DmlException ex){
                             System.debug('***Exception faced in inserting Provisioning is*** ' + ex);
                         }
                     }                      
                }
            }
            
            
     }
     
     /**
        This method deprovisions all the Provisioning records of Sub PDKs or PDK Specs when a Master PDK record is marked as Obsolete.

        @method name: deprovisionAllForObsoletePDK
        @parameter:   Set of Master PDK record Ids when a Master PDK record is marked as Obsolete.
        @return :     None.
     **/
     
     public static void deprovisionAllForObsoletePDK(Set<Id>  setPDKIds){
        
        Set<Id> setChildSubPDKIds = new Set<Id>();
        Set<Id> setChildPDKSpecIds = new Set<Id>();
        List<Document_Provisioning__c> lstProvsToUpdate = new List<Document_Provisioning__c>();
        
        if(setPDKIds!=null && setPDKIds.size()>0){
        
            for(Sub_PDK__c obj: [Select Id from Sub_PDK__c where PDK__c IN:setPDKIds]){
                setChildSubPDKIds.add(obj.Id);      
            }
            for(Design_Spec__c obj: [Select Id from Design_Spec__c where PDK__c IN:setPDKIds]){
                setChildPDKSpecIds.add(obj.Id);     
            }
            for(Document_Provisioning__c objDP:[Select Id, Status__c,Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c,AccountID__r.Short_Name__c,Design_Spec__r.Specification_Release_List_long__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c from Document_Provisioning__c where Design_Spec__c IN: setChildPDKSpecIds
                                                OR Sub_PDK__c IN: setChildSubPDKIds]){
                lstProvsToUpdate.add(objDP);        
            }
            if(lstProvsToUpdate!=null && lstProvsToUpdate.size()>0){
                updateDocumentProvisioning(lstProvsToUpdate);                           
            }   
        }           
     }
     
     /**
        This method deprovisions all the Provisioning records of Patch Specs when a Patch record is marked as Obsolete.

        @method name: deprovisionAllForObsoletePDKPatch
        @parameter:   Set of Patch record Ids when a Patch record is marked as Obsolete.
        @return :     None.
     **/
     
     public static void deprovisionAllForObsoletePDKPatch(Set<Id>  setPDKPatchIds){
        
        Set<Id> setChildPDKSpecIds = new Set<Id>();
        List<Document_Provisioning__c> lstProvsToUpdate = new List<Document_Provisioning__c>();
        
        if(setPDKPatchIds!=null && setPDKPatchIds.size()>0){
        
            for(Design_Spec__c obj: [Select Id from Design_Spec__c where PDK_Patch__c IN:setPDKPatchIds]){
                setChildPDKSpecIds.add(obj.Id);     
            }
            if(setChildPDKSpecIds!=null && setChildPDKSpecIds.size()>0){
                for(Document_Provisioning__c objDP:[Select Id, Status__c,Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c,AccountID__r.Short_Name__c,Design_Spec__r.Specification_Release_List_long__c,Design_Spec__r.Release_Status__c,Design_spec__r.Lifecycle_Phase__c from Document_Provisioning__c where Design_Spec__c IN: setChildPDKSpecIds]){
                    lstProvsToUpdate.add(objDP);        
                }
                if(lstProvsToUpdate!=null && lstProvsToUpdate.size()>0){
                    updateDocumentProvisioning(lstProvsToUpdate);                           
                }
            }   
        }           
     }
     
     /**
        This method deprovisions all the Provisioning records of White List when a White List record is deleted.

        @method name: deprovisionForWhiteListDeletion
        @parameter:   List of White List records which have been deleted.
        @return :     None.
     **/
     
     public static void deprovisionForWhiteListDeletion(List<White_List__c> lstWhiteList){
        
        Set<String> setAllUserIds = new Set<String>();
        Set<String> setAllSubPDKIds = new Set<String>();
        Set<String> setAllPackageIds = new Set<String>();
        Map<String, Set<String>> mapItemIdsToAccountIds = new Map<String, Set<String>>();
        Map<String, List<String>> mapItemIdsToDocProvs = new Map<String, List<String>>();
        Map<String, String> mapUserIdsToAccIds = new Map<String, String>();
        List<Document_Provisioning__c> lstProvsToUpdate = new List<Document_Provisioning__c>();
        Map<Id,List<Id>> mapSpecIdsToUserIds = new Map<Id,List<Id>>();
        Map<Id,List<Id>> mapSubPDKIdsToUserIds = new Map<Id,List<Id>>();
        Map<Id,List<Id>> mapPackageIdsToUserIds = new Map<Id,List<Id>>();
                
        if(lstWhiteList!=null && lstWhiteList.size()>0){
            
            for(White_List__c objWL: lstWhiteList){
                if(objWL.Account__c!=null){
                    String itemId = '';
                    if(objWL.Design_Spec__c!=null){
                        itemId = objWL.Design_Spec__c;                                  
                    }
                    else if(objWL.Sub_PDK__c!=null){
                        itemId = objWL.Sub_PDK__c;
                        setAllSubPDKIds.add(itemId);    
                    }
                    else if(objWL.Package__c!=null){
                        itemId = objWL.Package__c;
                        setAllPackageIds.add(itemId);
                    }
                    Set<String> tempSet = new Set<String>();
                
                    if(mapItemIdsToAccountIds!=null){ 
                        if(mapItemIdsToAccountIds.containsKey(itemId)){
                            tempSet.addAll(mapItemIdsToAccountIds.get(itemId)) ;
                        }
                        tempSet.add(objWL.Account__c);
                        mapItemIdsToAccountIds.put(itemId , tempSet);
                    }  
    
                }       
            }
                        
            if(mapItemIdsToAccountIds!=null && mapItemIdsToAccountIds.size()>0){
                
                for(Document_Provisioning__c objDP:
                [Select Id, Status__c, User__c, Design_Spec__c, Sub_PDK__c, Design_Package__c from Document_Provisioning__c 
                where Design_Spec__c IN: mapItemIdsToAccountIds.keySet() OR 
                Sub_PDK__c IN:mapItemIdsToAccountIds.keySet() OR Design_Package__c IN:mapItemIdsToAccountIds.keySet()]){
                    
                    if(objDP.User__c!=null){
                        String itemId = '';
                        if(objDP.Design_Spec__c!=null){
                            itemId = objDP.Design_Spec__c;                                  
                        }
                        else if(objDP.Sub_PDK__c!=null){
                            itemId = objDP.Sub_PDK__c;  
                        }
                        else if(objDP.Design_Package__c!=null){
                            itemId = objDP.Design_Package__c;
                        }
                        List<String> tempList = new List<String>();
                    
                        if(mapItemIdsToDocProvs!=null){ 
                            if(mapItemIdsToDocProvs.containsKey(itemId)){
                                tempList.addAll(mapItemIdsToDocProvs.get(itemId)) ;
                            }
                            tempList.add(objDP.User__c);
                            mapItemIdsToDocProvs.put(itemId , tempList);
                        }
                        setAllUserIds.add(objDP.User__c);       
                    }   
                }
                
                if(setAllUserIds != null && setAllUserIds.size()>0){
                    for(User objUser:[Select Id, Parent_Account_Id__c from User where Id IN:setAllUserIds]){
                        mapUserIdsToAccIds.put(objUser.Id,objUser.Parent_Account_Id__c);       
                    }   
                }
                
                if(mapItemIdsToDocProvs != null && mapItemIdsToDocProvs.size()>0){
                    for(String itemId:mapItemIdsToDocProvs.keySet()){
                        if(mapItemIdsToDocProvs.containsKey(itemId)){
                            for(String userId:mapItemIdsToDocProvs.get(itemId)){
                                if(mapItemIdsToAccountIds!=null && mapItemIdsToAccountIds.containsKey(itemId)){
                                    if(mapItemIdsToAccountIds.get(itemId).contains(mapUserIdsToAccIds.get(userId))){
                                        List<Id> tempUserList = new List<Id>();
                                        
                                        if(setAllSubPDKIds.contains(itemId)){               
                                            if(mapSubPDKIdsToUserIds!=null){ 
                                                if(mapSubPDKIdsToUserIds.containsKey(itemId)){
                                                    tempUserList.addAll(mapSubPDKIdsToUserIds.get(itemId)) ;
                                                }
                                                tempUserList.add(userId);
                                                mapSubPDKIdsToUserIds.put(itemId , tempUserList);
                                            }       
                                        }
                                        
                                        else if(setAllPackageIds.contains(itemId)){
                                            if(mapPackageIdsToUserIds!=null){ 
                                                if(mapPackageIdsToUserIds.containsKey(itemId)){
                                                    tempUserList.addAll(mapPackageIdsToUserIds.get(itemId)) ;
                                                }
                                                tempUserList.add(userId);
                                                mapPackageIdsToUserIds.put(itemId , tempUserList);
                                            }   
                                        }
                                        
                                        else{
                                            if(mapSpecIdsToUserIds!=null){ 
                                                if(mapSpecIdsToUserIds.containsKey(itemId)){
                                                    tempUserList.addAll(mapSpecIdsToUserIds.get(itemId)) ;
                                                }
                                                tempUserList.add(userId);
                                                mapSpecIdsToUserIds.put(itemId , tempUserList);
                                            }
                                        }   
                                    }   
                                }
                            }   
                        }
                            
                    }
                    if(mapSpecIdsToUserIds != null && mapSpecIdsToUserIds.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.deProvisioningMethod(mapSpecIdsToUserIds, 'Spec');   
                    }
                    if(mapSubPDKIdsToUserIds != null && mapSubPDKIdsToUserIds.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.deProvisioningMethod(mapSubPDKIdsToUserIds, 'SubPDK');   
                    }
                    if(mapPackageIdsToUserIds != null && mapPackageIdsToUserIds.size()>0){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.deProvisioningMethod(mapPackageIdsToUserIds, 'Package'); 
                    }
                }
                    
            }
            
        }
            
     }
     
      /**
        This method populates the Account names for which provisioning has been done to Account Provisioned To fields.

        @method name: addAccountProvisionedTo
        @parameter:   List of provisioning records which have been provisioned.
        @return :     None.
     **/
     
   /*  public static void addAccountProvisionedTo(List<Document_Provisioning__c> lstDP){
        
        map<String, List<String>> mapItemIdsToAccountIds = new map<String, List<String>>();
        map<String, String> mapItemIdsToType = new map<String, String>();
        map<String, String> mapAccountIdsToAccountNames = new map<String, String>();
        map<String, Design_Spec__c> mapSpecIdsToRecords = new map<String, Design_Spec__c>();
        map<String, Sub_PDK__c> mapSubPDKIdsToRecords = new map<String, Sub_PDK__c>();
        map<String, Package__c> mapPackageIdsToRecords = new map<String, Package__c>();
        set<String> setDesignSpecIds = new set<String>();
        set<String> setPackageIds = new set<String>();
        set<String> setSubPDKIds = new set<String>();
        set<String> setAllAccountIds = new set<String>();
        list<Design_Spec__c> lstUpdateSpec = new list<Design_Spec__c>();
        list<Sub_PDK__c> lstUpdateSubPDK = new list<Sub_PDK__c>();
        list<Package__c> lstUpdatePackage = new list<Package__c>();
                
        if(lstDP!=null && lstDP.size()>0){
            for(Document_Provisioning__c dp:lstDP){
                List<String> tempAccList = new List<String>();
                String item = '';
                if(dp.Design_Spec__c!=null){
                    item = dp.Design_Spec__c;
                    setDesignSpecIds.add(item);
                    mapItemIdsToType.put(item,'Spec');      
                }
                else if(dp.Sub_PDK__c!=null){
                    item = dp.Sub_PDK__c;
                    setSubPDKIds.add(item);
                    mapItemIdsToType.put(item,'SubPDK');
                }
                else if(dp.Design_Package__c!=null){
                    item = dp.Design_Package__c;
                    setPackageIds.add(item);
                    mapItemIdsToType.put(item,'Package');
                }
                if(dp.User__c!=null){
                    setAllAccountIds.add(dp.Account__c);        
                }                                   
                if(mapItemIdsToAccountIds!=null){ 
                    if(mapItemIdsToAccountIds.containsKey(item)){
                        tempAccList.addAll(mapItemIdsToAccountIds.get(item)) ;
                    }
                    tempAccList.add(dp.Account__c);
                    mapItemIdsToAccountIds.put(item , tempAccList);
                }
            }
            if(setAllAccountIds!=null && setAllAccountIds.size()>0){
                for(Account acc:[Select Id, Name from Account where Id IN:setAllAccountIds]){
                    mapAccountIdsToAccountNames.put(acc.Id,acc.Name);       
                }   
            }
            if(setDesignSpecIds!=null && setDesignSpecIds.size()>0){
                for(Design_Spec__c item:[Select Id, Name, Accounts_Provisioned_To__c, Specification_Type__c from Design_Spec__c where 
                    Id IN:setDesignSpecIds AND Specification_Type__c NOT IN ('Stepper Tooling Forms','Reticle Grade Table')]){
                    mapSpecIdsToRecords.put(item.Id,item);      
                }   
            }
            if(setSubPDKIds!=null && setSubPDKIds.size()>0){
                for(Sub_PDK__c item:[Select Id, Name, Accounts_Provisioned_To__c from Sub_PDK__c where Id IN:setSubPDKIds]){
                    mapSubPDKIdsToRecords.put(item.Id,item);        
                }       
            }
            if(setPackageIds!=null && setPackageIds.size()>0){
                for(Package__c item:[Select Id, Name, Accounts_Provisioned_To__c from Package__c where Id IN:setPackageIds]){
                    mapPackageIdsToRecords.put(item.Id,item);       
                }       
            }
            if(mapItemIdsToAccountIds!=null && mapItemIdsToAccountIds.size()>0){
                Design_Spec__c ds;
                Sub_PDK__c subpdk;
                Package__c pck;
                for(String itemId:mapItemIdsToAccountIds.keySet()){                     
                    List<String> tempAcc = new List<String>();
                    tempAcc.addAll(mapItemIdsToAccountIds.get(itemId));
                    if(mapItemIdsToType.get(itemId)=='Spec'){
                        if(mapSpecIdsToRecords!=null && mapSpecIdsToRecords.containskey(itemId)){
                            ds = new Design_Spec__c();
                            ds = mapSpecIdsToRecords.get(itemId);
                        }       
                    }
                    else if(mapItemIdsToType.get(itemId)=='SubPDK'){
                        if(mapSubPDKIdsToRecords!=null && mapSubPDKIdsToRecords.containskey(itemId)){
                            subpdk = new Sub_PDK__c();
                            subpdk = mapSubPDKIdsToRecords.get(itemId);
                        }   
                    }
                    else if(mapItemIdsToType.get(itemId)=='Package'){
                        if(mapPackageIdsToRecords!=null && mapPackageIdsToRecords.containskey(itemId)){
                            pck = new Package__c();
                            pck = mapPackageIdsToRecords.get(itemId);
                        }       
                    }
                    for(String accId:tempAcc){
                        String accName = mapAccountIdsToAccountNames.get(accId);
                       if(accName!=null)//added by cognizant
                        { //added by cognizant
                        if(ds!=null){                                           
                            if(ds.Accounts_Provisioned_To__c==null){
                                ds.Accounts_Provisioned_To__c = accName;            
                            }
                            else if(!ds.Accounts_Provisioned_To__c.contains(accName)){
                                ds.Accounts_Provisioned_To__c = ds.Accounts_Provisioned_To__c + ';' + accName;  
                            }
                        }
                        else if(subpdk!=null){
                            if(subpdk.Accounts_Provisioned_To__c==null){
                                subpdk.Accounts_Provisioned_To__c = accName;            
                            }
                            else if(!subpdk.Accounts_Provisioned_To__c.contains(accName)){
                                subpdk.Accounts_Provisioned_To__c = subpdk.Accounts_Provisioned_To__c + ';' + accName;  
                            }
                        }
                        else if(pck!=null){
                            if(pck.Accounts_Provisioned_To__c==null){
                                pck.Accounts_Provisioned_To__c = accName;           
                            }
                            else if(!pck.Accounts_Provisioned_To__c.contains(accName)){
                                pck.Accounts_Provisioned_To__c = pck.Accounts_Provisioned_To__c + ';' + accName;    
                            }                           
                        }
                        
                       }   //added by cognizant         
                    }
                    if(ds!=null){
                        lstUpdateSpec.add(ds);  
                    }
                    else if(subpdk!=null){
                        lstUpdateSubPDK.add(subpdk);    
                    }
                    else if(pck!=null){
                        lstUpdatePackage.add(pck);
                    }                                                                       
                }
                if(lstUpdateSpec!=null && lstUpdateSpec.size()>0){
                    try{
                        update lstUpdateSpec;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }   
                }
                if(lstUpdateSubPDK!=null && lstUpdateSubPDK.size()>0){
                    try{
                        update lstUpdateSubPDK;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }   
                }
                if(lstUpdatePackage!=null && lstUpdatePackage.size()>0){
                    try{
                        update lstUpdatePackage;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }   
                }   
            }           
        }
     }*/
     
     /**
        This method removes the Account names for which de-provisioning has been done to Account Provisioned To fields.

        @method name: removeAccountProvisionedTo
        @parameter:   List of provisioning records which have been de-provisioned.
        @return :     None.
     **/
     
   /*  public static void removeAccountProvisionedTo(List<Document_Provisioning__c> lstDP,set<String> setAllAccountIds){
        
        map<String, set<String>> mapItemIdsToAccountIds = new map<String, set<String>>();
        map<String, set<String>> mapExistingOtherItemIdsToAccountIds = new map<String, set<String>>();
        map<String, Design_Spec__c> mapSpecIdsToRecords = new map<String, Design_Spec__c>();
        map<String, Sub_PDK__c> mapSubPDKIdsToRecords = new map<String, Sub_PDK__c>();
        map<String, Package__c> mapPackageIdsToRecords = new map<String, Package__c>();
        set<String> setDesignSpecIds = new set<String>();
        set<String> setPackageIds = new set<String>();
        set<String> setSubPDKIds = new set<String>();
        set<String> setAllDPIds = new set<String>();
        list<Design_Spec__c> lstUpdateSpec = new list<Design_Spec__c>();
        list<Sub_PDK__c> lstUpdateSubPDK = new list<Sub_PDK__c>();
        list<Package__c> lstUpdatePackage = new list<Package__c>();
                        
        if(lstDP!=null && lstDP.size()>0){
            for(Document_Provisioning__c dp:lstDP){
                setAllDPIds.add(dp.Id);
                set<String> tempAccSet = new set<String>();
                String item = '';
                if(dp.Design_Spec__c!=null){
                    item = dp.Design_Spec__c;
                    setDesignSpecIds.add(item);                     
                }
                else if(dp.Sub_PDK__c!=null){
                    item = dp.Sub_PDK__c;
                    setSubPDKIds.add(item);                 
                }
                else if(dp.Design_Package__c!=null){
                    item = dp.Design_Package__c;
                    setPackageIds.add(item);                    
                }
                                                
                if(mapItemIdsToAccountIds!=null){ 
                    if(mapItemIdsToAccountIds.containsKey(item)){
                        tempAccSet.addAll(mapItemIdsToAccountIds.get(item)) ;
                    }
                    tempAccSet.add(dp.Account_Short_Name__c);
                    mapItemIdsToAccountIds.put(item , tempAccSet);
                }
            }
            if(mapItemIdsToAccountIds!=null && mapItemIdsToAccountIds.size()>0){
                
                for(Document_Provisioning__c dp:[Select Id, Name, Status__c, User__c, Account__c, Account_Short_Name__c, Design_Spec__c, Sub_PDK__c, Design_Package__c
                from Document_Provisioning__c where (Status__c='Provisioned') AND (Id NOT IN:setAllDPIds) AND (Account_Short_Name__c IN:setAllAccountIds) 
                AND ((Design_Spec__c IN:setDesignSpecIds) OR (Sub_PDK__c IN:setSubPDKIds) OR (Design_Package__c IN:setPackageIds))]){               
                    
                    set<String> tempAccSet = new set<String>();
                    String item = '';
                    if(dp.Design_Spec__c!=null){
                        item = dp.Design_Spec__c;   
                    }
                    else if(dp.Sub_PDK__c!=null){
                        item = dp.Sub_PDK__c;
                    }
                    else if(dp.Design_Package__c!=null){
                        item = dp.Design_Package__c;
                    }
                    if(mapExistingOtherItemIdsToAccountIds!=null){ 
                        if(mapExistingOtherItemIdsToAccountIds.containsKey(item)){
                            tempAccSet.addAll(mapExistingOtherItemIdsToAccountIds.get(item)) ;
                        }
                        tempAccSet.add(dp.Account_Short_Name__c);
                        mapExistingOtherItemIdsToAccountIds.put(item , tempAccSet);
                    }                                   
                }
                            
            }
            
            if(setDesignSpecIds!=null && setDesignSpecIds.size()>0){
                for(Design_Spec__c item:[Select Id, Name, Accounts_Provisioned_To__c from Design_Spec__c where Id IN:setDesignSpecIds]){
                    mapSpecIdsToRecords.put(item.Id,item);                          
                }   
            }
            if(setSubPDKIds!=null && setSubPDKIds.size()>0){
                for(Sub_PDK__c item:[Select Id, Name, Accounts_Provisioned_To__c from Sub_PDK__c where Id IN:setSubPDKIds]){
                    mapSubPDKIdsToRecords.put(item.Id,item);        
                }       
            }
            if(setPackageIds!=null && setPackageIds.size()>0){
                for(Package__c item:[Select Id, Name, Accounts_Provisioned_To__c from Package__c where Id IN:setPackageIds]){
                    mapPackageIdsToRecords.put(item.Id,item);       
                }       
            }
            if(mapItemIdsToAccountIds!=null && mapItemIdsToAccountIds.size()>0){
                Design_Spec__c ds;
                Sub_PDK__c subpdk;
                Package__c pck;
                for(String itemId:mapItemIdsToAccountIds.keySet()){                     
                    set<String> tempAcc = new set<String>();
                    list<String> nameList = new list<String>();
                    list<String> nameListFinal = new list<String>(); 
                        
                    tempAcc.addAll(mapItemIdsToAccountIds.get(itemId));
                    if(mapSpecIdsToRecords!=null && mapSpecIdsToRecords.containsKey(itemId)){
                        ds = new Design_Spec__c();
                        ds = mapSpecIdsToRecords.get(itemId);
                        if(ds.Accounts_Provisioned_To__c!=null){
                            nameList.addAll(generateNameList(ds.Accounts_Provisioned_To__c));
                        }       
                    }
                    else if(mapSubPDKIdsToRecords!=null && mapSubPDKIdsToRecords.containsKey(itemId)){
                        subpdk = new Sub_PDK__c();
                        subpdk = mapSubPDKIdsToRecords.get(itemId);
                        if(subpdk.Accounts_Provisioned_To__c!=null){
                            nameList.addAll(generateNameList(subpdk.Accounts_Provisioned_To__c));
                        }       
                    }
                    else if(mapPackageIdsToRecords!=null && mapPackageIdsToRecords.containsKey(itemId)){
                        pck = new Package__c();
                        pck = mapPackageIdsToRecords.get(itemId);
                        if(pck.Accounts_Provisioned_To__c!=null){
                            nameList.addAll(generateNameList(pck.Accounts_Provisioned_To__c));
                        }       
                    }
                    
                    String str = '';                    
                    if(nameList!=null && nameList.size()>0){                                        
                        for(String s: nameList){
                            if((!tempAcc.contains(s))||(tempAcc.contains(s)&&(mapExistingOtherItemIdsToAccountIds!=null && mapExistingOtherItemIdsToAccountIds.containsKey(itemId) 
                            && mapExistingOtherItemIdsToAccountIds.get(itemId).contains(s)))){
                                nameListFinal.add(s);
                            }
                        }               
                    }
                    if(nameListFinal!=null && nameListFinal.size()>0){
                        str = nameListFinal[0];
                        if(nameListFinal.size()>1){
                            for(Integer i=1;i<nameListFinal.size();i++){
                                str = str + ';' + nameListFinal[i];                                       
                            }
                        }      
                    }
                        
                    if(ds!=null){
                        ds.Accounts_Provisioned_To__c = str;
                        lstUpdateSpec.add(ds);  
                    }
                    else if(subpdk!=null){
                        subpdk.Accounts_Provisioned_To__c = str;
                        lstUpdateSubPDK.add(subpdk);    
                    }
                    else if(pck!=null){
                        pck.Accounts_Provisioned_To__c = str;
                        lstUpdatePackage.add(pck);
                    }                                                                       
                }
                if(lstUpdateSpec!=null && lstUpdateSpec.size()>0){
                    try{
                        update lstUpdateSpec;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }   
                }
                if(lstUpdateSubPDK!=null && lstUpdateSubPDK.size()>0){
                    try{
                        update lstUpdateSubPDK;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }   
                }
                if(lstUpdatePackage!=null && lstUpdatePackage.size()>0){
                    try{
                        update lstUpdatePackage;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }   
                }   
            }           
        }
     }*/
     
     /**
        This method generates the Account Provisioned To name after concatenating the different Account names by splitting with semi-colons.

        @method name: generateNameList
        @parameter:   String to be split and concatenated.
        @return :     List of Strings after concatenation.
     **/
     
   /*  public static list<String> generateNameList(String accProvTo){
        
        list<String> names = new list<String>();
        
        if(accProvTo.contains(';')){
            names.addAll(accProvTo.split(';'));
        }
        else{
            names.add(accProvTo);
        }
        
        return names;
     }*/
     
     /**
        This method deletes the patch records and reassigns Spec records to Master PDK records when a new PDK version comes.

        @method name: reassignSpecsToPDK
        @parameter:   Set of Master PDK Ids for which a new Version has come.
        @return :     None.
     **/
     
     public static void reassignSpecsToPDK(Set<Id> setPDKIds){
        
        Map<Id,Id> mapPatchToPDKIds = new Map<Id,Id>();
        Map<Id,Decimal> mapPatchIdToPDKOTId = new Map<Id,Decimal>();
        List<PDK_Patch__c> lstPatchesToDelete = new List<PDK_Patch__c>();
        List<Design_Spec__c> lstPDKSpecsToUpdate = new List<Design_Spec__c>();
/*-------added on 09072014 for Case 00029532 start------------------------------------------------------*/       
        List<Design_Spec__c> lstPatchSpecsToDelete= new List<Design_Spec__c>();
        List<Sub_PDK_Spec__c> lstPDKSpecsToDelete= new List<Sub_PDK_Spec__c>();
        Set<Id> SetofSpecIds=new Set<Id>();
        Set<Id> SetOfSubPdkIds=new Set<Id>();
        Set<Id> SetOfPdkSpecIds =new Set<Id>();
/*-------added on 09072014 for Case 00029532 end------------------------------------------------------*/  
 
        if(setPDKIds!=null && setPDKIds.size()>0){
    
            for(PDK_Patch__c obj: [Select Id,PDK__c,PDK__r.Opentext_Id__c from PDK_Patch__c where PDK__c IN:setPDKIds]){
                mapPatchToPDKIds.put(obj.Id,obj.PDK__c);
                mapPatchIdToPDKOTId.put(obj.Id,obj.PDK__r.Opentext_Id__c);
                lstPatchesToDelete.add(obj);        
            }
            if(mapPatchToPDKIds!=null && mapPatchToPDKIds.size()>0){
            
/*-------commented on 09072014 for Case 00029532 start------------------------------------------------------*/                  
              /*  for(Design_Spec__c objDP:[Select Id, PDK_Patch__c, PDK__c from Design_Spec__c where PDK_Patch__c IN: mapPatchToPDKIds.keySet()]){
                    objDP.PDK__c = mapPatchToPDKIds.get(objDP.PDK_Patch__c);
                    objDP.ParentID__c = mapPatchIdToPDKOTId.get(objDP.PDK_Patch__c);
                    objDP.PDK_Patch__c = null;
                    lstPDKSpecsToUpdate.add(objDP);     
                }
                if(lstPDKSpecsToUpdate!=null && lstPDKSpecsToUpdate.size()>0){
                    try{
                        update lstPDKSpecsToUpdate;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }                           
                }*/
/*-------commented on 09072014 for Case 00029532 end------------------------------------------------------*/   

/*----added on 09072014 for Case 00029532 start---------------------------------------------*/                           
          for(Design_Spec__c objDP:[Select Id, PDK_Patch__c, PDK__c from Design_Spec__c where PDK_Patch__c !=Null and PDK_Patch__c IN: mapPatchToPDKIds.keySet()])
            {
            system.debug('objDP$$$$'+objDP);
             lstPatchSpecsToDelete.add(objDP);    
            SetofSpecIds.add(objDP.Id);
            }
            
            
            
          for(Sub_PDK__c objsubpdk:[Select Id,PDK__c from Sub_PDK__c where PDK__c in:setPDKIds])
          {
          SetOfSubPdkIds.add(objsubpdk.Id);
          }
          //Prajnith K Modified
          map<ID,list<Sub_PDK_spec__c>>  PDK_SubPdkMap = new map<ID,list<Sub_PDK_spec__c>>(); // pdk bundle id, sub pdk spec list                 
                    
          for(Sub_PDK_spec__c objspec:[Select Id,Sub_PDK__c,Design_Spec__c,Design_Spec__r.OpenText_ID__c,Design_Spec__r.Name,OTID__c  from Sub_PDK_spec__c where Sub_PDK__c in:SetOfSubPdkIds and Design_Spec__c in:SetofSpecIds])          
          {
          SetOfPdkSpecIds.add(objspec.Id);
                // Modified by Prajnith K
                if(objspec.Sub_PDK__c != null){             
                    if(!PDK_SubPdkMap.containskey(objspec.Sub_PDK__c)){
                        PDK_SubPdkMap.put(objspec.Sub_PDK__c, new list<Sub_PDK_spec__c>());
                        PDK_SubPdkMap.get(objspec.Sub_PDK__c).add(objspec);
                    }
                    else{
                        PDK_SubPdkMap.get(objspec.Sub_PDK__c).add(objspec);
                    }
                }
                          
          }
         
          // remove the pdk association ids from DP before deleting.
          if(!PDK_SubPdkMap.keyset().isEmpty())
            updateDocuProv(PDK_SubPdkMap);
             
          lstPDKSpecsToDelete =[Select Id from Sub_PDK_Spec__c where id in:SetOfPdkSpecIds];
          
         /* for(Design_Spec__c objDP:[Select Id, PDK_Patch__c, PDK__c, (SELECT id FROM Design_Spec__c.Sub_PDK_Specs__r) from Design_Spec__c where PDK_Patch__c !=Null and PDK_Patch__c IN: mapPatchToPDKIds.keySet()])
          {
          lstPatchSpecsToDelete.add(objDP);  
          lstPDKSpecsToDelete.add(objDP.Sub_PDK_Specs__r);
          }*/
           system.debug('lstPatchSpecsToDelete$$$$'+lstPatchSpecsToDelete);
           system.debug('lstPDKSpecsToDelete$$$$'+lstPDKSpecsToDelete);
           
            if(lstPDKSpecsToDelete!=null && lstPDKSpecsToDelete.size()>0){
                    try{
                    system.debug('pdk spec delete$$$$');
                        delete lstPDKSpecsToDelete;
                    }
                    catch(Exception ex){
                        System.debug('Exception thrown while delete of pdk spec'+ex);
                    }                           
                }
            if(lstPatchSpecsToDelete!=null && lstPatchSpecsToDelete.size()>0){
                    try{
                    system.debug('delete$$$$');
                        delete lstPatchSpecsToDelete;
                    }
                    catch(Exception ex){
                        System.debug('Exception thrown while delete'+ex);
                    }                           
                }
/*----added on 09072014 for Case 00029532 end---------------------------------------------*/         
                      
                
                if(lstPatchesToDelete!=null && lstPatchesToDelete.size()>0){
                    try{
                        delete lstPatchesToDelete;
                    }
                    catch(Exception ex){
                        System.debug(ex);
                    }                           
                }
            }   
        }           
     }
     /**
        This method updates the document provisioning records based on pdk association records.

        @method name: updateDocuProv
        @parameter:  map with key of Pdkspec ids and list of pdk association records.
        @Void :
        Author -  Prajnith Karra 12/08/2015        
     **/

     public static void updateDocuProv(map<ID,list<Sub_PDK_spec__c>> PDK_SubPdkMap) 
     {
        list<Document_Provisioning__c> docProvList = new list<Document_Provisioning__c>();
          // get all the Document Provisioning records.

          for(Document_Provisioning__c docpro : [SELECT ID,PdkSpecs__c,Sub_PDK__c,PDK_Spec_Names__c,Status__c,Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c,Design_spec__r.Release_Status__c,Design_spec__c FROM Document_Provisioning__c WHERE Sub_PDK__c IN: PDK_SubPdkMap.keyset()]){
                                
                if(docpro.Sub_PDK__c != null && PDK_SubPdkMap.containskey(docpro.Sub_PDK__c) && !PDK_SubPdkMap.get(docpro.Sub_PDK__c).isEmpty()){
                    boolean addSemicolon = false; 
                    boolean isfieldUpdated = false; 
                          system.debug('DP Record***'+docpro.ID);
                          system.debug('DP Record***'+docpro.PDK_Spec_Names__c);
                          system.debug('DP Record***'+docpro.PdkSpecs__c);  
                          system.debug('Assocaition Records***'+PDK_SubPdkMap.get(docpro.Sub_PDK__c).size());
                          
                                                             
                    for(Sub_PDK_spec__c sPdkSpec : PDK_SubPdkMap.get(docpro.Sub_PDK__c)){
                          //if(String.isEmpty(docpro.PDK_Spec_Names__c) || String.isEmpty(docpro.PdkSpecs__c))
                          //  break ;  
                                                 
                          if(!addSemicolon){
                                 addSemicolon = true;
                                docpro.PDK_Spec_Names__c = docpro.PDK_Spec_Names__c + ';';
                                docpro.PdkSpecs__c = docpro.PdkSpecs__c + ';';
                          }                                                  
                          if(docpro.PDK_Spec_Names__c.contains(String.valueOf(sPdkSpec.Design_Spec__r.Name+';'))){            
                                docpro.PDK_Spec_Names__c=docpro.PDK_Spec_Names__c.remove(String.valueOf(sPdkSpec.Design_Spec__r.Name+';')).deleteWhitespace();                                                                                                                                                                                                   
                                docpro.PDK_Spec_Names__c = docpro.PDK_Spec_Names__c.replaceAll(';',';\n').trim();
                                isfieldUpdated = true;
                          }                                               
                          if(sPdkSpec.Design_Spec__r.OpenText_ID__c != null && sPdkSpec.OTID__c != null){
                                docpro.PdkSpecs__c=docpro.PdkSpecs__c.remove(String.valueOf(sPdkSpec.Design_Spec__r.OpenText_ID__c)+':'+sPdkSpec.OTID__c+';').deleteWhitespace();                                                           
                                isfieldUpdated = true;                              
                          }
                    }
/*
                        // if PDK bundle is made obsolete                       
                        if(docpro.Sub_PDK__c!=null && docpro.Sub_PDK__r.Sub_PDK_Lifecycle_Phase__c=='OBSOLETE')
                        {
                            docpro.Status__c = 'De-Provisioning In Progress';                        
                        }
                        // if a Design spec is made obsolete just de Provision the DP record
                        if(docpro.Design_spec__c!=null && docpro.Design_spec__r.Release_Status__c!='General Release')
                        {                      
                            docpro.Status__c = 'De-Provisioning In Progress';                        
                        }
*/                                      

                    
                    if(isfieldUpdated){
                        //if(isObsoleteCall == false)
                            //docpro.isProvUpdate__c = true;
                        docpro.PDK_Spec_Names__c=docpro.PDK_Spec_Names__c.removeEnd(';');
                        docpro.PdkSpecs__c=docpro.PdkSpecs__c.removeEnd(';');
                        if(docpro.PDK_Spec_Names__c == 'null'){
                            //docpro.Status__c = 'De-Provisioning In Progress';
                            docpro.PDK_Spec_Names__c = '';
                        }
                        if(docpro.PdkSpecs__c == 'null'){
                            //docpro.Status__c = 'De-Provisioning In Progress';
                            docpro.PdkSpecs__c = '';
                        }       
                        docProvList.add(docpro); 
                    }
                                       
                                           
                }   
                                    
           }
            system.debug('**dp.PdkSpecs__c***'+docProvList);
           if(!docProvList.isEmpty())
            update docProvList;
     }
      
     /**
        This method populates the Account Provisioned To value when a Stepper Tooling Forms Specification is auto-provisioned.

        @method name: addAccProvToSTF
        @parameter:   List of Specification of type Stepper Tooling Forms.
        @return :     List of Specification of type Stepper Tooling Forms after update.
     **/
     
     public static List<Design_Spec__c> addAccProvToSTF (List<Design_Spec__c> listSTF){
     
        List<Design_Spec__c> listSTFmodified = new List<Design_Spec__c>();
        
        Map<String, List<String>> mapDSIdToAccLists = new Map<String, List<String>>();
        Map<String, String> mapAccSNToAccNames = new Map<String, String>();
        Set<String> setAllAccIds = new Set<String>();
        List<Document_Provisioning__c> lstDocProvToAutoInsert = new List<Document_Provisioning__c>();
        
        system.debug('enter if listSTF$$$'+listSTF);
        
        if(listSTF!=null && listSTF.size()>0){
            for(Design_Spec__c objDS: listSTF){
                List<String> accList = new List<String>();
                 system.debug('objDS.Specification_Release_List_Long__c$$'+objDS.Specification_Release_List_Long__c);
                 system.debug('objDS.Specification_Release_List_Long__c$$'+objDS.Specification_Release_List_Long__c.contains(';'));
                if(objDS.Specification_Release_List_Long__c.contains(';')){ // CR # 4562 - Field replaced
                    accList.addAll(objDS.Specification_Release_List_Long__c.toLowerCase().split(';')); // CR # 4562 - Field replaced   
                    
                  system.debug('enter if$$');     
                }   
                else{
                    accList.add(objDS.Specification_Release_List_Long__c.toLowerCase());   // CR # 4562 - Field replaced  
                    
                    system.debug('enter ifelse$$');  
                }
                
                system.debug('accList$$'+accList);  
                setAllAccIds.addAll(accList);
                mapDSIdToAccLists.put(objDS.Id,accList);
                
                system.debug('setAllAccIds$$'+setAllAccIds);  
                system.debug('mapDSIdToAccLists$$'+mapDSIdToAccLists);  
            }
            
            if(setAllAccIds!=null && setAllAccIds.size()>0){
                for(Account objAcc:[Select Id, Name, Short_Name__c from Account where Short_Name__c IN: setAllAccIds]){                 
                    mapAccSNToAccNames.put(objAcc.Short_Name__c,objAcc.Name);    
                }   
            }
            
            system.debug('mapAccSNToAccNames$$'+mapAccSNToAccNames);
            
            for(Design_Spec__c objDS: listSTF){
                String str = '';
                List<String> accList = new List<String>();
                accList.addAll(mapDSIdToAccLists.get(objDS.Id));
                
                system.debug('accList$$%%%'+accList);  
                
                if(accList!=null && accList.size()>0){                  
                    for(String accShortName: accList){
                        if(mapAccSNToAccNames!=null && mapAccSNToAccNames.containsKey(accShortName)){
                            if(str==''){
                                str = mapAccSNToAccNames.get(accShortName);
                                
                                system.debug('enter str if$$%%%'+str );  
                            }
                            else{
                                str = str + ';' + mapAccSNToAccNames.get(accShortName); 
                                
                                system.debug('enter str else$$%%%'+str ); 
                            }                           
                        }  
                    }
                    
                    system.debug('str$$%%%'+str ); 
                    objDS.Accounts_Provisioned_To__c = str;
                    listSTFmodified.add(objDS);   
                    
                    system.debug('listSTFmodified$$%%%'+listSTFmodified);
                }
            }
             
        }   
        
        return listSTFmodified; 
     }
  /* Added new Class 
  SubPDKNameForPatchRevDateChange for Issue -25527 on 02062014 START */
   
   public static void modifySubPDKNameForPatchRevDateChange(Set<Id> patchUpdDtTm)
   {
        List<Design_Spec__c> patchSpecs = [ SELECT Id, PDK_Patch__c FROM Design_Spec__c WHERE  PDK_Patch__c IN: patchUpdDtTm];
        System.debug('KrishTesting-patchSpecs='+patchSpecs) ; 
        Map<Id, List<Id>> mapBundleToLstSpecs = new Map<Id, List<Id>>() ;
        Map<Id, Set<Id>> mapBundleToSetPatch = new Map<Id, Set<Id>>() ;
        Map<Id,Sub_PDK_Spec__c> mapsubPdkTosubPdkSpec=new Map<Id,Sub_PDK_Spec__c> ();


        /** 
        New Filed Created on Object 'Sub_PDK_Spec__c' 
            1. Spec_Patch_Id__c 
            2. Spec_Patch_Master_PDK_Version__c 
            3. Spec_Patch_Release_Date_Time__c
        **/


        for( Sub_PDK_Spec__c pdkSpecs:[SELECT Id, Name, Sub_PDK__c, Design_Spec__c, Spec_Patch_Id__c FROM Sub_PDK_Spec__c 
        WHERE  Sub_PDK__c !=null and Design_Spec__c != null and Spec_Patch_Id__c !=null and 
        Design_Spec__c IN: patchSpecs ORDER BY Sub_PDK__c] 
        ) 
        {
            if(mapBundleToSetPatch.containsKey(pdkSpecs.Sub_PDK__c))
            {
                /*
                List<Id> tempLstSpecs = mapBundleToLstSpecs.get(pdkSpecs.Sub_PDK__c) ; 
                tempLstSpecs.add(pdkSpecs.Design_Spec__c) ; 
                mapBundleToLstSpecs.put(pdkSpecs.Sub_PDK__c,tempLstSpecs) ; 
                */
                Set<Id> tempSetPatch = mapBundleToSetPatch.get(pdkSpecs.Sub_PDK__c) ; 
                tempSetPatch.add(pdkSpecs.Spec_Patch_Id__c) ; 
                mapBundleToSetPatch.put(pdkSpecs.Sub_PDK__c,tempSetPatch) ; 
                     
            }
            else{
                Set<Id> tempSetPatch = new Set<Id>() ;
                tempSetPatch.add(pdkSpecs.Spec_Patch_Id__c) ; 
                mapBundleToSetPatch.put(pdkSpecs.Sub_PDK__c,tempSetPatch) ;          
            }
        
        }
        System.debug('KrishTesting-mapBundleToSetPatch='+mapBundleToSetPatch) ;
        
        List<Sub_PDK__c> lstBundleNameUpdate = new List<Sub_PDK__c>() ;

    for(sub_pdk_spec__c  subpdkspecObj :[select id,sub_pdk__c,Spec_Patch_Master_PDK_Version__c from sub_pdk_spec__c 
        where sub_pdk__c in :mapBundleToSetPatch.keySet() and sub_pdk__c!=null and Spec_Patch_Id__c !=null order by Spec_Patch_Counter__c desc ]
    )
    {
        if(!mapsubPdkTosubPdkSpec.containsKey(subpdkspecObj.sub_pdk__c))
        {
            mapsubPdkTosubPdkSpec.put(subpdkspecObj.sub_pdk__c,subpdkspecObj);
        }
    }
    
        
        for(Sub_PDK__c bundle : [ SELECT Id, Master_PDK_Doc_Title__c, Name, Bundle_Name__c FROM Sub_PDK__c  WHERE Id IN :mapBundleToSetPatch.keySet()] )
        {
            /*
        List<PDK_Patch__c> latestPatch =[SELECT Id,name,PDK_Revision_Release_Date__c,PDK_Version__c FROM PDK_Patch__c 
        WHERE Id In: mapBundleToSetPatch.get(bundle.Id) ORDER BY PDK_Revision_Release_Date__c DESC LIMIT 1];
                System.debug('KrishTesting-latestPatch='+latestPatch);
                if(latestPatch!= null && latestPatch.size()>0)
                {
                    bundle.Name = 'PDK ' + bundle.Master_PDK_Doc_Title__c+ ' '+mapsubPdkTosubPdkSpec.get(bundle.Id).Spec_Patch_Master_PDK_Version__c +' - ' +bundle.Bundle_Name__c; 
                    System.debug('KrishTesting');
                    lstBundleNameUpdate.add(bundle) ;
                }
       */
        if(mapsubPdkTosubPdkSpec.containsKey(bundle.Id))
        {
            String str = 'PDK ' + bundle.Master_PDK_Doc_Title__c+ ' '+mapsubPdkTosubPdkSpec.get(bundle.Id).Spec_Patch_Master_PDK_Version__c +' - ' +bundle.Bundle_Name__c; 
            if(str.length()>80)
            {
                bundle.Name = str.substring(0,80);//Added by kunal
            }
            else
            {
                bundle.Name = str;
            }
            bundle.Full_PDK_Name__c = str;
            lstBundleNameUpdate.add(bundle) ;
        }
            
        }
        
        System.debug('KrishTesting-lstBundleNameUpdate='+lstBundleNameUpdate) ;
        
        try{
            update lstBundleNameUpdate ;
        }
        catch(Exception e)
        {
            system.debug(e) ; 
        }
   }
   
    /* Added new Class modifySubPDKNameForPatchRevDateChange for Issue -25527 on 02062014 END */
         
     /**
        This method modifies the name of the PDKs associated with Master PDKs when the name of the Master PDKs get modified.

        @method name: modifySubPDKName
        @parameter:   Map of Master PDK Ids to Master PDK Names.
        @return :     None.
     **/
     
   public static void modifySubPDKName(Map<Id, String> mapPDKIdsToPDKNames){
        
    List<Sub_PDK__c> listSPDKNamesMod = new List<Sub_PDK__c>();
   
    string str=''; //added by cognizant 
    Set<String> setSubPDKIds = new Set<String>();//added by cognizant
    Set<String> setDesignSpecId= new Set<String>();//added by cognizant
    Set<String> SetPatchId= new Set<String>();//added by cognizant
    
    List<Design_Spec__c> lstDesignSpec=new List<Design_Spec__c>();//added by cognizant
    Map<String,String> mapPDKIdsToPDKDoctitle= new Map<String,String>();//added by cognizant
    List<PDK_Patch__c> lstPatch =new List<PDK_Patch__c>();//added by cognizant
    String PDKVersion;//added by cognizant
    Map<Id,Id> mapSubPDKIdsToSubPDKIds=new Map<Id,Id>();//added by cognizant on 5th feb
    Map<Id,Id> mapSubPDKIdsTopatchIds=new Map<Id,Id>();//added by cognizant on 5th feb

    Map<id,List<Sub_PDK_Spec__c>> mapOfSubpdkIdAndSpecList = new Map<id,List<Sub_PDK_Spec__c>>();
    
       if(mapPDKIdsToPDKNames!=null && mapPDKIdsToPDKNames.size()>0){
 //commented by cognizant       
          /*  for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c from Sub_PDK__c where PDK__c IN:mapPDKIdsToPDKNames.keySet()]){
                objSubPDK.Name = 'PDK ' + mapPDKIdsToPDKNames.get(objSubPDK.PDK__c) + ' - ' + objSubPDK.Bundle_Name__c;
                listSPDKNamesMod.add(objSubPDK);        
            }*/
 /*----------------------------added by cognizant for the Case 00002585-------------------------------------------------------------------------------------------------------*/ 
            for(PDK__c objPDK:[Select Id, Name,Master_PDK_Full_Name__c,PDK_DocTitle__c from PDK__c where Id IN:mapPDKIdsToPDKNames.keySet()])
            {
            mapPDKIdsToPDKNames.put(objPDK.Id,objPDK.Master_PDK_Full_Name__c);
            mapPDKIdsToPDKDoctitle.put(objPDK.Id,objPDK.PDK_DocTitle__c); //added by cognizant
            }
        
            for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c from Sub_PDK__c where PDK__c IN:mapPDKIdsToPDKNames.keySet()])
           
            {
            
            mapSubPDKIdsToSubPDKIds.put(objSubPDK.Id,objSubPDK.Id);
            setSubPDKIds.add(objSubPDK.Id);
            }
            system.debug('mapSubPDKIdsToSubPDKIds@@'+mapSubPDKIdsToSubPDKIds);
            
            if(mapSubPDKIdsToSubPDKIds!=null && mapSubPDKIdsToSubPDKIds.size()>0 && setSubPDKIds!=null && setSubPDKIds.size()>0)
            {
                 for(Sub_PDK_Spec__c objPDKspec:[Select Id,Name,Sub_PDK__c,Design_Spec__c,Design_Spec__r.PDK_Patch__c from Sub_PDK_Spec__c where Sub_PDK__c IN:mapSubPDKIdsToSubPDKIds.keySet() and Design_Spec__r.PDK_Patch__c!=''])
                 {
                 mapSubPDKIdsTopatchIds.put(objPDKspec.Sub_PDK__c,objPDKspec.Design_Spec__r.PDK_Patch__c);
                 SetPatchId.add(objPDKspec.Design_Spec__r.PDK_Patch__c);
                }
            }
            system.debug('mapSubPDKIdsTopatchIds@@'+mapSubPDKIdsTopatchIds);
            
       if(SetPatchId !=null && SetPatchId.size()>0)
       {    
       lstPatch =[select Id,name,PDK_Revision_Release_Date__c,PDK_Version__c from PDK_Patch__c where Id IN:SetPatchId order by Master_PDK_Patch_Counter__c desc ];
       
       }
       if(lstPatch.size()>0)
       {
       PDKVersion =lstPatch[0].PDK_Version__c ;
       }   

        // Modifed by Kunal
        if(setSubPDKIds!=null && setSubPDKIds.size()>0)   
           mapOfSubpdkIdAndSpecList = DesignSpecTriggerHandler.getSubPdkSpeclist(setSubPDKIds);
           
       for(Sub_PDK__c objSubPDK:[Select Id, Name, Bundle_Name__c, PDK__c from Sub_PDK__c where Id IN:setSubPDKIds])
           
       {
         if(mapSubPDKIdsTopatchIds!=null)
         { 
            if(!mapSubPDKIdsTopatchIds.containsKey(objSubPDK.Id))
            {
                system.debug('mapSubPDKIdsTopatchIds do notcontainsKey');
                str= 'PDK ' + mapPDKIdsToPDKNames.get(objSubPDK.PDK__c) + ' - ' +objSubPDK.Bundle_Name__c;              
                /*if(str.length()>255){
                    objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
                }*/
                if(str.length()>80)
                {
                    objSubPDK.Name = str.substring(0,80);//Added by kunal
                }
                else
                {
                    objSubPDK.Name = str;
                }
                objSubPDK.Full_PDK_Name__c = str;
                system.debug('<<<<<<<<<<<<<??????'+objSubPDK.Full_PDK_Name__c);       
            }
            else
            {
                system.debug('mapSubPDKIdsTopatchIds containsKey');
                if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)!=null && PDKVersion !=null)
                {   
                    str='PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) + ' '+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;
                    /*if(str.length()>255){
                        objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
                    }*/
                    if(str.length()>80)
                    {
                        objSubPDK.Name = str.substring(0,80);////Added by kunal
                    }
                    else
                    { 
                        objSubPDK.Name = str;
                    }
                    objSubPDK.Full_PDK_Name__c = str;             
                }
                else if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)==null && PDKVersion !=null)
                {
                    str='PDK ' +''+PDKVersion +' - ' +objSubPDK.Bundle_Name__c;
                    /*if(str.length()>255){
                        objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
                    }*/
                    if(str.length()>80)
                    {
                        objSubPDK.Name = str.substring(0,80);////Added by kunal
                    }
                    else
                    {
                        objSubPDK.Name =str;
                    }
                    objSubPDK.Full_PDK_Name__c = str;   
                 }
                 else if(mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c)!=null && PDKVersion ==null)
                 {
                    str= 'PDK ' + mapPDKIdsToPDKDoctitle.get(objSubPDK.PDK__c) +' - ' +objSubPDK.Bundle_Name__c;
                    /*if(str.length()>255){
                        objSubPDK.addError('The PDK Name should not be  greater than 255 length character');
                    }*/
                    if(str.length()>80)
                    {
                        objSubPDK.Name = str.substring(0,80);//Added by kunal
                    }
                    else
                    {
                        objSubPDK.Name = str;
                    }
                    objSubPDK.Full_PDK_Name__c = str;       
                 }
                }
              }
              // modified by Kunal
            list<Sub_PDK_Spec__c> subPdkSpecs = mapOfSubpdkIdAndSpecList.get(objSubPDK.id);
            String PdkSpecs = '';
            if(subPdkSpecs!=null && subPdkSpecs.size()>0){
                for(Sub_PDK_Spec__c PDKSpec: subPdkSpecs){
                        if(PdkSpecs == '' || PdkSpecs == NULL)
                            PdkSpecs = PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;        
                        else
                            PdkSpecs = PdkSpecs+';'+PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;   
                    }
                }
                if(PdkSpecs!='' && PdkSpecs!=null)
                    objSubPDK.Pdk_Spec_Associations__c = PdkSpecs;
                else
                    objSubPDK.Pdk_Spec_Associations__c = ':NONE:';    
                    objSubPDK.Ready_For_Provisioning__c = false;
                    objSubPDK.Time_Req_To_Create_Association_In_OT__c = null;    
               // modified by Kunal                   
              listSPDKNamesMod.add(objSubPDK);    
             } 
              
/*----------------------------------------------------------------------------------------------------------------------------------------------*/       
            
            if(listSPDKNamesMod!=null && listSPDKNamesMod.size()>0){
                try{
                    update listSPDKNamesMod;
                }
                catch(Exception ex){
                    System.debug(ex);
                }       
            }   
        }          
     }

     /**
     This method is used to get sub pdk specs list related to pdk bundle.
     Added by Kunal
     **/
     public static Map<id,List<Sub_PDK_Spec__c>> getSubPdkSpeclist(Set<String> setOfsubpdkids){
         Map<id,List<Sub_PDK_Spec__c>> mapOfSubpdkIdAndSpecList = new Map<id,List<Sub_PDK_Spec__c>>();
             List<Sub_PDK_Spec__c> lstSubpdkspecs = [select id,Design_Spec__c,Design_Spec__r.Name,Sub_PDK__c,
                OTID__c,Design_Spec__r.Release_Status__c,Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,
                Design_Spec__r.Document_Title__c,Design_Spec_OpenTextId__c from Sub_PDK_Spec__c 
                where sub_pdk__c IN:setOfsubpdkids]; 
             for(Sub_PDK_Spec__c PDKSpec : lstSubpdkspecs){
                 List<Sub_PDK_Spec__c> lstSpecList = mapOfSubpdkIdAndSpecList.get(PDKSpec.Sub_PDK__c);
                 if(lstSpecList == null)
                 lstSpecList = new List<Sub_PDK_Spec__c>();
                 lstSpecList.add(PDKSpec);
                 mapOfSubpdkIdAndSpecList.put(PDKSpec.Sub_PDK__c,lstSpecList);                      
             }
          
         return mapOfSubpdkIdAndSpecList;                                 
     }
          
     /**
        This method populates the Approval Comment from Approval Process into the Approval Process Comments field.

        @method name: getApprovalProcessComments
        @parameter:   Document Provisioning Id.
        @return :     Approval Comment from Approval Process.
     **/
     
     public static Map<Id,String> getApprovalProcessComments(Set<Id> setOfDocumentProvisioningIds){
        String approvalComments = '';
        Map<Id,String> mapOfDpIdAndApprovalComment = new Map<Id,String>();
        
        for(ProcessInstanceStep objPIS : [Select Comments, ProcessInstance.TargetObjectId, StepStatus From ProcessInstanceStep 
                                            where ProcessInstance.TargetObjectId IN : setOfDocumentProvisioningIds order by CreatedDate asc]){
                                                
            if(objPIS.Comments!=null && objPIS.Comments!='Submitted for approval. Please approve.'){
                approvalComments =  'Comments given are: \r\n' + objPIS.Comments;
                mapOfDpIdAndApprovalComment.put(objPIS.ProcessInstance.TargetObjectId,approvalComments);
            }
        }
        
        return mapOfDpIdAndApprovalComment;       
     }
     
    /* public static String getApprovalProcessComments(Id objDPId){
        
        String approvalComments = '';
        
        for(ProcessInstanceStep objPIS:[Select Comments, ProcessInstance.TargetObjectId, StepStatus From ProcessInstanceStep 
        where ProcessInstance.TargetObjectId =: objDPId order by CreatedDate asc]){
            if(objPIS.Comments!=null && objPIS.Comments!='Submitted for approval. Please approve.'){
                approvalComments =  'Comments given are: \r\n' + objPIS.Comments;
            }
        }
        
        return approvalComments;       
     }
    */
}