/*******************************************************************
* Author: Sakthi 
* Project: DIW-DesignExecution 
* Name: DesignExecutionUtility 
* Description: this is the Utility class to retrive the DE record details & Logged in User PermissionSet
* CreatedDate:
* Modified By : Abhishek/Sandesh 
* Modified date : 03-Dec-2016  
				: 26-June-2017, fetchOpportunityTeamEmails method to collect the Opportunity Team Member based on Applicable Design Execution
********************************************************************/
public class DesignExecutionUtility {
    

    Public static Design_Execution__c fetchDErecords(id deid){
        List<Design_Execution__c> lidesignexecution = [Select id,Name,Google_Sheet_Id__c, Actual_Date__c,CDS_completion_date__c,Customer_Design_Specification__r.Device__c,Customer_Design_Specification__r.Device__r.Geometry__c,Customer_Design_Specification__r.name,Tech_Review_Summary__c, Opportunity_Product_Line__c, Option__c,Option__r.Option_Stage__c,Option__r.RIT_Type__c, Customer_Design_Specification__c,Opportunity__c, CDS_completion_No_NL_Del__c,End_Customer__c, Opp_Control_Number__c, Soldto_Customer__c, Status__c, End_Customer_Project__c,Customer_Part_Name__c,MD_Part_Name__c,Option_Control_Number__c, Deliverable_Part_Type__c, Part_Number_Status__c, Deliverable_Part_Number_DPN__c , Design_assay_part_number_DAPN__c, Last_Update_IDR__c, Last_Updated_Commit_Date__c, Last_Updated_Outlook_Date__c, Last_Updated_Actual_Date__c, Last_Updated_No_NL_Del__c, CDS_completion_IDR__c, CDS_completion_Commit_Date__c, CDS_completion_Outlook_Date__c, CDS_completion_Actual_Date__c, Analysis_netlist_delivery_IDR__c, Analysis_netlist_delivery_Commit_Date__c, Analysis_netlist_delivery_Outlook_Date__c, Analysis_netlist_delivery_Actual_Date__c,Analysis_netlist_delivery_No_NL_Del__c, Floorplan_netlist_delivery_IDR__c, Floorplan_netlist_delivery_Commit_Date__c, Floorplan_netlist_delivery_Outlook_Date__c, Floorplan_netlist_delivery_Actual_Date__c, Floorplan_netlist_delivery_No_NL_Del__c, Release_to_Floorplan_IDR__c, Release_to_Floorplan_Commit_Date__c, Release_to_Floorplan_Outlook_Date__c, Release_to_Floorplan_Actual_Date__c, Release_to_Floorplan_No_NL_Del__c, Exit_from_Floorplan_IDR__c, Exit_from_Floorplan_Commit_Date__c, Exit_from_Floorplan_Outlook_Date__c, Exit_from_Floorplan_Actual_Date__c, Exit_from_Floorplan_No_NL_Del__c, Preliminary_netlist_delivery_IDR__c, Preliminary_ntlst_delivery_Commit_Date__c, Preliminary_ntlst_delivery_Outlook_Date__c, Preliminary_ntlst_delivery_Actual_Date__c, Preliminary_ntlst_delivery_No_NL_Del__c, Release_to_Preliminary_IDR__c, Release_to_Preliminary_Commit_Date__c, Release_to_Preliminary_Actual_Date__c, Release_to_Preliminary_No_NL_Del__c, Exit_from_Preliminary_IDR__c, Exit_from_Preliminary_Commit_Date__c, Exit_from_Preliminary_Outlook_Date__c, Exit_from_Preliminary_Actual_Date__c, Exit_from_Preliminary_No_NL_Del__c, Production_netlist_delivery_IDR__c, Production_netlist_delivery_Commit_Date__c, Production_ntlst_delivery_Outlook_Date__c, Production_netlist_delivery_Actual_Date__c, Production_netlist_delivery_No_NL_Del__c, Release_to_Layout_IDR__c, Release_to_Layout_Commit_Date__c, Release_to_Layout_Outlook_Date__c, Release_to_Layout_Actual_Date__c, Release_to_Layout_No_NL_Del__c, RTC_DT_ready_IDR__c, RTC_DT_ready_Commit_Date__c, RTC_DT_ready_Outlook_Date__c, RTC_DT_ready_Actual_Date__c, RTC_RIT_B_ready_IDR__c, RTC_RIT_B_ready_Commit_Date__c, RTC_RIT_B_ready_Outlook_Date__c, RTC_RIT_B_ready_Actual_Date__c, RTC_RIT_B_ready_No_NL_Del__c, RTC_RIT_A_ready_IDR__c, RTC_RIT_A_ready_Commit_Date__c, RTC_RIT_A_ready_Outlook_Date__c, RTC_RIT_A_ready_Actual_Date__c, RTC_RIT_A_ready_No_NL_Del__c, RTM_RIT_A_ready_IDR__c, RTM_RIT_A_ready_Commit_Date__c, RTM_RIT_A_ready_Outlook_Date__c, RTM_RIT_A_ready_Actual_Date__c, RTM_RIT_A_ready_No_NL_Del__c, RTM_RIT_B_ready_IDR__c, RTM_RIT_B_ready_Commit_Date__c, RTM_RIT_B_ready_Outlook_Date__c, RTM_RIT_B_ready_Actual_Date__c, RTM_RIT_B_ready_No_NL_Del__c, RTM_e_Release_IDR__c, RTM_e_Release_Commit_Date__c, RTM_e_Release_Outlook_Date__c, RTM_e_Release_Actual_Date__c, RTM_e_Release_No_NL_Del__c, RTM_e_Release_RIT_A_IDR__c, RTM_e_Release_RIT_A_Commit_Date__c, RTM_e_Release_RIT_A_Outlook_Date__c, RTM_e_Release_RIT_A_Actual_Date__c, RTM_e_Release_RIT_A_No_NL_Del__c, RTM_e_Release_RIT_B_IDR__c, RTM_e_Release_RIT_B_Commit_Date__c, RTM_e_Release_RIT_B_Outlook_Date__c, RTM_e_Release_RIT_B_Actual_Date__c, RTM_e_Release_RIT_B_No_NL_Del__c,RTC_DT_ready_No_NL_Del__c,RTM_DT_ready_Actual_Date__c,RTM_DT_ready_Commit_Date__c,RTM_DT_ready_IDR__c,RTM_DT_ready_No_NL_Del__c,RTM_DT_ready_Outlook_Date__c,PTRF_RIT_A_Actual_Date__c,PTRF_RIT_A_Commit_Date__c,PTRF_RIT_A_IDR__c,PTRF_RIT_A_No_NL_Del__c,PTRF_RIT_A_Outlook_Date__c,PTRF_RIT_B_Actual_Date__c,PTRF_RIT_B_Commit_Date__c,PTRF_RIT_B_IDR__c,PTRF_RIT_B_No_NL_Del__c,PTRF_RIT_B_Outlook_Date__c,
                             RTC_Rit_A_B_Ready_Commit_Date__c,RTC_Rit_A_B_Ready_IDR__c,RTC_Rit_A_B_Ready_No_NL_Del__c,RTC_Rit_A_B_Ready_Outlook_Date__c,Customer_Design_Specification__r.IDR_actual_date__c,
                             RTM_RIT_A_B_ready_Actual_Date__c,RTM_RIT_A_B_ready_Commit_Date__c,RTM_RIT_A_B_ready_IDR__c,RTM_RIT_A_B_ready_No_NL_Del__c,RTM_RIT_A_B_ready_Outlook_Date__c,
                             RTC_Rit_A_B_Ready_Actual_Date__c,cancelDT__c,enableCreateRTDTButton__c,enableRITABSplitButton__c,
                             enablePTRF__c,enablePTRFB__c,enableNONPTRFB__c,Customer_Design_Specification__r.DIW_Opp_Control_Number__c,
                             PTRF_RIT_A_B_Actual_Date__c,PTRF_RIT_A_B_Commit_Date__c,PTRF_RIT_A_B_IDR__c,PTRF_RIT_A_B_No_NL_Del__c,PTRF_RIT_A_B_Outlook_Date__c,RELEASE_TO_PRELIMINARY_OUTLOOK_DATE__C,Option__r.Device__r.Geometry__c,
                             Option__r.Account__r.Name, Option__r.MD_part_name__c, Option__r.ProductOffering__r.Name,
                             RTM_RIT_A_B_Actual_Date__c,RTM_RIT_A_B_Commit_Date__c,RTM_RIT_A_B_IDR__c,RTM_RIT_A_B_No_NL_Del__c,RTM_RIT_A_B_Outlook_Date__c,Rit_A_Off_set__c,Rit_B_Off_set__c,Rit_A_Off_set_7LP__c,Rit_B_Off_set_7LP__c from Design_Execution__c where id =: deid];             
        Design_Execution__c de = new Design_Execution__c();
        if(lidesignexecution.size() > 0)
            de = lidesignexecution.get(0);
        return de;
    }
    
    Public static Design_Execution__c fetchDErecordsbyCDS(id cdsid){         
        List<Design_Execution__c> lidesignexecution = [Select id,Name,Google_Sheet_Id__c, CDS_completion_date__c,Actual_Date__c,Customer_Design_Specification__r.Device__c,Customer_Design_Specification__r.Device__r.Geometry__c,Customer_Design_Specification__r.IDR_actual_date__c,Option__r.Device__r.Geometry__c,
                                                       Customer_Design_Specification__r.name,Tech_Review_Summary__c, Opportunity_Product_Line__c, Option__c,Option__r.Option_Stage__c,Option__r.RIT_Type__c, Customer_Design_Specification__c,
                                                       Opportunity__c, CDS_completion_No_NL_Del__c,End_Customer__c, Opp_Control_Number__c, Soldto_Customer__c, Status__c, End_Customer_Project__c,Customer_Part_Name__c,MD_Part_Name__c,
                                                       Option_Control_Number__c, Deliverable_Part_Type__c, Part_Number_Status__c, Deliverable_Part_Number_DPN__c , Design_assay_part_number_DAPN__c, Last_Update_IDR__c, Last_Updated_Commit_Date__c, 
                                                       Last_Updated_Outlook_Date__c, Last_Updated_Actual_Date__c, Last_Updated_No_NL_Del__c, CDS_completion_IDR__c, CDS_completion_Commit_Date__c, CDS_completion_Outlook_Date__c, CDS_completion_Actual_Date__c, 
                                                       Analysis_netlist_delivery_IDR__c, Analysis_netlist_delivery_Commit_Date__c, Analysis_netlist_delivery_Outlook_Date__c, Analysis_netlist_delivery_Actual_Date__c,Analysis_netlist_delivery_No_NL_Del__c, 
                                                       Floorplan_netlist_delivery_IDR__c, Floorplan_netlist_delivery_Commit_Date__c, Floorplan_netlist_delivery_Outlook_Date__c, Floorplan_netlist_delivery_Actual_Date__c, Floorplan_netlist_delivery_No_NL_Del__c, 
                                                       Release_to_Floorplan_IDR__c, Release_to_Floorplan_Commit_Date__c, Release_to_Floorplan_Outlook_Date__c, Release_to_Floorplan_Actual_Date__c, Release_to_Floorplan_No_NL_Del__c, Exit_from_Floorplan_IDR__c, 
                                                       Exit_from_Floorplan_Commit_Date__c, Exit_from_Floorplan_Outlook_Date__c, Exit_from_Floorplan_Actual_Date__c, Exit_from_Floorplan_No_NL_Del__c, Preliminary_netlist_delivery_IDR__c, 
                                                       Preliminary_ntlst_delivery_Commit_Date__c, Preliminary_ntlst_delivery_Outlook_Date__c, Preliminary_ntlst_delivery_Actual_Date__c, Preliminary_ntlst_delivery_No_NL_Del__c, Release_to_Preliminary_IDR__c, 
                                                       Release_to_Preliminary_Commit_Date__c, Release_to_Preliminary_Actual_Date__c, Release_to_Preliminary_No_NL_Del__c, Exit_from_Preliminary_IDR__c, Exit_from_Preliminary_Commit_Date__c, 
                                                       Exit_from_Preliminary_Outlook_Date__c, Exit_from_Preliminary_Actual_Date__c, Exit_from_Preliminary_No_NL_Del__c, Production_netlist_delivery_IDR__c, Production_netlist_delivery_Commit_Date__c, 
                                                       Production_ntlst_delivery_Outlook_Date__c, Production_netlist_delivery_Actual_Date__c, Production_netlist_delivery_No_NL_Del__c, Release_to_Layout_IDR__c, Release_to_Layout_Commit_Date__c, Release_to_Layout_Outlook_Date__c, 
                                                       Release_to_Layout_Actual_Date__c, Release_to_Layout_No_NL_Del__c, RTC_DT_ready_IDR__c, RTC_DT_ready_Commit_Date__c, RTC_DT_ready_Outlook_Date__c, RTC_DT_ready_Actual_Date__c, RTC_RIT_B_ready_IDR__c, 
                                                       RTC_RIT_B_ready_Commit_Date__c, RTC_RIT_B_ready_Outlook_Date__c, RTC_RIT_B_ready_Actual_Date__c, RTC_RIT_B_ready_No_NL_Del__c, RTC_RIT_A_ready_IDR__c, RTC_RIT_A_ready_Commit_Date__c, RTC_RIT_A_ready_Outlook_Date__c, 
                                                       RTC_RIT_A_ready_Actual_Date__c, RTC_RIT_A_ready_No_NL_Del__c, RTM_RIT_A_ready_IDR__c, RTM_RIT_A_ready_Commit_Date__c, RTM_RIT_A_ready_Outlook_Date__c, RTM_RIT_A_ready_Actual_Date__c, 
                                                       RTM_RIT_A_ready_No_NL_Del__c, RTM_RIT_B_ready_IDR__c, RTM_RIT_B_ready_Commit_Date__c, RTM_RIT_B_ready_Outlook_Date__c, RTM_RIT_B_ready_Actual_Date__c, RTM_RIT_B_ready_No_NL_Del__c, RTM_e_Release_IDR__c, 
                                                       RTM_e_Release_Commit_Date__c, RTM_e_Release_Outlook_Date__c, RTM_e_Release_Actual_Date__c, RTM_e_Release_No_NL_Del__c, RTM_e_Release_RIT_A_IDR__c, RTM_e_Release_RIT_A_Commit_Date__c, 
                                                       RTM_e_Release_RIT_A_Outlook_Date__c, RTM_e_Release_RIT_A_Actual_Date__c, RTM_e_Release_RIT_A_No_NL_Del__c, RTM_e_Release_RIT_B_IDR__c, RTM_e_Release_RIT_B_Commit_Date__c, RTM_e_Release_RIT_B_Outlook_Date__c, 
                                                       RTM_e_Release_RIT_B_Actual_Date__c, RTM_e_Release_RIT_B_No_NL_Del__c,RTC_DT_ready_No_NL_Del__c,RTM_DT_ready_Actual_Date__c,RTM_DT_ready_Commit_Date__c,RTM_DT_ready_IDR__c,RTM_DT_ready_No_NL_Del__c,
                                                       RTM_DT_ready_Outlook_Date__c,PTRF_RIT_A_Actual_Date__c,PTRF_RIT_A_Commit_Date__c,PTRF_RIT_A_IDR__c,PTRF_RIT_A_No_NL_Del__c,PTRF_RIT_A_Outlook_Date__c,PTRF_RIT_B_Actual_Date__c,
                                                       PTRF_RIT_B_Commit_Date__c,PTRF_RIT_B_IDR__c,PTRF_RIT_B_No_NL_Del__c,PTRF_RIT_B_Outlook_Date__c,PTRF_RIT_A_B_Actual_Date__c,PTRF_RIT_A_B_Commit_Date__c,PTRF_RIT_A_B_IDR__c,PTRF_RIT_A_B_No_NL_Del__c,PTRF_RIT_A_B_Outlook_Date__c,
                                                       RTC_Rit_A_B_Ready_Actual_Date__c,RTC_Rit_A_B_Ready_Commit_Date__c,RTC_Rit_A_B_Ready_IDR__c,RTC_Rit_A_B_Ready_No_NL_Del__c,RTC_Rit_A_B_Ready_Outlook_Date__c,cancelDT__c,enableCreateRTDTButton__c,enableRITABSplitButton__c,
                               enablePTRF__c,enablePTRFB__c,enableNONPTRFB__c,
                             RTM_RIT_A_B_ready_Actual_Date__c,RTM_RIT_A_B_ready_Commit_Date__c,RTM_RIT_A_B_ready_IDR__c,RTM_RIT_A_B_ready_No_NL_Del__c,RTM_RIT_A_B_ready_Outlook_Date__c,RELEASE_TO_PRELIMINARY_OUTLOOK_DATE__C,
                             RTM_RIT_A_B_Actual_Date__c,RTM_RIT_A_B_Commit_Date__c,RTM_RIT_A_B_IDR__c,RTM_RIT_A_B_No_NL_Del__c,RTM_RIT_A_B_Outlook_Date__c from Design_Execution__c where Customer_Design_Specification__c =: cdsid];                 
        Design_Execution__c de = new Design_Execution__c();
        if(lidesignexecution.size() > 0)
                    de = lidesignexecution.get(0);
        return de;
    }
    
    
    Public static Design_Execution__c fetchDErecordsbyTechReview(id techreviewid){         
        List<Design_Execution__c> lidesignexecution = [Select id,Name,Google_Sheet_Id__c, Actual_Date__c,CDS_completion_date__c,Customer_Design_Specification__r.name,Tech_Review_Summary__c, Opportunity_Product_Line__c, Option__c,Option__r.Option_Stage__c, Customer_Design_Specification__c,Opportunity__c, CDS_completion_No_NL_Del__c,End_Customer__c, Opp_Control_Number__c, Soldto_Customer__c, Status__c, End_Customer_Project__c,Customer_Part_Name__c,MD_Part_Name__c,Option_Control_Number__c, Deliverable_Part_Type__c, Part_Number_Status__c, Deliverable_Part_Number_DPN__c , Design_assay_part_number_DAPN__c, Last_Update_IDR__c, Last_Updated_Commit_Date__c, Last_Updated_Outlook_Date__c, Last_Updated_Actual_Date__c, Last_Updated_No_NL_Del__c, CDS_completion_IDR__c, CDS_completion_Commit_Date__c, CDS_completion_Outlook_Date__c, CDS_completion_Actual_Date__c, Analysis_netlist_delivery_IDR__c, Analysis_netlist_delivery_Commit_Date__c, Analysis_netlist_delivery_Outlook_Date__c, Analysis_netlist_delivery_Actual_Date__c,Analysis_netlist_delivery_No_NL_Del__c, Floorplan_netlist_delivery_IDR__c, Floorplan_netlist_delivery_Commit_Date__c, Floorplan_netlist_delivery_Outlook_Date__c, Floorplan_netlist_delivery_Actual_Date__c, Floorplan_netlist_delivery_No_NL_Del__c, Release_to_Floorplan_IDR__c, Release_to_Floorplan_Commit_Date__c, Release_to_Floorplan_Outlook_Date__c, Release_to_Floorplan_Actual_Date__c, Release_to_Floorplan_No_NL_Del__c, Exit_from_Floorplan_IDR__c, Exit_from_Floorplan_Commit_Date__c, Exit_from_Floorplan_Outlook_Date__c, Exit_from_Floorplan_Actual_Date__c, Exit_from_Floorplan_No_NL_Del__c, Preliminary_netlist_delivery_IDR__c, Preliminary_ntlst_delivery_Commit_Date__c, Preliminary_ntlst_delivery_Outlook_Date__c, Preliminary_ntlst_delivery_Actual_Date__c, Preliminary_ntlst_delivery_No_NL_Del__c, Release_to_Preliminary_IDR__c, Release_to_Preliminary_Commit_Date__c, Release_to_Preliminary_Actual_Date__c, Release_to_Preliminary_No_NL_Del__c, Exit_from_Preliminary_IDR__c, Exit_from_Preliminary_Commit_Date__c, Exit_from_Preliminary_Outlook_Date__c, Exit_from_Preliminary_Actual_Date__c, Exit_from_Preliminary_No_NL_Del__c, Production_netlist_delivery_IDR__c, Production_netlist_delivery_Commit_Date__c, Production_ntlst_delivery_Outlook_Date__c, Production_netlist_delivery_Actual_Date__c, Production_netlist_delivery_No_NL_Del__c, Release_to_Layout_IDR__c, Release_to_Layout_Commit_Date__c, Release_to_Layout_Outlook_Date__c, Release_to_Layout_Actual_Date__c, Release_to_Layout_No_NL_Del__c, RTC_DT_ready_IDR__c, RTC_DT_ready_Commit_Date__c, RTC_DT_ready_Outlook_Date__c, RTC_DT_ready_Actual_Date__c, RTC_RIT_B_ready_IDR__c, RTC_RIT_B_ready_Commit_Date__c, RTC_RIT_B_ready_Outlook_Date__c, RTC_RIT_B_ready_Actual_Date__c, RTC_RIT_B_ready_No_NL_Del__c, RTC_RIT_A_ready_IDR__c, RTC_RIT_A_ready_Commit_Date__c, RTC_RIT_A_ready_Outlook_Date__c, RTC_RIT_A_ready_Actual_Date__c, RTC_RIT_A_ready_No_NL_Del__c, RTM_RIT_A_ready_IDR__c, RTM_RIT_A_ready_Commit_Date__c, RTM_RIT_A_ready_Outlook_Date__c, RTM_RIT_A_ready_Actual_Date__c, RTM_RIT_A_ready_No_NL_Del__c, RTM_RIT_B_ready_IDR__c, RTM_RIT_B_ready_Commit_Date__c, RTM_RIT_B_ready_Outlook_Date__c, RTM_RIT_B_ready_Actual_Date__c, RTM_RIT_B_ready_No_NL_Del__c, RTM_e_Release_IDR__c, RTM_e_Release_Commit_Date__c, RTM_e_Release_Outlook_Date__c, RTM_e_Release_Actual_Date__c, RTM_e_Release_No_NL_Del__c, RTM_e_Release_RIT_A_IDR__c, RTM_e_Release_RIT_A_Commit_Date__c, RTM_e_Release_RIT_A_Outlook_Date__c, RTM_e_Release_RIT_A_Actual_Date__c, RTM_e_Release_RIT_A_No_NL_Del__c, RTM_e_Release_RIT_B_IDR__c, RTM_e_Release_RIT_B_Commit_Date__c, RTM_e_Release_RIT_B_Outlook_Date__c, RTM_e_Release_RIT_B_Actual_Date__c, RTM_e_Release_RIT_B_No_NL_Del__c,RTC_DT_ready_No_NL_Del__c,RTM_DT_ready_Actual_Date__c,RTM_DT_ready_Commit_Date__c,RTM_DT_ready_IDR__c,RTM_DT_ready_No_NL_Del__c,RTM_DT_ready_Outlook_Date__c,PTRF_RIT_A_Actual_Date__c,PTRF_RIT_A_Commit_Date__c,PTRF_RIT_A_IDR__c,PTRF_RIT_A_No_NL_Del__c,PTRF_RIT_A_Outlook_Date__c,PTRF_RIT_B_Actual_Date__c,PTRF_RIT_B_Commit_Date__c,PTRF_RIT_B_IDR__c,PTRF_RIT_B_No_NL_Del__c,PTRF_RIT_B_Outlook_Date__c,
                              RTC_Rit_A_B_Ready_Actual_Date__c,RTC_Rit_A_B_Ready_Commit_Date__c,RTC_Rit_A_B_Ready_IDR__c,RTC_Rit_A_B_Ready_No_NL_Del__c,RTC_Rit_A_B_Ready_Outlook_Date__c,Customer_Design_Specification__r.IDR_actual_date__c,Option__r.Device__r.Geometry__c,
                            RTM_RIT_A_B_ready_Actual_Date__c,RTM_RIT_A_B_ready_Commit_Date__c,RTM_RIT_A_B_ready_IDR__c,RTM_RIT_A_B_ready_No_NL_Del__c,RTM_RIT_A_B_ready_Outlook_Date__c,RELEASE_TO_PRELIMINARY_OUTLOOK_DATE__C,
                            RTM_RIT_A_B_Actual_Date__c,RTM_RIT_A_B_Commit_Date__c,RTM_RIT_A_B_IDR__c,RTM_RIT_A_B_No_NL_Del__c,RTM_RIT_A_B_Outlook_Date__c,PTRF_RIT_A_B_Actual_Date__c,PTRF_RIT_A_B_Commit_Date__c,PTRF_RIT_A_B_IDR__c,PTRF_RIT_A_B_No_NL_Del__c,PTRF_RIT_A_B_Outlook_Date__c,cancelDT__c,enableCreateRTDTButton__c,enableRITABSplitButton__c,
                                                enablePTRF__c,enablePTRFB__c,enableNONPTRFB__c
                            from Design_Execution__c where Tech_Review_Summary__c =: techreviewid];                 
        Design_Execution__c de = new Design_Execution__c();
        if(lidesignexecution.size() > 0)
                    de = lidesignexecution.get(0);
        return de;
    }

    public static Set<String> setOfPermissionSetForLoggedInUser(){
        Set<String> setOfPermissionSet = new Set<String>();
         for(PermissionSetAssignment permissionSetName :[SELECT PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment 
                                                                WHERE ( AssigneeId= :UserInfo.getUserId() 
                                                                       and (PermissionSet.Name IN: new List<String>{
                                                                           label.DIWApplicationEngineer,
                                                                           label.DIWPhysicalDesignEngineer, 
                                                                           label.DIWDesignCenterEngineer,
                                                                           label.DIWProductEngineer }))])
         {
            setOfPermissionSet.add(String.valueOf(permissionSetName.PermissionSet.Name)); 
         }
         return setOfPermissionSet;
     }
    
    public static ID requote(Id cdsId){
        try{
            id reqinfoid;
            Custom_Design__c cds = [Select Id, Device__c, Device__r.Last_Accepted_Quote__c 
                                    From Custom_Design__c 
                                    Where id =:cdsId LIMIT 1];
            if(null !=cds && null != cds.Device__c && null !=cds.Device__r.Last_Accepted_Quote__c){
                 reqinfoid = BNPRIRequoteCtrl.BNPRIRequote(cds.Device__r.Last_Accepted_Quote__c);
            }
            return reqinfoid;
        }
        catch(exception e){
            ApexPages.addMessages(e);
            return null;
        }      
    } 
    
    /**
    * @description fetchOpportunityTeamEmails method to collect the Opportunity Team Member based on 
    * Applicable Design Execution
    * @param    No Parameter
    * @return   List<String>: Opportunity Team member Email
    */
    public static Set<String> fetchOpportunityTeamEmails(Id deid){
        string str = Label.DesignExecutionTeamRole;
        List<String> teamRole =str.split('\\|');
        Set<String> oppTeamEmails = new Set<String>();
        //Call page Header 
        Design_Execution__c designExecution = fetchDErecords(deid);
        for(Opportunity_Program_Team_Member__c oppTeamEmail : [SELECT User_Full_Name__c,User_Email__c,Team_Role__c,User__r.phone FROM Opportunity_Program_Team_Member__c 
                            WHERE Team_Role__c in :teamRole 
                            AND Opportunity_Id__c =: designexecution.Opportunity__c]){
            oppTeamEmails.add(oppTeamEmail.User_Email__c);
        }
		return oppTeamEmails;
    }  
}