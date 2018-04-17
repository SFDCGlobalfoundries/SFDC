<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WR_Related_Bug_UniqueId_Update</fullName>
        <field>UniqueId__c</field>
        <formula>UniqueText__c</formula>
        <name>WR Related Bug UniqueId Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WR Related Work Request Creation</fullName>
        <actions>
            <name>WR_Related_Bug_UniqueId_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF will update the UniqueId for Related Work request and is making sure it does not include same Work request  twice.</description>
        <formula>NOT( $Setup.IntegrationUsers__c.Is_Integration_User__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
