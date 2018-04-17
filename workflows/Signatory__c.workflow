<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdatenNonTagging</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Request</literalValue>
        <name>UpdatenNonTagging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Agreement__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>UpdateAgreementForNonTagSignatory</fullName>
        <actions>
            <name>UpdatenNonTagging</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Signatory__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NDA to Account Tagging Only</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
