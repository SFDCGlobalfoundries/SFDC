<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_IP_Type</fullName>
        <description>Update IP Type from IP</description>
        <field>IP_Type__c</field>
        <formula>IPNumber__r.Ip_Type__c</formula>
        <name>Update IP Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update IP Type from IP</fullName>
        <actions>
            <name>Update_IP_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Base_IP__c.Ip_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update IP Type from IP : Used for Rollup-summary in the PT detail page</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
