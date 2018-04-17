<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LP_Last_Sync_Status_Now</fullName>
        <field>Last_Sync_to_Martinistore_Status__c</field>
        <formula>TEXT(NOW())</formula>
        <name>LP - Last Sync Status - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LP_Martinistore_Sync_Status_Sent</fullName>
        <field>Martinistore_Sync_Status__c</field>
        <formula>&quot;SENT&quot;</formula>
        <name>LP - Martinistore Sync Status - Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LP_Set_Lot_Prefix_Key</fullName>
        <field>Lot_Prefix_Key__c</field>
        <formula>Account__c &amp; TEXT(Fab__c) &amp; Name</formula>
        <name>LP - Set Lot Prefix Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Lot_Prefix_To_AIA</fullName>
        <apiVersion>27.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/LotPrefixAIAService/LotPrefixAIAService_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/LotPrefixAIAService/LotPrefixAIAService_client</endpointUrl>
        <fields>Account_Short_Name__c</fields>
        <fields>Account__c</fields>
        <fields>Created_By_HCM_Login_ID__c</fields>
        <fields>Fab__c</fields>
        <fields>Id</fields>
        <fields>Lot_Prefix_Key__c</fields>
        <fields>Modified_By_HCM_Login_ID__c</fields>
        <fields>Name</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>Lot Prefix To AIA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Lot Prefix - Outbound Message - To AIA</fullName>
        <actions>
            <name>LP_Last_Sync_Status_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LP_Martinistore_Sync_Status_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lot_Prefix_To_AIA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>OR(      ISNEW()      , ISCHANGED(Fab__c),ISCHANGED( LotPrefix_Sync__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lot Prefix - Populate Lot Prefix Key</fullName>
        <actions>
            <name>LP_Set_Lot_Prefix_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(  ISNEW()  , ISCHANGED(Fab__c)  , ISCHANGED(Name)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
