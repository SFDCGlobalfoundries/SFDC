public with sharing class RMA_Edit_Extension{
        
    public boolean isFab9or10{get;set;} //for Fab 9 and 10
    public boolean canAckReq{get;set;} //to check acknowledgement request
    public string rmaByOldVal{get;set;}//To store previous value of RMA_By__c
    public boolean showExtensionReason{get;set;}
    public boolean renderPageMessage{get;set;}
    public String pageMessage{get;set;}
    public List<RMA_Return_Invoice__c> lstRMAInvoices{get;set;}
    public List<LineItemWrapper> lstLineItemWrapper{get;set;}
    public RMA__c RMArecord = new RMA__c();
    Set<String> setLotNumber;
    
    //Select Options for Lot/Device Selection
    public SelectOption[] leftOptionsFRF {get;set;}
    public SelectOption[] rightOptionsFRF{get;set;}
    public SelectOption[] leftOptionsDRW {get;set;}
    public SelectOption[] rightOptionsDRW{get;set;}
    public SelectOption[] leftOptionsETW {get;set;}
    public SelectOption[] rightOptionsETW{get;set;}
    public SelectOption[] leftOptionsRP  {get;set;}
    public SelectOption[] rightOptionsRP {get;set;}
    public SelectOption[] leftOptionsReturn {get;set;}
    public SelectOption[] rightOptionsReturn{get;set;}
    public SelectOption[] leftOptionsScrapReturn {get;set;}
    public SelectOption[] rightOptionsScrapReturn{get;set;}
    
    //For Scrap Receivers
    public List<String> leftSelectedUsersForScrap{get;set;}
    public List<String> rightSelectedUsersForScrap{get;set;}
    public Set<string> leftScrapUserValues{get;set;}
    public Set<string> rightScrapUserValues{get;set;}
    public String searchScrapUser{get;set;}
    public Map<String,Id> rightScrapUserMap{get;set;}
    public Map<String,Id> leftScrapUserMap{get;set;}
    public List<RMA_Access_User__c> scrapUserList{get;set;}
    public boolean showScrapReceiver{get;set;}
    
    //For Wafer Return Receivers
    public List<String> leftSelectedUsersForWafer{get;set;}
    public List<String> rightSelectedUsersForWafer{get;set;}
    public Set<string> leftWaferUserValues{get;set;}
    public Set<string> rightWaferUserValues{get;set;}
    public String searchWaferUser{get;set;}
    public Map<String,Id> rightWaferUserMap{get;set;}
    public Map<String,Id> leftWaferUserMap{get;set;}
    public List<RMA_Access_User__c> WaferUserList{get;set;}
    public boolean showWaferReceiver{get;set;}
    
    //For Notify / Circulate to (FE / Fab YE / Others)
    public List<String> leftSelectedUsersForNotify{get;set;}
    public List<String> rightSelectedUsersForNotify{get;set;}
    public Set<string> leftNotifyUserValues{get;set;}
    public Set<string> rightNotifyUserValues{get;set;}
    public String searchNotifyUser{get;set;}
    public Map<String,Id> rightNotifyUserMap{get;set;}
    public Map<String,Id> leftNotifyUserMap{get;set;}
    public List<RMA_Access_User__c> NotifyUserList{get;set;}
    public boolean showNotifyReceiver{get;set;}
    
    //For Non Fab Validation
    public List<String> leftSelectedUsersForNonFab{get;set;}
    public List<String> rightSelectedUsersForNonFab{get;set;}
    public Set<string> leftNonFabUserValues{get;set;}
    public Set<string> rightNonFabUserValues{get;set;}
    public String searchNonFabUser{get;set;}
    public Map<String,Id> rightNonFabUserMap{get;set;}
    public Map<String,Id> leftNonFabUserMap{get;set;}
    public List<RMA_Access_User__c> NonFabUserList{get;set;}
    public boolean showNonFabReceiver{get;set;}
    
    //For Fab Validation
    public List<String> leftSelectedUsersForFab{get;set;}
    public List<String> rightSelectedUsersForFab{get;set;}
    public Set<string> leftFabUserValues{get;set;}
    public Set<string> rightFabUserValues{get;set;}
    public String searchFabUser{get;set;}
    public Map<String,Id> rightFabUserMap{get;set;}
    public Map<String,Id> leftFabUserMap{get;set;}
    public List<RMA_Access_User__c> FabUserList{get;set;}
    public boolean showFabReceiver{get;set;}
    
    //For Turnkey Validation
    public List<String> leftSelectedUsersForTurnkey{get;set;}
    public List<String> rightSelectedUsersForTurnkey{get;set;}
    public Set<string> leftTurnkeyUserValues{get;set;}
    public Set<string> rightTurnkeyUserValues{get;set;}
    public String searchTurnkeyUser{get;set;}
    public Map<String,Id> rightTurnkeyUserMap{get;set;}
    public Map<String,Id> leftTurnkeyUserMap{get;set;}
    public List<RMA_Access_User__c> TurnkeyUserList{get;set;}
    public boolean showTurnkeyReceiver{get;set;} 
    
    //for Failure Mode
    public List<RMA_PRF_CAR_Particulars__c> failureModeList{get;set;}
    public String searchTextForFailureMode{get;set;}
    public boolean showAddFailurModeSection{get;set;}
    public boolean showFailureModeError{get;set;}
    public List<selectOption> failureModeSelectOption{get;set;}
    public RMA_PRF_CAR_Particulars__c rmaFailureCode{get;set;}
    public SelectOption[] leftOptionForFailureMode{get;set;}
    public SelectOption[] rightOptionForFailureMode{get;set;}
    public String failureModeId{get;set;}
    public Set<String> setFailureMode;
    
    public boolean dispDispositionScrapBool{get;set;}
    public boolean dispDispositionReturnBool{get;set;}
    public boolean rejectionPopUp{get;set;}
    public string LineItemToEdit{get;set;}
    public boolean showPopUp{get;set;}
    public string LineItemToEditForFab{get;set;}
    public boolean showPopUpForFab{get;set;}
    public string LineItemToEditForReg{get;set;}
    public boolean showPopUpForReg{get;set;}
    public String site{get;set;} //Site
    public Integer lotCount{get;set;} //count of lot invoice
    public Integer totalReceivingQty{get;set;}
    public String selTab {get;set;} //Extensions for passing params
    public boolean validateRMA{get;set;}
    public boolean showCycleTimeHistoryLink {get;set;} //Cycle time history
    public boolean voidRMA{get;set;} //for Void function
    public static RMA_Utility.RMAwrapper rmaWrap{get;set;}
    public boolean SystemModeOn{get;set;}
    public String DRAFT_STATUS {get;set;}
    public String REJECTED_STATUS {get;set;}
    public boolean sendEmail = false;
    public boolean justificationFlag{get;set;} //Nikhil- To Control Visiblity of Justification field
    public string businessCategory{get;set;}
    
    //for PRF & CAR
    public RMA_PRF_CAR_Particulars__c prfParticular {get;set;}
    public RMA_PRF_CAR_Particulars__c carParticular {get;set;}
    public SelectOption[] rightOptionsCAR {get;set;}
    public boolean hasError {get;set;}
    public boolean showprfCARpopup{get;set;}
    public boolean isPRF{get;set;}
                                                                                      
    public SelectOption[] leftOptionsCAR  {get{
                                                if(leftOptionsCAR == null || leftOptionsCAR.isEmpty()){
                                                    return getLotNumbers();
                                                }return leftOptionsCAR;
                                            }set;}
    
    //Mail log
    public String reportDevName {get;set;}
    public ApexPages.StandardSetController mailLogSetCon{get{
                                                    if(mailLogSetCon == null){
                                                        mailLogSetCon = new ApexPages.StandardSetController([SELECT Cc__c, Subject__c, CreatedById, CreatedDate, Email_Body__c, 
                                                                                                                    From__c, LastModifiedDate, RMA__c, Name, Id,To__c
                                                                                                            FROM RMA_Audit_log__c
                                                                                                            WHERE RecordTypeId =: RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.MAIL_LOG)
                                                                                                            and rma__c = : RMArecord.Id order by CreatedDate Desc
                                                                                                           ]);
                                                        mailLogSetCon.setPageSize(5);                                                                                                      
                                                    }return mailLogSetCon;
                                                }set;}
        
    public List<RMA_audit_log__c> mailLogList {get{ 
                                                    mailLogList = mailLogSetCon.getRecords();               
                                                    return mailLogList;
                                                  } set;
                                               }
    
    public RMA_Edit_Extension(ApexPages.StandardController controller){
        isFab9or10 = false;
        DRAFT_STATUS = RMA_CONSTANTS.DRAFT_STATUS;
        REJECTED_STATUS = RMA_CONSTANTS.REJECTED_STATUS;
        searchTextForFailureMode = '';
        showFailureModeError = false;
        canAckReq = false;
        failureModeId = '';
        showAddFailurModeSection = false;
        showExtensionReason = false;
        voidRMA = false;
        lotCount = 0;
        rejectionComments = '';
        rejectionPopUp = false;
        RMArecord = (RMA__c)controller.getRecord();
        
        lstRMAInvoices = new List<RMA_Return_Invoice__c>();
        lstLineItemWrapper = new List<LineItemWrapper>();
        LineItemToEdit = '';
        leftOptionsFRF = new List<SelectOption>();
        rightOptionsFRF= new List<SelectOption>();
        leftOptionsDRW = new List<SelectOption>();
        rightOptionsDRW= new List<SelectOption>();
        leftOptionsETW = new List<SelectOption>();
        rightOptionsETW= new List<SelectOption>();
        leftOptionsRP  = new List<SelectOption>();
        rightOptionsRP = new List<SelectOption>();
        leftOptionsReturn = new List<SelectOption>();
        rightOptionsReturn= new List<SelectOption>();
        showPopUp = false;
        leftOptionsScrapReturn = new List<SelectOption>();
        rightOptionsScrapReturn= new List<SelectOption>();
        leftSelectedUsersForScrap = new List<String>();
        rightSelectedUsersForScrap = new List<String>();
        leftScrapUserValues = new Set<string>();
        rightScrapUserValues = new Set<string>();
        rightScrapUserMap = new Map<String,Id>();
        leftScrapUserMap = new Map<String,Id>();
        scrapUserList = new List<RMA_Access_User__c>();
        showScrapReceiver = false;
        
        leftSelectedUsersForWafer = new List<String>();
        rightSelectedUsersForWafer = new List<String>();
        leftWaferUserValues = new Set<string>();
        rightWaferUserValues = new Set<string>();
        rightWaferUserMap = new Map<String,Id>();
        leftWaferUserMap = new Map<String,Id>();
        WaferUserList = new List<RMA_Access_User__c>();
        showWaferReceiver = false;
        
        leftSelectedUsersForNotify = new List<String>();
        rightSelectedUsersForNotify = new List<String>();
        leftNotifyUserValues = new Set<string>();
        rightNotifyUserValues = new Set<string>();
        rightNotifyUserMap = new Map<String,Id>();
        leftNotifyUserMap = new Map<String,Id>();
        NotifyUserList = new List<RMA_Access_User__c>();
        showNotifyReceiver = false;
        
        leftSelectedUsersForNonFab = new List<String>();
        rightSelectedUsersForNonFab = new List<String>();
        leftNonFabUserValues = new Set<string>();
        rightNonFabUserValues = new Set<string>();
        rightNonFabUserMap = new Map<String,Id>();
        leftNonFabUserMap = new Map<String,Id>();
        NonFabUserList = new List<RMA_Access_User__c>();
        showNonFabReceiver = false;
        
        leftSelectedUsersForFab = new List<String>();
        rightSelectedUsersForFab = new List<String>();
        leftFabUserValues = new Set<string>();
        rightFabUserValues = new Set<string>();
        rightFabUserMap = new Map<String,Id>();
        leftFabUserMap = new Map<String,Id>();
        FabUserList = new List<RMA_Access_User__c>();
        showFabReceiver = false;
        
        leftSelectedUsersForTurnkey = new List<String>();
        rightSelectedUsersForTurnkey = new List<String>();
        leftTurnkeyUserValues = new Set<string>();
        rightTurnkeyUserValues = new Set<string>();
        rightTurnkeyUserMap = new Map<String,Id>();
        leftTurnkeyUserMap = new Map<String,Id>();
        TurnkeyUserList = new List<RMA_Access_User__c>();
        showTurnkeyReceiver = false;
        
        isPRF = false;
        hasError = false;
        rightOptionsCAR = new List<SelectOption>();
        
        PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF);
        carParticular = new RMA_PRF_CAR_Particulars__c(recordTypeId = RMA_Constants.PRFCAR_CAR);
        
        for(RMA_Access_User__c access : [select Id,User__c,User_Name__c,Category__c,RMA__c from RMA_Access_User__c where RMA__c =: RMArecord.Id order by User__c ASC]){
            if(access.Category__c == 'Scrap Certificate'){
                scrapUserList.add(access);
            }
            else if(access.Category__c == 'Return Wafer'){
                WaferUserList.add(access);
            }
            else if(access.Category__c == 'Notify/Circulate'){
                NotifyUserList.add(access);
            }
            else if(access.Category__c == 'Non Fab'){
                NonFabUserList.add(access);
            }
            else if(access.Category__c == 'Fab'){
                FabUserList.add(access);
            }
            else if(access.Category__c == 'Turnkey'){
                TurnkeyUserList.add(access);
            }
        }
        
        retrieveScrapUsers();
        retrieveWaferUsers();
        retrieveNotifyUsers();
        retrieveNonFabUsers();
        retrieveFabUsers();
        retrieveTurnkeyUsers();
        
        rmaWrap= new RMA_Utility.RMAwrapper(0,0,0);
        if(controller.getId() != NULL){
            if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                isFab9or10 = true;
            }
            SystemModeOn = RMA_Utility.checkApprover(RMArecord.Id) || RMArecord.OwnerId == UserInfo.getUserId() || 
                           RMA_AccessClass.hasAdminPriv() || RMA_Utility.checkAmountPermissionSet();
            populateLineItems(controller.getId());
            PopulateLotNumbers(setLotNumber);            
            if(SystemModeOn){
                rmaWrap = RMA_Utility.getRMAtotalSystemMode(RMArecord.Id);
            }            
            businessCategory = RMArecord.Business_Category__c;
        }
        
        //set the Site
        if(RMArecord.Fab__c == NULL){
          site = '';
          RMArecord.Receiver_Address__c = NULL;
        }
        else if(RMArecord.Fab__c == 'FAB 1'){
          site = 'Dresden';
            if(string.isEmpty(RMArecord.Receiver_Address__c)){  
                RMArecord.Receiver_Address__c = Label.RMA_Dresden_Address;
            }
        }
        else if(RMArecord.Fab__c == 'FAB 8'){
          site = 'Malta';
            if(string.isEmpty(RMArecord.Receiver_Address__c)){  
                RMArecord.Receiver_Address__c = Label.RMA_Malta_Address;
            }
        }
        else if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            site = 'Singapore';
            if(string.isEmpty(RMArecord.Receiver_Address__c)){  
                RMArecord.Receiver_Address__c = Label.RMA_Singapore_Address;
            }
        }
        
        rmaByOldVal = RMArecord.RMA_By__c;
        
        retrieveDisposition();
        reAssign = '';
        String selTabParam = ApexPages.currentPage().getParameters().get('selTab');
        selTab = String.isNotBlank(selTabParam) ? selTabParam : '';
        showCycleTimeHistoryLink = enableCycleTimeHistoryLink();
        renderPageMsg();
        retreiveFailureModeList();
        QueryAllRMAAttachments(); //For retrieving the attachments
        
        if(controller.getId() != NULL && 
            (!RMA_Utility.checkFab9or10(RMARecord.Fab__c) || (RMA_Utility.checkFab9or10(RMARecord.Fab__c) && RMArecord.RMA_category__c != 'Failure Analysis'))){
            justificationFlag = RMA_Field_Validation_Helper.validateJustificationWarranty(RMArecord);
        }
    }
    
    //to check if Fab is Fab 9/10
    public void checkFab(){
        if(RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            isFab9or10 = true;
        }
        else{
            isFab9or10 = false;
            RMArecord.ITAR_Part__c = false;
            RMArecord.Business_Unit__c = RMArecord.Product_Line__c = RMArecord.RMA_Category__c = RMArecord.ReasonCode__c = NULL;
        }
    }
    
    public void setCurrenTabNameMethod(){
        selTab = ApexPages.currentPage().getParameters().get('currentTab');
    }
    
    public void retreiveFailureModeList(){
        failureModeList = new List<RMA_PRF_CAR_Particulars__c>();
        if(RMArecord.Id != NULL){
            failureModeList = [select Id, RMA__c, Lot__c, Failure_Mode__c from RMA_PRF_CAR_Particulars__c where RecordTypeId =: RMA_Constants.PRFCAR_FailureMode and RMA__c =: RMArecord.Id];
        }
    }
    
    public void renderPageMsg(){
        renderPageMessage = false;
        pageMessage = '';
        if(RMArecord.Status__c == 'Voided'){
            renderPageMessage = true;
            pageMessage = 'The RMA record has been Voided. Please create a new one if you need to raise the RMA again.';
        }
        else if(RMArecord.Extension_Status__c == 'Requested' && checkCSR()){
            renderPageMessage = true;
            pageMessage = 'Technical Validation has requested for extension by '+RMArecord.Number_of_Days__c+' day(s). Please click on <b>Approve Extension</b> to approve the request, or <b>Reject Extension</b> to reject the request.';
        }
        else if(RMArecord.Workflow_Stage__c != NULL 
        &&(RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)
        || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL)
        || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL))
        && RMArecord.Extension_Status__c != 'Approved' 
        && RMArecord.Extension_Status__c != 'Requested' 
        && RMArecord.Extension_for_Fab_validation_required__c
        && RMArecord.Number_of_Days__c == NULL
        && (RMA_Utility.checkApprover(RMArecord.Id) || RMA_AccessClass.hasAdminPriv())){
            renderPageMessage = true;
            pageMessage = 'Please mention by how many days you need to extend validation.';           
        }
        else if(checkTechApprv()){
            canAckReq = true;
            renderPageMessage = true;
            pageMessage = 'Due date to respond the RMA validation is <b>'+RMArecord.Escalation_Date_for_Fab_Validation__c+'</b> and you have requested extension for <b>'+RMArecord.Number_of_Days__c+' day(s)</b>. Please select <b>Extend time for validation</b> button.';
        }
        else if(RMArecord.Is_Legacy__c){
            renderPageMessage = true;
            pageMessage = 'This is the migrated RMA from Lotus Notes application. Full details of the RMA are still available (read only mode) in the Lotus Notes RMA application.';
        }
    
    }
    
    public boolean checkTechApprv(){
        boolean isTechApprv = false;
        if(RMArecord.Workflow_Stage__c != NULL 
        &&(RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)
        || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_TNK_VAL)
        || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_NONFAB_VAL))
        && RMArecord.Extension_Status__c != 'Approved' 
        && RMArecord.Extension_Status__c != 'Requested' 
        && RMArecord.Extension_for_Fab_validation_required__c
        && RMArecord.Number_of_Days__c != NULL){
            isTechApprv = RMA_Utility.checkApprover(RMArecord.Id) || RMA_AccessClass.hasAdminPriv();
        }
        return isTechApprv;
    }
    
    public boolean checkCSR(){
        boolean isCSR = false;
        if(RMARecord.OwnerId == userInfo.getUserId()){
            isCSR = true;
        }
        return isCSR || RMA_AccessClass.hasAdminPriv();
    }
    
    public void populateLineItems(String controllerId){
        lstRMAInvoices.clear();
        lstLineItemWrapper.clear();
        if(!SystemModeOn){
            lstRMAInvoices = [SELECT Id,RMA__c,Wafer_Die_Unit_Price__c,Wafer_Id_CSR_Submission__c,Wafer_Id_Fab_Validated__c,Current_Die_Quantity__c,
                                 Adjusted_Unit_Price__c,Total_Price__c,Wafer_Quantity__c,Wafer_Id_Regional_Personnel_Recommended__c,Invoice__r.Item_Type__c,
                                 Invoice__r.Ship_from_Address__c,Invoice_Number__c,Lot_Number__c,Name,Scrap_Limit__c,Wafer_Yield__c,RMA__r.Name,
                                 Total_Price_FAB_Validation__c,Wafer_Id_Fab_In_Validated__c,Total_Wfr_Qty_after_validation__c,Total_Price_Final__c,Device__c,
                                 Die_Selling_Price__c,Wafer_Id_Regional_Personnel_Not_Rec__c,Final_RMA_Wfr_Qty_To_Issue_CN_SO__c,Die_Quantity__c,GDPW__c,Invoice_Date__c,
                                 Die_Quantity_Fab_Validated__c,Die_Quantity_Regional_Validated__c,RMA_By__c,RMA__r.Workflow_Stage__c,Invoice_Lot_Combination__c,
                                 Wafer_Id_Fab_9_10_CSR_Submission__c,Module_Quantity__c,Module_Quantity_Fab_Validated__c,Module_Quantity_Regional_Validated__c,
                                 Wafer_Id_Fab_9_10_Fab_Validated__c,Wafer_Id_Fab_9_10_Regional_Validated__c,Wafer_Id_Fab_9_10_Fab_Invalidated__c,
                                 Wafer_Id_Fab_9_10_Regional_Invalidated__c,Current_Module_Quantity__c,Bill_Quantity__c,Existing_Form_Factor_Quantity__c,
                                 Existing_Form_Factor__c,Process__c,Purchase_Order_Number__c,RMA__r.OwnerId,CreatedById,Fab_Group__c
                                FROM RMA_Return_Invoice__c 
                                WHERE RMA__c= :controllerId
                                ORDER BY Name];
        }else{
            lstRMAInvoices = RMA_Utility.QueryLineItemsSystemMode(controllerId);
        }
        lotCount = lstRMAInvoices.size();
        
        //NJain- 26-Oct-16 - Adding logic to compute quantity for Receiving Team
        Set<String> setReceivingLots = new Set<String>();
        totalReceivingQty = 0;
        if(rmaRecord.Lot_Device_To_Return__c != NULL && rmaRecord.Lot_Device_To_Return__c != ''){
            setReceivingLots.addAll(rmaRecord.Lot_Device_To_Return__c.split(';'));
        }
        
        for(RMA_Return_Invoice__c ri: lstRMAInvoices){
            lstLineItemWrapper.add(new LineItemWrapper(ri,ri.Lot_Number__c));
                        
            if(!setReceivingLots.isEmpty() && setReceivingLots.contains(ri.Lot_Number__c+ '-' + ri.Invoice_Number__c)){
                totalReceivingQty += integer.valueOf(ri.Wafer_Quantity__c);
            }
        }
        
        //Collecting the Lot numbers for all the Line items associated with RMA
        setLotNumber = new Set<String>();
        for(RMA_Return_Invoice__c retInv: lstRMAInvoices){
            setLotNumber.add(retInv.Lot_Number__c+'-'+retInv.Invoice_Number__c);
        }
    }
    
    public pageReference AddReturnInvoice(){
        String accShortName, addInvoiceURL, sapAccountNum;
        
        List<Account> lstAccount = [select id,Short_Name__c,Customer_Number__c,SAP_Account_Number__c from Account where Id =: RMArecord.Customer__c];
        if(lstAccount!= NULL && !lstAccount.isEmpty()){
            accShortName= lstAccount[0].Customer_Number__c;
            sapAccountNum = lstAccount[0].SAP_Account_Number__c;
        }
        addInvoiceURL = '/apex/RMA_Invoice?fabName=' + RMArecord.Fab__c + '&custName=' + accShortName + '&sapAccNo=' + sapAccountNum + '&RMA=' + RMArecord.Id + '&RMABy=' + RMArecord.RMA_By__c;
        PageReference pageRef = new PageReference(addInvoiceURL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference MassUpload(){
        PageReference pageRef = new PageReference('/apex/RMA_MassUpload?id='+RMArecord.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //Nikhil- Why are we having NULL functions for different types of Issues?
    //Control visibility of section : Field reliability Failure Issue 
    public pagereference dispSectFRF(){
        return null;
    }
    //Control visibility of section : RMA related to Waiver Issue
    public pagereference dispSectWaiverIssue(){
        return null;
    }
    //Control visibility of section : Risk Production
    public pagereference dispSectRiskProd(){
        return null;
    }
    //Control visibility of section : Others
    public pagereference dispSectOthers(){
        return null;
    }
    //Control visibility of section : CAR
    public pagereference dispSectCAR(){
        return null;
    }
    //Control visibility of section : PRF
    public pagereference dispSectPRF(){
        return null;
    }
    
    public void retrieveDisposition(){
        if(RMArecord.Disposition_of_Wafers__c == NULL){
            dispDispositionScrapBool  = false;
            dispDispositionReturnBool = false;
        }else if(RMArecord.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
            dispDispositionScrapBool  = true;
            dispDispositionReturnBool = false;
        }else if(RMArecord.Disposition_of_Wafers__c == 'Return to GF'){
            dispDispositionScrapBool  = false;
            dispDispositionReturnBool = true;
        }else{
            dispDispositionScrapBool  = true;
            dispDispositionReturnBool = true;
        }
    }
    
    public pageReference dispDisposition(){
        boolean validateDOW = true;
        if(RMArecord.Disposition_of_Wafers__c != NULL){
            if(lotCount == 1 && RMArecord.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                validateDOW = false;
                dispDispositionScrapBool  = false;
                dispDispositionReturnBool = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'You cannot use this option as there is only one Lot available in the RMA. Minimum 2 lots are needed to use this option.'));
            }            
        }
        if(!validateDOW){
            RMArecord.Disposition_of_Wafers__c = NULL;
            return NULL;
        }
        else{
            if(isFab9or10 && (RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF') || RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF and to Scrap at Customer Site'))){
                RMArecord.Carrier_Vendor__c = RMArecord.Carrier_Vendor_Account_Number__c = RMArecord.New_Carrier_Vendor__c = NULL;
                RMArecord.Return_Location__c = RMArecord.Receiver_Address__c = NULL;
                if(lotCount == 1){
                    for(RMA_Return_Invoice__c inv : lstRMAInvoices){
                        RMArecord.Ship_from_Address__c = inv.Invoice__r.Ship_from_Address__c;
                    }    
                }
            }
            rightOptionsReturn.clear();
            leftOptionsReturn.clear();
            rightOptionsScrapReturn.clear();
            leftOptionsScrapReturn.clear();
            for(String str: setLotNumber){
                leftOptionsReturn.add(new selectOption(str,str));
                leftOptionsScrapReturn.add(new selectOption(str,str));
            }
            retrieveDisposition();
            return NULL;
        }
    }
    
    //Populate Lot Numbers in respective fields for selection
    public void PopulateLotNumbers(Set<String> setLotNumber){
        Set<String> setLotFRF = new Set<String>();
        Set<String> setLotDRW = new Set<String>();
        Set<String> setLotETW = new Set<String>();
        Set<String> setLotRP = new Set<String>();
        Set<String> setLotReturn = new Set<String>();
        Set<String> setScrapLotReturn = new Set<String>();
        
        setLotRP.addAll(setLotNumber);
        setLotETW.addAll(setLotNumber);
        setLotDRW.addAll(setLotNumber);
        setLotFRF.addAll(setLotNumber);
        setLotReturn.addAll(setLotNumber);
        setScrapLotReturn.addAll(setLotNumber);
        
        if(RMArecord.Lot_Device_FRF__c != NULL){                
            for(String str: RMArecord.Lot_Device_FRF__c.split(';')){
                rightOptionsFRF.add(new SelectOption(str,str));
            }
            setLotFRF.removeAll(RMArecord.Lot_Device_FRF__c.split(';'));
        }            
        for(String str: setLotFRF){
            leftOptionsFRF.add(new SelectOption(str,str));
        }
        
        if(RMArecord.Lot_Device_Design_Rule_Waiver__c != NULL){                
            for(String str: RMArecord.Lot_Device_Design_Rule_Waiver__c.split(';')){
                rightOptionsDRW.add(new SelectOption(str,str));
            }
            setLotDRW.removeAll(RMArecord.Lot_Device_Design_Rule_Waiver__c.split(';'));
        }
        for(String str: setLotDRW){
            leftOptionsDRW.add(new SelectOption(str,str));
        }
        
        if(RMArecord.Lot_Device_ET_Waiver__c != NULL){                
            for(String str: RMArecord.Lot_Device_ET_Waiver__c.split(';')){
                rightOptionsETW.add(new SelectOption(str,str));
            }
            setLotETW.removeAll(RMArecord.Lot_Device_ET_Waiver__c.split(';'));
        }
        for(String str: setLotETW){
            leftOptionsETW.add(new SelectOption(str,str));
        }
        
        if(RMArecord.Lot_Device_Risk_Production__c != NULL){                
            for(String str: RMArecord.Lot_Device_Risk_Production__c.split(';')){
                rightOptionsRP.add(new SelectOption(str,str));
            }
            setLotRP.removeAll(RMArecord.Lot_Device_Risk_Production__c.split(';'));
        }
        for(String str: setLotRP){
            leftOptionsRP.add(new SelectOption(str,str));
        }
        
        if(RMArecord.Lot_Device_To_Return__c != NULL){                
            for(String str: RMArecord.Lot_Device_To_Return__c.split(';')){
                rightOptionsReturn.add(new SelectOption(str,str));
            }
            setLotReturn.removeAll(RMArecord.Lot_Device_To_Return__c.split(';'));
        }
        for(String str: setLotReturn){
            leftOptionsReturn.add(new SelectOption(str,str));
        }
        if(RMArecord.Lot_Device_Requires_Scrap_Certificate__c != NULL){                
            for(String str: RMArecord.Lot_Device_Requires_Scrap_Certificate__c.split(';')){
                rightOptionsScrapReturn.add(new SelectOption(str,str));
            }
            setScrapLotReturn.removeAll(RMArecord.Lot_Device_Requires_Scrap_Certificate__c.split(';'));
        }
        for(String str: setScrapLotReturn){
            leftOptionsScrapReturn.add(new SelectOption(str,str));
        }
    }
    
    public pageReference SaveRMA(){
        try{
            searchTextForFailureMode = '';
            showFailureModeError=false;
            hasError = false;
            //clear Reason_for_delay__c if reason_code__c is not 'Other'
            if(String.isNotBlank(RMArecord.reason_code__c) &&  !(RMArecord.reason_code__c.equals('Other')) && 
               String.isNotBlank(RMArecord.Reason_for_delay__c)){
                RMArecord.Reason_for_delay__c = null;
            }
            if(reAssign == 'Assign to Non-Fab' && RMArecord.Notify_For_Non_Fab__c == NULL){
                hasError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select atleast one Non-Fab User.'));
                return NULL;
            }
            else if((RMArecord.Acknowledged_Wafer_Return__c || RMArecord.Acknowledged_Wafer_Scrap__c) && RMA_Field_Validation_Helper.checkAckn(RMArecord)){
                hasError = true;
                return NULL;
            }
            else{
                //for populating the field Lot_Device_FRF__c 
                string selLotsFRF = '';
                for(SelectOption so: rightOptionsFRF){
                    selLotsFRF += so.getValue() + ';';
                }
                RMArecord.Lot_Device_FRF__c = selLotsFRF;
                
                //for populating the field Lot_Device_Design_Rule_Waiver__c
                string selLotsDRW = '';
                for(SelectOption so: rightOptionsDRW){
                    selLotsDRW += so.getValue() + ';';
                }
                RMArecord.Lot_Device_Design_Rule_Waiver__c = selLotsDRW;
                
                //for populating the field Lot_Device_ET_Waiver__c
                string selLotsETW = '';
                for(SelectOption so: rightOptionsETW){
                    selLotsETW += so.getValue() + ';';
                }
                RMArecord.Lot_Device_ET_Waiver__c = selLotsETW;
                
                //for populating the field Lot_Device_Risk_Production__c
                string selLotsRP = '';
                for(SelectOption so: rightOptionsRP){
                    selLotsRP += so.getValue() + ';';
                }
                RMArecord.Lot_Device_Risk_Production__c = selLotsRP;
                
                //for populating the field Lot_Device_To_Return__c
                string selLotsReturn = '';
                for(SelectOption so: rightOptionsReturn){
                    selLotsReturn += so.getValue() + ';';
                }
                RMArecord.Lot_Device_To_Return__c = selLotsReturn;
                
                //for populating the field Lot_Device_Requires_Scrap_Certificate__c
                string selScrapLotsReturn = '';
                for(SelectOption so: rightOptionsScrapReturn){
                    selScrapLotsReturn += so.getValue() + ';';
                }
                RMArecord.Lot_Device_Requires_Scrap_Certificate__c = selScrapLotsReturn;
                
                calculateBusinessCategory(); //populate the updated warranty as per the Business Category
                //Nikhil- why are we using the similar functions multiple time. Rather create single function and pass parameters
                saveScrapUsers();
                saveWaferUsers();
                saveNotifyUsers();
                saveNonFabUsers();
                saveFabUsers();
                saveTurnkeyUsers();
                
                if(RMArecord.Acknowledged_Wafer_Return__c){
                  RMArecord.Acknowledge_By_Wafer_Return__c = userInfo.getUserId();
                  RMArecord.Acknowledge_On_Wafer_Return__c = DateTime.now();
                }
                if(RMArecord.Acknowledged_Wafer_Scrap__c){
                  RMArecord.Acknowledge_By_Wafer_Scrap__c = userInfo.getUserId();
                  RMArecord.Acknowledge_On_Wafer_Scrap__c = DateTime.now();
                }
                RMArecord.ReAssign_To__c = reAssign;
                if(RMArecord.Return_Classes__c != NULL){
                    RMArecord.Technical_Return_Classification__c = RMArecord.Return_Classes__c;
                }
                
                //Check RMA due to Field reliability Failure? field is checked
                if(RMArecord.Count_Line_Item__c != NULL && RMArecord.Count_Line_Item__c>0){
                     hasError = RMA_field_Validation_Helper.validateFieldReliability(RMArecord);    
                }
                if(!hasError){
                    update RMArecord;
                    if(RMArecord.ReAssign_To__c != NULL && RMArecord.ReAssign_To__c != ''){
                        approveRecord(RMArecord,reAssign);
                    }
                }  
                
                PageReference pageRef;
                pageRef = new PageReference('/apex/RMA_view?id='+ RMArecord.Id + '&selTab='+selTab);
                pageRef.setRedirect(True);
                return hasError ? null : pageRef;   
            }
        }catch(Exception e){
            if(e.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You don\'t have permission to edit this record.'));
            }
            else if(!e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            }else{
                    ApexPages.addmessages(e);
            }
            return NULL;
        }
    }
    
    public pageReference CreateRMA(){
        try{
            hasError = false;
            
            if(RMArecord.Fab__c == NULL || RMArecord.Customer__c == NULL || RMArecord.Customer_Request_Date__c == NULL || RMArecord.RMA_By__c == NULL){
                RMA_Field_Validation_Helper.validateBeforeInsert(new List<RMA__c>{RMArecord});
                return NULL;
            }
            string itClause = '';
            if(RMArecord.RMA_By__c == 'Wafer'){
                itClause = ' AND Item_Type__c NOT IN (\'TK\',\'SD\',\'MOD\',\'DEV\')';
            }else if(RMArecord.RMA_By__c == 'Die'){
                itClause = ' AND (Item_Type__c = \'TK\' OR Part_Number__c like \'%*%\' OR Item_Type__c = \'DEV\')';
            }else if(RMArecord.RMA_By__c == 'Module'){
                itClause = ' AND ( Item_Type__c IN (\'MOD\') ) ';
            }
            List<Invoice__c> lstInvAvailable = database.query('SELECT Id FROM Invoice__c '+
                                                               ' WHERE Customer_Name__c = \''+ RMArecord.Customer__c + '\'' +
                                                               '   AND Fab_Group__c = \'' + RMArecord.Fab__c + '\'' + itClause +'limit 1');
            if(!lstInvAvailable.isEmpty()){
                //Rma raised.
                RMArecord.Workflow_Stage__c = 'RMA Raised';
                calculateBusinessCategory();
                //for R81
                if(isFab9or10 && RMArecord.RMA_Category__c != NULL && RMArecord.RMA_Category__c.equalsIgnoreCase('Failure Analysis') 
                && RMArecord.ReasonCode__c.equalsIgnoreCase('R81') && RMArecord.Customer__c != NULL){
                    RMArecord.Alternative_Customer__c = RMArecord.Customer__c;
                }
                insert RMArecord;
                PageReference pageRef = new PageReference('/apex/RMA_Edit?id='+RMArecord.Id);
                pageRef.setRedirect(True);
                return pageRef;
            }else{
                if(RMArecord.Fab__c != ''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Invoice exists for the selection.'));
                }
                return NULL;
            }
            
        }catch(Exception e){
            if(!e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                return null;
            }else{
                ApexPages.addmessages(e);
                return null;
            }
        }
        return NULL;
    }
    
    //for receiver names for Scrap Certificate
    public pageReference showScrapPopUp(){
      showScrapReceiver = true;
      return null;
    }
    
    public pageReference cancelScrapPopUp(){
      showScrapReceiver = false;
      return null;
    }
    
    public pageReference addScrapUsersToField(){
      String names = '';
      for(String s: rightScrapUserValues){
        names += s +',';
      }
      names = names.removeEnd(',');
      RMArecord.Receiver_Names_for_Scrap__c = names;
      showScrapReceiver = false;
      return null;
    }
    
    public void retrieveScrapUsers(){
      if(!scrapUserList.isEmpty()){
        for(RMA_Access_User__c member: scrapUserList){
          rightScrapUserValues.add(member.User_Name__c);
          rightScrapUserMap.put(member.User_Name__c, member.User__c);
        }
      }
    }
    
    public pageReference selectScrapUserClick(){
      rightSelectedUsersForScrap.clear();
      for(String s : leftSelectedUsersForScrap){
          leftScrapUserValues.remove(s);
            if(!rightScrapUserValues.contains(s)){
              rightScrapUserValues.add(s); 
            }
            for(string key : leftScrapUserMap.keySet()){
              if(key == s){
                  rightScrapUserMap.put(key, leftScrapUserMap.get(key));    
                }
            }
            leftScrapUserMap.remove(s);
        }
        return null;
    }
    
    public PageReference unselectScrapUserClick(){
      leftSelectedUsersForScrap.clear();
        for(String s : rightSelectedUsersForScrap){
          rightScrapUserValues.remove(s);
            leftScrapUserValues.add(s);
            for(String key: rightScrapUserMap.keySet()){
              if(key == s){
                  leftScrapUserMap.put(key, rightScrapUserMap.get(key));
                }
            }
            if(!scrapUserList.isEmpty()){
                List<RMA_Access_User__c> lstToDeleteForScrap = new List<RMA_Access_User__c>(); 
                for(RMA_Access_User__c member: scrapUserList){
                    if(member.User__c == rightScrapUserMap.get(s)){
                        lstToDeleteForScrap.add(member);
                    }
                } 
                if(!lstToDeleteForScrap.isEmpty()){
                    delete lstToDeleteForScrap;
                }      
            }
            rightScrapUserMap.remove(s);
        }
        return null;
    }
    
    public List<SelectOption> getunselectedScrapUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(leftScrapUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public List<SelectOption> getSelectedScrapUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(rightScrapUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    } 
    
    public void SearchScrapUser(){
      String s = '%'+searchScrapUser+'%';
      leftScrapUserValues.clear();
      leftScrapUserMap.clear();
      for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
          leftScrapUserValues.add(searchedUser.Name);
          leftScrapUserMap.put(searchedUser.Name, searchedUser.Id);
        }
      searchScrapUser = '';  
    }
    
    public void saveScrapUsers(){
      List<RMA_Access_User__c> selectedScrapUserList = new List<RMA_Access_User__c>();
      if(!rightScrapUserMap.isEmpty()){
        for(String key: rightScrapUserMap.keySet()){
          selectedScrapUserList.add(new RMA_Access_User__c(RMA__c = RMArecord.Id, User__c = rightScrapUserMap.get(key), Category__c = 'Scrap Certificate'));
        }
      }
      Set<Id> existingScrapUserList = new Set<Id>();
      for(RMA_Access_User__c access: scrapUserList){
        existingScrapUserList.add(access.User__c);
      }
      if(!selectedScrapUserList.isEmpty()){
        if(!scrapUserList.isEmpty()){
            List<RMA_Access_User__c> lstInsertForScrap = new List<RMA_Access_User__c>();
          for(RMA_Access_User__c access1: selectedScrapUserList){
            for(RMA_Access_User__c access2: scrapUserList){
              if(access1.User__c != access2.User__c){
                if(!existingScrapUserList.contains(access1.User__c)){
                     lstInsertForScrap.add(access1);
                     break;           
                }
              }
            }
          }
          if(!lstInsertForScrap.isEmpty()){
            insert lstInsertForScrap;
          }
        }
        else{
          upsert selectedScrapUserList;
        }
      }
    }
    
    //For Return Wafer
    public pageReference showWaferPopUp(){
      showWaferReceiver = true;
      return null;
    }
    
    public pageReference cancelWaferPopUp(){
      showWaferReceiver = false;
      return null;
    }
    
    public pageReference addWaferUsersToField(){
      String names = '';
      for(String s: rightWaferUserValues){
        names += s +',';
      }
      names = names.removeEnd(',');
      RMArecord.Receiver_Names_for_Wafer__c = names;
      showWaferReceiver = false;
      return null;
    }
    
    public void retrieveWaferUsers(){
      if(!WaferUserList.isEmpty()){
        for(RMA_Access_User__c member: WaferUserList){
          rightWaferUserValues.add(member.User_Name__c);
          rightWaferUserMap.put(member.User_Name__c, member.User__c);
        }
      }
    }
    
    public pageReference selectWaferUserClick(){
      rightSelectedUsersForWafer.clear();
      for(String s : leftSelectedUsersForWafer){
          leftWaferUserValues.remove(s);
            if(!rightWaferUserValues.contains(s)){
              rightWaferUserValues.add(s); 
            }
            for(string key : leftWaferUserMap.keySet()){
              if(key == s){
                  rightWaferUserMap.put(key, leftWaferUserMap.get(key));    
                }
            }
            leftWaferUserMap.remove(s);
        }
        return null;
    }
    
    public PageReference unselectWaferUserClick(){
      leftSelectedUsersForWafer.clear();
        for(String s : rightSelectedUsersForWafer){
          rightWaferUserValues.remove(s);
            leftWaferUserValues.add(s);
            for(String key: rightWaferUserMap.keySet()){
              if(key == s){
                  leftWaferUserMap.put(key, rightWaferUserMap.get(key));
                }
            }
            if(!WaferUserList.isEmpty()){
                List<RMA_Access_User__c> lstToDeleteForWafer = new List<RMA_Access_User__c>();  
              for(RMA_Access_User__c member: WaferUserList){
                  if(member.User__c == rightWaferUserMap.get(s)){
                      lstToDeleteForWafer.add(member);
                    }
                } 
                if(!lstToDeleteForWafer.isEmpty()){
                    delete lstToDeleteForWafer;
                }      
            }
            rightWaferUserMap.remove(s);
        }
        return null;
    }
    
    public List<SelectOption> getunselectedWaferUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(leftWaferUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public List<SelectOption> getSelectedWaferUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(rightWaferUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public void SearchWaferUser(){
      String s = '%'+searchWaferUser+'%';
      leftWaferUserValues.clear();
      leftWaferUserMap.clear();
      for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
          leftWaferUserValues.add(searchedUser.Name);
          leftWaferUserMap.put(searchedUser.Name, searchedUser.Id);
        }
      searchWaferUser = '';  
    }
    
    public void saveWaferUsers(){
      List<RMA_Access_User__c> selectedWaferUserList = new List<RMA_Access_User__c>();
      if(!rightWaferUserMap.isEmpty()){
        for(String key: rightWaferUserMap.keySet()){
          selectedWaferUserList.add(new RMA_Access_User__c(RMA__c = RMArecord.Id, User__c = rightWaferUserMap.get(key), Category__c = 'Return Wafer'));
        }
      }
      Set<Id> existingWaferUserList = new Set<Id>();
      for(RMA_Access_User__c access: WaferUserList){
        existingWaferUserList.add(access.User__c);
      }
      if(!selectedWaferUserList.isEmpty()){
        if(!WaferUserList.isEmpty()){
            List<RMA_Access_User__c> lstToInsertForWafer = new List<RMA_Access_User__c>();
          for(RMA_Access_User__c access1: selectedWaferUserList){
            for(RMA_Access_User__c access2: WaferUserList){
              if(access1.User__c != access2.User__c){
                if(!existingWaferUserList.contains(access1.User__c)){
                 lstToInsertForWafer.add(access1);
                 break;           
                }
              }
            }
          }
          if(!lstToInsertForWafer.isEmpty()){
            insert lstToInsertForWafer;
          }
        }
        else{
          upsert selectedWaferUserList;
        }
      }
    }
    
    //For Notify / Circulate to (FE / Fab YE / Others)
  public pageReference showNotifyPopUp(){
      showNotifyReceiver = true;
      return null;
    }
    
    public pageReference cancelNotifyPopUp(){
      showNotifyReceiver = false;
      return null;
    }
    
    public pageReference addNotifyUsersToField(){
      String names = '';
      for(String s: rightNotifyUserValues){
        names += s +',';
      }
      names = names.removeEnd(',');
      RMArecord.Notify_Circulate_to_FE_Fab_YE_Others__c = names;
      showNotifyReceiver = false;
      return null;
    }
    
    public void retrieveNotifyUsers(){
      if(!NotifyUserList.isEmpty()){
        for(RMA_Access_User__c member: NotifyUserList){
          rightNotifyUserValues.add(member.User_Name__c);
          rightNotifyUserMap.put(member.User_Name__c, member.User__c);
        }
      }
    }
    
    public pageReference selectNotifyUserClick(){
      rightSelectedUsersForNotify.clear();
      for(String s : leftSelectedUsersForNotify){
          leftNotifyUserValues.remove(s);
            if(!rightNotifyUserValues.contains(s)){
              rightNotifyUserValues.add(s); 
            }
            for(string key : leftNotifyUserMap.keySet()){
              if(key == s){
                  rightNotifyUserMap.put(key, leftNotifyUserMap.get(key));    
                }
            }
            leftNotifyUserMap.remove(s);
        }
        return null;
    }
    
    public PageReference unselectNotifyUserClick(){
      leftSelectedUsersForNotify.clear();
        for(String s : rightSelectedUsersForNotify){
          rightNotifyUserValues.remove(s);
            leftNotifyUserValues.add(s);
            for(String key: rightNotifyUserMap.keySet()){
              if(key == s){
                  leftNotifyUserMap.put(key, rightNotifyUserMap.get(key));
                }
            }
            if(!NotifyUserList.isEmpty()){
                List<RMA_Access_User__c> lstToDeleteForNotify = new List<RMA_Access_User__c>(); 
              for(RMA_Access_User__c member: NotifyUserList){
                  if(member.User__c == rightNotifyUserMap.get(s)){
                      lstToDeleteForNotify.add(member);
                    }
                }  
                if(!lstToDeleteForNotify.isEmpty()){
                    delete lstToDeleteForNotify;
                }     
            }
            rightNotifyUserMap.remove(s);
        }
        return null;
    }
    
    public List<SelectOption> getunselectedNotifyUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(leftNotifyUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public List<SelectOption> getSelectedNotifyUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(rightNotifyUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public void SearchNotifyUser(){
      String s = '%'+searchNotifyUser+'%';
      leftNotifyUserValues.clear();
      leftNotifyUserMap.clear();
      for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
          leftNotifyUserValues.add(searchedUser.Name);
          leftNotifyUserMap.put(searchedUser.Name, searchedUser.Id);
        }
      searchNotifyUser = '';  
    }
    
    public void saveNotifyUsers(){
      List<RMA_Access_User__c> selectedNotifyUserList = new List<RMA_Access_User__c>();
      if(!rightNotifyUserMap.isEmpty()){
        for(String key: rightNotifyUserMap.keySet()){
          selectedNotifyUserList.add(new RMA_Access_User__c(RMA__c = RMArecord.Id, User__c = rightNotifyUserMap.get(key), Category__c = 'Notify/Circulate'));
        }
      }
      Set<Id> existingNotifyUserList = new Set<Id>();
      for(RMA_Access_User__c access: NotifyUserList){
        existingNotifyUserList.add(access.User__c);
      }
      if(!selectedNotifyUserList.isEmpty()){
        if(!NotifyUserList.isEmpty()){
            List<RMA_Access_User__c> lstToInsertForNotify = new List<RMA_Access_User__c>(); 
          for(RMA_Access_User__c access1: selectedNotifyUserList){
            for(RMA_Access_User__c access2: NotifyUserList){
              if(access1.User__c != access2.User__c){
                if(!existingNotifyUserList.contains(access1.User__c)){
                 lstToInsertForNotify.add(access1);
                 break;           
                }
              }
            }
          }
          if(!lstToInsertForNotify.isEmpty()){
            insert lstToInsertForNotify;
          }
        }
        else{
          upsert selectedNotifyUserList;
        }
      }
    }
    
    //For Non Fab Validation
  public pageReference showNonFabPopUp(){
      showNonFabReceiver = true;
      return null;
    }
    
    public pageReference cancelNonFabPopUp(){
      showNonFabReceiver = false;
      return null;
    }
    
    public pageReference addNonFabUsersToField(){
      String names = '';
      for(String s: rightNonFabUserValues){
        names += s +',';
      }
      names = names.removeEnd(',');
      RMArecord.Notify_For_Non_Fab__c = names;
      showNonFabReceiver = false;
      return null;
    }
    
    public void retrieveNonFabUsers(){
      if(!NonFabUserList.isEmpty()){
        for(RMA_Access_User__c member: NonFabUserList){
          rightNonFabUserValues.add(member.User_Name__c);
          rightNonFabUserMap.put(member.User_Name__c, member.User__c);
        }
      }
    }
    
    public pageReference selectNonFabUserClick(){
      boolean success = false;
      rightSelectedUsersForNonFab.clear();
      for(String s : leftSelectedUsersForNonFab){
          if(rightNonFabUserValues.size() < 10){
            leftNonFabUserValues.remove(s);
              if(!rightNonFabUserValues.contains(s)){
                rightNonFabUserValues.add(s); 
              }
              success = true;
          }
          else{
            success = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can add only 10 users as approvers.'));
          }
          if(success){
              for(string key : leftNonFabUserMap.keySet()){
                if(key == s){
                    rightNonFabUserMap.put(key, leftNonFabUserMap.get(key));    
                  }
              }
              leftNonFabUserMap.remove(s);  
          }
        }
        return null;
    }
    
    public PageReference unselectNonFabUserClick(){
        leftSelectedUsersForNonFab.clear();
        for(String s : rightSelectedUsersForNonFab){
          rightNonFabUserValues.remove(s);
            leftNonFabUserValues.add(s);
            for(String key: rightNonFabUserMap.keySet()){
              if(key == s){
                  leftNonFabUserMap.put(key, rightNonFabUserMap.get(key));
                }
            }
            if(!NonFabUserList.isEmpty()){
                List<RMA_Access_User__c> lstToDeleteForNonFab = new List<RMA_Access_User__c>();
              for(RMA_Access_User__c member: NonFabUserList){
                  if(member.User__c == rightNonFabUserMap.get(s)){
                      lstToDeleteForNonFab.add(member);
                    }
                } 
                if(!lstToDeleteForNonFab.isEmpty()){
                    delete lstToDeleteForNonFab;
                }      
            }
            rightNonFabUserMap.remove(s);
        }
        return null;
    }
    
    public List<SelectOption> getunselectedNonFabUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(leftNonFabUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public List<SelectOption> getSelectedNonFabUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(rightNonFabUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public void SearchNonFabUser(){
      String s = '%'+searchNonFabUser+'%';
      leftNonFabUserValues.clear();
      leftNonFabUserMap.clear();
      for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
          leftNonFabUserValues.add(searchedUser.Name);
          leftNonFabUserMap.put(searchedUser.Name, searchedUser.Id);
        }
      searchNonFabUser = '';  
    }

    public void saveNonFabUsers(){
        List<RMA_Access_User__c> selectedNonFabUserList = new List<RMA_Access_User__c>();
        if(!rightNonFabUserMap.isEmpty()){
            for(String key: rightNonFabUserMap.keySet()){
                selectedNonFabUserList.add(new RMA_Access_User__c(RMA__c = RMArecord.Id, User__c = rightNonFabUserMap.get(key), Category__c = 'Non Fab'));
            }
        }
        if(selectedNonFabUserList.size() <= 10){
            if(selectedNonFabUserList.size() > 0){
                RMArecord.Non_Fab_Personnel_1__c = selectedNonFabUserList[0].User__c;
            }
            if(selectedNonFabUserList.size() > 1){
                RMArecord.Non_Fab_Personnel_2__c = selectedNonFabUserList[1].User__c;
            }
            if(selectedNonFabUserList.size() > 2){
                RMArecord.Non_Fab_Personnel_3__c = selectedNonFabUserList[2].User__c;
            }
            if(selectedNonFabUserList.size() > 3){
                RMArecord.Non_Fab_Personnel_4__c = selectedNonFabUserList[3].User__c;
            }
            if(selectedNonFabUserList.size() > 4){
                RMArecord.Non_Fab_Personnel_5__c = selectedNonFabUserList[4].User__c;
            }
            if(selectedNonFabUserList.size() > 5){
                RMArecord.Non_Fab_Personnel_6__c = selectedNonFabUserList[5].User__c;
            }
            if(selectedNonFabUserList.size() > 6){
                RMArecord.Non_Fab_Personnel_7__c = selectedNonFabUserList[6].User__c;
            }
            if(selectedNonFabUserList.size() > 7){
                RMArecord.Non_Fab_Personnel_8__c = selectedNonFabUserList[7].User__c;
            }
            if(selectedNonFabUserList.size() > 8){
                RMArecord.Non_Fab_Personnel_9__c = selectedNonFabUserList[8].User__c;
            }
            if(selectedNonFabUserList.size() > 9){
                RMArecord.Non_Fab_Personnel_10__c = selectedNonFabUserList[9].User__c;
            }
        }
        Set<Id> existingNonFabUserList = new Set<Id>();
        for(RMA_Access_User__c access: NonFabUserList){
            existingNonFabUserList.add(access.User__c);
        }
        if(!selectedNonFabUserList.isEmpty()){
            if(!NonFabUserList.isEmpty()){
                List<RMA_Access_User__c> lstToInsertForNonFab = new List<RMA_Access_User__c>();
                for(RMA_Access_User__c access1: selectedNonFabUserList){
                    for(RMA_Access_User__c access2: NonFabUserList){
                        if(access1.User__c != access2.User__c){
                            if(!existingNonFabUserList.contains(access1.User__c)){
                                lstToInsertForNonFab.add(access1);
                                break;           
                            }
                        }
                    }
                }
                if(!lstToInsertForNonFab.isEmpty()){
                    insert lstToInsertForNonFab;
                }
            }else{
                upsert selectedNonFabUserList;
            }
        }
    }
        
    //For Fab Validation
    public pageReference showFabPopUp(){
      showFabReceiver = true;
      return null;
    }
        public pageReference cancelFabPopUp(){
      showFabReceiver = false;
      return null;
    }
    
    public pageReference addFabUsersToField(){
      String names = '';
      for(String s: rightFabUserValues){
        names += s +',';
      }
      names = names.removeEnd(',');
      RMArecord.Notify_For_Fab__c = names;
      showFabReceiver = false;
      return null;
    }
    
    public void retrieveFabUsers(){
      if(!FabUserList.isEmpty()){
        for(RMA_Access_User__c member: FabUserList){
          rightFabUserValues.add(member.User_Name__c);
          rightFabUserMap.put(member.User_Name__c, member.User__c);
        }
      }
    }
    
    public pageReference selectFabUserClick(){
      boolean success = false;
      rightSelectedUsersForFab.clear();
      for(String s : leftSelectedUsersForFab){
          if(rightFabUserValues.size() < 10){
            leftFabUserValues.remove(s);
              if(!rightFabUserValues.contains(s)){
                rightFabUserValues.add(s); 
              }
              success = true;
          }
          else{
            success = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can only add upto 10 users.'));
          }
          if(success){
              for(string key : leftFabUserMap.keySet()){
                if(key == s){
                    rightFabUserMap.put(key, leftFabUserMap.get(key));    
                  }
              }
              leftFabUserMap.remove(s);  
          }
        }
        return null;
    }
    
    public PageReference unselectFabUserClick(){
        leftSelectedUsersForFab.clear();
        for(String s : rightSelectedUsersForFab){
          rightFabUserValues.remove(s);
            leftFabUserValues.add(s);
            for(String key: rightFabUserMap.keySet()){
              if(key == s){
                  leftFabUserMap.put(key, rightFabUserMap.get(key));
                }
            }
            if(!FabUserList.isEmpty()){
                List<RMA_Access_User__c> lstToDeleteForFab = new List<RMA_Access_User__c>(); 
              for(RMA_Access_User__c member: FabUserList){
                  if(member.User__c == rightFabUserMap.get(s)){
                      lstToDeleteForFab.add(member);
                    }
                }
                if(!lstToDeleteForFab.isEmpty()){
                    delete lstToDeleteForFab;
                }       
            }
            rightFabUserMap.remove(s);
        }
        return null;
    }
    
    public List<SelectOption> getunselectedFabUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(leftFabUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public List<SelectOption> getSelectedFabUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(rightFabUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public void SearchFabUser(){
      String s = '%'+searchFabUser+'%';
      leftFabUserValues.clear();
      leftFabUserMap.clear();
      for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
          leftFabUserValues.add(searchedUser.Name);
          leftFabUserMap.put(searchedUser.Name, searchedUser.Id);
        }
      searchFabUser = '';  
    }
    
    public void saveFabUsers(){
      sendEmail = false;
      List<RMA_Access_User__c> selectedFabUserList = new List<RMA_Access_User__c>();
      if(!rightFabUserMap.isEmpty()){
        for(String key: rightFabUserMap.keySet()){
          selectedFabUserList.add(new RMA_Access_User__c(RMA__c = RMArecord.Id, User__c = rightFabUserMap.get(key), Category__c = 'Fab'));
        }
      }
      Set<Id> existingFabUserList = new Set<Id>();
      for(RMA_Access_User__c access: FabUserList){
        existingFabUserList.add(access.User__c);
      }
      if(!selectedFabUserList.isEmpty()){
        if(!FabUserList.isEmpty()){
          List<RMA_Access_User__c> lstToInsertForFab = new List<RMA_Access_User__c>();
          for(RMA_Access_User__c access1: selectedFabUserList){
            for(RMA_Access_User__c access2: FabUserList){
              if(access1.User__c != access2.User__c){
                 if(!existingFabUserList.contains(access1.User__c)){
                     lstToInsertForFab.add(access1);
                     break;           
                }
              }
            }
          }
          if(!lstToInsertForFab.isEmpty()){
            insert lstToInsertForFab;
            sendEmail = true;
          }
        }
        else{
          upsert selectedFabUserList;
          if(existingFabUserList.isEmpty()){
            sendEmail = true;
          }
        }
        if(sendEmail){
            RMA_Email_Notification_Helper.checkTechValidator(RMArecord,RMArecord.Workflow_Stage__c,userInfo.getUserEmail());
        }
      }
    }
    
    //For Turnkey Validation
    public pageReference showTurnkeyPopUp(){
      showTurnkeyReceiver = true;
      return null;
    }
    
    public pageReference cancelTurnkeyPopUp(){
      showTurnkeyReceiver = false;
      return null;
    }
    
    public pageReference addTurnkeyUsersToField(){
      String names = '';
      for(String s: rightTurnkeyUserValues){
        names += s +',';
      }
      names = names.removeEnd(',');
      RMArecord.Notify_For_Turnkey__c = names;
      showTurnkeyReceiver = false;
      return null;
    }
    
    public void retrieveTurnkeyUsers(){
      if(!TurnkeyUserList.isEmpty()){
        for(RMA_Access_User__c member: TurnkeyUserList){
          rightTurnkeyUserValues.add(member.User_Name__c);
          rightTurnkeyUserMap.put(member.User_Name__c, member.User__c);
        }
      }
    }
    
    public pageReference selectTurnkeyUserClick(){
      boolean success = false;
      rightSelectedUsersForTurnkey.clear();
      for(String s : leftSelectedUsersForTurnkey){
          if(rightTurnkeyUserValues.size() < 10){
            leftTurnkeyUserValues.remove(s);
              if(!rightTurnkeyUserValues.contains(s)){
                rightTurnkeyUserValues.add(s); 
              }
              success = true;
          }
          else{
            success = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can only add upto 10 users.'));
          }
          if(success){
              for(string key : leftTurnkeyUserMap.keySet()){
                if(key == s){
                    rightTurnkeyUserMap.put(key, leftTurnkeyUserMap.get(key));    
                  }
              }
              leftTurnkeyUserMap.remove(s);  
          }
        }
        return null;
    }
    
    public PageReference unselectTurnkeyUserClick(){
        leftSelectedUsersForTurnkey.clear();
        for(String s : rightSelectedUsersForTurnkey){
          rightTurnkeyUserValues.remove(s);
            leftTurnkeyUserValues.add(s);
            for(String key: rightTurnkeyUserMap.keySet()){
              if(key == s){
                  leftTurnkeyUserMap.put(key, rightTurnkeyUserMap.get(key));
                }
            }
            if(!TurnkeyUserList.isEmpty()){
                List<RMA_Access_User__c> lstToDeleteForTurnkey = new List<RMA_Access_User__c>();
              for(RMA_Access_User__c member: TurnkeyUserList){
                  if(member.User__c == rightTurnkeyUserMap.get(s)){
                      lstToDeleteForTurnkey.add(member);
                    }
                }       
                if(!lstToDeleteForTurnkey.isEmpty()){
                    delete lstToDeleteForTurnkey;
                }
            }
            rightTurnkeyUserMap.remove(s);
        }
        return null;
    }
    
    public List<SelectOption> getunselectedTurnkeyUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(leftTurnkeyUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public List<SelectOption> getSelectedTurnkeyUserValues(){
      List<SelectOption> options = new List<SelectOption>();
      List<String> tempList = new List<String>();
      tempList.addAll(rightTurnkeyUserValues);
      tempList.sort();
      for(String s: tempList){
        options.add(new SelectOption(s,s));
      }
      return options;
    }
    
    public void SearchTurnkeyUser(){
      String s = '%'+searchTurnkeyUser+'%';
      leftTurnkeyUserValues.clear();
      leftTurnkeyUserMap.clear();
      for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
          leftTurnkeyUserValues.add(searchedUser.Name);
          leftTurnkeyUserMap.put(searchedUser.Name, searchedUser.Id);
        }
        searchTurnkeyUser = '';
    }
    
    public void saveTurnkeyUsers(){
      sendEmail = false;
      List<RMA_Access_User__c> selectedTurnkeyUserList = new List<RMA_Access_User__c>();
      if(!rightTurnkeyUserMap.isEmpty()){
        for(String key: rightTurnkeyUserMap.keySet()){
          selectedTurnkeyUserList.add(new RMA_Access_User__c(RMA__c = RMArecord.Id, User__c = rightTurnkeyUserMap.get(key), Category__c = 'Turnkey'));
        }
      }
      Set<Id> existingTurnkeyUserList = new Set<Id>();
      for(RMA_Access_User__c access: TurnkeyUserList){
        existingTurnkeyUserList.add(access.User__c);
      }
      if(!selectedTurnkeyUserList.isEmpty()){
        if(!TurnkeyUserList.isEmpty()){
            List<RMA_Access_User__c> lstToInsertForTurnkey = new List<RMA_Access_User__c>();
          for(RMA_Access_User__c access1: selectedTurnkeyUserList){
            for(RMA_Access_User__c access2: TurnkeyUserList){
              if(access1.User__c != access2.User__c){
                if(!existingTurnkeyUserList.contains(access1.User__c)){
                 lstToInsertForTurnkey.add(access1);
                 break;           
                }
              }
            }
          }
          if(!lstToInsertForTurnkey.isEmpty()){
            insert lstToInsertForTurnkey;
            sendEmail = true;
          }
        }
        else{
          upsert selectedTurnkeyUserList;
          if(existingTurnkeyUserList.isEmpty()){
            sendEmail = true;
          } 
        }
        if(sendEmail && !RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            RMA_Email_Notification_Helper.checkTechValidator(RMArecord,RMArecord.Workflow_Stage__c,userInfo.getUserEmail());
        }
      }
    }

    public class LineItemWrapper{
        public RMA_Return_Invoice__c RIrec{get;set;}
        public String LotNumber{get;set;}
        public Decimal TotalCSR{get;set;}
        public Decimal TotalTec{get;set;}
        public Decimal TotalReg{get;set;}
        public Decimal WaferDieAmt{get;set;}
        public Decimal AdjustedAmt{get;set;}
        public LineItemWrapper(RMA_Return_Invoice__c ri,String lotNo){
            RIrec     = ri;
            LotNumber = lotNo;
            TotalCSR  = ri.Total_Price__c;
            TotalTec  = ri.Total_Price_FAB_Validation__c;
            TotalReg  = ri.Total_Price_Final__c;
            if(ri.RMA_By__c == 'Wafer' || ri.RMA_By__c == 'Module'){
                WaferDieAmt = ri.Wafer_Die_Unit_Price__c;
            }else if(ri.RMA_By__c == 'Die'){
                WaferDieAmt = ri.Die_Selling_Price__c;
            }
            AdjustedAmt = ri.Adjusted_Unit_Price__c;
        }
    }
    
    //Handle the deletion of Return Invoice/ Line Item
    public PageReference DeleteLineItem(){
        string LotIdtoRemove= [select Lot_Number__c from RMA_Return_Invoice__c where id=:LineItemToEdit].Lot_Number__c;
        database.delete(new RMA_Return_Invoice__c(id=LineItemToEdit));
        
        return refreshPage();
    }
    
    
    //Handle the Edit of Return Invoice/ Line Item
    public SelectOption[] leftOptions{get;set;}
    public SelectOption[] rightOptions{get;set;}
    public string adjustedPrice{get;set;}
    public string waferYield{get;set;}
    public string scrapLimit{get;set;}
    public string dieQuantity{get;set;}
    public string modQuantity{get;set;}
    public string formFactor{get;set;}
    public string formFactorQuantity{get;set;}
    public string itemType{get;set;}
    public string rejectionComments{get;set;}
    RMA_Return_Invoice__c rmaRIrec;
    
    public PageReference EditLineItem() {
        leftOptions  = new List<SelectOption>();
        rightOptions = new List<SelectOption>();
        showPopUp = True;
        rmaRIrec = [SELECT Id,Adjusted_Unit_Price__c,Scrap_Limit__c,Wafer_Yield__c,Wafer_Id_CSR_Submission__c,Wafer_Id_Fab_9_10_CSR_Submission__c,
                        Invoice__r.Wafer_Id__c,Die_Quantity__c,GDPW__c,Die_Selling_Price__c,Invoice__r.Item_Type__c,Fab_Group__c,Module_Quantity__c,
                        Existing_Form_Factor__c,Existing_Form_Factor_Quantity__c
                    FROM RMA_Return_Invoice__c 
                    WHERE Id=:LineItemToEdit];
        if(rmaRIrec != NULL){
            if(!RMA_Utility.checkFab9or10(rmaRIrec.Fab_Group__c)){
                if(rmaRIrec.Wafer_Id_CSR_Submission__c != NULL && rmaRIrec.Wafer_Id_CSR_Submission__c != ''){
                    for(String str: rmaRIrec.Wafer_Id_CSR_Submission__c.split(';')){
                        rightOptions.add(new SelectOption(str,str));
                    }
                }                            
            }else{
                if(rmaRIrec.Wafer_Id_Fab_9_10_CSR_Submission__c != NULL && rmaRIrec.Wafer_Id_Fab_9_10_CSR_Submission__c != ''){
                    for(String str: rmaRIrec.Wafer_Id_Fab_9_10_CSR_Submission__c.split(';')){
                        rightOptions.add(new SelectOption(str,str));
                    }
                }
            }
            adjustedPrice = String.valueOf(rmaRIrec.Adjusted_Unit_Price__c);
            waferYield    = String.valueOf(rmaRIrec.Wafer_Yield__c);
            scrapLimit    = String.valueOf(rmaRIrec.Scrap_Limit__c);
            dieQuantity   = String.valueOf(rmaRIrec.Die_Quantity__c);
            modQuantity   = String.valueOf(rmaRIrec.Module_Quantity__c);
            formFactor    = String.valueOf(rmaRIrec.Existing_Form_Factor__c);
            formFactorQuantity = String.valueOf(rmaRIrec.Existing_Form_Factor_Quantity__c);
            itemType      = rmaRIrec.Invoice__r.Item_Type__c;
            
            Set<String> setFinalLeftOptions = new Set<String>();
            if(rmaRIrec.Invoice__r.Wafer_Id__c != NULL){
                setFinalLeftOptions.addAll(rmaRIrec.Invoice__r.Wafer_Id__c.split(';'));
            }
            if(!RMA_Utility.checkFab9or10(rmaRIrec.Fab_Group__c)){
                if(rmaRIrec.Wafer_Id_CSR_Submission__c != NULL){
                    setFinalLeftOptions.removeAll(rmaRIrec.Wafer_Id_CSR_Submission__c.split(';'));
                }
            }else{
                if(rmaRIrec.Wafer_Id_Fab_9_10_CSR_Submission__c != NULL){
                    for(String wfrId: rmaRIrec.Wafer_Id_Fab_9_10_CSR_Submission__c.split(';')){
                        setFinalLeftOptions.remove(wfrId.trim());
                    }
                }
            }
            for(String str: setFinalLeftOptions){
                if(str != NULL && str != ''){
                    leftOptions.add(new SelectOption(str,str));
                }
            }
        }
        return null;
    }
    public PageReference UpdateLineItem(){
        try{
            string selLots = '';
            if(RMArecord.RMA_By__c != 'Module' && (RMArecord.RMA_By__c != 'Die' || itemType == 'SD')){
                if(!rightOptions.isEmpty()){
                    for(SelectOption so: rightOptions){
                        selLots += so.getValue() + ';';
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one wafer.'));
                    return NULL;
                }
            }
            if(
               (Pattern.matches('^[0-9]\\d*(\\.\\d+)?$',string.valueOf(adjustedPrice)) || String.isEmpty(adjustedPrice)) &&
               (Pattern.matches('^[0-9]\\d*(\\.\\d+)?$',string.valueOf(waferYield)) || String.isEmpty(waferYield)) &&
               (Pattern.matches('^[0-9]\\d*(\\.\\d+)?$',string.valueOf(scrapLimit)) || String.isEmpty(scrapLimit)) &&
               (rmaRecord.RMA_By__c == 'Die'? (Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(dieQuantity)) || String.isEmpty(dieQuantity)):True) &&
               (rmaRecord.RMA_By__c == 'Module'? (Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(modQuantity)) || String.isEmpty(modQuantity)):True) &&
               (rmaRecord.ReasonCode__c == 'R81'? (Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(formFactorQuantity)) || String.isEmpty(formFactorQuantity)):True)
            ){
                if(rmaRIrec != NULL){
                    if(waferYield != NULL && waferYield != '' && decimal.valueOf(waferYield) != 0){
                        rmaRIrec.Wafer_Yield__c = decimal.valueOf(waferYield);
                    }else{
                        rmaRIrec.Wafer_Yield__c = NULL;
                    }
                    if(scrapLimit != NULL && scrapLimit != '' && decimal.valueOf(scrapLimit) != 0){
                        rmaRIrec.Scrap_Limit__c = decimal.valueOf(scrapLimit);
                    }else{
                        rmaRIrec.Scrap_Limit__c = NULL;
                    }
                    if(adjustedPrice != NULL && adjustedPrice != '' && decimal.valueOf(adjustedPrice) != 0){
                        rmaRIrec.Adjusted_Unit_Price__c = decimal.valueOf(adjustedPrice);
                    }else{
                        rmaRIrec.Adjusted_Unit_Price__c = NULL;
                    }
                    if(dieQuantity != NULL && dieQuantity != '' && decimal.valueOf(dieQuantity) != 0){
                        rmaRIrec.Die_Quantity__c = decimal.valueOf(dieQuantity);
                    }else{
                        rmaRIrec.Die_Quantity__c = NULL;
                    }
                    if(modQuantity != NULL && modQuantity != '' && decimal.valueOf(modQuantity) != 0){
                        rmaRIrec.Module_Quantity__c = decimal.valueOf(modQuantity);
                    }else{
                        rmaRIrec.Module_Quantity__c = NULL;
                    }
                    if(formFactorQuantity != NULL && formFactorQuantity != '' && decimal.valueOf(formFactorQuantity) != 0){
                        rmaRIrec.Existing_Form_Factor_Quantity__c = decimal.valueOf(formFactorQuantity);
                    }else{
                        rmaRIrec.Existing_Form_Factor_Quantity__c = NULL;
                    }                    
                    if(formFactor != NULL && formFactor != ''){
                        rmaRIrec.Existing_Form_Factor__c = formFactor;
                    }else{
                        rmaRIrec.Existing_Form_Factor__c = NULL;
                    }
                    if(!RMA_Utility.checkFab9or10(rmaRIrec.Fab_Group__c)){
                        rmaRIrec.Wafer_Id_CSR_Submission__c = selLots;
                    }else{
                        rmaRIrec.Wafer_Id_Fab_9_10_CSR_Submission__c = selLots;
                    }
                    update rmaRIrec;
                    return refreshPage();
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid input. Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
            }
        }catch(Exception e){
			//Throwing the message through trigger
        }
        return NULL;
    }
    public PageReference CancelPopup(){
        showPopUp    = false;
        LineItemToEdit= '';
        adjustedPrice = NULL;
        waferYield = NULL;
        scrapLimit = NULL;
        dieQuantity= NULL;
        modQuantity= NULL;
        formFactor = NULL;
        formFactorQuantity= NULL;
        itemType = NULL;
        rightOptions.clear();
        leftOptions.clear();
        return NULL;
    }
    
    public PageReference ExportLineItem(){
        PageReference pageRef =  new PageReference('/apex/RMA_ExportLineItem?id='+RMArecord.Id);
        return pageRef;
    }
    
    //For Fab Validation
    public SelectOption[] leftFabValidatedOptions{get;set;}
    public SelectOption[] righFabValidatedtOptions{get;set;}
    RMA_Return_Invoice__c rmaRIrec1;
    
    public PageReference EditLineItemForFabValidation() {
        leftFabValidatedOptions  = new List<SelectOption>();
        righFabValidatedtOptions = new List<SelectOption>();
        showPopUpForFab = True;
        rmaRIrec1 = [SELECT Id,Adjusted_Unit_Price__c,Scrap_Limit__c,Wafer_Yield__c,Wafer_Id_CSR_Submission__c,
                            Wafer_Id_Fab_Validated__c,Wafer_Id_Fab_In_Validated__c,Wafer_Quantity__c,Die_Quantity__c,
                            Total_Wfr_Qty_after_validation__c,Invoice__r.Wafer_Id__c,Die_Quantity_Fab_Validated__c,Module_Quantity__c,
                            Wafer_Id_Fab_9_10_Fab_Validated__c,Wafer_Id_Fab_9_10_Fab_Invalidated__c,Module_Quantity_Fab_Validated__c
                        FROM RMA_Return_Invoice__c 
                        WHERE Id=:LineItemToEditForFab];
        if(rmaRIrec1 != NULL){
            if(RMArecord.RMA_By__c == 'Wafer'){
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec1.Wafer_Id_Fab_Validated__c != null){
                    for(String str: rmaRIrec1.Wafer_Id_Fab_Validated__c.split(';')){
                        leftFabValidatedOptions.add(new SelectOption(str,str));
                    }
                }else if(RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec1.Wafer_Id_Fab_9_10_Fab_Validated__c != null){
                    for(String str: rmaRIrec1.Wafer_Id_Fab_9_10_Fab_Validated__c.split(';')){
                        leftFabValidatedOptions.add(new SelectOption(str,str));
                    }
                }
                
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec1.Wafer_Id_Fab_In_Validated__c != null){
                    for(String str: rmaRIrec1.Wafer_Id_Fab_In_Validated__c.split(';')){
                        righFabValidatedtOptions.add(new SelectOption(str,str));
                    }
                }else if(RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec1.Wafer_Id_Fab_9_10_Fab_Invalidated__c != null){
                    for(String str: rmaRIrec1.Wafer_Id_Fab_9_10_Fab_Invalidated__c.split(';')){
                        righFabValidatedtOptions.add(new SelectOption(str,str));
                    }
                }
            }else if(RMArecord.RMA_By__c == 'Die'){                
                DieQuantity = string.valueOf(rmaRIrec1.Die_Quantity_Fab_Validated__c);
            }else if(RMArecord.RMA_By__c == 'Module'){
                modQuantity = string.valueOf(rmaRIrec1.Module_Quantity_Fab_Validated__c);
            }
        }
        return null;
    }
    
    public PageReference UpdateLineItemForFabValidation(){
        try{
        if(RMArecord.RMA_By__c == 'Wafer'){
            string selLots1 = '';
            string selLots2 = '';
            if(!righFabValidatedtOptions.isEmpty()){
                for(SelectOption so: righFabValidatedtOptions){
                    selLots1 += so.getValue() + ';';
                }
            }
            
            for(SelectOption so: leftFabValidatedOptions){
                selLots2 += so.getValue() + ';';
            }
            if(rmaRIrec1 != NULL){
                
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                    rmaRIrec1.Wafer_Id_Fab_Validated__c = selLots2;
                    rmaRIrec1.Wafer_Id_Fab_In_Validated__c = selLots1;
                }else{
                    rmaRIrec1.Wafer_Id_Fab_9_10_Fab_Validated__c   = selLots2;
                    rmaRIrec1.Wafer_Id_Fab_9_10_Fab_Invalidated__c = selLots1;
                }
            }
        }else if(RMArecord.RMA_By__c == 'Die'){
            if(rmaRIrec1 != NULL){
                if(String.isEmpty(dieQuantity)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Die Quantity cannot blank'));
                    return NULL;
                }
                if(Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(dieQuantity))){
                    rmaRIrec1.Die_Quantity_Fab_Validated__c = decimal.valueOf(dieQuantity);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid input. Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
                    return NULL;
                }
                if(decimal.valueOf(dieQuantity) > rmaRIrec1.Die_Quantity__c){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Die Quantity cannot exceed the CSR Submitted Die Quantity'));
                    return NULL;
                }
            }
        }else if(RMArecord.RMA_By__c == 'Module'){
            if(rmaRIrec1 != NULL){
                if(String.isEmpty(modQuantity)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Module Quantity cannot blank'));
                    return NULL;
                }
                if(Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(modQuantity))){
                    rmaRIrec1.Module_Quantity_Fab_Validated__c = decimal.valueOf(modQuantity);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid input. Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
                    return NULL;
                }
                if(decimal.valueOf(modQuantity) > rmaRIrec1.Module_Quantity__c){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Module Quantity cannot exceed the CSR submitted Module Quantity'));
                    return NULL;
                }
            }
        }
        update rmaRIrec1;
        return refreshPage();
        }catch(Exception e){
			//Throwing the message through trigger
        }
        return NULL;
    }
    
    public PageReference CancelPopupForFab(){
        showPopUpForFab = false;
        LineItemToEditForFab= '';
        righFabValidatedtOptions.clear();
        leftFabValidatedOptions.clear();
        return NULL;
    }
    
    //For Regional Validation
    public SelectOption[] leftRegValidatedOptions{get;set;}
    public SelectOption[] rightRegValidatedOptions{get;set;}
    RMA_Return_Invoice__c rmaRIrec2;
    
    public PageReference EditLineItemForRegValidation(){
        leftRegValidatedOptions  = new List<SelectOption>();
        rightRegValidatedOptions = new List<SelectOption>();
        showPopUpForReg = True;
        rmaRIrec2 = [SELECT Id,Wafer_Id_Fab_Validated__c,Wafer_Id_Regional_Personnel_Recommended__c,Fab_Group__c,
                        Wafer_Id_Regional_Personnel_Not_Rec__c,Die_Quantity_Regional_Validated__c,Die_Quantity_Fab_Validated__c,
                        Wafer_Id_Fab_9_10_Regional_Validated__c,Wafer_Id_Fab_9_10_Regional_Invalidated__c,
                        Module_Quantity_Fab_Validated__c,Module_Quantity_Regional_Validated__c
                    FROM RMA_Return_Invoice__c 
                    WHERE Id=:LineItemToEditForReg];
        if(rmaRIrec2 != NULL){
            if(RMArecord.RMA_By__c == 'Wafer'){
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec2.Wafer_Id_Regional_Personnel_Recommended__c != null){
                    for(String str: rmaRIrec2.Wafer_Id_Regional_Personnel_Recommended__c.split(';')){
                        leftRegValidatedOptions.add(new SelectOption(str,str));
                    }
                }else if(RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec2.Wafer_Id_Fab_9_10_Regional_Validated__c != null){
                    for(String str: rmaRIrec2.Wafer_Id_Fab_9_10_Regional_Validated__c.split(';')){
                        leftRegValidatedOptions.add(new SelectOption(str,str));
                    }
                }
                
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec2.Wafer_Id_Regional_Personnel_Not_Rec__c != null){
                    for(String str: rmaRIrec2.Wafer_Id_Regional_Personnel_Not_Rec__c.split(';')){
                        rightRegValidatedOptions.add(new SelectOption(str,str));
                    }
                }else if(RMA_Utility.checkFab9or10(RMArecord.Fab__c) && rmaRIrec2.Wafer_Id_Fab_9_10_Regional_Invalidated__c != null){
                    for(String str: rmaRIrec2.Wafer_Id_Fab_9_10_Regional_Invalidated__c.split(';')){
                        rightRegValidatedOptions.add(new SelectOption(str,str));
                    }
                }
            }else if(RMArecord.RMA_By__c == 'Die'){
                DieQuantity = string.valueOf(rmaRIrec2.Die_Quantity_Regional_Validated__c);
            }else if(RMArecord.RMA_By__c == 'Module'){
                modQuantity = string.valueOf(rmaRIrec2.Module_Quantity_Regional_Validated__c);
            }
        }
        return null;
    }
    
    public PageReference UpdateLineItemForRegValidation(){
        try{
        if(RMArecord.RMA_By__c == 'Wafer'){
            string selLots1 = '';
            string selLots2 = '';
            if(!rightRegValidatedOptions.isEmpty()){
                for(SelectOption so: rightRegValidatedOptions){
                    selLots1 += so.getValue() + ';';
                }
            }
            
            for(SelectOption so: leftRegValidatedOptions){
                selLots2 += so.getValue() + ';';
            }
            if(rmaRIrec2 != NULL){
                if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                    rmaRIrec2.Wafer_Id_Regional_Personnel_Recommended__c = selLots2;
                    rmaRIrec2.Wafer_Id_Regional_Personnel_Not_Rec__c = selLots1;
                }else{
                    rmaRIrec2.Wafer_Id_Fab_9_10_Regional_Validated__c   = selLots2;
                    rmaRIrec2.Wafer_Id_Fab_9_10_Regional_Invalidated__c = selLots1;
                }
            }
        }else if(RMArecord.RMA_By__c == 'Die'){
            if(rmaRIrec2 != NULL){
                if(String.isEmpty(dieQuantity)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Die Quantity cannot blank'));
                    return NULL;
                }
                if(Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(dieQuantity))){
                    rmaRIrec2.Die_Quantity_Regional_Validated__c = decimal.valueOf(dieQuantity);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid input. Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
                    return NULL;
                }
                if(RMArecord.RMA_Category__c != 'Business'){
                    if(decimal.valueOf(dieQuantity) > rmaRIrec2.Die_Quantity_Fab_Validated__c){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Die Quantity cannot exceed the FAB Submitted Die Quantity'));
                        return NULL;
                    }
                }else{
                    if(decimal.valueOf(dieQuantity) > rmaRIrec2.Die_Quantity__c){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Die Quantity cannot exceed the CSR Submitted Die Quantity'));
                        return NULL;
                    }
                }
            }
        }else if(RMArecord.RMA_By__c == 'Module'){
            if(rmaRIrec2 != NULL){
                if(String.isEmpty(modQuantity)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Module Quantity cannot blank'));
                    return NULL;
                }
                if(Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(modQuantity))){
                    rmaRIrec2.Module_Quantity_Regional_Validated__c = decimal.valueOf(modQuantity);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid input. Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
                    return NULL;
                }
                if(RMArecord.RMA_Category__c != 'Business'){
                    if(decimal.valueOf(modQuantity) > rmaRIrec2.Module_Quantity_Fab_Validated__c){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Module Quantity cannot exceed the FAB submitted Module Quantity'));
                        return NULL;
                    }
                }else{
                    if(decimal.valueOf(modQuantity) > rmaRIrec2.Module_Quantity__c){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Module Quantity cannot exceed the CSR submitted Module Quantity'));
                        return NULL;
                    }
                }
            }
        }
        update rmaRIrec2;
        return refreshPage();
        }catch(Exception e){
			//Throwing the message through trigger
        }
        return null;
    }
    
    public PageReference CancelPopupForReg(){
        showPopUpForReg = false;
        LineItemToEditForReg= '';
        rightRegValidatedOptions.clear();
        leftRegValidatedOptions.clear();
        return NULL;
    }
    
    public PageReference refreshPage(){
        PageReference pageRef = new PageReference('/apex/RMA_Edit?id='+RMArecord.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    //++ ----------------------------Approval Process Re-Assign -------------------------------------------
    public string reAssign{get;set;}
    
    // Get ProcessInstanceWorkItemId using SOQL
    public static Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [SELECT p.Id from ProcessInstanceWorkitem p
                                                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId
                                                  AND p.ProcessInstance.Status = 'Pending'])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    // This method will Approve the Lot Service Request 
    public static void approveRecord(RMA__c rmaReq,String reAssign){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request automatically to Re-Assign to Different Group');
        req.setAction('Approve');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        Id workItemId = getWorkItemId(rmaReq.Id); 
        
        if(workItemId == NULL){
            rmaReq.addError('Some Exception occurred. Please contact system administrator.');
        }else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
            
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Re-Assigning the approval request.');
            req1.setObjectId(rmaReq.Id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(UserInfo.getUserId()); 
            req1.setSkipEntryCriteria(true);
            // Submit the record to specific process and skip the criteria evaluation
            if(reAssign == 'Assign to Fab'){
                req1.setProcessDefinitionNameOrId('RMA_Fab_Group_Approval');
            }else if(reAssign == 'Assign to Non-Fab'){
                req1.setProcessDefinitionNameOrId('RMA_Non_Fab_Approval');
            }else if(reAssign == 'Assign to Turnkey'){
                req1.setProcessDefinitionNameOrId('RMA_Turnkey_Approval');
            }
            // Submit the approval request for the RMA
            Approval.ProcessResult resultReAssign = Approval.process(req1);
        }
    }
    
    //-- ----------------------------Approval Process Re-Assign ----------------------------------------
    
    public pageReference sumbitForApproval(){
        boolean validateRMA = RMA_Field_Validation_Helper.validateFieldsBeforeApproval(RMARecord);
        boolean validateWarranty = false;
        if(isFab9or10 && !RMArecord.RMA_Category__c.equalsIgnoreCase('Failure Analysis') && RMArecord.Warranty__c != NULL && RMArecord.Warranty__c > 0){
            validateWarranty = RMA_Field_Validation_Helper.checkWarrantyForFab9or10(RMArecord);
        }
        if(!validateRMA || validateWarranty){
            return null;
        }
        else{
            try{
                String workflowStage = '';
                Map<String,Boolean> mapErrorStatus = new Map<String,Boolean>();
                mapErrorStatus = RMA_ReturnInvoiceTrigger_Helper.checkDuplicate(lstRMAInvoices);
                if(mapErrorStatus.containsKey('WaferExists') && mapErrorStatus.get('WaferExists') == TRUE){
                    return NULL;
                }
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for quality validation');
                req.setObjectId(RMArecord.Id);
                req.setSubmitterId(UserInfo.getUserId());
                req.setSkipEntryCriteria(true);
                req.setProcessDefinitionNameOrId('RMA_Quality_Validation');
                Approval.ProcessResult result = Approval.process(req);
                
                if(result.isSuccess()){
                    if(!isFab9or10){
                        RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Technical Quality Approval');
                    }
                    workflowStage = RMA_Constants.PEN_CQ_VAL;
                }
                
                if(!isFab9or10){
                    if(RMArecord.RMA_due_to_Field_reliability_Failure__c){
                        boolean isFRF = false;
                        if(RMArecord.Lot_Device_FRF__c != NULL){
                            for(String lot : RMArecord.Lot_Device_FRF__c.split(';')){
                                for(RMA_Return_Invoice__c invoice : lstRMAInvoices){
                                    if(invoice.Lot_Number__c == lot){
                                        if(invoice.Invoice_Date__c.daysBetween(date.today()) > 365){
                                            isFRF = true;
                                            break;
                                        }                                   
                                    }
                                }
                            }
                        }
                        if(isFRF && !RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                            RMA_Email_Notification_Helper.checkFailReliability(RMArecord,workflowStage);    
                        }
                    }
                    boolean isImpact = false;
                    for(String impact : RMArecord.Access_Impact__c.split(';')){
                        if(impact == 'Safety Impact' || impact == 'Environment Impact') {
                            isImpact = true;
                            break;
                        }
                    }
                    if(isImpact){
                        RMA_Email_Notification_Helper.checkAccessImpact(RMArecord,workflowStage);
                    }
                }
                else{
                    
                }
                
                pageReference pg = new pageReference('/apex/RMA_View?Id='+RMArecord.Id);
                pg.setRedirect(true);
                return pg;
            }
            catch(Exception ex){
				//Throwing the message through trigger
                return null;
            }
        }
    }
  
    public boolean enableCycleTimeHistoryLink(){
        List<Rma_Audit_log__c> rmahistory = new List<Rma_Audit_log__c>([SELECT Id 
                                                                        FROM Rma_Audit_log__c 
                                                                        where rma__c =:RMArecord.Id
                                                                        and recordtypeId = :RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.CYCLE_TIME_LOG)
                                                                      ]);
                                                                              
        return ((rmaRecord.status__c == RMA_Constants.REJECTED_STATUS && rmahistory.size() > 1) || (rmaRecord.status__c != RMA_Constants.REJECTED_STATUS && rmahistory.size() > 0));                                                              
    }
    
    //for RMA Category Validation
    public pageReference validateRMACategory(){
        RMA_Field_Validation_Helper.validateRMACategory(RMARecord);
        return NULL;
    }
    
    public PageReference getReportUrl(){
        List<Report> reports;
        Pagereference reportUrl;
        if(rmaRecord != null  && rmaRecord.id != null && String.isNotBlank(reportDevName)){
            reports = new List<Report>([select developername,id from report where developername= :reportDevName]);
            if(!reports.isEmpty()){
                String pv0 = rmaRecord.id;
                pv0 = pv0.length() > 15 ? pv0.subString(0, 15) : rmaRecord.id;
                reportUrl = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + reports[0].id + '?pv0=' + pv0 + '&export=1&enc=UTF-8&xf=xls');
            }
        }
        return reportUrl;
    }
    
    //method to enable section for void
    public void enableVoid(){
        voidRMA = true; 
    }   
    
    public void cancelVoid(){
        voidRMA = false;
    }
     
    //method to Void RMA record
    public pageReference voidRMA(){
        boolean validateVoidReason = true;
        if(RMARecord.Reason_to_Void__c == NULL){
            validateVoidReason = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please mention reason to void the RMA.'));
        }
        if(!validateVoidReason){
            return null;
        }
        else{
            RMARecord.Status__c = 'Voided';
            RMARecord.Workflow_Stage__c = 'Voided RMA';
            update RMARecord;
            pageReference pg = new pageReference('/'+RMARecord.Id);
            pg.setRedirect(true);
            return pg;
        }
    }
    
    //method to navigate RMA to view page is Voided
    public pageReference checkVoided(){
        if(RMARecord.Id != NULL && (RMARecord.Status__c == 'Voided by System' || RMARecord.Status__c == 'Voided RMA')){
            pageReference pg = new pageReference('/'+RMARecord.Id);
            pg.setRedirect(true);
            return pg;
        }
        else{
            List<RMA_Return_Invoice__c> lstRMAinvoices = [SELECT Id,Lot_Number__c,Invoice_Number__c ,Wafer_Id_CSR_Submission__c,
                                                            RMA__r.Workflow_Stage__c,Invoice_Lot_Combination__c,Current_Die_Quantity__c,
                                                            Wafer_Id_Fab_Validated__c,Wafer_Id_Regional_Personnel_Recommended__c,
                                                            rma__r.RMA_By__c,RMA_By__c,Die_Quantity__c,Bill_Quantity__c,Fab_Group__c,
                                                            Wafer_Id_Fab_9_10_CSR_Submission__c,Wafer_Id_Fab_9_10_Fab_Validated__c,
                                                            Wafer_Id_Fab_9_10_Regional_Validated__c,Module_Quantity__c,Current_Module_Quantity__c
                                                          FROM RMA_Return_Invoice__c where RMA__c = :rmaRecord.Id];
            RMA_ReturnInvoiceTrigger_Helper.checkDuplicate(lstRMAinvoices);
            return null;
        }
    }
    
    public pageReference checkDuplicateDNCN(){
        if(RMArecord.Workflow_Stage__c == RMA_Constants.RMA_RAISED || RMArecord.Workflow_Stage__c == RMA_Constants.REJECTED_RMA || 
           RMArecord.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){       
            List<RMA_Return_Invoice__c> lstRMAinvoices = [SELECT Id,Lot_Number__c,Invoice_Number__c ,Wafer_Id_CSR_Submission__c,
                                                            RMA__r.Workflow_Stage__c,Invoice_Lot_Combination__c,Current_Die_Quantity__c,
                                                            Wafer_Id_Fab_Validated__c,Wafer_Id_Regional_Personnel_Recommended__c,
                                                            rma__r.RMA_By__c,RMA_By__c,Die_Quantity__c,Bill_Quantity__c,Fab_Group__c,
                                                            Wafer_Id_Fab_9_10_CSR_Submission__c,Wafer_Id_Fab_9_10_Fab_Validated__c,
                                                            Wafer_Id_Fab_9_10_Regional_Validated__c,Module_Quantity__c,Current_Module_Quantity__c
                                                          FROM RMA_Return_Invoice__c where RMA__c = :rmaRecord.Id];
            RMA_ReturnInvoiceTrigger_Helper.checkDuplicate(lstRMAinvoices);
            return null;
        }
        return null;
    }
    
    //method to clear Lot Details on change of RMA By
    public pageReference onChangeOfRMABy(){
        if(!lstRMAInvoices.isEmpty()){
            delete lstRMAInvoices;
        }
        update RMARecord;
        PageReference pageRef = new PageReference('/apex/RMA_Edit?id='+ RMArecord.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //method to send request for extension
    public pageReference sendRequestForExtension(){
        if(RMArecord.Number_of_Days__c == NULL){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Number of Days cannot be blank.'));
            return null;
        }
        else{
            pageReference pg = new pageReference('/'+RMArecord.Id);
            RMARecord.Extension_Approve_Reject_Reason__c = '';
            RMArecord.Extension_Status__c = 'Requested';
            User req = [select FirstName, LastName from User where Id =: userInfo.getUserId()];
            RMArecord.Extension_Requested_By__c = req.FirstName +' '+req.LastName;
            update RMArecord;
            pg.setRedirect(true);
            return pg;
        }
    }
    
    //method to approve extension
    public pageReference approveExtension(){
        RMArecord.Extension_Status__c = 'Approved';
        RMArecord.Extension_Approve_Reject_Reason__c = 'Approved';
        RMArecord.Cycle_Time_for_Fab_Validation__c  = RMArecord.Cycle_Time_for_Fab_Validation__c + RMARecord.Number_of_Days__c;
        update RMArecord;
         
        List<RMA__c> lstRMA = new List<RMA__c>();
        lstRMA.add(RMArecord);
        RMA_Email_Notification_Helper.sendEmailNotification(lstRMA,'Extension Approved');
            
        pageReference pg = new pageReference('/'+RMArecord.Id);
        pg.setRedirect(true);
        return pg;
    }
    
    public void showExtensionReason(){
        showExtensionReason = true;
    }
    
    public void hideExtensionReason(){
        showExtensionReason = false;
    }
    
    public pageReference rejectExtension(){
        RMArecord.Extension_Status__c = RMA_Constants.REJECTED_STATUS;
        RMArecord.Extension_for_Fab_validation_required__c = false;
        RMArecord.Extension_Approve_Reject_Reason__c = RMArecord.Extension_Approve_Reject_Reason__c;
        RMArecord.Extension_Reason__c = NULL;
        RMArecord.Number_of_Days__c = NULL;
        update RMArecord;
            List<RMA__c> lstRMA = new List<RMA__c>();
            lstRMA.add(RMArecord);
            RMA_Email_Notification_Helper.sendEmailNotification(lstRMA,'Extension Rejected');
        pageReference pg = new pageReference('/'+RMArecord.Id);
        pg.setRedirect(true);
        return pg;
    }
    
    //++method to reject wafer acknowledgement
    public pageReference showRejectionPopUp(){
        rejectionPopUp = true;
        return null;
    }
    public pageReference CancelRejection(){
        rejectionPopUp = false;
        rejectionComments = '';
        return null;
    }
    public pageReference rejectAcknowledgement(){
        rejectionPopUp = false;
        
        RMArecord.Workflow_Stage__c = 'Rejected RMA';
        RMArecord.Status__c = RMA_Constants.REJECTED_STATUS;
        if(RMArecord.Disposition_of_Wafers__c == 'Return to GF' || 
           RMArecord.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
            if(RMArecord.Remarks_Reason_Wafer_Receipt__c != NULL && RMArecord.Remarks_Reason_Wafer_Receipt__c != ''){
                RMArecord.Remarks_Reason_Wafer_Receipt__c += '\n' + rejectionComments;
            }else{
                RMArecord.Remarks_Reason_Wafer_Receipt__c = rejectionComments;
            }
        }else if(RMArecord.Disposition_of_Wafers__c == 'To Scrap at Customer Site' || 
                 RMArecord.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
            if(RMArecord.Remarks_Reason_Wafer_Scrap__c != NULL && RMArecord.Remarks_Reason_Wafer_Scrap__c != ''){
                RMArecord.Remarks_Reason_Wafer_Scrap__c += '\n' + rejectionComments;
            }else{
                RMArecord.Remarks_Reason_Wafer_Scrap__c = rejectionComments;
            }            
        }
        update RMArecord;
        
        if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
            List<RMA__c> rmaList = new List<RMA__c>();
            rmaList.add(RMArecord);
            RMA_Email_Notification_Helper.sendEmailNotification(rmaList,'Reject Acknowledgement');
        }
        pageReference pg = new pageReference('/'+RMArecord.Id);
        pg.setRedirect(true);
        return pg;
    }
    //--method to reject wafer acknowledgement
    
    @TestVisible
    private List<RMA_Return_invoice__c> getReturnInvoices(){
        if(RMArecord.Id != NULL){
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA_Return_Invoice__c');
            String query = 'select '+f+' from RMA_Return_Invoice__c where RMA__c = \''+RMArecord.Id+'\'';
            return Database.query(query);
        }else{
            return NULL;
        }
        return NULL;
    }
    
     /**
     * @author Surendranadh Nune
     * @Description : This method is used to retrieve the vendor codes
     *                for return invoices based on wafer & lot Id combination
     */
    public List<RMA_Vendor_Code__c> getVendorCodes(){
        Set<String> lotIdWaferIdSet = new Set<String>();
        List<RMA_Return_invoice__c> rmaReturnInvoices = new List<RMA_Return_invoice__c>(getReturnInvoices());
        if(String.isNotBlank(RMArecord.Workflow_Stage__c) && !rmaReturnInvoices.isEmpty()){                                                                                 
            if(RMArecord.Workflow_Stage__c == 'RMA Raised' || RMArecord.Workflow_Stage__c == 'Rejected RMA'){
                for(RMA_Return_invoice__c retInv : rmaReturnInvoices){
                    lotIdWaferIdSet.addAll(prepareLotWaferIdSet(retInv, 'Wafer_Id_CSR_Submission__c'));
                }
            }else if(RMArecord.Workflow_Stage__c == 'Pending for Fab Validation' || RMArecord.Workflow_Stage__c == 'Pending for Turnkey/ Sub-con Validation' || 
                     RMArecord.Workflow_Stage__c == 'Pending for Non Fab Category Validation'){
                for(RMA_Return_invoice__c retInv : rmaReturnInvoices){
                    lotIdWaferIdSet.addAll(prepareLotWaferIdSet(retInv, 'Wafer_Id_Fab_Validated__c'));
                }                   
            }else if (RMArecord.Workflow_Stage__c.contains('Regional') || RMArecord.Workflow_Stage__c.contains('Receipt') || RMArecord.Workflow_Stage__c.contains('Finance') ||
                      RMArecord.Workflow_Stage__c == 'Pending for CN Issue' || RMArecord.Workflow_Stage__c == 'Pending for SO Issue' || RMArecord.Workflow_Stage__c == 'Closed RMA'){
                for(RMA_Return_invoice__c retInv : rmaReturnInvoices){
                    lotIdWaferIdSet.addAll(prepareLotWaferIdSet(retInv, 'Wafer_Id_Regional_Personnel_Recommended__c'));
                }   
            }else if(RMArecord.Workflow_Stage__c == 'Voided'){
                for(RMA_Return_invoice__c retInv : rmaReturnInvoices){
                    if(String.isNotBlank(retInv.Wafer_Id_Regional_Personnel_Recommended__c)){
                        lotIdWaferIdSet.addAll(prepareLotWaferIdSet(retInv, 'Wafer_Id_Regional_Personnel_Recommended__c'));
                    }else if(String.isNotBlank(retInv.Wafer_Id_Fab_Validated__c)){
                        lotIdWaferIdSet.addAll(prepareLotWaferIdSet(retInv, 'Wafer_Id_Fab_Validated__c'));
                    }else{
                        lotIdWaferIdSet.addAll(prepareLotWaferIdSet(retInv, 'Wafer_Id_CSR_Submission__c'));
                    }
                }  
            }
        }
        return [SELECT Name, Lot_Id__c, Unique_Field__c, Wafer_Id__c from RMA_Vendor_Code__c where Unique_Field__c in :lotIdWaferIdSet];
    }
    
    /**
     * @author Surendranadh Nune
     * @description  This method is used to prepare wafer & lot id collection for 
     *               return invoice
     */ 
    private Set<String> prepareLotWaferIdSet(RMA_Return_invoice__c retInv, String fieldName){
        Set<String> lotIdWaferIdSet = new Set<String>();
        String selectedWaferIds = (String)retInv.get(fieldName);
        if(String.isNotblank(selectedWaferIds)){
            for(String waferId : selectedWaferIds.split(';')){
                if(integer.valueOf(waferId) < 10){
                    waferId = '0' + waferId;
                }
                if(retInv.Lot_Number__c.indexOf('.')>-1){
                    lotIdWaferIdSet.add(retInv.Lot_Number__c + '-' + 
                                        retInv.Lot_Number__c.substring(0,retInv.Lot_Number__c.indexOf('.')) + '.' + waferId.trim());
                }else{
                    lotIdWaferIdSet.add(retInv.Lot_Number__c + '-' + retInv.Lot_Number__c + '.' + waferId.trim());
                }
            }
        }
        return lotIdWaferIdSet;
    }  
    
    //For failure mode
    public void addFailureMode(){
        setFailureMode = new Set<String>();
        setFailureMode.addAll(setLotNumber);
        showAddFailurModeSection = true;
        searchTextForFailureMode = '';
        leftOptionForFailureMode = new List<SelectOption>();
        rightOptionForFailureMode = new List<SelectOption>();
        rmaFailureCode = new RMA_PRF_CAR_Particulars__c();
        failureModeSelectOption = new List<SelectOption>();
        failureModeSelectOption.add(new selectOption('None','--None--'));
        for(String str: setFailureMode){
            leftOptionForFailureMode.add(new SelectOption(str,str));
        }
    }
    
    public void hideAddFailureModeSection(){
        failureModeId = '';
        rightOptionForFailureMode = new List<SelectOption>();
        rmaFailureCode = new RMA_PRF_CAR_Particulars__c();
        showAddFailurModeSection = false;
    }
    
    public void searchFailureMode(){
        showFailureModeError = false;
        List<RMA_Failure_Code__c> rmaFailureCodeList = new List<RMA_Failure_Code__c>();
        failureModeSelectOption = new List<SelectOption>();
        failureModeSelectOption.add(new selectOption('None','--None--'));
        String queryString = 'select Id, Fab_Group__c, Scrap_Code__c, Scrap_Description__c, Failure_Code__c from RMA_Failure_Code__c where Fab_Group__c = \''+RMArecord.Fab__c+'\' ';
        if(searchTextForFailureMode != ''){
            queryString += 'and Failure_Code__c LIKE \'%'+searchTextForFailureMode+'%\' ';
        }
        queryString += 'order by Failure_Code__c asc limit 200';
        rmaFailureCodeList = database.query(queryString);
        if(rmaFailureCodeList != NULL && !rmaFailureCodeList.isEmpty()){
            for(RMA_Failure_Code__c fcode : rmaFailureCodeList){
                failureModeSelectOption.add(new selectOption(fcode.Failure_Code__c,fcode.Failure_Code__c));
            }
        }
        else{
            showFailureModeError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Records Found.'));
        }
        searchTextForFailureMode = '';
    }
    
    public void saveFailureMode(){
        showFailureModeError = false;
        string selLot = '';
        if(!rightOptionForFailureMode.isEmpty() && rmaFailureCode.Failure_Mode__c != 'None'){
            try{
                for(SelectOption so: rightOptionForFailureMode){
                    selLot += so.getValue();
                }
                rmaFailureCode.Lot__c = selLot;
                rmaFailureCode.RMA__c = RMArecord.Id;
                rmaFailureCode.RecordTypeId = RMA_Constants.PRFCAR_FailureMode;
                upsert rmaFailureCode;
                retreiveFailureModeList();
                showAddFailurModeSection = false;
            }
            catch(Exception e){
                showFailureModeError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            }
        }
        else{
            showFailureModeError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Lot#/Failure Mode.'));
        }
    }
    
    public void editFailureModeLineItem(){
        showFailureModeError = false;
        try{
            rmaFailureCode = new RMA_PRF_CAR_Particulars__c();
            rmaFailureCode = [select Id, RMA__c, Lot__c, Failure_Mode__c from RMA_PRF_CAR_Particulars__c where Id =: failureModeId];
            setFailureMode = new Set<String>();
            setFailureMode.addAll(setLotNumber);
            showAddFailurModeSection = true;
            searchTextForFailureMode = '';
            leftOptionForFailureMode = new List<SelectOption>();
            rightOptionForFailureMode = new List<SelectOption>();
            failureModeSelectOption = new List<SelectOption>();
            failureModeSelectOption.add(new selectOption('None','--None--'));
            searchFailureMode();
            if(rmaFailureCode.Failure_Mode__c != NULL){                
                for(String str: rmaFailureCode.Lot__c.split(';')){
                    rightOptionForFailureMode.add(new SelectOption(str,str));
                }
                setFailureMode.removeAll(rmaFailureCode.Lot__c.split(';'));
            }            
            for(String str: setFailureMode){
                leftOptionForFailureMode.add(new SelectOption(str,str));
            }   
        }
        catch(Exception e){
            showFailureModeError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
    public void deleteFailureModeLineItem(){
        showFailureModeError = false;
        try{
            if(failureModeId != NULL){
                database.delete(new RMA_PRF_CAR_Particulars__c(Id=failureModeId));
                retreiveFailureModeList();
            }
        }
        catch(Exception e){
            showFailureModeError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
    public void showPRFPopup(){
        prfParticular.prf__c = prfParticular.lot__c = null;
        isPRF = true;
    }
    
   public void showCARPopup(){
        carParticular.car__c = carParticular.lot__c = null;
        isPRF = false;
        rightOptionsCAR.clear();
    }
    
    public void cancelPRFCARPopup(){
        showPRFCARPopup = false;
        isPRF = false;
    }
    
    public void addPRF(){
        String errorMessage = 'The following fields are required:';
        hasError = false;
        if(String.isBlank(prfParticular.prf__c)){
            hasError = true;
            errorMessage += '<li>PRF Number</li>';
        }
        if(String.isBlank(prfParticular.lot__c)){
            hasError = true;
            errorMessage += '<li>Lot#</li>';
        }
        if(hasError){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }else{
            prfParticular.rma__c = rmaRecord.id;
            insert prfParticular;
            prfParticular =  new RMA_PRF_CAR_Particulars__c(recordTypeId=RMA_Constants.PRFCAR_PRF);
        }
    }
    
    public void addCAR(){
        String errorMessage = 'The following fields are required:';
        hasError = false;
        if(String.isBlank(carParticular.car__c)){
            hasError = true;
            errorMessage += '<li>Car Number</li>';
        }
        if(rightOptionsCAR.isEmpty()){
            hasError = true;
            errorMessage += '<li>Lot #</li>';
        }
        if(hasError){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }else{
            carParticular.lot__c  = '';
            for(SelectOption so : rightOptionsCar){
                carParticular.lot__c += so.getValue() + ';';
            }
            rightOptionsCar.clear();
            carParticular.rma__c = rmaRecord.id;
            insert carParticular;
            carParticular =  new RMA_PRF_CAR_Particulars__c(recordTypeId=RMA_Constants.PRFCAR_CAR);
        }
    }
    
    public void removePRFCAR(){
        Id recId;
        recId = ApexPages.currentPage().getParameters().get('prfId');
        if(recId == null){
            recId = ApexPages.currentPage().getParameters().get('carId');
        }
        if(recId != null){
            delete new RMA_PRF_CAR_Particulars__c(id=recId);
        }
    }
   
    public List<SelectOption> getLotNumbers(){
        List<SelectOption> lotNumbers = new List<SelectOption>();
        if(isPrf){
            lotNumbers.add(new SelectOption('','--None--'));
        }
        for(RMA_Return_invoice__c retInv : [SELECT ID, Lot_Number__c,Invoice_Number__c, Wafer_Id_CSR_Submission__c, Wafer_Id_Fab_Validated__c, 
                                                Wafer_Id_Regional_Personnel_Recommended__c
                                            FROM RMA_Return_invoice__c 
                                            WHERE RMA__c =:RMArecord.Id ]){
            lotNumbers.add(new SelectOption(retInv.Lot_Number__c+'-'+retInv.Invoice_Number__c,retInv.Lot_Number__c+'-'+retInv.Invoice_Number__c));
        }
        return lotNumbers;
    }
    
    public List<RMA_PRF_CAR_Particulars__c> getPRFParticulars(){
        return getPRFCARParticulars(RMA_Constants.PRFCAR_PRF);  
    }
    public List<RMA_PRF_CAR_Particulars__c> getCARParticulars(){
        return getPRFCARParticulars(RMA_Constants.PRFCAR_CAR); 
    }
    public void deletePrfParticulars(){
        if(!rmaRecord.Is_the_RMA_lot_s_related_to_PRF__c){
            delete getPRFCARParticulars(RMA_Constants.PRFCAR_PRF);
        }
    }
    public void deleteCarParticulars(){
        if(!rmaRecord.Customer_CAR_Raised__c){ 
            delete getPRFCARParticulars(RMA_Constants.PRFCAR_CAR);
        }
    }
    
    private List<RMA_PRF_CAR_Particulars__c> getPRFCARParticulars(Id recordTypeId){
            return [SELECT ID, CAR__C, LOT__C, PRF__C 
                    FROM RMA_PRF_CAR_Particulars__c 
                    WHERE RMA__c =:rmaRecord.id
                    AND recordtypeId = :recordTypeId];
        
    }
    
    //to check if user belongs to Account Team Proxy of selected Account
    public void checkAccTeamProxy(){
        boolean isProxyMember = false;
        boolean isRMACSRGrpMember = false;
        List<Account_Team_Proxy__c> accTeamProxyList = [select User__c from Account_Team_Proxy__c where Account__c =: RMArecord.Customer__c
                                                        and User__c =: UserInfo.getUserId() 
                                                        and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep')];
        
        List<GroupMember> groupMemberList = [select UserOrGroupId from GroupMember where UserOrGroupId =: UserInfo.getUserId()
                                                and Group.Type = 'Regular' and (Group.DeveloperName = 'RMA_CSR' OR Group.DeveloperName = 'RMA_CSR_Fab_9_10')];
        
        if(accTeamProxyList != NULL && !accTeamProxyList.isEmpty()){
          isProxyMember = true;
        }
        
        if(groupMemberList != NULL && !groupMemberList.isEmpty()){
            isRMACSRGrpMember = true;
        }
      
        if(!(isProxyMember || isRMACSRGrpMember || RMA_AccessClass.hasAdminPriv())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'You are not allowed to create RMA request. Either you have to be a part of the Account Team Proxy table of the selected account or belong to the group RMA CSR.'));
            RMArecord.Customer__c = NULL;            
        }
    }
    
    //This method is used to retrieve attachments and links.
    public List<ContentDocumentLink> lstRMAattachmentsINFO{get;set;}
    public List<ContentDocumentLink> lstRMAattachmentsDISP{get;set;}
    public List<ContentDocumentLink> lstRMAattachmentsFAB{get;set;}
    public List<RMA_Attachment__c> lstRMALinksINFO{get;set;}
    public List<RMA_Attachment__c> lstRMALinksDISP{get;set;}
    public List<RMA_Attachment__c> lstRMALinksFAB{get;set;}
    
    public void QueryAllRMAAttachments(){
        Map<Id,RMA_Attachment__c> mapRMAvsSection;
        lstRMAattachmentsINFO = new List<ContentDocumentLink>();
        lstRMAattachmentsDISP = new List<ContentDocumentLink>();
        lstRMAattachmentsFAB  = new List<ContentDocumentLink>();
        lstRMALinksINFO = new List<RMA_Attachment__c>();
        lstRMALinksDISP = new List<RMA_Attachment__c>();
        lstRMALinksFAB  = new List<RMA_Attachment__c>();
        List<Id> rmaAttachIds = new List<Id>();
        mapRMAvsSection = new Map<Id,RMA_Attachment__c>([SELECT ID,attachment__c, Section__c,Resource_URL__c,CreatedById,CreatedDate
                                                            FROM Rma_Attachment__c 
                                                            WHERE RMA__c = :RMArecord.id]);
        for(RMA_Attachment__c rmaAttch: mapRMAvsSection.values()){
            if(rmaAttch.Attachment__c != NULL){
                rmaAttachIds.add(rmaAttch.Id);
            }else if(rmaAttch.Resource_URL__c != NULL){
                if(rmaAttch.Section__c == 'RMA Information'){
                    lstRMALinksINFO.add(rmaAttch);
                }else if(rmaAttch.Section__c == 'Disposition of Wafers'){
                    lstRMALinksDISP.add(rmaAttch);
                }else if(rmaAttch.Section__c == 'Technical Validation'){
                    lstRMALinksFAB.add(rmaAttch);
                }
            }
        }
        if(!rmaAttachIds.isEmpty()){
            for(ContentDocumentLink cdl: [SELECT ContentDocument.LatestPublishedVersionId, ContentDocumentId, ContentDocument.Title, LinkedEntityId,
                                                ContentDocument.Fileextension, ContentDocument.ContentModifiedDate, ContentDocument.OwnerId
                                            FROM ContentDocumentLink 
                                            WHERE LinkedEntityId IN :rmaAttachIds
                                            ORDER BY ContentDocument.ContentModifiedDate DESC]){
                if(mapRMAvsSection.get(cdl.LinkedEntityId) != NULL){
                    if(mapRMAvsSection.get(cdl.LinkedEntityId).Section__c == 'RMA Information'){
                        lstRMAattachmentsINFO.add(cdl);
                    }else if(mapRMAvsSection.get(cdl.LinkedEntityId).Section__c == 'Disposition of Wafers'){
                        lstRMAattachmentsDISP.add(cdl);
                    }else if(mapRMAvsSection.get(cdl.LinkedEntityId).Section__c == 'Technical Validation'){
                        lstRMAattachmentsFAB.add(cdl);
                    }
                }
            }
        }
    }
    
    //to retrieve Business Category
    public void calculateBusinessCategory(){
        if(businessCategory != NULL && businessCategory != ''){
            RMArecord.Business_Category__c = businessCategory;
        }
        //to calculate warranty
        if(RMArecord.Warranty__c == NULL){
            if(RMArecord.Business_Category__c == RMA_Constants.FOUNDRY){
                RMArecord.Warranty__c = Integer.valueOf(Label.RMA_Foundry_Warranty);
            }
            else if(RMArecord.Business_Category__c == RMA_Constants.ASIC){
                RMArecord.Warranty__c = Integer.valueOf(Label.RMA_ASIC_Warranty);
            }
            else if(RMArecord.Business_Category__c == RMA_Constants.IBM_SERVER){
                RMArecord.Warranty__c = Integer.valueOf(Label.RMA_IBM_Server_Warranty);
            }
        }
    }
    
    public void checkWarrantyForFA(){
        if(RMArecord.RMA_Category__c == 'Failure Analysis'){
            //RMArecord.Warranty__c = NULL;
            RMArecord.Compensation_Type__c  = 'No Compensation';
        }
        else{
            calculateBusinessCategory();
        }
    }
    
    public void setReturnLocation(){
        if(RMARecord.Return_Location__c != NULL){
            if(RMARecord.Return_Location__c == 'Burlington'){
                RMArecord.Receiver_Address__c = Label.RMA_Burlington_Address;
            }
            else if(RMARecord.Return_Location__c == 'APLC'){
                RMArecord.Receiver_Address__c = Label.RMA_APLC_Address;
            }   
        }
        else{
            RMArecord.Receiver_Address__c = NULL;
        }
    }
    
    public void clearCarrierFields(){
        RMARecord.Carrier_Vendor_Account_Number__c = RMARecord.New_Carrier_Vendor__c = NULL;
    }
    
}