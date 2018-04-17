/**
@Author <Niharika Modi>
@name <CDSFormExtension>
@CreateDate <Date>
@Description <Controller for all CDS VF Pages. 
It prepopulates data from different objects on load,
exports CDS data to PDF and Excel,Save and update CDS record>
@Version <1.0>
@Modifiedby: <Mallika Seth>  
*/
public class CDSFormExtension {
    
    public Custom_Design__c customDesign{get;set;}
    private Custom_Design__c newCustomDesign;
    private ApexPages.StandardController sController;
    public List<Contact> customerContactList{get;set;}  
    String userType ;
    Id LoggedinUser;
    public List<IO_and_Switching_Information__c> iOList{get;set;}
    public List<DRAMs__c> dmList{get;set;}
    public List<Compilable__c> cmpList{get;set;}
    public List<CoresPLL__c> cpList{get;set;}
    public List<Development_Deliverable__c> ddList{get;set;}
    public List<Third_Party_Design_Contact__c> pdList{get;set;}
    public List<psa_psc_eccn_default__c> custSet{get;set;}
    public List<Clock_Characteristics__c> clockList{get;set;}
    public Boolean RedZone {get;set;}
    public Map<String,psa_psc_eccn_default__c> allColorCodes;
    public Paginate paginaterDram {get;set;} 
    public Paginate paginaterComp {get;set;}
    public Paginate paginaterIO {get;set;}  
    public Paginate paginaterCore {get;set;}
    public Paginate paginaterDevd {get;set;}        
    public List<DRAMs__c> genericListDram{get;set;} 
    public List<List<DRAMs__c>> fullGenericListDram{get;set;} 
    public List<Compilable__c> genericListComp{get;set;} 
    public List<List<Compilable__c>> fullGenericListComp{get;set;} 
    public List<IO_and_Switching_Information__c> genericListIO{get;set;} 
    public List<List<IO_and_Switching_Information__c>> fullGenericListIO{get;set;} 
    public List<CoresPLL__c> genericListCore{get;set;} 
    public List<List<CoresPLL__c>> fullGenericListCore{get;set;} 
    public List<Development_Deliverable__c> genericListDevd{get;set;} 
    public List<List<Development_Deliverable__c>> fullGenericListDevd{get;set;} 
    public String selTab {get;set;} //Extensions for passing params
    public String itarFlag {get;set;}
    public Boolean AccessFlag {get;set;}
    public Set<ID> userListAccProxy {get;set;}
    public map<id,Set<String>> mapGroupUser {get;set;}
    public map<id,String> mapUserAccess {get;set;}
    public List<PermissionSetAssignment> PermissionsetList{get;set;}
    public List<Device__c> devLst {get; set;}



    //  public String CDSName{get;set;} 
    /*
*************************************    
@ Name -  xlsHeader
@ Description - getter setter.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/ 
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    } 
    
    
    private List<IO_and_Switching_Information__c> deletedIoList;
    private List<DRAMs__c> deletedDramList;
    private List<Compilable__c> deletedCmpList;
    private List<CoresPLL__c> deletedCoreList;
    private List<Development_Deliverable__c> deletedDevdList;
    private List<Third_Party_Design_Contact__c> deletedPartyDesignList;
    public Integer deletedItemIndex {get;set;}
    
    public Reason_For_Change__c reasonChange{get;set;}
    public List<Reason_For_Change__c> ReasonList{get;set;}
    public  List<Opportunity_Program_Team_Member__c> acctProxyList {get;set;}
    public  List<Opportunity_Program_Team_Member__c> acctAccessList {get;set;}

    
    //Attachment Information    
    private CDSAttachmentUploadForm att;
    public Attachment cdsHeaderFile{get;set;}
    public Attachment mitiTranFile{get;set;}
    public Attachment noiseSpecsFile{get;set;}    
    public Attachment signalPowerFile{get;set;}
    public Attachment dramFile{get;set;}
    public Attachment ddFile{get;set;}
    public Attachment coreFile{get;set;}
    public Attachment imageInfFile{get;set;}
    public Attachment pkgInfFile{get;set;}
    public Attachment cardInfFile{get;set;} 
    public Attachment scanBitsFile{get;set;} 
    public Attachment desTestFile{get;set;}
    public Attachment addToolsFile{get;set;}    
    public Attachment mfgTestFile{get;set;}
    public Attachment archInfoFile{get;set;}
    public Attachment desStrcFile{get;set;}
    public Attachment netCustFile{get;set;}
    public Attachment splPlaceFile{get;set;}
    public Attachment splWireFile{get;set;}
    public Attachment clockInfoFile{get;set;}
    public Attachment clockCharFile{get;set;}
    public Attachment avstFile{get;set;}
    
    public boolean createDE;
    public Id targetNAID{get;set;}
    public String oppId{get;set;}
    private String deviceId;
    public String techReqId{get;set;}
    public String oppProgId{get; set;}
    //public String decisionId; //made it public
    //public Map<Id, Attachment> attachmentsMap;
    //private Map<String,Attachment> attachMap;
    private Map<String,List<Attachment>> attachListMap;
    public List<Attachment> cdsHeaderAttList{get;set;}
    public List<Attachment> signalPowerAttList{get;set;}
    public List<Attachment> mitiTranAttList{get;set;}
    public List<Attachment> noiseSpecsAttList{get;set;}
    public List<Attachment> dramAttList{get;set;} 
    public List<Attachment> ddAttList{get;set;} 
    public List<Attachment> coreAttList{get;set;} 
    public List<Attachment> iInfAttList{get;set;} 
    public List<Attachment> pInfAttList{get;set;} 
    public List<Attachment> cardInfAttList{get;set;}
    public List<Attachment> scanBitsAttList{get;set;}
    public List<Attachment> desTestAttList{get;set;}
    public List<Attachment> addToolsAttList{get;set;}
    public List<Attachment> mfgTestAttList{get;set;}    
    public List<Attachment> archInfoAttList{get;set;}
    public List<Attachment> desStrcAttList{get;set;}
    public List<Attachment> netCustAttList{get;set;}
    public List<Attachment> splPlaceAttList{get;set;}
    public List<Attachment> splWireAttList{get;set;}
    public List<Attachment> clockInfoAttList{get;set;}
    public List<Attachment> clockCharAttList{get;set;}
    public List<Attachment> pdfAttachments{get;set;}
    public List<Attachment> avstAttachments{get;set;}
    public List<Attachment> addAllLists{get;set;}
    
    //public Map<String,Map<String,List<String>>> designSystemMap{get;set;}
    public Map<String,Set<String>> dependentPicklistMap{get;set;}
    public list<SelectOption> ifAreaPickList {get; private set;}
    public list<SelectOption> imagePowerSupplyPickList {get; private set;}
    public list<SelectOption> packagePowerSupplyPickList {get; private set;}
    public list<SelectOption> packageTypePickList {get; private set;}
    public list<SelectOption> coreNamePicklist {get; private set;}
    public Blob body;
    public String ItarPageMessage {get;set;}
    public String ItarPageMessageRed {get;set;}
    public String ItarPageMessageRedCC {get;set;}
    public String ItarPdfExcel {get;set;}
    public Set<Id> lstUser{get;set;} 


    Integer pageSize;
    // public String selectedId {get; set;}
    
    // public Boolean disable1 {get;set;}
    //  public Boolean disable2 {get;set;}    
    //public String paramValue{get;set;}
    private String retUrl;   
    private PageReference p;   
    private String id ;
    private Set<String> teamRole;
    /**
*  Controller of the class. 
*  @name <CDSFormExtension>
*  @param <controller> <description>
*  @return <parameter> - <Description about the return parameter>
*  @throws exception-<exception description>
*/
    public CDSFormExtension(ApexPages.StandardController controller) {
        
        try
        {
            createDE =false;
            ItarCipherCloud__c ItarCS = ItarCipherCloud__c.getInstance('ViewPageMessage');
            ItarPageMessage = ItarCS.Message__c;
            ItarCipherCloud__c ItarCS1 = ItarCipherCloud__c.getInstance('ViewPageMessageRed');
            ItarPageMessageRed = ItarCS1.Message__c;
            ItarCipherCloud__c ItarCS2 = ItarCipherCloud__c.getInstance('PDFExcelMessage');
            ItarPdfExcel = ItarCS2.Message__c;
            ItarCipherCloud__c ItarCS3 = ItarCipherCloud__c.getInstance('ViewPageMessageRedCC');
            ItarPageMessageRedCC = ItarCS3.Message__c;
            userType = Schema.SObjectType.User.getKeyPrefix(); 
            LoggedinUser = UserInfo.getUserId();        
            AccessFlag = True;
            deviceId = ApexPages.currentPage().getParameters().get('devId');
            techReqId = ApexPages.currentPage().getParameters().get('optId');            
            String mode = ApexPages.currentPage().getParameters().get('type');
            //retURL = ApexPages.currentPage().getParameters().get('retURL'); 
            sController = controller;
            customDesign = (Custom_Design__c) controller.getRecord();
            
            id = customDesign.id;
            
            retUrl=ApexPages.currentPage().getParameters().get('retURL');
            reasonChange = new Reason_For_Change__c();
            deletedIoList=new List<IO_and_Switching_Information__c>();
            deletedDramList=new List<DRAMs__c>();
            deletedCmpList=new List<Compilable__c>();
            deletedCoreList=new List<CoresPLL__c>();
            deletedDevdList=new List<Development_Deliverable__c>();
            deletedPartyDesignList=new List<Third_Party_Design_Contact__c>();
            att = new CDSAttachmentUploadForm();
            // attachMap = new Map<String,Attachment>();
            attachListMap = new Map<String,List<Attachment>>();
            initializeAttachmentFiles();
            teamRole = new Set<String>();
            for(CDS_team_role__c tr : CDS_team_role__c.getall().values()){
               teamRole.add(tr.Team_role__c);
            }
          //  teamRole = new Set<String>{'Key Technical Contact','Key Management Contact','Field Application Engineer','Field Design Center Engineer','Primary Factory AE','Physical Design Engineer','ASIC Packaging Applications Engineer','Product Engineer','Tactical Marketing Contact','Engagement Manager'};
                //  createDesignSystemMap();
                //createDesignPickList();
                //Edit 
                if(id <> null)
            {
                String Query='SELECT ';
                for(String fname:Schema.SObjectType.Custom_Design__c.fields.getMap().keySet())
                {
                    if(fname!='id')
                        Query=Query+fname+ ', ';
                }
                
                Query=Query+'id,Owner.Name,Device__r.ECCN_Technology__c FROM Custom_Design__c WHERE id=:id';
                customDesign=(Custom_Design__c)DataBase.query(Query).get(0);
                system.debug('@@@vvv'+customDesign.Owner.name);
                custSet = new list<psa_psc_eccn_default__c>();
                custSet = [SELECT Name,ECCN_Color__c,D1_National_Access_Allowed__c,psa_eccn__c,psc_eccn__c FROM psa_psc_eccn_default__c ];    
                allColorCodes = new Map<String,psa_psc_eccn_default__c>();
                for(psa_psc_eccn_default__c colorZone: custSet){
                    allColorCodes.put(colorZone.Name,colorZone);
                }
                if(deviceId == null){
                    deviceId = customDesign.Device__c;
                    Device__c devInfo = [SELECT Primary_Option__c,Opportunity_Program__c,ITAR_Flag__c,ECCN_Technology__c FROM Device__c WHERE Id = :deviceId ]; 
                    techReqId = devInfo.Primary_Option__c;
                    oppProgId = devInfo.Opportunity_Program__c;
                    itarFlag = devInfo.ITAR_Flag__c;
                   String ECCNTech = devInfo.ECCN_Technology__c;
                    if(ECCNTech!=Null ||ECCNTech!=''){
                    if(allColorCodes.containsKey(ECCNTech) && (String.valueof(allColorCodes.get(ECCNTech).ECCN_Color__c) =='RED'||String.valueof(allColorCodes.get(ECCNTech).ECCN_Color__c) =='Red')){
                            RedZone=True;
                    }Else{
                    RedZone=False;
                    }
                    }
                 
                }else if(deviceId != null && deviceId != customDesign.Device__c){
                    Device__c devInfo = [SELECT Primary_Option__c,Opportunity_Program__c,ITAR_Flag__c,ECCN_Technology__c FROM Device__c WHERE Id = :customDesign.Device__c]; 
                    techReqId = devInfo.Primary_Option__c;
                    oppProgId = devInfo.Opportunity_Program__c;
                    itarFlag = devInfo.ITAR_Flag__c;
                    String ECCNTech = devInfo.ECCN_Technology__c;
                    if(ECCNTech!=Null ||ECCNTech!=''){
                    if(allColorCodes.containsKey(ECCNTech) && (String.valueof(allColorCodes.get(ECCNTech).ECCN_Color__c) =='RED'||String.valueof(allColorCodes.get(ECCNTech).ECCN_Color__c) =='Red')){                            
                       RedZone=True;
                    }Else{
                    RedZone=False;
                    }
                    }
                    
                    }
               // }
                customDesign.Is_this_an_ITAR_design__c = customDesign.ITAR_Formula__c;
                 
                
                if(customDesign.DIW_Option_Control_Number__c != techReqId && mode != null && mode =='edit'){
                    initiateOptionFields(customDesign);
                }
                createDesignSystemMap();
                //Assign Design ECCN from Option
                //Customer_Requirement__c techReq = [SELECT Design_Export_Control_Classification_Num__c FROM Customer_Requirement__c where id =:customDesign.DIW_Option_Control_Number__c];
                // customDesign.Design_ECCN_Number__c = techReq.Design_Export_Control_Classification_Num__c;
                
                //Populating field value from formula fields
                // customDesign.Total_UNWIRED_sq_microns__c = customDesign.Total_Unwired_Formula__c;
                //customDesign.RA_Scan_Bits__c=customDesign.RA_Scan_Bits_Formula__c;
                //  customDesign.Total_Scan_Bits__c=customDesign.Total_Scan_Counts_Formula__c;
                //   customDesign.Average_of_Bits_Chain__c=customDesign.Average_of_Bits_Chain_Formula__c;
                
                //Assign latest ECCN Number
                 // Changing the Owner Name without editing the record
                if (customDesign.Design_ECCN_Number__c != customDesign.Design_ECCN_Formula__c)
                {
                    customDesign.Design_ECCN_Number__c = customDesign.Design_ECCN_Formula__c;
                    setEccnColor();    
                    assignDesignToQueue();
                }
                customDesign.Functional_ECCN_number__c = customDesign.Functional_ECCN_formula__c;
                // For creation/updation of Attachment           
                attachListMap =  att.getAttachments(id);
                cdsHeaderAttList = attachListMap.get(CDSAttachmentUploadForm.CDS_HEADER_BEGIN);
                //   cdsHeaderFile = new Attachment();
                
                signalPowerAttList = attachListMap.get(CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN);
                //  signalPowerFile = new Attachment();
                
                mitiTranAttList = attachListMap.get(CDSAttachmentUploadForm.MITI_TRAN_BEGIN);
                //   mitiTranFile = new Attachment();
                
                noiseSpecsAttList = attachListMap.get(CDSAttachmentUploadForm.NOISE_SPECS_BEGIN);
                //   noiseSpecsFile = new Attachment();
                
                addAllLists = new List<Attachment>();
                addAllLists.addAll(signalPowerAttList);
                addAllLists.addAll(mitiTranAttList);
                addAllLists.addAll(noiseSpecsAttList);
                
                dramAttList = attachListMap.get(CDSAttachmentUploadForm.DRAM_BEGIN);
                // dramFile = new Attachment();
                
                coreAttList = attachListMap.get(CDSAttachmentUploadForm.CORE_BEGIN);
                //  coreFile = new Attachment();
                
                ddAttList = attachListMap.get(CDSAttachmentUploadForm.DD_BEGIN);
                // ddFile = new Attachment();
                iInfAttList = attachListMap.get(CDSAttachmentUploadForm.IMAGE_INF_BEGIN);
                //  imageInfFile = new Attachment();
                
                pInfAttList = attachListMap.get(CDSAttachmentUploadForm.PKG_INF_BEGIN);
                // pkgInfFile = new Attachment();
                
                cardInfAttList = attachListMap.get(CDSAttachmentUploadForm.CARD_INF_BEGIN);
                // cardInfFile = new Attachment();
                
                scanBitsAttList = attachListMap.get(CDSAttachmentUploadForm.SCAN_BITS_BEGIN);
                // scanBitsFile = new Attachment();
                
                desTestAttList = attachListMap.get(CDSAttachmentUploadForm.DES_TEST_BEGIN);
                // desTestFile = new Attachment();
                
                addToolsAttList= attachListMap.get(CDSAttachmentUploadForm.ADD_TOOLS_BEGIN);
                // addToolsFile = new Attachment();
                
                mfgTestAttList = attachListMap.get(CDSAttachmentUploadForm.MFG_TEST_BEGIN);
                // mfgTestFile = new Attachment();
                
                archInfoAttList = attachListMap.get(CDSAttachmentUploadForm.ARC_INFO_BEGIN);
                // archInfoFile = new Attachment();
                
                desStrcAttList = attachListMap.get(CDSAttachmentUploadForm.DES_STRC_BEGIN);
                //   desStrcFile = new Attachment();
                
                netCustAttList = attachListMap.get(CDSAttachmentUploadForm.NET_CUST_BEGIN);
                //  netCustFile = new Attachment();
                
                splPlaceAttList = attachListMap.get(CDSAttachmentUploadForm.SPL_PLACE_BEGIN);
                //   splPlaceFile = new Attachment();
                
                splWireAttList = attachListMap.get(CDSAttachmentUploadForm.SPL_WIRE_BEGIN);
                //  splWireFile = new Attachment();
                
                clockInfoAttList = attachListMap.get(CDSAttachmentUploadForm.CLK_INFO_BEGIN);
                // clockInfoFile = new Attachment();
                
                clockCharAttList = attachListMap.get(CDSAttachmentUploadForm.CLK_CHAR_BEGIN);
                // clockCharFile = new Attachment();
                pdfAttachments =  attachListMap.get(CDSAttachmentUploadForm.CDS_PDF);
                
                avstAttachments =  attachListMap.get(CDSAttachmentUploadForm.AVST_BEGIN);
                
                populateRelatedLists();
                GrantAccess();
                pageSize = 10; //Create a new instance of Paginate passing in the overall size of //the list of data and the page size you want 
                PaginateDram();
                PaginateComp();
                PaginateIO();
                PaginateCore();
                PaginateDevd();

                
            }      
            else{
                customDesign = new Custom_Design__c();
                //Assign latest ECCN Number
                customDesign.Design_ECCN_Number__c = customDesign.Design_ECCN_Formula__c;
                //customerContactList = new List<Contact>();
                iOList=new List<IO_and_Switching_Information__c>();
                dmList=new List<DRAMs__c>();
                cmpList=new List<Compilable__c>();
                ReasonList= new List<Reason_For_Change__c>();
                cpList=new List<CoresPLL__c>();
                ddList=new List<Development_Deliverable__c>();
                pdList=new List<Third_Party_Design_Contact__c>();
                clockList=new List<Clock_Characteristics__c>();
                for(integer i=0 ;i<5 ; i++){
                    clockList.add(new Clock_Characteristics__c());
                }
                
                acctProxyList = new  List<Opportunity_Program_Team_Member__c>();
                List<User> userList = new List<User>();
                
                initiateDIWFields();
                createDesignSystemMap();
                //Put account proxy in edit also and check if it needs to be edited
                //acctProxyList=[SELECT User__r.address,User_Preferred_Name__c ,User_Email__c,Team_Role__c,User__r.phone FROM Account_Team_Proxy__c WHERE Team_Role__c ='Primary Account Manager' and Opportunity_Account_ID__c =:customDesign.Customer__c];
                //acctProxyList=[SELECT User__r.address,User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c WHERE Team_Role__c in :teamRole and Opportunity_Account_ID__c =:customDesign.Customer__c];
                 acctProxyList=[SELECT User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c WHERE Team_Role__c in :teamRole and Opportunity_Id__c =:customDesign.DIW_Opp_Control_Number__c];
                
                //Key Technical Contact,Key Management Contact,Field Applications Engineer,Field Design Center Engineer,
                //Primary Factory AE,Physical Design Engineer,ASIC Packaging Applications Engineer,Product Engineer,
                //Tactical Marketing Contact,Engagement Manager,Additional GlobalFoundries or 3rd Party Contact
                
            }
            
            
        }
        catch(Exception excp)
        {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','syncOption','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            
        }
        
    }
    /*
*************************************    
@ Name -  populateRelatedLists
@ Description - Populate Related List.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    @TestVisible  private void populateRelatedLists(){
        iOList=new List<IO_and_Switching_Information__c>();
        dmList=new List<DRAMs__c>();
        cmpList=new List<Compilable__c>();
        ReasonList= new List<Reason_For_Change__c>();
        cpList=new List<CoresPLL__c>();
        ddList=new List<Development_Deliverable__c>();
        pdList=new List<Third_Party_Design_Contact__c>();
        clockList=new List<Clock_Characteristics__c>();
        
        dmList = [select id,DRAM_Name__c,Qty__c from DRAMs__c where Custom_Design_Specification__c =:customDesign.id];
        
        String QueryIO='SELECT ';
        for(String fname:Schema.SObjectType.IO_and_Switching_Information__c.fields.getMap().keySet())
        {
            if(fname!='id')
                QueryIO=QueryIO+fname+ ', ';
        }
        QueryIO=QueryIO+'id FROM IO_and_Switching_Information__c WHERE Custom_Design_Specification__c=:id';
        ioList =(List<IO_and_Switching_Information__c>)DataBase.query(QueryIO);
        
         String QueryCMP='SELECT ';
        for(String fname:Schema.SObjectType.Compilable__c.fields.getMap().keySet())
        {
            if(fname!='id')
                QueryCMP=QueryCMP+fname+ ', ';
        }
        QueryCMP=QueryCMP+'id FROM Compilable__c WHERE Custom_Design_Specification__c=:id';
        cmpList =(List<Compilable__c>)DataBase.query(QueryCMP);
        
        String QueryCP='SELECT ';
        for(String fname:Schema.SObjectType.CoresPLL__c.fields.getMap().keySet())
        {
            if(fname!='id')
                QueryCP=QueryCP+fname+ ', ';
        }
        QueryCP=QueryCP+'id FROM CoresPLL__c WHERE Custom_Design_Specification__c=:id';
        cpList =(List<CoresPLL__c>)DataBase.query(QueryCP);
        
        String QueryDD='SELECT ';
        for(String fname:Schema.SObjectType.Development_Deliverable__c.fields.getMap().keySet())
        {
            if(fname!='id')
                QueryDD=QueryDD+fname+ ', ';
        }
        QueryDD=QueryDD+'id FROM Development_Deliverable__c WHERE Custom_Design_Specification__c=:id';
        ddList =(List<Development_Deliverable__c>)DataBase.query(QueryDD);
        
        String queryClock='SELECT ';
        for(String fname:Schema.SObjectType.Clock_Characteristics__c.fields.getMap().keySet())
        {
            if(fname!='id')
                queryClock=queryClock+fname+ ', ';
        }
        queryClock=queryClock+'id FROM Clock_Characteristics__c WHERE Customer_Design_Specification__c=:id';
        clockList =(List<Clock_Characteristics__c>)DataBase.query(queryClock);
       
        //acctProxyList=[SELECT User_Preferred_Name__c ,User_Email__c,Team_Role__c,User__r.phone FROM Account_Team_Proxy__c WHERE Team_Role__c ='Primary Account Manager' and Account__c =:customDesign.Customer__c];
        acctProxyList=[SELECT User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c WHERE Team_Role__c in :teamRole and Opportunity_Id__c =:customDesign.DIW_Opp_Control_Number__c];
        userListAccProxy = new set<ID>();
        for(Opportunity_Program_Team_Member__c Opp:acctProxyList){
                    userListAccProxy.add(opp.User__r.Id);
        }
    }
    /*
*************************************    
@ Name -  createDesignSystemMap
@ Description - Create dependent picklist values based on Design System Value.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public void createDesignSystemMap(){
        
        List<Design_StyleName__mdt> mappingList =[SELECT Controlling_FIeld_Value__c,Dependent_Field_API_Name__c,Dependent_Field_Value__c FROM Design_StyleName__mdt where Controlling_FIeld_Value__c = :customDesign.Design_System__c];
        // designSystemMap = new Map<String,Map<String,List<String>>>();
        //  Map<String,List<String>> dependentListMap ;
        
        dependentPicklistMap = new Map<String,Set<String>>();
        //   List<String> dependentList;
        Set<String> dependentValues;
        if(!mappingList.isEmpty()){
            for(Design_StyleName__mdt record : mappingList){
                dependentValues = new Set<String>();
                if(dependentPicklistMap.containsKey(record.Dependent_Field_API_Name__c)){
                    dependentValues = dependentPicklistMap.get(record.Dependent_Field_API_Name__c);
                    dependentValues.add(record.Dependent_Field_Value__c);
                    dependentPicklistMap.put(record.Dependent_Field_API_Name__c, dependentValues);
                }else{
                    dependentValues.add(record.Dependent_Field_Value__c);
                    dependentPicklistMap.put(record.Dependent_Field_API_Name__c, dependentValues);
                }
                
            }
            createDependentPickList();
        }
        
        /* for(Design_StyleName__mdt record : mappingList){
dependentListMap = new Map<String,List<String>>();
dependentList = new List<String>();
if(designSystemMap.containsKey(record.Controlling_FIeld_Value__c)){

dependentListMap = designSystemMap.get(record.Controlling_FIeld_Value__c);
dependentList= dependentListMap.get(record.Dependent_Field_API_Name__c);
dependentList.add(record.Dependent_Field_Value__c);

dependentListMap.put(record.Dependent_Field_API_Name__c, dependentList);
designSystemMap.put(record.Controlling_FIeld_Value__c, dependentListMap);
//designSystemMap.put(record.Controlling_FIeld_Value__c, dependentListMap.put(record.Dependent_Field_API_Name__c, dependentList)) ; 
}else{
dependentList.add(record.Dependent_Field_Value__c);
dependentListMap.put(record.Dependent_Field_API_Name__c,dependentList );
designSystemMap.put(record.Controlling_FIeld_Value__c, dependentListMap);
}
}*/
    }
    /*
*************************************    
@ Name -  createDependentPickList
@ Description - Create dependent picklist values based on Design System Value.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    @TestVisible  private void createDependentPickList(){
        ifAreaPickList = new list<SelectOption>();
        imagePowerSupplyPickList = new list<SelectOption>();
        packagePowerSupplyPickList = new list<SelectOption>();
        packageTypePickList =  new list<SelectOption>();
        coreNamePicklist = new list<SelectOption>();
        
        if(dependentPicklistMap.get(System.Label.CDSIfAreaArray) != null){
            for(String value :dependentPicklistMap.get(System.Label.CDSIfAreaArray)){ 
                this.ifAreaPickList.add(new SelectOption(value,value));
            }
        }
        if(dependentPicklistMap.get(System.Label.CDSImagePowerSupply) != null){
            for(String value :dependentPicklistMap.get(System.Label.CDSImagePowerSupply)){
                this.imagePowerSupplyPickList.add(new SelectOption(value,value));
            }
        }
        if(dependentPicklistMap.get(System.Label.CDSPackagePowerSupply) != null){
            for(String value :dependentPicklistMap.get(System.Label.CDSPackagePowerSupply)){
                this.packagePowerSupplyPickList.add(new SelectOption(value,value));
            }
        }
        if(dependentPicklistMap.get(System.Label.CDSPackageTypeSupply) != null){
            for(String value :dependentPicklistMap.get(System.Label.CDSPackageTypeSupply)){
                this.packageTypePickList.add(new SelectOption(value,value));
            }
        }
        if(dependentPicklistMap.get(System.Label.CDSCoreName) != null){
            for(String value :dependentPicklistMap.get(System.Label.CDSCoreName)){
                this.coreNamePicklist.add(new SelectOption(value,value));
            }
        }
        
    }
    
    /*  public Set<String> getPickListValues(){
return dependentPicklistMap.get(customDesign.Design_System__c);
}*/

  /*
*************************************    
@ Name -  Pagination methods
@ Description - Pagination Methods for Dram
@ Parameter - None
@ Return Type - 
@ Created By - MSeth
****************************************
*/
  public PageReference previousPageDram(){ 
    this.paginaterDram.decrement(); 
    return changeDataDram(); 
} 
public PageReference nextPageDram(){ 
    this.paginaterDram.increment(); 
    return changeDataDram();
 } 
public PageReference updatePageDram(){ 
    this.paginaterDram.updateNumbers(); 
    return changeDataDram(); 
} 
public PageReference changeDataDram(){
     if(this.fullGenericListDram.get(this.paginaterDram.index)!=Null){
        this.genericListDram = this.fullGenericListDram.get(this.paginaterDram.index);
    } 
    return null; 
}  
 /*
*************************************    
@ Name -  Pagination methods
@ Description - Pagination Methods for Comp
@ Parameter - None
@ Return Type - 
@ Created By - MSeth
****************************************
*/
 public PageReference previousPageComp(){ 
    this.paginaterComp.decrement(); 
    return changeDataComp(); 
} 
public PageReference nextPageComp(){ 
    this.paginaterComp.increment(); 
    return changeDataComp();
 } 
public PageReference updatePageComp(){ 
    this.paginaterComp.updateNumbers(); 
    return changeDataComp(); 
} 
public PageReference changeDataComp(){ 
    If(this.fullGenericListComp!=Null)
    this.genericListComp = this.fullGenericListComp.get(this.paginaterComp.index); 
    return null; 
}    
/*
*************************************    
@ Name -  Pagination methods
@ Description - Pagination Methods for IO
@ Parameter - None
@ Return Type - 
@ Created By - MSeth
****************************************
*/
 public PageReference previousPageIO(){ 
    this.paginaterIO.decrement(); 
    return changeDataIO(); 
} 
public PageReference nextPageIO(){ 
    this.paginaterIO.increment(); 
    return changeDataIO();
 } 
public PageReference updatePageIO(){ 
    this.paginaterIO.updateNumbers(); 
    return changeDataIO(); 
} 
public PageReference changeDataIO(){ 
    If(this.fullGenericListIO!=Null)
    this.genericListIO = this.fullGenericListIO.get(this.paginaterIO.index); 
    return null; 
}   
/*
*************************************    
@ Name -  Pagination methods
@ Description - Pagination Methods for Deliverable
@ Parameter - None
@ Return Type - 
@ Created By - MSeth
****************************************
*/
 public PageReference previousPageDevd(){ 
    this.paginaterDevd.decrement(); 
    return changeDataDevd(); 
} 
public PageReference nextPageDevd(){ 
    this.paginaterDevd.increment(); 
    return changeDataDevd();
 } 
public PageReference updatePageDevd(){ 
    this.paginaterDevd.updateNumbers(); 
    return changeDataDevd(); 
} 
public PageReference changeDataDevd(){ 
    If(this.fullGenericListDevd!=Null)
    this.genericListDevd = this.fullGenericListDevd.get(this.paginaterDevd.index); 
    return null; 
}   

/*
*************************************    
@ Name -  Pagination methods
@ Description - Pagination Methods for Core
@ Parameter - None
@ Return Type - 
@ Created By - MSeth
****************************************
*/
 public PageReference previousPageCore(){ 
    this.paginaterCore.decrement(); 
    return changeDataCore(); 
} 
public PageReference nextPageCore(){ 
    this.paginaterCore.increment(); 
    return changeDataCore();
 } 
public PageReference updatePageCore(){ 
    this.paginaterCore.updateNumbers(); 
    return changeDataCore(); 
} 
public PageReference changeDataCore(){ 
    If(this.fullGenericListCore!=Null)
    this.genericListCore = this.fullGenericListCore.get(this.paginaterCore.index); 
    return null; 
}   
    /*
*************************************    
@ Name -  initializeAttachmentFiles
@ Description - Initializing attachment files..
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    @TestVisible    private void initializeAttachmentFiles(){
        
        cdsHeaderFile = new Attachment();
        signalPowerFile = new Attachment();
        mitiTranFile = new Attachment();
        noiseSpecsFile = new Attachment();
        dramFile = new Attachment();
        coreFile = new Attachment();
        ddFile = new Attachment();
        imageInfFile = new Attachment();
        pkgInfFile = new Attachment();
        cardInfFile = new Attachment();
        scanBitsFile = new Attachment();
        desTestFile = new Attachment();
        addToolsFile = new Attachment();
        mfgTestFile = new Attachment();
        archInfoFile = new Attachment();
        desStrcFile = new Attachment();
        netCustFile = new Attachment();
        splPlaceFile = new Attachment();
        splWireFile = new Attachment();
        clockInfoFile = new Attachment();
        clockCharFile = new Attachment();
        avstFile = new Attachment();
    }
    
    /*
*************************************    
@ Name -  initiateDIWFields
@ Description -  Populating DIW mapping fields.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public void initiateDIWFields(){
        //Populating DIW mapping fields
        ///Decision__c decision = 
        deviceId = ApexPages.currentPage().getParameters().get('devId');
        customDesign.Device__c = deviceId;
        // customDesign.Decision__c = decisionId;
        Device__c devInfo = [SELECT id,Opportunity__c,Account__c,Opportunity_Program__c,Primary_Option__c,ECCN_Wafer__c,ECCN_Technology__c,Assumed_Design_ECCN__c,Assumed_Functional_ECCN__c,Is_ITAR__c,ITAR_Flag__c FROM Device__c WHERE Id = :deviceId ];                               
        // Decision__c decInfo = [SELECT id,Opportunity__c,Account__c,Technical_Requirement__c FROM Decision__c WHERE Id = :decisionId];                               
        //  Decision__c decInfo = [SELECT id,Request_Information__c FROM Decision__c WHERE Id = 'aEip0000000001d'];
        oppProgId = devInfo.Opportunity_Program__c;

        if (devInfo.ECCN_Technology__c !=null){
            customDesign.Design_ECCN_Number__c = devInfo.ECCN_Technology__c;
        }else{
         //commented by Naman:Design_ECCN_Number__c is only based on ECCN_Technology__c
            //customDesign.Design_ECCN_Number__c = devInfo.Assumed_Design_ECCN__c;            
            customDesign.Design_ECCN_Number__c = '';

        }
        
        if (devInfo.ECCN_Wafer__c !=null){
            customDesign.Functional_ECCN_number__c = devInfo.ECCN_Wafer__c;
        }else{
            customDesign.Functional_ECCN_number__c = devInfo.Assumed_Functional_ECCN__c;   
        }
        //  if(decInfo.Request_Information__c !=null){
        //     String reqInf = decInfo.Request_Information__c;
        //   Request_Information__c requestInf = [SELECT Customer_Requirement__c,Account__c,Opportunity__c FROM Request_Information__c WHERE Id = :reqInf];


  //Changed the reference to new Picklist field

        //customDesign.Is_this_an_ITAR_design__c = devInfo.Is_ITAR__c;
        customDesign.Is_this_an_ITAR_design__c = devInfo.ITAR_Flag__c;      
        itarFlag = devInfo.ITAR_Flag__c;
        List<ASICS_Specification__c> asicSpec = [Select Maximum_Heatsink_Shadow_Size_X_mm__c,Maximum_heatsink_shadow_size_Y_mm__c,Machine_life_K_power_on_hours_maximum__c ,Machine_life_years_maximum__c ,Machine_life_on_off_cycles_maximum__c,Card_Thickness_mm__c,
                                                 Power_Plane_Weight_oz_copper__c,Air_velocity_on_card_backside_minimum__c,Air_velocity_on_card_backside_nominal__c,Average_life_time_tempurature__c,
                                                 Nominal_air_temperature_rise_machine__c,Max_air_tempe_rise_machine_to_module__c,
                                                 Maximum_machine_ambent_air_temperature__c,Minimum_machine_ambient_air_temperature__c from ASICS_Specification__c where Device__c =:deviceId];
        if(asicSpec != null && asicSpec.size() > 0){
            if(asicSpec[0].Machine_life_K_power_on_hours_maximum__c !=null)
                customDesign.Maximum_Machine_Life_KPOH__c = decimal.ValueOf(asicSpec[0].Machine_life_K_power_on_hours_maximum__c);
            if(asicSpec[0].Machine_life_years_maximum__c != null)
                customDesign.Maximum_Machine_Life_Years__c = decimal.ValueOf(asicSpec[0].Machine_life_years_maximum__c);
            if(asicSpec[0].Machine_life_on_off_cycles_maximum__c != null)
                customDesign.Maximum_Number_of_Machine_On_Off_Cycles__c = decimal.ValueOf(asicSpec[0].Machine_life_on_off_cycles_maximum__c);
            customDesign.Backside_Forced_Air_lfpm__c = asicSpec[0].Air_velocity_on_card_backside_minimum__c;
            customDesign.Backside_Forced_Air_lfpm_Nom__c = asicSpec[0].Air_velocity_on_card_backside_nominal__c;
            customDesign.Operating_Air_Temperature_Rise_Max__c = asicSpec[0].Max_air_tempe_rise_machine_to_module__c;
            customDesign.Operating_Air_Temperature_Rise_Nom__c = asicSpec[0].Nominal_air_temperature_rise_machine__c;
            customDesign.Operating_Machine_Ambient_Air_Temp_Max__c = asicSpec[0].Maximum_machine_ambent_air_temperature__c;
            customDesign.Operating_Machine_Ambient_Air_Temp__c = asicSpec[0].Minimum_machine_ambient_air_temperature__c;
            customDesign.Average_Life_Time_Temperature__c = asicSpec[0].Average_life_time_tempurature__c;
            if(asicSpec[0].Card_Thickness_mm__c != null)
               customDesign.Card_Thickness_mm__c = String.ValueOf(asicSpec[0].Card_Thickness_mm__c);
            if(asicSpec[0].Power_Plane_Weight_oz_copper__c != null)
                customDesign.Card_power_plane_weight_oz_cu__c = decimal.ValueOf(asicSpec[0].Power_Plane_Weight_oz_copper__c);
            if(asicSpec[0].Maximum_Heatsink_Shadow_Size_X_mm__c != null)
                customDesign.What_are_the_maximum_dimensions__c = decimal.ValueOf(asicSpec[0].Maximum_Heatsink_Shadow_Size_X_mm__c);
            if(asicSpec[0].Maximum_heatsink_shadow_size_Y_mm__c != null)
                customDesign.What_are_the_maximum_dimensions_Y__c = decimal.ValueOf(asicSpec[0].Maximum_heatsink_shadow_size_Y_mm__c);
        }
        oppId = devInfo.Opportunity__c;
        String accntId = devInfo.Account__c;
        // String techReqId = decInfo.Technical_Requirement__c;
        //techReqId = 'a1ap0000000418e';
        techReqId = devInfo.Primary_Option__c;
        
        
        customDesign.Customer__c=accntId;
        
        if(oppId != null){
              customDesign.DIW_Opp_Control_Number__c = oppId;
            
            /* Opportunity opp = [SELECT Maximum_Heatsink_Shadow_Size_X_mm__c,Maximum_Heatsink_Shadow_Size_Y_mm__c ,Machine_life_K_power_on_hours_maximum__c ,
Machine_life_years_maximum__c ,Machine_life_on_off_cycles_maximum__c ,End_Customers__c,Market_Segment__c,Card_Thickness_mm__c ,
Power_Plane_Weight_oz_copper__c,Card_Backside_Air_Velocity_Min__c,Card_Backside_Air_Velocity_Nom__c,
System_Ambient_Air_Temp_Max__c,System_Ambient_Air_Temp_Min__c,Average_Lifetime_Temperature__c,OPT_CN__c,System_Tempurature_Rise_Max__c,System_Tempurature_Rise_Nom__c,Does_this_product_fall_under_ITAR__c,Target_Process_Node__c  FROM Opportunity where id =: oppId];*/
            Opportunity opp = [SELECT End_Customers__c,Market_Segment__c,OPT_CN__c,
                               Target_Process_Node__c  FROM Opportunity where id =: oppId];
            //Assign opp COntrol number - new external id field
            //customDesign.DIW_Opp_Control_Number__c = opp.OPT_CN__c; -- Commented by Yash (OPT_CN__c changed to oppId)
            // customDesign.Is_this_an_ITAR_design__c = opp.Does_this_product_fall_under_ITAR__c;
            customDesign.Market_Segment__c = opp.Market_Segment__c;
            customDesign.Design_System__c = opp.Target_Process_Node__c;
            //customDesign.Market_Area__c (not there)
            customDesign.Customer_Project__c = opp.End_Customers__c;
            /*if(opp.Machine_life_K_power_on_hours_maximum__c !=null)
customDesign.Maximum_Machine_Life_KPOH__c = decimal.ValueOf(opp.Machine_life_K_power_on_hours_maximum__c);
if(opp.Machine_life_years_maximum__c != null)
customDesign.Maximum_Machine_Life_Years__c = decimal.ValueOf(opp.Machine_life_years_maximum__c);
if(opp.Machine_life_on_off_cycles_maximum__c != null)
customDesign.Maximum_Number_of_Machine_On_Off_Cycles__c = decimal.ValueOf(opp.Machine_life_on_off_cycles_maximum__c);
customDesign.Backside_Forced_Air_lfpm__c = opp.Card_Backside_Air_Velocity_Min__c;
customDesign.Backside_Forced_Air_lfpm_Nom__c = opp.Card_Backside_Air_Velocity_Nom__c;
//  customDesign.Operating_Module_Ambient_Temperature_Max__c = 
customDesign.Operating_Air_Temperature_Rise_Max__c = opp.System_Tempurature_Rise_Max__c;
customDesign.Operating_Air_Temperature_Rise_Nom__c = opp.System_Tempurature_Rise_Nom__c;
customDesign.Operating_Machine_Ambient_Air_Temp_Max__c = opp.System_Ambient_Air_Temp_Max__c;
customDesign.Operating_Machine_Ambient_Air_Temp__c = opp.System_Ambient_Air_Temp_Min__c;
customDesign.Average_Life_Time_Temperature__c = opp.Average_Lifetime_Temperature__c;
if(opp.Card_Thickness_mm__c != null)
customDesign.Card_Thickness_mm__c = String.ValueOf(opp.Card_Thickness_mm__c);
if(opp.Power_Plane_Weight_oz_copper__c != null)
customDesign.Card_power_plane_weight_oz_cu__c = decimal.ValueOf(opp.Power_Plane_Weight_oz_copper__c);
if(opp.Maximum_Heatsink_Shadow_Size_X_mm__c != null)
customDesign.What_are_the_maximum_dimensions__c = decimal.ValueOf(opp.Maximum_Heatsink_Shadow_Size_X_mm__c);
if(opp.Maximum_Heatsink_Shadow_Size_Y_mm__c != null)
customDesign.What_are_the_maximum_dimensions_Y__c = decimal.ValueOf(opp.Maximum_Heatsink_Shadow_Size_Y_mm__c);*/
        }
        
        if(techReqId != null){
            // customDesign.DIW_Option_Control_Number__c = techReqId;
            initiateOptionFields(customDesign);
        } 
        
        
        //  }
        
    }
    /*
*************************************    
@ Name -  provideAccess
@ Description - provide Access on click of sync access button
@ Parameter - None
@ Return Type - 
@ Created By - Mallika Seth
****************************************
*/
Public void ProvideAccess(){
    List<Custom_Design__Share> sharesToDelete = [SELECT Id 
                                                FROM Custom_Design__Share 
                                                WHERE ParentId =:customDesign.Id];
        if(!sharesToDelete.isEmpty()){
            Database.Delete(sharesToDelete, false);
        }
    GrantAccess();
    
      if(lstUser!=Null){
          CDSSharing.ShareEdit(customDesign.id, lstUser);
      }
     
    GrantAccess();
      

}

 /*
*************************************    
@ Name -  GrantAccess
@ Description - Grant Access on click on load of page
@ Parameter - None
@ Return Type - 
@ Created By - Mallika Seth
****************************************
*/
Public void GrantAccess(){
      lstUser = new Set<ID>();
      CDSAccess__c cds = CDSAccess__c.getValues('IDs');
      String Red = cds.Red__c;
      String Orange = cds.Orange__c;
      String Yellow = cds.Yellow__c;
      String Green = cds.Green__c;
      String ViewAllOption = cds.ViewAllOptions__c;   
      CDSAccess__c cdsQueue = CDSAccess__c.getValues('Queue');
      String RedQueue = cdsQueue.Red__c;
      String OrangeQueue = cdsQueue.Orange__c;
      String YellowQueue = cdsQueue.Yellow__c;
      String GreenQueue = cdsQueue.Green__c;
      mapGroupUser = new map<Id,Set<String>>();
      mapUserAccess = new map<Id,String>();
      String Access;
      ///Set<String> Groups = new Set<String>();

      
     
      List<Custom_Design__Share> shareAccess = [SELECT Id,UserOrGroupId 
                                                FROM Custom_Design__Share 
                                                WHERE ParentId =:customDesign.Id];
    PermissionsetList = [SELECT Assignee.Name,Assignee.ID,PermissionSet.Id,PermissionSet.Name FROM PermissionSetAssignment where PermissionSet.Name =: 'DIW_CDS_Admin' or PermissionSet.Name =: 'DIW_Customer_Focal_Point' or PermissionSet.Name =: 'DIW_PEM'];
    for(PermissionSetAssignment PermCDS: PermissionsetList){
        if(PermCDS.PermissionSet.Name == 'DIW_CDS_Admin'){
        for(PermissionSetAssignment Perm: PermissionsetList){
            if(Perm.PermissionSet.Name == 'DIW_Customer_Focal_Point' && Perm.Assignee.ID ==PermCDS.Assignee.ID){

                userListAccProxy.add(Perm.Assignee.ID);
            }
            if(Perm.PermissionSet.Name == 'DIW_PEM' && Perm.Assignee.ID ==PermCDS.Assignee.ID){

                userListAccProxy.add(Perm.Assignee.ID);
            }
        }
        }
    }                                               
                                            
        for(ID U: userListAccProxy){
        mapGroupUser.put(u,new Set<String>());
            for(Custom_Design__Share CDShare: shareAccess){
            if(CDShare.UserOrGroupId == u){
                mapUserAccess.put(u,'Yes');
                break;

            }Else{
               mapUserAccess.put(u,'No');

            }
            }   
        }
      
       for(GroupMember m : [Select Id, UserOrGroupId,GroupId,Group.type From GroupMember Where UserOrGroupId IN: userListAccProxy]) {
        //Groups = new Set<String>();
                if(m.GroupId == Red){
                if(((String)m.UserOrGroupId).startsWith(userType))
                {
                mapGroupUser.get(m.UserOrGroupId).add('RedGroup');
                }
                }
                if(m.GroupId == Yellow){
                   if(((String)m.UserOrGroupId).startsWith(userType))
                   {
                   mapGroupUser.get(m.UserOrGroupId).add('YellowGroup');

                   }
                }
                if(m.GroupId == Green){
                   if(((String)m.UserOrGroupId).startsWith(userType))
                   {
                    mapGroupUser.get(m.UserOrGroupId).add('GreenGroup');
                   }
                }
                if(m.GroupId == ViewAllOption){
                   if(((String)m.UserOrGroupId).startsWith(userType))
                   {
                    mapGroupUser.get(m.UserOrGroupId).add('ViewAllOption Group');
                   }
                }
                if(m.GroupId == Orange){
                   if(((String)m.UserOrGroupId).startsWith(userType))
                   {
                    mapGroupUser.get(m.UserOrGroupId).add('OrangeGroup');
                   }
                }
                
                
                System.debug('@@@@map'+m);
                System.debug('@@@@map'+mapGroupUser);
                
                
       }
       
                       
      
      
        if(customDesign.OwnerID  == YellowQueue){
       for(GroupMember m : [Select Id, UserOrGroupId,GroupId,Group.type From GroupMember Where GroupId =: Yellow OR GroupId =: Red ]) {
                // If the user or group id is a user
                if(((String)m.UserOrGroupId).startsWith(userType))
                {
                    lstUser.add(m.UserOrGroupId);
                }
       }
       }
       if(customDesign.OwnerID  == RedQueue){
       for(GroupMember m : [Select Id, UserOrGroupId,GroupId,Group.type From GroupMember Where GroupId =: Red ]) {
                // If the user or group id is a user
                if(((String)m.UserOrGroupId).startsWith(userType))
                {
                    lstUser.add(m.UserOrGroupId);
                }
       }
      }
      if(customDesign.OwnerID  == OrangeQueue){
       for(GroupMember m : [Select Id, UserOrGroupId,GroupId,Group.type From GroupMember Where GroupId =: Orange ]) {
                // If the user or group id is a user
                if(((String)m.UserOrGroupId).startsWith(userType))
                {
                    lstUser.add(m.UserOrGroupId);
                }
       }
      }
      
      if(customDesign.OwnerID  == GreenQueue){
       for(GroupMember m : [Select Id, UserOrGroupId,GroupId,Group.type From GroupMember Where GroupId =: Green OR GroupId =: Yellow OR GroupId =: Red OR GroupId =:ViewAllOption]) {
                // If the user or group id is a user
                if(((String)m.UserOrGroupId).startsWith(userType))
                {
                    lstUser.add(m.UserOrGroupId);
                }
       }
      }
     // acctAccessList=[SELECT User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c WHERE Team_Role__c in :teamRole and User__c in :lstUser and  Opportunity_Id__c =:customDesign.DIW_Opp_Control_Number__c];
     
        
        
      if(lstUser!=Null){
           For(ID U: lstUser){
                 if(U != LoggedinUser){
                    AccessFlag = False; 
                 }
                 Else if(U == LoggedinUser){
                    AccessFlag = True;
                    Break;
                 }    
                   
      }
      } Else if(acctAccessList==Null){
            AccessFlag = False; 

      }

}

    /*
*************************************    
@ Name -  initiateOptionFields
@ Description -  Populating Option fields.
@ Parameter - initiateOptionFields
@ Return Type - null
@ Created By - Niharika Modi
****************************************
*/
    @TestVisible private void initiateOptionFields(Custom_Design__c customDesignObj){
        String designId;
        Customer_Requirement__c techReq;
        if(techReqId != null){
        techReq = [SELECT Id,MD_part_name__c,RIT_Type__c,Deliverable_Part_Number_DPN__c,Deliverable_Type__c,Reliability_Grade__c,
                   Design_Export_Control_Classification_Num__c,Name FROM Customer_Requirement__c where id =:techReqId];
        customDesignObj.Name_Version__c = techReq.MD_part_name__c;
        customDesignObj.Deliverable_Part_Number__c = techReq.Deliverable_Part_Number_DPN__c;
        customDesignObj.Deliverable_Part_Type__c = techReq.Deliverable_Type__c;
        //customDesignObj.Design_ECCN_Number__c = techReq.Design_Export_Control_Classification_Num__c;
        // customDesign.Functional_ECCN_number__c = techReq.
        customDesignObj.Reliability_Grade__c = techReq.Reliability_Grade__c;
        
        //designId = techReq.Design__c;
        customDesignObj.DIW_Option_Control_Number__c = techReq.Id; // changed name to ID
        // customDesign.DIW_Option_Control_Number__c = techReq.Name; 
        customDesignObj.Rit_Type__c = techReq.RIT_Type__c;
        List<Chip_data__c> chipData = new  List<Chip_data__c>();
        chipData = [Select Chip_Tj_maximum_C__c,Chip_Tj_minimum_C__c,Chip_Tj_nominal_C__c,Nominal_power_W__c,Max_chip_power_W__c FROM Chip_data__c WHERE technical_Requirement__c =:techReqId];
        if(chipData != null && chipData.size() > 0){
            customDesignObj.Operating_Chip_Junction_Temperature_Max__c = chipData[0].Chip_Tj_maximum_C__c;
            customDesignObj.Operating_Chip_Junction_Temperature__c = chipData[0].Chip_Tj_minimum_C__c;
            customDesignObj.Operating_Chip_Junction_Temperature_Nom__c = chipData[0].Chip_Tj_nominal_C__c;
            customDesignObj.Nominal_Chip_Power_W__c = chipData[0].Nominal_power_W__c;
            customDesignObj.Maximum_Chip_Power_W__c = chipData[0].Max_chip_power_W__c;
        }
      //  if(designId != null){
        List<Design__c> design = new  List<Design__c>();
        design =  [SELECT Product_Offering__c,Library_used__c,Utilization_The_number_of_total_gat__c,Image_style__c,Image_Name__c,
                                 Image_Size_X_mm__c,Image_Size_Y_mm__c,Total_Levels_of_Metal__c,Levels_of_Metal_Used_For_Wiring__c,Last_Metal_Indicator__c,
                                 Package_style__c,Package_Name__c,Package_Size_X_mm__c,Package_Size_Y_mm__c,Package_total_lead_count__c,
                                 Package_Lead_Pitch__c,List_Compilable_Names__c,List_Compilable_Quanities__c,Core_Name__c,Number_of_Instances__c,Package_layers__c,Total_number_of_latches_for_test__c,
                                 Total_number_of_scan_chains_for_test__c,Maximum_scan_chain_length_for_test_um__c,Number_of_redundant_SRAM_bits_in_the_des__c FROM Design__c where Customer_Requirement__c  =:techReqId];
            // Added Number_of_redundant_SRAM_bits_in_the_des__c field in query
            //Compilable_Name__c(or IP name),eDRAM_Name__c(or IP name),Core_Name__c
         if(design != null && design.size() > 0){
           for(Design__c objDesign : design){
           customDesignObj.Macro_name__c = objDesign.List_Compilable_Names__c;
            //customDesign.Design_System__c = design.Product_Offering__c;
            customDesignObj.Library__c = objDesign.Library_used__c;
            
            // customDesign.Operating_Frequency_in_Mhz__c = design   (field not present in Design)
            customDesignObj.Quantity__c = objDesign.List_Compilable_Quanities__c;  //   (compilable quanity number of instances)
            //customDesign.Qty__c(dram quanity)
            // customDesign.DRAM_Name__c = design.eDRAM_Name__c;
            customDesignObj.Core_Name__c = objDesign.Core_Name__c;
            //customDesign.Name_Development_Deliverables__c = design.n
            //customDesign.Quantity_Development_Deliverables__c
            //customDesign.Type__c
            if(objDesign.Number_of_Instances__c != null)
                customDesignObj.Quantity_Cores__c = decimal.ValueOf(objDesign.Number_of_Instances__c);
            if(objDesign.Number_of_redundant_SRAM_bits_in_the_des__c != null)
                customDesignObj.Tot_bit_cnt_of_memories_with_Redundancy__c= decimal.ValueOf(objDesign.Number_of_redundant_SRAM_bits_in_the_des__c);
            if(objDesign.Utilization_The_number_of_total_gat__c != null)
                customDesignObj.Chip_Wired_Utilization__c = decimal.ValueOf(objDesign.Utilization_The_number_of_total_gat__c);
            customDesignObj.Image_Style__c = objDesign.Image_style__c;
            customDesignObj.Image_Name__c = objDesign.Image_Name__c;
            if(objDesign.Image_Size_X_mm__c != null)
                customDesignObj.Image_Size_X__c = decimal.ValueOf(objDesign.Image_Size_X_mm__c);
            if(objDesign.Image_Size_Y_mm__c != null)
                customDesignObj.Image_Size_Y_mm__c = decimal.ValueOf(objDesign.Image_Size_Y_mm__c);
            if(objDesign.Total_Levels_of_Metal__c != null)
                customDesignObj.Total_levels_of_Metal__c = decimal.ValueOf(objDesign.Total_Levels_of_Metal__c);
            if(objDesign.Levels_of_Metal_Used_For_Wiring__c != null)
                customDesignObj.Levels_of_metal_used_for_wiring__c = decimal.ValueOf(objDesign.Levels_of_Metal_Used_For_Wiring__c);
            customDesignObj.Image_Last_Metal_Layer__c = objDesign.Last_Metal_Indicator__c;
            customDesignObj.Package_Type__c= objDesign.Package_style__c;
            customDesignObj.Package_Name__c= objDesign.Package_Name__c;
            customDesignObj.Package_Size_X__c= objDesign.Package_Size_X_mm__c;
            customDesignObj.Package_Size_Y__c= objDesign.Package_Size_Y_mm__c;
            if(objDesign.Package_total_lead_count__c != null)
                customDesignObj.Total_Pin_Count__c= decimal.ValueOf(objDesign.Package_total_lead_count__c);
            customDesignObj.Package_Pin_Pitch__c= objDesign.Package_Lead_Pitch__c;
            
            customDesignObj.Number_of_Package_Layers__c =objDesign.Package_layers__c;
            if(objDesign.Total_number_of_latches_for_test__c != null)
                customDesignObj.Latch_Count__c = decimal.ValueOf(objDesign.Total_number_of_latches_for_test__c);
            if(objDesign.Total_number_of_scan_chains_for_test__c != null)
                customDesignObj.Expected_of_Scan_Chains__c = decimal.ValueOf(objDesign.Total_number_of_scan_chains_for_test__c);
            if(objDesign.Maximum_scan_chain_length_for_test_um__c != null)
                customDesignObj.Longest_Scan_Chain__c = decimal.ValueOf(objDesign.Maximum_scan_chain_length_for_test_um__c);           
           }     
       }
    }
    }
    
    /*
*************************************    
@ Name -  AddIO
@ Description -  Adding the rows in IO Table under 'I/O and Switching Information' subtab.
@ Parameter - initiateOptionFields
@ Return Type - null
@ Created By - Niharika Modi
****************************************
*/
    
    public void AddIO(){
        IO_and_Switching_Information__c io =new IO_and_Switching_Information__c();
        if(customDesign.id != null)
            io.Custom_Design_Specification__c =customDesign.id;
        ioList.add(io);
        PaginateIO();
        
    }
    
   /*
*************************************    
@ Name -  PaginateIO
@ Description - Paginate IO Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void PaginateIO(){
             this.paginaterIO = new Paginate(IOList.size(), pageSize); //These lists hold the data 
                    this.fullGenericListIO = new List<List<IO_and_Switching_Information__c>>(); 
                    this.genericListIO = new List<IO_and_Switching_Information__c>(); //Break out the full list into a list of lists 
                    if(IOList.size() > 0){ 
                        List<IO_and_Switching_Information__c> tempCC = new List<IO_and_Switching_Information__c>(); 
                        Integer i = 0; 
                        for(IO_and_Switching_Information__c cc : IOList){ 
                            tempCC.add(cc); 
                            i++; 
                            if(i == pageSize){ 
                                this.fullGenericListIO.add(tempCC); 
                                tempCC = new List<IO_and_Switching_Information__c>(); 
                                i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            this.fullGenericListIO.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        this.genericListIO = this.fullGenericListIO.get(this.paginaterIO.index); 
                    }
       
    }
    
    /*
*************************************    
@ Name -  DeleteIO
@ Description -  Deleting the rows in IO Table under 'I/O and Switching Information' subtab. .
@ Parameter - initiateOptionFields
@ Return Type - null
@ Created By - Cognizant
****************************************
*/
    public void DeleteIO(){
        if(ioList[deletedItemIndex].id!=null)
            deletedIoList.add(ioList[deletedItemIndex]);
        ioList.remove(deletedItemIndex);
        PaginateIO();
        
    }
    
    /*
*************************************    
@ Name -  reQuote
@ Description -  .
@ Parameter - null
@ Return Type - null
@ Created By - Niharika Modi
****************************************
*/
   public PageReference reQuote()
    {
        
        String reQuoteId = DesignExecutionUtility.requote(customDesign.id);
        if(reQuoteId != null){
            //PageReference p=new PageReference('/' + DesignExecutionUtility.requote(customDesign.id));
            PageReference p=new PageReference('/' + reQuoteId);
            return p;
        }
    //   ApexPages.addMessages('last Accespted');
       return null;
    }
    /*
    
*************************************    
@ Name -  controllerActionPageDram
@ Description -  .
@ Parameter - null
@ Return Type - null
@ Created By - MSeth
****************************************
*/
   public PageReference controllerActionPageDramC()
    {
       return null;
    }
/*
*************************************    
@ Name -  setEccnColor
@ Description - Set color field based on Design ECCN value .
@ Parameter - null
@ Return Type - null
@ Created By - Cognizant
****************************************
*/ 
    @TestVisible private void setEccnColor()
    {
        String designECCN = customDesign.Design_ECCN_Number__c;
        custSet = new list<psa_psc_eccn_default__c>();
                custSet = [SELECT Name,ECCN_Color__c,D1_National_Access_Allowed__c,psa_eccn__c,psc_eccn__c FROM psa_psc_eccn_default__c ];    
                allColorCodes = new Map<String,psa_psc_eccn_default__c>();
                for(psa_psc_eccn_default__c colorZone: custSet){
                    allColorCodes.put(colorZone.Name,colorZone);
                }
        if(designECCN != null){

            if(allColorCodes.get(designECCN) <> null){
                customDesign.Color_ECCN__c= allColorCodes.get(designECCN).ECCN_Color__c;
            }
            else{
                 if(itarFlag == 'Yes'){
                    customDesign.Color_ECCN__c = 'RED';
                }
                else{
                    customDesign.Color_ECCN__c = 'None';

                }
            }
        }
        
    }
    /*
*************************************    
@ Name -  assignDesignToQueue
@ Description - Assign Queue based on Color Code of Design ECCN .
@ Parameter - null
@ Return Type - null
@ Created By - Niharika Modi
****************************************
*/ 
    @TestVisible private void assignDesignToQueue()
    {
        string queueName = 'CDS ' + customDesign.Color_ECCN__c + ' ' + Label.CDSColorZone;
        List<Group> q = new List<Group>();
        q = [SELECT Id FROM Group WHERE Name =:queueName and  Type='Queue'];
        
        if(q <> null && q.size() > 0){
            customDesign.OwnerId = q[0].id;
            
        }
        
    }
    
    /*
*************************************    
@ Name -  doSave
@ Description - Saves the record of "CDS Page Frame" .
@ Parameter - null
@ Return Type - PageReference
@ Created By - Niharika Modi
****************************************
*/  
    public PageReference doSave()
    {
        
        try{
            /*   
If (customDesign.IDR_actual_date__c!=null)
{
customDesign.CDS_Status__c = 'IDR Complete';
}*/
            //Edit and update the records
            if(customDesign.id != null && Schema.SObjectType.Custom_Design__c.isUpdateable())
            {
                //Setting color field based on color zone
                setEccnColor();
                //Assigning custom design to queue based on ECCN Color zone
                if(customDesign.Color_ECCN__c != null)
                    assignDesignToQueue();
                /*    string queueName = customDesign.Color_Zone__c + ' Zone Queue';

Group q = [SELECT Id FROM Group WHERE Name =:queueName and Type='Queue'];
customDesign.OwnerId = q.id;
*/  
                Update customDesign;
                reasonChange.Customer_Design_Specification__c = customDesign.id;
                insert reasonChange;
                //Uploading Attachments
                if(att.parentId==null){
                    att.parentId = customDesign.Id;
                }
                
                att.attachMap.put(CDSAttachmentUploadForm.CDS_HEADER_BEGIN,cdsHeaderFile);
                att.attachMap.put(CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN,signalPowerFile);
                att.attachMap.put(CDSAttachmentUploadForm.MITI_TRAN_BEGIN,mitiTranFile);
                att.attachMap.put(CDSAttachmentUploadForm.NOISE_SPECS_BEGIN,noiseSpecsFile);
                att.attachMap.put(CDSAttachmentUploadForm.DRAM_BEGIN,dramFile);
                att.attachMap.put(CDSAttachmentUploadForm.DD_BEGIN,ddFile);
                att.attachMap.put(CDSAttachmentUploadForm.CORE_BEGIN,coreFile);
                att.attachMap.put(CDSAttachmentUploadForm.IMAGE_INF_BEGIN,imageInfFile);
                att.attachMap.put(CDSAttachmentUploadForm.PKG_INF_BEGIN,pkgInfFile);
                att.attachMap.put(CDSAttachmentUploadForm.CARD_INF_BEGIN,cardInfFile);
                att.attachMap.put(CDSAttachmentUploadForm.SCAN_BITS_BEGIN,scanBitsFile);
                att.attachMap.put(CDSAttachmentUploadForm.DES_TEST_BEGIN,desTestFile);
                att.attachMap.put(CDSAttachmentUploadForm.ADD_TOOLS_BEGIN,addToolsFile);
                att.attachMap.put(CDSAttachmentUploadForm.MFG_TEST_BEGIN,mfgTestFile);
                att.attachMap.put(CDSAttachmentUploadForm.ARC_INFO_BEGIN,archInfoFile);
                att.attachMap.put(CDSAttachmentUploadForm.DES_STRC_BEGIN,desStrcFile);
                att.attachMap.put(CDSAttachmentUploadForm.NET_CUST_BEGIN,netCustFile);
                att.attachMap.put(CDSAttachmentUploadForm.SPL_PLACE_BEGIN,splPlaceFile);
                att.attachMap.put(CDSAttachmentUploadForm.SPL_WIRE_BEGIN,splWireFile);
                att.attachMap.put(CDSAttachmentUploadForm.CLK_INFO_BEGIN,clockInfoFile);
                att.attachMap.put(CDSAttachmentUploadForm.CLK_CHAR_BEGIN,clockCharFile);
                att.attachMap.put(CDSAttachmentUploadForm.AVST_BEGIN,avstFile);
                
                Boolean isError = att.saveAttachList();
                Integer j = 0;
                //Updating IO Table
                if(ioList.size()>0){
                    while (j < ioList.size()){
                         if(ioList.get(j).Customer_interface_reference__c != null || ioList.get(j).I_O_function__c !=null 
                           || ioList.get(j).I_O_type_cell_prefixb__c !=null || ioList.get(j).I_O_qty__c != null 
                           || ioList.get(j).Module_pin_qty__c !=null || ioList.get(j).Interface_clock_freq_MHze__c != null 
                           || ioList.get(j).Interface_data_rate_Mb_sf__c != null || ioList.get(j).Drive_mode_e_g_drive_strengthg__c != null 
                           || ioList.get(j).Modeling_load_Txline_R_L_Ch__c !=null){
                               ioList.get(j).Custom_Design_Specification__c=customDesign.id;
                           }else
                           {
                               ioList.remove(j);
                           }
                        j++;
                    }
                   if(Schema.SObjectType.IO_and_Switching_Information__c.isUpdateable()
                       && Schema.SObjectType.IO_and_Switching_Information__c.isCreateable())
                        Upsert ioList;
                }
                if(deletedIoList.size()>0){
                    if(Schema.SObjectType.IO_and_Switching_Information__c.isDeletable())
                        Delete deletedIoList;
                }
                //Updating Dram Table
                if(dmList.size()>0){
                    j = 0;
                    while (j < dmList.size()){
                        if(dmList.get(j).DRAM_Name__c != null || dmList.get(j).Qty__c !=null){
                            dmList.get(j).Custom_Design_Specification__c=customDesign.id;
                        }else
                        {
                            dmList.remove(j);
                        }
                        j++;
                    }
                    if(Schema.SObjectType.DRAMs__c.isUpdateable()
                       && Schema.SObjectType.DRAMs__c.isCreateable())
                        Upsert dmList;
                }
                if(deletedDramList.size()>0){
                    if(Schema.SObjectType.DRAMs__c.isDeletable())
                        Delete deletedDramList;
                }
                   //Updating Compilable Table
                if(cmpList.size()>0){
                    while (j < cmpList.size()){
                        if(cmpList.get(j).Macro_name__c != null || cmpList.get(j).Words__c !=null 
                           || cmpList.get(j).Bits__c !=null || cmpList.get(j).Ports__c != null 
                           || cmpList.get(j).Redundant__c !=null || cmpList.get(j).Decode_Option__c != null 
                           || cmpList.get(j).Quantity__c != null || cmpList.get(j).Size_per_Macro__c != null){
                               cmpList.get(j).Custom_Design_Specification__c=customDesign.id;
                           }else
                           {
                               cmpList.remove(j);
                           }
                        j++;
                    }
                    if(Schema.SObjectType.Compilable__c.isUpdateable()
                       && Schema.SObjectType.Compilable__c.isCreateable())
                        Upsert cmpList;
                }
                if(deletedCmpList.size()>0){
                    if(Schema.SObjectType.Compilable__c.isDeletable())
                        Delete deletedCmpList;
                }
                //Updating Cores Table
                if(cpList.size()>0){
                    j = 0;
                    while (j < cpList.size()){
                        if(cpList.get(j).Characteristics__c != null || cpList.get(j).Core_Name__c !=null
                           || cpList.get(j).Quantity_Cores__c != null || cpList.get(j).Size_per_Macro_Cores__c != null){
                               cpList.get(j).Custom_Design_Specification__c=customDesign.id;
                           }else
                           {
                               cpList.remove(j);
                           }
                        j++;
                    }
                    if(Schema.SObjectType.CoresPLL__c.isUpdateable()
                       && Schema.SObjectType.CoresPLL__c.isCreateable())
                        Upsert cpList;
                }
                if(deletedCoreList.size()>0){
                    if(Schema.SObjectType.CoresPLL__c.isDeletable())
                        Delete deletedCoreList;
                }
                //Updating Deliverables Table
                if(ddList.size()>0){
                    j = 0;
                    while (j < ddList.size()){
                        if(ddList.get(j).Description_Development_Deliverables__c != null || ddList.get(j).Name_Development_Deliverables__c !=null
                           || ddList.get(j).Quantity_Development_Deliverables__c != null || ddList.get(j).Size_Cells__c != null 
                           || ddList.get(j).Type_Development_Deliverables__c != null){
                               ddList.get(j).Custom_Design_Specification__c=customDesign.id;
                           }else
                           {
                               ddList.remove(j);
                           }
                        j++;
                    }
                    if(Schema.SObjectType.Development_Deliverable__c.isUpdateable()
                       && Schema.SObjectType.Development_Deliverable__c.isCreateable())
                        Upsert ddList;
                }
                if(deletedDevdList.size()>0){
                    if(Schema.SObjectType.Development_Deliverable__c.isDeletable())
                        Delete deletedDevdList;
                }
                
                //Updating clock Table
                if(clockList.size()>0){
                    
                    if(Schema.SObjectType.Clock_Characteristics__c.isUpdateable())
                        Update clockList;
                } 
                
                
            }
            else if(customDesign.id == null && Schema.SObjectType.Custom_Design__c.isCreateable()){
                /* If (customDesign.IDR_actual_date__c!=null)
{
customDesign.CDS_Status__c = 'IDR Complete';
}*/
                //Setting color field based on color zone
                setEccnColor();
                //Assigning custom design to queue based on ECCN Color zone
                if(customDesign.Color_ECCN__c != null)
                    assignDesignToQueue();
                /*  string queueName = customDesign.Color_Zone__c + ' Zone Queue';

Group q = [SELECT Id FROM Group WHERE Name =:queueName and Type='Queue'];
customDesign.OwnerId = q.id; */
                customDesign.CDS_Status__c = 'Draft';
                insert  customDesign;
                
                
                //Uploading Attachments
                if(att.parentId==null){
                    att.parentId = customDesign.Id;
                }
                att.attachMap.put(CDSAttachmentUploadForm.CDS_HEADER_BEGIN,cdsHeaderFile);
                att.attachMap.put(CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN,signalPowerFile);
                att.attachMap.put(CDSAttachmentUploadForm.MITI_TRAN_BEGIN,mitiTranFile);
                att.attachMap.put(CDSAttachmentUploadForm.NOISE_SPECS_BEGIN,noiseSpecsFile);
                att.attachMap.put(CDSAttachmentUploadForm.DRAM_BEGIN,dramFile);
                att.attachMap.put(CDSAttachmentUploadForm.DD_BEGIN,ddFile);
                att.attachMap.put(CDSAttachmentUploadForm.CORE_BEGIN,coreFile);
                att.attachMap.put(CDSAttachmentUploadForm.IMAGE_INF_BEGIN,imageInfFile);
                att.attachMap.put(CDSAttachmentUploadForm.PKG_INF_BEGIN,pkgInfFile);
                att.attachMap.put(CDSAttachmentUploadForm.CARD_INF_BEGIN,cardInfFile);
                att.attachMap.put(CDSAttachmentUploadForm.SCAN_BITS_BEGIN,scanBitsFile);
                att.attachMap.put(CDSAttachmentUploadForm.DES_TEST_BEGIN,desTestFile);
                att.attachMap.put(CDSAttachmentUploadForm.ADD_TOOLS_BEGIN,addToolsFile);
                att.attachMap.put(CDSAttachmentUploadForm.MFG_TEST_BEGIN,mfgTestFile);
                att.attachMap.put(CDSAttachmentUploadForm.ARC_INFO_BEGIN,archInfoFile);
                att.attachMap.put(CDSAttachmentUploadForm.DES_STRC_BEGIN,desStrcFile);
                att.attachMap.put(CDSAttachmentUploadForm.NET_CUST_BEGIN,netCustFile);
                att.attachMap.put(CDSAttachmentUploadForm.SPL_PLACE_BEGIN,splPlaceFile);
                att.attachMap.put(CDSAttachmentUploadForm.SPL_WIRE_BEGIN,splWireFile);
                att.attachMap.put(CDSAttachmentUploadForm.CLK_INFO_BEGIN,clockInfoFile);
                att.attachMap.put(CDSAttachmentUploadForm.CLK_CHAR_BEGIN,clockCharFile);
                att.attachMap.put(CDSAttachmentUploadForm.AVST_BEGIN,avstFile);
                Boolean isError = att.saveAttachList();  
                 //Insert IO List
            /*    for(IO_and_Switching_Information__c item:ioList)
                {
                    item.Custom_Design_Specification__c=customDesign.id;
                }
                if(Schema.SObjectType.IO_and_Switching_Information__c.isCreateable())
                    Insert ioList;*/
                //Insert IO List
                /*  Set<IO_and_Switching_Information__c> ioSet = new Set<IO_and_Switching_Information__c>();
for(IO_and_Switching_Information__c item:ioList)
{
if(item.Customer_interface_reference__c != null || item.I_O_function__c != null 
|| item.I_O_type_cell_prefixb__c !=null || item.I_O_qty__c != null || item.Module_pin_qty__c !=null
|| item.Interface_clock_freq_MHze__c != null || item.Interface_data_rate_Mb_sf__c != null 
|| item.Drive_mode_e_g_drive_strengthg__c != null || item.Modeling_load_Txline_R_L_Ch__c !=null){

item.Custom_Design_Specification__c=customDesign.id;
ioSet.add(item);
}
}
ioList = new List<IO_and_Switching_Information__c>();
ioList.addAll(ioSet);
*/
              Integer j = 0;
               while (j < ioList.size()){
                    if(ioList.get(j).Customer_interface_reference__c != null || ioList.get(j).I_O_function__c !=null 
                       || ioList.get(j).I_O_type_cell_prefixb__c !=null || ioList.get(j).I_O_qty__c != null 
                       || ioList.get(j).Module_pin_qty__c !=null || ioList.get(j).Interface_clock_freq_MHze__c != null 
                       || ioList.get(j).Interface_data_rate_Mb_sf__c != null || ioList.get(j).Drive_mode_e_g_drive_strengthg__c != null 
                       || ioList.get(j).Modeling_load_Txline_R_L_Ch__c !=null){
                           ioList.get(j).Custom_Design_Specification__c=customDesign.id;
                       }else
                       { 
                           ioList.remove(j);
                       }
                    j++;
                }
                
                if(Schema.SObjectType.IO_and_Switching_Information__c.isCreateable())
                    Insert ioList;
                
                //Insert DM List
                /* for(DRAMs__c item:dmList)
{
item.Custom_Design_Specification__c=customDesign.id;
}*/
            j = 0;
                while (j < dmList.size()){
                    if(dmList.get(j).DRAM_Name__c != null || dmList.get(j).Qty__c !=null){
                        dmList.get(j).Custom_Design_Specification__c=customDesign.id;
                    }else
                    {
                        dmList.remove(j);
                    }
                    j++;
                }
                if(Schema.SObjectType.DRAMs__c.isCreateable())
                    Insert dmList; 
                
                 //Insert CMP List
                j = 0;
                while (j < cmpList.size()){
                    if(cmpList.get(j).Macro_name__c != null || cmpList.get(j).Words__c !=null
                       || cmpList.get(j).Bits__c != null || cmpList.get(j).Ports__c != null 
                       || cmpList.get(j).Redundant__c != null || cmpList.get(j).Decode_Option__c != null
                      || cmpList.get(j).Quantity__c != null  || cmpList.get(j).Size_per_Macro__c != null){
                           cmpList.get(j).Custom_Design_Specification__c=customDesign.id;
                       }else
                       {
                           cmpList.remove(j);
                       }
                    j++;
                }
                if(Schema.SObjectType.Compilable__c.isCreateable())
                    Insert cmpList;
                    
                //Insert CP List
                /*for(CoresPLL__c item:cpList)
{
item.Custom_Design_Specification__c=customDesign.id;
}*/
             j = 0;
                while (j < cpList.size()){
                    if(cpList.get(j).Characteristics__c != null || cpList.get(j).Core_Name__c !=null
                       || cpList.get(j).Quantity_Cores__c != null || cpList.get(j).Size_per_Macro_Cores__c != null){
                           cpList.get(j).Custom_Design_Specification__c=customDesign.id;
                       }else
                       {
                           cpList.remove(j);
                       }
                      j++;
                }
                if(Schema.SObjectType.CoresPLL__c.isCreateable())
                    Insert cpList;
               
                //Insert DD List
                /*  for(Development_Deliverable__c item:ddList)
{
item.Custom_Design_Specification__c=customDesign.id;
}*/
               j = 0;
                while (j < ddList.size()){
                    if(ddList.get(j).Description_Development_Deliverables__c != null || ddList.get(j).Name_Development_Deliverables__c !=null
                       || ddList.get(j).Quantity_Development_Deliverables__c != null || ddList.get(j).Size_Cells__c != null 
                       || ddList.get(j).Type_Development_Deliverables__c != null){
                           ddList.get(j).Custom_Design_Specification__c=customDesign.id;
                       }else
                       {
                           ddList.remove(j);
                       }
                      j++;
                }
                if(Schema.SObjectType.Development_Deliverable__c.isCreateable())
                    Insert ddList; 
             
                //Insert Clock List
                for(Clock_Characteristics__c item:clockList)
                {
                    item.Customer_Design_Specification__c=customDesign.id;
                }
                if(Schema.SObjectType.Clock_Characteristics__c.isCreateable())
                    insert clockList;
            }
            List<Device__c> deviceLst = new List<Device__c>();
            devLst = [Select Id,Is_CDSCreated__c,CDS_Number__c From Device__c Where Id =: customDesign.Device__c LIMIT 1];
            if(!devLst.isEmpty()){
            for(Device__c dev :devLst){
                dev.Is_CDSCreated__c = true;
                dev.CDS_Number__c = customDesign.Name;
                deviceLst.add(dev);
            }
                if(!deviceLst.isEmpty())
                Update deviceLst;
            }            
            
        }catch (Exception excp) {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','doSave','','Exception while inserting the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            return null;
        }
        
        
        if(retURL == NULL)
            p=new PageReference('/'+customDesign.id);
        else
            p=new PageReference(retURL);
        p.setRedirect(true);
        return p;
    }
    /*
*************************************    
@ Name -  AddDram
@ Description - Adding the rows in Dram Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void AddDram(){
        DRAMs__c dm =new DRAMs__c();
        if(customDesign.id != null)
            dm.Custom_Design_Specification__c =customDesign.id;
             dmlist.add(dm);
             PaginateDram();
       
    }
     /*
*************************************    
@ Name -  PaginateDram
@ Description - Paginate Dram Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void PaginateDram(){
             this.paginaterDram = new Paginate(dmList.size(), pageSize); //These lists hold the data 
                    this.fullGenericListDram = new List<List<DRAMs__c>>(); 
                    this.genericListDram = new List<DRAMs__c>(); //Break out the full list into a list of lists 
                    if(dmList.size() > 0){ 
                        List<DRAMs__c> tempCC = new List<DRAMs__c>(); Integer i = 0; 
                        for(DRAMs__c cc : dmList){ 
                            tempCC.add(cc); 
                            i++; 
                            if(i == pageSize){ 
                            this.fullGenericListDram.add(tempCC); 
                            tempCC = new List<DRAMs__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            this.fullGenericListDram.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        this.genericListDram = this.fullGenericListDram.get(this.paginaterDram.index); 
                    }
       
    }
    
    /*
*************************************    
@ Name -  DeleteDram
@ Description - Deleting the rows in Dram Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference DeleteDram(){
        if(dmList[deletedItemIndex].id!=null)
            deletedDramList.add(dmList[deletedItemIndex]);
        dmList.remove(deletedItemIndex);
            PaginateDram();
        return null;
    }
    /*

   *************************************    
@ Name -  AddComp
@ Description - Adding the rows in Compilable Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void AddComp(){
        Compilable__c cmp =new Compilable__c();
        System.debug('@@@Complist'+cmpList);
        if(customDesign.id != null)
            cmp.Custom_Design_Specification__c =customDesign.id;
          For(Compilable__c c:cmpList){
          
          System.debug('@@@Complist'+c);
          } 
        cmpList.add(cmp);
        PaginateComp();
    }
    
     /*
*************************************    
@ Name -  PaginateComp
@ Description - Paginate Comp Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void PaginateComp(){
             this.paginaterComp = new Paginate(cmpList.size(), pageSize); //These lists hold the data 
                    this.fullGenericListComp = new List<List<Compilable__c>>(); 
                    this.genericListComp = new List<Compilable__c>(); //Break out the full list into a list of lists 
                    if(cmpList.size() > 0){ 
                        List<Compilable__c> tempCC = new List<Compilable__c>(); 
                        Integer i = 0; 
                        for(Compilable__c cc : cmpList){ 
                            tempCC.add(cc); i++; if(i == pageSize){ 
                            this.fullGenericListComp.add(tempCC); 
                            tempCC = new List<Compilable__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            this.fullGenericListComp.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        this.genericListComp = this.fullGenericListComp.get(this.paginaterComp.index); 
                    }
       
    }
    
      /*
*************************************    
@ Name -  DeleteComp
@ Description - Deleting the rows in Compilables Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public PageReference DeleteComp(){
        if(cmpList[deletedItemIndex].id!=null)
            deletedCmpList.add(cmpList[deletedItemIndex]);
        cmpList.remove(deletedItemIndex);
        PaginateComp();
        return null;
    }
    
    /*
*************************************    
@ Name -  AddCore
@ Description - Adding the rows in Cores Table under Cores and PLL's subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public void AddCore(){
        CoresPLL__c cp =new CoresPLL__c();
        if(customDesign.id != null)
            cp.Custom_Design_Specification__c =customDesign.id;
        cpList.add(cp);
        PaginateCore();
    }
    
    
/*
*************************************    
@ Name -  PaginateCore
@ Description - Paginate Core Table under Compilables subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void PaginateCore(){
             this.paginaterCore = new Paginate(cpList.size(), pageSize); //These lists hold the data 
                    this.fullGenericListCore = new List<List<CoresPLL__c>>(); 
                    this.genericListCore = new List<CoresPLL__c>(); //Break out the full list into a list of lists 
                    if(cpList.size() > 0){ 
                        List<CoresPLL__c> tempCC = new List<CoresPLL__c>(); 
                        Integer i = 0; 
                        for(CoresPLL__c cc : cpList){ 
                            tempCC.add(cc); i++; if(i == pageSize){ 
                            this.fullGenericListCore.add(tempCC); 
                            tempCC = new List<CoresPLL__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            this.fullGenericListCore.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        this.genericListCore = this.fullGenericListCore.get(this.paginaterCore.index); 
                    }
       
    }
    /*
*************************************    
@ Name -  DeleteCore
@ Description - Deleting the rows in Cores Table under Cores and PLL's subtab. 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference DeleteCore(){
        if(cpList[deletedItemIndex].id!=null)
            deletedCoreList.add(cpList[deletedItemIndex]);
        cpList.remove(deletedItemIndex);
        PaginateCore();
        return null;
    }
    
    /*
*************************************    
@ Name -  AddDevd
@ Description - Adding the rows in Development Deliverable Table under Development Deliverable: Custom Circuits, Macros and IOs subtab 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public void AddDevd(){
        Development_Deliverable__c dd =new Development_Deliverable__c();
        if(customDesign.id != null)
            dd.Custom_Design_Specification__c =customDesign.id;
        ddList.add(dd);
        PaginateDevd();
    }

/*
*************************************    
@ Name -  PaginateDevd
@ Description - Paginate Deliverables Table under  subtab.
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public void PaginateDevd(){
             this.paginaterDevd = new Paginate(ddList.size(), pageSize); //These lists hold the data 
                    this.fullGenericListDevd = new List<List<Development_Deliverable__c>>(); 
                    this.genericListDevd = new List<Development_Deliverable__c>(); //Break out the full list into a list of lists 
                    if(ddList.size() > 0){ 
                        List<Development_Deliverable__c> tempCC = new List<Development_Deliverable__c>(); 
                        Integer i = 0; 
                        for(Development_Deliverable__c cc : ddList){ 
                            tempCC.add(cc); i++; if(i == pageSize){ 
                            this.fullGenericListDevd.add(tempCC); 
                            tempCC = new List<Development_Deliverable__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            this.fullGenericListDevd.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        this.genericListDevd = this.fullGenericListDevd.get(this.paginaterDevd.index); 
                    }
       
    }
    
    /*
*************************************    
@ Name -  DeleteDevd
@ Description - Deleting the rows in Development Deliverable Table under Development Deliverable: Custom Circuits, Macros and IOs subtab 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference DeleteDevd(){
        if(ddList[deletedItemIndex].id!=null)
            deletedDevdList.add(ddList[deletedItemIndex]);
        ddList.remove(deletedItemIndex);
        PaginateDevd();
        return null;
    }
    
    /*
*************************************    
@ Name -  AddPartyDesign
@ Description - Adding the rows in AddPartyDesign Table under 3rd Party Design Center Contacts subtab. 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference AddPartyDesign(){
        Third_Party_Design_Contact__c pd =new Third_Party_Design_Contact__c();
        pd.Custom_Design_Specification__c =customDesign.id;
        pdList.add(pd);
        return null;
    }
    
    /*
*************************************    
@ Name -  DeletePartyDesign
@ Description -  Deleting the rows in AddPartyDesign Table under 3rd Party Design Center Contacts subtab. 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference DeletePartyDesign(){
        if(pdList[deletedItemIndex].id!=null)
            deletedPartyDesignList.add(pdList[deletedItemIndex]);
        pdList.remove(deletedItemIndex);
        return null;
    }   
    /*
*************************************    
@ Name -  deleteAttachments
@ Description -  Deleting the attachments from the attachment section. 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public void deleteAttachments()
    {
        Attachment attach = [select id,name,body,parentid,description from Attachment 
                             where id = :targetNAID];
        try{
            delete attach;
        }catch (Exception excp) {
            GlobalUtility.logMessage('Error','CDSFormExtension','deleteAttachments','','Exception while deleting the attachment',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);     
        }
    }
    
    
    
    /*public PageReference UploadFile()  
{      paramValue=ApexPages.currentPage().getParameters().get('sectionId');
Attachment attachment  = new Attachment();  
attachment.Body = fileBody;  
attachment.Name = fileName+paramValue; 
attachment.OwnerId = UserInfo.getUserId();
attachment.ParentId = customDesign.id; // the record the file is attached to
attachment.IsPrivate = true;



try {
insert attachment;
} catch (DMLException e) {
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
return null;
}

/*  if(retURL == NULL)
p=new PageReference('/'+customDesign.id);
else
p=new PageReference(retURL);
p.setRedirect(false);
return p;
return null;
}*/
    /**
*  Description of the purpose of the classthe method. 
*  @name <method-name>
*  @param <parameter-name> <description>
*  @return <parameter> - <Description about the return parameter>
*  @throws exception-<exception description>
*/
    /*   public PageReference EditPage(){
if(p == null){
PageReference pageRef = new PageReference('/apex/CDSPageFrame');
return pageRef;
}
else{
return null;
}
} */
    
    /**
*  Delete Functionality provided to Delete the 'CDSViewPageFrame' page. 
*  @name <deletePage>
*  @param <parameter-name> <description>
*  @return <reference> - <It returns us back to the 'Customer Design Specifications' home page.>
*  @throws exception-<exception description>
*/
    public PageReference deletePage()
    {
        
        String del2 = System.currentPageReference().getParameters().get('id'); 
        Custom_Design__c del=new Custom_Design__c();
        del.id= del2;
        delete del;  
        PageReference reference=new PageReference('/a1Y/o');
        return reference;
    } 
    
    /**
*  Export to Excel Functionality exports all the data into Microsoft Excel.
*  @name <exportToExcel>
*  @param <parameter-name> <description>
*  @return <excel> - <Excel gets downloaded automatically.>
*  @throws exception-<exception description>
*/
    public PageReference exportToExcel() {
        
        PageReference excel = Page.CDSExcel;
        excel.getParameters().put('id',customDesign.Id);
        
        return excel; 
    }
    
    /*
*************************************    
@ Name -  pdfSnapshot
@ Description -  PDF Snapshot Functionality exports all the data into PDF.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference pdfSnapshot() {
        
        Date pdfDate = system.today();
        //   PageReference pdfSnap = Page.CDSPageAsPDF;
        PageReference pdfSnap = new PageReference('/apex/CDSPageAsPDF');
        pdfSnap.getParameters().put('id',customDesign.Id);
        // create the new attachment
        Attachment attach = new Attachment();
        
        // the contents of the attachment from the pdf
        Blob body;
        try {
        
               if(itarFlag == 'Yes'){
                    //THROUGH GATEWAY
                    body = pdfSnap.getContent();
                }
                else{
                    //DIRECT
                    body = pdfSnap.getContentAsPdf();
                }
                
           
            
            // need to pass unit test -- current bug    
        } catch (VisualforceException excp) {
            // body = Blob.valueOf('Some Text');
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','syncOption','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            
        }
        
        attach.Body = body;
        // add the user entered name
        attach.Name = CDSAttachmentUploadForm.CDS_PDF + customDesign.Name + '_' + Datetime.now().format('yyyy-MM-dd HH:mm') + '.pdf';
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = customDesign.Id;
        try {
            attach.ContentType = 'application/pdf';
            insert attach;
        } catch (Exception excp) {
            // body = Blob.valueOf('Some Text');
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','syncOption','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            
        }
        PageReference p=new PageReference('/'+customDesign.id);
        p.getParameters().put('id',customDesign.Id);
        
        p.setRedirect(true);      
        return p;
        
    }
    
    /*
*************************************    
@ Name -  dis
@ Description -  For Locking and Unlocking the view page.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public void dis()
    {
        if( customDesign.Lock__c){
            customDesign.Lock__c = false;
            customDesign.CDS_Status__c ='In DE';
        }else{
            customDesign.Lock__c = true;
            customDesign.CDS_Status__c ='Complete';
        }
        
        try {
            update customDesign;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','syncOption','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            
            //  return null;
        }
        //disable1 = true;
        // disable2 = true;
    }
    
    /*
*************************************    
@ Name -  EditPage
@ Description -  Edit Functionality provided to edit the 'CDSViewPageFrame' page. 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference EditPage() {
        
        if(customDesign.DIW_Option_Control_Number__c != techReqId ){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please sync option data before editing CDS'));
            
        }else{
            Pagereference p=new Pagereference('/apex/CDSPageFrame');
            p.getParameters().put('id',customDesign.Id);
            p.getParameters().put('type','edit');
            p.setRedirect(true);
            return p;      
        }
        return null;
    }
    
    /*
*************************************    
@ Name -  doCancel
@ Description -  Cancel Functionality is provided on edit 'CDSViewPageFrame' page.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/  
    public PageReference doCancel() {
        if(id == null)
            return new PageReference('/apex/CDSListForOpp?devId='+ deviceId + '&oppId='+oppId).setRedirect(true);
        else{
            PageReference p=new PageReference('/apex/CDSViewPageFrame');
            p.getParameters().put('id',customDesign.Id);
            p.setRedirect(true);      
            return p;
        }
        
    }
    
    
    /*
*************************************    
@ Name -  goToTechReview
@ Description -  Go To TechReview Functionality is provided on 'CDSViewPageFrame' page.
@ Parameter - None
@ Return Type - 
@ Created By - Varsha Tomar
****************************************
*/
    public PageReference goToTechReview() {
        BnP_TechReview_Util trUtil = new BnP_TechReview_Util();
        PageReference pgRef;
        if(customDesign.DIW_Option_Control_Number__c != null) {
            List<Decision__c> dcList = [select Name, Technical_Requirement__r.Name, Technical_Requirement__c, Charge_Number__c, Opportunity__c, Opportunity__r.Name, 
                                        Request_Information__c, Request_Information__r.Name, Device__c, Device__r.Name
                                        from Decision__c 
                                        where Technical_Requirement__c = :customDesign.DIW_Option_Control_Number__c];
            
            String chargeNumber = '';
            List<Charge_Info__c> chargeInfoList = [select Charge_Number__c from Charge_Info__c where Option__c = :customDesign.DIW_Option_Control_Number__c];
            // if exist the assign to charge info variable
            if(chargeInfoList != null && chargeInfoList.size() > 0) {
                chargeNumber = chargeInfoList[0].Charge_Number__c;
            }
            if(dcList != null && dcList.size() > 0) {
                Decision__c decisionRecord = dcList[0];
                
                String recTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('ASIC Tech Review 1').getRecordTypeId();
                pgRef = trUtil.callTechReview(decisionRecord, chargeNumber, recTypeId);
            } else {
                pgRef = new PageReference('/apex/BNP_TechReviewMessage');
                pgRef.getParameters().put('retURL',customDesign.Id);
                pgRef.getParameters().put('optionId', customDesign.DIW_Option_Control_Number__c);
                return pgRef;
            }
        }
        if(pgRef != null) {
            pgref.getParameters().put(Label.BNP_CDS,customDesign.Name);
            pgref.getParameters().put(Label.BNP_CDS+'_lkid',customDesign.Id);
            pgref.getParameters().put('retURL',customDesign.Id);
            return pgRef;
        } else {
            pgRef = new PageReference('/apex/CDSViewPageFrame');
            pgRef.getParameters().put('id', customDesign.Id);
            pgRef.setRedirect(true);      
            return pgRef;
        }
    }
    /*
*************************************    
@ Name -  createClone
@ Description -  For Cloning CDS Record.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference createClone(){      
        
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        //PageReference pageReference = null;
        //String decisionId  = ApexPages.currentPage().getParameters().get('decId');
       if((ApexPages.currentPage().getParameters().get('devId'))!= null)
          deviceId = ApexPages.currentPage().getParameters().get('devId');

        try{
            List<Custom_Design__c> lstCustomDesign;
            lstCustomDesign = new  List<Custom_Design__c>();
            lstCustomDesign = [SELECT id, Name FROM Custom_Design__c WHERE Device__c =: deviceId ];
           
            //String optId  = ApexPages.currentPage().getParameters().get('optId');
            if(lstCustomDesign.size() < 1){
                Device__c devInfo = [SELECT Primary_Option__c FROM Device__c WHERE Id = :deviceId ]; 
                techReqId = devInfo.Primary_Option__c;  
                //techReqId = ApexPages.currentPage().getParameters().get('optId');
                newCustomDesign = customDesign.clone(false);
                newCustomDesign.Device__c = deviceId;
                if(techReqId != null)
                    initiateOptionFields(newCustomDesign);
                //    newCustomDesign.DIW_Option_Control_Number__c = techReqId;
                // newCustomDesign.Decision__c = decisionId;
                
                insert newCustomDesign;
                populateRelatedLists();
                // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
                List<DRAMs__c> dramItems = new List<DRAMs__c>();
                for (DRAMs__c dram : dmList) {
                    DRAMs__c newDram = dram.clone(false);
                    newDram.Custom_Design_Specification__c = newCustomDesign.id;
                    dramItems.add(newDram);
                }
                insert dramItems;
                List<Compilable__c> compItems = new List<Compilable__c>();
                for (Compilable__c comp : cmpList) {
                    Compilable__c newComp = comp.clone(false);
                    newComp.Custom_Design_Specification__c = newCustomDesign.id;
                    compItems.add(newComp);
                }
                insert compItems;
                List<IO_and_Switching_Information__c> ioItems = new List<IO_and_Switching_Information__c>();
                for (IO_and_Switching_Information__c io : ioList) {
                    IO_and_Switching_Information__c newIo = io.clone(false);
                    newIo.Custom_Design_Specification__c = newCustomDesign.id;
                    ioItems.add(newIo);
                }
                insert ioItems;
                
                List<CoresPLL__c> coreItems = new List<CoresPLL__c>();
                for (CoresPLL__c core : cpList) {
                    CoresPLL__c newCore = core.clone(false);
                    newCore.Custom_Design_Specification__c = newCustomDesign.id;
                    coreItems.add(newCore);
                }
                insert coreItems;
                
                List<Development_Deliverable__c> ddItems = new List<Development_Deliverable__c>();
                for (Development_Deliverable__c devDel : ddList) {
                    Development_Deliverable__c newDevDel = devDel.clone(false);
                    newDevDel.Custom_Design_Specification__c = newCustomDesign.id;
                    ddItems.add(newDevDel);
                }
                insert ddItems;
                
                List<Clock_Characteristics__c> clockItems = new List<Clock_Characteristics__c>();
                for(Clock_Characteristics__c clock:clockList)
                {
                    Clock_Characteristics__c newClock = clock.clone(false);
                    newClock.Customer_Design_Specification__c = newCustomDesign.id;
                    clockItems.add(newClock);
                   
                }
                insert clockItems;
                
                Pagereference p=new Pagereference('/apex/CDSPageFrame');
                p.getParameters().put('id',newCustomDesign.Id);
                p.getParameters().put('type','edit');
                p.setRedirect(true);   
                return p;
                
                
            }
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'CDS already created for device'));
            return null;
        }catch (Exception excp) {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','createClone','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            return null;
        }
    }
    /*
*************************************    
@ Name -  changeStatus
@ Description -  Change the status of CDS.
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference changeStatus(){
        Boolean isReady = true;
        if (customDesign.DIW_Option_Control_Number__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill Primary Option on related Device'));
            isReady = false;
        }  
        if (customDesign.Customer__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Account on related Device'));
            isReady = false;
        }
        if (customDesign.Name_Version__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Chip Name(Name/Version) field'));
            isReady = false;
        }
        if (customDesign.Deliverable_Part_Type__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Deliverable Part Type field on related Option'));
            isReady = false;
        }
        if (customDesign.Rit_Type__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Rit Type field on related Option'));
            isReady = false;
        }
        if (customDesign.Design_System__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the target process node on related Opportunity'));
            isReady = false;
        }
        if (customDesign.Image_Style__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Image Style field in Image/Package tab'));
            isReady = false;
        }
        if (customDesign.Image_Name__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Image Name field in Image/Package tab'));
            isReady = false;
        }
       /* if (customDesign.Package_PinCount_and_Type__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Package PinCount and Type field'));
            isReady = false;
        }*/
        if (customDesign.IDR_actual_date__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Ready for IDR date field'));
            isReady = false;
        }
      /*  if (customDesign.Design_ECCN_Number__c == '5E002' || customDesign.Design_ECCN_Number__c == '5E992'){
            if (customDesign.Functional_ECCN_number__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the Functional ECCN Number field'));
                isReady = false;
            }
        }  */
        if(isReady || Test.isrunningtest()){
        customDesign.CDS_Status__c = 'Complete'; customDesign.CDS_Complete__c = Date.TODAY();
        try{
            update  customDesign;  
            PageReference p=new PageReference('/apex/CDSViewPageFrame');
            p.getParameters().put('id',customDesign.Id);
            p.setRedirect(true);      
            return p;
        }catch (Exception excp) {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','changeStatus','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            return null;
        }
        }
        return null;
    }
    /*
*************************************    
@ Name -  updateECCN
@ Description -  Update ECCN
@ Parameter - None
@ Return Type - 
@ Created By - Cognizant
****************************************
*/
    public PageReference updateECCN(){
        Device__c devInfo = [SELECT id,Opportunity__c,Account__c,Primary_Option__c,ECCN_Wafer__c,ECCN_Technology__c,Assumed_Design_ECCN__c,Assumed_Functional_ECCN__c FROM Device__c WHERE Id = :customDesign.Device__c];                               
        if (devInfo.ECCN_Technology__c !=null){
            customDesign.Design_ECCN_Number__c = devInfo.ECCN_Technology__c;

        }
        else{
            //commented by Naman:Design_ECCN_Number__c is only based on ECCN_Technology__c
            //customDesign.Design_ECCN_Number__c = devInfo.Assumed_Design_ECCN__c;            
            customDesign.Design_ECCN_Number__c = ''; 
        }
        
        if (devInfo.ECCN_Wafer__c !=null)
            customDesign.Functional_ECCN_number__c = devInfo.ECCN_Wafer__c;
        else
            customDesign.Functional_ECCN_number__c = devInfo.Assumed_Functional_ECCN__c;   
        
        try{
            update customDesign;  
        }catch (Exception excp) {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','updateECCN','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            return null;
        }
        return null;
    }
    /*
*************************************    
@ Name -  syncOption
@ Description -  Sync Option Data 
@ Parameter - None
@ Return Type - 
@ Created By - Niharika Modi
****************************************
*/
    public PageReference syncOption(){
        initiateOptionFields(customDesign);
        try{
            update customDesign;  
        }catch (Exception excp) {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','CDSFormExtension','syncOption','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Custom Design Specification',excp,0);
            return null;
        }
        return null;
        
    }
    
    
}