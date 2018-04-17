<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RMA_DNCN_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DNCN</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RMA:DNCN:RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_DNCN_RecordType_RMA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>RMA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RMA:DNCN:RecordType:RMA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update%3A RMA DNCN RecordType%3ADNCN</fullName>
        <actions>
            <name>RMA_DNCN_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Record_Source__c == &quot;DNCN&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update%3A RMA DNCN RecordType%3ARMA</fullName>
        <actions>
            <name>RMA_DNCN_RecordType_RMA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Record_Source__c == &quot;RMA&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
