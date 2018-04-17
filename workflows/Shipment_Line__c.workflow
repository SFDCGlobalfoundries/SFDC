<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Shipment_Line_Name</fullName>
        <field>Name</field>
        <formula>&quot;SAP-SHP-ITEM-&quot;&amp;Shipment__r.Shipment_ID__c&amp;&quot;-&quot; &amp; Text(Ship_Item_ID__c)</formula>
        <name>Change Shipment Line Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WF to update Shipment Line Name</fullName>
        <actions>
            <name>Change_Shipment_Line_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Shipment__c.Shipment_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
