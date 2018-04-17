<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BNP_RFQ_Routing_Pause_End_Date_Update</fullName>
        <field>Pause_End_Date__c</field>
        <formula>now()</formula>
        <name>BNP RFQ Routing Pause End Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BNP_RFQ_Routing_Pause_date_Update</fullName>
        <field>Pause_Date__c</field>
        <formula>now()</formula>
        <name>BNP RFQ Routing Pause date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BNP RFQ Routing Pause End Date Update</fullName>
        <actions>
            <name>BNP_RFQ_Routing_Pause_End_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISCHANGED(Status__c ), ISPICKVAL(PRIORVALUE(Status__c ),&apos;Pause&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BNP RFQ Routing Pause date Update</fullName>
        <actions>
            <name>BNP_RFQ_Routing_Pause_date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>RFQ_Routing__c.Status__c</field>
            <operation>equals</operation>
            <value>Pause</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
