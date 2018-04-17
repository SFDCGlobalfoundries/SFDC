<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Expedite_Executed_when_Lot_Type_PE</fullName>
        <field>Expedited_Executed__c</field>
        <literalValue>1</literalValue>
        <name>Check Expedite Executed when Lot Type PE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_date_of_Expedite_Executed</fullName>
        <field>Date_Expedite_Executed__c</field>
        <formula>TODAY()</formula>
        <name>Populate date of Expedite Executed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Expedited Executed on Lot Type</fullName>
        <actions>
            <name>Check_Expedite_Executed_when_Lot_Type_PE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_date_of_Expedite_Executed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>If(ISCHANGED(Lot_Type__c) &amp;&amp; PRIORVALUE(Lot_Type__c) != &apos;PE&apos; &amp;&amp; Lot_Type__c == &apos;PE&apos;,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
