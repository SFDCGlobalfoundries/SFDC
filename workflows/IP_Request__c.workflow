<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Email_Notification</fullName>
        <description>Approval Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP_Council_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_IP_Request_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_IP_Counsel_Team_on_Submission_for_Approval</fullName>
        <description>Notification to IP Counsel Team on Submission of New IP Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP_Council_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_IP_Req_Submission_Notification</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Email_Notification</fullName>
        <description>Rejection Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP_Council_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_IP_Request_Rejection_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Stage</fullName>
        <description>Updates the Stage of the New IP Request to Submitted</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Approved</fullName>
        <description>Updates the Stage of the New IP Request to Approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Stage Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Rejected</fullName>
        <description>Updates the Stage of the New IP Request to Rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Stage Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
