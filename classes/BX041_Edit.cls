/*
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Class manages the BX041 Edit and View page.
    History: 
      PS            07072013    - Code creation.
      TL            27022014    - Added mandatory validation for Die Size fields of CDRS
      TL            25042014    - Added validatoin for FE submission to CE as per case 16657
      TL            09072014    - Added reopen function for FE as per case 28592
      ZAmbat        09112014    - Updated code as per CASE 18115.
      VM            02232015    - updated the code to support the Internal Device CDRS functionality.added InternalDevice check to skip to the exsisting code and 
                                  invoke the Internal Device CDRS approval process related functionality.
      Psamal       26042016    - Modified code as for Case 00049037.
      
*/


public class BX041_Edit {
    
    
    /******************************* Start: Variable Declaration block ***********************************/
    public Id bx041ID; 
    public transient Set<String> ChangeSections;
    public BX_041__c bx041 {get;set;}
    public boolean backtrackwindow {get;set;}
    public transient List<id> QstnMetaData ; 
    public transient Map<id,List<selectOption>> MapPickList ;
    public transient String TemplateName {get;set;}
    public transient Map<id, List<Question_Metadata__c>> MapSectionQstnMetadata;
    public transient Map<id,List<Question_Metadata__c>> MapTopSection;
    public transient List<Question_Metadata__c> TopSectionName;
    public List<TopSectionWrapper> WrapperTopSectionList {get;set;}
    public transient Map<String,Process_Information__c > MapProcessInfoValue;
    public transient Map<String,sobject> MapSobjectValue;
    public map<String,map<string,sobject>> mapSobjectData = new map<String,map<string,sobject>>();
    public List<BX041_IP_Merge__c> ipmList {get; set;}
    public map<id,BX041_IP_Merge__c> ipmOldMap {get; set;}
    public transient List<sobject> updatesobject ;
    public List<SelectOption> BackTrackSelectOption {get;set;}
    public String BackTrackValue {get;set;}
    public boolean piyeApprSelectionWindow {get; set;}
    public boolean isCustomer {get; set;}
    public boolean isAdmin {get; set;}
    public String pfName {get; set;}
    public String accountRegion {get; set;}
    public String comment {get;set;}
    public String QueueID {get;set;}
    public String QueueName {get;set;}
    public boolean isGapNone ; //used to check whether the user has updated all the GAP values before approve in the PIYE level.
    public boolean addNewIP {get; set;} // 18/11/13 Thomas Added: for custom lookup button for Ip Type
    public String iptypevalue{get;set;}
    public boolean ipSectionChanged {get; set;}  //16/01/14 Thomas Added
    public boolean ipmSectionChanged {get; set;}  //16/01/14 Thomas Added
    public id prevAssignedPID {get;set;}
    public string baseUrl {get; set;} // Tlai 7/7/2014
    public boolean hasPermission {get; set;}
    public boolean isAuthorizedCustomer {get; set;}
    public Boolean isInternalDevice {get;set;} // Added by Vijay 02132015
    
    /******************************* Start: Variable Declaration block ***********************************/
    
    /******************************* Start: Wrapper defination section ***********************************/
    //TopSection wrapper- displays the top section.
    public class TopSectionWrapper{
        public String SectionName {get;set;}
        public List<SectionWrapper> AllWrapperSection {get;set;}
        public Boolean visible {get; set;}
        public String shortName {get; set;}
        public String recordType {get; set;}
    }
    
    //Section wrapper
    public class SectionWrapper{
        public Question_Metadata__c PISectionList {get;set;}
        public List<RowWrapper> WrapperList {get;set;}
        public string title {get; set;}
    }
    
    //Row wrapper(question and value is saved here)
    public class RowWrapper{
        public String question {get; set;}
        public String FEinfo {get; set;}
        public String PiyeInfo {get; set;}
        public String Comments {get; set;}
        public List<selectOption> CustInfoList {get; set;}
        public String value {get; set;}
        public String custcomment {get; set;}
        public String resolution {get; set;}
        public String fieldType {get;set;}
        public String GAResolution {get;set;}
        public boolean editfe {get;set;}
        public boolean editpiye {get;set;}
        public String metadataid {get;set;}
        public String reqGap {get; set;}
        public String intlCmt {get; set;}
        public boolean mandatory {get;set;}
    }
    
    
    /******************************* Start: Wrapper defination section ***********************************/
    
    
    /******************************************************************************************************
    @Method Name:    Constructor ( CLS_BX041_Create )
    @Return Type:    NA
    @parameter:      ApexPages.StandardController controller
    @Reason:         Constructor of the VF page BX041_Edit_Page and BX041_View_Page
    *******************************************************************************************************/    
    public BX041_Edit (ApexPages.StandardController controller) {
        this.bx041 = (BX_041__c)controller.getRecord();
        bx041ID = bx041.id;
        //Making query to get BX041 record
        bx041 = [SELECT id,
                        name,
                        Device__c,
                        Device__r.Requested_Process_ID__c,
                        Device__r.Assigned_Process_ID__c,
                        Device__r.Geometry__c,
                        device__r.Fab__c,
                        device__r.Tapeout_Type__c,
                        Device__r.Account__r.Region__c,
                        device__r.Current_Forecast_Tapeout_Date__c,
                        Device__r.Confidence_Level_Tapeout__c, //Added Tlai 25042014
                        BX_041_Status__c,
                        Approval_Status__c,
                        Approval_Step__c ,
                        Need_MEMS_informaton__c,
                        Need_PowerMOS__c,
                        Need_eDRAM__c,
                        Need_High_Voltage__c,
                        Need_NVM__c,
                        Need_RF__c,
                        Need_Turnkey__c,
                        Need_IP_information__c,
                        Need_IP_Merge_information__c,
                        Reference_Process_ID__c ,
                        Die_Size_Pre_Shrink_mm2__c,
                        Reference_Process_ID_txt__c,
                        Assigned_Process_ID__c,
                        Assigned_Process_ID__r.Name,
                        Requested_Process_ID__c,
                        Requested_Process_ID__r.Name,
                        Process_ID_is_known__c,
                        Backtrack_Request__c,
                        Configuration_Status__c,
                        Next_WorkItem_Id__c,
                        Approver_1__c,
                        Approver_2__c,
                        Approver_3__c,
                        No_of_CE_Approver__c,                        
                        Template_Name__c,
                        GAP_Closed__c,
                        Initial_Submitter__c,
                        Geometry_Filter__c,
                        Process_Family_Filter__c,
                        CRMDID_Fromula__c,
                        Process_Technology__c,
                        Opportunity_Program__c,
                        Design_Match_Vendor_DR_DM__c,
                        Design_Match_Vendor_EP__c,
                        Design_Match_Vendor_EPET__c,
                        Design_Match_Vendor_SPICE__c,
                        Die_Size_mm2__c,
                        Die_Size_X_mm__c,
                        Die_Size_Y_mm__c,
                        DSCP__c,
                        External_IPs_require_replacement__c,
                        GLOBALFOUNDRIES_Sponsored_IP_Used__c,
                        Intended_Rotation_in_PTRF__c,
                        Max_Operating_Freq_MHz__c,
                        No_of_Gates__c,
                        No_of_IOs__c,
                        No_of_Pins__c,
                        Notch_Location__c,
                        Other_Special_Requirements__c,
                        Poly_Orientation_Compliance__c,
                        Porting_Design_External_IPs_require_rep__c,
                        Restricted_Gate_Poly_Orientation__c,
                        Special_Scribe_Width__c,
                        Step_5_Assigned__c,
                        Steps_Completed__c,
                        Steps_Rejected__c,
                        STF__c,
                        SystemModstamp,
                        CreatedDate,
                        BX_041_Opportunity_Program__c,
                        Key_Notes__c,
                        Device__r.OwnerId,
                        Device__r.Owner.Name,
                        Device__r.Account__r.OwnerId,
                        Device__r.Account__r.Owner.Name,
                        Device__r.Account__c,
                        Device__r.Account__r.Name
                FROM    BX_041__c 
                WHERE   id = :bx041ID];
                
                
        iptypevalue = '';
        ipSectionChanged = false;
        ipmSectionChanged = false;
        //get profile name for profile validation.
        pfName = [select name from profile where id = :UserInfo.getProfileId()].name;
        isAdmin = false;
        hasPermission = true;
        if(pfName.contains('Portal') ) {
            isCustomer = true;
            isAuthorizedCustomer = true;
            list<Portal_Tab_Access__c> ptaList = [select id from Portal_Tab_Access__c where User__c = :UserInfo.getUserId() and Change_request_report__c = true];
            if(ptaList.size() > 0){
                
                isAuthorizedCustomer = true;
            } else{
                isAuthorizedCustomer = false;
            }
            String currentUrl = system.currentPageReference().getURL();
            system.debug(currentUrl);
            if(!isAuthorizedCustomer ||( currentUrl.contains('BX041_Edit_Page') && bx041.BX_041_Status__c != 'Pending Submission')){
                hasPermission = false;
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.WARNING,'Operation is not allowed on CDRS.'));           
            }
            
        } else{
            isCustomer = false;
            if(pfName.contains('Admin')){
                isAdmin = true;
            } 
        }
        if (ApexPages.currentPage().getHeaders().get('host').indexOf('globalfoundryview') == -1) {
            baseUrl = '/apex/CustomLoopUpPage?';
        }else {
            baseUrl = '/GlobalfoundryView/apex/CustomLoopUpPage?';
        }
        //Set local variables for the Constructor 
        displayPopup = false;
        
        
        MapSectionQstnMetadata = new Map<id, List<Question_Metadata__c>>();
        MapTopSection = new Map<id,List<Question_Metadata__c>>();
        TopSectionName = new List<Question_Metadata__c>();
        QstnMetaData = new List<id>();
        WrapperTopSectionList = new List<TopSectionWrapper>();
        MapSobjectValue= new map<String, sobject>();
        backtrackwindow = false;
        piyeApprSelectionWindow = false;
        
        
        //Making query to get BX041 record
        bx041 = [SELECT id,
                        name,
                        Device__c,
                        Device__r.Requested_Process_ID__c,
                        Device__r.Assigned_Process_ID__c,
                        Device__r.Geometry__c,
                        device__r.Fab__c,
                        device__r.Tapeout_Type__c,
                        Device__r.Account__r.Region__c,
                        device__r.Current_Forecast_Tapeout_Date__c,
                        Device__r.Confidence_Level_Tapeout__c, //Added Tlai 25042014
                        BX_041_Status__c,
                        Approval_Status__c,
                        Approval_Step__c ,
                        Need_MEMS_informaton__c,
                        Need_PowerMOS__c,
                        Need_eDRAM__c,
                        Need_High_Voltage__c,
                        Need_NVM__c,
                        Need_RF__c,
                        Need_Turnkey__c,
                        Need_IP_information__c,
                        Need_IP_Merge_information__c,
                        Reference_Process_ID__c ,
                        Die_Size_Pre_Shrink_mm2__c,
                        Reference_Process_ID_txt__c,
                        Assigned_Process_ID__c,
                        Assigned_Process_ID__r.Name,
                        Requested_Process_ID__c,
                        Requested_Process_ID__r.Name,
                        Process_ID_is_known__c,
                        Backtrack_Request__c,
                        Configuration_Status__c,
                        Next_WorkItem_Id__c,
                        Approver_1__c,
                        Approver_2__c,
                        Approver_3__c,
                        No_of_CE_Approver__c,                        
                        Template_Name__c,
                        GAP_Closed__c,
                        Initial_Submitter__c,
                        Geometry_Filter__c,
                        Process_Family_Filter__c,
                        CRMDID_Fromula__c,
                        Process_Technology__c,
                        Opportunity_Program__c,
                        Design_Match_Vendor_DR_DM__c,
                        Design_Match_Vendor_EP__c,
                        Design_Match_Vendor_EPET__c,
                        Design_Match_Vendor_SPICE__c,
                        Die_Size_mm2__c,
                        Die_Size_X_mm__c,
                        Die_Size_Y_mm__c,
                        DSCP__c,
                        External_IPs_require_replacement__c,
                        GLOBALFOUNDRIES_Sponsored_IP_Used__c,
                        Intended_Rotation_in_PTRF__c,
                        Max_Operating_Freq_MHz__c,
                        No_of_Gates__c,
                        No_of_IOs__c,
                        No_of_Pins__c,
                        Notch_Location__c,
                        Other_Special_Requirements__c,
                        Poly_Orientation_Compliance__c,
                        Porting_Design_External_IPs_require_rep__c,
                        Restricted_Gate_Poly_Orientation__c,
                        Special_Scribe_Width__c,
                        Step_5_Assigned__c,
                        Steps_Completed__c,
                        Steps_Rejected__c,
                        STF__c,
                        SystemModstamp,
                        CreatedDate,
                        BX_041_Opportunity_Program__c,
                        Key_Notes__c,
                        Device__r.RecordType.DeveloperName,
                        Device__r.OwnerId,
                        Device__r.Owner.Name,
                        Device__r.Account__r.OwnerId,
                        Device__r.Account__r.Owner.Name,
                        Device__r.Account__c,
                        Device__r.Account__r.Name
                FROM    BX_041__c 
                WHERE   id = :bx041ID];
        
        accountRegion = bx041.Device__r.Account__r.Region__c;
        prevAssignedPID = bx041.Assigned_Process_ID__c;
        setButtonPermission(); //revoking the button permission- calling the setButtonPermission method
        MapPickList = new Map<id,List<selectOption>>();
        
        //making query on question metadata for the TopSection
        for(Question_Metadata__c  q : [SELECT    id,
                                                 name,
                                                 Record_Type__c,
                                                 Type__c,
                                                 Question__c,
                                                 Mandatory__c,
                                                 Mandatory_for_Templates__c,
                                                 Template_Name__c,
                                                 Question_Metadata_Section__c,
                                                 CreatedDate
                                      FROM       Question_Metadata__c
                                      WHERE      Type__c = 'TopSection'                                      
                                      AND        ((Record_Type__c = 'Process Id' and template_name__c includes( :bx041.template_name__c)) or Record_Type__c != 'Process Id')
                                      //AND        CreatedDate <= :bx041.CreatedDate 
                                      ORDER BY   Sequence__c
                                      ]){
            TopSectionName.add(q);                              
        }       
        
        //making query on question metadata for the Section
        for(Question_Metadata__c qsm: [SELECT    id,
                                                 name,
                                                 Record_Type__c,
                                                 Mandatory__c,
                                                 Question__c,
                                                 Question_to_Display__c,
                                                 Sequence__c,
                                                 Mandatory_for_Templates__c,
                                                 Template_Name__c,
                                                 Question_Metadata_Section__c,
                                                 Type__c,
                                                 CreatedDate
                                      FROM       Question_Metadata__c
                                      WHERE      ((Record_Type__c = 'Process Id' and template_name__c includes( :bx041.template_name__c)) or Record_Type__c != 'Process Id')
                                      AND        Type__c = 'Section'
                                      //AND        CreatedDate <= :bx041.CreatedDate
                                      ORDER BY   Sequence__c
                                      ]){
            if(MapTopSection.get(qsm.Question_Metadata_Section__c) == NULL){
                List<Question_Metadata__c> tempList = new List<Question_Metadata__c>();
                tempList.add(qsm);
                MapTopSection.put(qsm.Question_Metadata_Section__c,tempList);
            }
            else{
                MapTopSection.get(qsm.Question_Metadata_Section__c).add(qsm);
            }                              
        }
        
        //making query on question metadata for the question of different sections
        
        for( Question_Metadata__c qm :  [SELECT     id,
                                                    Record_Type__c,
                                                    Mandatory__c,
                                                    Question__c,
                                                    Question_to_Display__c,
                                                    Sequence__c,
                                                    Template_Name__c,
                                                    Mandatory_for_Templates__c,
                                                    Question_Metadata_Section__c,
                                                    Type__c,
                                                    CreatedDate
                                         FROM       Question_Metadata__c
                                         WHERE      ((Record_Type__c = 'Process Id' and template_name__c includes( :bx041.template_name__c)) or Record_Type__c != 'Process Id')
                                         AND        (Type__c = 'Picklist' 
                                         OR         Type__c = 'Text')
                                         //AND        CreatedDate <= :bx041.CreatedDate 
                                         ORDER BY   Sequence__c
                            ]){
            QstnMetaData.add(qm.id);
            if(MapSectionQstnMetadata.get(qm.Question_Metadata_Section__c) == NULL ){
                List<Question_Metadata__c> tempqmlist = new List<Question_Metadata__c>();
                tempqmlist.add(qm);
                MapSectionQstnMetadata.put(qm.Question_Metadata_Section__c,tempqmlist);
            }    
            else{
                MapSectionQstnMetadata.get(qm.Question_Metadata_Section__c).add(qm);   
            }
        }
        
        //making query on question metadata picklist value for the picklist options
        list<Question_Metadata_Picklist_Value__c> qmpvList = [SELECT id,
                                                             name,
                                                             Question_Metadata__c,
                                                             Value__c
                                                      FROM   Question_Metadata_Picklist_Value__c
                                                      WHERE  Question_Metadata__c 
                                                      IN     :QstnMetaData
                                                      ORDER BY sequence__c ];
       for (Integer i=0;i<qmpvList.size();i++) {
            Question_Metadata_Picklist_Value__c plv  = qmpvList[i]; 
            if(MapPickList.get(plv.Question_Metadata__c) == NULL){
                List<selectOption> temppicklst = new List<selectOption>();
                temppicklst.add(new selectoption (plv.Value__c,plv.Value__c));
                MapPickList.put(plv.Question_Metadata__c , temppicklst);
            }
            else{
                MapPickList.get(plv.Question_Metadata__c ).add(new selectoption (plv.Value__c,plv.Value__c));
            }
        }
        
        //**** Start: retrieving BX041 Child object Data *****            
        Map<String,String> apiNm2RtMap = new Map<String,String>(); //record type -->child object Api name
        for(BX041__c cs : [select name,SObject_Type__c FROM BX041__c where IsActive__c = true]){
                apiNm2RtMap.put(cs.SObject_Type__c,cs.name);
        }
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String , Map<String,Schema.SObjectField> > mapObj_FielMap = new Map<String , Map<String,Schema.SObjectField> >();
        
        for(String objApiName : apiNm2RtMap.keyset()){        
            Schema.SObjectType sobjType = gd.get(objApiName);
            Schema.DescribeSObjectResult dsr = sobjType.getDescribe();
            Map<String,Schema.SObjectField> api2FieldsMap = dsr.fields.getMap();
            mapObj_FielMap.put(objApiName , api2FieldsMap);
        }
        
        for(String objApiName : apiNm2RtMap.keyset()){
            Set<String> fieldnames = mapObj_FielMap.get(objApiName).keyset();
            List<String> fields = new List<String>();
            map<String,sobject> tempmap = new map<String,sobject>();
            fields.addall(fieldnames);
            String str = String.join ( fields, ',');
            String querystr = 'SELECT ' +str +'  FROM  '+ objApiName + ' WHERE  BX_041__c = '+ '\''+ bx041.id+'\''; 
            List<sobject> listsobj = database.query(querystr);
            BX041__c bx = BX041__c.getInstance(apiNm2RtMap.get(objApiName));      
            if(objApiName == 'Process_Information__c') {
                for(Process_Information__c pi : database.query(querystr)){
                    tempmap.put(pi.Question_Metadata__c,pi);    
                }
            }      
            else if(objApiName == 'Gap_Analysis_Form__c'){
                isGapNone = false;
                // isGapNone = true if any of the GAP statuses is None
                // isGapNone = false if all of the GAP statuses are not None
                for(Gap_Analysis_Form__c ga : database.query(querystr)){
                    tempmap.put(ga.Question_Metadata__c, ga);
                    if(ga.APTS_Status__c == 'None'){
                        if(isGapNone == false){
                            isGapNone = true;
                        }
                    }
                }
            }   
            else{
                for(Sobject record : listsobj ){
                    BX041__c instance = BX041__c.getInstance(apiNm2RtMap.get(objApiName));
                    if(instance != NULL && String.valueof(record.get(instance.API_Name__C)) != NULL ){
                        tempmap.put(String.valueof(record.get('Question_Metadata__c')),record);
                    }
                }
            }
            
            mapSobjectData.put(objApiName,tempmap);  
            system.debug(logginglevel.error,mapSobjectData);
                   
        }
        //**** End: retrieving BX041 Child object Data *****
        
        //*********Start: creating Wrapper to display different sections*********
        for(Question_Metadata__c topSec: TopSectionName ){// loop topsection start
            TopSectionWrapper tempTopSection = new TopSectionWrapper ();
            List<SectionWrapper> tempwrrapersection = new List<SectionWrapper>();
            BX041__c instance = BX041__c.getInstance(topSec.Record_Type__c);
            if(instance == null){ addMessage(topSec.Record_Type__c + ' not found in BX041__c'); continue;}
                
                
            
            if(MapTopSection.get(topSec.id) != NULL){
                for(Question_Metadata__c sec: MapTopSection.get(topSec.id)){// loop subsection start
                    SectionWrapper tempwrapsec = new SectionWrapper();
                    List<RowWrapper> tempwrapperclass = new List<RowWrapper>();  
                              
                    if(MapSectionQstnMetadata.get(sec.id)!= NULL){
                        for(Question_Metadata__c qmRow : MapSectionQstnMetadata.get(sec.id)){//loop question/Row start
                            RowWrapper  tempwrap = new RowWrapper();
                            tempwrap.question = qmRow.Question__c;
                            tempwrap.metadataid = qmRow.id;
                            // If it is textbox, blank value is default. If picklist, 'None' is default
                            // 17/10/2013 Thomas: first option for picklist is 'None', no need to set None
                            if(tempwrap.fieldType == 'Text'){
                                tempwrap.value = '';
                            } 
                                                       
                            Sobject sobj;                             
                            if( mapSobjectData.containsKey(instance.SObject_Type__c ) && mapSobjectData.get(instance.SObject_Type__c).containsKey(qmRow.id)){
                                sobj = mapSobjectData.get(instance.SObject_Type__c).get(qmRow.id);
                                if(sobj.get(instance.GetValue__c)!= null ){                            
                                    tempwrap.value =String.valueOf(sobj.get(instance.GetValue__c)) ;
                                }                                                                            
                            }   
                            
                            /* IP QA Status of the Gap analysis section should be No Gap/NA by default                         
                            if(qmRow.Question_to_Display__c == 'IP QA Status' && tempwrap.value == 'None'){
                                tempwrap.value = 'No Gap/NA';
                                
                            }*/
                            
                            if(topSec.record_type__c == Label.QM_RT_PI && sobj != null){                               
                                tempwrap.FEinfo = string.valueOf(sobj.get('FE_Requested_Information__c'));
                                tempwrap.PiyeInfo = string.valueOf(sobj.get('PIYE__c'));                                
                                tempwrap.reqGap = string.valueOf(sobj.get('Requirement_Gaps__c'));
                                tempwrap.intlCmt = string.valueOf(sobj.get('Comments__c'));
                                tempwrap.custcomment = string.valueOf(sobj.get('Customer_Comment__c'));
                                tempwrap.mandatory = false;
                                if(qmRow.Mandatory_for_Templates__c != null ){
                                    system.debug(qmrow.question__c);
                                    system.debug(qmRow.mandatory__c  + '&&&' + qmRow.Mandatory_for_Templates__c + ' &&& contains ' + bx041.Template_Name__c + ' ' + qmRow.Mandatory_for_Templates__c.contains(bx041.Template_Name__c));
                                    if(qmRow.mandatory__c  || qmRow.Mandatory_for_Templates__c.contains(bx041.Template_Name__c)){
                                        tempwrap.mandatory = true;
                                    }
                                }
                            } 
                            else if(topSec.record_type__c == Label.QM_RT_GA && sobj != null){
                                tempwrap.custcomment = string.valueOf(sobj.get('APTS_Comments__c'));
                                tempwrap.GAResolution = string.valueOf(sobj.get('APTS_Resolution__c'));
                            }
                            tempwrap.CustInfoList = MapPickList.get(qmRow.id);
                            
                            //if(tempwrap.CustInfoList != NULL)
                                // remove None for IP QA Status if required later
                                //tempwrap.CustInfoList.add(new SelectOption('None','None'));
                                
                            if(MapPickList.get(qmRow.id) != NULL){
                                tempwrap.fieldType = 'Picklist';
                            }
                            else{
                                tempwrap.fieldType = 'Text';
                            }
                            
                            tempwrapperclass.add(tempwrap);
                        }//loop question/Row end
                    
                        //remove the section if NO question is associated. 
                        tempwrapsec.PISectionList = sec;
                        tempwrapsec.WrapperList = tempwrapperclass ;
                        tempwrapsec.title = sec.Question__c;
                        if(tempwrapsec != NULL)
                        tempwrrapersection.add(tempwrapsec);
                    }//end of if
                } //loop section end
            }//loop Topsection end
            
            BX041__c ds = BX041__c.getInstance(topSec.Record_Type__c);
            tempTopSection.SectionName = ds.section_name__c;
            tempTopSection.recordType = topSec.Record_Type__c;       
            tempTopSection.AllWrapperSection  = tempwrrapersection;            
            tempTopSection.shortName =  ds.Short_Name__c;  
            
            //visibility of sections is setting here  
            if(topSec.Record_Type__c == Label.QM_RT_PI && bx041.Need_MEMS_informaton__c) {
                    tempTopSection.visible = false;
            } else if(topSec.Record_Type__c == Label.QM_RT_PI && bx041.Need_MEMS_informaton__c == false) {
                 tempTopSection.visible = true;
            }else if(topSec.Record_Type__c == Label.QM_RT_GA && isCustomer == false){//Tlai 16072014, hide Gap to Customer
                 tempTopSection.visible = true;
            }
            else {
                //BX041__c ds = BX041__c.getInstance(topSec.record_type__c);
                if(ds.Need_Name__c != null)
                tempTopSection.visible = Boolean.valueOf(bx041.get(ds.Need_Name__c));
            }
            
            WrapperTopSectionList.add(tempTopSection); //final wrapper list ready to display in the page. 
        }
        
        //visibility of IP section is controller through displayIpKit() method
        //if(bx041.Need_IP_information__c){
            displayIpKit();
        //}
        //visibility of IP section is controller through displayIpmKit() method
        //if(bx041.Need_IP_Merge_information__c){
            displayIpmKit();
        //}
        /*****retrieving queue information*****/
        if( bx041.BX_041_Status__c == 'Pending Review' && bx041.Next_WorkItem_Id__c != NULL && bx041.device__r.Tapeout_Type__c == 'GlobalShuttle MPW'){
            string seq = '';
            if(bx041.device__r.fab__c == 'FAB 1'){
                seq = '1';
            }else if (bx041.device__r.fab__c == 'FAB 8'){
                seq = '8';
            }
            
            QueueName = 'BX041 CE-FAB' + seq +' Approver Queue';  
        
        }else if(bx041.BX_041_Status__c == 'Pending Submission' && bx041.Next_WorkItem_Id__c != NULL){
            QueueName = 'BX041 FAE-'+ bx041.Device__r.Account__r.Region__c +' Approver Queue';
        
        }
        
        if(!String.isEmpty(QueueName)){
            list<group> queueIdList = [select id from group where name = :QueueName];
            if(!queueIdList.isEmpty()){
                queueId = queueIdList[0].id;
            }
        }
        
        //Added by Vijay 02132015
        isInternalDevice = false;
        if(bx041.Device__r.RecordType.DeveloperName != null && (bx041.Device__r.RecordType.DeveloperName == 'Internal_Device'  ||
            bx041.Device__r.RecordType.DeveloperName == 'Internal_Device_Read_Only')){
            isInternalDevice = true;        
        }
        
    }// constructor BX041_Edit ends here 
    
    
    /****************************************  Main Methods Start  ***************************************/
    private boolean validatedAssignedPID(id deviceId, id processId){
        boolean result = true;
        for(Assigned_Process__c ap: [select id, device__c, process__c, primary_process__c from Assigned_Process__c where device__c = :deviceId]){
            if(processId == ap.process__c && ap.primary_process__c == false)  result = false;
               
        }
        return result;
    }
    /******************************************************************************************************
    @Method Name:    updatebx041
    @Return Type:    pagereference (returning to BX041 view page)
    @parameter:      NA
    @Reason:         This method updates BX041 changes along with its child objects data.
    *******************************************************************************************************/     
    public pagereference updatebx041(){ // update method start
        //Savepoint sp = Database.setSavepoint(); //savepoint to rollback in case of any error.
        if(bx041.BX_041_Status__c == 'Closed'){
            update bx041;
            //retruning to view page on updating BX041 record.
            Pagereference pf = new pagereference ('/'+bx041.id);
            pf.setRedirect(true);
            return pf;//retun page reference of the view page.
        }
        ChangeSections = new Set<String>();
        updatesobject = new List<Sobject>();
        if(bx041.Assigned_Process_ID__c != null && bx041.Assigned_Process_ID__c != prevAssignedPID && !validatedAssignedPID(bx041.device__c, bx041.Assigned_Process_ID__c)){
            addMessage('Selected Assigned PID has already been added, please select another PID.');return null;
            
        }
        //Check: whether the process ID is known to the customer and reference process ID is balnk.
        if(bx041.Process_ID_is_known__c == 'Yes' && bx041.Reference_Process_ID_txt__c == NULL){
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'Please provide reference Process ID'));return null;
            
        }
        //if the user provide reference process ID and it matchs with the master process id then, 
        //requested process ID should be populated
        if(bx041.Reference_Process_ID_txt__c != NULL){
            ID processid ;
            for(process__c  pc:  [SELECT ID, name FROM process__c WHERE name = :bx041.Reference_Process_ID_txt__c AND Process_Family__c = :bx041.Process_Family_Filter__c and Tech_Geometry__c =: bx041.Geometry_Filter__c]){
                processid = pc.id;
            }
            if(processid != NULL){
                bx041.Requested_Process_ID__c = processid;
                onchangePopulateFEComments();
            }
            
        }
        
        for(TopSectionWrapper tswrap : WrapperTopSectionList ){//loop wrapper topsection start
            //=============================Process Information block start================================//
            if(tswrap.recordType == Label.QM_RT_PI){ 
                BX041__c instance = BX041__c.getInstance(tswrap.recordType);
                for(SectionWrapper ws: tswrap.AllWrapperSection){//loop wrapper section start               
                    for(RowWrapper wc: ws.WrapperList){ //loop wrapper row/question start                        
                        
                        Process_Information__c temppi = (Process_Information__c )mapSobjectData.get(instance.SObject_Type__c).get(wc.metadataid);
                        system.debug(logginglevel.error,temppi.Customer_Comment__c);
                        //this is used to save the change information in the BX041 header lavel. Data will be used in the mail notification.
                        if(ChangeSections.contains(tswrap.SectionName) == false && bx041.Approval_Step__c != ''){
                            if(temppi.Customer_Comment__c != wc.Comments || temppi.Customer_Request__c != wc.value || temppi.FE_Requested_Information__c != wc.FEinfo 
                            ||temppi.PIYE__c != wc.piyeinfo || temppi.Requirement_Gaps__c != wc.reqGap || temppi.Comments__c != wc.intlCmt){
                                ChangeSections.add(tswrap.SectionName);    
                            }    
                        }
                        //setting data for process information section only.                 
                        temppi.Customer_Comment__c =         wc.custcomment;        
                        temppi.Customer_Request__c =         wc.value ; 
                        temppi.FE_Requested_Information__c = wc.FEinfo ;
                        temppi.PIYE__c =                     wc.piyeinfo;   
                        temppi.Question__c =                 wc.question ;
                        temppi.Question_to_Display__c =      wc.question ;
                        temppi.Requirement_Gaps__c =         wc.reqGap;
                        temppi.Comments__c =                 wc.intlCmt;
                        temppi.mandatory__c =                wc.mandatory;
                        updatesobject.add(temppi);
                    }//loop wrapper row/question end
                }//loop wrapper section end
            }
            //=============================Process Information block end================================//
            
            //=============================GAP analysis block start================================//
            else if(tswrap.recordType == Label.QM_RT_GA){
                BX041__c instance = BX041__c.getInstance(tswrap.recordType);
                for(SectionWrapper wsga : tswrap.AllWrapperSection){ //loop wrapper section start                   
                    for(RowWrapper wc :   wsga.WrapperList ){//loop wrapper row/question start                        
                        Gap_Analysis_Form__c tempga = (Gap_Analysis_Form__c ) mapSobjectData.get(instance.SObject_Type__c).get(wc.metadataid);
                        //this is used to save the change information in the BX041 header lavel. Data will be used in the mail notification.
                        if(ChangeSections.contains(tswrap.SectionName) == false && bx041.Approval_Step__c != ''){
                            if(tempga.Gap_Name__c != wc.question || tempga.APTS_Status__c != wc.value || tempga.APTS_Resolution__c != wc.value
                            ||tempga.APTS_Comments__c != wc.custcomment){
                                ChangeSections.add(tswrap.SectionName);    
                            }    
                        }
                        
                        //setting data for GAP Analysis section only.                 
                        tempga.Gap_Name__c =         wc.question;
                        tempga.APTS_Status__c =      wc.value;
                        tempga.APTS_Resolution__c =  wc.GAResolution;
                        tempga.APTS_Comments__c =    wc.custcomment;
                        
                        if(wc.question == 'IP QA Status'){
                            if(tempga.APTS_Status__c == 'Closed' && ipSectionChanged == false && ipmSectionChanged == false){
                                //do nothing    
                            }else {
                                String ipNo = getGapIP(ipwList, ipmList);
                                if(ipNo != null){
                                        tempga.APTS_Status__c = 'Yes';
                                        tempga.APTS_Comments__c = ipNo;
                                } else{
                                    if(wc.value == 'None'){
                                        tempga.APTS_Status__c  = 'No Gap/NA';
                                    }
                                     tempga.APTS_Comments__c = '';
                                }
                            }
                            
                        }
                        updatesobject.add(tempga);
                    }//loop wrapper row/question end
                }  //loop wrapper section end  
            }
            //=============================GAP analysis block end================================//
            
            //=============================Other sections block start================================//
            else{
                BX041__c instance = BX041__c.getInstance(tswrap.recordType);  
                for(SectionWrapper wsga : tswrap.AllWrapperSection){//loop wrapper section start                    
                    for(RowWrapper wc :   wsga.WrapperList ){//loop wrapper row/question start                        
                        if(instance != null && wc.question != null && mapSobjectData.get(instance.SObject_Type__c) != null){
                            sobject sobjct =  mapSobjectData.get(instance.SObject_Type__c).get(wc.metadataid);
                            if(sobjct != NULL && sobjct.get(instance.api_name__c) != null){
                                //this is used to save the change information in the BX041 header lavel. Data will be used in the mail notification.
                                if(ChangeSections.contains(tswrap.SectionName) == false && bx041.Approval_Step__c != ''){
                                    if(sobjct.get(instance.API_Name__c) != wc.question || sobjct.get(instance.getValue__c ) != wc.value  ){
                                        ChangeSections.add(tswrap.SectionName);    
                                    }    
                                }
                                
                                //setting data for Other section only.                 
                                sobjct.put(instance.API_Name__c , wc.question );
                                sobjct.put(instance.getValue__c , wc.value );
                                updatesobject.add(sobjct);
                            }
                        }
                    }//loop wrapper row/question end
                } //loop wrapper section end 
            }
            //=============================Other sections block end================================//
        }
        
        //============================== Block to record change in the row level start ================================//
        if(ChangeSections.size()>0){
            string changedSectionStr = '';
            for(String secName : ChangeSections){
                if(changedSectionStr == ''){
                    changedSectionStr= secName;
                }
                else{
                    changedSectionStr = changedSectionStr + ',' + secName; //section name will be added with comma separated value in the BX041 header section.
                }
            }
            bx041.Change_Infomation_Details__c = changedSectionStr;
        }
        
        //============================== Block to record change in the row level end ================================//
        
        if(bx041.Need_IP_Merge_information__c){
            if(!saveIpmKit()){
                return null;
            }
        }
        
        //============================Saving/updating BX041 and its child records start ============================//
        try{
            if(bx041.Die_Size_X_mm__c == 0 ) bx041.Die_Size_X_mm__c = null;
            if(bx041.Die_Size_Y_mm__c == 0 ) bx041.Die_Size_Y_mm__c = null;
            update bx041;
            update updatesobject;
        }
        
        catch(exception ex){addMessage(ex.getMessage());return null;
            
            //database.rollback(sp); //roll back in case of exception
            
        }        
        //============================Saving/updating BX041 and its child records end ============================//
        
        
        //retruning to view page on updating BX041 record.
        Pagereference pf = new pagereference ('/'+bx041.id);
        pf.setRedirect(true);
        return pf;//retun page reference of the view page.
    }//end of updatebx041 methods
    
    
    public pagereference reopen(){
        //ProcessInstanceWorkitem workItem = [SELECT Id FROM ProcessInstanceWorkitem where processInstance.targetObjectId = :bx041.id];
        if(bx041.Next_WorkItem_Id__c != null){
            BX041ApprovalHelper helper = new BX041ApprovalHelper(); 
            helper.recallReq(bx041, comment);
            bx041.Next_WorkItem_Id__c = null;
        }
        if(bx041.Assigned_Process_ID__c != null){
            list<Process_Information__c> piList = new list<Process_Information__c>();
            for(Process_Information__c pi: [select id,PIYE__c from Process_Information__c where BX_041__c = : bx041.id]){
                pi.PIYE__c = null;
                piList.add(pi);
            }
            if(piList.size() > 0)
                update piList;
                
            bx041.Assigned_Process_ID__c = null;
        }
        
        bx041.Approver_1__c = null;
        bx041.Approver_2__c = null;
        bx041.Approver_3__c = null;
        bx041.Approver_4__c = null;
        bx041.Approver_5__c = null;
        bx041.Approver_6__c = null;
        bx041.Approver_7__c = null;
        bx041.Approver_8__c = null;
        bx041.Approver_9__c = null;
        bx041.Approver_10__c = null;
        
        bx041.Gap_Closed__c = false;
        bx041.BX_041_Status__c = 'Pending Submission';
        if(!isInternalDevice){
            bx041.Approval_Step__c = 'Pending for FAE/FTS';
            bx041.Approval_Status__c = 'Approved by FAE/FTS' ;
        }else{
            bx041.Approval_Step__c = '';
            bx041.Approval_Status__c = '';
        }
            
        update bx041;
        
        
        //bx041.initial_submitter__c = null;
        //bx041.Next_WorkItem_Id__c = null;
        Pagereference pf = new pagereference ('/'+bx041.id);
        pf.setRedirect(true);
        return pf;
    }
    
    /* =============================================  Main Methods End  ============================================= */
    
    /* =============================================  Helper Methods Start  ============================================= */
    private String getGapIP(List<Bx041IpWrapper> ipList,List<BX041_IP_Merge__c> ipmList){
        String result = '';
        if(bx041.need_ip_information__c){
            set<id> ipSet  = new set<id>();
            for(Bx041IpWrapper ipw : ipList){
                if(ipw.bx041Ip.IP_Master__c != null){
                    ipSet.add(ipw.bx041Ip.IP_Master__c);
                }
            }
            if(ipSet.size() > 0){
                list<IP__c> ipResult = [select name from IP__c where id in :ipSet and PH1_QA_Status__c = 'NCR' and Showstopper__c = 'Yes' ];
                 if( !ipResult.isEmpty()) {
                    for(IP__c ip : ipResult){
                        result = result + ip.name+',';
                    }
                }
                
            }
            
        }
        
        if(bx041.need_ip_merge_information__c){
            set<id> ipSet  = new set<id>();
            for(BX041_IP_Merge__c ipm : ipmList){
                if(ipm.IP_Master__c != null){
                    ipSet.add(ipm.IP_Master__c);
                }
            }
            
            if(ipSet.size() > 0){
                list<IP_Merge__c> ipmResult = [select name from IP_Merge__c where id in :ipSet and PH1_QA_Status__c = 'NCR' and Showstopper__c = 'Yes'];
                 if( !ipmResult.isEmpty()) {
                    for(IP_Merge__c ipm : ipmResult){
                        result = result + ipm.name+',';
                    }
                }
            }
            
        }
        
        if(result != ''){
            return result.removeEnd(',');
        }else
            return null;
        
    }
    
    /******************************************************************************************************
    @Method Name:    closepopup
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method is used to closed pop up window.
    *******************************************************************************************************/      
    public void closepopup() {        
        backtrackwindow = false;    
        piyeApprSelectionWindow = false;
    } //end of closepopup() method.
    
    /******************************************************************************************************
    @Method Name:    backtrack
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method is used to display the popup window of backtrack closed BX041 record.
    *******************************************************************************************************/
    public void backtrack(){
        //TASK-446 : Should have validation to restrict closed CDRS from backtrack if Current Forecast Tapeout date is past
        system.debug('$$$$$'+ bx041.device__r.Current_Forecast_Tapeout_Date__c + '  ' + system.today());
        if(bx041.BX_041_Status__c == 'Closed' && bx041.device__r.Current_Forecast_Tapeout_Date__c < system.today()){
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'Backtrack is not allow for Closed CDRS form with Current Forecast Tapeout Date in the past'));  return ;
           
        }
        
        backtrackwindow = true;
        BackTrackSelectOption = new List<SelectOption>();
        BackTrackSelectOption.add(new SelectOption('Backtrack to FTS','Backtrack to FTS'));
        BackTrackSelectOption.add(new SelectOption('Backtrack to CE','Backtrack to CE'));
        
    }//end of backtrack() method.
    
    /******************************************************************************************************
    @Method Name:    showPIPdf
    @Return Type:    pagereference of the BX041_ProcessInfoPDF page.
    @parameter:      NA
    @Reason:         This method is used to view the process information in PDF format
    *******************************************************************************************************/
    public pagereference showPIPdf(){
        return new pagereference ('/apex/BX041_ProcessInfoPDF?id='+bx041ID);
    }//end of showPIPdf() method.
    
    /******************************************************************************************************
    @Method Name:    cancelbx
    @Return Type:    pagereference of the device detail page.
    @parameter:      NA
    @Reason:         This method is used to retun the pagereference of the device detail page. 
    *******************************************************************************************************/
    public pagereference cancelbx(){
        return(new pagereference('/'+bx041.device__c));
    }//end of cancelbx() method.
    
    /******************************************************************************************************
    @Method Name:    cancelEditbx
    @Return Type:    pagereference of the BX041 view page.
    @parameter:      NA
    @Reason:         This method is used to retun the pagereference of the BX041 view page. 
    *******************************************************************************************************/
    public pagereference cancelEditbx(){
        return(new pagereference('/'+bx041Id));
    }//end of the cancelEditbx() method.
    
    /******************************************************************************************************
    @Method Name:    onchangePopulateFEComments
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method is used to populate the FE comments in the process information section on  
                     change the Requested process ID in the BX041 header level.
    *******************************************************************************************************/
    public void onchangePopulateFEComments(){
       //mapFEndPIYE = pihandler.FEandPIYEValue(bx041.Requested_Process_ID__c); // By Thomas 201308221415
       if(bx041.Requested_Process_ID__c != null){
           Map<String,String> mapFE = ProcessInformationHandler.getProcessQuestions(bx041.Requested_Process_ID__c);
           for(TopSectionWrapper wts : WrapperTopSectionList ){//start of the top section wrapper
               if(wts.recordType == Label.QM_RT_PI){               
                   for(SectionWrapper ws : wts.AllWrapperSection  ){//start of the section wrapper
                       for(RowWrapper wc : ws.WrapperList ){   //start of the row wrapper                    
                           if(mapFE.get(wc.metadataid) != NULL){ //if the process record contains data for a particular question.
                               wc.FEinfo = mapFE.get(wc.metadataid);
                               wc.editfe = false; //FE section should not be editable for the particualar question.
                           }
                           else{//if the process record does not contain data for a particular question.
                               if(  wc.metadataid != null && 
                                    mapSobjectData.get('Process_Information__c') != null &&
                                    mapSobjectData.get('Process_Information__c').get(wc.metadataid) != null &&
                                    string.valueOf(mapSobjectData.get('Process_Information__c').get(wc.metadataid).get('FE_Requested_Information__c')) != null){
                                    //get the value if user has already set some value of a particular question
                                    wc.FEinfo = string.valueOf(mapSobjectData.get('Process_Information__c').get(wc.metadataid).get('FE_Requested_Information__c'));
                                    wc.editfe = true;
                                }
                                else{//if no value is available in the process record and user input is not available for a question.
                                    wc.FEinfo = '';
                                    wc.editfe = true;    
                                }
                           }
                       }//end of the row wrapper.
                   }//end of the section wrapper.
                   break;
               }
           }//end of topsection wrapper
       }
       else{//if requested process ID is null
           for(TopSectionWrapper wts : WrapperTopSectionList ){//start of the top section wrapper
               if(wts.recordType == Label.QM_RT_PI){               
                   for(SectionWrapper ws : wts.AllWrapperSection  ){//start of the section wrapper
                       for(RowWrapper wc : ws.WrapperList ){   //start of the row wrapper                    
                            wc.FEinfo = '';
                            wc.editfe = true;    
                           
                       }//end of the row wrapper.
                   }//end of the section wrapper.
                   break;
               }
           }//end of topsection wrapper
       }
            
    }//end of onchangePopulateFEComments method.
    
    /******************************************************************************************************
    @Method Name:    onchangePopulatePIYEComments
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method is used to populate the PIYE comments in the process information section on  
                     change the assigned process ID in the BX041 header level.
    *******************************************************************************************************/
    public void onchangePopulatePIYEComments(){
        //mapFEndPIYE = pihandler.FEandPIYEValue(bx041.Assigned_Process_ID__c); // By Thomas 201308221415
        if(bx041.Assigned_Process_ID__c != null){
            if(bx041.Assigned_Process_ID__c != prevAssignedPID && !validatedAssignedPID(bx041.device__c, bx041.Assigned_Process_ID__c)){
                addMessage('Selected Assigned PID has already been added, please select another PID.');return;
                
            }
            Map<String,String> mapPIYE = ProcessInformationHandler.getProcessQuestions(bx041.Assigned_Process_ID__c);
            for(TopSectionWrapper wts : WrapperTopSectionList ){//start of the top section wrapper
                if(wts.recordType == Label.QM_RT_PI){               
                    for(SectionWrapper ws : wts.AllWrapperSection  ){//start of the section wrapper
                        for(RowWrapper wc : ws.WrapperList ){ //start of the row wrapper                                          
                            if(mapPIYE.get(wc.metadataid) != NULL){ //if the process record contains data for a particular 
                                wc.PiyeInfo = mapPIYE.get(wc.metadataid);
                                wc.editpiye = false;//PIYE section should not be editable for the particualar question.
                            }
                            else{ //if the process record does not contain data for a particular question.
                                if(  
                                    wc.metadataid != null && 
                                    mapSobjectData.get('Process_Information__c') != null &&
                                    mapSobjectData.get('Process_Information__c').get(wc.metadataid) != null &&
                                    string.valueOf(mapSobjectData.get('Process_Information__c').get(wc.metadataid).get('PIYE__c')) != null){
                                    //get the value if user has already set some value of a particular question
                                    wc.PiyeInfo = string.valueOf(mapSobjectData.get('Process_Information__c').get(wc.metadataid).get('PIYE__c'));
                                    wc.editpiye = true;
                                }
                                else{//if no value is available in the process record and user input is not available for a question.
                                    wc.PiyeInfo = '';
                                    wc.editpiye = true;    
                                }
                            }
                        }//end of the row wrapper.
                    }//end of the section wrapper.
                    break;
                }
            }//end of topsection wrapper
        }
        else{//if assigned process ID is null
           for(TopSectionWrapper wts : WrapperTopSectionList ){//start of the top section wrapper
               if(wts.recordType == Label.QM_RT_PI){               
                   for(SectionWrapper ws : wts.AllWrapperSection  ){//start of the section wrapper
                       for(RowWrapper wc : ws.WrapperList ){   //start of the row wrapper                    
                            wc.PiyeInfo = '';
                            wc.editpiye = true;    
                           
                       }//end of the row wrapper.
                   }//end of the section wrapper.
                   break;
               }
           }//end of topsection wrapper
       }
    }//end of onchangePopulatePIYEComments method.
    
    /******************************************************************************************************
    @Method Name:    getFields
    @Return Type:    List<Schema.FieldSetMember>
    @parameter:      NA
    @Reason:         This method is used to get the API name of the field used in the additional information section
    *******************************************************************************************************/
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.BX_041__c.FieldSets.CDRS_Addition_Information.getFields();
    }
    
    
    /******************************************************************************************************
    @Method Name:    exportToExcel
    @Return Type:    PageReference of the VF_ProcessInfoExcel page.
    @parameter:      NA
    @Reason:         export to excel - returns a page reference to the VF_ProcessInfoExcel page
    *******************************************************************************************************/    
    public PageReference exportToExcel(){
        return new pagereference ('/apex/BX041_ProcessInfoExcel?id='+bx041ID);
    }//end of exportToExcel method.
    
    /******************************************************************************************************
    @Method Name:    editbx
    @Return Type:    PageReference of the BX041 edit page.
    @parameter:      NA
    @Reason:         returns a page reference to the BX041 edit page
    *******************************************************************************************************/   
    public pageReference editbx(){
        return new pagereference ('/'+bx041ID+'/e');
    }//end of editbx method.
    
    /******************************************************************************************************
    @Method Name:    validateMandatoryData
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method validates whether all the mandatory fields have been filled up on view page
    *******************************************************************************************************/              
    public String validateMandatoryData(){
        //boolean result = true;
        String resultMsg = '';
        for(Process_Information__c pi : [SELECT id, 
                                                mandatory__c,
                                                Customer_Request__c,
                                                FE_Requested_Information__c, 
                                                Question_Metadata__r.Question__c
                                        from Process_Information__c 
                                        where BX_041__c =:bx041ID 
                                            and Mandatory__c = True]){
            if(pi.mandatory__c){
                if((String.isEmpty(pi.Customer_Request__c)|| pi.Customer_request__c == 'None' ) && String.isEmpty(pi.FE_Requested_Information__c)){
                    resultMsg = resultMsg + '<br>'+ pi.Question_Metadata__r.Question__c;
                    //result = false;
                }
            }
        } 
        return resultMsg;
    }//end of validateMandatoryData method.
    
    
    /* =============================================  Helper Methods End ============================================= */
    
    
    /* =============================================  BX041 IP and IP Merge Start ================================================= */
    public List<Bx041IpWrapper> ipwList {get; set;}
    public Bx041IpWrapper currentIP {get; set;}
    public boolean  displayPopup {get; set;}
    //**********BX041IPWrapper declaration************//
    public class Bx041IpWrapper {
        public BX041_IP__c bx041Ip {get; set;}
        public String stepNo {get; set;}
        public String ipMaster {get; set;}
        public boolean isNew {get; set;}
        public integer index {get; set;}
        public boolean isSpecial {get; set;} // linked IP design kit has the conditions (PH1 QA Status = 'NCR' && showstopper = 'Yes')
        public Bx041IpWrapper(BX041_IP__c ip, Boolean newflag){
            if(newflag){
                isNew = true;
                stepNo = '0';
            }else {
                isNew = false;
                stepNo = '3';
            }
            bx041Ip = ip;
            isSpecial = false;
            //bx041Ip.bx_041__c = bx041.id;
        }
    }//end of wrapper declaration
    
    /******************************************************************************************************
    @Method Name:    addIpm
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Add new IP merge record in the wrapper list.
    *******************************************************************************************************/   
    public void addIpm(){
        if(ipmList == null)ipmList = new List<BX041_IP_Merge__c>();
            
        ipmList.add(new BX041_IP_Merge__c(IP_Master__c = null,BX_041__c = bx041ID));
    }//end of addIpm method.
    
    /******************************************************************************************************
    @Method Name:    remIpm
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Remove IP merge record from the wrapper list.
    *******************************************************************************************************/ 
    //public string removedIPName ;   
    public void remIpm(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipmSeq'));
        BX041_IP_Merge__c ipm = ipmList[ipSeq];
        system.debug('remipm ' + ipSeq);
        if(ipm.id != null){ delete ipm;}
        
        ipmList.remove(ipSeq);
    }//end of remIpm method.
    
    /******************************************************************************************************
    @Method Name:    saveIpmKit
    @Return Type:    Boolean: true = NO duplicate IP merge record
                              false = Duplicate IP merge record.
    @parameter:      NA
    @Reason:         Save IP merge record.
    *******************************************************************************************************/   
    public boolean saveIpmKit(){
        //decalre local variable.
        List<BX041_IP_Merge__c> updateipm = new List<BX041_IP_Merge__c>(); 
        List<BX041_IP_Merge__c> insertipm = new List<BX041_IP_Merge__c>();
        List<BX041_IP_Merge__c> deleteipm = new List<BX041_IP_Merge__c>();
        set<id> ipmIdSet = new set<id>();
        boolean result = true;
        set<id> ipMasterSet = new set<id>();
        
        for(BX041_IP_Merge__c ipm : ipmList){            
            if(ipm.IP_Master__c != null){
                if(ipMasterSet.contains(ipm.IP_Master__c)){ // if IP merge record is already there in the BX041.
                    result = false;
                    ip_merge__c dupIpm = [select name from ip_merge__c where id = : ipm.IP_Master__c];
                    addMessage('Duplicate CDRS IP Merge - ' + dupIpm.name);
                    continue;
                }                
                if(ipm.id == NULL){
                    insertipm.add(ipm);
                    ipmIdSet.add(ipm.IP_Master__c);
                }
                else {
                    updateipm.add(ipm);
                    system.debug('testing PHQA ' + ipmOldMap.get(ipm.id).remarks__c + '-' + ipm.remarks__c + '-' + ipmOldMap.get(ipm.id).IP_Master__c + '-' + ipm.IP_Master__c);
                    system.debug(ipmOldMap.containsKey(ipm.id) && (ipmOldMap.get(ipm.id).remarks__c != ipm.remarks__c|| ipmOldMap.get(ipm.id).IP_Master__c != ipm.IP_Master__c));
                    if(ipmOldMap.containsKey(ipm.id) && (ipmOldMap.get(ipm.id).remarks__c != ipm.remarks__c|| ipmOldMap.get(ipm.id).IP_Master__c != ipm.IP_Master__c)){
                        ipmIdSet.add(ipm.IP_Master__c);
                    }
                }
                ipMasterSet.add(ipm.IP_Master__c);
             }else if(!String.isEmpty(ipm.remarks__c)){
                if(ipm.id == NULL){insertipm.add(ipm);}
                    
                else { updateipm.add(ipm); }
            }else{
                if(ipm.id != NULL){deleteipm.add(ipm);}
                    
            }
        }
        system.debug('testing PHQA1 ' + ipmIdSet.size());
        if(ipmIdSet.size()>0){
            Integer num = [select count()
                                            from IP_Merge__c 
                                            where id in : ipmIdSet
                                                and Showstopper__c = 'Yes'
                                                and PH1_QA_Status__c = 'NCR'
            ];
            system.debug('testing PHQA2 ' + num);
            if(num > 0){
                ipmSectionChanged = true;
                system.debug('testing PHQA3 ' + ipmSectionChanged);
            }
        }
        if(updateipm.size()>0) update updateipm; //update existing records.
            
        if(insertipm.size()>0) insert insertipm; //insert new BX041 IP merge records.

        if(deleteipm.size() >0) delete deleteipm;

        return result;
    }//end of saveIpmKit method.
    
    /******************************************************************************************************
    @Method Name:    addIp
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Add new IP record in the wrapper list.
    *******************************************************************************************************/   
    public void addIp(){
        if(ipwList == null)  ipwList = new List<Bx041IpWrapper>();
        currentIP = new Bx041IpWrapper(new BX041_IP__c(),true);
        currentIp.bx041Ip.BX_041__c = bx041.id;
        currentIP.bx041Ip.id = null;
        ipwList.add(currentIP); 
        currentIp.stepNo = '0';
        addNewIP = false;
        iptypevalue = '';
    }//end of addIp method.
    
    /******************************************************************************************************
    @Method Name:    remIp
    @Return Type:    NA
    @parameter:      NA
    @Reason:         remove IP record from the wrapper list.
    *******************************************************************************************************/   
    public void remIp(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        BX041_IP__c ip = ipwList[ipSeq].bx041Ip;
        if(ip.id != null){  delete ip;
           
        }else{ addNewIP = true; }
        /*
        if(ipwList[ipSeq].isSpecial == true){
            ipSectionChanged = true;
        }*/
        ipwList.remove(ipSeq);
        currentIp = null;
        
        if(ipwList.size() == 0){addNewIP = true;}
            
    }//end of remIp  method.
   
    /******************************************************************************************************
    @Method Name:    onchangePopulateIP
    @Return Type:    NA
    @parameter:      NA
    @Reason:         ON change master IP, one pop up window will open to add different field information 
                     regarding the IP.
    *******************************************************************************************************/          
    public void onchangePopulateIP(){     
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];
        
        if(currentIP.bx041Ip.IP_Master__c == null){return;}
        
        //validate duplicate IP
        for( integer i=0; i< ipwList.size();i++){
            if(i == ipSeq){
                continue;
            }
            Bx041IpWrapper ipw  = ipwList[i];
            if(ipw.bx041Ip.IP_Master__c == currentIP.bx041Ip.IP_Master__c){
                addMessage('Duplicate IP Design Kit selected :' + ipw.ipMaster);
                currentIP.bx041Ip.IP_Master__c = null;
                return;
            }
        }
        
        IP__c ipDesignKit = [select PH1_QA_Status__c, Showstopper__c, id,name,IP_Type__c,IP_Technology__c,Lifecycle__c,Latest_Version__c,Library_Name__c,IP_Device_List__c,IP_Type_Category__c,IP_Vendor__c from IP__c where id = :currentIP.bx041Ip.IP_Master__c];
        currentIP.bx041Ip.IP_CATG__c = ipDesignKit.IP_Type_Category__c;
        currentIP.bx041Ip.Version__c = ipDesignKit.Latest_Version__c;
        currentIP.bx041Ip.Lib_Nm__c = ipDesignKit.Library_Name__c;
        currentIP.bx041Ip.Vendor__c  = ipDesignKit.IP_Vendor__c;
        currentIP.bx041Ip.IP_Device_List__c = ipDesignKit.IP_Device_List__c;
        currentIP.ipMaster = ipDesignKit.name;
        
        displayPopUp = true;
        currentIp.stepNo = '2';
        if(ipDesignKit.PH1_QA_Status__c == 'NCR' && ipDesignKit.Showstopper__c == 'Yes'){
            currentIP.isSpecial = true;
        }
 
    }//end of  onchangePopulateIP method.
    
    /******************************************************************************************************
    @Method Name:    onchangeIPType
    @Return Type:    NA
    @parameter:      NA
    @Reason:         ON change of IP type in the IP Type Dropdown list in CDRS IP Section only when creation on CDRS IP 
    *******************************************************************************************************/             
    public void onchangeIPType(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];
        iptypevalue = currentIP.bx041Ip.IP_Type__c;
        currentIp.stepNo = '1';
    }//end of onchangeIPType method.
    
    /******************************************************************************************************
    @Method Name:    editIp
    @Return Type:    NA
    @parameter:      NA
    @Reason:         edit IP record.
    *******************************************************************************************************/             
    public void editIp(){
        
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];        
        displayPopup = true;
    }//end of editIP method.
    
    /******************************************************************************************************
    @Method Name:    addMessage
    @Return Type:    NA
    @parameter:      NA
    @Reason:         used to add error meggage.
    *******************************************************************************************************/             
    private void addMessage(String msg){
        Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, msg));
    }//end of addMessage method.
    
    /******************************************************************************************************
    @Method Name:    saveIP
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Save IP record w/o IP Master populated
    *******************************************************************************************************/
               
    public void saveIP(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];
                
        if(currentIP.isNew){           
            currentIP.bx041Ip.id = null;            
            insert currentIP.bx041Ip;
            currentIp.stepNo = '3';
            currentIp.isNew = false;
            addNewIP = true;
        }
        
    }//end of saveIP method.
    
    /******************************************************************************************************
    @Method Name:    saveIpPopup
    @Return Type:    NA
    @parameter:      NA
    @Reason:         save the value inserted by the user in the pop up window.
    *******************************************************************************************************/             
    public void saveIpPopup() {
        if(currentIP.isNew){
            currentIP.bx041Ip.id = null;
            insert currentIP.bx041Ip;
        }else{
            update currentIP.bx041Ip;
        }
        
        
        displayPopup = false;
        if(currentIp.isNew){
            currentIp.isNew = false;
            addNewIP = true;
            currentIp.stepNo = '3';
        }
        
        if(currentIP.isSpecial == true){
            ipSectionChanged = true;
        }
        
    }// end of saveIpPopup method.
    
    /******************************************************************************************************
    @Method Name:    cancelIpPopup
    @Return Type:    NA
    @parameter:      NA
    @Reason:         used to cancel IP pop up window. 
                         if it is closed from the edit IP window, no value should be changed   
                         if it is closed from the Create IP window, no value should be saved.
    *******************************************************************************************************/             
    public void cancelIpPopup() {
        //reset the value
        displayPopup = false;
        if(currentIp.isNew){
            //In case of new IP the record would be removed from BX041 record.
            //Only one record is new in the list
            for(integer i = 0; i< ipwList.size(); i++){
                if(ipwList[i].isNew){
                    ipwList.remove(i);
                    break;
                }
            }
            addNewIP = true;
        }
    }
    
    /******************************************************************************************************
    @Method Name:    getDynamicComp
    @Return Type:    Component.Apex.PageBlockSection
    @parameter:      NA 
    @Reason:         get Dynamic field set for different IP type.
    *******************************************************************************************************/             
    public Component.Apex.PageBlockSection getDynamicComp(){
        Component.Apex.PageBlockSection pbs = new Component.Apex.PageBlockSection();
        
        if(!displayPopup) {
            pbs.rendered = false;
        } else {            
            pbs.title = currentIP.bx041Ip.IP_Type__c;
            pbs.rendered = true;
            Component.Apex.outputField ipType = new Component.Apex.outputField();
            ipType.expressions.value = '{!currentIP.bx041Ip.IP_Type__c}';            
            /*Component.Apex.ActionSupport ipTypeSpt = new Component.Apex.ActionSupport();
            ipTypeSpt.expressions.action = '{!onchangeIPType}';
            ipTypeSpt.event = 'onchange';
            ipTypeSpt.status = 'blockUI';
            ipTypeSpt.rerender = new set<string>{'ipdetail'};
            ipType.childcomponents.add(ipTypeSpt);*/
            pbs.childcomponents.add(ipType);           
            BX041IP__c dsCommon = BX041IP__c.getInstance('Common');
            String fieldList = dsCommon.Field_List__c;            
            String ipTypeUpperCase = pbs.title.toUpperCase();
            BX041IP__c spec = BX041IP__c.getInstance(ipTypeUpperCase);
            //BX041IP__c spec = BX041IP__c.getInstance(pbs.title);
            if(spec != null && (!String.isEmpty(spec.Field_List__c))){
                fieldList = fieldList + ','+ spec.Field_List__c;
                if(!String.isEmpty(spec.Field_List2__c)){
                    fieldList = fieldList + ','+ spec.Field_List2__c;
                }
            }
             
            for(String fieldName : fieldList.split(',')){
                    Component.Apex.InputField inf = new Component.Apex.InputField();
                    inf.expressions.value = '{!currentIP.bx041Ip.'+ fieldName.trim() + '}';
                    pbs.childcomponents.add(inf);
            }
            
        }
        return pbs;
    }//end of getDynamicComp method.
    
    /******************************************************************************************************
    @Method Name:    displayIpmKit
    @Return Type:    NA
    @parameter:      NA
    @Reason:         To display IP merge information in the BX041 form.
    *******************************************************************************************************/             
    private void displayIpmKit(){
        ipmList = new list<BX041_IP_Merge__c>();
        ipmOldMap = new map<id, BX041_IP_Merge__c>();
        for(BX041_IP_Merge__c ipm : [SELECT id,
                          IP_Master__c,
                          Remarks__c,
                          name
                   FROM   BX041_IP_Merge__c
                   WHERE  BX_041__c = : BX041ID]){
            ipmList.add(ipm);
            ipmOldMap.put(ipm.id, new BX041_IP_Merge__c(IP_Master__c = ipm.IP_Master__c, Remarks__c = ipm.Remarks__c));             
         }
    }//end of displayIpmkit method.
    
    /******************************************************************************************************
    @Method Name:    displayIpKit
    @Return Type:    NA
    @parameter:      NA
    @Reason:         To display IP information in the BX041 form.
    *******************************************************************************************************/             
    private void displayIpKit(){
        ipwList = new List<Bx041IpWrapper>();
        List<BX041_IP__c> ipList = [SELECT  ID,
                                            IP_Lifecycle__c,
                                            IP_Master__c,
                                            IP_Master__r.name,
                                            IP_Master__r.PH1_QA_Status__c,
                                            IP_Master__r.Showstopper__c,
                                            Name,
                                            BX_041__c,
                                            Version__c,
                                            IP_Catg__c,
                                            Lib_Nm__c,
                                            IP_Device_List__c,
                                            Vendor__c,
                                            Cust_Rqmt__c,
                                            Addl_Rqmt__c,
                                            Remarks__c,
                                            IP_Type__c,
                                            Bitcell_Needed__c,
                                            Bitcell_Size__c,
                                            Blk_Needed__c,
                                            Blk_Cfg_Reqd__c,
                                            Max_Blksize_X__c,
                                            Max_Blksize_Y__c,
                                            Max_Blksize_XY__c,
                                            Charge_Pump_Needed__c,
                                            Vt_Ref_Needed__c,
                                            Digital_Ctrl_Needed__c,
                                            Input_Data_IF__c,
                                            Output_Data_IF__c,
                                            End_Spec__c,
                                            Pw_Rqmt__c,
                                            data_rttn__c,
                                            SMF_Cmt__c,
                                            OTP_Blk_Needed__c,
                                            OTP_Blk_Cfg_Reqd__c,
                                            eFuse_Type__c,
                                            EFUSE_BlkSize_Cfg__c,
                                            Inline_Staggered__c,
                                            IO_Height__c,
                                            IO_Pitch__c,
                                            Proc_Nm__c,
                                            Speed__c,
                                            Licensing_Reqd__c,
                                            Cache_Size__c,
                                            Third_party__c,
                                            Access_Time__c,
                                            Redun__c,
                                            Row_Num__c,
                                            Col_Num__c,
                                            Memory_size__c,
                                            Min_Op_Vcc__c,
                                            GF_bitcell__c,
                                            GF_Bitcell_GDS__c,
                                            GF_XY_Ds__c,
                                            GF_Mem_size__c,
                                            GF_Bitcell_Vt_opt__c,
                                            GF_Bitcell_PT__c,
                                            GF_Min_op_Vcc__c,
                                            Others_bitcell__c,
                                            Non_GF_BitCell__c,
                                            Non_GF_XY_Ds__c,
                                            Non_GF_Mem_size__c,
                                            Non_GF_Bitcell_Vt_opt__c,
                                            Non_GF_Bitcell_PT__c,
                                            Non_GF_Min_op_Vcc__c               
                                     FROM   BX041_IP__c
                                     WHERE  BX_041__c = :bx041ID
                                      ];
        if(!ipList.isEmpty() ){          
            
            for(BX041_IP__c ip : ipList){               
                Bx041IpWrapper ipw = new Bx041IpWrapper(ip,false);
                if(ip.IP_Master__c != null){
                    ipw.ipMaster = ip.IP_Master__r.name;
                    if(ip.IP_Master__r.PH1_QA_Status__c == 'NCR' && ip.IP_Master__r.Showstopper__c == 'Yes'){
                        ipw.isSpecial = true;
                    }
                } 
                ipw.isNew = false;
                ipw.stepNo = '3';            
                ipwList.add(ipw);    
            }
        }
        
        addNewIP = true;
    }//end of displayIpKit method.
    
    
    /* =============================================  BX041 IP End =================================================== */
    
    
    /* =============================================  BX041 Approval Start =================================================== */
    /******************************************************************************************************
    @Method Name:    submitForApproval 
    @Return Type:    pagereference 
    @parameter:      NA
    @Reason:         This method is used to submit for approval functionality.
    *******************************************************************************************************/             
    public pagereference submitForApproval (){
        
        //if the related account region doesnt match then request should not be considered for approval.
        if(accountRegion == '' || accountRegion == 'Not Applicable'){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'Related Account Region is Not Applicable.'));return null;
            
        }
        
        String initSubmitter = '';
        String appStep = '';
        String appStatus = '';
        String bx041Status = '';
        if(String.isEmpty(bx041.Initial_Submitter__c)){
            //Added by Vijay 02132015 - added Device recort type check to toggle the approval related status
            if(!isInternalDevice){
                if(isCustomer){
                    initSubmitter = 'Customer';
                }else { 
                    initSubmitter = 'FAE/FTS';// Admin approval is taken as FTS approval
                    appStatus = 'Approved by FAE/FTS';
                }
                appStep = 'Pending for FAE/FTS';
                bx041Status = 'Pending Submission';
            }else{
                initSubmitter = 'Device Owner/Account Admin';
                appStep = 'Pending for Account Owner';
                bx041Status = 'Pending Submission';
                
            }
        } else{
            appStep = bx041.Approval_Step__c;
            appStatus = bx041.Approval_Status__c;
            bx041Status = bx041.BX_041_Status__c;
        }
        
        //when FE submit, validate mandatory fields of Process information if available and CDRS 
        if( bx041.BX_041_Status__c == 'Pending Submission' && (pfName == 'GF FAE/FTS' || isAdmin || isCustomer || isInternalDevice)  ){
            
            if(!BX041.Need_MEMS_informaton__c){
                String result = validateMandatoryData();
                if(!String.isEmpty(result)){
                    ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'Please fill all the required fields of Process Information section before submit:' + result)); return null;
                    
                }
            }
            //hotfix Thomas 27022014 - Validate Die Size and Special scribe width of CDRS
            if(bx041.Die_Size_X_mm__c == null || bx041.Die_Size_Y_mm__c == null || String.isEmpty(bx041.Special_Scribe_Width__c)){
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'Die Sizes and Special Scribe Width are required before submission'));return null;
                
            }
            
            //TLai 25042014 - added validation as per case 16657
            /*if(String.isblank(bx041.device__r.Confidence_Level_Tapeout__c) || integer.valueOf(bx041.device__r.Confidence_Level_Tapeout__c.trim()) < 50){
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'CDRS submission requires Tapeout Confidence level more than 50%, please update it before submit again'));
                return null;
            }*/
        }
        
        if(String.isEmpty(bx041.Initial_Submitter__c)){
            bx041.Approval_Step__c = appStep;
            bx041.Approval_Status__c = appStatus ;
            bx041.BX_041_Status__c = bx041Status ;
            bx041.initial_submitter__c = initSubmitter;
        }
        
        update bx041;//updating BX041 record.
        
        //creating instance of the BX041ApprovalHelper class. 
        BX041ApprovalHelper helper = new BX041ApprovalHelper();      
        //try{      
            String result = helper.submitForApproval(bx041.id, comment ,null);//calling submitForApproval method.
            if(result != null){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                
            }
        //} catch(Exception ex) {
           // Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,ex.getMessage()));
           // return null;
        //}  
       
        return  getNextPage();//returning page reference based on the status of the form.
    }//end of submitForApproval method.
    
    /******************************************************************************************************
    @Method Name:    backTrackForApproval 
    @Return Type:    pagereference 
    @parameter:      NA
    @Reason:         This method handles the backtrack functionality of the BX041 record when the status 
                     of the BX041 is closed.
    *******************************************************************************************************/             
    public pagereference backTrackForApproval (){
        backtrackwindow = false;
        
        BX041ApprovalHelper helper = new BX041ApprovalHelper();    
        try{        
            String result = helper.BackTrackApproval(bx041.id, comment,BackTrackValue);
            if(result != null){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                
            }
        } catch(Exception ex) {
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,ex.getMessage()));return null;
            
        }  
       
        return  getNextPage();//generate page reference dynamically.
        //return new pagereference('/'+bx041.id);
    }//end of backTrackForApproval method.
    
    /******************************************************************************************************
    @Method Name:    approve
    @Return Type:    page reference
    @parameter:      NA
    @Reason:         This method handles the approve function for PIYE profile and approve&submit function for other profiles 
    *******************************************************************************************************/             
    public pagereference approve(){
        // validate mandatory fields of Process Id if available and CDRS
        if( bx041.BX_041_Status__c == 'Pending Submission' && (pfName == 'GF FAE/FTS' || isAdmin || isCustomer || isInternalDevice) ){
            
            if(!BX041.Need_MEMS_informaton__c)  {
                String result = validateMandatoryData();
                if(!String.isEmpty(result)){
                    ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'Please fill all the required fields of Process Information section before submit: ' + result)); return null;
                    
                }
            }                              
            //hotfix Thomas 27022014 - Validate Die Size and Special Scribe width of CDRS
            if(bx041.Die_Size_X_mm__c == null || bx041.Die_Size_Y_mm__c == null || bx041.Special_Scribe_Width__c == null){
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'Die Sizes and Special Scribe Width are required before submission')); return null;
                
            }
            
            //TLai 25042014 - added validation as per case 16657
            /*if(String.isblank(bx041.device__r.Confidence_Level_Tapeout__c) || integer.valueOf(bx041.device__r.Confidence_Level_Tapeout__c.trim()) >= 50){
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'CDRS submission requires Tapeout Confidence level more than 50%, please update it before submit again'));
                return null;
            }*/
        }
        
        List<id> userList;
        if(BX041ApprovalHelper.approvedByFAEOrFTS(bx041.Approval_Status__c) || (isInternalDevice && String.isBlank(bx041.Approval_Status__c))){// when FE submitted req to CE. 
            if(bx041.Approver_1__c == null && bx041.Approver_2__c == null && bx041.Approver_3__c == null ){// approver1/approver2/approver3 populated in the popup 'select PIYE' window
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'At least One PI/YE Approver is required.'));return null;
                
            } 
            System.debug('----isInternalDevice------'+isInternalDevice);
            piyeApprSelectionWindow = false;
            userList = new list<id>();
            for(integer i = 1; i<=3 ; i++){
                if(bx041.get('Approver_'+ i +'__c') != null){
                    ID userId = (ID)bx041.get('Approver_'+ i +'__c');
                    userlist.add(userId);
                }
            }
            
            // CE approve req
           BX041ApprovalHelper helper = new BX041ApprovalHelper();
            if(!String.isEmpty(bx041.Next_WorkItem_Id__c)){
               String result = helper.approveReq(bx041.id, comment);
               if(result != null) {
                    Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                    
               }
            }
            // CE submit for PIYE approval
            String result = helper.submitForApproval(bx041.id, '', userList);
            if(result != null) {
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                
            }
            return  getNextPage();
        } else if(bx041.Approval_Status__c == 'Approved by CE' && String.isEmpty(bx041.Next_WorkItem_Id__c) ){//when CE has approved req from homepage, pending for submission
            if(bx041.Approver_1__c == null && bx041.Approver_2__c == null && bx041.Approver_3__c == null ){ // approver1/approver2/approver3 populated in the popup 'select PIYE' window
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'At least One PI/YE Approver is required.'));return null;
                
            } 
            piyeApprSelectionWindow = false;
            userList = new list<id>();
            for(integer i = 1; i<=3 ; i++){
                if(bx041.get('Approver_'+ i +'__c') != null){
                    ID userId = (ID)bx041.get('Approver_'+ i +'__c');
                    userlist.add(userId);
                }
            }
            
            // CE submit for PIYE approval
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            String result = helper.submitForApproval(bx041.id, comment, userList);
            if(result != null){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                
            }
            return  getNextPage();
        }
        
        //request should not be approved if any of the Gaps is None
        //isGapNone = true if any of the Gap status is None. 
        if(bx041.Approval_Status__c == 'Approved by CE' && isGapNone == true){
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'Gap with status "None" cannot be approved. Please modify the GAP status')); return null;
            
        }
        
        BX041ApprovalHelper helper = new BX041ApprovalHelper();  
        try{
            String result = helper.approveReq(bx041.id, comment);
            if(result != null){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                
            }
        } catch(Exception ex) {
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,ex.getMessage()));return null;
            
        }          
        
        return  getNextPage();
    }// end of approve method.
    
    /******************************************************************************************************
    @Method Name:    reject
    @Return Type:    page reference
    @parameter:      NA
    @Reason:         This method handles the reject functionality of the BX041 record .
    *******************************************************************************************************/             
    public pagereference reject(){
        BX041ApprovalHelper helper = new BX041ApprovalHelper();    
        try{        
            String result = helper.rejectReq(bx041.id, comment);
            if(result != null){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,result));return null;
                
            }
        } catch(Exception ex) {
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,ex.getMessage())); return null;
            
        }  
        return getNextPage();
    }//end of reject method.
    
    /******block to generate show PIYE pop up window start*******/
    /******************************************************************************************************
    @Method Name:    showPiyeAppr
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method displays the PIYE users in the page.
    *******************************************************************************************************/              
    public void showPiyeAppr(){
        piyeApprSelectionWindow = true;
        bx041.Approver_1__c = null;
        bx041.Approver_2__c = null;
        bx041.Approver_3__c = null;
    }
    /******************************************************************************************************
    @Method Name:    cancel
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method cancels the select PIYE window.
    *******************************************************************************************************/              
    public pagereference cancel(){
        displayPopup = false;
        return null;
    }//end of cancel block.
    /******block to generate show PIYE pop up window end *******/
    
    
    /******************************************************************************************************
    @Method Name:    getNextPage
    @Return Type:    pagereference 
    @parameter:      NA
    @Reason:         This method dynamically retuns the pagereference for different scenario.
    *******************************************************************************************************/              
    private pagereference getNextPage(){
        bx041 = [SELECT id,
                        name,
                        Device__c,
                        Device__r.Requested_Process_ID__c,
                        Device__r.Assigned_Process_ID__c,
                        Device__r.Geometry__c,
                        device__r.Fab__c,
                        device__r.Current_Forecast_Tapeout_Date__c,
                        BX_041_Status__c,
                        Approval_Status__c,
                        Need_MEMS_informaton__c,
                        No_of_CE_Approver__c,
                        Need_PowerMOS__c,
                        Need_eDRAM__c,
                        Need_High_Voltage__c,
                        Need_NVM__c,
                        Need_RF__c,
                        Need_Turnkey__c,
                        Need_IP_information__c,
                        Need_IP_Merge_information__c,
                        Reference_Process_ID__c ,
                        Reference_Process_ID_txt__c,
                        Assigned_Process_ID__c,
                        Assigned_Process_ID__r.Name,
                        Requested_Process_ID__c,
                        Requested_Process_ID__r.Name,
                        Process_ID_is_known__c,
                        Approval_Step__c ,
                        Backtrack_Request__c,
                        Configuration_Status__c,
                        Next_WorkItem_Id__c,
                        Approver_1__c,
                        Approver_2__c,
                        Approver_3__c,
                        GAP_Closed__c,
                        Initial_Submitter__c,
                        Geometry_Filter__c,
                        Process_Family_Filter__c,
                        CRMDID_Fromula__c,
                        device__r.Tapeout_Type__c
                FROM    BX_041__c 
                WHERE   id = :bx041ID];
        
        pagereference pf = new pagereference('/'+bx041.id);
        setButtonPermission();//checking the permission of different buttons of the BX041 form.
        return pf;      
    }//end of getNextPage method.
    
    //declaring few variables used to display different buttons in the BX041 view and edit page.
    public boolean editBtnVisible {get; set;}
    public boolean submitBtnVisible {get; set;}
    public boolean approveBtnVisible {get; set;}
    public boolean rejectBtnVisible {get; set;}
    public boolean piyeSltBtnVisible {get; set;}
    public boolean backtrackBtnVisible {get; set;}
    public boolean reopenable {get; set;}
    
    
    /******************************************************************************************************
    @Method Name:    setButtonPermission
    @Return Type:    NA
    @parameter:      NA
    @Reason:         This method sets the permission of different users on different buttons.
    *******************************************************************************************************/              
    private void setButtonPermission(){
        
            List<boolean> psList = BX041PermissionHelper.getPermissions(bx041.id, UserInfo.getUserId(), pfName);
            //system.debug(psList);
            editBtnVisible = psList[0];
            submitBtnVisible = psList[1];
            piyeSltBtnVisible = psList[2];
            approveBtnVisible  = psList[3];
            rejectBtnVisible = psList[4];
            backtrackBtnVisible = psList[5];
            reopenable = psList[6];
        
    }//end of setButtonPermission method.
    /* =============================================  BX041 Approval end =================================================== */
    
}//end of the class BX041_Edit