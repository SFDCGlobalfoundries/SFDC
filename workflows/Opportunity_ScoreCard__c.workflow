<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opportunity_ScoreCard_UniqueId_update</fullName>
        <description>Update the field &quot;UniqueId__c&quot; based on the value of &quot;Opportunity__c&quot; field of Opportunity ScoreCard Object .</description>
        <field>UniqueId__c</field>
        <formula>Opportunity__c</formula>
        <name>Opportunity ScoreCard UniqueId update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity ScoreCard For UniqueId</fullName>
        <actions>
            <name>Opportunity_ScoreCard_UniqueId_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow Rule will Update the field &quot;UniqueId__c&quot; based on the value of &quot;Opportunity__c&quot; field of Opportunity ScoreCard Object .</description>
        <formula>ISCHANGED( Opportunity__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
