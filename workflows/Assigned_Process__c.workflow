<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Assigned_Process_to_MartiniStore</fullName>
        <apiVersion>29.0</apiVersion>
        <description>https://test.foundryview.com/aianoauth/soa-infra/services/SF/SFAssignedProcessService/SFAssignedProcessService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFAssignedProcessService/SFAssignedProcessService_client</endpointUrl>
        <fields>CRMDID__c</fields>
        <fields>CreatedBy_HCMLoginID__c</fields>
        <fields>CreatedDate</fields>
        <fields>Device__c</fields>
        <fields>GAP_Comment__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>MRS_Status__c</fields>
        <fields>Modifiedby_HCMLoginID__c</fields>
        <fields>PID_Status__c</fields>
        <fields>Primary_Process__c</fields>
        <fields>Process_Name__c</fields>
        <fields>Siebel_Device_Id__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Assigned Process to MartiniStore</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Assigned Process %E2%80%93 Create or Update</fullName>
        <actions>
            <name>Assigned_Process_to_MartiniStore</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>!$Setup.IntegrationUsers__c.Is_Integration_User__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
