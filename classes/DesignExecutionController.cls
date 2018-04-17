/********************************************************************
* Author: Sakthi 
* Project: DIW-DesignExecution 
* Name: DesignExecutionController 
* Description: Class is created for inserting/updating DE records and to launch the SignOff/Waiver page
* CreatedDate:
* Modified By :  Abhishek/Sandesh 
* Modified date : 03-Dec-2016  
* Modified date : 18-Apr-2017<Sandesh> added flag cancelDT in enableDisableRITDTButton
* Modified date : 11-May-2017<Sandesh> 
                  Line: 45: Limits initialization with value 10
                  line: 177 & method:enableDisableRITDTButton - addedd condition check for device if cds record is not available for DE record, while data migration. check value of designExecution.Option__r.Device__c    
                  Line: 511 & method:saveExecutionDetail - Update Checkpoint value for clone functionality of RTC RIT A Ready,RTC RIT A Ready,RTM RIT A, RTM RIT B, RTM RIT A Ready, RTM RIT B Ready, RTF RIT A & RTF RIT B 
                  Line: 77 & inside construcotr - Assigned boolean value to enable and disbale button
                  22-June-2017<Sandesh>
                  Line: 838 method returnGeometryFromOpp added, this method take input string and return decimal and same decimal value used in 
                  			method enableDisableRITDTButton to verify Geometry condition from device
*********************************************************************/

public class DesignExecutionController {
    
    public Design_Execution__c designExecution{
        get { if (designExecution == null)designExecution = new Design_Execution__c();
            return designExecution;
        }
        set;
      }
    public String ritAVar{get; set;}
    public String ritBVar{get; set;}     
    public String ritVar1{get; set;}
    public String ritVar2{get; set;}
    public String ritVar3{get; set;}
    public String ritVar4{get; set;}
    public String ritB14LPP{get; set;}
    public String ritA14LPP{get; set;}
    public String ritB7LP{get; set;} 
    public String ritA7LP{get; set;}
    public Device__c dev{get; set;}  
    public boolean EnableIDRActualDate{get; set;}  
    public String recordTypeName {get; set;}  
    public boolean showEditButton{get; set;}
    public boolean showDDbutton{get; set;} 
    public boolean showSignoffbutton{get; set;} 
    public boolean showCheckbox {get; set;}
    public boolean showExportMilestone{get; set;}
    public boolean showWaiverbutton{get; set;} 
    public boolean ExportMilestone ;
    public boolean showPromotetoCustomerDecisionbutton{get; set;}
    public string optionstage;
    public Id deid{get; set;} 
    public string idrDate;
    public boolean createDE; 
    public Date idrActualDate;
    public id cdsId; 
    private final Design_Execution__c acct;
    public string deviceId ;
    public String oppProgId{get; set;}
    public  List<Opportunity_Program_Team_Member__c> acctProxyList {get;set;}
    public integer counter = 0;
    public integer recNum = 0;
    public integer limits {get;set;}
    public Design_Execution__c  de {get;set;}  
    public boolean enableCreateRTDTButton {get;set;}
    public boolean enableRITABSplitButton {get;set;}
    public boolean enablePTRF {get;set;}
    public boolean enablePTRFB {get;set;}
    public boolean enableNONPTRFB {get;set;}
    public boolean cancelDT {get;set;}
    public boolean avoidCallInConst {get;set;}
    public boolean ritOffSetSec1{get; set;}
    public boolean ritOffSetSec2{get; set;}
    public boolean IsritOffSetBtn{get; set;}
    private set<String> listofAssignedPSandProfileName = new set<String>();
   // public DesignExecutionStaticValue__c deOffSet {get; set;}
    
    public DesignExecutionController(){
        
        cdsId = ApexPages.currentPage().getParameters().get('cdsId');
        deid  = ApexPages.currentPage().getParameters().get('deid');
        ritOffSetSec1 = false;
        ritOffSetSec2 = false;
        IsritOffSetBtn = false;
        EnableIDRActualDate = false;
        createDE = false;
        showEditButton =  false;
        showDDbutton  = false;
        showSignoffbutton = false;
        showCheckbox = false;
        showExportMilestone  =false;
        ExportMilestone = false;
        showWaiverbutton = false;
        limits =10;
        showPromotetoCustomerDecisionbutton = false;
        if(deid != null) {
            de = [select id, Customer_Design_Specification__r.CDS_Complete__c, Customer_Design_Specification__r.Initial_Date__c,Customer_Design_Specification__r.IDR_actual_date__c,
                  cancelDT__c,enableCreateRTDTButton__c,enableRITABSplitButton__c, enablePTRF__c,enablePTRFB__c,enableNONPTRFB__c from Design_Execution__c where id =: deid];
        }
        
        //assigned boolean value to enable and disbale button
        enablePTRF = (null != de && de.enablePTRF__c == true?true:false);
        enablePTRFB = (null != de && de.enablePTRFB__c == true?true:false);
        enableCreateRTDTButton = (null != de && de.enableCreateRTDTButton__c == true?true:false);
        enableRITABSplitButton = (null != de && de.enableRITABSplitButton__c == true?true:false);
        cancelDT = (null != de && de.cancelDT__c == true?true:false);
        enableNONPTRFB = (null != de && de.enableNONPTRFB__c == true?true:false);
        
        callCalulateUserAccessMethod();
        
    }
    
    public DesignExecutionController(ApexPages.StandardController stdController) {
        
        deid  = ApexPages.currentPage().getParameters().get('id');
        if(deid == null){
            deid  = ApexPages.currentPage().getParameters().get('deid');
        }
        this.designExecution = (Design_Execution__c)stdController.getRecord();
        ritAVar = '';
        ritBVar = '';
        ritA7LP = '';
        ritB7LP = '';
        ritA14LPP = '';
        ritB14LPP = '';
        ritOffSetSec1 = false;
        ritOffSetSec2 = false;
        IsritOffSetBtn = false;
        createDE = false;
        EnableIDRActualDate = false;
        showEditButton =  false;
        showDDbutton  = false;
        showSignoffbutton = false;
        showCheckbox = false;
        showExportMilestone  =false;
        ExportMilestone = false;
        showWaiverbutton = false;
        showPromotetoCustomerDecisionbutton = false;
        avoidCallInConst =true;
        limits =10;
        if(deid != null) {
            de = [select id, Customer_Design_Specification__r.CDS_Complete__c, Customer_Design_Specification__r.Initial_Date__c,Option__r.Device__c,
                  Customer_Design_Specification__r.Device__r.Geometry__c,Option__r.RIT_Type__c, Option__c,Customer_Design_Specification__r.IDR_actual_date__c,
                  Last_Update_IDR__c, Last_Updated_Commit_Date__c, Last_Updated_Outlook_Date__c, Last_Updated_Actual_Date__c, Last_Updated_No_NL_Del__c, CDS_completion_IDR__c, CDS_completion_Commit_Date__c, CDS_completion_Outlook_Date__c, CDS_completion_Actual_Date__c, Analysis_netlist_delivery_IDR__c, Analysis_netlist_delivery_Commit_Date__c, Analysis_netlist_delivery_Outlook_Date__c, Analysis_netlist_delivery_Actual_Date__c,Analysis_netlist_delivery_No_NL_Del__c, Floorplan_netlist_delivery_IDR__c, Floorplan_netlist_delivery_Commit_Date__c, Floorplan_netlist_delivery_Outlook_Date__c, Floorplan_netlist_delivery_Actual_Date__c, Floorplan_netlist_delivery_No_NL_Del__c, Release_to_Floorplan_IDR__c, Release_to_Floorplan_Commit_Date__c, Release_to_Floorplan_Outlook_Date__c, Release_to_Floorplan_Actual_Date__c, Release_to_Floorplan_No_NL_Del__c, Exit_from_Floorplan_IDR__c, Exit_from_Floorplan_Commit_Date__c, Exit_from_Floorplan_Outlook_Date__c, 
                  Exit_from_Floorplan_Actual_Date__c, Exit_from_Floorplan_No_NL_Del__c, Preliminary_netlist_delivery_IDR__c, Preliminary_ntlst_delivery_Commit_Date__c, Preliminary_ntlst_delivery_Outlook_Date__c, Preliminary_ntlst_delivery_Actual_Date__c, Preliminary_ntlst_delivery_No_NL_Del__c, Release_to_Preliminary_IDR__c, Release_to_Preliminary_Commit_Date__c, Release_to_Preliminary_Actual_Date__c, Release_to_Preliminary_No_NL_Del__c, Exit_from_Preliminary_IDR__c, Exit_from_Preliminary_Commit_Date__c, Exit_from_Preliminary_Outlook_Date__c, Exit_from_Preliminary_Actual_Date__c, Exit_from_Preliminary_No_NL_Del__c, Production_netlist_delivery_IDR__c, Production_netlist_delivery_Commit_Date__c, Production_ntlst_delivery_Outlook_Date__c, Production_netlist_delivery_Actual_Date__c, 
                  Production_netlist_delivery_No_NL_Del__c, Release_to_Layout_IDR__c, Release_to_Layout_Commit_Date__c, Release_to_Layout_Outlook_Date__c, Release_to_Layout_Actual_Date__c, Release_to_Layout_No_NL_Del__c, RTC_DT_ready_IDR__c, RTC_DT_ready_Commit_Date__c, RTC_DT_ready_Outlook_Date__c, RTC_DT_ready_Actual_Date__c, RTC_RIT_B_ready_IDR__c, RTC_RIT_B_ready_Commit_Date__c, RTC_RIT_B_ready_Outlook_Date__c, RTC_RIT_B_ready_Actual_Date__c, RTC_RIT_B_ready_No_NL_Del__c, RTC_RIT_A_ready_IDR__c, RTC_RIT_A_ready_Commit_Date__c, RTC_RIT_A_ready_Outlook_Date__c, RTC_RIT_A_ready_Actual_Date__c, RTC_RIT_A_ready_No_NL_Del__c, RTM_RIT_A_ready_IDR__c, RTM_RIT_A_ready_Commit_Date__c, RTM_RIT_A_ready_Outlook_Date__c, RTM_RIT_A_ready_Actual_Date__c, RTM_RIT_A_ready_No_NL_Del__c, RTM_RIT_B_ready_IDR__c, RTM_RIT_B_ready_Commit_Date__c, RTM_RIT_B_ready_Outlook_Date__c, RTM_RIT_B_ready_Actual_Date__c, 
                  RTM_RIT_B_ready_No_NL_Del__c, RTM_e_Release_IDR__c, RTM_e_Release_Commit_Date__c, RTM_e_Release_Outlook_Date__c, RTM_e_Release_Actual_Date__c, RTM_e_Release_No_NL_Del__c, RTM_e_Release_RIT_A_IDR__c, RTM_e_Release_RIT_A_Commit_Date__c, RTM_e_Release_RIT_A_Outlook_Date__c, RTM_e_Release_RIT_A_Actual_Date__c, RTM_e_Release_RIT_A_No_NL_Del__c, RTM_e_Release_RIT_B_IDR__c, RTM_e_Release_RIT_B_Commit_Date__c, RTM_e_Release_RIT_B_Outlook_Date__c, RTM_e_Release_RIT_B_Actual_Date__c, RTM_e_Release_RIT_B_No_NL_Del__c,RTC_DT_ready_No_NL_Del__c,RTM_DT_ready_Actual_Date__c,RTM_DT_ready_Commit_Date__c,RTM_DT_ready_IDR__c,RTM_DT_ready_No_NL_Del__c,RTM_DT_ready_Outlook_Date__c,
                  CDS_completion_date__c,PTRF_RIT_A_Actual_Date__c,PTRF_RIT_A_Commit_Date__c,PTRF_RIT_A_IDR__c,PTRF_RIT_A_No_NL_Del__c,PTRF_RIT_A_Outlook_Date__c,PTRF_RIT_B_Actual_Date__c,PTRF_RIT_B_Commit_Date__c,PTRF_RIT_B_IDR__c,PTRF_RIT_B_No_NL_Del__c,PTRF_RIT_B_Outlook_Date__c,
                  RTC_Rit_A_B_Ready_Actual_Date__c,RTC_Rit_A_B_Ready_Commit_Date__c,RTC_Rit_A_B_Ready_IDR__c,RTC_Rit_A_B_Ready_No_NL_Del__c,RTC_Rit_A_B_Ready_Outlook_Date__c,
                  RTM_RIT_A_B_ready_Actual_Date__c,RTM_RIT_A_B_ready_Commit_Date__c,RTM_RIT_A_B_ready_IDR__c,RTM_RIT_A_B_ready_No_NL_Del__c,RTM_RIT_A_B_ready_Outlook_Date__c,
                  RTM_RIT_A_B_Actual_Date__c,RTM_RIT_A_B_Commit_Date__c,RTM_RIT_A_B_IDR__c,RTM_RIT_A_B_No_NL_Del__c,RTM_RIT_A_B_Outlook_Date__c,Option__r.Device__r.Geometry__c,
                  RELEASE_TO_PRELIMINARY_OUTLOOK_DATE__C,cancelDT__c,enableCreateRTDTButton__c,enableRITABSplitButton__c,
                  enablePTRF__c,enablePTRFB__c,enableNONPTRFB__c,Rit_A_Off_set__c,Rit_B_Off_set__c
                  from Design_Execution__c where id =: deid];
                  
         ritAVar = de.Rit_A_Off_set__c;
         ritBVar = de.Rit_B_Off_set__c;
                  
	      List<PermissionSetAssignment> permissionset = [SELECT PermissionSetId, PermissionSet.Name, PermissionSet.Label, Assignee.Profile.Name FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId()];
	        for(PermissionSetAssignment psa : permissionset){
	            if(psa.PermissionSet.Name == 'DIW_Customer_Focal_Point' || psa.PermissionSet.Name == 'DIW_Design_Center_Engineer' || psa.PermissionSet.Name == 'DIW_Packaging_Engineer'){
	                IsritOffSetBtn = true;    
	            }   
	        }
                   
          	dev = [SELECT Id,Opportunity2__r.Target_Process_Node__c FROM Device__c WHERE id =: de.option__r.device__c];
            if(dev.Opportunity2__r.Target_Process_Node__c =='14LPP'){
                ritOffSetSec1 = true;
                ritOffSetSec2 = false;
                IsritOffSetBtn = true;
            }
            else if(dev.Opportunity2__r.Target_Process_Node__c =='7LP'){
                ritOffSetSec1 = false;
                ritOffSetSec2 = true;
                IsritOffSetBtn = true;
            }
            else {
            	IsritOffSetBtn = false;
            }             
        }
        List<DesignExecutionStaticValue__c> deOffSet = [Select Id, Off_Set_A_7LP__c,Off_Set_B_7LP__c,Off_Set_A_14LPP__c,Off_Set_B_14LPP__c From DesignExecutionStaticValue__c where Off_Set_A_7LP__c != null OR Off_Set_B_7LP__c != null OR Off_Set_A_14LPP__c != null OR Off_Set_B_14LPP__c != null];
        if(deOffSet.size()>0){
            for(DesignExecutionStaticValue__c deOffSetObj : deOffSet){
                ritB14LPP = string.valueof(deOffSetObj.Off_Set_B_14LPP__c);    
                ritA14LPP = String.valueOf(deOffSetObj.Off_Set_A_14LPP__c);
                ritB7LP = String.valueOf(deOffSetObj.Off_Set_B_7LP__c); 
                ritA7LP = String.valueOf(deOffSetObj.Off_Set_A_7LP__c);    
            }    
        } 
      		

        
        //Assigned boolean value to enable and disbale button
        enablePTRF = (null != de && de.enablePTRF__c == true?true:false);
        enablePTRFB = (null != de && de.enablePTRFB__c == true?true:false);
        enableCreateRTDTButton = (null != de && de.enableCreateRTDTButton__c == true?true:false);
        enableRITABSplitButton = (null != de && de.enableRITABSplitButton__c == true?true:false);
        cancelDT = (null != de && de.cancelDT__c == true?true:false);
        enableNONPTRFB = (null != de && de.enableNONPTRFB__c == true?true:false);
        avoidCallInConst =true;
        
        callCalulateUserAccessMethod();
        enableDisableRITDTButton();
    }
    
    
    /*   *************************************    
    @ Name -  enableDisableRITDTButton
    @ Description -  Create Enable & disable Create DT & RIT A/B Split button, based on button RTC & RTM record can group
    @ Parameter - None
    @ Return Type - 
    @ Created By - Sandesh Singh
    ****************************************
    */
    public PageReference enableDisableRITDTButton(){
        designExecution = de;
        Boolean showCreateDT = false;
        Boolean showSplitAB = false; 
        Decimal processGeometry = 0.00;
        String geometryCustSetStr = DesignExecutionStaticValue__c.getvalues('DeviceGeometry').value__c;
		Decimal geometryDecFromCustSetStr = Decimal.valueOf(geometryCustSetStr); 
        
		processGeometry =(designExecution !=null && designExecution.Customer_Design_Specification__c !=null && designExecution.Customer_Design_Specification__r.Device__c !=null)? 
							returnGeometryFromOpp(designExecution.Customer_Design_Specification__r.Device__r.Geometry__c):
							(designExecution !=null && designExecution.Option__c  !=null && designExecution.Option__r.Device__c  !=null ?
								returnGeometryFromOpp(designExecution.Option__r.Device__r.Geometry__c):0.00);
		
        //set showCreateDT true or false from custom setting permission setup data entry
        for(string accessLevel: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(accessLevel);
            if(dePermission != null) {
                if(dePermission.Create_DT__c == true) {
                    showCreateDT = true;
                    break;
                }
            }
        }
        //set showSplitAB true or false from custom setting permission setup data entry
        for(string accessLevel: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(accessLevel);
            if(dePermission != null) {
                if(dePermission.RIT_A_B_Split__c == false) {
                    showSplitAB = false;
                    break;
                }
            }
        }
        
        
        //Default data view
        //If RIT Type field is 'A/B' or 'A/B R' (RIT_Type__c on Options) and Geometry field on Device Geometry_c >22um and showCreateDT is true 
        //then enable CreateDT button and show default view data
        if(!(enableCreateRTDTButton && cancelDT) && showCreateDT && designExecution !=null && designExecution.Option__c !=null && designExecution.Option__r.RIT_Type__c !=null 
            && (designExecution.Option__r.RIT_Type__c.equals('A/B') || designExecution.Option__r.RIT_Type__c.equals('A/B R'))
            && processGeometry >geometryDecFromCustSetStr && (!enableRITABSplitButton && !enableCreateRTDTButton)){
            		enableCreateRTDTButton =true;
            		cancelDT =true;
                
        }
        //enablePTRF equalhttps://globalfoundries--diwsit.cs31.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage# true
        // If RIT Type field is 'A/B' or A/B R and Geometry =< 22um && showSplitAB =true
        // addedd condition check for device if cds record is not available for DE record, while data migration. check value of designExecution.Option__r.Device__c 
        // then enable RIT A/B Split Button
        if(!(enableCreateRTDTButton && enablePTRF) && showCreateDT && designExecution !=null && designExecution.Option__c !=null && designExecution.Option__r.RIT_Type__c !=null 
            && (designExecution.Option__r.RIT_Type__c.equals('A/B') || designExecution.Option__r.RIT_Type__c.equals('A/B R'))
            && processGeometry <=geometryDecFromCustSetStr){
                if(!enableRITABSplitButton && !enableCreateRTDTButton){
	                enableCreateRTDTButton =true;
                }
                enablePTRF = true;
                cancelDT = false;
        }
        
        //enablePTRFB & enableNONPTRFB equal true 
        //If RIT Type field is 'B' or 'B R' and Geometry <=22nm
        //addedd condition check for device if cds record is not available for DE record, while data migration. check value of designExecution.Option__r.Device__c 
        //Then show only the Bs not the A check points:-
        //PTRF Rit B, RTM RIT B Ready , RTM Rit B
        if(designExecution !=null && designExecution.Option__c !=null && designExecution.Option__r.RIT_Type__c !=null 
            && (designExecution.Option__r.RIT_Type__c.equals('B') || designExecution.Option__r.RIT_Type__c.equals('B R'))){
                if(!enablePTRFB && processGeometry <=geometryDecFromCustSetStr){
                    	enablePTRFB = true;
                } 
                else if(!enableNONPTRFB && processGeometry >geometryDecFromCustSetStr){
                    enableNONPTRFB = true;
                } 
                enableRITABSplitButton = false;
            	enableCreateRTDTButton = false;
            	cancelDT = false;
               
        }  
        
        //Avoide DE record update from constructor call
        if(!avoidCallInConst){
            try{           
                designExecution.enableCreateRTDTButton__c =enableCreateRTDTButton;
                designExecution.enableNONPTRFB__c = enableNONPTRFB;
                designExecution.enablePTRF__c =enablePTRF;
                designExecution.enablePTRFB__c=enablePTRFB;
                designExecution.enableRITABSplitButton__c=enableRITABSplitButton;
                designExecution.cancelDT__c=cancelDT;
                update designExecution;
            }
            catch(exception e){
            GlobalUtility.logMessage('Error','DesignExecutionController','doUpdate','','Exception while Updating the Design Execution record',String.valueof(e.getMessage()),'','Design Execution',e,0);
            return null;
           }  
            
        }
        
        
        
        return null;
    }
    
    
    /*   *************************************    
    @ Name -  goToDesignExecution
    @ Description -  Create Design Execution records
    @ Parameter - None
    @ Return Type - 
    @ Created By - Abhishek Srivastava
    ****************************************
    */
    public PageReference goToDesignExecution() {
        
        try{
            PageReference pageRef, ref;
            Design_Execution__c designExecution;
            List<Custom_Design__c> listOfCDSrecords = new List<Custom_Design__c>();
            List<Tech_Review_Summary__c> listOftechreviewrecords = new List<Tech_Review_Summary__c>();
            Design_Execution__c deRecords = new Design_Execution__c();
            Custom_Design__c customDesign= [select id, Initial_Date__c , IDR_actual_date__c,DIW_Option_Control_Number__r.name,DIW_Option_Control_Number__r.Opportunity__c, DIW_Opp_Control_Number__r.name,DIW_Opp_Control_Number__c, DIW_Option_Control_Number__c from Custom_Design__c where id =: cdsId];
            if(customDesign!= null && customDesign.Id != null ){
                Design_Execution__c checkderecord = DesignExecutionUtility.fetchDErecordsbyCDS(customDesign.id);                        
                if(checkderecord.id == null){
                    listOfCDSrecords = [select id,Initial_Date__c ,DIW_Option_Control_Number__r.name, DIW_Opp_Control_Number__r.name,DIW_Opp_Control_Number__c, DIW_Option_Control_Number__c from Custom_Design__c where id =: cdsId];
                    if(listOfCDSrecords.size()>0){
                        deRecords.Customer_Design_Specification__c = cdsId;
                        deRecords.Opportunity__c = customDesign.DIW_Opp_Control_Number__c; //DIW_Option_Control_Number__r.Opportunity__c;//DIW_Opp_Control_Number__c; 
                        deRecords.Option__c = customDesign.DIW_Option_Control_Number__c;
                        deRecords.CDS_completion_date__c = customDesign.IDR_actual_date__c;
                        system.debug('%%%%%deRecords%%%%%%%%' + deRecords);
                        if(createDE == true){
                            insert deRecords;        
                        }
                        else{
                            ref = new PageReference('/apex/DesignExecutionInfo');
                            ref.setRedirect(true);
                            //return ref;
                        }     
                    }
                    BnP_OptionUtility  bnpOption = new BnP_OptionUtility();                            
                    bnpOption.updateOptionStages(new List<Id>{derecords.Option__c}, 'Design Execution');                           
                    bnpOption.updateCDSStatus(new List<Id>{derecords.Customer_Design_Specification__c}, 'In DE');                       
                }
                //designExecution = DesignExecutionUtility.fetchDErecords(cdsid);
                if(deRecords.id != null){
                    pageRef = new pageReference('/apex/DesignExecutionRead?deid='+deRecords.id);
                    pageRef.setRedirect(true);
                }
                if(checkderecord.id != null){
                    pageRef = new pageReference('/apex/DesignExecutionRead?deid='+checkderecord.id);
                    pageRef.setRedirect(true);
                }
            }
            if(pageRef != null) {
                return pageRef;
            } else {
                return ref;
            }
        }
        catch(exception e){
            GlobalUtility.logMessage('Error','DesignExecutionController','doInsert','','Exception while inserting the Design Execution record',String.valueof(e.getMessage()),'','Design Execution',e,0);
            return null;
        }    
    }
    
    /**
    * @description Action Method for creating DE records based on permission set
    * @param  No Parameter
    * @return  Pagereference
    */
    public PageReference createDesignExecutionRecord(){
    
        designExecution = DesignExecutionUtility.fetchDErecords(deid);
        optionstage = designExecution.Option__r.Option_Stage__c ;                   
        if(ExportMilestone == true){
     // kushal commented 2/15 and added below line-- if (designExecution.RTM_RIT_A_ready_Actual_Date__c != null && designExecution.RTM_RIT_B_ready_Actual_Date__c != null && designExecution.RTM_e_Release_Actual_Date__c != null && designExecution.RTM_e_Release_RIT_A_Actual_Date__c != null && designExecution.RTM_e_Release_RIT_B_Actual_Date__c != null){
                  if (designExecution.RTM_e_Release_RIT_A_Actual_Date__c != null && designExecution.RTM_e_Release_RIT_B_Actual_Date__c != null){     
                    showExportMilestone = true;
                }
        }
                
        if(designExecution.Option__r.Option_Stage__c == 'Prototype Fulfillment'){
            showPromotetoCustomerDecisionbutton = true;
            optionstage = DesignExecutionUtility.fetchDErecords(cdsid).Option__r.Option_Stage__c ;
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Prototype ship date needs to be filled into device PSP under "Actual Prototype Ship Date"');
            apexpages.addmessage(msg);    
        }
        
        deviceId = designExecution.Customer_Design_Specification__r.Device__c;
        Device__c devInfo;
        if(deviceId != null){
            devInfo = [SELECT Primary_Option__c,Opportunity_Program__c FROM Device__c WHERE Id = :deviceId ]; 
            oppProgId = devInfo.Opportunity_Program__c;
        }
        
        string strn = Label.DesignExecutionTeamRole;
        List<String> teamRoles =strn.split('\\|');        
        recNum = [SELECT count() FROM Opportunity_Program_Team_Member__c WHERE Team_Role__c in :teamRoles and Opportunity_Id__c =: designexecution.Opportunity__c ];
        //recNum = actProxyList.size();
        
        populateRelatedLists();
        return null;
        
    }        
    
    //Method for Showing/Hiding button bsaed on Permission set
    private void callCalulateUserAccessMethod(){
        List<PermissionSetAssignment> listOfUserPS = [SELECT PermissionSetId, PermissionSet.Name, PermissionSet.Label, Assignee.Profile.Name FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId()];
        set<String> listofPSName = new set<String>();
        set<String> listofProfileName = new set<String>();
        //set<String> listofAssignedPSandProfileName = new set<String>();
        Map<String, DesignExecutionPermission__c> psValues = DesignExecutionPermission__c.getAll();

        for(PermissionSetAssignment dep : listOfUserPS ){
            if(psValues.containsKey(dep.PermissionSet.Label)) {
                listofPSName.add(dep.PermissionSet.Label);
            }
            if(psValues.containsKey(dep.Assignee.Profile.Name)) {
                listofProfileName.add(dep.Assignee.Profile.Name);
            }
        }
        listofAssignedPSandProfileName.addAll(listofProfileName);
        listofAssignedPSandProfileName.addAll(listofPSName);
        system.debug('listofAssignedPSandProfileName::'+listofAssignedPSandProfileName);
        
        //Create_DE__c
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.Create_DE__c == true) {
                    createDE = true;
                    break;
                }
            }
        }   
        system.debug('createDE:::'+createDE);
        //Edit_DE__c
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.Edit_DE__c == true) {
                    showEditButton = true;
                    break;
                }
            }
        }   

        //Export_DE__c
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.Export_DE__c == true) {
                    showDDbutton = true;
                    break;
                }
            }
        }   

        //Promote_SignOff__c
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.Promote_SignOff__c == true) {
                    showSignoffbutton = true;
                    break;
                }
            }
        }   

        //Promote_Waiver__c
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.Promote_Waiver__c == true) {
                    showWaiverbutton = true;
                    break;
                }
            }
        }
        //Export MileStone and DCE checkbox
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.Export_MileStone__c == true){
                    ExportMilestone  =true;
                }
            }
        }
        
        //Edit IDR Actual date
        for(string s: listofAssignedPSandProfileName) {
            DesignExecutionPermission__c dePermission = DesignExecutionPermission__c.getValues(s);
            if(dePermission != null) {
                if(dePermission.EditIDRActualDate__c == true) {
                    EnableIDRActualDate = true;
                    break;
                }
            }
        }
    }
    
    
    
    public void populateRelatedLists(){
        
        system.debug('oppid' + designexecution.Opportunity__c );
        //teamRole = new Set<String>{'Field Design Center Engineer','Physical Design Engineer','Product Engineer'};
        string str = Label.DesignExecutionTeamRole;
        List<String> teamRole =str.split('\\|');
        //acctProxyList = Database.Query('SELECT User__r.address,User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c LIMIT :blockSize OFFSET :index') ;
        acctProxyList = [SELECT User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c WHERE Team_Role__c in :teamRole and Opportunity_Id__c =: designexecution.Opportunity__c LIMIT :limits OFFSET: counter ];
        //recNum = actProxyList.size();
    }
    
    
    /**
    * @description Method for updating the design execution record with checkpoint 
    * @param  No Parameter
    * @return  Pagereference
    */      
    public Pagereference saveExecutionDetail(){
    	
        if(ritVar3 != '' && ritVar3 != null){
          designExecution.Rit_A_Off_set__c = ritVar3;  
        }       
        if(ritVar1 != '' && ritVar1 != null){
        designExecution.Rit_A_Off_set__c = ritVar1;
        }
        if(ritVar4 != '' && ritVar4 != null){
        designExecution.Rit_B_Off_set__c = ritVar4;
        }
        if(ritVar2 != '' && ritVar2 != null){
        designExecution.Rit_B_Off_set__c = ritVar2;
        } 
        id derecid;
      try{
          system.debug('%%%%%%' + designExecution);
          if(null !=designExecution){
              if(designExecution.Last_Update_IDR__c==null){
                designExecution.Last_Update_IDR__c=designExecution.Last_Updated_Commit_Date__c;
              }
              if(designExecution.CDS_completion_IDR__c==null){
                designExecution.CDS_completion_IDR__c=designExecution.CDS_completion_Commit_Date__c;
              }              
              if(designExecution.Analysis_netlist_delivery_IDR__c==null){
                designExecution.Analysis_netlist_delivery_IDR__c=designExecution.Analysis_netlist_delivery_Commit_Date__c;
              }
              if(designExecution.Floorplan_netlist_delivery_IDR__c==null){
                designExecution.Floorplan_netlist_delivery_IDR__c=designExecution.Floorplan_netlist_delivery_Commit_Date__c;
              }
              if(designExecution.Release_to_Floorplan_IDR__c==null){
                designExecution.Release_to_Floorplan_IDR__c=designExecution.Release_to_Floorplan_Commit_Date__c;
              }
              if(designExecution.Exit_from_Floorplan_IDR__c==null){
                 designExecution.Exit_from_Floorplan_IDR__c=designExecution.Exit_from_Floorplan_Commit_Date__c;
              }
              if(designExecution.Preliminary_netlist_delivery_IDR__c==null){
                 designExecution.Preliminary_netlist_delivery_IDR__c=designExecution.Preliminary_ntlst_delivery_Commit_Date__c;
              }
              if(designExecution.Release_to_Preliminary_IDR__c==null){
                 designExecution.Release_to_Preliminary_IDR__c=designExecution.Release_to_Preliminary_Commit_Date__c;
              }
              if(designExecution.Exit_from_Preliminary_IDR__c==null){
                 designExecution.Exit_from_Preliminary_IDR__c=designExecution.Exit_from_Preliminary_Commit_Date__c;
              }
              if(designExecution.Production_netlist_delivery_IDR__c==null){
                 designExecution.Production_netlist_delivery_IDR__c=designExecution.Production_netlist_delivery_Commit_Date__c;
              }
              if(designExecution.Release_to_Layout_IDR__c==null){
                 designExecution.Release_to_Layout_IDR__c=designExecution.Release_to_Layout_Commit_Date__c;
              }
              if(designExecution.RTC_DT_ready_IDR__c==null){
                 designExecution.RTC_DT_ready_IDR__c=designExecution.RTC_DT_ready_Commit_Date__c;
              }
              if(designExecution.RTM_DT_ready_IDR__c==null){
                 designExecution.RTM_DT_ready_IDR__c=designExecution.RTM_DT_ready_Commit_Date__c;
              }
              
              
              //Update Checkpoint value for clone functionality of RTC RIT A Ready,RTC RIT A Ready,RTM RIT A, RTM RIT B, RTM RIT A Ready, RTM RIT B Ready, RTF RIT A & RTF RIT B  
              if(designExecution.RTM_RIT_A_B_IDR__c ==null){
                  designExecution.RTM_RIT_A_B_IDR__c = designExecution.RTM_RIT_A_B_Commit_Date__c;
              }
              designExecution.RTM_e_Release_RIT_A_Actual_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_Actual_Date__c?designExecution.RTM_RIT_A_B_Actual_Date__c:designExecution.RTM_e_Release_RIT_A_Actual_Date__c);
              designExecution.RTM_e_Release_RIT_A_Commit_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_Commit_Date__c?designExecution.RTM_RIT_A_B_Commit_Date__c:designExecution.RTM_e_Release_RIT_A_Commit_Date__c);   
              designExecution.RTM_e_Release_RIT_A_No_NL_Del__c =String.valueOf(null !=designExecution.RTM_RIT_A_B_No_NL_Del__c?designExecution.RTM_RIT_A_B_No_NL_Del__c:designExecution.RTM_e_Release_RIT_A_No_NL_Del__c);
              designExecution.RTM_e_Release_RIT_A_Outlook_Date__c=Date.valueOf(null!=designExecution.RTM_RIT_A_B_Outlook_Date__c?designExecution.RTM_RIT_A_B_Outlook_Date__c:designExecution.RTM_e_Release_RIT_A_Outlook_Date__c);
              
              designExecution.RTM_e_Release_RIT_B_Actual_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_Actual_Date__c?designExecution.RTM_RIT_A_B_Actual_Date__c:designExecution.RTM_e_Release_RIT_B_Actual_Date__c);
              designExecution.RTM_e_Release_RIT_B_Commit_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_Commit_Date__c?designExecution.RTM_RIT_A_B_Commit_Date__c:designExecution.RTM_e_Release_RIT_B_Commit_Date__c);
              designExecution.RTM_e_Release_RIT_B_No_NL_Del__c =String.valueOf(null !=designExecution.RTM_RIT_A_B_No_NL_Del__c?designExecution.RTM_RIT_A_B_No_NL_Del__c:designExecution.RTM_e_Release_RIT_B_No_NL_Del__c);
              designExecution.RTM_e_Release_RIT_B_Outlook_Date__c= Date.valueOf(null!=designExecution.RTM_RIT_A_B_Outlook_Date__c?designExecution.RTM_RIT_A_B_Outlook_Date__c:designExecution.RTM_e_Release_RIT_B_Outlook_Date__c);
              
              if(designExecution.RTM_RIT_A_B_ready_IDR__c ==null){
                  designExecution.RTM_RIT_A_B_ready_IDR__c = designExecution.RTM_RIT_A_B_ready_Commit_Date__c;
              }
              designExecution.RTM_RIT_A_ready_Actual_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_ready_Actual_Date__c?designExecution.RTM_RIT_A_B_ready_Actual_Date__c:designExecution.RTM_RIT_A_ready_Actual_Date__c);
              designExecution.RTM_RIT_A_ready_Commit_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_ready_Commit_Date__c?designExecution.RTM_RIT_A_B_ready_Commit_Date__c:designExecution.RTM_RIT_A_ready_Commit_Date__c);   
              designExecution.RTM_RIT_A_ready_No_NL_Del__c =String.valueOf(null !=designExecution.RTM_RIT_A_B_ready_No_NL_Del__c?designExecution.RTM_RIT_A_B_ready_No_NL_Del__c:designExecution.RTM_RIT_A_ready_No_NL_Del__c);
              designExecution.RTM_RIT_A_ready_Outlook_Date__c=Date.valueOf(null!=designExecution.RTM_RIT_A_B_ready_Outlook_Date__c?designExecution.RTM_RIT_A_B_ready_Outlook_Date__c:designExecution.RTM_RIT_A_ready_Outlook_Date__c);
              
              designExecution.RTM_RIT_B_ready_Actual_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_ready_Actual_Date__c?designExecution.RTM_RIT_A_B_ready_Actual_Date__c:designExecution.RTM_RIT_B_ready_Actual_Date__c);
              designExecution.RTM_RIT_B_ready_Commit_Date__c = Date.valueOf(null !=designExecution.RTM_RIT_A_B_ready_Commit_Date__c?designExecution.RTM_RIT_A_B_ready_Commit_Date__c:designExecution.RTM_RIT_B_ready_Commit_Date__c); 
              designExecution.RTM_RIT_B_ready_No_NL_Del__c =String.valueOf(null !=designExecution.RTM_RIT_A_B_ready_No_NL_Del__c?designExecution.RTM_RIT_A_B_ready_No_NL_Del__c:designExecution.RTM_RIT_B_ready_No_NL_Del__c);
              designExecution.RTM_RIT_B_ready_Outlook_Date__c= Date.valueOf(null!=designExecution.RTM_RIT_A_B_ready_Outlook_Date__c?designExecution.RTM_RIT_A_B_ready_Outlook_Date__c:designExecution.RTM_RIT_B_ready_Outlook_Date__c);
              
              
              if(designExecution.RTC_Rit_A_B_Ready_IDR__c ==null){
                  designExecution.RTC_Rit_A_B_Ready_IDR__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c;
              }
              designExecution.RTC_Rit_A_Ready_Actual_Date__c=Date.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_Actual_Date__c?designExecution.RTC_Rit_A_B_Ready_Actual_Date__c:designExecution.RTC_Rit_A_Ready_Actual_Date__c);
              designExecution.RTC_Rit_A_Ready_Commit_Date__c=Date.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_Commit_Date__c?designExecution.RTC_Rit_A_B_Ready_Commit_Date__c:designExecution.RTC_Rit_A_Ready_Commit_Date__c);
              designExecution.RTC_Rit_A_Ready_No_NL_Del__c=String.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_No_NL_Del__c?designExecution.RTC_Rit_A_B_Ready_No_NL_Del__c:designExecution.RTC_Rit_A_Ready_No_NL_Del__c);
              designExecution.RTC_Rit_A_Ready_Outlook_Date__c=Date.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c?designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c:designExecution.RTC_Rit_A_Ready_Outlook_Date__c);
              
              designExecution.RTC_Rit_B_Ready_Actual_Date__c= Date.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_Actual_Date__c?designExecution.RTC_Rit_A_B_Ready_Actual_Date__c:designExecution.RTC_Rit_B_Ready_Actual_Date__c);
              designExecution.RTC_Rit_B_Ready_Commit_Date__c= Date.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_Commit_Date__c?designExecution.RTC_Rit_A_B_Ready_Commit_Date__c:designExecution.RTC_Rit_B_Ready_Commit_Date__c);
              designExecution.RTC_Rit_B_Ready_No_NL_Del__c= String.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_No_NL_Del__c?designExecution.RTC_Rit_A_B_Ready_No_NL_Del__c:designExecution.RTC_Rit_B_Ready_No_NL_Del__c);
              designExecution.RTC_Rit_B_Ready_Outlook_Date__c= Date.valueOf(null!=designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c?designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c:designExecution.RTC_Rit_B_Ready_Outlook_Date__c);
              
              if(designExecution.PTRF_RIT_A_B_IDR__c ==null){
                  designExecution.PTRF_RIT_A_B_IDR__c = designExecution.PTRF_RIT_A_B_Commit_Date__c;
              }
              designExecution.PTRF_RIT_A_Actual_Date__c = Date.valueOf(null !=designExecution.PTRF_RIT_A_B_Actual_Date__c?designExecution.PTRF_RIT_A_B_Actual_Date__c:designExecution.PTRF_RIT_A_Actual_Date__c);
              designExecution.PTRF_RIT_A_Commit_Date__c = Date.valueOf(null !=designExecution.PTRF_RIT_A_B_Commit_Date__c?designExecution.PTRF_RIT_A_B_Commit_Date__c:designExecution.PTRF_RIT_A_Commit_Date__c);   
              designExecution.PTRF_RIT_A_No_NL_Del__c =String.valueOf(null !=designExecution.PTRF_RIT_A_B_No_NL_Del__c?designExecution.PTRF_RIT_A_B_No_NL_Del__c:designExecution.PTRF_RIT_A_No_NL_Del__c);
              designExecution.PTRF_RIT_A_Outlook_Date__c=Date.valueOf(null!=designExecution.PTRF_RIT_A_B_Outlook_Date__c?designExecution.PTRF_RIT_A_B_Outlook_Date__c:designExecution.PTRF_RIT_A_Outlook_Date__c);
              
              designExecution.PTRF_RIT_B_Actual_Date__c = Date.valueOf(null !=designExecution.PTRF_RIT_A_B_Actual_Date__c?designExecution.PTRF_RIT_A_B_Actual_Date__c:designExecution.PTRF_RIT_B_Actual_Date__c);
              designExecution.PTRF_RIT_B_Commit_Date__c = Date.valueOf(null !=designExecution.PTRF_RIT_A_B_Commit_Date__c?designExecution.PTRF_RIT_A_B_Commit_Date__c:designExecution.PTRF_RIT_B_Commit_Date__c);   
              designExecution.PTRF_RIT_B_No_NL_Del__c =String.valueOf(null !=designExecution.PTRF_RIT_A_B_No_NL_Del__c?designExecution.PTRF_RIT_A_B_No_NL_Del__c:designExecution.PTRF_RIT_B_No_NL_Del__c);
              designExecution.PTRF_RIT_B_Outlook_Date__c= Date.valueOf(null!=designExecution.PTRF_RIT_A_B_Outlook_Date__c?designExecution.PTRF_RIT_A_B_Outlook_Date__c:designExecution.PTRF_RIT_B_Outlook_Date__c);
              
              
              if(designExecution.RTC_RIT_A_ready_IDR__c==null){
                 designExecution.RTC_RIT_A_ready_IDR__c=designExecution.RTC_RIT_A_ready_Commit_Date__c;
              }
              if(designExecution.RTC_RIT_B_ready_IDR__c==null){
                 designExecution.RTC_RIT_B_ready_IDR__c=designExecution.RTC_RIT_B_ready_Commit_Date__c;
              }
              if(designExecution.RTM_RIT_A_ready_IDR__c==null){
                 designExecution.RTM_RIT_A_ready_IDR__c=designExecution.RTM_RIT_A_ready_Commit_Date__c;
              }
              if(designExecution.RTM_RIT_B_ready_IDR__c==null){
                 designExecution.RTM_RIT_B_ready_IDR__c=designExecution.RTM_RIT_B_ready_Commit_Date__c;
              }
              if(designExecution.RTM_e_Release_IDR__c==null){
                 designExecution.RTM_e_Release_IDR__c=designExecution.RTM_e_Release_Commit_Date__c;
              }
              if(designExecution.RTM_e_Release_RIT_A_IDR__c==null){
                 designExecution.RTM_e_Release_RIT_A_IDR__c=designExecution.RTM_e_Release_RIT_A_Commit_Date__c;
              }
              if(designExecution.RTM_e_Release_RIT_B_IDR__c==null){
                 designExecution.RTM_e_Release_RIT_B_IDR__c=designExecution.RTM_e_Release_RIT_B_Commit_Date__c;
              }
              if(designExecution.PTRF_RIT_B_IDR__c==null){
                 designExecution.PTRF_RIT_B_IDR__c=designExecution.PTRF_RIT_B_Commit_Date__c;
              }
              if(designExecution.PTRF_RIT_a_IDR__c==null){
                 designExecution.PTRF_RIT_A_IDR__c=designExecution.PTRF_RIT_A_Commit_Date__c;
              }
              dev = [SELECT Id, Opportunity2__r.Target_Process_Node__c FROM Device__c WHERE id =: designExecution.option__r.device__c];
              if(dev.Opportunity2__r.Target_Process_Node__c == '14LPP'){
                  if(designExecution.RTC_RIT_A_ready_Commit_Date__c != null && designExecution.RTC_RIT_A_ready_Outlook_Date__c == null){
                      if(ritVar3 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                      designExecution.PTRF_RIT_A_Commit_Date__c = designExecution.RTC_RIT_A_ready_Commit_Date__c.addDays(Integer.valueOf(ritA14LPP));    
                      } else if(ritVar3 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                      designExecution.PTRF_RIT_A_Commit_Date__c = designExecution.RTC_RIT_A_ready_Commit_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c)); 
                      } else if(ritVar3 != null && ritVar3 != ''){
                      	designExecution.PTRF_RIT_A_Commit_Date__c = designExecution.RTC_RIT_A_ready_Commit_Date__c.addDays(Integer.valueOf(ritVar3));     
                      }
                  }
                  if(designExecution.RTC_RIT_A_ready_Outlook_Date__c != null && designExecution.RTC_RIT_A_ready_Commit_Date__c == null){
                      if(ritVar3 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritA14LPP));       
                      } else if(ritVar3 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                    	designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar3 != null && ritVar3 != ''){
                      	designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar3));	    
                      }
                  }
                  if(designExecution.RTC_RIT_A_ready_Outlook_Date__c != null && designExecution.RTC_RIT_A_ready_Commit_Date__c != null){
                      if(ritVar3 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritA14LPP));      
                      } else if(ritVar3 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar3 != null && ritVar3 != ''){
                      	designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar3));	    
                      }
                  }
                  if(designExecution.RTC_RIT_B_ready_Commit_Date__c != null && designExecution.RTC_RIT_B_ready_Outlook_Date__c == null){
                      if(ritVar4 == null && (designExecution.Rit_B_Off_set__c == null || designExecution.Rit_B_Off_set__c == '')){
                        designExecution.PTRF_RIT_B_Commit_Date__c = designExecution.RTC_RIT_B_ready_Commit_Date__c.addDays(Integer.valueOf(ritB14LPP));      
                      } else if(ritVar4 == null && designExecution.Rit_B_Off_set__c != null && designExecution.Rit_B_Off_set__c != ''){
                        designExecution.PTRF_RIT_B_Commit_Date__c = designExecution.RTC_RIT_B_ready_Commit_Date__c.addDays(Integer.valueOf(designExecution.Rit_B_Off_set__c));     
                      } else if(ritVar4 != null && ritVar4 != ''){
                      	designExecution.PTRF_RIT_B_Commit_Date__c = designExecution.RTC_RIT_B_ready_Commit_Date__c.addDays(Integer.valueOf(ritVar4));                         
                      }                     
                  }
                  if(designExecution.RTC_RIT_B_ready_Outlook_Date__c != null && designExecution.RTC_RIT_B_ready_Commit_Date__c == null){
                      if(ritVar4 == null && (designExecution.Rit_B_Off_set__c == null || designExecution.Rit_B_Off_set__c == '')){
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritB14LPP));    
                      } else if(ritVar4 == null && designExecution.Rit_B_Off_set__c != null && designExecution.Rit_B_Off_set__c != ''){ 
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_B_Off_set__c));
                      } else if(ritVar4 != null && ritVar4 != ''){
                      	designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar4));    
                      }
                  }
                  if(designExecution.RTC_RIT_B_ready_Outlook_Date__c != null && designExecution.RTC_RIT_B_ready_Commit_Date__c != null){
                      if(ritVar4 == null && (designExecution.Rit_B_Off_set__c == null || designExecution.Rit_B_Off_set__c == '')){
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritB14LPP));    
                      } else if(ritVar4 == null && designExecution.Rit_B_Off_set__c != null && designExecution.Rit_B_Off_set__c != ''){ 
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_B_Off_set__c));
                      } else if(ritVar4 != null && ritVar4 != ''){
                      	designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar4));    
                      }      
                  }
                  if(designExecution.RTC_Rit_A_B_Ready_Commit_Date__c !=null && designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c == null){
                      if(ritVar3 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_B_Commit_Date__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c.addDays(Integer.valueOf(ritA14LPP));     
                      } else if(ritVar3 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_B_Commit_Date__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar3 != null && ritVar3 != ''){
                      	designExecution.PTRF_RIT_A_B_Commit_Date__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c.addDays(Integer.valueOf(ritVar3));    
                      }
                  }
                  if(designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c != null && designExecution.RTC_Rit_A_B_Ready_Commit_Date__c == null){
                      if(ritVar3 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritA14LPP));       
                      } else if(ritVar3 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){ 
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar3 != null && ritVar3 != ''){
                      	designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar3));    
                      }
                  }
                  if(designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c != null && designExecution.RTC_Rit_A_B_Ready_Commit_Date__c !=null){
                      if(ritVar3  == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritA14LPP));    
                      } else if(ritVar3 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar3 != null && ritVar3 != ''){
                      	designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar3));    
                      }
                  }
              }  else if(dev.Opportunity2__r.Target_Process_Node__c == '7LP'){
                  system.debug('ritVar1*:'+ritVar1);
                  if(designExecution.RTC_RIT_A_ready_Commit_Date__c != null && designExecution.RTC_RIT_A_ready_Outlook_Date__c == null){
                      if(ritVar1 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_Commit_Date__c = designExecution.RTC_RIT_A_ready_Commit_Date__c.addDays(Integer.valueOf(ritA7LP));     
                      } else if(ritVar1 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != '') {
                        designExecution.PTRF_RIT_A_Commit_Date__c = designExecution.RTC_RIT_A_ready_Commit_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar1 != null && ritVar1 != ''){
                      	designExecution.PTRF_RIT_A_Commit_Date__c = designExecution.RTC_RIT_A_ready_Commit_Date__c.addDays(Integer.valueOf(ritVar1));    
                      }
                  } 
                  if(designExecution.RTC_RIT_A_ready_Outlook_Date__c != null && designExecution.RTC_RIT_A_ready_Commit_Date__c == null){
                      if(ritVar1 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritA7LP));      
                      } else if(ritVar1 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar1 != null && ritVar1 != ''){
                      	designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar1));	    
                      }
                  }
                  if(designExecution.RTC_RIT_A_ready_Outlook_Date__c != null && designExecution.RTC_RIT_A_ready_Commit_Date__c != null){
                      if(ritVar1 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){ 
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritA7LP));
                      } else if(ritVar1 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar1 != null && ritVar1 != ''){
                      	designExecution.PTRF_RIT_A_Outlook_Date__c = designExecution.RTC_RIT_A_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar1));	    
                      }   
                  }
                  if(designExecution.RTC_RIT_B_ready_Commit_Date__c != null && designExecution.RTC_RIT_B_ready_Outlook_Date__c == null){
                      if(ritVar2 == null && (designExecution.Rit_B_Off_set__c == null || designExecution.Rit_B_Off_set__c == '')){
                        designExecution.PTRF_RIT_B_Commit_Date__c = designExecution.RTC_RIT_B_ready_Commit_Date__c.addDays(Integer.valueOf(ritB7LP));    
                      } else if(ritVar2 == null && designExecution.Rit_B_Off_set__c != null && designExecution.Rit_B_Off_set__c != ''){
                        designExecution.PTRF_RIT_B_Commit_Date__c = designExecution.RTC_RIT_B_ready_Commit_Date__c.addDays(Integer.valueOf(designExecution.Rit_B_Off_set__c));
                      } else if(ritVar2 != null && ritVar2 != ''){
                      	designExecution.PTRF_RIT_B_Commit_Date__c = designExecution.RTC_RIT_B_ready_Commit_Date__c.addDays(Integer.valueOf(ritVar2));  
                      }
                  }
                  if(designExecution.RTC_RIT_B_ready_Outlook_Date__c != null && designExecution.RTC_RIT_B_ready_Commit_Date__c == null){
                      if(ritVar2 == null && (designExecution.Rit_B_Off_set__c == null || designExecution.Rit_B_Off_set__c == '')){
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritB7LP));    
                      } else if(ritVar2 == null && designExecution.Rit_B_Off_set__c != null && designExecution.Rit_B_Off_set__c != ''){
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_B_Off_set__c));
                      } else if(ritVar2 != null && ritVar2 != ''){
                      	designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar2));    
                      }
                  }
                  if(designExecution.RTC_RIT_B_ready_Outlook_Date__c != null && designExecution.RTC_RIT_B_ready_Commit_Date__c != null){
                      if(ritVar2 == null && (designExecution.Rit_B_Off_set__c == null || designExecution.Rit_B_Off_set__c == '')){
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritB7LP));    
                      } else if(ritVar2 == null && designExecution.Rit_B_Off_set__c != null && designExecution.Rit_B_Off_set__c != ''){
                        designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_B_Off_set__c));
                      } else if(ritVar2 != null && ritVar2 != ''){
                      	designExecution.PTRF_RIT_B_Outlook_Date__c = designExecution.RTC_RIT_B_ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar2));    
                      }
                  }
                  if(designExecution.RTC_Rit_A_B_Ready_Commit_Date__c !=null && designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c == null){
                      if(ritVar1 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_B_Commit_Date__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c.addDays(Integer.valueOf(ritA7LP));    
                      } else if(ritVar1 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_B_Commit_Date__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar1 != null && ritVar1 != ''){
                      	designExecution.PTRF_RIT_A_B_Commit_Date__c = designExecution.RTC_Rit_A_B_Ready_Commit_Date__c.addDays(Integer.valueOf(ritVar1));    
                      }
                  }
                  if(designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c != null && designExecution.RTC_Rit_A_B_Ready_Commit_Date__c == null){
                      if(ritVar1== null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritA7LP));    
                      } else if(ritVar1 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      } else if(ritVar1 != null && ritVar1 != ''){
                      	designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar1));    
                      }
                  }
                  if(designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c != null && designExecution.RTC_Rit_A_B_Ready_Commit_Date__c !=null){
                      if(ritVar1 == null && (designExecution.Rit_A_Off_set__c == null || designExecution.Rit_A_Off_set__c == '')){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritA7LP));    
                      } else if(ritVar1 == null && designExecution.Rit_A_Off_set__c != null && designExecution.Rit_A_Off_set__c != ''){
                        designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(designExecution.Rit_A_Off_set__c));
                      }  else if(ritVar1 != null && ritVar1 != ''){
                      	designExecution.PTRF_RIT_A_B_Outlook_Date__c = designExecution.RTC_Rit_A_B_Ready_Outlook_Date__c.addDays(Integer.valueOf(ritVar1));    
                      } 
                  }    
              }                   
          }
            system.debug('&&designExecution&&' + designExecution ); 
          update designExecution;
          
          //added by Naman :  logic to update Design Execution dates to device fields for PSP milestones
          if(designExecution.option__c != null && designExecution.option__r.device__c != null){
          	  List<Device__c> devLst = new List<Device__c>();	
              dev = [Select id, Product_Line__c, CDS_Complete_Current__c, First_customer_design_data_Done__c, First_customer_design_data_Current__c, First_customer_design_data__c,
                                RTM_e_Release_Dt_Current__c, RTM_e_Release_Dt_Done__c, RTM_e_Release_Dt__c, RTM_e_Release_A__c, RTM_e_Release_A_Current__c, RTM_e_Release_A_Done__c,
                                Product_TO_Date__c, Product_TO_Current__c, Actual_Tapeout_Date_Done__c from Device__c where id =: designExecution.option__r.device__c];
                                
              if(dev.Product_Line__c == 'ASIC' || dev.Product_Line__c == 'SiPh' ){
                  
                  //Ready For IDR mapping from DE to Device PSP Milestone - Ready For IDR
                  dev.CDS_Complete_Current__c = designExecution.Customer_Design_Specification__r.IDR_actual_date__c != null?designExecution.Customer_Design_Specification__r.IDR_actual_date__c:null;
                  
                  //Production Netlist Delivery from DE to Device PSP Milestone - 1st Customer design data (netlist)
                  dev.First_customer_design_data__c = designExecution.Production_netlist_delivery_IDR__c != null?designExecution.Production_netlist_delivery_IDR__c:null;                 
                  if(designExecution.Production_netlist_delivery_Commit_Date__c == null && designExecution.Production_ntlst_delivery_Outlook_Date__c == null && designExecution.Production_netlist_delivery_Actual_Date__c == null && designExecution.Production_netlist_delivery_IDR__c != null){
                    dev.First_customer_design_data_Current__c = designExecution.Production_netlist_delivery_IDR__c;
                    dev.First_customer_design_data_Done__c = false;
                  }
                  else if(designExecution.Production_netlist_delivery_Commit_Date__c != null && designExecution.Production_ntlst_delivery_Outlook_Date__c == null && designExecution.Production_netlist_delivery_Actual_Date__c == null){
                    dev.First_customer_design_data_Current__c = designExecution.Production_netlist_delivery_Commit_Date__c;
                    dev.First_customer_design_data_Done__c = false;
                  }
                  else if(designExecution.Production_ntlst_delivery_Outlook_Date__c != null && designExecution.Production_netlist_delivery_Actual_Date__c == null){
                    dev.First_customer_design_data_Current__c = designExecution.Production_ntlst_delivery_Outlook_Date__c;
                    dev.First_customer_design_data_Done__c = false;
                  }
                  else if(designExecution.Production_netlist_delivery_Actual_Date__c != null){
                    dev.First_customer_design_data_Current__c = designExecution.Production_netlist_delivery_Actual_Date__c;
                    dev.First_customer_design_data_Done__c = true;
                  }
                  
                   dev.RTM_e_Release_Dt__c = designExecution.PTRF_RIT_A_IDR__c != null?designExecution.PTRF_RIT_A_IDR__c:null;               
                  if(designExecution.PTRF_RIT_A_Commit_Date__c == null && designExecution.PTRF_RIT_A_Outlook_Date__c == null && designExecution.PTRF_RIT_A_Actual_Date__c == null && designExecution.PTRF_RIT_A_IDR__c != null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.PTRF_RIT_A_IDR__c;
                    dev.RTM_e_Release_Dt_Done__c = false;
                  }
                  else if(designExecution.PTRF_RIT_A_Commit_Date__c != null && designExecution.PTRF_RIT_A_Outlook_Date__c == null && designExecution.PTRF_RIT_A_Actual_Date__c == null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.PTRF_RIT_A_Commit_Date__c;
                    dev.RTM_e_Release_Dt_Done__c = false;
                  }
                  else if(designExecution.PTRF_RIT_A_Outlook_Date__c != null && designExecution.PTRF_RIT_A_Actual_Date__c == null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.PTRF_RIT_A_Outlook_Date__c;
                    dev.RTM_e_Release_Dt_Done__c = false;
                  }
                  else if(designExecution.PTRF_RIT_A_Actual_Date__c != null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.PTRF_RIT_A_Actual_Date__c;
                    dev.RTM_e_Release_Dt_Done__c = true;
                  }
                  
                  //RTM Dt mapping from DE to Device PSP Milestone - RTM e-Release Dt
                  dev.RTM_e_Release_Dt__c = designExecution.RTM_e_Release_IDR__c != null?designExecution.RTM_e_Release_IDR__c:null;               
                  if(designExecution.RTM_e_Release_Commit_Date__c == null && designExecution.RTM_e_Release_Outlook_Date__c == null && designExecution.RTM_e_Release_Actual_Date__c == null && designExecution.RTM_e_Release_IDR__c != null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.RTM_e_Release_IDR__c;
                    dev.RTM_e_Release_Dt_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_Commit_Date__c != null && designExecution.RTM_e_Release_Outlook_Date__c == null && designExecution.RTM_e_Release_Actual_Date__c == null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.RTM_e_Release_Commit_Date__c;
                    dev.RTM_e_Release_Dt_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_Outlook_Date__c != null && designExecution.RTM_e_Release_Actual_Date__c == null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.RTM_e_Release_Outlook_Date__c;
                    dev.RTM_e_Release_Dt_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_Actual_Date__c != null){
                    dev.RTM_e_Release_Dt_Current__c = designExecution.RTM_e_Release_Actual_Date__c;
                    dev.RTM_e_Release_Dt_Done__c = true;
                  }
                  
                  
                  //RTM RIT A mapping from DE to Device PSP Milestone - RTM e-Release A
                  dev.RTM_e_Release_A__c = designExecution.RTM_e_Release_RIT_A_IDR__c != null?designExecution.RTM_e_Release_RIT_A_IDR__c:null;                
                  if(designExecution.RTM_e_Release_RIT_A_Commit_Date__c == null && designExecution.RTM_e_Release_RIT_A_Outlook_Date__c == null && designExecution.RTM_e_Release_RIT_A_Actual_Date__c == null && designExecution.RTM_e_Release_RIT_A_IDR__c != null){
                    dev.RTM_e_Release_A_Current__c = designExecution.RTM_e_Release_RIT_A_IDR__c;
                    dev.RTM_e_Release_A_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_RIT_A_Commit_Date__c != null && designExecution.RTM_e_Release_RIT_A_Outlook_Date__c == null && designExecution.RTM_e_Release_RIT_A_Actual_Date__c == null){
                    dev.RTM_e_Release_A_Current__c = designExecution.RTM_e_Release_RIT_A_Commit_Date__c;
                    dev.RTM_e_Release_A_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_RIT_A_Outlook_Date__c != null && designExecution.RTM_e_Release_RIT_A_Actual_Date__c == null){
                    dev.RTM_e_Release_A_Current__c = designExecution.RTM_e_Release_RIT_A_Outlook_Date__c;
                    dev.RTM_e_Release_A_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_RIT_A_Actual_Date__c != null){
                    dev.RTM_e_Release_A_Current__c = designExecution.RTM_e_Release_RIT_A_Actual_Date__c;
                    dev.RTM_e_Release_A_Done__c = true;
                  }
                  
                  //RTM RIT B mapping from DE to Device PSP Milestone - Product Tapeout(RTM e-Release B)
                  dev.Product_TO_Date__c = designExecution.RTM_e_Release_RIT_B_IDR__c != null?designExecution.RTM_e_Release_RIT_B_IDR__c:null;                
                  if(designExecution.RTM_e_Release_RIT_B_Commit_Date__c == null && designExecution.RTM_e_Release_RIT_B_Outlook_Date__c == null && designExecution.RTM_e_Release_RIT_A_Actual_Date__c == null && designExecution.RTM_e_Release_RIT_B_IDR__c != null){
                    dev.Product_TO_Current__c = designExecution.RTM_e_Release_RIT_B_IDR__c;
                    dev.Actual_Tapeout_Date_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_RIT_B_Commit_Date__c != null && designExecution.RTM_e_Release_RIT_B_Outlook_Date__c == null && designExecution.RTM_e_Release_RIT_B_Actual_Date__c == null){
                    dev.Product_TO_Current__c = designExecution.RTM_e_Release_RIT_B_Commit_Date__c;
                    dev.Actual_Tapeout_Date_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_RIT_B_Outlook_Date__c != null && designExecution.RTM_e_Release_RIT_B_Actual_Date__c == null){
                    dev.Product_TO_Current__c = designExecution.RTM_e_Release_RIT_B_Outlook_Date__c;
                    dev.Actual_Tapeout_Date_Done__c = false;
                  }
                  else if(designExecution.RTM_e_Release_RIT_B_Actual_Date__c != null){
                    dev.Product_TO_Current__c = designExecution.RTM_e_Release_RIT_B_Actual_Date__c;
                    dev.Actual_Tapeout_Date_Done__c = true;
                  }
                 // devLst.add(dev);
              }
              if(designExecution.PTRF_RIT_A_Commit_Date__c != null && designExecution.PTRF_RIT_A_Outlook_Date__c == null){
                    dev.Current_Forecast_Tapeout_Date__c = designExecution.PTRF_RIT_A_Commit_Date__c;    
                  }
              else if(designExecution.PTRF_RIT_A_Outlook_Date__c != null && designExecution.PTRF_RIT_A_Commit_Date__c == null){
                  dev.Current_Forecast_Tapeout_Date__c = designExecution.PTRF_RIT_A_Outlook_Date__c;     
              }
              else if(designExecution.PTRF_RIT_A_Outlook_Date__c != null && designExecution.PTRF_RIT_A_Commit_Date__c != null){
                  dev.Current_Forecast_Tapeout_Date__c = designExecution.PTRF_RIT_A_Outlook_Date__c;     
              }
              devLst.add(dev);
              update devLst;                        
          }
      }catch(exception e){
          GlobalUtility.logMessage('Error','DesignExecutionController','doUpdate','','Exception while Updating the Design Execution record',String.valueof(e.getMessage()),'','Design Execution',e,0);
      }
      pageReference pageRef = new pageReference('/apex/DesignExecutionRead?deid='+designExecution.id);
      pageRef.setRedirect(true);
      return pageRef;
    }
    
    
    /**
    * @description method to redirect on design execution read page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */      
    public Pagereference cancelExecutionDetail(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionRead?deid='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    /**
    * @description method to redirect on design execution edit page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */
    public Pagereference editExecutionDetail(){
        system.debug('&&&&id&&&&&' + designexecution.id +'&&&&idrActualDate&&&&' + idrActualDate +'&&&cdsId&&&' +cdsId);
        pageReference pageRef = new pageReference('/apex/DesignExecutionDetail?deid='+designexecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    /**
    * @description method to redirect on requote page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */   
    public pageReference requoteExecutionDetail(){
        id reqid = DesignExecutionUtility.requote(designExecution.Customer_Design_Specification__c);
        if(reqid != null){
            pageReference pageRef = new pageReference('/' + reqid );
            pageRef.setRedirect(true);
            return pageRef;
        }
        else{
            return null;
        }
    }
    
    
    /**
    * @description method to redirect on sign off recordtype page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */      
    public Pagereference viewSignOffRT(){
        //pageReference pageRef = new pageReference('/apex/DesignExecutionSignOffRecType?deid='+designExecution.id);
        pageReference pageRef = new pageReference('/apex/DesignExecutionSignOffRecType?deid='+designExecution.id + '&cancelDT='+cancelDT + '&enableCreateRTDTButton='+enableCreateRTDTButton);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    /**
    * @description method to redirect on waiver page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */    
    public Pagereference redirectToWaiverCapability(){        
        pageReference pageRef = new pageReference('/apex/DesignExecutionWaiverCapabilityRec?deid='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
        
    
    /**
    * @description Method to redirect sign off export page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */
    public Pagereference exportMilestones(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionSignOffExport?deid='+designExecution.id);
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    
    /**
    * @description Method to redirect on Design page
    * @param    No Parameter
    * @return   Pagereference pageRef
    */
    /*
    public Pagereference redirectToDecision(){
        Decision__c decisionrec = new Decision__c();
        pageReference pageRef;
        try{
            if(designExecution.Option__r.Option_Stage__c == 'Prototype Fulfillment'){
                decisionrec = [select id from Decision__c where Technical_Requirement__c =: designExecution.Option__c];
                if(decisionrec != null){
                    BnP_OptionUtility  bnpOption = new BnP_OptionUtility();                            
                    bnpOption.updateOptionStages(new List<Id>{designExecution.Option__c}, 'Customer Decision');
                    pageRef = new pageReference('/'+decisionrec.id);
                    pageRef.setRedirect(false);
                }
            }
            if(pageRef != null) {
                return pageRef;
            } else {
                return null;
            }
        }
        catch(exception e){
            GlobalUtility.logMessage('Error','DesignExecutionController','doUpdate','','Exception while Updating the OptionStage field',String.valueof(e.getMessage()),'','Design Execution',e,0);
            return null;
        }        
    }
    */
       
    /**
    * @description getSignOffProfileStaus method is return signOff records based on permmission Set.
    * @param  No Parameter
    * @return  List lsit of Sign_off_Module__c
    */
    public List<Sign_off_Module__c> getSignOffMilestoneDetails(){
        List<Sign_off_Module__c> lstProfileSignOff = new List<Sign_off_Module__c> ();
        List<Sign_off_Module__c> listSignOffRecord = [SELECT Id,PE_Approval_User__c,PD_Approval_User__c,DCE_Approval_User__c,AE_Approval_User__c, Name, RecordTypeId, RTL_Checkpoint_Reached__c, Application_Engineer__c, Field_Design_Center_Engineer__c, 
                                          Physical_Design_Engineer__c, Product_Engineer__c, IBM_ASIC__c, Customer_Details__c, AE_Approval__c, PD_Approval__c, 
                                          PE_Approval__c, DCE_Approval__c,  RIT_Type__c, Profile_ID__c, SignOffExternalId__c, Stage__c, Design_Execution__c
                                          FROM Sign_off_Module__c 
                                          WHERE Design_Execution__c=:deid];

        //create map with signOff module stage as a key and Permission set name as a value from SignOff module.
        for(Sign_off_Module__c sfm : listSignOffRecord  ){
            lstProfileSignOff.add(sfm); 
        }
        return lstProfileSignOff;        
    }
    
    /*
*************************************    
@ Name -  goToTechReview
@ Description -  Go To TechReview Functionality is provided on 'DesignExecutionRead' page.
@ Parameter - None
@ Return Type - 
@ Created By - Varsha Tomar
****************************************
*/
    public PageReference goToTechReview() {
        BnP_TechReview_Util trUtil = new BnP_TechReview_Util();
        PageReference pgRef;
        if(designExecution.Option__c != null) {
            List<Decision__c> dcList = [select Name, Technical_Requirement__r.Name, Technical_Requirement__c, Charge_Number__c, Opportunity__c, Opportunity__r.Name, 
                                        Request_Information__c, Request_Information__r.Name, Device__c, Device__r.Name
                                        from Decision__c 
                                        where Technical_Requirement__c = :designExecution.Option__c];
            
            String chargeNumber = '';
            List<Charge_Info__c> chargeInfoList = [select Charge_Number__c from Charge_Info__c where Option__c = :designExecution.Option__c];
            // if exist the assign to charge info variable
            if(chargeInfoList != null && chargeInfoList.size() > 0) {
                chargeNumber = chargeInfoList[0].Charge_Number__c;
            }
            if(dcList != null && dcList.size() > 0) {
                Decision__c decisionRecord = dcList[0];
                
                String recTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('ASIC Tech Review 2').getRecordTypeId();
                pgRef = trUtil.callTechReview(decisionRecord, chargeNumber, recTypeId);
            } else {
                pgRef = new PageReference('/apex/BNP_TechReviewMessage');
                pgRef.getParameters().put('retURL', '/apex/DesignExecutionRead?deid='+designExecution.id);
                pgRef.getParameters().put('optionId', designExecution.Option__c);
                return pgRef;
            }
        }
        if(pgRef != null) {
            pgref.getParameters().put('retURL','/apex/DesignExecutionRead?deid='+designExecution.id);
            return pgRef;
        } else {
            return null;
        }
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        return options;
    }
    
    public void nextbtn(){
        counter += limits ;
        populateRelatedLists();
    }
    
    public void prvbtn(){
        counter -= limits ;
        populateRelatedLists();
    }
    
    public void fstbtn(){
        counter = 0;
        populateRelatedLists();
    }
    
    public void endbtn(){
        counter = recNum - math.mod(recNum,limits);
        populateRelatedLists();
    }
    
    public boolean getprv(){
        if(counter == 0)
            return true;
        else
            return false;
    }
    
    public boolean getnxt(){
        if((counter + limits) > recNum)
            return true;
        else
            return false;
    }
    
    /*   *************************************    
    @ Name -  returnGeometryFromOpp
    @ Description -  filter numric value from string and convert into decimal
    @ Parameter - String: geometryValue
    @ Return Type - Decimal 
    @ Created By - Sandesh Singh
    ****************************************
    */
    @TestVisible
    private Decimal returnGeometryFromOpp(String geometryValue){
		String strGeometry = '';
		Decimal numericGeometry = 0.00;
		
		List<String> chars = geometryValue.split('|');
		for (String s : chars)
		{
		    if (!s.isAlpha())
		    {
		        strgeometry += s;
		    }
		    else{
		    	break;
		    }
		    
		}
		numericGeometry = Decimal.valueOf(strgeometry); 
		    
		return numericGeometry;
    }
}