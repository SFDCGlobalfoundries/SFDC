<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ROS_Concatenate_Fab_String_on_reticle</fullName>
        <field>FabStr__c</field>
        <formula>IF(ISBLANK(Reticle__r.FabStr__c),FAB__r.Name,Reticle__r.FabStr__c+&apos;,&apos;+FAB__r.Name)</formula>
        <name>ROS_Concatenate Fab String on reticle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Reticle__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>ROS_Concatenate reticle Fab</fullName>
        <actions>
            <name>ROS_Concatenate_Fab_String_on_reticle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(NOT(CONTAINS(Reticle__r.FabStr__c,FAB__r.Name)), ISBLANK(Reticle__r.FabStr__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
