<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMSendTeamRoomDocInfoToOTCS</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFTeamRoomDOC/SFTeamRoomDOC_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFTeamRoomDOC/SFTeamRoomDOC_client</endpointUrl>
        <fields>Design_Package__c</fields>
        <fields>Design_Spec__c</fields>
        <fields>Id</fields>
        <fields>Package_OpenText_Id__c</fields>
        <fields>Spec_OpenText_Id__c</fields>
        <fields>Sub_PDK_OpenText_Id__c</fields>
        <fields>Sub_PDK__c</fields>
        <fields>Team_Room_Doc_Folder_Id__c</fields>
        <fields>Team_Room_OpenText_ID__c</fields>
        <fields>Team_Room__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMSendTeamRoomDocInfoToOTCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFSendTeamRoomDocInfoToAIA</fullName>
        <actions>
            <name>OBMSendTeamRoomDocInfoToOTCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>$Profile.Name != &apos;GF Integration&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
