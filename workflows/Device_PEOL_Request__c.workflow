<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Device_PEOL_Request_Form_Approved</fullName>
        <description>Device PEOL Request Form when Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/Device_PEOL_Request_Form_Approved</template>
    </alerts>
    <alerts>
        <fullName>Device_PEOL_Request_Form_Rejected</fullName>
        <description>Device PEOL Request Form Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply-salesforce@globalfoundries.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLOBALFOUNDRIES/Device_PEOL_Request_Form_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>PEOL_Request_Form_Status_Cancelled</fullName>
        <description>Canceled (by AM)</description>
        <field>Status__c</field>
        <literalValue>Canceled</literalValue>
        <name>PEOL Request Form Status: Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEOL_Request_Form_Status_In_Process</fullName>
        <description>In-process (Approved by CSR, but waiting for ACK by  ERP)</description>
        <field>Status__c</field>
        <literalValue>In-process</literalValue>
        <name>PEOL Request Form Status: In Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEOL_Request_Form_Status_Pending</fullName>
        <description>Pending (by AM)</description>
        <field>Status__c</field>
        <literalValue>Pending</literalValue>
        <name>PEOL Request Form Status: Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEOL_Request_Form_Status_Review</fullName>
        <description>Set PEOL Request Form Status to Review when submitted to CSR for approval</description>
        <field>Status__c</field>
        <literalValue>Review</literalValue>
        <name>PEOL Request Form Status: Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
