<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUSetAssociationType</fullName>
        <description>FV2:Set the field Association Type’ (Association_Type__c) value to ‘Primary Account’</description>
        <field>Association_Type__c</field>
        <literalValue>Primary Account</literalValue>
        <name>FUSetAssociationType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WFSetAssociationType</fullName>
        <actions>
            <name>FUSetAssociationType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Team_Room__c.Num_Associated_Accs__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>FV2:Will be there to check the value of the rollup summary field Num_Associated_Accs__c, if the value is 0 then the below field update occurs</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
