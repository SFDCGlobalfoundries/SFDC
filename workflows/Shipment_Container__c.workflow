<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Shipment_Container_Id</fullName>
        <field>Shipment_Container_Id__c</field>
        <formula>&quot;SAP-SHP-CONTAINER-&quot;&amp; Shipment_Id__r.Shipment_ID__c &amp;&quot;-&quot; &amp; Handling_Unit_ID__c</formula>
        <name>Change Shipment Container Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WF to update Container Id</fullName>
        <actions>
            <name>Change_Shipment_Container_Id</name>
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
