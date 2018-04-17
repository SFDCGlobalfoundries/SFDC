/* 
    Author: Abhita Bansal
    Description: This serves as the controller for MPWReservationFormVF.
    History: 
        ABansal      05212015    - Code creation.
        SNair        05262015    - added logic for reservation form functionalities.
        SNair        05272015    - added logic for reservation form functionalities.
        SNair        05282015    - added logic for reservation form functionalities.
        SNair        05292015    - added logic for reservation form functionalities.
        SNair        06012015    - added logic for reservation form functionalities.
        SNair        06022015    - added logic for reservation form functionalities.
        SNair        06032015    - added logic for reservation form functionalities.
        SNair        06042015    - added logic for reservation form functionalities.
        SNair        06052015    - added logic for reservation form functionalities.
        SNair        06082015    - added logic for reservation form functionalities.
        SNair        06092015    - added logic formpwResf.Customer_Company_Name__c reservation form functionalities.
        SNair        06102015    - added logic for reservation form functionalities.
        SNair        06112015    - added logic for reservation form functionalities.
        SNair        06122015    - added logic for reservation form functionalities.
        SNair        06152015    - added logic for reservation form functionalities.
        SNair        06162015    - added logic for reservation form functionalities.
        SNair        06172015    - added logic for reservation form functionalities.
        SNair        06182015    - added logic for reservation form functionalities.
        Poulami      01042016    - added logic for Corner Split In Wafer Form (MPW-PP28) 
        Poulami      01222016    - added logic for Copy form fuction should be allowed if the account list assigned to train past reservation closed date. (MPW-PP27)
        Poulami      03082016    - updated code to display Metal Stack information in Edit page (MPW-PP57)
        Poulami      03182016    - updated code to display Bare Die Forecast Ship Date field (MPW-PP30)
        Poulami      04072016    - Modified code to add 2 new category ASIC R&D, RF_ASIC_A&D Protos (MPW-PP87)
                                 - Modified code to populate Sub Category based on ASIC R&D, RF_ASIC_A&D Protos categories (MPW-PP87).
                                 - Modified code to populate PA Code based on ASIC R&D, RF_ASIC_A&D Protos categories (MPW-PP87).
        Poulami      04132016    - Modified code to allow user to do Die size change 7 days after customer tapeout date based on Geometry.
        Poulami      04292016    - Modified code to add 'MPW Change Request' column under 'Chip Information' section to display CR's related to specific Prime Die (MPW-PP60).
        Poulami      06062916    - Modified code for case 00056083
        Anil Kumar   00070564    - 0.15um Sub-Device Extraction supportability : April 18, 2017
        Anil Kumar   00070567    - Forwarder Account# more than 4 char : April 18, 2017
        Venkat       MPW-PP145   - Increase the total number of FAE Approvers. Current limit is 10. Increased the Limit to 15 (23-Jun-2017)
        Venkat       MPW-PP146   - allow expedite change request for 0 in both die and wafer. (23-Jun-2017)     
        Kanishk      MPW-PP145   - Increase the total number of FAE Approvers. Current limit is 10. Increased the Limit to 15 (11-July-2017)   
        Kanishk     Steave SFDC Reservation Update   -allow Backgrind change request 1 week after Reservation Cancelalation date
        Kanishk     add ​​'701141' PA code for ALL sub-category under ASIC R&D category.    
        Jabee 00082453 we have added logic for No backgrind values to check
        Venkat       00088599    - added 12/14nm in addition to 14nm.
*/

public class MPWReservationFormController {

    public String selectedProcessTypeName{get;set;}
    public Map<String,String> processTypeMap{get;set;}
    public String primeDieRecordId{get;set;}
    public String attachmentType{get;set;}
    public boolean showDeviceWarning{get;set;}
    public boolean showApprovalHistory{get;set;}
    public boolean isExternalUser{get;set;}
    public boolean showAddress1{get;set;}
    public boolean showAddress2{get;set;}
    public boolean showAddress3{get;set;}
    public boolean preview{get;set;}
    public boolean success{get;set;}
    public boolean agree{get;set;}
    public boolean editAddDet{get;set;}
    public boolean editCeTurn{get;set;}
    public boolean showError{get;set;}
    public boolean isfae{get;set;}
    public MPW_Reservation__c mpwResf {get;set;}
    public MPW_Train_Maintenance__c mpwtm{get;set;}
    public List<MPW_Notes__c> listFormNotes {get;set;} 
    public List<mpwPrimeDieWrapperClass> mpwPrimeDieList{get;set;}
    public List<MPW_Train_Maintenance_Details__c> mpwtmdList{get;set;}
    public List<TechModuleAnswersWrapper> mpwtmawList{get;set;}
    public List<MPW_Process_Information_Question__c> mpwpiqList{get;set;}
    public List<MPW_Prime_Die__c> mpwpdList{get;set;}
    //04292016 - Added by Poulami Starts.
    public List<MPW_Prime_Die__c> mpwpdchList{get;set;}
    //04292016 - Added by Poulami Ends.
    public MPW_Prime_Die__c mpwPrimeDieCh{get;set;}
    public mpwChangeRequestWrapperClass mpwChangeReqWrapp{get;set;}
    public List<MPW_Keyword_Config__c> mpwkcList{get;set;} 
    public List<MPW_SRAM_Question__c> mpwsramquestionList{get;set;}
    public String mpwTrainId{get;set;}
    public String initPoint{get;set;}
    public String geometry{get;set;}
    public String geometry1{get;set;}
    public String deviceId{get;set;}
    public String accessMode{get;set;}
    public String voidtheform{get;set;}
    public String returnURL;
    public UtilClassToGetAllFields util{get;set;}
    public List<SelectOption> subCategory{get;set;}
    public List<SelectOption> usage{get;set;}
    public List<SelectOption> paCode{get;set;}
    public List<SelectOption> forwarderAccountType1{get;set;}
    public List<SelectOption> forwarderAccountType2{get;set;}
    public List<SelectOption> forwarderAccountType3{get;set;}
    public User requestor{get;set;}
    public User supervisor{get;set;}
    public String recordId{get;set;}
    public List<SelectOption> categoryList{get;set;}
    public List<SelectOption> changeReqList{get;set;}
    public static Integer rowSize = 10;
    public List<Account_Team_Proxy__c> feList{get;set;}
    public List<Account_Team_Proxy__c> amList{get;set;}
    public List<Account_Team_Proxy__c> csrList{get;set;}
    public Set<Id> feEditSet{get;set;}
    public Set<Id> amEditSet{get;set;}
    public Set<Id> csrEditSet{get;set;}
    public Boolean isSubmitApp {get;set;}
    public Boolean isEdit {get;set;}
    public String isChangeReq {get;set;}
    public String search {get;set;}
    public boolean isShow {get;set;}
    public boolean isAdmin {get;set;}
    public Integer rowNum{get;set;}
    public String copySearchNumber {get;set;}
    public Set<Id> userId;
    public String primeId {get;set;}
    public String primeName {get;set;}
    public String selectedChangeOption {get;set;}
    public boolean isSelectedChangeReqField {get;set;}
    public MPW_Change_Request__c mpwChangeReq {get;set;}
    public List<MPW_Change_Request__c> mpwListChangeReq {get;set;}
    public String optionValues{get;set;}
    public Blob filebody1 {get; set;}
    public String filename1 {get; set;}
    public Blob filebody2 {get; set;}
    public String filename2 {get; set;}
    public Blob filebody3 {get; set;}
    public String filename3 {get; set;}
    public boolean displayvoidsection{get;set;}
    public boolean isValidate {get;set;}
    public turnkeyWrapper turnkeyWrap{get;set;}
    public List<MPW_Turnkey__c> mpwturnkeyList{get;set;}
    public String displayPACode{get;set;}
    public String selectedAccountName{get;set;}
    public Boolean isCompare {get;set;}
    public boolean showAnswer{get;set;}
    public integer mpwpiqsize{get;set;}
    public String ruleName {get;set;}
    public boolean isCSR{get;set;}
    public boolean isCSRProfile{get;set;}
    public boolean editCSR  {get;set;}
    public boolean isCopy{get;set;}
    public boolean showCRButton {get; set;}   //Added by Anil - Nov 22, 2016
    public boolean showVoidButton {get; set;}   //Added by Kanishk - June 29, 2017
    public boolean showSubDeviceExtraction {get; set;}   //Added by Anil - April 18, 2017
    public boolean isAllowEditTurnkeySection {get; set;}   //Added by Anil - Jan 09, 2017 : MPW-PP110
    public Set<Id> mpwPortalFormIds;
    public Set<Id> mpwPortalFormIds1;
    public Set<Id> accountIds;
    
    public Set<Id> accIds;
    public Map<Id, Id> mpwTrainAccIdMap;
    public Map<Id, Set<Id>> atpMap; 
    private Set<String> setSubDeviceExtractionGeometry = new Set<String>(); //Added by Anil - April 18, 2017
    public set<String> GeometrySet=new set<String>();
    public string strUserSearchFilter=ApexPages.currentPage().getParameters().get('query');
   
    
    public MPWReservationFormController(ApexPages.StandardController sc) {
        this.isCopy = false;
        this.isCSR = true;
        this.mpwpiqsize = 0;
        this.ruleName = null;
        this.showDeviceWarning = false;
        this.showApprovalHistory = false;
        this.isfae = false;
        this.isCompare = false; 
        this.turnkeyWrap = new turnkeyWrapper();
        this.displayvoidsection = false;
        this.isExternalUser = false;
        this.showAddress1 = false;
        this.showAddress2 = false;
        this.showAddress3 = false;
        this.isSubmitApp = false;
        this.isEdit = false;
        this.preview = false;
        this.showError = false;
        this.editAddDet = false;
        this.editCeTurn = false;
        this.isShow = false;
        this.isAdmin = false;
        this.isCSRProfile = false;
        this.editCSR = false;
        this.isSelectedChangeReqField = false;
        this.mpwPrimeDieCh = new MPW_Prime_Die__c();
        this.mpwPrimeDieList = new List<mpwPrimeDieWrapperClass>();
        this.mpwChangeReqWrapp =  new mpwChangeRequestWrapperClass();
        this.mpwtmdList = new List<MPW_Train_Maintenance_Details__c>();
        this.mpwListChangeReq  = new List<MPW_Change_Request__c>();
        this.mpwturnkeyList = new List<MPW_Turnkey__c>();
        this.mpwtmawList = new List<TechModuleAnswersWrapper>(); 
        this.subCategory = new List<SelectOption>();
        this.usage = new List<SelectOption>();
        this.changeReqList= new List<SelectOption>();
        this.paCode = new List<SelectOption>();
        this.userId = new Set<Id>();
        accountIds = new Set<Id>();
        mpwPortalFormIds = new Set<Id>();
        mpwPortalFormIds1 = new Set<Id>();
        accIds = new Set<Id>();
        mpwTrainAccIdMap = new Map<Id, Id>();
        atpMap = new Map<Id, Set<Id>>();
        
        showCRButton = false;
        showVoidButton=false;
        showSubDeviceExtraction = false;
        isAllowEditTurnkeySection = false;
        setSubDeviceExtractionGeometry = new Set<String>(); 
        
        for(MPW_Sub_Device_Extraction_Geometry__c cs : [SELECT Name, Geometry__c FROM MPW_Sub_Device_Extraction_Geometry__c]) {
            setSubDeviceExtractionGeometry.add(cs.Geometry__c.toLowerCase());
        }
        
        this.mpwTrainId = ApexPages.currentPage().getParameters().get('mpwId');
        this.initPoint = ApexPages.currentPage().getParameters().get('intpoint');
        this.geometry = ApexPages.currentPage().getParameters().get('geometry');
        this.accessMode = ApexPages.currentPage().getParameters().get('mode');
        this.deviceId = ApexPages.currentPage().getParameters().get('deviceId');
        this.returnURL = ApexPages.currentPage().getParameters().get('retURL');
        this.voidtheform  = ApexPages.currentPage().getParameters().get('voidtheform');
        
        if(this.initPoint == null){
            this.initPoint = 'mpwtrain';
        }
        if(this.accessMode == null){
            this.accessMode = 'View';
        }
        if(voidtheform == 'true'){
            this.displayvoidsection = true;
        }
        // Copy Functionality
        this.copySearchNumber = ApexPages.currentPage().getParameters().get('Clone');
        
        // Search 
        this.search = ApexPages.currentPage().getParameters().get('Search');
        
        // Change Request Functionality
        this.isChangeReq = ApexPages.currentPage().getParameters().get('ChangeRequest');
        
        // CE and Turnkey Queues
        Group sgpTurnkey = getPublicGp('MPW SGP Turnkey Queue');
        Group sgpCEFab7 = getPublicGp('MPW Singapore MPW CE Fab 7 Queue');
        Group sgpCE3E = getPublicGp('MPW Singapore MPW CE Giga+ 3E Queue');
        Group dresdenCE = getPublicGp('MPW Dresden MPW CE Queue');
        Group drsUSTurnkey = getPublicGp('MPW DRS,US Turnkey Queue');
        Group usCE = getPublicGp('MPW US MPW CE Queue');
        
        util = new UtilClassToGetAllFields();
        this.mpwResf = new MPW_Reservation__c();
        this.mpwChangeReq = new MPW_Change_Request__c();
        this.mpwtm = new MPW_Train_Maintenance__c();
        this.mpwpdList = new List<MPW_Prime_Die__c>();
        //04292016 - Added by Poulami Starts.
        this.mpwpdchList = new List<MPW_Prime_Die__c>();
        //04292016 - Added by Poulami Ends.
        this.mpwResf = (MPW_Reservation__c)sc.getRecord();
        this.recordId = this.mpwResf.Id;
        this.listFormNotes = new List<MPW_Notes__c>();
        this.mpwkcList = new List<MPW_Keyword_Config__c>();
        this.mpwkcList = [select Value__c, Type__c from MPW_Keyword_Config__c 
                            where Type__c IN ('IPSubCategory','CategoryUsage','DieQuantity','QuantityWaferForm','Backgrind','ShortLoopWafers',
                            'Expedite','ExpediteQuantityWaferForm','DeviceType','DrawnOrientation','CornerSplit','TurnkeyServices','DESubCategory','SubDeviceExtraction','ForwarderAccountType','ASIC_R&DSubCategory','RF_ASIC_A&D_ProtosSubCategory') 
                            and Active__c  = true 
                            order by Type__c, Sequence_No__c asc];
        this.requestor = [select Id, Name, ManagerId, Profile.Name, Email, AccountId from User where Id =: UserInfo.getUserId()];
        if(this.requestor.Profile.Name == 'System Administrator' || this.requestor.Profile.Name == 'CTS Developers' || this.requestor.Profile.Name == 'GF Developer' || this.requestor.Profile.Name == 'GF Integration') {
            this.isAdmin = true;
            this.isCompare = true;
        }
        
        if(this.requestor.Profile.Name == 'GF CSR') {
            this.isCSRProfile = true;
        }
               
        retreiveNotesData();
        if(userInfo.getUserType() == 'CustomerSuccess' || userInfo.getUserType() == 'PowerCustomerSuccess'){
            this.isExternalUser = true;
            this.mpwResf.Customer_Company_Name__c = this.requestor.AccountId;
            this.categoryList = new List<SelectOption>();
            this.categoryList.add(new SelectOption('Customer','Customer'));
            this.mpwResf.Category__c = 'Customer';
            retreiveCustomerInformation();
        }
        else{
            this.isExternalUser = false;
            this.categoryList = new List<SelectOption>();
            this.categoryList.add(new SelectOption('Customer','Customer'));
            this.categoryList.add(new SelectOption('IP','IP'));
            this.categoryList.add(new SelectOption('TD','TD'));
            this.categoryList.add(new SelectOption('FAB','FAB'));
            //this.categoryList.add(new SelectOption('DE','DE'));
            //04072016 - Modified by Poulami Starts.
            this.categoryList.add(new SelectOption('ASIC R&D','ASIC R&D'));
            //this.categoryList.add(new SelectOption('RF_ASIC_A&D Protos','RF_ASIC_A&D Protos'));
            //this.categoryList.add(new SelectOption('Lighting','Lighting'));
            //04072016 - Modified by Poulami Ends.
            this.mpwResf.Category__c = 'FAB';
        }
        
        // Added By Abhita
        if(this.isExternalUser) {
            if(this.requestor.AccountId != null){
                retrievePortalAccounts(this.requestor.AccountId);
            }
        }
        
        // CE and Turnkey Users
        if(!this.isExternalUser) {
            for(Id queueId : getUserIds(sgpTurnkey.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(sgpCEFab7.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(sgpCE3E.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(dresdenCE.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(drsUSTurnkey.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(usCE.Id)) {
                userId.add(queueId);
            }
            
            if(userId.contains(UserInfo.getUserId())) {
                isAllowEditTurnkeySection = true;
            }
        }
        retrieveSubCategoryAndUsage();
        if(this.accessMode == 'Edit') {  //&& this.recordId == null) || (this.accessMode == 'Edit' && this.search != null)){
            //retrievePickListforPrimeDie();
            this.showAddress1 = true;            
            this.agree = false;
            
            if(this.requestor.ManagerId != null){
                this.supervisor = [select Id, Name, Email from User where Id =: requestor.ManagerId];        
            }
            if(this.requestor != null){
                this.mpwResf.Requestor_Name__c = requestor.Name;
                this.mpwResf.Requestor_Email__c = requestor.Email;      
            }
            if(this.supervisor != null){
                this.mpwResf.Supervisor_Name__c = supervisor.Name;
                this.mpwResf.Supervisor_Email__c = supervisor.Email; 
                this.mpwResf.Supervisor__c = this.supervisor.Id;   
            }
            if(this.mpwTrainId != null){
                String queryFields = util.getAllFields('MPW_Train_Maintenance__c');
                String query = 'select '+queryFields+' from MPW_Train_Maintenance__c where Id =\''+mpwTrainId+'\'';
                this.mpwtm = database.query(query);
                
                //Added by Anil Kumar : 00070564 - 0.15um Sub-Device Extraction supportability : April 18, 2017
                if(this.mpwtm.Geometry__c != null && setSubDeviceExtractionGeometry.contains(this.mpwtm.Geometry__c.toLowerCase())){
                    showSubDeviceExtraction = true;
                }
            }
             retrievePickListforPrimeDie();
            if(this.mpwResf.Category__c == 'Customer'){
                this.mpwResf.Form_Type__c = 'External';
                retriveMetalStackValues();
            }
            //04072016 - Modified by Poulami Starts.
            else if(this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'TD' || this.mpwResf.Category__c == 'DE' || this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
                this.mpwResf.Form_Type__c = 'Internal';
            }
            //04072016 - Modified by Poulami Ends.
            
            this.forwarderAccountType1 = new List<SelectOption>();
            this.forwarderAccountType2 = new List<SelectOption>();
            this.forwarderAccountType3 = new List<SelectOption>();
            for(MPW_Keyword_Config__c m: this.mpwkcList){
                if(m.Type__c == 'ForwarderAccountType'){
                        this.forwarderAccountType1.add(new SelectOption(m.Value__c,m.Value__c));
                        this.forwarderAccountType2.add(new SelectOption(m.Value__c,m.Value__c));
                        this.forwarderAccountType3.add(new SelectOption(m.Value__c,m.Value__c));
                }
            }
            if(this.deviceId != null){
                this.mpwResf.Device__c = this.deviceId;
            }
        }
        
        if(this.recordId != null){
            retrieveMPWReservationDetails(recordId);
            
            /** Start : Added by Anil - Nov 22, 2016 - MPW-PP112 **/
            showCRButton = false; 
            showVoidButton=false;
            //String queryTemp = 'SELECT Id, Form_Status__c, MPW_Train_Name__r.Tapeout_Date_Customer__c, MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c, Category__c, MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c, MPW_Train_Name__r.Lot_Start_Date__c FROM MPW_Reservation__c WHERE Id =: recordId';
            String queryTemp =  'Select Extra_Die_Qty__c, MPW_Train_Name__r.Name, MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c, MPW_Train_Name__r.Tapeout_Date_Customer__c, MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_End__c, '+
              'MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c, MPW_Train_Name__r.Lot_Start_Date__c, MPW_Train_Name__c, Name, Geometry__c, Form_Status__c, Process_Type__c, FE_Name__r.Name, AM_Name__r.Name, CSR_Name__r.Name, ' +
              'MPW_Train_Name__r.Cancellation_Deadline__c, Owner.Name, Customer_Company_Name__r.Name, lastModifiedDate, Bare_Die_Ship_Date__c, No_of_Prime_Dies__c, Category__c, ' +
              'Step_1_Approver_1__c, Step_1_Approver_2__c, Step_1_Approver_3__c, Step_1_Approver_4__c, Step_1_Approver_5__c, Step_1_Approver_6__c, Extra_Die_Qty_Total__c,'+
              'Step_1_Approver_7__c, Step_1_Approver_8__c, Step_1_Approver_9__c, Step_1_Approver_10__c, Supervisor__c, Approved_Queue__c '+
              ' from MPW_Reservation__c WHERE Id =: recordId';
           
            MPW_Reservation__c oMPWResTemp = database.query(queryTemp);
            DateTime dtCTD;
            if(oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c != null) {
                dtCTD = datetime.newInstance(oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c.Year()+1, oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c.month(), oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c.day())+1;
            }
            // Change Request Logic
            if((oMPWResTemp.Form_Status__c == 'Accepted by CE' || oMPWResTemp.Form_Status__c == 'Accepted by MPW Tapeout' || oMPWResTemp.Form_Status__c == 'Accepted by Turnkey') 
            && ((oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c != null && oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c > datetime.now()) 
            || (oMPWResTemp.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c != null && oMPWResTemp.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c > datetime.now()                    
            && oMPWResTemp.Category__c != 'FAB' && oMPWResTemp.Category__c != 'TD' && oMPWResTemp.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c != 'NA') 
            || (oMPWResTemp.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c == null && oMPWResTemp.Category__c != 'FAB' && oMPWResTemp.Category__c != 'TD' && oMPWResTemp.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c != 'NA')
            || (oMPWResTemp.MPW_Train_Name__r.Lot_Start_Date__c != null && oMPWResTemp.MPW_Train_Name__r.Lot_Start_Date__c > datetime.now() && oMPWResTemp.Category__c != 'FAB' && oMPWResTemp.Category__c != 'TD')
            || (oMPWResTemp.MPW_Train_Name__r.Tapeout_Date_Customer__c != null && (datetime.now() < dtCTD) 
            && oMPWResTemp.Category__c != 'FAB' && oMPWResTemp.Category__c != 'TD'))) {
                showCRButton = true; 
            }
            /** End : Added by Anil - Nov 22, 2016 - MPW-PP112 **/
           
           if(!displayvoidsection){ 
             showVoidButton=isVoidShow(oMPWResTemp);
           } 
            retrivePACodeForDisplay();
            
            /** Start : Added by Anil - Nov 15, 2016 - MPW-PP101 **/
            if(this.copySearchNumber == null) {
                listChangeReqRecords();
            }
            /** End : Added by Anil - Nov 15, 2016 - MPW-PP101 **/
            
            //listChangeReqRecords(); //Commented by Anil
        }
        
        //Logic for Compare Form button
        PermissionSet permissionSetRecord = new PermissionSet();
        permissionSetRecord = [select id, Label from PermissionSet where Label =: 'MPW GlobalShuttle User'];
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        permissionSetList = [select AssigneeId from PermissionSetAssignment where PermissionSetId =: permissionSetRecord.Id];
        
        for(PermissionSetAssignment p : permissionSetList){
            if(UserInfo.getUserId() == p.AssigneeId){
                this.isCompare = true;
            }
        }    
        
        //Added By SNAIR 10-13-2015 for Copy
        if(this.mpwResf.Category__c == 'Customer') {
            if(this.isExternalUser) {
                if(this.mpwResf.FE_Name__c != null && this.mpwResf.CSR_Name__c != null && this.mpwResf.AM_Name__c != null) {
                    isCopy = true;
                }
            }                
        } else if(this.mpwResf.Category__c != 'Customer'){
            if(!this.isExternalUser){
                isCopy = true;
            }
        }
        if(this.isAdmin) {
            isCopy = true;
        }
        //End
        
      
    }
    
 //Added Kanishk: void button logic
private boolean isVoidShow(MPW_Reservation__c mpw) {
    boolean isVoid = false;
    User u = [SELECT UserType, Profile.Name, AccountId
        FROM User
        WHERE Id = : UserInfo.getUserId()
    ];

    if (u.UserType != 'CustomerSuccess' && u.UserType != 'PowerCustomerSuccess') {
        if (mpw.Form_Status__c == 'Draft' || mpw.Form_Status__c == 'Rejected by FAE') {
            if (UserInfo.getUserId() == mpw.OwnerId) {
                if (mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                    isVoid = true;
                }
            }
            if (UserInfo.getUserId() == mpw.Supervisor__c && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                isVoid = true;
            }
        } else if (mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey') {
            
            List<String> queueNameList=retrieveQueueNames();
           
            if (mpw.Approved_Queue__c != null && queueNameList.size() > 0) {
                for (String q:queueNameList) {
                    if (q == mpw.Approved_Queue__c) {
                        isVoid = true;
                    }
                }
            }
        }
    }
    
    if (u.UserType == 'CustomerSuccess' || u.UserType == 'PowerCustomerSuccess') {

        if (mpw.FE_Name__c != null && mpw.CSR_Name__c != null && mpw.AM_Name__c != null) {
            if (mpw.Form_Status__c == 'Draft' || mpw.Form_Status__c == 'Rejected By FAE' || mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey') {
               
                if (UserInfo.getUserId() == mpw.OwnerId && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                   isVoid = true;
                }
                Set < Id > faeuserids = new Set < Id > ();
                if (mpw.Step_1_Approver_1__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_1__c);
                }
                if (mpw.Step_1_Approver_2__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_2__c);
                }
                if (mpw.Step_1_Approver_3__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_3__c);
                }
                if (mpw.Step_1_Approver_4__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_4__c);
                }
                if (mpw.Step_1_Approver_5__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_5__c);
                }
                if (mpw.Step_1_Approver_6__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_6__c);
                }
                if (mpw.Step_1_Approver_7__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_7__c);
                }
                if (mpw.Step_1_Approver_8__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_8__c);
                }
                if (mpw.Step_1_Approver_9__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_9__c);
                }
                if (mpw.Step_1_Approver_10__c != null) {
                    faeuserids.add(mpw.Step_1_Approver_10__c);
                }
                if (faeuserids.size() > 0) {
                    if (faeuserids.contains(UserInfo.getUserId()) && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                        isVoid = true;
                    }
                }
            }
        }


    }


    if (u.Profile.Name == 'System Administrator' || u.Profile.Name == 'CTS Developers') {
        
        if (mpw.Form_Status__c == 'Draft' || mpw.Form_Status__c == 'Rejected By FAE' || mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey') {
          
            if (mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                isVoid = true;
            }
        }
    }
return isVoid;
}

 private List<String> retrieveQueueNames(){
    List<String> queueNameSet = new List<String>();
    for(GroupMember g: [select Id, Group.Name, UserorGroupId from GroupMember where UserOrGroupId =: userInfo.getUserId()]){
        queueNameSet.add(g.Group.Name);
    }
    return queueNameSet;
  }    
    
    // Added By Abhita
    private void retreiveAccountTeamProxyOnCopy(Id mpwTID) {
        Set<Id> atpList = new Set<Id>();
        System.debug(mpwTID);
        List<MPW_Train_Account__c> mpwTrainAccs = [Select MPW_Train__c, Account__c, MPW_Train__r.Train_Type__c FROM MPW_Train_Account__c where MPW_Train__c =: mpwTID AND MPW_Train__r.Train_Type__c = 'GlobalShuttle'];
        System.debug(mpwTrainAccs);
        for(MPW_Train_Account__c mpwAcc : mpwTrainAccs) {
            mpwTrainAccIdMap.put(mpwAcc.MPW_Train__c, mpwAcc.Account__c);
            accIds.add(mpwAcc.Account__c);
        }
                
        List<Account_Team_Proxy__c> proxyList = [select User__c, Account__c from Account_Team_Proxy__c where Account__c IN :accIds order by Account__c asc];
                
        if(!proxyList.isEmpty()){
            Id accAM = proxyList[0].Account__c;
            for(Account_Team_Proxy__c p: proxyList) {
                if(p.Account__c == accAM) {
                    atpList.add(p.User__c);
                } else {
                    atpMap.put(accAM, atpList);
                    accAM = p.Account__c;
                    atpList = new Set<Id>();
                    atpList.add(p.User__c);
                }
            }
            atpMap.put(accAM, atpList);
        }
    }
    
    // Added By Abhita
    private void retrievePortalAccounts(Id portalAccountId) {
        
        Set<Id> belowAccountIds = new Set<Id>();
        
        // Get Account Id and ParentId
        accountIds.add(portalAccountId);
                        
        // Get Accounts below
        belowAccountIds = retrievePortalAccountBelow(accountIds);
        
        
        // Get MPW Forms from Account Ids
        if(!belowAccountIds.isEmpty()) {
            retrievePortalMPWForms(belowAccountIds);
        }                                
    }
    
    private Set<Id> retrievePortalAccountBelow(Set<Id> portalAccountIds) {
        
        Set<Id> tempAccountIds =  new Set<Id>();
    
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c IN :portalAccountIds
                                                    AND Account_Id__c NOT IN :portalAccountIds
                                        LIMIT 50]) { 
        tempAccountIds.add(ah.Account_Id__c);
        accountIds.add(ah.Account_Id__c);
        }
        
        if(!tempAccountIds.isEmpty()) {
            retrievePortalAccountBelow(tempAccountIds);           
        }
        
        return accountIds;
    }
    
    private void retrievePortalMPWForms(Set<Id> portalAccountIds) {
            
            for(MPW_Train_Account__c mpwAccountTrain : [ SELECT     MPW_Train__c
                                                                    , Account__c 
                                                         FROM       MPW_Train_Account__c 
                                                         WHERE      Account__c IN :portalAccountIds]){
                    mpwPortalFormIds.add(mpwAccountTrain.MPW_Train__c);                                                                                             
            }
            for(MPW_Train_Account__c mpwAccountTrain1 : [ SELECT    MPW_Train__c
                                                                    , Account__c 
                                                         FROM       MPW_Train_Account__c ]){
                    mpwPortalFormIds1.add(mpwAccountTrain1.MPW_Train__c);                                                                                             
            }
            
    }
        
    //Added By SNAIR 10-13-2015 for Copy
    public pageReference copy(){
        pageReference pg = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwResf.Id+'&intpoint=mpwtrain&mode=Edit&Clone=1&Search=1');
        pg.setRedirect(true);
        return pg;
    }
    //End
    
    public void retrivePACodeForDisplay(){
        //04072016 - Modified by Poulami Starts.
        if(this.mpwResf.PA_Code__c != null && this.mpwResf.PA_Code__c != 'For Opportunistic Usage' && this.mpwResf.Category__c == 'TD'){
        //04072016 - Modified by Poulami Ends.
                MPW_ERP_PA_Code__c temppacode = new MPW_ERP_PA_Code__c();
                temppacode = [select Name, PA_Description__c from MPW_ERP_PA_Code__c where Name =: this.mpwResf.PA_Code__c];
                this.displayPACode = temppacode.PA_Description__c;
        }
    }
    
    public static Group getPublicGp(String PName){
            Group gp = [Select Type, id From Group where Type= 'Queue' And Name =:PName Limit 1];
            return gp;
    }
    
    public static Set<Id> getUserIds(String gpId){
           Set<Id> userList = new Set<Id>();
           for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId =:gpId]){
                userList.add(groupMem.UserOrGroupId);
           }
           return userList;
    }
    
    public void retreiveCustomerInformation(){
        
        String accountId = '';
        
        if(this.mpwResf.Category__c != 'Customer' && this.mpwResf.Account_Internal__c != null){
            
                this.selectedAccountName = [select Id,Name from Account where Id =: this.mpwResf.Account_Internal__c].Name;
                accountId = this.mpwResf.Account_Internal__c;
        }
        else if(this.mpwResf.Customer_Company_Name__c != null){
                this.selectedAccountName = [select Id,Name from Account where Id =: this.mpwResf.Customer_Company_Name__c].Name;
                accountId = this.mpwResf.Customer_Company_Name__c;  
        }
            List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();
            feList = new List<Account_Team_Proxy__c>();
            amList = new List<Account_Team_Proxy__c>();
            csrList = new List<Account_Team_Proxy__c>();
            
            feEditSet = new Set<Id>();
            amEditSet = new Set<Id>();
            csrEditSet = new Set<Id>();
            if(accountId != ''){
                    proxyList = [SELECT User__c, User__r.Name, User_Email__c, Team_Role__c, Is_FAE__c
                                    FROM Account_Team_Proxy__c 
                                    WHERE Account__c =: accountId 
                                        AND Team_Role__c IN ('Account Manager','Primary Account Manager','Backup Customer Service Rep','Customer Service Rep','Primary Customer Service Rep','Field Application Engineer','Primary Field Application Engineer') 
                                    ORDER BY Team_Role__c desc];
                        if(!proxyList.isEmpty()){
                            for(Account_Team_Proxy__c p: proxyList){
                                if(p.Team_Role__c == 'Primary Account Manager' || p.Team_Role__c == 'Account Manager'){
                                    amList.add(p);
                                    amEditSet.add(p.User__c);
                                }
                                if(p.Team_Role__c == 'Backup Customer Service Rep' || p.Team_Role__c == 'Customer Service Rep' || p.Team_Role__c == 'Primary Customer Service Rep'){
                                    csrList.add(p);
                                    csrEditSet.add(p.User__c);
                                }
                                if(  p.Team_Role__c == 'Field Application Engineer' || 
                                     p.Team_Role__c == 'Primary Field Application Engineer' ||
                                    (p.Team_Role__c == 'Account Manager' && p.Is_FAE__c == TRUE) ||
                                    (p.Team_Role__c == 'Primary Account Manager' && p.Is_FAE__c == TRUE)){
                                    feList.add(p);
                                    feEditSet.add(p.User__c);
                                }
                            }
                        }
                        if(!amList.isEmpty()){
                            for(Account_Team_Proxy__c am: amList){
                                if(am.Team_Role__c == 'Primary Account Manager'){
                                    this.mpwResf.AM_Name__c = am.User__c;
                                    this.mpwResf.AM_Email__c = am.User_Email__c;
                                }
                            }
                        }
                        if(!feList.isEmpty()){
                            for(Account_Team_Proxy__c fe: feList){
                                if(fe.Team_Role__c == 'Primary Field Application Engineer'){
                                    this.mpwResf.FE_Name__c = fe.User__c;
                                    this.mpwResf.FE_Email__c = fe.User_Email__c;
                                }
                            }
                        }
                        if(!csrList.isEmpty()){
                            for(Account_Team_Proxy__c csr: csrList){
                                if(csr.Team_Role__c == 'Primary Customer Service Rep'){
                                    this.mpwResf.CSR_Name__c = csr.User__c;
                                    this.mpwResf.CSR_Email__c = csr.User_Email__c;
                                }
                            }
                        }
            }
            
    }
    
    public void exitPreview(){
        this.preview = false;
    }
    
    public void retrievePickListforPrimeDie(){
        
        GeometrySet=new set<String>();
        String processTypeRecordId = Schema.getGlobalDescribe().get('MPW_Config_Settings__c').getDescribe().getRecordTypeInfosByName().get('Process').getRecordTypeId();
       system.debug(this.mpwtm.Id+'=======TEST======='+processTypeRecordId);
      
        List<AggregateResult> aggrList = new List<AggregateResult>();
        aggrList = [select Process_Type__c from MPW_Train_Maintenance_Details__c where MPW_Train_Maintenance__c =: this.mpwtm.Id group by Process_Type__c];
        List<Id> processTypeId  = new List<Id>();
        if(!aggrList.isEmpty()){
            for(AggregateResult aggr: aggrList){
                processTypeId.add(String.valueOf(aggr.get('Process_Type__c')));
            }
            if(!processTypeId.isEmpty()){
                for(MPW_Config_Settings__c m: [select Id, Name from MPW_Config_Settings__c where Id IN: processTypeId and recordTypeId =: processTypeRecordId order by Name asc]){
                    
                    GeometrySet.add(m.Name);
                    
                }
            }
        }
             
        if(!this.mpwkcList.isEmpty()){
            
            mpwPrimeDieWrapperClass primeDie = new mpwPrimeDieWrapperClass();
                        boolean FlagetoaddBackgrind=false;
            primeDie.selected = false;
                        Set<String> SetofGeos=new Set<String>();
                        String GeometryLable=MPWGeometry__c.getInstance().Geometry__c;
                        List<String> SetofGeomertys = GeometryLable.split(',');
                        for(String GEOM:SetofGeomertys){
                                SetofGeos.add(GEOM);
                        }
                        for(String GEOM:GeometrySet){
                                if(SetofGeos.contains(GEOM)){
                                        FlagetoaddBackgrind=true;                        
                                }
                        }
            for(MPW_Keyword_Config__c m: mpwkcList) {
                if(m.Type__c == 'DieQuantity'){
                    primeDie.quantityDieFormList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'QuantityWaferForm'){
                    primeDie.quantityWaferFormList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'Backgrind'){                    
                   
                    if(FlagetoaddBackgrind){
                        if(m.Value__c!='None'){                             
                            primeDie.backgrindList.add(new SelectOption(m.Value__c, m.Value__c));
                        }
                    }else{
                         if(m.Value__c!='No Backgrind'){                              
                            primeDie.backgrindList.add(new SelectOption(m.Value__c, m.Value__c));
                        }
                    }                   
                    
                }
                if(m.Type__c == 'ShortLoopWafers'){
                    primeDie.shortLoopList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'Expedite'){
                    primeDie.expediteDieFormList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'ExpediteQuantityWaferForm'){
                    primeDie.expediteWaferFormList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'DeviceType'){
                    primeDie.deviceTypeList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'DrawnOrientation'){
                    primeDie.drawnOrientationList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'CornerSplit'){
                    primeDie.cornerSplitList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'TurnkeyServices'){
                    primeDie.turnkeyServicesList.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'SubDeviceExtraction'){
                    primeDie.subDeviceExtractionList.add(new SelectOption(m.Value__c, m.Value__c));
                }
            }
            this.mpwPrimeDieList.add(primeDie); 
        }    
    }
    
    public void retrieveMPWReservationDetails(String recId){
        String queryFields = '';
        String query = '';
        
        this.agree = true;
        
        queryFields = util.getAllFields('MPW_Reservation__c');
        queryFields += ', Process_Type__r.Name, Customer_Company_Name__r.Name';
        query = 'select '+queryFields+' from MPW_Reservation__c where Id =\''+recId+'\'';
        this.mpwResf = database.query(query);
        this.forwarderAccountType1 = new List<SelectOption>();
        this.forwarderAccountType2 = new List<SelectOption>();
        this.forwarderAccountType3 = new List<SelectOption>();
        for(MPW_Keyword_Config__c m: this.mpwkcList){
                if(m.Type__c == 'ForwarderAccountType'){
                this.forwarderAccountType1.add(new SelectOption(m.Value__c,m.Value__c));
                this.forwarderAccountType2.add(new SelectOption(m.Value__c,m.Value__c));
                this.forwarderAccountType3.add(new SelectOption(m.Value__c,m.Value__c));
            }
        } 
        
        if(this.accessMode == 'Edit'){
            if(this.requestor != null){
                this.mpwResf.Requestor_Name__c = requestor.Name;
                this.mpwResf.Requestor_Email__c = requestor.Email;      
            }
            if(this.supervisor != null){
                this.mpwResf.Supervisor_Name__c = supervisor.Name;
                this.mpwResf.Supervisor_Email__c = supervisor.Email; 
                this.mpwResf.Supervisor__c = this.supervisor.Id;   
            }
            if(this.supervisor == null) {
                this.mpwResf.Supervisor_Name__c = '';
                this.mpwResf.Supervisor_Email__c = ''; 
                this.mpwResf.Supervisor__c = null;
            }  
        }
        
        if(this.mpwResf.Company_Name__c != null){
            this.showAddress1 = true;
        }
        if(this.mpwResf.Company_Name2__c != null){
            this.showAddress2 = true;
        }
        if(this.mpwResf.Company_Name3__c != null){
            this.showAddress3 = true;
        }
        
        if(this.showAddress1 == false && this.showAddress2 == false && this.showAddress3 == false){
            this.showAddress1 = true;
        }
        
        queryFields = util.getAllFields('MPW_Train_Maintenance__c');
        query = 'select '+queryFields+' from MPW_Train_Maintenance__c where Id =\''+mpwResf.MPW_Train_Name__c+'\'';
        this.mpwtm = database.query(query);
        
        //Added by Anil Kumar : 00070564 - 0.15um Sub-Device Extraction supportability : April 18, 2017
        if(this.mpwtm.Geometry__c != null && setSubDeviceExtractionGeometry.contains(this.mpwtm.Geometry__c.toLowerCase())){
            showSubDeviceExtraction = true;
        }
        
        //if(this.mpwResf.Category__c == 'Customer'){
            retreiveCustomerInformation();
        //}
                
        //Submit Functionality
        if((this.mpwResf.Form_Status__c == 'Draft' || this.mpwResf.Form_Status__c == 'Rejected By FAE')  && this.accessMode == 'View'){
            if(!this.isExternalUser) { 
                if(UserInfo.getUserId() == this.mpwResf.OwnerId || this.isAdmin) {
                    this.isSubmitApp = true;
                }
            } else if(this.isExternalUser) {
                this.isSubmitApp = true;
            }  
            if(this.mpwResf.Category__c == 'Customer' && (feEditSet != null && feEditSet.contains(UserInfo.getUserId()))) {
                this.isSubmitApp = true;
            }
        }
        
        // for Edit Functionality
        if(this.accessMode == 'View' && (this.mpwResf.Form_Status__c == 'Draft' || this.mpwResf.Form_Status__c == 'Rejected By FAE')){
            if(!this.isExternalUser) { 
                if(UserInfo.getUserId() == this.mpwResf.OwnerId || this.isAdmin) {
                    this.isEdit = true;
                }
            } else if(this.isExternalUser) {
                this.isEdit = true;
            }
        } else if(this.accessMode == 'View' && this.mpwResf.Form_Status__c == 'Pending FAE Review') {
            if(feEditSet.contains(UserInfo.getUserId())) {
                this.isEdit = true;
                this.isfae = true;
            }
        } else if(this.accessMode == 'View' && (this.mpwResf.Form_Status__c == 'Accepted by CE' || this.mpwResf.Form_Status__c == 'Accepted by MPW Tapeout' || this.mpwResf.Form_Status__c == 'Accepted by Turnkey')) {
            if(!this.isExternalUser) {           
                    if(UserInfo.getUserId() == this.mpwResf.OwnerId || (amEditSet != null && amEditSet.contains(UserInfo.getUserId())) || (feEditSet != null && feEditSet.contains(UserInfo.getUserId())) || (csrEditSet != null && csrEditSet.contains(UserInfo.getUserId())) || this.isAdmin) {
                        this.isEdit = true;
                    } else if(userId.contains(UserInfo.getUserId())) {
                        this.isEdit = true;
                    } else if(this.isCSRProfile && this.mpwResf.Category__c != 'Customer') {
                        this.isEdit = true;
                    }
                } else if(this.isExternalUser) {
                    this.isEdit = true;
                }
        }
        
        if(!csrEditSet.isEmpty()){
            if((csrEditSet.contains(UserInfo.getUserId()) || this.isAdmin) && this.mpwResf.Form_Status__c != null){
                system.debug('IS CSR');
                this.isCSR = true;
            }
            
            if(csrEditSet.contains(UserInfo.getUserId())) {
                this.isCSRProfile = true;
            }
        }
        
        
        
        if(this.accessMode == 'Edit') {
            if((this.mpwResf.Form_Status__c == 'Accepted by CE' || this.mpwResf.Form_Status__c == 'Accepted by MPW Tapeout' || this.mpwResf.Form_Status__c == 'Accepted by Turnkey')  && this.copySearchNumber == null) {
                if(!this.isExternalUser) {           
                    if(UserInfo.getUserId() == this.mpwResf.OwnerId || (amEditSet != null && amEditSet.contains(UserInfo.getUserId())) || (feEditSet != null && feEditSet.contains(UserInfo.getUserId())) || (csrEditSet != null && csrEditSet.contains(UserInfo.getUserId()))) {
                        this.editAddDet = true;
                    } else if(userId.contains(UserInfo.getUserId())) {
                        this.editAddDet = true;
                        this.editCeTurn = true;
                    } 
                    if(this.isCSRProfile) {
                        this.editCSR = true;
                        if(UserInfo.getUserId() != this.mpwResf.OwnerId && this.mpwResf.Category__c != 'Customer') {
                            this.editAddDet = true;
                            this.editCeTurn = true;
                        }
                    }
                } else if(this.isExternalUser) {
                    this.editAddDet = true;
                }
            }
            if(this.mpwResf.Form_Status__c == 'Pending FAE Review'){
                if(!isExternalUser){
                    if(feEditSet != null && feEditSet.contains(UserInfo.getUserId())){
                        isfae = true;
                    }
                }
            }
        }
        
        retrieveSubCategoryAndUsage();
        
        this.mpwpiqList = new List<MPW_Process_Information_Question__c>();
        queryFields = util.getAllFields('MPW_Process_Information_Question__c');
        queryFields += ', MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c, MPW_Maintenance_Details__r.Answers__c';
        query = 'select '+queryFields+' from MPW_Process_Information_Question__c where MPW_Reservation_Form__c =\''+mpwResf.Id+'\'';
        query += ' AND MPW_Maintenance_Details__c != null'; //Added by Anil : Jan 10, 2017
        this.mpwpiqList = database.query(query);
        
        if(this.mpwpiqList.size() > 0){
            this.mpwpiqsize = this.mpwpiqList.size();
        }
        
        this.mpwsramquestionList = new List<MPW_SRAM_Question__c>();
        queryFields = util.getAllFields('MPW_SRAM_Question__c');
        queryFields += ', MPW_SRAM_Configuration__r.Name';
        query = 'select '+queryFields+' from MPW_SRAM_Question__c where MPW_Process_Information_Question__c =\''+this.mpwResf.Id+'\' order by MPW_SRAM_Configuration__r.Name';
        this.mpwsramquestionList = database.query(query);
        
        List<MPW_SRAM_Configuration__c> sramconfigList = new List<MPW_SRAM_Configuration__c>();
        sramconfigList = [select Id, Name from MPW_SRAM_Configuration__c where Active__c = true and Process_Type__c =: this.mpwResf.Process_Type__c];
        
        Set<String> existingSRAMNames = new Set<String>();
        if(!this.mpwsramquestionList.isEmpty()){
            for(MPW_SRAM_Question__c m: this.mpwsramquestionList){
                existingSRAMNames.add(m.MPW_SRAM_Configuration__r.Name);
            }
        }
              
        this.mpwtmawList = new List<TechModuleAnswersWrapper>();
        if(!this.mpwpiqList.isEmpty()){
            for(MPW_Process_Information_Question__c m: this.mpwpiqList){
                TechModuleAnswersWrapper temp = new TechModuleAnswersWrapper();
                List<String> answerList = m.MPW_Maintenance_Details__r.Answers__c.split(', ');
                if(!answerList.isEmpty()){
                    for(String a : answerList){
                        temp.selectOption.add(new SelectOption(a,a));
                    }
                }
                temp.answer = m.Answer__c;
                temp.mpwiq = m;
                temp.question = m.MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c;
                temp.mpwtmdId = m.MPW_Maintenance_Details__c;
                if(!this.mpwsramquestionList.isEmpty()){
                    for(MPW_SRAM_Question__c s: this.mpwsramquestionList){
                        for(MPW_SRAM_Configuration__c sram: sramconfigList){
                            if(s.MPW_SRAM_Configuration__r.Name == sram.Name){
                                SRAMQuestionWrapper ss = new SRAMQuestionWrapper();
                                ss.selected = true;
                                ss.mpwSRAMQues = s;
                                ss.name = s.MPW_SRAM_Configuration__r.Name;
                                temp.sqwList.add(ss);
                            }
                            else if(!existingSRAMNames.contains(sram.Name)){
                                SRAMQuestionWrapper ss = new SRAMQuestionWrapper();
                                ss.selected = false;
                                ss.mpwSRAMQues.MPW_SRAM_Configuration__c = sram.Id;
                                ss.name = sram.Name;
                                temp.sqwList.add(ss);
                            }
                        }
                    }
                }
                
                this.mpwtmawList.add(temp);
            }
        }
        
        this.mpwpdList = new List<MPW_Prime_Die__c>();
                List<MPW_Prime_Die__c> MPWPrimeDieAllfieldList=new List<MPW_Prime_Die__c>();
        List<MPW_Prime_Die__c> CopyMPWPrimeDieList=new List<MPW_Prime_Die__c>();
        queryFields = util.getAllFields('MPW_Prime_Die__c');
        queryFields += ', GMPL_Project_Name__r.Name';
        query = 'select '+queryFields+' from MPW_Prime_Die__c where MPW_Form__c = \''+this.mpwResf.Id+'\'';
                System.debug(this.mpwResf.Form_Status__c+'(((((((((MPW PIME DIE FIELDS))))))))))))))'+query);
        //this.mpwpdList = database.query(query);
        
        //04292016 - Added by Poulami Starts.
                
                 MPWPrimeDieAllfieldList = database.query(query);
            for(MPW_Prime_Die__c MPWPD : MPWPrimeDieAllfieldList){
                MPWPD.Extra_Die_B__c=null;
                MPWPD.RETICLE_SPACE_A__c=null;
                MPWPD.Extra_Wafer_Qty__c=null;
                MPWPD.isExtraDieRequest__c=false;
                MPWPD.isVoided__c=false;
                MPWPD.RETICLE_SPACE_A_Void_c__c=null;
                MPWPD.Extra_Die_B_Void__c=null;
                MPWPD.ADDER_D1__c=null;
                MPWPD.OPTION_C1__c=null;
                CopyMPWPrimeDieList.add(MPWPD);
            }
            this.mpwpdList =CopyMPWPrimeDieList;
       
        System.debug(this.mpwpdList.size()+'(((((((((LIST))))))))))))))'+this.mpwpdList);
                                
                List<Id> mpwPrmDieIdList = new List<Id>();
        for(MPW_Prime_Die__c m: this.mpwpdList){
            mpwPrmDieIdList.add(m.id);
        }
        this.mpwpdchList = new List<MPW_Prime_Die__c>();
        this.mpwpdchList = [SELECT id, Name, Prime_Die_Name__c,Turnkey_OSAT_address__c, Drawn_Die_Size_X_um__c,GMPL_Project_Name__c,Drawn_Die_Size_Y_um__c, Delivery_Qty_Die_Form__c, Delivery_Qty_Wafer_Form__c, Drawn_Orientation_Restricted_Structures__c, Metal_Stack__c, Device_Type__c, Corner_Split__c, POR__c, FF__c, SS__c, FS__c, SF__c, Wafer_POR__c, Wafer_FF__c, Wafer_SS__c, Wafer_FS__c, Wafer_SF__c, CornerSplitAttachedId__c,CornerSplitAttached__c, GMPL_Project_Name_Text__c, GMPL_Purpose__c, Backgrind__c, ShortLoop_Wafer__c, Sub_Devices_Extraction__c, SubDevicesExtractionAttachedId__c, SubDevicesExtractionAttached__c, Expedite_In_DIE_Form__c, Expedite_In_WAFER_Form__c, Turnkey_Service__c, TurnkeyAttachedId__c, TurnkeyAttached__c,  (SELECT Id, Name FROM MPW_Change_Requests__r) FROM MPW_Prime_Die__c where id IN :mpwPrmDieIdList];
        //04292016 - Added by Poulami Ends.
        
        this.mpwturnkeyList = new List<MPW_Turnkey__c>();
        queryFields = util.getAllFields('MPW_Turnkey__c');
        query = 'select '+queryFields+' from MPW_Turnkey__c where MPW_Reservation__c = \''+this.mpwResf.Id+'\'';
        this.mpwturnkeyList = database.query(query);
        
        //03082016 - Added by Poulami Starts.
        String cat = this.mpwResf.Category__c;
        List<MPW_Metal_Stack_Configuration__c> mpwmscList = new List<MPW_Metal_Stack_Configuration__c>();
        String soql = 'select Name from MPW_Metal_Stack_Configuration__c where Active__c = true and Category__c = \''+cat+'\' and Geometry__c = \''+this.mpwtm.Geometry__c+'\'';
        //06062016 - Modified code for case 00056083
        //if(this.mpwtm.Geometry__c == '55/65nm'){
        if(this.mpwResf.Process_Type__c != null){
            soql += ' and Process_Type__c = \''+mpwResf.Process_Type__c+'\'';
        }
        soql += ' order by Name asc';
        mpwmscList  = database.query(soql);
        //03082016 - Added by Poulami Ends.
        
        this.mpwPrimeDieList = new List<mpwPrimeDieWrapperClass>();
        for(MPW_Prime_Die__c m: this.mpwpdList){
            mpwPrimeDieWrapperClass d = new mpwPrimeDieWrapperClass();
            d.selected = false;
            if(this.copySearchNumber != null) {
                m.Prime_Die_Name__c = null;
                m.Id = null;    //Added by Anil : Backlog - MPW-PP102 : MPW Prime Die Name should not be the same for the given MPW train. Same category is validate but different category did not validate
                m.Legacy_Form_Audit_Trials__c = null;
            }
            d.mpwPrimeDie = m;
            for(MPW_Keyword_Config__c mk: mpwkcList)    {
                if(mk.Type__c == 'DieQuantity'){
                    d.quantityDieFormList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'QuantityWaferForm'){
                    d.quantityWaferFormList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'Backgrind'){
                    d.backgrindList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'ShortLoopWafers'){
                    d.shortLoopList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'Expedite'){
                    d.expediteDieFormList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'ExpediteQuantityWaferForm'){
                    d.expediteWaferFormList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'DeviceType'){
                    d.deviceTypeList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'DrawnOrientation'){
                    d.drawnOrientationList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'CornerSplit'){
                    d.cornerSplitList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'TurnkeyServices'){
                    d.turnkeyServicesList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
                if(mk.Type__c == 'SubDeviceExtraction'){
                    d.subDeviceExtractionList.add(new SelectOption(mk.Value__c, mk.Value__c));
                }
            }
            //03082016 - Added by Poulami Starts.
            for(MPW_Metal_Stack_Configuration__c metal: mpwmscList){
                d.metalStackList.add(new SelectOption(metal.Name, metal.Name));
            }
            //03082016 - Added by Poulami Ends.
            this.mpwPrimeDieList.add(d);
        }
        
        if(this.isChangeReq != null) {
            retrievePickListforChangeReq();
        }
        
        geometry1 = this.mpwResf.Geometry__c;
        
        if(this.copySearchNumber == null) {
            this.turnkeyWrap = new turnkeyWrapper(); 
            for(MPW_Prime_Die__c mpwpd: this.mpwpdList){
                this.turnkeyWrap.mpwpdsList.add(new SelectOption(mpwpd.Id, mpwpd.Prime_Die_Name__c));
            }
        }
        
        if(accessMode == 'View'){
            if(this.mpwResf.Form_Status__c != 'Draft' && this.mpwResf.Form_Status__c == 'Rejected By FAE' ){
                this.showApprovalHistory = true;
                if(this.mpwResf.Form_Status__c == 'Pending FAE Review' && isfae == true && this.mpwResf.Device__c == null){
                    this.showApprovalHistory = false;
                    this.showDeviceWarning = true;
                }
            }
        }
        
    }
    
    public void addRowToAddress(){
        integer addCount = 0;
        if(showAddress1 == false && addCount == 0){
            addCount++;
            showAddress1 = true;
        }
        if(showAddress2 == false && addCount == 0){
            addCount++;
            showAddress2 = true;
        }
        if(showAddress3 == false && addCount == 0){
            addCount++;
            showAddress3 = true;
        }
    }
    
    public void deleteAddress1(){
        showAddress1 = false;
        this.mpwResf.Company_Name__c = '';
        this.mpwResf.Address__c = '';
        this.mpwResf.Postal_Code__c = '';
        this.mpwResf.Contact_Person__c = '';
        this.mpwResf.Fax__c = null;
        this.mpwResf.Phone__c = null;
        this.mpwResf.Forwarder_Name1__c = '';
        this.mpwResf.Forwarder_Account1__c = '';
        this.mpwResf.Forwarder_Account_Type1__c = '';
        this.mpwResf.Registered_Company_Name1__c = '';
        for(mpwPrimeDieWrapperClass m: this.mpwPrimeDieList){
            m.mpwPrimeDie.Address1_Quantity_Delivery_In_DIE_Form__c = '';
            m.mpwPrimeDie.Address1_Quantity_Delivery_In_WAFER_Form__c = '';
        }
    }
    
    public void deleteAddress2(){
        showAddress2 = false;
        this.mpwResf.Company_Name2__c = '';
        this.mpwResf.Address2__c = '';
        this.mpwResf.Postal_Code2__c = '';
        this.mpwResf.Contact_Person2__c = '';
        this.mpwResf.Fax2__c = null;
        this.mpwResf.Phone2__c = null;
        this.mpwResf.Forwarder_Name2__c = '';
        this.mpwResf.Forwarder_Account2__c = '';
        this.mpwResf.Forwarder_Account_Type2__c = '';
        this.mpwResf.Registered_Company_Name2__c = '';
        for(mpwPrimeDieWrapperClass m: this.mpwPrimeDieList){
            m.mpwPrimeDie.Address2_Quantity_Delivery_In_DIE_Form__c = '';
            m.mpwPrimeDie.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        }
    }
    
    public void deleteAddress3(){
        showAddress3 = false;
        this.mpwResf.Company_Name3__c = '';
        this.mpwResf.Address3__c = '';
        this.mpwResf.Postal_Code3__c = '';
        this.mpwResf.Contact_Person3__c = '';
        this.mpwResf.Fax3__c = null;
        this.mpwResf.Phone3__c = null;
        this.mpwResf.Forwarder_Name3__c = '';
        this.mpwResf.Forwarder_Account3__c = '';
        this.mpwResf.Forwarder_Account_Type3__c = '';
        this.mpwResf.Registered_Company_Name3__c = '';
        for(mpwPrimeDieWrapperClass m: this.mpwPrimeDieList){
            m.mpwPrimeDie.Address3_Quantity_Delivery_In_DIE_Form__c = '';
            m.mpwPrimeDie.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        }
    }
    
    public void retreiveNotesData() {
        String todayDT = datetime.now().format('yyyy-MM-dd');
        String notesVar = 'FormNotes';
        String soql = 'select Value__c from MPW_Notes__c where Active__c = true and Type__c = \''+notesVar+'\' and Effective_Start_Date__c <= ' + todayDT + ' AND Effective_Finish_Date__c >= ' + todayDT + ' order by Sequence_No__c ASC';
        this.listFormNotes = database.query(soql);
    }
    
    public List<selectOption> gettrainOptions() {
    
        DateTime todayDT = datetime.now();
        
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Select Schedule', 'Select Schedule')); 
        if(geometry != null){
                for (MPW_Train_Maintenance__c mtm : [SELECT    Id
                                                               , Name
                                                               , Publish__c 
                                                               , Active__c 
                                                               , Geometry__c 
                                                               , Geometry_ID__c
                                                               , Reservation_Open_Date__c 
                                                               , Reservation_Close_Date__c
                                                     FROM      MPW_Train_Maintenance__c
                                                     WHERE     Active__c = true
                                                               AND Publish__c = true
                                                               AND Geometry_ID__c =: geometry
                                                               AND Reservation_Close_Date__c >= :todayDT 
                                                     ORDER BY  Name ASC ]) {                                    
                    options.add(new selectOption(mtm.Id, mtm.Name)); 
                }
        }
        return options;
   }
   
   public List<selectOption> gettrainOptions1() {
    
        DateTime todayDT = datetime.now();
        
        List<selectOption> options = new List<selectOption>();
        if(geometry1 != null){
                for (MPW_Train_Maintenance__c mtm : [SELECT    Id
                                                               , Name
                                                               , Publish__c 
                                                               , Active__c 
                                                               , Geometry__c 
                                                               , Reservation_Open_Date__c 
                                                               , Reservation_Close_Date__c
                                                     FROM      MPW_Train_Maintenance__c
                                                     WHERE     Active__c = true
                                                               AND Publish__c = true
                                                               AND Geometry__c =: geometry1
                                                               //AND Projected_2nd_Batch_Bare_Die_Ship_End__c != null
                                                     ORDER BY  Name ASC ]) {                                    
                    options.add(new selectOption(mtm.Id, mtm.Name)); 
                }
        }
        return options;
   }
   
   public void addRowToChipInformation(){
        if(this.mpwPrimeDieList.size() < rowSize) { 
            retrievePickListforPrimeDie(); 
            //04072016 - Modified by Poulami Starts.
            if(this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'Customer' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
                retriveMetalStackValues();
            }
            //04072016 - Modified by Poulami Ends.
        }
        else{
            showError = true;
        }   
   }
   
   public List<mpwPrimeDieWrapperClass> getPrimeDieWrapperList(){
    return this.mpwPrimeDieList;    
   }
   
   public void delRowToChipInformation(){
        List<MPW_Prime_Die__c> listToDelete = new List<MPW_Prime_Die__c>();
        rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
        if(this.copySearchNumber != null) {
            this.mpwPrimeDieList[rowNum].mpwPrimeDie.Id = null;
        }
        if(this.mpwPrimeDieList[rowNum].mpwPrimeDie.Id != null){
            listToDelete.add(this.mpwPrimeDieList.get(rowNum).mpwPrimeDie);
        }
        this.mpwPrimeDieList.remove(rowNum);
        if(!listToDelete.isEmpty()){
            delete listToDelete;
        }
   }
   
   public void retrieveMPWTrainScheduleDetails() {
       if(this.mpwResf.Id != null){
           delete [select Id from MPW_Process_Information_Question__c where MPW_Reservation_Form__c =: this.mpwResf.Id];
       }
        //06062016 - Modified code for case 00056083
        //if(this.mpwResf.mpwtm.Geometry__c == '55/65nm'){
        if(this.mpwResf.Process_Type__c != null){
            retriveMetalStackValues();
        }
        if(this.mpwtm.Geometry__c == '40nm' || this.mpwtm.Geometry__c == '28nm') {
            String processTypeRecordId = Schema.getGlobalDescribe().get('MPW_Config_Settings__c').getDescribe().getRecordTypeInfosByName().get('Process DM').getRecordTypeId();
            List<MPW_Config_Settings__c> mpwConfig = [Select Rule__c from MPW_Config_Settings__c where Geometry__c = :this.mpwtm.Geometry__c AND Name = :this.processTypeMap.get(this.mpwResf.Process_Type__c) AND Active__c = true AND recordTypeId = :processTypeRecordId LIMIT 1];
            if(!mpwConfig.isEmpty()) {
                ruleName = mpwConfig[0].Rule__c;
            }
        }
        List<MPW_SRAM_Configuration__c> sramConfig = new List<MPW_SRAM_Configuration__c>();
        mpwtmdList = new List<MPW_Train_Maintenance_Details__c>();
        mpwtmawList = new List<TechModuleAnswersWrapper>();
        this.selectedProcessTypeName = this.processTypeMap.get(this.mpwResf.Process_Type__c);
        mpwtmdList = [
            SELECT    Id
                      , Name
                      , Geometry__c
                      , Process_Type__c
                      , Process_Type__r.Name
                      , MPW_Tech_Module__c
                      , MPW_Tech_Module__r.Module_Name__c
                      , MPW_Tech_Module__r.Module_Description__c
                      , MPW_Tech_Module__r.Question__c
                      , Answers__c
            FROM      MPW_Train_Maintenance_Details__c
            WHERE     MPW_Train_Maintenance__c = :this.mpwtm.Id
            AND       Process_Type__c = : this.mpwResf.Process_Type__c   
            AND       MPW_Tech_Module__c != null
            ORDER BY  Geometry__c ASC, Process_Type__r.Name ASC
        ];
        if(mpwtmdList.isEmpty()){
                
        }
        else{   
                sramConfig = [select Id, Name, Process_Type__c from MPW_SRAM_Configuration__c where Active__c = true and Process_Type__c =: this.mpwResf.Process_Type__c];
                for(MPW_Train_Maintenance_Details__c m: mpwtmdList){
                        TechModuleAnswersWrapper t = new TechModuleAnswersWrapper();
                        t.mpwtmdId = m.Id;
                        t.question = m.MPW_Tech_Module__r.Question__c;
                        if(t.question.contains('Do you need SRAM')){
                            for(MPW_SRAM_Configuration__c mc: sramConfig){
                                SRAMQuestionWrapper s = new SRAMQuestionWrapper();
                                s.selected = false;
                                s.mpwSRAMQues.MPW_SRAM_Configuration__c = mc.Id;
                                s.mpwSRAMConfig = mc;
                                s.name = mc.Name;
                                t.sqwList.add(s);
                            }
                        }
                        List<String> options = new List<String>();
                        options = m.Answers__c.split(',');
                        for(String o: options){
                            t.selectOption.add(new SelectOption(o,o));
                        }
                        mpwtmawList.add(t);
                }
        }
        
    }
   
   public List<SelectOption> getProcesses() {
        this.processTypeMap = new Map<String,String>();
        String processTypeRecordId = Schema.getGlobalDescribe().get('MPW_Config_Settings__c').getDescribe().getRecordTypeInfosByName().get('Process').getRecordTypeId();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        List<AggregateResult> aggrList = new List<AggregateResult>();
        aggrList = [select Process_Type__c from MPW_Train_Maintenance_Details__c where MPW_Train_Maintenance__c =: this.mpwtm.Id group by Process_Type__c];
        List<Id> processTypeId  = new List<Id>();
        if(!aggrList.isEmpty()){
            for(AggregateResult aggr: aggrList){
                processTypeId.add(String.valueOf(aggr.get('Process_Type__c')));
            }
            if(!processTypeId.isEmpty()){
                for(MPW_Config_Settings__c m: [select Id, Name from MPW_Config_Settings__c where Id IN: processTypeId and recordTypeId =: processTypeRecordId order by Name asc]){
                    options.add(new SelectOption(m.Id, m.Name));
                    this.processTypeMap.put(m.Id,m.Name);
                }
            }
        }
        return options;
    }
           
    public List<TechModuleAnswersWrapper> getMPWTrainMaintenanceDetailList() {
        return this.mpwtmawList;
    }
    
    public void retrieveSubCategoryAndUsage(){
        subCategory = new List<SelectOption>();
        usage = new List<SelectOption>();
        paCode = new List<SelectOption>();
        if(this.mpwResf.Category__c == 'IP'){ 
                if(!this.mpwkcList.isEmpty()){
                        for(MPW_Keyword_Config__c m: this.mpwkcList){
                                if(m.Type__c == 'IPSubCategory'){
                                        subCategory.add(new SelectOption(m.Value__c,m.Value__c));       
                                }
                        }
                }
        }
      
        if(this.mpwResf.Category__c == 'TD'){
                if(!this.mpwkcList.isEmpty()){
                        for(MPW_Keyword_Config__c m: this.mpwkcList){
                                if(m.Type__c == 'CategoryUsage'){
                                        usage.add(new SelectOption(m.Value__c,m.Value__c));
                                }
                        }
                        if(this.mpwResf.Id == null && this.mpwResf.Usage__c != 'Opportunistic'){
                            this.mpwResf.Usage__c = 'Required';
                        }   
                        List<MPW_ERP_PA_Code__c> mpwepcList = new List<MPW_ERP_PA_Code__c>();
                        mpwepcList = [select Id, Name, PA_Description__c from MPW_ERP_PA_Code__c where Name != '0' order by Name asc];
                        if(!mpwepcList.isEmpty() && this.mpwResf.Usage__c != 'Opportunistic'){
                            for(MPW_ERP_PA_Code__c m: mpwepcList){
                                paCode.add(new SelectOption(m.Name,m.PA_Description__c));
                            }
                        }
                }
        }
        if(this.mpwResf.Category__c == 'FAB'){
                if(!this.mpwkcList.isEmpty()){
                        for(MPW_Keyword_Config__c m: this.mpwkcList){
                                if(m.Type__c == 'CategoryUsage'){
                                        usage.add(new SelectOption(m.Value__c,m.Value__c));
                                }
                        }
                }
        }
        if(this.mpwResf.Category__c == 'DE'){
            if(!this.mpwkcList.isEmpty()){
                for(MPW_Keyword_Config__c m: this.mpwkcList){
                    if(m.Type__c == 'DESubCategory'){
                        subCategory.add(new SelectOption(m.Value__c,m.Value__c));
                    }
                }
            }
        }
        //04072016 - Added by Poulami Starts.
        if(this.mpwResf.Category__c == 'ASIC R&D'){
            if(!this.mpwkcList.isEmpty()){
                for(MPW_Keyword_Config__c m: this.mpwkcList){
                    if(m.Type__c == 'ASIC_R&DSubCategory'){
                        subCategory.add(new SelectOption(m.Value__c,m.Value__c));
                    }
                }
                //Kanishk:Show ASIC R&D related PA Code
                Map<String,string> mapPACODE=new map<String,string>();
                for(MPW_Approval_Matrix__c obj:[Select PA_Code__c from MPW_Approval_Matrix__c where Category__c =: this.mpwResf.Category__c order by createdDate asc]){
                        if(obj.PA_Code__c!=null && mapPACODE.get(obj.PA_Code__c)==null){
                           paCode.add(new SelectOption(obj.PA_Code__c,obj.PA_Code__c));
                           mapPACODE.put(obj.PA_Code__c,obj.PA_Code__c);
                        } 
                }
            }
        }
        if(this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
            if(!this.mpwkcList.isEmpty()){
                for(MPW_Keyword_Config__c m: this.mpwkcList){
                    if(m.Type__c == 'RF_ASIC_A&D_ProtosSubCategory'){
                        subCategory.add(new SelectOption(m.Value__c,m.Value__c));
                    }
                }
            }
        }
        //if(this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
        if(this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
            this.mpwResf.PA_Code__c = [Select PA_Code__c from MPW_Approval_Matrix__c where Category__c =: this.mpwResf.Category__c LIMIT 1].PA_Code__c;
        }
        //04072016 - Added by Poulami Ends.
       
    }
    
    public List<SelectOption> getSubCategories(){
        return subCategory;
    }
    
    public List<SelectOption> getUsages(){
        return usage;
    }
    
    public List<SelectOption> getPACodes(){
        return paCode;
    }
    
    //Added By Abhita
    private DateTime convertDateTime(DateTime pDT) {
        system.debug('pDT:'+pDT);
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');
        String[] ss = temp.split(' ');
        String[] st = ss[0].split('-');
        String[] tt = ss[1].split(':');

        Datetime pstTime = Datetime.newInstanceGMT(Integer.valueOf(st[0]),Integer.valueOf(st[1]),Integer.valueOf(st[2]),Integer.valueOf(tt[0]),Integer.valueOf(tt[1]),Integer.valueOf(tt[2]));
        
        return pstTime;
    }
    
    Public void PrimeDieValidation(){
        success = true;
        Set<String> primedienameset = new Set<String>();
         List<MPW_Prime_Die__c> temppdList = new List<MPW_Prime_Die__c>();
        Map<Id, String> mapExistingPrimeDieName = new Map<Id, String>();
        temppdList = [select Id, Prime_Die_Name__c, MPW_Form__r.Form_Status__c, MPW_Form__r.MPW_Train_Name__r.Id from MPW_Prime_Die__c where MPW_Form__r.MPW_Train_Name__r.Id =: this.mpwtm.Id AND MPW_Form__r.Form_Status__c != 'Void'];
         
         if(mpwResf.Process_Type__c==null){
            success = false;
            mpwResf.Process_Type__c.addError('Select Process Type.');
        }
        
        if(!temppdList.isEmpty()){
            for(MPW_Prime_Die__c m: temppdList){
                
                if(m.Prime_Die_Name__c!=null){
                    primedienameset.add(m.Prime_Die_Name__c);
                    mapExistingPrimeDieName.put(m.Id, m.Prime_Die_Name__c.toLowerCase());
                }
            }
        }
        if(!mpwPrimeDieList.isEmpty()){
            for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                    if(m.mpwPrimeDie.Prime_Die_Name__c == null){
                        success = false;
                        m.mpwPrimeDie.Prime_Die_Name__c.addError('Prime Die Name cannot be blank.');
                    }
                    if(m.mpwPrimeDie.Prime_Die_Name__c != null && m.mpwPrimeDie.Prime_Die_Name__c.length() > 20){
                        success = false;
                        m.mpwPrimeDie.Prime_Die_Name__c.addError('Prime Die Name should be not greater than 20 characters.');
                    }
                    if(!primedienameset.isEmpty()){
                        //Commented and Updated by Anil : verifing Duplicate Prime Die Name for same Train irrespective of Category or new or edit 
                        //if(primedienameset.contains(m.mpwPrimeDie.Prime_Die_Name__c)){
                        if((primedienameset.contains(m.mpwPrimeDie.Prime_Die_Name__c) && m.mpwPrimeDie.Id == null) || (primedienameset.contains(m.mpwPrimeDie.Prime_Die_Name__c) && m.mpwPrimeDie.Id != null && mapExistingPrimeDieName.containsKey(m.mpwPrimeDie.Id) && m.mpwPrimeDie.Prime_Die_Name__c.toLowerCase() != mapExistingPrimeDieName.get(m.mpwPrimeDie.Id) )) {
                            success = false;
                            m.mpwPrimeDie.Prime_Die_Name__c.addError('Prime Die Name already in use.');
                        }
                    }
            }
        }
        
    }
    
    public void validate(){
        success = true;
        
        List<MPW_Prime_Die__c> temppdList = new List<MPW_Prime_Die__c>();
        Set<String> primedienameset = new Set<String>();
        Map<Id, String> mapExistingPrimeDieName = new Map<Id, String>();
        
        //Added by Anil : AND MPW_Form__r.Form_Status__c != 'Void'
        temppdList = [select Id, Prime_Die_Name__c, MPW_Form__r.Form_Status__c, MPW_Form__r.MPW_Train_Name__r.Id from MPW_Prime_Die__c where MPW_Form__r.MPW_Train_Name__r.Id =: this.mpwtm.Id AND MPW_Form__r.Form_Status__c != 'Void'];
        
        if(!temppdList.isEmpty()){
            for(MPW_Prime_Die__c m: temppdList){
                system.debug(m.Prime_Die_Name__c+'____________DIEVALUE________'+m.Id);
                if(m.Prime_Die_Name__c!=null){
                    primedienameset.add(m.Prime_Die_Name__c);
                    mapExistingPrimeDieName.put(m.Id, m.Prime_Die_Name__c.toLowerCase());
                }
            }
        }
        
        if(this.copySearchNumber != null) {
            // Added By Abhita
            Datetime todayDT = convertDateTime(DateTime.now());
            if(!this.isExternalUser) {
                retreiveAccountTeamProxyOnCopy(this.mpwtm.Id);
                Set<Id> atpValues = new Set<Id>();
                atpValues = atpMap.get(mpwTrainAccIdMap.get(this.mpwtm.Id));
                System.debug(mpwTrainAccIdMap.containsKey(this.mpwtm.Id));
                //System.debug(!atpValues.contains(UserInfo.getUserId()));
                if(mpwTrainAccIdMap.containsKey(this.mpwtm.Id)) {
                    if(!atpValues.contains(UserInfo.getUserId())) {
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Logged In User is not present in Account Team Proxy Team. Please pick another MPW.'));
                    }
                } else if(this.mpwtm.Reservation_Close_Date__c < todayDT) {
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reservation Close Date for selected MPW train has been passed. Please pick another MPW.'));
                }
            } else if(this.isExternalUser) {
                if(this.mpwtm.Train_Type__c == 'CustomizedShuttle' && mpwPortalFormIds.contains(this.mpwtm.Id) && this.mpwtm.Reservation_Close_Date__c < todayDT ){
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reservation Close Date for selected MPW train has been passed. Please pick another MPW.'));
                }
                //if(this.mpwtm.Train_Type__c == 'GlobalShuttle' && ((this.mpwtm.Reservation_Close_Date__c < todayDT) || (mpwPortalFormIds.contains(this.mpwtm.Id) && this.mpwtm.Reservation_Close_Date__c >= todayDT))){
                //01222016 - Modified by Poulami.
                if(this.mpwtm.Train_Type__c == 'GlobalShuttle' && this.mpwtm.Reservation_Close_Date__c < todayDT && (mpwPortalFormIds.contains(this.mpwtm.Id) == false)){
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Reservation Close Date for selected MPW train has been passed. Please pick another MPW.'));
                }  
            }
        }
        
        if(!mpwPrimeDieList.isEmpty()){
            if(this.mpwResf.Process_Type__c == null){
                success = false;
                this.mpwResf.Process_Type__c.addError('Please select a Process Type.');
            }
            if(this.mpwResf.Category__c != 'TD' && this.mpwResf.Category__c != 'FAB'){
                if(showAddress1){
                    if((mpwResf.Company_Name__c != null && mpwResf.Company_Name__c.trim() == '') || mpwResf.Company_Name__c == null || (mpwResf.Address__c != null && mpwResf.Address__c.trim() == '') || mpwResf.Address__c == null || (mpwResf.Contact_Person__c != null && mpwResf.Contact_Person__c.trim() == '') || mpwResf.Contact_Person__c == null || (mpwResf.Phone__c != null && mpwResf.Phone__c.trim() == '') || mpwResf.Phone__c == null || (mpwResf.Postal_Code__c != null && mpwResf.Postal_Code__c.trim() == '') || mpwResf.Postal_Code__c == null || (this.mpwResf.Category__c == 'Customer' && ((mpwResf.Forwarder_Name1__c != null && mpwResf.Forwarder_Name1__c.trim() == '') || mpwResf.Forwarder_Name1__c == null || (mpwResf.Forwarder_Account1__c != null && mpwResf.Forwarder_Account1__c.trim() == '') || mpwResf.Forwarder_Account1__c == null || (mpwResf.Registered_Company_Name1__c != null && mpwResf.Registered_Company_Name1__c.trim() == '') || mpwResf.Registered_Company_Name1__c == null))){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'All fields are mandatory for Address 1.'));
                    }
                    //Modified by Anil Kumar : 00070567 : Forwarder Account# more than 4 char : April 18, 2017
                    else if(this.mpwResf.Category__c == 'Customer' && mpwResf.Forwarder_Account1__c != null && mpwResf.Forwarder_Account1__c.trim().length() <= 4 && !Test.isRunningTest()){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Forwarder Account should have more than 4 character in Address 1.'));
                    }
                }
                if(showAddress2){
                    if((mpwResf.Company_Name2__c != null && mpwResf.Company_Name2__c.trim() == '') || mpwResf.Company_Name2__c == null || (mpwResf.Address2__c != null && mpwResf.Address2__c.trim() == '') || mpwResf.Address2__c == null || (mpwResf.Contact_Person2__c != null && mpwResf.Contact_Person2__c.trim() == '') || mpwResf.Contact_Person2__c == null || (mpwResf.Phone2__c != null && mpwResf.Phone2__c.trim() == '') || mpwResf.Phone2__c == null || (mpwResf.Postal_Code2__c != null && mpwResf.Postal_Code2__c.trim() == '') || mpwResf.Postal_Code2__c == null || (this.mpwResf.Category__c == 'Customer' && ((mpwResf.Forwarder_Name2__c != null && mpwResf.Forwarder_Name2__c.trim() == '') || mpwResf.Forwarder_Name2__c == null || (mpwResf.Forwarder_Account2__c != null && mpwResf.Forwarder_Account2__c.trim() == '') || mpwResf.Forwarder_Account2__c == null || (mpwResf.Registered_Company_Name2__c != null && mpwResf.Registered_Company_Name2__c.trim() == '') || mpwResf.Registered_Company_Name2__c == null))){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'All fields are mandatory for Address 2.'));
                    }
                    //Modified by Anil Kumar : 00070567 : Forwarder Account# more than 4 char : April 18, 2017
                    else if(this.mpwResf.Category__c == 'Customer' && mpwResf.Forwarder_Account2__c != null && mpwResf.Forwarder_Account2__c.trim().length() <= 4 && !Test.isRunningTest()){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Forwarder Account should have more than 4 character in Address 2.'));
                    }
                }
                if(showAddress3){
                    if((mpwResf.Company_Name3__c != null && mpwResf.Company_Name3__c.trim() == '') || mpwResf.Company_Name3__c == null || (mpwResf.Address3__c != null && mpwResf.Address3__c.trim() == '') || mpwResf.Address3__c == null || (mpwResf.Contact_Person3__c != null && mpwResf.Contact_Person3__c.trim() == '') || mpwResf.Contact_Person3__c == null || (mpwResf.Phone3__c != null && mpwResf.Phone3__c.trim() == '') || mpwResf.Phone3__c == null || (mpwResf.Postal_Code3__c != null && mpwResf.Postal_Code3__c.trim() == '') || mpwResf.Postal_Code3__c == null || (this.mpwResf.Category__c == 'Customer' && ((mpwResf.Forwarder_Name3__c != null && mpwResf.Forwarder_Name3__c.trim() == '') || mpwResf.Forwarder_Name3__c == null || (mpwResf.Forwarder_Account3__c != null && mpwResf.Forwarder_Account3__c.trim() == '') || mpwResf.Forwarder_Account3__c == null || (mpwResf.Registered_Company_Name3__c != null && mpwResf.Registered_Company_Name3__c.trim() == '') || mpwResf.Registered_Company_Name3__c == null))){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'All fields are mandatory for Address 3.'));
                    }
                    //Modified by Anil Kumar : 00070567 : Forwarder Account# more than 4 char : April 18, 2017
                    else if(this.mpwResf.Category__c == 'Customer' && mpwResf.Forwarder_Account3__c != null && mpwResf.Forwarder_Account3__c.trim().length() <= 4 && !Test.isRunningTest()){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Forwarder Account should have more than 4 character in Address 3.'));
                    }
                }
            }
            if(this.mpwResf.Category__c != 'Customer'){
                if(this.mpwResf.Account_Internal__c == null){
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select an account.'));
                }
            }
            
            if(this.mpwResf.Category__c == 'Customer' && isExternalUser == false){
                if(this.mpwResf.Customer_Company_Name__c == null){
                    success = false;
                    this.mpwResf.Customer_Company_Name__c.addError('Please select an account.');
                }
            }
            if(this.mpwResf.Category__c == 'Customer'){
                if(this.mpwResf.Customer_Name__c == null){
                        success = false;
                    this.mpwResf.Customer_Name__c.addError('Please enter value.');
                }
                if(this.mpwResf.Customer_Email__c == null){
                        success = false;
                    this.mpwResf.Customer_Email__c.addError('Please enter value.');
                }
                if(this.mpwResf.Customer_Phone__c == null){
                        success = false;
                    this.mpwResf.Customer_Phone__c.addError('Please enter value.');
                }
            }
            Set<String> pdnameList = new Set<String>();
            for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                pdnameList.add(m.mpwPrimeDie.Prime_Die_Name__c);
            }
            if(pdnameList.size() != mpwPrimeDieList.size()){
                success = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Duplicate Prime Die Names found.'));
            }
            
            for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                if(m.mpwPrimeDie.Prime_Die_Name__c == null){
                    success = false;
                    m.mpwPrimeDie.Prime_Die_Name__c.addError('Prime Die Name cannot be blank.');
                }
                if(m.mpwPrimeDie.Prime_Die_Name__c != null && m.mpwPrimeDie.Prime_Die_Name__c.length() > 20){
                    success = false;
                    m.mpwPrimeDie.Prime_Die_Name__c.addError('Prime Die Name should be not greater than 20 characters.');
                }
                if(!primedienameset.isEmpty()){
                    //Commented and Updated by Anil : verifing Duplicate Prime Die Name for same Train irrespective of Category or new or edit 
                    //if(primedienameset.contains(m.mpwPrimeDie.Prime_Die_Name__c)){
                    if((primedienameset.contains(m.mpwPrimeDie.Prime_Die_Name__c) && m.mpwPrimeDie.Id == null) || (primedienameset.contains(m.mpwPrimeDie.Prime_Die_Name__c) && m.mpwPrimeDie.Id != null && mapExistingPrimeDieName.containsKey(m.mpwPrimeDie.Id) && m.mpwPrimeDie.Prime_Die_Name__c.toLowerCase() != mapExistingPrimeDieName.get(m.mpwPrimeDie.Id) )) {
                        success = false;
                        m.mpwPrimeDie.Prime_Die_Name__c.addError('Prime Die Name already in use.');
                    }
                }
                if(m.mpwPrimeDie.Drawn_Die_Size_X_um__c == null){
                    success = false;
                    m.mpwPrimeDie.Drawn_Die_Size_X_um__c.addError(m.mpwPrimeDie.Prime_Die_Name__c+': Drawn Die Size Xum cannot be blank.');
                }
                if(m.mpwPrimeDie.Drawn_Die_Size_Y_um__c == null){
                    success = false;
                    m.mpwPrimeDie.Drawn_Die_Size_Y_um__c.addError(m.mpwPrimeDie.Prime_Die_Name__c+': Drawn Die Size Yum cannot be blank.');
                }
                if(this.mpwResf.Category__c == 'TD' || this.mpwResf.Category__c == 'FAB'){
                    
                }
                else{
                    /** Commented by Anil - Dec 2, 2016 - MPW Backlog : MPW-PP111
                    if(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c == '0' && m.mpwPrimeDie.Delivery_Qty_Die_Form__c == '0'){
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Delivery Quantity should be selected either in Die form or Wafer form.'));
                    }
                    */
                }
                
                if(m.mpwPrimeDie.Device_Type__c == 'None' && this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD'){
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+':Device Type cannot be blank.'));
                }
                
                //Kanishk: Metal Stack cannot be blank for 14 and 7nm Geometry
                if(m.mpwPrimeDie.Metal_Stack__c == 'None' && this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD' 
                   &&(this.mpwtm.Geometry__c=='14nm' ||this.mpwtm.Geometry__c=='12/14nm' ||this.mpwtm.Geometry__c=='7nm' ) ){
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Metal_Stack__c+':Metal Stack cannot be blank.'));
                }
                
                if(this.mpwResf.Category__c == 'TD'){
                    if(this.mpwResf.Usage__c == 'Required' && m.mpwPrimeDie.GMPL_Project_Name_Id__c == ''){
                        success = false;
                        m.mpwPrimeDie.GMPL_Project_Name_Id__c.addError('GMPL Project cannot be blank for '+m.mpwPrimeDie.Prime_Die_Name__c);
                    }
                    else if(this.mpwResf.Usage__c == 'Opportunistic' && m.mpwPrimeDie.GMPL_Purpose__c == null){
                        success = false;
                        m.mpwPrimeDie.GMPL_Purpose__c.addError('Purpose/Remarks cannot be blank for '+m.mpwPrimeDie.Prime_Die_Name__c);
                    }
                }
                else if(this.mpwResf.Category__c != 'Customer' && m.mpwPrimeDie.GMPL_Purpose__c == null){
                        success = false;
                        m.mpwPrimeDie.GMPL_Purpose__c.addError(m.mpwPrimeDie.Prime_Die_Name__c+': Purpose/Remarks cannot be blank.');
                }
                
                
                if(m.mpwPrimeDie.Delivery_Qty_Die_Form__c != '0' && m.mpwPrimeDie.Backgrind__c == 'None'){
                    success = false;
                    m.mpwPrimeDie.Backgrind__c.addError(m.mpwPrimeDie.Prime_Die_Name__c+': Backgrind__c cannot be blank since Delivery Quantity is in Die Form.');
                }
                if(m.mpwPrimeDie.Corner_Split__c == 'Yes' && this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD'){
                    //01042016 - Added by Poulami Starts
                    
                    if((integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) == 0) && (m.mpwPrimeDie.POR__c == null || (m.mpwPrimeDie.POR__c.isNumeric() == true && Integer.valueOf(m.mpwPrimeDie.POR__c) <= 0))) {
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Die Form cannot be null or zero for '+m.mpwPrimeDie.Prime_Die_Name__c));
                    }
                    if(integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) == 0 && m.mpwPrimeDie.FF__c == null && m.mpwPrimeDie.FS__c == null && m.mpwPrimeDie.SF__c == null && m.mpwPrimeDie.SS__c == null) {
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Die Form should have value.'));
                    }
                    if((integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) == 0) && (m.mpwPrimeDie.Wafer_POR__c == null || (m.mpwPrimeDie.Wafer_POR__c.isNumeric() == true && Integer.valueOf(m.mpwPrimeDie.Wafer_POR__c) <= 0))) {
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Wafer Form cannot be null or zero for '+m.mpwPrimeDie.Prime_Die_Name__c));
                    }
                    if(integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) == 0 && m.mpwPrimeDie.Wafer_FF__c == null && m.mpwPrimeDie.Wafer_FS__c == null && m.mpwPrimeDie.Wafer_SF__c == null && m.mpwPrimeDie.Wafer_SS__c == null) {
                        success = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Wafer Form should have value.'));
                    }
                    //01042016 - Added by Poulami Ends
                    Integer subCorner = 0;
                    if(m.mpwPrimeDie.FF__c != null && m.mpwPrimeDie.FF__c.isNumeric() == true){
                        subCorner += integer.valueOf(m.mpwPrimeDie.FF__c);
                    }
                    if(m.mpwPrimeDie.FS__c != null && m.mpwPrimeDie.FS__c.isNumeric() == true){
                        subCorner += integer.valueOf(m.mpwPrimeDie.FS__c);
                    }
                    if(m.mpwPrimeDie.SF__c != null && m.mpwPrimeDie.SF__c.isNumeric() == true){
                        subCorner += integer.valueOf(m.mpwPrimeDie.SF__c);
                    }
                    if(m.mpwPrimeDie.SS__c != null && m.mpwPrimeDie.SS__c.isNumeric() == true){
                        subCorner += integer.valueOf(m.mpwPrimeDie.SS__c);
                    }
                    if(m.mpwPrimeDie.POR__c != null && m.mpwPrimeDie.POR__c.isNumeric() == true){
                        subCorner += integer.valueOf(m.mpwPrimeDie.POR__c);
                    }
                    //01042016 - Added by Poulami Starts
                    Integer subCorner1 = 0;
                    if(m.mpwPrimeDie.Wafer_FF__c != null && m.mpwPrimeDie.Wafer_FF__c.isNumeric() == true){
                        subCorner1 += integer.valueOf(m.mpwPrimeDie.Wafer_FF__c);
                    }
                    if(m.mpwPrimeDie.Wafer_FS__c != null && m.mpwPrimeDie.Wafer_FS__c.isNumeric() == true){
                        subCorner1 += integer.valueOf(m.mpwPrimeDie.Wafer_FS__c);
                    }
                    if(m.mpwPrimeDie.Wafer_SF__c != null && m.mpwPrimeDie.Wafer_SF__c.isNumeric() == true){
                        subCorner1 += integer.valueOf(m.mpwPrimeDie.Wafer_SF__c);
                    }
                    if(m.mpwPrimeDie.Wafer_SS__c != null && m.mpwPrimeDie.Wafer_SS__c.isNumeric() == true){
                        subCorner1 += integer.valueOf(m.mpwPrimeDie.Wafer_SS__c);
                    }
                    if(m.mpwPrimeDie.Wafer_POR__c != null && m.mpwPrimeDie.Wafer_POR__c.isNumeric() == true){
                        subCorner1 += integer.valueOf(m.mpwPrimeDie.Wafer_POR__c);
                    }
                    
                    if(integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) == 0){
                        if(subCorner != integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c)){
                            success = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of POR, FF, SS, SF, FS in Die Form are not matching with Quantity Delivery in Die Form.'));
                        }
                    }
                    if(integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) == 0){
                        if(subCorner1 != integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c)){
                            success = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of POR, FF, SS, SF, FS in Wafer Form are not matching with Quantity Delivery in Wafer Form.'));
                        }
                    }
                    if(integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) != 0){
                        if(subCorner == integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) || subCorner1 == integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c)){
                            if(subCorner == integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c)){
                                if(m.mpwPrimeDie.POR__c == null || (m.mpwPrimeDie.POR__c.isNumeric() == true && Integer.valueOf(m.mpwPrimeDie.POR__c) <= 0)) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Die Form cannot be null or zero for '+m.mpwPrimeDie.Prime_Die_Name__c));
                                }
                                if(m.mpwPrimeDie.FF__c == null && m.mpwPrimeDie.FS__c == null && m.mpwPrimeDie.SF__c == null && m.mpwPrimeDie.SS__c == null) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Die Form should have value.'));
                                }
                            }else if(subCorner != integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c) && ((m.mpwPrimeDie.FF__c != null && m.mpwPrimeDie.FF__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.FF__c) != 0) || (m.mpwPrimeDie.FS__c != null && m.mpwPrimeDie.FS__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.FS__c) != 0) || (m.mpwPrimeDie.SF__c != null && m.mpwPrimeDie.SF__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.SF__c) != 0) || (m.mpwPrimeDie.SS__c != null && m.mpwPrimeDie.SS__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.SS__c) != 0) || (m.mpwPrimeDie.POR__c != null && m.mpwPrimeDie.POR__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.POR__c) != 0))){
                                success = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of POR, FF, SS, SF, FS in Die Form are not matching with Quantity Delivery in Die Form.'));
                                if(m.mpwPrimeDie.POR__c == null || (m.mpwPrimeDie.POR__c.isNumeric() == true && Integer.valueOf(m.mpwPrimeDie.POR__c) <= 0)) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Die Form cannot be null or zero for '+m.mpwPrimeDie.Prime_Die_Name__c));
                                }
                                if(m.mpwPrimeDie.FF__c == null && m.mpwPrimeDie.FS__c == null && m.mpwPrimeDie.SF__c == null && m.mpwPrimeDie.SS__c == null) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Die Form should have value.'));
                                }
                                
                            }
                            if(subCorner1 == integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c)){
                                if(m.mpwPrimeDie.Wafer_POR__c == null || (m.mpwPrimeDie.Wafer_POR__c.isNumeric() == true && Integer.valueOf(m.mpwPrimeDie.Wafer_POR__c) <= 0)) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Wafer Form cannot be null or zero for '+m.mpwPrimeDie.Prime_Die_Name__c));
                                }
                                if(m.mpwPrimeDie.Wafer_FF__c == null && m.mpwPrimeDie.Wafer_FS__c == null && m.mpwPrimeDie.Wafer_SF__c == null && m.mpwPrimeDie.Wafer_SS__c == null) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Wafer Form should have value.'));
                                }
                            }else if(subCorner1 != integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c) && ((m.mpwPrimeDie.Wafer_FF__c != null && m.mpwPrimeDie.Wafer_FF__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.Wafer_FF__c) != 0) || (m.mpwPrimeDie.Wafer_FS__c != null && m.mpwPrimeDie.Wafer_FS__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.Wafer_FS__c) != 0) || (m.mpwPrimeDie.Wafer_SF__c != null && m.mpwPrimeDie.Wafer_SF__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.Wafer_SF__c) != 0) || (m.mpwPrimeDie.Wafer_SS__c != null && m.mpwPrimeDie.Wafer_SS__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.Wafer_SS__c) != 0) || (m.mpwPrimeDie.Wafer_POR__c != null && m.mpwPrimeDie.Wafer_POR__c.isNumeric() == true && integer.valueOf(m.mpwPrimeDie.Wafer_POR__c) != 0))){
                                success = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of POR, FF, SS, SF, FS in Wafer Form are not matching with Quantity Delivery in Wafer Form.'));
                                if(m.mpwPrimeDie.Wafer_POR__c == null || (m.mpwPrimeDie.Wafer_POR__c.isNumeric() == true && Integer.valueOf(m.mpwPrimeDie.Wafer_POR__c) <= 0)) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Wafer Form cannot be null or zero for '+m.mpwPrimeDie.Prime_Die_Name__c));
                                }
                                if(m.mpwPrimeDie.Wafer_FF__c == null && m.mpwPrimeDie.Wafer_FS__c == null && m.mpwPrimeDie.Wafer_SF__c == null && m.mpwPrimeDie.Wafer_SS__c == null) {
                                    success = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Wafer Form should have value.'));
                                }
                            }
                        }else{
                            success = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Either sum of POR, FF, SS, SF, FS in Die Form or Wafer Form are not matching with Quantity Delivery in Die Form or Wafer Form respectively.'));
                        }
                    }
                    
                    
                    //01042016 - Added by Poulami Ends
                }
                if(this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD'){
                        if(integer.valueOf(m.mpwPrimeDie.Expedite_In_DIE_Form__c) > integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c)){
                            success = false;
                            m.mpwPrimeDie.Expedite_In_DIE_Form__c.addError(m.mpwPrimeDie.Prime_Die_Name__c+': Expedite In Die Form cannot be greater that Delivery Quantity in Die Form.');
                        }
                        if(integer.valueOf(m.mpwPrimeDie.Expedite_In_WAFER_Form__c) > integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c)){
                            success = false;
                            m.mpwPrimeDie.Expedite_In_WAFER_Form__c.addError(m.mpwPrimeDie.Prime_Die_Name__c+': Expedite In Wafer Form cannot be greater that Delivery Quantity in Wafer Form.');
                        }
                        if(showAddress1 || showAddress2 || showAddress3){
                            Integer totalDieQuantity = 0;
                            if(showAddress1){
                                Integer add1die = 0;
                                if(m.mpwPrimeDie.Address1_Quantity_Delivery_In_DIE_Form__c == null){
                                    add1die = 0;
                                }
                                else{
                                    add1die = integer.valueOf(m.mpwPrimeDie.Address1_Quantity_Delivery_In_DIE_Form__c);
                                }
                                totalDieQuantity += add1die;
                            }
                            if(showAddress2){
                                Integer add2die = 0;
                                if(m.mpwPrimeDie.Address2_Quantity_Delivery_In_DIE_Form__c == null){
                                    add2die = 0;
                                }
                                else{
                                    add2die = integer.valueOf(m.mpwPrimeDie.Address2_Quantity_Delivery_In_DIE_Form__c);
                                }
                                totalDieQuantity += add2die;
                            }
                            if(showAddress3){
                                Integer add3die = 0;
                                if(m.mpwPrimeDie.Address3_Quantity_Delivery_In_DIE_Form__c == null){
                                    add3die = 0;
                                }
                                else{
                                    add3die = integer.valueOf(m.mpwPrimeDie.Address3_Quantity_Delivery_In_DIE_Form__c);
                                }
                                totalDieQuantity += add3die;
                            }
                            if(m.mpwPrimeDie.Delivery_Qty_Die_Form__c != 'None' && totalDieQuantity != integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Die_Form__c)){
                                success = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of Quantity Delivery in Die Form is not matching.'));
                            }
                            Integer totalWaferQuantity = 0;
                            if(showAddress1){
                                Integer add1wafer = 0;
                                if(m.mpwPrimeDie.Address1_Quantity_Delivery_In_WAFER_Form__c == null){
                                    add1wafer = 0;
                                }
                                else{
                                    add1wafer = integer.valueOf(m.mpwPrimeDie.Address1_Quantity_Delivery_In_WAFER_Form__c);
                                }
                                totalWaferQuantity += add1wafer;
                            }
                            if(showAddress2){
                                Integer add2wafer = 0;
                                if(m.mpwPrimeDie.Address2_Quantity_Delivery_In_WAFER_Form__c == null){
                                    add2wafer = 0;
                                }
                                else{
                                    add2wafer = integer.valueOf(m.mpwPrimeDie.Address2_Quantity_Delivery_In_WAFER_Form__c);
                                }
                                totalWaferQuantity += add2wafer;
                            }
                            if(showAddress3){
                                Integer add3wafer = 0;
                                if(m.mpwPrimeDie.Address3_Quantity_Delivery_In_WAFER_Form__c == null){
                                    add3wafer = 0;
                                }
                                else{
                                    add3wafer = integer.valueOf(m.mpwPrimeDie.Address3_Quantity_Delivery_In_WAFER_Form__c);
                                }
                                totalWaferQuantity += add3wafer;
                            }
                            if(totalWaferQuantity != integer.valueOf(m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c)){
                                success = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of Quantity Delivery in Wafer Form is not matching.'));
                            }
                            Integer ShortLoop = 0;
                            if(showAddress1){
                                Integer addSL1 = 0;
                                if(m.mpwPrimeDie.Address1_ShortLoop_Wafer__c == null){
                                        addSL1 = 0;
                                }
                                else{
                                        addSL1 = Integer.valueOf(m.mpwPrimeDie.Address1_ShortLoop_Wafer__c);
                                }
                                ShortLoop += addSL1;
                            }
                            if(showAddress2){
                                Integer addSL2 = 0;
                                if(m.mpwPrimeDie.Address2_ShortLoop_Wafer__c == null){
                                        addSL2 = 0;
                                }
                                else{
                                        addSL2 = Integer.valueOf(m.mpwPrimeDie.Address2_ShortLoop_Wafer__c);
                                }
                                ShortLoop += addSL2;
                            }
                            if(showAddress3){
                                Integer addSL3 = 0;
                                if(m.mpwPrimeDie.Address3_ShortLoop_Wafer__c == null){
                                        addSL3 = 0;
                                }
                                else{
                                        addSL3 = Integer.valueOf(m.mpwPrimeDie.Address3_ShortLoop_Wafer__c);
                                }
                                ShortLoop += addSL3;
                            }
                            if(m.mpwPrimeDie.ShortLoop_Wafer__c == 'None' || ShortLoop != Integer.valueOf(m.mpwPrimeDie.ShortLoop_Wafer__c)){
                                success = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, m.mpwPrimeDie.Prime_Die_Name__c+': Sum of ShortLoop Wafer is not matching.'));
                            }
                        }
                }
            }
            for(TechModuleAnswersWrapper t: this.mpwtmawList){
                if(t.answer == null){
                    success = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please answer all questions under Process Information section.'));
                }
                if(t.question.contains('Do you need SRAM')){
                    for(SRAMQuestionWrapper sram: t.sqwList){
                        if(sram.selected && sram.mpwSRAMQues.Answer__c == null){
                            success = false;
                            sram.mpwSRAMQues.Answer__c.addError('SRAM Array total block size cannot be blank for '+sram.name);
                        }
                    }
                }
            }
        }
    }
        
    public void gotoPreview(){
        validate();
        if(!success){
            return;
        }
        else{
            this.preview = true;    
        }   
        
    }
    
    public String retreiveFormName(){
         Map<String, MPW_Geometry_Mapping__c> mpwgmMap =  new Map<String, MPW_Geometry_Mapping__c>();
         List<MPW_Geometry_Mapping__c> mpwgmList = new List<MPW_Geometry_Mapping__c>();
         string f = util.getAllFields('MPW_Geometry_Mapping__c');
         string s = 'select '+f+' from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc';
         mpwgmList = database.query(s);
         if(!mpwgmList.isEmpty()){
            for(MPW_Geometry_Mapping__c g: mpwgmList){
                mpwgmMap.put(g.Name, g);
            }
         }
         String formno = '';
        String techNo = mpwgmMap.get(this.mpwtm.Geometry__c).TechNo__c; 
        Date currentdate = Date.today();
        String currentyear = String.valueof(currentdate.year());
        List<MPW_Form_No_Generator__c> mpwfngList = new List<MPW_Form_No_Generator__c>();
        mpwfngList = [select Id, Year__c, Geometry__c, Last_Sequence_No__c from MPW_Form_No_Generator__c where Year__c =: currentyear and Geometry__c =: techNo];
        if(!mpwfngList.isEmpty()){
            //Kanishk: Make list to avoid DML under the loop
            List < MPW_Form_No_Generator__c > lstMpwfng = new List < MPW_Form_No_Generator__c > ();
            
            for(MPW_Form_No_Generator__c mpwfng: mpwfngList){
                if(mpwfng.Last_Sequence_No__c != null){
                    String lastsequence = String.valueOf(mpwfng.Last_Sequence_No__c+1);
                    String finalsequence = '';
                    if(lastsequence.length() == 1){
                        finalsequence = '0000'+String.valueof(lastsequence);
                    }
                    if(lastsequence.length() == 2){
                        finalsequence = '000'+String.valueof(lastsequence);
                    }
                    if(lastsequence.length() == 3){
                        finalsequence = '00'+String.valueof(lastsequence);
                    }
                    if(lastsequence.length() == 4){
                        finalsequence = '0'+String.valueof(lastsequence);
                    }
                    if(lastsequence.length() == 5){
                        finalsequence  = String.valueOf(lastsequence);
                    }
                    formno = mpwfng.Year__c+'-'+mpwfng.Geometry__c+'-'+finalsequence;
                    mpwfng.Last_Sequence_No__c = Integer.valueOf(lastsequence);
                    //update mpwfng;
                     lstMpwfng.add(mpwfng);
                }
            }
            if (lstMpwfng != null && lstMpwfng.size() > 0) {
               performDMLOperation(lstMpwfng, true);
            }
        }
        else{
            MPW_Form_No_Generator__c tempmpwfng = new MPW_Form_No_Generator__c();
            tempmpwfng.Year__c = currentyear;
            tempmpwfng.Geometry__c = techNo;
            tempmpwfng.Last_Sequence_No__c = 1;
            insert tempmpwfng;
            formno  = tempmpwfng.Year__c+'-'+tempmpwfng.Geometry__c+'-00001';
        }
            return formno;
    }   
     
    private void performDMLOperation(List <sObject> lstObject, boolean allOrNone) {

        Database.UpsertResult[] srList = Database.upsert(lstObject, allOrNone);

        if (srList != null) {
            for (Database.UpsertResult sr: srList) {
                if (!sr.isSuccess()) {
                    for (Database.Error err: sr.getErrors()) {
                        throw new DMLException(err.getMessage());
                    }
                }
            }
        }
    } 
    
    public pageReference saveAsDraft(){
        //validate();
        PrimeDieValidation();
        if(!success){
            return null;
        }
        else{
            try{
                if(mpwResf.Category__c == 'Fab'){
                    mpwResf.Sub_Category__c = mpwtm.Geometry__c;
                }
                //04072016 - Modified by Poulami Starts.
                if(mpwResf.Category__c == 'DE' || mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || mpwResf.Category__c == 'ASIC R&D' || mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
                    mpwResf.Usage__c = 'Required';
                }
                //04072016 - Modified by Poulami Ends.
                if(mpwResf.Category__c == 'TD' && mpwResf.Usage__c == 'Opportunistic'){
                    mpwResf.PA_Code__c = 'For Opportunistic Usage';
                }
                mpwResf.MPW_Train_Name__c = mpwtm.Id;
                if(deviceId != null){
                    mpwResf.Device__c = deviceId;
                }
                if(this.copySearchNumber != null) {
                    this.mpwResf.MPW_External_ID__c = null;
                    this.mpwResf.Id = null;
                    this.mpwResf.Reason_to_Void__c = '';
                    this.mpwResf.OwnerId = UserInfo.getUserID();
                }
                if(mpwResf.Id == null) {
                    mpwResf.Form_Status__c  = 'Draft';
                    this.mpwResf.Name = retreiveFormName();
                }
                if(this.mpwResf.Category__c != 'Customer' && isExternalUser == false){
                    this.mpwResf.Customer_Company_Name__c = this.mpwResf.Account_Internal__c;
                    //Added by Shyam Nair on 11/2/2015
                    this.mpwResf.FE_Email__c = null;
                    this.mpwResf.FE_Name__c = null;
                    this.mpwResf.AM_Email__c = null;
                    this.mpwResf.AM_Name__c = null;
                    this.mpwResf.CSR_Email__c = null;
                    this.mpwResf.CSR_Name__c = null;
                    //End
                }
                upsert mpwResf;
                retreiveApprovers();
                success = true;
                if(!mpwtmawList.isEmpty()){
                    //Kanishk: Make list to avoid DML under the loop
                    List < MPW_Process_Information_Question__c > lstMpwiqUpsert = new List < MPW_Process_Information_Question__c > ();
                    List < MPW_SRAM_Question__c > lstmpwSRAMQuesUpsert = new List < MPW_SRAM_Question__c > ();
                    
                    for(TechModuleAnswersWrapper m: mpwtmawList){
                        m.mpwiq.Answer__c = m.answer;
                        m.mpwiq.MPW_Maintenance_Details__c = m.mpwtmdId;
                        m.mpwiq.MPW_Reservation_Form__c = mpwResf.Id;
                        if(this.copySearchNumber != null) {
                            m.mpwiq.Id = null;
                        }
                        /*if(m.mpwiq.Id == null){
                            insert m.mpwiq;
                        }
                        else{
                            update m.mpwiq;
                        }*/
                        lstMpwiqUpsert.add(m.mpwiq);
                        
                        if(m.mpwiq != null && m.question.contains('Do you need SRAM')){
                            for(SRAMQuestionWrapper s: m.sqwList){
                                if(s.selected){
                                    s.mpwSRAMQues.MPW_Process_Information_Question__c = this.mpwResf.Id;
                                    if(this.copySearchNumber != null) {
                                        s.mpwSRAMQues.Id = null;
                                    }
                                    /*if(s.mpwSRAMQues.Id == null){
                                        insert s.mpwSRAMQues;
                                    }       
                                    else{
                                        update s.mpwSRAMQues;
                                    }*/
                                    lstmpwSRAMQuesUpsert.add(s.mpwSRAMQues);
                                }
                            }
                        }
                    }
                    
                    if (lstMpwiqUpsert != null && lstMpwiqUpsert.size() > 0) {
                        performDMLOperation(lstMpwiqUpsert, true);
                    }

                    if (lstmpwSRAMQuesUpsert != null && lstmpwSRAMQuesUpsert.size() > 0) {
                        performDMLOperation(lstmpwSRAMQuesUpsert, true);
                    }
                    success = true;
                }
                MPW_Reservation__c testRes = [select Name from MPW_Reservation__c where Id =: this.mpwResf.Id];
                this.mpwResf.Prime_Die_Name__c = '';
                Set<Id> attachIDList = new Set<Id>();
                
                List<MPW_Prime_Die__c> tempPrimeDieList = new List<MPW_Prime_Die__c>();
                if(!mpwPrimeDieList.isEmpty()){
                    for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                        MPW_Prime_Die__c p = new MPW_Prime_Die__c();
                        m.mpwPrimeDie.MPW_Form__c = mpwResf.Id;
                        
                        //Kanishk: If die qty is zero then backgrind should be blank;
                         if(m.mpwPrimeDie.Delivery_Qty_Die_Form__c == '0'){
                                m.mpwPrimeDie.Backgrind__c ='No Backgrind';
                         }
                         
                        if(m.mpwPrimeDie.Corner_Split__c == 'No'){
                            m.mpwPrimeDie.POR__c = '0';
                            m.mpwPrimeDie.SS__c = '0';
                            m.mpwPrimeDie.SF__c = '0';
                            m.mpwPrimeDie.FF__c = '0';
                            m.mpwPrimeDie.FS__c = '0';
                            //01042016 - Added by Poulami Starts
                            m.mpwPrimeDie.Wafer_POR__c = '0';
                            m.mpwPrimeDie.Wafer_SS__c = '0';
                            m.mpwPrimeDie.Wafer_SF__c = '0';
                            m.mpwPrimeDie.Wafer_FF__c = '0';
                            m.mpwPrimeDie.Wafer_FS__c = '0';
                            //01042016 - Added by Poulami Ends
                            if(m.mpwPrimeDie.CornerSplitAttached__c){
                                attachIDList.add(m.mpwPrimeDie.CornerSplitAttachedId__c);
                                m.mpwPrimeDie.CornerSplitAttached__c = false;
                                m.mpwPrimeDie.CornerSplitAttachedId__c = '';
                            }
                        }
                        //01042016 - Added by Poulami Starts
                        if(m.mpwPrimeDie.Corner_Split__c == 'Yes' && m.mpwPrimeDie.Delivery_Qty_Die_Form__c == '0'){
                            m.mpwPrimeDie.POR__c = '0';
                            m.mpwPrimeDie.SS__c = '0';
                            m.mpwPrimeDie.SF__c = '0';
                            m.mpwPrimeDie.FF__c = '0';
                            m.mpwPrimeDie.FS__c = '0';
                        }
                        if(m.mpwPrimeDie.Corner_Split__c == 'Yes' && m.mpwPrimeDie.Delivery_Qty_Wafer_Form__c == '0'){
                            m.mpwPrimeDie.Wafer_POR__c = '0';
                            m.mpwPrimeDie.Wafer_SS__c = '0';
                            m.mpwPrimeDie.Wafer_SF__c = '0';
                            m.mpwPrimeDie.Wafer_FF__c = '0';
                            m.mpwPrimeDie.Wafer_FS__c = '0';
                        }
                        //01042016 - Added by Poulami Ends
                        String extrawaferId = '';
                        extrawaferId += testRes.Name;
                        extrawaferId += '-00';
                        m.mpwPrimeDie.EXTRA_WAFER_ID__c = extrawaferId;
                        if(m.mpwPrimeDie.GMPL_Project_Name_Id__c != ''){
                            m.mpwPrimeDie.GMPL_Project_Name__c = m.mpwPrimeDie.GMPL_Project_Name_Id__c;
                        }
                        if(this.copySearchNumber != null) {
                            m.mpwPrimeDie.MPW_External_ID__c = null;
                            m.mpwPrimeDie.RETICLE_SPACE_A_Void_c__c = 0;
                            m.mpwPrimeDie.Extra_Die_B_Void__c = 0;
                            m.mpwPrimeDie.ERP_Status__c = null;
                            m.mpwPrimeDie.ERP_Status_2__c = null;
                            m.mpwPrimeDie.Operation_Type__c = null;
                            m.mpwPrimeDie.Id = null;
                            m.mpwPrimeDie.CornerSplitAttached__c = false;
                            m.mpwPrimeDie.CornerSplitAttachedId__c = null;
                            m.mpwPrimeDie.SubDevicesExtractionAttached__c = false;
                            m.mpwPrimeDie.SubDevicesExtractionAttachedId__c = null;
                            m.mpwPrimeDie.TurnkeyAttached__c = false;
                            m.mpwPrimeDie.TurnkeyAttachedId__c = null;
                        }
                        
                        Integer questionCount = 1;
                        Integer processCount = 1;
                        Integer SRAMCount = 1;                        
                        String questionAPIName;
                        String answerAPIName;
                        
                        for(TechModuleAnswersWrapper t: this.mpwtmawList){
                            if(UtilsString.isNotBlank(t.mpwiq.answer__c)){
                                if(processCount <= 5){
                                    questionAPIName = 'question_' + processCount +'__c';
                                    answerAPIName = 'answer_' + processCount +'__c';
                                    processCount++;
                                } else {
                                    questionAPIName = 'SRAM_Question_' + SRAMCount +'__c';
                                    answerAPIName = 'SRAM_Answer_' + SRAMCount +'__c';
                                    SRAMCount++;
                                }
                                
                                m.mpwPrimeDie.put(questionAPIName,t.question.replace(':',''));
                                
                                if(t.question.contains('SRAM')){
                                    if(t.sqwList.size() > 0){
                                        String ans = t.mpwiq.answer__c + '\n';
                                        for(SRAMQuestionWrapper s: t.sqwList){
                                            if(UtilsString.isNotBlank(s.mpwSRAMQues.answer__c)){
                                                ans += s.name +';' + s.mpwSRAMQues.answer__c +'\n';
                                            }
                                        }
                                        m.mpwPrimeDie.put(answerAPIName,ans);
                                    }   
                                } else {
                                    m.mpwPrimeDie.put(answerAPIName,t.mpwiq.answer__c);
                                }

                                //max 15 questions to be stored
                                if(questionCount == 15){
                                    break;
                                }
                                questionCount++;            
                            }
                        }

                        p = m.mpwPrimeDie;
                        tempPrimeDieList.add(p);
                        this.mpwResf.Prime_Die_Name__c += p.Prime_Die_Name__c + ',';
                    }
                    
                }
                if(attachIDList.size()>0){
                    delete [select Id from Attachment where ParentId IN: attachIDList];
                }
                if(!tempPrimeDieList.isEmpty() && (this.mpwResf.Form_Status__c == 'Draft' || this.mpwResf.Form_Status__c == 'Rejected By FAE'  || this.mpwResf.Form_Status__c == 'Accepted by MPW Tapeout')){
                    upsert tempPrimeDieList;       
                }  
                
                this.mpwResf.Prime_Die_Name__c = this.mpwResf.Prime_Die_Name__c.removeEnd(',');
                update this.mpwResf;
                
                if(turnkeyWrap.selectedmpwpd != ''){
                    List<String> selectedpdList = turnkeyWrap.selectedmpwpd.split(',');
                    if(!selectedpdList.isEmpty()){
                        for(String pd: selectedpdList){
                            pd = pd.replace('[','');
                            pd = pd.replace(']','');
                            pd = pd.replace(' ','');
                            if(pd != ''){
                                MPW_Turnkey__c mpwturnkey = new MPW_Turnkey__c();
                                mpwturnkey.MPW_Prime_Die__c = pd;
                                mpwturnkey.MPW_Reservation__c = this.mpwResf.Id;
                                mpwturnkey.Actual_Wafer_Skeleton_Return_Date__c = turnkeyWrap.turnkey.Actual_Wafer_Skeleton_Return_Date__c;
                                mpwturnkey.AWB__c = turnkeyWrap.turnkey.AWB__c;
                                mpwturnkey.Ship_Date__c = turnkeyWrap.turnkey.Ship_Date__c;
                                mpwturnkey.Wafer_Ship_Date__c = turnkeyWrap.turnkey.Wafer_Ship_Date__c;
                                //03182016 - Added by Poulami Starts.
                                mpwturnkey.Bare_Die_Forecast_Ship_Date__c = turnkeyWrap.turnkey.Bare_Die_Forecast_Ship_Date__c;
                                //03182016 - Added by Poulami Ends.
                                mpwturnkey.Expected_Wafer_Skeleton_Return_Date__c = turnkeyWrap.turnkey.Expected_Wafer_Skeleton_Return_Date__c;
                                mpwturnkeyList.add(mpwturnkey);
                            }
                        }
                        if(!mpwturnkeyList.isEmpty()){
                            upsert mpwturnkeyList;
                        }
                    }
                }
                
                pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+mpwResf.Id);
                p.getParameters().put('mode','View');
                p.getParameters().put('intpoint',this.initPoint);
                p.getParameters().put('Search', '1');
                p.setRedirect(true);
                return p;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()+'.'+e.getLineNumber()));
                //showError = true;
                return null;
            }
        }
        
    }
    public void retrieveMPWSchedule(){
        this.mpwtmawList = new List<TechModuleAnswersWrapper>();
        if(this.copySearchNumber != null) {
            mpwResf.Process_Type__c = null;
        }
        String queryFields = util.getAllFields('MPW_Train_Maintenance__c');
        String query = 'select '+queryFields+' from MPW_Train_Maintenance__c where Id =\''+mpwResf.MPW_Train_Name__c+'\'';
        this.mpwtm = database.query(query);
        
        //Added by Anil Kumar : 00070564 - 0.15um Sub-Device Extraction supportability : April 18, 2017
        if(this.mpwtm.Geometry__c != null && setSubDeviceExtractionGeometry.contains(this.mpwtm.Geometry__c.toLowerCase())){
            showSubDeviceExtraction = true;
        }
    }
    
    public pageReference back(){
        pageReference p;
        if(this.search == null) {
            if(mpwResf.Id != null) {
                p = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwResf.Id);
                p.getParameters().put('mode','View');
                p.getParameters().put('Search','1');
                 p.getParameters().put('query',strUserSearchFilter);
            }
            else if(mpwResf.Id == null && initPoint == 'mpwtrain'){
                p = new pageReference('/'+this.mpwtm.Id);
            }
            else if(initPoint == 'viewmpwtrain'){
                String tabId = MPW_Settings__c.getInstance('View_MPW_Schedule_Tab_Id').Value__c;
                p = new pageReference('/apex/MPWTrainScheduleTabVF?sfdc.tabName='+tabId);
            }
            else if(mpwResf.Id == null && initPoint == 'device'){
                p = new pageReference('/'+this.deviceId);
            }
            else if(initPoint == 'mydevices' && this.returnURL != null){
                p = new pageReference(this.returnURL);
            }
        
        } else{
            p = new pageReference('/apex/MPWSearchReservationFormVF');
            p.getParameters().put('query',strUserSearchFilter);
        }
        p.setRedirect(true);
        return p;
    }
    
    public pageReference compare() {
        pageReference p = new pageReference('/apex/MPWCompareFormsTabVF');
        //.getParameters().put('mode','Edit');
        p.getParameters().put('Form1',this.mpwResf.Name);
        p.setRedirect(true);
        return p;
    }
    
    public pageReference editPage(){
        pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwResf.Id);
        p.getParameters().put('mode','Edit');
        p.getParameters().put('intpoint',this.initPoint);
        p.setRedirect(true);
        return p;
    }
    
    /** Start : Added by Anil : Adding Change Request Button on Page **/
    public pageReference changeRequest(){
        pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwResf.Id);
        p.getParameters().put('intpoint','mpwtrain');
        p.getParameters().put('mode','View');
        p.getParameters().put('ChangeRequest','1');
        p.getParameters().put('Search','1');
        p.getParameters().put('query',strUserSearchFilter);
        p.setRedirect(true);
        return p;
    }
    /** End : Added by Anil : Adding Change Request Button on Page **/
    
     /** Start : Added by Kanishk : Adding Void Button on Page **/
    public pageReference voidformAction(){
       
        /*Map<String,string> mapParam=ApexPages.CurrentPage().getParameters();
        for(string strprmKey: mapParam.keyset()){
            p.getParameters().put(strprmKey,mapParam.get(strprmKey));
        }*/
       
        pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwResf.Id);
        p.getParameters().put('intpoint','mpwtrain');
        p.getParameters().put('mode','View');
        p.getParameters().put('voidtheform','true');
        p.getParameters().put('Search','1');
        p.setRedirect(true);
        return p;
      
    }
    /** End : Added by Kanishk : Adding Void Button on Page **/
    
    public void retriveMetalStackValues(){
        String cat = this.mpwResf.Category__c;
        List<MPW_Metal_Stack_Configuration__c> mpwmscList = new List<MPW_Metal_Stack_Configuration__c>();
        String soql = 'select Name from MPW_Metal_Stack_Configuration__c where Active__c = true and Category__c = \''+cat+'\' and Geometry__c = \''+this.mpwtm.Geometry__c+'\'';
        //06062016 - Modified code for case 00056083
        //if(this.mpwtm.Geometry__c == '55/65nm'){
        if(this.mpwResf.Process_Type__c != null){
            soql += ' and Process_Type__c = \''+mpwResf.Process_Type__c+'\'';
        }
        soql += ' order by Name asc';
        mpwmscList  = database.query(soql);
        for(mpwPrimeDieWrapperClass m: this.mpwPrimeDieList){
            m.metalStackList = new List<SelectOption>();
            m.metalStackList.add(new SelectOption('None','--None--'));
            for(MPW_Metal_Stack_Configuration__c metal: mpwmscList){
                m.metalStackList.add(new SelectOption(metal.Name, metal.Name));
            }
        }
    }
    
    public List<SelectOption> retriveMetalStackValuesOption(){
        String cat = this.mpwResf.Category__c;
        List<MPW_Metal_Stack_Configuration__c> mpwmscList = new List<MPW_Metal_Stack_Configuration__c>();
        String soql = 'select Name from MPW_Metal_Stack_Configuration__c where Active__c = true and Category__c = \''+cat+'\' and Geometry__c = \''+this.mpwtm.Geometry__c+'\'';
        //06062016 - Modified code for case 00056083
        //if(this.mpwtm.Geometry__c == '55/65nm'){
        if(this.mpwResf.Process_Type__c != null){
            soql += ' and Process_Type__c = \''+mpwResf.Process_Type__c+'\'';
        }
        soql += ' order by Name asc';
        mpwmscList  = database.query(soql);
        
         List<SelectOption> metalStackList =new List<SelectOption>();
         metalStackList = new List<SelectOption>();
         metalStackList.add(new SelectOption('None','--None--'));
            for(MPW_Metal_Stack_Configuration__c metal: mpwmscList){
                metalStackList.add(new SelectOption(metal.Name, metal.Name));
            }
      
      return  metalStackList;
    }
    
    public void onCategoryChange(){
        System.debug('Value Change:'+this.mpwResf.Category__c);
        //this.mpwResf.PA_Code__c = null;
        
        // Added By Abhita As a Category Change Issue
        if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'Customer' || this.mpwResf.Category__c == 'DE') {
            if(this.mpwResf.PA_Code__c != null) {
                this.mpwResf.PA_Code__c = null;
            }           
            for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                if(m.mpwPrimeDie.GMPL_Project_Name__c != null) {                
                    m.mpwPrimeDie.GMPL_Project_Name__c = null;
                    m.mpwPrimeDie.GMPL_Project_Name_Text__c = null;
                    m.mpwPrimeDie.GMPL_Project_Name_Id__c = null;
                }
            }
        }
        if(this.mpwResf.Category__c == 'TD' || this.mpwResf.Category__c == 'Customer') {
            if(this.mpwResf.Sub_Category__c != null) {
                this.mpwResf.Sub_Category__c = null;
            }
        }
        if(this.mpwResf.Category__c == 'Customer') {
            if(this.mpwResf.Usage__c == null) {
                this.mpwResf.Usage__c = null;
            }
        }
        if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'TD') {
            for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                if(m.mpwPrimeDie.Delivery_Qty_Die_Form__c != null) {
                    m.mpwPrimeDie.Delivery_Qty_Die_Form__c = '0';
                }
                if(m.mpwPrimeDie.Device_Type__c != null) {
                    m.mpwPrimeDie.Device_Type__c = null;
                }
                if(m.mpwPrimeDie.Metal_Stack__c != null) {
                    m.mpwPrimeDie.Metal_Stack__c = null;
                }
                if(m.mpwPrimeDie.Corner_Split__c != null) {
                    m.mpwPrimeDie.Corner_Split__c = 'No';
                }
                if(m.mpwPrimeDie.CornerSplitAttached__c != null) {
                    m.mpwPrimeDie.CornerSplitAttached__c = false;
                }
                if(m.mpwPrimeDie.CornerSplitAttachedId__c != null) {
                    m.mpwPrimeDie.CornerSplitAttachedId__c = null;
                }
                if(m.mpwPrimeDie.POR__c != null) {
                    m.mpwPrimeDie.POR__c = '0';
                }
                if(m.mpwPrimeDie.FF__c != null) {
                    m.mpwPrimeDie.FF__c = '0';
                }
                if(m.mpwPrimeDie.FS__c != null) {
                    m.mpwPrimeDie.FS__c = '0';
                }
                if(m.mpwPrimeDie.SF__c != null) {
                    m.mpwPrimeDie.SF__c = '0';
                }
                if(m.mpwPrimeDie.SS__c != null) {
                    m.mpwPrimeDie.SS__c = '0';
                }
                //01042016 - Added by Poulami Starts
                if(m.mpwPrimeDie.Wafer_POR__c != null) {
                    m.mpwPrimeDie.Wafer_POR__c = '0';
                }
                if(m.mpwPrimeDie.Wafer_FF__c != null) {
                    m.mpwPrimeDie.Wafer_FF__c = '0';
                }
                if(m.mpwPrimeDie.Wafer_FS__c != null) {
                    m.mpwPrimeDie.Wafer_FS__c = '0';
                }
                if(m.mpwPrimeDie.Wafer_SF__c != null) {
                    m.mpwPrimeDie.Wafer_SF__c = '0';
                }
                if(m.mpwPrimeDie.Wafer_SS__c != null) {
                    m.mpwPrimeDie.Wafer_SS__c = '0';
                }
                //01042016 - Added by Poulami Ends
                if(m.mpwPrimeDie.Backgrind__c != null) {
                    m.mpwPrimeDie.Backgrind__c = null;
                }
                if(m.mpwPrimeDie.ShortLoop_Wafer__c != null) {
                    m.mpwPrimeDie.ShortLoop_Wafer__c = null;
                }
                if(m.mpwPrimeDie.Expedite_In_DIE_Form__c != null) {
                    m.mpwPrimeDie.Expedite_In_DIE_Form__c = null;
                }
                if(m.mpwPrimeDie.TurnkeyAttachedId__c != null) {
                    m.mpwPrimeDie.TurnkeyAttachedId__c = null;
                }
                if(m.mpwPrimeDie.Turnkey_Service__c != null) {
                    m.mpwPrimeDie.Turnkey_Service__c = 'No';
                }
                if(m.mpwPrimeDie.TurnkeyAttached__c != null) {
                    m.mpwPrimeDie.TurnkeyAttached__c = false;
                }
                if(m.mpwPrimeDie.Expedite_In_WAFER_Form__c != null) {
                    m.mpwPrimeDie.Expedite_In_WAFER_Form__c = null;
                }                
                if(m.mpwPrimeDie.Address1_Quantity_Delivery_In_DIE_Form__c != null) {
                    m.mpwPrimeDie.Address1_Quantity_Delivery_In_DIE_Form__c = null;
                }
                if(m.mpwPrimeDie.Address1_Quantity_Delivery_In_WAFER_Form__c != null) {
                    m.mpwPrimeDie.Address1_Quantity_Delivery_In_WAFER_Form__c = null;
                }
                if(m.mpwPrimeDie.Address1_ShortLoop_Wafer__c != null) {
                    m.mpwPrimeDie.Address1_ShortLoop_Wafer__c = null;
                }
                if(m.mpwPrimeDie.Address2_Quantity_Delivery_In_DIE_Form__c != null) {
                    m.mpwPrimeDie.Address2_Quantity_Delivery_In_DIE_Form__c = null;
                }
                if(m.mpwPrimeDie.Address2_Quantity_Delivery_In_WAFER_Form__c != null) {
                    m.mpwPrimeDie.Address2_Quantity_Delivery_In_WAFER_Form__c = null;
                }
                if(m.mpwPrimeDie.Address2_ShortLoop_Wafer__c != null) {
                    m.mpwPrimeDie.Address2_ShortLoop_Wafer__c = null;
                }
                if(m.mpwPrimeDie.Address3_Quantity_Delivery_In_DIE_Form__c != null) {
                    m.mpwPrimeDie.Address3_Quantity_Delivery_In_DIE_Form__c = null;
                }
                if(m.mpwPrimeDie.Address3_Quantity_Delivery_In_WAFER_Form__c != null) {
                    m.mpwPrimeDie.Address3_Quantity_Delivery_In_WAFER_Form__c = null;
                }
                if(m.mpwPrimeDie.Address3_ShortLoop_Wafer__c != null) {
                    m.mpwPrimeDie.Address3_ShortLoop_Wafer__c = null;
                }
            }
            if(this.mpwResf.Company_Name__c != null) {
                this.mpwResf.Company_Name__c = null;
            }
            if(this.mpwResf.Company_Name2__c != null) {
                this.mpwResf.Company_Name2__c = null;
            }
            if(this.mpwResf.Company_Name3__c != null) {
                this.mpwResf.Company_Name3__c = null;
            }
            if(this.mpwResf.Address__c != null) {
                this.mpwResf.Address__c = null;
            }
            if(this.mpwResf.Address2__c != null) {
                this.mpwResf.Address2__c = null;
            }
            if(this.mpwResf.Address3__c != null) {
                this.mpwResf.Address3__c = null;
            }
            if(this.mpwResf.Postal_Code__c != null) {
                this.mpwResf.Postal_Code__c = null;
            }
            if(this.mpwResf.Postal_Code2__c != null) {
                this.mpwResf.Postal_Code2__c = null;
            }
            if(this.mpwResf.Postal_Code3__c != null) {
                this.mpwResf.Postal_Code3__c = null;
            }
            if(this.mpwResf.Contact_Person__c != null) {
                this.mpwResf.Contact_Person__c = null;
            }
            if(this.mpwResf.Contact_Person2__c != null) {
                this.mpwResf.Contact_Person2__c = null;
            }
            if(this.mpwResf.Contact_Person3__c != null) {
                this.mpwResf.Contact_Person3__c = null;
            }
            if(this.mpwResf.Phone__c != null) {
                this.mpwResf.Phone__c = null;
            }
            if(this.mpwResf.Phone2__c != null) {
                this.mpwResf.Phone2__c = null;
            }
            if(this.mpwResf.Phone3__c != null) {
                this.mpwResf.Phone3__c = null;
            }
        }
        //04072016 - Modified by Poulami Starts.
        if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'TD' || this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'DE' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos') {
        //04072016 - Modified by Poulami Ends.    
            if(this.mpwResf.Forwarder_Name1__c != null) {
                this.mpwResf.Forwarder_Name1__c = null;
            }
            if(this.mpwResf.Forwarder_Name2__c != null) {
                this.mpwResf.Forwarder_Name2__c = null;
            }
            if(this.mpwResf.Forwarder_Name3__c != null) {
                this.mpwResf.Forwarder_Name3__c = null;
            }
            if(this.mpwResf.Registered_Company_Name1__c != null) {
                this.mpwResf.Registered_Company_Name1__c = null;
            }
            if(this.mpwResf.Registered_Company_Name2__c != null) {
                this.mpwResf.Registered_Company_Name2__c = null;
            }
            if(this.mpwResf.Registered_Company_Name3__c != null) {
                this.mpwResf.Registered_Company_Name3__c = null;
            }
            if(this.mpwResf.Forwarder_Account1__c != null) {
                this.mpwResf.Forwarder_Account1__c = null;
            }
            if(this.mpwResf.Forwarder_Account2__c != null) {
                this.mpwResf.Forwarder_Account2__c = null;
            }
            if(this.mpwResf.Forwarder_Account3__c != null) {
                this.mpwResf.Forwarder_Account3__c = null;
            }
            if(this.mpwResf.Forwarder_Account_Type1__c != null) {
                this.mpwResf.Forwarder_Account_Type1__c = null;
            }
            if(this.mpwResf.Forwarder_Account_Type2__c != null) {
                this.mpwResf.Forwarder_Account_Type2__c = null;
            }
            if(this.mpwResf.Forwarder_Account_Type3__c != null) {
                this.mpwResf.Forwarder_Account_Type3__c = null;
            }
            if(this.mpwResf.Customer_Name__c != null) {
                this.mpwResf.Customer_Name__c = null;
            }
            if(this.mpwResf.Customer_Phone__c != null) {
                this.mpwResf.Customer_Phone__c = null;
            }
            if(this.mpwResf.Customer_Email__c != null) {
                this.mpwResf.Customer_Email__c = null;
            }
        }
        if(this.mpwResf.Category__c != 'FAB' || this.mpwResf.Category__c != 'TD') {
            //Modified by Anil : 00070564 : 0.15um Sub-Device Extraction supportability : April 18, 2017
            if(this.mpwtm.Geometry__c == '0.15um' || this.mpwtm.Geometry__c == '0.18um' || this.mpwtm.Geometry__c == '0.35um' || this.mpwtm.Geometry__c == '0.11/0.13um') {
                for(mpwPrimeDieWrapperClass m: mpwPrimeDieList){
                    if(m.mpwPrimeDie.Sub_Devices_Extraction__c != null) {
                        m.mpwPrimeDie.Sub_Devices_Extraction__c = '0';
                    }
                    if(m.mpwPrimeDie.SubDevicesExtractionAttached__c != null) {
                        m.mpwPrimeDie.SubDevicesExtractionAttached__c = false;
                    }
                    if(m.mpwPrimeDie.SubDevicesExtractionAttachedId__c != null) {
                        m.mpwPrimeDie.SubDevicesExtractionAttachedId__c = null;
                    }
                }
            }
        }
        retreiveCustomerInformation();
        retrieveSubCategoryAndUsage();
        //04072016 - Modified by Poulami Starts.
        if(this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'Customer' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
            retriveMetalStackValues();
        }
        //04072016 - Modified by Poulami Ends.
    }
    
    public PageReference submitForApproval(){
        System.debug('_________VALEUS________');
       
        if(this.mpwResf.Id != null){
            validate();
            integer flag=0;
            if(!success){
                return null;
            }else{
                for(MPW_Prime_Die__c mpwpd: this.mpwpdList){ 
                    if((mpwpd.Sub_Devices_Extraction__c != '0' && mpwpd.SubDevicesExtractionAttached__c == false) || (mpwpd.Turnkey_Service__c == 'Yes' && mpwpd.TurnkeyAttached__c == false)){
                        flag = 0;
                        break;
                    }
                    else{
                        flag++;
                    }
                }
            }
            if(flag > 0){
                retreiveApprovers();
                update this.mpwResf;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting Request for Approval.');
                req.setObjectId(this.mpwResf.Id);
                Approval.ProcessResult result = Approval.process(req);
                
                pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+mpwResf.Id);
                p.getParameters().put('mode','View');
                p.getParameters().put('intpoint',this.initPoint);
                p.setRedirect(true);
                            
                return p;
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Attachment is required '+
                'in the prime die if Corner Split or Turnkey or Sub-Device Extraction are set to Yes. You can click on the '+
                '*Attach* link in the prime die record to add the attachment'+ 
                 '.'));
                return null;
            }
        }
        else{
            return null;
        }
    
    }
  
  // 23-Jun Update by Venkat for MPW-PP145 Increase the total number of FAE Approvers. Current limit is 10. Increased the Limit to 15                 
    public void retreiveApprovers(){
        MPW_Train_Maintenance__c train = new MPW_Train_Maintenance__c();
        train = [select Id, Name, Fab__c, Train_Type__c, Geometry__c, OwnerId from MPW_Train_Maintenance__c where Id =: this.mpwResf.MPW_Train_Name__c];
        String queryFields = util.getAllFields('MPW_Approval_Matrix__c');
        String soql = 'select '+queryFields+' from MPW_Approval_Matrix__c';
        MPW_Approval_Matrix__c mpwm = new MPW_Approval_Matrix__c();
        //04072016 - Modified by Poulami Starts.
        if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'TD' || this.mpwResf.Category__c == 'DE' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
        //04072016 - Modified by Poulami Ends.    
            if(train.Train_Type__c == 'GlobalShuttle'){
                if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'TD'){
                    String fab = train.Fab__c;
                    soql += ' where Category__c = \''+this.mpwResf.Category__c+'\' and Fab__c = \''+fab+'\' and Geometry__c = \''+train.Geometry__c+'\'';
                }
                //04072016 - Modified by Poulami Starts.
                else if(this.mpwResf.Category__c == 'DE' || this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
                //04072016 - Modified by Poulami Ends.    
                    soql += ' where Category__c = \''+this.mpwResf.Category__c+'\' and Sub_Category__c = \''+this.mpwResf.Sub_Category__c+'\'';
                }else if(this.mpwResf.Category__c == 'Lighting'){
                         soql += ' where Category__c = \''+this.mpwResf.Category__c+'\'';
                }
                
                //Kanishk :may be one category have more than one record. Needs to add limit 1
                if(this.mpwResf.Category__c == 'ASIC R&D'){
                  soql +=' limit 1';
                }
                
                mpwm = database.query(soql);
                if(mpwm.Id != null){
                    if(this.mpwResf.Usage__c == 'Required'){
                        this.mpwResf.Step_1_Approver_1__c = mpwm.Step_1_Approver_1__c;
                        this.mpwResf.Step_1_Approver_2__c = mpwm.Step_1_Approver_2__c; 
                        this.mpwResf.Internal_Budget_Owner_1__c = mpwm.Step_1_Approver_1__c;
                        this.mpwResf.Internal_Budget_Owner_2__c = mpwm.Step_1_Approver_2__c;  
                    }
                    else if(this.mpwResf.Usage__c == 'Opportunistic'){
                        this.mpwResf.Step_1_Approver_1__c = mpwm.Step_1_Approver_3__c;
                        this.mpwResf.Step_1_Approver_2__c = mpwm.Step_1_Approver_3__c;
                        this.mpwResf.Business_Representative__c = mpwm.Step_1_Approver_3__c;
                    }
                }
            }
            else if(train.Train_Type__c == 'CustomizedShuttle'){
                this.mpwResf.Step_1_Approver_1__c = train.OwnerId;
                this.mpwResf.Program_Manager__c = train.OwnerId;
            }
        }
        else if(this.mpwResf.Category__c == 'Customer'){
            if(this.mpwResf.Customer_Company_Name__c != null){
                List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();
               
               integer proxylimit=(Environment_Variable__c.getInstance('AccountProxy'))!=null?Integer.valueOf(Environment_Variable__c.getInstance('AccountProxy').value__c):10;
               proxylimit=proxylimit>25?25:proxylimit;//Kanishk: we can't set more than 25 approver 
               
               
                proxyList = [SELECT User__c, Team_Role__c from Account_Team_Proxy__c 
                                WHERE User__r.isActive = true and Account__c =: this.mpwResf.Customer_Company_Name__c
                                  AND (  Team_Role__c='Field Application Engineer' 
                                      OR Team_Role__c='Primary Field Application Engineer' 
                                      OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                      OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                ORDER BY Team_Role__c desc limit:proxylimit];
                if(!proxyList.isEmpty()){
                    //Njain 08Jun16 Sorting the ATP keeping PFAE on top
                    proxyList = Utility.getSortedFAE(proxyList);
                 
                   setApprover(proxyList,this.mpwResf,proxylimit);
                    
                  
                 
                   /* if(proxyList.size() == 1){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                    }
                    if(proxyList.size() == 2){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                    }
                    if(proxyList.size() == 3){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                    }
                    if(proxyList.size() == 4){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                    }
                    if(proxyList.size() == 5){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwResf.Step_1_Approver_5__c = proxyList[4].User__c;
                    }
                    if(proxyList.size() == 6){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwResf.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwResf.Step_1_Approver_6__c = proxyList[5].User__c;
                    }
                    if(proxyList.size() == 7){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwResf.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwResf.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwResf.Step_1_Approver_7__c = proxyList[6].User__c;
                    }
                    if(proxyList.size() == 8){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwResf.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwResf.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwResf.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwResf.Step_1_Approver_8__c = proxyList[7].User__c;
                    }
                    if(proxyList.size() == 9){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwResf.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwResf.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwResf.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwResf.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwResf.Step_1_Approver_9__c = proxyList[8].User__c;
                    }
                    if(proxyList.size() == 10){
                        this.mpwResf.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwResf.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwResf.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwResf.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwResf.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwResf.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwResf.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwResf.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwResf.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwResf.Step_1_Approver_10__c = proxyList[9].User__c;
                    }*/
                   
                }
            }
        }
    }
   
   //Kanishk: populate approvers in step approver  field
   private void setApprover(List < Account_Team_Proxy__c > proxyList, MPW_Reservation__c objRervation, integer proxylimit) {
    set<string> setObjectField=new set<string>();
    
    for(string strField:Schema.SObjectType.MPW_Reservation__c.fields.getMap().keySet()){
        setObjectField.add(strField.toUppercase());
    }
    
     for (integer ii = 0; ii < proxyList.size(); ii++) {
         string keyField = 'Step_1_Approver_' + (ii + 1) + '__c';
         if (setObjectField.contains(keyField.toUppercase())) {
             objRervation.put(keyField, proxyList[ii].User__c);
         }
     }
     if (proxyList.size()>0 && proxylimit > proxyList.size() && objRervation.Process_Type__r.Name!='28nm HPP') {
         integer startIndex = proxyList.size() + 1;
         //Step_1_Approver should not be blank . needs to populate first approver to all blank approver list
         for (integer ii = startIndex; ii <= proxylimit; ii++) {
             string keyField = 'Step_1_Approver_' + ii + '__c';
             if (setObjectField.contains(keyField.toUppercase())) {
                 objRervation.put(keyField, proxyList[0].User__c);
             }
         }

     }
 }

    
  // 23-Jun Update by Venkat ends
    
    public class mpwPrimeDieWrapperClass{
       public MPW_Prime_Die__c mpwPrimeDie{get;set;}
       public Boolean selected{get; set;}
       public String gmplProjectName{get;set;}
       public String gmplProjectId{get;set;}
       public String CornerSplitId{get;set;}
       public String TurnkeyId{get;set;}
       public String SubExtractionId{get;set;}
       public List<SelectOption> quantityDieFormList{get;set;}
       public List<SelectOption> quantityWaferFormList{get;set;}
       public List<SelectOption> backgrindList{get;set;}
       public List<SelectOption> shortLoopList{get;set;}
       public List<SelectOption> expediteDieFormList{get;set;}
       public List<SelectOption> expediteWaferFormList{get;set;}
       public List<SelectOption> deviceTypeList{get;set;}
       public List<SelectOption> drawnOrientationList{get;set;}
       public List<SelectOption> cornerSplitList{get;set;}
       public List<SelectOption> turnkeyServicesList{get;set;}
       public List<SelectOption> subDeviceExtractionList{get;set;}
       public List<SelectOption> metalStackList{get;set;}
       
       
       public mpwPrimeDieWrapperClass(){
           selected =  false;
           mpwPrimeDie = new MPW_Prime_Die__c(); 
           mpwPrimeDie.Corner_Split__c = 'No';
           mpwPrimeDie.Sub_Devices_Extraction__c = '0';
           mpwPrimeDie.Turnkey_Service__c = 'No';
           mpwPrimeDie.Delivery_Qty_Die_Form__c = '0';
           mpwPrimeDie.Delivery_Qty_Wafer_Form__c = '0';
           gmplProjectName = '';
           gmplProjectId = '';
           quantityDieFormList = new List<SelectOption>();
           quantityWaferFormList = new List<SelectOption>();
           backgrindList = new List<SelectOption>();
           shortLoopList = new List<SelectOption>();
           expediteDieFormList = new List<SelectOption>();
           expediteWaferFormList = new List<SelectOption>();
           deviceTypeList = new List<SelectOption>();
           deviceTypeList.add(new SelectOption('None','--None--'));
           drawnOrientationList = new List<SelectOption>();
           cornerSplitList = new List<SelectOption>();
           turnkeyServicesList = new List<SelectOption>();
           subDeviceExtractionList = new List<SelectOption>();
           metalStackList = new List<SelectOption>();
           metalStackList.add(new SelectOption('None','--None--'));
       }
   }
    
    public class TechModuleAnswersWrapper {
        public MPW_Process_Information_Question__c mpwiq{get;set;}
        public String question{get;set;}
        public String answer{get;set;}
        public List<SelectOption> selectOption{get;set;}
        public String mpwtmdId{get;set;}
        public List<SRAMQuestionWrapper> sqwList{get;set;}
        
        public TechModuleAnswersWrapper() {
            question = '';
            answer = '';
            mpwtmdId = '';
            selectOption = new List<SelectOption>();
            mpwiq = new MPW_Process_Information_Question__c();
            sqwList = new List<SRAMQuestionWrapper>();
        }
    }
    
    public class SRAMQuestionWrapper{
        public boolean selected{get;set;}
        public MPW_SRAM_Configuration__c mpwSRAMConfig{get;set;}
        public MPW_SRAM_Question__c mpwSRAMQues{get;set;}
        public String name{get;set;}
        
        public SRAMQuestionWrapper(){
            selected = false;
            name = '';
            mpwSRAMConfig = new MPW_SRAM_Configuration__c();
            mpwSRAMQues = new MPW_SRAM_Question__c();
        }
    }
    
    public class turnkeyWrapper{
        public MPW_Turnkey__c turnkey{get;set;}
        public List<SelectOption> mpwpdsList{get;set;}
        public String selectedmpwpd{get;set;}
        
        public turnkeyWrapper(){
            turnkey = new MPW_Turnkey__c();
            mpwpdsList = new List<SelectOption>();
            selectedmpwpd = '';
        }
    }
    
    // Change Request Functionality
    public void showChangeRequest() {
        this.isShow = true;
        //01042016 - Added by Poulami Starts
        this.isSelectedChangeReqField = false;
        //01042016 - Added by Poulami Ends
        DateTime dtCTD;
        
        if(this.mpwtm.Tapeout_Date_Customer__c != null) {
            dtCTD = datetime.newInstance(this.mpwtm.Tapeout_Date_Customer__c.Year()+1, this.mpwtm.Tapeout_Date_Customer__c.month(), this.mpwtm.Tapeout_Date_Customer__c.day())+1;
        }
        
        
        primeId = ApexPages.currentPage().getParameters().get('primeIdfield');
        primeName = ApexPages.currentPage().getParameters().get('primeNamefield');
        
        mpwPrimeDieCh = [Select Id, Expedite_In_DIE_Form__c, Expedite_In_WAFER_Form__c, Delivery_Qty_Die_Form__c, Delivery_Qty_Wafer_Form__c, Corner_Split__c, Turnkey_Service__c, Address1_Quantity_Delivery_In_DIE_Form__c
                         , FF__c, FS__c, SF__c, SS__c, POR__c, Wafer_FF__c, Wafer_FS__c, Wafer_POR__c, Wafer_SF__c, Wafer_SS__c, Address1_Quantity_Delivery_In_WAFER_Form__c, Address2_Quantity_Delivery_In_DIE_Form__c, Address2_Quantity_Delivery_In_WAFER_Form__c
                         , Address3_Quantity_Delivery_In_DIE_Form__c, Address3_Quantity_Delivery_In_WAFER_Form__c from MPW_Prime_Die__c where Id =: primeId];
            
            //01042016 - Added by Poulami Starts
            selectedChangeOption = '--None--';
            //01042016 - Added by Poulami Ends
            
            //04132016 - Added by Poulami Starts
            MPW_Geometry_Mapping__c mpwgm = new MPW_Geometry_Mapping__c();
            Boolean allowLateDieSizeChange = false;
            if(this.mpwtm.Geometry__c != 'None'){
                mpwgm = [select Id, Allow_Late_Die_Size_Change_Request__c from MPW_Geometry_Mapping__c where Name =: this.mpwtm.Geometry__c];
                if(mpwgm.Id != null){
                    if(mpwgm.Allow_Late_Die_Size_Change_Request__c == 'Yes'){
                        allowLateDieSizeChange = true;
                    }
                }
            }
            //04132016 - Added by Poulami Ends
            
            this.changeReqList = new List<SelectOption>();
            this.changeReqList.add(new SelectOption('--None--','--None--'));
            //04132016 - Added by Poulami Starts
            if(this.mpwtm.Tapeout_Date_Customer__c != null && (this.mpwtm.Tapeout_Date_Customer__c > datetime.now() || (allowLateDieSizeChange == true && date.valueof(this.mpwtm.Tapeout_Date_Customer__c).daysBetween(date.today())<7))){
                this.changeReqList.add(new SelectOption('Drawn Die Size Change','Drawn Die Size Change')); 
                //this.changeReqList.add(new SelectOption('Wafer Form Delivery','Wafer Form Delivery'));
                this.changeReqList.add(new SelectOption('Wafer Form Delivery','Quantity Change'));
            }
            //04132016 - Added by Poulami Ends
            
            if(this.mpwtm.Tapeout_Date_Customer__c != null && (datetime.now() < dtCTD)) {
                if(this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD'){
                    this.changeReqList.add(new SelectOption('Extra Dies/Wafer Re-start','Extra Dies/Wafer Re-start'));
                }
            }
            
            if(this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD' && this.mpwtm.Lot_Start_Date__c != null && this.mpwtm.Lot_Start_Date__c > datetime.now()){// Add the logic for Lot Start
                this.changeReqList.add(new SelectOption('Corner Split Change','Corner Split Change'));
                this.changeReqList.add(new SelectOption('Expedite Change','Expedite Change'));
                this.changeReqList.add(new SelectOption('Turnkey Services Change','Turnkey Services Change'));
            }
            if((this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c != null && this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c > datetime.now() && this.mpwtm.Projected_1st_Batch_Bare_Die_Ship__c != 'NA') 
                || (this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c == null && this.mpwtm.Projected_1st_Batch_Bare_Die_Ship__c != 'NA')){
                if(this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD') {
       //01272017 - Commented by Venkatesh                
         //           if(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c != '0') {
                        this.changeReqList.add(new SelectOption('Short Loop Change','Short Loop Change'));
       //01272017 - Commented by Venkatesh
           //         }
                   
                    this.changeReqList.add(new SelectOption('Backgrind Change','Backgrind Change'));
                   
                    //Modified by Anil : 00070564 : 0.15um Sub-Device Extraction supportability : April 18, 2017
                    if(this.mpwtm.Geometry__c == '0.15um' || this.mpwtm.Geometry__c == '0.18um' || this.mpwtm.Geometry__c == '0.35um' || this.mpwtm.Geometry__c == '0.11/0.13um') {
                        this.changeReqList.add(new SelectOption('Sub Devices Extraction','Sub Devices Extraction'));
                    }
                } 
            }//Kanishk:1 week after Reservation Cancelalation date
            else if((this.mpwtm.Geometry__c == '14nm' || this.mpwtm.Geometry__c == '12/14nm' || this.mpwtm.Geometry__c == '7nm')&& this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD'
                    && (allowLateDieSizeChange == true && this.mpwtm.Cancellation_Deadline__c!=null&& date.valueof(this.mpwtm.Cancellation_Deadline__c).daysBetween(date.today())<7)){
                      this.changeReqList.add(new SelectOption('Backgrind Change','Backgrind Change'));
            }
            
           
         //Kanishk: Allow Stack change request 1 week after Reservation Cancelalation date OR 3 weeks before Tapeout - Customer. Create new change request for this one also   
         if(((this.mpwtm.Tapeout_Date_Customer__c!=null && date.valueof(date.today()).daysBetween(this.mpwtm.Tapeout_Date_Customer__c.Date())>21)
             ||(this.mpwtm.Cancellation_Deadline__c!=null && allowLateDieSizeChange == true && date.valueof(this.mpwtm.Cancellation_Deadline__c).daysBetween(date.today())<7))
              &&(this.mpwtm.Geometry__c == '14nm' || this.mpwtm.Geometry__c == '12/14nm' || this.mpwtm.Geometry__c == '7nm')){
                 this.changeReqList.add(new SelectOption('Metal Stack Change','Metal Stack Change'));
         }  
             
    }
    
    public void showSelectedChangeReq() {
       //Kanishk:Metal Stack
        if(selectedChangeOption == 'Metal Stack Change') {
                mpwChangeReqWrapp.metalStackList=retriveMetalStackValuesOption();
        }
       
        if(selectedChangeOption == 'Corner Split Change') {
            //01042016 - Added by Poulami Starts
            mpwChangeReqWrapp.cornerSplitList1 = new List<SelectOption>();
            if(mpwPrimeDieCh.Corner_Split__c == 'Yes'){
                mpwChangeReqWrapp.cornerSplitList1.add(new SelectOption('No','No'));
                mpwChangeReqWrapp.cornerSplitList1.add(new SelectOption('Yes','Yes'));
                mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'No';
            } else {
                mpwChangeReqWrapp.cornerSplitList1.add(new SelectOption('Yes','Yes'));
                //mpwChangeReqWrapp.cornerSplitList1.add(new SelectOption('No','No'));
                mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';
            }           
            mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Die_Form__c = mpwPrimeDieCh.Delivery_Qty_Die_Form__c;
            mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Wafer_Form__c = mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c;
            mpwChangeReqWrapp.mpwChangeReq.POR__c = mpwPrimeDieCh.POR__c;
            mpwChangeReqWrapp.mpwChangeReq.FF__c = mpwPrimeDieCh.FF__c;
            mpwChangeReqWrapp.mpwChangeReq.SS__c = mpwPrimeDieCh.SS__c;
            mpwChangeReqWrapp.mpwChangeReq.FS__c = mpwPrimeDieCh.FS__c;
            mpwChangeReqWrapp.mpwChangeReq.SF__c = mpwPrimeDieCh.SF__c; 
            mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = mpwPrimeDieCh.Wafer_POR__c;
            mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = mpwPrimeDieCh.Wafer_FF__c;
            mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = mpwPrimeDieCh.Wafer_SS__c;
            mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = mpwPrimeDieCh.Wafer_FS__c;
            mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = mpwPrimeDieCh.Wafer_SF__c;
            //01042016 - Added by Poulami Ends
        }
        if(selectedChangeOption == 'Turnkey Services Change') {
            if(mpwPrimeDieCh.Turnkey_Service__c == 'Yes'){
                mpwChangeReqWrapp.mpwChangeReq.Turnkey_Service__c = 'No';
            } else {
                mpwChangeReqWrapp.mpwChangeReq.Turnkey_Service__c = 'Yes';
            }
        }
        if(selectedChangeOption == 'Wafer Form Delivery') {
            if(mpwPrimeDieCh.Address1_Quantity_Delivery_In_DIE_Form__c != null){
                mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = mpwPrimeDieCh.Address1_Quantity_Delivery_In_DIE_Form__c;
            } 
            if(mpwPrimeDieCh.Address1_Quantity_Delivery_In_WAFER_Form__c != null){
                mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = mpwPrimeDieCh.Address1_Quantity_Delivery_In_WAFER_Form__c;
            }
            if(mpwPrimeDieCh.Address2_Quantity_Delivery_In_DIE_Form__c != null){
                mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c = mpwPrimeDieCh.Address2_Quantity_Delivery_In_DIE_Form__c;
            }
            if(mpwPrimeDieCh.Address2_Quantity_Delivery_In_WAFER_Form__c != null){
                mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c = mpwPrimeDieCh.Address2_Quantity_Delivery_In_WAFER_Form__c;
            }
            if(mpwPrimeDieCh.Address3_Quantity_Delivery_In_DIE_Form__c != null){
                mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c = mpwPrimeDieCh.Address3_Quantity_Delivery_In_DIE_Form__c;
            }
            if(mpwPrimeDieCh.Address3_Quantity_Delivery_In_WAFER_Form__c != null){
                mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c = mpwPrimeDieCh.Address3_Quantity_Delivery_In_WAFER_Form__c;
            }
        }
        if(selectedChangeOption == 'Expedite Change'){
            mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c = mpwPrimeDieCh.Expedite_In_DIE_Form__c;
            mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c = mpwPrimeDieCh.Expedite_In_WAFER_Form__c;
        }
        this.isSelectedChangeReqField = true;        
     }
    
    // Wrapper Class for Change Request Object
    public class mpwChangeRequestWrapperClass{
       public MPW_Change_Request__c mpwChangeReq{get;set;}
       public String CornerSplitId{get;set;}
       public String TurnkeyId{get;set;}
       public String SubExtractionId{get;set;}
       public List<SelectOption> quantityDieFormList1{get;set;}
       public List<SelectOption> quantityWaferFormList1{get;set;}
       public List<SelectOption> backgrindList1{get;set;}
       public List<SelectOption> shortLoopList1{get;set;}
       public List<SelectOption> expediteDieFormList1{get;set;}
       public List<SelectOption> expediteWaferFormList1{get;set;}
       public List<SelectOption> cornerSplitList1{get;set;}
       public List<SelectOption> turnkeyServicesList1{get;set;}
       public List<SelectOption> subDeviceExtractionList1{get;set;}  
       
       //Kanishk
       public List<SelectOption> metalStackList{get;set;}        
       
       public mpwChangeRequestWrapperClass(){
           mpwChangeReq = new MPW_Change_Request__c();
           mpwChangeReq.Corner_Split__c = 'No';
           mpwChangeReq.Sub_Devices_Extraction__c = '0';
           mpwChangeReq.Turnkey_Service__c = 'No';
           quantityDieFormList1 = new List<SelectOption>();
           quantityWaferFormList1 = new List<SelectOption>();
           backgrindList1 = new List<SelectOption>();
           shortLoopList1 = new List<SelectOption>();
           shortLoopList1.add(new SelectOption('None','--None--'));
           expediteDieFormList1 = new List<SelectOption>();
           expediteWaferFormList1 = new List<SelectOption>();
           //01042016 - Added by Poulami Starts
           cornerSplitList1 = new List<SelectOption>();
           //01042016 - Added by Poulami Ends
           subDeviceExtractionList1 = new List<SelectOption>();
           metalStackList=new List<SelectOption>();
       }
   }
   
   // Adding picklist values to the Change Request Object
   public void retrievePickListforChangeReq(){
        if(!this.mpwkcList.isEmpty()){
            for(MPW_Keyword_Config__c m: mpwkcList) {
                if(m.Type__c == 'DieQuantity'){
                    mpwChangeReqWrapp.quantityDieFormList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'QuantityWaferForm'){
                    mpwChangeReqWrapp.quantityWaferFormList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'Backgrind'){
                    mpwChangeReqWrapp.backgrindList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'ShortLoopWafers'){
                    mpwChangeReqWrapp.shortLoopList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'Expedite'){
                    mpwChangeReqWrapp.expediteDieFormList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'ExpediteQuantityWaferForm'){
                    mpwChangeReqWrapp.expediteWaferFormList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
                if(m.Type__c == 'SubDeviceExtraction'){
                    mpwChangeReqWrapp.subDeviceExtractionList1.add(new SelectOption(m.Value__c, m.Value__c));
                }
            }
        }    
    }
    
    
    
    public List<SelectOption> getdiesOption(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Extra Dies','Extra Dies'));
        options.add(new SelectOption('Wafer Re-start','Wafer Re-start'));
        return options;
    }

    public void validateChangeReq() {
        isValidate = true;
        
        //Kanishk
         if(selectedChangeOption == 'Metal Stack Change') {
                if(this.mpwChangeReqWrapp.mpwChangeReq.Metal_Stack__c == null || this.mpwChangeReqWrapp.mpwChangeReq.Metal_Stack__c=='' ) {
                         isValidate = false;
                 this.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c.addError('Metal Stack cannot be blank.');
                }
         }
        
        if(selectedChangeOption == 'Drawn Die Size Change') {
            if(this.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c == null) {
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c.addError('Drawn Die Size Xum cannot be blank.');
            }
            if(this.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c == null){
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c.addError('Drawn Die Size Yum cannot be blank.');
            }
        }
        if(selectedChangeOption == 'Wafer Form Delivery') {
            if(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c == '0' && this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c == '0'){
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c.addError('Delivery Quantity in Die Form cannot be blank.');
            }
            if(this.mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Wafer_Form__c == '0'){
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Wafer_Form__c.addError('Delivery Quantity in Wafer Form cannot be blank.');
            }           
        }
        if(selectedChangeOption == 'Backgrind Change') {
            if(this.mpwChangeReqWrapp.mpwChangeReq.Backgrind__c == 'None'){
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Backgrind__c.addError('Backgrind__c cannot be blank.');
            }
        }
        if(selectedChangeOption == 'Corner Split Change') {
            if(this.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c == 'Yes' && this.mpwResf.Category__c != 'FAB' && this.mpwResf.Category__c != 'TD'){
                //01042016 - Added by Poulami Starts
                if((integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) == 0) && (this.mpwChangeReqWrapp.mpwChangeReq.POR__c == null || (this.mpwChangeReqWrapp.mpwChangeReq.POR__c.isNumeric() == true && Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.POR__c) <= 0))) {
                    isValidate = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Die Form cannot be null or zero.'));
                }
                if(integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) == 0 && this.mpwChangeReqWrapp.mpwChangeReq.FF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.FS__c == null && this.mpwChangeReqWrapp.mpwChangeReq.SF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.SS__c == null) {
                    isValidate = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Die Form should have value.'));
                }               
                
                if((integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) == 0) && (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c == null || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c.isNumeric() == true && Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c) <= 0))) {
                    isValidate = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Wafer Form cannot be null or zero.'));
                }
                if(integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) == 0 && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c == null) {
                    isValidate = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Wafer Form should have value.'));
                }
                //01042016 - Added by Poulami Ends
                
                Integer subCorner = 0;
                if(this.mpwChangeReqWrapp.mpwChangeReq.FF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.FF__c.isNumeric() == true){
                    subCorner += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.FF__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.FS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.FS__c.isNumeric() == true){
                    subCorner += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.FS__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.SF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.SF__c.isNumeric() == true){
                    subCorner += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.SF__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.SS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.SS__c.isNumeric() == true){
                    subCorner += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.SS__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.POR__c != null && this.mpwChangeReqWrapp.mpwChangeReq.POR__c.isNumeric() == true){
                    subCorner += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.POR__c);
                }
                
                //01042016 - Added by Poulami Starts
                Integer subCorner1 = 0;
                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c.isNumeric() == true){
                    subCorner1 += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c.isNumeric() == true){
                    subCorner1 += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c.isNumeric() == true){
                    subCorner1 += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c.isNumeric() == true){
                    subCorner1 += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c);
                }
                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c.isNumeric() == true){
                    subCorner1 += integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c);
                }
                
                if(integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) == 0){
                    if(subCorner1 != integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c)){
                            isValidate = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sum of POR, FF, SS, SF, FS in Wafer Form are not matching with Quantity Delivery in Wafer Form of the Prime Die.'));
                        }
                }
                if(integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) == 0){
                    if(subCorner != integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c)){
                            isValidate = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sum of POR, FF, SS, SF, FS in Die Form are not matching with Quantity Delivery in Die Form of the Prime Die.'));
                    }
                }
                if(integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) != 0 && integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) != 0){
                    if(subCorner == integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) || subCorner1 == integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c)){
                            if(subCorner == integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c)){
                                if(this.mpwChangeReqWrapp.mpwChangeReq.POR__c == null || (this.mpwChangeReqWrapp.mpwChangeReq.POR__c.isNumeric() == true && Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.POR__c) <= 0)) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Die Form cannot be null or zero.'));
                                }
                                if(this.mpwChangeReqWrapp.mpwChangeReq.FF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.FS__c == null && this.mpwChangeReqWrapp.mpwChangeReq.SF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.SS__c == null) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Die Form should have value.'));
                                }
                            }else if(subCorner != integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c) && ((this.mpwChangeReqWrapp.mpwChangeReq.FF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.FF__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.FF__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.FS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.FS__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.FS__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.SF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.SF__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.SF__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.SS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.SS__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.SS__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.POR__c != null && this.mpwChangeReqWrapp.mpwChangeReq.POR__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.POR__c) != 0))){
                                isValidate = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sum of POR, FF, SS, SF, FS in Die Form are not matching with Quantity Delivery in Die Form of the Prime Die.'));
                                if(this.mpwChangeReqWrapp.mpwChangeReq.POR__c == null || (this.mpwChangeReqWrapp.mpwChangeReq.POR__c.isNumeric() == true && Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.POR__c) <= 0)) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Die Form cannot be null or zero.'));
                                }
                                if(this.mpwChangeReqWrapp.mpwChangeReq.FF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.FS__c == null && this.mpwChangeReqWrapp.mpwChangeReq.SF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.SS__c == null) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Die Form should have value.'));
                                }
                                
                            }
                            if(subCorner1 == integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c)){
                                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c == null || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c.isNumeric() == true && Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c) <= 0)) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Wafer Form cannot be null or zero.'));
                                }
                                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c == null) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Wafer Form should have value.'));
                                }
                            }else if(subCorner1 != integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c) && ((this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c) != 0) || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c.isNumeric() == true && integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c) != 0))){
                                isValidate = false;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sum of POR, FF, SS, SF, FS in Wafer Form are not matching with Quantity Delivery in Wafer Form of the Prime Die.'));
                                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c == null || (this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c.isNumeric() == true && Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c) <= 0)) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Value of POR in Wafer Form cannot be null or zero.'));
                                }
                                if(this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c == null) {
                                    isValidate = false;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either of the fields FF, FS, SF, SS in Wafer Form should have value.'));
                                }
                            }
                        }else{
                            isValidate = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Either sum of POR, FF, SS, SF, FS in Die Form or Wafer Form should match with Quantity Delivery in Die Form or Wafer Form respectively.'));
                        }
                    
                }
                //01042016 - Added by Poulami Ends
            }                       
        }
        if(selectedChangeOption == 'Extra Dies/Wafer Re-start') {
            if(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c == '0' && this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c == '0') {
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.addError('Both of the fields cannot be null');
            }
        }
        if(selectedChangeOption == 'Expedite Change') {
  // 23-Jun update by Venkat. Commented below 4 lines for MPW-PP146 allow expedite change request for 0 in both die and wafer.
           // if(this.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c == '0' && this.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c == '0') {
           //     isValidate = false;
           //     this.mpwChangeReqWrapp.mpwChangeReq.addError('Both of the fields cannot be null');
          //  }
            if(integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c) > integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Die_Form__c)){
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c.addError('Expedite In Die Form cannot be greater that Delivery Quantity in Die Form.');
            }
            if(integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c) > integer.valueOf(mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c)){
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c.addError('Expedite In Wafer Form cannot be greater that Delivery Quantity in Wafer Form.');
            }
        }
        if(selectedChangeOption == 'Short Loop Change') {
            if(this.mpwChangeReqWrapp.mpwChangeReq.Address1_ShortLoop_Wafer__c == 'None') {
                isValidate = false;
                this.mpwChangeReqWrapp.mpwChangeReq.Address1_ShortLoop_Wafer__c.addError('Short Loop cannot be null');
            }
        }
    }
 // 23-Jun Update by Venkat for MPW-PP145 Increase the total number of FAE Approvers. Current limit is 10. Increased the Limit to 15               
    public void retreiveApproversForChangeReq(){
    
        MPW_Train_Maintenance__c train = new MPW_Train_Maintenance__c();
        train = [select Id, Name, Fab__c, Train_Type__c, Geometry__c, OwnerId from MPW_Train_Maintenance__c where Id =: this.mpwResf.MPW_Train_Name__c];
        String queryFields = util.getAllFields('MPW_Approval_Matrix__c');
        String soql = 'select '+queryFields+' from MPW_Approval_Matrix__c';       
        MPW_Approval_Matrix__c mpwm = new MPW_Approval_Matrix__c();
        //04072016 - Modified by Poulami Starts.
        if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'Lighting' || this.mpwResf.Category__c == 'TD' || this.mpwResf.Category__c == 'DE' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
        //04072016 - Modified by Poulami Ends.    
            if(this.mpwResf.Category__c == 'FAB' || this.mpwResf.Category__c == 'TD'){
                String fab = train.Fab__c;
                soql += ' where Category__c = \''+this.mpwResf.Category__c+'\' and Fab__c = \''+fab+'\' and Geometry__c = \''+train.Geometry__c+'\'';
            }
            //04072016 - Modified by Poulami Starts.
            else if(this.mpwResf.Category__c == 'DE' || this.mpwResf.Category__c == 'IP' || this.mpwResf.Category__c == 'ASIC R&D' || this.mpwResf.Category__c == 'RF_ASIC_A&D Protos'){
            //04072016 - Modified by Poulami Ends.    
                soql += ' where Category__c = \''+this.mpwResf.Category__c+'\' and Sub_Category__c = \''+this.mpwResf.Sub_Category__c+'\'';
            }else if(this.mpwResf.Category__c == 'Lighting'){
                 soql += ' where Category__c = \''+this.mpwResf.Category__c+'\'';
             }
             
           //Kanishk :may be one category have more than one record. Needs to add limit 1
            soql +=' limit 1';
         
            mpwm = database.query(soql);
            if(mpwm.Id != null){
                this.mpwChangeReqWrapp.mpwChangeReq.Internal_Budget_Owner_1__c = mpwm.Step_1_Approver_1__c;
                this.mpwChangeReqWrapp.mpwChangeReq.Internal_Budget_Owner_2__c = mpwm.Step_1_Approver_2__c; 
            }
        } else {
            this.mpwChangeReqWrapp.mpwChangeReq.Primary_Account_Manager__c = this.mpwResf.AM_Name__c;
            this.mpwChangeReqWrapp.mpwChangeReq.Primary_CSR__c = this.mpwResf.CSR_Name__c;
            if(this.mpwResf.Customer_Company_Name__c != null){
                List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();

                proxyList = [SELECT User__c from Account_Team_Proxy__c 
                                WHERE User__r.isActive = true 
                                    AND Account__c =: this.mpwResf.Customer_Company_Name__c 
                                    AND ( Team_Role__c = 'Field Application Engineer' 
                                       OR Team_Role__c = 'Primary Field Application Engineer' 
                                       OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                       OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                ORDER BY Team_Role__c desc limit 10];
                if(!proxyList.isEmpty()){
                    if(proxyList.size() == 1){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                    }
                    if(proxyList.size() == 2){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                    }
                    if(proxyList.size() == 3){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                    }
                    if(proxyList.size() == 4){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                    }
                    if(proxyList.size() == 5){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                    }
                    if(proxyList.size() == 6){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                    }
                    if(proxyList.size() == 7){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                    }
                    if(proxyList.size() == 8){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                    }
                    if(proxyList.size() == 9){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                    }
                    if(proxyList.size() == 10){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_10__c = proxyList[9].User__c;
                    }
                    /*if(proxyList.size() == 11){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_10__c = proxyList[9].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_11__c = proxyList[10].User__c;
                    }
                    if(proxyList.size() == 12){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_10__c = proxyList[9].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_11__c = proxyList[10].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_12__c = proxyList[11].User__c;
                    }
                    if(proxyList.size() == 13){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_10__c = proxyList[9].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_11__c = proxyList[10].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_12__c = proxyList[11].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_13__c = proxyList[12].User__c;
                    }
                    if(proxyList.size() == 14){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_10__c = proxyList[9].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_11__c = proxyList[10].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_12__c = proxyList[11].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_13__c = proxyList[12].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_14__c = proxyList[13].User__c;
                    }
                    if(proxyList.size() == 15){
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_1__c = proxyList[0].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_2__c = proxyList[1].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_3__c = proxyList[2].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_4__c = proxyList[3].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_5__c = proxyList[4].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_6__c = proxyList[5].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_7__c = proxyList[6].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_8__c = proxyList[7].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_9__c = proxyList[8].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_10__c = proxyList[9].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_11__c = proxyList[10].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_12__c = proxyList[11].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_13__c = proxyList[12].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_14__c = proxyList[13].User__c;
                        this.mpwChangeReqWrapp.mpwChangeReq.Step_1_Approver_15__c = proxyList[14].User__c;
                    }*/
                }
            }
        }
    }
  // 23-Jun Update by Venkat Ends  
  
    public pageReference submitReq(){
    
        validateChangeReq();
        if(!isValidate){
            return null;
        }
        else {
            try {
                integer flag=0;          
                    MPW_Change_Request__c cr = new MPW_Change_Request__c(); 
                    Integer extraQuantityDie;
                    Integer extraQuantityWafer;
                    Integer deliveryDieQuantity;
                    Integer deliveryWaferQuantity;
                    this.mpwChangeReqWrapp.mpwChangeReq.MPW_Prime_Die__c = primeId;
                    this.mpwChangeReqWrapp.mpwChangeReq.Status__c = 'Draft';
                    this.mpwChangeReqWrapp.mpwChangeReq.MPW_Form__c = mpwResf.Id;
                    this.mpwChangeReqWrapp.mpwChangeReq.Remarks__c = mpwChangeReq.Remarks__c;
                    this.mpwChangeReqWrapp.mpwChangeReq.Request_Type__c = selectedChangeOption;
                    
                    retreiveApproversForChangeReq();
                    
                    if(selectedChangeOption == 'Wafer Form Delivery' && mpwResf.Category__c != 'FAB' && mpwResf.Category__c != 'TD') {
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c == null) {
                            deliveryDieQuantity = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c);
                        }
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c == null) {
                            deliveryDieQuantity = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c);
                        }  
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c != null) {
                            deliveryDieQuantity = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c);
                        }

                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c == null) {
                            deliveryWaferQuantity = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c);
                        }
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c == null) {
                            deliveryWaferQuantity = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c);
                        }  
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c != null) {
                            deliveryWaferQuantity = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c);
                        }
                        
                        if(mpwPrimeDieCh.Corner_Split__c == 'Yes') {
                            Integer subCorner = 0;
                            
                            if(mpwPrimeDieCh.FF__c != null){
                                subCorner += integer.valueOf(mpwPrimeDieCh.FF__c);
                            }
                            if(mpwPrimeDieCh.FS__c != null){
                                subCorner += integer.valueOf(mpwPrimeDieCh.FS__c);
                            }
                            if(mpwPrimeDieCh.SF__c != null){
                                subCorner += integer.valueOf(mpwPrimeDieCh.SF__c);
                            }
                            if(mpwPrimeDieCh.SS__c != null){
                                subCorner += integer.valueOf(mpwPrimeDieCh.SS__c);
                            }
                            if(mpwPrimeDieCh.POR__c != null){
                                subCorner += integer.valueOf(mpwPrimeDieCh.POR__c);
                            }
                            
                            //01042016 - Added by Poulami Starts
                            if(subCorner != deliveryDieQuantity && ((mpwPrimeDieCh.FF__c != null && integer.valueOf(mpwPrimeDieCh.FF__c) != 0) || (mpwPrimeDieCh.FS__c != null && integer.valueOf(mpwPrimeDieCh.FS__c) != 0) || (mpwPrimeDieCh.SF__c != null && integer.valueOf(mpwPrimeDieCh.SF__c) != 0) || (mpwPrimeDieCh.SS__c != null && integer.valueOf(mpwPrimeDieCh.SS__c) != 0) || (mpwPrimeDieCh.POR__c != null && integer.valueOf(mpwPrimeDieCh.POR__c) != 0))){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sum of POR, FF, SS, SF, FS in Die Form are not matching with Quantity Delivery in Die Form of the Prime Die.'));
                                return null;
                            }
                            Integer subCorner1 = 0;
                            if(mpwPrimeDieCh.Wafer_FF__c != null){
                                subCorner1 += integer.valueOf(mpwPrimeDieCh.Wafer_FF__c);
                            }
                            if(mpwPrimeDieCh.Wafer_FS__c != null){
                                subCorner1 += integer.valueOf(mpwPrimeDieCh.Wafer_FS__c);
                            }
                            if(mpwPrimeDieCh.Wafer_SF__c != null){
                                subCorner1 += integer.valueOf(mpwPrimeDieCh.Wafer_SF__c);
                            }
                            if(mpwPrimeDieCh.Wafer_SS__c != null){
                                subCorner1 += integer.valueOf(mpwPrimeDieCh.Wafer_SS__c);
                            }
                            if(mpwPrimeDieCh.Wafer_POR__c != null){
                                subCorner1 += integer.valueOf(mpwPrimeDieCh.Wafer_POR__c);
                            }
                            if(subCorner1 != deliveryWaferQuantity && ((mpwPrimeDieCh.Wafer_FF__c != null && integer.valueOf(mpwPrimeDieCh.Wafer_FF__c) != 0) || (mpwPrimeDieCh.Wafer_FS__c != null && integer.valueOf(mpwPrimeDieCh.Wafer_FS__c) != 0) || (mpwPrimeDieCh.Wafer_SF__c != null && integer.valueOf(mpwPrimeDieCh.Wafer_SF__c) != 0) || (mpwPrimeDieCh.Wafer_SS__c != null && integer.valueOf(mpwPrimeDieCh.Wafer_SS__c) != 0) || (mpwPrimeDieCh.Wafer_POR__c != null && integer.valueOf(mpwPrimeDieCh.Wafer_POR__c) != 0))){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sum of POR, FF, SS, SF, FS in Wafer Form are not matching with Quantity Delivery in Wafer Form of the Prime Die.'));
                                return null;
                            }
                            //01042016 - Added by Poulami Ends
                        }
                        this.mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Die_Form__c = String.valueOf(deliveryDieQuantity);
                        this.mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Wafer_Form__c = String.valueOf(deliveryWaferQuantity);
                    }
                    //01042016 - Added by Poulami Starts
                    if(selectedChangeOption == 'Corner Split Change') {
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c == 'No'){
                            this.mpwChangeReqWrapp.mpwChangeReq.FF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.FS__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.SF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.SS__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.POR__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '0';
                        }
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c == 'Yes' && mpwPrimeDieCh.Delivery_Qty_Die_Form__c == '0'){
                            this.mpwChangeReqWrapp.mpwChangeReq.POR__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.SS__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.SF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.FF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.FS__c = '0';
                            
                        }
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c == 'Yes' && mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c == '0'){
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '0';
                            this.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '0';
                            
                        }
                    }
                    //01042016 - Added by Poulami Ends
                    
                    if(selectedChangeOption == 'Extra Dies/Wafer Re-start') {
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c == null) {
                            extraQuantityDie = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c);
                        }
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c == null) {
                            extraQuantityDie = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c);
                        }  
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c != null) {
                            extraQuantityDie = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c);
                        }               
                        
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c == null) {
                            this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '0';
                        }
                        
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c == null) {
                            this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c = '0';
                        }
                        
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c == null) {
                            this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c = '0';
                        }                       
                        
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c != null) {
                            extraQuantityWafer = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c);
                        }
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c == null && this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c != null) {
                            extraQuantityWafer = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c);
                        }  
                        if(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c != null && this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c != null) {
                            extraQuantityWafer = Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(this.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c);
                        }                                               
                        
                        if(mpwResf.Category__c == 'Customer') {
                            this.mpwChangeReqWrapp.mpwChangeReq.Extra_Die_Quantity__c = extraQuantityDie + (extraQuantityWafer * 50);
                            this.mpwChangeReqWrapp.mpwChangeReq.Extra_Wafer_Qty__c = (extraQuantityDie + (extraQuantityWafer*50))/50;
                        } else {                        
                            this.mpwChangeReqWrapp.mpwChangeReq.Extra_Die_Quantity__c = extraQuantityDie + (extraQuantityWafer*50);
                            this.mpwChangeReqWrapp.mpwChangeReq.Extra_Wafer_Qty__c = (extraQuantityDie  + (extraQuantityWafer*50))/50;
                        }
                    }
                    
                    cr = this.mpwChangeReqWrapp.mpwChangeReq;      
                    upsert cr;
                                      
                    isValidate = true;
                        
                    if(selectedChangeOption == 'Turnkey Services Change') {
                        if(filebody3 != null && filename3 != null){
                            Attachment attach = new Attachment();
                            attach.Body = filebody3;
                            attach.ParentId = cr.Id;
                            attach.Name = 'TurnkeyPreAlertForm_'+this.filename3;
                                
                            filebody3 = null;
                            insert attach;
                            
                            cr.TurnkeyAttached__c = true;
                            cr.TurnkeyAttachedId__c = attach.Id;
                            update cr;
                        }
                    }
                    else if(selectedChangeOption == 'Corner Split Change'){
                        if(filebody1 != null && filename1 != null){
                            Attachment attach = new Attachment();
                            attach.Body = filebody1;
                            attach.ParentId = cr.Id;
                            attach.Name = 'CornerSplit_'+this.filename1;
                            filebody1 = null;
                            insert attach;
                            
                            cr.CornerSplitAttached__c = true;
                            cr.CornerSplitAttachedId__c = attach.Id;
                            update cr;
                        }
                    }
                    else if(selectedChangeOption == 'Sub Devices Extraction'){
                        if(filebody2 != null && filename2 != null){
                            Attachment attach = new Attachment();
                            attach.Body = filebody2;
                            attach.ParentId = cr.Id;
                            attach.Name = 'SubDevicesExtraction_'+this.filename2;
                            filebody2 = null;
                            insert attach;
                                                        
                            cr.SubDevicesExtractionAttached__c = true;
                            cr.SubDevicesExtractionAttachedId__c = attach.Id;
                            update cr;
                        }
                    }
                    
                    if((cr.Sub_Devices_Extraction__c != '0' && cr.SubDevicesExtractionAttached__c == false) || (cr.Turnkey_Service__c == 'Yes' && cr.TurnkeyAttached__c == false)){
                        flag = 0;
                        isValidate = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please attach required documents'));
                        return null;
                    } else{
                        flag++;
                    } 
                    if(flag > 0){
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitting Request for Approval.');
                        req.setObjectId(cr.Id);
                        Approval.ProcessResult result = Approval.process(req);            
                    }  

                pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+mpwResf.Id);
                p.getParameters().put('mode','View');
                p.getParameters().put('intpoint',this.initPoint);
                p.getParameters().put('ChangeRequest','1');
                p.setRedirect(true);
                return p;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()+e.getLineNumber()));
                return null;
            }
        }    
    }    

    public pageReference cancelReq(){
        this.isShow = false;
        pageReference p = new pageReference('/apex/MPWReservationFormVF?Id='+mpwResf.Id);
        p.getParameters().put('mode','View');
        p.getParameters().put('intpoint',this.initPoint);
        p.getParameters().put('ChangeRequest','1');
        p.setRedirect(true);
        return p;
    }
    
    public void listChangeReqRecords() { 
        util = new UtilClassToGetAllFields();
        String queryFields = util.getAllFields('MPW_Change_Request__c');
        queryFields += ', MPW_Change_Request__c.MPW_Prime_Die__r.Prime_Die_Name__c, CreatedBy.Name';
        String query = 'select '+queryFields+' from MPW_Change_Request__c where MPW_Form__c =\''+mpwResf.Id+'\' order by Name desc';
        this.mpwListChangeReq = database.query(query);
    }
    
    public List<MPW_Change_Request__c> getChangeRequestsRecords(){
        return this.mpwListChangeReq;    
    } 
    
    //method to Void the form
    public pageReference voidForm(){
        pageReference pgRef = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwResf.Id+'&intpoint=mpwtrain&mode=View');
        if(this.mpwResf.Reason_to_Void__c != null){
            this.mpwResf.Form_Status__c = 'Void';
            update this.mpwResf;
            pgRef.setRedirect(true);
            return pgRef;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please mention the reason to void the form.'));
            return null;
        }
    }   
    
     private class DMLException extends Exception {}
}