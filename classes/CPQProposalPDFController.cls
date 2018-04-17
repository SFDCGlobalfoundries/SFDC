/**
 *  Class:      CPQProposalPDFController 
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Akash Aggarwal
 * Description: controller to fetch data for proposal pdf
 *
 * History:
 *              AA          10282015     - code creation.
 *  Surendranadh Nune       14092015     - Added Exception Handling, Added field in SOQL for PCM Project
    11. Ravi Teja Boggala 03 May 2017 - Line Numbers: 66, 70, 80, 81, 89, 91, 93, 95, 97, 99, 187, 188, 191, 244, 245 - Case#00068406
        Reason: Missing Devices as the Product Option field record value is getting deleted on technology update.
**/

public class CPQProposalPDFController { 
  public Apttus_Proposal__Proposal__c proposal{get;set;}     
  public list<Apttus_Proposal__Proposal_Line_Item__c> lstTechnologyOptionLineItem{get;set;}
  public list<Apttus_Proposal__Proposal_Line_Item__c> lstIPsLstLineItem{get;set;}
  public list<Apttus_Proposal__Proposal_Line_Item__c> lstDevicesLstLineItem{get;set;}
  public list<Apttus_Proposal__Proposal_Line_Item__c> lstAddlntQuesLstLineItem{get;set;}
  public list<Apttus_Proposal__Proposal_Line_Item__c> lstRFLstLineItem{get;set;}
  public list<IP_Declaration_Form__c> lstIpDeclaration{get;set;}
  public list<Configurator_Plus_IP_Merge_Kit__c> lstIpMergeKit{get;set;}
  public list<Configurator_Plus_Response__c> lstConfigResponse{get;set;}
  public Apttus_Proposal__Proposal_Line_Item__c productLine{get;set;}
  public List<Product2> LstFreeDevices { get; set; }
  public List<Configurator_Plus_Response__c> responselist1{get;set;}
  public string doSave{get;set;}
  public List<Configurator_Plus_Response__c> lstAdvancedPackagingResponses {get; set;}
  public list<Apttus_Proposal__Proposal_Line_Item__c> lstPacakgingLstLineItem{get;set;}
  public CPQ_DisplayProposalAttributesController objProposalAttributesController{get;set;}
  public integer assignedPIDMaskCount {get;set;}
  public string assignedPIDMask{get;set;}
  
  public CPQProposalPDFController() {
        try{
        doSave = ApexPages.currentPage().getParameters().get('doSave');
        lstWrapIp = new list<WrapIps>();
        productLine = new Apttus_Proposal__Proposal_Line_Item__c();
        proposal = [SELECT Id,Purpose_of_the_Configuration__c,Apttus_Proposal__Account__r.name,Apttus_Proposal__Proposal_Name__c,Name,
                     Process_Technology_Name__c,Owner.Name,Apttus_Proposal__Primary_Contact__r.Firstname,Apttus_Proposal__Primary_Contact__r.LastName,
                     Apttus_Proposal__Primary_Contact__r.Email,Device__r.Name,Application__c,Forecast_Tape_out_Date__c,VV_Large_Via_Size_option__c,
                     Fab_Name__c,Fab_Location__c,APTPS_Packaging_Option__c,Package_Type__c,Bump_for_FC__c,Package_Substrate_Type_for_FC__c,
                     Die_Thickness_in_package__c,Bumping_for_FC__c,Minimum_Bump_In_Line_pad_pitch__c,Wire_Diameter_for_WB__c,Package_Body_Size__c,
                     Package_Substrate_Thickness__c,Wire_Material_for_WB__c,Circuit_Under_Bond_Pad_for_WB_picklist__c,Pad_Opening_for_WB__c,
                     Pinout_Number_of_Pad_rows__c,Package_Substrate_layer_count_for_FC__c,Passivation_Nitride_Opening__c, Sorting_Location_for_FC__c,
                     Polymide_Opening__c,Crackstop_Seal_Ring_Die_Seal__c,Other_Package_Options__c,Packaging_Customisation_Details__c,
                     SRAM__c,SRAM_Gate_Orientation__c,Gate_Orientation_Horizontal_Vertical__c,Gate_Orientation_PFET__c,ACLV_Gate_Orientation__c,PTRF_Rotation__c,
                     Free_Device_Names__c,Mask_Set__c,Mask_Set_Long__c,Mask_Count__c,Mask_layers_1__c,IPs__c,Devices_1__c,Metal_Stacks_1__c,IS_Manually_Configured__c,PDK_Version__c,
                     Is_there_gap_req_in_Layer_Map_Table__c,Any_other_Special_Requirements__c,DMOS_Type__c
                     ,Additional_Scribeline_Dropin_Req__c,Other_Special_Requirements__c,Drop_in_Required__c ,Free_Devices__c,SRAM_Sizes__c,
                     Device__r.Dies_X_per_illumination_field__c,Device__r.Dies_Y_per_illumination_field__c,Device__r.Min_scribe_width_X_post_shrink__c,Device__r.Min_scribe_width_Y_post_shrink__c,
                     Device__r.Std_scribe_width_X_post_shrink__c,Device__r.Std_scribe_width_Y_post_shrink__c,APTPS_Metal_Options__c, Apttus_Proposal__Proposal__c.Special_test_structure_placement__c,
                     Apttus_Proposal__Proposal__c.BEOL_stack_Not_offered_by_DM__c, Apttus_Proposal__Proposal__c.SRAM_cell_Not_offered_by_DM__c, 
                     Apttus_Proposal__Proposal__c.Speed_push_Not_offered_by_DM__c, Apttus_Proposal__Proposal__c.Request_for_special_chip_arrangement__c, 
                     Apttus_Proposal__Proposal__c.Metal_Wall_Seal_Ring_NotPartOfCustProd__c, Apttus_Proposal__Proposal__c.Dicing_dependency__c, Apttus_Proposal__Proposal__c.Special_illumination_field_usage__c,
                     Assigned_Process_ID__r.Mask_Layers__c, Assigned_Process_ID__c,Packaging_Disclaimer_Message__c
                     FROM Apttus_Proposal__Proposal__c
                     WHERE Id =:ApexPages.currentpage().getParameters().get('id')];  
            
            //Added by Ravi Teja 08012017 Case#00084788
            if(proposal.Assigned_Process_ID__r.Mask_Layers__c != null){
                assignedPIDMaskCount = proposal.Assigned_Process_ID__r.Mask_Layers__c.split(',').size();
                assignedPIDMask = proposal.Assigned_Process_ID__r.Mask_Layers__c.replaceAll(',',' ');
            }
            else{
                assignedPIDMaskCount = 0;
                assignedPIDMask = '';
            }
        
        //Kanisk: Technology Attributes
          setTechnologyAttributes();
          
        lstTechnologyOptionLineItem = [Select Id,APTPS_Core_Voltage__c,APTPS_IO_Voltage__c,Die_Size_is_Pre_Shrink_Post_Rotation__c,APTPS_Notch_Location__c,
                                        APTPS_DNWELL_Needed__c,Die_Size_X_mm__c,Die_Size_Y_mm__c,Die_Size_mm2__c,APTPS_Poly_Orientation_Compliance__c,
                                        APTPS_Metal_Options__c,APTPS_Need_RF__c,APTPS_Need_Turnkey__c,APTPS_Need_IP_Merge__c,APTPS_Secure_Application__c,
                                        APTPS_Automotive_Application__c,Apttus_Proposal__Description__c,Apttus_QPConfig__ConfigurationId__r.Name
                                        FROM Apttus_Proposal__Proposal_Line_Item__c 
                                        WHERE Apttus_Proposal__Proposal__c = :proposal.Id AND Apttus_QPConfig__LineType__c = 'Product/Service' limit 1];
         
         if(!lstTechnologyOptionLineItem.isEmpty()) {
           productLine = lstTechnologyOptionLineItem[0]; 
         }
         
         lstIPsLstLineItem = [Select Id,Option_Name__c,Option_Name_Static__c,APTPS_IP_Lifecycle__c,IP_Design_Kit__c, LIB_ID__c,Option_IP_DesignKit_Version_Static__c,APTPS_IP_Type__c,IP_Vendors__c,IP_Device_List__c,Option_IP_Device_List_Static__c,
                              Apttus_QPConfig__OptionId__r.ProductCode,Option_Product_ExternalId_Static__c
                              FROM Apttus_Proposal__Proposal_Line_Item__c 
                              WHERE Option_Product_Family_Static__c = 'IPs' AND Apttus_Proposal__Proposal__c = :proposal.Id ];
         set<string> stIPNames = new set<string>(); 
         for(Apttus_Proposal__Proposal_Line_Item__c  it : lstIPsLstLineItem ) {
           lstWrapIp.add(new WrapIps(it));
           stIPNames.add(it.Option_Product_ExternalId_Static__c);
         }                     
         Map<String,string> IPDesignKitMap = new Map<String,string>();
         for(IP__c ipdes : [SELECT id, name,IPNumber__c,IPNumber__r.name,Latest_Design_Kit__c,IP_ID__c,Device_List__c,Description__c FROM   IP__c WHERE  IPNumber__r.name IN :stIPNames AND    Latest_Design_Kit__c  = TRUE]){ 
                                   
           if(!IPDesignKitMap.containsKey(ipdes.IPNumber__r.name)){
              IPDesignKitMap.put(ipdes.IPNumber__r.name,ipdes.name);  
           }                                    
         }
         for(WrapIps wr : lstWrapIp) {
           if(IPDesignKitMap.containsKey(wr.item.Option_Product_ExternalId_Static__c)) {
             wr.ipid = IPDesignKitMap.get(wr.item.Option_Product_ExternalId_Static__c);
           }
         }
                              
         lstIpDeclaration = [SELECT Name,IP_Declaration_Template__c,IP_Technology__c,Fab__c,Form_Submitted_Date__c,LastModifiedBy__c 
                             FROM IP_Declaration_Form__c WHERE Configuration__c = :proposal.Id];
                             
         //Ravindra Added column Apttus_QPConfig__OptionId__r.Description as VF page is trying to display it.
          lstDevicesLstLineItem = [Select Id,Option_Section_Name_Static__c, Option_Name__c,Option_Name_Static__c,Mask_Sets__c,Option_Mask_Sets_Static__c,Apttus_QPConfig__OptionId__r.Description,Option_Model_Name_Static__c
                                   FROM Apttus_Proposal__Proposal_Line_Item__c 
                                   WHERE Option_Product_Family_Static__c = 'Devices' AND Apttus_Proposal__Proposal__c = :proposal.Id order by Option_Section_Name_Static__c, Option_Name_Static__c];
        
        //Kanishk:show packaing line item.
          lstPacakgingLstLineItem = [Select Id,Option_Name__c,Option_Section_Name_Static__c,Option_Name_Static__c,Mask_Sets__c,Option_Mask_Sets_Static__c,Apttus_QPConfig__OptionId__r.Description,Option_Model_Name_Static__c
                                   FROM Apttus_Proposal__Proposal_Line_Item__c 
                                   WHERE (Option_Product_Family_Static__c = 'Packaging' OR  Option_Product_Family_Static__c = 'packaging') AND Apttus_Proposal__Proposal__c = :proposal.Id order by Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ProductOptionGroupId__r.Apttus_Config2__Left__c ASC];  
        
        
         lstAddlntQuesLstLineItem = [Select Id,Option_Name__c,Option_Name_Static__c
                                     FROM Apttus_Proposal__Proposal_Line_Item__c 
                                     WHERE Option_Product_Family_Static__c = 'Additional Questions' AND Apttus_Proposal__Proposal__c = :proposal.Id ];
         
         lstRFLstLineItem = [Select Id,Option_Name__c,Option_Name_Static__c
                                     FROM Apttus_Proposal__Proposal_Line_Item__c 
                                     WHERE Option_Product_Family_Static__c = 'RF' AND Apttus_Proposal__Proposal__c = :proposal.Id ];
      
         lstAdvancedPackagingResponses = [Select Id, Configurator_Plus_Question__r.Question_Name__c, Response__c FROM Configurator_Plus_Response__c where Configurator_Plus__c =:proposal.Id AND Configurator_Plus_Question__r.Level__c <> null AND Configurator_Plus_Question__r.Unique_Identifier__c <> null AND Response__c != ''];
         
         lstIpMergeKit = [SELECT Id,IP_Merge__r.Name,Comment__c from Configurator_Plus_IP_Merge_Kit__c WHERE Configurator_Plus__c = :proposal.Id];
         
         lstConfigResponse = [ SELECT    ID
                                                  , Configurator_Plus_Question__c
                                                  , Configurator_Plus_Question__r.Question_Name__c,Configurator_Plus_Question__r.Metal_Options__c,Configurator_Plus_Question__r.Expected_Release_date__c 
                                                  , Configurator_Plus__c
                                                  , Name__c
                                                  , Proposal_Line_Item__c
                                                  , Question_ID__c
                                                  , Response__c
                                                  , Response_Type__c
                                       FROM       Configurator_Plus_Response__c
                                       WHERE      Response__c = 'TRUE'
                                       AND        Configurator_Plus__c = :proposal.Id
                                       AND        Response_Type__c = 'Roadmap Features'] ;
                                      // [SELECT Id,Configurator_Plus_Question__r.Question_Name__c,Configurator_Plus_Question__r.Metal_Options__c,Configurator_Plus_Question__r.Expected_Release_date__c FROM Configurator_Plus_Response__c WHERE (Configurator_Plus_Question__r.Question_Type__c LIKE 'Roadmap%') AND Configurator_Plus__c = :proposal.Id  ];
         
         responselist1 = [Select Id, Response__c,Additional_Response__c, 
                                 Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, 
                                 Response_Type__c,Configurator_Plus_Question__r.Sequence__c from Configurator_Plus_Response__c 
                                 where Configurator_Plus__c =: proposal.Id and Response_Type__c='Additional Requirement' 
                                 Order by Configurator_Plus_Question__r.Sequence__c];
             
              String szDelimiter = '<:>';
          
         //Query strings generated from field sets
            String szFreeDevicesQuery = 'Select ';
            
            for(Schema.FieldSetMember f : SObjectType.Product2.FieldSets.Free_Devices_Columns.getFields()) {
                szFreeDevicesQuery += f.getFieldPath() + ', ';
            }
            
            //Generate the Device Id tokens from Free Devices field of the current proposal
            String szDeviceIdTokens = '(';
            
            if(proposal.Free_Devices__c != null){
                for(String szDeviceId : proposal.Free_Devices__c.split(szDelimiter)){
                    szDeviceIdTokens += '\'' + szDeviceId + '\',';                                 
                }
            }
            
            szDeviceIdTokens = (szDeviceIdTokens != '(' ? szDeviceIdTokens.substring(0, szDeviceIdTokens.length() - 1) + ')' : '');
            
            szFreeDevicesQuery += 'Id FROM Product2 Where ProductCode IN ' + (szDeviceIdTokens != '' ? szDeviceIdTokens : '(\'\')');            
            
            LstFreeDevices = Database.query(szFreeDevicesQuery); 
            LstSRAMDevicesView = new List<SRAMWrapper>();
            fetchSRAM();
        }catch(Exception e){
             GlobalUtility.logMessage('Error', 'CPQProposalPDFController', 'Constructor', null, null, e.getMessage(), null,null,e, null);
        }
  }

  private void setTechnologyAttributes(){
    try{
     objProposalAttributesController=new CPQ_DisplayProposalAttributesController(proposal);
    }catch(Exception ex){
       GlobalUtility.logMessage('Error', 'CPQProposalPDFController', 'setTechnologyAttributes', null, null, ex.getMessage(), null,null,ex, null);
    }
  }
  // save the proposal pdf on load
  public void savePDF(){ 
    try{
        if(doSave == 'No'){ 
          return; 
        } 
        PageReference pagePdf = new PageReference('/apex/CPQ_Proposal_pdf?id='+proposal.Id+'&doSave=No'); 
        Blob pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
        
        Attachment a = new Attachment(); 
        a.Body = pdfPageBlob; 
        a.ParentID = proposal.Id; 
        a.Name = 'Proposal - ' + proposal.Name + ' - ' + proposal.Apttus_Proposal__Proposal_Name__c + '.pdf'; 
        a.Description = 'Proposal'; 
        insert a; 
    }catch(Exception e){
        GlobalUtility.logMessage('Error', 'CPQProposalPDFController', 'savePDF', null, null, e.getMessage(), null,null,e, null);
    }
    
  }
  
   public class SRAMWrapper {
      public String prodName{get;set;}
      public String size{get;set;}
      public SRAMWrapper(String prodct) {
        prodName = prodct;
      }
      public SRAMWrapper(String prodct,String psize) {      
        prodName = prodct;
        size = psize;
      }
    }
    public List<SRAMWrapper> LstSRAMDevicesView { get; set; }
    public void fetchSRAM() {
      String szDelimiter = '<:>';    
       List<Apttus_Proposal__Proposal_Line_Item__c> lstSram = [Select Id,Apttus_QPConfig__OptionId__c,Apttus_QPConfig__OptionId__r.Sram_Type__c,Option_Sram_Type_Static__c
                                                                FROM Apttus_Proposal__Proposal_Line_Item__c Where Apttus_Proposal__Proposal__c =:proposal.Id AND  Option_Sram_Type_Static__c != NULL];
        map<String,String> mpsramtype = new map<String,String>();
          for(Apttus_Proposal__Proposal_Line_Item__c item : lstSram ) {
            mpsramtype.put(item.Option_Sram_Type_Static__c.tolowercase(),item.Option_Sram_Type_Static__c);
          }
        
        set<string> existingProd = new set<string>();                    
        if(proposal.SRAM_Sizes__c != NULL) {
          for(String prodSize : proposal.SRAM_Sizes__c.Split('<:>')) {
            list<String> lstString =  prodSize.split('>:<');
            LstSRAMDevicesView.add(new SRAMWrapper(lstString[0],lstString.size() > 1 ? lstString [1] : NULL));
            existingProd.add(lstString[0].tolowercase());
          }
        }                    
        //Query strings generated from field sets
        String szFreeDevicesQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Product2.FieldSets.Free_Devices_Columns.getFields()) {
            szFreeDevicesQuery += f.getFieldPath() + ', ';
        }
        
        //Generate the Device Id tokens from Free Devices field of the current proposal
        String szDeviceIdTokens = '(';
        
        if(proposal.Free_Devices__c != null){
            for(String szDeviceId : proposal.Free_Devices__c.split(szDelimiter)){ 
                szDeviceIdTokens += '\'' + szDeviceId + '\',';                                 
            }
        }
        
        szDeviceIdTokens = (szDeviceIdTokens != '(' ? szDeviceIdTokens.substring(0, szDeviceIdTokens.length() - 1) + ')' : '');
        
        szFreeDevicesQuery += 'Id,Sram_Type__c FROM Product2 Where Sram_Type__c != NULL AND ProductCode IN ' + (szDeviceIdTokens != '' ? szDeviceIdTokens : '(\'\')');
        LstFreeDevices = Database.query(szFreeDevicesQuery);
        
        map<String,String> mpProduct = new map<String,String>();
        for(Product2 prod : LstFreeDevices) {
            mpsramtype.put(prod.Sram_Type__c.toLowerCase(),prod.Sram_Type__c);
        }
        for(String prodName : mpsramtype.keySet()) {
         
          if(existingProd.contains(prodName)) {
            continue;
          }
          LstSRAMDevicesView.add(new SRAMWrapper(mpsramtype.get(prodName)));
        }
    }
    
    public list<WrapIps> lstWrapIp{get;set;}
    public class WrapIps{
      public Apttus_Proposal__Proposal_Line_Item__c  item{get;set;}
      public string ipid{get;set;}
      public string device{get;set;}
      public WrapIps(Apttus_Proposal__Proposal_Line_Item__c ip) {
        item = ip;
        device = '';
        if(ip.Option_IP_Device_List_Static__c != NULL && ip.Option_IP_Device_List_Static__c != '') {
          for(String st : ip.Option_IP_Device_List_Static__c.split(',')) {
              device += '\n' +  st + ',' ;
          }
          if(device != NULL &&  device != '') {
            device = device.substring(0,device.length()-1);
          }
        }
      }
    }
  
}