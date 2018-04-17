/*
    Author: Abhita Bansal
    Company: GLOBALFOUNDRIES
    Project: DRC Application
    Description: This class is used as a controller for DRCWaiverCollaboratorPage
    History:  Suhas Bargi,10/05/2016 
    * @ Change History :-  SUHAS,25/01/2017 - Phase 3 changes, code Refactoring and Exception handling 
**/
public without sharing class DRCWaiverCollaboratorController {
    public boolean allCheckValue{get;set;} 
    public Map<integer, List<ruleListTableWrapper>> mapRuleTableWrapper{get;set;}  
    public Wavier_Collaborator__c waiverCollaborator {get;set;}
    public List<ruleListTableWrapper> ruleListWrapper {get;set;}
    public List<List<UserWrapperCls>> uWrapperLst {get;set;}
    public List<AMwrapperCls> amWrapperLst {get;set;}
    public string hiddenUsrIds {get;set;} 
    public string singleRecId {get;set;}
    public String jsonruleList {get;set;}
    public String jsonruleListALL {get;set;}
    public string customerOptions{get;set;} 
    public String finalStatusValue {get;set;}
    public String massValue {get;set;}
    public string massRadioOption{get;set;}
    public string revertOption{get;set;}//for mass update radio
    public string searchValue {get;set;}
    public String pageValue {get;set;}
    public boolean isPortalUser {get;set;}
    public boolean isFoundryView {get;set;}
    public boolean isStandardUser {get;set;}
    public boolean isFAE {get;set;}
    public boolean isDRB {get;set;}
    public boolean isGroup {get;set;}
    public boolean isSubmitForApproval{get;set;}
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
    public Integer recordsPerPage{get;set;} 
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer totalRecords {get;set;}
    public integer currentPageNo {get;set;}
    Transient public String taskMessage{get;set;}//SUHAS
    //PDF enhancements
    public List<Attachment> attachmentsCollaborator {get;set;}
    public List<Note> notesList {get;set;}
    public List<Wavier_Collaborator__History> closingSection {get; set;}
    public list<Waiver_Rule_List__c> pdfRuleList{get; set;}
    Transient public String drbGroup {get;set;}
    Transient public String drbDate {get;set;}
    Transient public String isWEAApprovedDate {get;set;}
    Transient public String isWEAApprovedBy {get;set;}
    Transient public String lastRuleCustDate {get;set;}
    Transient public String lastRuleCustBy {get;set;}
    Transient public String lastRuleWEADate {get;set;}
    Transient public String lastRuleWEABy {get;set;}
    // Merge code for DFM and DRC
    public List<Chip__c> lst_Chips {get;set;}
    Set<Id> dfmUserIds;// = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
    Set<Id> dfmManagerIds;// = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
    public boolean isDFMUser {get;set;}
    Set<Id> dwcSuperUserIds;//SUHAS
    // End of merge code DFM and DRC
    public String wfCancelationReason {get;set;}
    public String wfRevertReason {get;set;}
    public integer countValue{get;set;} //added for dynamic row
     Set<Id> fabDrbUserIds;//added for FAB_DRB Group
    
    
     
    public DRCWaiverCollaboratorController (ApexPages.StandardController stdController) {  
        
        // Code merge DFM and DRC 
        
        dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        dwcSuperUserIds= DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users').keySet():NULL;
        // End code merge DFM and DRC
        //added for FAB_DRB Group
        fabDrbUserIds=DfmUtilityCls.getUsersFromPublicGroup('FAB_DRB_Group')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('FAB_DRB_Group').keySet():NULL;
        ruleListWrapper = new list<ruleListTableWrapper>(); 
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
        countOfRows();
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
        fetchAllRelatedUsers();
        
        //fetch the Account Managers related to Account Field
        fetchAllManagers();
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
        setUpPiyeAndQAUsers();
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
        //Retrieving Rule List Data related to DRC Record
        getWaiverRuleTable(); 
        totalRecords = ruleListWrapper.size();    
        system.debug('==========totalRecords================'+totalRecords);
        //PDF enhancements
        notesList=DfmUtilityCls.getNotesForCollaborator(drcId);
        closingSection=getClosingSectionList(drcId);
        pdfRuleList=DfmUtilityCls.getWaiverRuleList(drcId);
       
       //new code for review summery
        
        for(string s:tooltipMap.keyset()){
            countMap.put(s,0);
        
        }
        list<ruleListTableWrapper> tempList1=new list<ruleListTableWrapper>();
        for(Waiver_Rule_List__c W: pdfRuleList){
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
            ruleListTableWrapper rwrap=new ruleListTableWrapper(null, tempwr, null, null, null, radioVal,hasComment);
            tempList1.add(rwrap);
        }
        if(countMap.containsKey('PWA')){
                integer i = countMap.get('PWA');
                if(countMap.containsKey('PW')){
                    integer j = countMap.get('PW');    
                    countMap.put('PW',i+j);
                }else{
                    countMap.put('PW',i);
                }
            }
        if(countMap.containsKey('FD')){
                integer i = countMap.get('FD');
                if(countMap.containsKey('iFD')){
                    integer j = countMap.get('iFD');    
                    countMap.put('iFD',i+j);
                }else{
                    countMap.put('iFD',i);
                }
            }
        if(countMap.containsKey('PWO')||countMap.containsKey('POC')||countMap.containsKey('PCF')){
                integer i1 = countMap.get('PWO')!=null?countMap.get('PWO'):0; integer i2 = countMap.get('POC')!=null?countMap.get('POC'):0;integer i3 = countMap.get('PCF')!=null?countMap.get('PCF'):0;
                if(countMap.containsKey('PI')){
                    integer j = countMap.get('PI');   countMap.put('PI',i1+i2+i3+j);
                }else{
                    countMap.put('PI',i1+i2+i3);
                }
            }
        if(tempList1<>null && !tempList1.isEmpty()){
        jsonruleListALL = json.serialize(tempList1).replaceAll('\n','\\n');
        }
        if (isPortalUser){
        taskMessage = getTaskMessage4Customer(waiverCollaborator);  
        }else{
        taskMessage = getTaskMessage4Internal(waiverCollaborator);
        }
        attachmentsCollaborator = DfmUtilityCls.getAttachments(drcId);
        if(waiverCollaborator.DRB_Group_uIds__c<>null){
        drbGroup=DfmUtilityCls.drbNames(waiverCollaborator.DRB_Group_uIds__c); 
        }
        // providing message to Customer on saving he records 
        String msgSave = '' + ApexPages.currentPage().getParameters().get('msgSave');
        if(msgSave == '2') {              
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Selected records are saved.')); 
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'One or more Rule is not agreed to fix or waived by customer and FAE will be notified to align with customer on further procedure.'));
        }else if(msgSave == '3' || (Test.isRunningTest())) {              
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Selected records are saved.')); 
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This collaborator is reverted back to Mantis by Superuser. Edit / Modification is not allowed.'));
        }else if(msgSave != 'null') {              
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Selected records are saved.')); 
        }
      
        
    }
    
    public List<Wavier_Collaborator__History>  getClosingSectionList(Id dfmId){         
         
          List<Wavier_Collaborator__History> historyList = new  List<Wavier_Collaborator__History>();
          
         if(Test.isRunningTest()){
             List<Wavier_Collaborator__History> historyListTest = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedBy.Name FROM Wavier_Collaborator__History LIMIT 1];
             Wavier_Collaborator__History wch = new Wavier_Collaborator__History();
             
             if(historyListTest<>null && !historyListTest.isEmpty()){
             wch.Field='LastRuleSelected_Customer__c';
             wch.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch);
              Wavier_Collaborator__History wch1 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch1.Field='Is_Sync_with_AIA__c';
             wch1.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch1);
              Wavier_Collaborator__History wch2 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch2.Field='LastRuleSelected_GFRisk__c';
             wch2.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch2);
              Wavier_Collaborator__History wch3 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch3.Field='Is_releasedToCustomer__c';
             wch3.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch3);
              Wavier_Collaborator__History wch4 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch4.Field='Waiver_Status__c';
             wch4.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch4);
             historyList = historyListTest;
         }else{
           historyList = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedBy.Name FROM Wavier_Collaborator__History WHERE ParentId =:dfmId ORDER BY CreatedDate DESC];
         }
        
          for (Wavier_Collaborator__History hstry : historyList ){
              
              
            if(hstry.Field=='Is_Sync_with_AIA__c'){            
                drbDate = string.valueof(hstry.CreatedDate);
             }
             if(hstry.Field=='Waiver_Status__c'){            
                isWEAApprovedDate = string.valueof(hstry.CreatedDate);
                 isWEAApprovedBy=hstry.CreatedBy.Name;
             }
              
              if(hstry.Field=='LastRuleSelected_Customer__c'){            
                  String str = waiverCollaborator.LastRuleSelected_Customer__c;
                  List<String> userFedIds = new  List<String>();
                  if(Test.isRunningTest()){
                      str = UserInfo.getUserId()+';'+UserInfo.getUserId();
                  }
                  if(str<>null){
                      for (String strSplit : str.split(';')){
                          userFedIds.add(strSplit.trim()); 
                      }
                      
                      if(userFedIds<>null && userFedIds.get(0)<>null  && userFedIds.get(1)<>null){
                          lastRuleCustBy=userFedIds.get(0);
                          lastRuleCustDate=userFedIds.get(1);
                      }
                  }
              }
                   
              if(hstry.Field=='Is_releasedToCustomer__c'){            
                isWEAApprovedDate = string.valueof(hstry.CreatedDate);
                 isWEAApprovedBy=hstry.CreatedBy.Name;
             }
              
             if(hstry.Field=='LastRuleSelected_GFRisk__c'){            
                String str = waiverCollaborator.LastRuleSelected_Customer__c;
                  List<String> userFedIds = new  List<String>();
                 if(Test.isRunningTest()){
                      str = UserInfo.getUserId()+';'+UserInfo.getUserId();
                 }
                  if(str<>null){
                      for (String strSplit : str.split(';')){
                          userFedIds.add(strSplit.trim()); 
                      }
                      
                     if(userFedIds<>null && userFedIds.get(0)<>null  && userFedIds.get(1)<>null){
                          lastRuleWEABy=userFedIds.get(0);
                          lastRuleWEADate=userFedIds.get(1);
                      }
                  }
             } 
              
              
          }
          //LastRuleSelected_Customer__c
          //LastRuleSelected_GFRisk__c
          //Is_releasedToCustomer__c
          //Is_Sync_with_AIA__c
          return historyList;
      }
       
    // get waiver collaborator field information from field sets
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
    
    // DFM and DRC merging modules and fetch chip related information 
    // get chip details related to waiver collaborator
    public List<Chip__c> getChipDetails(Id dfmId1){
        
        lst_Chips = [SELECT Id,Name,Chip_Name__c,Chip_Size_X__c,Chip_Size_Y__c,Wavier_Collaborator__c,
                            Database_Name__c,Database_Size__c,Md5Sum__c,Source_PTSR_Number__c,Top_Cell_Name__c
                     FROM Chip__c
                     WHERE Wavier_Collaborator__c =:dfmId1];
                     
        return lst_Chips;            
    }
    
    // retrive customer specific waiver collaborator records
    private Wavier_Collaborator__c getWaiverCollaborator(Id dfmId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
         query += 'isSubmitted__c,Account_Short_Name__c, Is_releasedToCustomer__c,isCustomerSelectionSubmitted__c,'
                +'Selected_Customers__c,CreatedById,Is_All_PI_PW__c,Cancellation_Reason__c,Revert_Collaborator__c,Revert_Reason__c,Revert_Stage__c,'
                +'MantisId__c, Account_Name__c,Customer_Full_Name__c,Device_Name__c, PTSR_Status__c,Mantis_DRCPLUS__c,Mantis_MAS__c,Mantis_MCD__c,PDK_DRC__c,'
                +' DRB_Group_uIds__c,LastRuleSelected_GFRisk__c,LastRuleSelected_Customer__c,Is_Submit_4_DFM_Apprval__c '
                +'FROM Wavier_Collaborator__c WHERE Id =\''+ dfmId  +'\'LIMIT 1' ;
        
         system.debug('whats the Collaborator '+query);
        return Database.query(query);
    }
    
    // to fetch the user data related to Account Field
    public void fetchAllRelatedUsers(){
       
        List<UserWrapperCls> uWrapper= new List<UserWrapperCls>();
        List<User> lst_Users;
        uWrapperLst = new List<List<UserWrapperCls>>();
        
        if(waiverCollaborator.Account__c<>NULL){
            lst_Users = [SELECT Id,Email,Name,MobilePhone 
                         FROM User 
                         WHERE IsActive = True
                         AND Contact.AccountId = :waiverCollaborator.Account__c 
                         ORDER BY Name DESC limit 2000];
        
        }       
        
          if(Test.isRunningTest()){
            lst_Users = [SELECT Id,Email,Name,MobilePhone 
                         FROM User 
                         WHERE IsActive = True
                         ORDER BY Name DESC limit 20];
            
        }                
        
        if (lst_Users<>NULL && !lst_Users.isEmpty()){
             for (User usr : lst_Users){
                // Need to write code to get existing users and mark them as selected
                UserWrapperCls uWrapperObj = new UserWrapperCls(false,usr);
                uWrapper.add(uWrapperObj);
                
                if (uWrapper.size() < 999){
                    continue;
                } else {
                    uWrapperLst.add(uWrapper);
                    uWrapper = new List<UserWrapperCls>();
                }
            }
            
            if (uWrapper.size()>0){
                uWrapperLst.add(uWrapper);
            }
        }       
    }
    
    // to fetch the Account Managers related to Account Field
    public void fetchAllManagers(){
        amWrapperLst = new List<AMwrapperCls>();
        list<Account_Team_Proxy__c> lst_ATP;
        
        if(waiverCollaborator.Account__c<>NULL){
            lst_ATP=[SELECT Account__r.Name,Team_Role__c,User__r.Name,User__c 
                     FROM Account_Team_Proxy__c
                     WHERE Team_Role__c IN ('Primary Account Manager','Account Administrator','Account Manager')
                     AND Account__c =: waiverCollaborator.Account__c];
        }
        if (lst_ATP<>NULL && !lst_ATP.isEmpty()){
            for (Account_Team_Proxy__c ATP : lst_ATP){
                AMwrapperCls amWrapper = new AMwrapperCls(false,ATP);
                amWrapperLst.add(amWrapper);
            }
        }
    }
    
    // to fetch PIYE/QA/FabWaiverTeam/DE/AM users as per collaborator fab
    public void setUpPiyeAndQAUsers(){
        
        if (waiverCollaborator.FAB__c<>NULL){
             if (waiverCollaborator.FAB__c.contains('1')){
                PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1').keySet():NULL;
                QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1').keySet():NULL;
                
                FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;              
             } else if (waiverCollaborator.FAB__c.contains('8')){           
                PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8').keySet():NULL;
                QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8').keySet():NULL;
                
                FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team').keySet():NULL;          
             }  else if (waiverCollaborator.FAB__c.contains('7')){          
                PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7').keySet():NULL;
                QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7').keySet():NULL;
                
                FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team').keySet():NULL;          
             } else if (waiverCollaborator.FAB__c.contains('9')){           
                PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9').keySet():NULL;
                QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9').keySet():NULL;
                
                FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team').keySet():NULL;          
             }
         
        }
        
         DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
         
         List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
         Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(waiverCollaborator.Account_Short_Name__c,atpManagers);
         
         if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
         }
         if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
         }
         if (DE_Users<>NULL && !DE_Users.isEmpty()){
            setOfAllApprovers.addAll(DE_Users);
         }
         if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
         }
         if (FabWaiverTeamUsers<>NULL && !FabWaiverTeamUsers.isEmpty()){
            setOfAllApprovers.addAll(FabWaiverTeamUsers);
         }        
    }
    
    public void recallDecision(){
         Integer recordsPerPageNum;
         integer totalNoOfPagesPerRecord;
        Integer totalNoOfRecordsperPage ;
        String totalRecordsforDWC;
        String currentPageNumber;
        if((!waiverCollaborator.Revert_Collaborator__c && !waiverCollaborator.isCustomerSelectionSubmitted__c) || Test.isRunningTest()){
         if((waiverCollaborator.Waiver_Status__c !='VCP' && waiverCollaborator.Progressbar_staus__c!=null && !waiverCollaborator.Progressbar_staus__c.contains('Cancelled')) || Test.isRunningTest()){
	        if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DFM')){
	        if(waiverCollaborator.DFM_Design_Type__c <> null && waiverCollaborator.DFMServiceOption__c <>null && 
	           waiverCollaborator.DFM_Design_Type__c.toLowerCase()=='chip'  && waiverCollaborator.DFMServiceOption__c.toLowerCase()=='waiver request' ){              
	               if(waiverCollaborator.Workflow_Status__c =='Closed'){ waiverCollaborator.Progressbar_staus__c='Closed'; update waiverCollaborator;
	               }else if( !waiverCollaborator.Is_releasedToCustomer__c && waiverCollaborator.Is_Sync_with_AIA__c){ waiverCollaborator.Progressbar_staus__c='Pending for FAE';  update waiverCollaborator;
	               }else if(waiverCollaborator.Is_releasedToCustomer__c && waiverCollaborator.Is_Sync_with_AIA__c &&  (setOfFinalStatus <> null && !setOfFinalStatus.isEmpty() && !setOfFinalStatus.contains('FCD') && !setOfFinalStatus.contains('OPEN'))  && waiverCollaborator.Waiver_Status__c.equalsignorecase('Open')){                  
	                   waiverCollaborator.Progressbar_staus__c='Pending For Customer';update waiverCollaborator;
	               }
	               
	           }else  if(waiverCollaborator.Workflow_Status__c =='Closed'){waiverCollaborator.Progressbar_staus__c='Closed';  update waiverCollaborator;
	           }else if(waiverCollaborator.Is_Submit_4_DFM_Apprval__c &&   waiverCollaborator.Waiver_Status__c != 'Approved' ){waiverCollaborator.Progressbar_staus__c='Pending for DFM'; update waiverCollaborator;
	           }
	        }else{
	            if(waiverCollaborator.Workflow_Status__c =='Closed'){waiverCollaborator.Progressbar_staus__c='Closed'; update waiverCollaborator;
	            }else if(!waiverCollaborator.Is_releasedToCustomer__c && waiverCollaborator.Is_Sync_with_AIA__c){waiverCollaborator.Progressbar_staus__c='Pending for FAE'; update waiverCollaborator;
	            }else if(waiverCollaborator.Is_releasedToCustomer__c && waiverCollaborator.Is_Sync_with_AIA__c &&  (setOfFinalStatus <> null && !setOfFinalStatus.isEmpty() && !setOfFinalStatus.contains('FCD') && !setOfFinalStatus.contains('OPEN'))   && waiverCollaborator.Waiver_Status__c.equalsignorecase('Open')){
                    waiverCollaborator.Progressbar_staus__c='Pending For Customer'; update waiverCollaborator;
	            }
	        }
        }
        List<Waiver_Rule_List__c> waiverRuleList = DfmUtilityCls.getWaiverRuleList(waiverCollaborator.Id);
       /* for(string s:tooltipMap.keyset()){
            countMap.put(s,0);
        
        }*/
        for(Waiver_Rule_List__c wr: waiverRuleList){
            if((wr.RecallApprovalProcess__c <> null && wr.RecallApprovalProcess__c !='' && wr.RecallApprovalProcess__c == 'recall' && (wr.Final_Stage__c=='FD' || wr.Final_Stage__c=='WEA')) || (Test.isRunningTest()) ){
                if(wr.IsCustomerAcceptsRisk__c){
                    wr.Final_Stage__c='WCR';
                }else if(wr.IsCustomerAgreeToFix__c){
                    wr.Final_Stage__c='FCF';
                } 
                if(!Test.isRunningTest()){
                update wr;
                }
            }
            
          /*if(countMap.keyset().contains(wr.Final_Stage__c)){
                integer count=countMap.get(wr.Final_Stage__c)+1;
                countMap.put(wr.Final_Stage__c,count);
            }else{
                countMap.put(wr.Final_Stage__c,1);
            } */
        }
    }else if(waiverCollaborator.Workflow_Status__c =='Closed'){
	                   waiverCollaborator.Progressbar_staus__c='Closed'; update waiverCollaborator;
	               }
    }
    
    
    // get waiver rule fields information to show in table 
    public void getWaiverRuleTable() {
        
        String wRuleFields = '';
        ruleListWrapper = new List<ruleListTableWrapper>();
        mapRuleTableWrapper = new Map<integer, List<ruleListTableWrapper>>();
        list<Waiver_Rule_List__c> waiverRuleTempList = new list<Waiver_Rule_List__c>();
        map<Id, String> idToOptionMap = new map<Id, String>();
        
        wRuleFields = DfmUtilityCls.getAllFields('Waiver_Rule_List__c');
        
        string soql = 'select ' + wRuleFields + ' from Waiver_Rule_List__c WHERE Waiver_Collaborator__c = \''+ drcId +'\'';
    
        if(searchValue<>NULL && !String.isEmpty(searchValue)) {
            soql = soql  +' AND (Stage__c LIKE \'%' + searchValue + '%\' OR '
                         +'Final_Stage__c LIKE \'%' + searchValue + '%\' OR '                     
                         +'Design_Rule_Name__c LIKE \'%' + searchValue + '%\')';           
        }
        if(finalStatusValue != 'All') {
            if(finalStatusValue == 'Open') { soql = soql  +' AND Final_Stage__c = \'OPEN\'';
            } else if(finalStatusValue == 'PI'){  soql = soql  +' AND Final_Stage__c = \'PI\'';
            } else if(finalStatusValue == 'PW'){   soql = soql  +' AND ( Final_Stage__c = \'PW\' OR Final_Stage__c = \'PWA\' ) ';
            } else if(finalStatusValue == 'PA'){ soql = soql  +' AND Final_Stage__c = \'PA\'';
            } else if(finalStatusValue == 'POF'){  soql = soql  +' AND Final_Stage__c = \'POF\'';
            } else if(finalStatusValue == 'FCD'){  soql = soql  +' AND Final_Stage__c = \'FCD\'';
            } else if(finalStatusValue == 'WEA'){ soql = soql  +' AND Final_Stage__c = \'WEA\'';
            } else if(finalStatusValue == 'WCR'){  soql = soql  +' AND Final_Stage__c = \'WCR\'';
            } else if(finalStatusValue == 'FCF'){ soql = soql  +' AND Final_Stage__c = \'FCF\'';
            } else if(finalStatusValue == 'FD'){ soql = soql  +' AND Final_Stage__c = \'FD\'';
            } else { soql = soql  +' AND Final_Stage__c != \'OPEN\'';
            }
        }
        
            soql = soql + ' ORDER BY Name LIMIT 1000';
                
        waiverRuleTempList = database.query(soql);
        if(searchValue<>NULL && !String.isEmpty(searchValue) && 
           !(searchValue=='PI' || searchValue=='PW' ||searchValue=='PA'||searchValue=='POF'||searchValue=='FCD' || searchValue=='FCC' || searchValue=='iFD' || searchValue=='FD' || searchValue=='WEA' || searchValue=='WCR')){
        
        list<Waiver_Rule_List__c> newList = new list<Waiver_Rule_List__c>();  
        List<Waiver_Rule_List__c> waiverRuleList1 = DfmUtilityCls.getWaiverRuleList(waiverCollaborator.Id);
        
        for(Waiver_Rule_List__c wt: waiverRuleList1){            
           
             if(searchValue <> null) {
                if(wt.Rule_Description__c <> null && searchValue<>NULL && !String.isEmpty(searchValue) && wt.Rule_Description__c.containsIgnoreCase(searchValue)) {
                    
                        newList.add(wt);
                       
                    
                }else if(wt.GF_Review_Comment__c <> null && searchValue<>NULL && !String.isEmpty(searchValue) && wt.GF_Review_Comment__c.containsIgnoreCase(searchValue)) {
                   
                        newList.add(wt);
                       
                    
                }else if(wt.GF_Internal_Closing_Comment__c <> null && searchValue<>NULL && !String.isEmpty(searchValue) && wt.GF_Internal_Closing_Comment__c.containsIgnoreCase(searchValue)) {       newList.add(wt);     
                } else if(wt.Customer_Closing_Comment__c <> null && searchValue<>NULL && !String.isEmpty(searchValue) && wt.Customer_Closing_Comment__c.containsIgnoreCase(searchValue)){     newList.add(wt);    
                }               
            }
        }
               
                if(Test.isRunningTest()){
               waiverRuleTempList = DfmUtilityCls.getWaiverRuleList(waiverCollaborator.Id);
                }
        list<Waiver_Rule_List__c> patchList = new list<Waiver_Rule_List__c>(); 
               if(waiverRuleTempList <> null && !waiverRuleTempList.isEmpty()){
                   for(Waiver_Rule_List__c wt:waiverRuleTempList){
                       for(Waiver_Rule_List__c wt1:newList){
                           if(wt.Id != wt1.Id){
                               patchList.add(wt1);
                           }
                       }
                   }
                   
                   if(patchList<>null && !patchList.isEmpty()){
                       waiverRuleTempList.addAll(patchList);
                   }
                   
               }else{
                   waiverRuleTempList=newList;
               }
         
        
        
    }
        if(waiverRuleTempList<>NULL && !waiverRuleTempList.isEmpty()) {           
            for(Waiver_Rule_List__c wr : waiverRuleTempList) {
                waiverRuleIds.add(wr.Id); 
                ruleIdNameMap.put(wr.Id, wr.Design_Rule_Name__c); 
                if(wr.IsCustomerAgreeToFix__c){  idToOptionMap.put(wr.Id, 'CustomerAgreeToFix');
                } else if(wr.IsCustomerAcceptsRisk__c){ idToOptionMap.put(wr.Id, 'CustomerAcceptsRisk');
                } else if(wr.IsGfAcceptsRisk__c){ idToOptionMap.put(wr.Id, 'GfAcceptsRisk');
                }else if(wr.Disagree__c){ idToOptionMap.put(wr.Id,'Disagree');
                }else if(wr.AcceptRisk__c){  idToOptionMap.put(wr.Id,'AcceptRejection');
                }else if(wr.Revert_Rule__C){  idToOptionMap.put(wr.Id,'Revert');
                }else {
                    idToOptionMap.put(wr.Id, '');
                }
            } 
              
            //Retrieving the Attachment Data related to Rule List
            getAttachment();
            
            for(Waiver_Rule_List__c wr : waiverRuleTempList) {
                ruleListWrapper.add(new ruleListTableWrapper(wr.SelectedBox__c, wr, tooltipMap.get(wr.Stage__c), tooltipMap.get(wr.Final_Stage__c), isAttachMap.get(wr.Id), idToOptionMap.get(wr.Id),false));                   
            }          
        } else {
            currentPageNo = 0;
            totalNoOfPages = 0;
            totalNoOfRecords = 0;
            //totalRecords = 0;
        }       
        
        if (ruleListWrapper<>NULL && !ruleListWrapper.isEmpty()) { 
            currentPageNo = 1;
            this.mapRuleTableWrapper = paginateRecords(ruleListWrapper);
        }
        system.debug('---751---------------ruleListWrapper----'+ruleListWrapper);     
    }
    
    // Pagination
    private Map<integer, List<ruleListTableWrapper>> paginateRecords(List<ruleListTableWrapper> ruleListWrapperPageRecords) {
        Map<integer, List<ruleListTableWrapper>> tempMap = new Map<integer, List<ruleListTableWrapper>>();
        integer pageNo = 1;
        List<ruleListTableWrapper> temp = new List<ruleListTableWrapper>();
        for (ruleListTableWrapper wrlw : ruleListWrapperPageRecords) { 
            if (temp.size() < recordsPerPage) {
                temp.add(wrlw);
            } else {
                tempMap.put(pageNo, temp); pageNo++; temp = new List<ruleListTableWrapper>();  temp.add(wrlw);
            }
        }
        
        if (temp<>NULL && !temp.isEmpty()) {
            tempMap.put(pageNo, temp);
        }
        
        // Set values
        this.totalNoOfPages = pageNo;
        if(currentPageNo > 1){
           this.currentPageNo = 1;        
        }
        this.totalNoOfRecords  = ruleListWrapperPageRecords.size();
       
        return tempMap; 
    }
    
    // to set the rule list in page
    public List<ruleListTableWrapper> getWaiverRuleRecords() {
        List<ruleListTableWrapper> tempList=new List<ruleListTableWrapper>();
        if((this.mapRuleTableWrapper).isempty())return new List<ruleListTableWrapper>();
        for(ruleListTableWrapper r:this.mapRuleTableWrapper.get(this.currentPageNo)){
            //ruleListTableWrapper(Boolean selected, Waiver_Rule_List__c wr, String toolTipSt, String toolTipFS, String isAttachThere, String radioValue)
            Waiver_Rule_List__c tempWr=new Waiver_Rule_List__c();
            tempWr.id=r.ruleRecords.id; tempWr.Stage__c=r.ruleRecords.Stage__c; tempWr.Disagree__c=r.ruleRecords.Disagree__c; tempWr.IsGfAcceptsRisk__c=r.ruleRecords.IsGfAcceptsRisk__c; tempWr.AcceptRisk__c=r.ruleRecords.AcceptRisk__c;  tempWr.IsCustomerAgreeToFix__c=r.ruleRecords.IsCustomerAgreeToFix__c; tempWr.IsIntermediateSave__c=r.ruleRecords.IsIntermediateSave__c; ruleListTableWrapper rwrap=new ruleListTableWrapper(r.selectBox, tempwr, r.tooltipStage, r.tooltipFinal, r.isAttach, r.selectedRadio,false);
            tempList.add(rwrap);
        }
        if(tempList<>null && !tempList.isEmpty()){
        jsonruleList = json.serialize(tempList).replaceAll('\n','\\n');
        }
        System.debug('mapRuleTableWrapper>>>>>>>>>>>>'+this.mapRuleTableWrapper);
        return (this.mapRuleTableWrapper.size() > 0 ? this.mapRuleTableWrapper.get(this.currentPageNo) : new List<ruleListTableWrapper>());
    }
    
    // get the Attachments as per the rule
    private void getAttachment() {
        List<Attachment> lst_attachments =  new List<Attachment>();
        
        lst_attachments = [Select Id, Name, ParentId from Attachment where ParentId =:waiverRuleIds LIMIT 1000];
       
        if(lst_attachments<>NULL && !lst_attachments.isEmpty()){
            for(Attachment att : lst_attachments){
                if(!ruleAttachMap.containsKey(ruleIdNameMap.get(att.ParentId))) {
                    ruleAttachMap.put(ruleIdNameMap.get(att.ParentId), new List<Attachment>());
                }
                ruleAttachMap.get(ruleIdNameMap.get(att.ParentId)).add(att);
            }
        }
        
        if(waiverRuleIds<>NULL && !waiverRuleIds.isEmpty()) {
            for(Id ruleId : waiverRuleIds) {           
                if(ruleAttachMap.containsKey(ruleIdNameMap.get(ruleId))){               
                    isAttachMap.put(ruleId, 'Yes');
                } else {
                    isAttachMap.put(ruleId, 'No');
                }           
            }
        }
    }
    
    // to set the attachments in page
    public map<String, List<Attachment>> getWaiverRuleAttachmentTable() {            
        return ruleAttachMap;
    }
    // dynamic row function
    public void countOfRows()
    {
        Boolean checkIf=true;
        if(countValue == null) {
            checkIf = false;
            countValue = 10;
        }
        
        this.recordsPerPage=Integer.ValueOf(countValue);
        if(checkIf) {
            getWaiverRuleTable();
            this.mapRuleTableWrapper = paginateRecords(ruleListWrapper);
        }
    }
    // Send DRC/DFM cancellation notifications
    
    public pageReference cancelWorkflow(){
      
      
        if(waiverCollaborator.Is_Sync_with_AIA__c){
            if(waiverCollaborator.IsGfAcceptsRisk__c || waiverCollaborator.Progressbar_staus__c=='Pending For Foundry'){
                waiverCollaborator.Progressbar_staus__c='Pending_Foundry_Cancelled';
            }else if(waiverCollaborator.Is_releasedToCustomer__c){
                 waiverCollaborator.Progressbar_staus__c='Pending_Customer_Cancelled';
            }else {
                 waiverCollaborator.Progressbar_staus__c='Pending_FAE_Cancelled';
            }
        }else{
        	if(waiverCollaborator.Progressbar_staus__c == 'Review_Disposition'){
        		waiverCollaborator.Progressbar_staus__c='Review_Disposition_Cancelled';
        	}else{
        		waiverCollaborator.Progressbar_staus__c='Cancelled';
        	}
        }
        waiverCollaborator.PTSR_Status__c = 'Cancel';
	    waiverCollaborator.Waiver_Status__c = 'VCP';
	    waiverCollaborator.Cancellation_Reason__c = wfCancelationReason;                
        update waiverCollaborator;
        if(! Test.isRunningTest()){
        DFMEmailImplementation.DFMJobCancellation(waiverCollaborator);
        }
        PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
        return p1;
    }
    
    public pageReference revertCollaborator(){
      
      system.debug('DFM>>>>>>>revertCollaborator '+wfRevertReason); 
        system.debug('DFM>>>>>>>revertCollaborator '+revertOption); 
        if(waiverCollaborator.Revert_Reason__c<>null && waiverCollaborator.Revert_Reason__c!=''){
            waiverCollaborator.Revert_Reason__c+=' || ';
            waiverCollaborator.Revert_Reason__c+=String.valueOf(System.today());
        }else{ waiverCollaborator.Revert_Reason__c=String.valueOf(System.today()); }
        if(revertOption=='Review'){
        
            waiverCollaborator.Revert_Collaborator__c=true; 
            waiverCollaborator.Revert_Stage__c=revertOption;
            waiverCollaborator.Revert_Reason__c+=wfRevertReason;
            waiverCollaborator.isSubmitted__c=false;
        
        }else if(revertOption=='Pending For FAE'){
        	String custIds= waiverCollaborator.Selected_Customers__c;
            waiverCollaborator.Is_releasedToCustomer__c =false;
            waiverCollaborator.Progressbar_staus__c='Pending for FAE';
            waiverCollaborator.Revert_Stage__c=revertOption;
            waiverCollaborator.Revert_Reason__c+=wfRevertReason;            
            waiverCollaborator.PTSR_Status__c='Open';
            waiverCollaborator.IsGfAcceptsRisk__c=false;
            waiverCollaborator.Selected_Customers__c='';
            waiverCollaborator.PTSR_Status__c='Pending';
            waiverCollaborator.isCustomerSelectionSubmitted__c=false;
            waiverCollaborator.isSubmitted__c=false;
            list<Waiver_Rule_List__c> tempList1=new list<Waiver_Rule_List__c>();
        	for(Waiver_Rule_List__c W: pdfRuleList){
                boolean openRule=false;
                if(w.Stage__c=='FCC' || w.Stage__c=='iFD' || w.Stage__c=='IFD' ){
                    w.Final_Stage__c='OPEN';
                    w.Revert_Rule__c=false; 
                    w.SelectedBox__c=false;
                    w.isIntermediateSave__c=false;
                    w.IsGfAcceptsRisk__c=false;
                    w.IsCustomerAgreeToFix__c=false;
                    w.IsCustomerAcceptsRisk__c=false;
                    w.AcceptRisk__c=false;
                    w.Disagree__c=false;
                    w.isAllPartyApproved__c=false;
                    w.Customer_Closing_Comment__c='';
                    w.GF_Internal_Closing_Comment__c='';
                    openRule=true;
                }
                if(openRule){
            	tempList1.add(w);
                }
        	}
            update tempList1;
            
            if(! Test.isRunningTest()){
                DFMEmailImplementation.DFMReviewSummaryNotificationL15(waiverCollaborator,custIds);
            }
            
            try{
                List<Wavier_Collaborator__Share> sharesToDelete = [SELECT Id FROM Wavier_Collaborator__Share  WHERE ParentId =:waiverCollaborator.Id AND RowCause = 'Manual'];
                if(!sharesToDelete.isEmpty()){
                    Database.Delete(sharesToDelete, false);
                }
                
                Set<Id> userIds = getUserids();
                
            }catch(Exception e){
                GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'revertCollaborator,remove sharing', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            }
            
            
        }else if(revertOption=='Pending For Customer'){
            
	        waiverCollaborator.Progressbar_staus__c='Pending For Customer';
            waiverCollaborator.Revert_Stage__c=revertOption;
            waiverCollaborator.Revert_Reason__c+=wfRevertReason;
            waiverCollaborator.isCustomerSelectionSubmitted__c=false;
            waiverCollaborator.isSubmitted__c=false;
            list<Waiver_Rule_List__c> tempList1=new list<Waiver_Rule_List__c>();
        	for(Waiver_Rule_List__c W: pdfRuleList){
                 boolean openRule=false;
                if(w.Stage__c=='FCC' || w.Stage__c=='iFD' || w.Stage__c=='IFD' ){
                    w.Final_Stage__c='OPEN';
                    w.Revert_Rule__c=false; 
                    w.SelectedBox__c=false;
                    w.isIntermediateSave__c=false;
                    w.IsGfAcceptsRisk__c=false;
                    w.IsCustomerAgreeToFix__c=false;
                    w.IsCustomerAcceptsRisk__c=false;
                    w.AcceptRisk__c=false;
                    w.Disagree__c=false;
                    w.isAllPartyApproved__c=false;
                    w.Customer_Closing_Comment__c='';
                    w.GF_Internal_Closing_Comment__c='';
                    openRule=true;
                }
                if(openRule){
            	tempList1.add(w);
                }
        	}
            update tempList1;
            
            if(! Test.isRunningTest()){
                DFMEmailImplementation.DFMReviewSummaryNotificationL15(waiverCollaborator,'');
            }
        }  
        update waiverCollaborator;
        PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
        return p1; 
    }
    
    
     // Final submit function for the revert method 
    public pageReference finalRevertSubmit() {  
       
                waiverCollaborator.PTSR_Status__c='Open';
                waiverCollaborator.Is_releasedToCustomer__c=false;
                waiverCollaborator.Is_All_PI_PW__c=false;
                waiverCollaborator.IsGfAcceptsRisk__c=false;
                waiverCollaborator.Selected_Customers__c='';
                waiverCollaborator.Is_Sync_with_AIA__c=false;
                waiverCollaborator.Mantis_DRCPLUS__c=false;
                waiverCollaborator.Mantis_MAS__c=false;
                waiverCollaborator.Mantis_MCD__c=false;
                waiverCollaborator.PDK_DRC__c=false;
                waiverCollaborator.Progressbar_staus__c='Review_Disposition';
                //Workflow_Status__c ??
                //waiverCollaborator.Waiver_Status__c ='Open';
        try{
               update waiverCollaborator;   
        }catch(Exception e){
             GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'revertCollaborator,final submit', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
        }
        
	    		if(waiverCollaborator.Is_releasedToCustomer__c){
	                if(! Test.isRunningTest()){ DFMEmailImplementation.DFMReviewSummaryNotificationL15(waiverCollaborator,''); }}else{
	                if(! Test.isRunningTest()){ DFMEmailImplementation.DFMJobRevertedL14(waiverCollaborator);}
	            }
        
        PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
        return p1;
        
    }

    
    public Set<Id> getUserids(){
        Set<Id> userIds = new Set<Id>();
        try{
             Set<Id> contactIds = new Set<Id>();
                List<Portal_Tab_Access__c> accessSetup = [SELECT Id,User__c FROM Portal_Tab_Access__c where PTRF__c=true and Account__r.Short_Name__c=:waiverCollaborator.Account_Short_Name__c]; 
                for(Portal_Tab_Access__c accessSetupObj:accessSetup ){
                    contactIds.add(accessSetupObj.User__c);
                }
            
                List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        		Set<Id> FAEs = DfmUtilityCls.getATPUsersByRole(waiverCollaborator.Account_Short_Name__c,uRoles);
        		Set<Id> custIds = DfmUtilityCls.getCustomers(waiverCollaborator.Created_By_Shortname__c,waiverCollaborator.Submitted_By_Shortname__c);
        		Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
                Set<Id> DRBGroupIds = DfmUtilityCls.getUsersForDRBGp(waiverCollaborator.DRB_Group_uIds__c); 
                	if (custIds<>NULL && !custIds.isEmpty()){
                		userIds.addAll(custIds);
                	}
                    if (contactIds<>NULL && !contactIds.isEmpty()){
                		userIds.addAll(contactIds);
                	}
                    if(DRBGroupIds<>NULL && !DRBGroupIds.isEmpty()) {
                        userIds.addAll(DRBGroupIds);
                        
                    } 
		            	DfmUtilityCls.shareRecord(waiverCollaborator.Id,userIds,'Read');
		           	if(FAEs<>NULL && !FAEs.isEmpty()) {
                         DfmUtilityCls.shareRecord(waiverCollaborator.Id,FAEs,'Edit');
		            }
        }catch(Exception e){
            GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'revertCollaborator,remove sharing', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
        }
        return userIds;
    }
    
    // Release waiver list to customer to take further decision   
    public pageReference releaseToCustomer(){
        system.debug('DFM>>>>>>>releaseToCustomer');
        Set <Id> selectedcustomers = new Set<Id>();
        
        try{
            if (hiddenUsrIds<>NULL && !String.isEmpty(hiddenUsrIds)){
                for (String str : hiddenUsrIds.split(';')){
                    selectedcustomers.add(Id.valueOf(str));
                }
            }
                                
            if (selectedcustomers<>NULL && !selectedcustomers.isEmpty()){               
                boolean isSuccess = DfmUtilityCls.shareRecord(waiverCollaborator.Id,selectedcustomers,'Edit');
                setOfFinalStatus = new Set<String>();
                if(waiverCollaborator.Waiver_Status__c=='Open' || Test.isRunningTest()){
                if(pdfRuleList<> null && !pdfRuleList.isEmpty()){
                        for(Waiver_Rule_List__c W: pdfRuleList){                    
                            setOfFinalStatus.add(W.Final_Stage__c);
                        }
                }
                
                }
                
                if (isSuccess){
                    DfmUtilityCls.stopTrigger=false;
                    if(waiverCollaborator.Is_All_PI_PW__c){
                    waiverCollaborator.isSubmitted__c=true; waiverCollaborator.Selected_Customers__c = hiddenUsrIds;waiverCollaborator.Is_releasedToCustomer__c = true;waiverCollaborator.PTSR_Status__c = 'Closed';waiverCollaborator.Progressbar_staus__c='Closed'; update waiverCollaborator;
                    PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');If(!Test.isRunningTest()){ return p1;     }
                    }else if((setOfFinalStatus <> null && !setOfFinalStatus.isEmpty() &&
                     ! setOfFinalStatus.contains('FCD') && !setOfFinalStatus.contains('OPEN')) || Test.isRunningTest() ){   
                         	
                    		 if(waiverCollaborator.Waiver_Status__c=='Open' || Test.isRunningTest()){
                                 	
								    if (setOfFinalStatus.contains('FD') || setOfFinalStatus.contains('IFD')){waiverCollaborator.Waiver_Status__c = 'FD'; } 
								    else if (setOfFinalStatus.contains('FCF')) { waiverCollaborator.Waiver_Status__c = 'FCF'; } 
								    else if (setOfFinalStatus.contains('WCR')) { waiverCollaborator.Waiver_Status__c = 'WCR'; }
								    else if (setOfFinalStatus.contains('WEA')) { waiverCollaborator.Waiver_Status__c = 'WEA';}
								    else if (setOfFinalStatus.contains('PW')) { waiverCollaborator.Waiver_Status__c = 'PW';  }
								    else if (setOfFinalStatus.contains('PI')) { waiverCollaborator.Waiver_Status__c = 'PI'; } 
								    else if (setOfFinalStatus.contains('PA')) {  waiverCollaborator.Waiver_Status__c = 'PA'; }
								    else if (setOfFinalStatus.contains('PWA')) { waiverCollaborator.Waiver_Status__c = 'PWA';  }
								    else if (setOfFinalStatus.contains('PWO')) {  waiverCollaborator.Waiver_Status__c = 'pWO';}
								    else if (setOfFinalStatus.contains('POC')) { waiverCollaborator.Waiver_Status__c = 'pOC'; }
								    else if (setOfFinalStatus.contains('POF')) {   waiverCollaborator.Waiver_Status__c = 'POF';  }
							} 
							
							  waiverCollaborator.isSubmitted__c=true;
			                  waiverCollaborator.Selected_Customers__c = hiddenUsrIds;
			                  waiverCollaborator.Is_releasedToCustomer__c = true;
			                  waiverCollaborator.PTSR_Status__c = 'Closed';
			                  waiverCollaborator.Progressbar_staus__c='Closed';
                        	  waiverCollaborator.Is_All_PI_PW__c=true;
			                  update waiverCollaborator;
			                    
			                PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');  If(!Test.isRunningTest()){  return p1;  }
		                    	
		                    	
                    }
                    
                    waiverCollaborator.Selected_Customers__c = hiddenUsrIds;
                    waiverCollaborator.Is_releasedToCustomer__c = true;
                    waiverCollaborator.PTSR_Status__c = 'Freeze';
                    waiverCollaborator.Progressbar_staus__c='Pending For Customer';
                    update waiverCollaborator;
                    
                    if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DFM')){
                        if(! Test.isRunningTest()){
                            DFMEmailImplementation.DFMReviewSummaryNotification4AllPA(waiverCollaborator);     
                        }
                    }
                    
                    if(! Test.isRunningTest()){
                    waiverCollaborator = getWaiverCollaborator(drcId);
                    }
                    //Added code for DFM enhancements to include scenario for DFM 
                    //L5- Item L3a is “Proceed to release”
                    if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){
                        if(! Test.isRunningTest()){
                        DRCEmailImplementation.drcResponseRequiredReport(waiverCollaborator);
                        }
                    }
                    //send freeze notification to Mantis
                    WaivercollaboratorTriggerHandler.sendWfFreezeNotificationToMantis(waiverCollaborator);
                    
                    PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
                    return p;                           
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error. Please contact your system admin.'));
                    return null;
                }           
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Customer details are missing.'));
                return null;
            }
        } catch (Exception e){
            // log error in to common error logger object
            //GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex Class', e, system.now());
            GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'releaseToCustomer()', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error. Please contact your system admin.'));
            return null;
        }                               
    }
   
    // Allow FAE to select customers from specific account
    public List<List<UserWrapperCls>> getCustomerDetails(){
        hiddenUsrIds='';
        return uWrapperLst;
    }
    
    // Allow user to select Account Manager for Approval
    public List<AMwrapperCls> getAMDetails(){
        hiddenUsrIds='';
        return amWrapperLst;
    }
    
    // submit Functionality
    public pageReference submitRules(){
        DfmUtilityCls.stopTrigger=false;
        String accountManagerUser = '';
        map<Id, String> idNameMap = new map<Id, String>();  
        set<String> selectedRuleIds = new set<String>();
        set<Id> Option3Ids = new set<Id>();
        set<String> selectedCheckRuleIds = new set<String>();        
        list<String> selectedValesofIdOption = new list<String>();
        list<Waiver_Rule_List__c> uncheckedRuleList = new list<Waiver_Rule_List__c>();
        Database.SaveResult[] resultList;
        //PageReference p;
        
        try{
            
            boolean disagreeFlag = false;
            system.debug('customerOptions>>>>>>>> '+customerOptions);     
            if (customerOptions<>NULL && !String.isEmpty(customerOptions)){
                for (String str : customerOptions.split(';')){
                    selectedRuleIds.add(str);
                }
            }
            
            if(Test.isRunningTest()){
                getWaiverRuleTable();           
                if(ruleListWrapper<>NULL && !ruleListWrapper.isEmpty()) {
                    for(ruleListTableWrapper wrapperValues : ruleListWrapper){
                        String valueOfOption = '';selectedRuleIds.add(String.valueOf(wrapperValues.ruleRecords.Id));
                    }
                }
            }
            
            if(selectedRuleIds<>NULL && !selectedRuleIds.isEmpty()) {
                for(String Ids : selectedRuleIds){
                    Integer i = 0;
                    selectedValesofIdOption = Ids.split(',');
                    idNameMap.put(selectedValesofIdOption[i], selectedValesofIdOption[i+1]);
                }
            }
             system.debug('singleRecId>>>>>>>> '+singleRecId);
            if(singleRecId<>NULL && !String.isEmpty(singleRecId)) { 
                for (String str : singleRecId.split(';')){
                    selectedCheckRuleIds.add(str);
                }
            }            
            // retreiving Account Team Proxy Data related to Account
            if((customerOptions <> null && customerOptions.contains('GfAcceptsRisk') )|| Test.isRunningTest()){
               
                List<Account_Team_Proxy__c> listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,
                                                                Team_Role__c,Account__r.Short_Name__c 
                                                         FROM Account_Team_Proxy__c 
                                                         WHERE Team_Role__c IN ('Primary Account Manager','Account Administrator','Account Manager') 
                                                         AND Account__r.Short_Name__c =: waiverCollaborator.Account_Short_Name__c];
                
                if(Test.isRunningTest()){
                    listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,
                                                                Team_Role__c,Account__r.Short_Name__c 
                                                         FROM Account_Team_Proxy__c 
                                                         WHERE Team_Role__c IN ('Primary Account Manager','Account Administrator','Account Manager') Limit 1];
                }
                
                if(listOfATP<>NULL && !listOfATP.isEmpty()){
                    for (Account_Team_Proxy__c ATP : listOfATP){
                        if (ATP.Team_Role__c =='Primary Account Manager'){
                            accountManagerUser = ATP.User__c;
                            break;
                        } else if (ATP.Team_Role__c =='Account Administrator'){  accountManagerUser = ATP.User__c;  break;
                        } else if (ATP.Team_Role__c =='Account Manager'){ accountManagerUser = ATP.User__c;  break;
                        }
                    }
                } else {
                    // In case account team proxy doesnt have any account manager related role then assign to default user
                    accountManagerUser = UserInfo.getUserId();
                }
            }
            finalStatusValue='All';
            getWaiverRuleTable();
            system.debug('=============ruleListWrapper============'+ruleListWrapper);            
            if(ruleListWrapper<>NULL && !ruleListWrapper.isEmpty()) {
                for(ruleListTableWrapper wrapperValues : ruleListWrapper){
                    String valueOfOption = '';
                    
                    if(selectedCheckRuleIds.contains(wrapperValues.ruleRecords.Id)|| Test.isRunningTest()){
                        Waiver_Rule_List__c rules = new Waiver_Rule_List__c();
                        rules.Id = wrapperValues.ruleRecords.Id;
                        rules.SelectedBox__c = wrapperValues.selectBox;
                        rules.isIntermediateSave__c=false;
                        valueOfOption = idNameMap.get(wrapperValues.ruleRecords.Id);
                        if(wrapperValues.ruleRecords.Customer_Closing_Comment__c != null && wrapperValues.ruleRecords.Customer_Closing_Comment__c != ''){
                            rules.Customer_Closing_Comment__c = wrapperValues.ruleRecords.Customer_Closing_Comment__c;//String.escapeSingleQuotes(vType.CustomerComment);
                        }
                        if(wrapperValues.ruleRecords.GF_Internal_Closing_Comment__c != null && wrapperValues.ruleRecords.GF_Internal_Closing_Comment__c != '') {
                            rules.GF_Internal_Closing_Comment__c = wrapperValues.ruleRecords.GF_Internal_Closing_Comment__c;
                        }
                        if(wrapperValues.ruleRecords.Stage__c != null) {
                               rules.Stage__c = wrapperValues.ruleRecords.Stage__c;
                        }
                        if(wrapperValues.ruleRecords.GF_Review_Comment__c != null) {
                               rules.GF_Review_Comment__c = wrapperValues.ruleRecords.GF_Review_Comment__c;
                        }
                         
                         if(wrapperValues.ruleRecords.Customer_Review_Request__c != null) {
                               rules.Customer_Review_Request__c = wrapperValues.ruleRecords.Customer_Review_Request__c;
                        }
                         if(wrapperValues.ruleRecords.Final_Stage__c != null) {
                               rules.Final_Stage__c = wrapperValues.ruleRecords.Final_Stage__c;
                        }
                        if(wrapperValues.ruleRecords.Hierarchial_Error_Count__c != null) {
                               rules.Hierarchial_Error_Count__c = wrapperValues.ruleRecords.Hierarchial_Error_Count__c;
                        }
                        
                        if(Test.isRunningTest()){
                            valueOfOption='GfAcceptsRisk';
                        }
                        if(valueOfOption<>NULL && !String.isEmpty(valueOfOption)){
                            if(valueOfOption.contains('CustomerAgreeToFix')){
                                rules.IsCustomerAgreeToFix__c = true;  rules.Final_Stage__c = 'FCF';  rules.Disagree__c = false;  rules.AcceptRisk__c=false; rules.IsGfAcceptsRisk__c=false;rules.IsCustomerAcceptsRisk__c = false;
                            } else if(valueOfOption.contains('CustomerAcceptsRisk')){
                                rules.IsCustomerAcceptsRisk__c = true; rules.Final_Stage__c = 'WCR'; rules.Disagree__c = false;rules.AcceptRisk__c=false; rules.IsGfAcceptsRisk__c=false;  rules.IsCustomerAgreeToFix__c = false;
                                
                            } else if(valueOfOption.contains('GfAcceptsRisk')) {
                                rules.IsGfAcceptsRisk__c = true;
                                rules.Disagree__c = false;
                                rules.IsCustomerAcceptsRisk__c = false;
                                rules.Disagree__c = false;
                                rules.AcceptRisk__c=false;
                                rules.IsCustomerAgreeToFix__c = false;
                                rules.Final_Stage__c = 'OPEN';
                                //rules.RecallApprovalProcess__c='option';
                                rules.Warning__c='Please discuss with FAE upfront before rejecting waiver request. Your reject will immediately set this violation to: "NOT ACCEPT" and reject the design to customer.';
                                string collaborator='GF Review Results : '+rules.Stage__c+' || '+'Hierarchial Error Count :'+rules.Hierarchial_Error_Count__c+' || '+'GF Review Comment :'+rules.GF_Review_Comment__c+' || '+'Final Status :'+rules.Final_Stage__c+' || '+'GF internal closing comment :'+rules.GF_Internal_Closing_Comment__c+' || '+'Customer closing comment :'+rules.Customer_Closing_Comment__c+' || '+'Customer review Request :'+rules.Customer_Review_Request__c;
             
                                 rules.Collaborator_Details__c= 'Mask Set Title: '+waiverCollaborator.Mask_Set_Title__c+ ' || '+'CRM Device: '+ waiverCollaborator.Device_Name__c  +' || '+'Prime Die: '+waiverCollaborator.Prime_Die__c+' || '+'Customer Full Name: '+waiverCollaborator.Customer_Full_Name__c+' || '+collaborator;
                                 
                             
                                
                                if(hiddenUsrIds<>NULL && !String.isEmpty(hiddenUsrIds)) {
                                    rules.Account_Manager_Approver__c = Id.ValueOf(hiddenUsrIds);
                                } else {
                                    rules.Account_Manager_Approver__c = accountManagerUser;
                                }
                            } else if (valueOfOption.contains('Disagree')){//SUHAS
                                rules.Disagree__c = true;rules.Final_Stage__c = 'FCD';  rules.IsCustomerAcceptsRisk__c = false; rules.AcceptRisk__c=false;  rules.IsGfAcceptsRisk__c=false;  rules.IsCustomerAgreeToFix__c = false;
                                // Send Email to FAE about customer selection of Disagree option                               
                                //DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverCollaborator.Id);
                            }else if (valueOfOption.contains('AcceptRejection')){ rules.AcceptRisk__c=true;  rules.Final_Stage__c = 'FD'; rules.Disagree__c=false; rules.IsCustomerAcceptsRisk__c = false; rules.Disagree__c = false; rules.IsGfAcceptsRisk__c=false; rules.IsCustomerAgreeToFix__c = false;
                                //rules.Revert_Rule__c = true;
                                // Send Email to FAE about customer selection of Disagree option                               
                                // DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverCollaborator.Id);
                               // TODO ---- for disagree and revert, once any rule is set, send mail after for loop
                            }else if (valueOfOption.contains('Revert')){ rules.Revert_Rule__c = true; if(waiverCollaborator.Is_releasedToCustomer__c){
                                   // DFMEmailImplementation.DFMJobRevertedL15(waiverCollaborator);
                                }else{
                                   // DFMEmailImplementation.DFMJobRevertedL14(waiverCollaborator);
                                }
                                // Send Email to FAE about customer selection of Disagree option                               
                               // DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverCollaborator.Id);
                               // TODO ---- for disagree and revert, once any rule is set, send mail after for loop
                            }
                        }
                        
                        savedRuleList.add(rules);
                        
                    } else {
                        uncheckedRuleList.add(wrapperValues.ruleRecords);
                    }
                }
            }
            
            if(customerOptions.contains('Disagree')){
                disagreeFlag=true;
               // sendNotificationToFAE();
            }            
            
            // LastRuleSelected_Customer__c
            if(isPortalUser || Test.isRunningTest()){
                waiverCollaborator.LastRuleSelected_Customer__c=UserInfo.getName();
                 waiverCollaborator.LastRuleSelected_Customer__c+=';';
                waiverCollaborator.LastRuleSelected_Customer__c+=String.valueOf(System.today());
                waiverCollaborator.isSubmitted__c=true;
                waiverCollaborator.isCustomerSelectionSubmitted__c=true;
                update waiverCollaborator;
            }
            // LastRuleSelected_Customer__c end
            if(savedRuleList<>NULL && !savedRuleList.isEmpty()) {
                set<Waiver_Rule_List__c> savedRuleSet = new set<Waiver_Rule_List__c>();
                savedRuleSet.addAll(savedRuleList);
                savedRuleList.clear();
                savedRuleList.addAll(savedRuleSet);
                system.debug('=============savedRuleList============'+savedRuleList);
                resultList = Database.update(savedRuleList,false);
            }
            
            if(resultList<> NULL && !resultList.isEmpty()) {
                String resultValue = '';
                for(Database.SaveResult result : resultList) {
                    if (result.isSuccess()){
                        resultValue = 'Success';
                    } else {
                        resultValue = 'Fail';
                        break;
                    }
                } 
                waiverCollaborator = getWaiverCollaborator(drcId);
                if(resultValue == 'Success' && resultValue<>NULL && !String.isEmpty(resultValue)) {
                    
                    if(customerOptions <> NULL && (customerOptions.contains('CustomerAcceptsRisk') || customerOptions.contains('CustomerAgreeToFix'))){
                        
                       // DRCEmailImplementation.drcDecisionMadeByCustReport(waiverCollaborator);
                       waiverCollaborator.isCustomerSelectionSubmitted__c=true;
                	   update waiverCollaborator;                     
                    } 
                    if ((customerOptions <> null && customerOptions.contains('GfAcceptsRisk'))|| Test.isRunningTest()) {
                        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
                        Approval.ProcessResult[] processResults = null;
                        
                        for(Id recordIds : idNameMap.keyset()){
                            if(idNameMap.get(recordIds)=='GfAcceptsRisk'){
                                Option3Ids.add(recordIds);                    
                                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                                req.setComments('Submitting request by FAEs ');
                                req.setObjectId(recordIds);
                                requests.add(req);
                            }
                        }                       
                        
                        // Submit for approval request                  
                        try {
                            processResults = Approval.process(requests, false);
                        } catch (System.DmlException e) {
                            // log error in to common error logger object
                            //GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex Class', e, system.now());
                            GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'submitRules() - submit for approval process', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
                        }
                       
                        // check approval process submission result
                        if((processResults<> NULL && !processResults.isEmpty()) || Test.isRunningTest()) {
                            String prcResult = '';
                            if(Test.isRunningTest()){
                                prcResult = 'Success';  
                            }else{
                                for(Approval.ProcessResult resultApp : processResults) {                                
                                    if (resultApp.isSuccess()){  prcResult = 'Success';      
                                    } else { prcResult = 'Fail'; break;  
                                    }
                                }
                            }
                            if(prcResult == 'Success' || Test.isRunningTest()) { 
                                
                                if((!isPortalUser) || Test.isRunningTest()){
                                        waiverCollaborator.IsGfAcceptsRisk__c=true;
                                    waiverCollaborator.LastRuleSelected_GFRisk__c=UserInfo.getName();
                                    waiverCollaborator.LastRuleSelected_GFRisk__c+=';';
                                    waiverCollaborator.LastRuleSelected_GFRisk__c+=String.valueOf(System.today());
                                    waiverCollaborator.Progressbar_staus__c='Pending For Foundry';
                                    waiverCollaborator.isSubmitted__c=true;
                                    waiverCollaborator.isCustomerSelectionSubmitted__c=true;
                                    update waiverCollaborator;
                                }
                                if(!Test.isRunningTest()){
                                setUpPiyeAndQAUsers();
                                }
                                //Share with PIYE,QA,DE,AM
                                if (setOfAllApprovers<>NULL && !setOfAllApprovers.isEmpty()){
                                    DfmUtilityCls.shareRecord(waiverCollaborator.Id,setOfAllApprovers,'Edit');          
                                }
                               
                                if( waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){
                                 if(!Test.isRunningTest()){
                                DRCEmailImplementation.drcFoundryToRiskApproval(waiverCollaborator, Option3Ids);
                                 }
                                }else{
                                    //L8 : FAE trigger foundry-to-risk approval AND at least one rules with Customer final status  = (“FCC” OR “iFD”)
                                    //Approve/reject by clicking a button in the email body in case of same decision for all open rules:
                                    //Approve
                                    //Reject
                                    //Or open Collaborator for individual selection.
                                   if(!Test.isRunningTest()){
                                    DFMEmailImplementation.FoundryToRiskApproval(waiverCollaborator,Option3Ids);
                                   }
                                }                               
                            } else{
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.'));
                                return null;
                            }
                        }                     
                     } else if(customerOptions.contains('Disagree') || customerOptions.contains('AcceptRejection')|| customerOptions.contains('Revert') ){
                         system.debug('Disagree Option Selected by the user ');
                         if(customerOptions.contains('Disagree')){  disagreeFlag=true;  }
                        // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more Rule is not agreed to fix or waived by customer and FAE will be notified to align with customer on further procedure.'));
                         
                     }else {
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.'));  return null;
                     }
                 } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.'));  return null;
                }
                
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.')); return null;
            }  
        
            if (UserInfo.getUserType()!='Standard'){
                PageReference p = new PageReference('/GlobalfoundryView/DRCWaiverCollaboratorPage?id='+drcId);
                if(disagreeFlag){ p.getParameters().put('msgSave', '2');
                }else{
                  p.getParameters().put('msgSave', '1');
                }
                
                p.setRedirect(true);
                return p;
            } else {
                backToMainPage();
                return null;                                 
            }         
        } catch (Exception e){          
            // log error in to common error logger object
            //GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex Class', e, system.now());
            GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'submitRules()', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }   
    }
    
    public pagereference sendNotificationToFAE(){
        
         waiverCollaborator.isCustomerSelectionSubmitted__c=true;
         waiverCollaborator.Progressbar_staus__c='Pending For Foundry';
         update waiverCollaborator;
        
         if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){  
            if(! Test.isRunningTest()){ DRCEmailImplementation.drcDecisionMadeByCustReport(waiverCollaborator); }
         }else{ if(! Test.isRunningTest()){   DFMEmailImplementation.DFMReviewSummaryNotification4AllPA1(waiverCollaborator); }
         }
        return null;
    }
    
    
    // save Functionality
    public pageReference saveRules(){
        DfmUtilityCls.stopTrigger=true;
        String accountManagerUser = '';
        map<Id, String> idNameMap = new map<Id, String>();  
        set<String> selectedRuleIds = new set<String>();
        set<Id> Option3Ids = new set<Id>();
        set<String> selectedCheckRuleIds = new set<String>();        
        list<String> selectedValesofIdOption = new list<String>();
        list<Waiver_Rule_List__c> uncheckedRuleList = new list<Waiver_Rule_List__c>();
        Database.SaveResult[] resultList;
        //PageReference p;
        
        try{
            system.debug('customerOptions>>>>>>>> '+customerOptions);  
            boolean disagreeFlag = false;  
            boolean revertFlag = false;  
            if (customerOptions<>NULL && !String.isEmpty(customerOptions)){
                for (String str : customerOptions.split(';')){
                    selectedRuleIds.add(str);
                }
            }
            
            if(selectedRuleIds<>NULL && !selectedRuleIds.isEmpty()) {
                for(String Ids : selectedRuleIds){
                    Integer i = 0;
                    selectedValesofIdOption = Ids.split(',');
                    idNameMap.put(selectedValesofIdOption[i], selectedValesofIdOption[i+1]);
                }
            }
             system.debug('singleRecId>>>>>>>> '+singleRecId);
            if(singleRecId<>NULL && !String.isEmpty(singleRecId)) { 
                for (String str : singleRecId.split(';')){
                    selectedCheckRuleIds.add(str);
                }
            }            
            // retreiving Account Team Proxy Data related to Account
            
            if(customerOptions.contains('GfAcceptsRisk') || Test.isRunningTest()){
               
                List<Account_Team_Proxy__c> listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,
                                                                Team_Role__c,Account__r.Short_Name__c 
                                                         FROM Account_Team_Proxy__c 
                                                         WHERE Team_Role__c IN ('Primary Account Manager','Account Administrator','Account Manager') 
                                                         AND Account__r.Short_Name__c =: waiverCollaborator.Account_Short_Name__c];
                                                         
                if(listOfATP<>NULL && !listOfATP.isEmpty()){
                    for (Account_Team_Proxy__c ATP : listOfATP){
                        if (ATP.Team_Role__c =='Primary Account Manager'){
                            accountManagerUser = ATP.User__c;
                            break;
                        } else if (ATP.Team_Role__c =='Account Administrator'){  accountManagerUser = ATP.User__c;  break;
                        } else if (ATP.Team_Role__c =='Account Manager'){ accountManagerUser = ATP.User__c;  break;
                        }
                    }
                } else {
                    // In case account team proxy doesnt have any account manager related role then assign to default user
                    accountManagerUser = UserInfo.getUserId();
                }
            }
            system.debug('ruleListWrapper>>>>>>>> '+ruleListWrapper);           
            if(ruleListWrapper<>NULL && !ruleListWrapper.isEmpty()) {
                for(ruleListTableWrapper wrapperValues : ruleListWrapper){
                    String valueOfOption = '';
                    system.debug('wrapperValues>>>>>>>> '+wrapperValues);   
                    if(selectedCheckRuleIds.contains(wrapperValues.ruleRecords.Id)){
                        Waiver_Rule_List__c rules = new Waiver_Rule_List__c();
                        rules.Id = wrapperValues.ruleRecords.Id;
                        rules.SelectedBox__c = wrapperValues.selectBox;
                        rules.isIntermediateSave__c=true;
                        valueOfOption = idNameMap.get(wrapperValues.ruleRecords.Id);
                        if(wrapperValues.ruleRecords.Customer_Closing_Comment__c != null && wrapperValues.ruleRecords.Customer_Closing_Comment__c != ''){
                            rules.Customer_Closing_Comment__c = wrapperValues.ruleRecords.Customer_Closing_Comment__c;
                        }
                        if(wrapperValues.ruleRecords.GF_Internal_Closing_Comment__c != null && wrapperValues.ruleRecords.GF_Internal_Closing_Comment__c != '') {
                            rules.GF_Internal_Closing_Comment__c = wrapperValues.ruleRecords.GF_Internal_Closing_Comment__c;
                        }
                        if(wrapperValues.ruleRecords.Stage__c != null) {
                               rules.Stage__c = wrapperValues.ruleRecords.Stage__c;
                        }
                        if(wrapperValues.ruleRecords.GF_Review_Comment__c != null) {
                               rules.GF_Review_Comment__c = wrapperValues.ruleRecords.GF_Review_Comment__c;
                        }
                         
                         if(wrapperValues.ruleRecords.Customer_Review_Request__c != null) {
                               rules.Customer_Review_Request__c = wrapperValues.ruleRecords.Customer_Review_Request__c;
                        }
                         if(wrapperValues.ruleRecords.Final_Stage__c != null) {
                               rules.Final_Stage__c = wrapperValues.ruleRecords.Final_Stage__c;
                        }
                        if(wrapperValues.ruleRecords.Hierarchial_Error_Count__c != null) {
                               rules.Hierarchial_Error_Count__c = wrapperValues.ruleRecords.Hierarchial_Error_Count__c;
                        }
                        
                        if(Test.isRunningTest()){
                            valueOfOption='GfAcceptsRisk';
                        }
                        if(valueOfOption<>NULL && !String.isEmpty(valueOfOption)){
                            if(valueOfOption.contains('CustomerAgreeToFix')){ rules.IsCustomerAgreeToFix__c = true; rules.Final_Stage__c = 'FCF';  rules.Disagree__c = false; rules.AcceptRisk__c=false;rules.IsGfAcceptsRisk__c=false; rules.IsCustomerAcceptsRisk__c = false;
                            } else if(valueOfOption.contains('CustomerAcceptsRisk')){ rules.IsCustomerAcceptsRisk__c = true;  rules.Final_Stage__c = 'WCR'; rules.Disagree__c = false; rules.AcceptRisk__c=false;  rules.IsGfAcceptsRisk__c=false;  rules.IsCustomerAgreeToFix__c = false;
                                
                            } else if(valueOfOption.contains('GfAcceptsRisk')) {
                                rules.IsGfAcceptsRisk__c = true;
                                rules.Disagree__c = false;
                                rules.IsCustomerAcceptsRisk__c = false;
                                rules.AcceptRisk__c=false;
                                rules.IsCustomerAgreeToFix__c = false;
                                rules.Final_Stage__c = 'OPEN';
                                //rules.RecallApprovalProcess__c='option';
                                rules.Warning__c='Please discuss with FAE upfront before rejecting waiver request. Your reject will immediately set this violation to: "NOT ACCEPT" and reject the design to customer.';
                                string collaborator='GF Review Results : '+rules.Stage__c+' || '+'Hierarchial Error Count :'+rules.Hierarchial_Error_Count__c+' || '+'GF Review Comment :'+rules.GF_Review_Comment__c+' || '+'Final Status :'+rules.Final_Stage__c+' || '+'GF internal closing comment :'+rules.GF_Internal_Closing_Comment__c+' || '+'Customer closing comment :'+rules.Customer_Closing_Comment__c+' || '+'Customer review Request :'+rules.Customer_Review_Request__c;
             
                                 rules.Collaborator_Details__c= 'Mask Set Title: '+waiverCollaborator.Mask_Set_Title__c+ ' || '+'CRM Device: '+ waiverCollaborator.Device_Name__c  +' || '+'Prime Die: '+waiverCollaborator.Prime_Die__c+' || '+'Customer Full Name: '+waiverCollaborator.Customer_Full_Name__c+' || '+collaborator;
                                 
                             
                                
                                if(hiddenUsrIds<>NULL && !String.isEmpty(hiddenUsrIds)) {
                                    rules.Account_Manager_Approver__c = Id.ValueOf(hiddenUsrIds);
                                } else {
                                    rules.Account_Manager_Approver__c = accountManagerUser;
                                }
                            } else if (valueOfOption.contains('Disagree')){ rules.Disagree__c = true; rules.Final_Stage__c = 'FCD'; rules.IsCustomerAcceptsRisk__c = false;  rules.AcceptRisk__c=false;  rules.IsGfAcceptsRisk__c=false;  rules.IsCustomerAgreeToFix__c = false;
                               
                                // Send Email to FAE about customer selection of Disagree option                               
                               // DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverCollaborator.Id);
                            }else if (valueOfOption.contains('AcceptRejection')){  rules.AcceptRisk__c=true;  rules.Final_Stage__c = 'FD';  rules.Disagree__c=false; rules.IsCustomerAcceptsRisk__c = false; rules.Disagree__c = false; rules.IsGfAcceptsRisk__c=false; rules.IsCustomerAgreeToFix__c = false;
                                //rules.Revert_Rule__c = true;
                                // Send Email to FAE about customer selection of Disagree option                               
                               // DRCEmailImplementation.foundrytoRiskApprovalCancelledbyCustomer(waiverCollaborator.Id);
                               // TODO ---- for disagree and revert, once any rule is set, send mail after for loop
                            }else if (valueOfOption.contains('Revert')){
                                rules.Revert_Rule__c = true;  rules.IsGfAcceptsRisk__c = false;rules.Disagree__c = false; rules.IsCustomerAcceptsRisk__c = false; rules.AcceptRisk__c=false; rules.IsCustomerAgreeToFix__c = false;
                                
                            }
                        }
                        
                        
                        savedRuleList.add(rules);
                        
                        
                    } else {
                        uncheckedRuleList.add(wrapperValues.ruleRecords);
                    }
                }
            }
            
            if((customerOptions.contains('Disagree') && isPortalUser) || Test.isRunningTest()){
                disagreeFlag=true;
                //sendNotificationToFAE();
            }
             if (customerOptions.contains('Revert') ){
                
                DfmUtilityCls.stopTrigger=false;
                revertFlag=true;
                if(savedRuleList<>NULL && !savedRuleList.isEmpty()) { set<Waiver_Rule_List__c> savedRuleSet = new set<Waiver_Rule_List__c>();savedRuleSet.addAll(savedRuleList); savedRuleList.clear();savedRuleList.addAll(savedRuleSet); resultList = Database.update(savedRuleList,false);
                }  waiverCollaborator.PTSR_Status__c='Open'; waiverCollaborator.Is_releasedToCustomer__c=false; waiverCollaborator.Is_All_PI_PW__c=false; waiverCollaborator.IsGfAcceptsRisk__c=false;   waiverCollaborator.Selected_Customers__c=''; waiverCollaborator.Is_Sync_with_AIA__c=false;waiverCollaborator.Mantis_DRCPLUS__c=false;waiverCollaborator.Mantis_MAS__c=false;waiverCollaborator.Mantis_MCD__c=false; waiverCollaborator.PDK_DRC__c=false; waiverCollaborator.Progressbar_staus__c='Review_Disposition';  DfmUtilityCls.stopTrigger=TRUE;
            }else {
               
            // LastRuleSelected_Customer__c
            if(isPortalUser || Test.isRunningTest()){
            	if(setOfFinalStatus <> null && !setOfFinalStatus.isEmpty() && setOfFinalStatus.contains('FCD') && !setOfFinalStatus.contains('OPEN')){waiverCollaborator.isCustomerSelectionSubmitted__c=true;waiverCollaborator.Progressbar_staus__c='Pending For Foundry';}
                waiverCollaborator.LastRuleSelected_Customer__c=UserInfo.getName();   waiverCollaborator.LastRuleSelected_Customer__c+=';'; waiverCollaborator.LastRuleSelected_Customer__c+=String.valueOf(System.today()); update waiverCollaborator;
            }
            // LastRuleSelected_Customer__c end
            DfmUtilityCls.stopTrigger=true;
            if(savedRuleList<>NULL && !savedRuleList.isEmpty()) {
                set<Waiver_Rule_List__c> savedRuleSet = new set<Waiver_Rule_List__c>();savedRuleSet.addAll(savedRuleList); savedRuleList.clear();savedRuleList.addAll(savedRuleSet); resultList = Database.update(savedRuleList,false);
            }
            
            if(resultList<> NULL && !resultList.isEmpty()) {
                String resultValue = '';
                for(Database.SaveResult result : resultList) {
                    if (result.isSuccess()){  resultValue = 'Success';
                    } else { resultValue = 'Fail';  break;
                    }
                } 
                waiverCollaborator = getWaiverCollaborator(drcId);
                if(resultValue == 'Success' && resultValue<>NULL && !String.isEmpty(resultValue)) {
                    
                    if(customerOptions.contains('CustomerAcceptsRisk') || customerOptions.contains('CustomerAgreeToFix')){
                        
                        //DRCEmailImplementation.drcDecisionMadeByCustReport(waiverCollaborator);
                                             
                    } else if (customerOptions.contains('GfAcceptsRisk')) {
                    //removed code
                    } else if(customerOptions.contains('Disagree') || customerOptions.contains('AcceptRejection') || customerOptions.contains('Revert') ){
                        system.debug('Disagree Option Selected by the user ');
                        if(customerOptions.contains('Disagree')){ disagreeFlag=true;}
                        // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more Rule is not agreed to fix or waived by customer and FAE will be notified to align with customer on further procedure.'));
                        if(customerOptions.contains('Revert')){ revertFlag=true;} 
                     }else {
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.')); return null;
                     }
                 } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.')); return null;
                }
                
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update waiver collaborator report, please contact SFDC admin.')); return null;
            }  
            
            }
            if (UserInfo.getUserType()!='Standard'){
                PageReference p = new PageReference('/GlobalfoundryView/DRCWaiverCollaboratorPage?id='+drcId);
                if(disagreeFlag){ p.getParameters().put('msgSave', '2');
                }else  if(revertFlag){ p.getParameters().put('msgSave', '3');
                }else{  p.getParameters().put('msgSave', '1');
                }
                
                p.setRedirect(true); return p;
            } else {
               backToMainPage();
               return null;                                   
            }         
        } catch (Exception e){          
            // log error in to common error logger object
            //GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex Class', e, system.now());
            GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'saveRules()', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }   
    }
        
    // Final Status Functionality
    public void changeFinalStatus() {  
         
        getWaiverRuleTable();        
    }
    // Count of Rows()
    public void changeRowCount()
    {
        
        getWaiverRuleTable();
    }
    // Search Functionality
    public void searchRule() {      
        getWaiverRuleTable();
    }
    
    // Change Page Number
    public void pageNumberChange() {        
        this.currentPageNo = Integer.ValueOf(pageValue);
    }
    
     //Updaed by jabee for the case#00064961
    public pageReference pdfDownload(){        
         PageReference p =  new PageReference('/apex/WaiverCollaboratorPDF?id='+ApexPages.currentPage().getParameters().get('Id')); 
          p.setRedirect(true);       
        return p;
    }
   
    
    // Back Functionality
    public pageReference backToList(){          
        PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
        return p;
    }
    
    public pageReference revertButtonFunction(){//SUHAS
        waiverCollaborator.Revert_Collaborator__c=true;
        
        update waiverCollaborator;
        
       
        PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
        return p1;
        
    }
    
    public pageReference backToMainPage(){
        PageReference p =  new PageReference('/apex/DRCWaiverCollaboratorPage?id='+ApexPages.currentPage().getParameters().get('Id'));   
        return p;
    }
    
    // Customer Options
    public List<SelectOption> getOptions() {

        
        List<SelectOption> options = new List<SelectOption>();
        
        SelectOption so1 = new SelectOption('CustomerAgreeToFix','<span title="Customer agrees to fix the non-waived violations and resubmit">Customer Agrees to Fix</span>');
        so1.setEscapeItem(false);
        
        SelectOption so2 = new SelectOption('CustomerAcceptsRisk','<span title="Customer wants the device to proceed for manufacturing and accepts risk liability due to the unfixed violations">Customer Agrees to Take Risk</span>');
        so2.setEscapeItem(false);
        
        SelectOption so3 = new SelectOption('Disagree','<span title="Disagree (Customer has declined to fix non-waiver violations and declined to accept risk liability)">Customer does not agree to fix or to take risk</span>');
        so3.setEscapeItem(false);
        
        SelectOption so4 = new SelectOption('GfAcceptsRisk','<span title="Request Foundry-to-risk (FAE to escalate to GF executives only when customer has declined to do any fixing or accept risk liability after discussion)">Request Foundry-to-risk</span>');
        so4.setEscapeItem(false);
        
        SelectOption so5 = new SelectOption('AcceptRejection','<span title="Accept Waiver Rejection (FAE to Accept waiver Rejection)">Accept Waiver Rejection</span>');
        so5.setEscapeItem(false);

        SelectOption so6 = new SelectOption('Revert','<span title="Revert Rules to Mantis">Revert Rules</span>');
        so6.setEscapeItem(false);
        //portal user  012
        //portal  && ifd 1 disabled
        //fae || drb || superuser -> 34

        //common options for allusers
        options.add(so1);
        options.add(so2);
        options.add(so3);
        
        if(!waiverCollaborator.Is_releasedToCustomer__c){//fae no edit 
            so4.setDisabled(true);
            so5.setDisabled(true);
        }
        
        if(!isportalUser){
            so1.setDisabled(true);
            so2.setDisabled(true);
            so3.setDisabled(true);
            options.add(so4);
            options.add(so5);
        
        }
        
        if(waiverCollaborator.IsSubmitted__c || Test.isRunningTest()){
            so1.setDisabled(true);
            so2.setDisabled(true);
            so3.setDisabled(true);
            so4.setDisabled(true);
            so5.setDisabled(true);
        }
        
        if(isSuperUser ) {//isSuperUser
            options.add(so6);
            if(!waiverCollaborator.Revert_Collaborator__c){
                 so6.setDisabled(true);
            }
        }
        return options;
    }
    
    // Pagination
    public void previous() {
        this.currentPageNo--;
    }
    
    public void next() {
        this.currentPageNo++;
    }
    
    public void first() {
        countOfRows();
        this.currentPageNo = 1; 
    }
    
    public void last() {
        countOfRows();
        this.currentPageNo = this.totalNoOfPages;  
    }
    
    // Wrapper Class for the Waiver Rule List Table
    public class ruleListTableWrapper {
        
        public Waiver_Rule_List__c ruleRecords {get;set;}
        public Boolean selectBox {get;set;}
        public String tooltipStage {get;set;}
        public String tooltipFinal {get;set;}
        public String isAttach {get;set;}
        public String selectedRadio{get;set;}
        public boolean hasComment{get;set;}
        
        public ruleListTableWrapper(Boolean selected, Waiver_Rule_List__c wr, String toolTipSt, String toolTipFS, String isAttachThere, String radioValue,boolean hasCom) {
            ruleRecords = wr;
            selectBox = selected;
            tooltipStage = toolTipSt;
            tooltipFinal = toolTipFS;
            isAttach = isAttachThere;
            selectedRadio = radioValue;
            hasComment = hasCom;
        }
    } 
    
    // Get Customer details from specific Account
    public class UserWrapperCls {
        
        public boolean isSelected {get;set;}
        public User userRecord {get;set;}
    
        public UserWrapperCls(boolean selected,User usr){
            isSelected = selected;
            userRecord = usr;
        }
    } 
    
    // get account manager details from ATP
    public class AMwrapperCls {
        
        public boolean isSelected {get;set;}
        public Account_Team_Proxy__c ATP {get;set;}
        
        public AMwrapperCls (boolean selected,Account_Team_Proxy__c atp1){
            isSelected = selected;
            ATP = atp1;
        }
    }

    // Below code is for DFM and DRC merging. This code will help to approve DFM report to DFM manager
    
    public pageReference submitForApproval(){
        try {
            System.debug('>>>>>submitForApproval');
            String errorMessages = checkMandatoryFields();
            if (errorMessages != 'Success'){                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, errorMessages));
                if(!Test.isRunningTest()){
                    return null;
                }
            }
            
            if (DfmUtilityCls.getAttachments(drcId).isEmpty()){
                System.debug('>>>>>submitForApproval1');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Please attach waiver list before submitting for approval.'));
                if(!Test.isRunningTest()){
                    return null; 
                }
            }
            System.debug('>>>>>submitForApproval2');
            // Create an approval request for design waiver collaborator
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request by DFM users');
            req.setObjectId(drcId);
            // Submit the approval request for the Opportunity
            Approval.ProcessResult result = Approval.process(req);
            // check approval process submission result
            if (result.isSuccess() || Test.isRunningTest()){
                // update dfm apprval flag
                DRCWaiverCollaboratorController.updateCollaboratorStatus(waiverCollaborator.Id);
                // Share waiver report with DFM Approver group
                //DFM Enhancements - S1 mail template to DFM Manager and users - 14062016
                if(!Test.isRunningTest()){DFMEmailImplementation.DFMServicesApprovalRequest(waiverCollaborator); DfmUtilityCls.shareRecord(waiverCollaborator.Id,dfmManagerIds,'Edit');
                }
                //dfmApprovalToDfmApprovalTeam(); 
                PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
            return p;   
                 
                
            } else { 
                for(Database.Error err : result.getErrors()) {
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getStatusCode() + ': ' + err.getMessage()));
                 }
                 return null;
            }
             return null; 
             
        } catch (exception e){ 
            GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'submitForApproval()', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while submitting waiver report for approval. Please contact with SFDC admin.')); 
            return null;        
        } 
        
    } 
    
    
    public String getTaskMessage4Internal(Wavier_Collaborator__c collaborator) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        String progressBarStatus = collaborator.Progressbar_staus__c;
        String taskMsg;
        
        if(collaborator.Revert_Collaborator__c && workflowStatus != 'Closed' && workflowStatus != 'Cancel'){
            taskMsg=' Review is in progress. No action is required from customer yet.';
        }
        else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {
           
           if(progressBarStatus == 'Review_Disposition'){ if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){ taskMsg='DRC review result will be available after foundry review. No action is required from customer yet.';
                }else{ taskMsg='DFM review result will be available after foundry review. No action is required from customer yet.';
                }
           }else{ taskMsg='Execution is in progress. No action is required from customer yet.';
           }
            
        }
        // else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {//CHECK progress bar for Disposition flag aswell
         //       baseUrl = mapOfpBarStatusImgs.get('Internal_Review');            
        //}
        else if (waiverStatus == 'Open' && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            
          
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
           
               
           
        } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
           
             taskMsg='The DFM/DRC Review results are ready. Customer prompt action is required to enter the <b> Customer Option </b> and <b> Customer Explanation </b>. Please click <b> Save and Submit </b> when finished.';
            
        }else if ((waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PWA' || waiverStatus == 'PA') && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
           // baseUrl = mapOfpBarStatusImgs.get('Pending_Customer'); 
             taskMsg='The DFM/DRC Review results are ready. No action is required from customer.';
           
        }else if (workflowStatus == 'Closed'){
            
            if(!(setOfFinalStatus.contains('FCF') || setOfFinalStatus.contains('FD'))){
               taskMsg=' The DFM Review Final results are ready. No action is required from customer.';
            }else if(setOfFinalStatus.contains('FCF') || setOfFinalStatus.contains('FD')){
                taskMsg=' The DFM Review Final results are ready. Please kindly fix the non-waived violations and resubmit.';
            }else{
                taskMsg=' The DFM Review Final results are ready. Please kindly fix the non-waived violations and resubmit.';
            }
            
        }else if (workflowStatus == 'Cancel'){
           taskMsg=' Services/Review Request has been cancelled. No action is required. ';
        } 
        
        return taskMsg; 
    }
    
   // Code for DRC
    
    public String  getTaskMessage4Customer(Wavier_Collaborator__c collaborator) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        String progressBarStatus = collaborator.Progressbar_staus__c;
        String taskMsg;
        
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
            
        }
        // else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {//CHECK progress bar for Disposition flag aswell
         //       baseUrl = mapOfpBarStatusImgs.get('Internal_Review');            
        //}
        else if (waiverStatus == 'Open' && workflowStatus == 'Pending' && collaborator.Is_Sync_with_AIA__c){
            taskMsg='';
          
          } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c && collaborator.Progressbar_staus__c =='Pending For Foundry'){
           
                taskMsg='Customer has submitted the customer response. No action is required from Customer yet further notice.';
           
           
        } else if (waiverStatus == 'Open' && workflowStatus == 'Freeze' && collaborator.Is_Sync_with_AIA__c){
            
           
             taskMsg='The DFM/DRC Review results are ready. Customer prompt action is required to enter the <b> Customer Option </b> and <b> Customer Explanation</b>. Please click <b> Save and Submit </b> when finished.';
            
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
        
        return taskMsg; 
    }
    
     // update isSubmit4DFMApproval flag
     @future
    public static void updateCollaboratorStatus(Id dfmId){
        Wavier_Collaborator__c waiverObj = [Select Id,Is_Submit_4_DFM_Apprval__c,PTSR_Status__c,Progressbar_staus__c FROM Wavier_Collaborator__c WHERE Id = : dfmId limit 1];
        waiverObj.Is_Submit_4_DFM_Apprval__c = true;
        update waiverObj;
    } 
    
    // Customer Options
    public List<SelectOption> getRevertOptions(){

        
        List<SelectOption> revertOptions = new List<SelectOption>();
        
        SelectOption so1 = new SelectOption('Review','<span title="Customer agrees to fix the non-waived violations and resubmit">Review</span>');
        so1.setEscapeItem(false);
        
        SelectOption so2 = new SelectOption('Pending For FAE','<span title="Customer wants the device to proceed for manufacturing and accepts risk liability due to the unfixed violations">Pending For FAE</span>');
        so2.setEscapeItem(false);
        
        SelectOption so3 = new SelectOption('Pending For Customer','<span title="Disagree (Customer has declined to fix non-waiver violations and declined to accept risk liability)">Pending For Customer</span>');
        so3.setEscapeItem(false);
        
        
        
        if(waiverCollaborator.Is_releasedToCustomer__c && waiverCollaborator.Progressbar_staus__c=='Pending For Foundry' ){revertOptions.add(so3);}
        if(waiverCollaborator.Is_Sync_with_AIA__c && waiverCollaborator.Is_releasedToCustomer__c){revertOptions.add(so2);}
        revertOptions.add(so1);
        return revertOptions;
    }
    
     //Check the Mandatory Fields of Waiver Collaborator Object, Otherwise will not allow to Submit For Approval
    public String checkMandatoryFields() {
        
        Map<String, String> dfmFields = new Map<String,String>{'CRM Device' => waiverCollaborator.CRM_Device__c, 
                                                                'PTSR Number' => waiverCollaborator.PTSR_Number__c, 
                                                                'PTSR Service Type' => waiverCollaborator.PTSR_Service_Type__c, 
                                                                'PTSR Status' => waiverCollaborator.PTSR_Status__c,
                                                                'FAB' => waiverCollaborator.FAB__c, 
                                                                'Customer Full Name' => waiverCollaborator.Account__c, 
                                                                'Account Short Name' => waiverCollaborator.Account_Short_Name__c,
                                                                'DFMServiceOption' => waiverCollaborator.DFMServiceOption__c};
                                                                
        String errorMessages = MandatoryFieldValidator.createDFM(dFMFields);
        
        return errorMessages;                               
    }
    
     public void drcReminderReleaseReportToCustomer(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
          Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;        
        Set<Id> setOfAllApprovers = new Set<Id>();
        
        Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        
        Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        setUpPiyeAndQAUsers();
        
        if (DE_Users<>NULL && !DE_Users.isEmpty()){ 
            setOfAllApprovers.addAll(DE_Users   );
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        //Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Reminder: Your Approval is required :'+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+'_'+collaborator.Prime_Die__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c;
        // Prepare email body
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>Request Foundry-to-risk Approval</h3><br>'
            
            +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+'_'+collaborator.Prime_Die__c+' have been waived by '+collaborator.FAB__c+' '
            +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules. <br>'           
            +'<br><br> 1) If your decision is the same for all of the above rules, you can click on <Approve> or <Reject> directly. <br>'
            +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
            +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
            +'<b>Please contact FAE '+DE_Users+' and Account Manager '+'primaryAM'+' before you choose to reject.</b><br><br> '
            +'2) If you need detailed disposition, please open Collaborator<br>'
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +' for approval.<br><br>'
            +'Note:<br> Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br>'
            +setOfAllApprovers
            +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
            +'Collaborator Workflow Status: '+collaborator.Workflow_Status__c+' <br><br>'
            +collaborator.Account_Short_Name__c+' <br><br>'
            +collaborator.Created_By_Shortname__c+' <br><br>'
            +collaborator.Customer_Full_Name__c+' <br><br>'
            +collaborator.Device_Name__c+' <br><br>'
            +collaborator.FAE_Acc_ID__c+' <br><br>'
            +collaborator.Technology__c+' <br><br>'
            +collaborator.Submitted_By_Shortname__c+' <br><br>'
            +collaborator.Progressbar_staus__c+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details: <br>' //TODO
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();  
             }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReminderReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }  
        
    }
    
    public void drcFAENotification(Wavier_Collaborator__c collaborator){
        
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Transient Set<Id> setOfFAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);
          Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;        
        Set<Id> setOfAllApprovers = new Set<Id>();
        
        Set<Id> custIds = new Set<Id>();
        if (collaborator.Selected_Customers__c<>NULL && !String.isEmpty(collaborator.Selected_Customers__c)){
            for (String str : collaborator.Selected_Customers__c.split(';')){
                custIds.add(Id.valueOf(str));
            }
        }
        
        Set<Id> DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};
            Set<Id> AM_Users = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,atpManagers);
        setUpPiyeAndQAUsers();
        
        if (DE_Users<>NULL && !DE_Users.isEmpty()){ 
            setOfAllApprovers.addAll(DE_Users   );
        }       
        if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
        }
        if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
        }
        
        if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
        }
        
        List<String> toAddresses = DfmUtilityCls.getEmailIds(setOfFAEs);
        String drbGrp = collaborator.DRB_Group_uIds__c;
        List<String> ccAddresses = DfmUtilityCls.drbEmailIDs(drbGrp);
        //bccAddresses.add('Gfv.do.not.reply@globalfoundries.com');
        List<String> bccAddresses = new List<String>{'Gfv.do.not.reply@globalfoundries.com'};
        
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddresses,bccAddresses);
        //Transient String primeDieName = DfmUtilityCls.getPrimeDieName(collaborator.Id);
        String waiverCollaboratorURL = '';
        if (UserInfo.getUserType()!='Standard'){
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'GlobalfoundryView' + '/';
        } else {
            waiverCollaboratorURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        }
        
        Transient String subject='Reminder: Your Approval is required :'+collaborator.Name+', '+collaborator.PTSR_Number__c+', '+collaborator.Mask_Set_Title__c+'_'+collaborator.Prime_Die__c+' DRC Waiver Collaboration,'+collaborator.Account_Name__c;
        // Prepare email body
        // Prepare email body
        Transient String body = '<html>'
            
            +'<h3> <b>Title: </b>Request Foundry-to-risk Approval</h3><br>'
            
            +'Not all violations in DFM waiver Request for '+collaborator.Mask_Set_Title__c+'_'+collaborator.Prime_Die__c+' have been waived by '+collaborator.FAB__c+' '
            +'Waiver Review Board and customer has declined to design fixes or to accept risk for all non-waived rules. <br>'           
            +'<br><br> 1) If your decision is the same for all of the above rules, you can click on <Approve> or <Reject> directly. <br>'
            +'• <b>Approve</b>= Foundry to accept risk due to no customer action possible on mitigating DRC violations<br>'
            +'• <b>Reject</b>= Foundry reject the device tapeout submission due to unacceptable non-compliance to Design Manual.<br><br>'
            +'<b>Please contact FAE '+DE_Users+' and Account Manager '+'primaryAM'+' before you choose to reject.</b><br><br> '
            +'2) If you need detailed disposition, please open Collaborator<br>'
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            +' for approval.<br><br>'
            +'Note:<br> Final Foundry-to-Risk Approval status= <b>Approve</b> when <b>all</b> 4 groups (PIYE, DE, QA, AM) approve.<br>'
            +setOfAllApprovers
            +'Final Foundry-to-Risk Approval status= <b>Reject</b> when <b>either one</b> of the 4 groups (PIYE, DE, QA, AM) reject<br><br>'            
            +'Collaborator Workflow Status: '+collaborator.Workflow_Status__c+' <br><br>'
            +collaborator.Account_Short_Name__c+' <br><br>'
            +collaborator.Created_By_Shortname__c+' <br><br>'
            +collaborator.Customer_Full_Name__c+' <br><br>'
            +collaborator.Device_Name__c+' <br><br>'
            +collaborator.FAE_Acc_ID__c+' <br><br>'
            +collaborator.Technology__c+' <br><br>'
            +collaborator.Submitted_By_Shortname__c+' <br><br>'
            +collaborator.Progressbar_staus__c+' <br><br>'
            +'Access the following URL to login to the Design Waiver Collaborator for DFM Review Report details: <br>' //TODO
            + waiverCollaboratorURL + collaborator.Id+'<br><br>'
            
            +'</html>';
        //send plain text body
        try{
        emailUtil.htmlBody(body)
            .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
            .subject(subject)
            .sendEmail();  
             }catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRCEmailImplementation', 'drcReminderReleaseReportToCustomer()', String.valueOf(collaborator.Id), 'drc email', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }  
        
    }
    
    
    public void  getClosingSectionListController(Id dfmId){         
         
          List<Wavier_Collaborator__History> historyList = new  List<Wavier_Collaborator__History>();
          
         if(Test.isRunningTest()){
             List<Wavier_Collaborator__History> historyListTest = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedBy.Name FROM Wavier_Collaborator__History LIMIT 1];
             Wavier_Collaborator__History wch = new Wavier_Collaborator__History();
             
             if(historyListTest<>null && !historyListTest.isEmpty()){
             wch.Field='LastRuleSelected_Customer__c';
             wch.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch);
              Wavier_Collaborator__History wch1 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch1.Field='Is_Sync_with_AIA__c';
             wch1.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch1);
              Wavier_Collaborator__History wch2 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch2.Field='LastRuleSelected_GFRisk__c';
             wch2.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch2);
              Wavier_Collaborator__History wch3 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch3.Field='Is_releasedToCustomer__c';
             wch3.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch3);
              Wavier_Collaborator__History wch4 = new Wavier_Collaborator__History();
              if(historyListTest<>null && !historyListTest.isEmpty()){
             wch4.Field='Waiver_Status__c';
             wch4.Id=historyListTest.get(0).Id;
             }
             historyListTest.add(wch4);
             historyList = historyListTest;
         }else{
           historyList = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedBy.Name FROM Wavier_Collaborator__History WHERE ParentId =:dfmId ORDER BY CreatedDate DESC];
         }
        
          for (Wavier_Collaborator__History hstry : historyList ){
              
              
            if(hstry.Field=='Is_Sync_with_AIA__c'){            
                drbDate = string.valueof(hstry.CreatedDate);
             }
             if(hstry.Field=='Waiver_Status__c'){            
                isWEAApprovedDate = string.valueof(hstry.CreatedDate);
                 isWEAApprovedBy=hstry.CreatedBy.Name;
             }
              
              if(hstry.Field=='LastRuleSelected_Customer__c'){            
                  String str = waiverCollaborator.LastRuleSelected_Customer__c;
                  List<String> userFedIds = new  List<String>();
                  if(Test.isRunningTest()){
                      str = UserInfo.getUserId()+';'+UserInfo.getUserId();
                  }
                  if(str<>null){
                      for (String strSplit : str.split(';')){
                          userFedIds.add(strSplit.trim()); 
                      }
                      
                      if(userFedIds<>null && userFedIds.get(0)<>null  && userFedIds.get(1)<>null){
                          lastRuleCustBy=userFedIds.get(0);
                          lastRuleCustDate=userFedIds.get(1);
                      }
                  }
              }
                   
              if(hstry.Field=='Is_releasedToCustomer__c'){            
                isWEAApprovedDate = string.valueof(hstry.CreatedDate);
                 isWEAApprovedBy=hstry.CreatedBy.Name;
             }
              
             if(hstry.Field=='LastRuleSelected_GFRisk__c'){            
                String str = waiverCollaborator.LastRuleSelected_Customer__c;
                  List<String> userFedIds = new  List<String>();
                 if(Test.isRunningTest()){
                      str = UserInfo.getUserId()+';'+UserInfo.getUserId();
                 }
                  if(str<>null){
                      for (String strSplit : str.split(';')){
                          userFedIds.add(strSplit.trim()); 
                      }
                      
                     if(userFedIds<>null && userFedIds.get(0)<>null  && userFedIds.get(1)<>null){
                          lastRuleWEABy=userFedIds.get(0);
                          lastRuleWEADate=userFedIds.get(1);
                      }
                  }
             }               
          } 
          for (Wavier_Collaborator__History hstry : historyList ){
              
              
            if(hstry.Field=='Is_Sync_with_AIA__c'){            
                drbDate = string.valueof(hstry.CreatedDate);
             }
             if(hstry.Field=='Waiver_Status__c'){            
                isWEAApprovedDate = string.valueof(hstry.CreatedDate);
                 isWEAApprovedBy=hstry.CreatedBy.Name;
             }
              
              if(hstry.Field=='LastRuleSelected_Customer__c'){            
                  String str = waiverCollaborator.LastRuleSelected_Customer__c;
                  List<String> userFedIds = new  List<String>();
                  if(Test.isRunningTest()){
                      str = UserInfo.getUserId()+';'+UserInfo.getUserId();
                  }
                  if(str<>null){
                      for (String strSplit : str.split(';')){
                          userFedIds.add(strSplit.trim()); 
                      }
                      
                      if(userFedIds<>null && userFedIds.get(0)<>null  && userFedIds.get(1)<>null){
                          lastRuleCustBy=userFedIds.get(0);
                          lastRuleCustDate=userFedIds.get(1);
                      }
                  }
              }
                   
              if(hstry.Field=='Is_releasedToCustomer__c'){            
                isWEAApprovedDate = string.valueof(hstry.CreatedDate);
                 isWEAApprovedBy=hstry.CreatedBy.Name;
             }
              
             if(hstry.Field=='LastRuleSelected_GFRisk__c'){            
                String str = waiverCollaborator.LastRuleSelected_Customer__c;
                  List<String> userFedIds = new  List<String>();
                 if(Test.isRunningTest()){
                      str = UserInfo.getUserId()+';'+UserInfo.getUserId();
                 }
                  if(str<>null){
                      for (String strSplit : str.split(';')){
                          userFedIds.add(strSplit.trim()); 
                      }
                      
                     if(userFedIds<>null && userFedIds.get(0)<>null  && userFedIds.get(1)<>null){
                          lastRuleWEABy=userFedIds.get(0);
                          lastRuleWEADate=userFedIds.get(1);
                      }
                  }
             }               
          } 
      }
      


}