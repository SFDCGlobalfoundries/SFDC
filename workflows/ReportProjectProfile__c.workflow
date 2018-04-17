<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>STM_Populate_Unique_Name_ReportProfile</fullName>
        <field>Unique_Name__c</field>
        <formula>Name</formula>
        <name>STM: Populate Unique Name ReportProfile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>STM%3A Maintain Uniqueness of Report Profile</fullName>
        <actions>
            <name>STM_Populate_Unique_Name_ReportProfile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
