<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>After_Approval_pro_Change_Stage</fullName>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>After Approval pro Change Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>After_BCM_Approval_Change_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Business_Continuity_Mgmt_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>After BCM Approval Change Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>After_EHS_Approval_Change_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Other_EHS_CSR_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>After EHS Approval Change Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>After_Impact_Approval_Change_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Impact_Notification_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>After Impact Approval Change Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>After_Rejection_Change_Stage</fullName>
        <field>Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>After Rejection Change Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OtherEHS_CSO_Approval_Pending</fullName>
        <field>Stage__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>EHS/CSO Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
