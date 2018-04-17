/**********************************************************************************************************************************
Class:         ProposalTriggerUtil
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
               Prosenjit Saha
Created Date:  31/10/2013
Reason:        Utility class for field updates from the proposal triggers

History:       02102014 Asolito
               - filter the geometry uniqueness
               04292014 PSaha
               - Set customer specific PriceList
               09152014 ARoy
               - Setting Customer specific PriceList using custom setting (CPQ Customer Price List)
               01092015 ARoy
               - Populating Primary User field from Account Team Proxy Field Application Engineer
               01292015 ARoy
               - Modified UpdatePriceList method for call from before insert.
               21072017
               - As Approval Stage of Configurator has been added with new Process Flow Accepted Values changes are made accordingly.
                20112017 Sunita Char
               -Case 00074954 - PCM Copy enhancement
***********************************************************************************************************************************/

public class ProposalTriggerUtil {
    
    //Trigger Context maps
    //public Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap { get; set; }
    //public Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap { get; set; }
    
    //Trigger Context variables
    //public Boolean isInsert  { get; set; }
    //public Boolean isUpdate  { get; set; }
    
    //Master proposal map to be updated;
    public Map<Id, Apttus_Proposal__Proposal__c> mapUpdatedProposals { get; set; }
    
    //Master New map
    public Map<Id, Apttus_Proposal__Proposal__c> mapMasterTriggeredProposals { get; set; }
    
    //Delimiter
    final String szDelimiter = '<:>';
    
    //PS01082014:
    public static Map<ID,boolean> MapConfig2IsValidforApprove = new Map<Id,boolean>();
    
    //Constructor
    public ProposalTriggerUtil(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap){
       mapUpdatedProposals = new Map<Id, Apttus_Proposal__Proposal__c>();
       mapMasterTriggeredProposals = new Map<Id, Apttus_Proposal__Proposal__c>();
       
       for(Apttus_Proposal__Proposal__c proposal  :  [Select Id,
                                                             Name,
                                                             Device__c,
                                                             /*Mask_Set__c, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                             Mask_Set_Long__c,
                                                             Apttus_Proposal__Opportunity__c,
                                                             APTPS_Allowed_Geometries__c,
                                                             Apttus_Proposal__Account__c,
                                                             Apttus_Proposal__Account__r.name,
                                                             Apttus_Proposal__Account__r.Short_Name__c,
                                                             Free_Devices__c,
                                                             Free_Device_Names__c,
                                                             //Next_Level_Approver__c,
                                                             Primary_User__c,
                                                             catalog_type__c,
                                                             Apttus_QPConfig__PriceListId__c
                                                        From Apttus_Proposal__Proposal__c
                                                       Where Id IN: mapTriggeredProposalsNewMap.keySet()]){
            mapMasterTriggeredProposals.put(proposal.Id, proposal);                              
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> mapMasterTriggeredProposals : ' + mapMasterTriggeredProposals);
    }
    
    
    // Start : Harsh for cloning chailds "Configurator puls response"
   
   public static void cloneConfigPlusResponse(Map<Id,String> mapOfOldandNewRec){
       
       //Map(old,New);
       
       list<Configurator_Plus_Response__c> oldChilds = new list<Configurator_Plus_Response__c>([SELECT Additional_Response__c,Configurator_Plus_Question__c,Configurator_Plus__c,Name__c,Proposal_Line_Item__c,
                                                           Question_ID__c,Response_Type__c,Response__c FROM Configurator_Plus_Response__c where Configurator_Plus__c = :mapOfOldandNewRec.keySet()]);
       
       system.debug('*******mapOfOldandNewRec'+mapOfOldandNewRec);
       //list<Configurator_Plus_Response__c> newChilds = oldChilds.clone();
       list<Configurator_Plus_Response__c> ConfPlusResRecs = new list<Configurator_Plus_Response__c>();
       for (Configurator_Plus_Response__c reParentChild : oldChilds){
           Configurator_Plus_Response__c tempresponse = reParentChild.clone(false,true);

           tempresponse.id=null;
           tempresponse.Question_ID__c = reParentChild.Configurator_Plus_Question__c + '-' + mapOfOldandNewRec.get(reParentChild.Configurator_Plus__c);
           tempresponse.Configurator_Plus__c = mapOfOldandNewRec.get(reParentChild.Configurator_Plus__c);
           ConfPlusResRecs.add(tempresponse);
           
       }
       
       system.debug('****ConfPlusResRecs'+ConfPlusResRecs);
       if(ConfPlusResRecs.size()>0){
           insert ConfPlusResRecs;
       }
           
       
       
   }
 /*-------------------------------added by sunita for Case 00074954----------------------------------------------------*/ 
  
   //Get all creatable fields for a given object
    public static list<String> getCreatableFields(String objAPIName){
        Map<string,string> childFieldsName = new Map<string,string>{};
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();
        SObjectType sot = gd.get(objAPIName);
      
        //Get all non-creatable fields name except
        //Get the field tokens map
        Map<String, SObjectField> fields = new Map<String, SObjectField>{};
        if(sot.getDescribe().fields.getMap().keyset().size()>0) {
          fields = sot.getDescribe().fields.getMap();
        }
        //And drop those tokens in a List
        List<SObjectField> fieldtokens = fields.values();
        List<string> objectFields = new List<String>();
        for(SObjectField fieldtoken:fieldtokens) {
            DescribeFieldResult dfr = fieldtoken.getDescribe();
            if(dfr.isCreateable()) {
              objectFields.add(dfr.getLocalName());
            }                           
        }
        return objectFields;
    }
    
    public static void clonePCMRelatedObjects(Map<Id,String> mapOfOldandNewRec){
    
      Set<Id> idSet = mapOfOldandNewRec.keySet();
      /*-----------------------config quarterly Vol------------------------*/
        string query = 'Select ';
        for(String key : getCreatableFields('Config_Quarterly_Volume__c')) {
           query += key+',';
        }
        list<Config_Quarterly_Volume__c> oldChilds = new list<Config_Quarterly_Volume__c>();
        if(query.endsWith(',')){       
           query = query.substring(0,query.length()-1);
           query += ' FROM Config_Quarterly_Volume__c where Quote_Proposal__c in: idSet';
           system.debug('Config_Quarterly_Volume__c query===>'+query);
           oldChilds = database.query(query);
        }
        system.debug('enter oldChilds '+oldChilds);
        list<Config_Quarterly_Volume__c> ConfQuarVolRecs = new list<Config_Quarterly_Volume__c>();
        for (Config_Quarterly_Volume__c reParentChild : oldChilds){
           Config_Quarterly_Volume__c tempresponse = reParentChild.clone(false,true);

           //tempresponse.id=null;
           tempresponse.Quote_Proposal__c= mapOfOldandNewRec.get(reParentChild.Quote_Proposal__c);
           ConfQuarVolRecs.add(tempresponse);
           
           
           
        }
       
        if(ConfQuarVolRecs.size()>0)
            {
            insert ConfQuarVolRecs;
           
           
            }   
      /*-----------------------config Post fab services------------------------*/   
      Map<Id,Config_Post_Fab_Services__c> ConfigPostOldIdandNewRecMap=new Map<Id,Config_Post_Fab_Services__c>();  
     
        string queryFabservices = 'Select ';
        for(String key : getCreatableFields('Config_Post_Fab_Services__c')) {
           queryFabservices += key+',';
        }
               list<Config_Post_Fab_Services__c> oldChilds1 = new list<Config_Post_Fab_Services__c>();
               if(queryFabservices.endsWith(',')){       
                   queryFabservices = queryFabservices.substring(0,queryFabservices.length()-1);
                   queryFabservices += ' FROM Config_Post_Fab_Services__c where Configuration__c in: idSet';
                   system.debug('Config_Post_Fab_Services__c query===>'+queryFabservices);
                   oldChilds1 = database.query(queryFabservices);
               }
               list<Config_Post_Fab_Services__c> ConfPostFabServRecs = new list<Config_Post_Fab_Services__c>();
               for (Config_Post_Fab_Services__c reParentChild1 : oldChilds1){
                   Config_Post_Fab_Services__c tempresponse1 = reParentChild1.clone(false,true);

                   //tempresponse1.id=null;
                   tempresponse1.Configuration__c= mapOfOldandNewRec.get(reParentChild1.Configuration__c);
                   ConfPostFabServRecs.add(tempresponse1);
                   ConfigPostOldIdandNewRecMap.put(reParentChild1.id,tempresponse1);
                   
                   
               }
        
        if(ConfigPostOldIdandNewRecMap.size()>0)
        {
           insert ConfigPostOldIdandNewRecMap.values();
           
           
        }   
        
     /*-----------------------config post fab services detail------------------------*/     
       
       string queryFabservicesDet = 'Select ';
       for(String key : getCreatableFields('Config_Post_Fab_Service_Detail__c')) {
           queryFabservicesDet += key+',';
       }
       list<Config_Post_Fab_Service_Detail__c> oldChilds2 = new list<Config_Post_Fab_Service_Detail__c>();
       
       if(queryFabservicesDet.endsWith(',')){       
           queryFabservicesDet = queryFabservicesDet.substring(0,queryFabservicesDet.length()-1);
           queryFabservicesDet += ' FROM Config_Post_Fab_Service_Detail__c where Config_Post_Fab_Service__r.Configuration__c in: idSet';
           system.debug('Config_Post_Fab_Service_Detail__c query===>'+queryFabservicesDet);
           oldChilds2 = database.query(queryFabservicesDet);
       }
       list<Config_Post_Fab_Service_Detail__c> ConfPostFabServDetailRecs= new list<Config_Post_Fab_Service_Detail__c>();    
       for (Config_Post_Fab_Service_Detail__c reParentChild2 : oldChilds2){
           Config_Post_Fab_Service_Detail__c tempresponse2 = reParentChild2.clone(false,true);

           //tempresponse2.id=null;
           tempresponse2.Config_Post_Fab_Service__c=null;
           ConfPostFabServDetailRecs.add(tempresponse2);
           tempresponse2.Config_Post_Fab_Service__c= ConfigPostOldIdandNewRecMap.get(reParentChild2.Config_Post_Fab_Service__c).Id;
           
           
       }
       
        
       system.debug('****ConfPostFabServDetailRecs@@@'+ConfPostFabServDetailRecs);
       if(ConfPostFabServDetailRecs.size()>0)
       {
           
           insert ConfPostFabServDetailRecs;
           
       }
       
       /*-----------------------config cost------------------------*/
     
        string queryConfigCost = 'Select ';
       for(String key : getCreatableFields('Configurator_Cost__c')) {
           queryConfigCost += key+',';
       }
       list<Configurator_Cost__c> oldChilds3 = new list<Configurator_Cost__c>();
       
       if(queryConfigCost.endsWith(',')){       
           queryConfigCost = queryConfigCost.substring(0,queryConfigCost.length()-1);
           queryConfigCost += ' FROM Configurator_Cost__c where Quote_Proposal__c in: idSet';
           system.debug('queryConfigCost query===>'+queryConfigCost);
           oldChilds3 = database.query(queryConfigCost);
       }
      // list<Configurator_Cost__c> ConfCostRecs= new list<Configurator_Cost__c>();
       Map<Id,Configurator_Cost__c> ConfigcostOldIdandNewRecMap=new Map<Id,Configurator_Cost__c>();
       for (Configurator_Cost__c reParentChild3 : oldChilds3){
           Configurator_Cost__c tempresponse3 = reParentChild3.clone(false,false);
           //tempresponse3.id=null;
           tempresponse3.Quote_Proposal__c = mapOfOldandNewRec.get(reParentChild3.Quote_Proposal__c);
           //ConfCostRecs.add(tempresponse3);
           ConfigcostOldIdandNewRecMap.put(reParentChild3.id,tempresponse3);
           
       }
       
       
       system.debug('****ConfigcostOldIdandNewRecMap@@@'+ConfigcostOldIdandNewRecMap);
       if(ConfigcostOldIdandNewRecMap.size()>0){
           
          // insert ConfCostRecs;
           insert ConfigcostOldIdandNewRecMap.values();
           
       }
       
       
       system.debug('****ConfigcostOldIdandNewRecMap@@@'+ConfigcostOldIdandNewRecMap);
       /*----------------config cost detail-----------*/
      
       string queryConfigCostDet = 'Select ';
       for(String key : getCreatableFields('Configurator_Cost_Detail__c')) {
           queryConfigCostDet += key+',';
       }
       list<Configurator_Cost_Detail__c> oldChilds4 = new list<Configurator_Cost_Detail__c>();
       
       if(queryConfigCostDet.endsWith(',')){       
           queryConfigCostDet = queryConfigCostDet.substring(0,queryConfigCostDet.length()-1);
           queryConfigCostDet += ' FROM Configurator_Cost_Detail__c where Configurator_Cost__r.Quote_Proposal__c in: idSet';
           system.debug('queryConfigCostDet query===>'+queryConfigCostDet);
           oldChilds4 = database.query(queryConfigCostDet);
       }
        list<Configurator_Cost_Detail__c> ConfCostDetailRecs= new list<Configurator_Cost_Detail__c>();
       for (Configurator_Cost_Detail__c reParentChild4 : oldChilds4){
           Configurator_Cost_Detail__c tempresponse4 = reParentChild4.clone(false,true);
           //tempresponse4.id=null;
           tempresponse4.Configurator_Cost__c= ConfigcostOldIdandNewRecMap.get(reParentChild4.Configurator_Cost__c).Id;
           ConfCostDetailRecs.add(tempresponse4);
          
           
           
       }
       
        
       system.debug('****ConfCostDetailRecs@@@'+ConfCostDetailRecs);
       if(ConfCostDetailRecs.size()>0){
           
           insert ConfCostDetailRecs;
           
       }
       
       /*----------------config cost YIELD -----------*/
       
       string queryConfigYeild = 'Select ';
       for(String key : getCreatableFields('Configurator_Yield__c')) {
           queryConfigYeild += key+',';
       }
       list<Configurator_Yield__c> oldChilds5 = new list<Configurator_Yield__c>();
       
       if(queryConfigYeild.endsWith(',')){       
           queryConfigYeild = queryConfigYeild.substring(0,queryConfigYeild.length()-1);
           queryConfigYeild += ' FROM Configurator_Yield__c where Quote_Proposal__c in: idSet';
           system.debug('queryConfigYeild query===>'+queryConfigYeild);
           oldChilds5 = database.query(queryConfigYeild);
       }
        list<Configurator_Yield__c> ConfYieldRecs= new list<Configurator_Yield__c>();
       for (Configurator_Yield__c reParentChild5 : oldChilds5){
           Configurator_Yield__c tempresponse5 = reParentChild5.clone(false,true);
           //tempresponse5.id=null;
           tempresponse5.Quote_Proposal__c = mapOfOldandNewRec.get(reParentChild5.Quote_Proposal__c);
           ConfYieldRecs.add(tempresponse5);
          
           
           
       }
       
        
       system.debug('****ConfYieldRecs@@@'+ConfYieldRecs);
       if(ConfYieldRecs.size()>0){
           
           insert ConfYieldRecs;
           
       }
    
	 /*-----------------------config test pass------------------------*/   
        
       string queryConfigTest = 'Select ';
       for(String key : getCreatableFields('Configurator_Test_Pass__c')) {
           queryConfigTest += key+',';
       }
       list<Configurator_Test_Pass__c> oldChilds6 = new list<Configurator_Test_Pass__c>();
       
       if(queryConfigTest.endsWith(',')){       
           queryConfigTest = queryConfigTest.substring(0,queryConfigTest.length()-1);
           queryConfigTest += ' FROM Configurator_Test_Pass__c where Configuration__c in: idSet';
           system.debug('queryConfigTest query===>'+queryConfigTest);
           oldChilds6 = database.query(queryConfigTest);
       }
        list<Configurator_Test_Pass__c> ConfTestPassRecs= new list<Configurator_Test_Pass__c>();
       for (Configurator_Test_Pass__c reParentChild6 : oldChilds6){
           Configurator_Test_Pass__c tempresponse6 = reParentChild6.clone(false,true);
           //tempresponse6.id=null;
           tempresponse6.Configuration__c= mapOfOldandNewRec.get(reParentChild6.Configuration__c);
           ConfTestPassRecs.add(tempresponse6);
          
       }
       
       system.debug('****ConfTestPassRecs@@@'+ConfTestPassRecs);
       if(ConfTestPassRecs.size()>0){
           
           insert ConfTestPassRecs;
           
       }
	   
   }
  /*-------------------------added by sunita for Case00074954 end--------------------------------*/    
    /*
    Populates the Proposal Opportunity with the Devices Opportunity when created from Devices.
    Populates the Proposal Opportunity with a dummy Opportunity when created from Teamrooms.
    The dummy opportunity are created for the first time if not exists.
    */
    public void UpdateOpportunity(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap,
                                      Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap,
                                      Boolean isInsert,
                                      Boolean isUpdate){
        //Dummy opportunity for proposals without device
        /*
        Opportunity DUMMYOPPORTUNITY = Null;
        Account DUMMYACCOUNT = Null;
        
        for(Opportunity dummyOpp : [Select Id
                                      From Opportunity
                                     Where Name = 'GLOBALFOUNDRIES DUMMY OPPORTUNITY' 
                                     Limit 1]){
            DUMMYOPPORTUNITY = dummyOpp;
        }
        */
        
        //This block Excecutes for the first time only (When first Proposal is created in the system)
        //Check if the dummy opportunity exists. If not create it for once only
        /*
        if(DUMMYOPPORTUNITY == Null){
            RecordType recType = [Select Id 
                                    From RecordType 
                                   Where Name='Customer'  And
                                         SobjectType = 'Account'
                                   Limit 1];
                                   
            DUMMYACCOUNT = new Account(Name = 'GLOBALFOUNDRIES DUMMY ACCOUNT',
                                       //RecordTypeId = recType.id,
                                       Site_Department__c = 'IT',
                                       Sub_Type__c = 'Indirect',
                                       Transaction_Type__c = 'Non-Transactional',
                                       Region__c = 'US',
                                       Bill_To_Address_1__c = 'Test Address',
                                       Bill_To_City__c = 'Test City',
                                       Bill_To_Country__c = 'India',
                                       Corporate_Address_1__c = 'Test Address',
                                       Corporate_City__c = 'Test City',
                                       Corporate_Country__c = 'India');
            
            insert DUMMYACCOUNT;
            
            DUMMYACCOUNT = [Select Id 
                              From Account 
                             Where Name = 'GLOBALFOUNDRIES DUMMY ACCOUNT'
                             Limit 1];
            */
            /*
            Id accId = [Select Id 
                          From Account 
                         Where Name = 'GLOBALFOUNDRIES DUMMY ACCOUNT'
                         Limit 1].Id;
            */
            
            /*                                          
            DUMMYOPPORTUNITY = new Opportunity (Name = 'GLOBALFOUNDRIES DUMMY OPPORTUNITY',
                                                AccountId = DUMMYACCOUNT.Id,
                                                StageName = '1. Discovery',
                                                Market_Segment__c = 'Automotive',
                                                Target_Process_Node__c = '14XM',
                                                Process_Platform__c = 'GF Baseline',
                                                Opportunity_Sourcing_Type__c = 'First Source',
                                                Fab_Split__c = 100,
                                                CloseDate = date.newinstance(2012, 12, 21),
                                                Process_Geometry__c = '0.014UM',
                                                Fab_Assignment_1__c = 'FAB 1',
                                                Process_Family__c = 'Super Low Power');
             
             insert DUMMYOPPORTUNITY;
             
             DUMMYOPPORTUNITY = [Select Id
                                   From Opportunity
                                  Where Name = 'GLOBALFOUNDRIES DUMMY OPPORTUNITY'
                                  Limit 1];
             */
        //}
        
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();
        
        //Set of Proposal Device Ids in scope
        Set<Id> setTriggeredProposalDeviceIds = new Set<Id>();
        
        //Map of Device Id with their Opportunity Id
        Map<Id,Id> mapDeviceIdWithOpportunityId = new Map<Id,Id>();
        
        //Map of Device Id with their Account Id
        //Map<Id,Id> mapDeviceIdWithAccountId = new Map<Id,Id>();
        
        //List of filtered and configured proposals in scope (i.e with not null/not blank Mask Set)
        List<Apttus_Proposal__Proposal__c> triggeredProposals = new List<Apttus_Proposal__Proposal__c>();
        
        //Filtered set of proposals with change in Device field only
        for(Apttus_Proposal__Proposal__c proposal : mapTriggeredProposalsNewMap.values()){
            //Check if this is triggered by Device update only
            if(IsInsert){
                if(proposal.Device__c != Null){
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                }
            } else if(IsUpdate){
                if(proposal.Device__c != Null &&
                   proposal.Device__c != mapTriggeredProposalsOldMap.get(proposal.Id).Device__c){
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                }
            }
        }
        
        if(setTriggeredProposalIds.size() == 0){
            return;
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalIds : ' + setTriggeredProposalIds);
        
        //get the filtered and configured proposals in scope (i.e with Device change only)
        /*
        triggeredProposals = [Select Id,
                                     Device__c,
                                     Mask_Set__c,
                                     Apttus_Proposal__Opportunity__c
                                From Apttus_Proposal__Proposal__c
                               Where Id IN: setTriggeredProposalIds];
        */
        for(Id proposalId : setTriggeredProposalIds){
            triggeredProposals.add(mapMasterTriggeredProposals.get(proposalId));
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> triggeredProposals : ' + triggeredProposals);
        
        //Prepare the Device Id set
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            if(proposal.Device__c != Null){
                setTriggeredProposalDeviceIds.add(proposal.Device__c);
            }
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalDeviceIds : ' + setTriggeredProposalDeviceIds);
        
        //Prepare the Device Id with Opportunity Id map
        for(Device__c device : [Select Id,
                                       Opportunity2__c/*,
                                       Account__c*/
                                  From Device__c
                                 Where Id IN: setTriggeredProposalDeviceIds]){
            mapDeviceIdWithOpportunityId.put(device.Id, device.Opportunity2__c);
            //mapDeviceIdWithAccountId.put(device.Id, device.Account__c);
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalDeviceIds : ' + setTriggeredProposalDeviceIds);
        
        //Update the opportunity field of the triggered proposals accordingly
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            /*
            if(proposal.Device__c == Null){
                if(mapUpdatedProposals.containsKey(proposal.Id)){
                    Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                    propTemp.Apttus_Proposal__Opportunity__c = DUMMYOPPORTUNITY.Id;
                    //propTemp.Apttus_Proposal__Account__c = DUMMYACCOUNT.Id;
                    mapUpdatedProposals.put(proposal.Id, propTemp);
                } else {
                    proposal.Apttus_Proposal__Opportunity__c = DUMMYOPPORTUNITY.Id;
                    //proposal.Apttus_Proposal__Account__c = DUMMYACCOUNT.Id;
                    mapUpdatedProposals.put(proposal.Id, proposal);
                }
            } else {
                if(mapUpdatedProposals.containsKey(proposal.Id)){
                    Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                    propTemp.Apttus_Proposal__Opportunity__c = mapDeviceIdWithOpportunityId.get(proposal.Device__c);
                    //propTemp.Apttus_Proposal__Account__c = mapDeviceIdWithAccountId.get(proposal.Device__c);
                    mapUpdatedProposals.put(proposal.Id, propTemp);
                } else {
                    proposal.Apttus_Proposal__Opportunity__c = mapDeviceIdWithOpportunityId.get(proposal.Device__c);
                    //proposal.Apttus_Proposal__Account__c = mapDeviceIdWithAccountId.get(proposal.Device__c);
                    mapUpdatedProposals.put(proposal.Id, proposal);
                }
            }
            */
            if(proposal.Device__c != Null){
                if(mapUpdatedProposals.containsKey(proposal.Id)){
                    Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                    propTemp.Apttus_Proposal__Opportunity__c = mapDeviceIdWithOpportunityId.get(proposal.Device__c);
                    propTemp.Bypass_Validation__c = TRUE; 
                    //propTemp.Apttus_Proposal__Account__c = mapDeviceIdWithAccountId.get(proposal.Device__c);
                    mapUpdatedProposals.put(proposal.Id, propTemp);
                } else {
                    proposal.Apttus_Proposal__Opportunity__c = mapDeviceIdWithOpportunityId.get(proposal.Device__c);
                    proposal.Bypass_Validation__c = TRUE; 
                    //proposal.Apttus_Proposal__Account__c = mapDeviceIdWithAccountId.get(proposal.Device__c);
                    mapUpdatedProposals.put(proposal.Id, proposal);
                }
            }
        }
    
        //return the proposals
        //return triggeredProposals;
    }
    
    //Added Asolito 02102014
    //Method will filter the geometries and return a comma concatenated string 
    //of unique geometries
    private String filterGeometry(String geometries){
        String result = '';
        
        if(UtilsString.isNotBlank(geometries)){
            
            List<String> vals = geometries.split('\\;');
            Set<String> uniqueVal = new Set<String>();
            
            for(String v: vals){
                uniqueVal.add(v);             
            }                     
            
            List<String> sortedVal = new List<String>();
            sortedVal.addAll(uniqueVal);
            sortedVal.sort();
            
            for(String u: sortedVal){
                result += u + ';';
            }
            result = result.substring(0, result.length()-1); 
        }
        return result;
    }
        
    
    /*
    Populates the Allowed Geometries field in Proposal with the NDA Geometries of all the
    Account Team Proxies of the proposal Account
    */
    public void UpdateAllowedGeometries(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap,
                                          Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap,
                                          Boolean isInsert,
                                          Boolean isUpdate){
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();
        
        //Map of Account Id with NDA Geometries (Concatenated)
        Map<Id, String> MapAccountWithNDAGeometries = new Map<Id, String>();
        
        //List of filtered and configured proposals in scope (i.e with not null/not blank Mask Set)
        List<Apttus_Proposal__Proposal__c> triggeredProposals = new List<Apttus_Proposal__Proposal__c>();
        
        //Filtered set of proposals with change in Account field only
        for(Apttus_Proposal__Proposal__c proposal : mapTriggeredProposalsNewMap.values()){
            //Check if this is triggered by Account update only
            if(isInsert){
                setTriggeredProposalIds.add(proposal.Id);
                //triggeredProposals.add(proposal);
            } else if(isUpdate){
                //System.Debug('[DEBUG :: JOYDEV] >> isUpdate +  proposal: ' + proposal);
                if(proposal.Apttus_Proposal__Account__c != mapTriggeredProposalsOldMap.get(proposal.Id).Apttus_Proposal__Account__c){
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                }
            }
        }
        
        if(setTriggeredProposalIds.size() == 0){
            return;
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalIds : ' + setTriggeredProposalIds);
        
        //List of proposals in scope
        /*
        List<Apttus_Proposal__Proposal__c> triggeredProposals = [Select Id,
                                                                        APTPS_Allowed_Geometries__c,
                                                                        Apttus_Proposal__Account__c
                                                                   From Apttus_Proposal__Proposal__c
                                                                  Where Id IN: setTriggeredProposalIds];
        */
        for(Id proposalId : setTriggeredProposalIds){
            triggeredProposals.add(mapMasterTriggeredProposals.get(proposalId));
        }
        
        //Proposals in scope
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            MapAccountWithNDAGeometries.put(proposal.Apttus_Proposal__Account__c, '');
        }
            
        for(Apttus__APTS_Agreement__c nda : [Select Id,
                                                    Geometries__c,
                                                    Apttus__Status_Category__c,
                                                    Apttus__Account__c
                                               From Apttus__APTS_Agreement__c
                                              Where Apttus__Account__c IN: MapAccountWithNDAGeometries.KeySet() AND
                                                    Geometries__c != NULL]){
            String szGeometries = MapAccountWithNDAGeometries.get(nda.Apttus__Account__c);
            
            szGeometries += !szGeometries.contains(nda.Geometries__c) ?
                            (szGeometries == '' ? '' : ';') + nda.Geometries__c + ';' : 
                            '';
            
            MapAccountWithNDAGeometries.put(nda.Apttus__Account__c, filterGeometry(szGeometries));
        }
        
        //Update the proposals
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            if(mapUpdatedProposals.containsKey(proposal.Id)){
                Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                propTemp.APTPS_Allowed_Geometries__c = MapAccountWithNDAGeometries.get(proposal.Apttus_Proposal__Account__c);                              
                propTemp.Bypass_Validation__c = TRUE; 
                mapUpdatedProposals.put(proposal.Id, propTemp);
            } else {
                proposal.APTPS_Allowed_Geometries__c = 
                                MapAccountWithNDAGeometries.get(proposal.Apttus_Proposal__Account__c);
                proposal.Bypass_Validation__c = TRUE;                                             
                mapUpdatedProposals.put(proposal.Id, proposal);
            }
        }
        
        //return the proposals
        //return triggeredProposals;
    }
    
  
  //***** Start: PS 03/04/2016 ******//
    /*  Author:     Prosenjit Saha
        Reason:     SRAM validation for polyorientation 
        Created Data:   March 4th, 2016
    */
    public void UpdateISSRAMDevice(List<Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap){
        //List of all the Device proposal line items of the filtered set of proposals in scope
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItems;
        
         //Map of configurator ID and IS SRAM added 
        Map<string, boolean> IsSRAMMAp = new Map<string, boolean>() ; 
        
        //get all the line items for the configurator
        lstProposalLineItems = [Select Id,
                                       Product_Family__c,
                                       Apttus_Proposal__Product__c,
                                       Apttus_Proposal__Proposal__c,
                                       Apttus_Proposal__Product__r.ProductCode,
                                       Apttus_QPConfig__OptionId__r.name,
                                       Apttus_QPConfig__AttributeValueId__r.IO_Voltage__c,
                                       Apttus_QPConfig__AttributeValueId__r.Core_voltagae__c,
                                       Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__c
                                  From Apttus_Proposal__Proposal_Line_Item__c
                                 Where (Product_Family__c = 'Devices' OR
                                        Product_Family__c = NULL OR
                                        Product_Family__c = '') AND
                                       Apttus_Proposal__Proposal__c IN :mapTriggeredProposalsNewMap]; 
                                       
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : lstProposalLineItems){// start: proposal line item loop           
            if(lineItem.Apttus_QPConfig__OptionId__c != NULL && (lineItem.Apttus_QPConfig__OptionId__r.name.contains('SRAM') || lineItem.Apttus_QPConfig__OptionId__r.name.contains('sram'))){   
                system.debug('[DEBUG: Inside SRAM condition ---> ]'+ lineItem.Apttus_QPConfig__OptionId__r.name );
                if(IsSRAMMAp.containskey(lineItem.Apttus_Proposal__Proposal__c)){
                    if(IsSRAMMAp.get(lineItem.Apttus_Proposal__Proposal__c) == FALSE){
                        IsSRAMMAp.remove(lineItem.Apttus_Proposal__Proposal__c);
                        IsSRAMMAp.put(lineItem.Apttus_Proposal__Proposal__c ,TRUE ) ; 
                    }
                }
                else{
                    IsSRAMMAp.put(lineItem.Apttus_Proposal__Proposal__c , TRUE); 
                }               
            }
            if(mapUpdatedProposals.containsKey(lineItem.Apttus_Proposal__Proposal__c)){
                Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(lineItem.Apttus_Proposal__Proposal__c);
                propTemp.IS_SRAM_Selected__c = IsSRAMMAp.containskey(lineItem.Apttus_Proposal__Proposal__c)? IsSRAMMAp.get(lineItem.Apttus_Proposal__Proposal__c) :  FALSE ;
                mapUpdatedProposals.put(lineItem.Apttus_Proposal__Proposal__c, propTemp);
            } else {
                mapUpdatedProposals.put(lineItem.Apttus_Proposal__Proposal__c, (new Apttus_Proposal__Proposal__c(id = lineItem.Apttus_Proposal__Proposal__c , IS_SRAM_Selected__c = IsSRAMMAp.containskey(lineItem.Apttus_Proposal__Proposal__c)? IsSRAMMAp.get(lineItem.Apttus_Proposal__Proposal__c) :  FALSE )) );
            }
             
        } // end : proposal line item loop
        
    }
    //***** stop: PS 03/04/2016 ******//
  
    /*
    Populates the Free Devices fields comma separated with devices with Masks layers 
    already included while configuring the Proposal on other device selections.
    */
    public void UpdateFreeDevices(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap,
                                  Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap,
                                  Boolean isInsert,
                                  Boolean isUpdate){
        System.Debug('[DEBUG :: JOYDEV] >> mapTriggeredProposalsNewMap : ' + mapTriggeredProposalsNewMap);
        System.Debug('[DEBUG :: JOYDEV] >> mapTriggeredProposalsOldMap : ' + mapTriggeredProposalsOldMap);
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();
        
        //Set of Proposal Device Ids in scope
        Set<Id> setTriggeredProposalDeviceIds = new Set<Id>();
        
        //Map of Proposal with thier List of Line Item Devices in comma seperated strings
        Map<Id, String> mapProposalIdWithLineItemDeviceIds = new Map<Id, String>();
        
        //Map of device Id with the devices in scope (from line item devices) 
        Map<Id, Product2> mapDeviceIdWithDevice;
        
        //Map of proposal id with the process tech product Code
        Map<Id, String> mapProposalIdWithProdessCode = new Map<Id, String>();
        
        //Map of proposal id with the IO Voltage
        Map<Id, String> mapProposalIdWithIOVoltage = new Map<Id, String>();
        
        //Map of proposal id with the Core Voltage
        Map<Id, String> mapProposalIdWithCoreVoltage = new Map<Id, String>();
        
        //List of filtered and configured proposals in scope (i.e with not null/not blank Mask Set)
        List<Apttus_Proposal__Proposal__c> triggeredProposals = new List<Apttus_Proposal__Proposal__c>();
        
        //List of all the Device proposal line items of the filtered set of proposals in scope
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItems;
        
        //List of all the Proposal Process Technlogies
        List<String> lstProcesTechs = new List<String>();
        
        //Proposal Process Technlogies (Comma Seperated for the Like search)
        String szProcessTechs = '';
        
        //Filtered set of proposals with change in Mask Set field only (which is driven by change in line items)
        for(Apttus_Proposal__Proposal__c proposal : mapTriggeredProposalsNewMap.values()){
            System.Debug('[DEBUG :: JOYDEV] >> proposal(from new map) : ' + proposal);
            //Check if this is triggered by Mask Set update only
            /*if(isInsert){
                setTriggeredProposalIds.add(proposal.Id);
                //triggeredProposals.add(proposal);
            }else */
            if(isUpdate){
                /*if(proposal.Mask_Set__c != Null &&
                   proposal.Mask_Set__c != mapTriggeredProposalsOldMap.get(proposal.Id).Mask_Set__c){
                    System.Debug('[DEBUG :: JOYDEV] >> proposal.Mask_Set__c(from new map) : ' + proposal.Mask_Set__c);
                    System.Debug('[DEBUG :: JOYDEV] >> proposal.Mask_Set__c(from old map) : ' + 
                                                            mapTriggeredProposalsOldMap.get(proposal.Id).Mask_Set__c);
                
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                }*/
                //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                if(proposal.Mask_Set_Long__c != Null &&
                   proposal.Mask_Set_Long__c != mapTriggeredProposalsOldMap.get(proposal.Id).Mask_Set_Long__c){
                    System.Debug('[DEBUG :: JOYDEV] >> proposal.Mask_Set__c(from new map) : ' + proposal.Mask_Set_Long__c);
                    System.Debug('[DEBUG :: JOYDEV] >> proposal.Mask_Set__c(from old map) : ' + 
                                                            mapTriggeredProposalsOldMap.get(proposal.Id).Mask_Set_Long__c);
                
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                }
            }
        }
        
        if(setTriggeredProposalIds.size() == 0){
            return;
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalIds : ' + setTriggeredProposalIds);
        
        /*
        triggeredProposals = [Select Id,
                                     Free_Devices__c,
                                     Free_Device_Names__c,
                                     Mask_Set__c
                                From Apttus_Proposal__Proposal__c
                               Where Id IN: setTriggeredProposalIds AND
                                     Mask_Set__c <> NULL];
        */
        
        //get the filtered and configured proposals in scope (i.e with not null/not blank Mask Set)
        for(Id proposalId : setTriggeredProposalIds){
            Apttus_Proposal__Proposal__c prop = mapMasterTriggeredProposals.get(proposalId);
            prop.Free_Devices__c = Null;
            prop.Free_Device_Names__c = Null;
            triggeredProposals.add(prop);
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> triggeredProposals : ' + triggeredProposals);
        
        //Get all the Device proposal line items of the filtered set of proposals in scope
        lstProposalLineItems = [Select Id,
                                       Product_Family__c,
                                       Apttus_Proposal__Product__c,
                                       Apttus_Proposal__Proposal__c,
                                       Apttus_Proposal__Product__r.ProductCode,
                                       Apttus_QPConfig__AttributeValueId__r.IO_Voltage__c,
                                       Apttus_QPConfig__AttributeValueId__r.Core_voltagae__c,
                                       Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__c
                                  From Apttus_Proposal__Proposal_Line_Item__c
                                 Where (Product_Family__c = 'Devices' OR
                                        Product_Family__c = NULL OR
                                        Product_Family__c = '') AND
                                       Apttus_Proposal__Proposal__c IN :setTriggeredProposalIds];
        
        System.Debug('[DEBUG :: JOYDEV] >> lstProposalLineItems : ' + lstProposalLineItems);
        
        mapProposalIdWithIOVoltage = new Map<Id, String>();
        mapProposalIdWithCoreVoltage = new Map<Id, String>();
        
        //loop through the line items and prepare the map of proposal with its string of line Items devices
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : lstProposalLineItems){
            System.Debug('[DEBUG :: JOYDEV] >> lineItem (*) : ' + lineItem);
            
            if(!mapProposalIdWithIOVoltage.containsKey(lineItem.Apttus_Proposal__Proposal__c)){
                mapProposalIdWithIOVoltage.put(lineItem.Apttus_Proposal__Proposal__c, 
                                               (lineItem.Apttus_QPConfig__AttributeValueId__r.IO_Voltage__c == null ? '' :
                                                lineItem.Apttus_QPConfig__AttributeValueId__r.IO_Voltage__c));
            }
            
            if(!mapProposalIdWithCoreVoltage.containsKey(lineItem.Apttus_Proposal__Proposal__c)){
                mapProposalIdWithCoreVoltage.put(lineItem.Apttus_Proposal__Proposal__c, 
                                                 (lineItem.Apttus_QPConfig__AttributeValueId__r.Core_voltagae__c == null ? '' :
                                                  lineItem.Apttus_QPConfig__AttributeValueId__r.Core_voltagae__c));
            }
            
            //take process code from Product_Family__c = '' * product code from Product_Family__c = 'Devices'
            if(lineItem.Product_Family__c == '' || lineItem.Product_Family__c == Null){
                System.Debug('[DEBUG :: JOYDEV] >> lineItem.Apttus_Proposal__Product__c (*) : ' + lineItem.Apttus_Proposal__Product__c);
            
                //keep adding the product codes to the Proposal Process Technlogies (Comma Seperated for the Like search)
                system.debug('szProcessTechs == >'+szProcessTechs);
                system.debug('lineItem.Apttus_Proposal__Product__r.ProductCode == >'+lineItem.Apttus_Proposal__Product__r.ProductCode);
                szProcessTechs += (szProcessTechs.contains(lineItem.Apttus_Proposal__Product__r.ProductCode) ? 
                                   '' : '\'' + lineItem.Apttus_Proposal__Product__r.ProductCode + '%\',');
            } else if(lineItem.Product_Family__c == 'Devices'){
                System.Debug('[DEBUG :: JOYDEV] >> lineItem.Product_Family__c (*) : ' + lineItem.Product_Family__c);
            
                /*If the map already have the current line item proposal entry, append the current device id to the line item devices strings 
                  else create an entry for the current line item proposal with a new String initialised with the current line item device id*/
                if(mapProposalIdWithLineItemDeviceIds.containsKey(lineItem.Apttus_Proposal__Proposal__c)){
                    mapProposalIdWithLineItemDeviceIds.put(lineItem.Apttus_Proposal__Proposal__c,
                           mapProposalIdWithLineItemDeviceIds.get(lineItem.Apttus_Proposal__Proposal__c) + 
                           ',' + lineItem.Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__c + ',');
                } else {
                    mapProposalIdWithLineItemDeviceIds.put(lineItem.Apttus_Proposal__Proposal__c, 
                                           lineItem.Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__c);
                }
                
                //keep adding the productId to the repository for included devices
                setTriggeredProposalDeviceIds.add(lineItem.Apttus_Proposal__Product__c);
            
                //add to the proposal to process code map
                //mapProposalIdWithProdessCode.put(lineItem.Apttus_Proposal__Proposal__c, 
                //                                 lineItem.Apttus_Proposal__Product__r.ProductCode);
            }
            
            //add to the proposal to process code map
            mapProposalIdWithProdessCode.put(lineItem.Apttus_Proposal__Proposal__c, 
                                             lineItem.Apttus_Proposal__Product__r.ProductCode);
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> mapProposalIdWithLineItemDeviceIds : ' + mapProposalIdWithLineItemDeviceIds);
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalDeviceIds : ' + setTriggeredProposalDeviceIds);    
        System.Debug('[DEBUG :: JOYDEV] >> szProcessTechs : ' + szProcessTechs);
        System.Debug('[DEBUG :: JOYDEV] >> mapProposalIdWithProdessCode : ' + mapProposalIdWithProdessCode);
        
        //Split the process techs string to populate the list of process tech codes
        for(String szCode : szProcessTechs.split(',')){
            System.Debug('[DEBUG :: JOYDEV] >> szCode : ' + szCode);
            
            if(szCode != null && szCode != ''){
                System.Debug('[DEBUG :: JOYDEV] >> if(true) -- > szCode : ' + szCode);
                lstProcesTechs.add(szCode);
            }
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> lstProcesTechs : ' + lstProcesTechs);
        
        //Get all the line item devices for the proposals in scope
        mapDeviceIdWithDevice =  new Map<Id, Product2>([Select Id,
                                                               Name,
                                                               Family,
                                                               ProductCode,
                                                               Mask_Sets__c,
                                                               APTPS_IO_Voltage__c,
                                                               APTPS_Core_Voltage__c
                                                          From Product2
                                                         Where Id IN: setTriggeredProposalDeviceIds]);
        
        System.Debug('[DEBUG :: JOYDEV] >> mapDeviceIdWithDevice : ' + mapDeviceIdWithDevice);
        
        /*Get all the Devices and check if the mask sets are included in the proposals but not part of the line items
          and then populate the free devices fields accordingly*/
        String szProcessTechTokens = 'AND (';
        
        for(String szProcessTech : lstProcesTechs)
        {
            szProcessTechTokens += 'ProductCode LIKE ' + szProcessTech + ' OR ';
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> szProcessTechTokens : ' + szProcessTechTokens);
        
        szProcessTechTokens = (szProcessTechTokens != 'AND (' ?
                               szProcessTechTokens.substring(0, szProcessTechTokens.length() - 4) + ')':
                               '');
        
        System.Debug('[DEBUG :: JOYDEV] >> szProcessTechTokens : ' + szProcessTechTokens);
        
        String szDeviceQuery =  'Select Id, Name, Family, ProductCode, Mask_Sets__c, APTPS_IO_Voltage__c, APTPS_Core_Voltage__c ' +
                                '  From Product2 ' +
                                ' Where Family = \'Devices\' AND Mask_Sets__c <> \'\' AND Mask_Sets__c <> NULL AND ' + 
                                '       ProductCode <> \'\' AND ProductCode <> NULL ' + szProcessTechTokens;
        
        System.Debug('[DEBUG :: JOYDEV] >> szDeviceQuery : ' + szDeviceQuery);
        
        for(List<Product2> lstDevices : Database.Query(szDeviceQuery)){
            System.Debug('[DEBUG :: JOYDEV] >> lstDevices : ' + lstDevices);
            
            //bulkified loop for devices more than 1000
            for(Product2 device : lstDevices){
                //loop through all the proposals in scope
                for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
                    //Skip marker
                    boolean isFreeDevice = true;
                    
                    System.Debug('[DEBUG :: JOYDEV] >> device.Mask_Sets__c : ' + device.Mask_Sets__c);
                    
                    //check if the current device mask set is a sub set of the current proposal mask set (configured)
                    for(String mask : device.Mask_Sets__c.split(',')){
                        /*Mark for skip if the device is already included in the current proposal line items
                          or if any of the mask of the current device is not present in the current proposal mask set
                          or the IO/Core voltage mismatches from the configured device voltages
                          or the product code (process tech code) mismatches*/
                        if(mapProposalIdWithProdessCode.containsKey(proposal.Id) &&
                           !device.ProductCode.contains(mapProposalIdWithProdessCode.get(proposal.Id))){
                            isFreeDevice = false;
                            break;
                        }
                        
                        System.Debug('[DEBUG :: JOYDEV] >> device.ProductCode : ' + device.ProductCode);
                        System.Debug('[DEBUG :: JOYDEV] >> mapProposalIdWithProdessCode : ' + mapProposalIdWithProdessCode);
                        
                        /*if(mapProposalIdWithLineItemDeviceIds.containsKey(proposal.Id) &&
                           mapProposalIdWithLineItemDeviceIds.get(proposal.Id).contains(device.Id) ||
                           (proposal.Mask_Set__c != null && !proposal.Mask_Set__c.trim().contains(mask.trim()))){
                                isFreeDevice = false;
                                break;
                        }*/
                        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                        if(mapProposalIdWithLineItemDeviceIds.containsKey(proposal.Id) &&
                           mapProposalIdWithLineItemDeviceIds.get(proposal.Id).contains(device.Id) ||
                           (proposal.Mask_Set_Long__c != null && !proposal.Mask_Set_Long__c.trim().contains(mask.trim()))){
                                isFreeDevice = false;
                                break;
                        }
                        
                        System.Debug('[DEBUG :: JOYDEV] >> device.Id : ' + device.Id);
                        System.Debug('[DEBUG :: JOYDEV] >> mapProposalIdWithLineItemDeviceIds : ' + mapProposalIdWithLineItemDeviceIds);
                        
                        if(mapProposalIdWithCoreVoltage.containsKey(proposal.Id) &&
                           mapProposalIdWithCoreVoltage.get(proposal.Id) != '' &&
                           device.APTPS_Core_Voltage__c != Null &&
                           !mapProposalIdWithCoreVoltage.get(proposal.Id).contains(device.APTPS_Core_Voltage__c)){
                            isFreeDevice = false;
                            break;
                        }
                        
                        if(mapProposalIdWithIOVoltage.containsKey(proposal.Id) && 
                           mapProposalIdWithIOVoltage.get(proposal.Id) != '' &&
                           device.APTPS_IO_Voltage__c != Null &&
                           !mapProposalIdWithIOVoltage.get(proposal.Id).contains(device.APTPS_IO_Voltage__c)){
                            isFreeDevice = false;
                            break;
                        }
                    }
                    
                    //remove string 'null' for the first time (to avoid 'null,product code' string formation while concatenating)
                    if(proposal.Free_Devices__c == null){
                        proposal.Free_Devices__c = '';
                        proposal.Free_Device_Names__c = '';
                    }
                    
                    //Append the device code with deduplication
                    if(isFreeDevice && !proposal.Free_Devices__c.contains(device.ProductCode)){
                        if(proposal.Free_Devices__c == ''){
                            proposal.Free_Devices__c += device.ProductCode;
                            proposal.Free_Device_Names__c += device.Name;
                        } else {
                            proposal.Free_Devices__c += szDelimiter + device.ProductCode;
                            proposal.Free_Device_Names__c += /*','*/ '\n' + device.Name;
                        }
                    }
                    
                    System.Debug('[DEBUG :: JOYDEV] >> proposal.Free_Devices__c : ' + proposal.Free_Devices__c);
                        
                    if(mapUpdatedProposals.containsKey(proposal.Id)){
                        Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                        propTemp.Free_Devices__c = proposal.Free_Devices__c;
                        propTemp.Free_Device_Names__c = proposal.Free_Device_Names__c;
                        propTemp.Bypass_Validation__c = TRUE; 
                        mapUpdatedProposals.put(proposal.Id, propTemp);
                    } else {
                        mapUpdatedProposals.put(proposal.Id, proposal);
                    }
                }
            }
        }
        
        //return the proposals
        //return triggeredProposals;   
    }
    
    /*
    Populates the Proposal Next Level Approver primary FAE and FTS users from the Account Team Proxies 
    at stages Draft and Submitted phases.
    */
    /*
    public void UpdateNextApprover(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap,
                                      Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap,
                                      Boolean isInsert,
                                      Boolean isUpdate){
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();
        
        //Set of Proposal Account Ids in scope
        Set<Id> setTriggeredProposalAccountIds = new Set<Id>();
        
        //Map of Account Id with Primary FAE User Id
        Map<Id, Id> mapAccountIdWithPrimaryFAEUserId = new Map<Id, Id>();
        
        //List of filtered and configured proposals in scope (i.e with Account changes only)
        List<Apttus_Proposal__Proposal__c> triggeredProposals = new List<Apttus_Proposal__Proposal__c>();
        
        //Filtered set of proposals with blank pricelist field only
        for(Apttus_Proposal__Proposal__c proposal : mapTriggeredProposalsNewMap.values()){
            //Check if this is triggered by Account update only
            if(isInsert){
                setTriggeredProposalIds.add(proposal.Id);
                //triggeredProposals.add(proposal);
                setTriggeredProposalAccountIds.add(proposal.Apttus_Proposal__Account__c);
            } else if(isUpdate){
                if(proposal.Apttus_Proposal__Account__c != mapTriggeredProposalsOldMap.get(proposal.Id).Apttus_Proposal__Account__c){
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                    setTriggeredProposalAccountIds.add(proposal.Apttus_Proposal__Account__c);
                }
            }
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalIds : ' + setTriggeredProposalIds);
        
        //get the filtered and configured proposals in scope (i.e with Device change only)
        for(Id proposalId : setTriggeredProposalIds){
            triggeredProposals.add(mapMasterTriggeredProposals.get(proposalId));
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> triggeredProposals : ' + triggeredProposals);
        
        for(Account_Team_Proxy__c accTmPrxy : [Select Id,User__c,Account__c
                                                From Account_Team_Proxy__c
                                                Where Account__c IN: setTriggeredProposalAccountIds 
                                                    AND (   Team_Role__c = 'Field Application Engineer'
                                                        OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                        OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )]){
            mapAccountIdWithPrimaryFAEUserId.put(accTmPrxy.Account__c, accTmPrxy.User__c);
        }
        
        //Update the Pricelist field of the triggered proposals accordingly
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            if(mapUpdatedProposals.containsKey(proposal.Id)){
                Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                propTemp.Next_Level_Approver__c = 
                                    mapAccountIdWithPrimaryFAEUserId.get(proposal.Apttus_Proposal__Account__c);
                mapUpdatedProposals.put(proposal.Id, propTemp);
            } else {
                proposal.Next_Level_Approver__c = mapAccountIdWithPrimaryFAEUserId.get(proposal.Apttus_Proposal__Account__c);
                mapUpdatedProposals.put(proposal.Id, proposal);
            }
        }
    
        //return the proposals
        //return triggeredProposals;                              
    }
    */
    
    //01092015 ARoy : Populates the Proposal Primary User from primary FAE and FTS users from the Account Team Proxies  
    public void UpdatePrimaryUser(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap,
                                      Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap,
                                      Boolean isInsert,
                                      Boolean isUpdate){
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();
        
        //Set of Proposal Account Ids in scope
        Set<Id> setTriggeredProposalAccountIds = new Set<Id>();
        
        //Map of Account Id with Primary FAE User Id
        Map<Id, Id> mapAccountIdWithPrimaryFAEUserId = new Map<Id, Id>();
        
        //List of filtered and configured proposals in scope (i.e with Account changes only)
        List<Apttus_Proposal__Proposal__c> triggeredProposals = new List<Apttus_Proposal__Proposal__c>();
        
        //Filtered set of proposals with blank pricelist field only
        for(Apttus_Proposal__Proposal__c proposal : mapTriggeredProposalsNewMap.values()){
            //Check if this is triggered by Account update only
            //if(isInsert){
                setTriggeredProposalIds.add(proposal.Id);
                //triggeredProposals.add(proposal);
                setTriggeredProposalAccountIds.add(proposal.Apttus_Proposal__Account__c);
            /*} else if(isUpdate){
                if(proposal.Apttus_Proposal__Account__c != mapTriggeredProposalsOldMap.get(proposal.Id).Apttus_Proposal__Account__c){
                    setTriggeredProposalIds.add(proposal.Id);
                    //triggeredProposals.add(proposal);
                    setTriggeredProposalAccountIds.add(proposal.Apttus_Proposal__Account__c);
                }
            }*/
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalIds : ' + setTriggeredProposalIds);
        
        //get the filtered and configured proposals in scope (i.e with Device change only)
        for(Id proposalId : setTriggeredProposalIds){
            triggeredProposals.add(mapMasterTriggeredProposals.get(proposalId));
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> triggeredProposals : ' + triggeredProposals);
        
        for(Account_Team_Proxy__c accTmPrxy : [SELECT Id,User__c,Account__c,Team_Role__c,Is_FAE__c
                                                 FROM Account_Team_Proxy__c
                                                 WHERE Account__c IN: setTriggeredProposalAccountIds 
                                                     AND ( Team_Role__c IN ('Field Application Engineer'
                                                                          , 'Primary Field Technical Support'
                                                                          , 'Primary Field Application Engineer')
                                                        OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                        OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )]){
            if(mapAccountIdWithPrimaryFAEUserId.containsKey(accTmPrxy.Account__c)){
                if(accTmPrxy.Team_Role__c == 'Primary Field Technical Support'||accTmPrxy.Team_Role__c == 'Primary Field Application Engineer'){
                    mapAccountIdWithPrimaryFAEUserId.put(accTmPrxy.Account__c, accTmPrxy.User__c);
                }
            }else{
                mapAccountIdWithPrimaryFAEUserId.put(accTmPrxy.Account__c, accTmPrxy.User__c);
            }
            
        }
        
        //Update the Primary User field of the triggered proposals accordingly
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            if(mapUpdatedProposals.containsKey(proposal.Id)){
                Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                propTemp.Primary_User__c = 
                                    mapAccountIdWithPrimaryFAEUserId.get(proposal.Apttus_Proposal__Account__c);
                mapUpdatedProposals.put(proposal.Id, propTemp);
            } else {
                proposal.Primary_User__c = mapAccountIdWithPrimaryFAEUserId.get(proposal.Apttus_Proposal__Account__c);
                mapUpdatedProposals.put(proposal.Id, proposal);
            }
        }
    
        //return the proposals
        //return triggeredProposals;                              
    }
    
    
    /*
    Populates the Proposal Pricelist with a dummy pricelist if left blank
    */
    public static void UpdatePricelist(List<Apttus_Proposal__Proposal__c> triggerProposalNewList){
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();        
        
        Apttus_Config2__PriceList__c SynopsysPriceList = new Apttus_Config2__PriceList__c();
        Apttus_Config2__PriceList__c internalUserPriceList = new Apttus_Config2__PriceList__c();
        Apttus_Config2__PriceList__c multiSourceInternalPriceList = new Apttus_Config2__PriceList__c();
        
        
        //AR : 09152014 - Made the customer price list a custom setting       
        Map<String,Apttus_Config2__PriceList__c> accPriceListMap = new Map<String,Apttus_Config2__PriceList__c>();        
        Map<String,String> custPriceMap = new Map<String,String>();
        for(CPQ_Customer_Price_List__c cpl : CPQ_Customer_Price_List__c.getall().values()){
            custPriceMap.put(cpl.Name,cpl.Price_List__c);
        }
        
        Set<String> allPriceList = new Set<String>();
        allPriceList.add('GLOBALFOUNDRIES Internal Price List');
        allPriceList.add('Multi-Source Internal Price List');
        allPriceList.addAll(custPriceMap.values());

        //AR: 09152014 - Made the customer price list a custom setting
        for(Apttus_Config2__PriceList__c SynPriceLst : [Select Id
                                                               , Name
                                                             From Apttus_Config2__PriceList__c
                                                            Where Name in :allPriceList 
                                                       ]){
            for(String acctShrtName : custPriceMap.keySet()){
                if(custPriceMap.get(acctShrtName)==SynPriceLst.Name){
                    accPriceListMap.put(acctShrtName,SynPriceLst);
                }
            }
            if(SynPriceLst.name ==  'GLOBALFOUNDRIES Internal Price List'){
                 internalUserPriceList = SynPriceLst;
            }else if(SynPriceLst.name ==  'Multi-Source Internal Price List'){
                multiSourceInternalPriceList = SynPriceLst;
            }
        }
        
        Set<String> acctIds = new Set<String>();
        for(Apttus_Proposal__Proposal__c proposal : triggerProposalNewList){
            acctIds.add(proposal.Apttus_Proposal__Account__c);
        }
        
        Map<String,String> acctShrtNameMap = new Map<String,String>();
        for(Account acc : [select id,Short_Name__c from Account where id in :acctIds]){
            acctShrtNameMap.put(acc.id,acc.Short_Name__c);
        }
        /*for(Apttus_Config2__PriceList__c internalPriceLst : [Select Id,
                                                                    name
                                                             From   Apttus_Config2__PriceList__c
                                                             Where  Name = 'GLOBALFOUNDRIES Internal Price List'
                                                                    OR Name = 'Multi-Source Internal Price List'
                                                             Limit 2]){
            if(internalPriceLst != null && internalPriceLst.name ==  'GLOBALFOUNDRIES Internal Price List'){
                 internalUserPriceList = internalPriceLst;
            }else{
                multiSourceInternalPriceList = internalPriceLst;
            }
         }*/       
                                              
        
        //Update the Pricelist field of the triggered proposals accordingly
        for(Apttus_Proposal__Proposal__c proposal : triggerProposalNewList){
            
            String acctShortName = (!acctShrtNameMap.isEmpty() && acctShrtNameMap.containsKey(proposal.Apttus_Proposal__Account__c))?acctShrtNameMap.get(proposal.Apttus_Proposal__Account__c):'';
            //AR: 09152014 - Made the customer price list a custom setting
            if(proposal.catalog_type__c == 'Multi Source'){  
                if(!accPriceListMap.isEmpty()){                    
                    if(UtilsString.isNotBlank(acctShortName) && !accPriceListMap.isEmpty() && accPriceListMap.containsKey(acctShortName)){
                        proposal.Apttus_QPConfig__PriceListId__c = accPriceListMap.get(acctShortName).id;
                    }else if(multiSourceInternalPriceList != null){
                        proposal.Apttus_QPConfig__PriceListId__c = multiSourceInternalPriceList.Id;
                    } 
                }
            }else{ 
                if(!accPriceListMap.isEmpty()){
                    if(UtilsString.isNotBlank(acctShortName) && !accPriceListMap.isEmpty() && accPriceListMap.containsKey(acctShortName)){
                        proposal.Apttus_QPConfig__PriceListId__c = accPriceListMap.get(acctShortName).id;
                    }else if(internalUserPriceList != null){
                        proposal.Apttus_QPConfig__PriceListId__c = internalUserPriceList.Id;
                    }
                }
            }
            system.debug('proposal.Apttus_QPConfig__PriceListId__c ==>'+proposal.Apttus_QPConfig__PriceListId__c);
            proposal.Bypass_Validation__c = TRUE; 

        }
    }
    
    /*
    Singulates the Primary field of the proposals for a device by 
    unchecking the same for other proposals in the same device.
    */
    public void SingulatePrimary(Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsNewMap,
                                  Map<Id, Apttus_Proposal__Proposal__c> mapTriggeredProposalsOldMap,
                                  Boolean isInsert,
                                  Boolean isUpdate){
        //Set of Proposal Ids in scope
        Set<Id> setTriggeredProposalIds = new Set<Id>();
        
        //Set of Device Ids of the filtered proposals in scope
        Set<Id> setTriggeredProposalDeviceIds = new Set<Id>();
        
        //List of proposals from the same device to be un-primaried in scope(i.e with primary checked)
        List<Apttus_Proposal__Proposal__c> triggeredProposals = new List<Apttus_Proposal__Proposal__c>();
        
        //Filtered set of proposals with primary change only
        for(Apttus_Proposal__Proposal__c proposal : mapTriggeredProposalsNewMap.values()){
            if(isInsert){
                if(proposal.APTPS_Primary__c && proposal.Device__c != NULL){
                    setTriggeredProposalIds.add(proposal.Id);
                    setTriggeredProposalDeviceIds.add(proposal.Device__c);
                }
            } else if(isUpdate){
                if(proposal.APTPS_Primary__c && proposal.Device__c != NULL){
                // 01152015: as per new requirement primary config can be associated later with device !mapTriggeredProposalsOldMap.get(proposal.Id).APTPS_Primary__c){
                    setTriggeredProposalIds.add(proposal.Id);
                    setTriggeredProposalDeviceIds.add(proposal.Device__c);
                }
            } 
        }
        
        if(setTriggeredProposalIds.size() == 0){
            return;
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> setTriggeredProposalIds : ' + setTriggeredProposalIds);
        
        triggeredProposals = [Select Id,
                                     APTPS_Primary__c, 
                                     Apttus_Proposal__Approval_Stage__c
                                From Apttus_Proposal__Proposal__c
                               Where Device__c IN: setTriggeredProposalDeviceIds];
        
        //Uncheck the previous propsals marked as primary
        for(Apttus_Proposal__Proposal__c proposal : triggeredProposals){
            if(!setTriggeredProposalIds.contains(proposal.Id)
               && mapUpdatedProposals.containsKey(proposal.Id)
               && proposal.Apttus_Proposal__Approval_Stage__c != 'Rejected Phase'){
                Apttus_Proposal__Proposal__c propTemp = mapUpdatedProposals.get(proposal.Id);
                propTemp.APTPS_Primary__c = False;
                propTemp.Bypass_Validation__c = TRUE; 
                mapUpdatedProposals.put(proposal.Id, propTemp);
            } else if(  !setTriggeredProposalIds.contains(proposal.Id)
                        && proposal.Apttus_Proposal__Approval_Stage__c != 'Rejected Phase') {
                proposal.APTPS_Primary__c = False;
                proposal.Bypass_Validation__c = TRUE; 
                mapUpdatedProposals.put(proposal.Id, proposal);
            }
        }
    
        //return the proposals
        //return triggeredProposals;
    }
    
    /*
    This is the helper method to get list of Configuration ID Vs Device ID
    */
    public static Map<ID,List<Apttus_Proposal__Proposal__c>> getConfigDeviceMap(List<Apttus_Proposal__Proposal__c> lstTriggeredProposalsNewMap,
                                                                                                  Boolean isInsert,
                                                                                                  Boolean isUpdate){
                                                                                                    
        Map<ID,List<Apttus_Proposal__Proposal__c>> MapConfig2ConfigOthr = new Map<ID,List<Apttus_Proposal__Proposal__c>>();
        Map<ID,ID> MapTriggeredDeviceID2config = new Map<ID,ID>();
        for(Apttus_Proposal__Proposal__c proposal : lstTriggeredProposalsNewMap){
            MapTriggeredDeviceID2config.put(proposal.device__c, proposal.id);
            List<Apttus_Proposal__Proposal__c> tempConfigMap = new List<Apttus_Proposal__Proposal__c>();
            MapConfig2ConfigOthr.put(proposal.id,tempConfigMap);
            MapConfig2IsValidforApprove.put(proposal.id,TRUE);
        }
        
        for(Apttus_Proposal__Proposal__c config :  [  Select Id
                                                             , APTPS_Primary__c
                                                             , device__c
                                                             , Apttus_Proposal__Approval_Stage__c
                                                        From Apttus_Proposal__Proposal__c
                                                       Where Device__c IN: MapTriggeredDeviceID2config.keyset()]){
            if( MapConfig2ConfigOthr.containskey(MapTriggeredDeviceID2config.get(config.device__c))){
                MapConfig2ConfigOthr.get(MapTriggeredDeviceID2config.get(config.device__c)).add(config);
            }       
            if( config.device__c != NULL
                && MapConfig2IsValidforApprove.containskey(MapTriggeredDeviceID2config.get(config.device__c))
                && MapTriggeredDeviceID2config.get(config.device__c) != config.id
                && config.Apttus_Proposal__Approval_Stage__c != null && config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))    {// Modified by Ravi Teja.B 21072017
                MapConfig2IsValidforApprove.put(MapTriggeredDeviceID2config.get(config.device__c)
                                                , MapConfig2IsValidforApprove.get(MapTriggeredDeviceID2config.get(config.device__c)) == TRUE 
                                                    ? FALSE
                                                    : TRUE);
            }                                       
        }
        return MapConfig2ConfigOthr;        
    }
    
    //Added for making rejection comments mandatory
    public static void checkRejectionComments(List<Apttus_Proposal__Proposal__c> newRecord, Map<Id,Apttus_Proposal__Proposal__c> oldRecord){
       
      Map<Id, Apttus_Proposal__Proposal__c> rejectedProposal = new Map<Id, Apttus_Proposal__Proposal__c>{};
    
      for(Apttus_Proposal__Proposal__c config: newRecord)
      {                
        if (oldRecord.get(config.id).Apttus_Proposal__Approval_Stage__c != 'Rejected Phase' && config.Apttus_Proposal__Approval_Stage__c == 'Rejected Phase')
        { 
          rejectedProposal.put(config.Id, config);  
        }
      }
       
      if (!rejectedProposal.isEmpty())  
      {        
        List<Id> processInstanceIds = new List<Id>{};
        
        for (Apttus_Proposal__Proposal__c prop : [SELECT (SELECT ID
                                                  FROM ProcessInstances
                                                  ORDER BY CreatedDate DESC
                                                  LIMIT 1)
                                          FROM Apttus_Proposal__Proposal__c 
                                          WHERE ID IN :rejectedProposal.keySet()])
        {
            processInstanceIds.add(prop.ProcessInstances[0].Id);
        }
        system.debug('processInstanceIds==>'+processInstanceIds);            
        for (ProcessInstance pi : [SELECT TargetObjectId, 
                                       (SELECT Id,Createddate, StepStatus, Comments 
                                        FROM Steps where ActorId = : Userinfo.getUserId() //StepStatus = 'Rejected'
                                        ORDER BY Createddate DESC  LIMIT 1
                                         )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC])   
        {   
           // system.debug('pi.Steps[0]==>'+pi.Steps[0]);                
           
          if (pi.Steps.size() > 0 && (pi.Steps[0].Comments == null || 
               pi.Steps[0].Comments.trim().length() == 0))
          {
            rejectedProposal.get(pi.TargetObjectId).addError(
              'Please provide a rejection reason!');
          }
        }  
      }
    
   }
    
}