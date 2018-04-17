<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ROS_Certificate_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Close_Certificate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ROS Certificate Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reticle_Scrap_Certificate_PDF_Generated</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Active_Certificate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Reticle Scrap Certificate: PDF Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ROS Certificate Remove Add Button</fullName>
        <actions>
            <name>Reticle_Scrap_Certificate_PDF_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ROS_Disposal_Certificate__c.PDF_Generated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROS Certificate Remove Edit Button</fullName>
        <actions>
            <name>ROS_Certificate_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ROS_Disposal_Certificate__c.PDF_Generated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
