<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Manual_Device_Publish_Report_Restriction</fullName>
        <description>Changes the Record type of the record to Read only.</description>
        <field>RecordTypeId</field>
        <lookupValue>Manual_Device_DI_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Manual Device Publish Report Restriction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manual_Device_Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Manual_Device_DI_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Manual Device Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Manual Device - Update Record Type</fullName>
        <actions>
            <name>Manual_Device_Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Manual Device Publish Report Restriction</fullName>
        <actions>
            <name>Manual_Device_Publish_Report_Restriction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(  ISPICKVAL(Device__r.Publish_Report__c, &apos;No&apos;), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
