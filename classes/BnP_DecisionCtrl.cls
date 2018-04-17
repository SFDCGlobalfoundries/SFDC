/**
@Author < Varsha Tomar >
@name < BnP_DecisionCtrl >
@CreateDate < 10/5/2016 >
@Description < Controller for BnP_DecisionNew and BnP_Decision View VF Page >
@Version <1.1>
@ModifiedBy <Arijit Mandal>
@Version <1.2>
@ModifiedBy <Vijay Vemuru>
@Version <1.2>
@ModifiedBy <Poulami Saha   13/07/2017> <If status set to Complete Validate Charge Number, Charge Type of Charge Information and SAP Order Number, SAP SoldTo #, Yield Mgmt Data Deliveryto #, Order Type should not be blank>
*/
public class BnP_DecisionCtrl {
    
    // variable to hold decision record
    public Decision__c decisionRecord { get; set; }
    // variable to check whether to display Tech Review button or not
    public Boolean showTechReview { get; set; }
    // variable to check whehter quote is valid to create decision or not
    public Boolean isValidQuote { get; set; }
    // variable to hold charge info record
    public Charge_Info__c chargeInfoObj {get;set;} 
    public Tech_Review_Summary__c techRev {get;set;} 
    // variable to hold all sap order details added/edited
    public List<SAP_Order_Detail__c> allSapOrderList {get;set;} 
    
    // variable to hold sap order details to be deleted
    public List<SAP_Order_Detail__c> deleteSapOrderList = new List<SAP_Order_Detail__c>();
    // variable to hold quote id
    String reqInfoId;
    // variable to hold account id
    String accId;
    //variable to hold option id,used to check functionality details
    String opId;
    // variable to hold option id, fetched from url parameters
    String optionId = System.currentPageReference().getParameters().get('optionId');
    // variable to hold decision id, fetched from url parameters
    //String decisionId = ApexPages.currentPage().getParameters().get('decisionId');
    String decisionId = ApexPages.currentPage().getParameters().get('Id');
    //variables to hold attachment File
    public Blob funcattachmentbody{get;set; }
    public String funcattachmentname{get;set; }
    public String selectedFileType{get;set; }
     
    // variable to check whether to display functionality details or not
    public Boolean showfunc { get; set; }
    public string decisionLink { get; set; }
        
    // constructor for view page with standard controller parameter
    public BnP_DecisionCtrl(ApexPages.StandardController ctrl) {
        decisionRecord = (Decision__c)ctrl.getRecord();
        decisionLink = EnvironmentVariable.get('BNP_DECISION_VFPAGE_LINK');
        
        // if decision id is not passed in url then fetch it from decision record variable
        if(decisionId == null || decisionId == '') 
            decisionId = decisionRecord.id;         
        
        // query decision record and assign values to decision record variable    
        decisionRecord = queryDecision(decisionId);
        techReviewCheck();
        
    }
    
    // constructor for edit/ new page 
    public BnP_DecisionCtrl() {
        decisionLink = EnvironmentVariable.get('BNP_DECISION_VFPAGE_LINK');
        // quote id fetched from url parameters
        reqInfoId = ApexPages.currentPage().getParameters().get('reqInfoId');
        // account id fetched from url parameters
        accId = ApexPages.currentPage().getParameters().get('accId');
        // option id fetched from url parameters
        opId = ApexPages.currentPage().getParameters().get('trId');
        isValidQuote = true;
        // call method to check if the quote is valid to create decision 
        validateQuote();
        
        // if decision id is not passed in url 
        // then check if there is an existing decision on quote and fetch its id
        if(decisionId == null || decisionId == '') 
            decisionId = getExistingDecisionId();
        
        // if decision id is not null then query existing decision    
        if(decisionId != null && decisionId != '') {
            decisionRecord = queryDecision(decisionId);
            if(decisionRecord != null) {
                accId = decisionRecord.Account__c;
                opId = decisionRecord.Technical_Requirement__c;
                techReviewCheck();
        
            }
        } else {
            // if decision record does not exist for quote then create new reference
            decisionRecord = new Decision__c();
            
            // fetch option id from url
            String trId = ApexPages.currentPage().getParameters().get('trId');
            // fetch opportunity id from url
            String oppId = ApexPages.currentPage().getParameters().get('oppId');
            // fetch device id from url
            String deviceId = ApexPages.currentPage().getParameters().get('deviceId');
            
            // assign ids to lookup fields on decision record
            if(reqInfoId != '') decisionRecord.Request_Information__c = reqInfoId;
            if(trId != '')      decisionRecord.Technical_Requirement__c = trId;
            if(accId != '')     decisionRecord.Account__c = accId;
            if(oppId != '')     decisionRecord.Opportunity__c = oppId;
            if(deviceId != '')  decisionRecord.Device__c = deviceId;
        }
        
        /* query charge info and order details from on option
           only one charge info can exist per option
        */
        if(decisionRecord != null) {
            chargeInfoOnLoad();
            trOnLoad();
            //added by Meghna
            /* validation to display functionality details when Option Stage is 'Customer Decision' OR 'Production'
            */
            if(opId != null){
                Customer_Requirement__c cr = [select Option_Stage__c from Customer_Requirement__c where id = :opId ];
                if(cr.Option_Stage__c == 'Customer Decision' || cr.Option_Stage__c == 'Production'){
                    showfunc = true;
                }
           }
       }
        //end
    } 
    
    public void techReviewCheck() {
        /* validation to display Tech Review button or not
            1. check if decision status is completed
            2. check if design win is approved on Opportunity
        */
        if(decisionRecord != null) {
            String stageName = String.valueOf(decisionRecord.Opportunity__r.StageName);
            
            Integer stageNumberIndex = stageName.indexOf('.');
            Integer stageNumber = 0;
            if(stageNumberIndex != null)
            stageNumber = Integer.valueOf(stageName.substring(0, stageNumberIndex));
            
            
            
            if((decisionRecord.Opportunity__r.Date_Design_Win_Approved__c != null || stageNumber >= 5)
                && (decisionRecord.Device__r.Product_Line__c == 'SiPh' && decisionRecord.Device__r.Design_Execution_Required__c =='RF flow' || decisionRecord.Device__r.Product_Line__c == 'RF'))
                  
                  
                showTechReview = true;
            
            /* query charge info and order details from on option
               only one charge info can exist per option
            */
            chargeInfoOnLoad();
            trOnLoad();
        }
    }
    
    // method returns the id of decision record if it already exist on quote
    public String getExistingDecisionId() {
        List<Decision__c> decisionList = [select id from Decision__c where Request_Information__c = :reqInfoId];
        if(decisionList != null && decisionList.size() > 0)
            return decisionList[0].id;
        else 
            return '';
    }
    
    /* method to check if quote is valid to create decision
       condition: Last Accepted Quote checkbox should be checked on quote
    */
    public void validateQuote() {
        if(reqInfoId != null){
        
            Request_Information__c ric = [select Last_Accepted_Quote__c from Request_Information__c where id = :reqInfoId];
            
            if(!ric.Last_Accepted_Quote__c) {
                isValidQuote = false;
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'You can not create decision from this quote as it is not last accepted quote.'));
                return;
            } else {
                isValidQuote = true;
            }
        }
    }
    
    // this method queries charge info and sap order details
    public void chargeInfoOnLoad() {
         // fetch option id from decision record
         optionId = decisionRecord.Technical_Requirement__c;
         // list of all sap order details
         allSapOrderList = new List<SAP_Order_Detail__c>();
         // variable for charge info record
         chargeInfoObj = new Charge_Info__c();
         
         if(optionId != null) {
             // query charge info related to option
             List<Charge_Info__c> chargeInfoList = [select id,name,Charge_Number__c, Charge_Type__c, Option__c, SAP_Mask_Order__c
                      from Charge_Info__c where Option__c = : optionId];
             // if exist the assign to charge info variable
             if(chargeInfoList != null && chargeInfoList.size() > 0) {
                 chargeInfoObj = chargeInfoList[0];
             
             } else {
                 // if not exist, then assign option and account to new charge info record
                 chargeInfoObj.Option__c = optionId;
                 chargeInfoObj.Account__c = accId;
                 
             }
             // query sap order details related to charge info
             if(chargeInfoObj.id != null) {
                 allSapOrderList = [Select Id,Name, Charge_Info__c, Order_Type__c, SAP_Order_Number__c, SAP_SoldTo__c, Yield_Mngmnt_Data_Deliveryto__c 
                             from SAP_Order_Detail__c where Charge_Info__c = :chargeInfoObj.id];
             }
         }
    }
    
    // save decision record
    public PageReference doSave() {
    
    /****************** 13/07/2017 Added code to validate fields when status set to Complete Starts ******************/
        Boolean isSAPBlank;
        if(!allSapOrderList.isEmpty()){
            for(SAP_Order_Detail__c sapOrd : allSapOrderList){
                if(sapOrd.SAP_Order_Number__c == '' || sapOrd.SAP_Order_Number__c == null || sapOrd.SAP_SoldTo__c == '' || sapOrd.SAP_SoldTo__c == null || sapOrd.Yield_Mngmnt_Data_Deliveryto__c == '' || sapOrd.Yield_Mngmnt_Data_Deliveryto__c == null ||  sapOrd.Order_Type__c == '' || sapOrd.Order_Type__c == null){
                    isSAPBlank = true;
                    break;
                }
            }
        }
        try {
            if(decisionRecord.Status__c == 'Completed' && (allSapOrderList.isEmpty() || chargeInfoObj.Charge_Number__c == '' || chargeInfoObj.Charge_Number__c == null || chargeInfoObj.Charge_Type__c == '' || chargeInfoObj.Charge_Type__c == null || isSAPBlank == true)){
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'You must enter >>Charge Number, >>Charge Type of Charge Information and >>SAP Order Number, >>SAP SoldTo #, >>Yield Mgmt Data Deliveryto #, >>Order Type of all Sap Order Detail before Completing decision.'));
                return null;
        }else{
    /****************** 13/07/2017 Added code to validate fields when status set to Complete Ends ******************/                       
                upsert decisionRecord;
            
                // save charge info and sap order details
                saveChargeInfo();
                //added by Vijay
                // upload Functionality Statement and PO attachment
                uploadAttachments();
                //update Option stage to production if conditions fulfilled
                
                if(decisionRecord.Technical_Requirement__c != null){
                    if(decisionRecord.Functionality_Date__c != null && decisionRecord.Functionality_Statement_attached__c 
                            && decisionRecord.PO_Document_Attached__c && decisionRecord.Technical_Requirement__r.Option_Stage__c == 'Customer Decision'){
                        Customer_Requirement__c cr = new Customer_Requirement__c(id = decisionRecord.Technical_Requirement__c);
                        cr.Option_Stage__c = 'Production'; 
                        update cr;
                    }  
                }
            }
            //end
        } catch (Exception e) {
            if(e.getMessage().contains('Duplicate')) {
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'You can have only one Decision record per Option.'));
            } else {
                ApexPages.addMessages(e);
            }
            GlobalUtility.logMessage('Error','BnP_DecisionCtrl','doSave','','Exception while creating/updating Decision record or updating Option record',String.valueof(e.getMessage()),'','Customer Decision',e,0);

            return null;
        }
        //return new PageReference('/apex/BnP_DecisionView?decisionId=' + decisionRecord.id);
        return new PageReference('/apex/BnP_DecisionView?Id=' + decisionRecord.id);
    }
    
    // method is called when clicked on Edit button, redirect to edit page
    public PageReference doEdit() {
        
        //return new PageReference('/apex/BnP_DecisionNew?decisionId=' + decisionRecord.id).setRedirect(true);
        return new PageReference('/apex/BnP_DecisionNew?Id=' + decisionRecord.id).setRedirect(true);
    }
    
    // method called when clicked on Cancel button, redirect to previous page
    public PageReference doCancel() {
        if(reqInfoId != null)
            return new PageReference('/' + reqInfoId);
        else
            //return new PageReference('/apex/BnP_DecisionView?decisionId=' + decisionRecord.id);
            return new PageReference('/apex/BnP_DecisionView?Id=' + decisionRecord.id);
    }
    
    //added by Meghna
    // method called when clicked on Tech Review button, redirect to Tech Review standard new page
     public PageReference goToTechReview() {
         BnP_TechReview_Util trUtil = new  BnP_TechReview_Util();
         String recTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();
         PageReference pgRef = trUtil.callTechReview(decisionRecord, chargeInfoObj.Charge_Number__c, recTypeId);
         if(pgRef != null) {
             pgref.getParameters().put('retURL',decisionRecord.id);
             
             PageReference pgr = pgRef;
             return pgr;
         } else
             return null;
    }
    //end
    
    // method to show Tech Review details
     public void trOnLoad() {
        String recTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();
        List<Tech_Review_Summary__c> techRevList = [select Approval_to_proceed_to_RTM__c, RIT_outlook__c , RTM_outlook__c
                      from Tech_Review_Summary__c where Decision__c = :decisionRecord.id];
        if(techRevList != null && techRevList.size() > 0) {
            techRev = techRevList[0];
        }
    }
    // return options and its quotes whose quote status is accepted, to be displayed on decision page
    public List<Customer_Requirement__c> getTRList() {
        if(decisionRecord != null) {
            List<Customer_Requirement__c> trList = [select Name, Option_Status__c, 
                                                (select Name, Quote_Status__c, Last_Accepted_Quote__c from Request_Information__r)
                                                from Customer_Requirement__c
                                                where id = :decisionRecord.Technical_Requirement__c];
            
            Map<Id, Customer_Requirement__c> mapTR = new Map<Id, Customer_Requirement__c>();
            for(Customer_Requirement__c tr :trList) {
                for(Request_Information__c ri :tr.Request_Information__r) {
                    if(ri.Quote_Status__c == 'Accept')
                        mapTR.put(tr.id, tr);
                }
            }
            return mapTR.values();
        }
        return null;
    }
    
    // add a temporary sap Order detail to the table. Not saved to the database
    public void addSapOrder(){
        SAP_Order_Detail__c c = new SAP_Order_Detail__c();
        List<Account> accList = [select SAP_Account_Number__c from Account where id = :accId];
        
        // assign sap order number from account
        if(accList != null && accList.size() > 0)
            c.SAP_SoldTo__c = accList[0].SAP_Account_Number__c;
        allSapOrderList.add(c);
    }

    // remove a sap Order detail from the table.
    public void removeSapOrder(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        // if the sapOrder is an existing sapOrder then add it to the list to delete from the databse
        if(allSapOrderList[indexVal - 1].Id != null)
            deleteSapOrderList.add(allSapOrderList[indexVal - 1]);
        // remove the sapOrder from the table    
        allSapOrderList.remove(indexVal - 1);            
    }    
    
    // save charge info and sap order details
    public PageReference saveChargeInfo(){
        // upsert charge info
        upsert chargeInfoObj;
        
        for(SAP_Order_Detail__c so :allSapOrderList) {
            if(so.Charge_Info__c == null)
                so.Charge_Info__c = chargeInfoObj.id;
        }
        
        //update existing sap order details and insert new ones
        upsert allSapOrderList;
        
        system.debug('<==>AM:' + allSapOrderList.size());
        if(allSapOrderList.size() > 0) // Arijit: Change the Option Stage to Reconciliation and Option Stage is still in BnQ (SP-3)
        {                                 
            Customer_Requirement__c objoption = new Customer_Requirement__c();
            objoption = [Select Option_Stage__c,Opportunity_Contract_Pricing__c From Customer_Requirement__c where Id =: chargeInfoObj.Option__c];
            
            //if(decisionRecord.Technical_Requirement__r.Option_Stage__c == 'Bid and Quote')
            if(objoption.Option_Stage__c == 'Bid and Quote' || (objoption.Option_Stage__c == 'Try for Fit' && objoption.Opportunity_Contract_Pricing__c =='Yes')) //SP4: Bug fixed of SP3
            {                
                Customer_Requirement__c objcr = new Customer_Requirement__c(id = decisionRecord.Technical_Requirement__c);
                objcr.Option_Stage__c = 'Reconciliation'; 
                update objcr;
            }
        }
        
        //delete the sap order details that were removed
        if(deleteSapOrderList.size() > 0)
            delete deleteSapOrderList;
    
        return null;
    }  
    
    public List<SelectOption> getTypesOfFile() {
        List<SelectOption> fileList = new List<SelectOption>();
        fileList.add(new SelectOption('', '--None--'));
        
        if(decisionRecord.Technical_Requirement__r.Option_Stage__c == 'Customer Decision'
                || decisionRecord.Technical_Requirement__r.Option_Stage__c == 'Production'
                || decisionRecord.Technical_Requirement__r.Option_Stage__c == 'Prototype Fulfillment') {
            
            fileList.add(new SelectOption('Functionality Statement', 'Functionality Statement'));
        }
        
        fileList.add(new SelectOption('PO', 'PO'));
        fileList.add(new SelectOption('Commitment Letter', 'Commitment Letter'));
        fileList.add(new SelectOption('Other', 'Other'));
        return fileList;
    }
    
    //added by Vijay
     // upload Functionality Statement and PO attachment
    public PageReference uploadAttachments(){
        
        //initialize functionality attachment and PO attachment
       Attachment funcattachment = new Attachment();
       
        if(funcattachmentname != null && funcattachmentbody != null){
            funcattachment.ParentId = decisionRecord.Id ;
            funcattachment.Name = funcattachmentname + '-:' + selectedFileType;
            funcattachment.Body = funcattachmentbody ;
            insert funcattachment;
        }
        
        if(funcattachment != null && funcattachment.id != null) {
            if(selectedFileType == 'Functionality Statement') {
                decisionRecord.Functionality_Statement_attached__c = true ;
            
            } else if(selectedFileType == 'PO') {
                decisionRecord.PO_Document_Attached__c = true ;
            }
            update decisionRecord;
        }
      return null;
    }
    //end  
    // query decision record
    public Decision__c queryDecision(String decisionId) {
        if(decisionId != null) {
            return [SELECT Account__c,Business_Unit__c,Charge_Number__c,Charge_Type__c,CreatedById,CreatedDate,
                Device__c, Name, Request_Information__c,Request_Information__r.Quote_Status__c, Opportunity__r.StageName,
                SAP_Order_Number__c,SAP_Soldto_Number__c,Technical_Requirement__c, UniqueId__c,X100_MD_Funded__c,
                Yield_Mngmnt_Data_Deliveryto_Number__c, Status__c, FAE_Prono_Date__c,Functionality_Date__c,Functionality_Statement_attached__c,
                PO_Document_Attached__c,Opportunity__r.LTR_Rev_M__c,Opportunity__r.Product_Line__c,Device__r.Product_Line__c,Reason_For_Rejection__c, Comments__c, 
                Opportunity__r.Date_Design_Win_Approved__c,Technical_Requirement__r.Name, Opportunity__r.Name, Request_Information__r.Name, 
                Device__r.Name, Device__r.Design_Execution_Required__c, Technical_Requirement__r.Option_Stage__c
                FROM Decision__c where id = :decisionId];
        } else {
            return null;
        }
    }  
    
    public List<AttachmentWrap> getAttachmentList() {
        List<AttachmentWrap> attList = new List<AttachmentWrap>();
        for(Attachment att : [select id, Name, ParentId, CreatedBy.Name, CreatedDate from Attachment where ParentId = :decisionId]) {
            
            List<String> fileNameSplit = att.Name.split('-:');
            attList.add(new AttachmentWrap((fileNameSplit.size() > 1 ? fileNameSplit[1] : ''), fileNameSplit[0], att.id, att));
        }
        return attList;
    }
    
    public class AttachmentWrap {
        public String fileType {get;set;}
        public String fileName {get;set;}
        public String id {get;set;}
        public Attachment attRecord {get;set;}
        
        public AttachmentWrap(String fileType, String fileName, String id, Attachment attRecord) {
            this.fileType = fileType;
            this.fileName = fileName;
            this.id = id;
            this.attRecord = attRecord;
        }
    }
}