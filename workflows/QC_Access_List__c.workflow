<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OBMQualityCerSendCustomerListToProvision</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/DocumentProvisioningService/DocumentProvisioningService_Client_ep</endpointUrl>
        <fields>Id</fields>
        <fields>OpenTextId__c</fields>
        <fields>Quality_Certificate__c</fields>
        <fields>Short_Name_BlackList__c</fields>
        <fields>Short_Name_WhiteList__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMQualityCerSendCustomerListToProvision</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>OBMQualityCerSendCustomerProvision</fullName>
        <apiVersion>29.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/DocumentProvisioningService/DocumentProvisioningService_Client_ep</endpointUrl>
        <fields>Account__c</fields>
        <fields>Id</fields>
        <fields>Quality_Certificate__c</fields>
        <fields>Short_Name_BlackList__c</fields>
        <fields>Short_Name_WhiteList__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>QC OBMQualityCerSendCustomerProvision</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>QC Provisioning</fullName>
        <actions>
            <name>OBMQualityCerSendCustomerProvision</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Alert use to initiate CPK and Quality Report provisioning.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
