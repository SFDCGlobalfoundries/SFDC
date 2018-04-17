<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OPT_Martinistore_Status_Message_Sent</fullName>
        <description>Used for integration with MartiniStore.</description>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>OPT - Martinistore Status Message - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Opportunity_Program_Team_To_AIA</fullName>
        <apiVersion>28.0</apiVersion>
        <description>This is the outbound message sent to AIA for the Oppty Program Team Member (Device Team) sync to MartiniStore.</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFOptyTeamAIAService/SFOptyTeamAIAService_client</endpointUrl>
        <fields>CreatedDate</fields>
        <fields>Created_By_HCM_Login_ID__c</fields>
        <fields>Fab_Assignment__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>MartiniStore_Role__c</fields>
        <fields>Martinistore_Sync_Status__c</fields>
        <fields>Modified_By_HCM_Login_ID__c</fields>
        <fields>Opportunity_Account_ID__c</fields>
        <fields>Opportunity_Id__c</fields>
        <fields>Opportunity_Program__c</fields>
        <fields>Opportunity_Siebel_Account_ID__c</fields>
        <fields>Opportunity_Siebel_Oppty_ID__c</fields>
        <fields>Sequence__c</fields>
        <fields>Team_Role__c</fields>
        <fields>User_First_Name__c</fields>
        <fields>User_Full_Name__c</fields>
        <fields>User_HCM_Login_ID__c</fields>
        <fields>User_Last_Name__c</fields>
        <fields>User__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Opportunity Program Team To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Oppty Program Team Member - Outbound Message - To AIA</fullName>
        <actions>
            <name>Opportunity_Program_Team_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>This workflow sends the Opportunity Program Team Member to AIA for MartiniStore synching.</description>
        <formula>NOT($Setup.IntegrationUsers__c.Is_Integration_User__c) || ISCHANGED( Synch_to_Downstream__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
