<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Final_Status_To_FD</fullName>
        <field>Final_Stage__c</field>
        <formula>&apos;FD&apos;</formula>
        <name>Update Final Status To FD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Final_Status_To_WEA</fullName>
        <field>Final_Stage__c</field>
        <formula>&apos;WEA&apos;</formula>
        <name>Update Final Status To WEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isAllPartyApproved</fullName>
        <field>isAllPartyApproved__c</field>
        <literalValue>1</literalValue>
        <name>isAllPartyApproved?</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_DRC_Snapshot_Outbound_Msg</fullName>
        <apiVersion>36.0</apiVersion>
        <description>This will send image path  and rule id to AIA to fetch  image from FTP server</description>
        <endpointUrl>https://www.global-foundryview.com/sfaia/soa-infra/services/SF/GetPTSRSnapshotService/GetPTSRSnapshotService_client_ep</endpointUrl>
        <fields>Id</fields>
        <fields>Image_Path__c</fields>
        <fields>MantisId__c</fields>
        <fields>RuleId_Txt__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Send DRC Snapshot Outbound Msg</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Send DRC Rule Info</fullName>
        <actions>
            <name>Send_DRC_Snapshot_Outbound_Msg</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Waiver_Rule_List__c.Image_Path__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
