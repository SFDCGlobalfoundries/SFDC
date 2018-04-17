<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Manage_Email_Update_Unique_Field</fullName>
        <description>Update ‘Unique__c’ field when record is created and edited</description>
        <field>Unique__c</field>
        <formula>User__c</formula>
        <name>Manage Email Update Unique Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Manage Email Notification Unique Field</fullName>
        <actions>
            <name>Manage_Email_Update_Unique_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update ‘Unique__c’ field when record is created and edited</description>
        <formula>AND(NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c), OR(  ISCHANGED(User__c), ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
