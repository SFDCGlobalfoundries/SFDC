<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Yr</fullName>
        <field>Year__c</field>
        <formula>LEFT( Fiscal_Quarter__c , 4)</formula>
        <name>Populate Yr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QR_Count_True</fullName>
        <field>Count__c</field>
        <literalValue>1</literalValue>
        <name>QR - Count - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Year</fullName>
        <actions>
            <name>Populate_Yr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quarterly_Revenue_Object__c.Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Qtrly Revenue%3A Update Roll Up Count</fullName>
        <actions>
            <name>QR_Count_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quarterly_Revenue_Object__c.Count_Design_Win_Revenue__c</field>
            <operation>equals</operation>
            <value>TRUE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
