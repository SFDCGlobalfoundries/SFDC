/*
  Author: Anirban Roy
  Description: This is the controller class for translation/matching of GDS and GR to masks to CPL masks
               for Multi Source Tapeout.
  History:
    ARoy        09222014    - code creation.
    ARoy        01132015    - modified code to include the GDS Header controller code.              
*/
public class CPQTranslateMaskLayerController
{
    // List of variables
    public transient List<CalculateMasksLayer> calcMaskLayerList;
    public CPQPaginateUtil paginater{get;set;}
    //public List<CalculateMasksLayer> maskLayerListPerPage {get;set;}
    public Map<Integer,List<CalculateMasksLayer>> fullGenericObjMap{get;set;}
    public Map<Integer,Boolean> errorMap{get;set;}
    public Map<Integer,Boolean> warnMap{get;set;}
    public Boolean isExternalUser{get;set;}
    public String gdsId{get;set;}
    public String customer{get;set;}
    public String ptNumber{get;set;}
    public String proposalId{get;set;}
    public Boolean isGDSTranslate{get;set;}
    public Boolean sortAscending{get;set;}
    public String grMasterLayerId{get;set;}
    public Boolean isUsrInGDSGroup {get;set;}
    public Integer totalRowCount {get;set;}
    /*public static final String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public static final String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
    public static final String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
    public static final String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
    public static final String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
    public static final String gfInt = EnvironmentVariable.get('GF_INTEGRATION');*/
    
    //========GDS Header Variables======//
    
    public String configID {get; set;}   
    public String id2 {get; set;}
    public String id3 {get; set;}
    public String id4 {get; set;}    
    public String translatedRowCount {get; set;}
        
    private Apttus_Proposal__Proposal__c config;
    private Integer GDScount;
    
    //==================================//       
    
    // Constructor
    public CPQTranslateMaskLayerController(){
        calcMaskLayerList = new List<CalculateMasksLayer>();
        errorMap = new Map<Integer,Boolean>();
        warnMap = new Map<Integer,Boolean>();       
        //gdsId='';
        proposalId = ApexPages.currentPage().getParameters().get('id');
        isGDSTranslate = false;
        Integer i=0;
        Integer j=0;
        Integer k=0;
        sortAscending = false;
        isUsrInGDSGroup = false;
        //grMasterLayerId='';
        
        
        //=============GDS Header Constructor=============//
        this.configID = ApexPages.currentPage().getParameters().get('id');
        this.id2 =  ApexPages.currentPage().getParameters().get('id2');     
        this.id3 =  ApexPages.currentPage().getParameters().get('id3');     
        this.id4 =  ApexPages.currentPage().getParameters().get('id4'); 

        this.config = new Apttus_Proposal__Proposal__c();
        
        String GDSId1;  
        for(Apttus_Proposal__Proposal__c rec: [SELECT product_name__c,product_revision__c,
                                                      (SELECT id,file_name__c,top_cell_name__c,status__c
                                                              FROM GDS__r
                                                              ORDER BY createdDate DESC
                                                              LIMIT 1)
                                                 FROM Apttus_Proposal__Proposal__c
                                                 WHERE id = :ApexPages.currentPage().getParameters().get('id')]){
            this.config = rec; 
            for(GDS__c g: rec.GDS__r){            
                GDSId1 = g.id;         
            }
        } 
        
        //get the GDS row count if any
        this.GDSCount = [SELECT count() 
                           FROM GDS_Layer__c 
                           WHERE gds__c = :GDSId1];                         
        
        
        //===============================================//
        
        Integer recCount = [select     count() 
                            from       GroupMember 
                            where      group.developername = 'GDS_Group'
                            and        UserOrGroupId =: UserInfo.getUserId()];
                            
         /*Profile prof = [select    Id
                                  ,Name 
                        from      Profile
                        where     Id = :UserInfo.getProfileId()
                       ];*/
    
         if(/*prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
            || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt||*/recCount!=0){
             isUsrInGDSGroup = true;
         }
        
        
        // Retrieving saved data from the translation object
        for(GDS_GR_Layer_Translation__c gdsGrLayerTrans :   [select    id
                                                                       , GDS_Layer_Name__c
                                                                       , GDS_Layer_Number__c
                                                                       , GDS_Layer_Data_Type__c
                                                                       , GF_Layer_Name__c
                                                                       , GF_Layer_Number__c
                                                                       , GF_Layer_Data_Type__c
                                                                       , GF_Mask_Layer__c
                                                                       , CPL_Mask_Layer__c
                                                                       , Row_Number__c
                                                                       , Is_Mask_Match__c
                                                                       , Quote_Proposal__c
                                                                       , GDS__c
                                                                       , GDS__r.Status__c
                                                                       , GR_Layer__c
                                                                       , GR_Masterlist__c
                                                                       , Status__c
                                                             from      GDS_GR_Layer_Translation__c
                                                             where     Quote_Proposal__c = :proposalId
                                                             order by  Row_Number__c asc    
                                                            ]){
            CalculateMasksLayer calcMskLyr = new CalculateMasksLayer(gdsGrLayerTrans.GDS_Layer_Name__c,
                                                                     (Integer)gdsGrLayerTrans.GDS_Layer_Number__c,
                                                                     (Integer)gdsGrLayerTrans.GDS_Layer_Data_Type__c,
                                                                     gdsGrLayerTrans.GF_Layer_Name__c,
                                                                     (Integer)gdsGrLayerTrans.GF_Layer_Number__c,
                                                                     (Integer)gdsGrLayerTrans.GF_Layer_Data_Type__c,
                                                                     gdsGrLayerTrans.GF_Mask_Layer__c,
                                                                     gdsGrLayerTrans.CPL_Mask_Layer__c,
                                                                     gdsGrLayerTrans.Status__c,
                                                                     (Integer)gdsGrLayerTrans.Row_Number__c,
                                                                     (String)gdsGrLayerTrans.GR_Layer__c,
                                                                     (String)gdsGrLayerTrans.GR_Masterlist__c                                                                     
                                                                    );
            // Checking for translation error
            if(i==0 && gdsGrLayerTrans.GDS__r.Status__c != 'Approved' && gdsGrLayerTrans.Status__c=='error'){                                               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_TRANSLATION_ERROR')));
                if(isUsrInGDSGroup){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_ERR_FLG')));
                }               
                i++;
            }
            
            if(k==0 && gdsGrLayerTrans.GDS__r.Status__c != 'Approved' && gdsGrLayerTrans.Status__c=='warn'){
                if(isUsrInGDSGroup){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ErrorCode.get('CPQ_MULTI_SOURCE_WARN_CLICK_FLG')));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ErrorCode.get('CPQ_MULTI_SOURCE_WARN_FLG')));
                }
                k++;
            }
            
            // Check for the gds status
            if(j==0){
                gdsId = gdsGrLayerTrans.GDS__c;
                isGDSTranslate = (gdsGrLayerTrans.GDS__r.Status__c=='Translating')?true:false;
                j++;
            }
            calcMaskLayerList.add(calcMskLyr);
        }
        
        if(calcMaskLayerList.size()==0){
            recordsRetrieval();
        }
        recordsPerPage();
       
        isExternalUser = false;
        //Check if the user is external User
        if(UserInfo.getUserType()==EnvironmentVariable.get('CPQ_MULTI_SOURCE_CUSTOMER_USR_TYPE')
                ||UserInfo.getUserType()==EnvironmentVariable.get('CPQ_MULTI_SOURCE_POWER_CUST_USR_TYP')){
            isExternalUser=true;
        }
        system.debug('gdsId1===>'+gdsId);
    }
    
    // Wrapper class for mask layer calculation
    class CalculateMasksLayer
    {
        // Variables      
        public String cplMaskLayer{get;set;}
        public String status{get;set;}
        public Integer rowCount{get;set;}
        
        public String gdsLayerName{get;set;}
        public Integer gdsLayerDT{get;set;}
        public Integer gdsLayerNumber{get;set;}
        public String grLayerName{get;set;}
        public Integer grLayerDT{get;set;}
        public Integer grLayerNumber{get;set;}
        public String grMaskLayer{get;set;}
        public String grLayerId{get;set;}
        public String grMasterList{get;set;}        
        
        //Constructor
        public CalculateMasksLayer(String gdsLayerName, Integer gdsLayerDT, Integer gdsLayerNumber,
                                    String grLayerName, Integer grLayerDT, Integer grLayerNumber, String grMaskLayer,
                                      String cplMaskLayer, String status, Integer rowCount, String grLayerId,
                                      String grMasterList){
           
           this.gdsLayerName = gdsLayerName;
           this.gdsLayerDT = gdsLayerDT;
           this.gdsLayerNumber = gdsLayerNumber;
           this.grLayerName = grLayerName;
           this.grLayerDT = grLayerDT;
           this.grLayerNumber = grLayerNumber;
           this.grMaskLayer = grMaskLayer;
           
           this.cplMaskLayer = cplMaskLayer;
           this.status = status;
           this.rowCount = rowCount;
           
           this.grLayerId = grLayerId;
           this.grMasterList = grMasterList;
        }
    }
    
    //=============GDS Header Methods===============//
    
    public String GDSRowCount {                
        get {                        
                if(!UtilsString.isNotBlank(this.GDSRowCount)){
                return String.valueOf(this.GDSCount);
            }                              
            return this.GDSRowCount;   
        }                  
        set;
    }  
    
    public String productRevision {
        get {return this.config.product_revision__c;}        
        set;
    }
    
    public String productName {
        get {return this.config.product_name__c;}        
        set;
    }
    
    public String status {                
        get {            
            for(GDS__c g: this.config.GDS__r){
                if(!UtilsString.isNotBlank(this.status)){
                    return g.status__c;
                }                              
            } 
            return this.status;   
        }
        set;
    }
    
    public String fileName {                
        get {            
            for(GDS__c g: this.config.GDS__r){
                if(!UtilsString.isNotBlank(this.fileName)){
                    return g.file_name__c;
                }                              
            } 
            return this.fileName;   
        }
        set;
    }
    
    public String topCellName {        
        get {            
            for(GDS__c g: this.config.GDS__r){                               
                if(!UtilsString.isNotBlank(this.topCellName)){
                    return g.top_cell_name__c;
                }
            }
            return this.topCellName;    
        }
        set;
    }
    
    public String GDSUploadStep {
        get {
            
            Boolean hasGDS = false;
                        
            for(GDS__c g: this.config.GDS__r){                               
                if(g.status__c == 'Draft' || g.status__c == 'Rejected' || !UtilsString.isNotBlank(g.status__c)){                    
                    return 'progtrckr-active';
                } else {
                    return 'progtrckr-done';
                }
                hasGDS = true;
            } 
            
            if(!hasGDS){
                return 'progtrckr-active';
            }
            
            return 'progtrckr-done';           
        }
        set;
    }
    
    public String GDSTranslateStep {
        get {
                      
            for(GDS__c g: this.config.GDS__r){                               
                if(g.status__c == 'Translating'){                    
                    return 'progtrckr-active';
                } else if (g.status__c == 'Approved'){
                    return 'progtrckr-done';
                }else if(g.status__c == 'Draft' || g.status__c == 'Rejected' || !UtilsString.isNotBlank(g.status__c)){                    
                    return 'progtrckr-next-active';
                }
            } 
            return 'progtrckr-todo';
                                         
        }
        set;
    }
    
    public String GDSApproveStep {
        get {
                      
            for(GDS__c g: this.config.GDS__r){                               
                if(g.status__c == 'Approved'){                    
                    return 'progtrckr-done';
                }else if(g.status__c == 'Translating' && !(ApexPages.currentPage().getURL().contains('GDSUPLOAD')) &&  !(this.isExternalUser)){
                    return 'progtrckr-next-active';
                }
                 
            } 
            return 'progtrckr-todo';
                                         
        }
        set;
    }
    
    public PageReference back(){
        PageReference pageRef = new PageReference('/apex/ProposalSummary?retId=' + this.configId +
                                                  '&id='+ this.id2 + '&businessObjectId=' + this.id3 +
                                                  '&configRequestId='+ this.id4);
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public PageReference backtoGDS(){   
        String url = '/apex/GDSUPLOAD?id=' + this.configId +
                     '&id2='+ this.id2 + '&id3=' + this.id3 +
                     '&id4='+ this.id4;
                     
        //add override = true if translation stage is active             
        if(this.GDSTranslateStep == 'progtrckr-active'){
            url += '&override=true';    
        }                      
        PageReference pageRef = new PageReference(url);
                                                         
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public PageReference backtoTranslate(){   
        String url = '/apex/CPQTranslateMaskLayerPage?id=' + this.configId +
                     '&id2='+ this.id2 + '&id3=' + this.id3 +
                     '&id4='+ this.id4;
                                               
        PageReference pageRef = new PageReference(url);
                                                         
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    
    //=============================================//        
    
    // Method to validate the matching and save the record
    public PageReference validationAndSave() {
        //Boolean errorFlag = false;
        List<GDS_GR_Layer_Translation__c> gdsGRtransList = new List<GDS_GR_Layer_Translation__c>();
        Integer i=0;
        Integer k=0;
        system.debug('gdsId===>'+gdsId);
        // Getting the records from the wrapper object into the GDS/GR translation object
        for(Integer pageCount : fullGenericObjMap.keySet()){
            for(CalculateMasksLayer calcMskLyr : fullGenericObjMap.get(pageCount)){                

                GDS_GR_Layer_Translation__c gdsGrLt = new GDS_GR_Layer_Translation__c();
                gdsGrLt.GDS_Layer_Name__c = calcMskLyr.gdsLayerName;
                gdsGrLt.GDS_Layer_Number__c = calcMskLyr.gdsLayerNumber;
                gdsGrLt.GDS_Layer_Data_Type__c = calcMskLyr.gdsLayerDT;
                gdsGrLt.GF_Layer_Name__c = calcMskLyr.grLayerName;
                gdsGrLt.GF_Layer_Number__c = calcMskLyr.grLayerNumber;
                gdsGrLt.GF_Layer_Data_Type__c = calcMskLyr.grLayerDT;
                gdsGrLt.GF_Mask_Layer__c = calcMskLyr.grMaskLayer;
                gdsGrLt.CPL_Mask_Layer__c = calcMskLyr.cplMaskLayer;
                gdsGrLt.Quote_Proposal__c = proposalId;
                gdsGrLt.Row_Number__c = calcMskLyr.rowCount;
                //gdsGrLt.Is_Mask_Match__c = calcMskLyr.isMatch;
                gdsGrLt.Status__c = calcMskLyr.status;
                // Error thrown if any of the record is not matched
                if(i==0 && calcMskLyr.status=='error'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_TRANSLATION_ERROR')));
                    if(isUsrInGDSGroup){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_ERR_FLG')));
                    }
                    i++;
                }
                if(k==0 && calcMskLyr.status=='warn'){
                    if(isUsrInGDSGroup){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ErrorCode.get('CPQ_MULTI_SOURCE_WARN_CLICK_FLG')));
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ErrorCode.get('CPQ_MULTI_SOURCE_WARN_FLG')));
                    }
                    k++;    
                }                
                gdsGrLt.GDS__c = gdsId;
                gdsGrLt.GR_Layer__c = calcMskLyr.grLayerId;
                gdsGrLt.GR_Masterlist__c = grMasterLayerId;
                gdsGRtransList.add(gdsGrLt);

            }
        }
        
        // Deleting the previous translation records.
        deleteTranslationRec();        
        
        // Save the latest translation records and show success or error message.
        if(gdsGRtransList.size()>0){
            try{
                insert gdsGRtransList;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, EnvironmentVariable.get('CPQ_MULTI_SOURCE_TRANSLATION_SAVE')));
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_TRANSLATE_SAVE_ERROR')));
            }
        }        
                
        return null;
    }            
    
    // Method to save the translation record and approve the GDS record approval process. 
    public PageReference approve(){
      
        //Error thrown when translation error is prevalent
        if(!errorMap.isEmpty()){
            Boolean isErr = false;
            for(Boolean isChk : errorMap.values()){
                if(isChk){
                    isErr = true;
                }
            }
            if(isErr){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_TRANS_ERR')));
                return null;
            }
        }
        
        // Invoke the validation and save record method.
        PageReference pgr = validationAndSave();                        
        
        // Invoke the approval process approval
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setAction('Approve');
        Id workItemId = getWorkItemId(gdsId);

        // If there is any error throw the error on the page with customised message
        if(workItemId == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_APPROVE_ERROR')));
        }
        else
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    // Method to reject the GDS record approval process.
    public PageReference reject(){        
        
        // Invoke the approval process rejection
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setAction('Reject');
        Id workItemId = getWorkItemId(gdsId);
        //opp.addError(workItemId);
        
        // If there is any error throw the error on the page with customised message
        if(workItemId == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_REJECT_ERROR')));
        }
        else
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
        
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/'+ proposalId);
        }else{
            pr = new PageReference('/'+ proposalId);
        }
        return pr;        
    }        
    
    // Method to retranslate the GDS/GR translational record and re-map it. 
    public PageReference retranslate(){
        // Invoke the translational record deletion.
        deleteTranslationRec();        
        
        // Run the translational process and save the records in the GDS/GR translational object. 
        recordsRetrieval();
        recordsPerPage();
        /*List<GDS_GR_Layer_Translation__c> gdsGRtransList = new List<GDS_GR_Layer_Translation__c>();
        for(Integer pageCount : fullGenericObjMap.keySet()){
            for(CalculateMasksLayer calcMskLyr : fullGenericObjMap.get(pageCount)){
                GDS_GR_Layer_Translation__c gdsGrLt = new GDS_GR_Layer_Translation__c();
                gdsGrLt.GDS_Layer_Name__c = calcMskLyr.gdsLayerName;
                gdsGrLt.GDS_Layer_Number__c = calcMskLyr.gdsLayerNumber;
                gdsGrLt.GDS_Layer_Data_Type__c = calcMskLyr.gdsLayerDT;
                gdsGrLt.GF_Layer_Name__c = calcMskLyr.grLayerName;
                gdsGrLt.GF_Layer_Number__c = calcMskLyr.grLayerNumber;
                gdsGrLt.GF_Layer_Data_Type__c = calcMskLyr.grLayerDT;
                gdsGrLt.GF_Mask_Layer__c = calcMskLyr.grMaskLayer;
                gdsGrLt.CPL_Mask_Layer__c = calcMskLyr.cplMaskLayer;
                gdsGrLt.Quote_Proposal__c = proposalId;
                gdsGrLt.Row_Number__c = calcMskLyr.rowCount;
                gdsGrLt.Is_Mask_Match__c = calcMskLyr.isMatch;
                gdsGrLt.GDS__c = gdsId;
                gdsGRtransList.add(gdsGrLt);
            }
        }
        // Save the GDS/GR translational and mapping record and throw success or error message on the page.
        if(gdsGRtransList.size()>0){
            try{
                insert gdsGRtransList;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, EnvironmentVariable.get('CPQ_MULTI_SOURCE_TRANSLATION_SAVE')));
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_TRANSLATE_SAVE_ERROR')));
            }
        }*/ 
        return null;
    }
    
    // Method to generate the excel for the GDS/GR translational and mapped table.
    public PageReference generateExcel(){
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/CPQTranslateMaskLayerExportPage?id='+ proposalId);
        }else{
            pr = new PageReference('/apex/CPQTranslateMaskLayerExportPage?id='+ proposalId);
        }
        
        //Save the excel as an attachment
        Attachment a = new Attachment();
        if(!Test.isRunningTest()){
            a.Body = pr.getContent();
        }else{
            a.Body = Blob.valueof('Test Attachment');
        }
        a.Name = 'GDS_GR_Layer_Translation_'+datetime.now().format()+'.xls';
        a.ParentId = proposalId;
        insert a;
        
        return pr;
    }
    
    // Method to navigate the user to the GDS upload page
    public PageReference goToUploadGDSPage(){
        PageReference pr;
        String otherParam = '&id2=' +Apexpages.currentPage().getParameters().get('id2') +
                            '&id3=' +Apexpages.currentPage().getParameters().get('id3') +
                            '&id4=' +Apexpages.currentPage().getParameters().get('id4') +
                            '&override=true';
                            
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/apex/GDSUPLOAD?id='+ proposalId + otherParam);
        }else{
            pr = new PageReference('/apex/GDSUPLOAD?id='+ proposalId + otherParam);
        }
        return pr;        
    }    
    
    // Method to cancel the translational process and navigate the user to the configuration detail page
    public PageReference cancel(){
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/'+ proposalId);
        }else{
            pr = new PageReference('/'+ proposalId);
        }
        return pr;
    }        
    
    // Method to navigate the user to the previous page
    public PageReference previousPage(){
        paginater.decrement();
        //return changeData();
        return null;
    }
    
    // Method to navigate the user to the next page 
    public PageReference nextPage(){
        paginater.increment();
        //return changeData();
        return null;
    }
    
    // Method to navigate the user to the designated page when clicked on the page link.
    public PageReference updatePage(){
        paginater.updateNumbers();
        //return changeData();
        return null;
    }
    
    // Get the work item id from the approval process
    private Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    
    // Method to delete the GDS/GR translational object record.
    private void deleteTranslationRec(){
        List<GDS_GR_Layer_Translation__c> gdsGrLayerTransList = [select id from GDS_GR_Layer_Translation__c where Quote_Proposal__c = :proposalId];
        if(gdsGrLayerTransList!=null && gdsGrLayerTransList.size()>0){
            delete gdsGrLayerTransList;
        }
    }
    
    // Get the records from CPL and translate mask from GDS/GR
    private void recordsRetrieval(){
        calcMaskLayerList = new List<CalculateMasksLayer>();
        Set<String> maskSet = getMaskLayerSet(proposalId);        
        calcMaskLayerList = translateMaskLayer(proposalId, maskSet);        
    }
    
    // Invoke the CPQPaginateUtil class to display limited number of records per page 
    private void recordsPerPage(){
        //maskLayerListPerPage = new List<CalculateMasksLayer>();
        fullGenericObjMap = new Map<Integer,List<CalculateMasksLayer>>();
         
        //Create a new instance of Paginate passing in the overall size of
        //the list of data and the page size you want
        
        system.debug('calcMaskLayerList ==> '+calcMaskLayerList);
        paginater = new CPQPaginateUtil(Integer.valueOf(EnvironmentVariable.get('GDS_TRANSLATION_REC_PER_PG')), calcMaskLayerList.size());
        getCompMapPerPage();

        /*for(CalculateMasksLayer cml : fullGenericObjMap.get(0)){
            maskLayerListPerPage.add(cml);
        }*/
    }    
    
    // Method to populate a map with records per page for all records.
    private void getCompMapPerPage(){              
        Integer j = 0;
        totalRowCount = 0;
        if(calcMaskLayerList.size() > 0){
            List<CalculateMasksLayer> tempObj = new List<CalculateMasksLayer>();        
            Integer i = 0;
            Integer k = 0;
            Integer m = 0; 
            Boolean isError = false;
            Boolean isWarn = false;           
            for(CalculateMasksLayer cc : calcMaskLayerList){
                tempObj.add(cc);
                if(cc.status=='error' && k==0){
                    isError = true;                    
                    k++;        
                }
                if(cc.status=='warn' && m==0){
                    isWarn = true;                    
                    m++;        
                }
                i++;
                if(i == paginater.pageSize){                    
                    fullGenericObjMap.put(j,tempObj);
                    totalRowCount +=  tempObj.size();                   
                    errorMap.put(j,isError);
                    warnMap.put(j,isWarn);
                    m=0;
                    k = 0;
                    isError = false;
                    isWarn = false;
                    tempObj = new List<CalculateMasksLayer>();
                    i = 0;
                    j++;                                        
                }
            }
            if(!tempObj.isEmpty()){
                fullGenericObjMap.put(j,tempObj);
                errorMap.put(j,isError);
                warnMap.put(j,isWarn);
                totalRowCount += tempObj.size(); 
            }                        
        }
    }
    
    // Method to calculate the translation of GDS/GR masks and to map it with CPL.
    private List<CalculateMasksLayer> translateMaskLayer(String proposalId, Set<String> maskSet){
        Map<String,GDS_Layer__c> gdsLayerMap = new Map<String,GDS_Layer__c>();
        customer = '';
        ptNumber = '';
        Integer i=0;
        String masterAccShrtNm = '';
        
        // Get the records from GDS and put it in a map with customer,pt number,gds name,gds layer data type 
        // and gds layer number    
        for(GDS_Layer__c gdsl : [select    Name
                                           , Layer_Data_Type__c
                                           , Layer_Number__c
                                           , GDS__c
                                           , GDS__r.Customer__c
                                           , GDS__r.Master_Account_Short_Name__c
                                           , GDS__r.PT_Number__c
                                           , GDS__r.Quote_Proposal__c
                                           , GDS__r.Status__c
                                 from      GDS_Layer__c
                                 where     GDS__r.Quote_Proposal__c = :proposalId]){                      
            
            // Get the customer, pt number and gds status
            if(i==0){
                //customer = gdsl.GDS__r.Customer__c;
                ptNumber = gdsl.GDS__r.PT_Number__c;
                masterAccShrtNm = gdsl.GDS__r.Master_Account_Short_Name__c;
                //customer = (masterAccShrtNm!=null)?CPQ_Customer_Master_Acc_Shrt_Name_List__c.getInstance(masterAccShrtNm).GDS_Customer_Name__c:'';
                Map<String,CPQ_Customer_Master_Acc_Shrt_Name_List__c> cpqMstrAcctShNm = CPQ_Customer_Master_Acc_Shrt_Name_List__c.getAll();
                if(masterAccShrtNm!=null && cpqMstrAcctShNm.containsKey(masterAccShrtNm)){
                    customer = cpqMstrAcctShNm.get(masterAccShrtNm).GDS_Customer_Name__c;
                }else{
                    customer = '';
                }
                gdsId = gdsl.GDS__c;
                isGDSTranslate = (gdsl.GDS__r.Status__c=='Translating')?true:false;
                i++;
            }
            
            // Populate the gds layer map           
            /*gdsLayerMap.put(customer+'_'+gdsl.GDS__r.PT_Number__c+'_'+
                            gdsl.Name+'_'+gdsl.Layer_Data_Type__c+'_'+gdsl.Layer_Number__c,gdsl);*/
            gdsLayerMap.put(customer+'_'+gdsl.GDS__r.PT_Number__c+'_'+
                            gdsl.Layer_Data_Type__c+'_'+gdsl.Layer_Number__c,gdsl);                               
        }
        system.debug('gdsLayerMap.size() ==> '+gdsLayerMap.size());
        system.debug('gdsLayerMap ==> '+gdsLayerMap);
        
        Map<String, GDS_Layer__c> newGdsLayerMap = new Map<String,GDS_Layer__c>();
        Map<String,GR_Layer__c> newGrLayerMap = new Map<String,GR_Layer__c>();
        List<GDS_Layer__c> newGdsLayerList;
        Set<String> gdsLayerKeySet = new Set<String>();
        String gdsLayerMapKey='';
        Boolean isGRExist = false;
        Integer x=0;
        
        // Populate the gr layer map corresponding to each mask and do the matching process
        for(GR_Layer__c grLayer : [select    Id
                                             , Customer_Layer_Data_Type__c
                                             , Customer_Layer_Name__c
                                             , Customer_Layer_Number__c
                                             , GF_Layer_Data_Type__c
                                             , GF_Layer_Name__c
                                             , GF_Layer_Number__c
                                             , Mask_Layer__c
                                             , GR_Masterlist__c
                                             , GR_Masterlist__r.Customer__c
                                             , GR_Masterlist__r.PT_Number__c
                                             , Operation__c
                                   from      GR_Layer__c
                                   where     GR_Masterlist__r.Customer__c = :customer
                                   and       GR_Masterlist__r.PT_Number__c = :ptNumber
                                   and       Operation__c != 'boolean_common']){
            isGRExist = true;  
            
            if(x==0){
               grMasterLayerId = (String)grLayer.GR_Masterlist__c;
               x++; 
            }
            
            /*gdsLayerMapKey = grLayer.GR_Masterlist__r.Customer__c+'_'+grLayer.GR_Masterlist__r.PT_Number__c
                            +'_'+grLayer.Customer_Layer_Name__c+'_'+grLayer.Customer_Layer_Data_Type__c+'_'+grlayer.Customer_Layer_Number__c;*/
            gdsLayerMapKey = grLayer.GR_Masterlist__r.Customer__c+'_'+grLayer.GR_Masterlist__r.PT_Number__c
                            +'_'+grLayer.Customer_Layer_Data_Type__c+'_'+grlayer.Customer_Layer_Number__c;
            if(!gdsLayerMap.isEmpty() && gdsLayerMap.containsKey(gdsLayerMapKey)){
                GDS_Layer__c gdsLayer1 = gdsLayerMap.get(gdsLayerMapKey);
                system.debug('grLayer.Mask_Layer__c ==> '+grLayer.Mask_Layer__c);
                String key = (grLayer.Mask_Layer__c==null || grLayer.Mask_Layer__c=='' || grLayer.Mask_Layer__c=='-')?gdsLayerMapKey:gdsLayerMapKey+'_'+grLayer.Mask_Layer__c; 
                newGdsLayerMap.put(key,gdsLayer1);
                newGrLayerMap.put(key,grLayer);
                //gdsLayerKeySet.add(gdsLayerMapKey);
             
            }                                   
        }
        
        if(!isGRExist){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_NO_GR_SPEC')));
        }
        
        system.debug('newGdsLayerMap 1####'+newGdsLayerMap.size());   
        system.debug('newGrLayerMap 1####'+newGrLayerMap.size());
                
        Integer rowCount = 1;
        Boolean isError=false;
        Boolean isWarn=false;
        Integer j=0;
        Integer m=0;
        Set<String> gdsSet = new Set<String>();        
        
        // Populate the wrapper class records with gds layers, gr layers and cpl masks.
        for(String msk : maskSet){
            for(String key1: newGdsLayerMap.keySet()){
                if(key1!=null && key1!='' && key1.substring(key1.lastIndexOf('_')+1,key1.length())==msk){
                    GDS_Layer__c newGdsLayer = newGdsLayerMap.get(key1);
                    GR_Layer__c newGrLayer = newGrLayerMap.get(key1);
                    /*gdsLayerMapKey = newGdsLayer.Name+'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                                +'_'+newGrLayer.GF_Layer_Name__c+'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c);
                    gdsSet.add(newGdsLayer.Name+'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                                +'_'+newGrLayer.GF_Layer_Name__c+'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c));*/
                    gdsLayerMapKey = newGrLayer.GR_Masterlist__r.Customer__c+'_'+newGrLayer.GR_Masterlist__r.PT_Number__c
                                +'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c);
                    gdsSet.add(String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                                +'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c));                            
                    

                    calcMaskLayerList.add(new CalculateMasksLayer(  newGdsLayer.Name,
                                                                    (Integer)newGdsLayer.Layer_Data_Type__c,
                                                                    (Integer)newGdsLayer.Layer_Number__c,
                                                                    newGrLayer.GF_Layer_Name__c,
                                                                    (Integer)newGrLayer.GF_Layer_Data_Type__c,
                                                                    (Integer)newGrLayer.GF_Layer_Number__c,
                                                                    newGrLayer.Mask_Layer__c,
                                                                    msk,'success',(Integer)rowCount,newGrLayer.Id,newGrLayer.GR_Masterlist__c));
                    
                    rowCount++;
                    newGdsLayerMap.remove(msk);
                    newGrLayerMap.remove(msk);
                    maskSet.remove(msk);
                    gdsLayerKeySet.add(gdsLayerMapKey);
                }
            }
        }
        
        system.debug('newGdsLayerMap 2####'+newGdsLayerMap.size());   
        system.debug('newGrLayerMap 2#####'+newGrLayerMap.size());     
        
        
        // Populate the wrapper class records with gds layers, gr layers but there is no matching CPL masks.
        for(String msk : newGdsLayerMap.keySet()){
            if(newGrLayerMap.containsKey(msk)){
                GDS_Layer__c newGdsLayer = newGdsLayerMap.get(msk);
                GR_Layer__c newGrLayer = newGrLayerMap.get(msk);
                /*if(!gdsSet.contains(newGdsLayer.Name+'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                    +'_'+newGrLayer.GF_Layer_Name__c+'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c))){
                    gdsLayerMapKey = newGdsLayer.Name+'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                            +'_'+newGrLayer.GF_Layer_Name__c+'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c);*/
                if(!gdsSet.contains(String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                    +'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c))
                    && (newGrLayer.Mask_Layer__c==null || newGrLayer.Mask_Layer__c=='' || (newGrLayer.Mask_Layer__c=='-' && newGrLayer.Operation__c=='drop'))){
                    gdsLayerMapKey = newGrLayer.GR_Masterlist__r.Customer__c+'_'+newGrLayer.GR_Masterlist__r.PT_Number__c
                            +'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c);                                        
                                        
                    calcMaskLayerList.add(new CalculateMasksLayer(  newGdsLayer.Name,
                                                                (Integer)newGdsLayer.Layer_Data_Type__c,
                                                                (Integer)newGdsLayer.Layer_Number__c,
                                                                newGrLayer.GF_Layer_Name__c,
                                                                (Integer)newGrLayer.GF_Layer_Data_Type__c,
                                                                (Integer)newGrLayer.GF_Layer_Number__c,
                                                                newGrLayer.Mask_Layer__c,
                                                                '','success',(Integer)rowCount,newGrLayer.Id,newGrLayer.GR_Masterlist__c));     
                                                         
                    rowCount++;
                    /*if(j==0){
                        isError=true;
                        j++;
                    }*/
                    gdsLayerKeySet.add(gdsLayerMapKey);
                }
            }
        }
        
        // Populate the wrapper class records with gds layers, gr layers but there is no matching CPL masks.
        for(String msk : newGdsLayerMap.keySet()){
            if(newGrLayerMap.containsKey(msk)){
                GDS_Layer__c newGdsLayer = newGdsLayerMap.get(msk);
                GR_Layer__c newGrLayer = newGrLayerMap.get(msk);

                if(!gdsSet.contains(String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c)
                    +'_'+String.valueOf(newGrLayer.GF_Layer_Data_Type__c)+'_'+String.valueOf(newGrLayer.GF_Layer_Number__c))
                    && newGrLayer.Mask_Layer__c!=null && newGrLayer.Mask_Layer__c!='' 
                    && newGrLayer.Mask_Layer__c!='-' && newGrLayer.Operation__c!='drop'){
                    gdsLayerMapKey = newGrLayer.GR_Masterlist__r.Customer__c+'_'+newGrLayer.GR_Masterlist__r.PT_Number__c
                            +'_'+String.valueOf(newGdsLayer.Layer_Data_Type__c)+'_'+String.valueOf(newGdsLayer.Layer_Number__c);                                        
                                           
                    calcMaskLayerList.add(new CalculateMasksLayer(  newGdsLayer.Name,
                                                                (Integer)newGdsLayer.Layer_Data_Type__c,
                                                                (Integer)newGdsLayer.Layer_Number__c,
                                                                newGrLayer.GF_Layer_Name__c,
                                                                (Integer)newGrLayer.GF_Layer_Data_Type__c,
                                                                (Integer)newGrLayer.GF_Layer_Number__c,
                                                                newGrLayer.Mask_Layer__c,
                                                                '','warn',(Integer)rowCount,newGrLayer.Id,newGrLayer.GR_Masterlist__c));
                                                           
                    rowCount++;
                    if(m==0){
                        //isError=true;
                        isWarn=true;
                        m++;
                    }
                    gdsLayerKeySet.add(gdsLayerMapKey);
                }
            }
        }        
        
        system.debug('gdsLayerKeySet.size() ==> '+gdsLayerKeySet.size());
        // Remove the gds layers from the map if already the matching is done for those records.
        for(String gdsLayerKey : gdsLayerKeySet){
            gdsLayerMap.remove(gdsLayerKey);
        }
        
        system.debug('gdsLayerMap 1 ==> '+ gdsLayerMap );
        
        newGdsLayerList = (!gdsLayerMap.isEmpty())?gdsLayerMap.values():new List<GDS_Layer__c>();
        system.debug('newGdsLayerList ==> ' + newGdsLayerList);
        
        // Populate the wrapper class records with gds layers but no gr layers and no CPL masks.
        for(GDS_Layer__c gdsLayer : newGdsLayerList){
            calcMaskLayerList.add(new CalculateMasksLayer( gdsLayer.Name,
                                                           (Integer)gdsLayer.Layer_Data_Type__c,
                                                           (Integer)gdsLayer.Layer_Number__c,
                                                           '?',null,null,'','','error',rowCount,null,grMasterLayerId));
            rowCount++;
            if(j==0){
                isError=true;
                //isWarn=true;
                j++;
            }
        }        
        
        system.debug('grMasterLayerId ==> '+grMasterLayerId);
        // Populate the wrapper class records with CPL records but no corresponding gds layers or gr layers.
        for(String msk : maskSet){
            calcMaskLayerList.add(new CalculateMasksLayer('',null,null,'',null,null,'',msk,'error',rowCount,null,grMasterLayerId));
            rowCount++;
            if(j==0){
                isError=true;               
                j++;
            }
        }                
        
        // Check for translation mapping error
        if(isError){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_TRANSLATION_ERROR')));
            if(isUsrInGDSGroup){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorCode.get('CPQ_MULTI_SOURCE_ERR_FLG')));
            }
        }
        
        if(isWarn){
            if(isUsrInGDSGroup){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ErrorCode.get('CPQ_MULTI_SOURCE_WARN_CLICK_FLG')));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ErrorCode.get('CPQ_MULTI_SOURCE_WARN_FLG')));
            }
        }
        
        return calcMaskLayerList;        
        
    }
    
    // Retrieve the CPL masks from proposal mask set
    private Set<String> getMaskLayerSet(String proposalId){
        Set<String> maskLayerSet = new Set<String>();
        Apttus_Proposal__Proposal__c proposal = [select    id
                                                           /*, Mask_Set__c changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                           , Mask_Set_Long__c
                                                 from      Apttus_Proposal__Proposal__c
                                                 where     id = :proposalId];
        //String[] maskArr =  proposal.Mask_Set__c.split(' ');
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        String[] maskArr =  proposal.Mask_Set_Long__c.split(' ');
        for(String msk : maskArr){
            maskLayerSet.add(msk);
        }
        return maskLayerSet;
    }
     
    /*public PageReference changeData(){
        maskLayerListPerPage.clear();
        for(CalculateMasksLayer cml : fullGenericObjMap.get(paginater.index)){
            maskLayerListPerPage.add(cml);
        }
        system.debug('maskLayerListPerPage ==> '+maskLayerListPerPage);
        return null;
    }*/
    
    // Sort functionality of the Status field
    public PageReference sortByStatus(){              
        sortAscending = sortAscending?false:true;
        calcMaskLayerList = new List<CalculateMasksLayer>();
        //Integer rowcount = 1;
        for(Integer pageCount : fullGenericObjMap.keySet()){
            for(CalculateMasksLayer calcMskLyr : reverse(fullGenericObjMap.get(fullGenericObjMap.keySet().size()-1-pageCount))){
                /*calcMskLyr.rowCount = rowcount;
                rowcount++;*/
                calcMaskLayerList.add(calcMskLyr);
            }
        }        
        paginater.pageNum = 1;
        paginater.updateNumbers();
        fullGenericObjMap.clear();
        errorMap.clear();
        warnMap.clear();
        getCompMapPerPage();
        return null;
    } 
    
    // Reversing the calculate mask layer list
    private List<CalculateMasksLayer> reverse(List<CalculateMasksLayer> actualList){        
        List<CalculateMasksLayer> reverseList = new List<CalculateMasksLayer>();
        for (Integer i = actualList.size()-1;i>=0;i--){
            CalculateMasksLayer cml = actualList[i];
            reverseList.add(cml);
        }
        return reverseList;
    }     
}