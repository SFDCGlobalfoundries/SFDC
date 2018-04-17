/*
Type Name: MRSEmailTemplateQuery 
Author: Cognizant 
Created Date: 27-February-2015
Reason: This class queries all the MRS related email templates once. 
Change History:

*/

public class MRSEmailTemplateQuery {
	public static Map<String,EmailTemplate> mapEmailTemplateAndName;
	public static Boolean queryOnce = false;
	
	public static void emailTemplateQuery(){
		if(!queryOnce){
			List<EmailTemplate> emailTemplatelst = [SELECT id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate 
	                                         where DeveloperName 
	                                         IN ('SWIFT_Customer_Gating_GDSOUTReview','SWIFT_Send_Data_Done','SWIFT_Layer_Chip_Manual_Update_Error_Template','MRS_Void_Chip_Template',
	                                              'SWIFT_Gating_Tapeout_Application_Custom','SWIFT_Non_Gating_Tapeout_Application_Custom','Swift_Device_Customer_MEBES_is_Released','Swift_Device_Foundry_MEBES_is_Released',
	                                              'SWIFT_Send_Email_To_GS_TDTI_MPW_Subsequent','SWIFT_Gating_Tapeout_Center_Initial','SWIFT_Customer_Frame_Mockup_Ready_Email','SWIFT_Foundry_Frame_Mockup_Ready_Email',
	                                              'SWIFT_Customer_Gating_MEBES_Received_Subsequent','SWIFT_Foundry_Gating_MEBES_Received_Subsequent','SWIFT_Customer_Non_Gating_MEBES_Subsequent','SWIFT_Foundry_Non_Gating_MEBES_Subsequent',
	                                              'SWIFT_Gating_MDP_Initial','SWIFT_Foundry_Gating_GDSOUTReview','SWIFT_Gating_MDP_Subsequent','SWIFT_Gating_Tapeout_Center_Subsequent',
	                                              'SWIFT_Customer_Gating_Remote_Jobview_Initial','SWIFT_Customer_Non_Gating_Remote_Jobview_Initial','SWIFT_Foundry_Gating_Remote_Jobview_Initial','SWIFT_Foundry_Non_Gating_Remote_Jobview_Initial',
	                                              'Swift_Customer_Gating_MEBES_Recieved_Initial','SWIFT_Customer_Non_Gating_MEBES_Recieved_Initial','Swift_Foundry_Gating_MEBES_Recieved_Initial','SWIFT_Foundry_Non_Gating_MEBES_Recieved_Initial',
	                                              'SWIFT_Send_Gating_Email_To_Tapeout_Applications_Subsequent','SWIFT_Send_Non_Gating_Email_To_Tapeout_Applications_Subsequent',
	                                              'Swift_Device_Tapeout_Applications_MEBES_is_Released','Swift_Device_GlobalShuttle_MEBES_is_Released','Swift_Device_TDTI_MPW_MEBES_is_Released',
	                                              'SWIFT_Customer_Gating_Remote_JobView_Subsequent','SWIFT_Foundry_Gating_Remote_JobView_Subsequent','Swift_Device_Frame_Mockup_is_Approved_Custom','Swift_Device_Frame_Mockup_is_Disapproved_Custom',
	                                              'Swift_Device_Tapeout_Centre_MEBES_is_Released','Swift_Device_MDP_MEBES_is_Released','Swift_Device_Prime_GDSOUT_Review_is_Approved_Custom',
	                                              'SWIFT_Send_Email_To_GS_Subsequent','SWIFT_Send_Email_To_TDTI_MPW_Subsequent','SWIFT_TDTI_Initial','SWIFT_GlobalShuttle_Initial',
	                                              'SWIFT_Customer_Non_Gating_Remote_Jobview_Subsequent','SWIFT_Foundry_Non_Gating_Remote_Jobview_Subsequent','Test_Template')];
	        mapEmailTemplateAndName = new Map<String,EmailTemplate>();
	        if(emailTemplatelst != null && emailTemplatelst.size() > 0){
		        for(EmailTemplate emailTemplateObj :emailTemplatelst){
		            mapEmailTemplateAndName.put(emailTemplateObj.DeveloperName,emailTemplateObj);
		        }
	        }
	        queryOnce = true;
		}
	}
}