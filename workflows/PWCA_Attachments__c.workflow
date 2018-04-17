<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PWCA_Publication_lock</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PWCA_Lock_Record</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PWCA Publication lock after publish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>PWCA_Publication__c</targetObject>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OBMPWCALastNodeUserInfo</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/UserInfoService/UserInfoService_Client_ep</endpointUrl>
        <fields>File_Name__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>OpenTextId__c</fields>
        <fields>ParentOpenTextId__c</fields>
        <fields>Short_Name__c</fields>
        <fields>Source__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>PWCA OBMPWCALastNodeUserInfo</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>PWCA_Attachment_move_service</fullName>
        <apiVersion>29.0</apiVersion>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/esoa-infra/services/SF/MoveObjectService/MoveObjectService_Client_ep</endpointUrl>
        <fields>Id</fields>
        <fields>OpenTextId__c</fields>
        <fields>PWCA_Publication__c</fields>
        <fields>ParentOpenTextId__c</fields>
        <fields>Ready_To_Publish__c</fields>
        <fields>Source__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>PWCA Attachment move service</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>PWCA LastNodeUserInfo</fullName>
        <actions>
            <name>OBMPWCALastNodeUserInfo</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PWCA Move Publishing</fullName>
        <actions>
            <name>PWCA_Publication_lock</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PWCA_Attachment_move_service</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(AND(OpenTextId__c!=null,OpenTextId__c!=&apos;&apos;), Ready_To_Publish__c==true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
