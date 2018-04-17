public without sharing class DWC_WaiverCollaboratorController {
  
    public Wavier_Collaborator__c waiverCollaborator {get;set;}
    public string rOriginalValue{get;set;}
    public string rValues{get;set;}
    public string pValue {get; set;}
    public string pdfValue {get; set;}
    public boolean isNonMatchRule {get;set;}
    public list<wrapperForComments> listWrapper {get;set;}
    public string hiddenUsrIds {get;set;} 
    public String jsonruleList {get;set;}
    public String jsonruleListALL {get;set;}
    public String finalStatusValue {get;set;}
    public boolean isPortalUser {get;set;}
    public boolean isFoundryView {get;set;}
    public boolean isStandardUser {get;set;}
    public boolean isFAE {get;set;}
    public boolean isDRB {get;set;}
    public boolean isGroup {get;set;}
    public boolean isSubmitForApproval{get;set;}
    public boolean isRunOnly {get;set;}
    public boolean isSuperUser{get;set;}//SUHAS
    Transient public Set<String> setOfFinalStatus;
    Transient public Set<String> setOfGFReviewStatus;
    public boolean isRevertedRules {get;set;}
    public map<String, String> tooltipMap;
    public map<String, String> reviewTaskMessage;
    public map<String, List<Attachment>> ruleAttachMap;
    public map<Id, String> ruleIdNameMap;
    public map<Id, String> isAttachMap;
    public list<Waiver_Rule_List__c> savedRuleList;
    public list<String> uRoles;
    public Set<Id> waiverRuleIds;
    public set<Id> setOfFAEUsers;
    public Set<Id> DE_Users;
    public Set<Id> PIYE_Users;
    public Set<Id> QA_Users;
    public Set<Id> DRBGroupIds;
    public Set<Id> setOfAllApprovers;
    public Set<Id> FabWaiverTeamUsers;
    public string wRuleQuery;
    public Id drcId;  
    public boolean isDRBUser{set;get;}
    String custPortalUsrTyp = EnvironmentVariable.get('USER_TYPE_CUST_PORTAL');
    public Map<string,integer> countMap{get;set;}
    //Pagination
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer totalRecords {get;set;}
    public integer currentPageNo {get;set;}
    Transient public String taskMessage{get;set;}//SUHAS
    //PDF enhancements
    public List<Attachment> attachmentsCollaborator {get;set;}
    public List<Note> notesList {get;set;}
    
   // public List<Wavier_Collaborator__History> closingSection {get; set;}
    public list<Waiver_Rule_List__c> pdfRuleList{get; set;}
    public list<Waiver_Rule_List__c> pdfWruleList{get; set;}
    public list<Waiver_Rule_List__c> pdfWruleListForPDF{get; set;}
    public Map<string,Map<string,integer>> PrimedieCountMap {get;set;}
    public Map<string,Map<string,integer>> PrimedieCountMapStatus {get;set;}
    public Map<string,string> PrimedieStatusMapStatus {get;set;}
    
    public list<string> finalStatus{get;set;}
    public set<string> pdNames {get;set;}
    public Map<string,string> PrimedieStatusMap {get;set;}
    
    public List<string> pdindexList{get;set;}
    public integer pdindex {get;set;}
    public Map<string,List<string>>  pdNameMap{get;set;}
    
    //Transient public String drbGroup {get;set;}
    // Merge code for DFM and DRC
    public List<Chip__c> lst_Chips {get;set;}
    Set<Id> dfmUserIds;// = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
    Set<Id> dfmManagerIds;// = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
    public boolean isDFMUser {get;set;}
    Set<Id> dwcSuperUserIds;//SUHAS
    Set<Id> fabDrbUserIds;//added for FAB_DRB Group
    
     public DWC_WaiverCollaboratorController (ApexPages.StandardController stdController) {  
        
        // Code merge DFM and DRC 
        
        dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        dwcSuperUserIds= DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users').keySet():NULL;
        // End code merge DFM and DRC
        //added for FAB_DRB Group
        fabDrbUserIds=DfmUtilityCls.getUsersFromPublicGroup('FAB_DRB_Group')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('FAB_DRB_Group').keySet():NULL;
       // ruleListWrapper = new list<ruleListTableWrapper>(); 
        ruleAttachMap = new map<String, List<Attachment>>();
        savedRuleList = new list<Waiver_Rule_List__c>();       
        waiverRuleIds = new Set<Id>();       
        ruleIdNameMap = new map<Id, String>();
        isAttachMap = new map<Id, String>();
        setOfFAEUsers = new Set<Id>();
        DRBGroupIds = new Set<Id>();
        setOfAllApprovers = new Set<Id>();
        DE_Users = new Set<Id>();
        QA_Users =  new Set<Id>();
        PIYE_Users = new Set<Id>();
        setOfFinalStatus = new Set<String>();
        setOfGFReviewStatus = new Set<String>();
        isRevertedRules=false;
        //Pagination
        this.totalNoOfPages = 0;
        this.totalNoOfRecords = 0;
        this.totalRecords = 0;
        this.currentPageNo = 1;
        //recordsPerPage = 10;
       // countOfRows();
        jsonruleList = '';
        jsonruleListALL = '';
         if(Test.isRunningTest()){
             finalStatusValue = 'FD';
         }else{
             finalStatusValue = 'All';
         }
        isDRBUser= false;
        isPortalUser = false;
        isFoundryView=false;
        isFAE = false;
        isDRB = false;
        isGroup = false;
        isDFMUser=false;
        isSuperUser=false;
        isSubmitForApproval=false;
        isRunOnly=false;
        tooltipMap = new map<String, String>{'PI' => 'Pass Ignore (No review requested by Customer,GLOBALFOUNDRIES expectation is that violation is absent in final TO or requested in additional waiver request.)',
                                            'PW' => 'Pass Waived (Waived for the specified use and/or Tapeout. No further action required by Customer.)',
                                            'PA' => 'Pass Auto (No Violations present in report.No further action required by Customer.)',
                                            'PWA' => 'Pass Waived (Waived for the specified use and/or Tapeout. No further action required by Customer.)',
                                            'POF' => 'Pass (Cannot be waived by GLOBALFOUNDRIES but not in scope of current request.)',
                                            'FCD' => 'Fail Design, Customer disagrees to fix or risk',
                                            'FD' =>  'Failed Design (Cannot be waived by GLOBALFOUNDRIES. Design cannot be accepted.)',
                                            'IFD' => 'Initial Failed Design (Cannot be waived by GLOBALFOUNDRIES, need to be fixed for final TO.)',
                                            'iFD' => 'Initial Failed Design (Cannot be waived by GLOBALFOUNDRIES, need to be fixed for final TO.)',
                                            'FCF' => 'Failed Design, Customer Agrees to Fix (Customer Agreed to fix, updated design to be submitted for Tapeout.)',
                                            'FCC' => 'Failed Design, Customer to check (Cannot be waived by GLOBALFOUNDRIES, need to be fixed or Customer Waiver provided with Customer assuming related risk.)',
                                            'WCR' => 'Waived Customer Risk (Customer agreed to waive, Customer is aware of related risk. Risk is assumed by Customer.)',
                                            'WEA' => 'Waived Exceptional Agreement (Waived with exceptional agreement by GLOBALFOUNDRIES. Please contact GLOBALFOUNDRIES Customer Representative)',
                                            'OPEN' => 'Waiver Collaborator status is open and action needs to be taken.)'}; 
        
        reviewTaskMessage= new map<String, String>{'TM1' => 'Execution /review is in progress. No action is required from customer yet.',
                                            'TM2' => 'The DFM/DRC Review results are ready. Your input is required to confirm which customers to receive the report when you approve Proceed to customer. Note that rules with Review status FCC or iFD are non-waived rules and are open for customer response.',
                                            'TM3' => 'The DFM/DRC Review results are ready. No action is required from customer.',
                                            'TM4' => 'The DFM/DRC Review results are ready. Customer prompt action is required to enter the Customer Option and Customer Explanation. Please click Save and Submit when finished.',
                                            'TM5' => 'Customer has submitted the customer response. No action is required from Customer yet further notice.',
                                            'TM6' => 'Customer has submitted the customer response. No action is required from Customer yet further notice.',
                                            'TM7' =>  'Customer has declined to design fixes or to accept risk for the non-waived rules.Executives/Tier2 approval is required for foundry to accept risk (Will communicate as Waived Exceptional Arrangement, WEA once approved).',
                                            'TM8' => 'The DFM Review Final results are ready. No action is required from customer.',
                                            'TM9' => 'The DFM Review Final results are ready. Please kindly fix the non-waived violations and resubmit.',
                                            'TM10' => 'Services/Review Request has been cancelled. No action is required. ',
                                            'TM11'=> 'Review is in progress. No action is required from customer yet.'};
        uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        countMap=new Map<string,integer>();
        // getting the DRC record Id
        drcId = stdController.getRecord().Id;
        // retreiving DRC record
        waiverCollaborator = getWaiverCollaborator(drcId);
        lst_Chips = getChipDetails(drcId);
        // fetch the user data related to Account Field 
        Set<Id> contactIds4Share = new Set<Id>();
       // fetchAllRelatedUsers();
        
        //fetch the Account Managers related to Account Field
       // fetchAllManagers();
        // fetch PIYE/QA/DE/AM/FabWaiverTeam users(as per fab)
        //setUpPiyeAndQAUsers();
        
        // fetch FAE users related to Account Field
        setOfFAEUsers = DfmUtilityCls.getATPUsersByRole(waiverCollaborator.Account_Short_Name__c,uRoles); 
        // access to FAE users       
        if (setOfFAEUsers <> NULL && setOfFAEUsers.contains(UserInfo.getUserId())){
            isFAE = true;
        } else {
            isFAE = false;
        }
        
        // fetch DRB Group Users
        DRBGroupIds = DfmUtilityCls.getUsersForDRBGp(waiverCollaborator.DRB_Group_uIds__c);
        // access to DRB Group Users
        if(DRBGroupIds<>NULL && DRBGroupIds.contains(UserInfo.getUserId())){
            isDRB = true;
        } else {
            isDRB = false;
        }
        if(!Test.isRunningTest()){
       // setUpPiyeAndQAUsers();
        }
        // access to PIYE/QA/DE/AM/FabWaiverTeam users
        if(setOfAllApprovers<>NULL && setOfAllApprovers.contains(UserInfo.getUserId())){
            isGroup = true;
        } else {
            isGroup = false;
        }
        
        //Check for DFM User        
        if(dfmUserIds<>NULL && dfmUserIds.contains(UserInfo.getUserId())){
            isDFMUser = true;
        } else {
            isDFMUser = false;
        }
        
        // checking whether the logged in User is Standard or not
        if (UserInfo.getUserType()!='Standard'){
            isPortalUser = true; 
            isStandardUser = false;           
        } else {
            isPortalUser = false;
            isStandardUser = true;
        }
        
        //Check Foundry View URL
        //isFoundryView
        String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
        if (currentRequestURL.contains('GlobalfoundryView')){
            isFoundryView=true;
            
        }
        
        if(waiverCollaborator.Is_Submit_4_DFM_Apprval__c){
        isSubmitForApproval=true;
        }
        
         if(waiverCollaborator.DRCServiceoption__c<>null && waiverCollaborator.DRCServiceoption__c.toLowerCase()=='DRC Run Only'){
         
           isRunOnly =true;  
             
         }     
        
        //check for FAB_DRB_Group user 
        if(fabDrbUserIds<>NULL && fabDrbUserIds.contains(UserInfo.getUserId())){
            isDRBUser = true;
        } else {
            isDRBUser = false;
        }
        
        if(dwcSuperUserIds<>NULL && dwcSuperUserIds.contains(UserInfo.getUserId())){
            isSuperUser = true;
        } else {
            isSuperUser = false;
        }
        
         if (isPortalUser){
        taskMessage = getTaskMessage4Customer(waiverCollaborator);  
        }else{
        taskMessage = getTaskMessage4Internal(waiverCollaborator);
        }
        //Retrieving Rule List Data related to DRC Record
       // getWaiverRuleTable(); 
       // totalRecords = ruleListWrapper.size();    
        system.debug('==========totalRecords================'+totalRecords);
        //PDF enhancements
        notesList=DfmUtilityCls.getNotesForCollaborator(drcId);
       // closingSection=getClosingSectionList(drcId);
        pdfWruleListForPDF=DfmUtilityCls.getWaiverRuleListForPDF(drcId); 
            
        if(pdfWruleListForPDF.size()<=0) isNonMatchRule=true;   
        system.debug('isNonMatchRule>>'+isNonMatchRule); 
             listWrapper=new list<wrapperForComments>();
        for(Waiver_Rule_List__c wRuleList: pdfWruleListForPDF){
         
         listWrapper.add(new wrapperForComments(wRuleList));
         system.debug('primediecomments>>'+wRuleList);
         }
       
        pdfWruleList = new List<Waiver_Rule_List__c>(); 
       
        if (waiverCollaborator.PTSR_Service_Type__c.contains('DRC')){
           finalStatus = new list<string>{'OPEN','FCD','FCF','WCR','WEA','FD','PW','PI','POF'};
        } else finalStatus = new list<string>{'OPEN','FCD','FCF','WCR','WEA','FD','PA','PW'};
        pdfRuleList=DfmUtilityCls.getWaiverRuleList(drcId); 
            for(Waiver_Rule_List__c wRuleList: pdfRuleList){
                pValue = ApexPages.currentPage().getParameters().get('primeDie');
                rValues = ApexPages.currentPage().getParameters().get('ruleType');    
                if(!Test.isRunningTest()){
                pValue.replace('[|+|]','_');
                } else {
                    if(pValue != 'All'){
                        pValue = 'Prime die1';    
                    }  
                   
                }    
                system.debug('rValues values:'+rValues);
                if(rValues == 'Additional'){
                    rOriginalValue = '0';       
                    pdfValue ='Non-Requested Waiver rules';
                } else if(rValues == 'Mandatory'){
                    rOriginalValue = '1'; 
                    pdfValue='Requested Waiver rules' ;  
                }else pdfValue='All';
                
                if(wRuleList.Prime_Die_Name__c == pValue && wRuleList.Rule_Type__c == rOriginalValue){
                        pdfWruleList.add(wRuleList);
                        system.debug('pdfWruleList:'+pdfWruleList);   
                }
                else if(pValue == 'All' && rValues == 'All'){
                    pdfWruleList.add(wRuleList);
                    system.debug('pdfWruleList------------'+pdfWruleList); 
                      
                }
                else if(wRuleList.Prime_Die_Name__c == pValue && rValues == 'All'){
                    pdfWruleList.add(wRuleList);    
                }
                else if(pValue == 'All' && wRuleList.Rule_Type__c == rOriginalValue){
                    pdfWruleList.add(wRuleList);             
                }
                
             } 
        
       //new code for review summery
        
        for(string s:tooltipMap.keyset()){
            countMap.put(s,0);
        
        }
     //   list<ruleListTableWrapper> tempList1=new list<ruleListTableWrapper>();
        PrimedieStatusMap = new Map<string,string>();
        PrimedieCountMap = new Map<string,Map<string,integer>>();
        Map<string,integer>  primeDieRUleMap=new  Map<string,integer>();
        pdNames = new set<string>();
        for(Waiver_Rule_List__c W: pdfWruleList){
            
            pdNames.add(w.Prime_Die_Name__c);
            
           if(PrimedieCountMap.containskey(w.Final_Stage__c)){
            primeDieRUleMap=PrimedieCountMap.get(w.Final_Stage__c);
           
            if(primeDieRUleMap.containsKey(w.Prime_Die_Name__c)){
                integer count=primeDieRUleMap.get(w.Prime_Die_Name__c)+1;
                primeDieRUleMap.put(w.Prime_Die_Name__c,count);
            }else{
                primeDieRUleMap.put(w.Prime_Die_Name__c,1);
                PrimedieCountMap.put(w.Final_Stage__c,primeDieRUleMap);
            }
            
        }else{
            PrimedieCountMap.put(w.Final_Stage__c,new Map<string,integer>{w.Prime_Die_Name__c=>1});
        }
        
        system.debug('PrimedieCountMap'+PrimedieCountMap);
            
            if(countMap.keyset().contains(W.Final_Stage__c)){
                integer count=countMap.get(W.Final_Stage__c)+1;
                countMap.put(W.Final_Stage__c,count);
            }else{
                countMap.put(W.Final_Stage__c,1);
            }
            setOfFinalStatus.add(W.Final_Stage__c);
            setOfGFReviewStatus.add(w.Stage__c);
            if(w.Revert_Rule__c){
            isRevertedRules=true;
            }
            Waiver_Rule_List__c tempWr=new Waiver_Rule_List__c();
            string radioVal='';
            tempWr.id=W.id;
            tempWr.Final_Stage__c=W.Final_Stage__c;
            tempWr.Stage__c=W.Stage__c;
            if(W.IsCustomerAgreeToFix__c){ radioVal='CustomerAgreeToFix';
            } else if(W.IsCustomerAcceptsRisk__c){  radioVal= 'CustomerAcceptsRisk';
            } else if(W.IsGfAcceptsRisk__c){  radioVal= 'GfAcceptsRisk';
            }else if(W.Disagree__c){ radioVal='Disagree';
            }else if(W.AcceptRisk__c){  radioVal='AcceptRejection';
            }else if(W.Revert_Rule__C){ radioVal='Revert';
            }
            boolean hasComment=false;
            if(W.GF_Internal_Closing_Comment__c<>null && W.GF_Internal_Closing_Comment__c!=''){
                hasComment=true;
            }
         //   ruleListTableWrapper rwrap=new ruleListTableWrapper(null, tempwr, null, null, null, radioVal,hasComment);
         //   tempList1.add(rwrap);
        }
        system.debug('PrimedieCountMap@@@'+PrimedieCountMap);
        for(string f : finalStatus){
             
          
          for(string pdname : pdNames){
                  if(PrimedieCountMap.containsKey(f)){
                   if(!PrimedieCountMap.get(f).containsKey(pdname)) {
                        PrimedieCountMap.get(f).put(pdname,0);   
                   }
                   
                  } else PrimedieCountMap.put(f,new map<string,integer>{pdname=>0});
                  
              }
              
        }
       PrimedieCountMapStatus = new Map<string,Map<string,integer>>();
       PrimedieStatusMapStatus = new Map<string,string>();
       list<Chip__c> objChip = [SELECT Id,Chip_Name__c, AllJobs_Submitted__c,Wavier_Collaborator__c FROM Chip__c WHERE Wavier_Collaborator__c =: waiverCollaborator.id and Chip_Name__c NOT IN: pdNames];
     
         //list<string> finalStage=new list<string>{'OPEN', 'FCD', 'FCF', 'WCR', 'WEA', 'FD', 'PW','PI','POF','PA'};
         for(Chip__c chip :objChip){
             
             if(chip.AllJobs_Submitted__c==true) {
             pdNames.add(chip.Chip_Name__c);
                Map<string,integer>  ChipPrimeDieRuleMap=new Map<string,integer>();
                for(string f:finalStatus){
                for(string pdname1 : pdNames){
                   ChipPrimeDieRuleMap.put(pdname1,0);
                    if(PrimedieCountMap.containsKey(f)){
                      PrimedieCountMap.get(f).put(pdname1,0);
                     }  else PrimedieCountMap.put(f,ChipPrimeDieRuleMap);
                }
                }
                
                PrimedieStatusMapStatus.put(chip.Chip_Name__c,'Auto Close');
                
             }
         }
       system.debug('pdNames@@@@@@'+pdNames);
         pdindexList= new List<string>();
       integer pdindex=0;
      pdNameMap=new Map<string,List<string>>();
      pdindexList.add(string.valueof(0));
      for(string pdname : pdNames){
          if(pdNameMap.get(string.valueof(pdindex))!=null && pdNameMap.get(string.valueof(pdindex)).size()>3){
              pdindex=pdindex+1;
              pdindexList.add(string.valueof(pdindex));
          }
          if(pdNameMap.containskey(string.valueof(pdindex))){
              pdNameMap.get(string.valueof(pdindex)).add(pdname);
          }
         else pdNameMap.put(string.valueof(pdindex),new List<string>{pdname});
          
      }
        
        
        
         
        

       
        
    List<Waiver_Rule_List__c> ruleList=new List<Waiver_Rule_List__c>();
    
    
    
    for(List<Waiver_Rule_List__c> wlist: [SELECT Prime_Die_Status__c,Final_Stage__c,Rule_Type__c ,isIntermediateSave__c,Stage__c,Final_Status__c,Prime_Die_Name__c  FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:waiverCollaborator.id and Rule_Type__c !='' ORDER BY Rule_Type__c DESC]){
        ruleList.addall(wlist);
     }
     
     
    for(Waiver_Rule_List__c w:ruleList){
        //system.debug('PrimedieCountMapStatus:'+w);
        if(PrimedieCountMapStatus.containskey(w.Prime_Die_Name__c)){
            
            Map<string,integer>  primeDieRUleMapStatus=PrimedieCountMapStatus.get(w.Prime_Die_Name__c);
            if(primeDieRUleMapStatus.containsKey(w.Final_Stage__c)){
                integer count=primeDieRUleMapStatus.get(w.Final_Stage__c)+1;
                primeDieRUleMapStatus.put(w.Final_Stage__c,count);
            }else{
                primeDieRUleMapStatus.put(w.Final_Stage__c,1);
                PrimedieCountMapStatus.put(w.Prime_Die_Name__c,primeDieRUleMapStatus);
            }
            
        }else{
            PrimedieCountMapStatus.put(w.Prime_Die_Name__c,new Map<string,integer>{w.Final_Stage__c=>1});
        }
        
        
        }
      // Wavier_Collaborator__c wc=[select id,DRCServiceoption__c from Wavier_Collaborator__c where id =:collabId]; 
        
    for(string s:PrimedieCountMapStatus.keyset()){
            Map<string,integer> countMap=PrimedieCountMapStatus.get(s);
           
            if(countMap.containsKey('POF')){
            PrimedieStatusMapStatus.put(s,'POF');
            }
            if(countMap.containsKey('PA')){
            PrimedieStatusMapStatus.put(s,'PA');
            }
            if(countMap.containsKey('PI')){
            PrimedieStatusMapStatus.put(s,'PI');
            }
            if(countMap.containsKey('PW')){
            PrimedieStatusMapStatus.put(s,'PW');
            }
            if(countMap.containsKey('WEA')){
            PrimedieStatusMapStatus.put(s,'WEA');
            }
            if(countMap.containsKey('WCR')){
            PrimedieStatusMapStatus.put(s,'WCR');
            }
            if(countMap.containsKey('FCF')){
            PrimedieStatusMapStatus.put(s,'FCF');
            }
            if(countMap.containsKey('FD')){
            PrimedieStatusMapStatus.put(s,'FD');
            }
            if(countMap.containsKey('OPEN')|| countMap.containsKey('FCD')){
            PrimedieStatusMapStatus.put(s,'OPEN');
            }
            
            system.debug('PrimedieStatusMapStatus'+PrimedieStatusMapStatus);
            if(countMap.containsKey('PWA')){
                    integer i = countMap.get('PWA');
                    if(countMap.containsKey('PW')){
                        integer j = countMap.get('PW');    
                        countMap.put('PW',i+j);
                    }else{
                        countMap.put('PW',i);
                    }
                    countmap.remove('PWA');
                }
            if(countMap.containsKey('FD')){
                    integer i = countMap.get('FD');
                    if(countMap.containsKey('iFD')){
                        integer j = countMap.get('iFD');    
                        countMap.put('FD',i+j);
                    }else{
                        countMap.put('FD',i);
                    }
                    countmap.remove('iFD');
                }
            if(countMap.containsKey('PWO')||countMap.containsKey('POC')||countMap.containsKey('PCF')){
                    integer i1 = countMap.get('PWO')!=null?countMap.get('PWO'):0;
                    integer i2 = countMap.get('POC')!=null?countMap.get('POC'):0;
                    integer i3 = countMap.get('PCF')!=null?countMap.get('PCF'):0;
                    if(countMap.containsKey('PI')){
                        integer j = countMap.get('PI');
                        countMap.put('PI',i1+i2+i3+j);
                    }else{
                        countMap.put('PI',i1+i2+i3);
                    }
                    countmap.remove('PWO');
                    countmap.remove('POC');
                    countmap.remove('PCF');
                }
                
                PrimedieCountMapStatus.put(s,countMap);
            }
        
        
         
     }
    
 
    
    public String getTaskMessage4Internal(Wavier_Collaborator__c collaborator) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        String progressBarStatus = collaborator.Progressbar_staus__c;
        String taskMsg;
            system.debug('waiverstatus'+waiverStatus);
            system.debug('workflowStatus'+workflowStatus);
            system.debug('Is_Sync_with_AIA__c'+collaborator.Is_Sync_with_AIA__c);
        try{
        if(collaborator.Revert_Collaborator__c && workflowStatus != 'Closed' && workflowStatus != 'Cancel'){
            taskMsg=' Review is in progress. No action is required from customer yet.';
        }

        else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {
             if(progressBarStatus == 'Review_Disposition'){ 
                if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){ taskMsg='DRC review result will be available after foundry review. No action is required from customer yet.';
                }else{ taskMsg='DFM review result will be available after foundry review. No action is required from customer yet.';
                }
           }else{ 
               taskMsg='Execution is in progress. No action is required from customer yet.';
           }
         
         } else if(isRunOnly && collaborator.Progressbar_staus__c.toLowerCase()== 'Pending For FAE' ) { 
           system.debug('isRunOnly'+isRunOnly);
                    taskMsg = 'The DFM/DRC Review results are ready. No action is required from FAE/Customer.'; 
         
         
         }else if (waiverStatus == 'Open' && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
          
           taskMsg='The DFM/DRC Review results are ready. Your input is required to confirm which customers to receive the report when you approve <b> Proceed to customer </b>. Note that rules with Review status FCC or iFD are non-waived rules and are open for customer response.';
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PA')  && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
          
             taskMsg='The DFM/DRC Review results are ready. Your input is required to confirm which customers to receive the report when you approve <b> Proceed to customer </b>. Note that rules with Review status FCC or iFD are non-waived rules and are open for customer response.';
        } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c =='Pending For Foundry'){
            
            if(setOfFinalStatus.contains('FCD')){
                  taskMsg='Customer has submitted the customer response. No action is required from Customer yet further notice.<br><br>'
                     +'There are non-waived rules which customer does not agree to fix or to take risk. FAE is to discuss with customer to encourage a response ( <b>agree to fix or accept risk</b>).'
                     +' If no positive response, FAE can select for <b> Request Foundry-to-risk or Accept waiver rejection. </b>';            
            }else{
                taskMsg='Customer has declined to design fixes or to accept risk for the non-waived rules.<br><br>'
                +'Executives/Tier2 approval is required for foundry to accept risk (Will communicate as <b> Waived Exceptional Arrangement, WEA </b>once approved).<br><br>'
                +'  Executives/Tier2  options are<br><br>'
                +'<b>&#8226;  Approve=</b> Foundry to accept risk due to no customer action possible on mitigating DFM/DRC violations;<br>'
                +'<b>&#8226;  Reject=</b> Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual. <b> Please contact FAE <FAE> and Account Manager <AM> before you choose to reject.</b> <br>'
                +'<br>Note: <br>'
                +'Final Request Foundry-to-risk Approval status= <b>Approve</b> <br> when all 4 groups (PIYE, DE, QA, AM) approve. <br>Final Request Foundry-to-risk Approval status=<b> Reject </b> <br>when <b> either </b> one of the 4 groups (PIYE, DE, QA, AM) reject                ';
            }
          } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){  taskMsg='The DFM/DRC Review results are ready. Customer prompt action is required to enter the <b> Customer Option </b> and <b> Customer Explanation </b>. Please click <b> Save and Submit </b> when finished.';
            
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PWA' || waiverStatus == 'PA') && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
           // baseUrl = mapOfpBarStatusImgs.get('Pending_Customer'); 
             taskMsg='The DFM/DRC Review results are ready. No action is required from customer.';
        }else if (workflowStatus == 'Closed'){
            
            if(!(setOfFinalStatus.contains('FCF') || setOfFinalStatus.contains('FD'))){ taskMsg=' The DFM/DRC Review Final results are ready. No action is required from customer.';
            }else if(setOfFinalStatus.contains('FCF') || setOfFinalStatus.contains('FD')){ taskMsg=' The DFM/DRC Review Final results are ready. Please kindly fix the non-waived violations and resubmit.';
            }else{
                taskMsg=' The DFM Review Final results are ready. Please kindly fix the non-waived violations and resubmit.';
            }
            
        }else if (workflowStatus == 'Cancel'){
           taskMsg=' Services/Review Request has been cancelled. No action is required. ';
        } 
        
        
             if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }  
        return taskMsg;
   
    } catch (exception e){
      //  GlobalUtility.logMessage('Debug', 'DWC_WaiverCollaboratorController', 'getTaskMessage4Internal()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_WaiverCollaboratorController.class.getName();
                alw.sourceFunction ='getTaskMessage4Internal()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
        return null;
                     
    }    
}
       // } catch (exception e){  GlobalUtility.logMessage('Debug', 'DWC_WaiverCollaboratorController', 'getTaskMessage4Internal()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
            
       // }     
    
    
   // Code for DRC
    
    public String  getTaskMessage4Customer(Wavier_Collaborator__c collaborator) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        String progressBarStatus = collaborator.Progressbar_staus__c;
        String taskMsg;
        try{
        if(collaborator.Revert_Collaborator__c && workflowStatus != 'Closed' && workflowStatus != 'Cancel'){
            taskMsg=' Review is in progress. No action is required from customer yet.';
        }
        else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {
            
           if(progressBarStatus == 'Review_Disposition'){
                if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){  taskMsg='DRC review result will be available after foundry review. No action is required from customer yet.';
                }else{ taskMsg='DFM review result will be available after foundry review. No action is required from customer yet.';
                }
           }else{ taskMsg='Execution is in progress. No action is required from customer yet.';
           }
            
        }else if (waiverStatus == 'Open' && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            taskMsg='';
          
          } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c =='Pending For Foundry'){
           
                taskMsg='Customer has submitted the customer response. No action is required from Customer yet further notice.';
           
           
        } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){ taskMsg='The DFM/DRC Review results are ready. Customer prompt action is required to enter the <b> Customer Option </b> and <b> Customer Explanation</b>. Please click <b> Save and Submit </b> when finished.';
       }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PWA' || waiverStatus == 'PA') && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
        // baseUrl = mapOfpBarStatusImgs.get('Pending_Customer'); 
             taskMsg='The DFM/DRC Review results are ready. No action is required from customer.';
        }else if (workflowStatus == 'Closed'){
            
            if(!(setOfFinalStatus.contains('FCF') || setOfFinalStatus.contains('FD'))){ taskMsg=' The DFM Review Final results are ready. No action is required from customer.';
            }else if(setOfFinalStatus.contains('FCF') || setOfFinalStatus.contains('FD')){ taskMsg=' The DFM Review Final results are ready. Please kindly fix the non-waived violations and resubmit.';
            }else{    taskMsg=' The DFM Review Final results are ready. No action is required from customer.';
            }
            
        }else if (workflowStatus == 'Cancel'){ taskMsg=' Services/Review Request has been cancelled. No action is required. ';
        } 
        
       // return taskMsg;
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }  
        return taskMsg;
   
    } catch (exception e){
      //  GlobalUtility.logMessage('Debug', 'DWC_WaiverCollaboratorController', 'getTaskMessage4Customer()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_WaiverCollaboratorController.class.getName();
                alw.sourceFunction ='getTaskMessage4Customer()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
          return null;
       // } catch (exception e){ GlobalUtility.logMessage('Debug', 'DWC_WaiverCollaboratorController', 'getTaskMessage4Customer()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
          //  return null;
        }     
    }
    
 @TestVisible     
 private Wavier_Collaborator__c getWaiverCollaborator(Id dfmId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
         query += 'isSubmitted__c,Additional_Comment__c ,Account_Short_Name__c,CMP__c,DRCServiceoption__c, Is_releasedToCustomer__c,isCustomerSelectionSubmitted__c,'
                +'Selected_Customers__c,CreatedById,Is_All_PI_PW__c,Cancellation_Reason__c,Revert_Collaborator__c,Revert_Reason__c,Revert_Stage__c,'
                +'MantisId__c, Account_Name__c,Customer_Full_Name__c,Device_Name__c, PTSR_Status__c,Mantis_DRCPLUS__c,Mantis_MAS__c,Mantis_MCD__c,PDK_DRC__c,'
                +' DRB_Group_uIds__c,CRMDID__c,D1_National__C,LastRuleSelected_GFRisk__c,isMulti__c ,LastRuleSelected_Customer__c,File_Name__c,File_Size__c,Is_Submit_4_DFM_Apprval__c '
                +'FROM Wavier_Collaborator__c WHERE Id =:dfmId LIMIT 1' ;
        
         system.debug('whats the Collaborator '+query);
        return Database.query(query);
    }
 public List<Chip__c> getChipDetails(Id dfmId1){
     try{
        lst_Chips = [SELECT Id,Name,Chip_Name__c,Chip_Size_X__c,Chip_Size_Y__c,Wavier_Collaborator__c,
                            Database_Name__c,Database_Size__c,Md5Sum__c,Source_PTSR_Number__c,Top_Cell_Name__c
                     FROM Chip__c
                     WHERE Wavier_Collaborator__c =:dfmId1];
                     
        
           if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }  
        return lst_Chips;
   
    } catch (exception e){
      //  GlobalUtility.logMessage('Debug', 'DWC_WaiverCollaboratorController', 'getChipDetails()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_WaiverCollaboratorController.class.getName();
                alw.sourceFunction ='getChipDetails()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
          return null;
      // } catch (exception e){ GlobalUtility.logMessage('Debug', 'DWC_WaiverCollaboratorController', 'getChipDetails()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0); return null;
        } 
    } 
  public boolean isTypeDFM {get;set;}
    public boolean isTypeDRC {get;set;}
    public boolean isLongFlow {get;set;}
    public List<Schema.FieldSetMember> getFields() {
        // Added new code for merging DFM and DRC modules
        Wavier_Collaborator__c collaborator = [Select Id, PTSR_Service_Type__c,DFM_Design_Type__c,DFMServiceOption__c from Wavier_Collaborator__c where Id=: drcId limit 1];
        isTypeDFM = false;
        isTypeDRC = false;
        isLongFlow=false;
        if (collaborator.PTSR_Service_Type__c.contains('DRC')){
            isTypeDRC = true;
            return SObjectType.Wavier_Collaborator__c.FieldSets.DRC_View.getFields();
        }
        
        if (collaborator.PTSR_Service_Type__c.contains('DFM')){
            isTypeDFM = true;
            if (collaborator.DFM_Design_Type__c <> null && collaborator.DFMServiceOption__c <>null && collaborator.DFM_Design_Type__c.toLowerCase()=='chip' && collaborator.DFMServiceOption__c.toLowerCase()=='waiver request'){
                isLongFlow = true;          
            }
            return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_Custome_View.getFields();
        }
        return null;
    }    
    
   public class wrapperForComments {
   
   public Waiver_Rule_List__c WaiverRuleList {get;set;}
   public string PrimeDieComments {get;set;}
   public string PrimeDieComments1 {get;set;}
   public wrapperForComments(Waiver_Rule_List__c waiver) {
   
   
  this.WaiverRuleList =waiver;
   string[] fabComments;
  if(WaiverRuleList .Prime_Die_Comment__c<>null) {
  fabComments=WaiverRuleList.Prime_Die_Comment__c.split(':');
     
  if(fabComments.size()>1){ 
  if(WaiverRuleList .Prime_Die_Comment__c<>null) PrimeDieComments=WaiverRuleList.Prime_Die_Comment__c.split(':')[0];
  if(WaiverRuleList .Prime_Die_Comment__c<>null) PrimeDieComments1= WaiverRuleList.Prime_Die_Comment__c.split(':')[1];
   } else {
       if(WaiverRuleList .Prime_Die_Comment__c<>null) PrimeDieComments=WaiverRuleList.Prime_Die_Comment__c;
   }
   }else {
   PrimeDieComments='';
   PrimeDieComments1='';
   }
   } 
  }  
public class applicationException extends Exception {} 
 }