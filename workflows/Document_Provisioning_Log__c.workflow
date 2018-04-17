<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>OB_Sync_Doc_Provisioning_Records</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFPDKDeleteService/SFPDKDeleteService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFPDKDeleteService/SFPDKDeleteService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>Bundle_OT_ID__c</fields>
        <fields>Document_Provisioning_SF_Id__c</fields>
        <fields>Entity__c</fields>
        <fields>IPLA__c</fields>
        <fields>Id</fields>
        <fields>Package_OpenText_Id__c</fields>
        <fields>Package_SF_Id__c</fields>
        <fields>PdkSpecs__c</fields>
        <fields>Pdk_Specs_DeProvisioned__c</fields>
        <fields>Spec_OpenText_Id__c</fields>
        <fields>Spec_SF_Id__c</fields>
        <fields>Status__c</fields>
        <fields>Sub_PDK_OpenText_Id__c</fields>
        <fields>Sub_PDK_SF_Id__c</fields>
        <fields>Sub_PDK_Spec_OtId__c</fields>
        <fields>Team_Member_Role__c</fields>
        <fields>Team_Room_Doc_Folder_Id__c</fields>
        <fields>Team_Room_Member_Short_Name__c</fields>
        <fields>Team_Room_OpenText_Id__c</fields>
        <fields>Team_Room_SF_Id__c</fields>
        <fields>isDeProUpdate__c</fields>
        <fields>isDeletionNeeded__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OB Sync Doc Provisioning Records</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WFSendDeletedInfoToAIA</fullName>
        <actions>
            <name>OB_Sync_Doc_Provisioning_Records</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>PDK_Release_Status__c !=&apos;General Release&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
