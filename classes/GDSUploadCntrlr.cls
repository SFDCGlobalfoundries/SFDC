/*
    Author: Ariz Solito
    Description: Apex class controller for the VF GDSUpload
    History: 
        Asolito     16092014    - Code creation.
        ARoy        13012015    - modified code to include GDS Header controller code. 
*/
public class GDSUploadCntrlr {    
    public static final String STARTINDEX = 'PURPOSE';
    public static final String ENDINDEX = 'Waived Errors';
    public static final String STARTINDEX2 = 'Stream File';
    public static final String STARTSUBINDEX2 = 'File Name:';
    public static final String ENDINDEX2 = 'Format:';
    public static final String STARTINDEX3 = 'Top Cell Name:';
    public static final String ENDINDEX3 = 'Cell Lower-Left:';
    public static final Integer OFFSET = 50;    
    public static final String GDS_ADD_ROW_SECTION_VALIDATION = ErrorCode.get('GDS_ADD_ROW_SECTION_VALIDATION');
    public static final String GDS_LAYER_INFO_SECTION_VALIDATION = ErrorCode.get('GDS_LAYER_INFO_SECTION_VALIDATION');
    public static final String GDS_UPLOAD_FILE_VALIDATION = ErrorCode.get('GDS_UPLOAD_FILE_VALIDATION');
    public static final String GDS_TRANSLATE_VALIDATION = ErrorCode.get('GDS_TRANSLATE_VALIDATION'); 
    public static final String GDS_DELETE_ROW_VALIDATION = ErrorCode.get('GDS_DELETE_ROW_VALIDATION');       
    public String overrideGDS {get; set;}           
    public String configurationId {get; set;}
    public GDSMasterlist masterlist {get; set;}    
    //public String filename { get; set; }
    public String deleteRow {get; set;} 
    public String deleteNewRow {get; set;}
    public String retID1 {get; set;}  
    public String retID2 {get; set;}  
    public String retID3 {get; set;}  
    //public String productName {get; set;}
    //public String productRevision {get; set;} 
    public Integer pageNum {get; set;} 
    public transient Blob contentFile {get; set;} 
    public GDS__c gds {get; set;} 
    
    //========GDS Header variables=========//
 
    public String configID {get; set;}   
    public String id2 {get; set;}
    public String id3 {get; set;}
    public String id4 {get; set;}    
    public String translatedRowCount {get; set;}
    public Boolean isPortalUser {get; set;}
        
    private Apttus_Proposal__Proposal__c config;
    private Integer GDScount;
    
    //=====================================//      

    public GDSUploadCntrlr(){
        this.configID = ApexPages.currentPage().getParameters().get('id');
        this.configurationId = ApexPages.currentPage().getParameters().get('id');   
        this.retID1 =  ApexPages.currentPage().getParameters().get('id2');     
        this.retID2 =  ApexPages.currentPage().getParameters().get('id3');     
        this.retID3 =  ApexPages.currentPage().getParameters().get('id4'); 
        this.overrideGDS = ApexPages.currentPage().getParameters().get('override'); 
        this.pageNum = 1;
                        
    }
    
    //=========GDS Header Methods=========//
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
                }else if(g.status__c == 'Translating' && !(ApexPages.currentPage().getURL().contains('GDSUPLOAD'))){
                    return 'progtrckr-next-active';
                }
                 
            } 
            return 'progtrckr-todo';
                                         
        }
        set;
    }
    
    public PageReference back(){
        PageReference pageRef = new PageReference('/apex/ProposalSummary?retId=' + this.configurationId +
                                                  '&id='+ this.retID1 + '&businessObjectId=' + this.retID2 +
                                                  '&configRequestId='+ this.retID3);
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public PageReference backtoGDS(){   
        String url = '/apex/GDSUPLOAD?id=' + this.configurationId +
                     '&id2='+ this.retID1 + '&id3=' + this.retID2 +
                     '&id4='+ this.retID3;
                     
        //add override = true if translation stage is active             
        if(this.GDSTranslateStep == 'progtrckr-active'){
            url += '&override=true';    
        }                      
        PageReference pageRef = new PageReference(url);
                                                         
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public PageReference backtoTranslate(){   
        String url = '/apex/CPQTranslateMaskLayerPage?id=' + this.configurationId +
                     '&id2='+ this.retID1 + '&id3=' + this.retID2 +
                     '&id4='+ this.retID3;
                                               
        PageReference pageRef = new PageReference(url);
                                                         
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //====================================//
    
    public PageReference init(){
        
        //=========GDS Header Constructor=====//
        this.config = new Apttus_Proposal__Proposal__c();
        
        String GDSId;  
        for(Apttus_Proposal__Proposal__c rec: [SELECT product_name__c,product_revision__c,
                                                      (SELECT id,file_name__c,top_cell_name__c,status__c
                                                              FROM GDS__r
                                                              ORDER BY createdDate DESC
                                                              LIMIT 1)
                                                 FROM Apttus_Proposal__Proposal__c
                                                 WHERE id = :ApexPages.currentPage().getParameters().get('id')]){
            this.config = rec; 
            for(GDS__c g: rec.GDS__r){            
                GDSId = g.id;         
            }
        } 
        
        //get the GDS row count if any
        this.GDSCount = [SELECT count() 
                           FROM GDS_Layer__c 
                           WHERE gds__c = :GDSId]; 
                        
        //check if current user is internal or portal user
        this.isPortalUser = false;
        for(User u: [SELECT contactid 
                       FROM User 
                       WHERE id = :userinfo.getUserId()]){
            if(UtilsString.isNotBlank(u.contactId)){                       
                this.isPortalUser = true;                               
            }
        } 
        
        //====================================//
        
        PageReference pageRef;
        this.gds = new GDS__c();
        
        for(GDS__c g: [SELECT id,status__c,file_name__c,top_cell_name__c,quote_proposal__r.product_name__c,
                              quote_proposal__r.product_revision__c 
                         FROM GDS__c
                         WHERE quote_proposal__c = :this.configurationID]){
            this.gds = g; 
            this.productName = g.quote_proposal__r.product_name__c;
            this.productRevision = g.quote_proposal__r.product_revision__c;
                                    
            //redirect to the translation page if status = translating              
            if(g.status__c == 'Translating' && this.overrideGDS <> 'true'){                                                                          
                pageRef = new PageReference('/apex/CPQTranslateMaskLayerPage?id=' + this.configurationId +
                                                          '&id2='+ this.retID1 + '&id3=' + this.retID2 +
                                                          '&id4='+ this.retID3);                                                          
                pageRef.setRedirect(true);
                return pageRef;                            
            } else {                        
                this.masterList = new GDSMasterlist(g);                                         
                return pageRef;                            
            }            
        } 
        
        //No GDS record yet
        
        //get the product name and revision from the configuration
        for(Apttus_Proposal__Proposal__c p: [SELECT product_name__c,product_revision__c
                                               FROM Apttus_Proposal__Proposal__c
                                               WHERE id = :this.configurationID]){
            this.productName = p.product_name__c;
            this.productRevision = p.product_revision__c;                                               
        }                                               
        
        this.masterList = new GDSMasterlist(this.configurationId); 
        return pageRef;                                                                  
    }
    
    public PageReference uploadGDS(){
        if(this.contentFile <> null){
            this.masterlist.uploadGDS(this.contentFile);
            this.masterlist.validate();
        }
        return null;
    }
    
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/' + this.configurationId);
        pageRef.setRedirect(true);
        return pageRef;     
    }
    
    /*public PageReference back(){  
        PageReference pageRef = new PageReference('/apex/ProposalSummary?retId=' + this.configurationId +
                                                  '&id='+ this.retID1 + '&businessObjectId=' + this.retID2 +
                                                  '&configRequestId='+ this.retID3);
        pageRef.setRedirect(true);
        return pageRef;
    }*/
    
    public PageReference translate(){
        if(this.masterlist.validate()){
            if(this.masterlist.validateTranslate()){                   
                //override GDS by internal users during translation process
                if(this.overrideGDS == 'true'){
                    this.masterlist.save();
                    PageReference pageRef = new PageReference('/apex/CPQTranslateMaskLayerPage?id=' + this.configurationId +
                                                                  '&id2='+ this.retID1 + '&id3=' + this.retID2 +
                                                                  '&id4='+ this.retID3);
                    pageRef.setRedirect(true);
                    return pageRef;
                //customer initiates the translation process                    
                } else {
                    this.masterlist.save();
                    
                    if(this.masterlist.translate()){
                        PageReference pageRef = new PageReference('/apex/CPQTranslateMaskLayerPage?id=' + this.configurationId +
                                                                  '&id2='+ this.retID1 + '&id3=' + this.retID2 +
                                                                  '&id4='+ this.retID3);
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                }                    
            }
        }
        return null;
    }
    
    public PageReference save(){
        if(this.masterlist.validate()){
            this.masterlist.save();
            init();          
        }                
        return null;
    }
    
    public PageReference movePage(){
        this.masterlist.movePage(this.pageNum);
        return null;
    }
    
    public PageReference addLayer(){      
        this.masterlist.addLayer();
        return null;  
    }
    
    public PageReference deleteLayer(){      
        this.masterlist.deleteLayer(this.deleteRow);
        return null;  
    }
    
    public PageReference deleteNewLayer(){       
        this.masterlist.deleteNewLayer(this.deleteNewRow); 
        return null;  
    }       
        
    public class GDSMasterlist {
        public Map<Integer,List<GDSLayer>> pages {get; set;}        
        public List<GDSLayer> layers {get; set;}
        public List<GDSLayer> addedLayers {get; set;}   
        public List<PageNumber> pageNumbers {get; set;} 
        public Integer pageNumber {get; set;}   
        public Integer layerCount {get; set;}                   
        public GDS__c gds {get; set;}     
        public String fileName {get; set;}
        public String topCellName {get; set;}        
        private List<GDSLayer> deleteLayers;
        private String configurationID;        
        private String filterContent;  
        private Blob contentFile; 
        
        public GDSMasterlist(GDS__c g){
            this.configurationID = configurationID;
            this.layers = new List<GDSLayer>();
            this.deletelayers = new List<GDSLayer>();
            this.pages = new Map<Integer,List<GDSLayer>>();
            this.pageNumbers = new List<PageNumber>();
            this.addedLayers = new List<GDSLayer>();                                   
            this.gds = g; 
            this.fileName = this.gds.file_name__c;
            this.topCellName = this.gds.top_cell_name__c;
                          
                         
            List<GDS_Layer__c> layers = [SELECT name,layer_data_type__c,layer_number__c,purpose__c
                                           FROM GDS_Layer__c
                                           WHERE gds__c = :this.gds.id
                                           ORDER BY layer_number__c];
                                        
            generateRows(layers);  
            paginate();                                                  
        }                
                        
        
        public GDSMasterlist(String configurationID){
            this.configurationID = configurationID;
            this.layers = new List<GDSLayer>();
            this.deletelayers = new List<GDSLayer>();
            this.pages = new Map<Integer,List<GDSLayer>>();
            this.pageNumbers = new List<PageNumber>();
            this.addedLayers = new List<GDSLayer>();                                   
            this.gds = new GDS__c();                                                                                            
        } 
        
        public Boolean validateTranslate(){
            if(this.gds.id == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,GDS_TRANSLATE_VALIDATION);
                ApexPages.addMessage(myMsg);
                
                return false;
            } else {
                Integer count = [SELECT count() FROM GDS_Layer__c WHERE gds__c = :this.gds.id];
                
                if(count == 0){                                        
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,GDS_TRANSLATE_VALIDATION);
                    ApexPages.addMessage(myMsg);
                    
                    return false;    
                }
            }
            return true;
        }               
        
        public void uploadGDS(Blob contentFile){ 
            try {   
                this.contentFile = contentFile;                
                String rawData = contentFile.toString(); 
                
                //get the file name
                String fileNameContent =  rawData.substring(rawData.lastIndexOf(STARTINDEX2) + STARTINDEX2.length(),
                                                            rawData.indexOf(ENDINDEX2));
                this.fileName = fileNameContent.substring(fileNameContent.indexOf(STARTSUBINDEX2) + STARTSUBINDEX2.length()).deleteWhiteSpace();
                
                //get top cell name
                this.topCellName =  rawData.substring(rawData.lastIndexOf(STARTINDEX3) + STARTINDEX3.length(),
                                                           rawData.indexOf(ENDINDEX3));                
                
                //get the layer information          
                this.filterContent = rawData.substring(rawData.indexOf(STARTINDEX) + STARTINDEX.length(),
                                                       rawData.indexOf(ENDINDEX));
                
                //flag for delete existing GDS layers                                                                       
                if(this.layers.size() > 0){
                    for(GDSLayer g: this.layers){
                        g.isDeleted = true;
                    }                     
                }                                                                           
                generateRows(this.filterContent); 
                paginate();                                                                                                       
            } catch (Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, GDS_UPLOAD_FILE_VALIDATION);
                ApexPages.addMessage(myMsg);                
            }
        }
        
        //generate rows for existing GDS data
        private void generateRows(List<GDS_Layer__c> layers){
            Integer rowCount = 1;                       
            for(GDS_Layer__c l: layers){
                GDSLayer layer = new GDSLayer(l,rowCount);
                this.layers.add(layer);                 
                            
                rowCount++;
            }  
            this.layerCount = rowCount;                                                                                                     
        }
        
        //generate rows for new GDS upload data
        private void generateRows(String filteredData){
            Integer rowCount = 1;                      
            for(String f: filteredData.split('\n')){
                //check for whitespace
                String temp = f.deleteWhiteSpace();
                                
                if(UtilsString.isNotblank(temp)){                    
                    GDSLayer layer = new GDSLayer(f,rowCount);
                    this.layers.add(layer);                   
                                      
                    rowCount++;
                }
            } 
            this.layerCount = rowCount;                                                                                                
        }
        
        //generate the GDS data pages
        private void paginate(){
            Integer pageCount = 1;
            Integer counter = 1;
            this.pages = new Map<Integer,List<GDSLayer>>();
            this.pageNumbers = new List<PageNumber>();
            
            Boolean hasPageError = false;
            
            List<GDSLayer> currLayers = new List<GDSLayer>();
            for(GDSLayer g: this.layers){
                if(!g.isDeleted){
                    currLayers.add(g);
                }
            }
            
            for(Integer count = 0; count < currLayers.size(); count++){
                if(counter < OFFSET){                        
                    //flag the page if its rows has an error 
                    //to highlight it in the VF
                    if(currLayers[count].hasValidationError || currLayers[count].hasNumericError || 
                       currLayers[count].hasDuplicateError){
                        hasPageError = true;
                    }
                    
                    if(this.pages.containsKey(pageCount)){
                        this.pages.get(pageCount).add(currLayers[count]);                                                
                    } else {
                        this.pages.put(pageCount, new list<GDSLayer>{currLayers[count]});
                    }                                                
                    
                    //last page
                    if(count == currLayers.size()-1){
                        this.pageNumbers.add(new PageNumber(pageCount,hasPageError));    
                    }
                    counter++;
                } else {
                    this.pages.get(pageCount).add(currLayers[count]);                   
                    this.pageNumbers.add(new PageNumber(pageCount,hasPageError));
                    hasPageError = false;
                    pageCount++;
                    counter = 1;
                }                
            }                                                                                  
            
            //set the page number to one if pageNumber is null
            //for pages instantiation
            if(this.pageNumber == null){
                if(this.pages.containsKey(1)){
                    this.pageNumber = 1;
                }
            }
        }
        
        //regerenate the row count of the layers
        private void regenerateNewRowCount(){
            Integer counter = 1;            
            for(GDSLayer g: this.addedLayers){               
                g.rowCount = counter;
                counter++;              
            }          
        } 
        
        //regerenate the row count of the layers
        private void regenerateRowCount(){
            Integer counter = 1;
            for(Integer key: this.pages.keyset()){
                for(GDSLayer g: this.pages.get(key)){
                    if(!g.isDeleted){
                        g.rowCount = counter;
                        counter++;
                    }
                }
            }          
        }
        
        //create attachment
        private void createAttachment(){
            Attachment a = new Attachment();
            a.Body = this.contentFile;
            a.name = 'GDS.readme';
            a.parentID = this.gds.id;
            insert a;
        }
        
        //fire the approval process
        public Boolean translate(){
            try {                                          
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting GDS for translation.');
                req.setObjectId(this.gds.id);
                
                // Submit on behalf of a specific submitter
                Approval.ProcessResult result = Approval.process(req);  
                return true;           
            } catch (Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(myMsg); 
                System.debug(e);
                return false;             
            } 
        }                                        
        
        //Remove an an existing layer
        public void deleteLayer(String currRow){
            if(this.pages.containsKey(this.pageNumber)){
                List<GDSLayer> lst = this.pages.get(this.pageNumber);
                Integer deleteRowIndex;
                for(integer counter = 0; counter < lst.size(); counter++){
                    if(lst[counter].rowCount == Integer.valueOf(currRow)){                        
                        deleteRowIndex = counter;
                        break;
                    }    
                }
                
                //at least 1 layer row remaining is mandatory 
                Integer rowCount = 0;
                for(GDSLayer g: this.layers){
                    if(!g.isDeleted){
                        rowCount++;
                        
                        if(rowCount > 1){
                            break;
                        }
                    }
                }
                 
                if(rowCount > 1){
                    //remove the layer from the page                
                    if(deleteRowIndex <> null){
                        lst[deleteRowIndex].isDeleted = true;
                        lst.remove(deleteRowIndex); 
                        regenerateRowCount();
                        paginate();
                        validate();
                    } 
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, GDS_DELETE_ROW_VALIDATION);
                    ApexPages.addMessage(myMsg);               
                }                                                               
            }    
                      
        }
        
        //Remove an added layer
        public void deleteNewLayer(String currRow){
            Integer row = Integer.valueOf(currRow);           
            this.addedLayers.remove(row-1); 
            validate();          
        }        
        
        //Add a new layer
        public void addLayer(){                       
            this.addedLayers.add(new GDSLayer(this.addedLayers.size()+1));            
        }
        
        //Traverse to the pages
        public void movePage(Integer pageNum){
            this.pageNumber = pageNum;               
        }               
        
        //Save the Layers
        public void save(){
            try {
                //new GDS
                if(this.gds.id == null){
                    //insert GDS
                    this.gds.quote_proposal__c = this.configurationID;
                    this.gds.file_name__c = this.fileName;
                    this.gds.top_cell_name__c = this.topCellName;
                    insert this.gds;
                                      
                    List<GDS_Layer__c> insertLayers = new List<GDS_Layer__c>();
                    for(GDSLayer g: this.layers){ 
                        if(!g.isDeleted){                      
                            GDS_Layer__c temp = g.getLayer();
                            temp.GDS__c = this.gds.id;
                            insertLayers.add(temp);                       
                        }
                    } 
                    
                    for(GDSLayer g: this.addedLayers){ 
                        if(g.isNotBlank){                      
                            GDS_Layer__c temp = g.getLayer();
                            temp.GDS__c = this.gds.id;
                            insertLayers.add(temp);                       
                        }
                    }                      
                    insert insertLayers; 
                    
                    if(this.contentFile <> null){
                        createAttachment();
                    }                                       
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'GDS Layer Information saved.');
                    ApexPages.addMessage(myMsg); 
                } else {
                    //update existing GDS or delete flagged records
                    List<GDS_Layer__c> insertLayers = new List<GDS_Layer__c>();
                    List<GDS_Layer__c> updateLayers = new List<GDS_Layer__c>();                    
                    List<GDS_Layer__c> deleteLayers = new List<GDS_Layer__c>();                    
                                  
                    
                    for(GDSLayer g: this.layers){ 
                        //deleted layers
                        if(g.isDeleted){ 
                            //check if existing GDS Layer
                            GDS_Layer__c temp = g.getOldLayer();
                            
                            if(temp.id <> null){
                                deleteLayers.add(temp);
                            }
                        //new or updated layers                              
                        } else {
                            if(g.layer.id == null){
                                GDS_Layer__c temp = g.getLayer();
                                temp.GDS__c = this.gds.id;
                                insertLayers.add(temp);   
                            } else {
                                updateLayers.add(g.getLayer());                     
                            } 
                        }
                    }
                                     
                    
                    //insert new GDS Layers                                                                           
                    for(GDSLayer g: this.addedLayers){
                        if(g.isNotBlank){
                            GDS_Layer__c temp = g.getLayer();
                            temp.GDS__c = this.gds.id;
                            insertLayers.add(temp);    
                        }
                    } 
                    
                    insert insertLayers;    
                    update updateLayers;    
                    delete deleteLayers; 
                    
                    if(this.contentFile <> null){
                        createAttachment();
                    }
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'GDS Layer Information saved.');
                    ApexPages.addMessage(myMsg);    
                }
                
                
            } catch (Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(myMsg); 
                System.debug(e);                
            }            
        }                             
        
        //Validate the layers       
        public Boolean validate(){            
            Boolean hasValidationError = false;
            Boolean hasNewValidationError = false;
            Set<String> checkUniqueLayers = new Set<String>();
            
            //validate existing or uploaded layers                                                   
            for(GDSLayer l: this.layers){
                if(!l.isDeleted){
                    if(l.validate()){
                        //check for uniqueness error if no prior validation error during the parsing
                        if(checkUniqueLayers.contains(l.key)){
                            l.hasDuplicateError = true;
                            hasValidationError = true;
                        } else {
                            checkUniqueLayers.add(l.key);    
                        }                    
                    } else {                   
                        hasValidationError = true;
                    }
                }
            } 
            
            //validate added layers                                                   
            for(GDSLayer l: this.addedLayers){              
                if(l.validate2()){
                    //check for uniqueness error if no prior validation error during the parsing
                    if(checkUniqueLayers.contains(l.key)){
                        l.hasDuplicateError = true;
                        hasNewValidationError = true;
                    } else {
                        checkUniqueLayers.add(l.key);    
                    }                    
                } else {                   
                    hasNewValidationError = true;
                }           
            }                                               

            if(hasValidationError){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, GDS_LAYER_INFO_SECTION_VALIDATION);
                ApexPages.addMessage(myMsg); 
                
                //refresh page numbers with errors
                paginate();                                   
            }
            
            if(hasNewValidationError){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, GDS_ADD_ROW_SECTION_VALIDATION);
                ApexPages.addMessage(myMsg);                                                        
            }
            
            if(hasValidationError || hasNewValidationError){               
                return false;      
            }
                      
            return true;
        }                
    }
    
    public class PageNumber {
        public Integer pageNum {get; set;} 
        public Boolean hasError {get; set;}
        
        public PageNumber(Integer pageNum, Boolean hasError){            
            this.pageNum = pageNum;
            this.hasError = hasError;
        }
    }
    
    public class GDSLayer {
        public String name {get; set;}
        public String layerNumber {get; set;}
        public String layerDataType {get; set;}
        public String purpose {get; set;}
        public String key {get; set;}
        public Boolean hasValidationError {get; set;}   
        public Boolean hasNumericError {get; set;}   
        public Boolean hasDuplicateError {get; set;}       
        public Integer rowCount {get; set;}
        public GDS_Layer__c layer;
        public Boolean isDeleted;
        public Boolean isNotBlank;
        
        //new layer row instantiate
        public GDSLayer(Integer rowCount){
            this.layer = new GDS_Layer__c();
            this.hasValidationError = false;
            this.hasDuplicateError = false;  
            this.hasNumericError = false;           
            this.rowCount = rowCount;
            this.isDeleted = false;
            this.isNotBlank = false;
        }
        
        //existing GDS layer row instantiate
        public GDSLayer(GDS_Layer__c layer,Integer rowCount){
            this.hasValidationError = false;  
            this.hasDuplicateError = false;  
            this.hasNumericError = false;                              
            this.layer = layer;   
            this.name = layer.name;
            this.layerNumber = String.valueOf(layer.layer_number__c);
            this.layerDataType = String.valueOf(layer.layer_data_type__c);  
            this.purpose = layer.purpose__c;          
            this.rowCount = rowCount; 
            this.isDeleted = false;                                          
        }  
        
        //Uploaded GDS layer information from the file instantiate
        public GDSLayer(String layer,Integer rowCount){
            this.hasValidationError = false;
            this.hasDuplicateError = false;   
            this.hasNumericError = false;                     
            this.rowCount = rowCount;
            this.isDeleted = false;            
            this.layer = new GDS_Layer__c();
            parse(layer);                        
        }
        
        //Return the default layer
        public GDS_Layer__c getOldLayer(){           
            return this.layer;
        } 
        
        //Return the updated layer
        public GDS_Layer__c getLayer(){           
            this.layer.name = this.name;
            this.layer.layer_data_type__c = Decimal.valueOf(this.layerDataType);
            this.layer.layer_number__c = Decimal.valueOf(this.layerNumber); 
            this.layer.purpose__c = this.purpose;
            return this.layer;        
        } 
        
        //Generic validation for data type and layer number
        private Boolean validateNumeric(){
            //wrong data type should be numeric for data type and layer number
            Pattern isnumbers = Pattern.Compile('^[0-9]+$');
            
            Matcher isNumeric = isnumbers.matcher(this.layerNumber);            
            if(!isNumeric.matches()){               
                return true;   
            }
            
            isNumeric = isnumbers.matcher(this.layerDataType);            
            if(!isNumeric.matches()){              
                return true;   
            }
            return false;
        }
        
        //validate the columns from existing GDS layer
        public Boolean validate(){
            this.hasDuplicateError = false;
            this.hasValidationError = false;
            this.hasNumericError = false;
            
            if(!UtilsString.isNotBlank(this.layerNumber) || !UtilsString.isNotBlank(this.layerDataType) ||
               !UtilsString.isNotBlank(this.name) || !UtilsString.isNotBlank(this.purpose)){               
                this.hasValidationError = true; 
            } else {
                //regenerate the key 
                this.key = this.layerNumber + this.layerDataType;
            }
            
            //numeric validation 
            this.hasNumericError = validateNumeric();
            
            if(this.hasValidationError || this.hasNumericError){
                return false;
            }
            return true;
        }  
        
        //Added layer validation
        public Boolean validate2(){
            this.isNotBlank = false;
            this.hasValidationError = false;
            this.hasNumericError = false;
            this.hasDuplicateError = false;
            
            //call normal validation 
            if(UtilsString.isNotBlank(this.layerNumber) || UtilsString.isNotBlank(this.layerDataType) ||
               UtilsString.isNotBlank(this.name) || UtilsString.isNotBlank(this.purpose)){ 
               this.isNotBlank = true;
               return validate();                        
            } 
            
            //bypass validation if rows is blank
            return true;
        }                
        
        private void parse(String layer){                                             
            List<String> layerInfo = layer.normalizeSpace().split(' ');
            
            //counter for columns
            //1 - layer number
            //2 - layer data type
            //3 - name
            //4 - purpose 
            for(Integer counter = 0; counter < layerInfo.size(); counter++){
                if(counter == 0){
                    this.layerNumber = layerInfo[counter];
                    this.key += layerInfo[counter];
                } else if(counter == 1){
                    this.layerDataType = layerInfo[counter];
                    this.key += layerInfo[counter];
                } else if(counter == 2){
                    this.name = layerInfo[counter];
                } else if(counter == 3){
                    this.purpose = layerInfo[counter];
                }                
            }                                   
            
            validate();                                                                                                                                
        }    
    }
}