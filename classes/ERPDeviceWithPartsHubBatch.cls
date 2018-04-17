/*
Author: Niharika Modi
Description: Batch class to extract ERP Device from Parts Hub
Created Date: 14th March,2017
History:
*    <Niharika Modi> 2017-04-26 - Code changes as per Review comments.
*  Custom Setting change and Composite key change
Devendra -19/09/2017 --removed the insertion of junction object record with same component and partnumber as it will be done on creation of erp device.
Devendra -4/10/2017 -refactored code.
*/
global class ERPDeviceWithPartsHubBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<BOM__c> finalStagingList ;
    global Map<ERP_Device__c,List<BOM__c>> erpStagingMap;
    global Set<String> processedComponentsForDpn;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String maskValue = Label.Part_BasicName_Mask;
        String query = 'SELECT '; 
        for(String fname:Schema.SObjectType.BOM__c.fields.getMap().keySet())
        {
            if(fname!='id')
                query=query+fname+ ', ';
        }
        erpStagingMap= new Map<ERP_Device__c,List<BOM__c>>();
        Set<String> levelCode = new Set<String>();
        List<Level_Code_Parts__c> listCodes = Level_Code_Parts__c.getAll().values(); 
        for(Level_Code_Parts__c code : Level_Code_Parts__c.getAll().values()){
            levelCode.add(code.Level_Code__c);
        }
        query=query+'id FROM BOM__c  WHERE Part_Level_Code__c IN :levelCode OR Part_BasicName__c =:maskValue';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject>
                        scope){
                            try{
                                List<BOM__c> partsHubList = (List<BOM__c>)scope;
                                Set<String> partsNumberComponent = new Set<String>();
                                Set<String> partsNumberParent = new Set<String>();
                                Set<String> partsNumber = new Set<String>();
                                
                                List<BOM__c> modifiedPartsHubList = new List<BOM__c>();
                                
                                
                                //Get value of custom setting 
                                ERP_Batch_Completion_Date__c erpBatch = ERP_Batch_Completion_Date__c.getInstance('CompletionDateValue');
                                //Get list based on modified date 
                                for(BOM__c st : partsHubList){ 
                                    if(st.LastModifiedDate >= erpbatch.Completion_Date__c){
                                        modifiedPartsHubList.add(st);
                                    }
                                }
                                //Get unique DPNs from Modified/New Parts Hub list 
                                for(BOM__c st : modifiedPartsHubList){
                                    partsNumberComponent.add(st.Component__c);
                                    partsNumberParent.add(st.Parent__c);
                                }
                                partsNumber.addAll(partsNumberComponent) ;
                                partsNumber.addAll(partsNumberParent) ;
                                List<ERP_Device__c> erpDeviceList =[Select PSA__c,PSC__c,Part_Number__c,ITAR__c from ERP_Device__c where Part_Number__c IN :partsNumber];
                                Set<ERP_Device__c> finalPartsNumber = new Set<ERP_Device__c>();
                                
                                //Getting unique DPN related to ERP device 
                                for(ERP_Device__c erpDevice : erpDeviceList){
                                    if(partsNumber.contains(erpDevice.Part_Number__c)){
                                        finalPartsNumber.add(erpDevice);
                                    }
                                }
                                //Traversing all records after filter criteria of MASK and Level code for unique DPNs.
                                //Creation of Map with each DPN 
                                erpStagingMap= new Map<ERP_Device__c,List<BOM__c>>();
                                for(ERP_Device__c erp : finalPartsNumber){
                                    finalStagingList = new List<BOM__c>();
                                    processedComponentsForDpn = new Set<String>();
                                    traverseStaging(erp.Part_Number__c,partsHubList);
                                    erpStagingMap.put(erp, finalStagingList);
                                }
                                
                                List<ERP_Device_SPDBOM__c> junctionList = new List<ERP_Device_SPDBOM__c>();
                                for(ERP_Device__c erp :erpStagingMap.keySet()){
                                    for(BOM__c partsHub : erpStagingMap.get(erp)){
                                        ERP_Device_SPDBOM__c junctObj = new ERP_Device_SPDBOM__c();
                                        junctObj.ERP_Device__c = erp.Id ;
                                        junctObj.BOM__c =partsHub.Id;
                                        junctObj.Change_Number__c = partsHub.Change_Number__c;
                                        junctObj.Component__c =  partsHub.Component__c;
                                        junctObj.Parent__c = erp.Part_Number__c;
                                        junctObj.Part_Ecrelease_Status__c = partsHub.Part_Ecrelease_Status__c;
                                        junctObj.Part_BasicName__c = partsHub.Part_BasicName__c;
                                        junctObj.Part_Classification__c = partsHub.Part_Classification__c;
                                        junctObj.Part_LabOfDesign__c = partsHub.Part_Labof_Design__c;
                                        junctObj.Part_LevelCode__c = partsHub.Part_Level_Code__c;
                                        junctObj.Part_Short_Desc__c = partsHub.Part_Short_Desc__c;
                                        junctObj.Primary_Or_OptionalFor__c = partsHub.Primary_Or_Optional_For__c;
                                        junctObj.PSA__c = erp.PSA__c;
                                        junctObj.PSC__c = erp.PSC__c;
                                        junctObj.APA__c = partsHub.APA_Code__c;
                                        junctObj.APC__c = partsHub.APC_Code__c ;
                                        junctObj.Integration_Status__c ='ReadytoSend';
                                        junctObj.Predicted_ITAR__c = erp.ITAR__c;
                                        junctObj.Released_Date__c = partsHub.Released_Date__c;
                                        junctObj.Technology__c = partsHub.Technology__c;
                                        junctObj.Parent_Component_Pair__c = erp.Part_Number__c + partsHub.Component__c;
                                        junctionList.add(junctObj);
                                    }
                                    
                                }
                                Schema.SObjectField f = ERP_Device_SPDBOM__c.Fields.Parent_Component_Pair__c;
                                Database.UpsertResult [] cr = Database.upsert(junctionList, f, false);
                                
                            }catch(Exception e){
                                //ApexPages.addMessages(e);
                                GlobalUtility.logMessage('Error','ERPDeviceWithPartsHubBatch','execute','','Exception while updating the Junction Object',String.valueof(e.getMessage()),'','SPD',e,0);
                                
                            }
                            
                        }
    
    private void traverseStaging(String dpn,List<BOM__c> partsHubList){
        for(BOM__c st : partsHubList){
            if(st.Parent__c == dpn ){
                if(!processedComponentsForDpn.contains(st.Component__c)){
                    processedComponentsForDpn.add(st.Component__c);
                    finalStagingList.add(st);
                    traverseStaging(st.Component__c,partsHubList);
                }
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        List<ERP_Device__c> erpToUpdate = new List<ERP_Device__c>();
        List<AsyncApexJob> apexJob =  [select  ApexClass.name,CompletedDate,status,CreatedBy.Email from AsyncApexJob where  Id = :BC.getJobId()];
        try{
            //Create custom settings and put value in that
            ERP_Batch_Completion_Date__c erpBatch = ERP_Batch_Completion_Date__c.getInstance('CompletionDateValue');
            if(apexJob != null && apexJob.size() > 0){
                erpbatch.Completion_Date__c = apexJob[0].CompletedDate;
                update erpBatch;
                for(ERP_Device__c erp :erpStagingMap.keySet()){
                    erp.Integration_Status__c = 'ReadytoSend';
                    erpToUpdate.add(erp);
                }
				if(!erpToUpdate.isempty())update erpToUpdate;
            }
          
        }catch(Exception e){
            //ApexPages.addMessages(e);
            GlobalUtility.logMessage('Error','ERPDeviceWithPartsHubBatch','finish','','Exception while updating the ERP Device',String.valueof(e.getMessage()),'','SPD',e,0);
            
        }
        
    }
}