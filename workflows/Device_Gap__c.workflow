<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Copy_of_Impr_C</fullName>
        <field>Copy_of_Impr_C__c</field>
        <formula>Improve_Prob__c</formula>
        <name>Update Copy of Impr%(C)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Original_Action_Close_Date</fullName>
        <field>Original_Action_Close_Date__c</field>
        <formula>Action_Close_Date__c</formula>
        <name>Update Original Action Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Value of Impr%25%28C%29</fullName>
        <actions>
            <name>Update_Copy_of_Impr_C</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device_Gap__c.Improve_Prob__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy Value of Impr%(C) of Opportunity Issue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Original Action Close Date</fullName>
        <actions>
            <name>Update_Original_Action_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device_Gap__c.Original_Action_Close_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
