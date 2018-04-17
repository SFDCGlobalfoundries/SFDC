<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OpportunityControlPoint1Email</fullName>
        <description>OpportunityControlPoint1Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Email_Templates/OpportunityControlPoint1Template</template>
    </alerts>
    <alerts>
        <fullName>OpportunityControlPoint2Email</fullName>
        <description>OpportunityControlPoint2Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Email_Templates/OpportunityControlPoint2Template</template>
    </alerts>
    <alerts>
        <fullName>OpportunityControlPoint3Email</fullName>
        <description>OpportunityControlPoint3Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Email_Templates/OpportunityControlPoint3Template</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_History</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Survey_on_Closed</fullName>
        <description>Opportunity Survey on Closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Email_Templates/Opportunity_Survey_on_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_EMail_Design_Win_Approval_Request_for_Approval_Rejected_SVP</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Rejected SVP&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_Rejected_SVP</template>
    </alerts>
    <alerts>
        <fullName>Send_E_MailDesign_Win_Approval_Request_Approved_SVP</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request Approved SVP&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_Approved_SVP</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Escalation_Letter</fullName>
        <description>Send E-Mail &quot; Design Win Approval Escalation Letter&quot; - Auto</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeffrey.darrow@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Escalation_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Escalation_Letter_CCS</fullName>
        <description>Send E-Mail &quot; Design Win Approval Escalation Letter&quot; - CCS</description>
        <protected>false</protected>
        <recipients>
            <recipient>paul.colestock@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Escalation_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Escalation_Letter_Industrial</fullName>
        <description>Send E-Mail &quot; Design Win Approval Escalation Letter&quot; - Industrial</description>
        <protected>false</protected>
        <recipients>
            <recipient>paul.colestock@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Escalation_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Escalation_Letter_Military</fullName>
        <description>Send E-Mail &quot; Design Win Approval Escalation Letter&quot; - Military</description>
        <protected>false</protected>
        <recipients>
            <recipient>paul.colestock@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Escalation_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Escalation_Letter_Mobility_Consumer_Testchip</fullName>
        <description>Send E-Mail &quot; Design Win Approval Escalation Letter&quot; - Mobility/Consumer/Testchip</description>
        <protected>false</protected>
        <recipients>
            <recipient>paul.colestock@globalfoundries.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Escalation_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_Approved_SVP</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request Approved SVP&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_Approved_SVP</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_PLM_Auto</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval PLM&quot; - Auto</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_AM_PLM</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_Regional_Head</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Regional Head&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_RH</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_Rejected_PLM</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Rejected PLM&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_Rejected_PLM</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_Rejected_RH</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Rejected RH&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_Rejected_RH</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_Rejected_SM</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Rejected SM&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_Rejected_SM</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_Rejected_SVP</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Rejected SVP&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_Rejected_SVP</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_Rejected_TH</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval Rejected TH&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_Rejected_TH</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_SM_Auto</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval SM&quot; - Auto</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_AM_Strategic_Marketing</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Request_for_Approval_SVP</fullName>
        <description>Send E-Mail &quot;Design Win Approval Request for Approval SVP&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_for_Approval_SVP</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Approval_Requested_Submitted</fullName>
        <ccEmails>ravi.sundaresan@globalfoundries.com.preprod</ccEmails>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <ccEmails>Sue.Raghavan@globalfoundries.com.preprod</ccEmails>
        <ccEmails>juan.cordovez@globalfoundries.com.preprod</ccEmails>
        <description>Send E-Mail &quot;Design Win Approval Requested Submitted&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Approval_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Recommended_for_Approval_Approved</fullName>
        <description>Send E-Mail &quot;Design Win Recommended for Approval - Approved&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Recommended_for_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Recommended_for_Approval_Rejected</fullName>
        <description>Send E-Mail &quot;Design Win Recommended for Approval - Rejected&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Recommended_for_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Recommended_for_Rejection_Approved</fullName>
        <description>Send E-Mail &quot;Design Win Recommended for Rejection - Approved&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Recommended_for_Rejection_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Recommended_for_Rejection_Rejected</fullName>
        <description>Send E-Mail &quot;Design Win Recommended for Rejection - Rejected&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Recommended_for_Rejection_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Rejected_for_Resubmission</fullName>
        <description>Send E-Mail &quot;Design Win Rejected for Resubmission&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Rejected_for_Resubmission</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Submitted_for_Recommendation_Approved</fullName>
        <description>Send E-Mail &quot;Design Win Submitted for Recommendation - Approved&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Submitted_for_Recommendation_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Submitted_for_Recommendation_Rejected</fullName>
        <description>Send E-Mail &quot;Design Win Submitted for Recommendation - Rejected&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Submitted_for_Recommendation_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Submitted_for_Review_Approved</fullName>
        <description>Send E-Mail &quot;Design Win Submitted for Review - Approved&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Submitted_for_Review_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Submitted_for_Review_Rejected</fullName>
        <description>Send E-Mail &quot;Design Win Submitted for Review - Rejected&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Submitted_for_Review_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_E_Mail_Design_Win_Won</fullName>
        <description>Send E-Mail &quot;Design Win Won&quot;</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Design_Win_Won</template>
    </alerts>
    <alerts>
        <fullName>SubmitForOpportunity_History</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <alerts>
        <fullName>SubmitFor_Opportunity_History</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <alerts>
        <fullName>Submit_ForOpportunity_History</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <alerts>
        <fullName>Submit_For_OppHistory</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <alerts>
        <fullName>Submit_For_Opp_History</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <alerts>
        <fullName>Submit_For_Opportunity_History</fullName>
        <ccEmails>jason.davison@globalfoundries.com.preprod</ccEmails>
        <description>Submit For Opportunity History</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/Design_Win_Request_for_Approval_FYI</template>
    </alerts>
    <fieldUpdates>
        <fullName>AM_CP1_last_modified_Date</fullName>
        <field>AM_last_modified_Date_CP1__c</field>
        <formula>TODAY()</formula>
        <name>AM CP1 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AM_CP1_last_modified_by</fullName>
        <field>AM_last_modified_by_CP1__c</field>
        <formula>$User.FirstName + &quot; &quot; +  $User.LastName</formula>
        <name>AM CP1 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AM_CP2_last_modified_by</fullName>
        <field>AM_last_modified_by_CP2__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>AM CP2 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AM_CP3_last_modified_Date</fullName>
        <field>AM_last_modified_Date_CP3__c</field>
        <formula>TODAY()</formula>
        <name>AM CP3 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AM_CP3_last_modified_by</fullName>
        <field>AM_last_modified_by_CP3__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>AM CP3 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AM_last_modified_Date_CP2</fullName>
        <field>AM_last_modified_Date_CP2__c</field>
        <formula>TODAY()</formula>
        <name>AM last modified Date CP2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Amount_Design_Win_Revenue</fullName>
        <description>Sets the Amount = Design Win Revenue</description>
        <field>Amount</field>
        <formula>Design_Win_Revenue__c</formula>
        <name>Amount = Design Win Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DateRecommended_by_Regional_Head</fullName>
        <field>Date_Submit_for_Regional_Head__c</field>
        <formula>TODAY()</formula>
        <name>Date Recommended by Regional Head</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_DWDecided_by_SVP_Sales</fullName>
        <field>Date_Design_Win_Decided_by_SVP_Sales__c</field>
        <formula>TODAY()</formula>
        <name>Date DW Decided by SVP Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_DW_Decided_by_SVPSales</fullName>
        <field>Date_Design_Win_Decided_by_SVP_Sales__c</field>
        <formula>TODAY()</formula>
        <name>Date DW Decided by SVPSales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_DW_Decided_by_SVP_Sales</fullName>
        <description>Date Design Win was decided by SVP Sales</description>
        <field>Date_Design_Win_Decided_by_SVP_Sales__c</field>
        <formula>TODAY()</formula>
        <name>Date DW Decided by SVP Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_DW_Recommended_by_Marketing</fullName>
        <description>Date Design Win recommended by Marketing</description>
        <field>Date_Design_Win_Recommended_by_Marketing__c</field>
        <formula>TODAY()</formula>
        <name>Date DW Recommended by Marketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_DW_Reviewed_by_Territory_Head</fullName>
        <description>Date the Territory Head Last Reviewed the Design Win Award.</description>
        <field>Date_Design_Win_Rev_d_by_Territory_Head__c</field>
        <formula>TODAY()</formula>
        <name>Date DW Reviewed by Territory Head</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Design_Win_Submitted_by_AM</fullName>
        <description>Date Design Win Award has been submitted by AM</description>
        <field>Date_Design_Win_Submitted_by_AM__c</field>
        <formula>TODAY()</formula>
        <name>Date Design Win Submitted by AM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Recommended_by_Regional_Head</fullName>
        <field>Date_Submit_for_Regional_Head__c</field>
        <formula>TODAY()</formula>
        <name>Date Recommended by Regional Head</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAE_CP1_last_modified_Date</fullName>
        <field>FAE_last_modified_Date_CP1__c</field>
        <formula>TODAY()</formula>
        <name>FAE CP1 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAE_CP1_last_modified_by</fullName>
        <field>FAE_last_modified_by_CP1__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>FAE CP1 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAE_CP2_last_modified_Date</fullName>
        <field>FAE_last_modified_Date_CP2__c</field>
        <formula>TODAY()</formula>
        <name>FAE CP2 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAE_CP2_last_modified_by</fullName>
        <field>FAE_last_modified_by_CP2__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>FAE CP2 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAE_CP3_last_modified_Date</fullName>
        <field>FAE_last_modified_Date_CP3__c</field>
        <formula>TODAY()</formula>
        <name>FAE CP3 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAE_CP3_last_modified_by</fullName>
        <field>FAE_last_modified_by_CP3__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>FAE CP3 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_CP3_last_modified_Date</fullName>
        <field>Pricing_last_modified_Date_CP3__c</field>
        <formula>TODAY()</formula>
        <name>Finance CP3 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_CP3_last_modified_by</fullName>
        <field>Pricing_last_modified_by_CP3__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Finance CP3 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_255_Char_to_standard_Next_Step</fullName>
        <description>Populate the standard</description>
        <field>NextStep</field>
        <formula>left(Opportunity_Next_Step__c,255)</formula>
        <name>First 255 Char to standard Next Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Segment_CP2_last_modified_Date</fullName>
        <field>Market_Segment_last_modified_Date_CP2__c</field>
        <formula>TODAY()</formula>
        <name>Market Segment CP2 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Segment_CP2_last_modified_by</fullName>
        <field>Market_Segment_last_modified_by_CP2__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Market Segment CP2 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Segment_CP3_last_modified_Date</fullName>
        <field>Market_Segment_last_modified_Date_CP3__c</field>
        <formula>TODAY()</formula>
        <name>Market Segment CP3 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_Segment_CP3_last_modified_by</fullName>
        <field>Market_Segment_last_modified_by_CP3__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Market Segment CP3 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NRE_Update</fullName>
        <field>Design_Win_w_NWR_Revenue__c</field>
        <formula>NWR__c  +  Design_Win_Revenue__c</formula>
        <name>NRE Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_AwardedAmount</fullName>
        <description>Awarded Amount</description>
        <field>Awarded_Amount__c</field>
        <formula>Design_Win_Revenue__c +  NWR__c</formula>
        <name>Opp - Awarded Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Awarded_Amount</fullName>
        <description>Field to capture Awarded amount once it is won</description>
        <field>Awarded_Amount__c</field>
        <formula>Design_Win_Revenue__c +  NWR__c</formula>
        <name>Opp - Awarded Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Awarded_Amount_w_o_NRE</fullName>
        <field>Awarded_Amount_w_o_NRE__c</field>
        <formula>Design_Win_Revenue__c</formula>
        <name>Opp - Awarded Amount w/o NRE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWAToday</fullName>
        <field>Date_Design_Win_Approved__c</field>
        <formula>Today()</formula>
        <name>Opp - DDWA -Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWA_Null</fullName>
        <field>Date_Design_Win_Approved__c</field>
        <name>Opp - DDWA - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWA_Today</fullName>
        <description>Date Design Win Approved - Today</description>
        <field>Date_Design_Win_Approved__c</field>
        <formula>TODAY()</formula>
        <name>Opp - DDWA - Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWD_SVP_Null</fullName>
        <field>Date_Design_Win_Decided_by_SVP_Sales__c</field>
        <name>Opp - DDWD(SVP) - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWPR_Today</fullName>
        <description>Opportunity - Date Design Win Process Reach = Today()</description>
        <field>Date_Design_Win_Process_Reach_100__c</field>
        <formula>TODAY()</formula>
        <name>Opp - DDWPR - Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWR_Marketing_Null</fullName>
        <field>Date_Design_Win_Recommended_by_Marketing__c</field>
        <name>Opp - DDWR(Marketing) - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWR_Null</fullName>
        <description>Sets the Date Design Win Recommended to null</description>
        <field>Date_Design_Win_Recommended__c</field>
        <name>Opp - DDWR - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWR_PLM_Null</fullName>
        <field>Date_Design_Win_Recommended_by_PLM__c</field>
        <name>Opp - DDWR(PLM) - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWR_PLM_Today</fullName>
        <field>Date_Design_Win_Recommended_by_PLM__c</field>
        <formula>TODAY()</formula>
        <name>Opp - DDWR(PLM) - Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWR_TH_Null</fullName>
        <field>Date_Design_Win_Rev_d_by_Territory_Head__c</field>
        <name>Opp - DDWR(TH) - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DDWR_Today</fullName>
        <description>Updates The Date Design Win Recommended to the current date/time.</description>
        <field>Date_Design_Win_Recommended__c</field>
        <formula>NOW()</formula>
        <name>Opp - DDWR - Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DSFR_Null</fullName>
        <field>Date_Submitted_for_Review__c</field>
        <name>Opp - DSFR - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DSFR_Today</fullName>
        <description>Date Submitted For Review = TODAY()</description>
        <field>Date_Submitted_for_Review__c</field>
        <formula>TODAY()</formula>
        <name>Opp - DSFR - Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRSRejected_for_Resubmission</fullName>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Rejected for Resubmission</literalValue>
        <name>Opp - DWRS - Rejected for Resubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRSWon</fullName>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Won</literalValue>
        <name>Opp - DWRSWon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Null</fullName>
        <field>Design_Win_Review_Status__c</field>
        <name>Opp - DWRS - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Recommend_for_Approval</fullName>
        <description>Design Win Review Status = &quot;Recommend for Approval&quot;</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Recommend for Approval</literalValue>
        <name>Opp - DWRS - Recommend for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Recommend_for_Rejection</fullName>
        <description>Design Win Review Status = &quot;Recommend for Rejection&quot;</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Recommend for Rejection</literalValue>
        <name>Opp - DWRS - Recommend for Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Rejected_for_Resubmission</fullName>
        <description>Design Win Review Status = &quot;Rejected for Resubmission&quot;</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Rejected for Resubmission</literalValue>
        <name>Opp - DWRS - Rejected for Resubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Submitted_for_Recommendation</fullName>
        <description>Design Win Review Status - Submitted for Recommendation</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Submitted for Recommendation</literalValue>
        <name>Opp - DWRS -Submitted for Recommendation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Submitted_for_Review</fullName>
        <description>Design Win Review Status = &quot;Submitted for Review&quot;</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Submitted for Review</literalValue>
        <name>Opp - DWRS - Submitted for Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Submitted_to_PLM_Review</fullName>
        <description>Opp - DWRS -Submitted to PLM Action</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Submitted for PLM Review</literalValue>
        <name>Opp - DWRS -Submitted to PLM Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DWRS_Won</fullName>
        <description>Design Win Review Status = &quot;Won&quot;</description>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Won</literalValue>
        <name>Opp - DWRS - Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Date_DW_Submitted_for_PLM_Review</fullName>
        <description>Date DW Submitted for PLM Review</description>
        <field>Date_DW_Submitted_for_PLM_Review__c</field>
        <formula>NOW()</formula>
        <name>Opp-Date DW Submitted for PLM Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_MartiniStore_Sync_Status_SENT</fullName>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&apos;SENT&apos;</formula>
        <name>Opp - MartiniStore Sync Status - SENT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Probability_Update_to_90</fullName>
        <description>Probability will update to 90% when AM submit for approval as per new requirement</description>
        <field>Probability</field>
        <formula>0.9</formula>
        <name>Opp Probability Update to 90</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_RHADNow</fullName>
        <field>Regional_Head_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Opp - RHAD - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_RHRejected_for_Resubmission</fullName>
        <field>Design_Win_Review_Status__c</field>
        <literalValue>Rejected for Resubmission</literalValue>
        <name>Opp - RH - Rejected for Resubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opp - RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_SMAD_NULL</fullName>
        <field>Stategic_Marketing_Approval_Date__c</field>
        <name>Opp - SMAD - NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_SMAD_Now</fullName>
        <field>Stategic_Marketing_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Opp - SMAD - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_SOI_SFDCID</fullName>
        <field>Siebel_Opportunity_ID__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Opp - SOI - SFDCID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Error_Message_Null</fullName>
        <description>Used by the integration to Siebel
-Clear the previous error message</description>
        <field>Siebel_Error_Message__c</field>
        <name>Opp - Siebel Error Message - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Opportunity_ID_Null</fullName>
        <field>Siebel_Opportunity_ID__c</field>
        <name>Opp - Siebel Opportunity ID - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Sent_DateTime_Now</fullName>
        <field>Siebel_Sent_DateTime__c</field>
        <formula>NOW()</formula>
        <name>Opp - Siebel Sent DateTime - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Status_Message_Null</fullName>
        <field>Siebel_Status__c</field>
        <name>Opp - Siebel Status Message - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Status_Message_Sent</fullName>
        <description>Used for integration to Siebel</description>
        <field>Siebel_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>Opp - Siebel Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Sync_ID_Now</fullName>
        <description>Used for integration to Siebel</description>
        <field>Siebel_Sync_ID__c</field>
        <formula>TEXT(NOW())</formula>
        <name>Opp - Siebel Sync ID - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Siebel_Sync_ID_Null</fullName>
        <field>Siebel_Sync_ID__c</field>
        <name>Opp - Siebel Sync ID - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_StageLostDropped_Now</fullName>
        <field>Date_for_Loss_Dropped__c</field>
        <formula>now()</formula>
        <name>Opp - StageLostDropped - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_1_Discovery</fullName>
        <field>StageName</field>
        <literalValue>1. Discovery</literalValue>
        <name>Opp - Stage - 1. Discovery</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_5Commitment</fullName>
        <field>StageName</field>
        <literalValue>5. Commitment</literalValue>
        <name>Opp - Stage - 5. Commitment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_5_Commitment</fullName>
        <field>StageName</field>
        <literalValue>5. Commitment</literalValue>
        <name>Opp - Stage - 5. Commitment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunityControlPointFieldUpdate</fullName>
        <field>Is_Submit_For_Approval__c</field>
        <literalValue>1</literalValue>
        <name>OpportunityControlPointFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_DW_Updates_Prob_100</fullName>
        <description>Updates the Probability Field to be 100% when design has been won</description>
        <field>Probability</field>
        <formula>1</formula>
        <name>Opportunity DW Updates Prob = 100%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Update_Owner_Profile</fullName>
        <description>Converts and copies the owners profile name.</description>
        <field>Owner_Profile__c</field>
        <formula>CASE(Owner.Profile.Name,
&apos;PT1&apos;, &apos;System Administrator&apos;, 
&apos;PT2&apos;, &apos;Standard User&apos;, 
&apos;PT3&apos;, &apos;Ready Only&apos;, 
&apos;PT4&apos;, &apos;Solution Manager&apos;, 
&apos;PT5&apos;, &apos;Marketing User&apos;, 
&apos;PT6&apos;, &apos;Contract Manager&apos;, 
&apos;PT7&apos;, &apos;Partner User&apos;, 
&apos;PT8&apos;, &apos;Standard Platform User&apos;, 
&apos;PT9&apos;, &apos;Standard Platform One App User&apos;, 
&apos;PT13&apos;, &apos;Customer Portal User&apos;, 
&apos;PT14&apos;, &apos;Customer Portal Manager&apos;, 
Owner.Profile.Name
)</formula>
        <name>Opportunity - Update Owner Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLM_CP2_last_modified_Date</fullName>
        <field>PLM_last_modified_Date_CP2__c</field>
        <formula>TODAY()</formula>
        <name>PLM CP2 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLM_CP2_last_modified_by</fullName>
        <field>PLM_last_modified_by_CP2__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>PLM CP2 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLM_CP3_last_modified_Date</fullName>
        <field>PLM_last_modified_Date_CP3__c</field>
        <formula>TODAY()</formula>
        <name>PLM CP3 last modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLM_CP3_last_modified_by</fullName>
        <field>PLM_last_modified_by_CP3__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>PLM CP3 last modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProbabiltyAsOldvalue</fullName>
        <field>Probability</field>
        <formula>PRIORVALUE(Probability)</formula>
        <name>ProbabiltyAsOldvalue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2016_C_M</fullName>
        <field>X2016_C__c</field>
        <formula>IF(X2016_Rollup__c=0, 0,X2016_Rollup__c /1000000)</formula>
        <name>Update 2016 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2017_C_M</fullName>
        <field>X2017_C__c</field>
        <formula>IF(X2017_Rollup__c=0, 0,X2017_Rollup__c /1000000)</formula>
        <name>Update 2017 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2018_C_M</fullName>
        <field>X2018_C__c</field>
        <formula>IF(X2018_Rollup__c=0, 0,X2018_Rollup__c /1000000)</formula>
        <name>Update 2018 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2019_C_M</fullName>
        <field>X2019_C__c</field>
        <formula>IF(X2019_Rollup__c=0, 0,X2019_Rollup__c /1000000)</formula>
        <name>Update 2019 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2020_C_M</fullName>
        <field>X2020_C__c</field>
        <formula>IF(X2020_Rollup__c=0, 0,X2020_Rollup__c /1000000)</formula>
        <name>Update 2020 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2021_C_M</fullName>
        <field>X2021_C__c</field>
        <formula>IF(X2021_Rollup__c=0, 0,X2021_Rollup__c /1000000)</formula>
        <name>Update 2021 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2022_C_M</fullName>
        <field>X2022_C__c</field>
        <formula>IF(X2022_Rollup__c=0, 0,X2022_Rollup__c /1000000)</formula>
        <name>Update 2022 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2023_C_M</fullName>
        <field>X2023_C__c</field>
        <formula>IF(X2023_Rollup__c=0, 0,X2023_Rollup__c /1000000)</formula>
        <name>Update 2023 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2024_C_M</fullName>
        <field>X2024_C__c</field>
        <formula>IF(X2024_Rollup__c=0, 0,X2024_Rollup__c /1000000)</formula>
        <name>Update 2024 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_2025_C_M</fullName>
        <field>X2025_C__c</field>
        <formula>IF(X2025_Rollup__c=0, 0,X2025_Rollup__c /1000000)</formula>
        <name>Update 2025 (C)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Obstacle_to_255_or_link</fullName>
        <description>Trancated to first 255 of opportunity obstacles</description>
        <field>Obstacles__c</field>
        <formula>if (len(Opportunity_Obstacles__c)&gt;255, left(Opportunity_Obstacles__c,252)&amp; &quot;...&quot;, Opportunity_Obstacles__c)</formula>
        <name>Update Obstacle to 255 or link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2016_A</fullName>
        <field>X2016_A_M__c</field>
        <formula>X2016_C__c</formula>
        <name>Update field 2016 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2017_A</fullName>
        <field>X2017_A_M__c</field>
        <formula>X2017_C__c</formula>
        <name>Update field 2017 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2018_A</fullName>
        <field>X2018_A_M__c</field>
        <formula>X2018_C__c</formula>
        <name>Update field 2018 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2019_A</fullName>
        <field>X2019_A_M__c</field>
        <formula>X2019_C__c</formula>
        <name>Update field 2019 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2020_A</fullName>
        <field>X2020_A_M__c</field>
        <formula>X2020_C__c</formula>
        <name>Update field 2020 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2021_A</fullName>
        <field>X2021_A_M__c</field>
        <formula>X2021_C__c</formula>
        <name>Update field 2021 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2022_A</fullName>
        <field>X2022_A_M__c</field>
        <formula>X2022_C__c</formula>
        <name>Update field 2022 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2023_A</fullName>
        <field>X2023_A_M__c</field>
        <formula>X2023_C__c</formula>
        <name>Update field 2023 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2024_A</fullName>
        <field>X2024_A_M__c</field>
        <formula>X2024_C__c</formula>
        <name>Update field 2024 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_2025_A</fullName>
        <field>X2025_A_M__c</field>
        <formula>X2025_C__c</formula>
        <name>Update field 2025 (A)($M)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Opportunity_To_AIA</fullName>
        <apiVersion>26.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/OpportunityAIAService/OpportunityAIAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/OpportunityAIAService/OpportunityAIAService_client</endpointUrl>
        <fields>AccountId</fields>
        <fields>Amount</fields>
        <fields>AssignedPID__c</fields>
        <fields>Awarded_Amount__c</fields>
        <fields>CloseDate</fields>
        <fields>Create_Forecast_in_Demantra__c</fields>
        <fields>CreatedDate</fields>
        <fields>Created_By_HCM_Login_ID__c</fields>
        <fields>Date_Design_Win_Approved__c</fields>
        <fields>Description__c</fields>
        <fields>Design_Win_Region__c</fields>
        <fields>Design_Win_Revenue__c</fields>
        <fields>Design_Win_Review_Status__c</fields>
        <fields>Design_Win_Territory__c</fields>
        <fields>Fab_Assignment_1__c</fields>
        <fields>Fab_Assignment_2__c</fields>
        <fields>Fab_Group__c</fields>
        <fields>Id</fields>
        <fields>Inactivate_Zero_Out_Forecast_in_Demantra__c</fields>
        <fields>LastModifiedDate</fields>
        <fields>Market_Segment__c</fields>
        <fields>Modified_By_HCM_Login_ID__c</fields>
        <fields>Name</fields>
        <fields>Opportunity_Owner_HCM__c</fields>
        <fields>Opportunity_Sourcing_Type__c</fields>
        <fields>Original_Name__c</fields>
        <fields>Process_Category__c</fields>
        <fields>Process_Family__c</fields>
        <fields>Process_Geometry__c</fields>
        <fields>Reason_for_Loss_Dropped__c</fields>
        <fields>Resume_Date__c</fields>
        <fields>Short_Name__c</fields>
        <fields>Siebel_Account_ID__c</fields>
        <fields>Siebel_Operation__c</fields>
        <fields>Siebel_Opportunity_ID__c</fields>
        <fields>Siebel_Probability__c</fields>
        <fields>Siebel_Stage__c</fields>
        <fields>Siebel_Sync_ID__c</fields>
        <fields>Target_Process_Node__c</fields>
        <fields>Target_Process_Technology_No__c</fields>
        <fields>Total_Lifetime_Revenue__c</fields>
        <fields>X1st_Product_Production_Date__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Opportunity To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>AM CP1 last modified by</fullName>
        <actions>
            <name>AM_CP1_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AM_CP1_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( AM_CP1__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AM CP2 last modified by</fullName>
        <actions>
            <name>AM_CP2_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AM_last_modified_Date_CP2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( AM_CP2__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AM CP3 last modified by</fullName>
        <actions>
            <name>AM_CP3_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AM_CP3_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( AM_CP3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Design Win NRE Revenue Update</fullName>
        <actions>
            <name>NRE_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(NWR__c)||ISCHANGED( Design_Win_Revenue__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Design Win Review Status - Recommend for Approval</fullName>
        <actions>
            <name>Opp_DWRS_Recommend_for_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_SMAD_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Stategic_Marketing_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Design_Win_Review_Status__c</field>
            <operation>equals</operation>
            <value>Submitted for Recommendation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Marketing_Recommendation__c</field>
            <operation>equals</operation>
            <value>Recommend for Approval</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Design Win Review Status - Recommend for Rejection</fullName>
        <actions>
            <name>Opp_DWRS_Recommend_for_Rejection</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_SMAD_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Stategic_Marketing_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Design_Win_Review_Status__c</field>
            <operation>equals</operation>
            <value>Submitted for Recommendation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Marketing_Recommendation__c</field>
            <operation>equals</operation>
            <value>Recommend for Rejection</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAE CP1 last modified by</fullName>
        <actions>
            <name>FAE_CP1_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAE_CP1_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( FAE_CP1__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAE CP2 last modified by</fullName>
        <actions>
            <name>FAE_CP2_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAE_CP2_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( FAE_CP2__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAE CP3 last modified by</fullName>
        <actions>
            <name>FAE_CP3_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAE_CP3_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( FAE_CP3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Finance CP3 last modified by</fullName>
        <actions>
            <name>Finance_CP3_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Finance_CP3_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( Finance_Check_CP3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Market Segment CP2 last modified by</fullName>
        <actions>
            <name>Market_Segment_CP2_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Market_Segment_CP2_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( MarketSegment_CP2__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Market Segment CP3 last modified by</fullName>
        <actions>
            <name>Market_Segment_CP3_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Market_Segment_CP3_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( MarketSegment_CP3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Approval Process - Auto Escalation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Date_Design_Win_Recommended__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Automotive</value>
        </criteriaItems>
        <description>Sends Design Win Escalation Letter to Strategic Marketing approvers if Opportunity is not yet approved after 72 hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_E_Mail_Design_Win_Approval_Escalation_Letter</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Design_Win_Recommended__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity - Approval Process - CCS Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Date_Design_Win_Recommended__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market_Segment__c</field>
            <operation>equals</operation>
            <value>&quot;Compute, Connect, Store (CCS)&quot;</value>
        </criteriaItems>
        <description>Sends Design Win Escalation Letter to Strategic Marketing approvers if Opportunity is not yet approved after 72 hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_E_Mail_Design_Win_Approval_Escalation_Letter_CCS</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Design_Win_Recommended__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity - Approval Process - Consumer Escalation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Date_Design_Win_Recommended__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market_Segment__c</field>
            <operation>equals</operation>
            <value>Mobility,Consumer,Testchip</value>
        </criteriaItems>
        <description>Sends Design Win Escalation Letter to Strategic Marketing approvers if Opportunity is not yet approved after 72 hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_E_Mail_Design_Win_Approval_Escalation_Letter_Mobility_Consumer_Testchip</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Design_Win_Recommended__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity - Approval Process - Industrial Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Date_Design_Win_Recommended__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market_Segment__c</field>
            <operation>equals</operation>
            <value>&quot;Industrial,Military,Aerospace&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.End_Application_for_Opty__c</field>
            <operation>contains</operation>
            <value>Smart Card,Others - IMA,Manufacturing,Security &amp; Energy,Medical</value>
        </criteriaItems>
        <description>Sends Design Win Escalation Letter to Strategic Marketing approvers if Opportunity is not yet approved after 72 hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_E_Mail_Design_Win_Approval_Escalation_Letter_Industrial</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Design_Win_Recommended__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity - Approval Process - Military Escalation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Date_Design_Win_Recommended__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market_Segment__c</field>
            <operation>equals</operation>
            <value>&quot;Industrial,Military,Aerospace&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.End_Application_for_Opty__c</field>
            <operation>contains</operation>
            <value>Military &amp; Aerospace</value>
        </criteriaItems>
        <description>Sends Design Win Escalation Letter to Strategic Marketing approvers if Opportunity is not yet approved after 72 hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_E_Mail_Design_Win_Approval_Escalation_Letter_Military</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Date_Design_Win_Recommended__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity - Copy Owner Profile</fullName>
        <actions>
            <name>Opportunity_Update_Owner_Profile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will populate the Owner Profile field based on the Profile of the Owner.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Field Update - Date Design Win Process Reach</fullName>
        <actions>
            <name>Opp_DDWPR_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Design_Win_Progress__c</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Field Update - Date For Loss%2FDropped</fullName>
        <actions>
            <name>Opp_StageLostDropped_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>8. Lost,9. Dropped</value>
        </criteriaItems>
        <description>Whenever Opportunity lost/dropped capturing the datetime value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Outbound Message - To AIA</fullName>
        <actions>
            <name>Opp_MartiniStore_Sync_Status_SENT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Error_Message_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Sent_DateTime_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Status_Message_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Sync_ID_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Integration to Siebel</description>
        <formula>AND( 	NOT(Account.Record_Type_Name__c = &apos;IBM Account&apos;), 		CONTAINS(Siebel_Opportunity_Complete__c , &apos;TRUE&apos;) , 	OR(  		ISNEW(),  		ISCHANGED( AccountId),  		ISCHANGED( CloseDate ),  		ISCHANGED( Create_Forecast_in_Demantra__c ),  		ISCHANGED( Description__c ),  		ISCHANGED( Inactivate_Zero_Out_Forecast_in_Demantra__c ),  		ISCHANGED( Market_Segment__c ),  		ISCHANGED( Name ),  		ISCHANGED( Opportunity_Sourcing_Type__c ),  		ISCHANGED( Process_Category__c ),  		ISCHANGED( Process_Family__c ),  		ISCHANGED( Process_Geometry__c ),  		ISCHANGED( Reason_for_Loss_Dropped__c ),  		ISCHANGED( Target_Process_Technology_No__c ),  		ISCHANGED( StageName ),  		ISCHANGED( Probability ),  		ISCHANGED( AssignedPID__c),  		ISCHANGED( Awarded_Amount__c),  		ISCHANGED( Date_Design_Win_Approved__c),  		ISCHANGED( Design_Win_Revenue__c),  		ISCHANGED( Design_Win_Review_Status__c),  		ISCHANGED( Fab_Assignment_1__c),  		ISCHANGED( Fab_Group__c), 		ISCHANGED( Opportunity_Owner_HCM__c),  		ISCHANGED(X1st_Product_Production_Date__c), 		ISCHANGED( Fab_Assignment_2__c ) ,ISCHANGED(  SynchToDownstream__c ) ,  		ISCHANGED( Design_Win_Region_Override__c ),  		ISCHANGED( Design_Win_Territory_Override__c )  	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Populate Siebel Opportunity ID</fullName>
        <actions>
            <name>Opp_SOI_SFDCID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(Siebel_Opportunity_ID__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Reset Fields on Clone</fullName>
        <actions>
            <name>Opp_DDWA_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DSFR_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DWRS_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Error_Message_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Status_Message_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Siebel_Sync_ID_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_Stage_1_Discovery</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notContain</operation>
            <value>GLOBALFOUNDRIES Internal</value>
        </criteriaItems>
        <description>Set some specific fields to Null when a new record is created. (Mainly applicable when an Opportunity is created using the &quot;Clone&quot; button)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Design Win Updates Prob %3D 100%25</fullName>
        <actions>
            <name>Opportunity_DW_Updates_Prob_100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates Probability to 100% when the design is won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Survey on Closed</fullName>
        <actions>
            <name>Opportunity_Survey_on_Closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends Email notification with Survey Link to Opportunity Owner for rating.</description>
        <formula>AND(ISCHANGED(StageName), OR( SurveyFor__c=&apos;Lost&apos;, SurveyFor__c=&apos;Void&apos;, SurveyFor__c=&apos;Dropped&apos; ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityControlPoint1WF</fullName>
        <actions>
            <name>OpportunityControlPoint1Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends Email notification if Opportunity stage is changed without completing control point 1 checkboxes</description>
        <formula>AND(  !$Setup.IntegrationUsers__c.Is_Integration_User__c,  OR(  ISPICKVAL( StageName , &quot;1. Discovery&quot;) ),  !AM_CP1__c,!FAE_CP1__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityControlPoint2WF</fullName>
        <actions>
            <name>OpportunityControlPoint2Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email notification if Opportunity stage is changed without completing control point 2 checkboxes</description>
        <formula>AND(  !$Setup.IntegrationUsers__c.Is_Integration_User__c,  OR(  ISPICKVAL( StageName , &quot;2. Assessment&quot;),  ISPICKVAL( StageName , &quot;3. Recommendation&quot;) ),  !AM_CP2__c,!FAE_CP2__c,!PLM_CP2__c,!MarketSegment_CP2__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityControlPoint3WF</fullName>
        <actions>
            <name>OpportunityControlPoint3Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email notification if Opportunity stage is changed without completing control point 3 checkboxes</description>
        <formula>AND(  !$Setup.IntegrationUsers__c.Is_Integration_User__c,  OR(  ISPICKVAL( StageName , &quot;4. Decision&quot;),  ISPICKVAL( StageName , &quot;5. Commitment&quot;),  ISPICKVAL( StageName , &quot;6. First Product TO&quot;),  ISPICKVAL( StageName , &quot;7. Revenue&quot;),  ISPICKVAL( StageName , &quot;8. Lost&quot;),  ISPICKVAL( StageName , &quot;9. Dropped&quot;),  ISPICKVAL( StageName , &quot;10. Void&quot;)  ),  !AM_CP3__c,!FAE_CP3__c,!PLM_CP3__c,!MarketSegment_CP3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityControlPointCheck</fullName>
        <actions>
            <name>OpportunityControlPointFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( AM_CP3__c=true,FAE_CP3__c=true, PLM_CP3__c=true, MarketSegment_CP3__c=true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PLM CP2 last modified by</fullName>
        <actions>
            <name>PLM_CP2_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PLM_CP2_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( PLM_CP2__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PLM CP3 last modified by</fullName>
        <actions>
            <name>PLM_CP3_last_modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PLM_CP3_last_modified_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( PLM_CP3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Amount %3D Design Win Revenue</fullName>
        <actions>
            <name>Amount_Design_Win_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Evaluate the rule when a record is created, and any time it’s edited to subsequently meet criteria</description>
        <formula>Design_Win_Revenue__c  &lt;&gt; -1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Next Step %3D first 255 of Opportunity Next Step</fullName>
        <actions>
            <name>First_255_Char_to_standard_Next_Step</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Next_Step__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Evaluate the rule when a record is created, and any time it’s edited to subsequently meet criteria</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Obstacles %3D first 25 of Opportunity Obstacles or link to detail report</fullName>
        <actions>
            <name>Update_Obstacle_to_255_or_link</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Obstacles__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Evaluate the rule when a record is created, and any time it’s edited to subsequently meet criteria</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Current Revenue Values</fullName>
        <actions>
            <name>Update_2016_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2017_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2018_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2019_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2020_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2021_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2022_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2023_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2024_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_2025_C_M</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( X2016_Rollup__c ) || ISCHANGED( X2017_Rollup__c )||ISCHANGED( X2018_Rollup__c )||ISCHANGED( X2019_Rollup__c )||ISCHANGED( X2020_Rollup__c ) || ISCHANGED( X2021_Rollup__c ) || ISCHANGED( X2022_Rollup__c ) || ISCHANGED( X2023_Rollup__c ) || ISCHANGED( X2024_Rollup__c ) || ISCHANGED( X2025_Rollup__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Values on Stage Change</fullName>
        <actions>
            <name>Update_field_2016_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2017_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2018_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2019_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2020_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2021_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2022_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2023_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2024_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_field_2025_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(PRIORVALUE(StageName), &quot;2. Assessment&quot;),     ISPICKVAL(StageName, &quot;3. Recommendation&quot;)     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
