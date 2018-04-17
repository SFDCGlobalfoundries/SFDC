/*
 @class: FMSmainFormViewPrintPDFExt 
 @CreatedBy: Ashwin Kumar Dash
 @CreatedDate: 09/05/2016
 @Description: Controller for FMS main Form PDF
 @Modifications-
     DATE               NAME                  COMMENTS
     17-May-2017        Abhita Bansal         Fixed the code for UAT Issue #145, 146
     18-May-2017        Abhita Bansal         Added the code for Catch-Up Release T39 Point 1, 2, 3, 4, 5
     31-May-2017        Abhita Bansal         Changed the condition for new UAT Issue #192
     02-Jun-2017        Abhita Bansal         Added the Metallization Field for new UAT Issue #210
**/
public class FMSmainFormViewPrintPDFExt{

    public Form_Management_System__c formObj {
        get;
        set;
    }
    public String fId {
        get;
        set;
    }
    public String addContactsCount {
        get;
        set;
    }
    public boolean dispIntConBumpServ {
        get;
        set;
    }
    public boolean dispchipEdgeWLCSP {
        get;
        set;
    }
    public boolean dispsourcingLocation {
        get;
        set;
    }
    public boolean dispLastMetalUsed {
        get;
        set;
    }
    public boolean dispNumMetalLayers {
        get;
        set;
    }
    public boolean dispPassivation {
        get;
        set;
    }
    public boolean dispStepPlanCustReq {
        get;
        set;
    }
    public boolean dispOtherServiceFeatures {
        get;
        set;
    }
    public boolean dispDataCheckingOpts{get;set;}
    public List < addContactWrapper > selectedAddContList {
        get;
        set;
    }
    public boolean isTFACompany {
        get;
        set;
    }
    public Integer Page2TFA {
        get;
        set;
    }
    public Integer Page3TFA {
        get;
        set;
    }
    public Integer Page4TFA {
        get;
        set;
    }
    public Integer Page5TFA {
        get;
        set;
    }
    public Integer Page6TFA {
        get;
        set;
    }
    public boolean dispWireBondSplit {
        get;
        set;
    }
    public boolean dispWireBondSplitTAT {
        get;
        set;
    }
    public boolean dispC4SplitTAT {
        get;
        set;
    }
    public boolean dispOtherSplitDepts {
        get;
        set;
    }
    public boolean dispClientResponseDt {
        get;
        set;
    }
    public boolean dispNeedBizComment {
        get;
        set;
    }
    public boolean dispITARCategory {
        get;
        set;
    }
    public boolean renderOtherForms {
        get;
        set;
    }
    public boolean dispWeapon {
        get;
        set;
    }
    public List < FMS_Mapping_Table__c > fmsMappingTable {
        get;
        set;
    }
    public List < String > selServiceOptions {
        get;
        set;
    }
    public boolean dispChipEdgeDesign {
        get;
        set;
    }

    public boolean dispFinalPassivation {
        get;
        set;
    }

    public boolean dispLineFront {
        get;
        set;
    }

    public boolean dispWirebondPad {
        get;
        set;
    }

    public boolean dispBacksideGrindThickness {
        get;
        set;
    }

    public boolean dispCll {
        get;
        set;
    }

    public boolean dispNonStandardCll {
        get;
        set;
    }

    public boolean dispPickMap {
        get;
        set;
    }

    public boolean dispShippingLabelCLL {
        get;
        set;
    }

    public Map<String, FMSDocumentsLinks__c> FMSdocuments {get;set;}
    public boolean renderLabel{get;set;} 

    public boolean dispStepPlanSection{get;set;}
    public boolean displayNotAvailableMsg{get;set;} 
    public boolean dispInputMethod{get;set;} 
    public boolean dispCircuitType {get;set;}
    public List < attachementWrapper > attWrap { get; set; }
    public List < attachementECCNWrapper > attWrapECCN { get; set; }
    public Boolean dispCrackOptions{get;set;}
    public boolean dispChannelType{get;set;}
    public boolean dispDicingPref{get;set;}
    public boolean dispDicingMarks {get;set;}
    public boolean dispNumC4Pads {get;set;}
    public boolean dispC4SolderMaterial {get;set;}
    public boolean dispC4LaminatePackage {get;set;}
    public List<AddStepPlanContWrapper> addStepPlanList{get;set;}
    public Boolean servContDicing {get;set;}
    public String webRDTSActive;

    public final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO'); 
    /*
    public final String FMS_SAP_ACC_NO1 = EnvironmentVariable.get('FMS_SAP_ACC_NO1'); 
    public final String FMS_SAP_ACC_NO2 = EnvironmentVariable.get('FMS_SAP_ACC_NO2'); 
    public final String FMS_SAP_ACC_NO3 = EnvironmentVariable.get('FMS_SAP_ACC_NO3');
    public final String FMS_SAP_ACC_NO4 = EnvironmentVariable.get('FMS_SAP_ACC_NO4'); 
    public final String FMS_SAP_ACC_NO5 = EnvironmentVariable.get('FMS_SAP_ACC_NO5'); 
    public final String FMS_SAP_ACC_NO6 = EnvironmentVariable.get('FMS_SAP_ACC_NO6');
    public final String FMS_SAP_ACC_NO7 = EnvironmentVariable.get('FMS_SAP_ACC_NO7');
    public final String FMS_SAP_ACC_NO8 = EnvironmentVariable.get('FMS_SAP_ACC_NO8');
    public final String FMS_SAP_ACC_NO9 = EnvironmentVariable.get('FMS_SAP_ACC_NO9');
    public final String FMS_SAP_ACC_NO10 = EnvironmentVariable.get('FMS_SAP_ACC_NO10');
    public final String FMS_SAP_ACC_NO11 = EnvironmentVariable.get('FMS_SAP_ACC_NO11');
    public final String FMS_SAP_ACC_NO13 = EnvironmentVariable.get('FMS_SAP_ACC_NO13');
    */
    
    public FMSmainFormViewPrintPDFExt(ApexPages.StandardController controller) {
        selectedAddContList = new List < addContactWrapper > ();
        fId = ApexPages.currentPage().getParameters().get('id');
        selServiceOptions = new List < String > ();
        isTFACompany = false;
        renderLabel = false;

        dispStepPlanSection = false;
        displayNotAvailableMsg = false;
        dispInputMethod = false;
        dispCircuitType = false;
        attWrap = new List < attachementWrapper > (); 
        attWrapECCN = new List < attachementECCNWrapper > ();
        dispCrackOptions = false;
        dispChannelType = false;
        dispDicingPref = false;
        dispDicingMarks = false;
        dispNumC4Pads = false;
        dispC4SolderMaterial = false;
        dispC4LaminatePackage = false;
        addStepPlanList = new List<AddStepPlanContWrapper>();
        servContDicing = false;

        renderOtherForms = true;
        FMSdocuments = FMSDocumentsLinks__c.getAll();
        fmsMappingTable = [SELECT id, name, Added_Masks__c, DB_Value__c, Feature_Part_Numbers__c, Field__c, Technology__c, UI_Value__c FROM FMS_Mapping_Table__c];
        
        webRDTSActive = Environment_Variable__c.getInstance('WebRDTS_IsActive').value__c;

        if(fId != null && fId != ''){
            String fmsFields = '';
            fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
            fmsFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c,'; 
            fmsFields += ' Customer_Name__r.Id,Customer_Name__r.Name,Device__r.Name,Device__r.id, Opportunity__r.id,';
            fmsFields += ' Opportunity__r.Name, Parent_Form_Id__r.recordtype.Name, Customer_Name__r.SAP_Account_Id__c';       
            string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Id = \''+ fId +'\'';
            formObj = database.query(soql); 
            
            if (formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != '') {
                for (String s: formObj.ServiceOptions__c.split(';')) {
                    selServiceOptions.add(s);
                }
                if(formObj.ServiceOptions__c.contains('Dicing')) {
                    servContDicing = true;
                } else {
                    servContDicing = false;
                }
            }

            if (formObj.Name__c != null && formObj.Name__c != '') {
                List < String > nameList = formObj.Name__c.split(';');
                List < String > phoneList = formObj.Phone__c.split(';');
                List < String > emailList = formObj.Email__c.split(';');
                addContactWrapper adc;
                for (Integer i = 0; i < nameList.size(); i++) {
                    adc = new addContactWrapper(nameList[i], i<emailList.size()?emailList[i]:'', i<phoneList.size()?phoneList[i]:'');
                    selectedAddContList.add(adc);
                }
            }
            
            if (selectedAddContList != null && !selectedAddContList.isEmpty()) {
                addContactsCount = String.valueOf(selectedAddContList.size());
            } else {
                addContactsCount = 'No';
            }
        } else {
            formObj = new Form_Management_System__c();
        }
        renderingOfIntConBumpSource();
        renderchipEdgeWLCSP();
        rendersourcingLocation();
        renderLastMetalUsed();
        renderNumMetalLayers();
        renderPassivation();
        renderStepPlanCustomReq();
        renderDataCheckingOpts();
        renderotherServiceFeatures();
        if (formObj.Customer_Name__c != null && formObj.Customer_Name__r.SAP_Account_Number__c != null) {
            if (checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO1) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, SAP_ACC_NO) ||
                (formObj.Customer_Name__r.Customer_Category__c != null && formObj.Customer_Name__r.Customer_Category__c.equalsIgnoreCase('TFA'))) { // || (formObj.Customer_Name__r.Customer_Category__c != null && formObj.Customer_Name__r.Customer_Category__c.equalsIgnoreCase('CC')) - Remove TFA Questions for CC Accounts  
                isTFACompany = true;
            } else {
                isTFACompany = false;
            }
        }
        if (isTFACompany && formObj.QuoteOnly__c == 'Yes' && (formObj.QuoteOnly_Old_Value__c == null || formObj.QuoteOnly_Old_Value__c == 'No' || formObj.QuoteOnly_Old_Value__c == '')) {
            Page2TFA = 2;
            Page3TFA = 0;
            Page4TFA = 0;
            Page5TFA = 0;
            Page6TFA = 0;
            renderOtherForms = false;
        } else if (isTFACompany && formObj.QuoteOnly__c == 'No' && formObj.QuoteOnly_Old_Value__c == 'Yes') {
            Page2TFA = 2;
            Page3TFA = 3;
            Page4TFA = 4;
            Page5TFA = 5;
            Page6TFA = 6;
            renderOtherForms = true;
        } else {
            Page2TFA = 0;
            Page3TFA = 2;
            Page4TFA = 3;
            Page5TFA = 4;
            Page6TFA = 5;
            renderOtherForms = true;
        }
        dispWeapon = checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO2);   
        renderWireBondSplit();
        renderWireBondSplitTAT();
        renderC4SplitTAT();
        renderOtherSplitDets();
        renderClientResponseDt();
        renderNeedBizComment();
        renderITARCat();
        renderLineFront();
        renderWireBondPad();
        renderBacksideGrindThickness();
        renderCll();
        renderNonStandardCll();
        renderPickMap();
        renderShippingLabelCLL();
        renderFinalPassivation();
        renderChipEdgeDesign();
        displayRenderLabel();

        renderCircuitType();

        renderStepPlanSection();
        renderInputMethod();
        renderCrackOptions();
        renderDicingMarks();
        renderNumC4Pads();
        renderC4SolderMaterial();
        renderC4LaminatePackage();

        List < String > attachmentIds = new List < String > ();
        List < String > attachmentECCNIds = new List < String > ();
       
        if (formObj.InputMethod__c != null && formObj.InputMethod__c != '' 
            && formObj.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment' 
            && formObj.FileAttachment__c != null && formObj.FileAttachment__c != '') {
            attachmentIds.add(formObj.FileAttachment__c);
        }
        if (formObj.InputMethod__c != null && formObj.InputMethod__c != '' 
            && formObj.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.' 
            && formObj.AdvancedProcessFileAttachment__c != null && formObj.AdvancedProcessFileAttachment__c != '') {
            attachmentIds.add(formObj.AdvancedProcessFileAttachment__c);
        }

        if(!attachmentIds.isEmpty() && attachmentIds<>null){
            Integer filesize;
            for (ContentVersion attDetails: [SELECT ContentDocumentId, ContentSize, Title FROM ContentVersion where Id IN: attachmentIds]) {
    
                attachementWrapper attWrapInst = new attachementWrapper();
                attWrapInst.attName = attDetails.Title;
                attWrapInst.attId = attDetails.Id;
                attWrapInst.ContentDocumentId = attDetails.ContentDocumentId;
                filesize = Integer.valueOf(attDetails.ContentSize/1024);
                if(filesize>1024) {
                    filesize = Integer.valueOf(filesize/1024);
                    attWrapInst.attSize = filesize + ' MB';
                } else if(filesize == 0){
                    attWrapInst.attSize = attDetails.ContentSize + ' Bytes';
                } else {
                    attWrapInst.attSize = filesize + ' KB';
                }
                attWrap.add(attWrapInst);
            }
        }
        if(isTFACompany && formObj.DesignSubmission__c != null && formObj.DesignSubmission__c != '' && 
            (formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign) 
            && formObj.ECCN_attachmentName__c != null && formObj.ECCN_attachmentName__c != '') {
            attachmentECCNIds.add(formObj.ECCN_attachmentName__c);
        }
        
        if(!attachmentECCNIds.isEmpty() && attachmentECCNIds<>null) {
            Integer filesize;
            for (ContentVersion attDetails: [SELECT ContentDocumentId, ContentSize, Title FROM ContentVersion where Id IN: attachmentECCNIds]) {
    
                attachementECCNWrapper attWrapInst = new attachementECCNWrapper();
                attWrapInst.attName = attDetails.Title ;
                attWrapInst.attId = attDetails.Id;
                attWrapInst.ContentDocumentId = attDetails.ContentDocumentId;
                filesize = Integer.valueOf(attDetails.ContentSize/1024);
                if(filesize>1024) {
                    filesize = Integer.valueOf(filesize/1024);
                    attWrapInst.attSize = filesize + ' MB';
                } else if(filesize == 0){
                    attWrapInst.attSize = attDetails.ContentSize + ' Bytes';
                } else {
                    attWrapInst.attSize = filesize + ' KB';
                }
                attWrapECCN.add(attWrapInst);
            }
        }

        List < String > spNameList = new List<String>();
        List < String > spEmailList = new List<String>();
        if (formObj.AppName__c != null && formObj.AppName__c != '') {
            spNameList = formObj.AppName__c.split(';');
            if (formObj.AppEmail__c != null && formObj.AppName__c != '')spEmailList = formObj.AppEmail__c.split(';');
            AddStepPlanContWrapper adcsp;
            for (Integer i = 0; i < spNameList.size(); i++) {
                adcsp = new AddStepPlanContWrapper(spNameList[i], i<spEmailList.size()?spEmailList[i]:'');
                addStepPlanList.add(adcsp);
            }
        } 
    }

    public String getFormId() {
        return ApexPages.currentPage().getParameters().get('id');
    }
        
    public boolean checkFormCompany(String soldTo, String str) {
        if (soldTo != null && soldTo != '' && str != null && str != '') {
            if (str.right(6).equals(soldTo.split('-')[0].right(6))) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }

    public void renderWireBondSplit() {
        if (formObj.QuoteOnly__c == 'Yes' || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote') ||
            (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes'))) {
            dispWireBondSplit = true;
        } else {
            dispWireBondSplit = false;
        }
    }

    public void renderWireBondSplitTAT() {
        if ((formObj.QuoteOnly__c == 'Yes' && formObj.WireBondSplit__c == 'Yes') || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote' &&
                formObj.WireBondSplit__c == 'Yes') || (checkStatesForTFAReadOnly() && formObj.WireBondSplit__c == 'Yes')) {
            dispWireBondSplitTAT = true;
        } else {
            dispWireBondSplitTAT = false;
        }
    }

    public void renderC4SplitTAT() {
        if ((formObj.QuoteOnly__c == 'Yes' && formObj.C4Split__c == 'Yes') || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote' &&
                formObj.C4Split__c == 'Yes') || (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes') && formObj.C4Split__c == 'Yes')) {
            dispC4SplitTAT = true;
        } else {
            dispC4SplitTAT = false;
        }
    }

    public void renderOtherSplitDets() {
        if ((formObj.QuoteOnly__c == 'Yes' && formObj.OtherSplits__c == 'Yes') || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote' &&
                formObj.OtherSplits__c == 'Yes') || (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes') && formObj.OtherSplits__c == 'Yes')) {
            dispOtherSplitDepts = true;
        } else {
            dispOtherSplitDepts = false;
        }
    }

    public void renderITARCat() {
        if ((formObj.QuoteOnly__c == 'Yes' || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote') || (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes'))) && formObj.AssetProtectionCode__c != '0') {
            dispITARCategory = true;
        } else {
            dispITARCategory = false;
        }
    }

    public void renderClientResponseDt() {
        if (formObj.QuoteOnly__c == 'Yes' || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote') ||
            (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes')) && isTFACompany) {
            dispClientResponseDt = true;
        } else {
            dispClientResponseDt = false;
        }
    }

    public void renderNeedBizComment() {
        if ((formObj.QuoteOnly__c == 'Yes' && isTFACompany) || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == 'SubmittedForQuote') ||
            (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes'))) {
            dispNeedBizComment = true;
        } else {
            dispNeedBizComment = false;
        }
    }

    public boolean checkStatesForTFAReadOnly() {
        if (formObj.State_of_the_Form__c == 'Draft' || formObj.State_of_the_Form__c == 'Submitted' || formObj.State_of_the_Form__c == 'Frozen' || formObj.State_of_the_Form__c == 'Thawed' || formObj.State_of_the_Form__c == 'InactiveSubmitted' || formObj.State_of_the_Form__c == 'InactiveThawed' || formObj.State_of_the_Form__c == 'SubmittedForQuote' || formObj.State_of_the_Form__c == 'InactiveSubmittedForQuote') {
            return true;
        }
        return false;
    }

    public void renderingOfIntConBumpSource() {
        if ((formObj.Technology__c == 'CSOI 7RF' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || formObj.Technology__c == 'CMS90WG (CMOS9WG)' ||
                formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' ||
                formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == 'CMOS 9RFe' || formObj.Technology__c == 'CMOS 9SF' ||
                formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formObj.Technology__c == 'IPD5PAE' || formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' ||
                formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'CMOS 6SF' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' ||
                formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'CSOI 7TF' || formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' ||
                formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' ||
                formObj.Technology__c == '--None--' || formObj.Technology__c == 'CMOS 10LP' || formObj.Technology__c == 'CMOS 10LPe' || formObj.Technology__c == 'CMOS 10RFe' ||
                formObj.Technology__c == 'CMOS 10SF' || formObj.Technology__c == 'SOI12S0' || formObj.Technology__c == '32SOI' || formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' ||
                formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == '45RFSOI' ) && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && 
                (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP) 
                || ((formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)&& formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar ))){   
            dispIntConBumpServ = true;
        } else {
            dispIntConBumpServ = false;
        }
    }

    public void renderchipEdgeWLCSP() {
        if ((formObj.Technology__c == 'CSOI 7RF' && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No') && (formObj.Chip_Interconnect__c == 'WLCSP-RDL' || formObj.Chip_Interconnect__c == 'WLCSP-BoP') && (formObj.IntConBumpSource__c == 'Yes' && formObj.QuoteOnly__c != 'Yes')) {
            dispchipEdgeWLCSP = true;
        } else {
            dispchipEdgeWLCSP = false;
        }
    }

    public void rendersourcingLocation() {

        if((formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' 
            || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CSOI 7SW' 
            || formObj.Technology__c == 'SOI7SWT') && (checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4)
            || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO5))){
                dispsourcingLocation = true;
        } else {
             dispsourcingLocation = false;
        }
    }

    public void renderLastMetalUsed() {
        if (formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' || formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' ||
                formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'CSOI 7RF' || formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' ||
                formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' ||
                formObj.Technology__c == 'IPD5PAE' || formObj.Technology__c == 'CSOI 7TF' || formObj.Technology__c == 'CMOS 6SF' ||formObj.Technology__c == UtilityCls.CSOI8SW|| formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)) {
            dispLastMetalUsed = true;
        } else {
            dispLastMetalUsed = false;
        }
    }

    public void renderNumMetalLayers() {
        if (formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' ||
                formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'CSOI 7RF' ||
                formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' ||
                formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' ||
                formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' || formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' ||
                formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'IPD5PAE' || formObj.Technology__c == 'CSOI 7TF' ||
                formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || formObj.Technology__c == 'BiMOS P6' || formObj.Technology__c == 'BMSP6C9' || formObj.Technology__c == 'CMOS 6SF' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)) {
            dispNumMetalLayers = true;
        } else {
            dispNumMetalLayers = false;
        }
    }

    public void renderPassivation() {
        if (formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' ||
                formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' ||
                formObj.Technology__c == 'CSOI 7RF' || formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'CMOS 10LPe' ||
                formObj.Technology__c == 'CMOS 10LP' || formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formObj.Technology__c == 'CMOS 10SF' ||
                formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' || formObj.Technology__c == 'CMOS 10RFe' || formObj.Technology__c == 'CMHV7SF' ||
                formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' ||
                formObj.Technology__c == 'CMOS 9SF' || formObj.Technology__c == 'CMOS 9RFe' || formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'IPD5PAE' ||
                formObj.Technology__c == 'CSOI 7TF' || formObj.Technology__c == 'SOI12S0' || formObj.Technology__c == 'CMOS 6SF' || formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == '45RFSOI' || formObj.Technology__c == UtilityCls.CSOI8SW||formObj.Technology__c == '32SOI' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || formObj.Technology__c == 'CMS90WG (CMOS9WG)' || formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)) {
            dispPassivation = true;
        } else {
            dispPassivation = false;
        }
    }

    public void renderStepPlanCustomReq() {
        if ((formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes') && (formObj.Technology__c == 'IPD5PAE' || formObj.Technology__c == 'CSOI 7RF' ||
                formObj.Technology__c == '--None--' || formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'SOI7SWT' ||
                formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' || formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' ||
                formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' ||
                formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' ||
                formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' ||
                formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' ||
                formObj.Technology__c == 'CMS90WG (CMOS9WG)'|| formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == '45RFSOI'||formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
            dispStepPlanCustReq = true;
        } else {
            dispStepPlanCustReq = false;
        }
    }

    public void renderDataCheckingOpts(){
        if(formObj.Technology__c == UtilityCls.X32SOI || formObj.Technology__c == UtilityCls.CNV8SFi || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_9SF || formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10LPe || formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMOS_10SF || formObj.Technology__c == UtilityCls.SOI12S0 || formObj.Technology__c == UtilityCls.BiMOS_P6 || formObj.Technology__c == UtilityCls.BMSP6C9){
            dispDataCheckingOpts = false;
        }else{
            dispDataCheckingOpts = true;
        }
    }

    public pageReference techFeaturePage() {
        PageReference p = new PageReference('/apex/FMSTechFeaturePage?id=' + formObj.id);
        p.setRedirect(true);
        return p;
    }

    public void renderotherServiceFeatures() {
        if (formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != '') {
            Set < String > sOpt1 = new Set < String > ();
            sOpt1.addAll(formObj.ServiceOptions__c.split(';'));
            if (sOpt1.contains('Other') && formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c != '--None--') {
                dispOtherServiceFeatures = true;
            } else {
                dispOtherServiceFeatures = false;
            }
        } else {
            dispOtherServiceFeatures = false;
        }
    }

    public class addContactWrapper {
        public String addContName {
            get;
            set;
        }
        public String addContEmail {
            get;
            set;
        }
        public String addContPhone {
            get;
            set;
        }

        public addContactWrapper(String n, String e, String p) {
            if (n == 'NA') {
                n = '';
            }
            this.addContName = n;
            if (e == 'NA') {
                e = '';
            }
            this.addContEmail = e;
            if (p == 'NA') {
                p = '';
            }
            this.addContPhone = p;
            
        }
    }

    public String getdataCheckingOptsList(){
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.DB_Value__c == formObj.DataCheckingOptions__c){
                return fmsTab.UI_Value__c;
            }
        }
        return '';
    }

    public void renderChipEdgeDesign() {
        Set < String > selOpt = new Set < String > ();
        selOpt.addAll(selServiceOptions);
        if ((formObj.Packaging_Services__c == 'Yes' || selOpt.contains('Dicing')) && (formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'SOI7SWT' ||
                formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == 'CSOI 7RF' ||
                formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' ||
                formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' ||
                formObj.Technology__c == 'CMS90WG (CMOS9WG)' || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == '45RFSOI'||formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)) {
            dispChipEdgeDesign = true;
        } else {
            dispChipEdgeDesign = false;
        }
    }


    public void renderFinalPassivation() {
        if (formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO11) &&
            formObj.Packaging_Services__c == 'No' && ((formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)' && formObj.Passivation__c == 'FV - Polyimide only (84Y8379)') ||
                ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') &&
                    formObj.Passivation__c == 'LV (01L6998)' && formObj.Chip_Interconnect__c == 'C4 flip chip'))) {    
            dispFinalPassivation = true;
        } else {
            dispFinalPassivation = false;
        }
    }

    public void renderLineFront() {
        if (formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO11) &&
            formObj.Packaging_Services__c == 'No' && ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' ||
                formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && formObj.Passivation__c == 'SZ - No Polyimide (LV drawn) (84Y6986)') ||
            (formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)' && formObj.Passivation__c == 'FV - Polyimide only (LV drawn) (84Y8379)' &&  formObj.FinalPassivation__c == 'Yes; 4X FV SHIFT (84Y8783)') || (((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && formObj.Passivation__c == 'LV (01L6998)' &&
                formObj.Chip_Interconnect__c == 'C4 flip chip') && formObj.FinalPassivation__c == 'Yes; 4X LV SHIFT (84Y8784)')) {    
            dispLineFront = true;
        } else {
            dispLineFront = false;
        }
    }

    public void renderWireBondPad() {
        Set < String > servOptsSet = new Set < String > ();
        if (formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != '') {
            servOptsSet.addAll(formObj.ServiceOptions__c.split(';'));
        }

        if (formObj.Chip_Interconnect__c == 'Wirebond' && (servOptsSet.contains('Dicing') || formObj.TestServices__c == 'Yes') && formObj.Technology__c != '--None--') {
            dispWirebondPad = true;
        } else {
            dispWirebondPad = false;
        }
    }

    public void renderBacksideGrindThickness() {
        Set < String > servOptsSet = new Set < String > ();
        servOptsSet.addAll(selServiceOptions);
        if (formObj.QuoteOnly__c != 'Yes' && servOptsSet.contains('Backside Grind')) {
            dispBacksideGrindThickness = true;
        } else {
            dispBacksideGrindThickness = false;
        }
    }

    public void renderCll() {
        if ((checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO13) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO6) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO10) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO8) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO9) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO16) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO17)) &&
            (formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' ||
                formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || formObj.Technology__c == 'IPD5PAE' ||
                formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' ||
                formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'CSOI 7RF' || formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'CSOI 7TF' ||
                formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' ||
                formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' ||
                formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == 'CMOS 9RFe' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)) {    
            dispCll = true;
        } else {
            dispCll = false;
        }
    }

    public void renderNonStandardCll() {
        if ((checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO13) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO7) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO6) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO10) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO8) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO9) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO16) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO17)) &&
            (formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' ||
                formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || formObj.Technology__c == 'IPD5PAE' ||
                formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' ||
                formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'CSOI 7RF' || formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'CSOI 7TF' ||
                formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' ||
                formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' ||
                formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == 'CMOS 9RFe' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && formObj.CLL__c == 'Non-standard CLL (requires pre-approval)') {   
            dispNonStandardCll = true;
        } else {
            dispNonStandardCll = false;
        }
    }

    public void renderPickMap() {
        if (formObj.DesignSubmission__c == 'Single Chip (one GDS)' && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4)) {   
            dispPickMap = true;
        } else {
            dispPickMap = false;
        }
    }

    public void renderShippingLabelCLL() {
        if ((checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO13) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO7) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO6) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO10) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO8) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3) ||
                checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO9) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO16) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO17)) &&
            (formObj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formObj.Technology__c == '--None--' || formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' ||
                formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || formObj.Technology__c == 'IPD5PAE' || formObj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formObj.Technology__c == 'CMOS 6RF (CMRF6SF)' || formObj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' ||
                formObj.Technology__c == 'CSOI 7RF' || formObj.Technology__c == 'CSOI 7SW' || formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'CSOI 7TF' ||
                formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' ||
                formObj.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' || formObj.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' ||
                formObj.Technology__c == 'CMOS 9LP (CMOS 9RF)' || formObj.Technology__c == 'CMOS 9RFe' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && (formObj.CLL__c == 'Non-standard CLL (requires pre-approval)' || formObj.CLL__c == 'Standard CLL (133X71LS)')) {   
            dispShippingLabelCLL = true;
        } else {
            dispShippingLabelCLL = false;
        }
    }
    
    public boolean displayRenderLabel() {
        if(formObj.Technology__c == 'CMOS 9SF' || formObj.Technology__c == 'CMOS 9RFe' || formObj.Technology__c == 'CMOS 8RF (CMRF8SF)' 
            || formObj.Technology__c == 'CMHV7SF' || formObj.Technology__c == '32SOI' || formObj.Technology__c == 'CMOS 6SF' 
            || formObj.Technology__c == 'CNV8SFi' || formObj.Technology__c == 'CMOS 10LP' || formObj.Technology__c == 'CMOS 10LPe' 
            || formObj.Technology__c == 'CMOS 10SF' || formObj.Technology__c == 'SOI12S0') {
            renderLabel = true;
        } else {
            renderLabel = false;
        }
        return renderLabel;
    }

    public List<MetallizationOptionWrapper> getMetalizationOption(){
        List<MetallizationOptionWrapper> mList = new List<MetallizationOptionWrapper>();
        MetallizationOptionWrapper mow;
        if(formObj.MetallizationOpts__c!=null && formObj.MetallizationOpts__c!='Other'){
            String uiValue ='';
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Technology__c == formObj.Technology__c 
                    && fmsTab.DB_Value__c == formObj.MetallizationOpts__c){
                    uiValue = fmsTab.UI_Value__c;
                    break;
                }
            }
            if(uiValue != '' && uiValue != null){
                String[] strArr = uiValue.split('##');
                mow = new MetallizationOptionWrapper(strArr[0],strArr[1],strArr[2],strArr[3]);
                mList.add(mow);
            }               
        }
        return mList;
    }
    
    public class MetallizationOptionWrapper{
        public String metalizationOption{get;set;}
        public String totWiringLevel{get;set;}
        public String lastWiringLevels{get;set;}
        public String featurePartNumbers{get;set;}
        
        public MetallizationOptionWrapper(String metalizationOption,String totWiringLevel,String lastWiringLevels,String featurePartNumbers){
            this.metalizationOption = metalizationOption;
            this.totWiringLevel = totWiringLevel;
            this.lastWiringLevels = lastWiringLevels;
            this.featurePartNumbers = featurePartNumbers;
        }                
    }
    
    public List<Apttus_Proposal__Proposal__c> getconfigData(){
        List<Apttus_Proposal__Proposal__c> proposals = [SELECT Id,Name,Apttus_Proposal__Account__c,FMS_Proposal__c,Apttus_Proposal__Opportunity__c, Fab_Name__c ,                                                                      
                                                                        Apttus_Proposal__Account__r.Name, Apttus_Proposal__Opportunity__r.Name, Apttus_Proposal__Proposal_Name__c
                                                                        FROM Apttus_Proposal__Proposal__c
                                                                        WHERE FMS_Proposal__c=:fId];
        if(proposals != null && proposals.size() !=0 ){
            fetch_ApttusProposalLineItems(proposals.get(0));
        }
        return  proposals;
    }
    
    public Boolean isTechnologyConfigured {get; set;}
    public Product2 bundleProduct {get; set;}
    public Map<Id, Apttus_Config2__ProductOptionGroup__c> mapTabPOGs {get; set;}
    public Map<Id, List<Apttus_Config2__ProductOptionGroup__c>> sectionsByTab {get; set;}
    public Map<Id, List<Apttus_Config2__ProductOptionComponent__c>> optionsBy_POG_Ids {get; set;}
    public void fetch_ApttusProposalLineItems(Apttus_Proposal__Proposal__c proposalRecord){
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItems =[Select  Apttus_QPConfig__OptionId__c, Apttus_Proposal__Product__c 
                                                                            from Apttus_Proposal__Proposal_Line_Item__c 
                                                                            where Apttus_Proposal__Proposal__c = :proposalRecord.Id Order By  Apttus_QPConfig__OptionId__r.Family, Apttus_QPConfig__OptionId__r.Name];
        if(lstProposalLineItems != null && lstProposalLineItems.size() >0 && lstProposalLineItems.get(0).Apttus_Proposal__Product__c != null){
            bundleProduct = [Select Name, Description, PT_Number__c, Geometry__c, Mask_Sets__c, Product_External_ID__c from Product2 where Id = : lstProposalLineItems.get(0).Apttus_Proposal__Product__c ].get(0); 
            isTechnologyConfigured = true;
        }else{
            return;
        }
        Set<Id> setOfAllSelectedoptions = new Set<Id>();
        for(Apttus_Proposal__Proposal_Line_Item__c pli : lstProposalLineItems){
            if(pli.Apttus_QPConfig__OptionId__c != null)
                setOfAllSelectedoptions.add(pli.Apttus_QPConfig__OptionId__c);
        }
        lstProposalLineItems.clear();

        optionsBy_POG_Ids = new Map<Id, List<Apttus_Config2__ProductOptionComponent__c>>();
        for(Apttus_Config2__ProductOptionComponent__c poc : [Select id, Apttus_Config2__ComponentProductId__c, Apttus_Config2__ProductOptionGroupId__c, Apttus_Config2__ComponentProductId__r.Name, 
                                                                Apttus_Config2__ComponentProductId__r.Family, Apttus_Config2__ComponentProductId__r.Mask_Sets__c, Apttus_Config2__ComponentProductId__r.Description
                                                                from Apttus_Config2__ProductOptionComponent__c 
                                                                where Apttus_Config2__ComponentProductId__c != '' AND Apttus_Config2__ProductOptionGroupId__c != '' AND Apttus_Config2__ComponentProductId__c IN : setOfAllSelectedoptions
                                                                Order by Apttus_Config2__Sequence__c]){
            if(optionsBy_POG_Ids.containsKey(poc.Apttus_Config2__ProductOptionGroupId__c))
                optionsBy_POG_Ids.get(poc.Apttus_Config2__ProductOptionGroupId__c).add(poc);
            else
                optionsBy_POG_Ids.put(poc.Apttus_Config2__ProductOptionGroupId__c, new List<Apttus_Config2__ProductOptionComponent__c>{poc});
        }
        setOfAllSelectedoptions.clear();

        mapTabPOGs = new Map<Id, Apttus_Config2__ProductOptionGroup__c>();
        sectionsByTab = new Map<Id, List<Apttus_Config2__ProductOptionGroup__c>>();
        
        Map<Id, Apttus_Config2__ProductOptionGroup__c> mapOfPOGs = new Map<Id, Apttus_Config2__ProductOptionGroup__c>([Select id, Apttus_Config2__OptionGroupId__c, Apttus_Config2__OptionGroupId__r.Apttus_Config2__Label__c, Apttus_Config2__IsHidden__c, Apttus_Config2__IsLeaf__c, Apttus_Config2__ParentOptionGroupId__c
                                                                from Apttus_Config2__ProductOptionGroup__c 
                                                                where Apttus_Config2__ProductId__c =: bundleProduct.Id 
                                                                Order By Apttus_Config2__RootSequence__c, Apttus_Config2__OptionGroupId__r.Apttus_Config2__Left__c]);
                                                     
        for(Apttus_Config2__ProductOptionGroup__c tabPOG : mapOfPOGs.values()){
            if(tabPOG.Apttus_Config2__ParentOptionGroupId__c == null && !tabPOG.Apttus_Config2__IsHidden__c){
                if(tabPOG.Apttus_Config2__IsLeaf__c && optionsBy_POG_Ids.containsKey(tabPOG.Id)){
                    sectionsByTab.put(tabPOG.Apttus_Config2__OptionGroupId__c, new List<Apttus_Config2__ProductOptionGroup__c>{tabPOG});
                    mapTabPOGs.put(tabPOG.Apttus_Config2__OptionGroupId__c, tabPOG);
                }
                else if(!tabPOG.Apttus_Config2__IsLeaf__c){
                    sectionsByTab.put(tabPOG.Apttus_Config2__OptionGroupId__c, new List<Apttus_Config2__ProductOptionGroup__c>());
                    mapTabPOGs.put(tabPOG.Apttus_Config2__OptionGroupId__c, tabPOG);
                }
                mapOfPOGs.remove(tabPOG.Id);
            }
        }

        for(Apttus_Config2__ProductOptionGroup__c sectionPOG : mapOfPOGs.values()){ 
            if(sectionPOG.Apttus_Config2__ParentOptionGroupId__c != null && optionsBy_POG_Ids.containsKey(sectionPOG.Id)){
                if(sectionsByTab.containsKey(sectionPOG.Apttus_Config2__ParentOptionGroupId__c))
                    sectionsByTab.get(sectionPOG.Apttus_Config2__ParentOptionGroupId__c).add(sectionPOG);
                else
                    sectionsByTab.put(sectionPOG.Apttus_Config2__ParentOptionGroupId__c, new List<Apttus_Config2__ProductOptionGroup__c>{sectionPOG});
            }
        }
        mapOfPOGs.clear();
    }
    
    public void renderStepPlanSection() {
        
        if( (formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No'  
        && (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null 
        && formObj.ServiceOptions__c.contains(UtilityCls.Dicing)) 
        && (formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign 
        || formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) ) 
        || (formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes' 
        && (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null 
        && formObj.ServiceOptions__c.contains(UtilityCls.Dicing))
        && formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) 
        || (formObj.Packaging_Services__c == 'Yes' 
        && formObj.TestServices__c == 'No' && formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) 
        || (formObj.Packaging_Services__c == 'Yes' 
        && formObj.TestServices__c == 'Yes' && (formObj.ServiceOptions__c!= '' 
        && formObj.ServiceOptions__c!= null && formObj.ServiceOptions__c.contains(UtilityCls.Dicing))
        && formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) 
        || formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == ''){
            dispStepPlanSection = false;    
        } else {
            dispStepPlanSection = true;
            renderChannelType();
            renderDicingPref();

            if (webRDTSActive == 'TRUE' && (dispChannelType || dispDicingPref)){
                if(formobj.StepPlanRotationActive__c != null && formobj.StepPlanRotationActive__c != '') {
                    displayNotAvailableMsg = false;
                } 
            } else if(webRDTSActive == 'FALSE'){
                displayNotAvailableMsg = false;
            } else {
                displayNotAvailableMsg = false;
            }
        }       
    } 

    public void renderCircuitType(){
        if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c != 'Yes' && (formObj.Technology__c != UtilityCls.BiMOS_P6 && formObj.Technology__c != '--None--' && formObj.Technology__c != UtilityCls.BMSP6C9)){
            dispCircuitType = true;
        }else {
            dispCircuitType = false;
        }
    } 

    public void renderInputMethod() {
        
        if((formObj.Packaging_Services__c == 'No' && formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null && 
            !formObj.ServiceOptions__c.contains(UtilityCls.Dicing)) || ((formObj.Packaging_Services__c == 'Yes' 
            || (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null 
            && formObj.ServiceOptions__c.contains(UtilityCls.Dicing)))
            && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle)) {
            dispInputMethod = true;
        } else {
            dispInputMethod = false;
        }
    }
    
    public class AddStepPlanContWrapper{
        public String spname{get;set;}
        public String spemail{get;set;}
        public AddStepPlanContWrapper(String spname, String spemail) {
            this.spname = spname;
            this.spemail = spemail;
        }
    }
    
    public class attachementWrapper {

        public string attName {get; set; }
        public id attId {get; set; }
        public String ContentDocumentId {get; set; }
        public String attSize {get; set; }
    }

    public class attachementECCNWrapper {

        public string attName {get; set; }
        public id attId {get; set; }
        public String ContentDocumentId {get; set; }
        public String attSize {get; set; }
    }

    public void renderCrackOptions(){
        
        if(formObj.Packaging_Services__c == 'No' && (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null && !formObj.ServiceOptions__c.contains(UtilityCls.Dicing))){
            if (checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4) && formobj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG){
                dispCrackOptions = true;
            } else if(formobj.Technology__c != UtilityCls.BiCMOS_8XP_SiGe_8XP && formobj.Technology__c != UtilityCls.BiCMOS_9HP_SiGe_9HP && formobj.Technology__c != 'CSOI 7SW' && formobj.Technology__c != UtilityCls.CMS90WG_CMOS9WG && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_1K5PAXE && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_SiG5PAX && formobj.Technology__c != UtilityCls.SOI7SWT && formobj.Technology__c != UtilityCls.X32SOI && formobj.Technology__c != 'BiMOS P6' && formobj.Technology__c != 'BMSP6C9' && formobj.Technology__c != 'BiCMOS 7PA (SiGe 7PA)' && formobj.Technology__c != '45RFSOI' && formObj.Technology__c != UtilityCls.BiCMOS5PA4_HRS5PA4 && formobj.Technology__c != UtilityCls.CSOI8SW){// && !checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO4)){
                dispCrackOptions = true;
            } else {
                dispCrackOptions = false;
            }
        }
    }

    public void renderChannelType() {
        
        if((formObj.Packaging_Services__c == 'No' && 
            (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null && !formObj.ServiceOptions__c.contains(UtilityCls.Dicing)))
            && (formobj.Technology__c == UtilityCls.CSOI_7SW || formobj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formobj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe 
            || formobj.Technology__c == UtilityCls.IPD5PAE || formobj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formobj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX 
            || formobj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formobj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formobj.Technology__c == UtilityCls.CMOS_6SF 
            || formobj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formobj.Technology__c == UtilityCls.CMHV7SF || formobj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF 
            || formobj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formobj.Technology__c == UtilityCls.CSOI_7RF || formobj.Technology__c == UtilityCls.CSOI_7SW 
            || formobj.Technology__c == UtilityCls.SOI7SWT || formobj.Technology__c == UtilityCls.CSOI_7TF || formobj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL 
            || formobj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formobj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA ||  formobj.Technology__c == UtilityCls.CSOI8SW
            || formobj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) ) {
                dispChannelType = true;
        } else {
            dispChannelType = false;
        }
    }

    public void renderDicingPref() {
        
        if((formObj.Packaging_Services__c == 'No' && 
            (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null && !formObj.ServiceOptions__c.contains(UtilityCls.Dicing)))
            && (formobj.Technology__c == UtilityCls.X32SOI || formobj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formobj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP 
            || formobj.Technology__c == UtilityCls.CNV8SFi || formobj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formobj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF 
            || formobj.Technology__c == UtilityCls.CMOS_9SF || formobj.Technology__c == UtilityCls.CMOS_9RFe || formobj.Technology__c == UtilityCls.CMS90WG_CMOS9WG 
            || formobj.Technology__c == UtilityCls.CMOS_10LP || formobj.Technology__c == UtilityCls.CMOS_10LPe || formobj.Technology__c == UtilityCls.CMOS_10RFe 
            || formobj.Technology__c == UtilityCls.CMOS_10SF || formobj.Technology__c == UtilityCls.SOI12S0 || formobj.Technology__c == '45RFSOI') ) {
                dispDicingPref = true;
        } else {
            dispDicingPref = false;
        }
    }

    public void renderDicingMarks() {
        if((formObj.Packaging_Services__c == 'No' && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle
            && (formObj.ServiceOptions__c!= '' && formObj.ServiceOptions__c!= null && !formObj.ServiceOptions__c.contains(UtilityCls.Dicing)))
            && (formobj.Technology__c == UtilityCls.X32SOI || formobj.Technology__c == UtilityCls.SOI12S0 || formobj.Technology__c == UtilityCls.CMOS_10SF || formobj.Technology__c == UtilityCls.CMOS_10LP || formobj.Technology__c == UtilityCls.CMOS_10RFe 
            || formobj.Technology__c == UtilityCls.CMOS_10LPe || formobj.Technology__c == '45RFSOI')) {
                dispDicingMarks = true;
        } else {
            dispDicingMarks = false;
        }
    }
    
    public void renderNumC4Pads(){
        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.IntConBumpSource__c != UtilityCls.No_21L2039){
            dispNumC4Pads = true;
        }else{
            dispNumC4Pads = false;
        }
    }
    
    public void renderC4SolderMaterial(){
        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c != UtilityCls.No_21L2039){
            dispC4SolderMaterial = true;
        }else{
            dispC4SolderMaterial = false;
        }
    }
    
    public void renderC4LaminatePackage(){
        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.Packaging_Services__c == 'No'){
            dispC4LaminatePackage = true;
        }else{
            dispC4LaminatePackage = false;
        }
    }
}