<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FU_Design_Package_Update_RT_to_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Draft_Package</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FU Design Package Update RT to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Package_Record_Type_to_non_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Released_Package</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Package Record Type to non-Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Package_Release_Status_as_Draft</fullName>
        <field>Package_Release_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Package Release Status as Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OBMSendPackageInfoToOTCS</fullName>
        <apiVersion>28.0</apiVersion>
        <description>https://www.foundryview.com/sfaia/soa-infra/services/SF/SFPackage/SFPackage_client</description>
        <endpointUrl>https://preprod.foundryview.com/aianoauth/soa-infra/services/SF/SFPackage/SFPackage_client</endpointUrl>
        <fields>Id</fields>
        <fields>Locked__c</fields>
        <fields>Name</fields>
        <fields>OTID__c</fields>
        <fields>OpenText_Id__c</fields>
        <fields>OwnerId</fields>
        <fields>Package_Description__c</fields>
        <fields>Package_Release_Status__c</fields>
        <fields>Package_Version__c</fields>
        <fields>Process_Type__c</fields>
        <fields>Tech_Geometry__c</fields>
        <fields>Technology_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>crmonlineuser@globalfoundries.com</integrationUser>
        <name>OBMSendPackageInfoToOTCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>WF Update Package Record Type to Draft</fullName>
        <actions>
            <name>FU_Design_Package_Update_RT_to_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Package__c.Package_Release_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WF Update Package Release Status on Create</fullName>
        <actions>
            <name>Update_Package_Release_Status_as_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This work flow will update the Release status of a Package to Draft on create.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WF Update Record Type to non-Draft</fullName>
        <actions>
            <name>Update_Package_Record_Type_to_non_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Package__c.Package_Release_Status__c</field>
            <operation>notEqual</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WFSendPackageInfoToOTCS</fullName>
        <actions>
            <name>OBMSendPackageInfoToOTCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a Package record is created or edited, this workflow will be triggered which will in turn send an outbound message OBMSendPackageInfoToOTCS.</description>
        <formula>$Profile.Name != &apos;GF Integration&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
