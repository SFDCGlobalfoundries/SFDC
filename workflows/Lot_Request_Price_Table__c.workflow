<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Uniqueness_of_LotPriceTable</fullName>
        <field>UniqueField__c</field>
        <formula>TEXT(Fab__c) +&apos;;&apos;+ TEXT(Geometry__c)</formula>
        <name>Uniqueness of LotPriceTable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
