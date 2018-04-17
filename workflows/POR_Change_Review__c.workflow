<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>POR_PCR_Status_Update_BCCB_Review</fullName>
        <description>PCR Status is updated to BCCB Review.</description>
        <field>PCR_Status__c</field>
        <literalValue>BCCB Review</literalValue>
        <name>POR - PCR Status Update BCCB Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POR_PCR_Status_Update_PC_Review</fullName>
        <description>PCR Status is updated to PC Review.</description>
        <field>PCR_Status__c</field>
        <literalValue>PC Review</literalValue>
        <name>POR - PCR Status Update PC Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POR_Update_PCR_Status_To_Closed</fullName>
        <description>PCR Status is updated to Closed.</description>
        <field>PCR_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>POR - Update PCR Status To Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>POR - Update PCR Status Closed</fullName>
        <actions>
            <name>POR_Update_PCR_Status_To_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>POR_Change_Review__c.PCR_Disposition__c</field>
            <operation>equals</operation>
            <value>PPE Document PCR</value>
        </criteriaItems>
        <criteriaItems>
            <field>POR_Change_Review__c.PCR_Disposition__c</field>
            <operation>equals</operation>
            <value>Approve</value>
        </criteriaItems>
        <criteriaItems>
            <field>POR_Change_Review__c.PCR_Disposition__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <description>This workflow rule will fire when PCR Disposition equals &apos;Approve&apos;,&apos;Reject&apos; or &apos;PPE Document PCR&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>POR - Update PCR Status To BCCB Review</fullName>
        <actions>
            <name>POR_PCR_Status_Update_BCCB_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>POR_Change_Review__c.PCR_Disposition__c</field>
            <operation>equals</operation>
            <value>Escalate to BCCB</value>
        </criteriaItems>
        <description>This workflow rule will fire when PCR Disposition equals &apos;Escalate to BCCB&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>POR - Update PCR Status To PC Review</fullName>
        <actions>
            <name>POR_PCR_Status_Update_PC_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>POR_Change_Review__c.PCR_Disposition__c</field>
            <operation>equals</operation>
            <value>Escalate to PC</value>
        </criteriaItems>
        <description>This workflow rule will fire when PCR Disposition equals &apos;Escalate to PC&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
