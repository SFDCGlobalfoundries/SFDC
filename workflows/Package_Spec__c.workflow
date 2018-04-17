<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMSendPackageSpecInfoToOTCS</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFPackageSpec/SFPackageSpec_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFPackageSpec/SFPackageSpec_client</endpointUrl>
        <fields>Design_Spec_OpenTextId__c</fields>
        <fields>Id</fields>
        <fields>Package_OpenText_Id__c</fields>
        <fields>Package__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMSendPackageSpecInfoToOTCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFSendPackageSpecInfoToOTCS</fullName>
        <actions>
            <name>OBMSendPackageSpecInfoToOTCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a Package Spec record is created, this workflow will be triggered which will in turn send an outbound message OBMSendPackageSpecInfoToOTCS.</description>
        <formula>$Profile.Name != &apos;GF Integration&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
