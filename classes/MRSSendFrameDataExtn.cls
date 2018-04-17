/*
Type Name:    MRSSendFrameDataExtn 
Author:       Cognizant 
Created Date: 16-April-2014
Reason: This is the controller class for Send Frame Data page. 
Change History:
Cognizant            16042014     -      Apex code created
Cognizant            19042014     -      Constructors and variables are declared.
Cognizant            22052014     -      Added the methods getMaskSetTitle
Cognizant            27052014     -      Added the methods filterOnMST
Cognizant            29052014     -      Added the methods populateDropdown
Cognizant            05052014     -      Added the methods clear
Cognizant            06052014     -      Added the methods exportToExcel
Cognizant            10052014     -      Added the methods exportToCSV
Cognizant            16052014     -      Bug fixing done for defects
Cognizant            09062014     -      Incorporated the Code Review Comments
*/

public with sharing class MRSSendFrameDataExtn {
     /** Public Variables Declaration **/
    public list<SelectOption> lstmst {get;set;}
    public String selectedmst {get;set;}
    public list<SelectOption> lstMaskLayer {get;set;}
    public String selectedMaskLayer {get;set;}
    public list<SelectOption> lstLayerStatus {get ;set;}
    public String selectedLayerStatus {get ;set;}
    public list<SelectOption> lstDeviceId {get;set;}
    public String selectedDeviceId {get ;set;}
    public list<SelectOption> lstPTRFDRTNumber{get ;set;}
    public String selectedPTRFDRTNumber {get;set;}
    public String selectedSendData{get;set;}
    public list<string> lstSelectedSendDataStatus;
    public Set<String> stDeviceId = new Set<String>();
    public Set<String> stChipName= new Set<String>();
    public Set<String> stPTRFDRTNumber= new Set<String>();
    public Set<String> stMaskLayer = new Set<String>();
    public Set<String> stLayerStatus= new Set<String>();
    public List<MRS_Layer_Chip_Association__c> mrslstLayerChip{get;set;}
    public Map<Id,String> IDMstNameMap{get;set;} 
    public List<SendDataTableWrapper> lstSendDataPrimeWrapper {get;set;}
    public Boolean reticleType {get ; set;}
    public Boolean isBreadcrumbActive {get;set;}
    Public String ValueCatcher {get;set;} 
    public Pagination setCon{get;set;}
    public Integer countOfTotalRecord{get;set;}
    public Integer endOfDisplay {get;set;}
    public Integer counterPagination{get;set;}
    public Integer numberOfRecordsPerPage {get;set;}
    public List<SelectOption> noOfRecordsPerPage {get;set;}
    public Integer selectedCounter{get;set;}       
    
    public Integer totalPages {get;set;}  
    Public Integer size{get;set;}
    public String nextPreviousPage {get;set;}
    public string  currentUrl {get;set;}
    public boolean isLargeRecord {get;set;}
    public string mstname{get;set;}
    public String strExport{get;set;}
    public list<SelectOption> lstChipName{get ;set;}
    public String selectedChipName {get;set;}
    public boolean noRecords{get;set;}
    public transient Map<Integer,List<SendDataTableWrapper>> mapMLCA{get;set;}    
    public string lookupMSTURL {get;set;}
    
    public MRSSendFrameDataExtn (ApexPages.StandardController controller) {
        
        lstMaskLayer=new List<SelectOption>();
        lstLayerStatus =new List<SelectOption>();
        lstDeviceId =new List<SelectOption>();
        lstPTRFDRTNumber=new List<SelectOption>();
        mrslstLayerChip=new  List<MRS_Layer_Chip_Association__c>();
        lstSendDataPrimeWrapper = new List<SendDataTableWrapper>();
        selectedSendData = 'Not Ready,Ready';
        IDMstNameMap  = new Map<Id,String>();
         mapMLCA=new Map<Integer,list<SendDataTableWrapper>>();
        lstSelectedSendDataStatus = new list<string>();
        
        String url = ApexPages.currentPage().getHeaders().get('Host');
        if(url.trim().contains(Label.Swift_Host_URL.trim())){
            isBreadcrumbActive = true;
            currentUrl = Label.SWIFT_Community_URL;
        }
        else {
            isBreadcrumbActive = false;
            currentUrl = Label.Internal_URL;
        }
        lookupMSTURL = currentUrl + 'VFMaskSetTitleLookupDialog?pg=SendData';
        selectedmst = 'All';
        if(string.valueof(ApexPages.currentPage().getParameters().get('selectedmst'))!='null'){
            selectedmst=ApexPages.currentPage().getParameters().get('selectedmst');
        }
        if(string.valueof(ApexPages.currentPage().getParameters().get('strExport'))!='null'){
            strExport=ApexPages.currentPage().getParameters().get('strExport');
        }
        if(string.valueof(ApexPages.currentPage().getParameters().get('selectedSendData'))!='null' && strExport!='PageLoad'){
            selectedSendData=ApexPages.currentPage().getParameters().get('selectedSendData');
        }
         if(string.valueof(ApexPages.currentPage().getParameters().get('selectedLayerStatus'))!='null'){
            ValueCatcher=ApexPages.currentPage().getParameters().get('selectedLayerStatus');
        }
        if(string.valueof(ApexPages.currentPage().getParameters().get('selectedMaskLayer'))!='null'){
            selectedMaskLayer=ApexPages.currentPage().getParameters().get('selectedMaskLayer');
        }
        if(string.valueof(ApexPages.currentPage().getParameters().get('selectedDeviceId'))!='null'){
            selectedDeviceId=ApexPages.currentPage().getParameters().get('selectedDeviceId');
        }
        if(string.valueof(ApexPages.currentPage().getParameters().get('selectedPTRFDRTNumber'))!='null'){
            selectedPTRFDRTNumber=ApexPages.currentPage().getParameters().get('selectedPTRFDRTNumber');
        }
    //    if(string.valueof(ApexPages.currentPage().getParameters().get('selectedChipName'))!='null'){
    //        selectedChipName=ApexPages.currentPage().getParameters().get('selectedChipName');
    //    }
        
      
       if(strExport=='Export' || strExport=='PageLoad')
       {
           populateExcel();
            
        }
        else
        {
        populateFilter();
        noOfRecordsPerPage = new List<SelectOption>();
        
        numberOfRecordsPerPage = Integer.valueOf(Label.MRSDefaultNoOfRecords);
        List<String> lstNoOfRecords = Label.MRSNoOfRecordsPerPage.split(';');
        for(String num : lstNoOfRecords){
            noOfRecordsPerPage.add(new SelectOption(num,num));
        }
        initPagination();
        populateDropdown();  
        strExport='PageLoad';
        }
    }
     /**
        This method fetches the List of MST names to be displayed on the MST combobox. 
        @method name: getMaskSetTitle
        @parameter:   None.
        @return :     List of MST names to be displayed.
     **/ 
    public void getMaskSetTitle()
    {
        lstmst = new List<SelectOption>();
        lstmst.add(new SelectOption('All','All'));
        for(Mask_Set_Title__c a:[select Id,name from Mask_Set_Title__c where Id in (select Mask_Set_Title__c from MRS__c) order by name])
        {
          lstmst.add(new SelectOption(a.Id,a.name));
        }
       // lstmst.sort();
    }
    /**
        This method populates the Send Frame Data Table in the Send Frame Data visualforce pages on MST change. 
        @method name: filterOnMST
        @parameter:   None.
        @return :     None.
     **/ 
    public void filterOnMST(){
      /*  if(stMaskLayer!=null){
        stMaskLayer.clear();
        }
        if(stLayerStatus!=null){
        stLayerStatus.clear();
        }
        if(stChipName!=null){
        stChipName.clear();
        }
        if(stDeviceId!=null){
        stDeviceId.clear();
        }
        if(stPTRFDRTNumber!=null){
        stPTRFDRTNumber.clear();
        }*/
       
        setCon = null;
        initPagination(); 
         populateDropdown();    
         setCon.setPageNumber(1);   
    }
        public void populateFilter(){
    lstLayerStatus =new List<SelectOption>();
    List<AggregateResult> aggLayerStatus = new List<AggregateResult>();
     if(lstLayerStatus!=null){
         lstLayerStatus.clear(); 
    }
      if(selectedSendData!=null){ 
          List<String> lstSelectedSendData = selectedSendData.split(',');
          if(lstSelectedSendData  != null && !lstSelectedSendData.isEmpty() && lstSelectedSendData.size() > 1) {
              if(selectedmst!='All'  && selectedmst!=null && selectedmst != ''){
              aggLayerStatus =[SELECT  Layer__r.Layer_Status__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True  And Send_Frame_Data__c IN :lstSelectedSendData AND layer__r.MRS__r.Mask_Set_Title__c =:selectedmst AND Layer__r.Layer_Status__c<>null AND Layer__r.Layer_Status__c<>'' group by Layer__r.Layer_Status__c];
              }
              else{
              aggLayerStatus =[SELECT  Layer__r.Layer_Status__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True And Send_Frame_Data__c IN :lstSelectedSendData AND Layer__r.Layer_Status__c<>null AND Layer__r.Layer_Status__c<>'' group by Layer__r.Layer_Status__c];
              }
              
          }
          else {
              if(selectedmst!='All'  && selectedmst!=null && selectedmst != '')
              {
              aggLayerStatus =[SELECT  Layer__r.Layer_Status__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True  And Send_Frame_Data__c =:selectedSendData AND layer__r.MRS__r.Mask_Set_Title__c =:selectedmst AND Layer__r.Layer_Status__c<>null AND Layer__r.Layer_Status__c<>'' group by Layer__r.Layer_Status__c];
              }
              else
              {
              aggLayerStatus =[SELECT  Layer__r.Layer_Status__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True And Send_Frame_Data__c =:selectedSendData AND Layer__r.Layer_Status__c<>null AND Layer__r.Layer_Status__c<>'' group by Layer__r.Layer_Status__c];
              }
          }
      }
       else
      {
          if(selectedmst!='All'  && selectedmst!=null && selectedmst != '')
          {
          aggLayerStatus =[SELECT  Layer__r.Layer_Status__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True And Send_Frame_Data__c in ('Not Done') AND layer__r.MRS__r.Mask_Set_Title__c =:selectedmst AND Layer__r.Layer_Status__c<>null AND Layer__r.Layer_Status__c<>'' group by Layer__r.Layer_Status__c];
          
          }
          else
          {
          aggLayerStatus =[SELECT  Layer__r.Layer_Status__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True And Send_Frame_Data__c in ('Not Done') AND Layer__r.Layer_Status__c<>null AND Layer__r.Layer_Status__c<>'' group by Layer__r.Layer_Status__c];
          }
      }
    for (AggregateResult ar : aggLayerStatus)  {
    lstLayerStatus.add(new SelectOption(string.valueof(ar.get('Layer_Status__c')),string.valueof(ar.get('Layer_Status__c'))));
    }
    lstLayerStatus.sort();  
    
    system.debug('layerstatus:' + lstLayerStatus);
    }

    public void showSearch()
    {
         setCon = null;
        initPagination(); 
         populateDropdown();    
         setCon.setPageNumber(1); 
    }
    
    public class SendDataTableWrapper {  
    public Integer SlNo{get;set;}
        public Boolean isEven{get; set;}
        public String userTimeStamp{get; set;}
        public MRS_Layer_Chip_Association__c objMRSLCA{get; set;}
        public String MaskLayerRomCode{get;set;}
        public SendDataTableWrapper(Integer SlNo,MRS_Layer_Chip_Association__c objMRSLCA, Boolean isEven, String userTimeStamp, String MaskLayerRomCode) {
            this.SlNo=SlNo;
            this.objMRSLCA = objMRSLCA;
            this.isEven = isEven;
            this.userTimeStamp = userTimeStamp;
            this.MaskLayerRomCode=MaskLayerRomCode;
        }
    }
    /**
        This method populates the Send Frame Data Table in the Send Frame Data visualforce pages on applying filter. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public pagereference populateDropdown()
    {
  //  if(lstLayerStatus!=null){
  //       lstLayerStatus.clear(); 
  //  }
  /*  if(lstDeviceId!=null){
         lstDeviceId.clear(); 
    }
    if(lstPTRFDRTNumber!=null){
         lstPTRFDRTNumber.clear();
        
    }
    
    if(lstMaskLayer!=null){
        lstMaskLayer.clear(); 
    }*/
    
    if(lstSendDataPrimeWrapper!=null){
        lstSendDataPrimeWrapper.clear(); 
        
    }
    if(mrslstLayerChip!=null && mrslstLayerChip.size()>0){
        mrslstLayerChip.clear();
    }
    lstMaskLayer=new List<SelectOption>();
    lstDeviceId =new List<SelectOption>();
    lstPTRFDRTNumber=new List<SelectOption>();
    stMaskLayer=new Set<String>();
    stDeviceId =new Set<String>();
    stPTRFDRTNumber=new Set<String>();

    IDMstNameMap.clear();
    lstMaskLayer.add(new SelectOption('',''));
    lstDeviceId.add(new SelectOption('',''));
    lstPTRFDRTNumber.add(new SelectOption('',''));
    reticleType=false;
    isLargeRecord=false;
    strExport='Export';
    
        for(MRS_Layer_Chip_Association__c a : (List<MRS_Layer_Chip_Association__c>)setCon.getRecords())
            //mrslstLayerChip.add(a.clone(true));
            mrslstLayerChip.add(a);
        
     if(mrslstLayerChip.size()>0)
        {
            noRecords=false;
        }
        else
        {
            noRecords=true;
        }
     // endOfDisplay= mrslstLayerChip.size();
      
      for(MRS_Layer_Chip_Association__c mrsObj:mrslstLayerChip){

         stMaskLayer.add(mrsObj.Layer__r.Name);
       //  if(mrsObj.Layer__r.Layer_Status__c != null) {
        //    stLayerStatus.add(mrsObj.Layer__r.Layer_Status__c);
        //  }
         if(mrsObj.PTRF__r.Device_Id__c != null)   {
            stDeviceId.add(mrsObj.PTRF__r.Device_Id__c); 
         }
         stChipName.add(mrsObj.Chip__r.Name);
         stPTRFDRTNumber.add(mrsObj.PTRF_Number__c); 
         IDMstNameMap.put(mrsObj.layer__r.MRS__r.Mask_Set_Title__c,mrsObj.layer__r.Mask_Set_Title_Name__c);
          
        if(mrsObj.PTRF__r.Recticle_Type__c =='Multi Node Reticle (MNR)')
        {
             reticleType=true;
        }  
                                                     
      }
         for(String layer : stMaskLayer){
             lstMaskLayer.add(new SelectOption(layer,layer));
         }
       //  for(String layerst : stLayerStatus){
       //      lstLayerStatus.add(new SelectOption(layerst,layerst));
       //  }
         for(String Device : stDeviceId){
             lstDeviceId.add(new SelectOption(Device,Device));
         }
         
         for(String PTRFDRTNumber : stPTRFDRTNumber){
             lstPTRFDRTNumber.add(new SelectOption(PTRFDRTNumber,PTRFDRTNumber));
         }
        lstMaskLayer.sort();
        lstDeviceId.sort();
        lstPTRFDRTNumber.sort();
        
        if(mrslstLayerChip != null && !mrslstLayerChip.isEmpty()) {
        Boolean isEven;
        String MaskLayerRomCode;
        for(Integer i=0; i < mrslstLayerChip.size(); i++) {
            isEven = false;
            if(Math.mod(i,2)==0) {
                isEven = true;
            }
            MaskLayerRomCode=mrslstLayerChip.get(i).Layer__r.Name;
            if(mrslstLayerChip.get(i).Rev__c!=null)
            {
                MaskLayerRomCode=MaskLayerRomCode +  mrslstLayerChip.get(i).Rev__c;
            }
            if(mrslstLayerChip.get(i).Rom_Code__c!=null && mrslstLayerChip.get(i).Rom_Code__c!='')
            {
               MaskLayerRomCode=MaskLayerRomCode + '(' + mrslstLayerChip.get(i).Rom_Code__c + ')';
            }
            
            if(mrslstLayerChip.get(i).Tech_Geo__c != NULL && mrslstLayerChip.get(i).Tech_Geo__c != 'NULL' && !mrslstLayerChip.get(i).Tech_Geo__c.contains('nm')){
            Double TechGeoValue = double.valueOf(mrslstLayerChip.get(i).Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                if(TechGeoValue != NULL && TechGeoValue <0.1){
                    mrslstLayerChip.get(i).Tech_Geo__c = mrslstLayerChip.get(i).Tech_Geo__c + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)';
                }
                
           }
            lstSendDataPrimeWrapper.add(new SendDataTableWrapper(((setCon.getPageNumber()-1)*size)+i+1,mrslstLayerChip.get(i),isEven,(mrslstLayerChip.get(i).Send_Frame_Data_Date__c==null?'':mrslstLayerChip.get(i).Send_Frame_Data_Date__c.format()),MaskLayerRomCode));           
          }
          }
         // countOfTotalRecord=rowCount();

        return null;
    }
    public void clear()
    {
        selectedMaskLayer= '';
        selectedLayerStatus= '';
        selectedDeviceId= '';
        selectedPTRFDRTNumber= '';
         ValueCatcher ='';
        setCon = null;
        initPagination(); 
        populateDropdown();    
        setCon.setPageNumber(1); 
    } 
     /**
        This method exports the data present in the Send Frame Data tables to Excel format. 
        @method name: exportToExcel
        @parameter:   None.
        @return :     The Send Frame Data screen.
    **/ 
   public void exportToExcel()
   {
       countOfTotalRecord=rowCount();
      
       if(countOfTotalRecord>15000)
       {
            isLargeRecord=true;
       }
       else
       {
        isLargeRecord=false;
       } 
   }
    list<SendDataTableWrapper> lstMLCA=new List<SendDataTableWrapper>();
    public void populateExcel()
    {  
    system.debug('selectedSendData:' + selectedSendData);
    system.debug('ValueCatcher:' + ValueCatcher);
    
       countOfTotalRecord=rowCount();  
       reticleType=false;
       String  lstmrsLayerChipAsso = 'Select PTRF_Number__c,Tech_Geo__c, Layer__r.Name,Send_Frame_Data__c,Send_Frame_Data_Date__c,Chip__r.Name,layer__r.Mask_Set_Title_Name__c,Rev__c,ROM_Code__c,PTRF__r.Recticle_Type__c FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True ';  
       if(selectedSendData!=null){
         
              List<String> lstSelectedSendData = selectedSendData.split(',');
              if(lstSelectedSendData  != null && !lstSelectedSendData.isEmpty() && lstSelectedSendData.size() > 0) {
                  lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Send_Frame_Data__c IN :lstSelectedSendData ';
              }
              else  {
                  lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Send_Frame_Data__c = \'\' ';
              }
       
      }
      else
      {
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Send_Frame_Data__c in (\'Not Done\')';
      }
      if(selectedmst!='All'  && selectedmst!=null && selectedmst != '')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND layer__r.MRS__r.Mask_Set_Title__c =:selectedmst';
      if(selectedMaskLayer!='' && selectedMaskLayer!=null && String.valueof(selectedMaskLayer)!='null')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND Layer__r.Name =:selectedMaskLayer';
      if(ValueCatcher !=null && ValueCatcher != ''){ 
          List<String> lstValueCatcher  = ValueCatcher.split(',');
          if(lstValueCatcher!= null && !lstValueCatcher.isEmpty()) {
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Layer__r.Layer_Status__c IN :lstValueCatcher ';
          }
         
      }
      if(selectedDeviceId!='' && selectedDeviceId!=null && String.valueof(selectedDeviceId)!='null')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND PTRF__r.Device_Id__c=:selectedDeviceId';
    //if(selectedChipName!='' && selectedChipName!=null && String.valueof(selectedChipName)!='null')
     //     lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND Chip__r.Name=:selectedChipName';
      if(selectedPTRFDRTNumber!='' && selectedPTRFDRTNumber!=null && String.valueof(selectedPTRFDRTNumber)!='null')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND PTRF_Number__c=:selectedPTRFDRTNumber';
       lstmrsLayerChipAsso  =lstmrsLayerChipAsso  + ' Order by Send_Frame_Data__c desc,layer__r.Mask_Set_Title_Name__c,PTRF_Number__c,Layer__r.Name,Chip__r.Name limit 15000';
       
     
       Integer counter=0;
       Integer j=1;
       for(MRS_Layer_Chip_Association__c  objMLCA :Database.Query(lstmrsLayerChipAsso))
       {
           mstname=objMLCA.layer__r.Mask_Set_Title_Name__c;
         
            if(objMLCA.PTRF__r.Recticle_Type__c =='Multi Node Reticle (MNR)')
            {
             reticleType=true;
            } 
          /*   if(objMLCA.Rev__c!=null){
                objMLCA.Layer__r.Name=objMLCA.Layer__r.Name+ objMLCA.Rev__c;
            }
            if(objMLCA.Rom_Code__c!=null &&objMLCA.Rom_Code__c!=''){
               objMLCA.Layer__r.Name=objMLCA.Layer__r.Name+ '(' +objMLCA.Rom_Code__c + ')';
            } */
            string MaskLayerRomCode;
             MaskLayerRomCode=objMLCA.Layer__r.Name;
            if(objMLCA.Rev__c!=null)
            {
                MaskLayerRomCode=MaskLayerRomCode +  objMLCA.Rev__c;
            }
            if(objMLCA.Rom_Code__c!=null && objMLCA.Rom_Code__c!='')
            {
               MaskLayerRomCode=MaskLayerRomCode + '(' + objMLCA.Rom_Code__c + ')';
            } 
            if(objMLCA.Tech_Geo__c != NULL && objMLCA.Tech_Geo__c != 'NULL' && !objMLCA.Tech_Geo__c.contains('nm')){
            Double TechGeoValue = double.valueOf(objMLCA.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                if(TechGeoValue != NULL && TechGeoValue <0.1){
                    objMLCA.Tech_Geo__c = objMLCA.Tech_Geo__c + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)';
                }   
             }
         lstSendDataPrimeWrapper.add(new SendDataTableWrapper(1,objMLCA,true,(objMLCA.Send_Frame_Data_Date__c==null?'':objMLCA.Send_Frame_Data_Date__c.format()),MaskLayerRomCode));           
      
       //   lstMLCA.add(objMLCA);
          counter=counter+1;
          if(counter==j*1000 || counter== countOfTotalRecord)
          {
              mapMLCA.put(j,lstSendDataPrimeWrapper);
              lstSendDataPrimeWrapper= new List<SendDataTableWrapper>();
                j=j+1;
        }  
       }
        
       
    }
    /**
        This method exports the data present in the Send Frame Data tables to CSV format. 
        @method name: exportToExcel
        @parameter:   None.
        @return :     The Send Frame Data screen.
    **/ 
   public PageReference exportToCSV()
   {
        PageReference page =null;
        if(lstSendDataPrimeWrapper!=null)
        {
         //  page =new PageReference('/apex/VFMRSSendFrameDataCSV?selectedmst=' + selectedmst + '&selectedSendData=' + selectedSendData + '&selectedMaskLayer=' + selectedMaskLayer  + '&selectedDeviceId=' + selectedDeviceId + '&selectedPTRFDRTNumber=' + selectedPTRFDRTNumber);
        }
        else
        {
           page =null;
        }
      //  page.setRedirect(false);
        return page;
    }
     /**
        This method count rows which is displayed in table. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public Integer rowCount()
    {
        //count 
          String  countQuery= 'SELECT  count() FROM  MRS_Layer_Chip_Association__c  WHERE PTRF__r.Frame_Tapeout__c=True ';
          if(selectedSendData!=null){ 
              List<String> lstSelectedSendData = selectedSendData.split(',');
              if(lstSelectedSendData  != null && !lstSelectedSendData.isEmpty() && lstSelectedSendData.size() > 1) {
                  countQuery=countQuery+' And Send_Frame_Data__c IN :lstSelectedSendData ';
              }
              else {
                  countQuery=countQuery+' And Send_Frame_Data__c = :selectedSendData ';
              }
          }
           else
          {
              countQuery=countQuery+' And Send_Frame_Data__c in (\'Not Done\')';
          }
          if(selectedmst!='All'  && selectedmst!=null && selectedmst != '')
              countQuery=countQuery+' AND layer__r.MRS__r.Mask_Set_Title__c =:selectedmst';
          if(selectedMaskLayer!='' && selectedMaskLayer!=null && String.valueof(selectedMaskLayer)!='null')
              countQuery=countQuery+' AND Layer__r.Name =:selectedMaskLayer';
          if(ValueCatcher !=null && ValueCatcher != ''){ 
              List<String> lstValueCatcher  = ValueCatcher.split(',');
              if(lstValueCatcher!= null && !lstValueCatcher.isEmpty()) {
                  countQuery=countQuery+' And Layer__r.Layer_Status__c IN :lstValueCatcher ';
              }     
          }
          if(selectedDeviceId!='' && selectedDeviceId!=null && String.valueof(selectedDeviceId)!='null')
              countQuery=countQuery+' AND PTRF__r.Device_Id__c=:selectedDeviceId';
        //  if(selectedChipName!='' && selectedChipName!=null && String.valueof(selectedChipName)!='null')
        //      countQuery=countQuery+' AND Chip__r.Name=:selectedChipName';
          if(selectedPTRFDRTNumber!='' && selectedPTRFDRTNumber!=null && String.valueof(selectedPTRFDRTNumber)!='null')
              countQuery=countQuery+' AND PTRF_Number__c=:selectedPTRFDRTNumber';
              
          countQuery=countQuery+ ' LIMIT 100000';
          system.debug('countQuery:' + countQuery);  
          return Database.countQuery(countQuery);
    }
     /**
        This method initializes Standard Set Controller. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public void initPagination()
    {
        if(setCon == null){
        size = numberOfRecordsPerPage;
        string  lstmrsLayerChipAsso = 'SELECT  Id,PTRF__r.Id,Layer__c,PTRF__r.Device_Id__c,DRT__r.Name,PTRF__r.Name,Layer__r.MRS__r.Mask_Set_Title__c,Layer__r.MRS__r.Mask_Set_Title__r.Name,Name,PTRF_Number__c,Tech_Geo__c,\n'+
                                  ' Layer__r.Name,Layer__r.Layer_Status__c, Send_Frame_Data__c,Send_Frame_Data_Date__c,Chip__c,Chip__r.Name,layer__r.Mask_Set_Title_Name__c,Rev__c,ROM_Code__c,PTRF__r.Recticle_Type__c\n'+
                                  ' FROM  MRS_Layer_Chip_Association__c WHERE PTRF__r.Frame_Tapeout__c=True  ';
      
      List<String> lstSelectedSendData;
      if(selectedSendData!=null){
          lstSelectedSendData = selectedSendData.split(',');
          if(lstSelectedSendData  != null && !lstSelectedSendData.isEmpty() && lstSelectedSendData.size() > 1) {
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Send_Frame_Data__c IN :lstSelectedSendData ';
          }
          else {
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Send_Frame_Data__c = :selectedSendData ';
          }
         
      }
      else
      {
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Send_Frame_Data__c in (\'Not Done\')';
      }
      if(selectedmst!='All'  && selectedmst!=null && selectedmst != '')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND layer__r.MRS__r.Mask_Set_Title__c =:selectedmst';
      if(selectedMaskLayer!='' && selectedMaskLayer!=null && String.valueof(selectedMaskLayer)!='null')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND Layer__r.Name =:selectedMaskLayer';
       List<String> lstValueCatcher = new list<string>();
       if(ValueCatcher !=null && ValueCatcher != ''){ 
          lstValueCatcher  = ValueCatcher.split(',');
          if(lstValueCatcher!= null && !lstValueCatcher.isEmpty()) {
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' And Layer__r.Layer_Status__c IN :lstValueCatcher ';
          }
         
      }
      if(selectedDeviceId!='' && selectedDeviceId!=null && String.valueof(selectedDeviceId)!='null')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND PTRF__r.Device_Id__c=:selectedDeviceId';
   
      if(selectedPTRFDRTNumber!='' && selectedPTRFDRTNumber!=null && String.valueof(selectedPTRFDRTNumber)!='null')
          lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND PTRF_Number__c=:selectedPTRFDRTNumber';
    
      lstmrsLayerChipAsso  =lstmrsLayerChipAsso  + ' Order by Send_Frame_Data__c desc,layer__r.Mask_Set_Title_Name__c,PTRF_Number__c,Layer__r.Name,Chip__r.Name';
      lstmrsLayerChipAsso  =lstmrsLayerChipAsso  + ' LIMIT 100000';           
                 
                integer maxRecordCount  = rowCount();  
                setCon = new Pagination(maxRecordCount,lstmrsLayerChipAsso,
                                        lstSelectedSendData,selectedSendData,selectedmst,
                                        selectedMaskLayer,lstValueCatcher,selectedDeviceId,
                                       selectedPTRFDRTNumber);
                                
                setCon.setPageSize(size);
                countOfTotalRecord= setCon.getResultSize();
               
                selectedCounter=setCon.getPageNumber();
                counterPagination=(selectedCounter-1)+1;
               
                
                if(Math.mod(countOfTotalRecord,size)==0) {
                totalPages=countOfTotalRecord/size;
                }
                else{
                totalPages=(countOfTotalRecord/size)+1;
                }
                if(size<countOfTotalRecord)
                {
                endOfDisplay=size;
                }
                else
                {
                endOfDisplay=countOfTotalRecord;
                }
            }
           
    }
 
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
   /**
         This method retrieves previous page records. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public void previous() {
       setCon.previous(); 
       populateDropdown();    
       selectedCounter=setCon.getPageNumber();
       counterPagination=((setCon.getPageNumber()-1)*size+1);
       endOfDisplay=(counterPagination+size)-1;
    }
   /**
        This method retrieves next page records. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public void next() {
        setCon.next(); 
        populateDropdown();    
       selectedCounter=setCon.getPageNumber();
       counterPagination=((setCon.getPageNumber()-1)*size+1);
       endOfDisplay=(counterPagination+size)-1;
       if(endOfDisplay>countOfTotalRecord)
       {
           endOfDisplay=countOfTotalRecord;
       }
    }
     /**
        This method retrieve the record of desired page. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public void changePage()
    {
   
     Integer minus=(selectedCounter-setCon.getPageNumber());
     Integer reverseMinus=(setCon.getPageNumber()-selectedCounter);
       if(selectedCounter>setCon.getPageNumber())
       {
           for(Integer i=1; i <=minus; i++) {  
           setCon.next(); 
           }
          
            populateDropdown();
       }
       else if(selectedCounter<setCon.getPageNumber())
       {
           for(Integer i=1; i <=reverseMinus; i++) {  
           setCon.previous();
           }
            populateDropdown();
       }
       selectedCounter=setCon.getPageNumber();
       counterPagination=((setCon.getPageNumber()-1)*size+1);
       endOfDisplay=(counterPagination+size)-1;
       if(endOfDisplay>countOfTotalRecord)
       {
           endOfDisplay=countOfTotalRecord;
       }
    
    }
     /**
        This method changes no of records per page. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    public void retrieveRecord()
    {
        setCon = null;
        initPagination(); 
        populateDropdown();    
        setCon.setPageNumber(1);   
    }
    
   /**
        This is custom pagination class which is instantiated on each call. 
        @method name: populateDropdown
        @parameter:   None.
        @return :     None.
     **/
    
    public class Pagination {
        private List<SObject> currentSetOfRecords;
        private Integer currentPageNumber;
        private Integer currentPageIndex;
        private Integer pageSize;
        private Integer resultSize;
        
        private string queryString;
        
        private list<string> lstSelectedSendData;
        private string selectedSendData;
        private string selectedmst;
        private string selectedMaskLayer;
        private list<string> lstValueCatcher;
        private string selectedDeviceId;
        private string selectedPTRFDRTNumber;
        
        
        public Pagination(integer maxRecordCount,string qStr,list<string> lstSelectedSendData,string selectedSendData,
                            string selectedmst,string selectedMaskLayer,list<string> lstValueCatcher,string selectedDeviceId,// string selectedChipName,
                            string selectedPTRFDRTNumber) {
            pageSize = 1;
            currentPageNumber = 1;
            currentPageIndex = 0;
            resultSize = 0;
            currentSetOfRecords = new List<SObject>();
            resultSize = maxRecordCount;
            queryString = qStr;
                                
            this.lstSelectedSendData = lstSelectedSendData;
            this.selectedSendData = selectedSendData;
            this.selectedmst = selectedmst;
            this.selectedMaskLayer = selectedMaskLayer;
            this.lstValueCatcher = lstValueCatcher;
            this.selectedDeviceId = selectedDeviceId;
            this.selectedPTRFDRTNumber = selectedPTRFDRTNumber;
        }
        
        public Integer getResultSize() {
            return resultSize;
        }
        public void setPageSize(Integer pageSize) {
            this.pageSize = pageSize;
            if(this.pageSize < 1) {
                this.pageSize = 1;
            }
        }
        public void setPageNumber(integer pgNum) {
            currentPageNumber = pgNum;
        }
        public Integer getPageNumber() {
            return currentPageNumber;
        }
        private list<sObject> fetchCurrentList(integer startIdx, integer endIdx) {
            list<sObject> tempList = new list<sObject>();
            /*
            integer counter = 0;            
            for(SObject sObj : Database.query(queryString)) {
                if((counter>=startIdx) && (counter<=endIdx)) {
                    tempList.add(sObj);
                }
                counter++;
            }
            */            
            integer chunkStartIdx=0;
            integer chunkEndIdx = 0;
            integer chunkOffset=0;
            for(list<sObject> lstSObj : Database.query(queryString)) {
                if(tempList.size() >= (endIdx-startIdx+1)) {
                    break;
                }
                chunkEndIdx = chunkStartIdx+lstSObj.size()-1;
                for(integer i=0; i<lstSObj.size();i++) {
                    chunkOffset = chunkStartIdx+i;
                    if(startIdx>chunkEndIdx) {
                        break;
                    }
                    if(chunkOffset>=startIdx && chunkOffset<=endIdx) {
                        tempList.add(lstSObj.get(i));
                    }
                }
                chunkStartIdx += lstSObj.size();
            }            
            return tempList;
        }
        public List<SObject> getRecords() {
                currentSetOfRecords.clear();
                if(resultSize == 0) {
                    return currentSetOfRecords;
                }
                integer startIdx = currentPageIndex;
                integer endIdx = currentPageIndex + pageSize - 1;
                if(endIdx > (resultSize-1)) {
                    endIdx = resultSize-1;
                }
                currentSetOfRecords.addAll(fetchCurrentList(startIdx,endIdx));  
                return currentSetOfRecords;
        }
        public void first() {
            currentPageNumber = 1;
            currentPageIndex = 0;
        }
        public void last() {
            currentPageNumber = resultSize/pageSize;
            if(Math.mod(resultSize, pageSize) > 0) {
                currentPageNumber++;
            }
            if(currentPageNumber == 0) {
                currentPageNumber = 1;
            }
            currentPageIndex = (currentPageNumber - 1) * pageSize;
        }
        public void next() {
            currentPageNumber++;
            currentPageIndex += pageSize;
            if(currentPageIndex > (resultSize - 1)) {
                currentPageIndex -= pageSize;
                currentPageNumber--;
            }
        }
        public void previous() {
            currentPageNumber--;
            currentPageIndex -= pageSize;
            if(currentPageIndex < 0) {
                currentPageIndex += pageSize;
                currentPageNumber++;
            }
        }
        
        public Boolean getHasNext() {
            if((currentPageIndex + pageSize) > (resultSize - 1)) {
                return false;
            }
            return true;
        }
        
        public Boolean getHasPrevious() {
            if(currentPageIndex < pageSize) {
                return false;
            }
            return true;
        }
    }
}