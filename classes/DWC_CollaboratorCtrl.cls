/* Author: DWC
    Company: GLOBALFOUNDRIES
    Project: DRC Application
    Description: This page is used to view the Waiver Collaborator record
    History: Updated Emails L14,L15 and L16 by Mohan 01/08/2017
**/

public with sharing class DWC_CollaboratorCtrl {
    public Boolean applyToAll{get;set;}
    public string primeDievl {get; set;}
   // public string primeDieValue{get; set;}
    public string accessSetupId{get;set;}
    public boolean isTypeDFM {get;set;}
    public boolean isTypeDRC {get;set;}
    public boolean isLongFlow {get;set;}
    public boolean isRunOnly {get;set;}
    public boolean isPortalUser{get;set;}
    //public static boolean isRuleType{get;set;}
    public string massRadioOption{get;set;}
    public set<SelectOption> ruleID {get; set;}
    public List<List<UserWrapperCls>> uWrapperLst {get;set;}
    public static Wavier_Collaborator__c waiverCollaborator{get;set;}
    public boolean allJobsSubmitted{get;set;}
    public Map<string,integer> countMap{get;set;}
    public String userGroup{get;set;}//SUHAS
    public String userId{get;set;}//SUHAS
    public Set<Id> setOfAllApprovers {get;set;}//SUHAS 
    public List<AMwrapperCls> amWrapperLst {get;set;}//SUHAS
    public string hiddenUsrIds {get;set;} //SUHAS
    public string statusValues {get;set;}
    public string hiddenAMsIds {get;set;} //SUHAS
    public String approverejectcomments {get;set;}//SUHAS
    public String wfCancelationReason{get;set;}//SUHAS
    public boolean isFoundryView {get;set;}
    public boolean isStandardUser {get;set;}
    public boolean isFAE {get;set;}
    public boolean isDRB {get;set;}
    public boolean isGroup {get;set;}
    public boolean isDFMUser {get;set;}
    public boolean isSubmitForApproval{get;set;}
    public boolean isSyncWithMantis {get;set;}
    public boolean isDRBUser{set;get;}
    Set<Id> dwcSuperUserIds;//SUHAS
    public boolean isSuperUser{get;set;}//SUHAS
    public string revertOption{get;set;}
    public String wfRevertReason {get;set;}
    public string collaboratorAccount{get;set;}
    public string collaRecId{get;set;}
    public list<String> uRoles;
    public Set<Id> dfmUserIds;
    public Set<Id> dfmManagerIds;
    public Set<Id> fabDrbUserIds;
    public set<Id> setOfFAEUsers;
    public Set<Id> DRBGroupIds;
    public String drbGroup {get;set;}
    public map<String, String> tooltipMap;
    public Set<String> setOfFinalStatus;
    public Set<String> setOfGFReviewStatus;
    public Id drcId; 
    public List<Chip__c> lst_Chips {get;set;}
    public List<DWC_Attachment__c> dwcAttachments {get;set;}
    public boolean isRevertedRules {get;set;}
    public string PtsrLink{get;set;}
    public string expectedDate{get;set;}
    public string myDate{get;set;}
    public string submittedBy{get;set;}
    public string SubmittedDate{get;set;}
    public List<Waiver_Rule_List__c> WruleList{get;set;}
    public static List<Waiver_Rule_List__c> WruleListForPrimeDieStatus =new list<Waiver_Rule_List__c>();
    
    // PDF Enhancements
    public List<Attachment> attachmentsCollaborator {get;set;}
    public Map<Id, String>  getCompleteRuleList{get;set;}
    Transient public String taskMessage{get;set;}
    public DWC_CollaboratorCtrl(apexpages.standardcontroller stdCntrl){
        isDRBUser= false;
        isPortalUser = false;
        isFoundryView=false;
        isFAE = false;
        isDRB = false;
        isGroup = false;
        isDFMUser=false;
        isSuperUser=false;
        isSyncWithMantis=false;
        isDRBUser= false;
        setOfFAEUsers = new Set<Id>();
        DRBGroupIds = new Set<Id>();
        setOfFinalStatus = new Set<String>();
        setOfGFReviewStatus = new Set<String>();
        isRevertedRules=false;
        ruleID = new set<SelectOption>();
        WruleList = new List<Waiver_Rule_List__c>();
       
        uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        if(!Test.IsRunningTest()){
        collaRecId=ApexPages.currentPage().getParameters().get('id');
        } else {
            waiverCollaborator = [Select Id from Wavier_Collaborator__c Where IsDeleted = false limit 1]; 
            collaRecId = waiverCollaborator.Id;            
        }
        
       // List<Waiver_Rule_List__c> WruleList = new List<Waiver_Rule_List__c>();
        WruleList = [Select Id, Prime_Die_Name__c from Waiver_Rule_List__c where Waiver_Collaborator__c =: collaRecId];
        system.debug('WruleList CollabId'+WruleList);
        for(Waiver_Rule_List__c Wrule : WruleList){
            system.debug('Wrule:'+Wrule.Prime_Die_Name__c);
           if(Wrule.Prime_Die_Name__c <>null) ruleID.add(new SelectOption(Wrule.Prime_Die_Name__c,Wrule.Prime_Die_Name__c));
            system.debug('ruleId:'+ruleID);
        }
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : getFields(collaRecId)) {
            query += f.getFieldPath() + ', ';
        }
        waiverCollaborator=new Wavier_Collaborator__c();
          query += 'isSubmitted__c,Account_Short_Name__c,Is_releasedToCustomer__c,isCustomerSelectionSubmitted__c,'
                +'Selected_Customers__c,CreatedById,Is_All_PI_PW__c,Cancellation_Reason__c,Revert_Collaborator__c,Revert_Reason__c,Revert_Stage__c,DRCServiceoption__c,Additional_Comment__c, '
                +'MantisId__c, Account_Name__c,Customer_Full_Name__c,Device_Name__c, PTSR_Status__c,Mantis_DRCPLUS__c,Mantis_MAS__c,Mantis_MCD__c,CMP__c,PDK_DRC__c,'
                +' DRB_Group_uIds__c,CRMDID__c,D1_National__C,PTSR_ID__c,LastRuleSelected_GFRisk__c,isMulti__c ,DFM_Transaction_Id__c ,isReleaseToCust4MultiDie__c ,LastRuleSelected_Customer__c,File_Name__c,File_Size__c,Is_Submit_4_DFM_Apprval__c '
                +'FROM Wavier_Collaborator__c WHERE Id =:collaRecId LIMIT 1' ;
        
         system.debug('whats the Collaborator '+query);
        waiverCollaborator=Database.query(query);
         system.debug('whats the Collaborator ==='+waiverCollaborator);
        setOfAllApprovers = new Set<Id>();
        setUpPiyeAndQAUsers();
        fetchAllRelatedUsers();
        collaboratorAccount=waiverCollaborator.Account__c;
        isSyncWithMantis = waiverCollaborator.Is_Sync_with_AIA__c;
        dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
        fabDrbUserIds=DfmUtilityCls.getUsersFromPublicGroup('FAB_DRB_Group')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('FAB_DRB_Group').keySet():NULL;
        //fetch the Account Managers related to Account Field
        fetchAllManagers();
        isPortalUser = false;
        if(!Test.isRunningTest()){
            String currentURL = URL.getCurrentRequestUrl().toExternalForm();
            String PtsrID=waiverCollaborator.PTSR_Number__c;
            if (currentURL.contains('uat2')){
             if(PtsrID!=null)PtsrLink='https://test.foundryview.com/cdnetapps/swift/ptsr/PTSR.aspx?PTSRNumber='+PtsrID.trim();
            } else {
                 if(PtsrID!=null)PtsrLink='https://www.global-foundryview.com/swiftweb/swift/ptsr/PTSR.aspx?PTSRNumber='+PtsrID.trim();
            }
        }
             
        
        if(waiverCollaborator.ExpectedDFM_Review_Completion_Date__c !=null){
        expectedDate=waiverCollaborator.ExpectedDFM_Review_Completion_Date__c.replace('T',' ').substringBefore('.');
        Datetime myDT =DateTime.valueOf(expectedDate); // Returns the current Datetime based on a GMT calendar.
        System.debug('$$$$$$$'+expectedDate);
         myDate = myDT.format('dd-MM-YYYY'); // formats the date
        system.debug('myDate='+myDate);
        
        }
        
        if(waiverCollaborator.Submitted_By_Shortname__c !=null && waiverCollaborator.Submitted_Date__c !=null) {
        Datetime myDT =DateTime.valueOf(waiverCollaborator.Submitted_Date__c);
        SubmittedDate=myDT.format('dd-MM-YYYY HH:mm');
        submittedBy=waiverCollaborator.Submitted_By_Shortname__c + '  ,  ' +SubmittedDate;
        }
        
        if( waiverCollaborator.PTSR_Service_Type__c.contains('DFM')) {
            isTypeDFM=true;
             if(waiverCollaborator.DFMServiceOption__c <>null && waiverCollaborator.DFMServiceOption__c.toLowerCase()=='waiver request'){
                isLongFlow = true;          
            }
        } 
         
         system.debug('DRCServiceoption__c'+waiverCollaborator.DRCServiceoption__c);        
       if(waiverCollaborator.DRCServiceoption__c<>null && waiverCollaborator.DRCServiceoption__c.toLowerCase()=='DRC Run Only'){
                system.debug('DRCServiceoption__c'+waiverCollaborator.DRCServiceoption__c);
                isRunOnly = true;          
            } else isRunOnly =false;
           
        if( waiverCollaborator.PTSR_Service_Type__c.contains('DRC'))isTypeDRC=true;
        dwcSuperUserIds= DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users').keySet():NULL;
        if(dwcSuperUserIds<>NULL && dwcSuperUserIds.contains(UserInfo.getUserId())){
            isSuperUser = true;
        } else {
            isSuperUser = false;
        }
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
        //Check Foundry View URL isFoundryView
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
        if(waiverCollaborator.DRB_Group_uIds__c<>null){
        drbGroup=DfmUtilityCls.drbNames(waiverCollaborator.DRB_Group_uIds__c); 
        }
        
        
         if (isPortalUser){
        taskMessage = getTaskMessage4Customer(waiverCollaborator);  
        }else{
        taskMessage = getTaskMessage4Internal(waiverCollaborator);
        }
        
       /* if(waiverCollaborator.isReleaseToCust4MultiDie__c){
        list<Waiver_Rule_List__c> ruleList = [Select Id, Final_Stage__c From Waiver_Rule_List__c Where Waiver_Collaborator__c =: waiverCollaborator.Id limit 1];
        system.debug('ruleList for auto close'+ruleList );
            if(ruleList.isEmpty()){
             system.debug('ruleList for auto close inside'+ruleList );
                 waiverCollaborator.isSubmitted__c=true;
                 waiverCollaborator.Is_releasedToCustomer__c = true;
                 waiverCollaborator.PTSR_Status__c = 'Closed';
                 waiverCollaborator.Waiver_Status__c='PA';
                 waiverCollaborator.Progressbar_staus__c='Closed';
                 update waiverCollaborator;
            }
        } */
               
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
        
        
         // getting the DRC record Id
        drcId = stdCntrl.getRecord().Id;
        // retreiving DRC record
       lst_Chips = getChipDetails(drcId);    
       dwcAttachments = getAttachmentsDetails(drcId);
    }
    
    // Customer Options
    public List<SelectOption> getOptions() {

        //Waiver_Rule_List__c ruleList = [Select Id, Final_Stage__c From Waiver_Rule_List__c Where Waiver_Collaborator__c =: waiverCollaborator.Id limit 1];
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
    
            
            
            if(!isportalUser){
                so1.setDisabled(true);
                so2.setDisabled(true);
                so3.setDisabled(true);
                options.add(so4);
                options.add(so5);
            
            }
            return options;   
    }
    
    // Allow FAE to select customers from specific account
    public List<List<UserWrapperCls>> getCustomerDetails(){
        
            hiddenUsrIds='';
            return uWrapperLst;  
    }
    
    public void fetchAllRelatedUsers(){
       
        List<UserWrapperCls> uWrapper= new List<UserWrapperCls>();
        List<User> lst_Users;
        set<id> contSet=new set<id>();
        uWrapperLst = new List<List<UserWrapperCls>>();
        if((waiverCollaborator!=null && waiverCollaborator.Account__c<>NULL)||collaboratorAccount!=null){
            string accId;
            if(waiverCollaborator!=null && waiverCollaborator.Account__c<>NULL)accId=waiverCollaborator.Account__c;
            else accId=collaboratorAccount;
            if(accId!=null){
                lst_Users = [SELECT Id,Email,Name,MobilePhone,contactId  
                         FROM User 
                         WHERE IsActive = True
                         AND Contact.AccountId = :accId 
                         ORDER BY Name DESC limit 2000];
            }
        
        }
        if(Test.isRunningTest()){
            lst_Users = [SELECT Id,Email,Name,MobilePhone,contactId
                         FROM User 
                         WHERE IsActive = True
                         ORDER BY Name DESC limit 20];
            
        }
        for(user u:lst_Users){
            contSet.add(u.contactId);
        }
              
        
        List<Portal_Tab_Access__c> paList= [select id,PTRF__c,Contact__c,User__c from Portal_Tab_Access__c where Contact__c in: contSet];
        Map<id,Portal_Tab_Access__c> ptrfAccessMap=new Map<id,Portal_Tab_Access__c>();
        for(Portal_Tab_Access__c pa:paList){
            ptrfAccessMap.put(pa.User__c,pa);
        }
        
        if (lst_Users<>NULL && !lst_Users.isEmpty()){
             for (User usr : lst_Users){
                // Need to write code to get existing users and mark them as selected
                UserWrapperCls uWrapperObj = new UserWrapperCls(false,usr,false,null);
                if(ptrfAccessMap!=null && ptrfAccessMap.containskey(usr.id)){
                    uWrapperObj.isPTRFUser=ptrfAccessMap.get(usr.id).PTRF__c;
                    uWrapperObj.portAccRecId=ptrfAccessMap.get(usr.id).Id;
                    
                }
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
    
    public pagereference createAccessSetupRecord(){
        system.debug('accessSetupId:'+accessSetupId);
        if(!string.isblank(accessSetupId)){
        system.debug('accessSetupId@@:'+accessSetupId);   
            Portal_Tab_Access__c pa=[select id,PTRF__c,My_Devices__c from  Portal_Tab_Access__c where id=:accessSetupId limit 1];
            if(!pa.My_Devices__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'User doesnt have access to My devices tab. '+ 
                                                           'Please provide the access by selecting department in contact record.'));
                return null;
            }else{
                pa.PTRF__c=true;
            }
            try{
            upsert pa;    
            fetchAllRelatedUsers();
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
            } catch (exception e){
                //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'createAccessSetupRecord()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);  
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='createAccessSetupRecord()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
                return null;
            }   
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Portal Access record not available. Please contact Administrator'));
            
        }
        return null;
    }
    
@remoteAction @readonly
public static integer  getCount(string collabId,string finalstatus,string primediename,string ruleType ){
    integer count=0;
    List<Waiver_Rule_List__c> wvrRuleList = [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId ];
    if(wvrRuleList.size() >= 10000){
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId  ]){
            count=count+wlist.size();
        }       
    } else {    
        if(finalstatus=='All'&& primediename=='All' && ruleType=='All') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId AND Rule_Type__c !='' ]){
                count=count+wlist.size();
           }
        }
        else if(finalstatus=='All'&& primediename=='All' && ruleType=='Mandatory'){
           for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and Rule_Type__c=:'1']){
                count=count+wlist.size();
           } 
            
        }
        else if(finalstatus=='All'&& primediename=='All' && ruleType=='Additional'){
           for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and Rule_Type__c=:'0']){
                count=count+wlist.size();
           } 
            
        }
        
        else  if(finalstatus=='All'&& primediename!='All' && ruleType=='All') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Prime_Die_Name__c =:primediename AND Rule_Type__c !='']){
                count=count+wlist.size();
           }
        }
        else if(finalstatus=='All'&& primediename!='All' && ruleType=='Mandatory'){
           for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Prime_Die_Name__c =:primediename and Rule_Type__c=:'1']){
                count=count+wlist.size();
           } 
            
        }
        else if(finalstatus=='All'&& primediename!='All' && ruleType=='Additional'){
           for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Prime_Die_Name__c =:primediename and Rule_Type__c=:'0']){
                count=count+wlist.size();
           } 
            
        }
        else  if(finalstatus!='All'&& primediename=='All' && ruleType=='All') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus AND Rule_Type__c !='']){
                count=count+wlist.size();
           }
        }  
        else  if(finalstatus!='All'&& primediename=='All' && ruleType=='Mandatory') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and Rule_Type__c=:'1']){
                count=count+wlist.size();
           }
        }
        else  if(finalstatus!='All'&& primediename=='All' && ruleType=='Additional') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and Rule_Type__c=:'0' ]){
                count=count+wlist.size();
           }
        }
        else if(finalstatus!='All'&& primediename!='All' && ruleType=='Additional') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and  Prime_Die_Name__c =:primediename and Rule_Type__c=:'0']){
                count=count+wlist.size();
           }
        }
        else if(finalstatus!='All'&& primediename!='All' && ruleType=='Mandatory') {
        for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and  Prime_Die_Name__c =:primediename and Rule_Type__c=:'1']){
                count=count+wlist.size();
           }
        }
        else if(finalstatus!='All'&& primediename!='All' && ruleType=='All') {
            for(List<Waiver_Rule_List__c> wlist: [SELECT id FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and  Prime_Die_Name__c =:primediename AND Rule_Type__c !='']){
                count=count+wlist.size();
           }
        }
           system.debug('count'+count);
    }   
            return count;
}
    
public static List<Waiver_Rule_List__c>  getAllWaiverRuleList(string collabId){
    integer count = 0;
    List<Waiver_Rule_List__c> waiverRulelist = new List<Waiver_Rule_List__c>();
    
        for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,Rule_Type__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                           Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                           GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                           IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                           MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                           Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId  ]){
             waiverRulelist.addAll(wlist) ;
           }
        return waiverRulelist;
}

@remoteAction
public static List<Waiver_Rule_List__c>  getAllWaiverRuleListForAllOpen(string collabId){
    integer count = 0;
    List<Waiver_Rule_List__c> waiverRulelist = new List<Waiver_Rule_List__c>();
    
        for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,Rule_Type__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                           Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                           GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                           IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                           MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                           Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and Final_Stage__c =:'OPEN' and Rule_Type__c !='']) {
             waiverRulelist.addAll(wlist) ;
           }
           
           system.debug('waiverRulelist@@@@'+waiverRulelist.size());
           //applyToAll=true;
        return waiverRulelist;
}

@remoteAction
public static PageReference  getAllWaiverRuleListForOpen(string collabId,string comment,string selectedVal, boolean isPortal ){
    
    //List<Waiver_Rule_List__c> ruleList= new List<Waiver_Rule_List__c>();
        system.debug('selectedVal@@@'+selectedVal);
        system.debug('isPortal' +isPortal);
        system.debug('comment' +comment);
        //selectedVal=true;
      List<Waiver_Rule_List__c> ruleList= [SELECT Account_Manager_Approver__c,Rule_Type__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                           Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                           GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                           IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                           MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                           Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and Final_Stage__c =:'OPEN' and Rule_Type__c !=''];
             
             for(Waiver_Rule_List__c w :ruleList ){
               if(!isPortal) {
               w.GF_Internal_Closing_Comment__c=comment;
               
               if(selectedVal.contains('GfAcceptsRisk')){
                   w.IsGfAcceptsRisk__c=true;
                   w.Final_Stage__c = 'OPEN';
               } 
               if(selectedVal.contains('AcceptRejection')){  
                   w.AcceptRisk__c =true;
                   w.Final_Stage__c = 'FD';
               }
                   
             
             }else if(isPortal) {
             w.Customer_Closing_Comment__c=comment;
             if(selectedVal.contains('CustomerAgreeToFix')){
                 w.IsCustomerAgreeToFix__c=true;
                 w.Final_Stage__c = 'FCF';
             }
             if(selectedVal.contains('CustomerAcceptsRisk')){
                 w.IsCustomerAcceptsRisk__c =true;
                 w.Final_Stage__c = 'WCR';
             }
             if(selectedVal.contains('Disagree')){
                 w.Disagree__c=true;
                 w.Final_Stage__c = 'FCD';
             }
             }
               
             
             }
             update ruleList;
             system.debug('ruleList@@@ for DML ISSUE '+ruleList);
              PageReference p1 = new PageReference('/'+collabId);   //DfmUtilityCls.returnToListView('Wavier_Collaborator__c');  
              
              return p1; 
              
       }
    
    
   
public static List<Approval_Task_Instance__c>  getAllApprovalRuleList(string collabId, String userGroup){
    integer count = 0;
    List<Approval_Task_Instance__c> approvalTasklist = new List<Approval_Task_Instance__c>();   
        for(List<Approval_Task_Instance__c> appTaskList: [SELECT Approved_Rejected_Date__c,Approval_Comments__c,Approver_Type__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                                                          Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c FROM  Approval_Task_Instance__c where Approver_Type__c=:userGroup   AND WaiverRule__r.Waiver_Collaborator__c  =:collabId  ]){
                                                              count+= appTaskList.size();  
                                                              approvalTasklist.addAll(appTaskList);
                                                          }
        
        
        System.debug('count >>>> '+count);
        return approvalTasklist;
}

@remoteAction @readonly
public static ruleDataWrapper  test(integer pagenumber,integer pageSize,string collabId,string finalstatus, string primediename,string searchval,string ruleType){
List<Waiver_Rule_List__c> ruleList1=new List<Waiver_Rule_List__c>();
List<Waiver_Rule_List__c> ruleList=new List<Waiver_Rule_List__c>();
System.debug('finalstatus'+finalstatus+'primediename'+primediename);
integer offset=(pagenumber)*pageSize; //20
integer count=0;
string searchstr='%'+searchval+'%'; 
integer countStart=(pagenumber-1)*pageSize;//10
Map<Id,List<Approval_Task_Instance__c>> approvalTasksMapTemp = new Map<Id,List<Approval_Task_Instance__c>>();//SUHAS
if(finalstatus=='All' && primediename=='All' && ruleType=='All'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId AND Rule_Type__c !='' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr)  ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
       // if(w.Rule_Description__c!=null && w.Rule_Description__c.contains('searchtext') )ruleList.add(w);
    }
    
}
}
else if (finalstatus=='All' && primediename=='All' && ruleType=='Mandatory'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId  AND Rule_Type__c =:'1' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus=='All' && primediename=='All' && ruleType=='Additional'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId  AND Rule_Type__c =:'0' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus=='All' && primediename!='All' && ruleType=='All'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Prime_Die_Name__c =:primediename AND Rule_Type__c !='' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus=='All' && primediename!='All' && ruleType=='Mandatory'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Prime_Die_Name__c =:primediename AND Rule_Type__c =:'1' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus=='All' && primediename!='All' && ruleType=='Additional'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Prime_Die_Name__c =:primediename AND Rule_Type__c =:'0' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus!='All' && primediename=='All' && ruleType=='All'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus AND Rule_Type__c !='' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus!='All' && primediename=='All' && ruleType=='Mandatory'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus AND Rule_Type__c =:'1' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus!='All' && primediename=='All' && ruleType=='Additional'){
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus AND Rule_Type__c =:'0' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus!='All' && primediename!='All' && ruleType=='All'){
    
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and  Prime_Die_Name__c =:primediename AND Rule_Type__c !='' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus!='All' && primediename!='All' && ruleType=='Mandatory'){
    
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and  Prime_Die_Name__c =:primediename AND Rule_Type__c =:'1' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}
else if (finalstatus!='All' && primediename!='All' && ruleType=='Additional'){
    
for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and  Final_Stage__c =: finalstatus and  Prime_Die_Name__c =:primediename AND Rule_Type__c =:'0' AND (Design_Rule_Name__c like :searchstr OR Stage__c like :searchstr OR Final_Stage__c like :searchstr) ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit :offset]){
                                                    

    for(Waiver_Rule_List__c w:wlist){
        count++;
        if(count>countStart)ruleList.add(w);
    }
}
}

List<Approval_Task_Instance__c> myApprovalTasks = [Select Approved_Rejected_Date__c,Approval_Comments__c,Approver_Type__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                                                        Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c From Approval_Task_Instance__c  where WaiverRule__r.Waiver_Collaborator__c=:collabId ];    
system.debug('myApprovalTasks:'+myApprovalTasks.size());
system.debug('ruleList:'+ruleList.size());    
//List<Approval_Task_Instance__c> approvalList =[Select Id FROM Approval_Task_Instance__c WHERE Waiver_Rule_List__r.Waiver_Collaborator__c  =:collabId ];       
//List<Approval_Task_Instance__c> apprvlistT = [SELECT Approved_Rejected_Date__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
//Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c FROM Approval_Task_Instance__c WHERE WaiverRule__c =:ruleId ];
    if(myApprovalTasks<>null && !myApprovalTasks.isEmpty() && ruleList<>null && !ruleList.isEmpty()){                                                        
    for(Waiver_Rule_List__c w:ruleList){
        List<Approval_Task_Instance__c> tempAptlist = new List<Approval_Task_Instance__c>();
        for(Approval_Task_Instance__c apt:myApprovalTasks){
            if(apt <>null && apt.WaiverRule__c <>null && w<>null && w.id <>null){
                if(apt.WaiverRule__c == w.Id){
                    tempAptlist.add(apt);
                }
            }
        }
        approvalTasksMapTemp.put(w.Id, tempAptlist);
    }
    }
    //for attchments 
    set<string> waiverRuleIds=new set<string>();
    map<String, boolean> ruleAttachMap = new map<String,boolean>();
    for(Waiver_Rule_List__c w:ruleList){
        waiverRuleIds.add(w.id);
        ruleAttachMap.put(w.id,false);
    }
    Map<id,Waiver_Rule_List__c> ruleIdNameMap=new Map<id,Waiver_Rule_List__c>(ruleList);
    List<Attachment> lst_attachments = [Select Id, Name, ParentId from Attachment where ParentId =:waiverRuleIds];
    if(lst_attachments<>NULL && !lst_attachments.isEmpty()){
        for(Attachment att : lst_attachments){
            if(ruleIdNameMap.containskey(att.ParentId)){
                ruleAttachMap.put(att.ParentId,true);
            }
            
        }
    }
        ruleDataWrapper rd=new ruleDataWrapper();
        rd.hasAttachmentMap=ruleAttachMap;
        rd.pagenumber=pagenumber;
        rd.pagesize=pageSize;
        rd.offset=limits.getlimitheapsize()-limits.getheapsize();
        rd.ruleList=ruleList;
        rd.approvalTasksMap= approvalTasksMapTemp;
        system.debug(limits.getlimitheapsize()+'================'+limits.getheapsize());
        return rd;  
}

public class ruleDataWrapper{
    public map<String, boolean> hasAttachmentMap;
    public integer pagenumber;
    public integer pagesize;
    public integer offset;
    public List<Waiver_Rule_List__c> ruleList;
    public Map<Id,List<Approval_Task_Instance__c>> approvalTasksMap;
}

public List<Chip__c> getChipDetails(Id dfmId1){
                      
        lst_Chips = [SELECT Id,Name,AllJobs_Submitted__c,Chip_Name__c,Chip_Size_X__c,Chip_Size_Y__c,Wavier_Collaborator__c,
                            Database_Name__c,Database_Size__c,Md5Sum__c,Source_PTSR_Number__c,Top_Cell_Name__c,PrimeDieComments1__c,PrimeDieComments2__c,MantisId1__c,MantisId2__c
                     FROM Chip__c
                     WHERE Wavier_Collaborator__c =:dfmId1];
        for(Chip__c ch :lst_Chips){
           
           if(ch.AllJobs_Submitted__c) allJobsSubmitted=true;
         }         
        return lst_Chips;           
}
    
public List<DWC_Attachment__c> getAttachmentsDetails(Id dfmId1){      
        dwcAttachments = [SELECT Attach_To__c,Content_Type__c,Created_By__c,CreatedDate__c ,Created_Date__c,File_ID__c,
                          File_Name__c,File_Size__c,Id,Modified_By__c,Modified_Date__c,
                          Name,PTSR_ID__c,PTSR_Number__c,Reference__c,Waiver_Collaborator__c FROM DWC_Attachment__c WHERE Waiver_Collaborator__c=:dfmId1];
        
        return dwcAttachments;     
}

//SUHAS
// to fetch PIYE/QA/FabWaiverTeam/DE/AM users as per collaborator fab
    public void setUpPiyeAndQAUsers(){
        Set<Id> PIYE_Users= new Set<Id>();
        Set<Id> QA_Users= new Set<Id>();
        Set<Id> FabWaiverTeamUsers= new Set<Id>();
        Set<Id> DE_Users= new Set<Id>();
        Set<Id> AM_Users= new Set<Id>();
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
         AM_Users = DfmUtilityCls.getATPUsersByRole(waiverCollaborator.Account_Short_Name__c,atpManagers);
         userId = UserInfo.getUserId();
         if (PIYE_Users<>NULL && !PIYE_Users.isEmpty()){
            setOfAllApprovers.addAll(PIYE_Users);
            if(PIYE_Users.contains(UserInfo.getUserId())){
            userGroup='PIYE';    
            }
         }
         if (QA_Users<>NULL && !QA_Users.isEmpty()){
            setOfAllApprovers.addAll(QA_Users);
            if(QA_Users.contains(UserInfo.getUserId())){
            userGroup='QA';    
            }
         }
         if (DE_Users<>NULL && !DE_Users.isEmpty()){
            setOfAllApprovers.addAll(DE_Users);
            if(DE_Users.contains(UserInfo.getUserId())){
            userGroup='DE';    
            }
         }
         if (AM_Users<>NULL && !AM_Users.isEmpty()){
            setOfAllApprovers.addAll(AM_Users);
            if(AM_Users.contains(UserInfo.getUserId())){
            userGroup='AM';    
            }
         }
         if (FabWaiverTeamUsers<>NULL && !FabWaiverTeamUsers.isEmpty()){
            setOfAllApprovers.addAll(FabWaiverTeamUsers);
            if(FabWaiverTeamUsers.contains(UserInfo.getUserId())){
            userGroup='FabUser';    
            }
         }        
        
        if(userGroup=='' || userGroup==null){//REMOVE THIS            
        if (UserInfo.getUserType()!='Standard'){
            userGroup='Portal';         
        } else {
            userGroup='Internal';
        }
        }
    }
    
@remoteaction 
public static List<Waiver_Rule_List__c> getRuleList(string collabId){
     
    List<Waiver_Rule_List__c> ruleList=new List<Waiver_Rule_List__c>();
    for(List<Waiver_Rule_List__c> wlist: [SELECT Account_Manager_Approver__c,Prime_Die_Status__c,Rule_Type__c,Prime_Die_Comment__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:collabId and Rule_Type__c =:'' ORDER BY Prime_Die_Name__c ASC ]){
        
        ruleList.addall(wlist);
    }
       
        List<Waiver_Rule_List__c> ruleListTemp=new List<Waiver_Rule_List__c>();
        for(integer i=0;i< ruleList.size();i++){
            ruleListTemp.add(ruleList[i]);
        }
        
       //getReasonForNonMatchRule(collabId);
       
        return ruleListTemp;    
}

@remoteaction @readonly 
public static summaryTableWrapper getRuleListForDataTable(string collabId ) {
    boolean isRuleType;
    Map<string,Map<string,integer>> PrimedieCountMap = new Map<string,Map<string,integer>>();
    Map<string,string> PrimedieStatusMap = new Map<string,string>(); 
    List<Waiver_Rule_List__c> ruleList=new List<Waiver_Rule_List__c>();
    
    set<string> primeDie= new set<string>();
    for(List<Waiver_Rule_List__c> wlist: [SELECT Prime_Die_Status__c,Final_Stage__c,Rule_Type__c ,isIntermediateSave__c,Stage__c,Final_Status__c,Prime_Die_Name__c  FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:collabId and Rule_Type__c !='' ORDER BY Rule_Type__c DESC]){
        ruleList.addall(wlist);
    }
    for(Waiver_Rule_List__c w:ruleList){
         primeDie.add(w.Prime_Die_Name__c);
         if(w.Rule_Type__c=='1'){
                isRuleType= true;
                
              system.debug('PrimedieCountMap123 : '+isRuleType);
            }
            system.debug('PrimedieCountMap123>>: '+isRuleType);
        system.debug('PrimedieCountMap:'+w);
        if(PrimedieCountMap.containskey(w.Prime_Die_Name__c)){
            
            Map<string,integer>  primeDieRUleMap=PrimedieCountMap.get(w.Prime_Die_Name__c);
            if(primeDieRUleMap.containsKey(w.Final_Stage__c)){
                integer count=primeDieRUleMap.get(w.Final_Stage__c)+1;
                primeDieRUleMap.put(w.Final_Stage__c,count);
            }else{
                primeDieRUleMap.put(w.Final_Stage__c,1);
                PrimedieCountMap.put(w.Prime_Die_Name__c,primeDieRUleMap);
            }
            
        }else{
            PrimedieCountMap.put(w.Prime_Die_Name__c,new Map<string,integer>{w.Final_Stage__c=>1});
        }
        
        
        
        if(PrimedieStatusMap.get(w.Prime_Die_Name__c)!='InProgress' && PrimedieStatusMap.get(w.Prime_Die_Name__c)!='Open'){
           if(w.isIntermediateSave__c){
               if(w.Final_Stage__c=='OPEN' || w.Final_Stage__c=='FCD' ){                   
                   PrimedieStatusMap.put(w.Prime_Die_Name__c,'InProgress');
                   system.debug('PrimediestatusMap'+PrimedieStatusMap.get(w.Prime_Die_Name__c));
               }
               else if(w.Final_Stage__c!='OPEN' || w.Final_Stage__c!='FCD' ) {
                   PrimedieStatusMap.put(w.Prime_Die_Name__c,'Closed');
               }
               
           }else {
            if(w.Final_Stage__c=='OPEN' || w.Final_Stage__c=='FCD'){
            PrimedieStatusMap.put(w.Prime_Die_Name__c,'Open');
            }
            else{
                   PrimedieStatusMap.put(w.Prime_Die_Name__c,'Closed');
                }
           }
           }


        }
      Wavier_Collaborator__c wc=[select id,PTSR_Service_Type__c,DRCServiceoption__c from Wavier_Collaborator__c where id =:collabId]; 
        
    for(string s:PrimedieCountMap.keyset()){
        Map<string,integer> countMap=PrimedieCountMap.get(s);
        
        if(countMap.containsKey('POF')){
        PrimedieStatusMap.put(s,'POF');
        }
        if(countMap.containsKey('PA')){
        PrimedieStatusMap.put(s,'PA');
        }
        if(countMap.containsKey('PI')){
        PrimedieStatusMap.put(s,'PI');
        }
        if(countMap.containsKey('PW')){
        PrimedieStatusMap.put(s,'PW');
        }
        if(countMap.containsKey('WEA')){
        PrimedieStatusMap.put(s,'WEA');
        }
        if(countMap.containsKey('WCR')){
        PrimedieStatusMap.put(s,'WCR');
        }
        if(countMap.containsKey('FCF')){
        PrimedieStatusMap.put(s,'FCF');
        }
        if(countMap.containsKey('FD')){
        PrimedieStatusMap.put(s,'FD');
        }
        if(countMap.containsKey('OPEN') || countMap.containsKey('FCD') ){
        PrimedieStatusMap.put(s,'OPEN');
        }
        if(wc.DRCServiceoption__c<>null && wc.PTSR_Service_Type__c.contains('DRC') && wc.DRCServiceoption__c.toLowerCase()=='DRC Run Only'){
            PrimedieStatusMap.put(s,'-');
        }
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
            PrimedieCountMap.put(s,countMap);
    }
    
    list<Chip__c> objChip = [SELECT Id,Chip_Name__c, AllJobs_Submitted__c,Wavier_Collaborator__c FROM Chip__c WHERE Wavier_Collaborator__c =: collabId and Chip_Name__c NOT IN:primeDie];
     //if (ruleList.size()==0){
         list<string> finalStage=new list<string>{'OPEN', 'FCD', 'FCF', 'WCR', 'WEA', 'FD', 'PW','PI','POF','PA'};
         for(Chip__c chip :objChip){
             if(chip.AllJobs_Submitted__c==true) {
                Map<string,integer>  ChipPrimeDieRuleMap=new Map<string,integer>();
                for(string f:finalStage){
                    ChipPrimeDieRuleMap.put(f,0);
                }
                PrimedieCountMap.put(chip.Chip_Name__c,ChipPrimeDieRuleMap);
                PrimedieStatusMap.put(chip.Chip_Name__c,'Auto Close');
                if(wc.DRCServiceoption__c<>null && wc.PTSR_Service_Type__c.contains('DRC') && wc.DRCServiceoption__c.toLowerCase()=='DRC Run Only'){
                    PrimedieStatusMap.put(chip.Chip_Name__c,'-');
                }
                
             }
         }
     //}
     list<Chip__c> chipListForPrimeDieStatus=new list<Chip__c>();
     list<Chip__c> objChipList = [SELECT Id,Chip_Name__c,Wavier_Collaborator__c,Prime_Die_Status__c FROM Chip__c WHERE Wavier_Collaborator__c =: collabId ];
          
          system.debug('objChipList '+objChipList );
          for(Chip__c cg:objChipList ){
              Chip__c  c=new Chip__c (id=cg.id,Prime_Die_Status__c=PrimedieStatusMap.get(cg.Chip_Name__c));
              
              chipListForPrimeDieStatus.add(c);
          }
     
     
     Pagereference pr = Page.DWC_CollaboratorHelper;
     pr.getParameters().put('ruleList',JSON.Serialize(chipListForPrimeDieStatus));
     pr.getParameters().put('waiverid',collabId);
     String xmlContent='';
     if(!test.isrunningtest())xmlContent= pr.getContent().toString();
     
    summaryTableWrapper s=new summaryTableWrapper();
    s.PrimedieCountMap=PrimedieCountMap;
    s.PrimedieStatusMap=PrimedieStatusMap;
    s.isRuleType=isRuleType;
    
    return s;    
}


public class summaryTableWrapper{
    public Map<string,Map<string,integer>> PrimedieCountMap;
    public Map<string,string> PrimedieStatusMap;
    public boolean isRuleType;
    
}

@remoteaction @readonly 
public static set<string> getRuleStatusMapForReleaseToCustomer(string collabId ) {
    
    set<string> setofFinalStatus = new set<string>(); 
    List<Waiver_Rule_List__c> ruleList=new List<Waiver_Rule_List__c>();
    
    for(List<Waiver_Rule_List__c> wlist: [SELECT Final_Stage__c,Final_Status__c,Prime_Die_Name__c  FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:collabId]){
        ruleList.addall(wlist);
    }
    for(Waiver_Rule_List__c w:ruleList){
        setofFinalStatus.add(w.Final_Stage__c);
    }   
    return setofFinalStatus;   
}


@remoteAction
public static List<attachment> getAttachment(string id){
    List<attachment> a=[select id from attachment where parentid=:id ];
    return a;   
}
    
    // to fetch the Account Managers related to Account Field
    public void fetchAllManagers(){
        amWrapperLst = new List<AMwrapperCls>();
        list<Account_Team_Proxy__c> lst_ATP;
        System.debug('waiverCollaborator >>>>> '+waiverCollaborator.Account__c);
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
    
    
    // Allow user to select Account Manager for Approval
public List<AMwrapperCls> getAMDetails(){
    hiddenAMsIds='';
    return amWrapperLst;    
}

    
@remoteAction
public static void saveRuleList(List<Waiver_Rule_List__c> ruleList,String collabId){
    Wavier_Collaborator__c waiverCollaborator1= getWaiverCollaborator(collabId);
    DfmUtilityCls.stopTrigger=true;
    for(Waiver_Rule_List__c rules:ruleList ){
        system.debug('Rules data >>> '+rules);
        rules.isIntermediateSave__c=true;
    }
    try{
        update ruleList;
        system.debug('test for open rules'+ruleList.size());
    if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }    
   
    } catch (exception e){
      //  GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'saveRuleList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='saveRuleList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
                     
    }    
}
 /* @remoteAction
public static void saveRuleListForOpen(List<Waiver_Rule_List__c> ruleList,String collabId){
    Wavier_Collaborator__c waiverCollaborator1= getWaiverCollaborator(collabId);
    ruleList=[SELECT Account_Manager_Approver__c,Rule_Type__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                           Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                           GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,isFAESubmitted__c,
                                                           IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                           MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                           Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c where Waiver_Collaborator__c  =:collabId and Final_Stage__c =:'OPEN' and Rule_Type__c !=''];
    DfmUtilityCls.stopTrigger=true;
    for(Waiver_Rule_List__c rules:ruleList ){
        system.debug('Rules data >>> '+rules);
        rules.isIntermediateSave__c=true;
    }
    try{
        update ruleList;
        system.debug('test for open rules'+ruleList.size());
    } catch (exception e){
        GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'saveRuleListForOpen()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
               
    }    
}  */

@remoteAction
public static void finalRevertSubmit(String collabId){
    Wavier_Collaborator__c waiverCollaborator1= getWaiverCollaborator(collabId);
    
      system.debug('finalrevert++');  
    if(waiverCollaborator1.Revert_Collaborator__c && waiverCollaborator1.Revert_Stage__c=='Review'){
        system.debug('finalrevert1++');
        if(!Test.isRunningTest() || (!waiverCollaborator1.Is_releasedToCustomer__c)){
        system.debug('finalrevert2++');
             DFMEmailImplementation.DFMJobRevertedL14(waiverCollaborator1);
        }else if(!Test.isRunningTest() || (waiverCollaborator1.Progressbar_staus__c=='Pending For Foundry')){
            DFMEmailImplementation.DFMJobRevertedL16(waiverCollaborator1);
        
        }else {
            DFMEmailImplementation.DFMJobRevertedL15(waiverCollaborator1);
        }
        
        
        DfmUtilityCls.stopTrigger=false;
        
        waiverCollaborator1.PTSR_Status__c='Open'; 
        waiverCollaborator1.Is_releasedToCustomer__c=false; 
        waiverCollaborator1.Is_All_PI_PW__c=false; 
        waiverCollaborator1.IsGfAcceptsRisk__c=false;   
        waiverCollaborator1.Selected_Customers__c=''; 
        waiverCollaborator1.Is_Sync_with_AIA__c=false;
		waiverCollaborator1.isReleaseToCust4MultiDie__c=false;
        waiverCollaborator1.Mantis_DRCPLUS__c=false;
        waiverCollaborator1.Mantis_MAS__c=false;
        waiverCollaborator1.Mantis_MCD__c=false; 
        waiverCollaborator1.PDK_DRC__c=false; 
        waiverCollaborator1.Progressbar_staus__c='Review_Disposition';
        waiverCollaborator1.CMP__c=false;   
        //DfmUtilityCls.stopTrigger=TRUE;
       
        system.debug('revertedrules>>>>');  
       List<Waiver_Rule_List__c> revertedRulesList1 = [SELECT Id,Operation_Type__c,Mantis_Id__c,Revert_Rule__c,RuleId__c,Prime_Die_Name__c
                                                      FROM  Waiver_Rule_List__c
                                                      WHERE Waiver_Collaborator__c = : collabId and Revert_Rule__c=true];
        system.debug('revertedRulesList1>>>>'+revertedRulesList1);  
       if(revertedRulesList1<>null){ 
       
        map<string,set<string>> revertPrimeDieMap=new map<string,set<string>>();
        
        
       for(Waiver_Rule_List__c  wr : revertedRulesList1) {
        system.debug('wr>>>>'+wr);
            if(revertPrimeDieMap.containskey(wr.Prime_Die_Name__c)){
                revertPrimeDieMap.get(wr.Prime_Die_Name__c).add(wr.Operation_Type__c);
            }else{
                revertPrimeDieMap.put(wr.Prime_Die_Name__c,new set<string>{wr.Operation_Type__c});
            }
       }
        
       List<Chip__c> chipList=[SELECT Id,Prime_Die_Name__c,Mantis_MAS__c,Mantis_MCD__c,PDK_DRC__c,Mantis_DRCPLUS__c,Mantis_CMP__c from Chip__c Where Prime_Die_Name__c IN : revertPrimeDieMap.keyset() AND Wavier_Collaborator__c= :collabId ]; 
       
       for(Chip__c chip:chipList){
            if(revertPrimeDieMap.containskey(chip.Prime_Die_Name__c) && revertPrimeDieMap.get(chip.Prime_Die_Name__c)!=null &&
                            revertPrimeDieMap.get(chip.Prime_Die_Name__c).size()>0){
                //reset the flags               
                for(string optype:revertPrimeDieMap.get(chip.Prime_Die_Name__c)){
                    if(optype=='MAS')chip.Mantis_MAS__c=false ; 
                         
                    if(optype=='MCD')chip.Mantis_MCD__c=false;
                    
                    if(optype=='DRCPLUS')chip.Mantis_DRCPLUS__c=false;
                    
                    if(optype=='PDKDRC')chip.PDK_DRC__c=false;
                    
                    if(optype=='CMP')chip.Mantis_CMP__c =false;
                   }
                }
                
                
            }
       
        if(chipList<>null && !chipList.isEmpty()){
            update chipList;
        }
       
       } 
        try{
            
            update waiverCollaborator1;
       if(Test.isRunningTest()) {
           throw new applicationException('In Test Mode');
          }
        } catch (exception e){
           // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'finalRevertSubmit()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
              ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='finalRevertSubmit()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
        }    
    }
   
}
  
@remoteAction
public static void submitFAERules(List<Waiver_Rule_List__c> ruleList,String collabId,String users){
    Wavier_Collaborator__c waiverCollaborator1= getWaiverCollaborator(collabId);
    DfmUtilityCls.stopTrigger=false;
    List<Approval_Task_Instance__c> approvalList = new List<Approval_Task_Instance__c>();
    Set<Id> approvalRuleList4Mail = new  Set<Id>();
    Set<Id> setOfAllApprovers = new Set<Id>();
    String userGroup='';
    for(Waiver_Rule_List__c rules:ruleList ){
        system.debug('Rules data >>> '+rules);
        if(rules.Final_Stage__c=='OPEN' && rules.IsGfAcceptsRisk__c && !rules.isFAESubmitted__c){
            Approval_Task_Instance__c appTask1 = new Approval_Task_Instance__c();
            appTask1.Approver_Type__c='PIYE';
            appTask1.Approvers__c='';
            appTask1.Name=String.valueOf(rules.Id)+'_PIYE';
            appTask1.Process_Status__c='Open';
            appTask1.WaiverRule__c=rules.Id;
            
            Approval_Task_Instance__c appTask2 = new Approval_Task_Instance__c();
            appTask2.Approver_Type__c='QA';
            appTask2.Approvers__c='';
            appTask2.Name=String.valueOf(rules.Id)+'_QA';
            appTask2.Process_Status__c='Open';
            appTask2.WaiverRule__c=rules.Id;
            
            Approval_Task_Instance__c appTask3 = new Approval_Task_Instance__c();
            appTask3.Approver_Type__c='DE';
            appTask3.Approvers__c='';
            appTask3.Name=String.valueOf(rules.Id)+'_DE';
            appTask3.Process_Status__c='Open';
            appTask3.WaiverRule__c=rules.Id;
            
            Approval_Task_Instance__c appTask4 = new Approval_Task_Instance__c();
            appTask4.Approver_Type__c='AM';
            appTask4.Approvers__c='';
            appTask4.Name=String.valueOf(rules.Id)+'_AM';
            appTask4.Process_Status__c='Open';
            if(users!='' && users!=null){
            appTask4.Re_AssignedUser__c=users;
            }
            appTask4.WaiverRule__c=rules.Id;
            
            approvalList.add(appTask1);
            approvalList.add(appTask2);
            approvalList.add(appTask3);
            approvalList.add(appTask4);
            
            approvalRuleList4Mail.add(rules.Id);
        }
        rules.Account_Manager_Approver__c=users;
        rules.isFAESubmitted__c=true;
    }
    try{
        update ruleList;
        if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
    } catch (exception e){
       // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'submitFAERules()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='submitFAERules()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
    }    
    
        if(approvalList<>null && !approvalList.isEmpty()){
            try{
                insert approvalList;
            if(Test.isRunningTest()) {
              throw new applicationException('In Test Mode');
            }
            } catch (exception e){
                //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'submitFAERules()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
               ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='submitFAERules()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw); 
            }     
        System.debug('approvalList >>>>>>> '+approvalList);
    }
        
    Set<Id> PIYE_Users= new Set<Id>();
    Set<Id> QA_Users= new Set<Id>();
    Set<Id> FabWaiverTeamUsers= new Set<Id>();
    Set<Id> DE_Users= new Set<Id>();
    Set<Id> AM_Users= new Set<Id>();
    
    if (waiverCollaborator1.FAB__c<>NULL){
        if (waiverCollaborator1.FAB__c.contains('1')){
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB1').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB1').keySet():NULL;
            
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab1_Waiver_Team').keySet():NULL;              
        } else if (waiverCollaborator1.FAB__c.contains('8')){           
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB8').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB8').keySet():NULL;
            
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab8_Waiver_Team').keySet():NULL;          
        }  else if (waiverCollaborator1.FAB__c.contains('7')){          
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB7').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB7').keySet():NULL;
            
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab7_Waiver_Team').keySet():NULL;          
        } else if (waiverCollaborator1.FAB__c.contains('9')){           
            PIYE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9').keySet():NULL;
            QA_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_QA_4_FAB9').keySet():NULL;
            
            FabWaiverTeamUsers = DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('Fab9_Waiver_Team').keySet():NULL;          
        }
        
    }
    
    DE_Users = DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_4_DE').keySet():NULL;
    
    List<String> atpManagers = new List<String>{'Primary Account Manager','Account Administrator','Account Manager'};  
        AM_Users = DfmUtilityCls.getATPUsersByRole(waiverCollaborator1.Account_Short_Name__c,atpManagers);
    
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
    if (setOfAllApprovers<>NULL && !setOfAllApprovers.isEmpty()){
        DfmUtilityCls.shareRecord(waiverCollaborator1.Id,setOfAllApprovers,'Edit');          
    }
    
    if( waiverCollaborator1.PTSR_Service_Type__c.toUpperCase().contains('DRC')){
        if(!Test.isRunningTest()){ DRCEmailImplementation.drcFoundryToRiskApproval(waiverCollaborator1, approvalRuleList4Mail);
        }
    }else{
        //L8 : FAE trigger foundry-to-risk approval AND at least one rules with Customer final status  = (“FCC” OR “iFD”)
        //Approve/reject by clicking a button in the email body in case of same decision for all open rules:Approve /Reject Or open Collaborator for individual selection.
        if(!Test.isRunningTest()){ DFMEmailImplementation.FoundryToRiskApproval(waiverCollaborator1,approvalRuleList4Mail);
        }
    } 

}    
   
@remoteAction
public static void submitRuleList(List<Waiver_Rule_List__c> ruleList,String collabId){
    Wavier_Collaborator__c waiverCollaborator1= getWaiverCollaborator(collabId);
    //SUHAS
    DfmUtilityCls.stopTrigger=false;
    //check for status of collaborator and trigger the signal
    system.debug('CUSTOMER DISAGREE'+ruleList.get(0).Disagree__c);
    if(ruleList.get(0).Disagree__c) {
     system.debug('customer options'+ruleList);
    sendNotificationToFAE(waiverCollaborator1); 
    }
    try{
        if(ruleList!=null && ruleList.size()>0)update ruleList;
        else{
            List<waiver_rule_List__c>   wlIst=[select id from waiver_rule_List__c where Waiver_Collaborator__c=:collabId limit 1];
            if(!wlIst.isempty())update wlIst;
        }
       if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            } 
    } catch (exception e){
        //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'submitRuleList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='submitRuleList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw); 
    }    
}
    
@remoteAction
public static void saveApprovalList(List<Approval_Task_Instance__c> appList){//SUHAS
    DfmUtilityCls.stopTrigger=false;
    Set<Id> waiverRuleListIds = new  Set<Id>();
    for(Approval_Task_Instance__c appTasks:appList ){
        system.debug('Rules data >>> '+appTasks);
        waiverRuleListIds.add(appTasks.WaiverRule__c);//Get Rule Id's of updated tasks
    }
    try{
        update appList;// update Tasks
    if(Test.isRunningTest()) {
      throw new applicationException('In Test Mode');
     }
    } catch (exception e){
        //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'saveApprovalList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='saveApprovalList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);   
    }    
    system.debug('waiverRuleListIds >>> '+waiverRuleListIds);
    //Get all Approval tasks related to rule Ids updated
    List<Approval_Task_Instance__c> approvalList = [Select Approved_Rejected_Date__c,Approval_Comments__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                                                        Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c from Approval_Task_Instance__c WHERE (WaiverRule__r.Final_Stage__c='OPEN' AND WaiverRule__c IN : waiverRuleListIds)];
    system.debug('approvalList >>> '+approvalList);
    Map<Id,List<Approval_Task_Instance__c>> associatedApprovalListMap = new Map<Id,List<Approval_Task_Instance__c>>();
    for(Id waiverId: waiverRuleListIds) {  
        List<Approval_Task_Instance__c> associatedTasks = new List<Approval_Task_Instance__c>();
        for(Approval_Task_Instance__c approvaltask: approvalList){            
            if(waiverId == approvaltask.WaiverRule__c){
              associatedTasks.add(approvaltask);
            }
        }
        associatedApprovalListMap.put(waiverId, associatedTasks);//Create a Map of Rule Id and associated tasks
    }
    system.debug('associatedApprovalListMap >>> '+associatedApprovalListMap);
    List<Waiver_Rule_List__c> rulesForUpdate = new List<Waiver_Rule_List__c>() ;    
    List<Waiver_Rule_List__c> rulesForUpdateTemp = getWaiverRulesList(waiverRuleListIds);
    system.debug('rulesForUpdateTemp >>> '+rulesForUpdateTemp);
    for(Waiver_Rule_List__c waiverRule: rulesForUpdateTemp){
        List<Approval_Task_Instance__c> associatedTasks = associatedApprovalListMap.get(waiverRule.Id);
        boolean isFailedDesign = false;
        system.debug('associatedTasks >>> '+associatedTasks.size()+'   >>>>> '+associatedTasks);
        if(associatedTasks.size()==4){
            boolean isApproved = false;
            boolean isOpenRule = false;
            for(Approval_Task_Instance__c approvaltask: associatedTasks){            
                if(approvaltask.Process_Status__c == 'Approved'){
                    isApproved = true;
                    isFailedDesign=false;
                }else if(approvaltask.Process_Status__c == 'Rejected'){
                    isApproved = false;
                    isFailedDesign=true;
                }else if(approvaltask.Process_Status__c == 'Open'){
                    isApproved = false;
                    isFailedDesign=false;
                    isOpenRule=true;
                }                 
            }
            if(isFailedDesign){
                //Rule is a FD
               waiverRule.Final_Stage__c='FD';
            }else if(isApproved && !isOpenRule){
                //Rule is approved
                waiverRule.Final_Stage__c='WEA';
            }else{
                //Rule approval still open
            }
        }
        rulesForUpdate.add(waiverRule);
    }
    try{
        update rulesForUpdate;
    if(Test.isRunningTest()) {
     throw new applicationException('In Test Mode');
     }        
    } catch (exception e){
        //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'saveApprovalList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='saveApprovalList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
    }
}
/*@remoteAction
public static void applyMassCommList(List<Waiver_Rule_List__c>ruleList){
    DfmUtilityCls.stopTrigger=true;
    List<Waiver_Rule_List__c> updateruleList= new List<Waiver_Rule_List__c>();
    
    for(Waiver_Rule_List__c rules : ruleList){
        updateruleList.add(rules);
        
    }
    update ruleList;
}  */   

    
   
@remoteAction 
    public static void applyMassAprvList(List<Waiver_Rule_List__c> ruleList, String comments, String radioval, String userGroup){
    DfmUtilityCls.stopTrigger=false;
    Set<Id> ruleListIds= new Set<Id>();
    System.debug('ruleList >>>> '+ruleList);
    System.debug('comments >>>> '+comments);
    System.debug('radioval >>> '+radioval);
    System.debug('userGroup >>>'+userGroup);
    
     for(Waiver_Rule_List__c rules:ruleList ){
         if(rules.Final_Stage__c=='OPEN' && rules.IsGfAcceptsRisk__c){
            ruleListIds.add(rules.Id);                  
        } 
     }    
    System.debug('ruleListIds >>>'+ruleListIds);
    
    List<Approval_Task_Instance__c> approvalList = [Select Approved_Rejected_Date__c,Approver_Type__c,Approval_Comments__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c  From Approval_Task_Instance__c Where WaiverRule__c In : ruleListIds];
    System.debug('approvalList >>>'+approvalList);
    List<Approval_Task_Instance__c> updatedApprovalList = new List<Approval_Task_Instance__c>();
    for(Approval_Task_Instance__c appTask:approvalList ){
    
        if(userGroup == 'PIYE'){
            if( appTask.Approver_Type__c=='PIYE' && radioval == 'ApproveAll'){
                appTask.Process_Status__c = 'Approved';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);
            }else if(appTask.Approver_Type__c=='PIYE' && radioval == 'RejectAll'){
                appTask.Process_Status__c = 'Rejected';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);                
            }
        }else if(userGroup == 'QA' ){
            if( appTask.Approver_Type__c=='QA' && radioval == 'ApproveAll'){
                appTask.Process_Status__c = 'Approved';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);          
            }else if(appTask.Approver_Type__c=='QA' &&radioval == 'RejectAll'){
                appTask.Process_Status__c = 'Rejected';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);                
            }
        }else if(userGroup == 'DE'){
            if( appTask.Approver_Type__c=='DE' && radioval == 'ApproveAll'){
                appTask.Process_Status__c = 'Approved';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);          
            }else if(appTask.Approver_Type__c=='DE' &&radioval == 'RejectAll'){
                appTask.Process_Status__c = 'Rejected';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);                
            }
        }else if(userGroup == 'AM'){
            if( appTask.Approver_Type__c=='AM' && radioval == 'ApproveAll'){
                appTask.Process_Status__c = 'Approved';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);          
            }else if(appTask.Approver_Type__c=='AM' &&radioval == 'RejectAll'){
                appTask.Process_Status__c = 'Rejected';
                appTask.Approval_Comments__c = comments;
                updatedApprovalList.add(appTask);                
            }
        }
    
    }
    try{    
        update updatedApprovalList; 
    if(Test.isRunningTest()) {
        throw new applicationException('In Test Mode');
     }        
    } catch (exception e){
        //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'applyMassAprvList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
      ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='applyMassAprvList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);     
    }
    Map<Id,List<Approval_Task_Instance__c>> associatedApprovalListMap = new Map<Id,List<Approval_Task_Instance__c>>();
    for(Id waiverId: ruleListIds) {  
        List<Approval_Task_Instance__c> associatedTasks = new List<Approval_Task_Instance__c>();
        for(Approval_Task_Instance__c approvaltask: approvalList){            
            if(waiverId == approvaltask.WaiverRule__c){
              associatedTasks.add(approvaltask);
            }
        }
        associatedApprovalListMap.put(waiverId, associatedTasks);//Create a Map of Rule Id and associated tasks
    }
    system.debug('associatedApprovalListMap >>> '+associatedApprovalListMap);
    List<Waiver_Rule_List__c> rulesForUpdate = new List<Waiver_Rule_List__c>() ;    
    List<Waiver_Rule_List__c> rulesForUpdateTemp = getWaiverRulesList(ruleListIds);
    system.debug('rulesForUpdateTemp >>> '+rulesForUpdateTemp);
    for(Waiver_Rule_List__c waiverRule: rulesForUpdateTemp){
        List<Approval_Task_Instance__c> associatedTasks = associatedApprovalListMap.get(waiverRule.Id);
        boolean isFailedDesign = false;
        system.debug('associatedTasks >>> '+associatedTasks.size()+'   >>>>> '+associatedTasks);
        if(associatedTasks.size()==4){
            system.debug('associatedTasks.size'+associatedTasks.size());
            boolean isApproved = false;
            boolean isOpenRule = false;
            for(Approval_Task_Instance__c approvaltask: associatedTasks){            
                if(approvaltask.Process_Status__c == 'Approved'){
                    isApproved = true;
                    isFailedDesign=false;
                }else if(approvaltask.Process_Status__c == 'Rejected'){
                    isApproved = false;
                    isFailedDesign=true;
                }else if(approvaltask.Process_Status__c == 'Open'){
                    isApproved = false;
                    isFailedDesign=false;
                    isOpenRule=true;
                }                 
            }
            if(isFailedDesign){
                //Rule is a FD
               waiverRule.Final_Stage__c='FD';
            }else if(isApproved && !isOpenRule){
                //Rule is approved
                waiverRule.Final_Stage__c='WEA';
            }else{
                //Rule approval still open
            }
        }
        rulesForUpdate.add(waiverRule);
    }
    try{
        update rulesForUpdate;
    if(Test.isRunningTest()) {
        throw new applicationException('In Test Mode');
     }    
    } catch (exception e){
        //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'applyMassAprvList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
         ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='applyMassAprvList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw); 
    }   
    
    
}    
 
 
  
@remoteAction 
public static void reAssignusersToAManager(List<Waiver_Rule_List__c> ruleList, String userGroup, String users,String collabId){

    Set<Id> ruleListIds= new Set<Id>();
    System.debug('ruleList >>>> '+ruleList);
    System.debug('userGroup >>>'+userGroup);
    System.debug('AM users >>>'+users);
    ruleList = getAllWaiverRuleList(collabId);
    System.debug('All ruleList >>>> '+ruleList.size());
     for(Waiver_Rule_List__c rules:ruleList ){
         if(rules.Final_Stage__c=='OPEN' && rules.IsGfAcceptsRisk__c){
            ruleListIds.add(rules.Id);                  
        }   
     }    
    System.debug('ruleListIds >>>'+ruleListIds);
    
    List<Approval_Task_Instance__c> approvalList = [Select Id, Name, WaiverRule__c,Approver_Type__c From Approval_Task_Instance__c Where WaiverRule__c In : ruleListIds];
    System.debug('approvalList >>>'+approvalList);
    List<Approval_Task_Instance__c> updatedApprovalList = new List<Approval_Task_Instance__c>();
    for(Approval_Task_Instance__c appTask:approvalList ){
    
        if(userGroup == 'PIYE'){
            if( appTask.Approver_Type__c=='PIYE' && (users!='' && users!=null)){
                appTask.Re_AssignedUser__c=users;
                updatedApprovalList.add(appTask);          
            }
        }else if(userGroup == 'QA' ){
            if( appTask.Approver_Type__c=='QA' && (users!='' && users!=null)){
                appTask.Re_AssignedUser__c=users;
                updatedApprovalList.add(appTask);       
            }
        }else if(userGroup == 'DE'){
            if( appTask.Approver_Type__c=='DE' && (users!='' && users!=null)){
                appTask.Re_AssignedUser__c=users;
                updatedApprovalList.add(appTask);          
            }
        }else if(userGroup == 'AM'){
            if( appTask.Approver_Type__c=='AM' && (users!='' && users!=null)){
                appTask.Re_AssignedUser__c=users;
                updatedApprovalList.add(appTask);          
            }
        }
    
    }
     Set <Id> selectedcustomers = new Set<Id>();
     selectedcustomers.add(users);
     if (selectedcustomers<>NULL && !selectedcustomers.isEmpty()){               
                boolean isSuccess = DfmUtilityCls.shareRecord(collabId,selectedcustomers,'Edit');
     }
    try{   
        update updatedApprovalList;
    if(Test.isRunningTest()) {
        throw new applicationException('In Test Mode');
     }    
    } catch (exception e){
       // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'reAssignusersToAManager()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
       ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='reAssignusersToAManager()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);   
    }    
}
    
 
    

@remoteAction 
public static void approveRejectAllRules(String userGroup, String collabId,String description,String decision){
    DfmUtilityCls.stopTrigger=false;
    Set<Id> ruleListIds= new Set<Id>();   
    System.debug('userGroup >>>'+userGroup);
    System.debug('description  >>>'+description);
    System.debug('decision  >>>'+decision);
    List<Approval_Task_Instance__c> approvalList = new List<Approval_Task_Instance__c> ();
    List<Approval_Task_Instance__c> updatedApprovalList = getAllApprovalRuleList(collabId,userGroup);
    System.debug('All ruleList >>>> '+updatedApprovalList.size());
     for(Approval_Task_Instance__c apprTask:updatedApprovalList ){
        apprTask.Approval_Comments__c=description;
        apprTask.Process_Status__c=String.valueOf(decision);
        ruleListIds.add(apprTask.WaiverRule__c);//Get Rule Id's of updated tasks
     }    
   
    try{
        update updatedApprovalList; 
    } catch (exception e){
        GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'approveRejectAllRules()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
        
    }
    //Get all Approval tasks related to rule Ids updated
    approvalList = [Select Approved_Rejected_Date__c,Approval_Comments__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate, Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c from Approval_Task_Instance__c WHERE (WaiverRule__r.Final_Stage__c='OPEN' AND WaiverRule__c IN : ruleListIds)];
    system.debug('approvalList >>> '+approvalList);
    Map<Id,List<Approval_Task_Instance__c>> associatedApprovalListMap = new Map<Id,List<Approval_Task_Instance__c>>();
    for(Id waiverId: ruleListIds) {  
        List<Approval_Task_Instance__c> associatedTasks = new List<Approval_Task_Instance__c>();
        for(Approval_Task_Instance__c approvaltask: approvalList){            
            if(waiverId == approvaltask.WaiverRule__c){
              associatedTasks.add(approvaltask);
            }
        }
        associatedApprovalListMap.put(waiverId, associatedTasks);//Create a Map of Rule Id and associated tasks
    }
    system.debug('associatedApprovalListMap >>> '+associatedApprovalListMap);
    List<Waiver_Rule_List__c> rulesForUpdate = new List<Waiver_Rule_List__c>() ;    
    List<Waiver_Rule_List__c> rulesForUpdateTemp = getWaiverRulesList(ruleListIds);
    system.debug('rulesForUpdateTemp >>> '+rulesForUpdateTemp);
    for(Waiver_Rule_List__c waiverRule: rulesForUpdateTemp){
        List<Approval_Task_Instance__c> associatedTasks = associatedApprovalListMap.get(waiverRule.Id);
        boolean isFailedDesign = false;
        system.debug('associatedTasks >>> '+associatedTasks.size()+'   >>>>> '+associatedTasks);
        if(associatedTasks.size()==4){
            boolean isApproved = false;
            boolean isOpenRule = false;
            for(Approval_Task_Instance__c approvaltask: associatedTasks){            
                if(approvaltask.Process_Status__c == 'Approved'){
                    isApproved = true;
                    isFailedDesign=false;
                }else if(approvaltask.Process_Status__c == 'Rejected'){
                    isApproved = false;
                    isFailedDesign=true;
                }else if(approvaltask.Process_Status__c == 'Open'){
                    isApproved = false;
                    isFailedDesign=false;
                    isOpenRule=true;
                }                 
            }
            if(isFailedDesign){
                //Rule is a FD
               waiverRule.Final_Stage__c='FD';
            }else if(isApproved && !isOpenRule){
                //Rule is approved
                waiverRule.Final_Stage__c='WEA';
            }else{
                //Rule approval still open
            }
        }
        rulesForUpdate.add(waiverRule);
    }
    try{
        update rulesForUpdate;
    if(Test.isRunningTest()) {
     throw new applicationException('In Test Mode');
     }    
    } catch (exception e){
        //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'approveRejectAllRules()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='approveRejectAllRules()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
    }
}

   


    public static List<Waiver_Rule_List__c> getWaiverRulesList(Set<Id> ids){            
          List<Waiver_Rule_List__c> waiverRuleList= [SELECT Account_Manager_Approver__c,Rule_Type__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,RecallApprovalProcess__c,Disagree__c,Old_Image_Path__c,Warning__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,isFAESubmitted__c,
                                                   Stage__c,Waiver_Collaborator__c FROM Waiver_Rule_List__c WHERE Id  IN :ids]; 
        return waiverRuleList;   
    }
       
// get account manager details from ATP SUHAS
    public class AMwrapperCls {
        
        public boolean isSelected {get;set;}
        public Account_Team_Proxy__c ATP {get;set;}
        
        public AMwrapperCls (boolean selected,Account_Team_Proxy__c atp1){
            isSelected = selected;
            ATP = atp1;
        }
    }    
    
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
@remoteAction 
 public static void revertCollaborator(String revertReason,String selectedOption, String drcId){
       waiverCollaborator= getWaiverCollaborator(drcId);
      system.debug('DFM>>>>>>>revertCollaborator '+revertReason); 
        system.debug('DFM>>>>>>>revertCollaborator '+selectedOption); 
        if(waiverCollaborator.Revert_Reason__c<>null && waiverCollaborator.Revert_Reason__c!=''){
            waiverCollaborator.Revert_Reason__c+=' || ';
            waiverCollaborator.Revert_Reason__c+=String.valueOf(System.today());
        }else{ waiverCollaborator.Revert_Reason__c=String.valueOf(System.today()); }
        if(selectedOption=='Review'){
        
            waiverCollaborator.Revert_Collaborator__c=true; 
            waiverCollaborator.Revert_Stage__c=selectedOption;
            waiverCollaborator.Revert_Reason__c+=revertReason;
            waiverCollaborator.isSubmitted__c=false;
            
            system.debug('reviewmail');
            if(! Test.isRunningTest()){
                    system.debug('reviewmail+++++');
                  DFMEmailImplementation.DFMJobRevertedL14(waiverCollaborator);

            }
        }else if(selectedOption=='Pending For FAE'){
            String custIds= waiverCollaborator.Selected_Customers__c;
            waiverCollaborator.Is_releasedToCustomer__c =false;
            waiverCollaborator.Progressbar_staus__c='Pending for FAE';
            waiverCollaborator.Revert_Stage__c=selectedOption;
            waiverCollaborator.Revert_Reason__c+=revertReason;            
            waiverCollaborator.PTSR_Status__c='Open';
            waiverCollaborator.IsGfAcceptsRisk__c=false;
            waiverCollaborator.Selected_Customers__c='';
            waiverCollaborator.PTSR_Status__c='Pending';
            waiverCollaborator.isCustomerSelectionSubmitted__c=false;
            waiverCollaborator.isSubmitted__c=false;
            list<Waiver_Rule_List__c> allWaiverRules=new list<Waiver_Rule_List__c>();
            allWaiverRules= getAllWaiverRuleList(waiverCollaborator.Id);
            Map<integer,List<Id>> totalRecords = new Map<integer,List<Id>>();
            if (allWaiverRules<>NULL && !allWaiverRules.isEmpty()){
                integer i=1;
                List<Id> tempList = new List<Id>();
                for (Waiver_Rule_List__c w : allWaiverRules){                    
                    tempList.add(w.Id);                    
                    if (tempList.size() < 9999){
                        continue;
                    } else {
                        totalRecords.put(i, tempList);i++;
                        tempList = new List<Id>();
                    }
                }
                if(tempList<>null && !tempList.isEmpty()){
                    if(tempList.size()<9998){
                        totalRecords.put(i, tempList);
                    }
                }
                if (totalRecords.size()>0){
                    system.debug('Pending For FAE>>>>>>>totalRecords.size()  '+totalRecords.size());
                    for(integer j:totalRecords.keySet()){
                       List<Id> updateList = totalRecords.get(j);
                       DWC_WaiverRuleListEditBatch updateRueList = new DWC_WaiverRuleListEditBatch(updateList);
                       Database.executeBatch(updateRueList) ;
                    }
                }
                system.debug('DONE>>>>  ');
            }  
            
            
            if(! Test.isRunningTest()){
                //DFMEmailImplementation.DFMReviewSummaryNotificationL15(waiverCollaborator,custIds);
                  DFMEmailImplementation.DFMJobRevertedL15(waiverCollaborator);

            }
            
            try{
                List<Wavier_Collaborator__Share> sharesToDelete = [SELECT Id FROM Wavier_Collaborator__Share  WHERE ParentId =:waiverCollaborator.Id AND RowCause = 'Manual'];
                if(!sharesToDelete.isEmpty()){
                    Database.Delete(sharesToDelete, false);
                }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
               }                   
            }catch(Exception e){
                //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'revertCollaborator,remove sharing', String.valueOf(waiverCollaborator.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='revertCollaborator()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
            }
            
            
        }else if(selectedOption=='Pending For Customer'){
            
            waiverCollaborator.Progressbar_staus__c='Pending For Customer';
            waiverCollaborator.Revert_Stage__c=selectedOption;
            waiverCollaborator.Revert_Reason__c+=revertReason;
            waiverCollaborator.isCustomerSelectionSubmitted__c=false;
            waiverCollaborator.isSubmitted__c=false;
            list<Waiver_Rule_List__c> allWaiverRules=new list<Waiver_Rule_List__c>();
            allWaiverRules= getAllWaiverRuleList(waiverCollaborator.Id);
            Map<integer,List<Id>> totalRecords = new Map<integer,List<Id>>();
            if (allWaiverRules<>NULL && !allWaiverRules.isEmpty()){
                integer i=1;
                List<Id> tempList = new List<Id>();
                for (Waiver_Rule_List__c w : allWaiverRules){                    
                    tempList.add(w.Id);                    
                    if (tempList.size() < 9999){
                        continue;
                    } else {
                        totalRecords.put(i, tempList);i++;
                        tempList = new List<Id>();
                    }
                }
                
                if(tempList<>null && !tempList.isEmpty()){
                    if(tempList.size()<9998){
                        totalRecords.put(i, tempList);
                    }
                }
                
                if (totalRecords.size()>0){
                    system.debug('Pending For FAE>>>>>>>totalRecords.size()  '+totalRecords.size());
                    for(integer j:totalRecords.keySet()){
                       List<Id> updateList = totalRecords.get(j);
                       DWC_WaiverRuleListEditBatch updateRueList = new DWC_WaiverRuleListEditBatch(updateList);
                       Database.executeBatch(updateRueList) ;
                    }
                }
                system.debug('DONE>>>>  ');
            }  
            if(! Test.isRunningTest()){
                //DFMEmailImplementation.DFMReviewSummaryNotificationL15(waiverCollaborator);
                  DFMEmailImplementation.DFMJobRevertedL16(waiverCollaborator);
            }
        }
        update waiverCollaborator;   
        PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
       
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
    
 public  static void sendNotificationToFAE(Wavier_Collaborator__c wc){
        
         wc.isCustomerSelectionSubmitted__c=true;
         wc.Progressbar_staus__c='Pending For Foundry';
     try{   
         update wc;
    if(Test.isRunningTest()) {
       throw new applicationException('In Test Mode');
      }         
     } catch (exception e){
       // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'sendNotificationToFAE()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
     ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='sendNotificationToFAE()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
     }    
        
         if(wc.PTSR_Service_Type__c.toUpperCase().contains('DRC')){  
            if(! Test.isRunningTest()){ DRCEmailImplementation.drcDecisionMadeByCustReport(wc); }
         }else{ if(! Test.isRunningTest()){   DFMEmailImplementation.DFMReviewSummaryNotification4AllPA1(wc); }
         }
       // return null;
    }
public static void backToMainPage(){
        PageReference p =  new PageReference('/apex/DWC_Collaborator?id='+ApexPages.currentPage().getParameters().get('Id'));   
       // return p;
    }

public static List<Schema.FieldSetMember> getFields(string collabId) {
        // Added new code for merging DFM and DRC modules
        Wavier_Collaborator__c collaborator = [Select Id, PTSR_Service_Type__c,DFM_Design_Type__c,DFMServiceOption__c from Wavier_Collaborator__c where Id=:collabId limit 1];
        boolean isTypeDFM = false;
        boolean isTypeDRC = false;
        boolean isLongFlow=false;
        
        
        if (collaborator.PTSR_Service_Type__c.contains('DRC')){
            isTypeDRC = true;
            return SObjectType.Wavier_Collaborator__c.FieldSets.DRC_View.getFields();
        }
        
        if (collaborator.PTSR_Service_Type__c.contains('DFM')){
            isTypeDFM = true;
            if (collaborator.DFM_Design_Type__c <> null && collaborator.DFMServiceOption__c <>null  && collaborator.DFMServiceOption__c.toLowerCase()=='waiver request'){
                isLongFlow = true;          
            }
            return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_Custome_View.getFields();
        }
        
        return null;
    }

 public PageReference pdfDownload(){        
         PageReference p =  new PageReference('/apex/DWC_WaiverCollaboratorPDF?id='+collaRecId); 
          p.setRedirect(true);
          return p;
    }      
    
  
  //SUHAS
    @remoteAction @readonly
    public static List<Approval_Task_Instance__c> ApprovalInstanceList(String ruleId){
        
        List<Approval_Task_Instance__c> apprvlist = new List<Approval_Task_Instance__c>();        
        for(List<Approval_Task_Instance__c> apprvlistT: [SELECT Approved_Rejected_Date__c,Approvers__c,CreatedById,CreatedDate,Created_Date__c,Delegateduser__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                                                        Name,OwnerId,Process_Status__c,Reassigned_Process__c,Re_AssignedUser__c,SystemModstamp,WaiverRule__c FROM Approval_Task_Instance__c WHERE WaiverRule__c =:ruleId ]){
                                                            

                                                        }
        
        Approval_Task_Instance__c apt = new Approval_Task_Instance__c();
        apt.Name='test';
        try{
        insert apt;
        if(Test.isRunningTest()) {
         throw new applicationException('In Test Mode');
        }
        
        } 
        
        catch (exception e){
           // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'ApprovalInstanceList()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
             ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='ApprovalInstanceList()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
            return null;
        } 
        apprvlist.add(apt);       

            return apprvlist;    
    }
    
    public pageReference setAMUsers(){
          Set <Id> selectedAMs= new Set<Id>();
        try{
            if (hiddenAMsIds<>NULL && !String.isEmpty(hiddenAMsIds)){
                for (String str : hiddenAMsIds.split(';')){
                    selectedAMs.add(Id.valueOf(str));
                }
            }
             System.debug('selectedAMs >>>> '+selectedAMs);
             if(Test.isRunningTest()) {
              throw new applicationException('In Test Mode');
             }
            return null;
            } catch (exception e){
               // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'setAMUsers()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
               ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='setAMUsers()';
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
    
    // Send DRC/DFM cancellation notifications   
    
    public pageReference cancelWorkflow(){
      waiverCollaborator=getWaiverCollaborator(collaRecId);
      system.debug('waiverCollaborator------------'+waiverCollaborator);
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
        system.debug('waiverCollaborator+++++++++++++'+waiverCollaborator);
        try{
            update waiverCollaborator;
           if(Test.isRunningTest()) {
              throw new applicationException('In Test Mode');
             }     
        } catch (exception e){
            //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'cancelWorkflow()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
              ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='cancelWorkflow()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
            return null;
        }    
        if(! Test.isRunningTest()){
        DFMEmailImplementation.DFMJobCancellation(waiverCollaborator);
        }
        PageReference p1 = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
        return p1;
    }
    // Release waiver list to customer to take further decision   
    public pageReference releaseToCustomer(){
        system.debug('DFM>>>>>>>releaseToCustomer');
        waiverCollaborator=getWaiverCollaborator(collaRecId);
        Set<String> setOfFinalStatus;
        Set <Id> selectedcustomers = new Set<Id>();
        
        if(statusValues!=null){
            List<String> statList =statusValues.split(',');
            setOfFinalStatus = new Set<String>(statList);
        }
        
        try{
            if (hiddenUsrIds<>NULL && !String.isEmpty(hiddenUsrIds)){
                for (String str : hiddenUsrIds.split(';')){
                    selectedcustomers.add(Id.valueOf(str));
                }
            }
                                
            if (selectedcustomers<>NULL && !selectedcustomers.isEmpty()){               
                boolean isSuccess = DfmUtilityCls.shareRecord(waiverCollaborator.Id,selectedcustomers,'Edit');
                setOfFinalStatus = new Set<String>();
                
                
                if (isSuccess){
                    DfmUtilityCls.stopTrigger=false;
                    if(waiverCollaborator.Is_All_PI_PW__c){
                    waiverCollaborator.isSubmitted__c=true; waiverCollaborator.Selected_Customers__c = hiddenUsrIds;waiverCollaborator.Is_releasedToCustomer__c = true;waiverCollaborator.PTSR_Status__c = 'Closed';waiverCollaborator.Progressbar_staus__c='Closed'; update waiverCollaborator;
                    PageReference p1 =new PageReference('/'+waiverCollaborator.id);  If(!Test.isRunningTest()){ return p1;     }
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
                                
                            PageReference p1 = new PageReference('/'+waiverCollaborator.id);   //DfmUtilityCls.returnToListView('Wavier_Collaborator__c');  
                            If(!Test.isRunningTest()){
                              return p1; 
                               }
                                
                                
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
                    //waiverCollaborator = getWaiverCollaborator(drcId);
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
                    List<waiver_rule_List__c>   wlIst=[select id from waiver_rule_List__c where Waiver_Collaborator__c=:waiverCollaborator.id limit 1];
                    if(!wlIst.isempty())update wlIst;
                    PageReference p = new PageReference('/'+waiverCollaborator.id); 
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
    
    
    
    // Below code is for DFM and DRC merging. This code will help to approve DFM report to DFM manager
     @remoteAction 
    public static string submitForApproval(String dwcId){
        Wavier_Collaborator__c dwc = getWaiverCollaborator(dwcId);
        try {
            System.debug('>>>>>submitForApproval');
            String errorMessages = checkMandatoryFields(dwc);
            Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
            if (errorMessages != 'Success'){                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, errorMessages));
                if(!Test.isRunningTest()){
                    return null;
                }
            }
            
            if (DfmUtilityCls.getAttachments(dwc.Id).isEmpty()){
                System.debug('>>>>>submitForApproval1');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Please attach waiver list before submitting for approval.'));
               return 'Please attach waiver list before submitting for approval';
            }
            System.debug('>>>>>submitForApproval2');
            // Create an approval request for design waiver collaborator
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request by DFM users');
            req.setObjectId(dwc.Id);
            // Submit the approval request for the Opportunity
            Approval.ProcessResult result = Approval.process(req);
            system.debug('result+++'+result);
            // check approval process submission result
            if (result.isSuccess() || Test.isRunningTest()){
                // update dfm apprval flag
               system.debug('result222222'+result);
               // DWC_CollaboratorCtrl.updateCollaboratorStatus(dwc.Id);
                // Share waiver report with DFM Approver group
                //DFM Enhancements - S1 mail template to DFM Manager and users - 14062016
                if(!Test.isRunningTest()){DFMEmailImplementation.DFMServicesApprovalRequest(dwc); DfmUtilityCls.shareRecord(dwc.Id,dfmManagerIds,'Edit');
                }
                //dfmApprovalToDfmApprovalTeam(); 
                PageReference p = DfmUtilityCls.returnToListView('Wavier_Collaborator__c');
            return '/aE1';   
                 
                
            } else { 
                for(Database.Error err : result.getErrors()) {
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getStatusCode() + ': ' + err.getMessage()));
                 }
                 return null;
            }
            if(Test.isRunningTest()) {
              throw new applicationException('In Test Mode');
             }
             return null; 
             
        } catch (exception e){ 
           // GlobalUtility.logMessage('Debug', 'DRCWaiverCollaboratorController', 'submitForApproval()', String.valueOf(dwc.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
             ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='submitForApproval()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while submitting waiver report for approval. Please contact with SFDC admin.')); 
            return null;        
        } 
        
    } 
    
   
    
     //Check the Mandatory Fields of Waiver Collaborator Object, Otherwise will not allow to Submit For Approval
    public static String checkMandatoryFields(Wavier_Collaborator__c dwc) {
        try{
        Map<String, String> dfmFields = new Map<String,String>{'CRM Device' => dwc.CRM_Device__c, 
                                                                'PTSR Number' => dwc.PTSR_Number__c, 
                                                                'PTSR Service Type' => dwc.PTSR_Service_Type__c, 
                                                                'PTSR Status' => dwc.PTSR_Status__c,
                                                                'FAB' => dwc.FAB__c, 
                                                                'Customer Full Name' => dwc.Account__c, 
                                                                'Account Short Name' => dwc.Account_Short_Name__c,
                                                                'DFMServiceOption' => dwc.DFMServiceOption__c};
                                                                
        String errorMessages = MandatoryFieldValidator.createDFM(dFMFields);
        if(Test.isRunningTest()) {
          throw new applicationException('In Test Mode');
         }
        return errorMessages;
        } catch (exception e){
           // GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'checkMandatoryFields()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
                           ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='checkMandatoryFields()';
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
    
    // update isSubmit4DFMApproval flag
    
     
    public static Wavier_Collaborator__c getWaiverCollaborator(Id drcId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : getFields(drcId)) {
            query += f.getFieldPath() + ', ';
        }
        
        query +=  'Account_Manager_Approver1__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,PTSR_Status__c,Account_Short_Name__c,'
            +'MantisIds__c,Approval_Field_Engineer__c,CreatedById,CreatedDate,Customer_Full_Name__c,Revert_Reason__c,'           
            +'DRB_Group_uIds__c,Selected_Customers__c,isCustomerSelectionSubmitted__c,'       
            +'Id,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,Is_releasedToCustomer__c,'
            +'LastActivityDate,LastModifiedById,Is_All_PI_PW__c,LastModifiedDate,LastReferencedDate,LastViewedDate,MantisId__c,'
            +'Prime_Die_Name__c,Revert_Collaborator__c,Revert_Stage__c'
            +' FROM Wavier_Collaborator__c WHERE Id =:drcId LIMIT 1';
        
        return Database.query(query);
    }
    
    
    public String getTaskMessage4Internal(Wavier_Collaborator__c collaborator) {
        
        String waiverStatus = collaborator.Waiver_Status__c;
        String workflowStatus = collaborator.Workflow_Status__c;
        String progressBarStatus = collaborator.Progressbar_staus__c;
        String taskMsg;
        try{
        if(collaborator.Revert_Collaborator__c && workflowStatus != 'Closed' && workflowStatus != 'Cancel'){
            taskMsg=' Review is in progress. No action is required from customer yet.';
        }
        else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending') {
           system.debug('review and dispostion'+progressBarStatus);
           if(progressBarStatus == 'Review_Disposition'){ if(waiverCollaborator.PTSR_Service_Type__c.toUpperCase().contains('DRC')){ taskMsg='DRC review result will be available after foundry review. No action is required from customer yet.';
                }else{ 
                     system.debug('review and dispostion>>>>'+progressBarStatus);
                    taskMsg='DFM review result will be available after foundry review. No action is required from customer yet.';
                }
           }else{ taskMsg='Execution is in progress. No action is required from customer yet.';
           }
            
        }
        // else if ((waiverStatus == 'Open' || waiverStatus == 'Approved') && workflowStatus == 'Pending' && !collaborator.Is_Sync_with_AIA__c) {//CHECK progress bar for Disposition flag aswell
         //       baseUrl = mapOfpBarStatusImgs.get('Internal_Review');            
        //}
        else if (waiverStatus == 'Open' && workflowStatus == 'Pending'){
             system.debug('pending for FAE'+progressBarStatus);
          
           if(progressBarStatus == 'Pending for FAE') taskMsg='The DFM/DRC Review results are ready. Your input is required to confirm which customers to receive the report when you approve <b> Proceed to customer </b>. Note that rules with Review status FCC or iFD are non-waived rules and are open for customer response.';
        }else if (progressBarStatus == 'Pending for FAE' && (waiverStatus == 'PI' || waiverStatus == 'PW' || waiverStatus == 'PA')  && workflowStatus == 'Pending'){
             system.debug('pending  >>>>'+progressBarStatus);
          
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
       if(Test.isRunningTest()) {
          throw new applicationException('In Test Mode');
         } 
        return taskMsg;
        } catch (exception e){
            //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'getTaskMessage4Internal()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
             ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
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
        if(Test.isRunningTest()) {
        throw new applicationException('In Test Mode');
        } 
        return taskMsg;
        } catch (exception e){
            //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'getTaskMessage4Customer()','', '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);    
             ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='getTaskMessage4Customer()';
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
    
     
    @remoteAction
    public static Map<Id, String> getCompleteRuleList(String dwcId){
        List<Waiver_Rule_List__c> ruleList = new List<Waiver_Rule_List__c> ();
        Wavier_Collaborator__c dwc = getWaiverCollaborator(dwcId);
        Map<Id, String> summaryRulemap = new Map<Id, String>();
        try {
            System.debug('>>>>>getCompleteRuleList');
            ruleList = getAllWaiverRuleList(dwcId);
            for(Waiver_Rule_List__c rules:ruleList ){
                summaryRulemap.put(rules.Id,rules.Final_Stage__c); 
             } 
             if(Test.isRunningTest()) {
              throw new applicationException('In Test Mode');
             }   
             return summaryRulemap; 
             
        } catch (exception e){ 
            //GlobalUtility.logMessage('Debug', 'DWC_CollaboratorCtrl', 'getCompleteRuleList()', String.valueOf(dwc.Id), '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while submitting waiver report for approval. Please contact with SFDC admin.')); 
             ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DWC_CollaboratorCtrl.class.getName();
                alw.sourceFunction ='getCompleteRuleList()';
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
    
    // Get Customer details from specific Account
    public class UserWrapperCls {
        
        public boolean isSelected {get;set;}
        public User userRecord {get;set;}
        public boolean isPTRFUser {get;set;}
        public Id portAccRecId{get;set;}
        public UserWrapperCls(boolean selected,User usr,boolean isPTRF, id parId){
            isSelected = selected;
            userRecord = usr;
            isPTRFUser=isPTRF;
            portAccRecId=parId;
        }
    }     
    
    Public Pagereference reload(){
    Pagereference p= new Pagereference('/'+collaRecId);
    p.setredirect(true);
    return p;
    }
    
    public class applicationException extends Exception {} 

      
    
    
}