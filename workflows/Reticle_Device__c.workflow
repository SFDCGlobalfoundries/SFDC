<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ROS_Concatenate_CRMDevice_On_Reticle</fullName>
        <field>Device_ID__c</field>
        <formula>IF(ISBLANK(Reticle__r.Device_ID__c),CRM_Device_ID__c ,Reticle__r.Device_ID__c +&apos;,&apos;+BR()+CRM_Device_ID__c )</formula>
        <name>ROS Concatenate Device On Reticle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Reticle__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ROS_Concatenate_Device_On_Reticle</fullName>
        <field>GlobalFoundries_Device_ID__c</field>
        <formula>IF(ISBLANK(Reticle__r.GlobalFoundries_Device_ID__c),IF(ISBLANK(GF_Device_Id__c),Global_foundries_device_Id__c,GF_Device_Id__c), Reticle__r.GlobalFoundries_Device_ID__c  +&apos;,&apos;+ BR() +IF(ISBLANK(GF_Device_Id__c),Global_foundries_device_Id__c,GF_Device_Id__c))</formula>
        <name>ROS Concatenate Device On Reticle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Reticle__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>ROS_Concatenate DeviceID On Reticle</fullName>
        <actions>
            <name>ROS_Concatenate_CRMDevice_On_Reticle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(NOT(CONTAINS(Reticle__r.Device_ID__c,CRM_Device_ID__c)), ISBLANK(Reticle__r.Device_ID__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ROS_Concatenate GlobalFoundries Device on Reticle</fullName>
        <actions>
            <name>ROS_Concatenate_Device_On_Reticle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(!CONTAINS(Reticle__r.GlobalFoundries_Device_ID__c, GF_Device_Id__c),ISBLANK(Reticle__r.GlobalFoundries_Device_ID__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
