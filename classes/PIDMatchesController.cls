/**********************************************************************************************************************************************
Class:         PIDMatchesController
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  20/09/2013
Reason:        Controls the Process Options page (PIDMatches) in the form of a table that shows the following PID matches:
                   1)Full Mask Set based on the PT selected
                   2)Proposed Mask Set based on the user selection of IPs, Devices and Masks
                   3)Exact Match if found
                   4)Greater than proposed Mask Set(s) if found
                   5)FEOL Mask Set(s) if found
                   6)BEOL Mask Set(s) if found      

               The table is broken into 6 zones:
                  [Row headers]    [Extra FEOL]          [FEOL]                      [BEOL]           [Extra BEOL]     [PID Links]
               ***********************************************************************************************************************
               |  Full mask set  ||  F1 F2 F3  |  DF DG EA HT JN LB M1  ||  M2 M3 M4 N3 NR NW OP PC  |  B3 B4 B5   ||                |
               |-----------------||------------|------------------------||---------------------------|-------------||----------------|
               |  Proposed       ||            |  DF DG EA HT JN LB M1  ||  M2 M3 M4 N3 NR NW OP PC  |             ||  PID-001 Link  |
               |  Exact          ||            |  DF DG EA HT JN LB M1  ||  M2 M3 M4 N3 NR NW OP PC  |             ||  PID-002 Link  |
               |  Greater        ||  F1 F2     |  DF DG EA HT JN LB M1  ||  M2 M3 M4 N3 NR NW OP PC  |     B4      ||  PID-003 Link  |
               |  Exact FEOL     ||            |  DF DG EA HT JN LB M1  ||  M2 M3                    |  B3 B4      ||  PID-004 Link  |
               |  Exact BEOL     ||         F3 |     DG             M1  ||  M2 M3 M4 N3 NR NW OP PC  |             ||  PID-005 Link  |
               ***********************************************************************************************************************

Change Log:    
               SNune        -    11142016:  Updated Changes for Case 00059192
                                            Created new method to split the Reticle layers.
                                            Made changes to log the exception in constructor through Page Action method.
               SNune        -    08172016:  Updated Changes for case 00054936 
               Change in Closest match functionality     -     JOYDEV     -     14/2/2014    
               Prosenjit    -    07092014:  Re-sequence Process option section as :
                                            Exact Match
                                            FEOL Match
                                            BEOL Match
                                            Greater Than Match
                                            Closest Match  
                                            
                Asolito    -     07102013:  Added mask count column
**********************************************************************************************************************************************/

public with sharing class PIDMatchesController {
    //Mask count
    transient public Map<String,Integer> maskCount {get; set;}
    //Current proposal
    transient public final Apttus_Proposal__Proposal__c CurrentProposal { get; set; }
    //Current proposal product code
    transient public String CurrentProposalProductCode { get; set; }
    
    /*Process Technology of CurrentProposal 
    (from any Line Item (eg. LI001) of the CurrentProposal [LI001.Apttus_Proposal__Product__c])*/
    transient public final Product2 CurrentProposalPT { get; set; }
    
    /*Map: <'Proposed', '3A B1 B2 BF BH BN BP CA DE DF DG EA HT JN LB'>
           <'Exact', '3A B1 B2 BF BH BN BP CA DE DF DG EA HT JN LB'>
           <'Greater', '3A B1 B2 BF BH BN BP CA DE DF DG EA HT JN LB M1 M2 M3 M4 N3 NR'>
           <'FEOL', '3A B1 B2 BF BH BN BP CA DE DF DG EA HT JN LB M1 M2'>
           <'BEOL', 'BP CA DE DF DG EA HT JN LB M1 M2 M3 3A B1 B2'>*/
    //transient public Map<String, String> MapMasterMaskSets { get; set; }
    transient public List<Map<String, String>> LstMapMasterMaskSets { get; set; }
    
    //PID link map
    transient public List<Map<String, Process__c>> LstMapMasterPID { get; set; }
    
    //[Extra FEOL] column headers <F1 F2 F3>
    transient public List<String> LstExtraFEOLMaskSet { get; set; }
    
    //[FEOL] column headers <DF DG EA HT JN LB M1>
    transient public List<String> LstFEOLMaskSet { get; set; }
    
    //[BEOL] column headers <M2 M3 M4 N3 NR NW OP PC>
    transient public List<String> LstBEOLMaskSet { get; set; }
    
    //[Extra BEOL] column headers <B3 B4 B5>
    transient public List<String> LstExtraBEOLMaskSet { get; set; }
    
    //[Row headers] row headers <'Proposed' 'Exact' 'Greater' 'FEOL' 'BEOL'>
    transient public List<String> LstMatchRows { get; set; }
    
    //Tokenized 'Proposed' mask set (from CurrentProposal.Mask_Layers__c)
    transient public List<String> LstProposalMaskSet { get; set; }
    
    //'Proposed' mask set lentgh (from CurrentProposal.Mask_Layers__c)
    transient public Integer ProposalMaskSetLength { get; set; }
    
    /*local PID (Process__c) database
    [JOYDEV] This needs bulk handeling later in the implementation phase*/
    transient private List<List<Process__c>> LstLstPIDs;
    
    //Match found Flag
    transient public Boolean MatchFound { get; set; }
    
    transient public boolean isMaskStepsTab {get;set;}
    transient public boolean isFeolTab {get;set;}
    transient public boolean isBeolTab {get;set;}
    transient public boolean isMaskSetTab{get;set;}
    @TestVisible private boolean hasError {get;set;}
    @TestVisible private Exception ex {get;set;}
    //Controler (extension)
    public PIDMatchesController(ApexPages.StandardController controller){        
        //This will not work because Mask_Set__C field is not in the layout
        //controller.addFields(new List<String>{'Id', 'Mask_Set__c'});
        try{
            /*
             SNune      -    08172016:  Updated Changes for case 00054936
             The tab parameter ensures that which columns have to be rendered in each tab(Full Masks, Feol, Beol).
            */
             String tab=ApexPages.currentPage().getParameters().get('tab');
             hasError = false;
             isMaskStepsTab = String.isBlank(tab) || tab == 'maskSteps' ? true : false;
             isFeolTab = tab == 'FEOL' ? true : false;
             isBeolTab = tab == 'BEOL' ? true : false;
             isMaskSetTab = tab == 'MaskSet' ? true : false;  
            //CurrentProposal = (Apttus_Proposal__Proposal__c)controller.getRecord();
            CurrentProposal = [Select Id,
                                      Mask_Set_Long__c /*Mask_Set__c, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463 */                                  
                                 From Apttus_Proposal__Proposal__c
                                Where Id =: ApexPages.currentPage().getParameters().get('Id')];
            
             if(!isMaskStepsTab){
                CurrentProposal.Mask_Set_Long__c = getReticleLayers(CurrentProposal.Mask_Set_Long__c);
                system.debug('CurrentProposal.Mask_Set_Long__c :::::::::::::::::::' +CurrentProposal.Mask_Set_Long__c);
             }                              
            
            List<Apttus_Proposal__Proposal_Line_Item__c> LstAnyLineItem =  [Select Id,
                                                                                   Apttus_Proposal__Product__c
                                                                              From Apttus_Proposal__Proposal_Line_Item__c
                                                                             Where Apttus_Proposal__Proposal__c = :CurrentProposal.Id
                                                                             Limit 1];
                                                                             
            tokenizeProposalMaskSet();
            
            If(LstAnyLineItem != null &&
               LstAnyLineItem.size() > 0){ 
                CurrentProposalPT  = [Select Id,
                                             Name,
                                             FEOL__c,
                                             BEOL__c,
                                             ProductCode,
                                             PT_Number__c,
                                             Compatible_PTs__c
                                        From Product2
                                       Where Id = :LstAnyLineItem[0].Apttus_Proposal__Product__c];
                if(!isMaskStepsTab){
                    CurrentProposalPT.FEOL__c = getReticleLayers(CurrentProposalPT.FEOL__c);
                    CurrentProposalPT.BEOL__c = getReticleLayers(CurrentProposalPT.BEOL__c);
                    system.debug('CurrentProposalPT.BEOL__c :::::::::::::::::::' +CurrentProposalPT.BEOL__c);
                    system.debug('CurrentProposalPT.FEOL__c :::::::::::::::::::' +CurrentProposalPT.FEOL__c);
                }   
                CurrentProposalProductCode = CurrentProposalPT.ProductCode;
                
                List<String> LstCurrentProposalProductCodeTokens = CurrentProposalPT.ProductCode.split('_');
                Integer iPCTokenSize = LstCurrentProposalProductCodeTokens.size();
                
                if(iPCTokenSize > 1){
                    CurrentProposalProductCode = '';
                    
                    for(Integer iCounter = 1 ; iCounter < iPCTokenSize ; iCounter++){
                        CurrentProposalProductCode += LstCurrentProposalProductCodeTokens[iCounter] + 
                                                      (iCounter != iPCTokenSize - 1 ? '_' : '');
                    }
                } 
                
                LstLstPIDs = new List<List<Process__c>>();
                
                String szMaskLikeTokens = '(';
                
                String szPIDTokens = '';
            
                for(String szMaskToken : LstProposalMaskSet){
                    szMaskLikeTokens += 'Mask_Layers__c Like \'%' + szMaskToken + '%\' Or ';
                }
                
                szMaskLikeTokens = szMaskLikeTokens.substring(0, szMaskLikeTokens.length() - 4) + ')';
                
                if(CurrentProposalPT.Compatible_PTs__c != Null &&
                   CurrentProposalPT.Compatible_PTs__c.trim() != ''){
                    szPIDTokens = '(';
                    
                    for(String szPIDToken : CurrentProposalPT.Compatible_PTs__c.replace(';',',').split(',')){
                        szPIDTokens += (szPIDToken != '' ? '\'' + szPIDToken + '\',' : '');
                    }
                    
                    szPIDTokens = szPIDTokens.substring(0,szPIDTokens.length()-1) + ')';
                }
                
                String szQuery = '';
                
                if(szPIDTokens != ''){
                    szQuery = 'Select Id, ' +
                                     'Name, ' +
                                     'Mask_Layers__c, ' +
                                     //'Mask_Layers_Length__c, ' +
                                     'No_Of_Mask_Layer__c,' +
                                     'PID_Number__c, ' +
                                     'Process_Technology__c ' +
                                'From Process__c ' +
                               'Where (Mask_Layers__c <> Null) AND ' +
                                     '(Process_Technology__c IN ' + szPIDTokens + ' OR ' +
                                      '(' + szMaskLikeTokens + ' AND ' +
                                       'Process_Technology__c = \'' + CurrentProposalPT.PT_Number__c + '\'))' +
                            //'Order By Mask_Layers_Length__c DESC';
                              'Order By No_Of_Mask_Layer__c DESC';
                } else {
                    szQuery = 'Select Id, ' +
                                     'Name, ' +
                                     'Mask_Layers__c, ' +
                                     //'Mask_Layers_Length__c, ' +
                                     'No_Of_Mask_Layer__c,' +
                                     'PID_Number__c, ' +
                                     'Process_Technology__c ' +
                                'From Process__c ' +
                               'Where Mask_Layers__c <> Null AND ' + 
                                      szMaskLikeTokens + ' AND ' +
                                     'Process_Technology__c = \'' + CurrentProposalPT.PT_Number__c + '\'' +
                            //'Order By Mask_Layers_Length__c DESC';
                              'Order By No_Of_Mask_Layer__c DESC';
                }
                
                /*
                String szQuery = 'Select Id, Name, Mask_Layers__c, PID_Number__c From Process__c ' +
                                 'Where Mask_Layers__c <> Null And ' + szMaskLikeTokens + 
                                 ' AND Process_Technology__c = \'' + CurrentProposalPT.PT_Number__c + '\'';
                */
                                 
                System.Debug('[DEBUG :: JOYDEV] >> szQuery >> ' + szQuery);
                
                for(List<Process__c> lstProcess : Database.Query(szQuery)){
                    System.Debug('[DEBUG :: JOYDEV] >> lstProcess >> ' + lstProcess);
                    LstLstPIDs.add(lstProcess);
                }
                
                LstMapMasterPID = new List<Map<String, Process__c>>();
                LstMapMasterPID.add(new Map<String, Process__c>());
                
                prepareMaskHeaderCategorySet();
                        
                prepareMasterMaskSets();
                
                System.Debug('[DEBUG :: JOYDEV] >> FINAL LstMapMasterPID: ' + LstMapMasterPID);
                System.Debug('[DEBUG :: JOYDEV] >> FINAL LstMapMasterMaskSets[0]: ' + LstMapMasterMaskSets[0]);
            }
        }catch(Exception e){
            hasError = true;
            ex = e;
            system.debug('Exception::::::::::::::::::::::::::' + e.getStacktraceString() +e.getMessage());
        }
    }
    
    public void logException(){
        if(hasError){
             GlobalUtility.logMessage('Error', 'PIDMatchesController', 'Constructor', null, null, ex.getMessage(), null,null,ex, null);
        }
    }
    //Populates the Header Category Sets
    public void prepareMaskHeaderCategorySet(){
        //String szCurrentProposalMaskSet = ' ' + CurrentProposal.Mask_Set__c.trim() + ' ';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        String szCurrentProposalMaskSet = ' ' + CurrentProposal.Mask_Set_Long__c.trim() + ' ';
        System.Debug('[DEBUG :: JOYDEV] >> szCurrentProposalMaskSet: ' + szCurrentProposalMaskSet);
                
        LstExtraFEOLMaskSet = new List<String>();
        LstFEOLMaskSet = new List<String>();
        LstBEOLMaskSet = new List<String>();
        LstExtraBEOLMaskSet = new List<String>();
        
        if(CurrentProposalPT.FEOL__c != Null){
            for(String szMask : CurrentProposalPT.FEOL__c.split(' ')){
                szMask = ' ' + szMask.trim() + ' ';
                System.Debug('[DEBUG :: JOYDEV] >> FEOL >> szMask: [' + szMask + ']');
                if(!szCurrentProposalMaskSet.contains(szMask)){
                    System.Debug('[DEBUG :: JOYDEV] >> FEOL >> !szCurrentProposalMaskSet.contains(szMask): TRUE');
                    LstExtraFEOLMaskSet.add(szMask.trim());
                } else {
                    System.Debug('[DEBUG :: JOYDEV] >> FEOL >> !szCurrentProposalMaskSet.contains(szMask): FALSE');
                    LstFEOLMaskSet.add(szMask.trim());
                }
            }
        }
        
        if(CurrentProposalPT.BEOL__c != Null){
            for(String szMask : CurrentProposalPT.BEOL__c.split(' ')){
                szMask = ' ' + szMask.trim() + ' ';
                System.Debug('[DEBUG :: JOYDEV] BEOL >> szMask: [' + szMask + ']');
                if(!szCurrentProposalMaskSet.contains(szMask)){
                    System.Debug('[DEBUG :: JOYDEV] >> BEOL >> !szCurrentProposalMaskSet.contains(szMask): TRUE');
                    LstExtraBEOLMaskSet.add(szMask.trim());
                } else {
                    System.Debug('[DEBUG :: JOYDEV] >> BEOL >> !szCurrentProposalMaskSet.contains(szMask): FALSE');
                    LstBEOLMaskSet.add(szMask.trim());
                }
            }
        }
    }
    
    //Splits the Mask Set into List of Masks
    public void tokenizeProposalMaskSet(){
        LstProposalMaskSet = new List<String>();
        ProposalMaskSetLength = 0;
        
        /*if(CurrentProposal.Mask_Set__c != Null &&
           CurrentProposal.Mask_Set__c != ''){
            //ProposalMaskSetLength = CurrentProposal.Mask_Set__c.length();
            ProposalMaskSetLength = CurrentProposal.Mask_Set__c.Split(' ').Size();
            for(String szMask : CurrentProposal.Mask_Set__c.split(' ')){
                LstProposalMaskSet.add(szMask.trim());
            }
        }*/
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        if(CurrentProposal.Mask_Set_Long__c != Null &&
           CurrentProposal.Mask_Set_Long__c != ''){            
            ProposalMaskSetLength = CurrentProposal.Mask_Set_Long__c.Split(' ').Size();
            for(String szMask : CurrentProposal.Mask_Set_Long__c.split(' ')){
                LstProposalMaskSet.add(szMask.trim());
            }
        }
    }
    
    //Gets the exact match
    public List<String> fetchExactMaskSets(){        
        List<String> LstExactMaskSets = new List<String>();
        Integer iIndex = 0;
        
        for(List<Process__c> LstPIDs : LstLstPIDs){
            for(Process__c pID : LstPIDs){
                String szExactMaskSet = pID.Mask_Layers__c;
                Boolean blExactMatchFound = true;
                
                System.Debug('[DEBUG :: JOYDEV] >> szExactMaskSet : ' + szExactMaskSet);
                
                System.Debug('[DEBUG :: JOYDEV] >> LstProposalMaskSet.size() : ' + LstProposalMaskSet.size());
                System.Debug('[DEBUG :: JOYDEV] >> szExactMaskSet.split(*).size() : ' + szExactMaskSet.split(',').size());
                
                if(LstProposalMaskSet.size() == szExactMaskSet.split(',').size()){
                    for(String szMask : LstProposalMaskSet){
                        System.Debug('[DEBUG :: JOYDEV] >> szExactMaskSet >> szMask : ' + szExactMaskSet + ' >> ' + szMask);
                        if(!szExactMaskSet.contains(szMask)){
                            System.Debug('[DEBUG :: JOYDEV] >> !szExactMaskSet.contains(szMask) : ' + !szExactMaskSet.contains(szMask));
                            blExactMatchFound = false;
                        }
                    }
                    
                    if(blExactMatchFound){
                        System.Debug('[DEBUG :: JOYDEV] >> blExactMatchFound  : ' + blExactMatchFound);
                        
                        //Populate the MapMasterPID map for the link in page
                        if(LstMapMasterPID[LstMapMasterPID.Size() - 1].Size() < 1000){
                            System.Debug('[DEBUG :: JOYDEV] >> pID  : ' + pID);
                            System.Debug('[DEBUG :: JOYDEV] >> LstMapMasterPID[LstMapMasterPID.Size() - 1]  : ' + 
                                                                                LstMapMasterPID[LstMapMasterPID.Size() - 1]);
                            
                            //szExactMaskSet = szExactMaskSet.replace(',', ' ');
                            LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szExactMaskSet + '(E_X_' + ++iIndex + ')', pID);
                            
                            System.Debug('[DEBUG :: JOYDEV] >> latest LstMapMasterPID entry : ' + 
                                                        LstMapMasterPID[LstMapMasterPID.Size() - 1].get(szExactMaskSet));
                        } /*else {
                            LstMapMasterPID.add(new Map<String, Process__c>{szExactMaskSet=>pID});
                        }*/
                        
                        //return szExactMaskSet;
                        LstExactMaskSets.add(szExactMaskSet);
                    }
                }
            } 
        }
        
        //return '';
        return LstExactMaskSets;
    }
    
    public List<String> fetchCompatibleMaskSets(){
        List<String> LstCompatibleMaskSets = new List<String>();
        
        if(CurrentProposalPT.Compatible_PTs__c != Null && 
           CurrentProposalPT.Compatible_PTs__c.trim() != ''){
            Integer iIndex = 0;
            
            for(List<Process__c> LstPIDs : LstLstPIDs){
                for(Process__c pID : LstPIDs){
                    if(CurrentProposalPT.Compatible_PTs__c.contains(pID.Process_Technology__c)){
                        String szCompatibleMaskSet = pID.Mask_Layers__c;
                    
                        if(LstMapMasterPID[LstMapMasterPID.Size() - 1].Size() < 1000){
                            LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szCompatibleMaskSet + '(C_X_' + ++iIndex + ')', pID);
                            
                            System.Debug('[DEBUG :: JOYDEV] >> latest LstMapMasterPID entry : ' + 
                                         LstMapMasterPID[LstMapMasterPID.Size() - 1].get(szCompatibleMaskSet + '(' + iIndex + ')'));
                        }
                        
                        LstCompatibleMaskSets.add(szCompatibleMaskSet);
                    }
                }
            }
        }
        
        return LstCompatibleMaskSets;
    }
    
    //Gets the Greater than match(es)
    public List<String> fetchGreaterThanMatchMaskSets(){
        List<String> LstGreaterMaskSet = new List<String>();
        Integer iIndex = 0;
        
        for(List<Process__c> LstPIDs : LstLstPIDs){
            for(Process__c pID : LstPIDs){
                String szGreaterMaskSet = pID.Mask_Layers__c;
                Boolean blGreaterMatchFound = true;
                
                System.Debug('[DEBUG :: JOYDEV] >> szGreaterMaskSet : ' + szGreaterMaskSet);
                
                if(LstProposalMaskSet.size() < szGreaterMaskSet.split(',').size()){
                    for(String szMask : LstProposalMaskSet){
                        if(!szGreaterMaskSet.contains(szMask)){
                            blGreaterMatchFound = false;
                            break;
                        }
                    }
                    
                    if(blGreaterMatchFound){
                        //Populate the MapMasterPID map for the link in page
                        if(LstMapMasterPID[LstMapMasterPID.Size() - 1].Size() < 1000){
                            //LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szGreaterMaskSet, pID);
                            LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szGreaterMaskSet + '(G_X_' + ++iIndex + ')', pID);
                        } /*else {
                            LstMapMasterPID.add(new Map<String, Process__c>{szGreaterMaskSet=>pID});
                        }*/
                        
                        LstGreaterMaskSet.add(szGreaterMaskSet);
                    }
                }
            } 
        }
        
        return LstGreaterMaskSet;
    }
    
    //Gets the FEOL match(es)
    public List<String> fetchFEOLMatchMaskSets(){
        List<String> LstFMaskSet = new List<String>();
        Integer iIndex = 0;
        
        for(List<Process__c> LstPIDs : LstLstPIDs){
            for(Process__c pID : LstPIDs){
                String szFEOLMaskSet = pID.Mask_Layers__c;
                Boolean blFEOLMatchFound = true;
                
                System.Debug('[DEBUG :: JOYDEV] >> szFEOLMaskSet : ' + szFEOLMaskSet);
                
                for(String szMask : LstFEOLMaskSet){
                    if(!szFEOLMaskSet.contains(szMask)){
                        blFEOLMatchFound = false;
                    }
                }
                
                /* BEOL - Don't Care
                for(String szMask : LstBEOLMaskSet){
                    if(szFEOLMaskSet.contains(szMask)){
                        blFEOLMatchFound = false;
                        break;
                    }
                }
                */
                
                /* Extra BEOL - Don't Care
                for(String szMask : LstExtraBEOLMaskSet){
                    if(szFEOLMaskSet.contains(szMask)){
                        blFEOLMatchFound = false;
                        break;
                    }
                }
                */
                
                for(String szMask : LstExtraFEOLMaskSet){
                    if(szFEOLMaskSet.contains(szMask)){
                        blFEOLMatchFound = false;
                        break;
                    }
                }
                
                if(blFEOLMatchFound){
                    //Populate the MapMasterPID map for the link in page
                    if(LstMapMasterPID[LstMapMasterPID.Size() - 1].Size() < 1000){
                        //LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szFEOLMaskSet, pID);
                        LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szFEOLMaskSet + '(F_X_' + ++iIndex + ')', pID);
                    } /*else {
                        LstMapMasterPID.add(new Map<String, Process__c>{szFEOLMaskSet=>pID});
                    }*/
                    
                    LstFMaskSet.add(szFEOLMaskSet);
                }
            } 
        }
        
        return LstFMaskSet;
    }
    
    //Gets the BEOL match(es)
    public List<String> fetchBEOLMatchMaskSets(){
        List<String> LstBMaskSet = new List<String>();
        Integer iIndex = 0;
        
        for(List<Process__c> LstPIDs : LstLstPIDs){
            for(Process__c pID : LstPIDs){
                String szBEOLMaskSet = pID.Mask_Layers__c;
                Boolean blBEOLMatchFound = true;
                
                System.Debug('[DEBUG :: JOYDEV] >> szBEOLMaskSet : ' + szBEOLMaskSet);
                
                for(String szMask : LstBEOLMaskSet){
                    if(!szBEOLMaskSet.contains(szMask)){
                        blBEOLMatchFound = false;
                        break;
                    }
                }
                
                /* FEOL - Don't Care
                for(String szMask : LstFEOLMaskSet){
                    if(szBEOLMaskSet.contains(szMask)){
                        blBEOLMatchFound = false;
                        break;
                    }
                }
                */
                
                /* Extra FEOL - Don't Care
                for(String szMask : LstExtraFEOLMaskSet){
                    if(szBEOLMaskSet.contains(szMask)){
                        blBEOLMatchFound = false;
                        break;
                    }
                }
                */
                
                for(String szMask : LstExtraBEOLMaskSet){
                    if(szBEOLMaskSet.contains(szMask)){
                        blBEOLMatchFound = false;
                        break;
                    }
                }
                
                if(blBEOLMatchFound){
                    //Populate the MapMasterPID map for the link in page
                    //MapMasterPID.put(szBEOLMaskSet, pID);
                    if(LstMapMasterPID[LstMapMasterPID.Size() - 1].Size() < 1000){
                        //LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szBEOLMaskSet, pID);
                        LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szBEOLMaskSet + '(B_X_' + ++iIndex + ')', pID);
                    } /*else {
                        LstMapMasterPID.add(new Map<String, Process__c>{szBEOLMaskSet=>pID});    
                    }*/
                    
                    LstBMaskSet.add(szBEOLMaskSet);
                }
            } 
        }
        
        return LstBMaskSet;
    }
    
    //Gets all the mismatch(es) ---- Needs to be optimized
    public List<String> fetchClosestMatchMaskSets(){
        List<String> LstCLMaskSet = new List<String>();
        Integer iIndex = 0;
        
        for(List<Process__c> LstPIDs : LstLstPIDs){
            for(Process__c pID : LstPIDs){
                String szClosestMaskSet = pID.Mask_Layers__c;
                
                Boolean isMismatch = true;
                    
                for(Map<String, Process__c> mapMasterPID : LstMapMasterPID){
                    for(Process__c proc : mapMasterPID.values()){
                        if(proc.Mask_Layers__c == pID.Mask_Layers__c){
                            isMismatch = false;
                            break;
                        }
                    }
                }
                
                if(isMismatch){
                    //Populate the MapMasterPID map for the link in page
                    //MapMasterPID.put(szBEOLMaskSet, pID);
                    if(LstMapMasterPID[LstMapMasterPID.Size() - 1].Size() < 1000){
                        //LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szClosestMaskSet, pID);
                        LstMapMasterPID[LstMapMasterPID.Size() - 1].put(szClosestMaskSet + '(CL_X_' + ++iIndex + ')', pID);
                    } /*else {
                        LstMapMasterPID.add(new Map<String, Process__c>{szClosestMaskSet=>pID});    
                    }*/
                    
                    LstCLMaskSet.add(szClosestMaskSet);
                }
            } 
        }
        
        return LstCLMaskSet;
    }
    
    //Populates the final results of matching masksets of all the types
    public void prepareMasterMaskSets(){
        LstMatchRows = new List<String>();
        
        LstMapMasterMaskSets = new List<Map<String, String>>();
        
        //LstMapMasterMaskSets.add(new Map<String, String>{'Proposed'=>CurrentProposal.Mask_Set__c});
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        LstMapMasterMaskSets.add(new Map<String, String>{'Proposed'=>CurrentProposal.Mask_Set_Long__c});
        LstMatchRows.add('Proposed');
        /*---------------------------------------Start: EXACT Match section--------------------------------- */
        Integer iIndex = 0;
        //Set<String> SetUniqueMastSet = new Set<String>(LstMapMasterMaskSets[0].values());
        //List<Set<String>> SetUniqueMastSets = new List<Set<String>>{SetUniqueMastSet};
        
        List<Set<String>> SetUniqueMastSets = new List<Set<String>>();
        
        for(Map<String, String> masterMaskSet : LstMapMasterMaskSets){
            SetUniqueMastSets.add(new Set<String>(masterMaskSet.values()));
        }
        
        //String szExactMaskSet = fetchExactMaskSets();
        for(String szMaskSet : fetchExactMaskSets()){
            String szMaskSet2 = szMaskSet.replace(',',' ').trim();
            boolean isUnique = true;
            
            //Kanishk: commented unique check because this is extact match and should be in Process detail list
            /*for(Set<String> uniqueMastSet : SetUniqueMastSets){
                for(String szMask : uniqueMastSet){
                    if(szMask.contains(szMaskSet) || 
                       szMask.contains(szMaskSet2)){
                        System.Debug('[DEBUG :: JOYDEV] >> isUnique @ EXACT : ' + isUnique);
                        isUnique = false;
                        break;
                    }
                }*/
                
                /*
                if(uniqueMastSet.contains(szMaskSet) || 
                   uniqueMastSet.contains(szMaskSet2)){
                    isUnique = false;
                    break;
                }
                */
            //}
            
            if(isUnique){
                String szIndex = 'Exact (' + ++iIndex + ')';
                    
                if(LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].Size() < 1000){
                    LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].put(szIndex, szMaskSet + '(E_X_' + iIndex + ')');
                } else {
                    LstMapMasterMaskSets.add(new Map<String, String>{szIndex=>szMaskSet + '(E_X_' + iIndex + ')'});
                }
                
                System.Debug('[DEBUG :: JOYDEV] >> LstMapMasterMaskSets[0].get(Exact(n)) : ' + LstMapMasterMaskSets[0].get(szIndex));
                
                //This is quick fix (limitation of 1000 results only)
                if(LstMatchRows.size() < 1000){
                    LstMatchRows.add(szIndex);
                }
                
                MatchFound = True;
            } else {
                ++iIndex;
            }
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> LstMapMasterPID **** : ' + LstMapMasterPID);
        
        /*
        if(szExactMaskSet != ''){
            LstMapMasterMaskSets[0].put('Exact', szExactMaskSet);
            
            System.Debug('[DEBUG :: JOYDEV] >> LstMapMasterMaskSets[0].get(Exact) : ' + LstMapMasterMaskSets[0].get('Exact'));
            
            LstMatchRows.add('Exact');
            MatchFound = True;
        }
        */
        /*---------------------------------------End: EXACT Match section--------------------------------- */
        
        /*---------------------------------------Start: COMPATIBLE section--------------------------------- */
        iIndex = 0;
        SetUniqueMastSets = new List<Set<String>>();
        
        for(Map<String, String> masterMaskSet : LstMapMasterMaskSets){
            SetUniqueMastSets.add(new Set<String>(masterMaskSet.values()));
        }
        
        for(String szMaskSet : fetchCompatibleMaskSets()){
            String szMaskSet2 = szMaskSet.replace(',',' ').trim();
            boolean isUnique = true;
            
            for(Set<String> uniqueMastSet : SetUniqueMastSets){
                for(String szMask : uniqueMastSet){
                    if(szMask.contains(szMaskSet) || 
                       szMask.contains(szMaskSet2)){
                        System.Debug('[DEBUG :: JOYDEV] >> isUnique @ COMPATIBLE : ' + isUnique);
                        isUnique = false;
                        break;
                    }
                }
            }
            
            if(isUnique){
                String szIndex = 'Compatible (' + ++iIndex + ')';
                    
                if(LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].Size() < 1000){
                    LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].put(szIndex, szMaskSet + '(C_X_' + iIndex + ')');
                } else {
                    LstMapMasterMaskSets.add(new Map<String, String>{szIndex=>szMaskSet + '(C_X_' + iIndex + ')'});
                }
                
                System.Debug('[DEBUG :: JOYDEV] >> LstMapMasterMaskSets[0].get(Compatible) : ' + LstMapMasterMaskSets[0].get(szIndex));
                
                //This is quick fix (limitation of 1000 results only)
                if(LstMatchRows.size() < 1000){
                    LstMatchRows.add(szIndex);
                }
            } else {
                ++iIndex;
            }
        }
        /*---------------------------------------End: COMPATIBLE section--------------------------------- */
        
        /*---------------------------------------Start:Exact FEOL section--------------------------------- */
        iIndex = 0;
        SetUniqueMastSets = new List<Set<String>>();
        
        for(Map<String, String> masterMaskSet : LstMapMasterMaskSets){
            SetUniqueMastSets.add(new Set<String>(masterMaskSet.values()));
        }
        
        System.Debug('[DEBUG :: JOYDEV] >> SetUniqueMastSets @ FEOL Unique Check: ' + SetUniqueMastSets);
        
        for(String szMaskSet : fetchFEOLMatchMaskSets()){
            System.Debug('[DEBUG :: JOYDEV] >> FEOLMatchMaskSet @ FEOL : ' + szMaskSet);
            
            String szMaskSet2 = szMaskSet.replace(',',' ').trim();
            boolean isUnique = true;
            
            System.Debug('[DEBUG :: JOYDEV] >> FEOLMatchMaskSet @ FEOL2 : ' + szMaskSet2);
            
            for(Set<String> uniqueMastSet : SetUniqueMastSets){
                System.Debug('[DEBUG :: JOYDEV] >> MaskSet @ SetUniqueMastSets : ' + uniqueMastSet);
            
                for(String szMask : uniqueMastSet){
                    if(szMask.contains(szMaskSet) || 
                       szMask.contains(szMaskSet2)){
                        System.Debug('[DEBUG :: JOYDEV] >> isUnique @ FEOL : ' + isUnique);
                        isUnique = false;
                        break;
                    }
                }
                
                /*
                if(uniqueMastSet.contains(szMaskSet) || 
                   uniqueMastSet.contains(szMaskSet2)){
                    System.Debug('[DEBUG :: JOYDEV] >> isUnique @ FEOL : ' + isUnique);
                    isUnique = false;
                    break;
                }
                */
            }
            
            if(isUnique){
                String szIndex = 'Exact FEOL (' + ++iIndex + ')';
                    
                System.Debug('[DEBUG :: JOYDEV] >> szIndex @ FEOL : ' + szIndex);
                
                if(LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].Size() < 1000){
                    LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].put(szIndex, szMaskSet + '(F_X_' + iIndex + ')');
                } else {
                    LstMapMasterMaskSets.add(new Map<String, String>{szIndex=>szMaskSet + '(F_X_' + iIndex + ')'});
                }
                
                //This is quick fix (limitation of 1000 results only)
                if(LstMatchRows.size() < 1000){
                    LstMatchRows.add(szIndex);
                }
            } else {
                ++iIndex;
            }
        }
        /*---------------------------------------End:Exact FEOL section--------------------------------- */
        
        /*---------------------------------------Start:Exact BEOL section--------------------------------- */
        iIndex = 0;
        SetUniqueMastSets = new List<Set<String>>();
        
        for(Map<String, String> masterMaskSet : LstMapMasterMaskSets){
            SetUniqueMastSets.add(new Set<String>(masterMaskSet.values()));
        }
        
        for(String szMaskSet : fetchBEOLMatchMaskSets()){
            String szMaskSet2 = szMaskSet.replace(',',' ').trim();
            boolean isUnique = true;
            
            for(Set<String> uniqueMastSet : SetUniqueMastSets){
                for(String szMask : uniqueMastSet){
                    if(szMask.contains(szMaskSet) || 
                       szMask.contains(szMaskSet2)){
                        System.Debug('[DEBUG :: JOYDEV] >> isUnique @ BEOL : ' + isUnique);
                        isUnique = false;
                        break;
                    }
                }
                
                /*
                if(uniqueMastSet.contains(szMaskSet) || 
                   uniqueMastSet.contains(szMaskSet2)){
                    isUnique = false;
                    break;
                }
                */
            }
            
            if(isUnique){
                String szIndex = 'Exact BEOL (' + ++iIndex + ')';
                    
                if(LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].Size() < 1000){
                    LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].put(szIndex, szMaskSet + '(B_X_' + iIndex + ')');
                } else {
                    LstMapMasterMaskSets.add(new Map<String, String>{szIndex=>szMaskSet + '(B_X_' + iIndex + ')'});
                }
                
                //This is quick fix (limitation of 1000 results only)
                if(LstMatchRows.size() < 1000){
                    LstMatchRows.add(szIndex);
                }
            } else {
                ++iIndex;
            }
        }
        
        /*---------------------------------------End:Exact BEOL section--------------------------------- */
        
        /*---------------------------------------Start: GREATER section--------------------------------- */
        iIndex = 0;
        SetUniqueMastSets = new List<Set<String>>();
        
        for(Map<String, String> masterMaskSet : LstMapMasterMaskSets){
            SetUniqueMastSets.add(new Set<String>(masterMaskSet.values()));
        }
        
        for(String szMaskSet : fetchGreaterThanMatchMaskSets()){
            String szMaskSet2 = szMaskSet.replace(',',' ').trim();
            boolean isUnique = true;
            
            for(Set<String> uniqueMastSet : SetUniqueMastSets){
                for(String szMask : uniqueMastSet){
                    if(szMask.contains(szMaskSet) || 
                       szMask.contains(szMaskSet2)){
                        System.Debug('[DEBUG :: JOYDEV] >> isUnique @ GREATER : ' + isUnique);
                        isUnique = false;
                        break;
                    }
                }
                
                /*
                if(uniqueMastSet.contains(szMaskSet) || 
                   uniqueMastSet.contains(szMaskSet2)){
                    isUnique = false;
                    break;
                }
                */
            }
            
            if(isUnique){
                String szIndex = 'Greater (' + ++iIndex + ')';
                    
                if(LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].Size() < 1000){
                    LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].put(szIndex, szMaskSet + '(G_X_' + iIndex + ')');
                } else {
                    LstMapMasterMaskSets.add(new Map<String, String>{szIndex=>szMaskSet + '(G_X_' + iIndex + ')'});
                }
                
                System.Debug('[DEBUG :: JOYDEV] >> LstMapMasterMaskSets[0].get(Greater) : ' + LstMapMasterMaskSets[0].get(szIndex));
                
                //This is quick fix (limitation of 1000 results only)
                if(LstMatchRows.size() < 1000){
                    LstMatchRows.add(szIndex);
                }
            } else {
                ++iIndex;
            }
        }
        /*---------------------------------------End : GREATER section--------------------------------- */
        
        /*---------------------------------------Start:ClosestMatchMaskSet section--------------------------------- */
        //if(LstMatchRows.size() == 2){            
            
        iIndex = 0;
        SetUniqueMastSets = new List<Set<String>>();
        
        for(Map<String, String> masterMaskSet : LstMapMasterMaskSets){
            SetUniqueMastSets.add(new Set<String>(masterMaskSet.values()));
        }
        
        for(String szMaskSet : fetchClosestMatchMaskSets()){
            System.Debug('[DEBUG :: JOYDEV] >> ClosestMatchMaskSet @ CLOSEST : ' + szMaskSet);
            
            String szMaskSet2 = szMaskSet.replace(',',' ').trim();
            boolean isUnique = true;
            
            for(Set<String> uniqueMastSet : SetUniqueMastSets){
                for(String szMask : uniqueMastSet){
                    System.Debug('[DEBUG :: JOYDEV] >> MaskSet @ SetUniqueMastSet - szMask : ' + szMask);
                    System.Debug('[DEBUG :: JOYDEV] >> MaskSet @ SetUniqueMastSet - szMaskSet : ' + szMaskSet);
                    System.Debug('[DEBUG :: JOYDEV] >> MaskSet @ SetUniqueMastSet - szMaskSet2 : ' + szMaskSet2);
                    
                    if(szMask.contains(szMaskSet) || 
                       szMask.contains(szMaskSet2)){
                        System.Debug('[DEBUG :: JOYDEV] >> isUnique @ CLOSEST : ' + isUnique);
                        isUnique = false;
                        break;
                    }
                }
            }
            
            if(isUnique){
                System.Debug('[DEBUG :: JOYDEV] >> ClosestMatchMaskSet2 @ ClosestMatchMaskSet2 : ' + szMaskSet2);
            
                String szIndex = 'Closest (' + ++iIndex + ')';
                        
                System.Debug('[DEBUG :: JOYDEV] >> szIndex @ CLOSEST : ' + szIndex);
                
                if(LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].Size() < 1000){
                    LstMapMasterMaskSets[LstMapMasterMaskSets.size() - 1].put(szIndex, szMaskSet + '(CL_X_' + iIndex + ')');
                } else {
                    LstMapMasterMaskSets.add(new Map<String, String>{szIndex=>szMaskSet + '(CL_X_' + iIndex + ')'});
                }
                
                //This is quick fix (limitation of 1000 results only)
                if(LstMatchRows.size() < 1000){
                    LstMatchRows.add(szIndex);
                }
            } else {
                ++iIndex;
            }
        }
        
        //added asolito 07102014
        //get mask count for the processes
        this.maskCount = new Map<String,Integer>();        
        String maskHeaders='';
        String feolmaskHeaders = '';
        String beolmaskHeaders = '';
        for(String s: this.LstExtraFEOLMaskSet){
            maskHeaders += s +',';
            feolmaskHeaders += s +',';
        }
        
        for(String s: this.LstFEOLMaskSet){
            maskHeaders += s +',';
            feolmaskHeaders += s +',';
        }
        
        for(String s: this.LstBEOLMaskSet){
            maskHeaders += s +',';
            beolmaskHeaders += s +',';
        }
        
        for(String s: this.LstExtraBEOLMaskSet){
            maskHeaders += s +',';
            beolmaskHeaders += s +',';
        }               
        
        for(Map<String,String> rec : this.LstMapMasterMaskSets){            
            for(String r: rec.keyset()){
                List<String> maskList = new List<String>();
                String masks = rec.get(r);
                
                if(UtilsString.isNotBlank(masks)){                        
                    if(r == 'Proposed'){
                        maskList = masks.split('\\ ');
                    } else {
                        //remove the suffixes ID for the mask set list
                        if(masks.contains('E_X_')){
                            masks = masks.substring(0,masks.indexOf('E_X_')-1);
                        } else if(masks.contains('C_X_')){
                            masks = masks.substring(0,masks.indexOf('C_X_')-1);
                        } else if(masks.contains('F_X_')){
                            masks = masks.substring(0,masks.indexOf('F_X_')-1);
                        } else if(masks.contains('B_X_')){
                            masks = masks.substring(0,masks.indexOf('B_X_')-1);
                        } else if(masks.contains('G_X_')){
                            masks = masks.substring(0,masks.indexOf('G_X_')-1);
                        } else if(masks.contains('CL_X_')){
                            masks = masks.substring(0,masks.indexOf('CL_X_')-1);
                        }
                    
                        maskList = masks.split('\\,');                       
                    }
                    
                    Integer counter = 0;
                    Integer feolCounter = 0;
                    Integer beolCounter = 0;
                    
                    for(String m: maskList){                     
                        if(maskHeaders.contains(m)){
                            counter++;
                        }
                        if(feolmaskHeaders.contains(m)){
                            feolCounter++;
                        }
                        if(beolmaskHeaders.contains(m)){
                            beolCounter++;
                        }
                    }
                    if(r == 'Proposed'){
                        if(isFeolTab){
                            this.maskCount.put(r,LstFEOLMaskSet.size());  
                        }else if(isBeolTab){
                            this.maskCount.put(r,LstBEOLMaskSet.size()); 
                        }else{
                            this.maskCount.put(r,counter);
                        }
                    }else{
                        if(isFeolTab){
                            this.maskCount.put(r, feolCounter);  
                        }else if(isBeolTab){
                            this.maskCount.put(r,beolcounter); 
                        }else{
                            this.maskCount.put(r,counter);
                        }               
                    }
                }
            }
        }
        /*---------------------------------------End:ClosestMatchMaskSet section--------------------------------- */
        //}
    }
    /**
     * @Author : Surendranadh Nune
     * @Reference : Case Num - 00059192
     * @description : This method is used to remove the duplicate occurence of Mask layers.
     *                It is used for rendering the data in "Reticle" tab.
     *                Eg: If the layerString is of the form 'BS AW(2) AW(1) SA(1) SA(2)', the
     *                resultant string after parsing would be 'BS AW SA'
     */
    public static String getReticleLayers(String layerString){ 
        Set<String> reticleSet = new Set<String>();
        String reticleStr = '';
        for(String mask : layerString.split(' ')){
            reticleSet.add(mask.split('\\(')[0].trim());
        }
        reticleStr = String.join(new List<String>(reticleSet), ' ');
        return reticleStr;
   }
}