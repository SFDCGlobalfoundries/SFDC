<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BUG_Email_notification_on_Bug_status_change</fullName>
        <description>BUG Email notification on Bug status change</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/BUG_Email_Notification_for_Bug_resolved_Status</template>
    </alerts>
    <alerts>
        <fullName>Bug_Assignment_Email_Alert</fullName>
        <description>Bug Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/Email_Notification_for_Bug_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Bug_Creation_Email_Alert</fullName>
        <ccEmails>bugcustomerresponse@1q07k2og5i3k8j8chk6i2aoxjqmz9x15fzrqnwtj3t1z4k6zp9.9-hfndeau.ap4.apex.salesforce.com</ccEmails>
        <description>Bug Creation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/Email_Notification_for_Bug_Creation</template>
    </alerts>
    <alerts>
        <fullName>Bug_Priority_Alert</fullName>
        <description>Bug Priority Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/Bug_Priority_Alert</template>
    </alerts>
    <alerts>
        <fullName>Bug_Update_Email_Alert</fullName>
        <description>Bug Update Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Bug_Templates/Email_Notification_for_Bug_update</template>
    </alerts>
    <alerts>
        <fullName>IPDEV_Bug_Assignment_Email_Alert</fullName>
        <description>IPDEV Bug Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/Email_Notification_for_IPDEV_Bug_Assignment</template>
    </alerts>
    <alerts>
        <fullName>IPDEV_Bug_Email_Notification_for_Resolved_Closed_Status_Change</fullName>
        <description>IPDEV Bug Email Notification for Resolved Closed Status Change</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/IPDEV_Bug_Email_Notification_for_Resolved_Closed</template>
    </alerts>
    <alerts>
        <fullName>IP_Email_Notification_for_IPDEV_Creation</fullName>
        <description>IP Email Notification for IPDEV Creation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/Email_Notification_for_IPDEV_Creation</template>
    </alerts>
    <alerts>
        <fullName>SR_Simulation_Request_Creation_Notification</fullName>
        <description>SR Simulation Request Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/SR_Simulation_Request_Created</template>
    </alerts>
    <alerts>
        <fullName>SR_Simulation_Request_Ownership_Notification</fullName>
        <description>SR Simulation Request Ownership Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/SR_Simulation_Request_Ownership_Transfer</template>
    </alerts>
    <alerts>
        <fullName>SR_Status_Changed_to_Closed_Mail_to_Creator</fullName>
        <description>SR Status Changed to Closed_Mail to Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/SR_Email_Notification_for_Closed_Status</template>
    </alerts>
    <alerts>
        <fullName>WR_Approval_Reminder_to_Creator</fullName>
        <description>WR Approval Reminder to Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/WR_Approval_Reminder_to_Creator</template>
    </alerts>
    <alerts>
        <fullName>WR_Approval_Reminder_to_Executive_Team</fullName>
        <description>WR Approval Reminder to Executive Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/WR_Approval_Reminder_to_Executive_Team</template>
    </alerts>
    <alerts>
        <fullName>WR_Approval_Reminder_to_Group</fullName>
        <description>WR Approval Reminder to Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>WR_Escalation_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/WR_Approval_Reminder_to_Group</template>
    </alerts>
    <alerts>
        <fullName>WR_Approval_Reminder_to_PLM</fullName>
        <description>WR Approval Reminder to PLM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/WR_Approval_Reminder_to_PLM</template>
    </alerts>
    <alerts>
        <fullName>WR_Approval_Reminder_to_PM</fullName>
        <description>WR Approval Reminder to PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/WR_Approval_Reminder_to_PM</template>
    </alerts>
    <alerts>
        <fullName>WR_Approval_Reminder_to_QA_Team</fullName>
        <description>WR Approval Reminder to QA Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Bug_Templates/WR_Approval_Reminder_to_QA_Team</template>
    </alerts>
    <alerts>
        <fullName>WR_Notification_for_PDK_Request_Creation</fullName>
        <description>WR Notification for PDK Request Creation</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/WR_Notification_for_PDK_Request_Creation</template>
    </alerts>
    <alerts>
        <fullName>WR_Ownership_Transferred_Notification</fullName>
        <description>WR Ownership Transferred Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/WR_Notification_for_Ownership_Transfer</template>
    </alerts>
    <alerts>
        <fullName>WR_Status_Changed_Notification</fullName>
        <description>WR Status Changed Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Bug_Templates/WR_Email_Notification_for_Status_Changed</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASIC_Field_IsAsicCIASubmitted_False</fullName>
        <field>IsAsicCIASubmitted__c</field>
        <literalValue>0</literalValue>
        <name>ASIC Field IsAsicCIASubmitted False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASIC_Update_Date_Approved_by_CIA</fullName>
        <description>Date Approved by CIA</description>
        <field>Date_Approved_by_CIA__c</field>
        <formula>Today()</formula>
        <name>ASIC Update Date Approved by CIA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASIC_Update_Date_Approved_for_Release</fullName>
        <description>Date Approved for Release</description>
        <field>Date_Approved_for_Release__c</field>
        <formula>Today()</formula>
        <name>ASIC Update Date Approved for Release</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASIC_Update_Status_of_CIA_To_Approve</fullName>
        <field>Status_of_CIA_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>ASIC Update Status of CIA To Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASIC_Update_Status_of_CIA_To_Reject</fullName>
        <field>Status_of_CIA_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>ASIC Update Status of CIA To Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Auto_Populate_Bug_Assigned_Date</fullName>
        <description>Auto populate bug assigned date with system date/ time when Bug is moved to Assigned status.</description>
        <field>Bug_Assigned_Date__c</field>
        <formula>Now()</formula>
        <name>Auto Populate Bug Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Auto_Populate_Bug_Closed_Date</fullName>
        <description>Auto populate bug closed date with system date/ time when bug is moved to Closed status.</description>
        <field>Bug_Closed_Date__c</field>
        <formula>Now()</formula>
        <name>Auto Populate Bug Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Auto_Populate_Bug_Resolved_Date</fullName>
        <description>Auto populate bug resolved date with system date/ time when bug is moved to Closed - Resolved status.</description>
        <field>Bug_Resolved_Date__c</field>
        <formula>Now()</formula>
        <name>Auto Populate Bug Resolved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BugASIC_FetchingAccountShortName</fullName>
        <field>Customer_Code__c</field>
        <formula>Account_Affected__r.Short_Name__c</formula>
        <name>BugASIC_FetchingAccountShortName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bug_Re_Open_Count</fullName>
        <description>This Field Update will update the Re_Open_Count__c to store value no of time Bug reopened.</description>
        <field>Re_Open_Count__c</field>
        <formula>IF(ISNULL(PRIORVALUE(Re_Open_Count__c)), 0, PRIORVALUE(Re_Open_Count__c) )+1</formula>
        <name>Bug Re-Open Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bug_Smart_Power_Auto_Populate_ClosByDate</fullName>
        <field>Close_By_Date__c</field>
        <formula>Now()+7</formula>
        <name>Bug Smart Power Auto Populate ClosByDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SR_Simulation_Request_Ownership_Count</fullName>
        <field>Ownership_Transfer_Count__c</field>
        <formula>IF(ISNULL(PRIORVALUE(Ownership_Transfer_Count__c)), 0, PRIORVALUE(Ownership_Transfer_Count__c) )+1</formula>
        <name>SR Simulation Request Ownership Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SR_Simulation_Request_Ownership_Transfer</fullName>
        <description>This workflow will reset the Ownership Transfer Count.</description>
        <field>Ownership_Transfer_Count__c</field>
        <formula>0</formula>
        <name>SR Simulation Request Ownership Transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SR_Simulation_Request_Private_Field_True</fullName>
        <description>This workflow Field Update will update the Private field to True</description>
        <field>Private__c</field>
        <literalValue>1</literalValue>
        <name>SR Simulation Request Private Field True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_LOE</fullName>
        <description>Update the field Total LOE based on Total level of Effort and IsAutoupdateLOE.</description>
        <field>Total_LOE__c</field>
        <formula>Total_Level_of_Effort__c</formula>
        <name>WR_Update Total LOE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsPLMSatisfied_True</fullName>
        <field>IsPLMSatisfied__c</field>
        <literalValue>1</literalValue>
        <name>WR Field IsPLMSatisfied True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsPLMSolutionSubmitted_False</fullName>
        <field>IsPLMSolutionSubmitted__c</field>
        <literalValue>0</literalValue>
        <name>WR Field IsPLMSolutionSubmitted False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsPLMSubmitted_False</fullName>
        <field>IsPLMSubmitted__c</field>
        <literalValue>0</literalValue>
        <name>WR Field IsPLMSubmitted False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsQASubmitted_False</fullName>
        <field>IsQASubmitted__c</field>
        <literalValue>0</literalValue>
        <name>WR Field IsQASubmitted False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsReopenSubmitted_True</fullName>
        <field>IsReopenSubmitted__c</field>
        <literalValue>1</literalValue>
        <name>WR Field IsReopenSubmitted True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsReopen_True</fullName>
        <field>IsReopen__c</field>
        <literalValue>1</literalValue>
        <name>WR Field IsReopen True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsSolutionAutoRejected_False</fullName>
        <field>IsSolutionAutoRejected__c</field>
        <literalValue>0</literalValue>
        <name>WR Field IsSolutionAutoRejected False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsSolutionAutoRejected_True</fullName>
        <field>IsSolutionAutoRejected__c</field>
        <literalValue>1</literalValue>
        <name>WR Field IsSolutionAutoRejected True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsSoulutionApproval_True</fullName>
        <field>IsSoulutionApproval__c</field>
        <literalValue>1</literalValue>
        <name>WR Field IsSoulutionApproval True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsTransferToProjectManagerFalse</fullName>
        <field>IsTransferToProjectManager__c</field>
        <literalValue>0</literalValue>
        <name>WR Field IsTransferToProjectManagerFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_IsTransferToProjectManager_True</fullName>
        <field>IsTransferToProjectManager__c</field>
        <literalValue>1</literalValue>
        <name>WR Field IsTransferToProjectManager True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_Update_Approval_Deadline_RESET</fullName>
        <field>Approval_Deadline_Date__c</field>
        <name>WR Field Update Approval Deadline RESET</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Field_Update_Re_open_Count</fullName>
        <field>Work_Request_Re_open_Count__c</field>
        <formula>IF(ISNULL(PRIORVALUE(Work_Request_Re_open_Count__c)), 0, PRIORVALUE(Work_Request_Re_open_Count__c) )+1</formula>
        <name>WR Field Update Re-open Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_RecordType_Update_PDK_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PDK_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WR RecordType Update PDK Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_RecordType_Update_PDK_Request2</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PDK_Request2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WR RecordType Update PDK Request2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_RecordType_Update_PDK_Request3</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PDK_Request3</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WR RecordType Update PDK Request3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Assigned_Owner</fullName>
        <field>Stages__c</field>
        <literalValue>Assigned-Owner</literalValue>
        <name>WR Stage Update Assigned-Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Assigned_Queue</fullName>
        <field>Stages__c</field>
        <literalValue>Assigned-Queue</literalValue>
        <name>WR Stage Update Assigned-Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Executive_Team_Approved</fullName>
        <field>Stages__c</field>
        <literalValue>Executive Team-Approved</literalValue>
        <name>WR Stage Update Executive Team-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Executive_Team_Rejected</fullName>
        <field>Stages__c</field>
        <literalValue>Executive Team-Rejected</literalValue>
        <name>WR Stage Update Executive Team-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Implementation</fullName>
        <field>Stages__c</field>
        <literalValue>Implementation</literalValue>
        <name>WR Stage Update Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_New_Request_Rejected</fullName>
        <field>Stages__c</field>
        <literalValue>New Request-Rejected</literalValue>
        <name>WR Stage Update New Request-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_QA_Approved</fullName>
        <field>Stages__c</field>
        <literalValue>QA-Approved</literalValue>
        <name>WR Stage Update QA-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_QA_Rejected</fullName>
        <field>Stages__c</field>
        <literalValue>QA-Rejected</literalValue>
        <name>WR Stage Update QA-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Reopen_Approved</fullName>
        <field>Stages__c</field>
        <literalValue>Reopen-Approved</literalValue>
        <name>WR Stage Update Reopen-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Reopen_Rejected</fullName>
        <field>Stages__c</field>
        <literalValue>Reopen-Rejected</literalValue>
        <name>WR Stage Update Reopen-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Resolved_Closed</fullName>
        <field>Stages__c</field>
        <literalValue>Resolved-Closed</literalValue>
        <name>WR Stage Update Resolved-Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Stage_Update_Solution_Rejected</fullName>
        <field>Stages__c</field>
        <literalValue>Solution-Rejected</literalValue>
        <name>WR Stage Update Solution-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Status_Update_Assigned</fullName>
        <field>Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>WR Status Update Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Status_Update_Closed</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>WR Status Update Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Status_Update_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>WR Status Update Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Status_Update_Implementation</fullName>
        <field>Status__c</field>
        <literalValue>Implementation</literalValue>
        <name>WR Status Update Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Status_Update_New_Request</fullName>
        <field>Status__c</field>
        <literalValue>New Request</literalValue>
        <name>WR Status Update New Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Status_Update_Reopen</fullName>
        <field>Status__c</field>
        <literalValue>Reopen</literalValue>
        <name>WR Status Update Reopen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WR_Update_IsAutoUpdateLOE</fullName>
        <description>It will update IsAutoUpdateLOE based on Sum of Total LOE value.</description>
        <field>IsAutoUpdateLOE__c</field>
        <literalValue>0</literalValue>
        <name>WR Update IsAutoUpdateLOE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Bug Auto Populate Close By Date</fullName>
        <actions>
            <name>Bug_Smart_Power_Auto_Populate_ClosByDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), Record_Type_API__c = &apos;Smart_Power&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Bug Re-Open Count</fullName>
        <actions>
            <name>Bug_Re_Open_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will update the Re_Open_Count__c field which is used for Counting no of time Bug reopened.</description>
        <formula>AND(   NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  IsBug__c,  TEXT(PRIORVALUE(Status__c))=&quot;Closed&quot;, NOT(ISPICKVAL(Status__c, &quot;Closed&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bug Status Changed to Resolved_Mail to Creator</fullName>
        <actions>
            <name>BUG_Email_notification_on_Bug_status_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Whenever Bug status changes to resolved then the creator of the bug will get an email notification.</description>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  IsBug__c, ISPICKVAL(Status__c, &apos;Resolved&apos;) , ISCHANGED(Status__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bug Status Moved to Assigned</fullName>
        <actions>
            <name>Auto_Populate_Bug_Assigned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Rule to match when a bug is moved to Assigned status.</description>
        <formula>And( ISPICKVAL(Status__c, &apos;Assigned&apos;) , ISCHANGED(Status__c),   NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), IsBug__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bug Status Moved to Closed</fullName>
        <actions>
            <name>Auto_Populate_Bug_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Rule to match when a bug is moved to Closed status.</description>
        <formula>And( ISPICKVAL(Status__c, &apos;Closed&apos;) ,  ISCHANGED(Status__c) ,  NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), IsBug__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bug Status Moved to Resolved</fullName>
        <actions>
            <name>Auto_Populate_Bug_Resolved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Rule to match when a bug is moved to Closed - Resolved status.</description>
        <formula>And(  ISPICKVAL(Status__c, &apos;Resolved&apos;) , ISCHANGED(Status__c), NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  IsBug__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bug Status Update on Owner Change</fullName>
        <actions>
            <name>Bug_Assignment_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>And( ISCHANGED(OwnerId),   NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), IsBug__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bug_FetchingAccountShortName</fullName>
        <actions>
            <name>BugASIC_FetchingAccountShortName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT($Setup.IntegrationUsers__c.Is_Integration_User__c),  IsASICBug__c,OR(ISCHANGED( Account_Affected__c),ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification for Bug update</fullName>
        <actions>
            <name>Bug_Update_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>And(  LastModifiedDate &gt;  CreatedDate ,  !ISCHANGED( OwnerId ), NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c)   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notification for Bug creation</fullName>
        <actions>
            <name>Bug_Creation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>And( OwnerId != null,   OwnerId != &apos;&apos;,  NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  IsBug__c   )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IPDEV Bug Email Notification for Resolved Closed</fullName>
        <actions>
            <name>IPDEV_Bug_Email_Notification_for_Resolved_Closed_Status_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>And(OR(ISPICKVAL(Status__c, &apos;Closed&apos;),ISPICKVAL(Status__c, &apos;Resolved&apos;)),IsIPDEV__c,ISCHANGED(Status__c) , NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPDEV Bug Owner Change Email Alert</fullName>
        <actions>
            <name>IPDEV_Bug_Assignment_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>And(ISCHANGED(OwnerId),NOT($Setup.IntegrationUsers__c.Is_Integration_User__c),IsIPDEV__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPDEV Email Notification for Bug Creation</fullName>
        <actions>
            <name>IP_Email_Notification_for_IPDEV_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>IPDEV Email Notification for Bug Creation</description>
        <formula>And(OwnerId != null, OwnerId != &apos;&apos;, NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), IsIPDEV__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SR Simulation Request Creation</fullName>
        <actions>
            <name>SR_Simulation_Request_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SR_Simulation_Request_Ownership_Transfer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SR_Simulation_Request_Private_Field_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will be triggered when Simulation Request record created and will send Email notification accordingly.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  Record_Type_API__c = &apos;Simulation_Request&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SR Simulation Request Ownership Change</fullName>
        <actions>
            <name>SR_Simulation_Request_Ownership_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SR_Simulation_Request_Ownership_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will triggered when Simulation Request Ownership changes and will send Email notification to the Owner.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c),  NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),    OR( ISNEW() ,ISCHANGED(OwnerId)),   Record_Type_API__c = &apos;Simulation_Request&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SR Status Changed to Closed_Mail to Creator</fullName>
        <actions>
            <name>SR_Status_Changed_to_Closed_Mail_to_Creator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Whenever Bug status changes to resolved then the creator of the bug will get an email notification.</description>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  Record_Type_API__c =&apos;Simulation_Request&apos; , ISPICKVAL(Status__c, &apos;Closed&apos;) , ISCHANGED(Status__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WR Approval Reminder to Executive Team</fullName>
        <active>true</active>
        <description>This workflow will send email notification if the request is not approved for 3 days to owner and creator. Also it will send escalation mail to the WR Escalation group if the request is not approved for more than 7 days.</description>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  (IsPDKRequest__c ),  OR( AND(TEXT(Stages__c)=&apos;Executive Team-Submitted&apos;,TEXT(Status__c) = &apos;New Request&apos;), AND(TEXT(Stages__c)=&apos;Executive Team-Submitted&apos;,TEXT(Status__c) = &apos;Reopen&apos;), AND(TEXT(Stages__c)=&apos;Reopen-Approved&apos;,TEXT(Status__c) = &apos;Reopen&apos;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Group</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Creator</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WR_Approval_Reminder_to_Executive_Team</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WR Approval Reminder to PLM</fullName>
        <active>true</active>
        <description>This workflow will send email notification if the request is not approved for 3 days to owner and creator. Also it will send escalation mail to the WR Escalation group if the request is not approved for more than 7 days.</description>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  (IsPDKRequest__c ),  OR(  AND(TEXT(Stages__c)=&apos;New Request-Submitted&apos;,TEXT(Status__c) = &apos;New Request&apos;), AND(TEXT(Stages__c)=&apos;Solution-Submitted&apos;,TEXT(Status__c) = &apos;Pending Approval&apos;), AND(TEXT(Stages__c)=&apos;Implementation-Completed&apos;,TEXT(Status__c) = &apos;Completed&apos;), AND(TEXT(Stages__c)=&apos;New Request-Submitted&apos;,TEXT(Status__c) = &apos;Reopen&apos;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Group</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Creator</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WR_Approval_Reminder_to_PLM</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WR Approval Reminder to PM</fullName>
        <active>true</active>
        <description>This workflow will send email notification if the request is not approved for 3 days to owner and creator. Also it will send escalation mail to the WR Escalation group if the request is not approved for more than 7 days.</description>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  (IsPDKRequest__c ),  AND(TEXT(Stages__c)=&apos;Reopen-Submitted&apos;,TEXT(Status__c) = &apos;Completed&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Group</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Creator</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WR_Approval_Reminder_to_PM</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WR Approval Reminder to QA Team</fullName>
        <active>true</active>
        <description>This workflow will send email notification if the request is not approved for 3 days to owner and creator. Also it will send escalation mail to the WR Escalation group if the request is not approved for more than 7 days.</description>
        <formula>AND( NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  IsPDKRequest__c ,TEXT(Stages__c)=&apos;QA-Submitted&apos;,TEXT(Status__c) = &apos;Implementation&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Creator</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WR_Approval_Reminder_to_QA_Team</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Approval_Reminder_to_Group</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WR Auto Rejected Solution</fullName>
        <active>false</active>
        <description>This Workflow will update the Auto Reject Field True after Approval Deadline Date.</description>
        <formula>AND(NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), (IsPDKRequest__c ), NOT(IsSoulutionApproval__c), TEXT(Status__c)=&apos;Pending Approval&apos;,  TEXT(Stages__c)=&apos;Solution-Submitted&apos;  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WR_Field_IsSolutionAutoRejected_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Bug__c.Approval_Deadline_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WR New Request Status Update</fullName>
        <actions>
            <name>WR_Status_Update_New_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will update the Status field to &quot;New Request&quot; on record creation.</description>
        <formula>AND(NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), (IsPDKRequest__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WR Ownership Transferred Notification</fullName>
        <actions>
            <name>WR_Ownership_Transferred_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an email notification to the Request Owner when Ownership is Transferred to them.</description>
        <formula>AND(NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  (Record_Type_API__c =&apos;PDK_Request2&apos;),  ISCHANGED(OwnerId),  OR( TEXT(Status__c) = &apos;New Request&apos;, TEXT(Status__c) =&apos;Assigned&apos;, TEXT(Status__c) =&apos;Reopen&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WR Status Update Assigned</fullName>
        <actions>
            <name>WR_Stage_Update_Assigned_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WR_Status_Update_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This Workflow will update the Status field to &quot;Assigned&quot; on Ownership Transfer to Project Manager.</description>
        <formula>AND(NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c),  (IsPDKRequest__c ),  ISCHANGED(OwnerId),  IF(OR(LEFT(OwnerId, 3)=&apos;005&apos;,AND(LEFT(OwnerId, 3)=&apos;00G&apos;,IsTransferToProjectManager__c = true)), true, false),  OR(TEXT(Status__c)=&apos;New Request&apos;,TEXT(Status__c)=&apos;Reopen&apos;),  OR(TEXT(Stages__c)=&apos;Assigned-Queue&apos;,TEXT(Stages__c)=&apos;Reopen-Approved&apos;),  PRIORVALUE(Status__c) &lt;&gt; &apos;Completed&apos;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WR Update IsAutoUpdateLOE</fullName>
        <actions>
            <name>WR_Update_IsAutoUpdateLOE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used  to update IsAutoUpdateLOE__c value as flase if  Sum_of_Components_LOEs__c equals false.</description>
        <formula>AND(  NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c),  IsPDKRequest__c , NOT(Sum_of_Components_LOEs__c), ISCHANGED(Sum_of_Components_LOEs__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WR Update Total LOE</fullName>
        <actions>
            <name>Update_Total_LOE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used  to update Total_LOE__c based on Total_Level_of_Effort__c  and   IsAutoUpdateLOE__c equals True.</description>
        <formula>AND( NOT($Setup.IntegrationUsers__c.Skip_Validation_Rule__c), NOT($Setup.IntegrationUsers__c.Skip_Trigger__c), IsPDKRequest__c , IsAutoUpdateLOE__c,  OR( ISCHANGED(IsAutoUpdateLOE__c), ISCHANGED( Total_Level_of_Effort__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
