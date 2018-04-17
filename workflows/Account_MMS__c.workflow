<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Account_MMS_Name</fullName>
        <description>Update the Account MMS Name</description>
        <field>Name</field>
        <formula>Account__r.Name &amp; &quot; MMS&quot;</formula>
        <name>Update Account MMS Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Account MMS Name</fullName>
        <actions>
            <name>Update_Account_MMS_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Account__r.Name &amp; &quot; MMS&quot; &lt;&gt;  Name</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
