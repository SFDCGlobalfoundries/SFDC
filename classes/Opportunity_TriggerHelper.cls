/*************************************************************************************************************************************************************
@ Class:          Opportunity_TriggerHelper
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        Helper class which consist of logics used in Opportunity Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.10.2016 / Ishtpreet Singh / Created the class.
                  04.04.2017 / Pradosh Samal / Case-00067002. Added updateLastEditorOfIPDF() method.   
                  25.07.2017/ Jabee/ case-00070089.
                  10.08.2017/ Manikumar/ Updated DW & QR fields.
				  25/10/2017 / jabee/ case-00081167.	
				  06.02.2018 / Pradosh Samal / Case-00085238. Added updateDeafaultOppIssue() method.
**************************************************************************************************************************************************************/
Public Class Opportunity_TriggerHelper{
    
    /*Global Variables*/
    public       Map<string,string>                   mapOpp                 { get; set; }
    public       Set<Id>                              opportunIds            { get; set; }
    public       List<Opportunity_Program__c>         lstOpptyprUpdate       { get; set; }
    public       Map<Id,Opportunity>                  triggerOldMap          { get; set; }
    public       Map<Id,Opportunity>                  triggerNewMap          { get; set; }
    public       set<string>                          statuses               { get; set; }
    public       set<id>                              setOpptyIDsForProgDel  { get; set; }
    public       set<id>                              voidedOpptyIDs         { get; set; }
    public       set<id>                              acctChangeOpptyIDs     { get; set; }
    public       Set<Id>                              opportunityIds         { get; set; }
    public       Set<Id>                              opptyChangePrivateIDs  { get; set; }
    
    /*Global Final Variables*/
    public final string OPPTY_STAGE_VOID = EnvironmentVariable.get('OPPTY_STAGE_VOID');
    public final string READONLY_NAME = EnvironmentVariable.get('READONLY_NAME'); 
    public final string DEVICE_STATUS_ACTIVE = EnvironmentVariable.get('DEVICE_STATUS_ACTIVE');
    
    public final string OPPTY_PROG_API_NAME = EnvironmentVariable.get('OPPTY_PROG_API_NAME');
    public final string DEVICE_API_NAME = EnvironmentVariable.get('DEVICE_API_NAME');
    public final string DEVICE_GAP_API_NAME = EnvironmentVariable.get('DEVICE_GAP_API_NAME');
    public final string EDA_REQ_API_NAME = EnvironmentVariable.get('EDA_REQ_API_NAME');
    
    /*********************************************************************************************************************************************************
    @ Constructor:    Opportunity_TriggerHelper
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/     
    public Opportunity_TriggerHelper(){      
        opportunIds = new Set<Id>();
        lstOpptyprUpdate = new List<Opportunity_Program__c>();
        mapOpp = new Map<string,string>();
        triggerOldMap = ((Map<Id,Opportunity>)Trigger.oldMap);
        triggerNewMap = ((Map<Id,Opportunity>)Trigger.newMap);
        System.debug('Opp new Value'+triggerOldMap);
        //statuses = new set<String>{'2. Assessment','3. Recommendation','4. Decision','5. Commitment','6. First Product TO','7. Revenue'};
        statuses = new set<String>{'0.Pre-Discovery','1. Discovery','2. Assessment','3. Recommendation','4. Decision','5. Commitment','6. First Product TO','7. Revenue'};
        setOpptyIDsForProgDel = new set<id>();
        voidedOpptyIDs = new set<id>();
        acctChangeOpptyIDs = new set<id>();
        opportunityIds = new Set<Id>();
        opptyChangePrivateIDs = new Set<Id>();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         oppProcessBefore()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity process before trigger logic.
    **********************************************************************************************************************************************************/      
    public void oppProcessBefore(){
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        if(RecursionPrevent.runOnce()){
            //Class to process change in probability and keep value from changing 
            //if(trigger.isBefore && trigger.isUpdate) 
            if(trigger.isBefore && trigger.isUpdate){
                OpptyStageValueUpdate.ProcessOpptyUpdate((Map<Id,Opportunity>)Trigger.oldMap,(Map<Id,Opportunity>)Trigger.newMap);
                
                Set<String> ConfigList=new Set<String>{'0.014UM','0.028UM','0.040UM','0.045UM'};
                Set<ID> SetOppty= new Set<ID>();
                List<Apttus_Proposal__Proposal__c> lstApttus=[Select id,Apttus_Proposal__Opportunity__c,Device__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c IN :Trigger.NewMap.keySet() and 
                                Device__c in (select id from Device__c where Opportunity2__c IN :Trigger.NewMap.keySet()) and APTPS_Primary__c=true and Apttus_Proposal__Approval_Stage__c LIKE 'Process Flow Accepted%'];//added by jabee 25.07.2017
                for(Opportunity oppty: (List<Opportunity>)trigger.new){
                    //List<Apttus_Proposal__Proposal__c> lstApttus=[Select id,Apttus_Proposal__Opportunity__c,Device__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c = :oppty.Id and 
                               // Device__c in (select id from Device__c where Opportunity2__c = :oppty.Id) and APTPS_Primary__c=true and Apttus_Proposal__Approval_Stage__c='Process Flow Accepted'];
                    
                    for(Apttus_Proposal__Proposal__c a :lstApttus)
                        SetOppty.add(a.Apttus_Proposal__Opportunity__c);
                        
                    if(oppty.Apttus_Configuration_Score__c==NULL) oppty.Apttus_Configuration_Score__c=0; 
                    if(oppty.DW_Progress__c==NULL) oppty.DW_Progress__c=0;   
                    oppty.DW_Progress__c=oppty.DW_Progress__c - (oppty.Apttus_Configuration_Score__c);
                     if(ConfigList.contains(oppty.Process_Geometry__c)){                                   
                        if(SetOppty.contains(oppty.id))
                            oppty.Apttus_Configuration_Score__c=5;
                        else 
                            oppty.Apttus_Configuration_Score__c=0;       
                     }else      
                        oppty.Apttus_Configuration_Score__c=   5;
      
                     oppty.DW_Progress__c=oppty.DW_Progress__c+ (oppty.Apttus_Configuration_Score__c);                               
                }
            }
            for(OpportunityProcess__c opp : [SELECT id,
                                                    Process_ID__c,
                                                    FAB__c,
                                                    Geometry__c,
                                                    Process_Family__c 
                                               FROM OpportunityProcess__c ]) {
                mapOpp.put(opp.FAB__c+'#'+opp.Geometry__c +'#'+opp.Process_Family__c,opp.Process_ID__c);
            }
            set<Id> overridePID = new set<Id>();
            for(Opportunity  opportunity: (List<Opportunity>)trigger.new) {
                if(opportunity.AssignedPID_Override__c != null)
                    overridePID.add(opportunity.AssignedPID_Override__c);
            }
            
            map<Id, Process__c> processMap = new map<Id, Process__c>([Select Id, Name from Process__c where Id IN :overridePID]);
            for(Opportunity  opportunity: (List<Opportunity>)trigger.new) {
                if(opportunity.AssignedPID_Override__c != null){
                    opportunity.AssignedPID__c = processMap.get(opportunity.AssignedPID_Override__c).Name;
                }else if((opportunity.Process_Geometry__c !=null ) && (opportunity.Process_Family__c!=null) && (opportunity.Fab_Assignment_1__c != null)) {
                    if(mapOpp.containskey(opportunity.Fab_Assignment_1__c+'#'+opportunity.Process_Geometry__c +'#'+opportunity.Process_Family__c)) {
                        opportunity.AssignedPID__c =mapOpp.get(opportunity.Fab_Assignment_1__c+'#'+opportunity.Process_Geometry__c +'#'+opportunity.Process_Family__c);
                    }
                    else {
                        opportunity.AssignedPID__c =null;
                    }
                }
                else {
                    if(opportunity.AssignedPID__c != null) {
                        opportunity.AssignedPID__c =null;
                    }
                }
                if((opportunity.Process_Geometry__c !=null ) && (opportunity.Process_Family__c!=null) && (opportunity.Fab_Assignment_2__c!= null)) {
                    if(mapOpp.containskey(opportunity.Fab_Assignment_2__c+'#'+opportunity.Process_Geometry__c +'#'+opportunity.Process_Family__c)) {
                         opportunity.Secondary_Indicative_PID__c =mapOpp.get(opportunity.Fab_Assignment_2__c+'#'+opportunity.Process_Geometry__c +'#'+opportunity.Process_Family__c);
                    }
                    else {
                        opportunity.Secondary_Indicative_PID__c=null;
                    }
                }
                else {
                    if(opportunity.Secondary_Indicative_PID__c!= null) {
                         opportunity.Secondary_Indicative_PID__c=null;
                    }
                }
            }           
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         oppPreDiscovery()
    @ Version:        1.0
    @ Author:         Meghna Ganguly (meghna.ganguly@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity Pre Discovery before insert trigger logic.
    **********************************************************************************************************************************************************/      
    public void oppPreDiscovery(){
        Set<Id> oppAccIds = new Set<Id>(); 
        Map<Id, Account_Team_Proxy__c> atpMap = new Map<Id, Account_Team_Proxy__c>();
        
        for (Opportunity opp: (List<Opportunity>)trigger.new) {        
           oppAccIds.add(opp.accountId);
        }
        
        for (Account_Team_Proxy__c atp : [ select Id,User__r.Id,User__c,User__r.Name,Team_Role__c,Account__c
                from Account_Team_Proxy__c where Account__c in :oppAccIds and ((Team_Role__c='Account Manager') OR(Team_Role__c='Primary Account Manager') )]) {
                
            atpMap.put(atp.Account__c, atp);
        }
    
        for (Opportunity opp : (List<Opportunity>)trigger.new) {
            Account_Team_Proxy__c atpc = atpMap.get(opp.accountId);
            if(atpc!=null&&atpc.User__c!=null){
            if (opp.OwnerId == atpc.User__r.Id) {
               opp.StageName = '1. Discovery';  
            }
            
            else {
                opp.StageName = '0.Pre-Discovery';
            }
          }
          else {
                opp.StageName = '0.Pre-Discovery';
            }
        }
      } 
    /*********************************************************************************************************************************************************
    @ Method:         oppProcessAfter()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity process after trigger logic.
    **********************************************************************************************************************************************************/     
    public void oppProcessAfter(){
        for(Opportunity opportunity : (List<Opportunity>)trigger.new){
            opportunIds.add(opportunity.id);
        }
        for(Opportunity_Program__c oOpptyProgram : [SELECT id,
                                                           name, 
                                                           Opportunity__c,
                                                           Opportunity__r.name 
                                                      FROM Opportunity_Program__c where Opportunity__c in :opportunIds]){
                                                      
            if(oOpptyProgram.name != oOpptyProgram.Opportunity__r.name)
            oOpptyProgram.name= oOpptyProgram.Opportunity__r.name;
            lstOpptyprUpdate.add(oOpptyProgram); 
        }
        if(lstOpptyprUpdate.size()>0){
            update lstOpptyprUpdate;
        }
        //commented by anushri
        //if(trigger.isAfter && trigger.isUpdate) OpptyGeometryValidator.OpptyReceiver(triggerOldMap,triggerNewMap);                                               
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         OpportunityGenerateOptyProgram()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity generate Opty Program trigger logic.
    **********************************************************************************************************************************************************/    
    public void OpportunityGenerateOptyProgram (){
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        for(Opportunity oOppty : (List <Opportunity>)trigger.new){
            if((oOppty.StageName != triggerOldMap.get(oOppty.Id).StageName) || oOppty.Create_Program__c){
                if(statuses.contains(oOppty.StageName) || oOppty.Create_Program__c){
                    lstOpptyprUpdate.add(createOptyProgram(oOppty));
                }else {
                    setOpptyIDsForProgDel.add(oOppty.id);
                
                }    
            }
            if (oOppty.Siebel_Opportunity_ID__c != triggerOldMap.get(oOppty.Id).Siebel_Opportunity_ID__c) {
                opportunityIds.add(oOppty.Id);
            }
            if(oOppty.StageName != triggerOldMap.get(oOppty.Id).StageName && oOppty.StageName == OPPTY_STAGE_VOID){
                if(oOppty.Design_Win_Review_Status__c==null){
                    voidedOpptyIDs.add(oOppty.id);
                }else{
                    oOppty.addError('Cannot set Opportunity status to \'Void\' because Design Win Review Status has value.');
                }
            }
            if(oOppty.AccountId != triggerOldMap.get(oOppty.Id).AccountId){
                acctChangeOpptyIDs.add(oOppty.id);
            }
            if(triggerOldMap.get(oOppty.Id).IsPrivate != oOppty.IsPrivate){
                opptyChangePrivateIDs.add(oOppty.Id);
            }
            
        }
        if(voidedOpptyIDs.size()>0){
            updateOpptyRelatedRecordsToReadOnly(voidedOpptyIDs);
        }
        if(acctChangeOpptyIDs.size()>0){
            //-----------Current user profile
            Profile ProfileName = [SELECT Name 
                                     FROM profile 
                                    WHERE id = :userinfo.getProfileId()];
            if((ProfileName.Name!='System Administrator') && (ProfileName.Name!='GF Integration') &&(ProfileName.Name!='GF System Admin') ){
                validateAccountChange(acctChangeOpptyIDs);
            }else{
                updateOpptyRelatedRecords(acctChangeOpptyIDs);
            }
        }
        if(opptyChangePrivateIDs.size()>0){
            updateOpptyProgramPrivateCopy(opptyChangePrivateIDs);
        }
        if (opportunityIds.size() > 0) {
            updateDevices(opportunityIds);
        }
        if(lstOpptyprUpdate.size()>0){
        // blindly insert Opty Program record. Duplicate Opty Program will fail to insert and won't be committed.
            database.SaveResult[] aResults = database.insert(lstOpptyprUpdate,false);
        
        // get all successfully created oppty program
            set<id> opptyProgIDs = new set<id>();
            for(database.Saveresult oResult : aResults){
                if(oResult.isSuccess()){
                    opptyProgIDs.add(oResult.getId());
                }else{
                    system.debug(oResult.getErrors());
                }
            }
        
        // generate core team members
            if(opptyProgIDs.size()>0){
                createOpptyProgramCoreTeam(opptyProgIDs);
            }   
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         opportunityIntegrationLog_au()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity Integration Log_au trigger logic.
    **********************************************************************************************************************************************************/    
    public void opportunityIntegrationLog_au(){
        if(triggerOldMap.size() == 1){
            for(Opportunity opportunity: (List<Opportunity>)trigger.new){
                if((triggerOldMap.get(opportunity.Id).Siebel_Status__c !=  opportunity.Siebel_Status__c)  && (opportunity.Siebel_Status__c == 'ERROR' || opportunity.Siebel_Status__c == 'SUCCESS' )) {
                    IntegrationLog.addIntegrationLog('Opportunity',
                                                      opportunity.ID, 
                                                      opportunity.Siebel_Sync_ID__c,
                                                      opportunity.Siebel_Error_Message__c,
                                                      opportunity.Siebel_Operation__c,
                                                      opportunity.Siebel_Status__c,
                                                      opportunity.Siebel_Sent_DateTime__c );
                }                                         
            }
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         oppCalculateRevenueValues()
    @ Version:        1.0
    @ Author:         Anushri Sarwade (anushribhushan.sarwade@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity trigger before logic.
    **********************************************************************************************************************************************************/         
    public void oppCalculateRevenueValues(){
        system.debug('start oppCalculateRevenueValues>>>>>>>>>Number of queries:'+Limits.getQueries());
        for(Opportunity  opportunity: (List<Opportunity>)trigger.new){
            opportunity.X2016_C__c = opportunity.X2016_Rollup__c==0? 0:opportunity.X2016_Rollup__c /1000000;
            opportunity.X2017_C__c = opportunity.X2017_Rollup__c==0? 0:opportunity.X2017_Rollup__c /1000000;
            opportunity.X2018_C__c = opportunity.X2018_Rollup__c==0? 0:opportunity.X2018_Rollup__c /1000000;
            opportunity.X2019_C__c = opportunity.X2019_Rollup__c==0? 0:opportunity.X2019_Rollup__c /1000000;
            opportunity.X2020_C__c = opportunity.X2020_Rollup__c==0? 0:opportunity.X2020_Rollup__c /1000000;
            opportunity.X2021_C__c = opportunity.X2021_Rollup__c==0? 0:opportunity.X2021_Rollup__c /1000000;
            opportunity.X2022_C__c = opportunity.X2022_Rollup__c==0? 0:opportunity.X2022_Rollup__c /1000000;
            opportunity.X2023_C__c = opportunity.X2023_Rollup__c==0? 0:opportunity.X2023_Rollup__c /1000000;
            opportunity.X2024_C__c = opportunity.X2024_Rollup__c==0? 0:opportunity.X2024_Rollup__c /1000000;
            opportunity.X2025_C__c = opportunity.X2025_Rollup__c==0? 0:opportunity.X2025_Rollup__c /1000000;
            
            //update Prob%(P) field with old value of Probability field
            Opportunity oldopty = (Opportunity)trigger.oldMap.get(opportunity.Id);
            if(oldopty.Probability != opportunity.Probability)
                opportunity.Prob_P__c = oldopty.Probability;  
        }
    }    
    
    /*********************************************************************************************************************************************************
    @ Method:         oppBeforeTrigger()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity trigger before logic.
    **********************************************************************************************************************************************************/     
    public void oppBeforeTrigger(){
        set<string> oppRecords = new set<string>();
        set<string> oppAccountId = new set<string>();
        set<string> oppName = new set<string>();
        set<string> oppAccId = new set<string>();
        set <string> setOpportunityNames = new set <string>();
        set<id> acctIds = new set<id>();
        set<Id> InformalQt1= new set<Id>();
        set<Id> oppIdset1 = new set<Id>(); 
        set <string> setAccountIDs = new set <string>();
        set <string> setOpportunityNamesPassed = new set <string>();
        set <string> setOpportunityIDs = new set <string>();
        list<Account_Team_Proxy__c> atp = new list<Account_Team_Proxy__c>();
        List<Budgetary_Quote_Item__c> BudgetQt1Item1 = new List<Budgetary_Quote_Item__c>();
        List<Quarterly_Revenue_Object__c> QuarterlyRev1 = new List<Quarterly_Revenue_Object__c>();
        map<string, set <string>> mapOpportunityNames = new map<string, set <string>>();
        boolean checkASPFlag = false;
        Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];//added by jabee 25.07.2017
        if(!RecursionPrevent.isAlreadyModified()){
            if(!IntegrationUserUtil.isSkipTrigger()){
                for(Opportunity  opportunity: (List<Opportunity>)trigger.new){
                    oppAccId.add(opportunity.accountid );
                }
                if(oppAccId.size() > 0){
                    atp = [SELECT id, 
                                  account__c,
                                  user__c, 
                                  Team_Role__c,
                                  flag_for_delete__c,
                                  lastmodifieddate,
                                  account__r.Primary_CSR__c, 
                                  account__r.Account_Manager__c, 
                                  account__r.Account_Admin__c,
                                  account__r.id
                             FROM Account_Team_Proxy__c 
                            WHERE account__c in : oppAccId
                              AND Team_Role__c =: 'Primary Field Application Engineer'
                              AND flag_for_delete__c = false
                         ORDER BY account__c, 
                                  lastmodifieddate desc ];
                }              
                              
                for(Opportunity  opportunity: (List<Opportunity>)trigger.new){
                    if(atp.size()>0 ){
                        for(integer i=0; i< atp.size();i++){
                            if(opportunity.Primary_Opportunity_FAE__c ==null && opportunity.accountid ==atp[i].account__c){
                                opportunity.Primary_Opportunity_FAE__c=atp[i].user__c;    
                            }
                        }    
                    }
                    else{
                         opportunity.Primary_Opportunity_FAE__c=null;        
                    
                    }
                    opportunity.Opportunity_Owner__c = opportunity.OwnerId;
                    
                    // Added by Nbustillos, 03072013 for Design win review fix. Forcefully update marketing recommendation if 
                    // marketing user approves the oppty but did not update marketing recommendation.
                    // This was done because we cannot execute validation from approval nor re execute workflow rule.
                    if(opportunity.Stategic_Marketing_Approval_Date__c!=null && opportunity.Marketing_Recommendation__c==null){
                      opportunity.Marketing_Recommendation__c = 'Recommend for Approval';
                    }
                    // Added by Nbustillos, 03072013 for temporary fix of fiscal quarter generation.
                    if(opportunity.X1st_Product_Production_Date__c!=null){
                      opportunity.First_Product_Production_Date_FQ_1__c = FiscalYearHelper.getFiscalQuarter(opportunity.X1st_Product_Production_Date__c);
                    }
                    
                    // Start Opportunity Name Validation Trigger Code
                    if(Trigger.IsUpdate  && (triggerOldMap.get(opportunity.Id).name != opportunity.name || triggerOldMap.get(opportunity.Id).AccountId != opportunity.AccountId )){
                        oppRecords.add(opportunity.id);
                        oppAccountId.add(opportunity.AccountId);
                        oppName.add(opportunity.name);
                    }else if(Trigger.IsInsert){
                        oppRecords.add(opportunity.id);
                        oppAccountId.add(opportunity.AccountId);
                        oppName.add(opportunity.name);
                        
                        // Added by Nbustillos, 03152012 for auto populate of original_name__c field
                        opportunity.Original_Name__c = opportunity.Name;
                    
                    } 
                    // End Opportunity Name Validation Trigger Code
                    // Added by Nbustillos, 08162013 copy IsPrivate to Is_Private_Copy__c for sharing settings.
                    if(Trigger.isUpdate && triggerOldMap.get(opportunity.Id).IsPrivate != opportunity.IsPrivate){
                        opportunity.Is_Private_Copy__c = opportunity.IsPrivate;
                    }else if(Trigger.isInsert){
                        opportunity.Is_Private_Copy__c = opportunity.IsPrivate;
                    }
                    // Start Opportunity Validate Integration Sequence Trigger Code
                    else if(Trigger.IsUpdate){
                        //Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
                        if(ProfileName.Name=='GF Integration'){
                            if (opportunity.Siebel_Sync_ID__c < triggerOldMap.get(opportunity.id).Siebel_Sync_ID__c){
                                opportunity.adderror('Out of sequence integration update');    
                            }         
                        }
                    } 
                    //End Opportunity Validate Integration Sequence Trigger Code 
                    if(opportunity.Design_Win_Review_Status__c != 'Submitted for Review' &&  opportunity.Design_Win_Review_Status__c != 'Won'){
                        acctIds.add(opportunity.accountid); //Tlai 31072014
                    }
                        
                    if(opportunity.Design_Win_Review_Status__c != 'Recommend for Approval' &&  opportunity.Design_Win_Review_Status__c != 'Recommend for Rejection' &&  opportunity.Design_Win_Review_Status__c != 'Won' ){
                        acctIds.add(opportunity.accountid); //Tlai 31072014
                    }
                }
                        // ZAmbat 08272014
                if (trigger.isInsert) {
                    Utility.generateSiebelOpportunityId(trigger.new);
                }
                
                //tlai 31072014 changed as per case 31543
                if(acctIds.size() > 0 && Trigger.isUpdate){
                    map<id,Account> acctMap = new map<id, Account>([SELECT id, 
                                                                           Sales_SVP__c,
                                                                           Region_Head_lk__c 
                                                                      FROM account 
                                                                     WHERE id in : acctIds]);
                    map<id,Account_Region_Head_Mapping__c> arhmMap = new Map<Id,Account_Region_Head_Mapping__c>();
                                                         
                    for (Account_Region_Head_Mapping__c arhm : [ SELECT id, 
                                                                           FAE_Head__c,
                                                                           Strategic_Account__c
                                                                      FROM Account_Region_Head_Mapping__c
                                                                     WHERE Strategic_Account__c in : acctIds]) {
                
                    arhmMap.put(arhm.Strategic_Account__c, arhm);
                        }                                                 
                   
                   for(Opportunity opportunity : (List<Opportunity>)trigger.new) {
                        Account acct = acctMap.get(opportunity.accountId);
                        Account_Region_Head_Mapping__c arhmc = arhmMap.get(opportunity.accountId);
                        //if(opp.Design_Win_Review_Status__c == null || opp.Design_Win_Review_Status__c == 'Rejected for Resubmission' )
                        if(opportunity.Design_Win_Review_Status__c != 'Submitted for Review' &&  opportunity.Design_Win_Review_Status__c != 'Won'){
                            opportunity.Territory_Head_for_Review__c = acct!=null? acct.Region_Head_lk__c:null; //Tlai 31072014
                        }
                            
                        if(opportunity.Design_Win_Review_Status__c != 'Recommend for Approval' &&  opportunity.Design_Win_Review_Status__c != 'Recommend for Rejection' &&  opportunity.Design_Win_Review_Status__c != 'Won' ){
                            opportunity.Sales_SVP_for_Review__c = acct!=null? acct.Sales_SVP__c:null; //Tlai 31072014
                        }
                            opportunity.FAE_Head__c = arhmc!=null? arhmc.FAE_Head__c:null;
                        
                    }
                }
                for(Opportunity opportunity: (List<opportunity>)trigger.new){
                    //find Accounts affected        
                    setAccountIDs.add(opportunity.AccountId);
                    setOpportunityNamesPassed.add(opportunity.Name);
                    setOpportunityIDs.add(opportunity.id);
                }
                     
                for (Opportunity opportunity:[SELECT id, 
                                                     AccountId, 
                                                     Name 
                                                FROM Opportunity 
                                               WHERE AccountId in :setAccountIDs 
                                                 AND Name in :setOpportunityNamesPassed 
                                                 AND id NOT in:setOpportunityIDs]){
                        //Account ID is already in the map
                    if (mapOpportunityNames.containsKey(opportunity.AccountId)){
                        setOpportunityNames = mapOpportunityNames.get(opportunity.AccountId);
                        setOpportunityNames.add(opportunity.Name);
                        mapOpportunityNames.put(opportunity.AccountId, setOpportunityNames);
                    }
                    else{
                        setOpportunityNames.add(opportunity.Name);
                        mapOpportunityNames.put(opportunity.AccountId, setOpportunityNames);
                    }
                }
                 
                for(Opportunity opportunity: (List<Opportunity>)trigger.new){
                    if (mapOpportunityNames.containsKey(opportunity.AccountId)){
                        set <string> setOpportunityName = mapOpportunityNames.get(opportunity.AccountId); 
                        if (setOpportunityName.contains(opportunity.Name)){
                            opportunity.addError(' Opportunity Name should be unique within the same account.');
                        }
                    }
                }
                
                if(trigger.isUpdate && !OpportunityGMPLHelper.hasRun){
                    OpportunityGMPLHelper.validateGMPLActive(trigger.new,triggerOldMap);
                }
                
                if (trigger.isUpdate) {
                    for (Opportunity opportunity : (List<Opportunity>)trigger.new) {
                        if (opportunity.Design_Win_Review_Status__c != triggerOldMap.get(opportunity.Id).Design_Win_Review_Status__c 
                            && opportunity.Design_Win_Review_Status__c == Environment_Variable__c.getInstance('OPPTY_DWRS_SUBMITTED_FOR_REVIEW').Value__c) {
                            // Clear value
                            opportunity.Node__c = null;
                             ConstantOpportunityValueStoreList__c oCOVSL = ConstantOpportunityValueStoreList__c.getInstance(string.valueof(opportunity.Target_Process_Node__c));
                             System.debug('@@@@@oCOVSL'+oCOVSL);
                             if(oCOVSL!= null){
                                    opportunity.Node__c = oCOVSL.Value__c;
                                }else{
                                    opportunity.Node__c = ConstantOpportunityValueStoreList__c.getInstance('Other').Value__c;
                                }
                            /*system.debug('opportunity.Target_Process_Node__c**'+opportunity.Target_Process_Node__c);
                            system.debug('ConstantOpportunityValueStoreList__c.getInstance'+ConstantOpportunityValueStoreList__c.getAll());
                            if(ConstantOpportunityValueStoreList__c.getValues(string.valueof(opportunity.Target_Process_Node__c)).Value__c!=null){
                                opportunity.Node__c = ConstantOpportunityValueStoreList__c.getInstance(string.valueof(opportunity.Target_Process_Node__c)).Value__c;
                            }*/
                        }
                    }
                }
                
                if(Trigger.isInsert || Trigger.isUpdate ){
                    for(Opportunity oppTemp: (List<Opportunity>)trigger.new){
                        if(oppTemp.Design_Win_Review_Status__c != 'Won'){                
                            oppTemp.DW_Progress__c = oppTemp.DW_Progress_Score1__c + oppTemp.DW_Progress_Score2__c ;
                        }
                        //case 43800
                        if(oppTemp.Design_Win_Review_Status__c == 'Won'){
                            if(oppTemp.Design_Win_FAE__c ==null)
                            {
                                oppTemp.Design_Win_FAE__c=oppTemp.Primary_Opportunity_FAE__c;
                            }
							if(oppTemp.Awarded_Amount__c!=null ){
								if(oppTemp.Awarded_Amount_New__c==null){
									oppTemp.Awarded_Amount_New__c=oppTemp.Awarded_Amount__c;
									
								}
							}
							if(oppTemp.Awarded_Amount_w_o_NRE__c!=null){
								if(oppTemp.Awarded_Amount_w_o_NRE_New__c==null){
									oppTemp.Awarded_Amount_w_o_NRE_New__c=oppTemp.Awarded_Amount_w_o_NRE__c;
								}
							}
                        }
                        if(oppTemp.Informal_Quote__c != null){
                        InformalQt1.add(oppTemp.Informal_Quote__c);
                        oppIdset1.add(oppTemp.Id);
                        }
                        if(((oppTemp.Process_Platform__c == 'GF-Full Custom' || oppTemp.Process_Platform__c == 'Customer Process Transfer' || oppTemp.Process_Platform__c == 'Customer Co-Developed') && oppTemp.Approved_GMPL_BX009_DW__c != null)|| ((oppTemp.Process_Platform__c == 'GF Baseline' || oppTemp.Process_Platform__c == 'GF Baseline plus custom modules')&& oppTemp.Approved_GMPL_BX009_DW__c == null) ){
                            if(oppTemp.Is_GF_Committed_to_Process__c != 'Yes'){
                                oppTemp.Is_GF_Committed_to_Process__c = 'Yes';
                            }
                        }               
                    }
                    if(!InformalQt1.isEmpty()){
                        BudgetQt1Item1 = [SELECT id,
                                                 Quarter__c,
                                                 Budgetary_Quote__c ,
                                                 Sales_Requested_Price__c,
                                                 Pricing_Approved_Price__c 
                                            FROM Budgetary_Quote_Item__c 
                                           WHERE Budgetary_Quote__c IN: InformalQt1];
                        QuarterlyRev1 = [SELECT id,
                                                Name,
                                                ASP__c,
                                                Informal_Quote__c,
                                                Fiscal_Quarter__c,
                                                Opportunity__c  
                                           FROM Quarterly_Revenue_Object__c 
                                          WHERE Opportunity__c IN: oppIdset1];
                        for(Quarterly_Revenue_Object__c QuartRev1 : QuarterlyRev1){
                            for(Budgetary_Quote_Item__c BudgetQt1: BudgetQt1Item1){
                                if(BudgetQt1.Quarter__c == QuartRev1.Fiscal_Quarter__c && BudgetQt1.Budgetary_Quote__c == QuartRev1.Informal_Quote__c && BudgetQt1.Pricing_Approved_Price__c != null){
                                    checkASPFlag = true;
                                }
                            }
                        }                
                        if(checkASPFlag == true){
                            for(Opportunity oppTempr: (List<Opportunity>)trigger.new){
                                oppTempr.Does_entered_ASP_Align_with_Quote__c = 'Yes';
                            }
                        }
                    }
                }              
            }
           
          /*Code added to update Deal Grading if Opportunity is set to Lost/Dropped/Void*/
            
          if(trigger.isUpdate || trigger.isinsert) {
                BnP_SyncDataHelper.beforeUpdateOppMethod(trigger.new, triggerOldMap);
            }
            
            if(trigger.isinsert) // Added by Arijit : While Creating new Opportunity (Clone) Deal Grading Field should be refreshed
            {
                for(Opportunity opportunity: (List<Opportunity>)trigger.new)
                {
                    if(opportunity.Product_Line__c == 'ASIC' || opportunity.Product_Line__c == 'SiPh')
                    {
                        opportunity.Deal_Grading_Status__c = '';
                        opportunity.Deal_Grading_Result__c = '';
                        
                    }
                }
            }
        }   
    }
    /*********************************************************************************************************************************************************
    @ Method:         OpportunityGenerateOptyProgramAfterInsert()
    @ Version:        1.0
    @ Author:         Meghna Ganguly (meghna.ganguly@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity generate Opty Program trigger logict for stage 0 opportunity on insert.
    **********************************************************************************************************************************************************/      
     public void OpportunityGenerateOptyProgramAfterInsert(){
        if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
        for(Opportunity oOppty : (List <Opportunity>)trigger.new){
             if(statuses.contains(oOppty.StageName)){
                    lstOpptyprUpdate.add(createOptyProgram(oOppty));
                
                }    
            
            opportunityIds.add(oOppty.Id);
            acctChangeOpptyIDs.add(oOppty.id);
                 
        }
        
        if(acctChangeOpptyIDs.size()>0){
            //-----------Current user profile
            Profile ProfileName = [SELECT Name 
                                     FROM profile 
                                    WHERE id = :userinfo.getProfileId()];
            if((ProfileName.Name!='System Administrator') && (ProfileName.Name!='GF Integration') &&(ProfileName.Name!='GF System Admin') ){
                validateAccountChange(acctChangeOpptyIDs);
            }else{
                updateOpptyRelatedRecords(acctChangeOpptyIDs);
            }
        }
       
        if (opportunityIds.size() > 0) {
            updateDevices(opportunityIds);
        }
        if(lstOpptyprUpdate.size()>0){
        // blindly insert Opty Program record. Duplicate Opty Program will fail to insert and won't be committed.
            database.SaveResult[] aResults = database.insert(lstOpptyprUpdate,false);
        
        // get all successfully created oppty program
            set<id> opptyProgIDs = new set<id>();
            for(database.Saveresult oResult : aResults){
                if(oResult.isSuccess()){
                    opptyProgIDs.add(oResult.getId());
                }else{
                    system.debug(oResult.getErrors());
                }
            }
        
        // generate core team members
            if(opptyProgIDs.size()>0){
                createOpptyProgramCoreTeam(opptyProgIDs);
            }   
        }
    }
    /*********************************************************************************************************************************************************
    @ Method:         oppAfterTrigger()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method calls the Opportunity trigger after logic.
    **********************************************************************************************************************************************************/     
    public void oppAfterTrigger(){
        set<Id> oppIdSetNew = new set<Id>();
        set<Id> InformalQt= new set<Id>();
        set<id> oppids2 = new set<id>();
        set<id> setOpptyIDsToRecompute = new set<id>();
        List<Design_Win_Approval_History__c> lstOppHistory =  new List<Design_Win_Approval_History__c>();
        List<Design_Win_Approval_History__c> lstChkOppHistory =  new List<Design_Win_Approval_History__c>();
        List<Quarterly_Revenues_History__c> lstQuarRevenue = new List<Quarterly_Revenues_History__c>();
        List<Quarterly_Revenue_Object__c> lstQuaRevobj = new List<Quarterly_Revenue_Object__c>();
        List<Budgetary_Quote_Item__c> BudgetQtItem = new List<Budgetary_Quote_Item__c>();
        List<Quarterly_Revenue_Object__c> QuarterlyRev = new List<Quarterly_Revenue_Object__c>();
        List<Quarterly_Revenue_Object__c> QuarterlyRevUpdate = new List<Quarterly_Revenue_Object__c>();
        list <Quarterly_Revenue_Object__c> listInsertQuarterLyRevenue = new list <Quarterly_Revenue_Object__c> (); 
        List<Device__c> lstDevice=new list<Device__c>();
        map<integer,double> mOldQuarterASP = new map<integer,double>();
        map<integer,decimal> mOldQuarterVolume = new map<integer,decimal>();
        map<integer,double> mOldHighVolume = new map<integer,double>();
        map<integer,double> mOldLowVolume = new map<integer,double>();
        Design_Win_Approval_History__c objOppHis = new Design_Win_Approval_History__c();
        Quarterly_Revenues_History__c objQuaRevHis=new Quarterly_Revenues_History__c();
        set<id> Opsidset=new set<id>();
        Boolean UpdateCond= false;
        string oppid;
        
        
        if(checkRecursive.runOnce()){
            if(trigger.isUpdate) {
               BnP_SyncDataHelper.afterUpdateDevMethod(trigger.new,triggerOldMap);// Commented by Baij
            }
            if(!IntegrationUserUtil.isSkipTrigger()){
                if(trigger.isUpdate){//added by jabee 25.07.2017
                   QuarterlyRevUpdate((List<Opportunity>)Trigger.new);
                   lstDevice=[SELECT Id,Opportunity2__c,Status__c 
                                                 FROM Device__c 
                                                WHERE Opportunity2__c IN:Trigger.NewMap.keySet() and Status__c='Active' and Tapeout_Type__c='Single Product'];
                }
                
                for(Opportunity opportunity : (List<Opportunity>)Trigger.new){
                    /*if(trigger.isUpdate){
                        for(Opportunity opporTemp: (List<Opportunity>)trigger.new){
                            if(opporTemp.Informal_Quote__c != null){
                                InformalQt.add(opporTemp.Informal_Quote__c);
                                oppIdSetNew.add(opporTemp.Id);
                            }
                        }
                        if(!InformalQt.isEmpty()){
                            BudgetQtItem = [SELECT id,
                                                   Quarter__c,
                                                   Budgetary_Quote__c,
                                                   Sales_Requested_Price__c,
                                                   Pricing_Approved_Price__c 
                                              FROM Budgetary_Quote_Item__c 
                                             WHERE Pricing_Approved_Price__c != Null and Budgetary_Quote__c IN: InformalQt];
                            QuarterlyRev = [SELECT id,
                                                   Name,
                                                   ASP__c,
                                                   Informal_Quote__c,
                                                   Fiscal_Quarter__c,
                                                   Opportunity__c  
                                              FROM Quarterly_Revenue_Object__c 
                                             WHERE Opportunity__c IN: oppIdSetNew];
                            for(Quarterly_Revenue_Object__c QuartRev : QuarterlyRev){
                                for(Budgetary_Quote_Item__c BudgetQt: BudgetQtItem){
                                    if(BudgetQt.Quarter__c == QuartRev.Fiscal_Quarter__c && BudgetQt.Budgetary_Quote__c == QuartRev.Informal_Quote__c){
                                        QuartRev.ASP__c =  BudgetQt.Pricing_Approved_Price__c;
                                        QuarterlyRevUpdate.add(QuartRev);   
                                        
                                    }
                                }
                            }
                            update QuarterlyRevUpdate;
                        }
                    }
                    */
                    //Case 11870 -start--Ykumar/ 18March2014
                    //Case 00041073 - start--Manikumar/21July2015
                    /*List<Device__c> lstDevice=[SELECT Id,Opportunity2__c,Status__c 
                                                 FROM Device__c 
                                                WHERE Opportunity2__c=:opportunity.Id and Status__c='Active' and Tapeout_Type__c='Single Product'];
                                                */
                    If(lstDevice.size()>0){                     
                        if(opportunity.StageName =='8. Lost' || opportunity.StageName =='9. Dropped' || opportunity.StageName =='10. Void'){
                            opportunity.addError('There are active devices under this opportunity, please set these devices to inactive prior to change opportunity stage to Lost/Dropped/Void');
                            //break;
                        }
                    }
                    Opsidset.add(opportunity.id);
                    if(Trigger.IsUpdate){
                        for(Opportunity  oOppty: (List<Opportunity>)trigger.new){
                             if((oOppty.Design_Win_Review_Status__c =='Won'  && (oOppty.Design_Win_Review_Status__c != triggerOldMap.get(oOppty.Id).Design_Win_Review_Status__c))|| (oOppty.StageName != triggerOldMap.get(oOppty.Id).StageName && oOppty.StageName != '0.Pre-Discovery')){
                                objOppHis.Account__c=opportunity.AccountId;
                                objOppHis.Market_Segment__c=oOppty.Market_Segment__c;
                                objOppHis.Opportunity__c=oOppty.id;
                                oppid=oOppty.id;
                                objOppHis.Opportunity_Name__c=oOppty.Name;
                                objOppHis.Opportunity_Owner__c=oOppty.Ownerid;
                                objOppHis.Opportunity_Sourcing_Type__c=oOppty.Opportunity_Sourcing_Type__c;
                                objOppHis.Total_Program_Value__c=oOppty.Total_Program_Value__c;
                                objOppHis.GF_Target_Share_DW__c=oOppty.GF_Target_Share__c;
                                objOppHis.GF_Opportunity_Size__c=oOppty.GF_Opportunity_Size__c;
                                objOppHis.Sum_of_Quarterly_Revenue__c=oOppty.Sum_of_Quarterly_Revenue__c;
                                objOppHis.Total_Lifetime_Revenue__c=oOppty.Total_Lifetime_Revenue__c;
                                objOppHis.Years_of_Production_DW__c=oOppty.Years_of_Production__c;
                                objOppHis.Process_Geometry__c=oOppty.Process_Geometry__c;
                                objOppHis.Process_Platform_Category_DW__c=oOppty.Process_Platform__c;
                                objOppHis.Target_Process_Node__c=oOppty.Target_Process_Node__c;
                                objOppHis.Primary_GF_Fab__c=oOppty.Fab_Assignment_1__c;
                                objOppHis.Is_GF_Committed_to_Process_DW__c=oOppty.Is_GF_Committed_to_Process__c;
                                objOppHis.Using_GF_PDK_DRC_or_SPICE_Models_DW__c=oOppty.Using_GF_PDK_DRC_or_SPICE_Models__c;
                                objOppHis.Date_Design_Win_Approved__c=oOppty.Date_Design_Win_Approved__c;
                                objOppHis.DW_Quarter_Awarded__c=oOppty.DW_Quarter_Awarded__c;
                                objOppHis.Design_Win_Revenue__c=oOppty.Design_Win_Revenue__c;
                                objOppHis.Awarded_Amount__c=oOppty.Awarded_Amount__c;								
								objOppHis.NWR__c=oOppty.NWR__c;
                                objOppHis.Fab_Group__c=oOppty.Fab_Group__c;
                                objOppHis.Opportunity_Owner_HCM__c=oOppty.Opportunity_Owner_HCM__c; 
                                objOppHis.X1st_Product_TO_Date_DW__c=oOppty.X1st_Product_TO_Date__c;
                                objOppHis.X1st_Product_Production_Date_DW__c=oOppty.X1st_Product_Production_Date__c;
                                objOppHis.Quote_DW__c=oOppty.Quote__c;
                                objOppHis.Does_entered_ASP_Align_with_Quote_DW__c=oOppty.Does_entered_ASP_Align_with_Quote__c;
                                objOppHis.Private__c=oOppty.IsPrivate;
                                objOppHis.Short_Name__c=oOppty.Short_Name__c;
                                objOppHis.Account_Owner__c=oOppty.Account_Owner__c;
                                objOppHis.Account_Division__c=oOppty.Account_Division__c;
                                objOppHis.Description__c=oOppty.Description__c;
                                objOppHis.Stage__c=oOppty.StageName;
                                objOppHis.Close_Date__c=oOppty.CloseDate;
                                objOppHis.Probability__c=oOppty.Probability;
                                objOppHis.AssignedPID__c=oOppty.AssignedPID__c;
                                objOppHis.Opportunity_Health__c=oOppty.Opportunity_Health__c;
                                objOppHis.Opportunity_Obstacles__c=oOppty.Opportunity_Obstacles__c;
                                objOppHis.Reason_for_Loss_Dropped__c=oOppty.Reason_for_Loss_Dropped__c;
                                objOppHis.Opportunity_Next_Step__c=oOppty.Opportunity_Next_Step__c;
                                objOppHis.End_Application_for_Opty__c=oOppty.End_Application_for_Opty__c;
                                objOppHis.Create_Program__c=oOppty.Create_Program__c;
                                objOppHis.Geometry_Requested_by_Customer__c=oOppty.Geometry_Requested_by_Customer__c;
                                objOppHis.Process_Family_Requested_by_Customer__c=oOppty.Process_Family_Requested_by_Customer__c;
                                objOppHis.First_Product_Production_Date_FQ__c=oOppty.First_Product_Production_Date_FQ__c;
                                objOppHis.Add_l_Process_Features__c=oOppty.Add_l_Process_Features__c;
                                objOppHis.Design_Enablements_Required__c=oOppty.Design_Enablements_Required__c;
                                objOppHis.Describe_Product_Development_Plan_DW__c=oOppty.Describe_Product_Development_Plan__c;
                                objOppHis.Target_Process_Technology__c=oOppty.Target_Process_Technology__c;
                                objOppHis.Secondary_GF_Fab__c=oOppty.Fab_Assignment_2__c;
                                objOppHis.Primary_GF_Fab_Production_Split__c=oOppty.Fab_Split__c;
                                objOppHis.Target_Process_Technology_Description__c=oOppty.Target_Process_Technology_Description__c;
                                objOppHis.Wafer_Size__c=oOppty.Wafer_Size__c;
                                objOppHis.Process_Category__c=oOppty.Process_Category__c;
                                objOppHis.Customer_Decision_Maker_DW__c=oOppty.Customer_Decision_Maker__c;
                                objOppHis.Paste_Commitment_Text_from_Customer_DW__c=oOppty.Paste_Commitment_Text_from_Customer__c;
								objOppHis.Territory_Head_for_ReviewDW__c=oOppty.Territory_Head_for_Review__c;
                                objOppHis.Date_Design_Win_Process_Reach_100__c=oOppty.Date_Design_Win_Process_Reach_100__c;
                                objOppHis.Design_Win_Review_Status__c=oOppty.Design_Win_Review_Status__c;
                                objOppHis.Date_Submitted_for_Review__c=oOppty.Date_Submitted_for_Review__c;
                                objOppHis.Sales_Ops_Comment__c=oOppty.Sales_Ops_Comment__c;
                                objOppHis.Design_Win_AM_Comments__c=oOppty.Design_Win_AM_Comments__c;
                                objOppHis.Marketing_Recommendation__c=oOppty.Marketing_Recommendation__c;
                                objOppHis.Design_Win_AM_Manager_s_Comments__c=oOppty.Design_Win_AM_Manager_s_Comments__c;
                                objOppHis.Design_Win_Marketing_Comments__c=oOppty.Design_Win_Marketing_Comments__c;
                                objOppHis.Process_Family__c=oOppty.Process_Family__c;
                                objOppHis.Product_Line_DW__c=oOppty.Product_Line__c;
                                objOppHis.Business_Unit_DW__c=oOppty.Business_Unit__c;
                                objOppHis.Blocking_Factor_DW__c=oOppty.Demand_Factor__c;
                                objOppHis.Status_P_DW__c=oOppty.Status_P__c;
                                objOppHis.Spotlight_DW__c=oOppty.Spotlight__c;
                                objOppHis.Is_this_Opportunity_for_Contract_Pricing__c=oOppty.Contract_Pricing__c;
                                objOppHis.Deliverable_Type_DW__c=oOppty.Deliverable_Type__c;
                                objOppHis.Net_Parts_Per_Wafer_DW__c=oOppty.Net_Parts_Per_Wafer__c;
                                objOppHis.Product_Tag_DW__c=oOppty.Product_Tag__c;
                                objOppHis.Exclude_from_Demand_Forecast_DW__c=oOppty.Create_Forecast_in_Demantra__c;
                                objOppHis.NPI_Device_DW__c=oOppty.NPI_Device__c;
                                objOppHis.Worst_Issue_Status_DW__c=oOppty.Worst_Issue_Status__c;
                                objOppHis.Primary_Opportunity_FAEDW__c=oOppty.Primary_Opportunity_FAE__c;
                                objOppHis.Design_Win_FAEDW__c=oOppty.Design_Win_FAE__c;
                                objOppHis.Production_Confidence_DW__c=oOppty.Production_Confidence__c;
                                objOppHis.Revenue_Potential_DW__c=oOppty.Revenue_Potential__c;
                                objOppHis.In_Base_Forecast_DW__c=oOppty.In_Base_Forecast1__c;
                                objOppHis.Accepted_OptionDW__c=oOppty.Option__c;
                                objOppHis.Add_l_Process_Features__c=oOppty.Add_l_Process_Features__c;
                                objOppHis.Is_this_an_Embedded_Memory_Opportunity__c=oOppty.Is_this_an_Embedded_Memory_Opportunity__c;
                                objOppHis.Primary_Indicative_Process_Id_DW__c=oOppty.AssignedPID__c;
                                objOppHis.Opportunity_Forecast_for_Service_DW__c=oOppty.Opportunity_Forecast_for_Service__c;
                                objOppHis.Opportunity_Forecast_for_Polymide_DW__c=oOppty.Opportunity_Forecast_for_Polymide__c;
                                objOppHis.Opportunity_Forecast_for_Sort_DW__c=oOppty.Opportunity_Forecast_for_Sort__c;
                                objOppHis.Opportunity_Forecast_for_Bump_DW__c=oOppty.Opportunity_Forecast_for_Bump__c;
                                objOppHis.LT_Wafers_kwfr_DW__c=oOppty.LT_Wafers_kwfr__c;
                                objOppHis.Design_Win_Region_DW__c=oOppty.Design_Win_Region__c;
                                objOppHis.Revenue_Region_DW__c=oOppty.Revenue_Region__c;
                                objOppHis.Design_Win_Territory_DW__c=oOppty.Design_Win_Territory__c;
                                objOppHis.Revenue_Territory_DW__c=oOppty.Revenue_Territory__c;
                                objOppHis.LTR_Rev_M_DW__c=oOppty.LTR_Rev_M__c;
                                objOppHis.Initiate_Deal_Grading_DW__c=oOppty.Initiate_Deal_Grading__c;
                                objOppHis.Number_of_Devices_to_claim_Tapeout_Win__c=oOppty.Number_of_Devices_to_claim_Tapeout_Win__c;
                                objOppHis.Approved_GMPLBX009_DW__c=oOppty.Approved_GMPL_BX009_DW__c;
                                objOppHis.Informal_Quote_DW__c=oOppty.Informal_Quote__c;
                                objOppHis.Application_and_Socket_Def_DW__c=oOppty.Application_and_Socket_Def__c;
                                objOppHis.Estimated_Die_X_dim_mm_DW__c=oOppty.Estimated_Die_X_dim_mm__c;
                                objOppHis.Estimated_Die_Y_dim_mm_DW__c=oOppty.Estimated_Die_Y_dim_mm__c;
								if((oOppty.Design_Win_Review_Status__c =='Won'  && (oOppty.Design_Win_Review_Status__c != triggerOldMap.get(oOppty.Id).Design_Win_Review_Status__c))){
									objOppHis.Reason_for_Design_Win_Snapshot_DW__c = 'Design Win Approved';
								}else{
									 objOppHis.Reason_for_Design_Win_Snapshot_DW__c ='Changed Stage From '+triggerOldMap.get(oOppty.Id).StageName+' To '+oOppty.StageName;
								}
                                
                                lstOppHistory.add(objOppHis);
                                oppids2.add(oOppty.id);    
                            }
                        }
                        if(lstOppHistory.size()>0){
                            QuarRevenueCreate(oppid,oppids2,lstOppHistory);//added by jabee 25.07.2017
                            /*lstChkOppHistory =[SELECT id,
                                                      Opportunity__c  
                                                 FROM Design_Win_Approval_History__c 
                                                WHERE Opportunity__c in :oppids2];system.debug('lstChkOppHistory:' + lstChkOppHistory);
                            if(lstChkOppHistory.size()<=0){
                                try{
                                    insert lstOppHistory;
                                }
                                catch(DMLException ex){
                                
                                    ApplicationLogWrapper appLog = new  ApplicationLogWrapper();
                                    appLog.source = 'Opportunity_TriggerHelper';
                                    appLog.sourceFunction = 'oppAfterTrigger()';
                                    appLog.ApplicationName = 'Unclassified';
                                    appLog.referenceId = string.valueOf(Opportunity.Id);
                                    appLog.referenceInfo = 'Opportunity';
                                    appLog.logMessage = ex.getMessage();
                                    appLog.payload = '';
                                    appLog.debugLevel = 'Error';
                                     
                                    GlobalUtility.logMessage(appLog);
                                    //trigger.new[0].addError(e+'test');
                                }
                                
                                lstQuaRevobj = [SELECT q.Volume__c, 
                                                       q.Revenue__c, 
                                                       q.Opportunity__c, 
                                                       q.Name, 
                                                       q.Id, 
                                                       q.Fiscal_Quarter__c, 
                                                       q.Count__c, 
                                                       q.ASP__c 
                                                  FROM Quarterly_Revenue_Object__c q 
                                                 WHERE Opportunity__c in :oppids2 and count__c=true];
                                                 
                                if(lstQuaRevobj.size()>0){
                                    for(integer i=0; i< lstQuaRevobj.size();i++){
                                        objQuaRevHis=new Quarterly_Revenues_History__c();//added by Jabee
                                        objQuaRevHis.ASP__c=lstQuaRevobj[i].ASP__c;
                                        objQuaRevHis.Fiscal_Quarter__c=lstQuaRevobj[i].Fiscal_Quarter__c;
                                        objQuaRevHis.Design_Win_Approval_History__c=lstOppHistory[0].id;
                                        objQuaRevHis.Opportunity__c=oppid;
                                        objQuaRevHis.Revenue__c=lstQuaRevobj[i].Revenue__c;
                                        objQuaRevHis.Volume__c=lstQuaRevobj[i].Volume__c;
                                        lstQuarRevenue.add(objQuaRevHis);
                                    }
                                    //insert lstQuarRevenue;
                                } 
                                //added by Jabee
                                if(lstQuarRevenue.size()>0){
                                    insert lstQuarRevenue;
                                }                     
                            }
                            */
                        }
                        // Start CreateQuarterlyRevenueRecords Trigger Code 
                        //Case 4962 ---Ykumar/21Jan2014 add two fields into below condition(High_End_Vol__c,Low_End_Vol__c)
                        if(opportunity.X1st_Product_Production_Date__c != triggerOldMap.get(opportunity.id).X1st_Product_Production_Date__c || opportunity.Years_of_Production__c != triggerOldMap.get(opportunity.id).Years_of_Production__c ||  opportunity.Reset_High_End_Vol_to_Percentage__c !=triggerOldMap.get(opportunity.id).Reset_High_End_Vol_to_Percentage__c ||  opportunity.Reset_Low_End_Vol_to_Percentage__c != triggerOldMap.get(opportunity.id).Reset_Low_End_Vol_to_Percentage__c){
                            // Updated by Nbustillos 07182012, cache values of old quarterly revenue. Currently this is not bulk optimize. See notes from comment header.
                            // List<Quarterly_Revenue_Object__c> Old_QRR=[select Id from Quarterly_Revenue_Object__c where  Opportunity__c=:opp.Id]
                            integer iCtr=0;
                            List<Quarterly_Revenue_Object__c> Old_QRR = new list<Quarterly_Revenue_Object__c>();
                             List<Quarterly_Revenue_Object__c> Old_QRR_List =QuarterlRevenuevalues(Opsidset);//added by jabee 25.07.2017
                             //Case 4962 ---Ykumar/21Jan2014 add two fields into below query(Reset_High_End_Vol_to_Percentage__c,Reset_Low_End_Vol_to_Percentage__c)
                            //for(Quarterly_Revenue_Object__c oQuarterlyRev : [select Id, Date__c, Volume__c, ASP__c,High_End_Vol__c,Low_End_Vol__c from Quarterly_Revenue_Object__c where Opportunity__c=:opportunity.Id]){
                            for(Quarterly_Revenue_Object__c oQuarterlyRev : Old_QRR_List){       
                                 Old_QRR.add(oQuarterlyRev);
                                
                                 mOldQuarterASP.put(iCtr, oQuarterlyRev.ASP__c);
                                 mOldQuarterVolume.put(iCtr, oQuarterlyRev.Volume__c);
                                  //Case 4962 -start--Ykumar/21Jan2014
                                 mOldHighVolume.put(iCtr,oQuarterlyRev.High_End_Vol__c);
                                 mOldLowVolume.put(iCtr,oQuarterlyRev.Low_End_Vol__c);
                                 //Case 4962 -END--Ykumar/21Jan2014
                                 iCtr++;
                            }
                            
                            //delete Old_QRR;  
                            //UpdateCond= true; 
                             UpdateCond= QuarterlyRevenueDelete(Old_QRR);//added by jabee 25.07.2017
                        }
                        // End CreateQuarterlyRevenueRecords Trigger Code 
                        
                        // Added by Nbustillos 02252013, for recomputation of adjusted volume during probability change.
                        for(Opportunity oppty : (List<Opportunity>)trigger.new){
                            if(oppty.Probability != triggerOldMap.get(oppty.id).Probability){
                                setOpptyIDsToRecompute.add(oppty.id);
                            }
                        }  
                    }
                    // Start CreateQuarterlyRevenueRecords Trigger Code
                    //RCUA: START Code to add the new Quarterly Revenue Records                 
                    if(opportunity.X1st_Product_Production_Date__c != null && opportunity.Years_of_Production__c !=null && opportunity.X1st_Product_Production_Date__c < date.newInstance(2025,12,30)){
                        if(Trigger.IsInsert || UpdateCond == true){
                            //Find out how many records are to be created based on Years of Production
                            decimal RecordsCreatedCount= opportunity.Years_of_Production__c*4;
                                
                            //Initiate the Date
                            Date dateInserted;
                            // Updated by Nbustillos, 03072013 for temporary fix of fiscal quarter generation.
                            string sFiscalQtr = FiscalYearHelper.getFiscalQuarter(opportunity.X1st_Product_Production_Date__c);
                            integer intFQ_Year = integer.valueof(sFiscalQtr.mid(0,4));
                            integer intFQ_Quarter = integer.valueof(sFiscalQtr.mid(6,1)); 
                                
                            //loop through the number of Quarterly Revenue records to be created
                            for(integer i=0; i<RecordsCreatedCount; i++){
                                //setup the Date
                                if(i==0){
                                    // Updated by Nbustillos 02252013, 'Date' field generation is now based on the Fiscal Quarter 
                                    // instead of '1st Product Production Date (DW)'
                                    if(intFQ_Quarter==1){
                                        // ZAmbat 04/04/2013
                                        dateInserted=date.newInstance(intFQ_Year, 1, 15);
                                    }else if(intFQ_Quarter==2){
                                        // ZAmbat 04/04/2013
                                        dateInserted=date.newInstance(intFQ_Year, 4, 15);
                                    }else if(intFQ_Quarter==3){
                                        // ZAmbat 04/04/2013
                                        dateInserted=date.newInstance(intFQ_Year, 7, 15);
                                    }else{
                                        // ZAmbat 04/04/2013
                                        dateInserted=date.newInstance(intFQ_Year, 10, 15);
                                    }
                                    
                                }else{
                                    date tempDate = dateInserted;
                                    dateInserted=tempDate.addMonths(3);
                                }
        
                                //setup the Quarter
                                string strFiscal_Quarter = intFQ_Year + '-Q' + intFQ_Quarter;
                                
                                // Updated by Nbustillos 07182012, update Volume/ASP if date is within range of old quarterly revenue records. Currently this is not bulk optimize. See notes from comment header.                              
                                double dASP = 0;
                                decimal nVolume = 0;
                                if(mOldQuarterASP.containsKey(i) || mOldQuarterVolume.containsKey(i)){
                                    dASP = mOldQuarterASP.get(i);
                                    nVolume = mOldQuarterVolume.get(i);
                                }
                                
                                 //Case 4962 -- start-Ykumar/21Jan2014
                                double sHighVol;
                                double sLowVol;
                                if(mOldHighVolume.containsKey(i))
                                {
                                    sHighVol=mOldHighVolume.get(i);
                                } 
                                if(mOldLowVolume.containsKey(i))
                                {
                                    sLowVol=mOldLowVolume.get(i);
                                } 
                                 //----Start ----06/03/2014 case #7011
                                sHighVol = opportunity.Reset_High_End_Vol_to_Percentage__c;
                                if(opportunity.Reset_High_End_Vol_to_Percentage__c != null)
                                {
                                   sHighVol= nVolume * ( 1 + opportunity.Reset_High_End_Vol_to_Percentage__c/100);
                                }
                                sLowVol= opportunity.Reset_Low_End_Vol_to_Percentage__c;
                                if(opportunity.Reset_Low_End_Vol_to_Percentage__c != null)
                                {
                                    sLowVol= nVolume * ( 1 + opportunity.Reset_Low_End_Vol_to_Percentage__c/100);
                                }
                               // ---end --06/03/2014 case #7011
                               
                                //Case 4962 -END--Ykumar/21Jan2014 
                                
                                listInsertQuarterLyRevenue.add(new Quarterly_Revenue_Object__c(Opportunity__c=opportunity.id,Date__c=dateInserted,ASP__c=dASP,Volume__c=nVolume,Counter__c=i+1, Fiscal_Quarter__c = strFiscal_Quarter,High_End_Vol__c=sHighVol,Low_End_Vol__c=sLowVol ));
                                    
                                //increment the Quarter
                                if (intFQ_Quarter == 4){
                                    intFQ_Quarter = 1;
                                    intFQ_Year = intFQ_Year + 1;
                                }else{
                                    intFQ_Quarter = intFQ_Quarter + 1;
                                }
                            }
                                
                        }
                    }else if(opportunity.X1st_Product_Production_Date__c != null && opportunity.Years_of_Production__c !=null && opportunity.X1st_Product_Production_Date__c > date.newInstance(2025,12,30)){
                      opportunity.addError('First Product Production Date should be between 2009-12-27 to 2025-12-30.');
                    }
                }//END Loop
            }
            if(listInsertQuarterLyRevenue.size() > 0)
                insert listInsertQuarterLyRevenue;
        
            if(Trigger.isUpdate)
                UpdDeviceOpptyHelper.ControllerMethod(Trigger.new, triggerOldMap);
            if (Trigger.isInsert)
                UpdDeviceOpptyHelper.ControllerMethod(Trigger.new);
            
             
        }
    }
    /*********************************************************************************************************************************************************
    @ Method:         updateTrOptionStage()
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        The Purpose of Trigger is to update the TechnicalRequirement OptionStage value based on Opportunity stage.
    **********************************************************************************************************************************************************/    
  /*  public void updateTrOptionStage(){
        
        for(Opportunity opportunity : (List<Opportunity>)Trigger.new){
            if(opportunity.StageName=='2. Assessment')
            opportunityIds.add(opportunity.Id);    
        }
        List<Customer_Requirement__c> TrToUpdate = new List<Customer_Requirement__c>();
        if(!opportunityIds.isEmpty()){
     
         for(Customer_Requirement__c TR : [select id, Option_Stage__c,Opportunity__c,Deliverable_Part_Number_DPN__c from Customer_Requirement__c where Opportunity__c in: opportunityIds]){   
          TR.Option_Stage__c='Customer Engagement';
          TrToUpdate.add(TR);
       }
        Update TrToUpdate;    
    }
    } */
     
     /*Private functions*/
    //------function that updates account in Opportunity Program and Devices records which are related to the current opportunity.
 @testvisible   private void updateOpptyRelatedRecords(Set<Id> opptyIDs){
        list<Opportunity_Program__c> lstOpptyProgramToUpdate = new list<Opportunity_Program__c>();
        list<Device__c> lstDeviceToUpdate = new list<Device__c>();
        for(Opportunity_Program__c oOpptyProgram : [SELECT recordtypeid, 
                                                           Opportunity__c, 
                                                           (SELECT RecordTypeId, 
                                                                   Status__c  
                                                              FROM Devices__r) 
                                                      FROM Opportunity_Program__c 
                                                     WHERE Opportunity__c in :opptyIDs]){
            if(oOpptyProgram.Devices__r!=null){
                for(Device__c oDevice : oOpptyProgram.Devices__r){
                    oDevice.Account__c = triggerNewMap.get(oOpptyProgram.Opportunity__c).Accountid;
                    lstDeviceToUpdate.add(oDevice);
                }
            }
            oOpptyProgram.Account__c = triggerNewMap.get(oOpptyProgram.Opportunity__c).Accountid;
            lstOpptyProgramToUpdate.add(oOpptyProgram);
        }
        if(lstOpptyProgramToUpdate.size()>0){
            update lstOpptyProgramToUpdate;
        }
        if(lstDeviceToUpdate.size()>0){
            update lstDeviceToUpdate;
        }
    }
    
    // function that creates Opty Program record.
 @testvisible   private Opportunity_Program__c createOptyProgram(Opportunity oOppty){
        Opportunity_Program__c retVal = new Opportunity_Program__c();
        retVal.Name = oOppty.Name;
        retVal.Opportunity_ID_Key__c = oOppty.Id;
        retVal.Opportunity__c = oOppty.Id;
        retVal.Account__c = oOppty.AccountId;
        retVal.Technology__c = oOppty.Target_Process_Node__c;
        retVal.OwnerId = oOppty.OwnerId;
        
        // Added By Nbustillos, 08162013 for sharing Oppty Program
        retVal.Is_Private_Copy__c = oOppty.IsPrivate;
        return retVal;
    }
    
    // function that checks if oppty has at least 1 device related to it and add error message.
  @testvisible  private void validateAccountChange(set<id> opptyIDs){
        for(Opportunity_Program__c oOpptyProgram : [SELECT Opportunity__c, (SELECT RecordTypeId, 
                                                                                   Status__c  
                                                                              FROM Devices__r limit 1) 
                                                      FROM Opportunity_Program__c 
                                                     WHERE Opportunity__c in :opptyIDs]){
            if(oOpptyProgram.Devices__r!=null){
                Opportunity oOppty = triggerNewMap.get(oOpptyProgram.Opportunity__c);
                oOppty.addError('Opportunity account cannot change as device record already exists in Opportunity Program.');
            }                                       
        }
    }
    
    // function that generates the Opportunity Program core team members.
    // TBD: This potentially can hit governor limit. Can be moved as asynchronous process via @future.
  @testvisible  private void createOpptyProgramCoreTeam(set<id> opptyProgIDs){
        
        //retrieve opportunity program records records
        map<id,list<id>> mAccountOpptyProgID = new map<id,list<id>>();
        for(Opportunity_Program__c oOpptyProgram : [SELECT id, 
                                                           Opportunity__c, 
                                                           Account__c 
                                                      FROM Opportunity_Program__c 
                                                     WHERE id in :opptyProgIDs]){
            // add account ID/opportunity IDs to map for opty team member creation
            if(mAccountOpptyProgID.containsKey(oOpptyProgram.Account__c)){
                // Record pulled for individual Accounts from list 
                // Modifications made to fix Account Team rolldown issue to opportunity program team member
                list<id> optyProgIDs = mAccountOpptyProgID.get(oOpptyProgram.Account__c);
                optyProgIDs.add(oOpptyProgram.id);
                mAccountOpptyProgID.put(oOpptyProgram.Account__c,optyProgIDs);
            }else{
                mAccountOpptyProgID.put(oOpptyProgram.Account__c, new list<id> {oOpptyProgram.id});
            }
        }
        
        // retrieve and generate core team records
        list<Opportunity_Program_Team_Member__c> lstOptyTeamMembers = new list<Opportunity_Program_Team_Member__c>();
        for(Account_Team_Proxy__c oATP : [SELECT id, 
                                                 Account__c, 
                                                 User__c, 
                                                 Team_Role__c, 
                                                 Opportunity_Access__c 
                                            FROM Account_Team_Proxy__c 
                                           WHERE Account__c in :mAccountOpptyProgID.keySet() and Flag_for_Delete__c = false and Opportunity_Access__c != null order by Account__c]){
            
            // get Account's Opportunity Id
            for(id optyProgID : mAccountOpptyProgID.get(oATP.Account__c)){
                lstOptyTeamMembers.add(new Opportunity_Program_Team_Member__c(User__c =oATP.User__c,
                                                                            Opportunity_Program__c=optyProgID,
                                                                            Core_Team_Member__c=true,
                                                                            Device_Access__c=oATP.Opportunity_Access__c,
                                                                            Opportunity_Program_Access__c=oATP.Opportunity_Access__c,
                                                                            Team_Role__c=oATP.Team_Role__c,
                                                                            ExternalUserKeyField__c=oATP.Account__c+'_'+oATP.User__c,
                                                                            Account_Team_Proxy__c=oATP.Id));
            }
        }
        
        if(lstOptyTeamMembers.size()>0){
            insert lstOptyTeamMembers;
        }
    }
    
    // function that makes all devices, oppty program, device gaps and EDA requirement related to Oppty read only.
    // TBD: This potentially can hit governor limit. Can be moved as asynchronous process via @future.
  @testvisible  private void updateOpptyRelatedRecordsToReadOnly(Set<Id> opptyIDs){
        map<String,Id> mRecordTypes = new map<String,id>();
        
        // query read only recordtypes
        set<string> setAPINames = new set<string>{OPPTY_PROG_API_NAME,DEVICE_API_NAME,DEVICE_GAP_API_NAME,EDA_REQ_API_NAME};
        
        for(RecordType oRecType : [SELECT id, 
                                          sobjectType 
                                     from RecordType 
                                    where SobjectType in :setAPINames and name = :READONLY_NAME]){
            mRecordTypes.put(oRecType.sObjectType,oRecType.id);
        }
        
        // process opportunity program
        list<Opportunity_Program__c> lstOpptyProgramToUpdate = new list<Opportunity_Program__c>();
        list<Device__c> lstDeviceToUpdate = new list<Device__c>();
        list<Device_Gap__c> lstDeviceGapToUpdate = new list<Device_Gap__c>();
        list<EDA_Requirement__c> lstEDAReqrmntsToUpdate = new list<EDA_Requirement__c>();
        
        for(Opportunity_Program__c oOpptyProgram : [select recordtypeid, Opportunity__c, 
                                                   (SELECT RecordTypeId FROM EDA_Requirements__r), 
                                                   (SELECT RecordTypeId FROM Device_Gaps__r), 
                                                   (SELECT RecordTypeId, Status__c  FROM Devices__r) from 
                                                   Opportunity_Program__c where Opportunity__c in :opptyIDs]){
            boolean bContinueUpdate = true;
            if(oOpptyProgram.Devices__r!=null){
                for(Device__c oDevice : oOpptyProgram.Devices__r){
                    // check if there is no active device or design win review equal to NULL
                    if(oDevice.Status__c!=DEVICE_STATUS_ACTIVE){
                        oDevice.recordtypeid = mRecordTypes.get(DEVICE_API_NAME);
                        lstDeviceToUpdate.add(oDevice);
                    }else{
                        Opportunity oOppty = triggerNewMap.get(oOpptyProgram.Opportunity__c);
                        oOppty.addError('Cannot set Opportunity status to \'Void\' because there are related active devices.');
                        
                        lstDeviceToUpdate.clear();
                        bContinueUpdate = false;
                        break;
                    }
                }
            }
            
            if(bContinueUpdate){
                
                if(oOpptyProgram.Device_Gaps__r!=null){
                    for(Device_Gap__c oDeviceGap : oOpptyProgram.Device_Gaps__r){
                        oDeviceGap.recordtypeid = mRecordTypes.get(DEVICE_GAP_API_NAME);
                        lstDeviceGapToUpdate.add(oDeviceGap);
                    }
                }
                
                if(oOpptyProgram.EDA_Requirements__r!=null){
                    for(EDA_Requirement__c oEDAReqrmnts : oOpptyProgram.EDA_Requirements__r){
                        oEDAReqrmnts.recordtypeid = mRecordTypes.get(EDA_REQ_API_NAME);
                        lstEDAReqrmntsToUpdate.add(oEDAReqrmnts);
                    }
                }
                
                oOpptyProgram.recordtypeid = mRecordTypes.get(OPPTY_PROG_API_NAME);
                lstOpptyProgramToUpdate.add(oOpptyProgram);
            }
        }
        
        if(lstOpptyProgramToUpdate.size()>0){
            update lstOpptyProgramToUpdate;
        }
        
        if(lstDeviceToUpdate.size()>0){
            update lstDeviceToUpdate;
        }
        
        if(lstDeviceGapToUpdate.size()>0){
            update lstDeviceGapToUpdate;
        }
        
        if(lstEDAReqrmntsToUpdate.size()>0){
            update lstEDAReqrmntsToUpdate;
        }
    }
    
    // Function to update related devices
 @testvisible   private void updateDevices(Set<Id> opptyIds) {
        System.debug('Opportunity Ids ==============> ' + opptyIds);
        // Retrieve all related devices
        List<Device__c> listDevices = [
            SELECT      Id
                        , Send_for_Integration__c
            FROM        Device__c
            WHERE       Opportunity2__c IN :opptyIds
                        AND (Siebel_Status__c = null
                            OR Siebel_Status__c = '')
                        AND Siebel_Device_Complete__c = 'TRUE'
                        AND Copied_Device__c = null
        ];
        
        for (Device__c d : listDevices) {
            d.Send_for_Integration__c = True;
        }

        // Force update records
        if (listDevices.size() > 0) {
            Update listDevices;
        }
    }
    
    // Function that updates Opportunity Program Is Private Copy field.
  @testvisible  private void updateOpptyProgramPrivateCopy(Set<Id> opptyIds){
        List<Opportunity_Program__c> lstOpptyProgramToUpdate = new List<Opportunity_Program__c>();
        for(Opportunity_Program__c oOpptyProgram : [select Is_Private_Copy__c, Opportunity__c from 
                                                    Opportunity_Program__c where Opportunity__c in :opptyIDs]){
            oOpptyProgram.Is_Private_Copy__c = triggerNewMap.get(oOpptyProgram.Opportunity__c).IsPrivate;
            lstOpptyProgramToUpdate.add(oOpptyProgram);
        }
        
        if(lstOpptyProgramToUpdate.size()>0){
            update lstOpptyProgramToUpdate;
        } 
    } 
     /*********************************************************************************************************************************************************
    @ Method:         updateoptyPLMMarketSegment()
    @ Version:        1.0
    @ Author:         Abhishek Srivastava (abhishekkumar.srivastava@globalfoundries.com)
    @ Purpose:        The Purpose of Trigger is to update the Assigned PLM/MarketSegment value based on custom table 'Opportunity_Control_Point_Approvals__c'
    **********************************************************************************************************************************************************/    
    public void updateoptyPLMMarketSegment(){ 
    
        List<Opportunity_Control_Point_Approvals__c> listofoptycpapproval = [Select Id, Market_Segment__c,PLM__c,Pricing__c,User__r.name,user__r.email from Opportunity_Control_Point_Approvals__c];
        Set<String> listofmarketsegmentusers = new Set<String>();
        Set<String> listofplmusers = new Set<String>();
        Set<String> listofmarketsegmentuserIds = new Set<String>();
        Set<String> listofplmuserIds = new Set<String>();
        for(Opportunity opt: (List<Opportunity>)Trigger.new){
            for(Opportunity_Control_Point_Approvals__c opc: listofoptycpapproval ){
                if(opt.Market_Segment__c == opc.Market_Segment__c && opt.Market_Segment__c != null && opc.Market_Segment__c != null){
                        listofmarketsegmentusers.add(string.valueOf(opc.User__r.name));
                        listofmarketsegmentuserIds.add(string.valueOf(opc.User__r.id));
                }
                if(opt.product_line__c == opc.PLM__c && opt.product_line__c != null && opc.PLM__c != null ){
                        listofplmusers.add(string.valueOf(opc.User__r.name));
                        listofplmuserIds.add(string.valueOf(opc.User__r.id));
                }
            }
        }
        
        for(Opportunity op: (List<Opportunity>)Trigger.new){
            op.Assigned_PLM__c = string.valueOf(converttostring(listofplmusers));
            op.Assigned_Segment_Marketing__c = string.valueOf(converttostring(listofmarketsegmentusers));
            op.Assigned_PLM_UserId__c = string.valueOf(converttostring(listofplmuserIds));
            op.Assigned_Segment_Marketing_UserId__c = string.valueOf(converttostring(listofmarketsegmentuserIds));
        } 
    
    }
    
    public string converttostring(set<string> setToConvert) {
        string str = '';
        if(setToConvert.size() > 0){
            for(String st: setToConvert){
                str += st+',';
            }    
        }
        string setUsername = '';
        if(str != null && str != ''){ 
            setUsername = str.removeEnd(',');
        } 
        return setUsername;
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateLastEditorOfIPDF()
    @ Version:        1.0
    @ Author:         Pradosh Sama; (pradosh.samal@globalfoundries.com)
    @ Purpose:        The Purpose of this method is to update last modifier user of Include PreDiscovery in Demand Forecast(Include_PreDiscovery_in_Demand_Forecast__c) field to Last Editor Of IPDF(Last_Editor_Of_IPDF__c) field of Opportunity object'
    **********************************************************************************************************************************************************/    
    public void updateLastEditorOfIPDF(){ 
    
        for(Opportunity optObj : (List<Opportunity>)Trigger.new){
            
            if(optObj.Include_PreDiscovery_in_Demand_Forecast__c != triggerOldMap.get(optObj.Id).Include_PreDiscovery_in_Demand_Forecast__c){
                
                optObj.Last_Editor_Of_IPDF__c = UserInfo.getUserId();
            }
        }
    }
      //Added by jabee for the case#00072092 LT Value and 00070089
     Public Void UpdateOpportunity(){
       set<Id> AccountIDs=new set<Id>();
        Map<Id,Account> AccountMap=new Map<Id,Account>();
        Map<Id,Opportunity> OldOppMap=new Map<Id,Opportunity>();
        for(Opportunity Oldopp:(List<Opportunity>)trigger.old){
            system.debug('***O*L*D*M*A*P***'+Oldopp);
            OldOppMap.put(Oldopp.id,Oldopp);
        }
        
        for (Opportunity opp: (List<Opportunity>)trigger.new) {
          if((OldOppMap.get(opp.id).Territory_Head_for_Review__c!=opp.Territory_Head_for_Review__c) || (OldOppMap.get(opp.id).Sales_SVP_for_Review__c!=opp.Sales_SVP_for_Review__c)){
           AccountIDs.add(opp.accountId);
          }
        }
        if(AccountIDs.size()!=0){
            for(Account AC:[select Id,Name,Region__c,Financial_Territory__c from Account where Id IN:AccountIDs]){
                AccountMap.put(AC.Id,AC);
            }
        }
        for(Opportunity oppty: (List<Opportunity>)trigger.new){
            if(AccountMap.size()!=0){
                if((OldOppMap.get(oppty.id).Territory_Head_for_Review__c!=oppty.Territory_Head_for_Review__c) || (OldOppMap.get(oppty.id).Sales_SVP_for_Review__c!=oppty.Sales_SVP_for_Review__c)){
                    if(oppty.Design_Win_Region_Override__c!=AccountMap.get(oppty.accountId).Region__c){
                        oppty.Design_Win_Region_Override__c=AccountMap.get(oppty.accountId).Region__c;
                        oppty.Design_Win_Territory_Override__c=AccountMap.get(oppty.accountId).Financial_Territory__c;
                        oppty.Revenue_Region_Override__c=AccountMap.get(oppty.accountId).Region__c;
                        oppty.Revenue_Territory_Override__c=AccountMap.get(oppty.accountId).Financial_Territory__c;
                    }
                    if(oppty.Design_Win_Region_Override__c==null || oppty.Revenue_Region_Override__c==null){
                        system.debug('***E*N*T*E*R***'+AccountMap.get(oppty.accountId).Region__c);
                        oppty.Design_Win_Region_Override__c=AccountMap.get(oppty.accountId).Region__c;
                        oppty.Design_Win_Territory_Override__c=AccountMap.get(oppty.accountId).Financial_Territory__c;
                        oppty.Revenue_Region_Override__c=AccountMap.get(oppty.accountId).Region__c;
                        oppty.Revenue_Territory_Override__c=AccountMap.get(oppty.accountId).Financial_Territory__c;
                    }
                }
            }
             oppty.LT_Wafers_kwfr__c=oppty.LT_Wafer_Rollup__c/1000;
      }
    
    }
    //added by jabee 11-07-2017
    Public void QuarterlyRevUpdate(List<Opportunity> OppList){
        List<Budgetary_Quote_Item__c> BudgetQtItem = new List<Budgetary_Quote_Item__c>();
         set<Id> InformalQt= new set<Id>();
         set<Id> oppIdSetNew = new set<Id>();
        Map<Id,Budgetary_Quote_Item__c> BudgetaryQuoteMap=new Map<Id,Budgetary_Quote_Item__c>();
        List<Quarterly_Revenue_Object__c> QuarterlyRev = new List<Quarterly_Revenue_Object__c>();
        List<Quarterly_Revenue_Object__c> QuarterlyRevUpdList = new List<Quarterly_Revenue_Object__c>();
        if(!OppList.isEmpty()){
            for(Opportunity opporTemp: OppList){
                if(opporTemp.Informal_Quote__c != null){
                    InformalQt.add(opporTemp.Informal_Quote__c);
                    oppIdSetNew.add(opporTemp.Id);
                }
            }
        }
        if(InformalQt.size()!=0){
            for(Budgetary_Quote_Item__c BudgetaryQuoteItem :[SELECT id,Quarter__c,Budgetary_Quote__c,Sales_Requested_Price__c,Pricing_Approved_Price__c FROM Budgetary_Quote_Item__c WHERE Pricing_Approved_Price__c != Null and Budgetary_Quote__c IN: InformalQt]){
                //BudgetaryQuoteMap.put(BudgetaryQuoteItem.id,BudgetaryQuoteItem);
                BudgetaryQuoteMap.put(BudgetaryQuoteItem.Budgetary_Quote__c,BudgetaryQuoteItem);
            }
        }
        if(oppIdSetNew.size()!=0){
            QuarterlyRev = [SELECT id,Name,ASP__c,Informal_Quote__c,Fiscal_Quarter__c,Opportunity__c,Opportunity__r.Informal_Quote__c FROM Quarterly_Revenue_Object__c WHERE Opportunity__c IN: oppIdSetNew];
            //Case 00041073 - start--Manikumar/21July2015
                    List<Device__c> lstDevice=[SELECT Id,Opportunity2__c,Status__c FROM Device__c WHERE Opportunity2__c IN :oppIdSetNew and Status__c='Active' and Tapeout_Type__c='Single Product'];
            
        }
        if(QuarterlyRev.size()!=0){
            for(Quarterly_Revenue_Object__c QuartRev : QuarterlyRev){
                if(BudgetaryQuoteMap != null && !BudgetaryQuoteMap.isEmpty()){
                    if(BudgetaryQuoteMap.get(QuartRev.Opportunity__r.Informal_Quote__c).Quarter__c==QuartRev.Fiscal_Quarter__c && BudgetaryQuoteMap.get(QuartRev.Opportunity__r.Informal_Quote__c).Budgetary_Quote__c==QuartRev.Informal_Quote__c){
                        QuartRev.ASP__c = BudgetaryQuoteMap.get(QuartRev.Opportunity__r.Informal_Quote__c).Pricing_Approved_Price__c;
                        QuarterlyRevUpdList.add(QuartRev);
                    }
                }
            }
        }
        if(!QuarterlyRevUpdList.isEmpty()){
            update QuarterlyRevUpdList;
        }
        
    }
    //added by jabee 11-07-2017
    Public void QuarRevenueCreate(id oppid,set<id> oppids2,List<Design_Win_Approval_History__c> lstOppHistory){
        List<Quarterly_Revenue_Object__c> lstQuaRevobj = new List<Quarterly_Revenue_Object__c>();
      List<Design_Win_Approval_History__c> lstChkOppHistory =  new List<Design_Win_Approval_History__c>();
       List<Quarterly_Revenues_History__c> lstQuarRevenue = new List<Quarterly_Revenues_History__c>();
      Quarterly_Revenues_History__c objQuaRevHis=new Quarterly_Revenues_History__c();
        lstChkOppHistory =[SELECT id,
                                  Opportunity__c  
                             FROM Design_Win_Approval_History__c 
                            WHERE Opportunity__c in :oppids2];system.debug('lstChkOppHistory:' + lstChkOppHistory);
        if(lstChkOppHistory.size()>=0){
            try{
                insert lstOppHistory;
            }
            catch(DMLException ex){
            
                ApplicationLogWrapper appLog = new  ApplicationLogWrapper();
                appLog.source = 'Opportunity_TriggerHelper';
                appLog.sourceFunction = 'oppAfterTrigger()';
                appLog.ApplicationName = 'Unclassified';
                appLog.referenceId = string.valueOf(Opportunity.Id);
                appLog.referenceInfo = 'Opportunity';
                appLog.logMessage = ex.getMessage();
                appLog.payload = '';
                appLog.debugLevel = 'Error';
                 
                GlobalUtility.logMessage(appLog);
                //trigger.new[0].addError(e+'test');
            }
            
            lstQuaRevobj = [SELECT q.Volume__c, 
                                   q.Revenue__c, 
                                   q.Opportunity__c, 
                                   q.Name, 
                                   q.Id, 
                                   q.Fiscal_Quarter__c,
                                   q.Count__c,
                                   q.Net_Parts_Per_Wafer__c,
                                   q.ASP_Module_Chip__c,
                                   q.NRE__c,
                                   q.Module_Die_ASP__c,
                                   q.Module_Die_Vol__c,
                                   q.Post_Wafer_ASP_Module_ASP__c,
                                   q.Turnkey_ASP__c,
                                   q.ASP__c 
                              FROM Quarterly_Revenue_Object__c q 
                             WHERE Opportunity__c in :oppids2 and count__c=true];
                             
            if(lstQuaRevobj.size()>0){
                for(integer i=0; i< lstQuaRevobj.size();i++){
                    objQuaRevHis=new Quarterly_Revenues_History__c();//added by Jabee
                    objQuaRevHis.ASP__c=lstQuaRevobj[i].ASP__c;
                    objQuaRevHis.Fiscal_Quarter__c=lstQuaRevobj[i].Fiscal_Quarter__c;
                    objQuaRevHis.Design_Win_Approval_History__c=lstOppHistory[0].id;
                    objQuaRevHis.Opportunity__c=oppid;
                    objQuaRevHis.Revenue__c=lstQuaRevobj[i].Revenue__c;
                    objQuaRevHis.Volume__c=lstQuaRevobj[i].Volume__c;
                    objQuaRevHis.Net_Parts_Per_Wafer__c=lstQuaRevobj[i].Net_Parts_Per_Wafer__c;
                    objQuaRevHis.ASP_Module_Chip__c=lstQuaRevobj[i].ASP_Module_Chip__c;
                    objQuaRevHis.Count__c=lstQuaRevobj[i].Count__c;
                    objQuaRevHis.NRE__c=lstQuaRevobj[i].NRE__c;
                    objQuaRevHis.Module_Die_ASP__c=lstQuaRevobj[i].Module_Die_ASP__c;
                    objQuaRevHis.Module_Die_Vol__c=lstQuaRevobj[i].Module_Die_Vol__c;
                    objQuaRevHis.Post_Wafer_ASP_Module_ASP__c=lstQuaRevobj[i].Post_Wafer_ASP_Module_ASP__c;
                    objQuaRevHis.Turnkey_ASP__c=lstQuaRevobj[i].Turnkey_ASP__c;
                    lstQuarRevenue.add(objQuaRevHis);
                }
                //insert lstQuarRevenue;
            } 
            //added by Jabee
            if(lstQuarRevenue.size()>0){
                insert lstQuarRevenue;
            }                     
        }
    }
    public boolean QuarterlyRevenueDelete(List<Quarterly_Revenue_Object__c> Old_QRR){
        delete Old_QRR;
        return true;
    }
    
    public List<Quarterly_Revenue_Object__c> QuarterlRevenuevalues(set<id> Oppsidset){
       List<Quarterly_Revenue_Object__c> QuarterlyRevenueList=[select Id, Date__c, Volume__c, ASP__c,High_End_Vol__c,Low_End_Vol__c from Quarterly_Revenue_Object__c where Opportunity__c IN:Oppsidset];
        return QuarterlyRevenueList;
    }
    /*********************************************************************************************************************************************************
    @ Method:         oppCheckforFeedback()
    @ Version:        1.0
    @ Author:         Yathish; (yathish.ns1@globalfoundries.com)
    @ Purpose:        The Purpose of this method is to show error message when opportumity stage changed to some vales
    **********************************************************************************************************************************************************/
    public void oppCheckforFeedback(){
        if(!test.isrunningtest())
        {
        for(opportunity op:(List<Opportunity>) trigger.new){
            Opportunity oldOp = (Opportunity)Trigger.oldMap.get(op.Id);
            if(op.IsFeedbackDone__c== false && (op.StageName != oldop.StageName) && (op.StageName =='8. Lost' || op.StageName =='9. Dropped' || op.StageName =='10. Void'))
            {
                op.addError(EnvironmentVariable.get('FEEDBACK_SURVEY_MADITORY_MSG'));
            }
        }    
        }
    }
         
     
     public void updateDeafaultOppIssue(){
        
        Set<Id> opportunityIdSet = new Set<Id>();
        
        for(Opportunity oppObj : (List<Opportunity>) Trigger.New){
            
            if(triggerNewMap.get(oppObj.Id).OwnerId != triggerOldMap .get(oppObj.Id).OwnerId
              || triggerNewMap.get(oppObj.Id).CloseDate !=  triggerOldMap.get(oppObj.Id).CloseDate
              || triggerNewMap.get(oppObj.Id).Primary_Opportunity_FAE__c != triggerOldMap .get(oppObj.Id).Primary_Opportunity_FAE__c
              || triggerNewMap.get(oppObj.Id).X1st_Product_TO_Date__c !=  triggerOldMap.get(oppObj.Id).X1st_Product_TO_Date__c){
                
                opportunityIdSet.add(oppObj.Id);
            }
        }
        
        if(! (opportunityIdSet.size() > 0) ){
            
            return;
        }
        
        List<Device_Gap__c> deviceGapList = [SELECT Id, Opportunity__c, Gap_Type__c, Gap_Sub_Type__c FROM Device_Gap__c WHERE Opportunity__c IN :opportunityIdSet AND Gap_Type__c = 'Milestone' AND (Gap_Sub_Type__c = 'Close Date' OR Gap_Sub_Type__c = '1st Product TO')];
        
        Set<Id> opty1stProductTOExistSet = new Set<Id>();
        Set<Id> optyCloseDateExistSet = new Set<Id>();
        List<Device_Gap__c> defaultOppIssueList = new List<Device_Gap__c>();
        Boolean isUpdate;
        
        for(Device_Gap__c deviceGap : deviceGapList){
            
            isUpdate = FALSE;
            
            if(deviceGap.Gap_Sub_Type__c == 'Close Date'){
                optyCloseDateExistSet.add(deviceGap.Opportunity__c);
            }
            else if(deviceGap.Gap_Sub_Type__c == '1st Product TO'){
                opty1stProductTOExistSet.add(deviceGap.Opportunity__c);
            }
            
            if(deviceGap.Gap_Sub_Type__c == 'Close Date' 
              && triggerNewMap.get(deviceGap.Opportunity__c).OwnerId != triggerOldMap .get(deviceGap.Opportunity__c).OwnerId){
                
                deviceGap.Solution_Owner__c = triggerNewMap.get(deviceGap.Opportunity__c).OwnerId;
                isUpdate = TRUE;
            }
            else if(deviceGap.Gap_Sub_Type__c == '1st Product TO'
              && triggerNewMap.get(deviceGap.Opportunity__c).Primary_Opportunity_FAE__c != triggerOldMap .get(deviceGap.Opportunity__c).Primary_Opportunity_FAE__c){
                
                deviceGap.Solution_Owner__c = triggerNewMap.get(deviceGap.Opportunity__c).Primary_Opportunity_FAE__c;
                isUpdate = TRUE;
            }
            
            if(deviceGap.Gap_Sub_Type__c == 'Close Date' 
              && triggerNewMap.get(deviceGap.Opportunity__c).CloseDate !=  triggerOldMap.get(deviceGap.Opportunity__c).CloseDate){
                
                deviceGap.Action_Close_Date__c = triggerNewMap.get(deviceGap.Opportunity__c).CloseDate;
                deviceGap.Action_Close_Date_P__c = triggerOldMap.get(deviceGap.Opportunity__c).CloseDate;
                deviceGap.Need_by_Date__c = triggerNewMap.get(deviceGap.Opportunity__c).CloseDate;
                isUpdate = TRUE;
            }
            else if(deviceGap.Gap_Sub_Type__c == '1st Product TO' 
              && triggerNewMap.get(deviceGap.Opportunity__c).X1st_Product_TO_Date__c !=  triggerOldMap.get(deviceGap.Opportunity__c).X1st_Product_TO_Date__c){
                
                deviceGap.Action_Close_Date__c = triggerNewMap.get(deviceGap.Opportunity__c).X1st_Product_TO_Date__c;
                deviceGap.Action_Close_Date_P__c = triggerOldMap.get(deviceGap.Opportunity__c).X1st_Product_TO_Date__c;
                deviceGap.Need_by_Date__c = triggerNewMap.get(deviceGap.Opportunity__c).X1st_Product_TO_Date__c;
                isUpdate = TRUE;
            }
            
            if(isUpdate){
                defaultOppIssueList.add(deviceGap);
            }
        }
        
        Device_Gap__c tempOppIssue;
        for(Opportunity oppObj : (List<Opportunity>) Trigger.New){
            
            if((! optyCloseDateExistSet.contains(oppObj.Id))
              && oppObj.CloseDate != NULL){
                
                tempOppIssue = new Device_Gap__c();
                tempOppIssue.Opportunity__c = oppObj.Id;
                tempOppIssue.Gap_Type__c = 'Milestone';
                tempOppIssue.Gap_Sub_Type__c = 'Close Date';
                tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
                tempOppIssue.Area__c = 'Milestone';
                tempOppIssue.Issue_Comments__c = 'Close Date';
                tempOppIssue.Select_Status__c = 'M - Milestone';
                tempOppIssue.Improve_Prob__c = 0;
                tempOppIssue.Improve_Prob_P__c = 0;
                tempOppIssue.Action_to_Close_Issue__c = '<< Design Win Close Date >>';
                tempOppIssue.Solution_Owner__c = oppObj.OwnerId;
                tempOppIssue.Action_Close_Date__c = oppObj.CloseDate;
                tempOppIssue.Need_by_Date__c = oppObj.CloseDate;
                
                defaultOppIssueList.add(tempOppIssue);
            }
            
            if((! opty1stProductTOExistSet.contains(oppObj.Id))
              && oppObj.X1st_Product_TO_Date__c != NULL){
                
                tempOppIssue = new Device_Gap__c();
                tempOppIssue.Opportunity__c = oppObj.Id;
                tempOppIssue.Gap_Type__c = 'Milestone';
                tempOppIssue.Gap_Sub_Type__c = '1st Product TO';
                tempOppIssue.Select_Engagement_Step__c = 'B. DWIN Pre-Product Definition Plan & Resourcing (Schedule for achieving DWIN, Benchmarking)';
                tempOppIssue.Area__c = 'Milestone';
                tempOppIssue.Issue_Comments__c = '1st Prod TO';
                tempOppIssue.Select_Status__c = 'M - Milestone';
                tempOppIssue.Improve_Prob__c = 0;
                tempOppIssue.Improve_Prob_P__c = 0;
                tempOppIssue.Action_to_Close_Issue__c = '<< 1st Product TO Date >>';
                tempOppIssue.Solution_Owner__c = oppObj.Primary_Opportunity_FAE__c;
                tempOppIssue.Action_Close_Date__c = oppObj.X1st_Product_TO_Date__c;
                tempOppIssue.Need_by_Date__c = oppObj.X1st_Product_TO_Date__c;
                
                defaultOppIssueList.add(tempOppIssue);
            }
        }
        
        if(defaultOppIssueList.size() > 0){
            upsert defaultOppIssueList;
        }
    }
}