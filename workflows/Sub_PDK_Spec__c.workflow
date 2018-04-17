<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMSendSubPDKSpecInfoToOTCS</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFSubPDKSpec/SFSubPDKSpec_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFSubPDKSpec/SFSubPDKSpec_client</endpointUrl>
        <fields>Design_Spec_OpenTextId__c</fields>
        <fields>Id</fields>
        <fields>OTID__c</fields>
        <fields>Sub_PDK_OpenText_Id__c</fields>
        <fields>Sub_PDK__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMSendSubPDKSpecInfoToOTCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFSendSubPDKSpecInfoToOTCS</fullName>
        <actions>
            <name>OBMSendSubPDKSpecInfoToOTCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>When a Sub PDK Spec record is created, this workflow will be triggered which will in turn send an outbound message OBMSendSubPDKSpecInfoToOTCS.</description>
        <formula>$Profile.Name != &apos;GF Integration&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
