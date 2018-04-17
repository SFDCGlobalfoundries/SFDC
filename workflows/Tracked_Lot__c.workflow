<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UniqueField_to_LotName_and_MfgLot</fullName>
        <field>UniqueField__c</field>
        <formula>Lot_Tracker__c +&apos;;&apos;+ Manufacturing_Lot__c</formula>
        <name>UniqueField to LotName and MfgLot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Maintaining Uniqueness of Lots on Tracked Lot</fullName>
        <actions>
            <name>UniqueField_to_LotName_and_MfgLot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Maintaining Uniqueness of Lots on Tracked Lot</description>
        <formula>ISCHANGED(Manufacturing_Lot__c) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
