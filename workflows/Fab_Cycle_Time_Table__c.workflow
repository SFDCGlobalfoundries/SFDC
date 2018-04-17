<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ConcatenatedString_for_Uniqueness</fullName>
        <field>UniqueField__c</field>
        <formula>TEXT(Fab__c)+&apos;;&apos;+TEXT(Geometry__c)
/*+&apos;;&apos;+TEXT(Technology_Type__c)*/</formula>
        <name>ConcatenatedString for Uniqueness</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
