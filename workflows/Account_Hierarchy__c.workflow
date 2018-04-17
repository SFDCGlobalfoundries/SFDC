<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AH_Last_Sync_Status_Now</fullName>
        <field>Last_Sync_to_Martinistore_Status__c</field>
        <formula>TEXT(NOW())</formula>
        <name>AH - Last Sync Status - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AH_Martinistore_Sync_Status_Sent</fullName>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>AH - Martinistore Sync Status - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Account_Hierarchy_To_AIA</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFAcctHierarchyAIAService/SFAcctHierarchyAIAService_client</endpointUrl>
        <fields>Account_Id__c</fields>
        <fields>Account_Short_Name__c</fields>
        <fields>Account_Siebel_Account_ID__c</fields>
        <fields>Id</fields>
        <fields>Master_Account_Id__c</fields>
        <fields>Master_Account_Short_Name__c</fields>
        <fields>Parent_Account_Short_Name__c</fields>
        <fields>Parent_Account_Siebel_Account_ID__c</fields>
        <fields>Parent_Id__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Account Hierarchy To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account Hierarchy - Outbound Message - To AIA</fullName>
        <actions>
            <name>AH_Last_Sync_Status_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AH_Martinistore_Sync_Status_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Hierarchy_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( 
OR( 
ISNEW(), 
ISCHANGED(Parent_Id__c), 
ISCHANGED(Master_Account_Id__c), 
ISCHANGED( Hierarchy_Description__c)), 
!$Setup.IntegrationUsers__c.Is_Integration_User__c 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
