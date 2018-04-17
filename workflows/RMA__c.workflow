<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RMA_14_days_After_Draft</fullName>
        <ccEmails>rma_mail_log_service@v-2gfjhfg2dmoieh9t1v4cnvyiry5n39sik82r4ytdc2cd7lg7gk.o-4xpjamaa.cs5.apex.sandbox.salesforce.com</ccEmails>
        <description>RMA:14 days After Draft</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RMA_Email_Templates/RMA_14_Days_After_Draft</template>
    </alerts>
    <alerts>
        <fullName>RMA_14_days_After_Rejected</fullName>
        <ccEmails>rma_mail_log_service@v-2gfjhfg2dmoieh9t1v4cnvyiry5n39sik82r4ytdc2cd7lg7gk.o-4xpjamaa.cs5.apex.sandbox.salesforce.com</ccEmails>
        <description>RMA:14 days After Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RMA_Email_Templates/RMA_14_Days_After_Rejected</template>
    </alerts>
    <alerts>
        <fullName>RMA_22_days_After_Draft</fullName>
        <ccEmails>rma_mail_log_service@v-2gfjhfg2dmoieh9t1v4cnvyiry5n39sik82r4ytdc2cd7lg7gk.o-4xpjamaa.cs5.apex.sandbox.salesforce.com</ccEmails>
        <description>RMA:22 days After Draft</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RMA_Email_Templates/RMA_22_Days_After_Draft</template>
    </alerts>
    <alerts>
        <fullName>RMA_Email_Resubmission_APLC</fullName>
        <description>RMA:Email:Resubmission:APLC</description>
        <protected>false</protected>
        <recipients>
            <recipient>RMA_APLC_Members</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RMA_Email_Templates/RMA_Receiving_Team</template>
    </alerts>
    <alerts>
        <fullName>RMA_Email_Resubmission_Zone88</fullName>
        <description>RMA:Email:Resubmission:Zone88</description>
        <protected>false</protected>
        <recipients>
            <recipient>RMA_Zone88_Members</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RMA_Email_Templates/RMA_Receiving_Team</template>
    </alerts>
    <alerts>
        <fullName>RMA_ForSTMAlert</fullName>
        <ccEmails>qiaoqiao.zhang2@globalfoundries.com</ccEmails>
        <ccEmails>SiewWei.RUSSELL@globalfoundries.com</ccEmails>
        <ccEmails>Jacqueline.TAN@globalfoundries.com</ccEmails>
        <ccEmails>peggy.falkner@globalfoundries.com</ccEmails>
        <ccEmails>yokemeng.kek@globalfoundries.com</ccEmails>
        <description>RMA:ForSTMAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>RMA_STM_To_Address_List</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RMA_Email_Templates/RMA_STM_Template</template>
    </alerts>
    <alerts>
        <fullName>RMA_ReturntoGFAcknForSTMAlert</fullName>
        <ccEmails>qiaoqiao.zhang2@globalfoundries.com</ccEmails>
        <ccEmails>SiewWei.RUSSELL@globalfoundries.com</ccEmails>
        <ccEmails>Jacqueline.TAN@globalfoundries.com</ccEmails>
        <ccEmails>peggy.falkner@globalfoundries.com</ccEmails>
        <ccEmails>yokemeng.kek@globalfoundries.com</ccEmails>
        <description>RMA:ReturntoGFAcknForSTMAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>RMA_STM_To_Address_List</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RMA_Email_Templates/RMA_STM_ReturntoGFAckn_Template</template>
    </alerts>
    <alerts>
        <fullName>RMA_ScrapAcknForSTMAlert</fullName>
        <ccEmails>qiaoqiao.zhang2@globalfoundries.com</ccEmails>
        <ccEmails>SiewWei.RUSSELL@globalfoundries.com</ccEmails>
        <ccEmails>Jacqueline.TAN@globalfoundries.com</ccEmails>
        <ccEmails>peggy.falkner@globalfoundries.com</ccEmails>
        <ccEmails>yokemeng.kek@globalfoundries.com</ccEmails>
        <description>RMA:ScrapAcknForSTMAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>RMA_STM_To_Address_List</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RMA_Email_Templates/RMA_STM_ScrapAcknowledgement_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>RMA_ClosedDate_NOW</fullName>
        <field>Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>RMA:ClosedDate:NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_CompensationType_NoComp</fullName>
        <field>Compensation_Type__c</field>
        <literalValue>No Compensation</literalValue>
        <name>RMA:CompensationType:NoComp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_CustomerShortName_SharingRule</fullName>
        <field>Customer_Short_Name_Sharing_Rule__c</field>
        <formula>Customer__r.Short_Name__c</formula>
        <name>RMA:CustomerShortName(SharingRule)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_DispositionByQuality_Scrap</fullName>
        <field>Disposition_by_Quality__c</field>
        <literalValue>Scrap</literalValue>
        <name>RMA:DispositionByQuality:Scrap</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_FabCategory_Fab</fullName>
        <field>Fab_Category__c</field>
        <literalValue>Fab</literalValue>
        <name>RMA:FabCategory:Fab</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_FabCategory_NonFab</fullName>
        <field>Fab_Category__c</field>
        <literalValue>Non-Fab</literalValue>
        <name>RMA:FabCategory:NonFab</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_FabCategory_Turnkey</fullName>
        <field>Fab_Category__c</field>
        <literalValue>Turnkey</literalValue>
        <name>RMA:FabCategory:Turnkey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Fourteen_Days_After_Rejected_True</fullName>
        <field>Fourteen_Days_after_RMA_Rejected__c</field>
        <literalValue>1</literalValue>
        <name>RMA:Fourteen Days After Rejected:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_NoOverdueDays</fullName>
        <field>No_of_Overdue_Days__c</field>
        <formula>IF(	Workflow_Stage__c  = &apos;RMA Raised&apos;,
	Cycle_time_consumed_for_CSR_Submission__c - Cycle_Time_for_CSR_Submission__c,
	IF(	Workflow_Stage__c  = &apos;Pending For Fab Validation&apos; || 
		Workflow_Stage__c == &apos;Pending for Turnkey/ Sub-con Validation&apos; || 
		Workflow_Stage__c == &apos;Pending for Non Fab Category Validation&apos;,
		Cycle_time_consumed_for_Fab_Validation__c - Cycle_Time_for_Fab_Validation__c,
		IF(	Workflow_Stage__c  == &apos;Pending for Regional Recommendation - Director&apos; ||
			Workflow_Stage__c  == &apos;Pending for Regional Recommendation - VP&apos; ||
			Workflow_Stage__c  == &apos;Pending for Regional Approval - Snr. VP&apos;,
			Cycle_time_consumed_for_RegionalApproval__c - Cycle_Time_for_Regional_Approval__c,
			/*IF(	Workflow_Stage__c  == &apos;Pending for Finance Approval - Verifier&apos; ||
				Workflow_Stage__c  == &apos;Pending for Finance Approval - Accountant&apos; ||
				Workflow_Stage__c  == &apos;Pending for Finance Approval - Manager&apos; ||
				Workflow_Stage__c  == &apos;Pending for Finance Approval - CEO Direct Report&apos; ||
				Workflow_Stage__c  == &apos;Pending for Finance Approval - CFO&apos; ||
				Workflow_Stage__c  == &apos;Pending for Finance Approval - CEO&apos; ||
				Workflow_Stage__c  == &apos;Pending for Finance Verification&apos;,*/
			IF(
				OR( 
					Workflow_Stage__c == &apos;Pending for Finance Approval - Manager&apos;, 
					Workflow_Stage__c == &apos;Pending for Finance Approval - Fab Director&apos;, 
					Workflow_Stage__c == &apos;Pending for Finance Approval - VP Operations,Finance&apos;, 
					Workflow_Stage__c == &apos;Pending for Finance Approval - Corporate Controller&apos;, 
					Workflow_Stage__c == &apos;Pending for Finance Approval - Pricing Council&apos; 
				),	
				Cycle_time_consumed_for_Finance_Approval__c - Cycle_Time_for_Finance_Approval__c,
				IF(	Workflow_Stage__c  == &apos;Pending for Receipt of Physical Wafers&apos; ||
					Workflow_Stage__c  == &apos;Pending for Receipt of Scrap Certificate&apos; ||
					Workflow_Stage__c  == &apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos;,
					Cycle_time_consumed_for_Wafer_Ack__c - Cycle_Time_for_Wafer_Acknowledgement__c,
					NULL
				)
			)
		)			
	)
)</formula>
        <name>RMA:NoOverdueDays</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_QueueInTimeForAck_Conditional</fullName>
        <field>Queue_in_Time_for_Wafer_Acknowledgement__c</field>
        <formula>IF(
AND(
ISNULL(Queue_in_Time_for_Wafer_Acknowledgement__c),
OR(
AND(
ISPICKVAL(RMA_Category__c,&apos;Technical/ Turnkey&apos;),
ISPICKVAL(ReasonCode__c,&apos;R50&apos;)
),
ISPICKVAL(RMA_Category__c,&apos;Failure Analysis&apos;)
)
),
NOW(),
NULL
)</formula>
        <name>RMA:QueueInTimeForAck:Conditional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_in_time_for_CQ_Validation</fullName>
        <field>Queue_in_Time_for_CQ_Validation__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue in time for CQ Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_in_time_for_CSR_Submission</fullName>
        <description>This field update is used to populate the Queue_in_Time_for_CSR_Submission__c from Customer_Request_Date__c</description>
        <field>Queue_in_Time_for_CSR_Submission__c</field>
        <formula>Customer_Request_Date__c</formula>
        <name>RMA Queue in time for CSR Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_in_time_for_Fab_Validation</fullName>
        <description>This field update is used to update the Queue_in_Time_for_Fab_Validation__c	when RMA is submitted for Fab Validation</description>
        <field>Queue_in_Time_for_Fab_Validation__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue in time for Fab Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_in_time_for_Finance_Approval</fullName>
        <description>This field update is used to update Queue_in_Time_for_Finance_Approval__c when RMA is submitted for Finance Approval</description>
        <field>Queue_in_Time_for_Finance_Approval__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue in time for Finance Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_in_time_for_Regional_Approval</fullName>
        <description>This field is used to update Queue_in_Time_for_Regional_Approval__c when RMA is submitted for Regional Approval</description>
        <field>Queue_in_Time_for_Regional_Approval__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue in time for Regional Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_in_time_for_Wafer_Ack</fullName>
        <description>This field is used to populate Queue_in_Time_for_Wafer_Acknowledgement__c</description>
        <field>Queue_in_Time_for_Wafer_Acknowledgement__c</field>
        <formula>IF(ISNULL(Queue_in_Time_for_Wafer_Acknowledgement__c), NOW(), Queue_in_Time_for_Wafer_Acknowledgement__c)</formula>
        <name>RMA Queue in time for Wafer Ack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_out_time_for_CQ_Validation</fullName>
        <field>Queue_out_Time_for_CQ_Validation__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue out time for CQ Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_out_time_for_CSR_Submission</fullName>
        <description>This field update is used to update Queue_out_Time_for_CSR_Submission__c when RMA is submitted by CSR</description>
        <field>Queue_out_Time_for_CSR_Submission__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue out time for CSR Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_out_time_for_Fab_Validation</fullName>
        <description>This field update is used to populate the Queue_out_Time_for_Fab_Validation__c when RMA which is submitted for Fab Validation is :
1. Rejected (in Fab, Turn key, Non Fab) or
2. Submitted for Regional Approval.</description>
        <field>Queue_out_Time_for_Fab_Validation__c</field>
        <formula>IF(ISPICKVAL( RMA_Category__c , &apos;Business&apos;), NULL, NOW())</formula>
        <name>RMA Queue out time for Fab Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_out_time_for_Finance_Approval</fullName>
        <description>This field is used to update the queue out time for Finance Approval when RMA is accepted/rejected by Finance Approvers</description>
        <field>Queue_out_Time_for_Finance_Approval__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue out time for Finance Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_out_time_for_Regional_Approval</fullName>
        <description>This field update is used to update Queue_out_Time_for_Regional_Approval__c when RMA is approved/rejected by Regional Approvers</description>
        <field>Queue_out_Time_for_Regional_Approval__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue out time for Regional Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_out_time_for_Wafer_Ack</fullName>
        <description>This field update is used to update Queue_out_Time_for_Wafer_Acknowledgement__c</description>
        <field>Queue_out_Time_for_Wafer_Acknowledgement__c</field>
        <formula>NOW()</formula>
        <name>RMA Queue out time for Wafer Ack</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReAssignTo_BLANK</fullName>
        <field>ReAssign_To__c</field>
        <name>RMA:ReAssignTo:BLANK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReasontoVoid_Noclaimdetailssubmit</fullName>
        <field>Reason_to_Void__c</field>
        <formula>&quot;No claim details submitted.&quot;</formula>
        <name>RMA:ReasontoVoid:Noclaimdetailssubmit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_RejectionDate_NOW</fullName>
        <field>Rejection_Date__c</field>
        <formula>NOW()</formula>
        <name>RMA:RejectionDate:NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderAck1Day_True</fullName>
        <field>Reminder_Acknowledgement_1_Day__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderAck1Day:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderAck2Days_True</fullName>
        <field>Reminder_Acknowledgement_2_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderAck2Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderAck3Days_True</fullName>
        <field>Reminder_Acknowledgement_3_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderAck3Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderAckDueDate_True</fullName>
        <field>Reminder_Acknowledgement_Due_Date__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderAckDueDate:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFabValidation2Days_True</fullName>
        <field>Reminder_Fab_Validation_2_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFabValidation2Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFabValidation3Days_True</fullName>
        <field>Reminder_Fab_Validation_3_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFabValidation3Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFabValidationOneDay_True</fullName>
        <field>Reminder_Fab_Validation_One_Day__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFabValidationOneDay:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFabvalidationDueDate_True</fullName>
        <field>Reminder_Fab_Validation_Due_Date__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFabvalidationDueDate:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFinanceApproval1Day_True</fullName>
        <field>Reminder_Finance_Approval_1_Day__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFinanceApproval1Day:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFinanceApproval2Days_True</fullName>
        <field>Reminder_Finance_Approval_2_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFinanceApproval2Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFinanceApproval3Days_True</fullName>
        <field>Reminder_Finance_Approval_3_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFinanceApproval3Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderFinanceApprovalDue_True</fullName>
        <field>Reminder_Finance_Approval_Due__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderFinanceApprovalDue:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderQualityApproval1Day_True</fullName>
        <field>Reminder_Quality_Approval_1_Day__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderQualityApproval1Day:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderQualityApproval2Days_True</fullName>
        <field>Reminder_Quality_Approval_2_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderQualityApproval2Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderQualityApproval3Days_True</fullName>
        <field>Reminder_Quality_Approval_3_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderQualityApproval3Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderQualityApprovalDueDate_True</fullName>
        <field>Reminder_Quality_Approval_Due_Date__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderQualityApprovalDueDate:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderRegRec1Day_True</fullName>
        <field>Reminder_Reg_Recommendation_1_Day__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderRegRec1Day:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderRegRec2Days_True</fullName>
        <field>Reminder_Reg_Recommendation_2_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderRegRec2Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderRegRec3Days_True</fullName>
        <field>Reminder_Reg_Recommendation_3_Days__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderRegRec3Days:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ReminderRegRecDueDate_True</fullName>
        <field>Reminder_Reg_Recommendation_Due_Date__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ReminderRegRecDueDate:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>RMA:Status:Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>RMA:Status:Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Status_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>RMA:Status:Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Status_Voided</fullName>
        <field>Status__c</field>
        <literalValue>Voided</literalValue>
        <name>RMA:Status:Voided</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Twenty_Two_Days_After_Rejected_True</fullName>
        <field>Twenty_Two_Days_after_RMA_Rejected__c</field>
        <literalValue>1</literalValue>
        <name>RMA:Twenty Two Days After Rejected:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Update_RMA_Name</fullName>
        <field>Name</field>
        <formula>&apos;RMA&apos; 
&amp; IF(TEXT(Fab__c) = &apos;Fab 3E&apos; || TEXT(Fab__c) = &apos;Fab 10&apos;,
	MID(TEXT(Fab__c), 5, LEN(TEXT(Fab__c))),
	IF(TEXT(Fab__c) = &apos;ALTIS&apos;,
		&apos;XF&apos;,
		&apos;0&apos; &amp; MID(TEXT(Fab__c), 5, LEN(TEXT(Fab__c)))
	   )
	)
&amp; &apos;-&apos; 
&amp; TEXT(YEAR( DATEVALUE(CreatedDate))) 
&amp; &apos;-&apos; 
&amp; RMA_Autonumber__c</formula>
        <name>RMA: Update RMA Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_ValidatedQuality_True</fullName>
        <field>Validated_Quality__c</field>
        <literalValue>1</literalValue>
        <name>RMA:ValidatedQuality:True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_AfterFinManagerConditional</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
AND( Grand_Total_Final__c  &gt; 50000,
Grand_Total_Final__c   &lt;= 1000000 ),
&apos;Pending for Finance Approval - Fab Director&apos;,
IF(
AND( Grand_Total_Final__c  &gt; 1000000,
Grand_Total_Final__c   &lt;= 3000000),
&apos;Pending for Finance Approval - VP Operations,Finance&apos;,
IF(
Grand_Total_Final__c &gt; 3000000,
&apos;Pending for Finance Approval - Corporate Controller&apos;,
IF(
Grand_Total_Final__c &gt; 5000000,
&apos;Pending for Finance Approval - Pricing Council&apos;,
&apos;Pending for Finance Approval - Manager&apos;
)
)
)
)</formula>
        <name>RMA:WFStage:AfterFinManagerConditional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_ConditionalAfterTechQuality</fullName>
        <description>NJain - 11Jul16 - Checked the Re-evaluate flag for Triggering the Time- based workflows approval from Customer Quality Validation.</description>
        <field>Workflow_Stage__c</field>
        <formula>IF(
OR(
ISPICKVAL(Fab__c,&apos;FAB 9&apos;),
ISPICKVAL(Fab__c,&apos;FAB 10&apos;),
ISPICKVAL(Fab__c,&apos;ALTIS&apos;)
),
IF(
OR( 
ISPICKVAL(RMA_Category__c,&apos;Technical/ Turnkey&apos;) &amp;&amp; 
!(ISPICKVAL(ReasonCode__c,&apos;R50&apos;) &amp;&amp; Grand_Total_Price__c &lt;= 2000), 
ISPICKVAL(RMA_Category__c,&apos;Rework&apos;) 
),
&quot;Pending for Fab Validation&quot;, 
IF(
ISPICKVAL(RMA_Category__c,&apos;Business&apos;), 
&quot;Pending for CSR Manager Approval&quot;, 
IF( 
AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;), 
!Acknowledged_Wafer_Return__c), 
&quot;Pending for Receipt of Physical Wafers&quot;, 
IF( 
AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;), 
!Acknowledged_Wafer_Scrap__c), 
&quot;Pending for Receipt of Scrap Certificate&quot;, 
IF( 
AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;), 
!Acknowledged_Wafer_Return__c, 
!Acknowledged_Wafer_Scrap__c), 
&quot;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&quot;, 
&quot;Disposition of Wafers Not Defined&quot; 
) 
) 
) 
)
),
IF(
ISPICKVAL(RMA_Category__c, &apos;Business&apos;),
IF(
Is_SMPLSI__c,
&quot;Pending for Product Engineering - Manager&quot;,
&quot;Pending for Regional Recommendation - Director&quot;
),
IF(
ISPICKVAL(RMA_Category__c, &apos;Failure Analysis&apos;),
IF( 
AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;), 
!Acknowledged_Wafer_Return__c), 
&quot;Pending for Receipt of Physical Wafers&quot;, 
IF( 
AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;), 
!Acknowledged_Wafer_Scrap__c), 
&quot;Pending for Receipt of Scrap Certificate&quot;, 
IF( 
AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;), 
!Acknowledged_Wafer_Return__c, 
!Acknowledged_Wafer_Scrap__c), 
&quot;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&quot;, 
&quot;Disposition of Wafers Not Defined&quot; 
) 
) 
),
IF(
ISPICKVAL(Assign_To__c,&apos;Fab&apos;),
IF(
Is_SMPLSI__c,
&quot;Pending for Product Engineering Validation&quot;,
&quot;Pending for Fab Validation&quot;
),
&quot;Pending for Turnkey/ Sub-con Validation&quot;
)
)
)
)</formula>
        <name>RMA:WFStage:ConditionalAfterTechQuality</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_ConditionalSOCNIssue</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
  OR(ISPICKVAL(Fab__c,&quot;FAB 9&quot;),ISPICKVAL(Fab__c,&quot;FAB 10&quot;),ISPICKVAL(Fab__c,&quot;ALTIS&quot;)),
  IF(ISPICKVAL(Compensation_Type__c,&quot;Replacement&quot;),
      &quot;Pending for SO Issue&quot;,
      &quot;Pending for CN Issue&quot;
  ),
  &quot;Pending for SO Issue&quot;
)</formula>
        <name>RMA:WFStage:ConditionalSOCNIssue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_Logistic</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
ISPICKVAL(ReasonCode__c,&apos;R25&apos;),
&quot;Pending for Logistics Approval&quot;,
NULL
)</formula>
        <name>RMA:WFStage:Logistic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_PendingCQValidation</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&quot;Pending for Quality Validation&quot;</formula>
        <name>RMA:WFStage:PendingCQValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_PendingSOIssue</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&quot;Pending for SO Issue&quot;</formula>
        <name>RMA:WFStage:PendingSOIssue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFStage_PricingCouncil</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
 Grand_Total_Final__c &gt; 5000000,
 &apos;Pending for Finance Approval - Pricing Council&apos;,
 NULL
)</formula>
        <name>RMA:WFStage:PricingCouncil</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_AfterFinanceARapproval</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF( Grand_Total_Final__c &gt; 25000 &amp;&amp; Grand_Total_Final__c&lt;=50000, 
    &apos;Pending for Finance Approval - Finance Director&apos;,
    IF( Grand_Total_Final__c &gt; 50000 &amp;&amp; Grand_Total_Final__c&lt;=1000000, 
        &apos;Pending for Finance Approval - Fab Director&apos;,
        IF( Grand_Total_Final__c &gt; 1000000 &amp;&amp; Grand_Total_Final__c&lt;=3000000, 
            &apos;Pending for Finance Approval - VP Operations,Finance&apos;,
            IF( (Grand_Total_Final__c &gt; 3000000 &amp;&amp; Grand_Total_Final__c&lt;=5000000 &amp;&amp; !ISPICKVAL(Fab__c,&apos;FAB 5&apos;)) ||
                (Grand_Total_Final__c &gt; 60000   &amp;&amp; Grand_Total_Final__c&lt;=5000000 &amp;&amp;  ISPICKVAL(Fab__c,&apos;FAB 5&apos;)), 
                &apos;Pending for Finance Approval - Corporate Controller&apos;,
                IF( Grand_Total_Final__c &gt; 5000000,
                    &apos;Pending for Finance Approval - Pricing Council&apos;,
                    &apos;No Stage Found for Finance Approval&apos;
                )
            )
        )
    )
)</formula>
        <name>RMA:WFstage:AfterFinanceARapproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_Closed_RMA</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&apos;Closed RMA&apos;</formula>
        <name>RMA:WFstage:Closed RMA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_Conditional</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF( 
	ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp;
	Acknowledged_Wafer_Return__c,
	IF(!ISPICKVAL(RMA_Category__c,&apos;Rework&apos;),&apos;Pending for Finance Approval - Verifier&apos;,&apos;Pending for SO Issue&apos;),
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp;
		!Acknowledged_Wafer_Return__c,
		&apos;Pending for Receipt of Physical Wafers&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) 
		&amp;&amp; Acknowledged_Wafer_Scrap__c,
		IF(!ISPICKVAL(RMA_Category__c,&apos;Rework&apos;),&apos;Pending for Finance Approval - Verifier&apos;,&apos;Pending for SO Issue&apos;),
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) 
		&amp;&amp; !Acknowledged_Wafer_Scrap__c,
		&apos;Pending for Receipt of Scrap Certificate&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp;	
		Acknowledged_Wafer_Return__c &amp;&amp;	
		Acknowledged_Wafer_Scrap__c,
		IF(!ISPICKVAL(RMA_Category__c,&apos;Rework&apos;),&apos;Pending for Finance Approval - Verifier&apos;,&apos;Pending for SO Issue&apos;),
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp;	
		!(Acknowledged_Wafer_Return__c &amp;&amp; Acknowledged_Wafer_Scrap__c),
		&apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos;,&apos;Disposition of Wafers Not Defined&apos;
	)
	)
	)
	)
	)
)</formula>
        <name>RMA:WFstage:Conditional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_Failure_Analysis</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF( 
	ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp;
	Acknowledged_Wafer_Return__c,
	&apos;Closed RMA&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp;
		!Acknowledged_Wafer_Return__c,
		&apos;Pending for Receipt of Physical Wafers&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) 
		&amp;&amp; Acknowledged_Wafer_Scrap__c,
		&apos;Closed RMA&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) 
		&amp;&amp; !Acknowledged_Wafer_Scrap__c,
		&apos;Pending for Receipt of Scrap Certificate&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp;	
		Acknowledged_Wafer_Return__c &amp;&amp;	
		Acknowledged_Wafer_Scrap__c,
		&apos;Closed RMA&apos;,
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp;	
		!(Acknowledged_Wafer_Return__c &amp;&amp; Acknowledged_Wafer_Scrap__c),
		&apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos;,&apos;Disposition of Wafers Not Defined&apos;
	)
	)
	)
	)
	)
)</formula>
        <name>RMA:WFstage:Failure Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_FinanceConditional</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
  ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp; Acknowledged_Wafer_Return__c,
  IF(!ISPICKVAL(RMA_Category__c,&apos;Rework&apos;),
    &apos;Pending for Finance Approval - Manager&apos;,
    IF(
      AND(!ISPICKVAL(Fab__c,&apos;FAB 9&apos;),!ISPICKVAL(Fab__c,&apos;FAB 10&apos;),!ISPICKVAL(Fab__c,&apos;ALTIS&apos;)),
      &apos;Pending for SO Issue&apos;,
      /*&apos;Pending for CN Issue&apos;*/&apos;Closed RMA&apos;
    )
  ),
  IF(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp; !Acknowledged_Wafer_Return__c,
    &apos;Pending for Receipt of Physical Wafers&apos;,
    IF(
      ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) &amp;&amp; Acknowledged_Wafer_Scrap__c,
      IF(!ISPICKVAL(RMA_Category__c,&apos;Rework&apos;),&apos;Pending for Finance Approval - Manager&apos;,
        IF(
          AND(!ISPICKVAL(Fab__c,&apos;FAB 9&apos;),!ISPICKVAL(Fab__c,&apos;FAB 10&apos;),!ISPICKVAL(Fab__c,&apos;ALTIS&apos;)),
          &apos;Pending for SO Issue&apos;,
          /*&apos;Pending for CN Issue&apos;*/&apos;Closed RMA&apos;
        )
      ),
      IF(ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) &amp;&amp; !Acknowledged_Wafer_Scrap__c,
        &apos;Pending for Receipt of Scrap Certificate&apos;,
        IF(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp; 
           Acknowledged_Wafer_Return__c &amp;&amp; 
           Acknowledged_Wafer_Scrap__c,
          IF(!ISPICKVAL(RMA_Category__c,&apos;Rework&apos;),&apos;Pending for Finance Approval - Manager&apos;,
            IF(
              AND(!ISPICKVAL(Fab__c,&apos;FAB 9&apos;),!ISPICKVAL(Fab__c,&apos;FAB 10&apos;),!ISPICKVAL(Fab__c,&apos;ALTIS&apos;)),
              &apos;Pending for SO Issue&apos;,
              /*&apos;Pending for CN Issue&apos;*/&apos;Closed RMA&apos;
            )
          ),
          IF(
            ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp; 
            !(Acknowledged_Wafer_Return__c &amp;&amp; Acknowledged_Wafer_Scrap__c),
            &apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos;,&apos;Disposition of Wafers Not Defined&apos;
          )
        )
      )
    )
  )
)</formula>
        <name>RMA:WFstage:FinanceConditional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingFabValidation</fullName>
        <field>Workflow_Stage__c</field>
        <formula>/*IF( Customer__r.Short_Name__c == &apos;agere&apos; &amp;&amp;  ISPICKVAL(Fab__c,&apos;FAB 5&apos;) ,
    &apos;Pending for Product Engineering Validation&apos;,
    &apos;Pending for Fab Validation&apos;
)*/
IF( Is_SMPLSI__c ,
    &apos;Pending for Product Engineering Validation&apos;,
    &apos;Pending for Fab Validation&apos;
)</formula>
        <name>RMA:WFstage:PendingFabValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingFinanceARmgr</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&quot;Pending for Finance Approval - AR Section Manager&quot;</formula>
        <name>RMA:WFstage:PendingFinanceARmgr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingFinanceManager</fullName>
        <field>Workflow_Stage__c</field>
        <formula>/*IF(AND(NOT(ISPICKVAL( Fab__c ,&quot;&quot;)),
Intercompany__c  = FALSE),
&quot;Pending for Finance Approval - Manager&quot;,
&quot;Pending for Finance Approval - AR Section Manager&quot;)*/
IF(
AND(
NOT(ISPICKVAL(Fab__c,&quot;&quot;)),
Intercompany__c  = TRUE,
AND(
NOT(ISPICKVAL(Fab__c,&apos;FAB 1&apos;)),
NOT(ISPICKVAL(Fab__c,&apos;FAB 8&apos;))
)
),
&quot;Pending for Finance Approval - AR Section Manager&quot;,
&quot;Pending for Finance Approval - Manager&quot;
)</formula>
        <name>RMA:WFstage:PendingFinanceManager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingNonFabValidation</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&apos;Pending for Non Fab Category Validation&apos;</formula>
        <name>RMA:WFstage:PendingNonFabValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingPEValidation</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&apos;Pending for Product Engineering Validation&apos;</formula>
        <name>RMA:WFstage:PendingPEValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingProdEnggDirector</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&apos;Pending for Product Engineering - Director&apos;</formula>
        <name>RMA:WFstage:PendingProdEnggDirector</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_PendingTurnkeyValidation</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&apos;Pending for Turnkey/ Sub-con Validation&apos;</formula>
        <name>RMA:WFstage:PendingTurnkeyValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_Pending_CN_Issue</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
  ISPICKVAL(RMA_Category__c,&quot;Rework&quot;) || ISPICKVAL(Compensation_Type__c,&quot;Replacement&quot;),
  &quot;Closed RMA&quot;,
  &quot;Pending for CN Issue&quot;
)</formula>
        <name>RMA:WFstage:Pending CN Issue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_R50</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(
	ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;) &amp;&amp; Acknowledged_Wafer_Return__c,
	IF(!ISPICKVAL(Compensation_Type__c,&apos;Replacement&apos;),&apos;Pending for CN Issue&apos;,&apos;Pending for SO Issue&apos;),
	IF(
		ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;) &amp;&amp; Acknowledged_Wafer_Scrap__c,
		IF(!ISPICKVAL(Compensation_Type__c,&apos;Replacement&apos;),&apos;Pending for CN Issue&apos;,&apos;Pending for SO Issue&apos;),
		IF(
			ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF and to Scrap at Customer Site&apos;) &amp;&amp;	Acknowledged_Wafer_Return__c &amp;&amp;	Acknowledged_Wafer_Scrap__c,
			IF(!ISPICKVAL(Compensation_Type__c,&apos;Replacement&apos;),&apos;Pending for CN Issue&apos;,&apos;Pending for SO Issue&apos;),
			Workflow_Stage__c
		)
	)
)</formula>
        <name>RMA:WFstage:R50</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_RegionalRecommendation</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF(ISPICKVAL(RMA_Category__c,&apos;Business&apos;),
IF( AND(Is_SMPLSI__c  = TRUE,ISPICKVAL(Fab__c,&apos;FAB 5&apos;)),
&apos;Pending for Product Engineering - Manager&apos;,
&apos;Pending for Regional Recommendation - Director&apos;),
Workflow_Stage__c)</formula>
        <name>RMA:WFstage:RegionalRecommendation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_RejectedRMA</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&apos;Rejected RMA&apos;</formula>
        <name>RMA:WFstage:RejectedRMA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WFstage_TechnicalToRegional</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF( !ISNULL(TEXT(ReAssign_To__c)) &amp;&amp; 
    !ISBLANK(TEXT(ReAssign_To__c)),
    IF(
        ISPICKVAL(ReAssign_To__c,&apos;Assign to Non-Fab&apos;),
        &apos;Pending for Non Fab Category Validation&apos;,
        IF(
            ISPICKVAL(ReAssign_To__c,&apos;Assign to Turnkey&apos;),
            &apos;Pending for Turnkey/ Sub-con Validation&apos;,
            IF(
                ISPICKVAL(ReAssign_To__c,&apos;Assign to Fab&apos;),
                IF( /*Customer__r.Short_Name__c == &apos;agere&apos; &amp;&amp; ISPICKVAL(Fab__c,&apos;FAB 5&apos;)*/ Is_SMPLSI__c , 
					&apos;Pending for Product Engineering Validation&apos;, 
					&apos;Pending for Fab Validation&apos; 
				),
				&apos;&apos;
            )
        )
     ),
    IF( /*Customer__r.Short_Name__c == &apos;agere&apos; &amp;&amp; ISPICKVAL(Fab__c,&apos;FAB 5&apos;)*/Is_SMPLSI__c , 
		&apos;Pending for Product Engineering - Manager&apos;, 
		&apos;Pending for Regional Recommendation - Director&apos;
	)
)</formula>
        <name>RMA:WFstage:TechnicalToRegional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WStage_PendingRegRecommSrVP</fullName>
        <field>Workflow_Stage__c</field>
        <formula>IF( 
AND(Grand_Total_Price__c &gt; 1000000, 
Is_SMPLSI__c  = false),
&quot;Pending for Regional Approval - Snr. VP&quot;,
Workflow_Stage__c)</formula>
        <name>RMA:WStage:PendingRegRecommSrVP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_WorkflowStage_VoidedBySystem</fullName>
        <field>Workflow_Stage__c</field>
        <formula>&quot;Voided by System&quot;</formula>
        <name>RMA:WorkflowStage:VoidedBySystem</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RMA Closed</fullName>
        <actions>
            <name>RMA_WFstage_Closed_RMA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    Workflow_Stage__c == &apos;Pending for CN Issue&apos;,    CN_DN_Number__c != NULL,   CN_DN_Number__c != &apos;&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA SO Populated</fullName>
        <actions>
            <name>RMA_WFstage_Pending_CN_Issue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    Workflow_Stage__c == &apos;Pending for SO Issue&apos;,    Sales_Order_Number__c != NULL,   Sales_Order_Number__c != &apos;&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A RMA is Closed</fullName>
        <actions>
            <name>RMA_ClosedDate_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RMA_Status_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), NOT( $Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  Workflow_Stage__c = &apos;Closed RMA&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A Send to Finance after Wafer Acknowledgement</fullName>
        <actions>
            <name>RMA_WFstage_FinanceConditional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the Workflow Stage when the wafers are acknowledged after the Finance Approval.</description>
        <formula>AND(  	OR(  		Workflow_Stage__c = &apos;Pending for Receipt of Physical Wafers&apos; &amp;&amp; Acknowledged_Wafer_Return__c,  		Workflow_Stage__c = &apos;Pending for Receipt of Scrap Certificate&apos; &amp;&amp; Acknowledged_Wafer_Scrap__c,  		Workflow_Stage__c = &apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos; &amp;&amp; Acknowledged_Wafer_Return__c &amp;&amp; Acknowledged_Wafer_Scrap__c  	), 	!ISPICKVAL(RMA_Category__c,&apos;Failure Analysis&apos;), 	!(ISPICKVAL(RMA_Category__c,&apos;Technical/ Turnkey&apos;) &amp;&amp; ISPICKVAL(ReasonCode__c,&apos;R50&apos;) &amp;&amp;  Grand_Total_Price__c &lt;=2000) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A Update Queue in time for CSR Submission</fullName>
        <actions>
            <name>RMA_Queue_in_time_for_CSR_Submission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is used to update the queue in time for CSR Submission</description>
        <formula>AND(NOT(ISNULL( Customer_Request_Date__c )), OR(ISNEW() || ISCHANGED(Customer_Request_Date__c )),  ISPICKVAL(Status__c, &apos;Draft&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A Update Queue in time for Fab Validation</fullName>
        <actions>
            <name>RMA_Queue_in_time_for_Fab_Validation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND ((2 AND 3 AND (4 OR 5 OR 6)) OR (7 AND (5 OR 6)))</booleanFilter>
        <criteriaItems>
            <field>RMA__c.Queue_in_Time_for_Fab_Validation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.RMA_Category__c</field>
            <operation>equals</operation>
            <value>Technical/ Turnkey</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Assign_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Turnkey/ Sub-con Validation</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Fab Validation</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Product Engineering Validation</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.RMA_Category__c</field>
            <operation>notEqual</operation>
            <value>Technical/ Turnkey</value>
        </criteriaItems>
        <description>This workflow rule is used to  update the Queue_in_Time_for_Fab_Validation__c when RMA is submitted for Fab Validation ( Fab 1-8). Assign To flag is checked to be not blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A Update Queue out time for CSR Submission</fullName>
        <actions>
            <name>RMA_Queue_out_time_for_CSR_Submission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is used to update the queue in time for CSR Submission</description>
        <formula>AND(  OR(     ISPICKVAL(PRIORVALUE(Status__c) , &apos;Draft&apos;),      ISPICKVAL(PRIORVALUE(Status__c) , &apos;Rejected&apos;)  ),  ISPICKVAL(Status__c, &apos;Submitted&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A Update Queue out time for Wafer Acknowledgment</fullName>
        <actions>
            <name>RMA_Queue_in_time_for_Wafer_Ack</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RMA_Queue_out_time_for_Wafer_Ack</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is used to populate the Queue_out_Time_for_Wafer_Acknowledgement__c when RMA is created.</description>
        <formula>OR( 	AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;), Acknowledged_Wafer_Scrap__c),  	AND(ISPICKVAL(Disposition_of_Wafers__c,&apos;Return to GF&apos;), Acknowledged_Wafer_Return__c),  	AND(ISPICKVAL(Disposition_of_Wafers__c, &apos;Return to GF and to Scrap at Customer Site&apos;), Acknowledged_Wafer_Return__c, Acknowledged_Wafer_Scrap__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3A Update RMA Name</fullName>
        <actions>
            <name>RMA_Update_RMA_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), NOT( $Setup.IntegrationUsers__c.Skip_Validation_Rule__c), OR( ISCHANGED(Fab__c), ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AApprove RMA after Wafer Acknowledgement for R50</fullName>
        <actions>
            <name>RMA_Status_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RMA_WFstage_R50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the Workflow Stage as Approved when the wafers are acknowledged for Technical/Turnkey RMA with Reason Code:R50</description>
        <formula>AND(  	OR(  		Workflow_Stage__c = &apos;Pending for Receipt of Physical Wafers&apos; &amp;&amp; Acknowledged_Wafer_Return__c,  		Workflow_Stage__c = &apos;Pending for Receipt of Scrap Certificate&apos; &amp;&amp; Acknowledged_Wafer_Scrap__c,  		Workflow_Stage__c = &apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos; &amp;&amp; Acknowledged_Wafer_Return__c &amp;&amp; Acknowledged_Wafer_Scrap__c  	),  	ISPICKVAL(RMA_Category__c,&apos;Technical/ Turnkey&apos;), 	ISPICKVAL(ReasonCode__c,&apos;R50&apos;),         Grand_Total_Price__c &lt;= 2000 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AClose RMA after Wafer Acknowledgement for FA</fullName>
        <actions>
            <name>RMA_Status_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RMA_WFstage_Failure_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the Workflow Stage as Closed when the wafers are acknowledged for Failure Analysis RMA.</description>
        <formula>AND(  	OR(  		Workflow_Stage__c = &apos;Pending for Receipt of Physical Wafers&apos; &amp;&amp; Acknowledged_Wafer_Return__c,  		Workflow_Stage__c = &apos;Pending for Receipt of Scrap Certificate&apos; &amp;&amp; Acknowledged_Wafer_Scrap__c,  		Workflow_Stage__c = &apos;Pending for Receipt of Physical Wafers &amp; Scrap Certificate&apos; &amp;&amp; Acknowledged_Wafer_Return__c &amp;&amp; Acknowledged_Wafer_Scrap__c  	),  	ISPICKVAL(RMA_Category__c,&apos;Failure Analysis&apos;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AClosedRMAForSTM</fullName>
        <actions>
            <name>RMA_ForSTMAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), ISCHANGED(Workflow_Stage__c),  Workflow_Stage__c = &apos;Closed RMA&apos;,  Customer_Short_Name__c = &apos;stmicro&apos;   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3ADispositionByQuality%3ADispWafers</fullName>
        <actions>
            <name>RMA_DispositionByQuality_Scrap</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the field &quot;Disposition by Quality&quot; based on the field &quot;Disposition of Wafers&quot;</description>
        <formula>(ISPICKVAL(Fab__c,&apos;FAB 9&apos;) || ISPICKVAL(Fab__c,&apos;FAB 10&apos;) || ISPICKVAL(Fab__c,&apos;ALTIS&apos;)) &amp;&amp;  ISCHANGED(Disposition_of_Wafers__c) &amp;&amp; ISPICKVAL(Disposition_of_Wafers__c,&apos;To Scrap at Customer Site&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AEmail%3AResubmission%3AAPLC</fullName>
        <actions>
            <name>RMA_Email_Resubmission_APLC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to APLC Team in case the rejected RMA is re-submitted for approval.</description>
        <formula>AND(     PRIORVALUE(Workflow_Stage__c) == &apos;Rejected RMA&apos;,     Workflow_Stage__c == &apos;Pending for Quality Validation&apos;,     ISPICKVAL(Return_Location__c,&apos;APLC&apos;),     (ISPICKVAL(Fab__c,&apos;FAB 9&apos;) || ISPICKVAL(Fab__c,&apos;FAB 10&apos;) || ISPICKVAL(Fab__c,&apos;ALTIS&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AEmail%3AResubmission%3ABurlington</fullName>
        <actions>
            <name>RMA_Email_Resubmission_Zone88</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to Zone88 Team in case the rejected RMA is re-submitted for approval.</description>
        <formula>AND(     PRIORVALUE(Workflow_Stage__c) == &apos;Rejected RMA&apos;,     Workflow_Stage__c == &apos;Pending for Quality Validation&apos;,     ISPICKVAL(Return_Location__c,&apos;Burlington&apos;),     (ISPICKVAL(Fab__c,&apos;FAB 9&apos;) || ISPICKVAL(Fab__c,&apos;FAB 10&apos;) || ISPICKVAL(Fab__c,&apos;ALTIS&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AEscalationMail%3APendingFinanceApproval</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Finance Approval - Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Finance Approval - Fab Director</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Finance Approval - VP Operations,Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Finance Approval - Corporate Controller</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Finance Approval - Pricing Council</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFinanceApproval2Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Finance_Approval__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFinanceApproval1Day_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Finance_Approval__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFinanceApproval3Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Finance_Approval__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFinanceApprovalDue_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Finance_Approval__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3AEscalationMail%3APendingForFabValdiation</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Fab Validation</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Turnkey/ Sub-con Validation</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Non Fab Category Validation</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Product Engineering Validation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFabvalidationDueDate_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Fab_Validation__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFabValidation3Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Fab_Validation__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFabValidation2Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Fab_Validation__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderFabValidationOneDay_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Fab_Validation__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3AEscalationMail%3APendingForQualityApproval</fullName>
        <active>true</active>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Quality Validation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderQualityApprovalDueDate_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Quality_Validation__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderQualityApproval2Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Quality_Validation__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderQualityApproval1Day_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Quality_Validation__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderQualityApproval3Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Quality_Validation__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3AEscalationMail%3APendingForRegRecommendation</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Regional Recommendation - Director</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Regional Approval - Snr. VP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderRegRec1Day_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Regional_Approval__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderRegRec2Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Regional_Approval__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderRegRec3Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Regional_Approval__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderRegRecDueDate_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.Escalation_Date_for_Regional_Approval__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3AFailureAnalysis%3ACompensationType</fullName>
        <actions>
            <name>RMA_CompensationType_NoComp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RMA__c.RMA_Category__c</field>
            <operation>equals</operation>
            <value>Failure Analysis</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AOnSubmissionForSTM</fullName>
        <actions>
            <name>RMA_ForSTMAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>/*AND( OR(PRIORVALUE(Status__c) = &apos;Draft&apos;, PRIORVALUE(Status__c) = &apos;Rejected&apos;),  Customer_Short_Name__c = &apos;stmicro&apos;,  ISPICKVAL(Status__c, &apos;Submitted&apos;)  )*/ AND( NOT( $Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  OR( ISPICKVAL(PRIORVALUE(Status__c),&apos;Draft&apos;), ISPICKVAL(PRIORVALUE(Status__c),&apos;Rejected&apos;) ), ISPICKVAL(Status__c, &apos;Submitted&apos;), Customer_Short_Name__c = &apos;stmicro&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3APendingAcknowledgement%3AReminder</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Receipt of Physical Wafers</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Receipt of Scrap Certificate</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Workflow_Stage__c</field>
            <operation>equals</operation>
            <value>Pending for Receipt of Physical Wafers &amp; Scrap Certificate</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Is_SMPLSI__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderAck2Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.EscalationDateForWaferAcknowledgement__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderAckDueDate_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.EscalationDateForWaferAcknowledgement__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderAck1Day_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.EscalationDateForWaferAcknowledgement__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_ReminderAck3Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.EscalationDateForWaferAcknowledgement__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3APendingCNIssueForSTM</fullName>
        <actions>
            <name>RMA_ForSTMAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  ISCHANGED(Workflow_Stage__c), Workflow_Stage__c = &apos;Pending for CN Issue&apos;,   Customer_Short_Name__c = &apos;stmicro&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3APopulate Customer ShortName for Sharing Rule</fullName>
        <actions>
            <name>RMA_CustomerShortName_SharingRule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This field is used for the Sharing Rule to check for the SMPLSI condition. Creating this additional field as we cannot refer the Formula field in the Sharing Rule for RMA.</description>
        <formula>ISCHANGED(Customer__c) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AReminderForCSRRejection</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>RMA__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>RMA__c.Twenty_Two_Days_after_RMA_Rejected__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Send reminder after 14 days when RMA is rejected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_14_days_After_Rejected</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.LastModifiedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Status_Voided</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>RMA_Twenty_Two_Days_After_Rejected_True</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>RMA_WorkflowStage_VoidedBySystem</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.LastModifiedDate</offsetFromField>
            <timeLength>22</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3AReminderToCSROnDraft</fullName>
        <active>true</active>
        <criteriaItems>
            <field>RMA__c.Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_22_days_After_Draft</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>RMA_Status_Voided</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>RMA_WorkflowStage_VoidedBySystem</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>22</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_14_days_After_Draft</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA%3AReturnToGFAcknForSTM</fullName>
        <actions>
            <name>RMA_ReturntoGFAcknForSTMAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  OR(  ISPICKVAL( Disposition_of_Wafers__c , &apos;Return to GF&apos;),  ISPICKVAL( Disposition_of_Wafers__c , &apos;Return to GF and to Scrap at Customer Site&apos;)   ),  PRIORVALUE(Acknowledged_Wafer_Return__c) = FALSE,   Acknowledged_Wafer_Return__c = TRUE,  Customer_Short_Name__c = &apos;stmicro&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA%3AScrapAcknForSTM</fullName>
        <actions>
            <name>RMA_ScrapAcknForSTMAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), OR(  ISPICKVAL( Disposition_of_Wafers__c , &apos;To Scrap at Customer Site&apos;),  ISPICKVAL( Disposition_of_Wafers__c , &apos;Return to GF and to Scrap at Customer Site&apos;)   ),  PRIORVALUE(Acknowledged_Wafer_Scrap__c) = FALSE,   Acknowledged_Wafer_Scrap__c  = TRUE,  Customer_Short_Name__c = &apos;stmicro&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
