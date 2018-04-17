<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMCreationOfTeamRoomMember</fullName>
        <apiVersion>27.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFTeamRoomMember/SFTeamRoomMember_clOBMCreationOfTeamRoomMember will send the desired team room member information, which will be updated to Open Text Content Server by a dedicated AIA orchestration.</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFTeamRoomMember/SFTeamRoomMember_client</endpointUrl>
        <fields>Id</fields>
        <fields>Team_Room_OpenText_ID__c</fields>
        <fields>Team_Room_Role__c</fields>
        <fields>Team_Room__c</fields>
        <fields>User_Short_Name__c</fields>
        <fields>User__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMCreationOfTeamRoomMember</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFCreationOfTeamRoomMember</fullName>
        <actions>
            <name>OBMCreationOfTeamRoomMember</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>FV2:When a Team Room Member will be created, this workflow will be triggered which will in turn send an outbound message OBMCreationOfTeamRoomMember.</description>
        <formula>$Profile.Name != &apos;GF Integration&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
