<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_on_GDS_Approval</fullName>
        <description>Send Email on GDS Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>GDS_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Translation_Process_Approved_VF</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_on_GDS_Rejection</fullName>
        <description>Send Email on GDS Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLOBALFOUNDRIES/Translation_Process_Rejected_VF</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_GDS_team</fullName>
        <description>Send Email to GDS team</description>
        <protected>false</protected>
        <recipients>
            <recipient>GDS_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/GDS_Translation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_GDS_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set GDS to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_GDS_to_Reject</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set GDS to Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_GDS_to_Translating</fullName>
        <field>Status__c</field>
        <literalValue>Translating</literalValue>
        <name>Set GDS to Translating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
