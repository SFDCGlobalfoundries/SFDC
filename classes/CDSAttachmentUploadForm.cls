/**
   @Author <Niharika Modi>
   @name <CDSAttachmentUploadForm>
   @CreateDate <Date>
   @Description <Attachment util for CDSPageFrame VF Page
   Uploads attachments from different sections of CDS form>
   @Version <1.0>
*/
public class CDSAttachmentUploadForm {
    
    // Environmental Variable declaration
  //  public static final string CDS_HEADER_DESC = 'CDS_HEADER_DESC';
  //  public static final string QUES_5_DESC = EnvironmentVariable.get('QUESTION_5_DESC');
    public static final string CDS_HEADER_BEGIN = 'CDS_HEADER_STARTSWITH';
   // public static final string QUES_5_BEGIN = EnvironmentVariable.get('QUES_5_STARTSWITH');
  //  public static final string SIGNAL_POWER_DESC = 'SIGNAL_POWER_DESC';
    public static final string SIGNAL_POWER_BEGIN = 'SIGNAL_POWER_STARTSWITH';
    public static final string MITI_TRAN_BEGIN = 'MITI_TRAN_STARTSWITH';
    public static final string NOISE_SPECS_BEGIN = 'NOISE_SPECS_STARTSWITH';
    public static final string DRAM_BEGIN = 'DRAM_STARTSWITH';
    public static final string DD_BEGIN = 'DevDel_STARTSWITH';
    public static final string CORE_BEGIN = 'Core_STARTSWITH';
    public static final string IMAGE_INF_BEGIN = 'Image_Inf_STARTSWITH';
    public static final string PKG_INF_BEGIN = 'Pkg_Inf_STARTSWITH';
    public static final string CARD_INF_BEGIN = 'Card_Inf_STARTSWITH';
    public static final string SCAN_BITS_BEGIN = 'Scan_Bits_STARTSWITH';
    public static final string DES_TEST_BEGIN = 'Des_Test_STARTSWITH';
    public static final string ADD_TOOLS_BEGIN = 'ASIC_DESIGN_STARTSWITH';
    public static final string MFG_TEST_BEGIN = 'Mfg_Test_STARTSWITH';
    public static final string ARC_INFO_BEGIN = 'Arch_Info_STARTSWITH';
    public static final string DES_STRC_BEGIN = 'Des_Strc_STARTSWITH';
    public static final string NET_CUST_BEGIN = 'Net_Cust_STARTSWITH';
    public static final string SPL_PLACE_BEGIN = 'Spl_Place_STARTSWITH';
    public static final string SPL_WIRE_BEGIN = 'Spl_Wire_STARTSWITH';
    public static final string CLK_INFO_BEGIN = 'Clk_Info_STARTSWITH';
    public static final string CLK_CHAR_BEGIN = 'Clk_Char_STARTSWITH';
    public static final string AVST_BEGIN = 'Avst_STARTSWITH';
    public static final string CDS_PDF = 'CDS_STARTSWITH';
   
    
    
    public static final string OTHER = 'Other';
    
    // Instance variables
    public Map<String,Attachment> attachMap = new Map<String,Attachment>();
    public Map<String,List<Attachment>> attachListMap = new Map<String,List<Attachment>>();
    public Id parentId;
    
  /*
   *************************************    
   @ Name -  getAttachments
   @ Description - Retrieve attachment map for Question 4, Question 5 and Other attachment.
   @ Parameter - Id 
   @ Return Type -  Map<String,List<Attachment>>
   @ Created By - Niharika Modi
   ****************************************
   */  
   public Map<String,List<Attachment>> getAttachments(Id id){
        if(id!=null){           
            parentId = id;
            // Query for Attachment  
            List<Attachment> attachList = [select id,name,body,parentid,CreatedBy.Name from Attachment 
                                      where parent.id = :id];
            
            // Populating the attachment map with Question 4 and Question 5 if these exists
            List<Attachment> cdsHeaderAttList = new List<Attachment>();
            List<Attachment> signalPowerAttList = new List<Attachment>();
            List<Attachment> mitiTranAttList = new List<Attachment>();
            List<Attachment> noiseSpecsAttList = new List<Attachment>();
            List<Attachment> dramAttList = new List<Attachment>();
            List<Attachment> ddAttList = new List<Attachment>();
            List<Attachment> coreAttList = new List<Attachment>();
            List<Attachment> iInfAttList = new List<Attachment>();
            List<Attachment> pInfAttList = new List<Attachment>();
            List<Attachment> cardInfAttList = new List<Attachment>();
            List<Attachment> scanBitsAttList = new List<Attachment>();
            List<Attachment> desTestAttList = new List<Attachment>();
            List<Attachment> addToolsAttList = new List<Attachment>();
            List<Attachment> mfgTestAttList = new List<Attachment>();
            List<Attachment> archInfoAttList = new List<Attachment>();
            List<Attachment> desStrcAttList = new List<Attachment>();
            List<Attachment> netCustAttList = new List<Attachment>();
            List<Attachment> splPlaceAttList = new List<Attachment>();
            List<Attachment> splWireAttList = new List<Attachment>();
            List<Attachment> clockInfoAttList = new List<Attachment>();
            List<Attachment> clockCharAttList = new List<Attachment>();
            List<Attachment> pdfAttachments = new List<Attachment>();
            List<Attachment> avstAttachments = new List<Attachment>();
            
           
            for(Attachment att : attachList){
                att.Body=null;
                if(att.Name.startsWith(CDSAttachmentUploadForm.CDS_HEADER_BEGIN)){
                    cdsHeaderAttList.add(att);
                }  
                  if(att.Name.startsWith(CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN)){
                    signalPowerAttList.add(att);
                }  
                if(att.Name.startsWith(CDSAttachmentUploadForm.MITI_TRAN_BEGIN)){
                    mitiTranAttList.add(att);
                }  
                if(att.Name.startsWith(CDSAttachmentUploadForm.NOISE_SPECS_BEGIN)){
                    noiseSpecsAttList.add(att);
                }  
                
                if(att.Name.startsWith(CDSAttachmentUploadForm.DRAM_BEGIN)){
                    dramAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.DD_BEGIN)){
                    
                    ddAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.CORE_BEGIN)){
                    
                    coreAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.IMAGE_INF_BEGIN)){
                    iInfAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.PKG_INF_BEGIN)){
                    pInfAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.CARD_INF_BEGIN)){
                    cardInfAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.SCAN_BITS_BEGIN)){
                    scanBitsAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.DES_TEST_BEGIN)){
                    desTestAttList.add(att);
                }
                  if(att.Name.startsWith(CDSAttachmentUploadForm.ADD_TOOLS_BEGIN)){
                    addToolsAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.MFG_TEST_BEGIN)){
                    mfgTestAttList.add(att);
                }
                  if(att.Name.startsWith(CDSAttachmentUploadForm.ARC_INFO_BEGIN)){
                    archInfoAttList.add(att);
                }
                  if(att.Name.startsWith(CDSAttachmentUploadForm.DES_STRC_BEGIN)){
                    desStrcAttList.add(att);
                }
                  if(att.Name.startsWith(CDSAttachmentUploadForm.NET_CUST_BEGIN)){
                    netCustAttList.add(att);
                }
                  if(att.Name.startsWith(CDSAttachmentUploadForm.SPL_PLACE_BEGIN)){
                    splPlaceAttList.add(att);
                }
                  if(att.Name.startsWith(CDSAttachmentUploadForm.SPL_WIRE_BEGIN)){
                    splWireAttList.add(att);
                }
                 if(att.Name.startsWith(CDSAttachmentUploadForm.CLK_INFO_BEGIN)){
                    clockInfoAttList.add(att);
                }
                if(att.Name.startsWith(CDSAttachmentUploadForm.CLK_CHAR_BEGIN)){
                    clockCharAttList.add(att);
                }
                 if(att.Name.startsWith(CDSAttachmentUploadForm.CDS_PDF)){
                    pdfAttachments.add(att);
                }
                 if(att.Name.startsWith(CDSAttachmentUploadForm.AVST_BEGIN)){
                    avstAttachments.add(att);
                }
            }
             attachListMap.put(CDSAttachmentUploadForm.CDS_HEADER_BEGIN,cdsHeaderAttList);
             attachListMap.put(CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN,signalPowerAttList);
             attachListMap.put(CDSAttachmentUploadForm.MITI_TRAN_BEGIN,mitiTranAttList);
             attachListMap.put(CDSAttachmentUploadForm.NOISE_SPECS_BEGIN,noiseSpecsAttList);
             attachListMap.put(CDSAttachmentUploadForm.DRAM_BEGIN,dramAttList);
             attachListMap.put(CDSAttachmentUploadForm.DD_BEGIN,ddAttList);
             attachListMap.put(CDSAttachmentUploadForm.CORE_BEGIN,coreAttList);
             attachListMap.put(CDSAttachmentUploadForm.IMAGE_INF_BEGIN,iInfAttList);
             attachListMap.put(CDSAttachmentUploadForm.PKG_INF_BEGIN,pInfAttList);
             attachListMap.put(CDSAttachmentUploadForm.CARD_INF_BEGIN,cardInfAttList);
             attachListMap.put(CDSAttachmentUploadForm.SCAN_BITS_BEGIN,scanBitsAttList);
             attachListMap.put(CDSAttachmentUploadForm.DES_TEST_BEGIN,desTestAttList);
             attachListMap.put(CDSAttachmentUploadForm.ADD_TOOLS_BEGIN,addToolsAttList);
             attachListMap.put(CDSAttachmentUploadForm.MFG_TEST_BEGIN,mfgTestAttList);
            attachListMap.put(CDSAttachmentUploadForm.ARC_INFO_BEGIN,archInfoAttList);
            attachListMap.put(CDSAttachmentUploadForm.DES_STRC_BEGIN,desStrcAttList);
            attachListMap.put(CDSAttachmentUploadForm.NET_CUST_BEGIN,netCustAttList);
            attachListMap.put(CDSAttachmentUploadForm.SPL_PLACE_BEGIN,splPlaceAttList);
            attachListMap.put(CDSAttachmentUploadForm.SPL_WIRE_BEGIN,splWireAttList);
            attachListMap.put(CDSAttachmentUploadForm.CLK_INFO_BEGIN,clockInfoAttList);
            attachListMap.put(CDSAttachmentUploadForm.CLK_CHAR_BEGIN,clockCharAttList);            
            attachListMap.put(CDSAttachmentUploadForm.CDS_PDF,pdfAttachments);
            attachListMap.put(CDSAttachmentUploadForm.AVST_BEGIN,avstAttachments);
            /*
            // Checking for CDS Header attachment or creating new attachment object
            if(!attachListMap.containsKey(AttachmentUploadCDSForm.CDS_HEADER_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.CDS_HEADER_BEGIN,new List<Attachment>());
            }
            // Checking for Signal And Power attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.SIGNAL_POWER_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.SIGNAL_POWER_BEGIN,new List<Attachment>());
            }
              // Checking for Mitigation Transient attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.MITI_TRAN_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.MITI_TRAN_BEGIN,new List<Attachment>());
            }
              // Checking for Noise specifications attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.NOISE_SPECS_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.NOISE_SPECS_BEGIN ,new List<Attachment>());
            }
            // Checking for DRAM attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.DRAM_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.DRAM_BEGIN,new List<Attachment>());
            }
             // Checking for Development Deliverables attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.DD_BEGIN)){
                 system.debug('isnide IFFFFF');
                attachListMap.put(AttachmentUploadCDSForm.DD_BEGIN,new List<Attachment>());
            }
             // Checking for Core attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.CORE_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.CORE_BEGIN,new List<Attachment>());
            }
             // Checking for Development Deliverables attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.IMAGE_INF_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.IMAGE_INF_BEGIN,new List<Attachment>());
            }
             // Checking for Core attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.PKG_INF_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.PKG_INF_BEGIN,new List<Attachment>());
            }
            // Checking for Core attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.CARD_INF_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.CARD_INF_BEGIN,new List<Attachment>());
            }
                 // Checking for Scan Bits attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.SCAN_BITS_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.SCAN_BITS_BEGIN,new List<Attachment>());
            }
                 // Checking for Design For Test attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.DES_TEST_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.DES_TEST_BEGIN,new List<Attachment>());
            }
             // Checking for ASIC Design Kit attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.ADD_TOOLS_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.ADD_TOOLS_BEGIN,new List<Attachment>());
            }
                 // Checking for Manufacturing Test Considerations attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.MFG_TEST_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.MFG_TEST_BEGIN,new List<Attachment>());
            }
                 // Checking for Architectural Information attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.ARC_INFO_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.ARC_INFO_BEGIN,new List<Attachment>());
            }
             // Checking for Design Structure attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.DES_STRC_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.DES_STRC_BEGIN,new List<Attachment>());
            }
             // Checking for Netlist Customer Requirements Summary attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.NET_CUST_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.NET_CUST_BEGIN,new List<Attachment>());
            }
             // Checking for Special placements checklist attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.SPL_PLACE_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.SPL_PLACE_BEGIN,new List<Attachment>());
            }
             // Checking for Special wiring checklist attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.SPL_WIRE_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.SPL_WIRE_BEGIN,new List<Attachment>());
            }
             // Checking for Clock Info attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.CLK_INFO_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.CLK_INFO_BEGIN,new List<Attachment>());
            }
             // Checking for Clock Characteristics checklist attachment or creating new attachment object
             if(!attachListMap.containsKey(AttachmentUploadCDSForm.CLK_CHAR_BEGIN)){
                attachListMap.put(AttachmentUploadCDSForm.CLK_CHAR_BEGIN,new List<Attachment>());
            }
            */
            return attachListMap;
        }
        return null;
    }   
       /*
   *************************************    
   @ Name -  saveAttachList
   @ Description - Saving the attachments.
   @ Parameter - None
   @ Return Type - Boolean 
   @ Created By - Niharika Modi
   ****************************************
   */     
    public Boolean saveAttachList(){
        Boolean isError = false;
        system.debug('--isnide1-');
        List<Attachment> attachmentList = new List<Attachment>();
           system.debug('--isnide-');
              system.debug('--attachMap-'+attachMap.keySet());
        
        for(String att : attachMap.keySet()){
            Attachment att1 = attachMap.get(att);
            system.debug('--att-'+att);
            system.debug('--att1-'+att1);
            
            // Adding the parent and description for the newly added attachment 1
            if(att!=null && att == CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN)){
                att1.name = CDSAttachmentUploadForm.SIGNAL_POWER_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = CDSAttachmentUploadForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            }
               if(att!=null && att == CDSAttachmentUploadForm.MITI_TRAN_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.MITI_TRAN_BEGIN)){
                att1.name = CDSAttachmentUploadForm.MITI_TRAN_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            }  
               if(att!=null && att == CDSAttachmentUploadForm.NOISE_SPECS_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.NOISE_SPECS_BEGIN)){
                att1.name = CDSAttachmentUploadForm.NOISE_SPECS_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            }  
           if(att!=null && att == CDSAttachmentUploadForm.CDS_HEADER_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.CDS_HEADER_BEGIN)){
                att1.name = CDSAttachmentUploadForm.CDS_HEADER_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            }  
             if(att!=null && att == CDSAttachmentUploadForm.DRAM_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.DRAM_BEGIN)){
                att1.name = CDSAttachmentUploadForm.DRAM_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
            if(att!=null && att == CDSAttachmentUploadForm.DD_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.DD_BEGIN)){
                att1.name = CDSAttachmentUploadForm.DD_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
             if(att!=null && att == CDSAttachmentUploadForm.CORE_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.CORE_BEGIN)){
                att1.name = CDSAttachmentUploadForm.CORE_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                  
                }
                attachmentList.add(att1);
            } 
           if(att!=null && att == CDSAttachmentUploadForm.IMAGE_INF_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.IMAGE_INF_BEGIN)){
                att1.name = CDSAttachmentUploadForm.IMAGE_INF_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                  
                }
                attachmentList.add(att1);
            } 
            if(att!=null && att == CDSAttachmentUploadForm.PKG_INF_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.PKG_INF_BEGIN)){
                att1.name = CDSAttachmentUploadForm.PKG_INF_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                  
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.CARD_INF_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.CARD_INF_BEGIN)){
                att1.name = CDSAttachmentUploadForm.CARD_INF_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                  
                }
                attachmentList.add(att1);
            } 
             if(att!=null && att == CDSAttachmentUploadForm.SCAN_BITS_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.SCAN_BITS_BEGIN)){
                att1.name = CDSAttachmentUploadForm.SCAN_BITS_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
             if(att!=null && att == CDSAttachmentUploadForm.DES_TEST_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.DES_TEST_BEGIN)){
                att1.name = CDSAttachmentUploadForm.DES_TEST_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.ADD_TOOLS_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.ADD_TOOLS_BEGIN)){
                att1.name = CDSAttachmentUploadForm.ADD_TOOLS_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                }
                attachmentList.add(att1);
            } 
             if(att!=null && att == CDSAttachmentUploadForm.MFG_TEST_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.MFG_TEST_BEGIN)){
                att1.name = CDSAttachmentUploadForm.MFG_TEST_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.ARC_INFO_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.ARC_INFO_BEGIN)){
                att1.name = CDSAttachmentUploadForm.ARC_INFO_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.DES_STRC_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.DES_STRC_BEGIN)){
                att1.name = CDSAttachmentUploadForm.DES_STRC_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.NET_CUST_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.NET_CUST_BEGIN)){
                att1.name = CDSAttachmentUploadForm.NET_CUST_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.SPL_PLACE_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.SPL_PLACE_BEGIN)){
                att1.name = CDSAttachmentUploadForm.SPL_PLACE_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
              if(att!=null && att == CDSAttachmentUploadForm.SPL_WIRE_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.SPL_WIRE_BEGIN)){
                att1.name = CDSAttachmentUploadForm.SPL_WIRE_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
             if(att!=null && att == CDSAttachmentUploadForm.CLK_INFO_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.CLK_INFO_BEGIN)){
                att1.name = CDSAttachmentUploadForm.CLK_INFO_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
             if(att!=null && att == CDSAttachmentUploadForm.CLK_CHAR_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.CLK_CHAR_BEGIN)){
                att1.name = CDSAttachmentUploadForm.CLK_CHAR_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
            if(att!=null && att == CDSAttachmentUploadForm.AVST_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(CDSAttachmentUploadForm.AVST_BEGIN)){
                att1.name = CDSAttachmentUploadForm.AVST_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.OwnerId = UserInfo.getUserId();
                   // att1.description = AttachmentUploadCDSForm.QUES_4_DESC;
                }
                attachmentList.add(att1);
            } 
        }
        
        // Insert or Update of attachment
        if(attachmentList.size()>0){
               try{
                    upsert attachmentList;
               }catch(Exception excp){
                    ApexPages.addMessages(excp);
                   GlobalUtility.logMessage('Error','CDSAttachmentUploadForm','saveAttachList','','Exception while updating the Custom Design record',String.valueof(excp.getMessage()),'','Device Management in logs',excp,0);                    
                    isError = true; 
               }               
        }
        
        // Checks for the error thrown on attaching files having size more than 5 MB
        if(ApexPages.hasMessages(ApexPages.severity.ERROR)) {
                   
            isError = true;
        }
        
        return isError;
        
    }
 

}