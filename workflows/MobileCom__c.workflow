<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Auto_Populate_Mobile_Com_Type</fullName>
        <description>This field will update the MobileCom type based on the MobileCom Number</description>
        <field>Mobilecom_Type__c</field>
        <formula>&apos;Wireless Phone-&apos;+  LEFT(MobileCom_Number__c , 6)  + &apos;xxx&apos;</formula>
        <name>Auto Populate Mobile Com Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
