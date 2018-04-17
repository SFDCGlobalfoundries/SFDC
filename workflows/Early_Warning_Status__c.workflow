<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_EWS_flag</fullName>
        <field>EWS_FLAG__c</field>
        <formula>TEXT(EWS_FLAG__c)</formula>
        <name>Update EWS flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Sales_Order1__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_EWS_flag_in_Schedule</fullName>
        <field>EARLY_SHIP_FLAG__c</field>
        <formula>EARLY_SHIP_FLAG__c</formula>
        <name>Update EWS flag in Schedule</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Sales_Order1__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_EWS_Changed_flag</fullName>
        <field>IS_EWS_CHANGED__c</field>
        <formula>&apos;Y&apos;</formula>
        <name>Update Is EWS Changed flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Sales_Order1__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update Is EWS Changed flag</fullName>
        <actions>
            <name>Update_Is_EWS_Changed_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Version_ID__c &gt;1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF to update ESI flag</fullName>
        <actions>
            <name>Update_EWS_flag_in_Schedule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Early_Warning_Status__c.EARLY_SHIP_FLAG__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WF to update EWS flag</fullName>
        <actions>
            <name>Update_EWS_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Early_Warning_Status__c.EWS_FLAG__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
