/**
@Author < Nikhil Bajaj >
@name < cloneIPRwithSizing vf >
@CreateDate < 1/5/2016 >
@Description < cloning Ip_sizingoptions Records with ip request >
@Version <1.0>
*/
public class CloneIPRwithSizing {

    private ApexPages.StandardController controller {get; set;}
    
    private IP_Request__c ipr {get;set;}
    
    public ID newRecordId {get;set;}
    public CloneIPRwithSizing(ApexPages.StandardController controller) {
       
        this.controller = controller;
        
        ipr = (IP_Request__c)controller.getRecord();

    }
    
    public PageReference cloning() {
        Savepoint sp = Database.setSavepoint();
        IP_Request__c newIPR;
          try {
              //copy the IPRequest - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             
             ipr =[select Id,Account_Manager__c,Account_Manager_Cell_Phone__c,Account_Manager_Email__c,Account_Manager_Name__c,Account_Manager_Office_Phone__c,Account_Manager_Phone__c,Acknowledged_by_FAE__c,Additional_Mask_Info__c,Additional_Opportunity_1__c,Additional_Opportunity_2__c,Adjustment_Range_Dll__c,Adjustment_Resolution_Dll__c,AE__c,Amount_of_Funding_Approved__c,Approval_Communication_to_Customer__c,Approved_by__c,Approved_Date__c,Approve_for_Full_Assessment__c,Approve_for_Sizing__c,Approve_for_Sizing_T__c,Approver_1__c,Approver_10__c,Approver_2__c,Approver_3__c,Approver_4__c,Approver_5__c,Approver_6__c,Approver_7__c,Approver_8__c,Approver_9__c,Aprprox_Dev_Funding_Available__c,Architecture__c,ASIC_Sizing_by__c,Assumptions__c,Bid_approval_for_restricted_IP__c,Bist_Memory__c,Bit_Cell_Size_um2__c,Block_Size_Configurations__c,Bond_Pad_Opening_Size__c,Bond_Pad_Pitch__c,Brand__c,Built_In_Charge_Pump__c,Business_Decision__c,Business_Unit__c,Cache_Size__c,Certification__c,Charging_Org__c,Checkpoint_Date__c,IP_Information_Comment__c,Competitor_Situation__c,Configurator_Plus__c,Core_Type__c,Cup__c,Current_Win_Probability__c,Customer_Account_Name__c,Customer_commits_to_design__c,Customer_Communication_Prep_Internal__c,Customer_Expectation__c,Customer_IP_Contact_Name_Lkp__c,Customer_Name__c,Customer_Response_external__c,Data_Retention__c,Deciding_T__c,Density_Range__c,Dependencies__c,Development_Sizing_Effort__c,Development_Sizing_Effort_MD__c,Device__c,Die_Size_Estimator_Level_Sizing__c,Different_Supplier__c,DIW_MDParts_Name__c,DIW_Project__c,Dnl__c,Dynamic_Power_Based_On_X1nand2__c,End_Application__c,Endurance_Mtp__c,ERD__c,Esd_Cdm__c,Esd_Hbm__c,Esd_Mm__c,Estimated_Complexity__c,Evaluators_or_Contacts__c,Existing_IP_Usage__c,Expected1__c,Expected2__c,Expected3__c,Fab__c,FAE_Email__c,FAE_Name__c,FAE_Phone__c,FAE_Review_T__c,FDK__c,Final_DK_Need_by__c,Final_Physical_Views__c,Fin_Range__c,Fout_Range__c,Frequency_Topspeed__c,Front_End_DK_Need_by__c,Front_end_Views__c,Funding_and_Schedule_Match__c,Funding_Source_Approved__c,Gate_Density__c,Geometry__c,GMPL__c,Has_Technology_Dependencies_been_address__c,Height_Io__c,Height_Um__c,Hs_Fs_Ls_Usb__c,Improved_Schedule__c,Initial_Assessment__c,Initial_Assessment_T__c,Initial_Assessment_by__c,INL__c,Inline_Or_Staggered__c,Input_Voltage_V__c,Internal_Stage__c,IP_Feature__c,IP_ITAR_Compliant__c,IP_Name__c,IP_Request_Description__c,IP_Request_Restriction__c,IP_Request_Status__c,IP_Sub_type__c,IP_Type__c,ITAR_Compliant__c,ITAR_Instructions__c,List__c,Load_Current__c,Market_Segment__c,Market_Segment_Sub_Segment_in_Plan__c,Max1__c,Max2__c,Max3__c,Meet_Need_by_Dates__c,Memory_Density_Range__c,Min1__c,Min2__c,Min3__c,MPW_for_Test_Chip__c,Nearest_IP_ID__c,New_del__c,New_IP_ID__c,Next_Checkpoint__c,Non_Production_DK_Need_by__c,Non_Standard_PVTs__c,No_of_RFQ__c,Number_Of_Cells_In_Library__c,Number_Of_Lanes__c,Number_Of_Tracks__c,NVM_Type__c,Opportunity__c,Opportunity_ITAR_Compliant__c,Opportunity_Priority__c,Opportunity_Rating__c,Orientation__c,Originator__c,Other_Opportunities_List__c,Others__c,Overall_Comment__c,Package__c,Parent_IP_Request__c,PDK__c,PDK_Version__c,Performance__c,Period_Jitter__c,PLM_Approve_for_sizing__c,Power_Active__c,Power_Standby__c,Preliminary_Physical_Views__c,Process_Node2__c,Process_Technology__c,Production_DK_Need_by__c,Product_Line__c,Programming_Time__c,Program_Voltage_Vpp__c,Projected_Start_date__c,Projected_Tapeout_Date__c,Projecedt_Testchip_Date__c,Project_Name__c,Proposed_Funding_Source__c,Provide_Options__c,Provide_Sizing_T__c,Quiescent_Current__c,Read_Access_Time__c,Reason_for_Request__c,Redundancy__c,Reg_Output_Voltage_V__c,Rejection_Communication_to_Customer__c,Released_Communication_to_Customer__c,Request_Category__c,Requested_IP_in_Roadmap__c,Request_Type__c,Research__c,Resolution__c,Revenue__c,Reviewed_by_AM__c,Reviewed_by_FAE__c,RFQ__c,RFQ_S_Due_Date__c,Risks__c,Roadmap__c,RTA__c,RTC__c,RTF_1__c,RTF_2__c,RTL__c,RTM__c,RTP__c,Rules_Views_Required__c,Sampling_Rate__c,Silicon_Area__c,Silicon_Validation_Need_by__c,Sized__c,Sizing_Completed__c,Sizing_Expiration__c,Sizing_Required_By__c,Source_Status_of_investigation__c,Special_Non_ASIC_rules_required__c,Specification_and_standards_if_any__c,Speed__c,Speed_Gbps__c,Stage__c,Standard_Compliance__c,Standard_Product_Name__c,Standard_Product_Revenue__c,Standby_Power_Based_On_X1nand2__c,Status__c,Submitted_to_GF__c,Tapless_Library__c,Target_Markets__c,Target_MPW__c,Technical_Area__c,Technical_Comments__c,Test_Chip_GDSII_MPW__c,Text_to_be_included_in_Quote__c,Type_of_Request__c,Updated_Specification__c,Use_LVT_RVT_Devices_only__c,Wb_Or_Fc__c,X1_Nand2_Delay__c from IP_Request__c where id = :ipr.id];
                
             newIPR = ipr.clone(false);
             insert newIPR;
             
             newRecordId = newIPR.id;
            
             List<IP_Sizing__c> sizinglist = new List<IP_Sizing__c>();
             
            
            for (IP_Sizing__c pi : [Select Area__c,ASIC_Sized_By__c,Assumptions__c,Charging_Org__c,Competitive_Offerings__c,Dependencies__c,Dev_t_Sizing_Effort_Person_Days__c,Has_Technology_Dependency_Responded__c,IP_Request__c,Others__c,Risks__c,Sized_By__c,Sizing_Expiration_Date__c From IP_Sizing__c p where IP_Request__c = :ipr.id]) {
             
                  if(pi !=null){
                  IP_Sizing__c  newPI = pi.clone(false);
                  newPI.IP_Request__c  = newIPR.id;
                
                                             
                  sizinglist.add(newPI);
              
                  }                        
             }

             insert sizinglist;

             }catch (Exception excp) {
                  Database.rollback(sp);
                  ApexPages.addMessages(excp);
                  GlobalUtility.logMessage('Error','CloneIPRwithSizing','cloning','','Exception while cloning IpSizingOptions records',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                  
               } 
              
             
             return new PageReference('/'+newIPR.id+'/e?retURL=%2F'+newIPR.id);
    
    }

}