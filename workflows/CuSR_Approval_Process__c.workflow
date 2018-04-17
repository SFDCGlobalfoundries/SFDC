<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CuSR_Approval_Reminer</fullName>
        <ccEmails>lilli-ann.bobadilla@globalfoundries.com</ccEmails>
        <description>CuSR Approval Reminer</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver5__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>swift@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/CuSR_Appoval_Reminder_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>CuSRApprovalUpdateAMApprovedOnField</fullName>
        <field>AM_Approved_On__c</field>
        <formula>TODAY()</formula>
        <name>CuSRApprovalUpdateAMApprovedOnField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Reminder_On_7th_Day</fullName>
        <field>Remind_On_7th_Day__c</field>
        <literalValue>1</literalValue>
        <name>CuSR Approval Reminder On 7th Day</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Update_Approved_To_False</fullName>
        <field>Approved__c</field>
        <literalValue>0</literalValue>
        <name>CuSR Approval Update Approved To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Update_Approved_To_True</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>CuSR Approval Update Approved To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Update_Reminder_On_3rd_Day</fullName>
        <field>Remind_On_3rd_Day__c</field>
        <literalValue>1</literalValue>
        <name>CuSR Approval Update Reminder On 3rd Day</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Update_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CuSR Approval Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Update_Status_to_New</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>CuSR Approval Update Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_Approval_Update_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>CuSR Approval Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CuSR_FAB_1_Update_Status_to_Pending_Appr</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>CuSR FAB 1 Update Status to Pending Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CuSR_Approval_Status_to_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Update CuSR Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CuSR Approval Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CuSR_Approval_Process__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>GF Integration</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CuSR_Approval_Reminder_On_7th_Day</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CuSR_Approval_Process__c.LastModifiedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CuSR_Approval_Update_Reminder_On_3rd_Day</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CuSR_Approval_Process__c.LastModifiedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
