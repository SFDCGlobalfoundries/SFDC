<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMSendSubPDKInfoToOTCS</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://preprod.foundryview.com/sfaia/soa-infra/services/SF/SFSubPDK/SFSubPDK_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFSubPDK/SFSubPDK_client</endpointUrl>
        <fields>Description__c</fields>
        <fields>Full_PDK_Name__c</fields>
        <fields>Id</fields>
        <fields>Master_PDK_OpenText_Id__c</fields>
        <fields>OTID__c</fields>
        <fields>Pdk_Spec_Associations__c</fields>
        <fields>Release_Status__c</fields>
        <fields>Sub_PDK_OpenText_Id__c</fields>
        <fields>isRetrigger__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMSendSubPDKInfoToOTCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFSendSubPDKInfoToOTCS</fullName>
        <actions>
            <name>OBMSendSubPDKInfoToOTCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a Sub PDK record is created or edited, this workflow will be triggered which will in turn send an outbound message OBMSendSubPDKInfoToOTCS.</description>
        <formula>($Profile.Name != &apos;GF Integration&apos; &amp;&amp; Pdk_Spec_Associations__c!=null) || (ISCHANGED(Full_PDK_Name__c) &amp;&amp; ($Profile.Name = &apos;GF Integration&apos;) &amp;&amp; Pdk_Spec_Associations__c!=null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
