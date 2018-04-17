<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Deleted_Record_To_AIA</fullName>
        <apiVersion>27.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/DeleteRecordAIAService/DeleteRecordAIAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/DeleteRecordAIAService/DeleteRecordAIAService_client</endpointUrl>
        <fields>Entity__c</fields>
        <fields>Id</fields>
        <fields>Record_Id__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Deleted Record To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Deleted Record - Outbound Message - To AIA</fullName>
        <actions>
            <name>Deleted_Record_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>(ISNEW() &amp;&amp; 
OR( TEXT(Entity__c) = &apos;Account Team Proxy&apos;, 
TEXT(Entity__c) = &apos;Lot Prefix&apos;, 
TEXT(Entity__c) = &apos;Account Hierarchy&apos;, 
TEXT(Entity__c) = &apos;Opportunity Program Team Member&apos;,
TEXT(Entity__c) = &apos;Account&apos;,
TEXT(Entity__c) = &apos;Device&apos;))||  ISCHANGED( Delete_Sync__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
