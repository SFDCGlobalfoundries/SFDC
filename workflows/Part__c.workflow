<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Part_Family_update</fullName>
        <description>Part Family update with first few characters up to the first blank</description>
        <field>Part_Family__c</field>
        <formula>LEFT ( MDPart_Family__c ,FIND(&quot; &quot;, MDPart_Family__c ))</formula>
        <name>Part Family update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Part Family update</fullName>
        <actions>
            <name>Part_Family_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Part__c.MDPart_Family__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update the part family field by the first few characters</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
