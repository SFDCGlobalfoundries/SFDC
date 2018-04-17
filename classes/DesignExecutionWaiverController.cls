/********************************************************************
* Author: Sakthi 
* Project: DIW-DesignExecution 
* Name: DesignExecutionWaiverController 
* Description: Class is created for inserting/updating or handle all Waivers for different permissionSet
* CreatedDate:
* Modified By : Abhishek/Sandesh/Mseth
* Modified date : 07-may-2017 
*               : 25-may-2017, method fetchOpportunityTeamEmails added to fetch user who is a member of opportunity team.
*               : 25-may-2017, fetchEmailDetails is having condition where validating user who is a member of oppotunity team.  
*               : 26-may-2017, method getSOMAttachmentId added to fetch file attachment
*               : 27-may-2017, method sendWaiverEmail, line: 614 - added logic to insert file attachment
                : 20-Jun-2017, method sendWaiverEmail, line 584 - logic added to add requestor in CC email group
                : 20-jun-2017, method getwaiverSummaryMap, logic waiverTypes list added which can sort waiver type value in RTL,RTC & RTM order.
                : 24-Jun-2017, method waiverDetails, logic added to populate default value of Company, Part Name, Design System 
                               and Document RIT Type while new wiver creation
*********************************************************************/
public class DesignExecutionWaiverController {
    
    public Waivers__c waiversDetail {get; set;}
    public string recordTypeName {get; set;}
    public string selectedRT {get; set;}  
    public Id deid {get; set;}
    public string waiverExtVal;
    public string IDRdt; 
    public id cdsId; 
    public String wId{get;set;}
    public string toAddressStr {get;set;}
    public Id WaiverSMEID {get;set;}  
    public set<Id> approverIds {get;set;}
    public string waiverApproverEmail{get;set;}
    public List<waiverWrapper> waiverList {get; set;}
    public Map<String, map<string,Integer>> waiverSummaryMap;
    public Set<String> keyValues {get;set;}
    public String Mode {get;set;}
    public List<String> waiverTypes {get;set;} 
    public List<Waivers__c> InsertWaiver;
    private Set<String> oppTeamEmails;
    Public list<Waiver_SMEs__c> waiverSMEDetails;
    
    public Design_Execution__c designExecution {
        get { if (designExecution == null)designExecution = new Design_Execution__c();
            return designExecution;
        }
        set;
    }
        
    public DesignExecutionWaiverController(){
        
        cdsId = ApexPages.currentPage().getParameters().get('cdsId');
        DEID  = ApexPages.currentPage().getParameters().get('deid');
        deid  = ApexPages.currentPage().getParameters().get('deid');
        deId  = ApexPages.currentPage().getParameters().get('deid');
        if(deId !=null)
            deid  = deId;
        
        recordTypeName = ApexPages.currentPage().getParameters().get('RTName');
        wId = ApexPages.currentPage().getParameters().get('wId');

        waiverDetails(); 

        //Call page Header 
        designExecution = DesignExecutionUtility.fetchDErecords(deid);  
        getwaiverSummaryMap();                                               
    }
    
    /**
    * @description method to redirect on design execution read page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */  
    public Pagereference cancelExecutionDetail(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionRead?deid='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    /**
    * @description method to retrive the Waiver RecordType values from Custom Label
    * @param    No Parameter
    * @return   SelectOption options
    */ 
    public list<SelectOption> getWaiverCapabilityRTDetail() {
        list<SelectOption> options = new list<SelectOption>();        
        //retrive the Waiver RecordType values from Custom Label
        string waiverRecTypes = Label.DesignExecutionWaiverRecordTypes;
        set<string> setWaiverRTs = new set<string>();
        if(waiverRecTypes != null && waiverRecTypes!= ''){ 
            setWaiverRTs.addAll(waiverRecTypes.split('[,;]'));
        }
        if(setWaiverRTs.size() > 0){
           for(string w : setWaiverRTs) {
               options.add(new SelectOption(w,w));
           }
        }
        return options;
    }
    /**
    * @description method to add waiver approver
    * @param    No Parameter
    */ 
    public void AddWaiverApprover() {
        if (waiversDetail!=Null){
        ID waiverApproverId =  waiversDetail.Add_Approver__c;
        list<User> lstAddApproverUsers = [SELECT Id, Name, Email, isActive FROM User Where ID =: waiverApproverId];
        if(lstAddApproverUsers.size() >0){
        string waiverApproverEmail = lstAddApproverUsers[0].Email;
        
                  List<PermissionSetAssignment>   PS =[SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= : waiverApproverId AND PermissionSet.Name = 'DIW_Regional_Admin'];
        
        if(PS.size()>0){
           approverIds.add(waiverApproverId);
           if(toAddressStr==Null || toAddressStr==''){
             toAddressStr = waiverApproverEmail;
           }else if (!toAddressStr.contains(waiverApproverEmail)){
             toAddressStr = toAddressStr + ',' + waiverApproverEmail;
           }
            
        
        }
        else if(PS.size()==0 && !toAddressStr.contains(waiverApproverEmail)){
          try{
          PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetID = '0PS6F000001Il7T', AssigneeId = waiverApproverId);
          upsert psa;
          approverIds.add(waiverApproverId);
           if(toAddressStr==Null || toAddressStr==''){
             toAddressStr = waiverApproverEmail;
           }else{
             toAddressStr = toAddressStr + ',' + waiverApproverEmail;
           }
         
          }
          catch(Exception e){
              GlobalUtility.logMessage('Error','DesignExecutionWaiverController','AddWaiverApprover','','Exception while giving permission set to Waiver approver',String.valueof(e.getMessage()),'','Design Execution',e,0);
          }
         }
        }
        

        }
    }
    
    public class waiverWrapper {
        public Waivers__c w {get; set;} //Waiver object
        public String ApprovalStatus {get; set;} //row counter variable
        
        public waiverWrapper(Waivers__c w, String ApprovalStatus) {
            this.w = w; //assign Waiver
            this.ApprovalStatus = ApprovalStatus; //assign row counter
        }
    }
    
    
     /**
    * @description method to retrive the Waiver summary map
    * @param    No Parameter
    * @return   SellectOption options
    * @lastModified : Mseth
    */ 
    Public Map<String, map<String,Integer>> getwaiverSummaryMap(){
        Integer RTLCount = 0;
        Integer RTCCount = 0;
        Integer RTMCount = 0;
        waiverTypes = new String[3];
        Map<String, map<String,Integer>> waiverSummaryMap = new Map<String, map<String,Integer>>();
        List<aggregateResult> results = [select Waiver_Type__c Type,Approval_Status__c Status, count(Id) total from Waivers__c where Design_Execution__c =: deid group by Waiver_Type__c,Approval_Status__c  order By Waiver_Type__c ];
        for (AggregateResult ar : results)  {
                 
        if((String)ar.get('Type') =='RTL'){
            if(!waiverSummaryMap.containsKey('RTL'))
                waiverTypes.add(0, 'RTL');
            map<String,Integer> StatusCount = new map<String,Integer>();

           if(ar.get('Status')=='Approved'){
             StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
           }
           
          else if(ar.get('Status') =='Rejected'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
         
          else if(ar.get('Status') =='Review'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
        
          else if(ar.get('Status') =='Cancel'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          else if(ar.get('Status') == Null){
           StatusCount.put('Draft',(Integer)ar.get('total'));
          }
         if(waiverSummaryMap.get('RTL') != null){
            waiverSummaryMap.get('RTL').putAll(StatusCount);
         }else{
         waiverSummaryMap.put('RTL',StatusCount);

         }
          RTLCount++;
        }
          if(ar.get('Type') =='RTC'){
            if(!waiverSummaryMap.containsKey('RTC'))
                waiverTypes.add(1, 'RTC');
            map<String,Integer> StatusCount = new map<String,Integer>();
          if(ar.get('Status') =='Approved'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
         
          else if(ar.get('Status') =='Rejected'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          
          else if(ar.get('Status') =='Review'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          else if(ar.get('Status') =='Cancel'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
           else if(ar.get('Status') == Null){
           StatusCount.put('Draft',(Integer)ar.get('total'));
          }
        
          
         if(waiverSummaryMap.get('RTC') != null){
            waiverSummaryMap.get('RTC').putAll(StatusCount);
         }else{
         waiverSummaryMap.put('RTC',StatusCount);

         }
          RTCCount++;
        }
        if(ar.get('Type') =='RTM'){
           if(!waiverSummaryMap.containsKey('RTM'))
                waiverTypes.add(2, 'RTM'); 
           map<String,Integer> StatusCount = new map<String,Integer>();
          if(ar.get('Status') =='Approved'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          else if(ar.get('Status') =='Rejected'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          else if(ar.get('Status') =='Review'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          else if(ar.get('Status') =='Cancel'){
           StatusCount.put((String)ar.get('Status'),(Integer)ar.get('total'));
          }
          else if(ar.get('Status') == Null){
           StatusCount.put('Draft',(Integer)ar.get('total'));
          }
          
            if(waiverSummaryMap.get('RTM') != null){
            waiverSummaryMap.get('RTM').putAll(StatusCount);
         }else{
         waiverSummaryMap.put('RTM',StatusCount);
         
         }
          RTMCount++;
          }
          
        }
        for(map<String,Integer> Waiver : waiverSummaryMap.values()){
            for(String Status: Waiver.keySet()){
                
            
            }
            if(Waiver.get('Approved')== Null){
            Waiver.put('Approved',0);
            }
             if(Waiver.get('Review')== Null){
            Waiver.put('Review',0);
            }
             if(Waiver.get('Rejected')== Null){
            Waiver.put('Rejected',0);
            }
             if(Waiver.get('Cancel')== Null){
            Waiver.put('Cancel',0);
            }
            if(Waiver.get('Draft')== Null){
            Waiver.put('Draft',0);
            }
            
        
        }
        
        system.debug('----waiverTypes---'+waiverTypes);
        keyValues = waiverSummaryMap.keySet(); 
        Return waiverSummaryMap;
    }
    public List<waiverWrapper> getWaiverToDisplay() {
        String ApprovalStatus = 'Approved';
        List<waiverWrapper> waiverList = new List<waiverWrapper>();
        List<Waivers__c> listWaivers = [SELECT Id, Name,CreatedByID,CreatedBy.FirstName,CreatedDate ,CreatedBy.Email,Self_Waiver__c, Approval_Status__c,Approver_Name__c, Design_Execution__c, Date_requesting_the_waiver__c, Waiver_need_date__c, Company__c, 
                                                    Part_name__c, Design_System__c, Document_RIT_Type__c, Library_version__c,Impact_On_Yield_Reliability_Testability__c, 
                                                    Tree__c,Waiver_SMEs__c,Section__c,Add_Approver__c,Add_Approver__r.Email,Waiver_Type__c, Check_being_reviewed__c, Exact_error_or_warning_statement__c, Justification__c, Comments__c, WaiversExternalId__c
                                                    FROM Waivers__c Where Design_Execution__c =: deid];
        
        set<Id> waiverIds = new set<Id>();
        if(listWaivers != null && !listWaivers.isEmpty()) {
            for(Waivers__c w : listWaivers) {
                waiverIds.add(w.Id);
            }
        }
        
        Map<Id, String> mapProcessInstance = new Map<Id, String>();
        map<Id, List<String>> mapProcessInstances = new map<Id, List<String>>();
        List<ProcessInstance> listProcessInstance = [SELECT Id, ProcessDefinitionId, TargetObjectId, Status, CompletedDate, LastActorId FROM ProcessInstance Where TargetObjectId IN : waiverIds];
        if(listProcessInstance!= null && !listProcessInstance.isEmpty()) {
            for(ProcessInstance PI : listProcessInstance) {
                
                
                if(mapProcessInstances.get(PI.TargetObjectId) == null) {
                    mapProcessInstances.put(PI.TargetObjectId, new List<String>());    
                }
                mapProcessInstances.get(PI.TargetObjectId).add(PI.Status);
            }
        }
        for (Waivers__c w : [SELECT Id, Name, Approval_Status__c, Design_Execution__c,CreatedBy.Email, Date_requesting_the_waiver__c, Waiver_need_date__c, Company__c, 
                                                    Part_name__c,Self_Waiver__c, Design_System__c, Document_RIT_Type__c, Library_version__c, Impact_On_Yield_Reliability_Testability__c,
                                                    Tree__c,Waiver_SMEs__c,Add_Approver__c,Add_Approver__r.Email, Section__c,Waiver_Type__c, Check_being_reviewed__c, Exact_error_or_warning_statement__c, Justification__c, Comments__c, WaiversExternalId__c
                                                    FROM Waivers__c Where Design_Execution__c =: deid ]) { //query for the details of the records you want to display
            
            
            
            
            if(w.Approval_Status__c == 'Approved') {
                waiverList.add(new waiverWrapper(w, 'Approved')); 
            } 
            if(w.Approval_Status__c == 'Review') {
                waiverList.add(new waiverWrapper(w, 'Review')); 
            } 
             
            if(w.Approval_Status__c == 'Rejected') {
                string aStatus = 'Rejected';
                if(mapProcessInstances != null) {
                    List<String> mValues = mapProcessInstances.get(w.Id);
                    for(String m: mValues) {
                        if(m == 'Approved') {
                            aStatus = 'Approved';
                            break;
                        }
                    }
                }
                waiverList.add(new waiverWrapper(w, aStatus)); 
            }
             if(w.Approval_Status__c == 'Cancel') {
                waiverList.add(new waiverWrapper(w, 'Cancel')); 
            }
            if(w.Approval_Status__c == Null) {
                waiverList.add(new waiverWrapper(w, 'Draft')); 
            }
        }
        return waiverList; //return the list of full records plus their row counter
    }   

     public List<waiverWrapper> getWaiverToDisplayList() {
        String ApprovalStatus = 'Approved';
        List<waiverWrapper> waiverList = new List<waiverWrapper>();
        
        List<Waivers__c> listWaivers = [SELECT Id, Name,CreatedByID,CreatedBy.FirstName,CreatedDate ,CreatedBy.Email, Approval_Status__c,Approver_Name__c, Design_Execution__c, Date_requesting_the_waiver__c, Waiver_need_date__c, Company__c, 
                                                    Part_name__c,Self_Waiver__c, Design_System__c, Document_RIT_Type__c, Library_version__c,Impact_On_Yield_Reliability_Testability__c, 
                                                    Tree__c,Waiver_SMEs__c,Add_Approver__c,Add_Approver__r.Email, Section__c,Waiver_Type__c, Check_being_reviewed__c, Exact_error_or_warning_statement__c, Justification__c, Comments__c, WaiversExternalId__c
                                                    FROM Waivers__c Where Design_Execution__c =: deid and Waiver_Type__c =:selectedRT];
        
        set<Id> waiverIds = new set<Id>();
        if(listWaivers != null && !listWaivers.isEmpty()) {
            for(Waivers__c w : listWaivers) {
                waiverIds.add(w.Id);
            }
        }
      
        Map<Id, String> mapProcessInstance = new Map<Id, String>();
        map<Id, List<String>> mapProcessInstances = new map<Id, List<String>>();
        List<ProcessInstance> listProcessInstance = [SELECT Id, ProcessDefinitionId, TargetObjectId, Status, CompletedDate, LastActorId FROM ProcessInstance Where TargetObjectId IN : waiverIds];
        if(listProcessInstance!= null && !listProcessInstance.isEmpty()) {
            for(ProcessInstance PI : listProcessInstance) {
                
                
                if(mapProcessInstances.get(PI.TargetObjectId) == null) {
                    mapProcessInstances.put(PI.TargetObjectId, new List<String>());    
                }
                mapProcessInstances.get(PI.TargetObjectId).add(PI.Status);
            }
        }
        for (Waivers__c w : [SELECT Id, Name, Approval_Status__c,CreatedBy.Email, Design_Execution__c, Date_requesting_the_waiver__c, Waiver_need_date__c, Company__c, 
                                                    Part_name__c,Self_Waiver__c, Design_System__c, Document_RIT_Type__c, Library_version__c, Impact_On_Yield_Reliability_Testability__c,
                                                    Tree__c,Waiver_SMEs__c,Add_Approver__c,Add_Approver__r.Email,Section__c,Waiver_Type__c, Check_being_reviewed__c,Approver_Name__c, Exact_error_or_warning_statement__c, Justification__c, Comments__c, WaiversExternalId__c
                                                    FROM Waivers__c Where Design_Execution__c =: deid and Waiver_Type__c =:selectedRT order By Date_requesting_the_waiver__c ]) { //query for the details of the records you want to display
            
            
            
            
            if(w.Approval_Status__c == 'Approved') {
                waiverList.add(new waiverWrapper(w, 'Approved')); 
            } 
            if(w.Approval_Status__c == 'Review') {
                waiverList.add(new waiverWrapper(w, 'Review')); 
            } 
             
            if(w.Approval_Status__c == 'Rejected') {
                string aStatus = 'Rejected';
                if(mapProcessInstances != null) {
                    List<String> mValues = mapProcessInstances.get(w.Id);
                    if(mValues!=Null){
                    for(String m: mValues) {
                        if(m == 'Approved') {
                            aStatus = 'Approved';
                            break;
                        }
                    }
                    }
                }
                waiverList.add(new waiverWrapper(w, aStatus)); 
            }
             if(w.Approval_Status__c == 'Cancel') {
                
                waiverList.add(new waiverWrapper(w, 'Cancel')); 
            }
            if(w.Approval_Status__c == Null) {
                
                waiverList.add(new waiverWrapper(w, 'Draft')); 
            }
        }
        return waiverList; //return the list of full records plus their row counter    
    }          
    
    
   /* public AggregateResult[] results {
    // list<String> lstWaiversReview = new list<String> ();
        get {
            return [select Waiver_Type__c Type,Approval_Status__c Status, count(Id) total from Waivers__c where Waiver_Type__c!='none' and Design_Execution__c =: deid group by Waiver_Type__c,Approval_Status__c  ];
        }
    } */
    
    public list<Waivers__c> getWaiverList(){
        list<Waivers__c> lstWaivers = new list<Waivers__c> ();
        for(Waivers__c w : [SELECT Id, Name, Approval_Status__c,CreatedBy.Email, Design_Execution__c, Date_requesting_the_waiver__c, Waiver_need_date__c, Company__c, 
                                                    Part_name__c,Self_Waiver__c, Design_System__c, Document_RIT_Type__c, Library_version__c, Impact_On_Yield_Reliability_Testability__c,
                                                    Tree__c,Waiver_SMEs__c,Add_Approver__c,Add_Approver__r.Email, Section__c,Waiver_Type__c,Approver_Name__c, Check_being_reviewed__c, Exact_error_or_warning_statement__c, Justification__c, Comments__c, WaiversExternalId__c
                                                    FROM Waivers__c Where Design_Execution__c =: deid]){
          
          lstWaivers.add(w);                
        }
        return lstWaivers;        
    }
    /**
    * @description waiverDetails method is used to fetch the Waivers record from Waivers__c Object
    * @param    No Parameter
    * @return   void
    */    
    public void waiverDetails() {
        recordTypeName = ApexPages.currentPage().getParameters().get('RTName');
        approverIds = new Set<Id>();
        if(selectedRT != null) {
                recordTypeName = selectedRT;
        }
        if(recordTypeName != null && wId!= '0') {
            waiverExtVal = deid+':'+recordTypeName;
            list<Waivers__c> lstWaivers = [SELECT Id, Name, Design_Execution__c,CreatedBy.Email, Date_requesting_the_waiver__c, Waiver_need_date__c, Company__c, 
                                                    Part_name__c,Self_Waiver__c, Design_System__c, Document_RIT_Type__c, Library_version__c, Impact_On_Yield_Reliability_Testability__c,
                                                    Tree__c,Waiver_SMEs__c,Waiver_Type__c,Add_Approver__c,Add_Approver__r.Email, Section__c, Check_being_reviewed__c, Exact_error_or_warning_statement__c, Justification__c, Comments__c, WaiversExternalId__c 
                                                    FROM Waivers__c Where ID =: wId  Limit 1]; //WaiversExternalId__c =: waiverExtVal
                            
            if(lstWaivers != null && !lstWaivers.isEmpty()) {
                waiversDetail = lstWaivers[0];
            }
           
        
        }
         Else {
            try{
            String noneFromCustSet = DesignExecutionStaticValue__c.getvalues('None').value__c;
            designExecution = DesignExecutionUtility.fetchDErecords(deid);
            InsertWaiver = new list<Waivers__c>();
                Waivers__c w = new Waivers__c();
                w.Design_Execution__c = deid;
                w.Check_being_reviewed__c = noneFromCustSet; 
                w.Section__c = noneFromCustSet;
                w.Waiver_Type__c = recordTypeName; 
                w.Company__c = designExecution.Option__r.Account__r.Name;
                w.Part_name__c = designExecution.Option__r.MD_part_name__c;
                w.Design_System__c = designExecution.Option__r.ProductOffering__r.Name;
                w.Document_RIT_Type__c = designExecution.Option__r.RIT_Type__c;
                InsertWaiver.add(w);
                waiversDetail = InsertWaiver[0];
                
            
            } catch(Exception e){
              GlobalUtility.logMessage('Error','DesignExecutionWaiverController','OpenWaiverForm','','Exception while creating Waiver record',String.valueof(e.getMessage()),'','Design Execution',e,0);
            }
        
        
            } 
       
        string sendEmail = ApexPages.currentPage().getParameters().get('se');
        if(sendEmail == '1') {
            fetchEmailDetails();
        }
    }
    /**
    * @description OpenWaiverForm method is used to redirect to New Waiver (DesignExecutionWaiverCapability)
    * @param    No Parameter
    * @return   Pagereference DesignExecutionWaiverCapability page
    * @lastModified MSeth
    */
    public Pagereference NewWaiver(){
    
        pageReference pageRef = new pageReference('/apex/DesignExecutionWaiverCapability?RTName=' + selectedRT+'&deid='+designExecution.id+'&&wId=0');
        pageRef.setRedirect(true);
        return pageRef;    

    }
    
    /**
    * @description OpenWaiverForm method is used to redirect to DesignExecutionWaiverCapability
    * @param    No Parameter
    * @return   Pagereference DesignExecutionWaiverCapability page
    */
    public Pagereference OpenWaiverForm(){
        waiverDetails();
        try{
            if(waiversDetail == null) {
                Waivers__c w = new Waivers__c();
                w.Design_Execution__c = deid;
                w.WaiversExternalId__c = wId+':'+selectedRT; 
                w.Check_being_reviewed__c = '-None-'; 
                w.Section__c = '-None-';
                w.Waiver_Type__c = '-None-'; 
                update w;
            }
        } catch(Exception e){
              GlobalUtility.logMessage('Error','DesignExecutionWaiverController','OpenWaiverForm','','Exception while creating Waiver record',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
        pageReference pageRef = new pageReference('/apex/DesignExecutionWaiverCapability?RTName=' + selectedRT+'&deid='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;    
    }
    
     /**
    * @description EditWaiver method is used to redirect to DesignExecutionWaiverCapability
    * @param    No Parameter
    * @return   Pagereference DesignExecutionWaiverCapability page
    */
    public Pagereference EditWaiver(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionWaiverCapability?RTName=' + selectedRT+'&deid='+designExecution.id+'&wId='+wId);
        pageRef.setRedirect(true);
        waiverDetails();
        return pageRef;    
    }
    
    /**
    * @description saveWaiverDetail method is used to cretae new Waiver record.
    * @param    No Parameter
    * @return   Pagereference DesignExecutionWaiverCapabilitySendEmail page
    */
    public Pagereference saveWaiverDetail(){        
        try { 
            
            if(waiversDetail.Waiver_Type__c == '' || waiversDetail.Waiver_Type__c == '-None-') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Waiver for RTL, RTC, RTM'));
                return null;
            }
            
            if(recordTypeName != null && wId!='0'){                
                  fetchEmailDetails();
                 if(null !=toAddressStr || '' !=toAddressStr)
                 waiversDetail.To__c = toAddressStr;
                if(null !=additionalAddress || '' !=additionalAddress)
                 waiversDetail.CC__c = additionalAddress;
                 waiversDetail.Waiver_SMEs__c = WaiverSMEID;
                 system.debug('@@@w'+waiversDetail.Waiver_SMEs__c);
                update waiversDetail;
                wId = waiversDetail.Id;
            }
            Else {
            if(InsertWaiver != null) {
                InsertWaiver[0].Waiver_Type__c =  waiversDetail.Waiver_Type__c;
                InsertWaiver[0].Section__c = waiversDetail.Section__c;
                InsertWaiver[0].Check_being_reviewed__c = waiversDetail.Check_being_reviewed__c;
                InsertWaiver[0].Date_requesting_the_waiver__c = waiversDetail.Date_requesting_the_waiver__c;
                InsertWaiver[0].Waiver_need_date__c = waiversDetail.Waiver_need_date__c;
                InsertWaiver[0].Company__c = waiversDetail.Company__c;
                InsertWaiver[0].Part_name__c = waiversDetail.Part_name__c;
                InsertWaiver[0].Design_System__c = waiversDetail.Design_System__c;
                InsertWaiver[0].Document_RIT_Type__c = waiversDetail.Document_RIT_Type__c;
                InsertWaiver[0].Library_version__c = waiversDetail.Library_version__c;
                InsertWaiver[0].Tree__c = waiversDetail.Tree__c;
                InsertWaiver[0].Exact_error_or_warning_statement__c = waiversDetail.Exact_error_or_warning_statement__c;
                InsertWaiver[0].Justification__c = waiversDetail.Justification__c;
                InsertWaiver[0].Self_Waiver__c = waiversDetail.Self_Waiver__c;
                InsertWaiver[0].Comments__c = waiversDetail.Comments__c;
                InsertWaiver[0].Impact_On_Yield_Reliability_Testability__c = waiversDetail.Impact_On_Yield_Reliability_Testability__c;
                if(null !=toAddressStr || '' !=toAddressStr)
                  InsertWaiver[0].To__c = toAddressStr;
                if(null !=additionalAddress || '' !=additionalAddress)
                  InsertWaiver[0].CC__c = additionalAddress;
                Insert InsertWaiver;
                waiversDetail = InsertWaiver[0];
                wId = InsertWaiver[0].Id;
            }
            }
        } catch(Exception e){
            GlobalUtility.logMessage('Error','DesignExecutionWaiverController','saveWaiverDetail','','Exception while creating Waiver record',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }

        pageReference pageRef = new pageReference('/apex/DesignExecutionWaiverCapabilitySendEmail?deid='+designExecution.id+'&wId='+wId+'&RTName='+recordTypeName+'&se=1');
         pageRef.setRedirect(true);
        return pageRef;
      }
       public void SaveWaiverAttachment() {
          
        try {  
            
            wId = ApexPages.currentPage().getParameters().get('wId');
            
            if(waiverAttachment !=null && waiverAttachment.body != null) {
                list<Messaging.Emailfileattachment> fileAttachments = new list<Messaging.Emailfileattachment>();
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(waiverAttachment.Name);
                efa.setBody(waiverAttachment.body);
                fileAttachments.add(efa);
                
                waiverAttachment.Name = 'WaiverAttachment_'+waiverAttachment.name;
                waiverAttachment.ParentId = wId; // the record the file is attached to
                insert waiverAttachment;           
            
        } 
        }catch(Exception e){
            GlobalUtility.logMessage('Error','DesignExecutionWaiverController','SaveWaiverAttachment','','Exception while sending Email',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
       
      }
      
      /**
    * @description sendWaiverEmail method is used to send the Email notification based on Waiver record entry and Waiver SME's
    * @param    No Parameter
    * @return   Pagereference DesignExecutionRead page
    */
      public PageReference sendWaiverEmail() {
          
        try {  
            
            wId = ApexPages.currentPage().getParameters().get('wId');
            //New instance of a single email message
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            // Who you are sending the email to
            Contact c = [select id, Email from Contact Where email ='noreply@salesforce.com'  limit 1];
            mail.setTargetObjectId(c.id);
            mail.setTreatTargetObjectAsRecipient(false);
            //OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
            //mail.setOrgWideEmailAddressId(owa.id)
            //add To Address
            set<string> setEmailAddresses = new set<string>();
            if(toAddressStr != null && toAddressStr != ''){ 
                setEmailAddresses.addAll(toAddressStr.split('[,;]'));
            } 
            if(setEmailAddresses.size() > 0){
                mail.setToAddresses(convertToList(setEmailAddresses));
            }
            //add the additional address into CC
            set<string> ccEmailAddresses = new set<string>();
            
            //add requestor in cc Email chain
            ccEmailAddresses.add(UserInfo.getUserEmail());
            
            if(additionalAddress!= null && additionalAddress!= ''){ 
                ccEmailAddresses.addAll(additionalAddress.split('[,;]'));
            }
            if(setEmailAddresses.size() == 0 && ccEmailAddresses.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Email Id (To OR Additional Addresses) is Mandatory while sending the Email'));
                return null;
            }
           // set<string> setCCEmailAddresses = new set<string>();
            if(ccEmailAddresses.size() > 0){
              /*  list<User> listOfUsers = [SELECT Id, Email, IsActive, UserType FROM User Where Email IN : ccEmailAddresses AND IsActive = true AND UserType ='Standard'];
                if(listOfUsers != null && !listOfUsers.isEmpty()) {
                    for(User u : listOfUsers) {
                        if(u.Email != null && u.Email != '') {
                            setCCEmailAddresses.add(u.Email);
                            approverIds.add(u.Id);
                        }
                    }
                } 
                mail.setCcAddresses(convertToList(setCCEmailAddresses));
                */
                mail.setCcAddresses(convertToList(ccEmailAddresses));
            }

            mail.setWhatId(wId); //Waiver Id to merge the template
            // The email template ID used for the email
            EmailTemplate et= [Select id from EmailTemplate where DeveloperName='DesignExecutionWaiverCapability'];
            mail.setTemplateId(et.id);

            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);  
            
           /* if(waiverAttachment !=null && waiverAttachment.body != null) {
                list<Messaging.Emailfileattachment> fileAttachments = new list<Messaging.Emailfileattachment>();
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(waiverAttachment.Name);
                efa.setBody(waiverAttachment.body);
                fileAttachments.add(efa);
                
                waiverAttachment.Name = 'WaiverAttachment_'+waiverAttachment.name;
                waiverAttachment.ParentId = wId; // the record the file is attached to
                insert waiverAttachment;
                waiverAttachment.clear();
          
                mail.setFileAttachments(fileAttachments);
                
            }*/ 
            List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
                if(approverIds != null) {
                for (Id approverId : approverIds) {
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    
                    req.setComments('Submitted for Approval');
                    req.setObjectId(wId);
                    req.setNextApproverIds(new List<Id>{approverId});
                    requests.add(req);
                }
                if(requests != null && !requests.isEmpty()) {
                    List<Approval.ProcessResult> results = Approval.process(requests);
                }
            }
            
            //update email for ToAddress and CCAddress in waiver
            saveWaiverDetail();
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           
            
        } catch(Exception e){
            GlobalUtility.logMessage('Error','DesignExecutionWaiverController','sendWaiverEmail','','Exception while sending Email',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
        pageReference pageRef = new pageReference('/apex/DesignExecutionWaiverCapabilityRec?deid='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
      }
      
    /**
    * waiverAttachment variable of type Attachement which return waiverAttachment.
    */  
    public Attachment waiverAttachment {
    get {
      if (waiverAttachment == null)
        waiverAttachment = new Attachment();
      return waiverAttachment;
    }
    set;
    }
    /**
    * Rerender Pageblock Table
    */  
    public Void Table(){
    }
      
   /**
    * convertToList method is used to convert from Set to list 
    * @param  set<string>  Set of Id
    * @return list<string> 
   */
    public list<string> convertToList(set<string> setToConvert) {
        list<string> lstString = new list<string>();
        lstString.addAll(setToConvert);
        return lstString;
    }
    /**
    * @description fetchEmailDetails method to collect the email values from Waiver SME's object based on the 
    * Waiver Type, Section & Check Being Reviewed values
    * @param    No Parameter
    * @return   void
    */
    public string additionalAddress {get;set;}
    public void fetchEmailDetails(){
        if (waiversDetail!=Null){
        string waiverType = waiversDetail.Waiver_Type__c;
        string waiverSections = waiversDetail.Section__c;
        string waiverCheckReview = waiversDetail.Check_Being_Reviewed__c;
        oppTeamEmails =DesignExecutionUtility.fetchOpportunityTeamEmails(deid);

        list<Waiver_SMEs__c> waiverSMEDetails = [SELECT Id, Name, Profile_Permission_Sets__c, SME1__c, SME1__r.Email, SME1__r.isActive, SME2__c, SME2__r.Email, SME2__r.isActive, SME3__c, SME3__r.Email, SME3__r.isActive, SME4__c, SME4__r.Email, SME4__r.isActive, SME5__c, SME5__r.Email, SME5__r.isActive, SME6__c, SME6__r.Email, SME6__r.isActive, SME7__c, SME7__r.Email, SME7__r.isActive, SME8__c, SME8__r.Email, SME8__r.isActive, SME9__c, SME9__r.Email, SME9__r.isActive, SME10__c, SME10__r.Email, SME10__r.isActive FROM Waiver_SMEs__c 
                                                  WHERE Waiver_Type__c =: waiverType AND Section__c =: waiverSections  AND Check_Being_Reviewed__c =: waiverCheckReview];
        
        if(!waiversDetail.Self_Waiver__c){
        if(waiverSMEDetails != null && !waiverSMEDetails.isEmpty()) {
            //fetchOpportunityTeamEmails();
            WaiverSMEID = waiverSMEDetails[0].Id;
           
            if(waiverSMEDetails[0].SME1__c != null && waiverSMEDetails[0].SME1__r.Email != '' && waiverSMEDetails[0].SME1__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                    toAddressStr = waiverSMEDetails[0].SME1__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME1__r.Email)){
                    toAddressStr += waiverSMEDetails[0].SME1__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME1__c);
            }
            if(waiverSMEDetails[0].SME2__c != null && waiverSMEDetails[0].SME2__r.Email != '' && waiverSMEDetails[0].SME2__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                    toAddressStr = waiverSMEDetails[0].SME2__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME2__r.Email)){
                    toAddressStr += waiverSMEDetails[0].SME2__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME2__c);
            }
            if(waiverSMEDetails[0].SME3__c != null && waiverSMEDetails[0].SME3__r.Email != '' && waiverSMEDetails[0].SME3__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                    toAddressStr = waiverSMEDetails[0].SME3__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME3__r.Email)){
                    toAddressStr += waiverSMEDetails[0].SME3__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME3__c);
            }
            if(waiverSMEDetails[0].SME4__c != null && waiverSMEDetails[0].SME4__r.Email != '' && waiverSMEDetails[0].SME4__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                    toAddressStr = waiverSMEDetails[0].SME4__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME4__r.Email)){
                    toAddressStr += waiverSMEDetails[0].SME4__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME4__c);
            }
            if(waiverSMEDetails[0].SME5__c != null && waiverSMEDetails[0].SME5__r.Email != '' && waiverSMEDetails[0].SME5__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                    toAddressStr = waiverSMEDetails[0].SME5__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME5__r.Email)){
                    toAddressStr += waiverSMEDetails[0].SME5__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME5__c);
            }
            if(waiverSMEDetails[0].SME6__c != null && waiverSMEDetails[0].SME6__r.Email != '' && waiverSMEDetails[0].SME6__r.isActive == true){
                 if(toAddressStr ==Null || toAddressStr=='' ){
                    toAddressStr = waiverSMEDetails[0].SME6__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME6__r.Email)){
                    toAddressStr += waiverSMEDetails[0].SME6__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME6__c);
            }
            if(waiverSMEDetails[0].SME7__c != null && waiverSMEDetails[0].SME7__r.Email != '' && waiverSMEDetails[0].SME7__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                   toAddressStr = waiverSMEDetails[0].SME7__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME7__r.Email)){
                   toAddressStr += waiverSMEDetails[0].SME7__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME7__c);
            }
            if(waiverSMEDetails[0].SME8__c != null && waiverSMEDetails[0].SME8__r.Email != '' && waiverSMEDetails[0].SME8__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                   toAddressStr = waiverSMEDetails[0].SME8__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME8__r.Email)){
                   toAddressStr += waiverSMEDetails[0].SME8__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME8__c);
            }
            if(waiverSMEDetails[0].SME9__c != null && waiverSMEDetails[0].SME9__r.Email != '' && waiverSMEDetails[0].SME9__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                   toAddressStr = waiverSMEDetails[0].SME9__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME9__r.Email)){
                   toAddressStr += waiverSMEDetails[0].SME9__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME9__c);
            }
            if(waiverSMEDetails[0].SME10__c != null && waiverSMEDetails[0].SME10__r.Email != '' && waiverSMEDetails[0].SME10__r.isActive == true){
                if(toAddressStr ==Null || toAddressStr=='' ){
                   toAddressStr = waiverSMEDetails[0].SME10__r.Email+',';
                }else if(!toAddressStr.contains(waiverSMEDetails[0].SME10__r.Email)){
                   toAddressStr += waiverSMEDetails[0].SME10__r.Email+',';
                }
                approverIds.add(waiverSMEDetails[0].SME10__c);
            }
            if(waiverSMEDetails[0].Profile_Permission_Sets__c != null) {
                string pName = waiverSMEDetails[0].Profile_Permission_Sets__c;
                
                list<string> setPName = new list<string>();
                if(pName != null && pName != ''){ 
                    setPName.addAll(pName.split('[,;]'));
                }                
                if(setPName.size() > 0){
                    //collect the user email address from assigned permissionSet
                    list<PermissionSetAssignment> lstPermissionUsers = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.Label, AssigneeId, Assignee.Name, Assignee.Email, Assignee.isActive FROM PermissionSetAssignment Where PermissionSet.Label IN : setPName];
                    string psEmail = '';
                    if(lstPermissionUsers != null && !lstPermissionUsers.isEmpty()) {
                        
                        for(PermissionSetAssignment psa : lstPermissionUsers) {
                            if(psa.Assignee.Email != null && psa.Assignee.Email != '' && psa.Assignee.isActive == true && !oppTeamEmails.isEmpty() && oppTeamEmails.contains(psa.Assignee.Email)) {
                                psEmail += psa.Assignee.Email +',';
                                approverIds.add(psa.AssigneeId);
                            }
                        }
                    }
                    if(psEmail != null && psEmail !='') {
                        toAddressStr += psEmail;
                    }
                    //collect the user email address from assigned profile
                    list<User> lstProfileUsers = [SELECT Id, Name, Email, ProfileId, Profile.Name, isActive FROM User Where Profile.Name IN : setPName];
                    string pEmail;
                    if(lstProfileUsers != null && !lstProfileUsers.isEmpty()) {
                        for(User u : lstProfileUsers) {
                            if(u.Email != null && u.Email != '' && u.isActive == true && !oppTeamEmails.isEmpty() && oppTeamEmails.contains(u.Email)) {
                                pEmail += u.Email +',';
                                approverIds.add(u.Id);
                            }
                        }
                    }
                    if(pEmail != null && pEmail !='') {
                        toAddressStr +=  pEmail;
                    }
                }
            }
            
           

            toAddressStr = toAddressStr.removeEnd(',');
        } /*else {
            toAddressStr = '';
        } */  
        }
         Else if(waiversDetail.Self_Waiver__c){
             toAddressStr += waiversDetail.CreatedBy.Email ;
             
        }       
        }       
    }
    
    /**
    * @description fetchOpportunityTeamEmails method to collect the Opportunity Team Member based on 
    * Applicable Design Execution
    * @param    No Parameter
    * @return   List<String>: Opportunity Team member Email
    */
  /*  private void fetchOpportunityTeamEmails(){
        string str = Label.DesignExecutionTeamRole;
        List<String> teamRole =str.split('\\|');
        oppTeamEmails = new Set<String>();
        //Call page Header 
        designExecution = DesignExecutionUtility.fetchDErecords(deid);
        for(Opportunity_Program_Team_Member__c oppTeamEmail : [SELECT User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c 
                            WHERE Team_Role__c in :teamRole 
                            AND Opportunity_Id__c =: designexecution.Opportunity__c]){
                                
            oppTeamEmails.add(oppTeamEmail.User_Email__c);
            
        }
    } */
    
    /**
    * @description getSOMAttachmentId method return waiverAttac 
    * @param    No Parameter
    * @return   List<Attachment> waiverAttach 
    */     
    public List<Attachment> getSOMAttachmentId() {
        if(wId != null ) {
           //Id sId = signOffModue.Id;
           List<Attachment> waiverAttach = [Select Id, Name, CreatedBy.Name from Attachment Where ParentId =: wId ];
            if(waiverAttach !=null && !waiverAttach.isEmpty()) {
                return waiverAttach;
            } 
        }
        return null;
     } 
      
}