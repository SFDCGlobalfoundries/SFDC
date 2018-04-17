<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMDeletedRecordFromOpenText</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/DeleteObjectService/DeleteObjectService_Client_ep</endpointUrl>
        <fields>Cancel__c</fields>
        <fields>CustomerName__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>OpenTextId__c</fields>
        <fields>SFDCId__c</fields>
        <fields>Short_Name__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>CPK OBMDeletedRecordFromOpenText</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CPK OBMDeletedRecordFromOpenText</fullName>
        <actions>
            <name>OBMDeletedRecordFromOpenText</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
