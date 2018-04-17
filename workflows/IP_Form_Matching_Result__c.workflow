<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IMR_Martinistore_Status_Message_Sent</fullName>
        <description>Used for integration with MartiniStore.</description>
        <field>MartiniStore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>IMR - Martinistore Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>IP_Matching_Result_To_AIA</fullName>
        <apiVersion>28.0</apiVersion>
        <description>This is the outbound message sent to AIA for the IP Matching Result sync to MartiniStore.</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFIPMatchAIAService/SFIPMatchAIAService_client</endpointUrl>
        <fields>CRM_DID__c</fields>
        <fields>CreatedDate</fields>
        <fields>Customer_Number__c</fields>
        <fields>IP_Vendor__c</fields>
        <fields>Id</fields>
        <fields>MartiniStore_Sync_Status__c</fields>
        <fields>OIC_IP_Component_ID__c</fields>
        <fields>Technical_Geometry__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>IP Matching Result To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>IP Matching Result - Outbound Message - To AIA</fullName>
        <actions>
            <name>IMR_Martinistore_Status_Message_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IP_Matching_Result_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>This workflow sends the IP Matching Result to AIA for MartiniStore synching.</description>
        <formula>AND(OR(NOT($Setup.IntegrationUsers__c.Is_Integration_User__c),Send_To_Martinistore__c),OR(ISPICKVAL(IP_Declaration_Form__r.Matching_Status__c, &apos;Matched&apos;),ISPICKVAL(IP_Declaration_Form__r.Matching_Status__c, &apos;Overridden by IP&apos;),ISPICKVAL(IP_Declaration_Form__r.Matching_Status__c, &apos;Overridden by VCID&apos;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
