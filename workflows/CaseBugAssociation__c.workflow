<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetUniqueFieldforCaseBugRecord</fullName>
        <field>UniqueCaseBug__c</field>
        <formula>CASESAFEID(Bug__c) + CASESAFEID(Case__c)</formula>
        <name>SetUniqueFieldforCaseBugRecord</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SetUniqueFieldforCaseBugRecord</fullName>
        <actions>
            <name>SetUniqueFieldforCaseBugRecord</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CaseBugAssociation__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
